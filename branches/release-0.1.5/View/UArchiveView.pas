unit UArchiveView;

interface

uses
  Windows, SysUtils, Classes, Messages, Controls, ComCtrls, StdCtrls, ExtCtrls, FileCtrl,
  Graphics, Forms, Dialogs, Menus, ARCHIVES,
  UImageTabSheet, UImagePageControl, UMSPageControl, UContentView, JLXPComCtrls;

type

  TArchivePageControl = class(TImagePageControl)
  public
    ArchiveView:TObject;//参照できるように
  end;

  TArchiveTabSheet = class(TLocalImageTabSheet);//区別のためだけに派生

  //統合アーカイバーDLLは複数のタスクを起動できないのと、
  //モーダルダイアログの競合を起こす可能性があるので調停が必要
  //また、モーダルダイアログに関するチェック、イベント発生に利用
  TArchiverManager = class(TObject)
  protected
    Timer:TTimer;
    ProcessList:TList;
    CurrentProcess:TCustomImageView;
    FModalDialogAppear:Boolean;
    procedure ExecuteProcess(Sender:TObject=nil);
    function GetModalDialogAppear:Boolean;
    procedure SetModalDialogAppear(Value:Boolean);

  public
    constructor Create;
    destructor Destroy;override;
    procedure RegisterProcess(AArchiveView:TCustomImageView);
    procedure RemoveProcess(AArchiveView:TCustomImageView);
    property ModalDialogAppear:Boolean read GetModalDialogAppear write SetModalDialogAppear;
  end;

  //展開済みファイルの読み込みスレッド
  TArchiveThread = class(TThread)
  protected
    CurrentNum:Integer;
    tmpExtractFile:string;
  public
    FileNum:Integer;
    TemporaryFile:string;
    FileList:TStringList;
    NewTabSheet:TArchiveTabSheet;
    StatusBar:TStatusBar;
    StatusMemo:TMemo;
    PageControl:TArchivePageControl;
    PopupMenu:TPopupmenu;
    Protect: Boolean;
    procedure Execute;override;
    procedure RegisterPage;
    procedure NoticeFailure;
  end;

  //書庫展開表示クラス
  TArchiveView = class(TCustomImageView)
  protected
    FFileNum,FCurrentNum:Integer;
    FFileName:string; //ちとまぬけ
    TemporaryFile:string;
    FileList:TStringList;
    PageControl:TArchivePageControl;
    StatusBar:TJLXPStatusBar;
    StatusMemo:TMemo;
    ArchiveThread:TArchiveThread;
    procedure SetProtect(AProtect: Boolean); override;
    procedure Finish;
    procedure TerminateExtractProcess(DecodeError:Boolean=False; WantEvent:Boolean=True);
    procedure ArchiveFileProgress(Sender:TObject; State:Integer; lpEis:LPEXTRACTINGINFOEX; var Abort:Boolean);
    procedure ThreadTerminate(Sender:TObject);
    procedure PageControlOnChange(Sender:TObject);
    procedure PageControlOnEdge(Sender:TObject ;GoForward:Boolean);
    procedure PageControlAllClosed(Sender:TObject);
  public
    constructor Create(AOwner:TWinControl);
    destructor Destroy;override;
    procedure AssignData(AData:TStringStream);override;
    procedure ExtractData;
    procedure RequestCancel;override;
    procedure Action;override;
    procedure Halt;override;
    procedure Highlight(Value:Boolean; FromOwnOriginTo:TPageControlDierction);override;
    procedure TerminateHighlight;override;
  end;

function EnumDir(Path: string; DirList: TStrings; FileList:TStrings=nil): Boolean;

var
  ArchiverManager:TArchiverManager;

implementation

uses
  StrSub, UImageViewConfig, UImageViewer, UConfig, UIDlg, Main;

const
  CallArchiverProcess=WM_USER+1002;

//ディレクトリの列挙関数
function EnumDir(Path: string; DirList: TStrings; FileList:TStrings=nil): Boolean;
var
  Back:Integer;
  F: TSearchRec;
begin

  Result:=False;

  if Not DirectoryExists(Path) then Exit;

  if Path[Length(Path)]<>'\' then Path:=Path+'\';

  try
    try
      Back:=FindFirst(Path+'*.*',faAnyFile,F);
      while Back =0 do begin
        if (F.Name<>'.') and (F.Name<>'..') then begin
          if ((F.Attr and faDirectory)<>0) then begin
            EnumDir(Path+F.Name,DirList,FileList);
            DirList.Add(Path+F.Name);
          end else if FileList<>nil then begin
            FileList.Add(Path+F.Name);
          end;
        end;
        Back:=FindNext(F);
      end;
    finally
      FindClose(F);
    end;
  except
    Raise;
  end;
  Result:=True;

end;


//ベースパス＋部分パスによるフルパス生成関数
function _PathCombine(lpszDest: PChar; const lpszDir, lpszFile: PChar): PChar; stdcall;
  external 'shlwapi.dll' name 'PathCombineA';

function PathCombine(const Path, FileName: String): String;
var
  Combined: array[0..MAX_PATH] of Char;
begin
  _PathCombine(@Combined[0], PChar(Path), PChar(FileName));
  Result := Trim(Combined);
end;


{ TArchiverManager }


//コンストラクタ
constructor TArchiverManager.Create;
begin
  ProcessList:=TList.Create;

  //ImageViewerが管理していないダイアログのためにタイマーでもチェック
  Timer:=TTimer.Create(nil);
  Timer.Enabled:=False;
  Timer.Interval:=300;
  Timer.OnTimer:=Self.ExecuteProcess;

  ModalDialogAppear:=False;

end;


//デストラクタ （全てのセッションとスレッドを破棄）
destructor TArchiverManager.Destroy;
begin
  Timer.Free;
  ProcessList.Free;
  ReleaseArchiverDLL;  //aiai
  inherited Destroy;
end;


//待機リストに登録
procedure TArchiverManager.RegisterProcess(AArchiveView:TCustomImageView);
begin
  ProcessList.Add(AArchiveView);
  if ProcessList.Count=1 then ExecuteProcess;
end;


//完了プロセスの待機リストからの削除
procedure TArchiverManager.RemoveProcess(AArchiveView:TCustomImageView);
begin
  ProcessList.Extract(AArchiveView);
  ProcessList.Capacity:=ProcessList.Count;
  if ProcessList.Count>0 then ExecuteProcess;
end;

//待機プロセスの実行(タイマーからもコール有り)
procedure TArchiverManager.ExecuteProcess(Sender:TObject=nil);
begin
  Timer.Enabled:=False;
  if (ProcessList.Count>0) then
    if ModalDialogAppear then
      Timer.Enabled:=True
    else
      TArchiveView(ProcessList[0]).ExtractData;
end;

//モーダルダイアログ関係。
//ImageView関係以外は直接調べる
function TArchiverManager.GetModalDialogAppear:Boolean;
begin
  Result := FModalDialogAppear
        or (Assigned(UIConfig) and UIConfig.Visible)
        or (Assigned(InputDlg) and InputDlg.Visible)
        or Assigned(MainWnd.QuickAboneRegist);
end;

procedure TArchiverManager.SetModalDialogAppear(Value:Boolean);
begin
  FModalDialogAppear:=Value;
  //ダイアログを出す時はポップアップヒントを消す
  if FModalDialogAppear then MainWnd.PopupHint.ReleaseHandle;
  ExecuteProcess;
end;

{ TArchiveThread }

//スレッドから展開ファイルの読み込みをコールする
//ぜんぜん並列処理になってないけど処理中の沈黙防止
procedure TArchiveThread.Execute;
var
  i:Integer;
  Attrib:Integer;
begin
  for i:=0 to FileList.Count-1 do begin
    tmpExtractFile := PathCombine(TemporaryFile + '.dir\', FileList[i]);
    CurrentNum:=i;
    if not Terminated then begin
      if FileExists(tmpExtractFile) then begin
        Synchronize(RegisterPage);
      end else begin
        Synchronize(NoticeFailure);
      end;
    end;
    Attrib:=FileGetAttr(tmpExtractFile);
    if (Attrib and faReadOnly)<>0 then
      FileSetAttr(tmpExtractFile, Attrib-faReadOnly);
    DeleteFile(tmpExtractFile);
    Sleep(10);//遺憾ながらこれがないと完了まで沈黙してしまう
  end;
end;

//実際の読み込み部分(VCLスレッドで呼び出し)
procedure TArchiveThread.RegisterPage;
begin
  if Assigned(Statusbar) then
    StatusBar.Panels[0].Text := Format('Load & Decode (%d/%d) %s',[CurrentNum + 1, FileList.Count, FileList[CurrentNum]]);
  NewTabSheet := TArchiveTabSheet.Create(PageControl);
  NewTabSheet.PageControl := PageControl;
  NewTabSheet.Protect := Protect;
  NewTabSheet.PopupMenu := PopupMenu;
  NewTabSheet.OpenFile(tmpExtractFile);
end;

//ファイルがないとき
procedure TArchiveThread.NoticeFailure;
begin
  StatusMemo.Lines.Add('展開失敗: '+FileList[CurrentNum]);
end;


{ TArchiveView }

constructor TArchiveView.Create(AOwner:TWinControl);
begin
  inherited Create(AOwner);
  FSmallBitmap:=TBitmap.Create;
  ImageViewConfig.GetIconBmp('ARCHIVE',FSmallBitmap);
end;


//破棄
destructor TArchiveView.Destroy;
var
  i:Integer;
begin

  RequestCancel;

  if Assigned(PageControl) then begin
    PageControl.Hide;
    for i:=0 to PageControl.PageCount-1 do
      PageControl.Pages[0].Free;
  end;

  FreeAndNil(StatusMemo);
  FreeAndNil(PageControl);
  if Assigned(StatusBar) then StatusBar.Panels.Clear;
  FreeAndNil(StatusBar);

  inherited;

end;


//書庫データ受け取り
procedure TArchiveView.AssignData(AData:TStringStream);
begin
  FData := AData;
  ArchiverManager.RegisterProcess(Self);
end;


//書庫データからページコントロールのデータを構築
procedure TArchiveView.ExtractData;
var
  tmpFile:TFileStream;
  ArcConv:TArchiveFile;
  FindRec:TIndivisualInfo;
  tmpDir:string;
  buf: array[0..255] of Char;
  cond, i, tmpLine :Integer;

  function BadPartialPath(const Path, FileName: String): Boolean;
  begin
    Result := not StartWith(Path, PathCombine(Path, FileName), 1);
  end;

begin

  tmpDir:=ExtractFilePath(Application.ExeName)+TMPDIRNAME;
  if not DirectoryExists(tmpDir) then
    if not CreateDir(tmpDir) then begin
      Log('テンポラリディレクトリが作成できません');
      TerminateExtractProcess(True);
      Exit;
    end;

  GetTempFileName(pchar(tmpDir),'ARC', 0, @buf[0]);

  TemporaryFile:=buf;

  tmpFile:=TFileStream.Create(TemporaryFile,fmCreate);
  try
    try
      tmpFile.CopyFrom(FData,0);
    finally
      FreeAndNil(tmpFile);
    end;
  except
    on e:EFilerError do begin
      Log('テンポラリファイルが作成できません'#13#10+e.Message);
      TerminateExtractProcess(True);
      Exit;
    end;
  end;

  ArcConv:=TArchiveFile.Create(FOwner);
  with ArcConv.Options do begin
    a  := 0;
    m  := 1;
    x  := 1;
    jf := 0;
    jse:= 0;
    jso:= 1;
    ga := 1;
    w  :=tmpDir;
  end;

  try
    ArcConv.ArchiverType:=ImageViewConfig.ExamArchiveType(FInfo);
  except
    on e:EArchiver do begin
      Log('解凍DLLが初期化できませんでした'#13#10+e.Message);
      FreeAndNil(ArcConv);
      Finish;
      TerminateExtractProcess(True);
      Exit;
    end;
  end;

  FileList:=TStringList.Create;

  try
    ArcConv.FileName:=TemporaryFile;
    ArcConv.FindOpen(Application.MainForm.Handle,0);
    try
  		cond := ArcConv.FindFirst('*.*',FindRec);
  		while cond = 0 do begin
        FileList.Add(StringReplace(FindRec.szFileName, '/', '\', [rfReplaceAll]));
  			cond := ArcConv.FindNext(FindRec);
  		end;
    finally
  		ArcConv.FindClose;
    end;
  except
    on e:EArchiver do begin
      Log('ファイル一覧が取得できません'#13#10+e.Message);
      FreeAndNil(ArcConv);
      FreeAndNil(FileList);
      Finish;
      TerminateExtractProcess(True);
      Exit;
    end;
  end;

  if ImageViewConfig.UseIndividualStatusBar then begin
    StatusBar:=TJLXPStatusBar.Create(FOwner);
    StatusBar.Parent:=FOwner;
    StatusBar.Align:=alBottom;
    StatusBar.Panels.Add;
    StatusBar.Panels.Add;
    ImageForm.StatusBarResize(StatusBar);
    StatusBar.OnResize:=ImageForm.StatusBarResize;
  end;

  PageControl:=TArchivePageControl.Create(FOwner);
  PageControl.ArchiveView:=Self;
  PageControl.StatusBar:=StatusBar;
  PageControl.OnEdge:=PageControlOnEdge;
  PageControl.OnChange:=PageControlOnChange;
  PageControl.OnAllTabClosed:=PageControlAllClosed;

  StatusMemo:=TMemo.Create(FOwner);
  StatusMemo.Align:=alClient;
  StatusMemo.ReadOnly:=True;
  StatusMemo.BorderStyle:=bsNone;
  StatusMemo.ScrollBars:=ssVertical;
  StatusMemo.Parent:=PageControl;
  StatusMemo.Text:='書庫情報'#13#10#13#10;
  StatusMemo.Lines.Add(Format('ファイルサイズ %14.0n byte',[FData.Size/1]));
  StatusMemo.Lines.Add(Format('書庫内ファイル数 %d',[FileList.Count]));
  StatusMemo.Lines.Add('');
  StatusMemo.PopupMenu:=ImageForm.ArchiveInfoPopUp;

  tmpLine:=StatusMemo.Lines.Add('◆解凍対象ではないファイル')+1;

  for i:=FileList.Count-1 downto 0 do
  begin
    if (AnsiPos('*' + LowerCase(ExtractFileExt(FileList[i])) + ';',
      GraphicFileMask(TGraphic) + ';') = 0) or BadPartialPath(tmpDir, FileList[i]) then
    begin
      StatusMemo.Lines.Insert(tmpLine,FileList[i]);
      FileList.Delete(i);
    end;
  end;
  StatusMemo.Lines.Add('');
  StatusMemo.Lines.Add('◆解凍対象のファイル');
  StatusMemo.Lines.AddStrings(FileList);


  if FileList.Count>0 then begin

    if not(DirectoryExists(TemporaryFile+'.dir')) then
      if not CreateDir(TemporaryFile+'.dir') then begin
        Log('テンポラリディレクトリが作成できません');
        FreeAndNil(FileList);
        FreeAndNil(ArcConv);
        Finish;
        TerminateExtractProcess(True);
        Exit;
      end;

    FCurrentNum:=0;
    ArcConv.OnProgress:=ArchiveFileProgress;
    ArcConv.UnpackFiles(ImageForm.Handle,nil,TemporaryFile+'.dir\',[FileList]);
    FreeAndNil(ArcConv);

    //読み込み用のスレッドを起動
    ArchiveThread:=TArchiveThread.Create(True);
    ArchiveThread.TemporaryFile:=TemporaryFile;
    ArchiveThread.FileList:=FileList;
    ArchiveThread.StatusBar:=StatusBar;
    ArchiveThread.StatusMemo:=StatusMemo;
    ArchiveThread.PageControl:=PageControl;
    ArchiveThread.PopupMenu:=ImageForm.ImagePopUpMenu;
    ArchiveThread.Protect := Protect;
    ArchiveThread.OnTerminate:=ThreadTerminate;
    ArchiveThread.FreeOnTerminate:=True;

    ArchiveThread.Resume;

    PageControl.UpdateStatusBar;

  end else begin
    StatusMemo.Lines.Add('解凍対象なし');
    FreeAndNil(ArcConv);
    Finish;
    TerminateExtractProcess;
  end;


end;

//OnTerminateでスレッド実行の後始末（nilを代入しておく）
procedure TArchiveView.ThreadTerminate(Sender:TObject);
begin
  ArchiveThread:=nil;
  TerminateExtractProcess;
  Finish;
end;

//展開の後始末(テンポラリ等を削除)
procedure TArchiveView.Finish;
var
  i:Integer;
  DirList :TStringList;
begin

  FreeAndNil(FileList);

  if FileExists(TemporaryFile) then
    if not DeleteFile(TemporaryFile) then
      MessageDlg('テンポラリファイルを削除できませんでした',mtError,[mbOK],0);

  if DirectoryExists(TemporaryFile+'.dir') then begin
    DirList:=TStringList.Create;
    EnumDir(TemporaryFile+'.dir',DirList);
    try
      for i:=0 to DirList.Count-1 do
        if LowerCase(copy(DirList[i],1,length(ExtractFilePath(Application.ExeName))+Length(TMPDIRNAME)+1))<>LowerCase(ExtractFilePath(Application.ExeName)+TMPDIRNAME+'\') then
          Raise Exception.Create('ディレクトリ削除ルーチンが許可範囲外のディレクトリを削除しようとしました')
        else if AnsiPos('..',DirList[i])>0 then
          Raise Exception.Create('ディレクトリ削除ルーチンに誤ったディレクトリ名が渡されました')
        else
          RemoveDir(DirList[i]);
    finally
      FreeAndNil(DirList);
    end;
    if not RemoveDir(TemporaryFile+'.dir') then
      MessageDlg('使用済みのテンポラリディレクトリを削除できませんでした',mtError,[mbOK],0);

  end;
end;

//展開処理の終了通知（イベント発生、ArchiveManager通知）
procedure TArchiveView.TerminateExtractProcess(DecodeError:Boolean=False; WantEvent:Boolean=True);
begin
  if WantEvent and Assigned(FOnComplete) then FOnComplete(Self,DecodeError);
  ArchiverManager.RemoveProcess(Self);
end;

//実行中止のリクエスト
procedure TArchiveView.RequestCancel;
begin
  inherited;
  if Assigned(ArchiveThread) then begin
    ArchiveThread.Suspend;
    ArchiveThread.FreeOnTerminate:=False;
    ArchiveThread.OnTerminate:=nil;
    ArchiveThread.Terminate;
    ArchiveThread.Resume;
    ArchiveThread.WaitFor;
    FreeAndNil(ArchiveThread);
    Finish;
    TerminateExtractProcess(True,False);
  end;
end;


//ステータスバーに展開の進行状況を表示
procedure TArchiveView.ArchiveFileProgress(Sender:TObject; State:Integer; lpEis:LPEXTRACTINGINFOEX; var Abort:Boolean);
begin
  if (State=ARCEXTRACT_BEGIN) and (FFileName<>lpEis.exinfo.szSourceFileName) then begin //なぜかUNLHAでファイルごとに２回ARCEXTRACT_BEGINが．．．
    Inc(FCurrentNum);
    FFileName:=lpEis.exinfo.szSourceFileName;
    if (lpEis<>nil) and Assigned(StatusBar) then begin
      StatusBar.Panels[0].Text:=Format('Extacting...(%d/%d) Name= %s',[FCurrentNum,FileList.Count,FFileName]);
      StatusBar.Refresh;
    end;
  end;
end;


//シフトが押されていなければ、範囲選択のフラグを解除
procedure TArchiveView.PageControlOnChange(Sender:TObject);
begin
  if (GetKeyState(VK_SHIFT)>=0) and Assigned(FOnSelectionTerminate) then
    FOnSelectionTerminate(Self);
end;


//PageControlが端まで来たらイベント発生
procedure TArchiveView.PageControlOnEdge(Sender:TObject ;GoForward:Boolean);
begin
  if ImageViewConfig.ContinuousTabChange and Assigned(FOnEdge) then begin
    if GetKeyState(VK_SHIFT)<0 then begin
      if not(Boolean(PageControl.ActivePage.Tag))
         and ((GoForward and (PageControl.BeginSelectionWithDirection=pdBACKWARD))
              or (not(GoForward) and (PageControl.BeginSelectionWithDirection=pdFORWARD))
              ) then begin
        PageControl.ActivePage.Highlighted:=False;
      end;
    end else begin
      PageControl.TerminateSelectionState;
    end;
    FOnEdge(Self,GoForward);
  end;
end;


//PageControlのタブが全て閉じられたら、自分の属するタブシートに閉じるリクエスト
procedure TArchiveView.PageControlAllClosed(Sender:TObject);
begin
  if Assigned(FOnContentClose) then FOnContentClose(Self);
end;


//Activeになった時、上位のPageControlの状態に対応してActivePageを決め、
//ActivePageにActiveになったことを通知する
procedure TArchiveView.Action;
begin
  if Assigned(PageControl) and (PageControl.PageCount>0) then begin
    if ImageViewConfig.ContinuousTabChange then begin
      if PageControl.CanFocus then PageControl.SetFocus;
      case TImagePageControl(TTabSheet(FOwner).PageControl).Direction of
        pdFORWARD :PageControl.ActivePageIndex:=0;
        pdBACKWARD:PageControl.ActivePageIndex:=PageControl.PageCount-1;
      end;
      if PageControl.ActivePageIndex<0 then begin
        PageControl.ActivePageIndex:=0;
        PageControl.Change;
      end;
      if (GetKeyState(VK_SHIFT)<0) then
        PageControl.BeginSelectionWithDirection:=TImagePageControl(TTabSheet(FOwner).PageControl).SelectionDirectTo;
    end else begin
      if PageControl.ActivePageIndex<0 then begin
        PageControl.ActivePageIndex:=0;
        PageControl.Change;
      end;
    end;
    if Assigned(PageControl.ActivePage) then
      TImageTabSheet(PageControl.ActivePage).ActContentView;
  end;
end;


//自分が非アクティブになったことを自分のActivePageに通知
procedure TArchiveView.Halt;
begin
  if Assigned(PageControl) and Assigned(PageControl.ActivePage) then
    TImageTabSheet(PageControl.ActivePage).HaltContentView;
end;


//上位タブシートのハイライトが変化した時の処理
procedure TArchiveView.Highlight(Value:Boolean; FromOwnOriginTo:TPageControlDierction);
begin
  if Assigned(PageControl) then PageControl.FillHighlight(Value,FromOwnOriginTo);
end;


//ハイライトを確定させる処理
procedure TArchiveView.TerminateHighlight;
begin
  if Assigned(PageControl) then PageControl.TerminateSelectionState;
end;


//子タブシートのモザイク解除
procedure TArchiveView.SetProtect(AProtect: Boolean);
var
  i: Integer;
begin
  FProtect := AProtect;
  if Assigned(PageControl) then
    for i := 0 to PageControl.PageCount - 1 do
      TArchiveTabSheet(PageControl.Pages[i]).Protect := AProtect;
end;


initialization
  ArchiverManager:=TArchiverManager.Create;

finalization
  ArchiverManager.Free;

end.
