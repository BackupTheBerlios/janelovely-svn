unit UAutoScrollSettingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Jconfig;

type
  TAutoScrollSettingForm = class(TForm)
    LabelScrollLines: TLabel;
    LabelInterval: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SpinEditLines1: TSpinEdit;
    SpinEditLines2: TSpinEdit;
    SpinEditLines3: TSpinEdit;
    SpinEditLines4: TSpinEdit;
    SpinEditLines5: TSpinEdit;
    SpinEditLines6: TSpinEdit;
    SpinEditLines7: TSpinEdit;
    SpinEditLines8: TSpinEdit;
    SpinEditInterval1: TSpinEdit;
    SpinEditInterval2: TSpinEdit;
    SpinEditInterval3: TSpinEdit;
    SpinEditInterval4: TSpinEdit;
    SpinEditInterval5: TSpinEdit;
    SpinEditInterval6: TSpinEdit;
    SpinEditInterval7: TSpinEdit;
    SpinEditInterval8: TSpinEdit;
    Label9: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

implementation

{$R *.dfm}

uses
  Main;

procedure TAutoScrollSettingForm.FormCreate(Sender: TObject);
begin
  SpinEditLines1.Value := Config.oprAutoScrollLines[1];
  SpinEditLines2.Value := Config.oprAutoScrollLines[2];
  SpinEditLines3.Value := Config.oprAutoScrollLines[3];
  SpinEditLines4.Value := Config.oprAutoScrollLines[4];
  SpinEditLines5.Value := Config.oprAutoScrollLines[5];
  SpinEditLines6.Value := Config.oprAutoScrollLines[6];
  SpinEditLines7.Value := Config.oprAutoScrollLines[7];
  SpinEditLines8.Value := Config.oprAutoScrollLines[8];

  SpinEditInterval1.Value := Config.oprAutoScrollInterval[1];
  SpinEditInterval2.Value := Config.oprAutoScrollInterval[2];
  SpinEditInterval3.Value := Config.oprAutoScrollInterval[3];
  SpinEditInterval4.Value := Config.oprAutoScrollInterval[4];
  SpinEditInterval5.Value := Config.oprAutoScrollInterval[5];
  SpinEditInterval6.Value := Config.oprAutoScrollInterval[6];
  SpinEditInterval7.Value := Config.oprAutoScrollInterval[7];
  SpinEditInterval8.Value := Config.oprAutoScrollInterval[8];
end;

procedure TAutoScrollSettingForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if modalResult = mrOK then
  begin
    Config.oprAutoScrollInterval[1] := SpinEditInterval1.Value;
    Config.oprAutoScrollInterval[2] := SpinEditInterval2.Value;
    Config.oprAutoScrollInterval[3] := SpinEditInterval3.Value;
    Config.oprAutoScrollInterval[4] := SpinEditInterval4.Value;
    Config.oprAutoScrollInterval[5] := SpinEditInterval5.Value;
    Config.oprAutoScrollInterval[6] := SpinEditInterval6.Value;
    Config.oprAutoScrollInterval[7] := SpinEditInterval7.Value;
    Config.oprAutoScrollInterval[8] := SpinEditInterval8.Value;

    Config.oprAutoScrollLines[1] := SpinEditLines1.Value;
    Config.oprAutoScrollLines[2] := SpinEditLines2.Value;
    Config.oprAutoScrollLines[3] := SpinEditLines3.Value;
    Config.oprAutoScrollLines[4] := SpinEditLines4.Value;
    Config.oprAutoScrollLines[5] := SpinEditLines5.Value;
    Config.oprAutoScrollLines[6] := SpinEditLines6.Value;
    Config.oprAutoScrollLines[7] := SpinEditLines7.Value;
    Config.oprAutoScrollLines[8] := SpinEditLines8.Value;

    Config.Modified := true;
  end;
end;

end.
