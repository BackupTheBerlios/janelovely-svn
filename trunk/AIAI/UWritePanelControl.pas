unit UWritePanelControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, ComCtrls, StdCtrls,
  Graphics, DateUtils, StrUtils, Dialogs, IMM,
  JConfig, HogeTextView, jconvert, StrSub, U2chBoard,
  U2chThread, UViewItem, UDat2HTML, UCrypt, UXTime, U2chTicket, UAsync,
  HTTPSub, IdURI, WriteSub, TntStdCtrls;

const
  MORNINGCOFFEE_NAME = '名無し募集中。。。';
  WRITE_BUTTON_CAPTION_A  = '書込(Shift+Enter)';
  WRITE_BUTTON_CAPTION_B  = 'あと';
  WRITE_BUTTON_CAPTION_C  = '秒';

  TABSHEET_WRITE      = 0;
  TABSHEET_PREVIEW    = 1;
  TABSHEET_SETTINGTXT = 2;
  TABSHEET_RESULT     = 3;

type

  TWidthHeight = packed record
    Width: Integer;
    Height: Integer;
  end;

  TRSListBox = class(TListBox)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;



  TWritePanelControl = class(TObject)
  private
    PreView: THogeTextView;
    PreViewItem: TFlexViewItem;
    FBBSCount: TBBSCount;
    FBoard: TBoard;
    FThread: TThreadItem;
    postType: TPostType;
    postCode: string;
    procPost: TAsyncReq;
    writeRetryCount: integer;
    cookieRetryCount: integer;
    TargetThread: TThreadItem;
    TargetBoard: TBoard;
    AAList: TRSListBox;
    PanelColor: array[0..2] of TColor;  //パネルの数だけ確保
    procedure PasteAA;

    procedure UnableWrite;
    procedure EnableWrite;
    procedure SetBoard(ABoard: TBoard);
    procedure SetNameMail;
    procedure SaveNameMailToList;
    procedure OnNotify(sender: TAsyncReq; code: TAsyncNotifyCode);
    procedure OnWritten(sender: TAsyncReq);
    procedure OnPostDone(Sender: TObject);
    procedure WaitTimerStart;
    procedure WaitTimerStop;
    procedure WaitTimerRestart(const ErrorMsg: String);
    procedure AAListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AAListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AAListExit(Sender: TObject);
  public
    EditNameBox: TComboBox;
    EditMailBox: TComboBox;
    CheckBoxSage: TCheckBox;
    Memo: TTntMemo;
    SettingTxt: TMemo;
    Result: TMemo;
    PageControl: TPageControl;
    WStatusBar: TStatusBar;
    ButtonWrite: TButton;
    constructor Create;
    destructor Destroy; override;
    procedure ChangeStatusBar;
    procedure writeActShowAAListExecute(Sender: TObject);
    procedure ChangeMemoIme;
    procedure SaveMemoIme;
    procedure ToolButtonHandle(Sender: TToolButton; tag: integer);
    procedure Post(thread: TThreadItem);
    procedure MakePreView;
    procedure SetUp;
    procedure SetThread(AThread: TThreadItem);
    procedure SetSettingTxt;
    procedure SetAAList;
    procedure ChangeEnableWrite(AEnabled: Boolean);
    procedure SetMemoText(AText: String);
    procedure ChangeWriteMemoColor;
    procedure ChangeWriteMemoFont;
    procedure ChangePreViewStyle;
    procedure ChangeMainPageControlActiveTab(newTab: integer);
    function SaveAAListBoundsRect(AWidthHeight: TWidthHeight): TWidthHeight;
    procedure WriteWaitNotify(DomainName: String; Remainder: Integer);
    procedure WriteWaitEnd;

    property board: TBoard read FBoard write SetBoard;
  end;

//-------------------------- Util Func --------------------------------------//
procedure ChangeWriteMemoSettingText(ABoard: TBoard);
procedure ChangeWriteMemoStyle;
//---------------------------------------------------------------------------//

implementation

uses  Main, UWriteForm;

//{$DEFINE WRITEPANELDEBUG}


 { TRSListBox }
procedure TRSListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_THICKFRAME;
end;


{ TWritePanelControl }

constructor TWritePanelControl.Create;
begin
  Preview := THogeTextView.Create(MainWnd);
  with PreView do
  begin
    Parent := MainWnd.TabSheetWritePreview;
    Align := alClient;
    LeftMargin := 8;
    TopMargin := 4;
    RightMargin := 8;
    ExternalLeading := 1;
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

  PreViewItem := TFlexViewItem.Create;
  PreViewItem.browser := PreView;
  PreViewItem.RootControl := MainWnd.PageControlWrite;
  PreViewItem.PopUpViewList := popupviewList;

  AAList := TRSListBox.Create(MainWnd);
  With AAList do
  begin
    Parent := MainWnd;
    Hide;
    Align := alCustom;
    Constraints.MinWidth := 100;
    Constraints.MinHeight := 100;
    OnMouseUp := AAListMouseUp;
    OnExit := AAListExit;
    OnKeyDown := AAListKeyDown;
  end;
end;

destructor TWritePanelControl.Destroy;
begin
  PreViewItem.Free;

  inherited Destroy;
end;

procedure TWritePanelControl.MakePreView;
begin
  CreatePreView(PreViewItem, Preview, FThread, FBoard,
    EditNameBox.Text, EditMailBox.Text, Memo.Text, SettingTxt.Lines);
end;

procedure TWritePanelControl.Post(thread: TThreadItem);
var
  temptext: String;
begin
  inherited;

  TargetThread := thread;

  if TargetThread <> FThread then
  begin
    tempText :=  'なんかおかしくなった' + #13#10 +
                 '見てるスレ：' + HTML2String(FThread.title) + #13#10 +
                 '書込みスレ：' + HTML2String(TargetThread.title);
    MessageBox(0, PChar(tempText), '警告', MB_ICONEXCLAMATION);
    TargetThread := nil;
    exit;
  end;

  TargetBoard := TBoard(TargetThread.board);

  if TargetBoard <> FBoard then
  begin
    tempText :=  'なんかおかしくなった' + #13#10 +
                 '見てるスレの板：' + HTML2String(FBoard.name) + #13#10 +
                 '書込みスレの板：' + HTML2String(TargetBoard.name);
    MessageBox(0, PChar(tempText), '警告', MB_ICONEXCLAMATION);
    TargetBoard := nil;
    exit;
  end;

  if Config.wrtTrimRight then //末尾整形
    Memo.Text := TrimRight(Memo.Text);

  if not PreWriteWarning(EditNameBox.Text,
    EditMailBox.Text, Memo.Text,
    '', SettingTxt.Lines, TargetThread, TargetBoard,
    Memo.Lines.Count, formWrite) then //警告関係
    exit;

  if (postType = postCheck) and Memo.Modified then
    postType := postNormal;

  writeRetryCount := 0;
  cookieRetryCount := 0;
  Result.Clear;

  ProcPost := PostArticle(TargetBoard, TargetThread, EditNameBox.Text,
    EditMailBox.Text, Memo.Text, '', formWrite,
    postType, PostCode, SettingTxt.Lines, OnWritten,
    OnNotify, OnPostDone);

  Memo.Modified := false;

  //▼シフト押してたらリストに追加
  if GetKeyState(VK_SHIFT) < 0 then
    SaveNameMailToList;

  if Config.wrtRecordNameMail then //521 Name・Mailの記憶・最終書込
  begin
    TargetThread.UsedWriteName := EditNameBox.Text;
    TargetThread.UsedWriteMail := '!' + EditMailBox.Text;
    TargetThread.SaveIndexData;
  end;
end;

procedure TWritePanelControl.PasteAA;
var
  text: string;
  index: integer;
begin
  text := AAList.Items[AAList.ItemIndex];
  if StartWith('*', text, 1) then
  begin
    index := 0;
    while (CompareStr('['+ Copy(text, 2, Length(text) - 1) + ']',
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

procedure TWritePanelControl.ToolButtonHandle(Sender: TToolButton; tag: integer);
var
  SaveDialog: TSaveDialog;
  OpenDialog: TOpenDialog;
begin
  Case tag of

    0: //SaveToFile
      begin
        SaveDialog := TSaveDialog.Create(nil);
        SaveDialog.Filter := 'テキストファイル(*.txt)|*.txt|すべてのファイル|*';
        if SaveDialog.Execute then
          Memo.Lines.SaveToFile(SaveDialog.FileName);
        SaveDialog.Free;
      end;
    1: //LoadFromFile
      begin
        OpenDialog := TOpenDialog.Create(nil);
        OpenDialog.Filter := 'テキストファイル(*.txt)|*.txt|すべてのファイル|*';
        if OpenDialog.Execute then
          Memo.Lines.LoadFromFile(OpenDialog.FileName);
        OpenDialog.Free;
      end;
    2: //Clear
      begin
        Memo.Lines.Clear;
        ChangeStatusBar;
        if PageControl.ActivePageIndex = TABSHEET_PREVIEW then
          MakePreView;
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
        if Assigned(WriteForm) then
          WriteForm.ToolButtonWriteWait.Down := Config.wrtUseWriteWait;
      end;
    6: //NameMailWarning
      begin
        Config.wrtNameMailWarning := not Config.wrtNameMailWarning;
        Sender.Down := Config.wrtNameMailWarning;
        if Assigned(WriteForm) then
          WriteForm.ToolButtonNameWarn.Down := Config.wrtNameMailWarning;
      end;
    7: //BeLogin
      begin
        Config.wrtBeLogin := not Config.wrtBeLogin;
        Sender.Down := Config.wrtBeLogin;
        if Assigned(WriteForm) then
          WriteForm.ToolButtonBeLogin.Down := Config.wrtBeLogin;
      end;

  end; //Case
end;

procedure TWritePanelControl.ChangeStatusBar;
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

  tmpColor := MainWnd.WritePanel.Color;
  if FBBSCount.linenumber > 0 then
    if Lines > FBBSCount.linenumber * 2 then
      tmpColor := $007f7fff
    else if Lines > FBBSCount.linenumber then
      tmpColor := $007fffff;
  PanelColor[1] := tmpColor;

  tmpTxt := Format('%4d',[Lines]);
  if FBBSCount.linenumber > 0 then
    WStatusBar.Panels[1].Text := Format('Lines: %4d/%4d',[Lines, FBBSCount.linenumber * 2])
  else
    WStatusBar.Panels[1].Text := Format('Lines: %4d/ 不明',[Lines]);

  MsgCnt := MessageCount(Memo.Text);

  if (FBBSCount.messagecount > 0) and (MsgCnt > FBBSCount.messagecount) then
    PanelColor[0] := $007f7fff
  else
    PanelColor[0] := clBtnFace;

  tmpTxt := Format('%4d',[Length(Memo.Text)]);
  if FBBSCount.messagecount > 0 then
    WStatusBar.Panels[0].Text := Format('Bytes: %6d/%6d',[MsgCnt, FBBSCount.messagecount])
  else
    WStatusBar.Panels[0].Text := Format('Bytes: %6d/  不明',[MsgCnt]);
end;


(* Imeを設定 *)
procedure TWritePanelControl.ChangeMemoIme;
begin
  inherited;

  if Config.optWriteMemoImeMode then
    Memo.ImeMode := imOpen
  else
    Memo.ImeMode := imClose;
end;

(* Imeを保存 *)
procedure TWritePanelControl.SaveMemoIme;
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

procedure TWritePanelControl.UnableWrite;
begin
  FBBSCount.linenumber := 0;
  FBBSCount.messagecount := 0;
  FBBSCount.subjectcount := High(Integer);
  FBBSCount.namecount := High(Integer);
  FBBSCount.mailcount := High(Integer);
  SettingTxt.Clear;
  ChangeStatusBar;
end;

procedure TWritePanelControl.EnableWrite;
begin
end;

procedure TWritePanelControl.SetBoard(ABoard: TBoard);
begin
  if (ABoard <> nil) and (ABoard <> FBoard) then
  begin
    FBoard := ABoard;
    {$IFDEF WRITEPANELDEBUG}
    Main.Log('SettingTxt:ChangeBoard:' + FBoard.name);
    {$ENDIF}
    SetSettingTxt;
    WriteSub.SetNameBox(EditNameBox, Config.wrtNameList, FBoard.bbs);
  end;
end;

procedure TWritePanelControl.SetNameMail;
var
  SageCheckBoxCheck: TNotifyEvent;
begin
  //名前
  if FThread.UsedWriteMail <> '' then
    EditNameBox.Text := FThread.UsedWriteName
  else if (FThread.UsedWriteMail = '') and // 記憶されてないスレ(記憶されたスレには必ず!が入る)
          Config.wrtUseDefaultName and (EditNameBox.Items.Count > 0) then
    EditNameBox.Text := EditNameBox.Items[0]
  else if FBoard.bbs = 'morningcoffee' then
    EditNameBox.Text := '名無し募集中。。。'
  else
    EditNameBox.Text := SettingTxt.Lines.Values['BBS_NONAME_NAME'];

  EditNameBox.SelStart := 0;

  //メール
  SageCheckBoxCheck := CheckBoxSage.OnClick;
  EditMailBox.OnClick := nil;
  CheckBoxSage.Checked := false;
  CheckBoxSage.OnClick := SageCheckBoxCheck;

  if FThread.UsedWriteMail <> '' then
    EditMailBox.Text := FThread.UsedWriteMail
  else if Config.wrtDefaultSageCheck then
    EditMailBox.Text := 'sage'
  else
    EditMailBox.Text := '';

  if AnsiStartsStr('!',EditMailBox.Text) then
    EditMailBox.Text := Copy(EditMailBox.Text, 2, length(EditMailBox.Text) - 1);
end;

procedure TWritePanelControl.SaveNameMailToList;
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
  if EditNameBox.Text <> '' then
  begin
    if GetKeyState(VK_CONTROL) < 0 then
      BoardName := '<'+ FBoard.bbs + '>' + EditNameBox.Text
    else if TagExist(EditNameBox.Text) then
      BoardName := '<*>' + EditNameBox.Text
    else
      BoardName := EditNameBox.Text;

    if Config.wrtNameList.IndexOf(BoardName) < 0 then
    begin
      Config.wrtNameList.Add(BoardName);
      SetNameBox(EditNameBox, Config.wrtNameList, FBoard.bbs);
    end;
  end;

  if EditMailBox.Text <> '' then
  begin
    if not CheckBoxSage.Checked and (Config.wrtMailList.IndexOf(EditMailBox.Text) < 0) then
    begin
      Config.wrtMailList.Add(EditMailBox.Text);
      EditMailbox.Items := config.wrtMailList;
    end;
  end;

  if (EditNameBox.Text <> '') or (EditMailBox.Text <> '') then
    Config.Modified := true;

end;

procedure TWritePanelControl.OnNotify(sender: TAsyncReq; code: TAsyncNotifyCode);
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

procedure TWritePanelControl.OnPostDone(Sender: TObject);
begin
  MainWnd.PauseToggleAutoReSc(false);
  ButtonWrite.Enabled := false;
  UWriteForm.SetButtonWriteEnabled(false);
  writing := True;
  if Config.wrtUseWriteWait then
    WaitTimerStart;
  Result.Lines.Add('--------------------');
  Result.Lines.Add('書込み中・・・');
  Result.Lines.Add('--------------------');
  ChangeMainPageControlActiveTab(TABSHEET_RESULT);
end;

procedure TWritePanelControl.OnWritten(sender: TAsyncReq);
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

  if TargetBoard.NeedConvert then
    responseHTML := euc2sjis(sender.GetString)
  else
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
      ProcPost := PostArticle(TargetBoard, TargetThread, EditNameBox.Text,
        EditMailBox.Text, Memo.Text, '', formWrite,
        postType, PostCode, SettingTxt.Lines, OnWritten,
        OnNotify, OnPostDone);
      exit;
    end;

    if (2 <= list.Count) and
      AnsiStartsStr('ＥＲＲＯＲ！', list[0]) and
      //AnsiStartsStr('ＥＲＲＯＲ - 593', list[1]) and
      AnsiContainsStr(list[1], ' sec しかたってない') then
      //AnsiContainsStr(list[1], ' sec たたないと書けません。') then
    begin
      if Config.wrtUseWriteWait then
        WaitTimerRestart(list[1]);
      list.Free;
      MainWnd.PauseToggleAutoReSc(true);
      if Assigned(FThread) then
        ButtonWrite.Enabled := not MainWnd.WriteWaitTimer.IsThisHost(FThread.GetHost);
      if Assigned(WriteForm) and Assigned(WriteForm.board) then
        WriteForm.ButtonWrite.Enabled := not MainWnd.WriteWaitTimer.IsThisHost(WriteForm.board.host);
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
      ProcPost := PostArticle(TargetBoard, TargetThread, EditNameBox.Text,
        EditMailBox.Text, Memo.Text, '', formWrite,
        postType, PostCode, SettingTxt.Lines, OnWritten,
        OnNotify, OnPostDone);
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
                                  AnsiContainsStr(list[0], '書き込みました') or
                                  AnsiContainsStr(list[0], '書き込み終了') )))then
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
      SaveKakikomi(TargetThread.title, TargetThread.ToURL(false),
        EditNameBox.Text, EditMailBox.Text,
        Memo.Text);

    viewItem := viewList.FindViewItem(TargetThread);
    if viewItem <> nil then
      viewItem.NewRequest(TargetThread, gotCHECK, -1, True, Config.oprCheckNewWRedraw);
  end;

  if errMsg = 'false' then
  begin
    //Caption := '注意が出ています';
    WaitTimerStop;
    MainWnd.PauseToggleAutoReSc(true);
    exit;
  end;

  Memo.Clear;
  ChangeStatusBar;

  MainWnd.PauseToggleAutoReSc(true);
  ChangeMainPageControlActiveTab(TABSHEET_WRITE);
  if Assigned(FThread) then
    ButtonWrite.Enabled := not MainWnd.WriteWaitTimer.IsThisHost(FThread.GetHost);
  if Assigned(WriteForm) and Assigned(WriteForm.board) then
    WriteForm.ButtonWrite.Enabled := not MainWnd.WriteWaitTimer.IsThisHost(WriteForm.board.host);
  TargetThread := nil;
  TargetBoard := nil;
  try Memo.SetFocus; except end;
end;


procedure TWritePanelControl.WaitTimerStart;
var
  DomainName: String;
  HostName: String;
  text: String;
  i: Integer;
  WaitTime: Cardinal;
begin
  DomainName := TargetThread.GetHost;
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
    UpdateTabColor;
    ButtonWrite.Caption := WRITE_BUTTON_CAPTION_B + IntToStr(WaitTime) + WRITE_BUTTON_CAPTION_C;
  end;
end;

procedure TWritePanelControl.WaitTimerStop;
begin
  MainWnd.WriteWaitTimer.Stop;
end;

procedure TWritePanelControl.WaitTimerRestart(const ErrorMsg: String);

  function GetNumber(const Msg: string): Cardinal;
  var
    i: integer;
    endpos: integer;
    substr: string;
  begin
    endpos := Pos(Msg, ErrorMsg);
    for i := endpos - 1 downto 1 do
      if (ErrorMsg[i] in ['0'..'9']) then
        substr := ErrorMsg[i] + substr
      else
        break;
    result := StrToIntDef(substr, 0);
  end;

  function GetNewWaitTime: Cardinal;
  begin
    result := GetNumber(' sec たたないと書けません。');
  end;

  //function GetElapsedTime: Cardinal;
  //begin
  //  result := GetNumber(' sec しかたってない');
  //end;

var
  DomainName: String;
  HostName: String;
  text: String;
  i, j: Integer;
  WaitTime, newWaitTime{, Remain}: Cardinal;
begin
  if not Assigned(TargetThread) then
  begin
    WaitTimerStop;
    exit;
  end;
  DomainName := TargetThread.GetHost;
  HostName := LeftStr(DomainName, AnsiPos('.', DomainName) - 1);
  WaitTime := 0;
  j := -1;

  for i := 0 to Config.waitTimeList.Count - 1 do
    if 0 < AnsiPos(hostname, Config.waitTimeList.Strings[i]) then begin
      j := i;
      text := Config.waitTimeList.Strings[i];
      WaitTime := StrToIntDef(RightStr(text, Length(text) - AnsiPos('=', text)), 0);
      break;
    end;

  newWaitTime := GetNewWaitTime;
  if newWaitTime = 0 then
    exit;
  if (newWaitTime <> WaitTime) then
  begin
    if j >= 0 then
    begin
      Config.waitTimeList.Delete(j);
      Config.waitTimeList.Insert(j, DomainName + '=' + IntToStr(newWaitTime));
    end else
      Config.waitTimeList.Add(DomainName + '=' + IntToStr(newWaitTime));
    Config.waitTimeList.SaveToFile(Config.BasePath + WRITEWAIT_FILE);
  end;

  //Remain := GetElapsedTime;
  //if Remain > 0 then
  //  Remain := newWaitTime - Remain
  //else
  //  exit;
  MainWnd.WriteWaitTimer.Start(DomainName, newWaitTime * 1000);
  Log('書き込み待機 - ' + DomainName);
  UpdateTabColor;
  ButtonWrite.Caption := WRITE_BUTTON_CAPTION_B + IntToStr(newWaitTime) + WRITE_BUTTON_CAPTION_C;
end;

(* AA入力支援 *)
procedure TWritePanelControl.AAListMouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if  (AAList.ItemIndex > -1) then
    begin
      PasteAA;
    end;
    AAList.Hide;
    Memo.SetFocus;
  end;
end;

procedure TWritePanelControl.AAListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
  begin
    AAList.Hide;
    MainWnd.MemoWriteMain.SetFocus;
  end else
  if (Key = VK_RETURN) then
  begin
    if (AAList.ItemIndex > -2) then
    begin
      PasteAA;
    end;
    AAList.Hide;
    Memo.SetFocus;
  end;
end;

procedure TWritePanelControl.AAListExit(Sender: TObject);
begin
  AAList.Hide;
end;

//------------------- public Procedure --------------------------------------//

procedure TWritePanelControl.SetUp;
begin
  ChangeStatusBar;
  procPost := nil;
  postType := postNormal;
  postCode := '';
  With MainWnd do
  begin
    ToolButtonWriteRecordNameMail.Down  := Config.wrtRecordNameMail;
    ToolButtonWriteTrim.Down            := Config.wrtTrimRight;
    ToolButtonWriteUseWriteWait.Down    := Config.wrtUseWriteWait;
    ToolButtonWriteNameMailWarning.Down := Config.wrtNameMailWarning;
    ToolButtonWriteBelogin.Down         := Config.wrtBeLogin;
  end;

  ChangeWriteMemoStyle
end;

procedure TWritePanelControl.SetThread(AThread: TThreadItem);
var
  SageCheckBoxCheck: TNotifyEvent;
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

  if PageControl.ActivePageIndex = TABSHEET_PREVIEW then
    MakePreView;
  SageCheckBoxCheck := CheckBoxSage.OnClick;
  CheckBoxSage.OnClick := nil;
  if EditMailBox.Text = 'sage' then
  begin
    EditMailBox.Enabled := false;
    CheckBoxSage.Checked := true;
  end
  else begin
    EditMailBox.Enabled := true;
    CheckBoxSage.Checked := false;
  end;
  CheckBoxSage.OnClick := SageCheckBoxCheck;

  if (FThread <> nil)
    and MainWnd.WriteWaitTimer.IsThisHost(FThread.GetHost) then
  begin
    ButtonWrite.Enabled := false;
    ButtonWrite.Caption := WRITE_BUTTON_CAPTION_B + IntToStr(MainWnd.WriteWaitTimer.Remainder)
                         + WRITE_BUTTON_CAPTION_C;
  end else begin
    ButtonWrite.Enabled := not writing and (FThread <> nil)
                           and (FThread.state = tsCurrency)
                           and ((0 < FThread.number) or ThreadIsNew(FThread));
    ButtonWrite.Caption := WRITE_BUTTON_CAPTION_A;
  end;
end;

procedure TWritePanelControl.SetSettingTxt;
begin
  {$IFDEF WRITEPANELDEBUG}
  Main.Log('SettingTxt:UpdateSettingTxt:' + FThread.title);
  {$ENDIF}
  FBoard.LoadSettingTXT;
  SettingTxt.Lines.Text := FBoard.settingText;
  FBBSCount := FBoard.BBSCount;
  ChangeStatusBar;
end;

procedure TWritePanelControl.SetAAList;
var
  index: integer;
begin
  index := 0;

  AAList.Clear;

  if Config.aaAAList.Count <= 0 then
  begin
    MainWnd.MenuAA.Enabled := false;
    MainWnd.MenuAA.Visible := false;
    exit;
  end;

  while (CompareStr('[aalist]', Config.aaAAList.Strings[index]) <> 0) do
  begin
    Inc(index);
    if Config.aaAAList.Count - 1 <= index then
    begin
      MainWnd.MenuAA.Enabled := false;
      MainWnd.MenuAA.Visible := false;
      exit;
    end;
  end;

  Inc(index);
  while not(StartWith('[', Config.aaAAList.Strings[index], 1)) do
  begin
    AAList.Items.Add(Config.aaAAList.Strings[index]);
    if index < Config.aaAAList.Count - 1 then
      Inc(index)
    else
      break;
  end;
  if AAList.items.Count > 0 then
  begin
    MainWnd.MenuAA.Enabled := True;
    MainWnd.MenuAA.Visible := True;
  end;
end;

procedure TWritePanelControl.ChangeEnableWrite(AEnabled: Boolean);
begin
  ButtonWrite.Enabled := AEnabled;
end;

procedure TWritePanelControl.SetMemoText(AText: String);
begin
  Memo.SelText := AText;

  if PageControl.ActivePageIndex = TABSHEET_PREVIEW then
    MakePreView;
end;

procedure TWritePanelControl.writeActShowAAListExecute(Sender: TObject);
var
  point: TPoint;
begin
  if AAlist.Visible then
    try Memo.SetFocus; except end
  else if 0 < AAList.Count then
  begin
    try Memo.SetFocus; except end;
    GetCaretPos(point);
    Point := Memo.ClientToScreen(Point);
    Point := MainWnd.ScreenToClient(Point);
    AAList.Top := Point.Y - Memo.Font.Height;
    if AAList.BoundsRect.Bottom > MainWnd.ClientHeight then
      AAList.Top := Point.Y - AAList.Height;
    AAList.Left :=  point.X + 5;
    if AAList.BoundsRect.Right > MainWnd.ClientWidth then
      AAList.Left := Point.X - AAList.Width - 5;
    AAList.ItemIndex := 0;
    AAList.Show;
    AAList.SetFocus;
  end;
end;

procedure TWritePanelControl.ChangeWriteMemoColor;
begin
  if Memo.Color <> Config.wrtWritePanelColor then
    Memo.Color := Config.wrtWritePanelColor;
end;

procedure TWritePanelControl.ChangeWriteMemoFont;
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

procedure TWritePanelControl.ChangePreViewStyle;
begin
  with PreView do
  begin
    VerticalCaretMargin := Config.viewVerticalCaretMargin;
    WheelPageScroll := Config.viewPageScroll;
    VScrollLines := Config.viewScrollLines;
    EnableAutoScroll := Config.viewEnableAutoScroll;
    Frames := Config.viewScrollSmoothness;
    FrameRate := Config.viewScrollFrameRate;
    Color := RGB($ef, $ef, $ef);
    ConfCaretVisible := Config.viewCaretVisible;
  end;

  if PageControl.ActivePageIndex = TABSHEET_PREVIEW then
    MakePreView;
end;

procedure TWritePanelControl.ChangeMainPageControlActiveTab(newTab: integer);
begin
  MainWnd.PageControlWrite.ActivePageIndex := newTab;
end;

function TWritePanelControl.SaveAAListBoundsRect(AWidthHeight: TWidthHeight): TWidthHeight;
begin
  Result.Width := AAList.Width;
  Result.Height := AAList.Height;

  AAList.Height := AWidthHeight.Height;
  AAList.Width := AWidthHeight.Width;
end;

procedure TWritePanelControl.WriteWaitNotify(DomainName: String; Remainder: Integer);
begin
  if not ButtonWrite.Enabled and Assigned(FThread)
    and (0 = AnsiCompareText(DomainName, FThread.GetHost)) then
  begin
    ButtonWrite.Caption := WRITE_BUTTON_CAPTION_B + IntToStr(Remainder) + WRITE_BUTTON_CAPTION_C;
  end;
end;

procedure TWritePanelControl.WriteWaitEnd;
begin
  ButtonWrite.Enabled := not writing;
  ButtonWrite.Caption := WRITE_BUTTON_CAPTION_A;
end;

(* ----------------------- TWritePanelControl ----------------------------------- *)
(* ------------------------------------------------------------------------- *)
(* ------------------------------------------------------------------------- *)
(* ------------------------------------------------------------------------- *)


//-------------------------- Util Func --------------------------------------//

//板のSETTING.TXTをとりに行った後WriteMemoにセットされているBoardが
//変わっていなければWriteMemoのSETTING.TXTを新しいのにかえる
procedure ChangeWriteMemoSettingText(ABoard: TBoard);
begin
  if not Assigned(WritePanelControl) then exit;

  if WritePanelControl.board = ABoard then
    WritePanelControl.SetSettingTxt;
end;

procedure ChangeWriteMemoStyle;
var
  bname: string;
begin
  WritePanelControl.ChangeWriteMemoColor;
  WritePanelControl.ChangeWriteMemoFont;
  WritePanelControl.ChangePreViewStyle;
  if WritePanelControl.board <> nil then
    bname := WritePanelControl.board.bbs
  else
    bname := '';
  SetNameBox(WritePanelControl.EditNameBox, Config.wrtNameList, bname);
  WritePanelControl.EditMailBox.Items.Assign(Config.wrtMailList);
end;

end.

