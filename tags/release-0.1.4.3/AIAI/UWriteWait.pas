unit UWriteWait;

///////////////////////////////////////////////////////////////////////////////
//
//function IsThisHost(const ADomainName: String): Boolean;
//  DomainName(ex7.2ch.netなど)がWriteWait中かどうか
//procedure Start(const ADomainName: String; ATimeForWait: Cardinal);
//  DomainName(ex7.2ch.netなど)に対してATimeForWait(ミリ秒)だけ
//  カウントダウンを始める
//procedure Stop;
//  カウントダウンを止める
//
//property Remainder;
//  残り時間(秒)
//
//property OnNotify: TWriteWaitEvent
//  カウントダウンの進歩イベント　
//property OnEnd: TNotifyEven
//  カウントダウン終了イベント
//
//TWriteWaitEvent = procedure (Sender: TObject; Remainder: Integer) of Object;
//  Remainderは残り時間(秒)
//
///////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, ExtCtrls, StrUtils, Math;

type
  TWriteWaitEvent = procedure (Sender: TObject; DomainName: String;
    Remainder: Integer) of Object;

  TWriteWaitTimer = class(TObject)
  private
    FWaitTimer: TTimer;       //100ミリ秒のタイマー
    FDomainName: String;      //対象サーバ(ex7.2ch.netなど)
    FTimeForWait: Cardinal;   //待つ時間(ミリ秒)
    FWaitCount: Cardinal;     //タイマーをスタートさせた時の時間

    FNotify: TWriteWaitEvent;
    FEnd: TNotifyEvent;

    procedure WaitTimerTimer(Sender: TObject);

    function GetRemainder: Integer;

    procedure DoNitify(Remainder: Integer);
    procedure DoEnd;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    function IsThisHost(const ADomainName: String): Boolean;
    procedure Start(const ADomainName: String; ATimeForWait: Cardinal);
    procedure Stop;

    property Remainder: Integer read GetRemainder;
    property OnNotify: TWriteWaitEvent read FNotify write FNotify;
    property OnEnd: TNotifyEvent read FEnd write FEnd;
  end;

implementation


 { TWriteWaitTimer }

constructor TWriteWaitTimer.Create;
begin
  FDomainName := '';
  FTimeForWait := 0;
  FWaitCount := 0;
  FWaitTimer := TTimer.Create(nil);
  FWaitTimer.Enabled := False;
  FWaitTimer.Interval := 100;
  FWaitTimer.OnTimer := WaitTimerTimer;
end;

destructor TWriteWaitTimer.Destroy;
begin
  FWaitTimer.Free;

  inherited Destroy;
end;

function TWriteWaitTimer.IsThisHost(const ADomainName: String): Boolean;
begin
  result := False;
  if (Length(FDomainName) <= 0)
     or (Length(ADomainName) <= 0)
       or not FWaitTimer.Enabled then
    exit;
  result := AnsiCompareText(FDomainName, ADomainName) = 0;
end;

procedure TWriteWaitTimer.Start(const ADomainName: String;
  ATimeForWait: Cardinal);
begin
  FWaitTimer.Enabled := False;
  if (Length(ADomainName) <= 0) or (ATimeForWait = 0) then
  begin
    FDomainName := '';
    FTimeForWait := 0;
    FWaitCount := 0;
    DoEnd;
  end else
  begin
    FDomainName := ADomainName;
    FTimeForWait := ATimeForWait;
    FWaitCount := GetTickCount;
    FWaitTimer.Enabled := True;
  end;
end;

procedure TWriteWaitTimer.Stop;
begin
  FWaitTimer.Enabled := False;
  FDomainName := '';
  FTimeForWait := 0;
  FWaitCount := 0;
  DoEnd;
end;




procedure TWriteWaitTimer.WaitTimerTimer(Sender: TObject);
var
  NowAt: Cardinal;
  Remainder: Double;
begin
  NowAt := GetTickCount;
  if NowAt < FWaitCount then
    Remainder := Integer(FTimeForWait - (NowAt + (high(Cardinal) - FWaitCount) + 1)) / 1000
  else
    Remainder := Integer(FTimeForWait - (NowAt - FWaitCount)) / 1000;

  if Remainder <= 0 then
  begin
    FWaitTimer.Enabled := False;
    DoEnd;
  end else
  begin
     DoNitify(Ceil(Remainder));
  end;
end;





function TWriteWaitTimer.GetRemainder: Integer;
var
  NowAt: Cardinal;
begin
  NowAt := GetTickCount;
  if NowAt < FWaitCount then
    Result := Ceil(Integer(FTimeForWait - (NowAt + (high(Cardinal) - FWaitCount) + 1)) / 1000)
  else
    Result := Ceil(Integer(FTimeForWait - (NowAt - FWaitCount)) / 1000);
end;





procedure TWriteWaitTimer.DoNitify(Remainder: Integer);
begin
  if Assigned(FNotify) then
    FNotify(Self, FDomainName, Remainder);
end;

procedure TWriteWaitTimer.DoEnd;
begin
  if Assigned(FEnd) then
    FEnd(Self);
end;

end.
