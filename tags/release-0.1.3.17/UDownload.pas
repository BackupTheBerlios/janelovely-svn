unit UDownload;
(* Copyright (c) 2002 Twiddle <hetareprog@hotmail.com> *)

interface

uses
  Classes,
  SysUtils,
  ExtCtrls,
  Dialogs,
  DateUtils,
  U2chCatList,
  U2chCat,
  U2chBoard,
  U2chThread,
  UAsync;

type
  (*-------------------------------------------------------*)
  TDownloadState = (dsFREE, dsDOWNLOAD, dsINTERVAL, dsDRAIN);
  TDownloadNotify = procedure(Sender: TObject; thread: TThreadItem) of Object;
  TDownloader = class (TStringList)
  protected
    FOwner: TComponent;
    FState: TDownloadState;
    FStartTime: TDateTime;
    FLimitBytesPerSec: Cardinal;
    FSpeedLimiter: TTimer;
    FOnNotify: TDownloadNotify;
    procedure SetTimer(interval: Cardinal);
    procedure FreeTimer;
    procedure BeginDownload;
    procedure ProcessDownload;
    procedure OnTimer(Sender: TObject);
    procedure OnEndDownload(thread: TThreadItem);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Add(const URI: string);
    procedure Drain;
    function IsLimit: boolean;
    property OnNotify: TDownloadNotify read FOnNotify write FOnNotify;
  end;


(*=======================================================*)
implementation
(*=======================================================*)
{$B-}

uses
  Main;

const
  LIMIT_BYTES_PER_SEC = (56 div 8 * 1024);
  CROWDED_INTERVAL    = 3000;
  TEST_MAX            = 30;


var
  counter: Integer = 0;

constructor TDownloader.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner;
  FLimitBytesPerSec := LIMIT_BYTES_PER_SEC;
  FStartTime := 0;
  FSpeedLimiter := nil;
  FOnNotify := nil;
end;

destructor TDownloader.Destroy;
begin
  FreeTimer;
  inherited;
end;

procedure TDownloader.FreeTimer;
begin
  if Assigned(FSpeedLimiter) then
  begin
    FSpeedLimiter.Free;
    FSpeedLimiter := nil;
  end;
end;

procedure TDownloader.SetTimer(interval: Cardinal);
begin
  FState := dsINTERVAL;
  if not Assigned(FSpeedLimiter) then
    FSpeedLimiter := TTimer.Create(FOwner);
  FSpeedLimiter.OnTimer := OnTimer;
  FSpeedLimiter.Interval := interval;
  FSpeedLimiter.Enabled := True;
end;

procedure TDownloader.Add(const URI: string);
begin
  if 0 <= IndexOf(URI) then
    exit;
  if IsLimit then
  begin
    MessageDlg('(°д°)･･･', mtWarning, [mbOK], 0);
    exit;
  end;
  inc(counter);
  inherited Add(URI);
 {Log('Qﾆ（･∀･） ' + IntToStr(Count) + 'ｺ');
  StatLog('ﾘﾐｯﾄ（･∀･）ｱﾄ ' + IntToStr(TEST_MAX - counter));}
  Log2(32, IntToStr(Count) + 'ｺ');            //ayaya
  StatLog2(33, IntToStr(TEST_MAX - counter)); //ayaya
  BeginDownload;
end;

procedure TDownloader.BeginDownload;
var
  interval: integer;
  currentTime: TDateTime;
begin
  if Count <= 0 then
  begin
   {Log('（･∀･）ｵﾜﾘ');
    StatLog('ﾘﾐｯﾄ（･∀･）ｱﾄ ' + IntToStr(TEST_MAX - counter));}
    Log2(34, '');                                 //ayaya
    StatLog2(35, IntToStr(TEST_MAX - counter));   //ayaya
    exit;
  end;
  case FState of
  dsFREE:;
  else
    exit;
  end;
  currentTime := Now;
  if FStartTime <= currentTime then
  begin
    ProcessDownload;
    exit;
  end;
  interval := Trunc((FStartTime - currentTime) * 24 * 60 * 60 * 1000);
  SetTimer(interval);
  {ayaya}
  if useTrace[36] then
    Log('ｱﾄ ' + IntToStr(Count) + traceString[36] + DateTimeToStr(FStartTime));
  {//ayaya}
 {Log('ｱﾄ ' + IntToStr(Count) + 'ｺ（･∀･）ｼﾞｶｲﾊ ' + DateTimeToStr(FStartTime));}
end;

procedure TDownloader.OnTimer(Sender: TObject);
begin
  FreeTimer;
  if FState = dsINTERVAL then
  begin
    FState := dsFREE;
    ProcessDownload;
  end;
end;

procedure TDownloader.ProcessDownload;
var
  URI: string;
  board: TBoard;
  thread: TThreadItem;
  host, bbs, datnum: string;
  oldLog: boolean;
  index: integer;
begin
  if FState <> dsFREE then
    exit;
  while 0 < Count do
  begin
    FState := dsDOWNLOAD;
    URI := Strings[0];
    Delete(0);

    Get2chInfo(URI, host, bbs, datnum, index, oldLog);
    if length(datnum) <= 0 then
      continue;
    board := Main.i2ch.FindBoard(host, bbs);
    if board = nil then
      continue;
    board.AddRef;
    thread := board.Find(datnum);
    if thread <> nil then
    begin
      if thread.Downloading then
      begin
        board.Release;
        continue;
      end;
    end
    else begin
      thread := TThreadItem.Create(board);
      thread.datName := datnum;
      thread.URI := 'http://' + host + '/' + bbs;
      board.Add(thread);
    end;
    board.Release;
    if oldLog and (thread.state <> tsComplete) then
      thread.queryState := tsHistory1;
    FStartTime := Now;
    case thread.StartAsyncRead(OnEndDownload, nil) of
    trrSuccess: exit;
    trrErrorProgress,
    trrErrorPermanent: continue;
    trrErrorTemporary:
      begin
        FStartTime := 0;
        Insert(0, URI);
        SetTimer(CROWDED_INTERVAL);
        exit;
      end;
    else
      begin
        Clear;
        exit;
      end;
    end;
  end;
  FState := dsFREE;
 {Log('（･∀･）ｵﾜﾘ');
  StatLog('ﾘﾐｯﾄ（･∀･）ｱﾄ ' + IntToStr(TEST_MAX - counter));}
  Log2(37, '');                                //ayaya
  StatLog2(38, IntToStr(TEST_MAX - counter));  //ayaya
end;

procedure TDownloader.OnEndDownload(thread: TThreadItem);
begin
  FState := dsFREE;
  FStartTime := FStartTime +
                (thread.TransferedSize / FLimitBytesPerSec)/(24*60*60);
  if Assigned(FOnNotify) then
    FOnNotify(Self, thread);
  if FStartTime <= Now then
    FStartTime := IncSecond(Now); 
  BeginDownload;
end;

procedure TDownloader.Drain;
begin
  FState := dsDRAIN;
  FreeTimer;
  Clear;
end;

function TDownloader.IsLimit: Boolean;
begin
  if 30 <= (Now - FStartTime)*24*60 then
    counter := 0;
  result := (TEST_MAX <= counter);
end;

end.
