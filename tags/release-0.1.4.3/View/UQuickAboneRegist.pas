unit UQuickAboneRegist;

interface

uses
  Windows, Messages, Classes, Controls, Forms, StdCtrls, ExtCtrls, JLXPSpin,
  HogeTextView, Menus;

type
  TQuickAboneRegist = class(TForm)
    Panel1: TPanel;
    btnRegister: TButton;
    btnCancel: TButton;
    btnSelectAll: TButton;
    cmbAboneType: TComboBox;
    seLifeSpan: TJLXPSpinEdit;
    Label1: TLabel;
    btnQuickAbone: TButton;
    PopupMenu: TPopupMenu;
    PopupCopy: TMenuItem;
    PopupSelectAll: TMenuItem;
    N1: TMenuItem;
    procedure btnSelectAllClick(Sender: TObject);
    procedure ItemViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ItemViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PopupCopyClick(Sender: TObject);
    procedure PopupSelectAllClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
  private
    { Private êÈåæ }
    procedure CheckItemView;
  public
    { Public êÈåæ }
    ItemView: THogeTextView;
  end;

implementation

{$R *.dfm}

procedure TQuickAboneRegist.FormCreate(Sender: TObject);
begin
  ItemView := THogeTextView.Create(Self);
  ItemView.Parent := Self;
  ItemView.OnKeyDown := ItemViewKeyDown;
  ItemView.OnMouseUp := ItemViewMouseUp;
  ItemView.PopupMenu := PopupMenu;
  ItemView.ConfCaretVisible := True;
  ItemView.Align := alClient;
end;

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
  if ItemView.GetSelection <> '' then begin
    btnQuickAbone.Enabled := True;
    btnRegister.Enabled := True;
  end else begin
    btnQuickAbone.Enabled := True;
    btnRegister.Enabled := False;
  end;
end;

procedure TQuickAboneRegist.PopupCopyClick(Sender: TObject);
begin
  ItemView.CopySelection;
end;

procedure TQuickAboneRegist.PopupSelectAllClick(Sender: TObject);
begin
  ItemView.SelectAll;
end;

procedure TQuickAboneRegist.PopupMenuPopup(Sender: TObject);
begin
  PopupCopy.Enabled := ItemView.GetSelection <> '';
end;

end.
