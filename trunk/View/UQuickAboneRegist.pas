unit UQuickAboneRegist;

interface

uses
  Windows, Messages, Classes, Controls, Forms, StdCtrls, ExtCtrls, JLXPSpin;

type
  TQuickAboneRegist = class(TForm)
    Panel1: TPanel;
    ItemView: TMemo;
    btnRegister: TButton;
    btnCancel: TButton;
    btnSelectAll: TButton;
    cmbAboneType: TComboBox;
    seLifeSpan: TJLXPSpinEdit;
    Label1: TLabel;
    btnQuickAbone: TButton;
    procedure btnSelectAllClick(Sender: TObject);
    procedure ItemViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ItemViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private éŒ¾ }
    procedure CheckItemView;
  public
    { Public éŒ¾ }
  end;

implementation

{$R *.dfm}

procedure TQuickAboneRegist.btnSelectAllClick(Sender: TObject);
begin
  ItemView.SelectAll;
  CheckItemView;
end;

procedure TQuickAboneRegist.ItemViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckItemView;
end;

procedure TQuickAboneRegist.ItemViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  CheckItemView;
end;

procedure TQuickAboneRegist.CheckItemView;
begin
  if ItemView.SelLength>0 then begin
    btnQuickAbone.Enabled := True;
    btnRegister.Enabled := True;
  end else begin
    btnQuickAbone.Enabled := True;
    btnRegister.Enabled := False;
  end;
end;


end.
