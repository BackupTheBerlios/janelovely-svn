unit WriteSub;

interface

uses
  Windows, Classes, SysUtils, StrUtils, U2chThread, U2chBoard, IdURI,
  UXTime, UAsync, StrSub, UViewItem, DateUtils, UDat2HTML, UCrypt,
  HogeTextView, StdCtrls;

type
  TPostType = (postNormal, postCheck);
  TFormType = (formWrite, formBuild);

const
  MORNINGCOFFEE_NAME = '名無し募集中。。。';

  BBS_LINE_NUMBER   = 'BBS_LINE_NUMBER';
  BBS_MESSAGE_COUNT = 'BBS_MESSAGE_COUNT';
  BBS_SUBJECT_COUNT = 'BBS_SUBJECT_COUNT';
  BBS_NAME_COUNT    = 'BBS_NAME_COUNT';
  BBS_MAIL_COUNT    = 'BBS_MAIL_COUNT';

  BUTTON_WRITE_CAPTION = '書き込む(&W)';


function PostArticle(TargetBoard: TBoard;
  TargetThread: TThreadItem; const AName, AMail, AMsg, ATitle: string;
  formType: TFormType; PostType: TPostType; PostCode: String;
  settingTxt: TStrings; OnWritten: TAsyncDone;
  OnNotify: TAsyncNotify; OnPostDone: TNotifyEvent
  ): TAsyncReq;
procedure SaveKakikomi(const title, url, name, mail, msg: string);
function MessageCount(Msg: String): Integer;
function PreWriteWarning(const AName, AMail, AMsg, ATitle: string;
  const settingTxt: TStrings; const thread: TThreadItem; const board: TBoard;
  const BBSNameCount, BBSMailCount, BBSMessageCount, BBSLineNumber, BBSSubjectCount: Integer;
  const LineCount: Integer; const formType: TFormType): Boolean;
procedure CreatePreView(View: TFlexViewItem; Browser: THogeTextView;
  thread: TThreadItem; board: TBoard;
  const AName, AMail, AMsg: string; const settingTxt: TStrings);
procedure SetNameBox(NameCombo: TCombobox; NameList: TStringList;
  const Board: string);

implementation

uses
  Main, U2chTicket, HTTPSub, jconvert, UWriteForm;

var
  procPost: TAsyncReq;

function PostArticle(TargetBoard: TBoard;
  TargetThread: TThreadItem; const AName, AMail, AMsg, ATitle: string;
  formType: TFormType; PostType: TPostType; PostCode: String;
  settingTxt: TStrings; OnWritten: TAsyncDone;
  OnNotify: TAsyncNotify; OnPostDone: TNotifyEvent
  ): TAsyncReq;
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
      {aiai}
      if TargetBoard.NeedConvert then
      begin
        if (AName = '') and (TargetBoard.bbs = 'morningcoffee') then
          encName := URLEncode(sjis2euc(MORNINGCOFFEE_NAME))
        else
          encName := URLEncode(sjis2euc(AName));
        encMail := URLEncode(sjis2euc(AMail));
      end else
      begin
        if (AName = '') and (TargetBoard.bbs = 'morningcoffee') then
          encName := URLEncode(MORNINGCOFFEE_NAME)
        else
          encName := URLEncode(AName);
        encMail := URLEncode(AMail);
      end;
      {/aiai}
      case formType of
      formWrite:
        begin
          case postType of
          postNormal:
            begin
              URI := 'http://' + TargetBoard.host + '/test/bbs.cgi';
              if TargetBoard.NeedConvert then
                postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(AMsg))
                         + '&bbs='  + TargetBoard.bbs
                         + '&key='  + ChangeFileExt(TargetThread.datName, '')
                         + '&time=' + IntToStr(TargetBoard.timeValue)
              else
                postDat := 'submit=' + URLEncode('書き込む')
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(AMsg)
                         + '&bbs='  + TargetBoard.bbs
                         + '&key='  + ChangeFileExt(TargetThread.datName, '')
                         + '&time=' + IntToStr(TargetBoard.timeValue);
            end;
          postCheck:
            begin
              URI := 'http://' + TargetBoard.host + '/test/subbbs.cgi';
              if TargetBoard.NeedConvert then
                postDat := 'bbs='  + TargetBoard.bbs
                         + '&key='  + ChangeFileExt(TargetThread.datName, '')
                         + '&time=' + IntToStr(TargetBoard.timeValue)
                         + '&subject='
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(AMsg))
                         + '&code='  + postCode
                         + '&submit=' + URLEncode(sjis2euc('全責任を負うことを承諾して書き込む'))
              else
                postDat := 'bbs='  + TargetBoard.bbs
                         + '&key='  + ChangeFileExt(TargetThread.datName, '')
                         + '&time=' + IntToStr(TargetBoard.timeValue)
                         + '&subject='
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(AMsg)
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
              URI := 'http://' + TargetBoard.host + '/test/bbs.cgi';
              if TargetBoard.NeedConvert then
                postDat := 'subject=' + URLEncode(sjis2euc(ATitle))
                         + '&submit=' + URLEncode(sjis2euc('新規スレッド作成'))
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(AMsg))
                         + '&bbs='  + TargetBoard.bbs
                         + '&time=' + IntToStr(TargetBoard.timeValue)
              else
                postDat := 'subject=' + URLEncode(ATitle)
                         + '&submit=' + URLEncode('新規スレッド作成')
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(AMsg)
                         + '&bbs='  + TargetBoard.bbs
                         + '&time=' + IntToStr(TargetBoard.timeValue);
            end;
          postCheck:
            begin
              URI := 'http://' + TargetBoard.host + '/test/subbbs.cgi';
              if TargetBoard.NeedConvert then
                postDat := 'subject=' + URLEncode(sjis2euc(ATitle))
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(sjis2euc(AMsg))
                         + '&bbs='  + TargetBoard.bbs
                         + '&time=' + IntToStr(TargetBoard.timeValue)
                         + '&submit=' + URLEncode(sjis2euc('全責任を負うことを承諾して書き込む'))
              else
                postDat := 'subject=' + URLEncode(ATitle)
                         + '&FROM=' + encName
                         + '&mail=' + encMail
                         + '&MESSAGE=' + URLEncode(AMsg)
                         + '&bbs='  + TargetBoard.bbs
                         + '&time=' + IntToStr(TargetBoard.timeValue)
                         + '&submit=' + URLEncode('全責任を負うことを承諾して書き込む');
            end;
          end;
        end;
      end;
      postDat := postDat + ticket2ch.GetSID(URI, '&');
    end;
  bbsJBBSShitaraba:
    begin
      encName := URLEncode(sjis2euc(AName));
      encMail := URLEncode(sjis2euc(AMail));
      URI := 'http://' + Config.bbsJBBSServers[0] + '/bbs/write.cgi';
      case formType of
      formWrite:
        begin
          postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(sjis2euc(AMsg))
                   + '&DIR=' + GetJBBSShitarabaCategory(TargetBoard.host)
                   + '&BBS='  + TargetBoard.bbs
                   + '&KEY='  + ChangeFileExt(TargetThread.datName, '')
                   + '&TIME=' + IntToStr(UTC);
        end;
      formBuild:
        begin
          postDat := 'SUBJECT=' + URLEncode(sjis2euc(ATitle))
                   + '&submit=' + URLEncode(sjis2euc('新規書き込み'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(sjis2euc(AMsg))
                   + '&DIR=' + GetJBBSShitarabaCategory(TargetBoard.host)
                   + '&BBS='  + TargetBoard.bbs
                   + '&TIME=' + IntToStr(UTC);
        end;
      end;
    end;
  bbsMachi, bbsJBBS:
    begin
      encName := URLEncode(AName);
      encMail := URLEncode(AMail);
      URI := 'http://' + TargetBoard.host + '/bbs/write.cgi';
      case formType of
      formWrite:
        begin
          postDat := 'submit=' + URLEncode(sjis2euc('書き込む'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(AMsg)
                   + '&BBS='  + TargetBoard.bbs
                   + '&KEY='  + ChangeFileExt(TargetThread.datName, '')
                   + '&TIME=' + IntToStr(UTC);
        end;
      formBuild:
        begin
          postDat := 'SUBJECT=' + URLEncode(ATitle)
                   + '&submit=' + URLEncode(sjis2euc('新規書き込み'))
                   + '&NAME=' + encName
                   + '&MAIL=' + encMail
                   + '&MESSAGE=' + URLEncode(AMsg)
                   + '&BBS='  + TargetBoard.bbs
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
    URIObj := TIdURI.Create(TargetBoard.GetURIBase + '/');
    referer := URIObj.URI;
  finally
    URIObj.Free;
  end;
  cookie := 'Cookie: NAME=' + encName + '; MAIL=' + encMail;
  list := TStringList.Create;
  {aiai}
  if (TargetBoard.GetBBSType = bbs2ch) then
  begin
    if (0 < length(Config.wrtBEIDDMDM)) and (0 < length(Config.wrtBEIDMDMD)) then
      if Config.wrtBeLogin or AnsiStartsStr('be', TargetBoard.host)
        {or AnsiStartsStr('live14', board.host)}
        or (SettingTxt.Values['BBS_BE_ID'] = '1') then
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
    OnPostDone(nil);
  end;
  list.Free;
  Result := procPost;
end;


//書き込み履歴保存部分を分離
procedure SaveKakikomi(const title, url, name, mail, msg: string);
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
    kakikomistr.Add('Subject: ' + title);
    kakikomistr.Add('URL    : ' + url);
    kakikomistr.Add('FROM   : ' + name);
    kakikomistr.Add('MAIL   : ' + mail);
    kakikomistr.Add('');
    kakikomistr.Add(msg);
    kakikomistr.Add('');
    kakikomistr.Add('');

    kakikomiFile.Seek(0, soFromEnd);
    kakikomiFile.Write(PChar(kakikomistr.Text)^, length(kakikomistr.Text));
  finally
    kakikomistr.Free;
    FreeAndNil(kakikomiFile);  //書き込み後ファイルを閉じる
  end;
end;

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

class function Trip(const Key: string): string;
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

function Res2Dat(const Name, Mail, Msg: string;
  settingTxt: TStrings; bbsType: TBBSType; NeedConvert: Boolean): string;

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
      if NeedConvert then
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
  if Name <> '' then
  begin
    if bbsType = bbs2ch then
      aName := StringReplace(Name, '&r', '', [rfReplaceAll])
    else
      aName := Name;
  end else
    aName := SettingTxt.Values['BBS_NONAME_NAME'];

  aMail := Mail;
  aDate := FormatDateTime('yy/mm/dd hh:nn:mm', Now);
  if SameText(SettingTxt.Values['BBS_FORCE_ID'], 'checked') then
    aDate := aDate + ' ID:xxxxxxxxxx'
  else if (SettingTxt.Values['BBS_NO_ID'] = '') or
          SameText(SettingTxt.Values['ID_DISP'], 'show') then
    if Length(aMail) = 0 then
      aDate := aDate + ' ID:xxxxxxxxxx'
    else
      aDate := aDate + ' ID:???';

  aMessage := Msg;

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
  if SameText(SettingTxt.Values['BBS_UNICODE'], 'change') then
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

function PreWriteWarning(const AName, AMail, AMsg, ATitle: string;
  const settingTxt: TStrings; const thread: TThreadItem; const board: TBoard;
  const BBSNameCount, BBSMailCount, BBSMessageCount, BBSLineNumber, BBSSubjectCount: Integer;
  const LineCount: Integer; const formType: TFormType): Boolean;
var
  WarningList: TStringList;
  Lines: Integer;
  ActView: TViewItem;
begin
  Result := False;

  WarningList := nil;
  try
    WarningList := TStringList.Create;
    if board.bbs = 'morningcoffee' then
    begin
      if Config.wrtNameMailWarning and (AName <> MORNINGCOFFEE_NAME) then
        WarningList.Add('コテハンで書き込みます。');
    end else
    begin
      if AName = '' then
      begin
        if pos('fusianasan', SettingTxt.Values['BBS_NONAME_NAME']) > 0 then
          WarningList.Add('この板のデフォルトの名無しはfusianasan(IP表示)です。')
        else if SettingTxt.Values['NANASHI_CHECK'] = '1' then
          WarningList.Add('名前強制入力の板です。');
      end
      else if Config.wrtNameMailWarning
             and (AName <> SettingTxt.Values['BBS_NONAME_NAME']) then
        WarningList.Add('コテハンで書き込みます。');
    end;


    if Config.wrtNameMailWarning and (AMail <> '')
            and  (AMail <> 'sage') then
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

    if not AnsiStartsStr('be', board.host)
      and not (SettingTxt.Values['BBS_BE_ID'] = '1')
        and Config.wrtBeLogin and (Length(Config.wrtBEIDDMDM) > 0)
          and (Length(Config.wrtBEIDMDMD) > 0) then
      Warninglist.Add('Beにログインして書き込みます。');

    if formType = formBuild then
      if Length(ATitle) <= 0 then
        WarningList.Add('スレタイが空です。')
      else if MessageCount(ATitle) > BBSSubjectCount then
        WarningList.Add('スレタイが長すぎです。');
    if Length(AMsg) <= 0 then
      WarningList.Add('メッセージが空です。')
    else if (BBSMessageCount > 0) and (MessageCount(AMsg) > BBSMessageCount) then
      WarningList.Add('メッセージが長すぎです。');
    if MessageCount(AName) > BBSNameCount then
      WarningList.Add('名前欄が長すぎです。');
    if MessageCount(AMail) > BBSMailCount then
      WarningList.Add('メール欄が長すぎです。');


    Lines := LineCount;
    if (AMsg <> '') and (AMsg[Length(AMsg)] = #10) then
      Inc(Lines);
    if (BBSLineNumber > 0) and (Lines > BBSLineNumber * 2) then
      WarningList.Add('改行が多すぎです。');

    if WarningList.Count > 0 then
    begin
      WarningList.Add('');
      WarningList.Add('書き込みますか？');
      // MessageDlgだと最前面フォームに隠れてしまう
      if MessageBox(MainWnd.Handle, PChar(WarningList.Text), '警告', MB_ICONEXCLAMATION or MB_OKCANCEL) <> IDOK then
        Exit;
    end;
  finally
    WarningList.Free;
  end;
  Result := True;
end;

procedure CreatePreView(View: TFlexViewItem; Browser: THogeTextView;
  thread: TThreadItem; board: TBoard;
  const AName, AMail, AMsg: string; const settingTxt: TStrings);

  function MakeDummyDat(line: Integer):string;
  const
    dummyDat : string = '<><><><>'#10;
  begin
    Result := DupeString(dummyDat, line);
  end;

  function ZoomToPoint(zoom: integer): Integer;
  begin
    result := -12;
  end;

const
  HeaderSkin = '<html><body><font face="ＭＳ Ｐゴシック"><dl>';
var
  TempStream: TDat2PreViewView;
  dat: TThreadData;
  PreViewD2HTML: TDat2HTML;
  ResSkin: String;
begin

  View.Base := '';
  Browser.HoverTime := Config.hintHoverTime;
  Browser.Clear;

  TempStream := TDat2PreViewView.Create(Browser);
  if AMail = '' then
    ResSkin := '<dt><SA i=1><b><PLAINNUMBER/></b><SA i=0> ：<SA i=2><b><NAME/></b></b><SA i=0>[<MAIL/>] ：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10
  else
    ResSkin := '<dt><SA i=1><b><PLAINNUMBER/></b><SA i=0> ：<SA i=1><b><NAME/></b></b><SA i=0>[<MAIL/>] ：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10;
  PreViewD2HTML := TDat2HTML.Create(ResSkin, '');
  dat := TThreadData.Create;

  try
    Browser.ExternalLeading := 1;//ZoomToExternalLeading(Config.viewZoomSize);
    Browser.SetFont(Browser.Font.Name, ZoomToPoint(Config.viewZoomSize));
    TempStream.WriteHTML(HeaderSkin);
    TempStream.Flush;
    if Assigned(thread) then
    begin
      View.thread := thread;
      dat.Add(MakeDummyDat(thread.lines));
      if Assigned(board) then
        dat.Add(Res2Dat(AName, AMail, AMsg, settingTxt, board.GetBBSType,
        board.NeedConvert))
      else
        dat.Add(Res2Dat(AName, AMail, AMsg, settingTxt, bbsNone, False));
      PreViewD2HTML.ToDatOut(TempStream, dat, thread.lines + 1, 1)
    end else
    begin
      if Assigned(board) then
        dat.Add(Res2Dat(AName, AMail, AMsg, settingTxt, board.GetBBSType,
        board.NeedConvert))
      else
        dat.Add(Res2Dat(AName, AMail, AMsg, settingTxt, bbsNone, False));
      PreViewD2HTML.ToDatOut(TempStream, dat, 1, 1);
    end;
    TempStream.Flush;
  finally
    dat.Free;
    PreViewD2HTML.Free;
    TempStream.Free;
  end;
end;

procedure SetNameBox(NameCombo: TCombobox; NameList: TStringList;
  const Board: string);
var
  i: Integer;
  tkBoard, tkName: string;
begin
  NameCombo.Items.Clear;
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

end.
