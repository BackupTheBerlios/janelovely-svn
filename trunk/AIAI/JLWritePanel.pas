unit JLWritePanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, ComCtrls, StdCtrls,
  Graphics, DateUtils, StrUtils, Dialogs, IMM,
  JConfig, HogeTextView, JLBaseWritePanel, jconvert, StrSub, U2chBoard,
  U2chThread, UViewItem, UDat2HTML, UCrypt, UXTime, U2chTicket, UAsync,
  HTTPSub, IdURI;

const
  MORNINGCOFFEE_NAME = '名無し募集中。。。';
  WAIT_LIST_FILE     = 'WriteWait.ini';
  WRITE_BUTTON_CAPTION_A  = '書込(Shift+Enter)';
  WRITE_BUTTON_CAPTION_B  = 'あと';
  WRITE_BUTTON_CAPTION_C  = '秒';

type
  TPostType = (postNormal, postCheck);

  TJLWritePanel = class(TJLBaseWritePanel)
  protected
    FParent2: TWinControl;
    BBSLineNumuber: Integer;
    BBSMessageCount: Integer;
    BBSSubjectCount: Integer;
    BBSNameCount: Integer;
    BBSMailCount: Integer;
    FBoard: TBoard;
    FThread: TThreadItem;
    postType: TPostType;
    postCode: string;
    procPost: TAsyncReq;
    writeRetryCount: integer;
    cookieRetryCount: integer;
    kakikomiFile: TFileStream;
    TargetThread: TThreadItem;
    TargetBoard: TBoard;
    FloatLeft: integer;
    FloatTop: integer;
    WaitList: TStringList;
    WaitTimer: TTimer;
    waittime: integer;
    hostname: string;
    procedure CreatePreView; override;
    procedure Post; override;
    procedure PasteAA; override;
    procedure ToolButtonHandle(Sender: TToolButton; tag: integer); override;
    procedure ChangeStatusBar; override;
    procedure ChangeMemoIme; override;
    procedure SaveMemoIme; override;

    function Res2Dat: String;
    class function Trip(const Key: string): string;
    procedure PasteAAListItem;
    procedure UnableWrite;
    procedure EnableWrite;
    procedure SetBoard(ABoard: TBoard);
    procedure SetNameBox;
    procedure SetMailBox;
    procedure SetNameMail;
    procedure SaveNameMailToList;
    procedure SaveKakikomi;
    function PreWriteWarning: Boolean;
    procedure PostArticle;
    procedure OnNotify(sender: TAsyncReq; code: TAsyncNotifyCode);
    procedure OnWritten(sender: TAsyncReq);
    procedure WaitTimerStart;
    procedure WaitTimerStop;
    procedure WaitTimerTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetUp(AParent: TWinControl); override;
    procedure SetToolBarImageList(AImageList: TImageList);
    procedure SetThread(AThread: TThreadItem);
    procedure SetSettingTxt;
    procedure SetAAList;
    procedure ChangeEnableWrite(AEnabled: Boolean);
    procedure SetMemoText(AText: String);
    procedure ChangeWriteMemoColor;
    procedure ChangeWriteMemoFont;
    procedure ChangePreViewStyle;
    function WriteWait: Boolean;
    procedure SetRecordNameMailCheckBox(ABool: Boolean);
    procedure SetTrimRightCheckBox(ABool: Boolean);
    procedure SetFocusToMemo;
    procedure SetWriteButtonEnabled(ABool: Boolean);
    procedure ChangeMainPageControlActiveTab(newTab: integer); override;
    procedure SetNameMailWarning(ABool: Boolean);

    property board: TBoard read FBoard write SetBoard;
    property Parent2: TWinControl read FParent2;
    property waithost: String read hostname;
  end;

var
  WriteMemo: TJLWritePanel;

//-------------------------- Util Func --------------------------------------//
procedure CreateWriteMemo(AOwner: TComponent; AParent: TWinControl;
  AImageList: TImageList);
procedure ChangeWriteMemoThread(AThread: TThreadItem);
procedure ChangeWriteMemoSettingText(ABoard: TBoard);
procedure ChangeWirteButtonEnabled(AEnabled: Boolean);
procedure ChangeWriteMemoText(AText: String);
procedure UpdateAAComboBox;
procedure ChangeWriteMemoStyle;
function CheckWriteWait(hostname: String): Boolean;
procedure SetNameBox;
procedure SetMailBox;
procedure SetRecordNameMailCheckBox(ABool: Boolean);
procedure SetTrimRightCheckBox(ABool: Boolean);
procedure SetFocusToWriteMemo;
procedure SetWriteButtonEnabled(ABool: Boolean);
procedure ChangeMainPageControlActiveTab(newTab: integer);
procedure SetNameMailWarning(AValue: Boolean);
//---------------------------------------------------------------------------//

implementation

uses Main, UWriteForm;

//{$DEFINE WRITEPANELDEBUG}

(* 書き込み可否判定用のメッセージバイト数 *)
//途中にヌルを含まず改行=CRLFのSJIS文字列専用
function MessageCount(Msg: String): Integer;
var
  p: PChar;
Label
  PermanentLoop;
begin
  Result := Length(Msg);
  p := PChar(Msg);
  PermanentLoop: //極力軽くするためgotoのLoop
  begin
    case p^ of
      #0: Exit; //末尾判定これだけなので注意
      #13:
        begin
          Inc(p, 2);
          Inc(Result, 4);
        end;
      '>', '<':
        begin
          Inc(p);
          Inc(Result, 3);
        end;
      #$81..#$9f, #$e0..#$fc:
        Inc(p, 2);
      else
        Inc(p);
    end;
  end;
  goto PermanentLoop;
end;



{ TJLWritePanel }

constructor TJLWritePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  hostname := '';
  writing := false;
  WaitList := TStringList.Create;
  WaitTimer := TTimer.Create(Self);
  WaitTimer.Interval := 1000;
  WaitTimer.OnTimer := WaitTimerTimer;
  WaitTimer.Enabled := False;
end;

destructor TJLWritePanel.Destroy;
begin
  WaitList.Free;
  WaitTimer.Free;

  inherited Destroy;
end;



procedure TJLWritePanel.CreatePreView;
  function MakeDummyDat(line: Integer):string;
  const
    dummyDat : string = '<><><><>'#10;
  begin
    Result := DupeString(dummyDat, line);
  end;

  function ZoomToPoint(zoom: integer): Integer;
  begin
    try
      result := Config.viewZoomPointArray[zoom];
    except
      result := -9;
    end; //try
  end;

  function ZoomToExternalLeading(zoom: integer): Integer;
  begin
    result := 1;
    case zoom of
    0: result := 1;
    1: result := 2;
    2: result := 2;
    3: result := 3;
    4: result := 4;
    end;
  end;

var
  TempStream: TDat2PreViewView;
  dat: TThreadData;
  PreViewD2HTML: TDat2HTML;
begin
  inherited;

  PreViewItem.Base := '';
  PreView.HoverTime := Config.hintHoverTime;
  PreView.Clear;

  TempStream := TDat2PreViewView.Create(PreView);
  PreViewD2HTML := TDat2HTML.Create(NewRecHTML);
  dat := TThreadData.Create;

  try
    PreView.ExternalLeading := ZoomToExternalLeading(Config.viewZoomSize);
    PreView.SetFont(Preview.Font.Name, ZoomToPoint(Config.viewZoomSize));
    TempStream.WriteHTML(HeaderHTML);
    TempStream.Flush;
    if Assigned(FThread) then
    begin
      PreViewItem.thread := FThread;
      dat.Add(MakeDummyDat(FThread.lines));
      dat.Add(Res2Dat);
      PreViewD2HTML.ToDatOut(TempStream, dat, FThread.lines + 1, 1)
    end else
    begin
      dat.Add(Res2Dat);
      PreViewD2HTML.ToDatOut(TempStream, dat, 1, 1);
    end;
    TempStream.Flush;
  finally
    dat.Free;
    PreViewD2HTML.Free;
    TempStream.Free;
  end;
end;

procedure TJLWritePanel.Post;
var
  viewItem: TViewItem;
  temptext: String;
begin
  inherited;

  viewItem := MainWnd.GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  TargetThread := viewItem.thread;

  if TargetThread <> FThread then
  begin
    tempText :=  'なんかおかしくなった' + #13#10 +
                 '見てるスレ：' + HTML2String(FThread.title) + #13#10 +
                 '書込みスレ：' + HTML2String(TargetThread.title);
    MessageBox(Self.Handle, PChar(tempText), '警告', MB_ICONEXCLAMATION);
    TargetThread := nil;
    exit;
  end;

  TargetBoard := TBoard(TargetThread.board);

  if TargetBoard <> FBoard then
  begin
    tempText :=  'なんかおかしくなった' + #13#10 +
                 '見てるスレの板：' + HTML2String(FBoard.name) + #13#10 +
                 '書込みスレの板：' + HTML2String(TargetBoard.name);
    MessageBox(Self.Handle, PChar(tempText), '警告', MB_ICONEXCLAMATION);
    TargetBoard := nil;
    exit;
  end;

  if Config.wrtTrimRight then //末尾整形
    Memo.Text := TrimRight(Memo.Text);

  if not PreWriteWarning then //警告関係
    exit;

  if (postType = postCheck) and Memo.Modified then
    postType := postNormal;

  writeRetryCount := 0;
  cookieRetryCount := 0;
  Result.Clear;

  PostArticle;

  Memo.Modified := false;

  //▼シフト押してたらリストに追加
  if GetKeyState(VK_SHIFT) < 0 then
    SaveNameMailToList;

  if Config.wrtRecordNameMail then //521 Name・Mailの記憶・最終書込
  begin
    TargetThread.UsedWriteName := NameComboBox.Text;
    TargetThread.UsedWriteMail := '!' + MailComboBox.Text;
    TargetThread.SaveIndexData;
  end;
end;

procedure TJLWritePanel.PasteAA;
begin
  inherited;

  if AAComboDropdown and (AAComboBox.ItemIndex > -1) then
  begin
    PasteAAListItem;
    AAComboDropDown := False;
    if MainPageControl.ActivePageIndex = TABSHEET_PREVIEW then
    begin
      CreatePreView;
      try PreView.SetFocus; except end;
    end else
      try Memo.SetFocus; except end;
  end;

end;

procedure TJLWritePanel.ToolButtonHandle(Sender: TToolButton; tag: integer);
var
  SaveDialog: TSaveDialog;
  OpenDialog: TOpenDialog;
begin
  inherited;

  Case tag of

    0: //SaveToFile
      begin
        SaveDialog := TSaveDialog.Create(Self);
        SaveDialog.Filter := 'テキストファイル(*.txt)|*.txt|すべてのファイル|*';
        if SaveDialog.Execute then
          Memo.Lines.SaveToFile(SaveDialog.FileName);
        SaveDialog.Free;
      end;
    1: //LoadFromFile
      begin
        OpenDialog := TOpenDialog.Create(Self);
        OpenDialog.Filter := 'テキストファイル(*.txt)|*.txt|すべてのファイル|*';
        if OpenDialog.Execute then
          Memo.Lines.LoadFromFile(OpenDialog.FileName);
        OpenDialog.Free;
      end;
    2: //Clear
      begin
        Memo.Clear;
        ChangeStatusBar;
        if MainPageControl.ActivePageIndex = TABSHEET_PREVIEW then
          CreatePreView;
      end;
    3: //RecordNameMail
      begin
        Config.wrtRecordNameMail := not Config.wrtRecordNameMail;
        Sender.Down := Config.wrtRecordNameMail;
        if Assigned(WriteForm) then
          //WriteForm.RecordCheckBox.Checked := Config.wrtRecordNameMail;
          WriteForm.ToolButtonRecordNameMail.Down := Config.wrtRecordNameMail;
      end;
    4: //TrimRight
      begin
        Config.wrtTrimRight := not Config.wrtTrimRight;
        Sender.Down := Config.wrtTrimRight;
        if Assigned(WriteForm) then
          WriteForm.ToolButtonTrim.Down := Config.wrtTrimRight;
      end;
    5: //WriteWait
      begin
        Config.wrtUseWriteWait := not Config.wrtUseWriteWait;
        Sender.Down := Config.wrtUseWriteWait;
      end;
    6: //NameMailWarning
      begin
        Config.wrtNameMailWarning := not Config.wrtNameMailWarning;
        Sender.Down := Config.wrtNameMailWarning;
        if Assigned(WriteForm) then
          WriteForm.ToolButtonNameWarn.Down := Config.wrtNameMailWarning;
      end;

  end; //Case
end;

procedure TJLWritePanel.ChangeStatusBar;
var
  tmpTxt: String;
  tmpColor: TColor;
  Lines: Integer;
  MsgCnt: Integer;
begin
  if not WStatusBar.Visible then
    Exit;

  Lines := Memo.Lines.Count;
  if (Memo.Text <> '') and (Memo.Text[Length(Memo.Text)] = #10) then
    Inc(Lines);

  tmpColor := Self.Color;
  if BBSLineNumuber > 0 then
    if Lines > BBSLineNumuber * 2 then
      tmpColor := $007f7fff
    else if Lines > BBSLineNumuber then
      tmpColor := $007fffff;
  PanelColor[1] := tmpColor;

  tmpTxt := Format('%4d',[Lines]);
  if BBSLineNumuber > 0 then
    WStatusBar.Panels[1].Text := Format('Lines: %4d/%4d',[Lines, BBSLineNumuber * 2])
  else
    WStatusBar.Panels[1].Text := Format('Lines: %4d/ 不明',[Lines]);

  MsgCnt := MessageCount(Memo.Text);

  if (BBSMessageCount > 0) and (MsgCnt > BBSMessageCount) then
    PanelColor[0] := $007f7fff
  else
    PanelColor[0] := clBtnFace;

  tmpTxt := Format('%4d',[Length(Memo.Text)]);
  if BBSMessageCount > 0 then
    WStatusBar.Panels[0].Text := Format('Bytes: %6d/%6d',[MsgCnt, BBSMessageCount])
  else
    WStatusBar.Panels[0].Text := Format('Bytes: %6d/  不明',[MsgCnt]);
end;


(* Imeを設定 *)
procedure TJLWritePanel.ChangeMemoIme;
begin
  inherited;

  if Config.optWriteMemoImeMode then
    Memo.ImeMode := imOpen
  else
    Memo.ImeMode := imClose;
end;

(* Imeを保存 *)
procedure TJLWritePanel.SaveMemoIme;
var
  imc: HIMC;
begin
  inherited;

  imc := ImmGetContext(Memo.Handle);
    Config.optWriteMemoImeMode := ImmGetOpenStatus(imc);
  ImmReleaseContext(Memo.Handle, imc);

  SetImeMode(MainWnd.Handle, imClose);
end;


//-------------------------- Helper Procedure -------------------------------//

function TJLWritePanel.Res2Dat: string;
  function HtmlPost(const S: string):string;
  begin
    Result := S;
    Result := AnsiReplaceStr(Result, '<', '&lt;');
    Result := AnsiReplaceStr(Result, '>', '&gt;');
    Result := AnsiReplaceStr(Result, #13#10, '<br>');
    Result := AnsiReplaceStr(Result, #13, '<br>');
    Result := AnsiReplaceStr(Result, #10, '<br>');
  end;
  function NameConv(const S: string):string;
  begin
    Result := HtmlPost(S);
    Result := AnsiReplaceStr(Result, '★', '☆');
    Result := AnsiReplaceStr(Result, '◆', '◇');
    if AnsiPos('#', Result) > 0 then
    begin
      Result := Copy(Result, 1, AnsiPos('#', Result) - 1) + '</b>'
        + Trip(Copy(Result,AnsiPos('#', Result) + 1, Length(Result))) + ' <b>';
    end;
    if AnsiPos('＃', Result) > 0 then
    begin
      Result := Copy(Result, 1, AnsiPos('＃', Result) - 1) + '</b>'
        + Trip(Copy(Result,AnsiPos('＃', Result) + 2, Length(Result))) + ' <b>';
    end;
    if not Config.tstAuthorizedAccess then
    begin
      Result := AnsiReplaceStr(Result, '●', '○');
    end;
    Result := AnsiReplaceStr(Result, '"', '&quot;');
  end;
  function MailConv(const S: string):string;
  begin
    Result := HtmlPost(S);
    if AnsiPos('#', Result) > 0 then
    begin
      Result := Copy(Result, 1, AnsiPos('#', Result) - 1);
    end;
    if AnsiPos('＃', Result) > 0 then
    begin
      Result := Copy(Result, 1, AnsiPos('＃', Result) - 1);
    end;
    Result := AnsiReplaceStr(Result, '"', '&quot;');
  end;
  function MessageConv(const S: string):string;
  begin
    Result := HtmlPost(S);
    Result := AnsiReplaceStr(Result, '"', '&quot;');
  end;
var
  aName, aMail, aDate, aMessage: string;
  p1, p2: PChar;
  tmp: String; //beginner
begin
  if NameComboBox.Text <> '' then
  begin
    if (FBoard <> nil) and (FBoard.GetBBSType = bbs2ch) then
      aName := StringReplace(NameComboBox.Text, '&r', '', [rfReplaceAll])
    else
      aName := NameComboBox.Text;
  end else
    aName := SettingTxt.Lines.Values['BBS_NONAME_NAME'];

  aMail := MailComboBox.Text;
  aDate := FormatDateTime('yy/mm/dd hh:nn:mm', Now);
  if SameText(SettingTxt.Lines.Values['BBS_FORCE_ID'], 'checked') then
    aDate := aDate + ' ID:xxxxxxxxxx'
  else if (SettingTxt.Lines.Values['BBS_NO_ID'] = '') or
          SameText(SettingTxt.Lines.Values['ID_DISP'], 'show') then
    if Length(aMail) = 0 then
      aDate := aDate + ' ID:xxxxxxxxxx'
    else
      aDate := aDate + ' ID:???';

  aMessage := Memo.Text;

  aName := NameConv(aName);
  aMail := MailConv(aMail);
  aMessage := MessageConv(aMessage);

  if Length(aName) = 0 then
    aName := '<b>名無しさん</b>';

  Result := aName + '<>'
          + aMail + '<>'
          + aDate + '<>'
          + aMessage + '<>' + #10;

  //Unicode置換板の処理
  if SameText(SettingTxt.Lines.Values['BBS_UNICODE'], 'change') then
  begin
    p1 := PChar(Result);
    SetLength(tmp, Length(Result));
    p2 := PChar(tmp);
    while True do
    begin
      if (p1^ = '&') and ((p1 + 1)^ ='#') then
      begin
        p2^ := #$81;
        inc(p2);
        p2^ := #$48;
        inc(p2);
        inc(p1, 2);
        while p1^ in ['0'..'9'] do
          inc(p1);
        if p1^ = ';' then
          inc(p1);
      end else
      begin
        if p1^ in LeadBytes then
        begin
          p2^ := p1^;
          inc(p1);
          inc(p2);
          p2^ := p1^;
          inc(p1);
          inc(p2);
        end else
        begin
          p2^ := p1^;
          if p1^ = #10 then
            Break;
          inc(p1);
          inc(p2);
        end;
      end;
    end;
    Result := copy(tmp, 1, p2 - PChar(tmp) + 1);
  end;
end;


class function TJLWritePanel.Trip(const Key: string): string;
{----------------------------------
$salt = substr($key."H.", 1, 2);//<--ぁゃιぃ
$salt =~ s/[^\.-z]/\./go;
$salt =~ tr/:;<=>?@[\\]^_`/ABCDEFGabcdef/;
-----------------------------------}
  function MakeSalt(const Key: string): string;
  var
    i: Integer;
  begin
    Result := Copy(Copy(Key, 2, 2) + 'H.', 1, 2);

    for i:=1 to Length(Result) do
    begin
      if ( Ord(Result[i]) < Ord('.') ) or ( Ord('z') < Ord(Result[i]) ) then
        Result[i] := '.';

      if ((Ord(':') <= Ord(Result[i])) and (Ord(Result[i]) <= Ord('@'))) then
        Result[i] := Char(Ord(Result[i]) - Ord(':') + Ord('A'))
      else if ((Ord('[') <= Ord(Result[i])) and (Ord(Result[i]) <= Ord('`'))) then
        Result[i] := Char(Ord(Result[i]) - Ord('[') + Ord('a'));
    end;
  end;
var
  Salt: string;
begin
  if Key = '' then
  begin
    Result := '#';
  end else
  begin
    Salt := MakeSalt(Key);
    Result := ' ◆' + Copy(crypt(Key, Salt), 4, 10);
  end;
end;

procedure TJLWritePanel.PasteAAListItem;
var
  text: string;
  index: integer;
begin
  text := AAComboBox.Items[AAComboBox.ItemIndex];
  if StartWith('*', text, 1) then
  begin
    index := 0;
    while(CompareStr('[' + Copy(text, 2, Length(text) - 1) + ']',
                                               Config.aaAAList[index]) <> 0) do
    begin
      Inc(index);
      if Config.aaAAList.Count - 1 <= index then
        exit;
    end;
    Inc(index);
    while not (StartWith('[', Config.aaAAList[index], 1)) do
    begin
      Memo.SelText := Config.aaAAList[index] + #13#10;
      if index < Config.aaAAList.Count - 1 then
        Inc(index)
      else
        break;
    end;
  end else
    Memo.SelText := text;
end;


procedure TJLWritePanel.UnableWrite;
begin
  BBSLineNumuber := 0;
  BBSMessageCount := 0;
  BBSSubjectCount := 0;
  BBSNameCount := 0;
  BBSMailCount := 0;
  SettingTxt.Clear;
  ChangeStatusBar;
end;

procedure TJLWritePanel.EnableWrite;
begin
end;

procedure TJLWritePanel.SetBoard(ABoard: TBoard);
begin
  if (ABoard <> nil) and (ABoard <> FBoard) then
  begin
    FBoard := ABoard;
    {$IFDEF WRITEPANELDEBUG}
    Main.Log('SettingTxt:ChangeBoard:' + FBoard.name);
    {$ENDIF}
    SetSettingTxt;
    SetNameBox;
  end;
end;

procedure TJLWritePanel.SetNameBox;
var
  i: Integer;
  tkBoard, tkName: string;
begin
  NameComboBox.ItemsEx.Clear;
  for i := 0 to Config.wrtNameList.Count - 1 do
  begin
    if (Config.wrtNameList[i] <> '') and (Config.wrtNameList[i][1] = '<')
            and (AnsiPos('>', Config.wrtNameList[i]) <> 0) then
    begin
      tkBoard := Copy(Config.wrtNameList[i], 2, AnsiPos('>', Config.wrtNameList[i]) - 2);
      tkName := Copy(Config.wrtNameList[i], AnsiPos('>', Config.wrtNameList[i]) + 1, Length(Config.wrtNameList[i]) - AnsiPos('>', Config.wrtNameList[i]));
    end else
    begin
      tkBoard := '*';
      tkName := Config.wrtNameList[i];
    end;

    if (tkBoard = FBoard.bbs) or (tkBoard = '*') then
      if NameComboBox.Items.IndexOf(tkName) < 0 then
        NameComboBox.Items.Add(tkName);
  end;
end;

procedure TJLWritePanel.SetMailBox;
begin
  MailComboBox.Items := Config.wrtMailList;
end;

procedure TJLWritePanel.SetNameMail;
begin
  //名前
  if FThread.UsedWriteMail <> '' then
    NameComboBox.Text := FThread.UsedWriteName
  else if (FThread.UsedWriteMail = '') and // 記憶されてないスレ(記憶されたスレには必ず!が入る)
          Config.wrtUseDefaultName and (NameComboBox.Items.Count > 0) then
    NameComboBox.Text := NameComboBox.Items[0]
  else if FBoard.bbs = 'morningcoffee' then
    NameComboBox.Text := '名無し募集中。。。'
  else
    NameComboBox.Text := SettingTxt.Lines.Values['BBS_NONAME_NAME'];

  //メール
  SageCheckBox.Checked := false;

  if FThread.UsedWriteMail <> '' then
    MailComboBox.Text := FThread.UsedWriteMail
  else if Config.wrtDefaultSageCheck then
    MailComboBox.Text := 'sage'
  else
    MailComboBox.Text := '';

  if AnsiStartsStr('!',MailComboBox.Text) then
    MailComboBox.Text := Copy(MailComboBox.Text, 2, length(MailComboBox.Text) - 1);
end;

procedure TJLWritePanel.SaveNameMailToList;
  function TagExist(const s: string):Boolean;
  begin
    if (s<>'') and (s[1]='<') and (AnsiPos('>', s)<>0) then
      Result := True
    else
      Result := False;
  end;

var
  BoardName: string;
begin
  if NameComboBox.Text <> '' then
  begin
    if GetKeyState(VK_CONTROL) < 0 then
      BoardName := '<'+ FBoard.bbs + '>' + NameComboBox.Text
    else if TagExist(NameComboBox.Text) then
      BoardName := '<*>' + NameComboBox.Text
    else
      BoardName := NameComboBox.Text;

    if Config.wrtNameList.IndexOf(BoardName) < 0 then
    begin
      Config.wrtNameList.Add(BoardName);
      SetNameBox;
    end;
  end;

  if MailComboBox.Text <> '' then
  begin
    if not SageCheckBox.Checked and (Config.wrtMailList.IndexOf(MailComboBox.Text) < 0) then
    begin
      Config.wrtMailList.Add(MailComboBox.Text);
      SetMailBox;
    end;
  end;

  if (NameComboBox.Text <> '') or (MailComboBox.Text <> '') then
    Config.Modified := true;

end;

procedure TJLWritePanel.SaveKakikomi;
var
  kakikomistr: TStringList;
begin
  if not FileExists(Config.BasePath + 'kakikomi.txt') then
  try
    FileClose(FileCreate(Config.BasePath + 'kakikomi.txt'));
  except
  end;
  if kakikomiFile = nil then
  try
    kakikomiFile := TFileStream.Create(Config.BasePath + 'kakikomi.txt',
                             fmOpenReadWrite or fmShareDenyWrite);
  except
  end;

  kakikomistr := TStringList.Create;
  try
    kakikomistr.Add('--------------------------------------------');
    kakikomistr.Add('Date   : ' + DateToStr(Date) + ' ' + TimeToStr(Time));
    kakikomistr.Add('Subject: ' + FThread.title);
    kakikomistr.Add('URL    : ' + FThread.ToURL(false));
    kakikomistr.Add('FROM   : ' + NameComboBox.Text);
    kakikomistr.Add('MAIL   : ' + MailComboBox.Text);
    kakikomistr.Add('');
    kakikomistr.AddStrings(Memo.Lines);
    kakikomistr.Add('');
    kakikomistr.Add('');

    kakikomiFile.Seek(0, soFromEnd);
    kakikomiFile.Write(PChar(kakikomistr.Text)^, length(kakikomistr.Text));
  finally
    kakikomistr.Free;
  end;
end;

function TJLWritePanel.PreWriteWarning: Boolean;
var
  WarningList: TStringList;
  Lines: Integer;
begin
  Result := False;

  WarningList := nil;
  try
    WarningList := TStringList.Create;
    if TargetBoard.bbs = 'morningcoffee' then
    begin
      if Config.wrtNameMailWarning and (NameComboBox.Text <> MORNINGCOFFEE_NAME) then
        WarningList.Add('コテハンで書き込みます。');
    end else
    begin
      if NameComboBox.Text = '' then
      begin
        if pos('fusianasan', SettingTxt.Lines.Values['BBS_NONAME_NAME']) > 0 then
          WarningList.Add('この板のデフォルトの名無しはfusianasan(IP表示)です。')
        else if SettingTxt.Lines.Values['NANASHI_CHECK'] = '1' then
          WarningList.Add('名前強制入力の板です。');
      end
      else if Config.wrtNameMailWarning
             and (NameComboBox.Text <> SettingTxt.Lines.Values['BBS_NONAME_NAME']) then
        WarningList.Add('コテハンで書き込みます。');
    end;


    if Config.wrtNameMailWarning and (MailComboBox.Text <> '')
            and  (MailComboBox.Text <> 'sage') then
      WarningList.Add('メール欄にsage以外の内容が含まれています。');

    if MessageCount(NameComboBox.Text) > BBSNameCount then
      WarningList.Add('名前欄が長すぎです。');
    if MessageCount(MailComboBox.Text) > BBSMailCount then
      WarningList.Add('メール欄が長すぎです。');

    if Length(Memo.Text) <= 0 then
      WarningList.Add('メッセージが空です。')
    else if (BBSMessageCount > 0) and (MessageCount(Memo.Text) > BBSMessageCount) then
      WarningList.Add('メッセージが長すぎです。');

    Lines := Memo.Lines.Count;
    if (Memo.Text <> '') and (Memo.Text[Length(Memo.Text)] = #10) then
      Inc(Lines);
    if (BBSLineNumuber > 0) and (Lines > BBSLineNumuber * 2) then
      WarningList.Add('改行が多すぎです。');

    if WarningList.Count > 0 then
    begin
      WarningList.Add('');
      WarningList.Add('書き込みますか？');
      // MessageDlgだと最前面フォームに隠れてしまう
      if MessageBox(self.Handle, PChar(WarningList.Text), '警告', MB_ICONEXCLAMATION or MB_OKCANCEL) <> IDOK then
        Exit;
    end;
  finally
    WarningList.Free;
  end;
  Result := True;
end;

procedure TJLWritePanel.PostArticle;
var
  URI: string;
  encName, encMail: string;
  postDat: string;
  URIObj: TIdURI;
  referer: string;
  list: TStringList;
  cookie: string;
begin
  if TargetBoard.timeValue <= 0 then
    TargetBoard.timeValue := timeValue; //起動時刻
  case TargetBoard.GetBBSType of
  bbs2ch, bbsOther:
    begin
      if (NameComboBox.Text = '') and (TargetBoard.bbs = 'morningcoffee') then
        encName := URLEncode(MORNINGCOFFEE_NAME)
      else
        encName := URLEncode(NameComboBox.Text);
      encMail := URLEncode(MailComboBox.Text);
      case postType of
      postNormal:
        begin
          URI := 'http://' + TargetBoard.host + '/test/bbs.cgi';
          postDat := 'submit=' + URLEncode('書き込む')
                       + '&FROM=' + encName
                       + '&mail=' + encMail
                       + '&MESSAGE=' + URLEncode(Memo.Text)
                       + '&bbs='  + TargetBoard.bbs
                       + '&key='  + ChangeFileExt(TargetThread.datName, '')
                       + '&time=' + IntToStr(board.timeValue);
        end;
      postCheck:
        begin
          URI := 'http://' + TargetBoard.host + '/test/subbbs.cgi';
          postDat := 'bbs='  + TargetBoard.bbs
                       + '&key='  + ChangeFileExt(TargetThread.datName, '')
                       + '&time=' + IntToStr(TargetBoard.timeValue)
                       + '&subject='
                       + '&FROM=' + encName
                       + '&mail=' + encMail
                       + '&MESSAGE=' + URLEncode(Memo.Text)
                       + '&code='  + postCode
                       + '&submit=' + URLEncode('全責任を負うことを承諾して書き込む');
        end;
      end; //case
      postDat := postDat + ticket2ch.GetSID(URI, '&');
    end;
  bbsJBBSShitaraba:
    begin
      encName := URLEncode(sjis2euc(NameComboBox.Text));
      encMail := URLEncode(sjis2euc(MailComboBox.Text));
      //▼ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      // したらばのURL対応を少し汎用的に
      URI := 'http://' + Config.bbsJBBSServers[0] + '/bbs/write.cgi';
      //▲ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(sjis2euc(Memo.Text))
                   + '&DIR=' + GetJBBSShitarabaCategory(TargetBoard.host)
                   + '&BBS='  + TargetBoard.bbs
                   + '&KEY='  + ChangeFileExt(TargetThread.datName, '')
                   + '&TIME=' + IntToStr(UTC);
    end;
  bbsMachi, bbsJBBS:
    begin
      encName := URLEncode(NameComboBox.Text);
      encMail := URLEncode(MailComboBox.Text);
      URI := 'http://' + board.host + '/bbs/write.cgi';
      postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(Memo.Text)
                   + '&BBS='  + TargetBoard.bbs
                   + '&KEY='  + ChangeFileExt(TargetThread.datName, '')
                   + '&TIME=' + IntToStr(UTC);
    end;
  end; //case

  URIObj := nil;
  try
    URIObj := TIdURI.Create(TargetBoard.GetURIBase + '/');
    referer := URIObj.URI;
  finally
    URIObj.Free;
  end;
  cookie := 'Cookie: NAME=' + encName + '; MAIL=' + encMail;
  list := TStringList.Create;
  if (TargetBoard.GetBBSType = bbs2ch) and (0 < length(Config.tstWrtCookie)) then
    cookie := cookie + '; ' + Config.tstWrtCookie;
  list.Add(cookie);
  procPost := Main.AsyncManager.Post(URI, postDat, referer, list,
                                     OnWritten, OnNotify);
  if procPost <> nil then
  begin
    MainWnd.PauseToggleAutoReSc(false);
    WriteButton.Enabled := false;
    UWriteForm.SetButtonWriteEnabled(false);
    writing := True;
    if Config.wrtUseWriteWait then
      WaitTimerStart;
    Result.Lines.Add('--------------------');
    Result.Lines.Add('書込み中・・・');
    Result.Lines.Add('--------------------');
    ChangeMainPageControlActiveTab(TABSHEET_RESULT);
  end;
  list.Free;
end;

procedure TJLWritePanel.OnNotify(sender: TAsyncReq; code: TAsyncNotifyCode);
begin
  case code of
  ancPRECONNECT:
    begin
      ticket2ch.On2chPreConnect(sender, code);
      sender.IdHTTP.AllowCookies := True;
    end;
  ancPRETERMINATE:
    if procPost = sender then
      Windows.Sleep(1000); (* 少しぐらい待たせてみるテスト *)
  end;
end;

procedure TJLWritePanel.OnWritten(sender: TAsyncReq);
var
  responseHTML: string;

  function GetErrMsg: string;
  var
    errPos, limit: integer;
  begin
    result := '';
    if responseHTML = '' then
      exit;
    limit := FindPosIC('<head>', responseHTML, 1);
    if limit >=0 then
    begin
      errPos := FindPosIC('2ch_X:', responseHTML, 1, limit);
      if errPos >= 0 then
      begin
        errPos := errPos + 6;
        limit := FindPos('-->', responseHTML, errPos, limit);
        result := trim(copy(responseHTML, errPos, limit - errPos));
      end;
    end;
  end;

  procedure SetPostCode;
  var
    codePos: integer;
  begin
    if responseHTML = '' then
      exit;
    codePos := FindPos('code value=', responseHTML, 0);
    if codePos >= 0 then
    begin
      codePos := codePos + 11;
      //▼ちょっと強引なcode取得
      postCode := copy(responseHTML, codePos, FindPos('>', responseHTML, codepos) - codePos);
    end;
    postType := postCheck;
    Result.Lines.Add('--------------------');
    Result.Lines.Add('確認したらもう一度「書き込む」を押してください・・・');
    Result.Lines.Add('--------------------');
  end;

var
  i: integer;
  viewItem: TViewItem;
  responseText: string;
  list: TStringList;
  errMsg: string;
  tempTime: integer;
begin
  if procPost <> sender then
    exit;
  procPost := nil;
  writing := False;
  if Config.tstCommHeaders then
  begin
    Log('--------------------');
    Log(sender.IdHTTP.ResponseText);
    Log('--------------------');
  end;

  tempTime := DateTimeToUnix(Str2DateTime(sender.GetDate));
  if TargetBoard.timeValue > tempTime then
    TargetBoard.timeValue := tempTime
  else
    Inc(TargetBoard.timeValue); //古いbbs.cgiで2重カキコループにならないように

  responseHTML := sender.GetString;
  responseText := HTML2String(responseHTML);

  ChangeMainPageControlActiveTab(TABSHEET_RESULT);

  if (sender.IdHTTP.ResponseCode = 200) then
  begin
    list := TStringList.Create;
    list.Text := responseText;
    for i := 0 to list.Count -1 do
      Result.Lines.Add(list.Strings[i]);
    if (2 <= list.Count) and
       AnsiStartsStr('ＥＲＲＯＲ！', list[0]) and
       AnsiStartsStr('再度ログインしてね。。。', list[1]) and
       (writeRetryCount < 1) then
    begin
      list.Free;
      Inc(writeRetryCount);
      ticket2ch.Reset;
      Result.Lines.Add('--------------------');
      Result.Lines.Add('ログインから再試行中・・・');
      Result.Lines.Add('--------------------');
      PostArticle;
      exit;
    end;

    errMsg := GetErrMsg;
    if (errMsg = 'error') then
    begin
      list.Free;
      WaitTimerStop;
      MainWnd.PauseToggleAutoReSc(true);
      exit;
    end;
    if ((errMsg = 'cookie') or
        ((2 <= list.Count) and AnsiContainsStr(list[0], 'クッキー確認！'))) and
       (cookieRetryCount < 1) then
    begin
      list.Free;
      Inc(cookieRetryCount);
      Config.tstWrtCookie := '';
      with sender.IdHTTP.CookieManager.CookieCollection do
        for i := 0 to Count -1 do
          if (Items[i].CookieName <> 'NAME') and (Items[i].CookieName <> 'MAIL') then
            Config.tstWrtCookie := Config.tstWrtCookie + Items[i].ClientCookie + '; ';
      Config.Modified := True;
      PostArticle;
      exit;
    end;

    if (errMsg = 'check') or
       ((2 <= list.Count) and AnsiContainsStr(list[1], '書き込み確認')) then
    begin
      list.Free;
      SetPostCode;
      MainWnd.PauseToggleAutoReSc(true);
      WaitTimerStop;
      exit;
    end;

    if not (((errMsg <> '') and ((errMsg = 'true') or (errMsg = 'false'))) or
            ((errMsg =  '') and (list.Count > 0) and
                                 (AnsiContainsStr(list[0], '書きこみました') or
                                  AnsiContainsStr(list[0], '書き込みました'))))then
    begin
      list.Free;
      WaitTimerStop;
      MainWnd.PauseToggleAutoReSc(true);
      exit;
    end;
    list.Free;
  end
  else  if (sender.IdHTTP.ResponseCode = 302) then //▼おそらく外部板での成功
  begin
    Result.Lines.Add('書き込めたかも・・・');
    Result.Lines.Add('--------------------');
    Log('川；’ー’）ﾀﾌﾞﾝｶｷｺﾒﾀﾝﾔﾖ･･･');
  end
  else begin
    Result.Lines.Add('書込みに失敗した模様');
    Result.Lines.Add('--------------------');
    Result.Lines.Add(sender.IdHTTP.ResponseText);
    Result.Lines.Add('--------------------');
    WaitTimerStop;
    MainWnd.PauseToggleAutoReSc(true);
    exit;
  end;

  //以降書き込み成功時

  TargetBoard.timeValue := tempTime;

  if TargetThread <> nil then
  begin
    TargetThread.LastWrote := DateTimeToUnix(Now);
    TargetThread.SaveIndexData;

    //▼書き込み履歴保存
    if Config.wrtRecordWriting then
      SaveKakikomi;

    viewItem := viewList.FindViewItem(TargetThread);
    if viewItem <> nil then
      viewItem.NewRequest(TargetThread, gotCHECK, -1, True, Config.oprCheckNewWRedraw);
  end;

  if errMsg = 'false' then
  begin
    Caption := '注意が出ています';
    WaitTimerStop;
    MainWnd.PauseToggleAutoReSc(true);
    exit;
  end;

  Memo.Clear;
  ChangeStatusBar;
  WriteButton.Enabled := not WaitTimer.Enabled;
  UWriteForm.SetButtonWriteEnabled(WriteButton.Enabled);

  MainWnd.PauseToggleAutoReSc(true);
  ChangeMainPageControlActiveTab(TABSHEET_WRITE);
end;


procedure TJLWritePanel.WaitTimerStart;
var
  domainname: string;
  text: string;
  i: Integer;
begin
  domainname := TargetThread.GetHost;
  hostname := LeftStr(domainname, AnsiPos('.', domainname) - 1);
  waittime := -1;

  for i := 0 to WaitList.Count - 1 do
    if 0 < AnsiPos(hostname, WaitList.Strings[i]) then begin
      text := WaitList.Strings[i];
      waittime := StrToInt(RightStr(text, Length(text) - AnsiPos('=', text)));
      break;
    end;

  if waittime > 0 then
  begin
    WaitTimer.Enabled := true;
    Log('書き込み待機 - ' + hostname);
    MainWnd.TabControl.Refresh;
    WriteButton.Caption := WRITE_BUTTON_CAPTION_B + IntToStr(waittime) + WRITE_BUTTON_CAPTION_C;
  end;
end;

procedure TJLWritePanel.WaitTimerStop;
begin
  if WaitTimer.Enabled then
  begin
    waittime := -1;
    WaitTimer.Enabled := false;
    MainWnd.TabControl.Refresh;
  end;

  WriteButton.Enabled := not writing;
  UWriteForm.SetButtonWriteEnabled(WriteButton.Enabled);
  WriteButton.Caption := WRITE_BUTTON_CAPTION_A;
end;

procedure TJLWritePanel.WaitTimerTimer(Sender: TObject);
begin

  waittime := waittime - 1;

  if FThread = nil then
  begin
    if waittime = 0 then
      WaitTimer.Enabled := false;
    exit;
  end;

  if(0 < AnsiPos(hostname, FThread.GetHost)) then
  begin
    WriteButton.Enabled := false;
    UWriteForm.SetButtonWriteEnabled(false);
    WriteButton.Caption := WRITE_BUTTON_CAPTION_B + IntToStr(waittime) + WRITE_BUTTON_CAPTION_C;
  end;

  if waittime = 0 then
  begin
    WriteButton.Enabled := not writing;
    UWriteForm.SetButtonWriteEnabled(WriteButton.Enabled);
    WriteButton.Caption := WRITE_BUTTON_CAPTION_A;
    WaitTimer.Enabled := false;
    MainWnd.TabControl.Refresh;
  end;
end;



//------------------- public Procedure --------------------------------------//

procedure TJLWritePanel.SetUp(AParent: TWinControl);
begin
  inherited SetUp(AParent);

  FParent2 := AParent;   //Dockingに使う
  FloatLeft := 100;
  FloatTop := 200;

  Align := alClient;
  Height := 180;

  ChangeStatusBar;
  procPost := nil;
  postType := postNormal;
  postCode := '';

  ToolButton[3].Down := Config.wrtRecordNameMail;
  ToolButton[4].Down := Config.wrtTrimRight;
  ToolButton[5].Down := Config.wrtUseWriteWait;
  ToolButton[6].Down := Config.wrtNameMailWarning;

  ChangeWriteMemoColor;
  ChangeWriteMemoFont;

  AAComboDropDown := False;

  with PreView do
  begin
    Font.Name := 'ＭＳ Ｐゴシック';
    Move(Config.viewTextAttrib, TextAttrib, SizeOf(TextAttrib));
    OnMouseMove :=  MainWnd.OnBrowserMouseMove;
    OnMouseDown :=  MainWnd.OnBrowserMouseDown;
    OnMouseHover := MainWnd.OnBrowserMouseHover;
  end;
  ChangePreViewStyle;
  
  PreViewItem.PopUpViewList := popupviewList;

  try
    WaitList.LoadFromFile(Config.BasePath + WAIT_LIST_FILE);
  except
    WaitList.Clear;
  end;
end;

procedure TJLWritePanel.SetToolBarImageList(AImageList: TImageList);
begin
  ToolBar.Images := AImageList;
end;

procedure TJLWritePanel.SetThread(AThread: TThreadItem);
begin
  if AThread = nil then
  begin
    FThread := nil;
    FBoard := nil;
    {$IFDEF WRITEPANELDEBUG}
    Main.Log('SettingTxt:NoThread');
    WStatusBar.Panels[2].Text := '';
    {$ENDIF}
    UnableWrite;
  end
  else if AThread <> FThread then
  begin
    FThread := AThread;
    {$IFDEF WRITEPANELDEBUG}
    Main.Log('SettingTxt:ChangeThread:' + HTML2String(FThread.title));
    WStatusBar.Panels[2].Text := HTML2String(FThread.title);
    {$ENDIF}
    SetBoard(TBoard(FThread.board));
    SetNameMail;
    EnableWrite;
  end;

  if MainPageControl.ActivePageIndex = TABSHEET_PREVIEW then
    CreatePreView;

  if MailComboBox.Text = 'sage' then
  begin
    MailComboBox.Enabled := false;
    SageCheckBox.Checked := true;
  end
  else begin
    MailComboBox.Enabled := true;
    SageCheckBox.Checked := false;
  end;

  if WaitTimer.Enabled and (FThread <> nil)
      and (0 < AnsiPos(hostname, FThread.GetHost)) then begin
    WriteButton.Enabled := false;
    WriteButton.Caption := WRITE_BUTTON_CAPTION_B + IntToStr(waittime)
                         + WRITE_BUTTON_CAPTION_C;
  end else begin
    WriteButton.Enabled := not writing and (FThread <> nil)
                           and (FThread.state = tsCurrency)
                           and ((0 < FThread.number) or ThreadIsNew(FThread));
    WriteButton.Caption := WRITE_BUTTON_CAPTION_A;
  end;
end;

procedure TJLWritePanel.SetSettingTxt;
begin
  {$IFDEF WRITEPANELDEBUG}
  Main.Log('SettingTxt:UpdateSettingTxt:' + FThread.title);
  {$ENDIF}
  SettingTxt.Lines := FBoard.settingText;
  BBSLineNumuber := FBoard.BBSLineNumuber;
  BBSMessageCount := FBoard.BBSMessageCount;
  BBSSubjectCount := FBoard.BBSSubjectCount;
  BBSNameCount := FBoard.BBSNameCount;
  BBSMailCount := FBoard.BBSMailCount;
  ChangeStatusBar;
end;

procedure TJLWritePanel.SetAAList;
var
  index: integer;
begin
  index := 0;

  AAComboBox.Items.Clear;

  if Config.aaAAList.Count <= 0 then
  begin
    AAComboBox.Enabled := false;
    MainWnd.MenuAA.Enabled := false;
    MainWnd.MenuAA.Visible := false;
    exit;
  end;

  while (CompareStr('[aalist]', Config.aaAAList.Strings[index]) <> 0) do
  begin
    Inc(index);
    if Config.aaAAList.Count - 1 <= index then
    begin
      AAComboBox.Enabled := false;
      MainWnd.MenuAA.Enabled := false;
      MainWnd.MenuAA.Visible := false;
      exit;
    end;
  end;

  Inc(index);
  while not(StartWith('[', Config.aaAAList.Strings[index], 1)) do
  begin
    AAComboBox.Items.Add(Config.aaAAList.Strings[index]);
    if index < Config.aaAAList.Count - 1 then
      Inc(index)
    else
      break;
  end;
  if AAComboBox.items.Count > 0 then
  begin
    AAComboBox.Enabled := True;
    MainWnd.MenuAA.Enabled := True;
    MainWnd.MenuAA.Visible := True;
  end;
end;

procedure TJLWritePanel.ChangeEnableWrite(AEnabled: Boolean);
begin
  WriteButton.Enabled := AEnabled;
end;

procedure TJLWritePanel.SetMemoText(AText: String);
begin
  Memo.SelText := AText;

  if MainPageControl.ActivePageIndex = TABSHEET_PREVIEW then
    CreatePreView;
end;

procedure TJLWritePanel.ChangeWriteMemoColor;
begin
  if Memo.Color <> Config.wrtWritePanelColor then
    Memo.Color := Config.wrtWritePanelColor;
end;

procedure TJLWritePanel.ChangeWriteMemoFont;
var
  font: TFont;
begin
  if Config.viewMemoFontInfo.face <> '' then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewMemoFontInfo);
    Memo.Font.Assign(font);
    font.Free;
  end;
end;

procedure TJLWritePanel.ChangePreViewStyle;
begin
  with PreView do
  begin
    VerticalCaretMargin := Config.viewVerticalCaretMargin;
    WheelPageScroll := Config.viewPageScroll;
    VScrollLines := Config.viewScrollLines;
    EnableAutoScroll := Config.viewEnableAutoScroll;
    Frames := Config.viewScrollSmoothness;
    FrameRate := Config.viewScrollFrameRate;
    Color := Config.clViewColor;  //スレビューと同じ色
    ConfCaretVisible := Config.viewCaretVisible;
  end;

  if MainPageControl.ActivePageIndex = TABSHEET_PREVIEW then
    CreatePreView;
end;

function TJLWritePanel.WriteWait: Boolean;
begin
  Result := WaitTimer.Enabled;
end;

procedure TJLWritePanel.SetRecordNameMailCheckBox(ABool: Boolean);
begin
  ToolButton[3].Down := ABool;
end;

procedure TJLWritePanel.SetTrimRightCheckBox(ABool: Boolean);
begin
  ToolButton[4].Down := ABool;
end;

procedure TJLWritePanel.SetFocusToMemo;
begin
  try Memo.SetFocus; except end;
end;

procedure TJLWritePanel.SetWriteButtonEnabled(ABool: Boolean);
begin
  WriteButton.Enabled := ABool;
end;

procedure TJLWritePanel.ChangeMainPageControlActiveTab(newTab: integer);
begin
  inherited;
end;

procedure TJLWritePanel.SetNameMailWarning(ABool: Boolean);
begin
  ToolButton[6].Down := ABool;
end;

(* ----------------------- TJLWritePanel ----------------------------------- *)
(* ------------------------------------------------------------------------- *)
(* ------------------------------------------------------------------------- *)
(* ------------------------------------------------------------------------- *)


//-------------------------- Util Func --------------------------------------//
procedure CreateWriteMemo(AOwner: TComponent; AParent: TWinControl;
  AImageList: TImageList);
begin
  WriteMemo := TJLWritePanel.Create(AOwner);
  WriteMemo.SetUp(AParent);
  WriteMemo.SetToolBarImageList(AImageList);
  WriteMemo.SetAAList;
end;

procedure ChangeWriteMemoThread(AThread: TThreadItem);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetThread(AThread);
end;

//板のSETTING.TXTをとりに行った後WriteMemoにセットされているBoardが
//変わっていなければWriteMemoのSETTING.TXTを新しいのにかえる
procedure ChangeWriteMemoSettingText(ABoard: TBoard);
begin
  if not Assigned(WriteMemo) then exit;

  if WriteMemo.board = ABoard then
    WriteMemo.SetSettingTxt;
end;

procedure ChangeWirteButtonEnabled(AEnabled: Boolean);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.ChangeEnableWrite(AEnabled);
end;

procedure ChangeWriteMemoText(AText: String);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetMemoText(AText);
end;

procedure UpdateAAComboBox;
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetAAList;
end;

procedure ChangeWriteMemoStyle;
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.ChangeWriteMemoColor;
  WriteMemo.ChangeWriteMemoFont;
  WriteMemo.ChangePreViewStyle;
end;

function CheckWriteWait(hostname: String): Boolean;
begin
  Result := False;
  if not Assigned(WriteMemo) then exit;

  Result := WriteMemo.WriteWait and (0 < Pos(WriteMemo.waithost, hostname));
end;

procedure SetNameBox;
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetNameBox;
end;

procedure SetMailBox;
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetMailBox;
end;

procedure SetRecordNameMailCheckBox(ABool: Boolean);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetRecordNameMailCheckBox(ABool);
end;

procedure SetTrimRightCheckBox(ABool: Boolean);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetTrimRightCheckBox(ABool);
end;

procedure SetFocusToWriteMemo;
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetFocusToMemo;
end;

procedure SetWriteButtonEnabled(ABool: Boolean);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetWriteButtonEnabled(ABool);
end;

procedure ChangeMainPageControlActiveTab(newTab: integer);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.ChangeMainPageControlActiveTab(newTab);
end;

procedure SetNameMailWarning(AValue: Boolean);
begin
  if not Assigned(WriteMemo) then exit;

  WriteMemo.SetNameMailWarning(AValue);
end;


end.

