unit UHttpManage;

{
初期設定と接続数を管理するTHttpManagerを作成し、
OpenSessionGetを呼ぶと戻り値としてTHttpSessionオブジェクトが作成される。
実際の接続スレッド(THttpThread)は隠蔽されているが、
THttpSessionオブジェクトを解放(またはTerminateメソッド)すると、
接続を解除して終了する。
}

interface

uses
  Windows, Messages, SysUtils, Classes, SyncObjs, Idhttp, IdComponent, UCryptAuto;


type
  THttpStatus = (htIDLING, htSTANDBY, htRESOLVING, htCONNECTING, htCONNECTED,
                 htTRANSFER, htCOMPLETED, htTERMINATED, htERROR ,htCONTENTERROR);

  TSessionType = (stNoCache, stIfModified, stResume);

  //キャッシュリスト用にキャッシュ情報を保持するクラス
  TCacheItem = class(TObject)
  public
    Name: String;
    Date: Integer;
    URL: String;
    Status: String;           //aiai
    LastModified: String;     //aiai
    Size: Integer;            //aiai
    ContentType: String;
    ResponseCode: Integer;
  end;

  //メッセージダイジェスト生成用クラス
  TMsgDigest5 = class(TObject)
  public
    function Digest(s: String): String;
    function DigestB32(s: String): String;
  end;

  THttpSession = class;

  //HTTP読み込みスレッド本体
  THttpThread = class(TThread)
  protected
    IdHTTP:TIdHTTP;
    LoadData: TMemoryStream;
    HttpSession: THttpSession;
    idStatus: TIdStatus;
    procedure EraseRef(Sender: TObject);
  public
    constructor Create(AHttpSession: THttpSession);
    destructor Destroy; override;
    procedure TerminateAndWait;
    procedure EventOnStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure EventOnWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
  protected
    procedure Execute;override;
  end;

  THttpManager = class;

  //HTTP読み込みインターフェイスクラス
  THttpSession = class(TObject)
  protected
    Manager: THttpManager;
    Sync: TCriticalSection;
    HttpThread: THttpThread;

    SessionType: TSessionType;
    FURL: string;
    FData: TStream;
    FFromCache: Boolean;
    FDownLoadSize: Integer;
    FStatus: THttpStatus;
    LastStatus: THttpStatus;

    procedure BeginSession;

    function GetHost: string;
    function GetStatus: THttpStatus;
    procedure SetStatus(AStatus: THttpStatus);
    function GetDownLoadSize: Integer;
    procedure SetDownLoadSize(ADownLoadSize: Integer);
    function GetData: TStream;
    procedure SetData(AData: TStream);
    function GetProtect: Boolean;
    procedure SetProtect(Value: Boolean);
    function GetBrowserCracher: Boolean;
    procedure SetBrowserCracher(Value: Boolean);
    function GetLastModified: String;
    procedure SetLastModified(Value: String);
    function GetContentType: String;
    procedure SetContentType(Value: String);

    procedure PostEventMessage(EventMethod:TNotifyEvent);
    procedure DoOnStatus(Sender: TObject);
    procedure DoOnWork(Sender: TObject);

  public
    Request: TIdHTTPRequest;
    Response: TIdHTTPResponse;
    CacheHeader: TStringList;
    OnStatus: TNotifyEvent;
    OnWork: TNotifyEvent;

    constructor Create(AManager: THttpManager);
    destructor Destroy; override;
    function Load(AURL, Referer: String; OffLine: Boolean): Boolean; //キャッシュ利用の時(OffLine時はキャッシュがあるときは)Trueを返す
    procedure Reload(NoCache: Boolean);
    procedure Terminate;
    function WriteCache: Integer;
    function CacheExists: Boolean;
    procedure DeleteCache;
    property URL:string read FURL;
    property FromCache: Boolean read FFromCache;
    property Host:string read GetHost;
    property Status:THttpStatus read GetStatus;
    property Data: TStream read GetData write SetData;
    property LastModified: String read GetLastModified;
    property ContentType: String read GetContentType;
    property DownLoadSize:Integer read GetDownLoadSize;
    property Protect: Boolean read GetProtect write SetProtect;
    property BrowserCracher: Boolean read GetBrowserCracher write SetBrowserCracher;
  end;

  TCacheDelete = class;

  //HTTP読み込み接続数,キャッシュ管理/設定基本クラス(カスタマイズは継承で)
  THttpManager = class(TObject)
  protected
    HandleForHttpMessage: HWND;
    Sessions: TList;
    StandBySessions: TList;
    ExecutingSessions: TList;
    DefaultCachePath: String;
    CacheDeleteThread: TCacheDelete;
    procedure ExecuteStandBySession;
    procedure RegisterSession(ASession: THttpSession);
    procedure ExtractSession(ASession: THttpSession);
    procedure RecieveHttpMessage(var Message:TMessage);
    function CheckCachePriority(URL: String): Boolean; virtual;
    procedure MsgOut(S: String); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function CacheExists(URL: string): Boolean;
    function ReadCache(Location: string; CacheData: TStream; Header: TStringList): Integer;
    procedure DeleteCache(URL: string);
    procedure RegisterBrowserCrasher(URL: string);
    procedure DeleteExpiredCaches;
    procedure GetCacheFileList(List: TList);
    function FillCacheItem(CacheItem: TCacheItem): Boolean;
    function CachePath: String; virtual;
    function RecvBufferSize: Integer; virtual;
    function UserAgent: String; virtual;
    function ConnectionLimit: Integer; virtual;
    function ReadTimeout: Integer; virtual;
    function RedirectMaximum: Integer; virtual;
    function UseCache: Boolean; virtual;
    function SaveCacheEachTime: Boolean; virtual;
    function LifeSpanOfCache: Integer; virtual;
    function ProxyServer: String; virtual;
    function ProxyPort: Integer; virtual;
    function OffLine: Boolean; virtual;
  end;

  //THttpManagerのキャッシュ削除用スレッドオブジェクト
  TCacheDelete = class(TThread)
  protected
    Count: Integer;
    Limit: Integer;
    CachePath:String;
    Manager: THttpManager;
    procedure Execute; override;
    procedure EraseRef(Sender: TObject);
  public
    constructor Create(AManager: THttpManager); reintroduce;
    procedure TerminateAndWait;
  end;


const HttpStatusText:array[THttpStatus] of string =
                 ('Idling',
                  'Stand by',
                  'Resolving Host',
                  'Connecting',
                  'Connected',
                  'Loading',
                  'Completed',
                  'Terminated by User',
                  'Error',
                  'Content Error');

var
  MsgDigest5: TMsgDigest5;


implementation


uses Forms;

const

  HP_ALGID    = $0001;
  HP_HASHVAL  = $0002;
  HP_HASHSIZE = $0004;

  HttpStatusMessage = WM_USER + 1000;
  HttpThreadTerminateMessage = WM_USER + 1001;

  ViewCacheDefRelativePath = 'VwCache\';
  BroCraString = '<html><body><h1>ブラクラ危険！</h1></body></html>';

//ハッシュ化APIコール→キャッシュファイル名決定に使用
function CryptGetHashParam(
        hHash: HCRYPTHASH;
        dwParam: Longword;
        pbData: Pointer;
        var pdwDataLen: Longword;
        dwFlags: Longword
        ) : LongBool; stdcall; external 'advapi32.dll';



//5bitエンコーディング関数　Base32ではない。
function EncodeB32(s: String): String;
const
  B32Char: array[0..31] of Char =
        ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F',
         'G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V');
var
  i: Integer;
  len: Integer;
begin
  if s = '' then begin
    Result :='';
    Exit;
  end;
  len := (Length(s) * 8 - 1) div 5 + 1;
  s := s + StringOfChar(#0, (len * 5 - 1) div 8 + 1 - length(s));
  SetLength(Result, len);
  for i:=0 to len - 1 do
    Result[i + 1] := B32Char[(MakeWord(Byte(s[(i * 5) div 8 + 1]), Byte(s[(i * 5) div 8 + 2]))
                                shr ((i * 5) mod 8)) and 31];
end;


{ MsgDigest5 } // MD5によるメッセージダイジェスト生成クラス

function TMsgDigest5.Digest(s: String):String;
var
  hProv: HCRYPTPROV;
  hHash: HCRYPTHASH;
  Buf: string;
  dwLen: Longword;
begin
  hProv := 0;
  hHash := 0;
  SetLength(Buf, 16);
  dwLen := 16;

  try
    try
      if (not CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL, 0)) and
         (not CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL, CRYPT_MACHINE_KEYSET)) and
         (not CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL, CRYPT_NEWKEYSET)) and
         (not CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL,
                                  CRYPT_NEWKEYSET or CRYPT_MACHINE_KEYSET)) then
        raise Exception.Create('CryptAcquireContext');
      if not CryptCreateHash(hProv, CALG_MD5, 0, 0, hHash) then
        raise Exception.Create('CryptCreateHash');
      if not CryptHashData(hHash, PChar(s), length(s), 0) then
        raise Exception.Create('CryptHashData');
      if not CryptGetHashParam(hHash, HP_HASHVAL, PChar(Buf), dwLen, 0) then
        raise Exception.Create('CryptHashData');
      Result := copy(Buf, 1, dwLen);
    finally
      CryptDestroyHash(hHash);
    end;
  finally
    CryptReleaseContext(hProv, 0);
  end;
end;

function TMsgDigest5.DigestB32(s: String): String;
begin
  Result := EncodeB32(Digest(s));
end;


{ THttpThread }

//コンストラクタ
constructor THttpThread.Create(AHttpSession: THttpSession);
begin
  FreeOnTerminate := True;
  OnTerminate := EraseRef;

  HttpSession := AHttpSession;
  idStatus := hsDisconnecting;

  IdHTTP := TIdHTTP.Create(nil);
  if HttpSession.Manager.ProxyServer <> '' then begin
    IdHTTP.ProxyParams.ProxyServer := HttpSession.Manager.ProxyServer;
    IdHTTP.ProxyParams.ProxyPort := HttpSession.Manager.ProxyPort;
  end;

  LoadData := TMemoryStream.Create;

  IdHTTP.Request := HttpSession.Request;
  IdHTTP.Request.UserAgent := HttpSession.Manager.UserAgent;
  case HttpSession.SessionType of
    stIfModified: begin
      if HttpSession.LastModified <> '' then
        IdHTTP.Request.CustomHeaders.Values['If-Modified-Since'] := HttpSession.LastModified;
    end;
    stResume: begin
      IdHTTP.Request.ContentRangeStart := HttpSession.FData.Size;
      IdHTTP.Request.ContentRangeEnd := 0;
      if HttpSession.LastModified <> '' then
        IdHTTP.Request.CustomHeaders.Values['If-Unmodified-Since'] := HttpSession.LastModified;
    end;
  end;

  IdHTTP.ReadTimeout := HttpSession.Manager.ReadTimeout;
  IdHTTP.RecvBufferSize := HttpSession.Manager.RecvBufferSize;
  if HttpSession.Manager.RedirectMaximum > 0 then begin
    IdHTTP.HandleRedirects := True;
    IdHTTP.RedirectMaximum := HttpSession.Manager.RedirectMaximum;
  end;

  IdHTTP.OnStatus := EventOnStatus;
  IdHTTP.OnWork := EventOnWork;

  inherited Create(False);
end;


//デストラクタ
destructor THttpThread.Destroy;
begin
  IdHTTP.Free;
  LoadData.Free;
  inherited Destroy;
end;


//スレッドの強制終了処理
procedure THttpThread.TerminateAndWait;
begin
  Suspend;
  FreeOnTerminate := False;
  OnTerminate := nil;
  Terminate;
  IdHTTP.DisconnectSocket; //一応動いてるけど、やってはいけない操作。
  Resume;
  WaitFor;
end;


//スレッド実行部
procedure THttpThread.Execute;
var
  Pos: Int64;
begin
  try
    IdHTTP.Get(HttpSession.URL, LoadData);
    if not Terminated then begin
      HttpSession.Sync.Enter;
      Pos := LoadData.Position;
      LoadData.Seek(0, soFromBeginning);
      if (HttpSession.SessionType = stResume) and (IdHTTP.ResponseCode = 206) then begin
        HttpSession.FData.Seek(0, soFromEnd);
        HttpSession.FData.CopyFrom(LoadData, Pos);
      end else begin
        HttpSession.FData.Size := 0;
        HttpSession.FData.CopyFrom(LoadData, Pos);
      end;
      HttpSession.Sync.Leave;
      HttpSession.SetStatus(htCOMPLETED);
      HttpSession.FFromCache := False;
    end;
  except
    on E:Exception do begin
      case IdHTTP.ResponseCode of
        304: begin
          if HttpSession.SessionType = stIfModified then begin
            HttpSession.SetStatus(htCOMPLETED);
            HttpSession.FFromCache := False;
          end else begin
            HttpSession.SetStatus(htERROR);
            HttpSession.Response.ResponseText := E.Message;
          end;
        end;
        else begin
          HttpSession.SetStatus(htERROR);
          HttpSession.Response.ResponseText := E.Message;
        end;
      end;
    end;
  end;
  if not Terminated then begin
    HttpSession.Response.Assign(IdHTTP.Response);
    HttpSession.PostEventMessage(HttpSession.DoOnStatus);
  end;
end;


//OnStatusイベントの処理(ステータス更新＋VCLスレッドのイベントコール)
procedure THttpThread.EventOnStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  if Terminated then begin
    IdHTTP.DisconnectSocket;
    Exit;
  end;

  if AStatus <> idStatus then begin
    case AStatus of
      hsResolving  : begin
        HttpSession.SetStatus(htRESOLVING);
        HttpSession.PostEventMessage(HttpSession.DoOnStatus);
      end;
      hsConnecting : begin
        HttpSession.SetStatus(htCONNECTING);
        HttpSession.PostEventMessage(HttpSession.DoOnStatus);
      end;
      hsConnected  : begin
        HttpSession.SetStatus(htCONNECTED);
        HttpSession.PostEventMessage(HttpSession.DoOnStatus);
      end;
      hsStatusText : begin
        try
          LoadData.Size := IdHTTP.Response.ContentLength;
        except
        end;
        HttpSession.SetStatus(htTRANSFER);
        HttpSession.PostEventMessage(HttpSession.DoOnStatus);
      end;
    end;
  end;
  idStatus := AStatus;
end;


//OnWorkイベントの処理(ステータス更新＋VCLスレッドのイベントコール)
procedure THttpThread.EventOnWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  if Terminated then begin
    IdHTTP.DisconnectSocket;
    Exit;
  end;

  if HttpSession.Status <> htTRANSFER then begin
    HttpSession.SetStatus(htTRANSFER);
    HttpSession.Response.Assign(IdHTTP.Response);
    HttpSession.PostEventMessage(HttpSession.DoOnStatus);
  end;

  HttpSession.Sync.Enter;
  if (HttpSession.SessionType = stResume) and (IdHTTP.ResponseCode = 206) then
    HttpSession.FDownLoadSize := HttpSession.FData.Size + LoadData.Position
  else
    HttpSession.FDownLoadSize := LoadData.Position;
  HttpSession.Sync.Leave;

  HttpSession.PostEventMessage(HttpSession.DoOnWork);
end;


//スレッド終了時に自分の参照を消去
procedure THttpThread.EraseRef(Sender: TObject);
begin
  if Assigned(HttpSession) then
    HttpSession.HttpThread := nil;
end;


{ THttpSession }


//待機セッションの作成
constructor THttpSession.Create(AManager: THttpManager);
begin
  inherited Create;
  Manager := AManager;
  Manager.Sessions.Add(Self);
  Sync := TCriticalSection.Create;
  SetStatus(htIDLING);
  Request := TIdHTTPRequest.Create(nil);
  Response := TIdHTTPResponse.Create(nil);
  CacheHeader := TStringList.Create;
end;


//セッションの破棄
destructor THttpSession.Destroy;
begin
  Terminate;
  CacheHeader.Free;
  Response.Free;
  Request.Free;
  Sync.Free;
  Manager.Sessions.Extract(Self);
end;


//ロード開始(キャッシュをチェックして、読み込みが必要ならManagerにリクエスト)
function THttpSession.Load(AURL, Referer: String; OffLine: Boolean): Boolean;
begin
  Terminate;
  SetStatus(htSTANDBY);
  FURL := AURL;
  Request.Referer := Referer;
  Result := False;
  OffLine := OffLine or Manager.OffLine;
  if Manager.ReadCache(FURL, FData, CacheHeader) >= 0 then begin
    FFromCache := True;
    if CacheHeader.Values['STATUS'] = 'BROCRA' then begin
      SetContentType('text/html');
      FData.Size := Length(BroCraString);
      FData.Seek(0, soFromBeginning);
      FData.Write(Pchar(BroCraString)^, Length(BroCraString));
      SetStatus(htCOMPLETED);
      PostEventMessage(DoOnStatus);
    end else if Manager.CheckCachePriority(FURL) or OffLine then begin
      SetStatus(htCOMPLETED);
      PostEventMessage(DoOnStatus);
      Result := True;
    end else begin
      SessionType := stIfModified;
      Manager.RegisterSession(Self);
    end;
  end else if OffLine then begin
      SetStatus(htERROR);
      PostEventMessage(DoOnStatus);
      Result := True;
  end else begin
    SessionType := stNoCache;
    FData.Size := 0;
    Manager.RegisterSession(Self);
  end;
end;


//リロード
procedure THttpSession.Reload(NoCache: Boolean);
begin
  if FURL <> '' then begin
    Terminate;

    BrowserCracher := False;
    SetStatus(htSTANDBY);
    if NoCache then
      SessionType := stNoCache
    else
      SessionType := stIfModified;

    Manager.RegisterSession(Self);
  end;
end;


//セッション開始
procedure THttpSession.BeginSession;
begin
  HttpThread := THttpThread.Create(Self);
end;
  

//セッション中止（HTTPスレッドの中断、Managerから登録削除）
procedure THttpSession.Terminate;
begin
  if Status in [htSTANDBY, htRESOLVING, htCONNECTING, htCONNECTED, htTRANSFER] then
    SetStatus(htTERMINATED);
  if Assigned(HttpThread) then begin
    HttpThread.TerminateAndWait;
    FreeAndNil(HttpThread);
  end;
  Manager.ExtractSession(Self);
end;


//WindowsメッセージをHTTPManagerに送信して非同期的にイベント発生
procedure THttpSession.PostEventMessage(EventMethod:TNotifyEvent);
var
  MethodCode, MethodData: Integer;
begin
  MethodCode := Integer(TMethod(EventMethod).Code);
  MethodData := Integer(TMethod(EventMethod).Data);
  PostMessage(Manager.HandleForHttpMessage, HttpStatusMessage, MethodCode, MethodData);
end;


//httpスレッドのステータスイベント受け取り
procedure THttpSession.DoOnStatus(Sender: TObject);
var
  NeedEvent:Boolean;
begin
  NeedEvent:=False;  //汚いやりかたで再突入を防止
  Sync.Enter;
  if LastStatus <> FStatus then NeedEvent := True;
  LastStatus := FStatus;
  Sync.Leave;

  if NeedEvent then begin
    if FStatus = htCOMPLETED then begin //SetDataからでも保存。削除がファイル作成日に依存するため。
      SetContentType(Response.ContentType);
      if Response.RawHeaders.Values['Last-Modified'] <> '' then
        SetLastModified(Response.RawHeaders.Values['Last-Modified'])
      else
        SetLastModified('');
      if Manager.UseCache and Manager.SaveCacheEachTime then
        WriteCache;
      Manager.ExtractSession(Self);
    end else if FStatus = htERROR then begin
      Manager.ExtractSession(Self);
    end;
    if Assigned(OnStatus) then OnStatus(Self);
  end;
end;


//httpスレッドの転送イベント受け取り
procedure THttpSession.DoOnWork(Sender: TObject);
begin
  //非同期でイベントが前後する可能性があるため、
  //StatusがCOMPLETEDやERRORならWorkイベントを無視。
  if not(Status in [htCOMPLETED, htERROR, htCONTENTERROR]) then
    if Assigned(OnWork) then OnWork(Self);
end;


//キャッシュファイルへの書き込み
function THttpSession.WriteCache: Integer;
var
  FileName: String;
  FileStream: TFileStream;
  HeaderSize: Integer;
begin
  Result := -1;

  if not(Manager.UseCache) or not(status in [htCOMPLETED, htCONTENTERROR]) then
    Exit;

  FileName := IncludeTrailingPathDelimiter(Manager.CachePath) + ChangeFileExt(copy(MsgDigest5.DigestB32(FURL), 1, 22), '.vch');

  CacheHeader.Values['URL'] := FURL;

  FileStream := nil;
  try
    if not DirectoryExists(Manager.CachePath) then
      ForceDirectories(Manager.CachePath);
    FileStream := TFileStream.Create(FileName, fmCreate);
    HeaderSize := Length(CacheHeader.Text);
    FileStream.Write(HeaderSize, Sizeof(HeaderSize));
    CacheHeader.SaveToStream(FileStream);
    if not BrowserCracher then
      Result := FileStream.CopyFrom(FData, 0);
  finally
    FileStream.Free;
  end;
end;


//キャッシュファイルの存在確認
function THttpSession.CacheExists: Boolean;
begin
  Result := Manager.CacheExists(FURL);
end;


//キャッシュファイルの削除
procedure THttpSession.DeleteCache;
begin
  Manager.DeleteCache(FURL);
end;


//ホストの取得
function THttpSession.GetHost:string;
var
  Slash:Integer;
begin
  Result := Copy(FURL, 8, Length(FURL));
  Slash := AnsiPos('/', Result);
  if Slash > 0 then Result := Copy(Result, 1, Slash - 1);
end;


//プロパティの読み書き関係
function THttpSession.GetData: TStream;
begin
  if FStatus in [htCOMPLETED, htCONTENTERROR] then
    Result := FData
  else
    Result := nil;
end;
//
procedure THttpSession.SetData(AData: TStream);
begin
  if FStatus in [htIDLING, htCOMPLETED, htCONTENTERROR] then
    FData := AData
  else
    raise Exception.Create('アクティブなHTTPセッションの変更操作');
end;
//
function THttpSession.GetStatus: THttpStatus;
begin
  Sync.Enter;
  Result:=FStatus;
  Sync.Leave;
end;
//
procedure THttpSession.SetStatus(AStatus: THttpStatus);
begin
  Sync.Enter;
  FStatus:=AStatus;
  Sync.Leave;
end;
//
function THttpSession.GetDownLoadSize: Integer;
begin
  Sync.Enter;
  Result := FDownLoadSize;
  Sync.Leave;
end;
//
procedure THttpSession.SetDownLoadSize(ADownLoadSize: Integer);
begin
  Sync.Enter;
  FDownLoadSize := ADownLoadSize;
  Sync.Leave;
end;
//
function THttpSession.GetProtect: Boolean;
begin
  Sync.Enter;
  if CacheHeader.Values['STATUS'] = 'PROTECT' then
    Result := True
  else
    Result := False;
  Sync.Leave;
end;
//
procedure THttpSession.SetProtect(Value: Boolean);
begin
  Sync.Enter;
  if not BrowserCracher then
    case Value of
      True:  CacheHeader.Values['STATUS'] := 'PROTECT';
      False: CacheHeader.Values['STATUS'] := '';
    end;
  Sync.Leave;
end;
//
function THttpSession.GetBrowserCracher: Boolean;
begin
  Sync.Enter;
  if CacheHeader.Values['STATUS'] = 'BROCRA' then
    Result := True
  else
    Result := False;
  Sync.Leave;
end;
//
procedure THttpSession.SetBrowserCracher(Value: Boolean);
begin
  Terminate;
  case Value of
    True: begin
      CacheHeader.Clear;
      CacheHeader.Values['URL'] := FURL;
      CacheHeader.Values['STATUS'] := 'BROCRA';
    end;
    False: begin
      if BrowserCracher then CacheHeader.Values['STATUS'] := '';
    end;
  end;
end;
//
function THttpSession.GetLastModified: String;
begin
  Sync.Enter;
  Result := CacheHeader.Values['LastModified'];
  Sync.Leave;
end;
//
procedure THttpSession.SetLastModified(Value: String);
begin
  Sync.Enter;
  CacheHeader.Values['LastModified'] := Value;
  Sync.Leave;
end;
//
function THttpSession.GetContentType: String;
begin
  Sync.Enter;
  Result := CacheHeader.Values['ContentType'];
  Sync.Leave;
end;
//
procedure THttpSession.SetContentType(Value: String);
begin
  Sync.Enter;
  if not BrowserCracher then
      CacheHeader.Values['ContentType'] := Value;
  Sync.Leave;
end;


{ THttpManager }

//コンストラクタ
constructor THttpManager.Create;
begin
  HandleForHttpMessage:=classes.AllocateHWnd(RecieveHttpMessage);
  Sessions := TList.Create;
  StandBySessions:=TList.Create;
  ExecutingSessions:=TList.Create;
  DefaultCachePath := ExtractFilePath(Application.ExeName) + ViewCacheDefRelativePath;
end;


//デストラクタ
destructor THttpManager.Destroy;
begin
  ExecutingSessions.Free;
  StandBySessions.Free;
  Sessions.Free;
  if Assigned(CacheDeleteThread) then
  begin
    CacheDeleteThread.TerminateAndWait;
    CacheDeleteThread.Free;
  end;
  Classes.DeallocateHWnd(HandleForHttpMessage);
  inherited Destroy;
end;


//セッション始動の受付
procedure THttpmanager.RegisterSession(ASession: THttpSession);
begin
  if (ExecutingSessions.IndexOf(ASession) >= 0) or (ExecutingSessions.IndexOf(ASession) >= 0) then
    Exit;
  StandBySessions.Add(ASession);
  ExecuteStandBySession;
end;


//待機セッションの始動(スレッド作成＋セッションとの関連づけ)
procedure THttpManager.ExecuteStandBySession;
var
  Session: THttpSession;
  i, j: Integer;
  IndividualServerLimit: Integer;
  ConnectingCount: Integer;
begin
  IndividualServerLimit := (ConnectionLimit - 1) div 5 + 1;

  for i := 0 to StandBySessions.Count - 1 do begin
    if ExecutingSessions.Count >= ConnectionLimit then Break;
    ConnectingCount := 0;
    Session := THttpSession(StandBySessions[i]);
    for j:=0 to ExecutingSessions.Count - 1 do begin
      if SameText(Session.Host, THttpSession(ExecutingSessions[j]).Host) then Inc(ConnectingCount);
    end;
    if ConnectingCount < IndividualServerLimit then begin
      Session.BeginSession;
      ExecutingSessions.Add(Session);
      StandBySessions[i]:=nil; //最後にPack
    end;
  end;
  StandBySessions.Pack;
end;


//セッション終了の通知受け取り
procedure THttpManager.ExtractSession(ASession: THttpSession);
begin
  StandBySessions.Extract(ASession);
  ExecutingSessions.Extract(ASession);
  ExecuteStandBySession;
end;


//THttpThreadからのメッセージでTHttpSessionのイベントを発生させる
procedure THttpManager.RecieveHttpMessage(var Message: TMessage);
var
  Method:TMethod;
  Event:TNotifyEvent;
begin
  if Message.msg = HttpStatusMessage then begin
    Method.Code:=pointer(Message.WParam);
    Method.Data:=pointer(Message.LParam);
    Event:=TNotifyEvent(Method);
    //対象になるセッションが破棄済みならイベントなし
    if Sessions.IndexOf(TObject(Method.Data)) >= 0 then
      Event(THttpSession(Method.Data).HttpThread);
  end else begin
    Message.Result := DefWindowProc(HandleForHttpMessage, Message.Msg, Message.wParam, Message.lParam);
  end;
end;


//キャッシュの存在確認
function THttpManager.CacheExists(URL: string): Boolean;
var
  FileName: String;
begin
  URL := Trim(URL);
  FileName := IncludeTrailingPathDelimiter(CachePath)
           + ChangeFileExt(Copy(MsgDigest5.DigestB32(URL), 1, 22), '.vch');

  try
    Result := FileExists(FileName);
  except
    Result := False;
  end;
end;


//キャッシュの読み込み(ヘッダー付き)
function THttpManager.ReadCache(Location: string; CacheData: TStream; Header: TStringList): Integer;
var
  FileName: String;
  FileStream: TFileStream;
  HeaderSize: Integer;
  Buf: String;
begin
  Result := -1;
  if not UseCache then
    Exit;

  if (CompareText(ExtractFileExt(Location), '.vch') = 0) and FileExists(Location) then begin
    FileName := Location;
  end else begin
    Location := Trim(Location);
    FileName := IncludeTrailingPathDelimiter(CachePath)
            + ChangeFileExt(Copy(MsgDigest5.DigestB32(Location), 1, 22), '.vch');

    if not FileExists(FileName) then
      Exit;
  end;

  FileStream := nil;
  try
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    FileStream.Read(HeaderSize, Sizeof(HeaderSize));
    SetLength(Buf, HeaderSize);
    FileStream.Read(Pchar(Buf)^, Length(Buf));
    Header.Text := Buf;
    if (FileName = Location) or (Header.Values['URL'] = Location) then begin
      if (Header.Values['STATE'] <> 'BROCRA') and Assigned(CacheData) then
          Result := CacheData.CopyFrom(FileStream, FileStream.Size - FileStream.Position)
      else
        Result := 0;
    end else begin
      Header.Text := '';
    end;
  finally
    FileStream.Free;
  end;
end;


//キャッシュの削除
procedure THttpManager.DeleteCache(URL: string);
var
  FileName: String;
begin
  URL := Trim(URL);
  FileName := IncludeTrailingPathDelimiter(CachePath)
           + ChangeFileExt(Copy(MsgDigest5.DigestB32(URL), 1, 22), '.vch');
  try
    if FileExists(FileName) then
      DeleteFile(FileName);
  except
  end;
end;

//URL指定によるブラクラ登録
procedure THttpManager.RegisterBrowserCrasher(URL: string);
var
  FileName: String;
  HeaderString: String;
  HeaderSize: Integer;
  FileStream: TFileStream;
begin
  URL := Trim(URL);
  HeaderString := 'URL=' + URL + #13#10'STATUS=BROCRA'#13#10;
  FileName := IncludeTrailingPathDelimiter(CachePath)
           + ChangeFileExt(Copy(MsgDigest5.DigestB32(URL), 1, 22), '.vch');
  FileStream := nil;
  try
    try
      if not DirectoryExists(CachePath) then
        ForceDirectories(CachePath);
      FileStream := TFileStream.Create(FileName, fmCreate);
      HeaderSize := Length(HeaderString);
      FileStream.WriteBuffer(HeaderSize, Sizeof(HeaderSize));
      FileStream.WriteBuffer(PChar(HeaderString)^, HeaderSize);
    finally
      FileStream.Free;
    end;
  except
  end;
end;

//期限切れキャッシュの一括削除(スレッド起動)
procedure THttpManager.DeleteExpiredCaches;
begin
  if CacheDeleteThread = nil then
    CacheDeleteThread := TCacheDelete.Create(Self);
end;


//キャッシュファイル名の一覧を取得
procedure THttpManager.GetCacheFileList(List: TList);
var
  Back: Integer;
  F: TSearchRec;
  Item: TCacheItem;
  Path: String;
begin
  Path := IncludeTrailingPathDelimiter(CachePath);
  if not DirectoryExists(Path) then Exit;
  try
    try
      Back := FindFirst(Path + '*.vch', faArchive, F);
      while Back = 0 do begin
        if (F.Name<>'.') and (F.Name<>'..') then begin
          Item := TCacheItem.Create;
          Item.Name := F.Name;
          Item.Date := F.Time;
          Item.Size := F.Size;
          List.Add(Item);
        end;
        Back := FindNext(F);
      end;
    finally
      FindClose(F);
    end;
  except
  end;
end;


//キャッシュリストアイテムの情報取得
function THttpManager.FillCacheItem(CacheItem: TCacheItem): Boolean;
var
  FileName: String;
  FileStream: TFileStream;
  Header: TStringList;
  HeaderSize: Integer;
  Buf: String;
begin
  FileName := IncludeTrailingPathDelimiter(CachePath) + CacheItem.Name;
  try
    FileStream := nil;
    try
      FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
      FileStream.Read(HeaderSize, Sizeof(HeaderSize));
      SetLength(Buf, HeaderSize);
      FileStream.Read(Pchar(Buf)^, Length(Buf));
    finally
      FileStream.Free;
    end;
    Header := TStringList.Create;
    Header.Text := Buf;
    CacheItem.Size := CacheItem.Size - HeaderSize - 4;
    CacheItem.URL := Header.Values['URL'];
    CacheItem.ContentType := Header.Values['ContentType'];
    CacheItem.ResponseCode := StrToIntDef(Header.Values['ResponseCode'], -1);
    CacheItem.LastModified := Header.Values['LastModified'];
    CacheItem.Status := Header.Values['STATUS'];
    Header.Free;
    Result := True;
  except
    Result := False;
  end;
end;



// オーバーライド前提の設定項目

//キャッシュを優先するか(更新をチェックするか)の判定
function THttpManager.CheckCachePriority(URL: String): Boolean;
begin
  Result := False;
end;
function THttpManager.CachePath: String;
begin
  Result := DefaultCachePath;
end;
function THttpManager.RecvBufferSize: Integer;
begin
	Result := 4096;
end;
function THttpManager.UserAgent: String;
begin
	Result := 'HttpManager';
end;
function THttpManager.ConnectionLimit: Integer;
begin
	Result := 5;
end;
function THttpManager.ReadTimeout: Integer;
begin
	Result := 120000;
end;
function THttpManager.RedirectMaximum: Integer;
begin
	Result := 0;
end;
function THttpManager.UseCache: Boolean;
begin
	Result := True;
end;
function THttpManager.SaveCacheEachTime: Boolean;
begin
  Result := False;
end;
function THttpManager.LifeSpanOfCache: Integer;
begin
  Result := 30;
end;
function THttpManager.ProxyServer: String;
begin
  Result := '';
end;
function THttpManager.ProxyPort: Integer;
begin
  Result := 0;
end;
procedure THttpManager.MsgOut(S: String);
begin
end;
function THttpManager.OffLine: Boolean;
begin
  Result := False;
end;



{ TCacheDelete }

//コンストラクタ
constructor TCacheDelete.Create(AManager: THttpManager);
begin
  Manager := AManager;
  Count := 0;
  Limit := DateTimeToFileDate(Now - Manager.LifeSpanOfCache);
  CachePath := IncludeTrailingPathDelimiter(Manager.CachePath);
  OnTerminate := EraseRef;
  FreeOnTerminate := True;
  inherited Create(True);
  Priority := tpIdle;
  Resume;
end;


//実行部
procedure TCacheDelete.Execute;
var
  Back: Integer;
  F: TSearchRec;
begin
  if not DirectoryExists(CachePath) then Exit;
  try
    try
      Back := FindFirst(CachePath + '*.vch', faArchive, F);
      while (Back = 0) and not(Terminated) do begin
        if (F.Name<>'.') and (F.Name<>'..') and (F.Time < Limit) then
          try
            DeleteFile(CachePath + F.Name);
            Inc(Count);
          except
          end;
          if (Count mod 100 = 99) and not Terminated then
            Sleep(10);
        Back := FindNext(F);
      end;
    finally
      FindClose(F);
    end;
  except
  end;
end;


//スレッドの強制終了処理
procedure TCacheDelete.TerminateAndWait;
begin
  Suspend;
  FreeOnTerminate := False;
  OnTerminate := nil;
  Terminate;
  Priority := tpNormal;
  Resume;
  WaitFor;
end;


//スレッド終了時に自分の参照を消去
procedure TCacheDelete.EraseRef(Sender: TObject);
begin
  {aiai}
//Manager.MsgOut(Format('%d個の期限切れｷｬｯｼｭをｻｸｼﾞｮ', [Count]));
  if Count = 0 then
    Manager.MsgOut('川*’ー’）ﾉ 期限切れｷｬｯｼｭはないんやよ')
  else
    Manager.MsgOut(Format('川*’ー’）ﾉ %d個の期限切れｷｬｯｼｭをｻｸｼﾞｮﾔﾖ', [Count]));
  {/aiai}
//  if Assigned(Manager) then
    Manager.CacheDeleteThread := nil;
end;




initialization
  MsgDigest5 := TMsgDigest5.Create;
finalization
  MsgDigest5.Free;
end.
