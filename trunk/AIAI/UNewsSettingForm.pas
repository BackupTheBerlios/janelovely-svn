unit UNewsSettingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
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
  end;

implementation

uses
  UNews, Main;

{$R *.dfm}

procedure TNewsSettingForm.FormCreate(Sender: TObject);
begin
  SpinEditNewsInterval.Value := Mynews.getChangeNewsTimerInterval div 1000;
end;

procedure TNewsSettingForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if modalResult = mrOK then
    Mynews.setChangeNewsTimerInterval(SpinEditNewsInterval.Value * 1000);
end;

end.
