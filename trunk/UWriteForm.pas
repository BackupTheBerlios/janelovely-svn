unit UWriteForm;
(* 書き込み画面 *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.109, 2004/09/28 13:39:43 *)

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  ComCtrls,
  StdCtrls,
  DateUtils,
  ActnList,
  Menus,
  HogeTextView,
  UTVSub,
  StrUtils,
  IniFiles,
  U2chThread,
  U2chBoard,
  HTTPSub,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  IdURI,
  JConfig,
  UDat2HTML,
  UViewItem,
  UAsync,
  UXTime,
  U2chTicket,
  ULocalCopy,
  StrSub,
  UCrypt,
  jconvert, ToolWin, JLXPComCtrls;

type
  TPostType = (postNormal, postCheck);
  TFormType = (formWrite, formBuild);

  TWriteForm = class(TForm)
    PageControl: TPageControl;
    TabSheetMain: TTabSheet;
    Panel1: TPanel;
    TabSheetLocalRule: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    CheckBoxSage: TCheckBox;
    Memo: TMemo;
    Panel2: TPanel;
    Panel3: TPanel;
    ButtonWrite: TButton;
    ButtonCancel: TButton;
    TabSheetResult: TTabSheet;
    Result: TMemo;
    ThreadTitlePanel: TPanel;
    CheckBoxTop: TCheckBox;
    EditSubjectBox: TEdit;
    TitleLabel: TLabel;
    SubjectPanel: TPanel;
    Panel4: TPanel;
    TabSheetPreview: TTabSheet;
    ActionList: TActionList;
    writeActWrite: TAction;
    writeActCancel: TAction;
    writeActFocusThread: TAction;
    AAList: TListBox;
    writeActShowAAList: TAction;
    TabSheetSettingTxt: TTabSheet;
    SettingTxt: TMemo;
    WStatusBar: TJLXPStatusBar;
    EditNameBox: TComboBoxEx;
    EditMailBox: TComboBoxEx;
    ToolBar1: TJLXPToolBar;
    ToolButtonRecordNameMail: TToolButton;
    ToolButtonTrim: TToolButton;
    ToolButtonNameWarn: TToolButton;  //rika
    ToolButtonBeLogin: TToolButton;
    ToolButtonWriteWait: TToolButton;

    procedure PageControlChange(Sender: TObject);
    procedure CheckBoxSageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonWriteClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function Hook(var Message: TMessage): Boolean;
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBoxTopClick(Sender: TObject);
    procedure writeActFocusThreadExecute(Sender: TObject);
    procedure AAListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure writeActShowAAListExecute(Sender: TObject);
    procedure AAListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AAListExit(Sender: TObject);
    procedure MemoChange(Sender: TObject);
    procedure WStatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    function IsShortCut(var Message: TWMKey): Boolean; override;
    procedure EditBoxChange(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ToolButtonRecordNameMailClick(Sender: TObject);
    procedure ToolButtonTrimClick(Sender: TObject);
    procedure ToolButtonNameWarnClick(Sender: TObject);
    procedure ToolButtonBeLoginClick(Sender: TObject);
    procedure ToolButtonWriteWaitClick(Sender: TObject);
  private
    { Private 宣言 }
    savedTop : integer;
    savedLeft : integer;
    savedWidth: integer;
    savedHeight: integer;
    gotRule: TProgState;
    procGet: TAsyncReq;
    procPost: TAsyncReq;
    storedRule: TLocalCopy;
    writeRetryCount: Integer;
    cookieRetryCount: Integer;
    postType: TPostType;
    postCode: string;
    //kakikomiFile: TFileStream;
    formType: TFormType;
    LoadText: TStringList;
    TextView: THogeTextView;
    Preview: THogeTextView;
    LocalRuleViewItem: TFlexViewItem;
    PreviewItem: TFlexViewItem;
    HideOnApplicationMinimize: Boolean; //beginner
    gotSettingTxt: TProgState;
    storedSettingTxt: TLocalCopy;
    procGetSettingTxt: TAsyncReq;
    BBSLineNumuber: Integer;
    BBSMessageCount: Integer;
    BBSSubjectCount: Integer;
    BBSNameCount: Integer;
    BBSMailCount: Integer;
    PanelColor: array[0..2] of TColor;  //パネルの数だけ確保
    procedure GetSettingTxt;
    procedure OnSettingTxt(sender: TAsyncReq);
    procedure PostArticle;
    procedure GetLocalRule;
    procedure OnNotify(sender: TAsyncReq; code: TAsyncNotifyCode);
    procedure OnWritten(sender: TAsyncReq);
    procedure OnLocalRule(sender: TAsyncReq);
    procedure WritePreview;
    procedure MakePreview;
    procedure RequestToGetLocalRule;
    procedure PasteAAListItem;
    procedure SetNameBox(NameCombo: TComboboxEx; NameList: TStringList; const Board: string);  //beginner(by nono)
    {aiai}
    procedure WaitTimerStart;
    procedure WaitTimerStop;
    {/aiai}

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    function Res2Dat: string;

  public
    { Public 宣言 }
    freeReserve: boolean;  //設定変更反映用の解放予約
    thread: TThreadItem;
    board: TBoard;
    chotto: boolean;   //rika
    procedure Show(threadItem: TThreadItem); overload;
    procedure Show(boardItem: TBoard); overload;
    class function Trip(const Key: string): string;
    function SavedBoundsRect:TRect; //beginner
    procedure MainWndOnHide; //beginner
    procedure MainWndOnShow; //beginner
    {aiai}
    procedure WriteWaitNotify(DomainName: String; Remainder: Integer);
    procedure WriteWaitEnd;
    {/aiai}
  end;

var
  WriteForm: TWriteForm;

procedure SetButtonWriteEnabled(ABool: Boolean);

(*=======================================================*)
implementation
(*=======================================================*)

uses
  Main, IdCookie, JLWritePanel;

{$R *.dfm}

const
  BBS_LINE_NUMBER   = 'BBS_LINE_NUMBER';
  BBS_MESSAGE_COUNT = 'BBS_MESSAGE_COUNT';
  BBS_SUBJECT_COUNT = 'BBS_SUBJECT_COUNT';
  BBS_NAME_COUNT    = 'BBS_NAME_COUNT';
  BBS_MAIL_COUNT    = 'BBS_MAIL_COUNT';

  BUTTON_WRITE_CAPTION = '書き込む(&W)';

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


(* ローカルルール、SETTING.TXT取得、プレビュー生成キック *)
procedure TWriteForm.PageControlChange(Sender: TObject);
var
  ActiveTab: TTabSheet;
begin
  (*  *)
  ActiveTab := PageControl.Pages[PageControl.ActivePageIndex];

  if ActiveTab = TabSheetLocalRule then
    GetLocalRule
  else if ActiveTab = TabSheetSettingTxt then
    GetSettingTxt
  else if ActiveTab = TabSheetPreview then
    MakePreview;
end;

(* 窓をタスクバーに *)
procedure TWriteForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if FormStyle in [fsNormal, fsStayOnTop] then
    if BorderStyle in [bsSingle, bsSizeable] then
      if Config.wrtFmUseTaskBar then
      begin
        Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
        Params.WndParent := 0;
      end else
        Params.ExStyle := Params.ExStyle and (not WS_EX_APPWINDOW);
end;

(* 閉じた時の処理 *)
procedure TWriteForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
 WriteForm := nil;
end;

(* 窓を最前面に *)
procedure TWriteForm.CheckBoxTopClick(Sender: TObject);
begin
  if Visible then //表示処理が入るのでCreate・Show時以外はここで位置・サイズ保存
    SavedBoundsRect;
  Config.wrtFormStayOnTop := CheckBoxTop.Checked;
  if Config.wrtFmUseTaskBar then
  begin
    SetWindowLong(self.Handle, GWL_HWNDPARENT, 0);
    if CheckBoxTop.Checked then
      FormStyle := fsStayOnTop
    else
      FormStyle := fsNormal;
  end
  else begin
    SetWindowLong(self.Handle, GWL_HWNDPARENT, MainWnd.Handle);
    FormStyle := fsNormal;
  end
end;

(* SAGE処理 *)
procedure TWriteForm.CheckBoxSageClick(Sender: TObject);
begin
  if CheckBoxSage.Checked then
  begin
    EditMailBox.Text := 'sage';
    EditMailBox.Enabled := false;
  end
  else begin
    EditMailBox.Text := '';
    EditMailBox.Enabled := true;
  end;
end;

(* 初期化 *)
procedure TWriteForm.FormCreate(Sender: TObject);

  procedure KeyConf;
  var
    ini: TMemIniFile;
    i: integer;

    procedure SetShortCut(action: TAction);
    var
      key: string;
    begin
      key := ini.ReadString('KEY', action.Name, '');
      if key = '' then
        exit;
      action.ShortCut := TextToShortCut(key);
      if (action.ShortCut = 0) and (length(key) > 1)then
      try
        action.ShortCut := StrToInt(key);
      except
      end;
    end;
  begin
    if not FileExists(Config.BasePath + KEYCONF_FILE) then
      exit;
    ini := TMemIniFile.Create(Config.BasePath + KEYCONF_FILE);
    for i := 0 to ActionList.ActionCount -1 do
      SetShortCut(TAction(ActionList.Actions[i]));
    ini.Free;
  end;

  procedure LoadAAlist;
  var
    index: integer;
  begin
    index := 0;
    LoadText := TStringList.Create;
    if  (FileExists(IncludeTrailingPathDelimiter(Config.BasePath) + AALIST_FILE))  then
      LoadText.LoadFromFile(IncludeTrailingPathDelimiter(Config.BasePath) + AALIST_FILE);
    if LoadText.count <= 0 then
      exit;
    while (CompareStr('[aalist]', LoadText[index]) <> 0) do
    begin
      Inc(index);
      if LoadText.Count - 1 <= index then
        exit;
    end;
    Inc(index);
    while not(StartWith('[', LoadText[index], 1)) do
    begin
      AAList.Items.Add(LoadText[index]);
      if index < LoadText.Count - 1 then
        Inc(index)
      else
        break;
    end;
  end;
var
  font: TFont;
begin
  savedLeft := 0;
  savedTop  := 0;
  savedWidth := 0;
  savedHeight := 0;
  writeRetryCount := 0;
  cookieRetryCount := 0;
  postType := postNormal;
  postCode := '';
  board := nil;
  thread := nil;
  procGet := nil;
  procPost := nil;
  FormStyle := fsNormal; // http://pc2.2ch.net/test/read.cgi/win/1045044108/223
  TextView := THogeTextView.Create(TabSheetLocalRule);
  with TextView do
  begin
    Parent := TabSheetLocalRule;
    Align := alClient;
    Enabled := True;
    Visible := True;
    TabStop := True;
    LeftMargin := 8;
    TopMargin := 4;
    RightMargin := 8;
    ExternalLeading := 1;
    VerticalCaretMargin := 1;
    VScrollLines := 5;
    TextAttrib[1].style := [fsBold];
    TextAttrib[2].color := clBlue;
    TextAttrib[2].style := [fsUnderline];
    TextAttrib[3].color := clBlue;
    TextAttrib[3].style := [fsBold, fsUnderline];
    TextAttrib[4].color := clRed;
    TextAttrib[5].color := clGreen;
    OnMouseMove  := MainWnd.OnBrowserMouseMove;
    OnMouseDown  := MainWnd.OnBrowserMouseDown;
    OnMouseHover := MainWnd.OnBrowserMouseHover;
  end;
  Preview := THogeTextView.Create(TabSheetPreview);
  with Preview do
  begin
    Parent := TabSheetPreview;
    Align := alClient;
    LeftMargin := 8;
    TopMargin := 4;
    RightMargin := 8;
    ExternalLeading := 1;
    VerticalCaretMargin := Config.viewVerticalCaretMargin;
    WheelPageScroll := Config.viewPageScroll;
    VScrollLines := Config.viewScrollLines;
    {beginner}
    EnableAutoScroll := Config.viewEnableAutoScroll;
    Frames := Config.viewScrollSmoothness;
    FrameRate := Config.viewScrollFrameRate;
    {/beginner}
    Font.Name := 'ＭＳ Ｐゴシック';
    Color := RGB($ef, $ef, $ef);
    TextAttrib[1].style := [fsBold];
    TextAttrib[2].color := clBlue;
    TextAttrib[2].style := [fsUnderline];
    TextAttrib[3].color := clBlue;
    TextAttrib[3].style := [fsBold, fsUnderline];
    TextAttrib[4].color := clGreen;
    TextAttrib[5].color := clGreen;
    TextAttrib[5].style := [fsBold];
    OnMouseMove :=  MainWnd.OnBrowserMouseMove;
    OnMouseDown :=  MainWnd.OnBrowserMouseDown;
    OnMouseHover := MainWnd.OnBrowserMouseHover;
  end;
  PreviewItem := TFlexViewItem.Create;
  PreviewItem.PopUpViewList := Main.popupviewList;
  PreviewItem.browser := Preview;
  PreviewItem.RootControl := TabSheetPreview;

  LocalRuleViewItem := TFlexViewItem.Create;
  LocalRuleViewItem.PopUpViewList := Main.popupviewList;
  LocalRuleViewItem.browser := TextView;
  LocalRuleViewItem.RootControl := TabSheetLocalRule;

  if Config.viewDefFontInfo.face <> '' then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewDefFontInfo);
    Self.Font.Assign(font);
    font.Free;
  end;
  if Config.viewWriteFontInfo.face <> '' then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewWriteFontInfo);
    Memo.Font.Assign(font);
    font.Free;
  end;

  //※[457]
  ThreadTitlePanel.Color := MainWnd.ThreadToolPanel.Color;
  ThreadTitlePanel.Font := MainWnd.ThreadTitleLabel.Font;

  storedRule := nil;
  storedSettingTxt := nil;
  //▼メインウィンドウのショートカットを無効化
  Application.HookMainWindow(hook);
  KeyConf;
  CheckBoxTop.Enabled := Config.wrtFmUseTaskBar;

  EditNameBox.Items := Config.wrtNameList;
  EditMailBox.Items := Config.wrtMailList;

  LoadAAlist; //aiai

  HideOnApplicationMinimize:=False; //beginner

  freeReserve := false;

end;

(* [再]表示時 *)
procedure TWriteForm.FormActivate(Sender: TObject);
begin
  if WindowState<>wsMaximized then begin
    if 0 < savedWidth then
      Width := savedWidth;
    if 0 < savedHeight then
      Height := savedHeight;
  end;

  //▼レスウィンドウアクティブ時にIME有効化
  SetImeMode(Handle, userImeMode);
end;

(* 邪魔にならないようにする *)
procedure TWriteForm.FormDeactivate(Sender: TObject);
begin
  if WindowState<>wsMinimized then begin
    savedLeft := Left;
    savedTop  := Top;
    savedWidth:= Width;
    savedHeight:= Height;
    if not Config.wrtFmUseTaskBar then
      Height := 10;
  end;

  //▼レスウィンドウからフォーカスが外れるときにIME状態を保存
  SaveImeMode(Handle);
end;

(* 表示処理 *)
procedure TWriteForm.Show(threadItem: TThreadItem);
begin
  if assigned(thread) then
  begin
    SetFocus;
  end
  else begin
    thread := threadItem;
    thread.AddRef;
  end;
  formType := formWrite;
  board := TBoard(thread.board);

  //レス用ウィンドウの表示状態設定
  Self.Caption := '『' + HTML2String(thread.title) + '』 にレス';
  ThreadTitlePanel.Visible := Config.wrtShowThreadTitle;
  SubjectPanel.Visible := false;
  ThreadTitlePanel.Caption := '【' + StringReplace(thread.GetBoardName + '】 - ' + HTML2String(thread.title), '&', '&&', [rfReplaceAll]);
  //RecordCheckBox.Enabled :=true;
  ToolButtonRecordNameMail.Enabled := True;
  PageControl.ActivePage := TabSheetMain;

  //名前とメール欄
  //521 記憶したName/Mailをボックスへ
  //RecordCheckBox.checked := Config.wrtRecordNameMail;
  ToolButtonRecordNameMail.Down := Config.wrtRecordNameMail;
  CheckBoxSage.Checked := false;
  //名前
  SetNameBox(self.EditNameBox, Config.wrtNameList, board.bbs);
  if thread.UsedWriteMail <> '' then
    EditNameBox.Text := thread.UsedWriteName
  else if (thread.UsedWriteMail = '') and // 記憶されてないスレ(記憶されたスレには必ず!が入る)
          Config.wrtUseDefaultName and (EditNameBox.Items.Count > 0) then
    EditNameBox.Text := EditNameBox.Items[0]
  else
    EditNameBox.Text := '';
  //メール
  if thread.UsedWriteMail <> '' then
    EditMailBox.Text := thread.UsedWriteMail
  else if (thread.UsedWriteMail = '') and Config.wrtDefaultSageCheck then
    EditMailBox.Text := 'sage'
  else
    EditMailBox.Text := '';
  if AnsiStartsStr('!',EditMailBox.Text) then
    EditMailBox.Text := Copy(EditMailBox.Text, 2, length(EditMailBox.Text) - 1);

  CheckBoxTop.Checked := Config.wrtFormStayOnTop;
  if Config.wrtFmUseTaskBar and not CheckBoxTop.Checked then
    FormStyle := fsNormal;

  inherited Show;
end;

(* スレ立て時の表示処理 *)
procedure TWriteForm.Show(boardItem: TBoard);
begin
  if assigned(board) then
  begin
    SetFocus;
  end
  else begin
    board := boardItem;
  end;
  formType := formBuild;
  thread := nil;

  //スレ立て用ウィンドウの表示状態設定
  Self.Caption := '【' + board.name + '】 に新規スレッド';
  SubjectPanel.Visible := true;
  ThreadTitlePanel.Visible := false;
  EditSubjectBox.Text := '';
  //RecordCheckBox.Enabled :=false;
  ToolButtonRecordNameMail.Down := False;
  PageControl.ActivePage := TabSheetLocalRule;

  //名前とメール欄
  SetNameBox(self.EditNameBox, Config.wrtNameList, board.bbs);
  if (Config.wrtUseDefaultName) and (EditNameBox.Items.Count > 0) then
    EditNameBox.Text := EditNameBox.Items[0]
  else
    EditNameBox.Text := '';
  if Config.wrtDefaultSageCheck then
    EditMailBox.Text := 'sage'
  else
    EditMailBox.Text := '';

  CheckBoxTop.Checked := Config.wrtFormStayOnTop;
  if Config.wrtFmUseTaskBar and not CheckBoxTop.Checked then
    FormStyle := fsNormal;

  inherited Show;
end;

procedure TWriteForm.SetNameBox(NameCombo: TComboboxEx; NameList: TStringList; const Board: string);
var
  i: Integer;
  tkBoard, tkName: string;
begin
  NameCombo.ItemsEx.Clear;
  for i := 0 to NameList.Count - 1 do
  begin
    if (NameList[i] <> '') and (NameList[i][1] = '<') and (AnsiPos('>', NameList[i]) <> 0) then
    begin
      tkBoard := Copy(NameList[i], 2, AnsiPos('>', NameList[i]) - 2);
      tkName := Copy(NameList[i], AnsiPos('>', NameList[i]) + 1, Length(NameList[i]) - AnsiPos('>', NameList[i]));
    end else
    begin
      tkBoard := '*';
      tkName := NameList[i];
    end;

    if (tkBoard = Board) or (tkBoard = '*') then
      if NameCombo.Items.IndexOf(tkName) < 0 then
        NameCombo.Items.Add(tkName);
  end;
end;

(* 表示時処理 *)
procedure TWriteForm.FormShow(Sender: TObject);
var
  NeedSETTINGTXT: Boolean;
begin
  if not HideOnApplicationMinimize then
    begin
    //レス・スレ立て共通
    if EditMailBox.Text = 'sage' then
    begin
      EditMailBox.Enabled := false;
      CheckBoxSage.Checked := true;
    end
    else begin
      EditMailBox.Enabled := true;
      CheckBoxSage.Checked := false;
    end;
    {aiai}
    if MainWnd.WriteWaitTimer.IsThisHost(board.host) then
    begin
      ButtonWrite.Enabled := False;
      ButtonWrite.Caption := IntToStr(MainWnd.WriteWaitTimer.Remainder);
    end else
    begin
      ButtonWrite.Enabled := not Main.writing;
      ButtonWrite.Caption := BUTTON_WRITE_CAPTION;
    end;
    {/aiai}
    TabSheetResult.TabVisible := (procPost <> nil);
    gotRule := tpsNone;
    gotSettingTxt := tpsNone;
    postType := postNormal;
    postCode := '';
    ToolButtonTrim.Down := Config.wrtTrimRight; //aiai
    ToolButtonWriteWait.Down := Config.wrtUseWriteWait; //aiai
    ToolButtonNameWarn.Down := Config.wrtNameMailWarning; //aiai
    ToolButtonBeLogin.Down := Config.wrtBeLogin; //aiai
    if Config.wrtDisableStatusBar then
      WStatusBar.Hide
    else
      WStatusBar.Show;

    {beginner} //保存された位置、サイズに移動
    if (Config.wrtFormTop >= 0) and (Config.wrtFormLeft >= 0) and
       (Config.wrtFormHeight >= 0) and (Config.wrtFormWidth >= 0) then
      BoundsRect := Bounds(Config.wrtFormLeft, Config.wrtFormTop,
                    Config.wrtFormWidth, Config.wrtFormHeight);
    {/beginner}

    //※[JS]
    if EditNameBox.CanFocus then
      EditNameBox.SetFocus;
    if Memo.CanFocus then
      Memo.SetFocus;
    if PageControl.ActivePage = TabSheetLocalRule then
      GetLocalRule;

    CheckBoxTopClick(Sender);

    //SETTING.TXT処理
    FreeAndNil(storedSettingTxt);
    NeedSETTINGTXT := False;
    BBSLineNumuber := 0;
    BBSMessageCount := 0;
    BBSSubjectCount := High(Integer);
    BBSNameCount := High(Integer);
    BBSMailCount := High(Integer);
    SettingTxt.Clear;
    try
      storedSettingTxt := TLocalCopy.Create(board.GetLogDir + '\setting.txt', '.idb');
      if storedSettingTxt.Load then
      begin
        SettingTxt.Text := storedSettingTxt.DataString;
        BBSLineNumuber := StrToIntDef(SettingTxt.Lines.Values[BBS_LINE_NUMBER], 0);
        BBSMessageCount := StrToIntDef(SettingTxt.Lines.Values[BBS_MESSAGE_COUNT], 0);
        BBSSubjectCount := StrToIntDef(SettingTxt.Lines.Values[BBS_SUBJECT_COUNT], BBSSubjectCount);
        BBSNameCount := StrToIntDef(SettingTxt.Lines.Values[BBS_NAME_COUNT], BBSNameCount);
        BBSMailCount := StrToIntDef(SettingTxt.Lines.Values[BBS_MAIL_COUNT], BBSMailCount);
        if (storedSettingTxt.Info.Count = 0) or
           (storedSettingTxt.Info[0] <> board.GetURIBase + '/SETTING.TXT') then
          NeedSETTINGTXT := True;
        if storedSettingTxt.Updated + 30 < Now then
          NeedSETTINGTXT := True;
      end else
        NeedSETTINGTXT := True;
    finally
      FreeAndNil(storedSettingTxt);
    end;
    if (board.GetBBSType = bbs2ch) and NeedSETTINGTXT then
      GetSettingTxt;

    MemoChange(nil);
  end;
end;

(* やめた処理 *)
procedure TWriteForm.ButtonCancelClick(Sender: TObject);
begin
  if (GetKeyState(VK_ESCAPE) < 0) and (AAList.Visible) then
  begin
    AAList.Hide;
    Memo.SetFocus
  end else
    Visible := False;
end;

(* カキコ処理 *)
procedure TWriteForm.ButtonWriteClick(Sender: TObject);
  function TagExist(const s: string):Boolean;
  begin
    if (s<>'') and (s[1]='<') and (AnsiPos('>', s)<>0) then
      Result := True
    else
      Result := False;
  end;
var
  BoardName: string;
  WarningList: TStringList;
  ActView: TViewItem;
  Lines: Integer;
begin
  {aiai}
  if Config.wrtTrimRight then
    Memo.Text := TrimRight(Memo.Text);
  {/aiai}

  //書き込み警告関係
  WarningList := nil;
  try
    WarningList := TStringList.Create;
    if board.bbs = 'morningcoffee' then
    begin
      if Config.wrtNameMailWarning and (EditNameBox.Text <> MORNINGCOFFEE_NAME) then
        WarningList.Add('コテハンで書き込みます。');
    end else
    begin
      if EditNameBox.Text = '' then
      begin
        if pos('fusianasan', SettingTxt.Lines.Values['BBS_NONAME_NAME']) > 0 then
          WarningList.Add('この板のデフォルトの名無しはfusianasan(IP表示)です。')
        else if SettingTxt.Lines.Values['NANASHI_CHECK'] = '1' then
          WarningList.Add('名前強制入力の板です。');
      end
      else if Config.wrtNameMailWarning
             and (EditNameBox.Text <> SettingTxt.Lines.Values['BBS_NONAME_NAME']) then
        WarningList.Add('コテハンで書き込みます。');
    end;

    if Config.wrtNameMailWarning and (EditMailBox.Text <> '')
            and  (EditMailBox.Text <> 'sage') then
      WarningList.Add('メール欄にsage以外の内容が含まれています。');

    if Config.wrtDiscrepancyWarning then
    begin
      if formType = formWrite then
      begin
        ActView := MainWnd.GetActiveView;
        if Assigned(ActView) and (ActView.thread <> thread) then
          WarningList.Add(Format('スレ欄と違うところ「%s」に書き込みます。', [thread.title]));
      end else
      begin
        if (MainWnd.currentBoard <> board) then
           WarningList.Add(Format('スレ一覧と違うところ「%s」にスレ立てします。', [board.name]));
      end;
    end;

    {aiai}
    if not AnsiStartsStr('be', board.host)
      and not (SettingTxt.Lines.Values['BBS_BE_ID'] = '1')
        and Config.wrtBeLogin and (Length(Config.wrtBEIDDMDM) > 0)
          and (Length(Config.wrtBEIDMDMD) > 0) then
      Warninglist.Add('Beにログインして書き込みます。');
    {/aiai}
    if formType = formBuild then
      if Length(EditSubjectBox.Text) <= 0 then
        WarningList.Add('スレタイが空です。')
      else if MessageCount(EditSubjectBox.Text) > BBSSubjectCount then
        WarningList.Add('スレタイが長すぎです。');
    if MessageCount(EditNameBox.Text) > BBSNameCount then
      WarningList.Add('名前欄が長すぎです。');
    if MessageCount(EditMailBox.Text) > BBSMailCount then
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

  if (postType = postCheck) and Memo.Modified then
    postType := postNormal;
  writeRetryCount := 0;
  cookieRetryCount := 0;
  Result.Clear;
  PostArticle;
  Memo.Modified := false;
  //▼シフト押してたらリストに追加
  if GetKeyState(VK_SHIFT) < 0 then
  begin
   if EditNameBox.Text <> '' then begin //aiai
    if GetKeyState(VK_CONTROL) < 0 then
      BoardName := '<'+ board.bbs + '>' + EditNameBox.Text
    else if TagExist(EditNameBox.Text) then
      BoardName := '<*>' + EditNameBox.Text
    else
      BoardName := EditNameBox.Text;

    if Config.wrtNameList.IndexOf(BoardName) < 0 then
    begin
      Config.wrtNameList.Add(BoardName);
      SetNameBox(EditNameBox, Config.wrtNameList, board.bbs);
      JLWritePanel.SetNameBox; //aiai
    end;
   end; //aiai
   if EditMailBox.Text <> '' then begin //aiai
    if not CheckBoxSage.Checked and (Config.wrtMailList.IndexOf(EditMailBox.Text) < 0) then
    begin
      Config.wrtMailList.Add(EditMailBox.Text);
      EditMailBox.Items := Config.wrtMailList;
      JLWritePanel.SetMailBox; //aiai
    end;
   end; //aiai
   if (EditNameBox.Text <> '') or (EditMailBox.Text <> '') then //aiai
    Config.Modified := true
  end;
  if formType = formWrite then
  begin
    //Config.wrtRecordNameMail := RecordCheckBox.checked; //521 Name・Mailの記憶・最終書込
    Config.wrtRecordNameMail := ToolButtonRecordNameMail.Down;
    if Config.wrtRecordNameMail then
    begin
      thread.UsedWriteName := EditNameBox.Text;
      thread.UsedWriteMail := '!' + EditMailBox.Text;
      thread.SaveIndexData;
    end;
  end;
end;

procedure TWriteForm.PostArticle;
var
  URI: string;
  encName, encMail: string;
  postDat: string;
  URIObj: TIdURI;
  referer: string;
  list: TStringList;
  cookie: string;
begin
  if board.timeValue <= 0 then
    board.timeValue := timeValue; //起動時刻
  case board.GetBBSType of
  bbs2ch, bbsOther:
    begin
      {aiai}
      if board.NeedConvert then
      begin
        if (EditNameBox.Text = '') and (board.bbs = 'morningcoffee') then
          encName := URLEncode(sjis2euc(MORNINGCOFFEE_NAME))
        else
          encName := URLEncode(sjis2euc(EditNameBox.Text));
        encMail := URLEncode(sjis2euc(EditMailBox.Text));
      end else
      begin
        if (EditNameBox.Text = '') and (board.bbs = 'morningcoffee') then
          encName := URLEncode(MORNINGCOFFEE_NAME)
        else
          encName := URLEncode(EditNameBox.Text);
        encMail := URLEncode(EditMailBox.Text);
      end;
      {/aiai}
      case formType of
      formWrite:
        begin
          case postType of
          postNormal:
            begin
              URI := 'http://' + board.host + '/test/bbs.cgi';
              if board.NeedConvert then
                postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(Memo.Text))
                         + '&bbs='  + board.bbs
                         + '&key='  + ChangeFileExt(thread.datName, '')
                         + '&time=' + IntToStr(board.timeValue)
              else
                postDat := 'submit=' + URLEncode('書き込む')
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(Memo.Text)
                         + '&bbs='  + board.bbs
                         + '&key='  + ChangeFileExt(thread.datName, '')
                         + '&time=' + IntToStr(board.timeValue);
            end;
          postCheck:
            begin
              URI := 'http://' + board.host + '/test/subbbs.cgi';
              if board.NeedConvert then
                postDat := 'bbs='  + board.bbs
                         + '&key='  + ChangeFileExt(thread.datName, '')
                         + '&time=' + IntToStr(board.timeValue)
                         + '&subject='
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(Memo.Text))
                         + '&code='  + postCode
                         + '&submit=' + URLEncode(sjis2euc('全責任を負うことを承諾して書き込む'))
              else
                postDat := 'bbs='  + board.bbs
                         + '&key='  + ChangeFileExt(thread.datName, '')
                         + '&time=' + IntToStr(board.timeValue)
                         + '&subject='
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(Memo.Text)
                         + '&code='  + postCode
                         + '&submit=' + URLEncode('全責任を負うことを承諾して書き込む');
            end;
          end;
        end;
      formBuild:
        begin
          case postType of
          postNormal:
            begin
              URI := 'http://' + board.host + '/test/bbs.cgi';
              if board.NeedConvert then
                postDat := 'subject=' + URLEncode(sjis2euc(EditSubjectBox.Text))
                         + '&submit=' + URLEncode(sjis2euc('新規スレッド作成'))
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(Memo.Text))
                         + '&bbs='  + board.bbs
                         + '&time=' + IntToStr(board.timeValue)
              else
                postDat := 'subject=' + URLEncode(EditSubjectBox.Text)
                         + '&submit=' + URLEncode('新規スレッド作成')
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(Memo.Text)
                         + '&bbs='  + board.bbs
                         + '&time=' + IntToStr(board.timeValue);
            end;
          postCheck:
            begin
              URI := 'http://' + board.host + '/test/subbbs.cgi';
              if board.NeedConvert then
                postDat := 'subject=' + URLEncode(sjis2euc(EditSubjectBox.Text))
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(Memo.Text))
                         + '&bbs='  + board.bbs
                         + '&time=' + IntToStr(board.timeValue)
                         + '&submit=' + URLEncode(sjis2euc('全責任を負うことを承諾して書き込む'))
              else
                postDat := 'subject=' + URLEncode(EditSubjectBox.Text)
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(Memo.Text)
                         + '&bbs='  + board.bbs
                         + '&time=' + IntToStr(board.timeValue)
                         + '&submit=' + URLEncode('全責任を負うことを承諾して書き込む');
            end;
          end;
        end;
      end;
      postDat := postDat + ticket2ch.GetSID(URI, '&');
    end;
  bbsJBBSShitaraba:
    begin
      encName := URLEncode(sjis2euc(EditNameBox.Text));
      encMail := URLEncode(sjis2euc(EditMailBox.Text));
      //▼ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      // したらばのURL対応を少し汎用的に
      URI := 'http://' + Config.bbsJBBSServers[0] + '/bbs/write.cgi';
      //▲ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      case formType of
      formWrite:
        begin
          postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(sjis2euc(Memo.Text))
                   + '&DIR=' + GetJBBSShitarabaCategory(board.host)
                   + '&BBS='  + board.bbs
                   + '&KEY='  + ChangeFileExt(thread.datName, '')
                   + '&TIME=' + IntToStr(UTC);
        end;
      formBuild:
        begin
          postDat := 'SUBJECT=' + URLEncode(sjis2euc(EditSubjectBox.Text))
                   + '&submit=' + URLEncode(sjis2euc('新規書き込み'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(sjis2euc(Memo.Text))
                   + '&DIR=' + GetJBBSShitarabaCategory(board.host)
                   + '&BBS='  + board.bbs
                   + '&TIME=' + IntToStr(UTC);
        end;
      end;
    end;
  bbsMachi, bbsJBBS:
    begin
      encName := URLEncode(EditNameBox.Text);
      encMail := URLEncode(EditMailBox.Text);
      URI := 'http://' + board.host + '/bbs/write.cgi';
      case formType of
      formWrite:
        begin
          postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(Memo.Text)
                   + '&BBS='  + board.bbs
                   + '&KEY='  + ChangeFileExt(thread.datName, '')
                   + '&TIME=' + IntToStr(UTC);
        end;
      formBuild:
        begin
          postDat := 'SUBJECT=' + URLEncode(EditSubjectBox.Text)
                   + '&submit=' + URLEncode(sjis2euc('新規書き込み'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(Memo.Text)
                   + '&BBS='  + board.bbs
                   + '&TIME=' + IntToStr(UTC);
        end;
      end;
    end;
  {bbsOther:
    begin
      encName := URLEncode(EditNameBox.Text);
      encMail := URLEncode(EditMailBox.Text);
      URI := 'http://' + board.host + '/test/bbs.cgi';
      case formType of
      formWrite:
        begin
          postDat := 'submit=' + URLEncode('書き込む')
                   + '&FROM=' + encName
                   + '&mail=' + encMail
                   + '&MESSAGE=' + URLEncode(Memo.Text)
                   + '&bbs='  + board.bbs
                   + '&key='  + ChangeFileExt(thread.datName, '')
                   + '&time=' + IntToStr(UTC);
        end;
      formBuild:
        begin
          postDat := 'subject=' + URLEncode(EditSubjectBox.Text)
                   + '&submit=' + URLEncode('新規スレッド作成')
                   + '&FROM=' + encName
                   + '&mail=' + encMail
                   + '&MESSAGE=' + URLEncode(Memo.Text)
                   + '&bbs='  + board.bbs
                   + '&time=' + IntToStr(UTC);
        end;
      end;
    end;}
  end;

  URIObj := nil;
  try
    URIObj := TIdURI.Create(board.GetURIBase + '/');
    referer := URIObj.URI;
  finally
    URIObj.Free;
  end;
  cookie := 'Cookie: NAME=' + encName + '; MAIL=' + encMail;
  list := TStringList.Create;
  {aiai}
  (*
  if (board.GetBBSType = bbs2ch) and (0 < length(Config.tstWrtCookie)) then
  begin
    {if Pos('=', Config.tstWrtCookie) < 0 then
      list.Add('Cookie: SPID=' + Config.tstWrtCookie + ';')
    else}
      cookie := cookie + '; ' + Config.tstWrtCookie;
  end;
  *)
  if (board.GetBBSType = bbs2ch) then
  begin
    if (0 < length(Config.wrtBEIDDMDM)) and (0 < length(Config.wrtBEIDMDMD)) then
      if Config.wrtBeLogin or AnsiStartsStr('be', board.host)
        {or AnsiStartsStr('live14', board.host)}
        or (SettingTxt.Lines.Values['BBS_BE_ID'] = '1') then
        cookie := cookie + '; DMDM=' + Config.wrtBEIDDMDM
          + '; MDMD=' + Config.wrtBEIDMDMD;
    if (0 < length(Config.tstWrtCookie)) then
      cookie := cookie + '; ' + Config.tstWrtCookie;
  end;
  {/aiai}
  list.Add(cookie);
  procPost := Main.AsyncManager.Post(URI, postDat, referer, list,
                                     OnWritten, OnNotify);
  if procPost <> nil then
  begin
    ButtonWrite.Enabled := false;
    {aiai}
    MainWnd.PauseToggleAutoReSc(false);
    JLWritePanel.SetWriteButtonEnabled(false);
    Main.writing := True;
    if Config.wrtUseWriteWait then
      WaitTimerStart;
    {/aiai}
    Result.Lines.Add('--------------------');
    Result.Lines.Add('書込み中・・・');
    Result.Lines.Add('--------------------');
    TabSheetResult.TabVisible := true;
    PageControl.ActivePage := TabSheetResult;
  end;
  list.Free;
end;

procedure TWriteForm.OnNotify(sender: TAsyncReq; code: TAsyncNotifyCode);
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

procedure TWriteForm.OnWritten(sender: TAsyncReq);
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
    ButtonWrite.Enabled := true;
    JLWritePanel.SetWriteButtonEnabled(true);
    MainWnd.PauseToggleAutoReSc(true);  //aiai
  end;

  {aiai}  //書き込み履歴保存部分を分離
  procedure SaveKakikomi;
  var
    kakikomistr: TStringList;
    kakikomiFile: TFileStream;
  begin
    if not FileExists(Config.BasePath + 'kakikomi.txt') then
    try
      FileClose(FileCreate(Config.BasePath + 'kakikomi.txt'));
    except
    end;

    try
      kakikomiFile := TFileStream.Create(Config.BasePath + 'kakikomi.txt',
                               fmOpenReadWrite or fmShareDenyWrite);
    except
    //エラーの場合は抜ける
      on E: Exception do begin
        Log(e.Message);
        exit;
      end;
    end;

    kakikomistr := TStringList.Create;
    try
      kakikomistr.Add('--------------------------------------------');
      kakikomistr.Add('Date   : ' + DateToStr(Date) + ' ' + TimeToStr(Time));
      kakikomistr.Add('Subject: ' + thread.title);
      kakikomistr.Add('URL    : ' + thread.ToURL(false));
      kakikomistr.Add('FROM   : ' + EditNameBox.Text);
      kakikomistr.Add('MAIL   : ' + EditMailBox.Text);
      kakikomistr.Add('');
      kakikomistr.AddStrings(Memo.Lines);
      kakikomistr.Add('');
      kakikomistr.Add('');

      kakikomiFile.Seek(0, soFromEnd);
      kakikomiFile.Write(PChar(kakikomistr.Text)^, length(kakikomistr.Text));
    finally
      kakikomistr.Free;
      FreeAndNil(kakikomiFile);  //書き込み後ファイルを閉じる
    end;
  end;
  {/aiai}


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
  Main.writing := False; //aiai
  procPost := nil;
  if Config.tstCommHeaders then
  begin
    //Log('--------------------');
    //Log(postDat);
    Log('--------------------');
    Log(sender.IdHTTP.ResponseText);
    Log('--------------------');
  end;

  tempTime := DateTimeToUnix(Str2DateTime(sender.GetDate));
  if board.timeValue > tempTime then
    board.timeValue := tempTime
  else
    Inc(board.timeValue); //古いbbs.cgiで2重カキコループにならないように
  {aiai}
  if board.NeedConvert then
    responseHTML := euc2sjis(sender.GetString)
  else
  {/aiai}
  responseHTML := sender.GetString;
  responseText := HTML2String(responseHTML);

  Visible := true;
  TabSheetResult.TabVisible := true;
  PageControl.ActivePage := TabSheetResult;

  if (sender.IdHTTP.ResponseCode = 200) then
  begin
    //if board.GetBBSType = bbsJBBSShitaraba then
    //  responseText := euc2sjis(responseText);

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
      {aiai}
      WaitTimerStop;
      MainWnd.PauseToggleAutoReSc(true);
      {/aiai}
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
      begin
        for i := 0 to Count -1 do
        begin
          //if (Items[i].CookieName = 'SPID') or (Items[i].CookieName = 'PON') then
          if (Items[i].CookieName <> 'NAME') and (Items[i].CookieName <> 'MAIL') then
          begin
            //Config.tstWrtCookie := Items[i].Value;
            //break;
            Config.tstWrtCookie := Config.tstWrtCookie + Items[i].ClientCookie + '; ';
          end;
        end;
      end;
      Config.Modified := True;
      PostArticle;
      exit;
    end;

    if (errMsg = 'check') or
       ((2 <= list.Count) and AnsiContainsStr(list[1], '書き込み確認')) then
    begin
      list.Free;
      SetPostCode;
      {aiai}
      MainWnd.PauseToggleAutoReSc(true);
      WaitTimerStop;
      {/aiai}
      exit;
    end;

    if not (((errMsg <> '') and ((errMsg = 'true') or (errMsg = 'false'))) or
            ((errMsg =  '') and (list.Count > 0) and
                                 (AnsiContainsStr(list[0], '書きこみました') or
                                  AnsiContainsStr(list[0], '書き込みました'))))then
    begin
      list.Free;
      {aiai}
      WaitTimerStop;
      MainWnd.PauseToggleAutoReSc(true);
      {/aiai}
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
    {aiai}
    WaitTimerStop;
    MainWnd.PauseToggleAutoReSc(true);
    {/aiai}
    exit;
  end;

  //以降書き込み成功時

  board.timeValue := tempTime;

  if thread <> nil then
  begin
    thread.LastWrote := DateTimeToUnix(Now);
    thread.SaveIndexData;

    //▼書き込み履歴保存
    if Config.wrtRecordWriting then
      SaveKakikomi;

    viewItem := viewList.FindViewItem(thread);
    {aiai}
    //if viewItem <> nil then
      //viewItem.NewRequest(thread, gotCHECK, -1, True, Config.oprCheckNewWRedraw);
    if viewItem <> nil then
    begin
      viewItem.NewRequest(thread, gotCHECK, -1, True, Config.oprCheckNewWRedraw);
      MainWnd.PauseToggleAutoReSc(true);
    end;
    {/aiai}
  end;

  if errMsg = 'false' then
  begin
    Caption := '注意が出ています';
    {aiai}
    WaitTimerStop;
    MainWnd.PauseToggleAutoReSc(true);
    {/aiai}
    exit;
  end;

  if Config.tstCloseAfterWriting then begin
    HideOnApplicationMinimize := False;
    Visible := False;
  end else begin
    HideOnApplicationMinimize := False;
    PageControl.ActivePage := TabSheetMain;
    try
      Memo.Clear;
      if Memo.Visible then Memo.SetFocus;
    except end;
  end;
  {aiai}
  if Assigned(thread) then
    ButtonWrite.Enabled := not MainWnd.WriteWaitTimer.IsThisHost(thread.GetHost);
  if Assigned(WriteMemo) and Assigned(WriteMemo.board) then
    ChangeWirteButtonEnabled(MainWnd.WriteWaitTimer.IsThisHost(WriteMemo.board.host));
  {/aiai}
end;

(* 閉じたように見せる時の処理 *)
procedure TWriteForm.FormHide(Sender: TObject);
begin
  if not HideOnApplicationMinimize then
  begin
    SavedBoundsRect;
    if procPost = nil then
    begin
      board := nil;
      if assigned(thread) then
        thread.Release;
      thread := nil;
      Result.Clear;
    end;
    procGetSettingTxt := nil;
    FreeAndNil(storedSettingTxt);
    gotSettingTxt := tpsNone;
    if MainWnd.Visible then  //aiai
      MainWnd.SetFocus;
  end;
end;


(* ローカルルール取得処理。 *)
procedure TWriteForm.GetLocalRule;
begin
  if gotRule <> tpsNone then
    exit;
  TextView.Clear;
  RequestToGetLocalRule;
end;

procedure TWriteForm.RequestToGetLocalRule;
var
  URI: string;
  lastModified: string;
begin
  lastModified := '';
  if storedRule = nil then
  begin
    storedRule := TLocalCopy.Create(board.GetLogDir + '\head.txt', '.idb');
    storedRule.Load;
    if 2 <= storedRule.Info.Count then
      lastModified := storedRule.Info.Strings[1];
  end;
  gotRule := tpsWorking;
  URI := board.GetURIBase + '/head.txt';
  procGet := AsyncManager.Get(URI, OnLocalRule, ticket2ch.On2chPreConnect,
                              lastModified);
end;


(* ローカルルール取得完了ハンドラ *)
procedure TWriteForm.OnLocalRule(sender: TAsyncReq);
  procedure WriteHTML(localRule: string);
  var
    ht2v: TSimpleDat2View;
  begin
    ht2v := TSimpleDat2View.Create(TextView);
    ht2v.WriteHTML(localRule);
    ht2v.Flush;
    ht2v.Free;
  end;
var
  localRule: string;
begin
  if procGet = sender then
  begin
    case sender.IdHTTP.ResponseCode of
    200: (* OK *)
      begin
        storedRule.Clear;
        {aiai}
        if board.NeedConvert then
          storedRule.WriteString(euc2sjis(sender.Content))
        else
        {/aiai}
        storedRule.WriteString(sender.Content);
        storedRule.Info.Add('');
        storedRule.Info.Add(sender.GetLastModified);
        storedRule.Save;
      end;
    304: (* Not Modified *)
      begin
      end;
    else
      begin
        storedRule.Clear;
      end;
    end;
    localRule := storedRule.DataString;

    procGet := nil;
    WriteHTML(localRule);
    storedRule.Free;
    storedRule := nil;
    gotRule := tpsDone;
    LocalRuleViewItem.Base := board.GetURIBase + '/';
  end;
end;


//SETTING.TXT取得処理
procedure TWriteForm.GetSettingTxt;
var
  URI: string;
  lastModified: string;
begin
  if gotSettingTxt <> tpsNone then
    exit;
  lastModified := '';
  if storedSettingTxt = nil then
  begin
    storedSettingTxt := TLocalCopy.Create(board.GetLogDir + '\setting.txt', '.idb');
    storedSettingTxt.Load;
    if 2 <= storedSettingTxt.Info.Count then
      lastModified := storedSettingTxt.Info.Strings[1];
  end;
  gotSettingTxt := tpsWorking;
  URI := board.GetURIBase + '/SETTING.TXT';
  procGetSettingTxt := AsyncManager.Get(URI, OnSettingTxt, ticket2ch.On2chPreConnect,
                              lastModified);
end;

//SETTING.TXT取得完了ハンドラ
procedure TWriteForm.OnSettingTxt(sender: TAsyncReq);
var
  lastModified: string;
begin
  if procGetSettingTxt = sender then
  begin
    case sender.IdHTTP.ResponseCode of
      200: (* OK *)
        begin
          storedSettingTxt.Clear;
          {aiai}
          if board.NeedConvert then
            storedSettingTxt.WriteString(StringReplace(euc2sjis(sender.Content), #10, #13#10, [rfReplaceAll]))
          else
          {/aiai}
          storedSettingTxt.WriteString(StringReplace(sender.Content, #10, #13#10, [rfReplaceAll]));
          storedSettingTxt.Info.Add(board.GetURIBase + '/SETTING.TXT');
          storedSettingTxt.Info.Add(sender.GetLastModified);
          storedSettingTxt.Save;
          SettingTxt.Text := storedSettingTxt.DataString;
          BBSLineNumuber  := StrToIntDef(SettingTxt.Lines.Values[BBS_LINE_NUMBER], 0);
          BBSMessageCount := StrToIntDef(SettingTxt.Lines.Values[BBS_MESSAGE_COUNT], 0);
          BBSSubjectCount := StrToIntDef(SettingTxt.Lines.Values[BBS_SUBJECT_COUNT], High(Integer));
          BBSNameCount    := StrToIntDef(SettingTxt.Lines.Values[BBS_NAME_COUNT], High(Integer));
          BBSMailCount    := StrToIntDef(SettingTxt.Lines.Values[BBS_MAIL_COUNT], High(Integer));
          Board.settingText.Assign(SettingTxt.Lines);
          ChangeWriteMemoSettingText(Board);
          MemoChange(nil);
        end;
      304: (* NotModifiedの時も再保存することで最終チェック時刻を更新 *)
        begin
          lastModified := '';
          if storedSettingTxt.Info.Count >= 2 then
            lastModified := storedSettingTxt.Info.Strings[1];
          storedSettingTxt.Info.Clear;
          storedSettingTxt.Info.Add(board.GetURIBase + '/SETTING.TXT');
          storedSettingTxt.Info.Add(lastModified);
          storedSettingTxt.Save;
        end;
    end;
    FreeAndNil(storedSettingTxt);
    procGetSettingTxt := nil;
    gotSettingTxt := tpsDone;
  end;
end;

procedure TWriteForm.FormDestroy(Sender: TObject);
begin

  if storedRule <> nil then
  begin
    storedRule.Free;
    storedRule := nil;
  end;
  PreviewItem.Free;
  LocalRuleViewItem.Free;
  TextView.Free;
  Preview.Free;
  //▼コテハンリスト保存
  //if FileExists(Config.BasePath + 'name.dat') then
  //  EditNameBox.Items.SaveToFile(Config.BasePath + 'name.dat');
  //if kakikomiFile <> nil then
  //  kakikomiFile.Free;
  //▼よくわかんないけど一応
  Application.UnhookMainWindow(Hook);
  if LoadText <> nil then
    LoadText.Free;
end;


//▼Tipsにあるまんま
function TWriteForm.Hook(var Message: TMessage): Boolean;
begin
  case Message.Msg of
  CM_APPKEYDOWN:
     Result := True;  // ショートカットを無効にする
  CM_APPSYSCOMMAND:
     Result := True;  // アクセラレータを無効にする
  else
     Result := False;
  end;
end;

procedure TWriteForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  Ord('A'):
    begin
      if ssCtrl in Shift then
        Memo.SelectAll;
    end;
  end;
end;

{------------------------------------------------------------------------}
{------------------------------------------------------------------------}

class function TWriteForm.Trip(const Key: string): string;
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

{------------------------------------------------------------------------}


function TWriteForm.Res2Dat: string;
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
      if Board.NeedConvert then
        Result := Copy(Result, 1, AnsiPos('#', Result) - 1) + '</b>'
          + Trip(sjis2euc(Copy(Result,AnsiPos('#', Result) + 1, Length(Result)))) + ' <b>'
      else
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
  if EditNameBox.Text <> '' then
  begin
    if board.GetBBSType = bbs2ch then
      aName := StringReplace(EditNameBox.Text, '&r', '', [rfReplaceAll])
    else
      aName := EditNameBox.Text;
  end else
    aName := SettingTxt.Lines.Values['BBS_NONAME_NAME'];

  aMail := EditMailBox.Text;
  aDate := FormatDateTime('yy/mm/dd hh:nn', Now);
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

function ZoomToPoint(zoom: integer): Integer;
begin
  result := -12; // 9;
  {case zoom of
  0: result := -9;
  1: result := -10;
  2: result := -12;
  3: result := -14;//521 -16
  4: result := -15;//521 -24
  end;}
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

procedure TWriteForm.MakePreview;
begin
  PreviewItem.thread := thread;
  PreviewItem.Base := '';
  Preview.HoverTime := Config.hintHoverTime;
  Preview.Clear;
  WritePreview;
end;

procedure TWriteForm.WritePreview;
  function MakeDummyDat(line: Integer):string;
  const
//  dummyDat : string = '名無し<>sage<>01/01/01 00:00<> message <>'#10;
    dummyDat : string = '<><><><>'#10;
  begin
    Result := DupeString(dummyDat, line);
  end;
const
  HeaderSkin = '<html><body><font face="ＭＳ Ｐゴシック"><dl>';
var
  dat: TThreadData;
  ResSkin: string;
  TempStream: TDat2View;
  PreviewD2HTML: TDat2HTML;
begin
  TempStream := TDat2View.Create(Preview);
  if EditMailBox.Text='' then
    ResSkin := '<dt><SA i=1><b><PLAINNUMBER/></b><SA i=0> ：<SA i=2><b><NAME/></b></b><SA i=0>[<MAIL/>] ：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10
  else
    ResSkin := '<dt><SA i=1><b><PLAINNUMBER/></b><SA i=0> ：<SA i=1><b><NAME/></b></b><SA i=0>[<MAIL/>] ：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10;

  PreviewD2HTML := TDat2HTML.Create(resSkin, Config.SkinPath);
  dat := TThreadData.Create;
  try
    Preview.ExternalLeading := ZoomToExternalLeading(Config.viewZoomSize);
    Preview.SetFont(Preview.Font.Name, ZoomToPoint(Config.viewZoomSize));
    TempStream.WriteHTML(HeaderSkin);
    TempStream.Flush;
    if Assigned(thread) then
    begin
      dat.Add(MakeDummyDat(thread.lines));
      dat.Add(Res2Dat);
      PreviewD2HTML.ToDatOut(TempStream, dat, thread.lines + 1, 1)
    end else
    begin
      dat.Add(Res2Dat);
      PreviewD2HTML.ToDatOut(TempStream, dat, 1, 1);
    end;
    TempStream.Flush;
  finally
    dat.Free;
    PreviewD2HTML.Free;
    TempStream.Free;
  end;
end;

procedure TWriteForm.writeActFocusThreadExecute(Sender: TObject);
begin
  MainWnd.MenuWndThreadClick(Self);
end;

//保存用の位置を返す(縮んでいるときは元のサイズを返す)
function TWriteForm.SavedBoundsRect:TRect;
begin
  Result := BoundsRect;
  if WindowState <> wsMaximized then
  begin
    if 0 < savedWidth then
      Result.Right := Result.Left + savedWidth;
    if 0 < savedHeight then
      Result.Bottom := Result.Top + savedHeight;
  end;
  Config.wrtFormTop := Result.Top;
  Config.wrtFormLeft := Result.Left;
  Config.wrtFormHeight := Result.Bottom - Result.Top;
  Config.wrtFormWidth := Result.Right - Result.Left;
end;

//アプリ最小化時に自分を隠す(Main.pasのTMainWnd.OnAboutToShow参照)
procedure TWriteForm.MainWndOnHide;
begin
  if Visible and (not Config.wrtFmUseTaskBar) then    //aiai
  begin
    HideOnApplicationMinimize := True;
    Hide;
  end;
end;

//アプリ復元時に必要なら復元(Main.pasのTMainWnd.OnAboutToShow参照)
procedure TWriteForm.MainWndOnShow;
begin
  if HideOnApplicationMinimize and (not Config.wrtFmUseTaskBar) then
    Self.Show;
  HideOnApplicationMinimize:=False;
end;

(* AA入力支援 *)
procedure TWriteForm.AAListMouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if  (AAList.ItemIndex > -1) then
    begin
      PasteAAListItem;
    end;
    AAList.Hide;
    Memo.SetFocus;
  end;
end;

procedure TWriteForm.writeActShowAAListExecute(Sender: TObject);
var
  point: TPoint;
begin
  if 0 < AAList.Count then
  begin
    GetCaretPos(point);
    AAList.Top  := TabSheetMain.Top + Memo.Top + point.Y - Memo.Font.Height;
    if (self.Height < AAList.Top + AAList.Height + 30) and
       (AAlist.Height < AAList.Top) then
      AAList.Top  := TabSheetMain.Top + Memo.Top + point.Y - AAList.Height;
    AAList.Left := PageControl.Left+ TabSheetMain.Left + Memo.Left + point.X;
    if Memo.Width < point.X + AAList.Width + 30 then
      AAList.Left := AAlist.Left - point.X + Memo.Width - AAList.Width - 30;
    AAList.ItemIndex := 0;
    AAList.Show;
    AAList.SetFocus;
  end;
end;

procedure TWriteForm.AAListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
  begin
    AAList.Hide;
    Memo.SetFocus;
  end else
  if (Key = VK_RETURN) then
  begin
    if (AAList.ItemIndex > -2) then
    begin
      PasteAAListItem;
    end;
    AAList.Hide;
    Memo.SetFocus;
  end;
end;

procedure TWriteForm.AAListExit(Sender: TObject);
begin
  AAList.Hide;
end;

procedure TWriteForm.PasteAAListItem;
var
  text: string;
  index: integer;
begin
  text := AAList.Items[AAList.ItemIndex];
  if StartWith('*', text, 1) then
  begin
    index := 0;
    while (CompareStr('['+ Copy(text, 2, Length(text) - 1) + ']', LoadText[index]) <> 0) do
    begin
      Inc(index);
      if LoadText.Count - 1 <= index then
        exit;
    end;
    Inc(index);
    while not (StartWith('[', LoadText[index], 1)) do
    begin
      Memo.SelText := LoadText[index] + #13#10;
      if index < LoadText.Count - 1 then
        Inc(index)
      else
        break;
    end;
  end else
    Memo.SelText := text;
end;


//書き込みメッセージの文字数、行数カウント
procedure TWriteForm.MemoChange(Sender: TObject);
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

type TDummyControl = class(TControl); //おまじない
procedure TWriteForm.EditBoxChange(Sender: TObject);
begin
  if (Sender = EditSubjectBox) and (MessageCount(EditSubjectBox.Text) > BBSSubjectCount) then
    EditSubjectBox.Color := $00dfdfff
  else
  if (Sender = EditNameBox) and (MessageCount(EditNameBox.Text) > BBSNameCount) then
    EditNameBox.Color := $00dfdfff
  else
  if (Sender = EditMailBox) and (MessageCount(EditMailBox.Text) > BBSMailCount) then
    EditMailBox.Color := $00dfdfff
  else
    TDummyControl(Sender).Color := clWindow;
end;

procedure TWriteForm.WStatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
  function RealHeight(Font: TFont): Integer;
  var
    tm: TEXTMETRIC;
  begin
    if Font.Height >= 0 then
      result := Abs(Font.Height)
    else
    begin
      GetTextMetrics(StatusBar.Canvas.Handle, tm);
      result := Abs(Font.Height) + tm.tmInternalLeading;
    end;
  end;
var
  i: Integer;
  X, Y: Integer;
begin
  StatusBar.Canvas.Brush.Color := WStatusBar.Color;
  for i := Low(PanelColor) to High(PanelColor) do
  begin
    if Panel = StatusBar.Panels[i] then
    begin
      StatusBar.Canvas.Brush.Color := PanelColor[i];
      Break;
    end;
  end;
  X := Rect.Left + 4;
  Y := (Rect.Top + Rect.Bottom - RealHeight(StatusBar.Canvas.Font)) div 2 + 1;
  StatusBar.Canvas.TextRect(Rect, X, Y, Panel.Text);
end;

function TWriteForm.IsShortCut(var Message: TWMKey): Boolean;
begin
  if AAList.Visible and AAList.Focused then
    result := false
  else
    result := inherited IsShortCut(Message);
end;

{beginner}
procedure TWriteForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  MainWnd.PopupHint.ReleaseHandle;
end;
{/beginner}

{aiai}
procedure TWriteForm.ToolButtonRecordNameMailClick(Sender: TObject);
begin
  Config.wrtRecordNameMail := not Config.wrtRecordNameMail;
  ToolButtonRecordNameMail.Down := Config.wrtRecordNameMail;
  JLWritePanel.SetRecordNameMailCheckBox(Config.wrtRecordNameMail);
end;

procedure TWriteForm.ToolButtonTrimClick(Sender: TObject);
begin
  Config.wrtTrimRight := not Config.wrtTrimRight;
  ToolButtonTrim.Down := Config.wrtTrimRight;
  JLWritePanel.SetTrimRightCheckBox(Config.wrtTrimRight);
end;

procedure TWriteForm.ToolButtonWriteWaitClick(Sender: TObject);
begin
  Config.wrtUseWriteWait := not Config.wrtUseWriteWait;
  ToolButtonWriteWait.Down := Config.wrtUseWriteWait;
  JLWritePanel.SetWriteWait(Config.wrtUseWriteWait);
end;

procedure TWriteForm.ToolButtonNameWarnClick(Sender: TObject);
begin
  Config.wrtNameMailWarning := not Config.wrtNameMailWarning;
  ToolButtonNameWarn.Down := Config.wrtNameMailWarning;
  JLWritePanel.SetNameMailWarning(Config.wrtNameMailWarning);
end;

procedure TWriteForm.ToolButtonBeLoginClick(Sender: TObject);
begin
  Config.wrtBeLogin := not Config.wrtBeLogin;
  ToolButtonBeLogin.Down := Config.wrtBeLogin;
  JLWritePanel.SetBeLogin(Config.wrtBeLogin);
end;

procedure TWriteForm.WaitTimerStart;
var
  DomainName: String;
  HostName: String;
  text: String;
  i: Integer;
  WaitTime: Cardinal;
begin
  DomainName := Board.host;
  HostName := LeftStr(DomainName, AnsiPos('.', DomainName) - 1);
  WaitTime := 0;

  for i := 0 to Config.waitTimeList.Count - 1 do
    if 0 < AnsiPos(hostname, Config.waitTimeList.Strings[i]) then begin
      text := Config.waitTimeList.Strings[i];
      WaitTime := StrToIntDef(RightStr(text, Length(text) - AnsiPos('=', text)), 0);
      break;
    end;

  if WaitTime > 0 then
  begin
    MainWnd.WriteWaitTimer.Start(DomainName, WaitTime * 1000);
    Log('書き込み待機 - ' + DomainName);
    MainWnd.TabControl.Refresh;
    ButtonWrite.Caption := IntToStr(WaitTime);
  end;
end;

procedure TWriteForm.WaitTimerStop;
begin
  MainWnd.WriteWaitTimer.Stop;
end;

procedure TWriteForm.WriteWaitNotify(DomainName: String; Remainder: Integer);
begin
  if not ButtonWrite.Enabled and Assigned(Thread)
    and (0 = AnsiCompareText(DomainName, Thread.GetHost)) then
  begin
    ButtonWrite.Caption := IntToStr(Remainder);
  end;
end;

procedure TWriteForm.WriteWaitEnd;
begin
  ButtonWrite.Enabled := not writing;
  ButtonWrite.Caption := BUTTON_WRITE_CAPTION;
end;
{/aiai}


(* ------------------------------------------------------------------------- *)
procedure SetButtonWriteEnabled(ABool: Boolean);
begin
  if not Assigned(WriteForm) then
    exit;

  WriteForm.ButtonWrite.Enabled := ABool;
end;

end.
