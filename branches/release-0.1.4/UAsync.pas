unit UAsync;
(* 非同期通信 *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.12, 2003/11/15 12:47:45 *)

interface

uses
  Windows, SysUtils, Classes, Dialogs, Forms, IdHTTP2, IdHTTP, gzip, USynchro,
  idURI, IdAuthentication;
type
  TCallbackStreamHandler = procedure(sender: TObject; const Buffer; var Count: Longint) of object;
  TCallbackStream = class(TMemoryStream)
  public
    OnWrite: TCallbackStreamHandler;
    constructor Create;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;
  (*-------------------------------------------------------*)
  TAsyncReq = class;
  TAsyncNotifyCode = (ancPRECONNECT, ancCONNECT, ancREQUEST, ancRESPONSE, ancPROGRESS,
                      ancPRETERMINATE, ancEUNZIP);
  TAsyncNotify = procedure(sender: TAsyncReq; code: TAsyncNotifyCode) of object;
  TAsyncDone = procedure(sender: TAsyncReq) of object;
  (*-------------------------------------------------------*)
  TAsyncReqRequestType = (agrtGet, agrtHead, agrtPost);
  TAsyncReq = class(TThread)
  protected
    notifyCode: TAsyncNotifyCode;
    decompressor : TGzipDecompressStream;
    unzipError: boolean;
    resStream: TCallbackStream;
    lastModified: string;

    canceled : boolean;


    OnNotify: TAsyncNotify;     (* ここは自分で呼ぶ *)
    AsyncDone: TAsyncDone;         (* これはManagerが使う *)

    uncompressedStream : TMemoryStream;
    reqType: TAsyncReqRequestType;
    synchro: THogeMutex;
    compressedSize: cardinal;
    uncompressedSize: cardinal;
    postData: string;
    procedure Notify(code: TAsyncNotifyCode);
    procedure OnHTTPNotifyProc(sender: TObject; notifyCode: TIdHTTP2NotifyCode);
    procedure OnWriteProc(sender: TObject; const Buffer; var Count: Longint);

    (* OnAsyncNotifyの前段 *)
    procedure OnAsyncNotifyProc(code: TAsyncNotifyCode);
    procedure QueryProc;

    function GetTransferedSize: Cardinal;
  public
    rangeStart: cardinal;
    rangeEnd: cardinal;
    URI: string;
    IdHTTP: TIdHTTP2;
    Content: string;
    constructor Create(const URI: string;
                       const LastModified: string = '';
                       RangeStart: Cardinal = 0;
                       RangeEnd: Cardinal = 0);
    destructor Destroy; override;
    procedure Execute; override;
    procedure Kill;
    function GetLastModified: string;
    function GetDate: string;
    function GetAsyncResponseCode: integer;
    function GetString: string;
    procedure Cancel;
    procedure Restart(const URL: string);
    property TransferedSize: Cardinal read GetTransferedSize;
  end;
  (*-------------------------------------------------------*)
  TAsyncManager = class(TObject)
  private
    procList: TList;
    procCount: ShortInt;
    procedure OnAsyncTerminateProc(Sender: TObject);
    function GetObjectCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Get(const URI: string;
                 OnTerminate: TAsyncDone;
                 OnNotify: TAsyncNotify = nil;
                 const LastModified: string = '';
                 RangeStart: Cardinal = 0;
                 RangeEnd: Cardinal = 0;
                 reqType: TAsyncReqRequestType = agrtGet): TAsyncReq;
    function Post(const URI: string;
                  const PostDat: string;
                  const referer: string;
                  const CustomHeaders: TStrings;
                  OnTerminate: TAsyncDone;
                  OnNotify: TAsyncNotify = nil): TAsyncReq;
    procedure WaitForTerminateAll;
    {$IFDEF DEBUG}
    procedure Dump;
    {$ENDIF}
    property Count: Integer read GetObjectCount;
  end;


(*=======================================================*)
implementation
(*=======================================================*)

uses
  Main, JConfig;

const
  NotifyCodeMap: array[TIdHTTP2NotifyCode] of TAsyncNotifyCode
                 = (ancCONNECT, ancREQUEST, ancRESPONSE);

var
  DEBUG_ENABLED: boolean = TRUE;
  ProcListMaximum: Integer = 3;
  
(*=======================================================*)
constructor TCallbackStream.Create;
begin
  OnWrite := nil;
  inherited;
end;

function TCallbackStream.Write(const Buffer; Count: Longint): Longint;
begin
  result := inherited Write(Buffer, Count);
  if Assigned(OnWrite) then
  begin
    OnWrite(self, Buffer, Count);
    if Count < result then
      result := Count;
  end;
end;

(*=======================================================*)

constructor TAsyncReq.Create(const URI: string;
                             const LastModified: string = '';
                             RangeStart: Cardinal = 0;
                             RangeEnd: Cardinal = 0);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  IdHTTP := TIdHTTP2.Create(nil);
  IdHTTP.AllowCookies := FALSE;
  (* IdHTTP.Request.CacheControl := 'no-cache'; *)
  IdHTTP.Request.Connection := 'close';
  if Config.netUseProxy then
  begin
    if Config.netNoCache then
    begin
      IdHTTP.Request.Pragma := 'no-cache';
      IdHTTP.Request.CacheControl := 'no-cache';
    end;
  {$IFDEF INDY901B}
    IdHTTP.Request.ProxyParams.ProxyServer := Config.netProxyServer;
    IdHTTP.Request.ProxyParams.ProxyPort   := Config.netProxyPort;
  {$ELSE}
    IdHTTP.ProxyParams.ProxyServer := Config.netProxyServer;
    IdHTTP.ProxyParams.ProxyPort   := Config.netProxyPort;
  {$ENDIF}
  end;
  IdHTTP.ReadTimeout := Config.netReadTimeout;
  IdHTTP.RecvBufferSize := Config.netRecvBufferSize * 1024;
  //IdHTTP.Request.UserAgent := GetUserAgent;

  IdHTTP.OnNotify := OnHTTPNotifyProc;

  self.URI := URI;
  self.lastModified := LastModified;
  self.rangeStart := RangeStart;
  self.rangeEnd   := RangeEnd;

  OnNotify := nil;
  AsyncDone := nil;

  compressedSize := 0;
  uncompressedSize := 0;

  reqType := agrtGet;

  canceled := false;

  synchro := THogeMutex.Create;
end;

destructor TAsyncReq.Destroy;
begin
  if Assigned(IdHTTP) then
    IdHTTP.Free;
  synchro.Free;
  inherited;
end;

procedure TAsyncReq.Kill;
begin
  Terminate;
  if not TerminateThread(self.Handle, High(cardinal)) then
    MessageDlg(Format('（(；ﾟДﾟ) スレッド $%Xを頃せません･･･', [ThreadID]),
               mtWarning, [mbOK], 0);
end;

procedure TAsyncReq.QueryProc;
var
  postStream: TStringStream;
  UriObj: TIdURI;
begin
  if reqType = agrtGet then
  begin
    IdHTTP.Request.ContentRangeStart := RangeStart;
    IdHTTP.Request.ContentRangeEnd := RangeEnd;
    if (RangeStart = 0) and (RangeEnd = 0) and
       (CompareText(ExtractFileExt(URI),'.gz') <> 0) then
      IdHTTP.Request.AcceptEncoding := 'gzip';
  end;
  IdHTTP.Request.CustomHeaders.Values['If-Modified-Since'] := LastModified;
  unzipError := false;
  uncompressedStream := nil;
  decompressor := nil;
  resStream := nil;
  uncompressedSize := 0;
  compressedSize := 0;
  postStream := nil;

  URIObj := TIdURI.Create(URI);
  if URIObj.Username <> '' then
    IdHTTP.Request.BasicAuthentication := True;
  URIObj.Free;

  try
    case reqType of
    agrtGet:
      begin
        resStream := TCallbackStream.Create;
        resStream.OnWrite := OnWriteProc;
        IdHTTP.Get(URI, resStream);
      end;
    agrtHead:
      begin
        IdHTTP.Head(URI);
        resStream := TCallbackStream.Create;
      end;
    agrtPost:
      begin
        postStream := TStringStream.Create(postData);
        resStream := TCallbackStream.Create;
        resStream.OnWrite := OnWriteProc;
        IdHTTP.Post(URI, postStream, resStream);
      end;
    end;
  except
    On e: Exception do
    begin
      Content := '';
      if not e.ClassNameIs('EWriteError') then
        Log(e.Message);
    end;
    else begin
      Content := '';
    end;
  end;

  if resStream <> nil then
    resStream.Free;
  if uncompressedStream <> nil then
    uncompressedStream.Free;
  if decompressor <> nil then
    decompressor.Free;
  if postStream <> nil then
    postStream.Free;

  if Config.tstCommHeaders and (0 < uncompressedSize) and (0 < compressedSize) then
    Log(Format('圧縮比 %d : %d (%2.3g%%  平均：%2.3g%% [%d samples])',
               [compressedSize, uncompressedSize,
                100 * compressedSize / uncompressedSize,
                Config.compressRatio * 100, Config.compressRatioSamples]));
end;

procedure TAsyncReq.Execute;
begin
  repeat
    Notify(ancPRECONNECT);
    if not canceled then
    begin
      QueryProc;
      canceled := true;
      Notify(ancPRETERMINATE);
    end;
  until canceled;
  try
    IdHTTP.Disconnect;
  except
  end;
end;

procedure TAsyncReq.Restart(const URL: string);
begin
  URI := URL;
  canceled := false;
end;

procedure TAsyncReq.OnWriteProc(sender: TObject; const Buffer; var Count: Longint);
  procedure AppendChunk(stream: TStream);
  var
    len: integer;
    position: cardinal;
    size: integer;
  begin
    position := stream.Position;
    size := position - uncompressedSize;
    if size <= 0 then
      exit;

    synchro.Wait;
    len := length(Content);
    SetLength(Content, len + size);
    stream.Position := uncompressedSize;
    stream.Read(Content[1+len], size);
    Inc(uncompressedSize, size);
    stream.Position := position;
    synchro.Release;
  end;
begin
  if canceled then
  begin
    Count := 0;
    exit;
  end;
  if assigned(decompressor) then
  begin
    try
      if (0 < Count) then
      begin
        Inc(compressedSize, Count);
        decompressor.Write(Buffer, Count);
        AppendChunk(uncompressedStream);
      end;
    except
      decompressor.Free;
      decompressor := nil;
      uncompressedStream.Free;
      uncompressedStream := nil;
      unzipError := true;
      Count := 0;
      exit;
    end;
  end
  else
    AppendChunk(resStream);
  Notify(ancPROGRESS);
end;

procedure TAsyncReq.OnHTTPNotifyProc(sender: TObject; notifyCode: TIdHTTP2NotifyCode);
begin
  if notifyCode = idHttp2nResponse then
  begin
    if (CompareText(IdHTTP.Response.ContentEncoding, 'gzip') = 0) or
       (CompareText(IdHTTP.Response.ContentEncoding, 'x-gzip') = 0) then
    begin
      uncompressedStream := TMemoryStream.Create;
      decompressor := TGzipDecompressStream.Create(uncompressedStream);
    end;
  end;
  Notify(NotifyCodeMap[notifyCode]);
end;

procedure TAsyncReq.Notify(code: TAsyncNotifyCode);
begin
  OnAsyncNotifyProc(code);
end;

const reqMethod: array[TAsyncReqRequestType] of string = ('GET', 'HEAD', 'POST');
(* HTTP進行状況 *)
procedure TAsyncReq.OnAsyncNotifyProc(code: TAsyncNotifyCode);
  function ProtocolVersion: string;
  begin
    case IdHTTP.ProtocolVersion of
    pv1_0: result := 'HTTP/1.0';
    pv1_1: result := 'HTTP/1.1';
    else  result := 'unknown';
    end;
  end;
var
  i: integer;
  trace: boolean;
  NotifyProc: TAsyncNotify;     (* ここは自分で呼ぶ *)
begin
  if Config.tstEnableHTTPTrace and DEBUG_ENABLED then
    trace := Config.tstCommHeaders
  else
    trace := false;
  case code of
  ancCONNECT:
    begin
      if trace then
        Log(reqMethod[reqType] +  ' ' + URI + ' ' + ProtocolVersion);
    end;
  ancREQUEST:
    begin
      if trace then
      begin
        BeginMultiLog;
        for i := 0 to IdHTTP.Request.RawHeaders.Count -1 do
          Log(IdHTTP.Request.RawHeaders.Strings[i]);
        EndMultiLog;
      end;
    end;
  ancRESPONSE:
    begin
      if Config.tstCommHeaders then
        Log(IdHTTP.ResponseText);
      if trace then
      begin
        BeginMultiLog;
        for i := 0 to IdHTTP.Response.RawHeaders.Count -1 do
          Log(IdHTTP.Response.RawHeaders.Strings[i]);
        EndMultiLog;
      end;
    end;
  ancPROGRESS:
    begin
    end;
  ancEUNZIP:
    begin
      if trace then
        Log('unzip exception');
    end;
  end;
  (* イベントハンドラを呼ぶ *)
  synchro.Wait;
  NotifyProc := OnNotify;
  synchro.Release;
  if Assigned(NotifyProc) then
    NotifyProc(self, code);
end;




function TAsyncReq.GetLastModified: string;
begin
  result := IdHTTP.Response.RawHeaders.Values['Last-Modified'];
end;

function TAsyncReq.GetDate: string;
begin
  result := IdHTTP.Response.RawHeaders.Values['Date'];
end;

function TAsyncReq.GetAsyncResponseCode: integer;
var
  i: integer;
begin
  result := 0;
  i := Pos(' ', IdHTTP.ResponseText);
  if 0 < i then
  begin
    for i := i + 1 to length(IdHTTP.ResponseText) do
    begin
      if (IdHTTP.ResponseText[i] in ['0'..'9']) then
        result := result * 10 + (Ord(IdHTTP.ResponseText[i]) - Ord('0'))
      else
        break;
    end;
  end;
end;

function TAsyncReq.GetString: string;
begin
  synchro.Wait;
  begin
    result  := Content;
    Content := '';
  end;
  synchro.Release;
end;

procedure TAsyncReq.Cancel;
begin
  synchro.Wait;
  begin
    canceled := true;
    OnNotify := nil;
    try
      IdHTTP.Disconnect;
    except
    end;
  end;
  synchro.Release;
end;

function TAsyncReq.GetTransferedSize: Cardinal;
begin
  if 0 < compressedSize then
    result := compressedSize
  else
    result := uncompressedSize;
end;


(*=======================================================*)
constructor TAsyncManager.Create;
begin
  procList := TList.Create;
  procCount := 0;
end;

destructor TAsyncManager.Destroy;
var
  i: integer;
  proc: TAsyncReq;
begin
  for i := 0 to procList.Count -1 do
  begin
    proc := TAsyncReq(procList.Items[i]);
    if Assigned(proc) then
      proc.Kill;
  end;
  procList.Free;
  inherited;
end;

function TAsyncManager.Get(const URI: string;
                     OnTerminate: TAsyncDone;
                     OnNotify: TAsyncNotify = nil;
                     const LastModified: string = '';
                     RangeStart: Cardinal = 0;
                     RangeEnd: Cardinal = 0;
                     reqType: TAsyncReqRequestType = agrtGet): TAsyncReq;
var
  proc: TAsyncReq;
begin
//  if ProcListMaximum * 2 <= procList.Count then   //aiai
//  begin
//    Log('（；´∀｀）同時リクエスト制限数超過');
//    result := nil;
//    exit;
//  end;
  if not (reqType in [agrtGet, agrtHead]) then
  begin
    result := nil;
    exit;
  end;
  proc := TAsyncReq.Create(URI, LastModified, RangeStart, RangeEnd);
  proc.AsyncDone := OnTerminate;
  proc.OnNotify := OnNotify;

  proc.OnTerminate := OnAsyncTerminateProc;
  proc.reqType := reqType;
  procList.Add(proc);
  if procList.Count <= ProcListMaximum then
  begin
    proc.Resume;
    Inc(procCount);
  end;
  result := proc;
  MainWnd.UpdateIndicatorEx(procCount);
end;

function TAsyncManager.Post(const URI: string;
                            const PostDat: string;
                            const referer: string;
                            const CustomHeaders: TStrings;
                            OnTerminate: TAsyncDone;
                            OnNotify: TAsyncNotify = nil): TAsyncReq;
var
  proc: TAsyncReq;
  i: integer;
begin
  if ProcListMaximum * 2 + 1 <= procList.Count then
  begin
    Log('（；´∀｀）同時リクエスト制限数超過');
    result := nil;
    exit;
  end;
  proc := TAsyncReq.Create(URI, '', 0, 0);
  proc.AsyncDone := OnTerminate;
  proc.OnNotify := OnNotify;

  proc.OnTerminate := OnAsyncTerminateProc;
  proc.reqType := agrtPost;
  proc.postData := PostDat;
  if Config.netUseProxy then
  begin
  {$IFDEF INDY901B}
    proc.IdHTTP.Request.ProxyParams.ProxyServer := Config.netProxyServerForWriting;
    proc.IdHTTP.Request.ProxyParams.ProxyPort   := Config.netProxyPortForWriting;
  {$ELSE}
    proc.IdHTTP.ProxyParams.ProxyServer := Config.netProxyServerForWriting;
    proc.IdHTTP.ProxyParams.ProxyPort   := Config.netProxyPortForWriting;
  {$ENDIF}
  end;
  proc.IdHTTP.Request.Referer := referer;
  proc.IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  if CustomHeaders <> nil then
  begin
    for i := 0 to CustomHeaders.Count -1 do
      proc.IdHTTP.Request.CustomHeaders.Add(CustomHeaders.Strings[i]);
  end;
  procList.Add(proc);
  if procList.Count <= ProcListMaximum + 1 then
  begin
    proc.Resume;
    Inc(procCount);
  end;
  result := proc;
  MainWnd.UpdateIndicatorEx(procCount);
end;


procedure TAsyncManager.OnAsyncTerminateProc(Sender: TObject);
var
  i, j: integer;
  proc: TAsyncReq;
begin
  for i := 0 to procList.Count -1 do
  begin
    if TObject(procList.Items[i]) = Sender then
    begin
      procList.Delete(i);
      Dec(procCount);
      proc := (Sender as TAsyncReq);
      (* 統計情報 *)
      Config.AddSample(proc.compressedSize, proc.uncompressedSize);
      if Assigned(proc.AsyncDone) then
        proc.AsyncDone(proc);
      for j := 0 to procList.Count -1 do
        if TAsyncReq(procList.Items[j]).Suspended then
        begin
          TAsyncReq(procList.Items[j]).Resume;
          Inc(procCount);
          break;
        end;
      MainWnd.UpdateIndicatorEx(procCount);
      exit;
    end;
  end;
  MainWnd.UpdateIndicatorEx(procCount);
end;

procedure Sleep(ms: cardinal); stdcall; external 'kernel32.dll';
procedure TAsyncManager.WaitForTerminateAll;
var
  i: integer;
begin
  for i := 0 to procList.Count -1 do
    TAsyncReq(procList.Items[i]).Cancel;
  i := 0;
  while 0 < procList.Count do
  begin
    Application.ProcessMessages;
    Sleep(200);
    Inc(i);
    if 25 <= i then
      break;
  end;
  for i := 0 to procList.Count -1 do
    TAsyncReq(procList.Items[i]).Kill;
end;

function TAsyncManager.GetObjectCount: Integer;
begin
  result := procList.Count;
end;


{$IFDEF DEBUG}
procedure TAsyncManager.Dump;
var
  i: integer;
begin
  Log(Format('async %d', [procList.Count]));
  for i := 0 to procList.Count -1 do
    Log(Format('  %d: %s', [i, TAsyncReq(procList[i]).IdHTTP.Request.URL]));
end;

{$ENDIF}

end.
