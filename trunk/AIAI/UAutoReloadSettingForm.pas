unit UAutoReloadSettingForm;

interface

uses
  Windows, Messages, Classes, Controls, Forms, StdCtrls, JConfig, JLXPSpin;

type
  TAutoReloadSettingForm = class(TForm)
    OKButton: TButton;
    IntervalSpinEdit: TJLXPSpinEdit;
    Label1: TLabel;
    CancelButton: TButton;
    DefaultButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DefaultButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

implementation

uses
  Main;

{$R *.dfm}

procedure TAutoReloadSettingForm.FormCreate(Sender: TObject);
begin
  IntervalSpinEdit.Value := Config.oprAutoReloadInterval;
end;

procedure TAutoReloadSettingForm.DefaultButtonClick(Sender: TObject);
begin
  IntervalSpinEdit.Value := Config.oprAutoReloadInterval;
end;

procedure TAutoReloadSettingForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if modalResult = mrOK then
  begin
    Config.oprAutoReloadInterval := IntervalSpinEdit.Value;
    Config.Modified := true;
  end;
end;

end.
