unit UImageTabSheet;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, Graphics,
  StdCtrls, Menus, Dialogs, ExtDlgs, ShellAPI, ARCHIVES, SPIs, SPIbmp,
  jconvert,UViewItem,HogeTextView,UTVSub,JConfig,
  UHttpManage, UImageViewConfig, UContentView, UAnimatedPaintBox,UMSPageControl;
type

  TSaveModeFlag =(smNotDefine,smOverWrite,smSkip);

  TTagAttrList = class(TStringList)
  protected
    FName:string;
    FLength:Integer;
  public
    constructor Create;reintroduce;
    procedure SetTagData(pTag: PChar);
    property Name:string read FName;
    property Length:Integer read FLength;
  end;

  TImageTabSheet = class(TTabSheet)
  protected
    FURI:string;
    FSubURI: string;
    FContentData: TStringStream;
    ContentView:IContentView;
    TextView:THogeTextView;
    TextViewStatus:string;
    PrevPos:TPoint;
    FPageStatus:THttpStatus;
    FStatusText:string;
    FRequestClose:Boolean;
    FTabBitmap:TBitmap;
    FProtect:Boolean;
    tmpFileName:TFileName;
    function GetStatusText:String;
    function GetAdjustToWindow:Boolean;
    procedure SetProtect(AProtect:Boolean); virtual;
    procedure SetTabBitmap(ATabBitmap:TBitmap);
    procedure SetAdjustToWindow(AAdjustToWindow:Boolean);
    procedure DecodeComplete(Sender:TObject; DecodeError: Boolean);
    procedure PageControlSelNext(Sender:TObject ;GoForward:Boolean);
    procedure ContentOnSelectTerminate(Sender:TObject);
    function MakeFullURL(PartURL:string):string;
    procedure ShowTextView(Stream:TStream);
    procedure OnBrowserMouseMove(Sender: TObject; Shift: TShiftState;
                                      X, Y: Integer);
    procedure BrowserStatusTextChange(Sender:TObject; AStatusText:string);
    procedure OnBrowserMouseDown(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure OnBrowserMouseUp(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
    procedure BrowserNavigate(URL, RefToSend:string);virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DecodeContent;
    procedure OpenWithExternalResource(UseViewer:Boolean);
    procedure ClickNavigate_D(Sender: TObject; Button: TMouseButton;
                 Shift: TShiftState; X, Y: Integer);
    procedure ClickNavigate_U(Sender: TObject; Button: TMouseButton;
                 Shift: TShiftState; X, Y: Integer);
    procedure ActContentView;
    procedure HideContentView;
    procedure HaltContentView;
    procedure ScrollContentView(x,y:Integer);
    procedure HighlightContentView(Value:Boolean; FromOwnOriginTo:TPageControlDierction);
    procedure TerminateContentViewHighlight;
    procedure RequestClose(Sender:TObject=nil);
    function QuerySaveImage(Path:String=''):Boolean;virtual;
    function SaveImage(Path:string; var SaveModeFlag:TSaveModeFlag):Boolean;virtual;
    procedure SaveToFile(Filename:string);
    function Bitmap:TBitmap;
    property Protect:Boolean read FProtect write SetProtect;
    property TabBitmap:TBitmap read FTabBitmap write SetTabBitmap;
    property URI:string read FURI;
    property SubURI:string read FSubURI;
    property PageStatus:THttpStatus read FPageStatus;
    property StatusText:string read GetStatusText;
    property AdjustToWindow:Boolean read GetAdjustToWindow write SetAdjustToWindow;
    class function TabSheet(Index:Integer):TTabSheet;
    class function TabCount:Integer;
    class function HighlightCount:Integer;
    class procedure ExecuteRequestClose;
    class procedure SetMultipleDelete(Value:Boolean);
    class procedure SetInvisibleTab(Value:Boolean);
  end;


  TLocalImageTabSheet = class(TImageTabSheet)
  public
    procedure OpenFile(FileName: String);
  end;


  TWebLoaderSheet = class(TImageTabSheet)
  protected
    FRefererThread: String;
    HttpSession:THttpSession;
    procedure SetProtect(AProtect:Boolean); override;
    procedure BrowserNavigate(URL, RefToSend: string);override;
  public
    constructor CreatePage(AOwner: TPageControl);
    destructor Destroy;override;
    function OpenURL(URL, OrgURL, ARefererThread, RefToSend: String; OffLine: Boolean): Boolean;
    procedure ReloadImage(NoCache: Boolean);
    procedure SessionOnStatus(Sender: TObject);
    procedure SessionOnWork(Sender: TObject);
    procedure RegisterBrowserCrasher;
    function FromCache: Boolean;
    function CacheExists: Boolean;
    procedure CacheControl(DeleteMode: Boolean);
    property RefererThread: String read FRefererThread;
  end;

procedure FreeImageTabSheet(TabSheet:TTabSheet);

var
  SavePictureDialog:TSavePictureDialog;

implementation

uses
  Forms, StrUtils,
  IdHTTP, UImagePageControl, UArchiveView, UImageViewer, Main,
  IdHTTPHeaderInfo;


type
  TTabDestructor = class(TObject)
  protected
    HandleForMessage:HWND;
    List:TList;
  public
    constructor Create;
    destructor Destroy;override;
    procedure RegisterTab(AImageTabSheet:TImageTabSheet);
    procedure RecieveMessage(var Message:TMessage);
    procedure ExecuteDestruction;
  end;

const
  CallTabDestructor=WM_USER+1003;

  LineFeedTag: array[1..22] of String = (
    'br',
    'h1',
    '/h1',
    'h2',
    '/h2',
    'h3',
    '/h3',
    'h4',
    '/h4',
    'h5',
    '/h5',
    'h6',
    '/h6',
    'table',
    '/table',
    '/tr',
    'div',
    '/div',
    '/p',
    '/li',
    'pre',
    '/pre');

  HeaderTag:array[1..6] of String = (
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6');

  HeaderEndTag:array[1..6] of String = (
    '/h1',
    '/h2',
    '/h3',
    '/h4',
    '/h5',
    '/h6');

  EnabledTag: array[1..7] of String = (
    'b',
    '/b',
    'i',
    '/i',
    'hr',
    '/dd',
    '/dl');

  EnabledLFTag: array[1..6] of String = (
    'blockquote',
    '/blockquote',
    'dt',
    'dd',
    'li',
    'p');

var
  ImageTabSheetList:TList;
  TabDestructor:TTabDestructor;
  MultipleDelete:Boolean=False;
  InvisibleTab:Boolean=False;

constructor TTagAttrList.Create;
begin
  inherited Create;
  CaseSensitive:=False;
end;

procedure TTagAttrList.SetTagData(pTag: PChar);
var
  p,b:pchar;
  len:Integer;
  buffer:String;
begin
  Clear;
  FLength:=-1;
  FName:='';

  p:=pTag;
  len:=StrLen(pTag);

  inc(p);
  if not (p^ in ['a'..'z','A'..'Z','/','!','?']) then
    Exit;

  if StrLIComp(p,'!--',3)=0 then begin
    p:=AnsiStrPos(p,'-->');
    if Assigned(p) then
      FLength:=(p-ptag)+3;
    Exit;
  end;

  buffer:=stringofchar(#0,len);
  UniqueString(buffer);
  b:=Pchar(Buffer);
  while not (p^ in [#0,'>',#9,#10,#13,' ','"','=']) do begin
    b^:=p^;
    inc(b);
    inc(p);
  end;
  FName:=LowerCase(Trim(buffer));

  while not (p^ in [#0,'>']) do begin
    buffer:=stringofchar(#0,len);
    UniqueString(buffer);
    b:=Pchar(Buffer);
    while p^ in [#9,#10,#13,' '] do
      inc(p);
    if p^='"' then begin
      inc(p);
      while not(p^ in [#0,'"']) do
        inc(p);
      if p^='"' then
        inc(p);
    end;
    while not (p^ in [#0,'>',#9,#10,#13,' ','"','=']) do
      if p^ in LeadBytes then begin
        system.move(p^,b^,2);
        inc(b,2);
        inc(p,2);
      end else begin
        b^:=p^;
        inc(b);
        inc(p);
      end;

    while p^ in [#9,#10,#13,' '] do
      inc(p);
    if p^='=' then begin
      b^:='=';
      inc(b);
      inc(p);
      while p^ in [#9,#10,#13,' '] do
        inc(p);
      if p^='"' then begin
        inc(p);
        while not(p^ in [#0,'"']) do
          if p^ in LeadBytes then begin
            system.move(p^,b^,2);
            inc(b,2);
            inc(p,2);
          end else begin
            if not(p^ in [#9,#10,#13]) then begin
              b^:=p^;
              inc(b);
            end;
            inc(p);
          end;
        if p^='"' then
          inc(p);
      end else begin
        while not (p^ in [#0,'>',#9,#10,#13,' ','"']) do
          if p^ in LeadBytes then begin
            system.move(p^,b^,2);
            inc(p,2);
            inc(b,2);
          end else begin
            b^:=p^;
            inc(p);
            inc(b);
          end;
      end;
    end;

    buffer:=trim(buffer);
    if buffer<>'' then
      Add(buffer);
  end;
  FLength:=p-pTag+1;
end;


{ TImageTabSheet }


//生成
constructor TImageTabSheet.Create(AOwner: TComponent);
begin
  inherited;
  FPageStatus := htIDLING;
  FStatusText := HttpStatusText[htIDLING];
  ImageIndex := 0;
  FContentData := TStringStream.Create('');
  OnMouseDown := ClickNavigate_D;
  OnMouseUp := ClickNavigate_U;

  TabVisible := not InvisibleTab;
  with ImageTabSheetList do begin
    Add(Self);
    if Capacity=Count then Capacity := Count * 2;
  end;
  tmpFileName := '';
end;


//破棄
destructor TImageTabSheet.Destroy;
begin

  if tmpFileName<>'' then
    if not DeleteFile(tmpFileName) then
      MessageDlg('テンポラリファイルを削除できませんでした',mtError,[mbOK],0);

  TabBitmap:=nil;
  ContentView:=nil;

  with ImageTabSheetList do begin
    if MultipleDelete then
      Items[IndexOf(Self)]:=nil
    else begin
      Remove(Self);
      if Capacity>Count*3 then Capacity := Count * 2;
    end;
  end;
  FContentData.Free;
  inherited Destroy;
end;


//プロパティ関係
procedure TImageTabSheet.SetTabBitmap(ATabBitmap:TBitmap);
begin
  FTabBitmap:=ATabBitmap;
end;
//
procedure TImageTabSheet.SetProtect(AProtect:Boolean);
begin
  if Assigned(ContentView) then ContentView.Protect:=AProtect;
  FProtect:=AProtect;
end;
//
function TImageTabSheet.GetAdjustToWindow:Boolean;
begin
  Result:=False;
  if Assigned(ContentView) then Result:=ContentView. AdjustToWindow;
end;
procedure TImageTabSheet.SetAdjustToWindow(AAdjustToWindow:Boolean);
begin
  if Assigned(ContentView) then ContentView.AdjustToWindow:=AAdjustToWindow;
end;

function TImageTabSheet.Bitmap:TBitmap;
begin
  Result:=nil;
  if Assigned(ContentView) then Result:=ContentView.Bitmap;
end;

//画像がある時はステータステキストで大きさを通知
function TImageTabSheet.GetStatusText:String;
begin
  if (PageStatus=htCOMPLETED) and Assigned(ContentView) and (ContentView.OriginalSize.X>0) then
    Result:=Format(' %d×%d (%d%%)',[ContentView.OriginalSize.X,ContentView.OriginalSize.Y,ContentView.Scale])
  else
    Result:=FStatusText;
end;



//画像ビューを表示／隠す／止める
procedure TImageTabSheet.ActContentView;
begin
  if Assigned(ContentView) then ContentView.Action;
end;
procedure TImageTabSheet.HideContentView;
begin
  if Assigned(ContentView) then ContentView.Hide;
end;
procedure TImageTabSheet.HaltContentView;
begin
  if Assigned(ContentView) then ContentView.Halt;
end;
procedure TImageTabSheet.HighlightContentView(Value:Boolean; FromOwnOriginTo:TPageControlDierction);
begin
  if Assigned(ContentView) then ContentView.Highlight(Value, FromOwnOriginTo);
end;
procedure TImageTabSheet.TerminateContentViewHighlight;
begin
  if Assigned(ContentView) then ContentView.TerminateHighlight;
end;


//画像をスクロール
procedure TImageTabSheet.ScrollContentView(x,y:Integer);
begin
  if Assigned(ContentView) then ContentView.Scroll(x,y);
end;


//タブシート上のマウスイベント処理振り分け(Down)
procedure TImageTabSheet.ClickNavigate_D(Sender: TObject; Button: TMouseButton;
             Shift: TShiftState; X, Y: Integer);
begin
  if PageControl.CanFocus and not(PageControl.Focused) then PageControl.SetFocus;
  case Button of
    mbLeft:begin
      if ssDouble in Shift then begin
        Screen.Cursor:=crDefault;
        RequestClose;
      end;
    end;
  end;
end;

//タブシート上のマウスイベント処理振り分け(Up)
procedure TImageTabSheet.ClickNavigate_U(Sender: TObject; Button: TMouseButton;
             Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:begin
      if ssAlt in Shift then begin
        OpenWithExternalResource(True);
      end else if ((ssCtrl  in Shift) and ImageViewConfig.SwapCtrlShift)
               or ((ssShift in Shift) and not(ImageViewConfig.SwapCtrlShift))
               or (ssRight in Shift)  then begin
        Protect := False;
      end;
    end;
    mbMiddle:begin
      if ssCtrl in Shift then begin
        ImageForm.QuickSavePopup.PopupComponent:=Self;
        ImageForm.QuickSavePopUp.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y)
      end else begin
        QuerySaveImage;
      end;
    end;
    mbRight:begin
      if ssLeft in Shift then begin
        TImagePageControl(PageControl).Highlighten(PageIndex,not(Highlighted));
        Tag:=Integer(Highlighted);
      end else begin
        PopUpMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
      end;
    end;
  end;
end;


//イメージの保存
function TImageTabSheet.QuerySaveImage(Path: String = ''): Boolean;
begin
  Result:=False;
  if (PageStatus in [htCOMPLETED, htCONTENTERROR]) and Assigned(ContentView) then begin

    SavePictureDialog.InitialDir := Path;
    SavePictureDialog.FileName := Self.Caption;
    SavePictureDialog.Filter := 'すべて(*.*)|*.*';

    ArchiverManager.ModalDialogAppear := True;
    try
      if SavePictureDialog.Execute then begin
        SaveToFile(SavePictureDialog.FileName);
        Result:=True;
      end;
    finally
      ArchiverManager.ModalDialogAppear := False;
    end;
  end;
end;


//イメージの保存２(全て保存で使用)
function TImageTabSheet.SaveImage(Path:string; var SaveModeFlag:TSaveModeFlag):Boolean;
var
  Filename:String;
  Warning:TForm;
begin

  Result:=True;

  if (PageStatus <> htCOMPLETED) or FProtect then Exit;

  Filename:=Path + Self.Caption;
  if FileExists(Filename) then begin
    case SaveModeFlag of
      smNotDefine:begin
        Self.Show;
        ContentView.Action;
        Warning:=CreateMessageDialog('同じ名前"' + Filename + '"のファイルがあります。上書きしますか？',
                                     mtConfirmation, mbYesAllNoAllCancel + [mbRetry]);
        TButton(Warning.FindComponent('Retry')).Caption := '名前を変更(&R)';
        ArchiverManager.ModalDialogAppear := True;
        try
          case Warning.ShowModal of
            mrYes     :SaveToFile(Filename);
            mrNo      :;
            mrCancel  :Result:=False;
            mrRetry   :QuerySaveImage(Path);
            mrNoToAll :SaveModeFlag:=smSkip;
            mrYesToAll:begin
              SaveModeFlag := smOverWrite;
              SaveToFile(Filename);
            end;
          end;
        finally
          ArchiverManager.ModalDialogAppear := False;
        end;
        FreeAndNil(Warning);
      end;
      smOverWrite: SaveToFile(Filename);
      smSkip:;
    end;
  end else begin
    SaveToFile(Filename);
  end;
end;


//コンテンツの保存
procedure TImageTabSheet.SaveToFile(Filename: string);
var
  SaveFile: TFileStream;
begin
  SaveFile := TFileStream.Create(FileName, fmCreate);
  try
    try
      SeekSkipMacBin(FContentData);
      SaveFile.CopyFrom(FContentData, FContentData.Size - FContentData.Position);
    finally
      SaveFile.Free;
    end;
  except
    on e:EFilerError do begin
      Log(e.Message);
      MessageDlg('ファイルを保存できませんでした',mtError,[mbOK],0);
    end;
  end;
end;


//閉じるリクエスト
procedure TImageTabSheet.RequestClose(Sender:TObject=nil);
begin
  TabDestructor.RegisterTab(Self);
end;


//外部ビューアで開く
procedure TImageTabSheet.OpenWithExternalResource(UseViewer:Boolean);
  procedure DelimitCommandDelimiter(Org, Fil: string; var Com, Par: string);
  var
    QL: PChar;
  begin
    Com := '';
    Par := '';
    Org := Trim(Org);
    Fil := Trim(Fil);

    if Org = '' then Exit;

    if Org[1] = '"' then begin
      QL := AnsiStrScan(PChar(Org) + 1, '"');
      if QL <> nil then begin
        Com := Copy(Org, 2, QL - PChar(Org) - 1);
        SetString(Par, QL + 1, Length(Org) - (QL - PChar(Org)) - 1);
        if AnsiPos('$FILE', Par) > 0 then
          Par := StringReplace(Par, '$FILE', Fil, [rfReplaceAll])
        else
          Par := Fil + ' ' + Par;
      end else begin
        Com := Copy(Org, 2, High(Integer));
        Par := Fil;
      end;
    end else begin
      Com := Org;
      Par := Fil;
    end;
  end;
var
  tmpDir: TFileName;
  tmpFile: TFileStream;
  Param: String;
  Command: String;

begin

  if not(Assigned(ContentView)) then Exit;

  tmpDir := ExtractFilePath(Application.ExeName) + TMPDIRNAME;

  if not DirectoryExists(tmpDir) then begin
    if not CreateDir(tmpDir) then begin
      MessageDlg('テンポラリディレクトリを作成できません', mtError, [mbOK], 0);
      Exit;
    end;
  end;
  tmpFileName := IncludeTrailingPathDelimiter(tmpDir) + Caption;
  tmpFile := TFileStream.Create(tmpFileName, fmCreate);
  try
    try
      SeekSkipMacBin(FContentData);
      tmpFile.CopyFrom(FContentData, FContentData.Size - FContentData.Position);
    finally
      tmpFile.Free;
    end;
  except
    on e:EFilerError do begin
      Log(e.Message);
      MessageDlg('テンポラリファイルを作成できません', mtError, [mbOK], 0);
      Exit;
    end;
  end;
  if UseViewer then begin
    DelimitCommandDelimiter(ImageViewConfig.ExternalViewer, tmpFileName, Command, Param);
    ShellExecute(Application.Handle, 'Open', pchar(Command), pchar(Param), pchar(tmpDir), SW_SHOW)
  end else begin
    ArchiverManager.ModalDialogAppear := True;
    if ImageViewConfig.DisableAlartAtOpenWithRelation
       or (MessageDlg(Format('Windowsの関連づけで%sを開きます。'#13#10'ローカルでの安全性を判断して実行してください',
       [Caption]),mtInformation,[mbOk,mbCancel],0)=mrOK) then
      ShellExecute(Application.Handle,'Open',pchar(tmpFileName),'',pchar(tmpDir),SW_SHOW);
    ArchiverManager.ModalDialogAppear:=False;
  end;
end;


//画像、書庫展開の開始処理
procedure TImageTabSheet.DecodeContent;
begin
  if not (PageStatus in [htCOMPLETED, htCONTENTERROR]) then
    Exit;

  TabBitmap:=nil;
  ContentView := nil;
  FStatusText:='Now Decoding...';
  if Assigned(PageControl) and (PageControl is TImagePageControl) then
    TImagePageControl(PageControl).UpdateStatusBar(Self);
  if ImageViewConfig.ExamArchiveType(Caption)<>atNone then begin
    ContentView:=TArchiveView.Create(Self);
    ContentView.OnEdge:=PageControlSelNext;
    ContentView.OnSelectionTerminate:=ContentOnSelectTerminate;
    ContentView.OnContentClose:=RequestClose;
  {$IFDEF FLASH}
  end else if SameText(ExtractFileExt(FURI),'.swf') then begin
    ContentView:=TFlashView.Create(Self);
  {$ENDIF}
  end else begin
    ContentView:=TImageView.Create(Self);
  end;
  ContentView.Info := Caption;
  ContentView.Protect := Protect;
  ContentView.OnMouseDown := ClickNavigate_D;
  ContentView.OnMouseUp := ClickNavigate_U;
  ContentView.OnComplete := Self.DecodeComplete;
  ContentView.AssignData(FContentData);
end;


//画像、書庫展開の完了処理
procedure TImageTabSheet.DecodeComplete(Sender:TObject; DecodeError: Boolean);
begin
  if DecodeError then begin
    FPageStatus := htCONTENTERROR;
    FStatusText:='Decode Error';
    ImageIndex:=3;
    ShowTextView(FContentData);
  end else begin
    FPageStatus:=htCOMPLETED;
    FStatusText:=HttpStatusText[htCOMPLETED];
    TabBitmap:=ContentView.SmallBitmap;
    ImageIndex:=2;
    if PageControl.ActivePage=Self then ContentView.Action;
  end;

  if Assigned(PageControl) and (PageControl is TImagePageControl) then
    TImagePageControl(PageControl).UpdateStatusBar(Self);

end;


//デコードエラーの時はテキスト表示
procedure TImageTabSheet.ShowTextView(Stream:TStream);
var
  buffer1, buffer2, tmp: string;
  p1, p2, pe:PChar;
  len: Integer;
  LF: Integer;
  InLinkElem: string;
  Invisible: Boolean;
  Header : Boolean;
  Pre: Boolean;
  i: Integer;
  stv: TSimpleDat2View;
  TagData: TTagAttrList;
  ImgWidth, ImgHeight: Integer;

  function WashStr(s:string):string;
  begin
    Result := StringReplace(s, '&','&amp;', [rfReplaceAll]);
    Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
    Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
    Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  end;

  procedure WriteBuffer(p:pchar; l:Integer);
  var
    pos: Integer;
  begin
    if not Invisible then begin
      while p2 + l >= pe do begin
        pos := p2 - PChar(buffer2);
        buffer2 := buffer2 + StringOfChar(#0, len);
        UniqueString(buffer2);
        p2 := PChar(buffer2) + pos;
        len := length(buffer2);
        {バッファオーバーフローに関する修正}
        //pe := p2 + len;
        pe := PChar(buffer2) + len;
        {/バッファオーバーフローに関する修正}
      end;
      System.Move(p^, p2^, l);
      inc(p2, l);
    end;
  end;

begin

  if Assigned(Stream) then begin
    Stream.Seek(soFromBeginning,0);
    len:=Stream.Size;
    buffer1:=StringOfChar(#0,len);
    Stream.Read(PChar(buffer1)^,len);
    if AnsiContainsText(buffer1,'charset=UTF-8') then begin
      buffer1:=UTF8toAnsi(buffer1);
    end else if InCodeCheck(buffer1)<>BINARY then begin
      buffer1:=ConvertJCode(buffer1,SJIS_OUT)
    end else begin
      buffer1:='<html><body>Binary Data</body></html>';
      len:=Length(buffer1);
    end;
  end else begin
    buffer1:='<html><body>No Data</body></html>';
    len:=Length(buffer1);
  end;

  p1 := PChar(buffer1);
  buffer2 := StringOfChar(#0, (len + 1) * 4);
  p2 := PChar(buffer2);
  pe := p2 + Length(buffer2); //バッファオーバーフローに関する修正
  
  LF:=0;
  InLinkElem:='';
  Invisible:=False;
  Header:=False;
  Pre:=False;

  TagData:=TTagAttrList.Create;

  while p1^<>#0 do
    if p1^ in LeadBytes then begin
      WriteBuffer(p1,2);
      inc(p1,2);
      LF:=0;
    end else if p1^='<' then begin
      TagData.SetTagData(p1);
      if TagData.Length<0 then begin
        WriteBuffer('&lt;',4);
        inc(p1);
      end else if TagData.Name='title' then begin
        WriteBuffer('<b><SA i="2"/>&lt;&lt;&lt;',26);
        inc(p1,TagData.Length);
      end else if TagData.Name='/title' then begin
        WriteBuffer('&gt;&gt;&gt;<SA i="0"/></b><br>',31);
        inc(p1,TagData.Length);
      end else if (TagData.Name='script') or (TagData.Name='style') then begin
        Invisible:=True;
        inc(p1,TagData.Length);
      end else if (TagData.Name='/script') or (TagData.Name='/style') then begin
        Invisible:=False;
        inc(p1,TagData.Length);
      end else if (TagData.Name='frame') or (TagData.Name='iframe') or (TagData.Name='ilayer') then begin
        tmp:='<b>●フレーム</b>[';
        if TagData.Values['name']<>'' then
          tmp:=tmp+WashStr(TagData.Values['name']);
        tmp:=tmp+'<a href="'+TagData.Values['src']+'">■</a>]<br>';
        WriteBuffer(PChar(tmp),Length(tmp));
        LF:=0;
        inc(p1,TagData.Length);
      end else if TagData.Name='img' then begin
        try
          ImgHeight:=StrToInt(TagData.Values['height']);
        except
          ImgHeight:=High(Integer);
        end;
        try
          ImgWidth:=StrToInt(TagData.Values['width']);
        except
          ImgWidth:=High(Integer);
        end;

        if ((ImgWidth>=32) and (ImgHeight>=32)) or (InLinkElem<>'') then begin
          tmp:='■画像';
          if TagData.Values['alt']<>'' then
            tmp:=tmp+'['+WashStr(TagData.Values['alt'])+']';
          if (InLinkElem<>'') then
            tmp:=tmp+'</a>['
          else
            tmp:=tmp+'[';
          if (TagData.Values['width']<>'') and (TagData.Values['height']<>'') then
            tmp:=tmp+WashStr(TagData.Values['width'])+'×'+WashStr(TagData.Values['height']);
          tmp:=tmp+'<a href="'+TagData.Values['src']+'">■</a>]';
          WriteBuffer(PChar(tmp),Length(tmp));
          LF:=0;
        end;
        inc(p1,TagData.Length);
      end else if TagData.Name='a' then begin
        if InLinkElem<>'' then
          tmp:='</a>'
        else
          tmp:='';
        if TagData.Values['href']='' then begin
          if TagData.IndexOf('href=')>=0 then begin
            tmp:=tmp+'<a href=" ">';
            InLinkElem:=' ';
          end else begin
            InLinkElem:='';
          end;
        end else begin
          tmp:=tmp+'<a href="'+TagData.Values['href']+'">';
          InLinkElem:=TagData.Values['href'];
        end;
        if tmp<>'' then
          WriteBuffer(PChar(tmp),Length(tmp));
        inc(p1,TagData.Length);
        LF:=0;
      end else if TagData.Name='/a' then begin
        if InLinkElem<>'' then
          WriteBuffer('</a>',4);
        inc(p1,TagData.Length);
        InLinkElem:='';
      end else begin //その他のタグ

        if Header then
          for i:=Low(HeaderEndTag) to High(HeaderEndTag) do
            if TagData.Name=HeaderEndTag[i] then begin
              WriteBuffer('</b><SA i="0"/>',15);
              Header:=False;
            end;

        if TagData.Name='pre' then Pre:=True;
        if TagData.Name='/pre' then Pre:=False;

        for i:=Low(LineFeedTag) to High(LineFeedTag) do
          if TagData.Name=LineFeedTag[i] then begin
            if LF<2 then begin
              if InLinkElem<>'' then begin
                if TagData.Name='table' then begin
                  tmp:='</a><br>';
                  InLinkElem:='';
                end else begin
                  tmp:='</a><br><a href="'+InLinkElem+'">';
                end;
              end else begin
                tmp:='<br>';
              end;
              WriteBuffer(Pchar(tmp),Length(tmp));
            end;
            inc(LF);
          end;

        for i:=Low(EnabledTag) to High(EnabledTag) do
          if TagData.Name=EnabledTag[i] then begin
            if InLinkElem<>'' then
              tmp:='</a><'+EnabledTag[i]+'><a href="'+InLinkElem+'">'
            else
              tmp:='<'+EnabledTag[i]+'>';
            WriteBuffer(Pchar(tmp),Length(tmp));
          end;

        for i:=Low(EnabledLFTag) to High(EnabledLFTag) do
          if TagData.Name=EnabledLFTag[i] then begin
            if LF=0 then
              tmp := 'br><'+EnabledLFTag[i]
            else
              tmp := EnabledLFTag[i];
            if InLinkElem<>'' then
              tmp:='</a><'+tmp+'><a href="'+InLinkElem+'">'
            else
              tmp:='<'+tmp+'>';
            WriteBuffer(Pchar(tmp),Length(tmp));
            inc(LF);
          end;

        if Not Header then
          for i:=Low(HeaderTag) to High(HeaderTag) do
            if TagData.Name=HeaderTag[i] then begin
              WriteBuffer('<SA i="2"/><b>',14);
              Header:=True;
            end;

        inc(p1,TagData.Length);
      end;
    end else begin
      if p1^ in [#9,#10,#13,' '] then begin
        if Pre then begin
          case p1^ of
            #9:tmp:='&ensp;';
            #13:begin
              tmp:='<br>';
              if (p1+1)^=#10 then inc(p1);
            end;
            #10:tmp:='<br>';
            ' ':tmp:='&nbsp;';
          else
            tmp:='';
          end;
          WriteBuffer(Pchar(tmp),Length(tmp));
          inc(p1);
        end else begin
          WriteBuffer(p1,1);
          inc(p1);
        end;
      end else begin
        LF:=0;
        WriteBuffer(p1,1);
        inc(p1);
      end;
    end;

  TagData.Free;

  buffer2:=Trim(buffer2);

  TextView:=THogeTextView.Create(Self);
  TextView.Parent:=Self;
  TextView.Align:=alClient;
  TextView.LeftMargin := 8;
  TextView.TopMargin := 4;
  TextView.RightMargin := 8;
  TextView.ExternalLeading := 1;
  Move(Main.Config.viewTextAttrib, TextView.TextAttrib, SizeOf(TextView.TextAttrib));
  TextView.SetFont(Font.Name, Font.Size);
  TextView.PopupMenu:=PopupMenu;
  TextView.OnMouseMove:=OnBrowserMouseMove;
  TextView.OnMouseDown:=OnBrowserMouseDown;
  TextView.OnMouseUp:=OnBrowserMouseUp;
  TextView.Color := Config.clViewColor;
  TextView.VerticalCaretMargin := Config.viewVerticalCaretMargin;
  TextView.WheelPageScroll := Config.viewPageScroll;
  TextView.VScrollLines := Config.viewScrollLines;
  {beginner}
  TextView.EnableAutoScroll := Config.viewEnableAutoScroll;
  TextView.Frames := Config.viewScrollSmoothness;
  TextView.FrameRate := Config.viewScrollFrameRate;
  {/beginner}

  stv:=TSimpleDat2View.Create(TextView);
  stv.WriteHTML(pchar(buffer2),length(buffer2));
  stv.Flush;
  stv.Free;

  TextView.SetTop(0);
  TextView.SetPhysicalCaret(0,0);

end;

//TextView上でのマウス移動
procedure TImageTabSheet.OnBrowserMouseMove(Sender: TObject; Shift: TShiftState;
                                      X, Y: Integer);
var
  st: String;
begin
  if (X = PrevPos.X) and (Y = PrevPos.Y) then
    exit;
  PrevPos.X := X;
  PrevPos.Y := Y;
  st := Trim(TVMouseProc(THogeTextView(Sender), Shift, X, Y));
  if (st<>'') and (st[1] =#$27) then
    st := copy(st, 2, Length(st) - 1);
  if (st<>'') and (st[Length(st)] =#$27) then
    st := copy(st, 1, Length(st) - 1);

  st := Trim(st);

  if st <> TextViewStatus then
  begin
    TextViewStatus := st;
    BrowserStatusTextChange(Sender, TextViewStatus);
  end
  else if length(st) <= 0 then
    ImageForm.PopupHint.ReleaseHandle;
end;


//ポップアップ
procedure TImageTabSheet.BrowserStatusTextChange(Sender:TObject; AStatusText:string);
var
  {koreawatcher}
  Point: TPoint;
  IdStr: string;
  {/koreawatcher}
begin
  {koreawatcher}
  Point := Mouse.CursorPos;
  IdStr := AStatusText;
  {/koreawatcher}
  if AStatusText<>'' then begin
    if not MainWnd.Show2chInfo(Point, IdStr, AStatusText, nil, False) then //koreawatcher 追加
      if not ImageForm.ShowImageHint(MakeFullURL(AStatusText),True) then
        //MainWnd.PopupHint.ShowTextHint(MakeFullURL(AStatusText),Mouse.CursorPos); //koreawatcher 削除
        MainWnd.ShowHint(Point, MakeFullURL(AStatusText)) //koreawatcher 追加
  end else begin
    MainWnd.PopupHint.ReleaseHandle;
  end;
end;


//TextView上のマウスクリック
procedure TImageTabSheet.OnBrowserMouseDown(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
var
  NavigationURL:string;
begin
  case Button of
  mbLeft:
    begin
      OnBrowserMouseMove(Sender, Shift, X, Y);
      if TextViewStatus<>'' then begin
        NavigationURL:=MakeFullURL(TextViewStatus);
        if StrLIComp(PChar(NavigationURL),'http:',5)<>0 then Exit;
        MainWnd.PopupHint.ReleaseHandle;
        if not MainWnd.NavigateIntoView(NavigationURL, gtOther) then
          BrowserNavigate(NavigationURL, '');
        THogeTextView(Sender).Selecting := False;
      end;
    end;
  mbRight:;
  end;
end;


procedure TImageTabSheet.OnBrowserMouseUp(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbRight:TextView.PopUpMenu.PopUp(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
end;


//ページロード(新規タブを作成)
procedure TImageTabSheet.BrowserNavigate(URL, RefToSend: string);
begin
  ImageForm.GetImage(URL, nil, Self);
end;


//部分URLから完全URLを生成 "../"はまっとうには処理しない
function TImageTabSheet.MakeFullURL(PartURL:string):string;
var
  Delimit:Integer;
  Base:string;
begin
  PartURL:=Trim(PartURL);

  if PartURL='' then begin
    Result:=FURI;
  end else if (StrLIComp(pchar(PartURL),'http:',5)=0)
      or (StrLIComp(pchar(PartURL),'https:',6)=0)
      or (StrLIComp(pchar(PartURL),'mailto:',7)=0)
      or (StrLIComp(pchar(PartURL),'ftp:',4)=0)
      or (StrLIComp(pchar(PartURL),'gopher:',7)=0)
      or (StrLIComp(pchar(PartURL),'file:',5)=0) then begin
    Result:=PartURL;
  end else begin
    if StrLIComp(pchar(URI),'http://',7)=0 then begin
      Base:=copy(URI,8,High(Integer));
      if PartURL[1]='/' then begin
        Delimit:=AnsiPos('/',Base);
        if Delimit=0 then
          Result:=URI+PartURL
        else
          Result:='http://'+copy(Base,1,Delimit-1)+PartURL;
      end else begin
        Base:=URI;
        Delimit:=AnsiPos('#',Base);
        if delimit<>0 then
          Base:=copy(Base,1,Delimit-1);
        Delimit:=AnsiPos('?',base);
        if delimit<>0 then
          Base:=copy(Base,1,Delimit-1);
        Delimit:=LastDelimiter('/',base);
        if delimit=0 then
          Result:=URI+'/'+PartURL
        else
          Result:=copy(URI,1,delimit)+PartURL;
      end;
    end else
      Result:=PartURL;
  end;
end;


//親ページコントロールのアクティブページを移動させる
procedure TImageTabSheet.PageControlSelNext(Sender:TObject ;GoForward:Boolean);
begin
  if Assigned(PageControl) then
    if PageControl is TImagePageControl then
      if GoForward then
        TImagePageControl(PageControl).GoForward
      else
        TImagePageControl(PageControl).GoBackward
    else
      PageControl.SelectNextPage(GoForward);
end;

procedure TImageTabSheet.ContentOnSelectTerminate(Sender:TObject);
begin
  if Assigned(PageControl) and (PageControl is TImagePageControl) then
    TImagePageControl(PageControl).TerminateSelectionState;
end;

//作成順がIndexのタブシートを返す列挙用のクラス関数
class function TImageTabSheet.TabSheet(Index:Integer):TTabSheet;
begin
  Result:=TTabSheet(ImageTabSheetList[Index]);
end;


//全てのTTabSheetCountの数を返す
//連続削除モード中は正しい値を返さないので注意
class function TImageTabSheet.TabCount:Integer;
begin
  Result:=ImageTabSheetList.Count;
end;


//ハイライトされたタブの数を返す
class function TImageTabSheet.HighlightCount:Integer;
var
  i:Integer;
begin
  Result:=0;
  for i:=0 to ImageTabSheetList.Count-1 do
    if TTabSheet(ImageTabSheetList[i]).Highlighted then Inc(Result);
end;


//Tabdestructorに溜まったタブクローズのリクエストを処理する
//削除されるタブシートから呼び出さないよう注意
class procedure TImageTabSheet.ExecuteRequestClose;
begin
  TabDestructor.ExecuteDestruction;
end;


//連続削除モード(削除でタブの通番がずれないよう、削除したタブがnilでリストに残る)設定
class procedure TImageTabSheet.SetMultipleDelete(Value:Boolean);
begin
  MultipleDelete:=Value;
  if not MultipleDelete then
    with ImageTabSheetList do begin
      Pack;
      if Capacity>Count*3 then Capacity := Count * 2;
    end;
end;


//タブ非表示モードの設定
class procedure TImageTabSheet.SetInvisibleTab(Value:Boolean);
var
  i:Integer;
begin
  InvisibleTab:=Value;
  for i:=0 to ImageTabSheetList.Count-1 do
    TTabSheet(ImageTabSheetList[i]).TabVisible:=not InvisibleTab;
end;




{ TLocalImageTabSheet }


//ファイルの読み込み
procedure TLocalImageTabSheet.OpenFile(Filename: String);
var
  ImageFile:TFilestream;
begin
  FURI:=ExtractFileName(StringReplace(Filename,'/','\',[rfReplaceAll]));
  Caption:=FURI;

  FContentData.Size := 0;
  try
    ImageFile := TFileStream.Create(Filename, fmOpenRead);
    try
      FContentData.CopyFrom(ImageFile, 0);
    finally
      ImageFile.Free;
    end;
  except
    on e:Exception do begin
      log(e.Message);
      FPageStatus := htERROR;
      Exit;
    end;
  end;
  FPageStatus := htCOMPLETED;
  DecodeContent;
end;




{ TWebLoaderSheet }


//イメージ読み込みパネルの作成、HttpSession作成
constructor TWebLoaderSheet.CreatePage(AOwner: TPageControl);
begin
  inherited Create(AOwner);
  HttpSession := THttpSession.Create(HttpManager);
  HttpSession.Data := FContentData;
  HttpSession.OnStatus := SessionOnStatus;
  HttpSession.OnWork := SessionOnWork;
end;


//イメージ読み込みパネルの破棄
destructor TWebLoaderSheet.Destroy;
begin
  FreeAndNil(HttpSession);
  ContentView:=nil;
  inherited Destroy;
end;


//URLを設定、読み込み
function TWebLoaderSheet.OpenURL(URL, OrgURL, ARefererThread, RefToSend: String; OffLine: Boolean): Boolean;
begin
  ImageIndex := 0;
  FPageStatus:=htSTANDBY;
  FStatusText:=HttpStatusText[FPageStatus];

  FURI := URL;
  Caption:=ExtractFileName(StringReplace(FURI,'/','\',[rfReplaceAll]));
  FRefererThread := ARefererThread;

  if orgURL <> '' then
    FSubURI := OrgURL
  else
    FSubURI := URL;
  if RefToSend<>'' then
    HttpSession.Request.Referer := RefToSend;
  Result := HttpSession.Load(FURI, RefToSend, OffLine);
end;


//HttpSessionのステータス更新通知ルーチン
procedure TWebLoaderSheet.SessionOnStatus(sender: TObject);
begin
  FPageStatus:=HttpSession.Status;
  FStatusText:=HttpStatusText[FPageStatus];
  case FPageStatus of
    htCONNECTING, htTRANSFER: begin
      ImageIndex:=1;
      if Assigned(PageControl) and (PageControl is TImagePageControl) then
        TImagePageControl(PageControl).UpdateStatusBar(Self);
    end;
    htCOMPLETED: begin
      FProtect := HttpSession.Protect;
      FPageStatus := htCOMPLETED;
      DecodeContent;
    end;
    htTERMINATED: begin
      ImageIndex := 3;
      if Assigned(PageControl) and (PageControl is TImagePageControl) then
        TImagePageControl(PageControl).UpdateStatusBar(Self);
    end;
    htERROR: begin
      ImageIndex := 3;
      FStatusText := HttpSession.Response.ResponseText;
      if Assigned(PageControl) and (PageControl is TImagePageControl) then
        TImagePageControl(PageControl).UpdateStatusBar(Self);
    end;
  end;
end;


//ダウンロードバイト数の表示
procedure TWebLoaderSheet.SessionOnWork(Sender:TObject);
begin
  if HttpSession.Response.ContentLength >= 1048576 then
    FStatusText := Format('( %d/%dkb)', [HttpSession.DownLoadSize div 1024, HttpSession.Response.ContentLength div 1024])
  else if HttpSession.Response.ContentLength>0 then
    FStatusText := Format('( %d/%db)', [HttpSession.DownLoadSize, HttpSession.Response.ContentLength])
  else
    FStatusText := Format('Loading %dbyte',[HttpSession.DownLoadSize]);
  if Assigned(PageControl) and (PageControl is TImagePageControl) then
    TImagePageControl(PageControl).UpdateStatusBar(Self);
end;


//画像のリロード
procedure TWebLoaderSheet.ReloadImage(NoCache: Boolean);
begin
  if not Main.Config.netOnline then Exit;
  if (PageStatus = htError) or ((PageStatus in [htCOMPLETED, htCONTENTERROR]) and FromCache) then begin
    FPageStatus:=htSTANDBY;
    FStatusText:=HttpStatusText[FPageStatus];
    ImageIndex:=0;
    if Assigned(ContentView) then
      FProtect:=ContentView.Protect;
    ContentView:=nil;
    FreeAndNil(TextView);
    HttpSession.Reload(NoCache);
  end;
end;


//ページロード(新規タブを作成)
procedure TWebLoaderSheet.BrowserNavigate(URL, RefToSend: string);
var
  ModifiedURL, NewRef: String;
begin
  if GetKeyState(VK_CONTROL) < 0 then begin
    ContentView := nil;
    FreeAndNil(TextView);
    ModifiedURL := ProofURLwithRef(URL, NewRef, False);
    if RefToSend = '' then
      RefToSend := NewRef;
    OpenURL(ModifiedURL, URL, '', RefToSend, False);
  end else begin
    inherited;
  end;
end;


//ブラクラ指定
procedure TWebLoaderSheet.RegisterBrowserCrasher;
begin
  if Assigned(HttpSession) then begin
    HttpSession.BrowserCracher := True;
    HttpSession.WriteCache;
    RequestClose;
  end;
end;


//モザイク条件変更をキャッシュにも保存する
procedure TWebLoaderSheet.SetProtect(AProtect:Boolean);
begin
  inherited;
  HttpSession.Protect := AProtect;
  if (HttpSession.Status in [htCOMPLETED, htCONTENTERROR]) and not(ImageViewConfig.CacheSelectedFileOnly) then
    HttpSession.WriteCache;
end;


//キャッシュから読み込まれたデータかどうかの判定
function TWebLoaderSheet.FromCache: Boolean;
begin
  Result := Assigned(HttpSession) and HttpSession.FromCache;
end;


//キャッシュファイルの存在確認
function TWebLoaderSheet.CacheExists: Boolean;
begin
  if Assigned(HttpSession) then
    Result := HttpSession.CacheExists
  else
    Result := False;
end;


//キャッシュの削除、手動保存
procedure TWebLoaderSheet.CacheControl(DeleteMode: Boolean);
begin
  if Assigned(HttpSession) then
    if DeleteMode then
      HttpSession.DeleteCache
    else
      HttpSession.WriteCache;
end;


{ TTabDestructor }

constructor TTabDestructor.Create;
begin
  inherited;
  List:=TList.Create;
  HandleForMessage:=classes.AllocateHWnd(RecieveMessage);
end;

destructor TTabDestructor.Destroy;
begin
  List.Free;
  classes.DeallocateHWnd(HandleForMessage);
  inherited Destroy;
end;

//削除するタブシートの登録
procedure TTabDestructor.RegisterTab(AImageTabSheet:TImageTabSheet);
begin
  List.Add(AImageTabSheet);
  PostMessage(HandleForMessage,CallTabDestructor,0,0);
end;

//届いたメッセージを確認して削除処理を呼び出し
procedure TTabDestructor.RecieveMessage(var Message:TMessage);
begin
  if Message.msg=CallTabDestructor then
    ExecuteDestruction
  else
    Message.Result := DefWindowProc(HandleForMessage, Message.Msg, Message.wParam, Message.lParam);
end;

//タブシートの削除処理
procedure TTabDestructor.ExecuteDestruction;
var
  i:Integer;
  DestructedSheet:TImageTabSheet;
  DummyMsg:TMsg;
begin
  PeekMessage(DummyMsg,HandleForMessage,CallTabDestructor,CallTabDestructor,PM_REMOVE);//余分なメッセージを破棄
  for i:=0 to List.Count-1 do begin
    DestructedSheet:=TImageTabSheet(List[i]);
    if ImageTabSheetList.IndexOf(DestructedSheet)>=0 then
      FreeImageTabSheet(DestructedSheet);
    List.Remove(DestructedSheet);
  end;
end;




//タブシートの削除(そのままFreeするとPageControlで必要なイベントが発生しないため)
procedure FreeImageTabSheet(TabSheet:TTabSheet);
var
  PageControl:TImagePageControl;
  Index:Integer;
begin
  if not Assigned(TabSheet) then Exit;

  PageControl:=TImagePageControl(TabSheet.PageControl);
  if not Assigned(PageControl) then begin
    TabSheet.Free;
  end else if TabSheet=PageControl.ActivePage then begin
    Index:=PageControl.ActivePageIndex;
    PageControl.CanChange;
    PageControl.ActivePage:=nil;
    TabSheet.Free;
    if ImageViewConfig.GoLeftWhenTabClose then begin
      if Index>0 then Dec(Index);
    end else begin
      if Index>=PageControl.PageCount then Index:=PageControl.PageCount-1;
    end;
    PageControl.ActivePageIndex:=Index;
    PageControl.Change;
    PageControl.CheckTabExist;
  end else begin
    TabSheet.Free;
    PageControl.CheckTabExist;
  end;

end;


initialization
  TabDestructor:=TTabDestructor.Create;
  ImageTabSheetList:=TList.Create;
  SavePictureDialog:=TSavePictureDialog.Create(nil);
  SavePictureDialog.Options:=SavePictureDialog.Options + [ofDontAddToRecent,ofOverwritePrompt];

finalization
  SavePictureDialog.Free;
  ImageTabSheetList.Free;
  TabDestructor.Free;

end.
