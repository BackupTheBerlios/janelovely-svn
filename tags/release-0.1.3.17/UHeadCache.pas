unit UHeadCache;
(* URLに関するポップアップのキャッシュ *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* 1.5, Sat Sep 18 18:12:05 2004 UTC *)
interface

uses
  Classes, StrUtils, Controls,
  jconvert,
  UAsync, UDat2HTML;

type
  (*-------------------------------------------------------*)
  TUrlHeadCache = class(TStringList)
  private
    procedure OnHead(sender: TAsyncReq);
  public
    function GetContents(const URI: string): string;
    function GetCache(const URI: string): string;
  end;




(*=======================================================*)
implementation
(*=======================================================*)

uses
  Main;

const
  MAX_URL_HINT_ENTRY: integer = 256;

(*=======================================================*)
function TUrlHeadCache.GetContents(const URI: string):string;
var
  i: integer;
  s: string;
  reqType: TAsyncReqRequestType;
begin
  result := '';
  s := '$' + URI;
  if MAX_URL_HINT_ENTRY <= Count then
  begin
    Move(Count -1, 0);
    Strings[0] := s;
  end
  else
    Insert(0, s);

{  case Config.hintForURLUseHead of
  true: reqType := agrtHead;
  else reqType := agrtGet;
  end;
}
  //▼
  if not Config.hintForURLUseHead then
  begin
    reqType := agrtGet;
    if Config.hintCancelGetExt.CommaText <> '' then
    begin
      for i := 0 to Config.hintCancelGetExt.Count -1 do
        if AnsiEndsText(Config.hintCancelGetExt[i], URI) then
        begin
          reqType := agrtHead;
          break;
        end;
    end;
  end else
    reqType := agrtHead;

  LogBeginQuery2;
  if AsyncManager.Get(URI, OnHead, nil, '', 0, Config.hintForURLMaxSize,
                      reqType) = nil then
  begin
    Delete(0);
  end;
  result := '';
end;

function ConvertToShiftJIS(const str: string): string;
begin
  result := ConvertJCode(str, SJIS_OUT);
end;

procedure TUrlHeadCache.OnHead(sender: TAsyncReq);
var
  i: integer;
  s: string;
  server: string;
  cookie: string;
  tmp: string;
  // ▼ Nightly version 1.5, 2004/09/18 18:12:05 UTC by view HTMLひんとのGETで内容によってはJaneがフリーズする不具合を修正
  content: WideString;
  chopped: WideString;
  p1, p2, r, l: Integer;
  // ▲ Nightly version 1.5, 2004/09/18 18:12:05 UTC by view HTMLひんとのGETで内容によってはJaneがフリーズする不具合を修正
begin
  LogEndQuery;
  MainWnd.WriteStatus('');
  s := '$' + sender.URI;
  i := IndexOf(s);
  if 0 <= i then
  begin
    Move(i, 0);
    server := sender.IdHTTP.Response.RawHeaders.Values['Server'];
    cookie := sender.IdHTTP.Response.RawHeaders.Values['Set-Cookie'];
    tmp := '';
    if 0 < length(server) then
      tmp := tmp + 'Server: ' + server + #13#10;
    if 0 < length(cookie) then
      tmp := tmp + 'Set-Cookie: ' + cookie + #13#10;
  // ▼ Nightly version 1.5, 2004/09/18 18:12:05 UTC by view HTMLひんとのGETで内容によってはJaneがフリーズする不具合を修正
    //Strings[0] := sender.URI + #13#10
    //            + sender.IdHTTP.ResponseText + #13#10
    //            + tmp
    //            + StripBlankLinesForHint(HTML2String(ConvertToShiftJIS(sender.Content)),
    //                                    Config.hintForURLMaxLine);
    content := StripBlankLinesForHint(HTML2String(ConvertToShiftJIS(
      Copy(sender.Content, 1, Config.hintForURLMaxSize))), Config.hintForURLMaxLine);

    l := Length(content);
    SetLength(chopped, l + l div 128);
    p1 := 1;
    p2 := 1;
    r := 0;
    while p1 <= l do
    begin
      chopped[p2] := content[p1];
      inc(p2);
      if content[p1] in [WideChar(#13), WideChar(#10)] then
        r := 0
      else
        Inc(r);
      if r >= 128 then
      begin
        chopped[p2] := #10;
        inc(p2);
        r := 0;
      end;
      inc(p1);
    end;
    SetLength(chopped, p2 - 1);

    Strings[0] := sender.URI + #13#10 + sender.IdHTTP.ResponseText + #13#10 + tmp + chopped;
  // ▲ Nightly version 1.5, 2004/09/18 18:12:05 UTC by view HTMLひんとのGETで内容によってはJaneがフリーズする不具合を修正
    if MainWnd.Active and MouseInPane(MainWnd.WebPanel) then
      MainWnd.ShowHint(Mouse.CursorPos, Strings[0], Config.hintForURLWidth, Config.hintForURLHeight);
  end;
end;

function TUrlHeadCache.GetCache(const URI: string): string;
var
  i: integer;
  s: string;
begin
  if AnsiContainsText(URI, '.2ch.net/') then
  begin
    result := URI + #13#10 + '2ちゃんねるのどこかだと思われ';
    exit;
  end;
  if AnsiContainsText(URI, '.bbspink.com/') then
  begin
    result := URI + #13#10 + '大人の時間みたいですけど';
    exit;
  end;
  s := URI + #13#10;
  for i := 0 to Count -1 do
  begin
    if AnsiStartsText(s, Strings[i]) then
    begin
      result := Strings[i];
      Move(i, 0);
      exit;
    end;
  end;
  result := '';
end;

end.
