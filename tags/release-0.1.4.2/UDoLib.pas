unit UDoLib;
(* 2002 Twiddle <hetareprog@hotmail.com> *)

interface
uses
  SysUtils,
  StrUtils,
  Classes,
  {$IFDEF INDYSSL}
  IdHTTP,
  IdSSLOpenSSL,
  {$ELSE}
  Windows,
  IdURI,
  {$ENDIF}
  HTTPSub
  ;


type

  THogeDoLibError = (hdleSUCCESS, hdleCONNECTION, hdleAUTHORIZATION);

  THogeDoLib = class(TObject)
  private
    FRequestURI: string;
    FInternalSessionInfo: string;
    function InternalLogin: Boolean;
  protected
    FSession: Pointer;
    FUID: string;               // user ID
    FPasswd: string;            // password

    FSessionID: string;         // session ID
    FUserAgent: string;         // user-agent as Monazilla
    FProductName: string;       // product-token '/' product-version

    FErrorCode: integer;
    FErrorString: string;
    FErrorType: THogeDoLibError;

    FAuthorized: Boolean;       // True if logged in.

    FProxyServer: string;       // proxy server (SSL)
    FProxyPort: integer;        // proxy port   (SSL)
    FVersion: string;

    FConnectTimeout: Cardinal;
    FReadTimeout: Cardinal;

    function GetVersion: string;
  public
    constructor Create;
    destructor Destroy; override;
    function  Login(const UID, Password: string): boolean;
    procedure Logout;

    property ProductName: string read FProductName write FProductName;
    property Authorized: Boolean read FAuthorized;
    property ErrorCode: integer read FErrorCode;
    property ErrorString: string read FErrorString;
    property ErrorType: THogeDoLibError read FErrorType;
    property ProxyServer: string read FProxyServer write FProxyServer;
    property ProxyPort: integer read FProxyPort write FProxyPort;
    property SessionID: string read FSessionID;
    property UserAgent: string read FUserAgent;
    property Version: string read GetVersion;
    property ConnectTimeout: Cardinal read FConnectTimeout write FConnectTimeout;
    property ReadTimeout: Cardinal read FReadTimeout write FReadTimeout;
    property InternalSessionInfo: string read FInternalSessionInfo;
    property RequestURI: string write FRequestURI;
  end;


(*=======================================================*)
implementation
(*=======================================================*)
const
  X_2CH_USER_AGENT    = 'X-2ch-UA';

const
  DEFAULT_REQUEST_URI = 'https://2chv.tora3.net/futen.cgi';
  DOLIB_USER_AGENT    = 'DOLIB/1.00';
  REQ_KEY_USER_ID     = 'ID';
  REQ_KEY_PASSWORD    = 'PW';
  RSP_KEY_SESSION_ID  = 'SESSION-ID';
  RSP_ERROR_IDENTIFIER= 'ERROR';
  DOLIB_VERSION       = $10000;
  DOLIB_REQUEST_METHOD= 'POST';

{$IFDEF INDYSSL}
function THogeDoLib.InternalLogin: Boolean;
var
  IdHTTP: TIdHTTP;
  PostStream: TStringStream;
  PosColon: integer;
  IOHandler: TIdSSLIOHandlerSocket;
  ResponseData: TStringList;
begin
  result := False;
  IdHTTP := TIdHTTP.Create(nil);
  IdHTTP.AllowCookies := False;
  if 0 < length(FProxyServer) then
  begin
    IdHTTP.ProxyParams.ProxyServer := FProxyServer;
    IdHTTP.ProxyParams.ProxyPort   := FProxyPort;
  end;
  IdHTTP.Request.UserAgent  := DOLIB_USER_AGENT;
  IdHTTP.Request.Connection := 'close';
  IdHTTP.Request.RawHeaders.Add(X_2CH_USER_AGENT + ': ' + FProductName);
  IdHTTP.ReadTimeout := FReadTimeout;
  IOHandler := TIdSSLIOHandlerSocket.Create(nil);
  IdHTTP.IOHandler := IOHandler;
  PostStream := TStringStream.Create(REQ_KEY_USER_ID  + '=' + FUID + '&' +
                                     REQ_KEY_PASSWORD + '=' + FPasswd);
  ResponseData := TStringList.Create;
  FErrorType := hdleSUCCESS;
  try
    FInternalSessionInfo := IdHTTP.Post(FRequestURI, PostStream);
    ResponseData.Text := FInternalSessionInfo;
    FSessionID := ResponseData.Values[RSP_KEY_SESSION_ID];
    PosColon := Pos(':', FSessionID);
    if 0 < PosColon then
      FUserAgent := Copy(FSessionID, 1, PosColon - 1)
    else
      FUserAgent := '';
    result := (0 < length(FUserAgent)) and
              (not AnsiStartsText(RSP_ERROR_IDENTIFIER, FSessionID));
    if not result then
    begin
      FErrorString := 'Authorization failed';
      FErrorType := hdleAUTHORIZATION;
    end;
  except
    On e: Exception do
    begin
      FErrorString := e.Message;
      FErrorType := hdleCONNECTION;
    end;
  end;
  try
    IdHTTP.Disconnect;
  except
  end;
  PostStream.Free;
  IdHTTP.Free;
  IOHandler.Free;
  ResponseData.Free;
end;
{$ELSE}
type
  THINTERNET = Pointer;
  TINTERNET_PORT = Word;
  PPChar = ^PChar;

const
  INTERNET_OPEN_TYPE_PRECONFIG                   = 0;   // use registry configuration
  INTERNET_OPEN_TYPE_DIRECT                      = 1;   // direct to net
  INTERNET_OPEN_TYPE_PROXY                       = 3;   // via named proxy
  INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4;   // prev

  INTERNET_FLAG_ASYNC             = $10000000;  // this request is asynchronous (where supported)
  INTERNET_FLAG_PASSIVE           = $08000000;  // used for FTP connections
  INTERNET_FLAG_NO_CACHE_WRITE    = $04000000;  // don't write this item to the cache
  INTERNET_FLAG_DONT_CACHE        = INTERNET_FLAG_NO_CACHE_WRITE;
  INTERNET_FLAG_MAKE_PERSISTENT   = $02000000;  // make this item persistent in cache
  INTERNET_FLAG_FROM_CACHE        = $01000000;  // use offline semantics
  INTERNET_FLAG_OFFLINE           = INTERNET_FLAG_FROM_CACHE;

  INTERNET_FLAG_SECURE            = $00800000;  // use PCT/SSL if applicable (HTTP)
  INTERNET_FLAG_KEEP_CONNECTION   = $00400000;  // use keep-alive semantics
  INTERNET_FLAG_NO_AUTO_REDIRECT  = $00200000;  // don't handle redirections automatically
  INTERNET_FLAG_READ_PREFETCH     = $00100000;  // do background read prefetch
  INTERNET_FLAG_NO_COOKIES        = $00080000;  // no automatic cookie handling
  INTERNET_FLAG_NO_AUTH           = $00040000;  // no automatic authentication handling
  INTERNET_FLAG_CACHE_IF_NET_FAIL = $00010000;  // return cache file if net request fails

  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP   = $00008000; // ex: https:// to http://
  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS  = $00004000; // ex: http:// to https://
  INTERNET_FLAG_IGNORE_CERT_DATE_INVALID  = $00002000; // expired X509 Cert.
  INTERNET_FLAG_IGNORE_CERT_CN_INVALID    = $00001000; // bad common name in X509 Cert.

  INTERNET_FLAG_RESYNCHRONIZE     = $00000800;  // asking wininet to update an item if it is newer
  INTERNET_FLAG_HYPERLINK         = $00000400;  // asking wininet to do hyperlinking semantic which works right for scripts
  INTERNET_FLAG_NO_UI             = $00000200;  // no cookie popup
  INTERNET_FLAG_PRAGMA_NOCACHE    = $00000100;  // asking wininet to add "pragma: no-cache"
  INTERNET_FLAG_CACHE_ASYNC       = $00000080;  // ok to perform lazy cache-write
  INTERNET_FLAG_FORMS_SUBMIT      = $00000040;  // this is a forms submit
  INTERNET_FLAG_NEED_FILE         = $00000010;  // need a file for this request
  INTERNET_FLAG_MUST_CACHE_REQUEST= INTERNET_FLAG_NEED_FILE;


  INTERNET_DEFAULT_FTP_PORT       = 21;          // default for FTP servers
  INTERNET_DEFAULT_GOPHER_PORT    = 70;          //    "     "  gopher "
  INTERNET_DEFAULT_HTTP_PORT      = 80;          //    "     "  HTTP   "
  INTERNET_DEFAULT_HTTPS_PORT     = 443;         //    "     "  HTTPS  "
  INTERNET_DEFAULT_SOCKS_PORT     = 1080;        // default for SOCKS firewall servers.

  INTERNET_SERVICE_FTP    = 1;
  INTERNET_SERVICE_GOPHER = 2;
  INTERNET_SERVICE_HTTP   = 3;

  INTERNET_OPTION_CALLBACK                = 1;
  INTERNET_OPTION_CONNECT_TIMEOUT         = 2;
  INTERNET_OPTION_CONNECT_RETRIES         = 3;
  INTERNET_OPTION_CONNECT_BACKOFF         = 4;
  INTERNET_OPTION_SEND_TIMEOUT            = 5;
  INTERNET_OPTION_CONTROL_SEND_TIMEOUT    = INTERNET_OPTION_SEND_TIMEOUT;
  INTERNET_OPTION_RECEIVE_TIMEOUT         = 6;
  INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT = INTERNET_OPTION_RECEIVE_TIMEOUT;
  INTERNET_OPTION_DATA_SEND_TIMEOUT       = 7;
  INTERNET_OPTION_DATA_RECEIVE_TIMEOUT    = 8;
  INTERNET_OPTION_HANDLE_TYPE             = 9;
  INTERNET_OPTION_LISTEN_TIMEOUT          = 11;
  INTERNET_OPTION_READ_BUFFER_SIZE        = 12;
  INTERNET_OPTION_WRITE_BUFFER_SIZE       = 13;
  INTERNET_OPTION_ASYNC_ID                = 15;
  INTERNET_OPTION_ASYNC_PRIORITY          = 16;
  INTERNET_OPTION_PARENT_HANDLE           = 21;
  INTERNET_OPTION_KEEP_CONNECTION         = 22;
  INTERNET_OPTION_REQUEST_FLAGS           = 23;
  INTERNET_OPTION_EXTENDED_ERROR          = 24;

  INTERNET_OPTION_OFFLINE_MODE            = 26;
  INTERNET_OPTION_CACHE_STREAM_HANDLE     = 27;
  INTERNET_OPTION_USERNAME                = 28;
  INTERNET_OPTION_PASSWORD                = 29;
  INTERNET_OPTION_ASYNC                   = 30;
  INTERNET_OPTION_SECURITY_FLAGS          = 31;
  INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT = 32;
  INTERNET_OPTION_DATAFILE_NAME           = 33;
  INTERNET_OPTION_URL                     = 34;
  INTERNET_OPTION_SECURITY_CERTIFICATE    = 35;
  INTERNET_OPTION_SECURITY_KEY_BITNESS    = 36;
  INTERNET_OPTION_REFRESH                 = 37;
  INTERNET_OPTION_PROXY                   = 38;
  INTERNET_OPTION_SETTINGS_CHANGED        = 39;
  INTERNET_OPTION_VERSION                 = 40;
  INTERNET_OPTION_USER_AGENT              = 41;
  INTERNET_OPTION_END_BROWSER_SESSION     = 42;
  INTERNET_OPTION_PROXY_USERNAME          = 43;
  INTERNET_OPTION_PROXY_PASSWORD          = 44;
  INTERNET_OPTION_CONTEXT_VALUE           = 45;
  INTERNET_OPTION_CONNECT_LIMIT           = 46;
  INTERNET_OPTION_SECURITY_SELECT_CLIENT_CERT = 47;
  INTERNET_OPTION_POLICY                  = 48;
  INTERNET_OPTION_DISCONNECTED_TIMEOUT    = 49;
  INTERNET_OPTION_CONNECTED_STATE         = 50;
  INTERNET_OPTION_IDLE_STATE              = 51;
  INTERNET_OPTION_OFFLINE_SEMANTICS       = 52;
  INTERNET_OPTION_SECONDARY_CACHE_KEY     = 53;
  INTERNET_OPTION_CALLBACK_FILTER         = 54;
  INTERNET_OPTION_CONNECT_TIME            = 55;
  INTERNET_OPTION_SEND_THROUGHPUT         = 56;
  INTERNET_OPTION_RECEIVE_THROUGHPUT      = 57;
  INTERNET_OPTION_REQUEST_PRIORITY        = 58;
  INTERNET_OPTION_HTTP_VERSION            = 59;
  INTERNET_OPTION_RESET_URLCACHE_SESSION  = 60;
  INTERNET_OPTION_ERROR_MASK              = 62;

function InternetOpen(
        lpszAgent: PChar;               // IN LPCSTR lpszAgent
        dwAccessType: Cardinal;         // IN DWORD dwAccessType
        lpszProxyName: PChar;           // IN LPCSTR lpszProxyName
        lpszProxyBypass: PChar;         // IN LPCSTR lpszProxyBypass
        dwFlags: Cardinal               // IN DWORD dwFlags
): THINTERNET; stdcall; external 'WinInet.dll' name 'InternetOpenA';

function InternetCloseHandle(
        hInet: THINTERNET               // IN HINTERNET hInet
): LongBool; stdcall; external 'WinInet.dll';

function InternetConnect(
        hInternetSession: THINTERNET;   // IN HINTERNET hInternetSession
        lpszServerName: PChar;          // IN LPCSTR lpszServerName
        nServerPort: TINTERNET_PORT;    // IN INTERNET_PORT nServerPort
        lpszUserName: PChar;            // IN LPCSTR lpszUserName
        lpszPassword: PChar;            // IN LPCSTR lpszPassword
        dwService: Cardinal;            // IN DWORD dwService
        dwFlags: Cardinal;              // IN DWORD dwFlags
        dwContext: Cardinal             // IN DWORD dwContext
): THINTERNET; stdcall; external 'WinInet.dll' name 'InternetConnectA';

function HttpOpenRequest(
        hHttpSession: THINTERNET;       // IN HINTERNET hHttpSession
        lpszVerb: PChar;                // IN LPCSTR lpszVerb
        lpszObjectName: PChar;          // IN LPCSTR lpszObjectName
        lpszVersion: PChar;             // IN LPCSTR lpszVersion
        lpszReferer: PChar;             // IN LPCSTR lpszReferer
        lpszAcceptTypes: PPChar;        // IN LPCSTR FAR* lpszAcceptTypes
        dwFlags: Cardinal;              // IN DWORD dwFlags
        dwContext: Cardinal             // IN DWORD dwContext
): THINTERNET; stdcall; external 'WinInet.dll' name 'HttpOpenRequestA';

function HttpSendRequest(
        hHttpRequest: THINTERNET;       // IN HINTERNET hHttpRequest,
        lpszHeaders: PChar;             // IN LPCSTR lpszHeaders,
        dwHeaderLength: Cardinal;       // IN DWORD dwHeadersLength,
        lpOptional: Pointer;            // IN LPVOID lpOptional,
        dwOptionalLength: Cardinal      // DWORD dwOptionalLength
): LongBool; stdcall; external 'WinInet.dll' name 'HttpSendRequestA';

function InternetReadFile(
        hFile: THINTERNET;              // IN HINTERNET hFile,
        lpBuffer: Pointer;              // IN LPVOID lpBuffer,
        dwNumberOfByte: Cardinal;       // IN DWORD dwNumberOfBytesToRead,
        var lpNumberOfBytesRead: Cardinal//OUT LPDWORD lpNumberOfBytesRead
): LongBool; stdcall; external 'WinInet.dll';

function InternetSetOption(
        hInternet: THINTERNET;          // IN HINTERNET hInternet,
        dwOption: Cardinal;             // IN DWORD dwOption,
        lpBuffer: Pointer;              // IN LPVOID lpBuffer,
        dwBufferLength: Cardinal        // IN DWORD dwBufferLength
): LongBool; stdcall; external 'WinInet.dll' name 'InternetSetOptionA';

function THogeDoLib.InternalLogin: Boolean;
var
  hInet: THINTERNET;
  hConnect: THINTERNET;
  hHttpRequest: THINTERNET;
  OpenType: Cardinal;
  ProxyName: PChar;
  ProxySpec: AnsiString;
  AdditionalHeaders: AnsiString;
  HostName: AnsiString;
  ObjectName: AnsiString;
  PostData: AnsiString;
  NumberOfBytesRead: Cardinal;
  ResponseData: TStringList;
  PosColon: Integer;
  URIObj: TIdURI;
  Position: Integer;
begin
  if 0 < length(FProxyServer) then
  begin
    OpenType := INTERNET_OPEN_TYPE_PROXY;
    ProxySpec := FProxyServer + ':' + IntToStr(FProxyPort);
    ProxyName := PChar(ProxySpec);
  end
  else begin
    OpenType := INTERNET_OPEN_TYPE_DIRECT;
    ProxyName := nil;
  end;

  result := False;
  hInet := nil;
  hConnect := nil;
  hHttpRequest := nil;
  ResponseData := TStringList.Create;
  AdditionalHeaders := X_2CH_USER_AGENT + ': ' + FProductName + #13#10;
  PostData := REQ_KEY_USER_ID  + '=' + FUID + '&' +
              REQ_KEY_PASSWORD + '=' + FPasswd;
  URIObj := nil;
  FErrorType := hdleCONNECTION;
  try
    URIObj := TIdURI.Create(FRequestURI);
    HostName := URIObj.Host;
    ObjectName := URIObj.Path + URIObj.Document;
    hInet := InternetOpen(PChar(DOLIB_USER_AGENT), OpenType, ProxyName,
                          nil, 0);
    if hInet = nil then
      raise Exception.Create('InternetOpen');

    InternetSetOption(hInet,
                      INTERNET_OPTION_CONNECT_TIMEOUT,
                      @FConnectTimeout,
                      SizeOf(FConnectTimeout));

    hConnect := InternetConnect(hInet,
                                PChar(HostName),
                                INTERNET_DEFAULT_HTTPS_PORT,
                                nil, nil,
                                INTERNET_SERVICE_HTTP,
                                INTERNET_FLAG_SECURE, 0);
    if hConnect = nil then
      raise Exception.Create('InterntConnect');
    hHttpRequest := HttpOpenRequest(hConnect,
                                    DOLIB_REQUEST_METHOD,
                                    PChar(ObjectName),
                                    nil,
                                    nil,
                                    nil,
                                    INTERNET_FLAG_DONT_CACHE or
                                    INTERNET_FLAG_SECURE,
                                    0);
    if hHttpRequest = nil then
      raise Exception.Create('HttpOpenRequest');

    if not HttpSendRequest(hHttpRequest,
                           PChar(AdditionalHeaders),
                           Length(AdditionalHeaders),
                           PChar(PostData),
                           Length(PostData)) then
      raise Exception.Create('HttpSendRequest');

    InternetSetOption(hHttpRequest,
                      INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT,
                      @FReadTimeout,
                      SizeOf(FReadTimeout));

    Position := 0;
    SetLength(FInternalSessionInfo, 1024);
    while InternetReadFile(hHttpRequest,
                           Pointer(PChar(FInternalSessionInfo) + Position),
                           Length(FInternalSessionInfo) - Position,
                           NumberOfBytesRead) do
    begin
      if NumberOfBytesRead <= 0 then
        break;
      Inc(Position, NumberOfBytesRead);
      SetLength(FInternalSessionInfo, Position + 1024);
    end;
    SetLength(FInternalSessionInfo, Position);
    ResponseData.Text := FInternalSessionInfo;
    FSessionID := ResponseData.Values[RSP_KEY_SESSION_ID];
    PosColon := Pos(':', FSessionID);
    if 0 < PosColon then
      FUserAgent := Copy(FSessionID, 1, PosColon - 1)
    else
      FUserAgent := '';
    result := (0 < length(FUserAgent)) and
              (not AnsiStartsText(RSP_ERROR_IDENTIFIER, FSessionID));
    if not result then
    begin
      FErrorString := 'Authorization failed';
      FErrorType := hdleAUTHORIZATION;
    end else
      FErrorType := hdleSUCCESS;

    //result := True;
  finally
    FErrorCode := Windows.GetLastError;
    if Assigned(URIObj) then URIObj.Free;
    if Assigned(ResponseData) then ResponseData.Free;
    if Assigned(hHttpRequest) then InternetCloseHandle(hHttpRequest);
    if Assigned(hConnect) then InternetCloseHandle(hConnect);
    if Assigned(hInet) then InternetCloseHandle(hInet);
  end;
end;

{$ENDIF}


constructor THogeDoLib.Create;
begin
  inherited;
  FAuthorized := False;
  FSession := nil;
  FConnectTimeout := 30000;
  FReadTimeout := 30000;
  FRequestURI := DEFAULT_REQUEST_URI;
end;

destructor THogeDoLib.Destroy;
begin
  Logout;
  inherited;
end;

function THogeDoLib.Login(const UID, Password: string): boolean;
begin
  if (not FAuthorized) or (UID <> FUID) or (Password <> FPasswd) then
  begin
    Logout;
    FUID := UID;
    FPasswd := Password;
    FAuthorized := InternalLogin;
  end;
  result := FAuthorized;
end;

function THogeDoLib.GetVersion: string;
var
  ver: cardinal;
begin
  if length(FVersion) <= 0 then
  begin
    ver := DOLIB_VERSION;
    FVersion := Format('%d.%2.2d', [ver div $10000, ver mod $10000]);
  end;
  result := FVersion;
end;

procedure THogeDoLib.Logout;
begin
  FSession := nil;
  FSessionID := '';
  FSessionID := '';
  FUserAgent := '';
  FErrorString := '';
  FAuthorized := False;
end;


end.
