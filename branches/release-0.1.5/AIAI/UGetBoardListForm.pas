unit UGetBoardListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TGetBoardListForm = class(TForm)
    MessageLabel1: TLabel;
    ComboBoxURL: TComboBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

implementation

{$R *.dfm}

uses
  Main;

procedure TGetBoardListForm.FormCreate(Sender: TObject);
begin
  ComboBoxURL.Items.Add('http://www.ff.iij4u.or.jp/~ch2/bbsmenu.html');
  ComboBoxURL.Items.Add('http://azlucky.s25.xrea.com/2chboard/bbsmenu.html');

  ComboBoxURL.ItemIndex := 0;

  Beep;
end;

procedure TGetBoardListForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if (modalResult = mrOK) and (ComboBoxURL.Text <> '') then begin
    Main.Config.bbsMenuURL := ComboBoxURL.Text;
    Main.Config.Modified := true;
  end;
end;

end.
