unit U2chTicket;
(* Copyright(c) 2002 Twiddle <hetareprog@hotmail.com> *)

interface

uses
  Classes,
  StrUtils,
  StrSub,
  Windows,
  Messages,
  UAsync,
  UDoLib,
  USynchro,
  HTTPSub;

type
  T2chTicket = class(TObject)
  protected
    FLock: THogeCriticalSection;
    FDoLib: THogeDoLib;
    FConfigChanged: boolean;
    procedure Get2chTicket;
    function GetUserAgent: string;
    function GetSessionID: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Reset;
    function GetSID(const URI, glue: string): string;
    function AppendSID(const URI, glue: string): string;
    function Authorized: Boolean;
    procedure On2chPreConnect(sender: TAsyncReq; code: TAsyncNotifyCode);
    (* ‚¿‚å‚Á‚ÆŒ©‚é—p (aiai) *)
    procedure OnChottoPreConnect(sender: TAsyncReq; code: TAsyncNotifyCode);
    procedure OnKuroPreConnect(sender: TAsyncReq; code: TAsyncNotifyCode); //184
    property SessionID: string read GetSessionID;
    property ConfigChanged: boolean read FConfigChanged write FConfigChanged;
  end;



procedure AsyncInitialize;
procedure AsyncUninitialize;
procedure AsyncUpdateConfig;

function Is2ch(const URI: string): boolean;

var
  ticket2ch: T2chTicket;


(*=======================================================*)
implementation
(*=======================================================*)

uses
  Main, JConfig;

(*=======================================================*)
procedure AsyncInitialize;
begin
  ticket2ch := T2chTicket.Create;
end;

procedure AsyncUninitialize;
begin
  ticket2ch.Free;
end;

procedure AsyncUpdateConfig;
begin
  ticket2ch.ConfigChanged := true;
end;

function DomainMatch(const domain, URI: string): boolean;
var
  domainStart: integer;
  domainEnd: integer;
begin
  result := false;
  if FindPosIC('http://', URI, 1) <> 1 then
    exit;
  domainEnd := FindPos('/', URI, 8);
  if domainEnd <= 0 then
    exit;
  domainStart := FindPos('.', URI, 8, domainEnd);
  if domainStart <= 0 then
    domainStart := 8;
  if length(domain) <> domainEnd - domainStart then
    exit;
  result := (0 < FindPosIC(domain, URI, domainStart, domainEnd -1));
end;

function Is2ch(const URI: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to Config.bbs2chServers.Count -1 do
  begin
    if DomainMatch(Config.bbs2chServers.Strings[i], URI) then
      result := true;
  end;
end;

(*=======================================================*)
constructor T2chTicket.Create;
begin
  FDoLib := THogeDoLib.Create;
  FLock := THogeCriticalSection.Create;
  FConfigChanged := false;
  FDoLib.ProductName := Main.KEYWORD_OF_USER_AGENT +'/'+ Main.VERSION;
end;

destructor T2chTicket.Destroy;
begin
  FDoLib.Free;
  FLock.Free;
end;

procedure T2chTicket.Get2chTicket;
  procedure ReGetTicket;
  var
    useProxy: boolean;
    proxy: string;
    port: integer;
    uid: string;
    pwd: string;
    rc: boolean;
  begin
    FLock.Enter;
    if FConfigChanged or not FDoLib.Authorized then
    begin
      Main.Config.proxyCrt.Enter;
      useProxy := Config.netUseProxy;
      proxy := Config.netProxyServerForSSL;
      port := Config.netProxyPortForSSL;
      uid := Config.accUserID;
      pwd := Config.accPasswd;
      Config.proxyCrt.Leave;

      if useProxy and (0 < length(proxy)) and (0 < port) then
      begin
        FDoLib.ProxyServer := proxy;
        FDoLib.ProxyPort := port;
      end
      else begin
        FDoLib.ProxyServer := '';
        FDoLib.ProxyPort   := 0;
      end;
      rc := FDoLib.Login(uid, pwd);
      if not rc then
        Log(FDoLib.ErrorString);
      Windows.PostMessage(MainWnd.Handle, WM_USER, INF_LOGIN, Longint(rc));
      FConfigChanged := false;
    end;
    FLock.Leave;
  end;
begin
  if (FConfigChanged or not FDoLib.Authorized) and Main.Config.tstAuthorizedAccess then
    ReGetTicket;
end;


function T2chTicket.GetUserAgent: string;
var
  ua: string;
begin
  if Main.Config.tstAuthorizedAccess then
  begin
    FLock.Enter;
    if not FDoLib.Authorized then
    begin
      Log('trying to login...');
      Get2chTicket;
      Log('done.');
    end;
    ua := FDoLib.UserAgent;
    FLock.Leave;
    if (length(ua) <= 0) or AnsiStartsStr('ERROR', ua) then
    begin
      Log('LOGIN FAILED');
      result := '';
    end
    else
      result := ua + ' ('
             + Main.KEYWORD_OF_USER_AGENT +'/'+ Main.VERSION +')';
  end
  else begin
    FLock.Enter;
    result := 'Monazilla/' + FDoLib.Version +
             ' (' + Main.KEYWORD_OF_USER_AGENT +'/'+ Main.VERSION +')';
    FLock.Leave;
//    result := 'Mozilla/3.0 (Compatible; Indy Library; '
//           + Main.KEYWORD_OF_USER_AGENT +'/'+ Main.VERSION +')';
  end;
end;


procedure T2chTicket.On2chPreConnect(sender: TAsyncReq; code: TAsyncNotifyCode);
var
  userAgent: string;
begin
  if code <> ancPRECONNECT then
    exit;
  if Is2ch(sender.URI) then
  begin
    userAgent := GetUserAgent;
    if Config.tstEnableHTTPTrace then
      Log('2ch');
    if 0 < length(userAgent) then
      TAsyncReq(sender).IdHTTP.Request.UserAgent := userAgent
    else
      sender.Cancel;
  end
  else if Config.tstEnableHTTPTrace then
    Log('normal');
end;

(* ‚¿‚å‚Á‚ÆŒ©‚é—p (aiai) *)
procedure T2chTicket.OnChottoPreConnect(sender: TAsyncReq;
        code: TAsyncNotifyCode);
var
  userAgent: string;
begin
  if code <> ancPRECONNECT then
    exit;
  if Is2ch(sender.URI) then
  begin
    userAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)';
    if Config.tstEnableHTTPTrace then
      Log('2ch');
    if 0 < length(userAgent) then
      TAsyncReq(sender).IdHTTP.Request.UserAgent := userAgent
    else
      sender.Cancel;
  end
  else if Config.tstEnableHTTPTrace then
    Log('normal');
end;

{184}
procedure T2chTicket.OnKuroPreConnect(sender: TAsyncReq; code: TAsyncNotifyCode);
var
  userAgent: string;
begin
  if code <> ancPRECONNECT then
    exit;
  userAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)';
  TAsyncReq(sender).IdHTTP.Request.UserAgent := userAgent;
  if Config.tstEnableHTTPTrace then
    Log('normal');
end;
{/184}

procedure T2chTicket.Reset;
begin
  FLock.Enter;
  FDoLib.Logout;
  FLock.Leave;
end;

function T2chTicket.GetSessionID: string;
begin
  if Main.Config.tstAuthorizedAccess then
  begin
    FLock.Enter;
    if not FDoLib.Authorized then
    begin
      Log('trying to login...');
      Get2chTicket;
      Log('done');
    end;
    result := FDoLib.SessionID;
    FLock.Leave;
  end
  else
    result := '';
end;

function T2chTicket.GetSID(const URI, glue: string): string;
var
  sessionID: string;
begin
  result := '';
  if Main.Config.tstAuthorizedAccess and Is2ch(URI) then
  begin
    sessionID := GetSessionID;
    if 0 < length(sessionID) then
      result := glue + 'sid=' + URLEncode(sessionID);
  end;
end;

function T2chTicket.AppendSID(const URI, glue: string): string;
var
  sessionInfo: string;
begin
  sessionInfo := GetSID(URI, glue);
  if 0 < length(sessionInfo) then
    result := URI + sessionInfo
  else
    result := URI;
end;

function T2chTicket.Authorized: Boolean;
begin
  result := FDolib.Authorized;
end;

end.
