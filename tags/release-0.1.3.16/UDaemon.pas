unit UDaemon;
(* 別スレッド→VCLスレッド へのAgent *)
(* Copyright (c) 2001,2002 hetareprog@hotmail.com *)

interface
uses
  Classes, SysUtils,
  USynchro;

type
  (*-------------------------------------------------------*)
  TSynchroReq = class(TObject)
  public
    procedure Call; virtual; abstract;
  end;
  TSynchroCallProcedure = procedure() of object;
  TSynchroCallReq = class(TSynchroReq)
  public
    callProc: TSynchroCallProcedure;
    constructor Create(sub: TSynchroCallProcedure);
    procedure Call; override;
  end;

  (*-------------------------------------------------------*)
  TDaemon = class(TThread)
  private
    logMutex: THogeMutex;
    logList: TStringList;
    savedLogList: TStringList;
    request: THogeEvent;

    reqList: TList;
    savedReqList: TList;
    procedure SynchroProcess;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Log(const str: string);
    procedure Execute; override;
    procedure LogLock;
    procedure LogFree;
    procedure RequestChunk;
    procedure Post(req: TSynchroReq); overload;
    procedure Post(proc: TSynchroCallProcedure); overload;
  end;

  (*-------------------------------------------------------*)
  TWaitTimer = class(TThread)
  private
    procedure SetInterval(const Value: Cardinal);
  protected
    FEnabled: Boolean;
    FInterval: Cardinal;
    FOnTimer: TNotifyEvent;
    FEvent: THogeEvent;
    FSync: THogeCriticalSection;
    procedure Execute; override;
    procedure DoTimer;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure SetBack;
    procedure Cancel;
    property Interval: Cardinal read FInterval write SetInterval;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

(*=======================================================*)
implementation
(*=======================================================*)

uses
  Main;

constructor TSynchroCallReq.Create(sub: TSynchroCallProcedure);
begin
  callProc := sub;
end;

procedure TSynchroCallReq.Call;
begin
  callProc;
end;

constructor TDaemon.Create;
begin
  self.FreeOnTerminate := false;
  logMutex := THogeMutex.Create(false);
  logList := TStringList.Create;
  savedLogList := TStringList.Create;
  request := THogeEvent.Create;

  reqList := TList.Create;
  savedReqList := TList.Create;
  inherited Create(false);
end;

destructor TDaemon.Destroy;
begin
  logMutex.Free;
  logList.Free;
  request.Free;
  reqList.Free;
  savedReqList.Free;
  savedLogList.Free;
end;

procedure TDaemon.Log(const str: string);
begin
  if logMutex.Wait = WAIT_OBJECT_0 then
  begin
    logList.Add(str);
    logMutex.Release;
    self.request.SetEvent;
  end;
end;



procedure TDaemon.SynchroProcess;
  procedure ProcessLogger;
  var
    tmpList: TStringList;
    i: integer;
  begin
    if logMutex.Wait = WAIT_OBJECT_0 then
    begin
      tmpList := self.logList;
      self.logList := self.savedLogList;
      self.savedLogList := tmpList;
      logMutex.Release;
    end;
    for i := 0 to savedLogList.Count -1 do
      MainWnd.WriteLog(savedLogList.Strings[i]);
    savedLogList.Clear;
  end;

  procedure ProcessCaller;
  var
    tmpList: TList;
    i: integer;
  begin
    if logMutex.Wait = WAIT_OBJECT_0 then
    begin
      tmpList := self.reqList;
      self.reqList := self.savedReqList;
      self.savedReqList := tmpList;
      logMutex.Release;
    end;
    for i := 0 to savedReqList.Count -1 do
    begin
      TSynchroReq(savedReqList.Items[i]).call;
      TSynchroReq(savedReqList.Items[i]).Free;
    end;
    savedReqList.Clear;
  end;
begin
  ProcessLogger;
  ProcessCaller;
end;


procedure TDaemon.Execute;
begin
  while not Terminated do
  begin
    if request.Wait = WAIT_OBJECT_0 then
    begin
      if Terminated then
        break;
      Synchronize(SynchroProcess);
    end;
  end;
end;

procedure TDaemon.LogLock;
begin
  self.logMutex.Wait;
end;

procedure TDaemon.LogFree;
begin
  self.logMutex.Release;
end;

procedure TDaemon.RequestChunk;
begin
  self.request.SetEvent;
end;

procedure TDaemon.Post(req: TSynchroReq);
begin
  if self.logMutex.Wait = WAIT_OBJECT_0 then
  begin
    self.reqList.Add(req);
    self.logMutex.Release;
    self.request.SetEvent;
  end;
end;

procedure TDaemon.Post(proc: TSynchroCallProcedure);
begin
  if self.logMutex.Wait() = WAIT_OBJECT_0 then
  begin
    self.reqList.Add(TSynchroCallReq.Create(proc));
    self.logMutex.Release;
    self.request.SetEvent;
  end;
end;


(*=======================================================*)

{ TWaitTimer }

//シグナル(Reset)後、??秒間次のシグナルが来ないとイベント発生

constructor TWaitTimer.Create;
begin
  FInterval := 100;
  FreeOnTerminate := False;
  FEvent := THogeEvent.Create(False, False, nil);
  FSync := THogeCriticalSection.Create;
  inherited Create(False);
end;

destructor TWaitTimer.Destroy;
begin
  Suspend;
  Terminate;
  FEvent.SetEvent;
  Resume;
  WaitFor;
  FSync.Free;
  FEvent.Free;
  inherited;
end;

procedure TWaitTimer.DoTimer;
begin
  if FEnabled and Assigned(FOnTimer) then
    FOnTimer(Self);
end;

procedure TWaitTimer.Execute;
var
  WaitResult: Cardinal;
  CurrentInterval: Cardinal;
begin
  while not Terminated do
  begin
    FEvent.Wait;
    FSync.Enter;
    CurrentInterval := FInterval;
    FSync.Leave;
    WaitResult := WAIT_OBJECT_0;
    while (not Terminated) and (WaitResult = WAIT_OBJECT_0) do
      WaitResult :=FEvent.Wait(CurrentInterval);
    if not Terminated then
      Synchronize(DoTimer);
  end;
end;

procedure TWaitTimer.SetBack;
begin
  FEnabled := True;
  FEvent.SetEvent;
end;

procedure TWaitTimer.Cancel;
begin
  FEnabled := False;
  FEvent.SetEvent;
end;


procedure TWaitTimer.SetInterval(const Value: Cardinal);
begin
  FSync.Enter;
  FInterval := Value;
  FEvent.SetEvent;
  FSync.Leave;
end;


end.
