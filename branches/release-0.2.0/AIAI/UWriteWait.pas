unit UWriteWait;

///////////////////////////////////////////////////////////////////////////////
//
//function IsThisHost(const ADomainName: String): Boolean;
//  DomainName(ex7.2ch.net�Ȃ�)��WriteWait�����ǂ���
//procedure Start(const ADomainName: String; ATimeForWait: Cardinal);
//  DomainName(ex7.2ch.net�Ȃ�)�ɑ΂���ATimeForWait(�~���b)����
//  �J�E���g�_�E�����n�߂�
//procedure Stop;
//  �J�E���g�_�E�����~�߂�
//
//property Remainder;
//  �c�莞��(�b)
//
//property OnNotify: TWriteWaitEvent
//  �J�E���g�_�E���̐i���C�x���g�@
//property OnEnd: TNotifyEven
//  �J�E���g�_�E���I���C�x���g
//
//TWriteWaitEvent = procedure (Sender: TObject; Remainder: Integer) of Object;
//  Remainder�͎c�莞��(�b)
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
    FWaitTimer: TTimer;       //100�~���b�̃^�C�}�[
    FDomainName: String;      //�ΏۃT�[�o(ex7.2ch.net�Ȃ�)
    FTimeForWait: Cardinal;   //�҂���(�~���b)
    FWaitCount: Cardinal;     //�^�C�}�[���X�^�[�g���������̎���

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
