unit UNewsSettingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TSettingType = (TInterval, TBarSize);

  TNewsSettingForm = class(TForm)
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label1: TLabel;
    SpinEditNewsInterval: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    Flag: TSettingType;
  end;

implementation

uses
  UNews, Main;

{$R *.dfm}

procedure TNewsSettingForm.FormCreate(Sender: TObject);
begin
  SpinEditNewsInterval.Value := Mynews.getChangeNewsTimerInterval div 1000;
  Flag := TInterval;
end;

procedure TNewsSettingForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if modalResult = mrOK then
  begin
    if Flag = TInterval then
    begin
      Mynews.setChangeNewsTimerInterval(SpinEditNewsInterval.Value * 1000);
      Config.tstNewsInterval := SpinEditNewsInterval.Value;
    end else
      Config.tstNewsBarSize := SpinEditNewsInterval.Value;
    Config.Modified := True;
  end;
end;

end.
