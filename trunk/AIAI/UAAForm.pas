unit UAAForm;

(* AA�G�f�B�^ *)
interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  JConfig, StdCtrls, ExtCtrls, Menus, JLWritePanel;

type
  TAAForm = class(TForm)
    Panel: TPanel;
    Edit: TMemo;
    ComboBox: TComboBox;
    PopupMenu: TPopupMenu;
    MenuSave: TMenuItem;
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxSelect(Sender: TObject);
    procedure MenuSaveClick(Sender: TObject);
  private
    { Private �錾 }
    savedTop: Integer;
    savedLeft: Integer;
    savedHeight: Integer;
    savedWidth: Integer;
    windowactive: Boolean;
    startline: Integer;
    endline: Integer;
    HideOnApplicationMinimize: Boolean;
  public
    { Public �錾 }
    function SavedBoundsRect:TRect;
    procedure MainWndOnShow;
    procedure MainWndOnHide;
  end;

var
  AAForm: TAAForm;

implementation

uses
  Main;

{$R *.dfm}

(* ������ *)
procedure TAAForm.FormCreate(Sender: TObject);
begin
  savedTop := 0;
  savedLeft := 0;
  savedHeight := 0;
  savedWidth := 0;
  HideOnApplicationMinimize := false;
end;

procedure TAAForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  Top := Config.aaFormTop;
  Left := Config.aaFormLeft;
  Height := Config.aaFormHeight;
  Width := Config.aaFormWidth;

  if -1 < AnsiPos('[aalist]', Config.aaAAList.Strings[0]) then
  begin
    for i := 1 to Config.aaAAList.Count - 1 do
    begin
      if 0 < AnsiPos('[', Config.aaAAList.Strings[i]) then
        break;
      ComboBox.Items.Add(Config.aaAAList.Strings[i]);
    end;
  end;

  windowactive := true;
end;

procedure TAAForm.FormDeactivate(Sender: TObject);
begin
  if (WindowState <> wsMinimized) then begin
    savedLeft := Left;
    savedTop  := Top;
    savedWidth:= Width;
    savedHeight:= Height;
    Height := 10;
  end;

  SaveImeMode(Handle);
end;

procedure TAAForm.FormActivate(Sender: TObject);
begin
  (* ���������ɖ߂� *)
  if (WindowState <> wsMaximized) then begin
    if 0 < savedWidth then
      Width := savedWidth;
    if 0 < savedHeight then
      Height := savedHeight;
  end;
  SetImeMode(Handle, userImeMode);
end;

procedure TAAForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Config.SaveAAFormPos(savedBoundsRect);
  Action := caFree;
  AAForm := nil;
end;

//�ۑ��p�̈ʒu��Ԃ�(�k��ł���Ƃ��͌��̃T�C�Y��Ԃ�)
function TAAForm.SavedBoundsRect:TRect;
begin
  Result := BoundsRect;
  if WindowState <> wsMaximized then
  begin
    if 0 < savedHeight then
      Result.Bottom := Result.Top + savedHeight;
  end;
  Config.aaFormTop := Result.Top;
  Config.aaFormLeft := Result.Left;
  Config.aaFormHeight := Result.Bottom - Result.Top;
  Config.aaFormWidth := Result.Right - Result.Left;
end;

procedure TAAForm.ComboBoxSelect(Sender: TObject);
var
  i: Integer;
  j: Integer;
  k: Integer;
begin
  if ComboBox.Text <> '' then
  begin
    k := AnsiPos('*', ComboBox.Text);
    if k = 1 then
    begin
      startline := -1;
      endline := -1;
      Edit.Clear;
      for i := 0 to Config.aaAAList.Count - 1 do
        if 1 = AnsiPos('[' + Copy(ComboBox.Text, 2, Length(ComboBox.Text)) + ']', Config.aaAAList.Strings[i]) then
          for j := i + 1 to Config.aaAAList.Count - 1 do
            if 1 = AnsiPos('[', Config.aaAAList.Strings[j]) then
            begin
              if endline = -1 then
                endline := j - 1;
              break;
            end else
            begin
              if startline = -1 then
                startline := j;
              Edit.Lines.Add(Config.aaAAList.Strings[j]);
            end;
    end else
    begin
      Edit.Clear;
      Edit.SelText := ComboBox.Text;
    end;
    Edit.SetFocus;
  end;
end;

procedure TAAForm.MenuSaveClick(Sender: TObject);
var
  i: Integer;
  j: Integer;
  k: Integer;
  index: Integer;
begin
  if ComboBox.Text = '' then   // AA���I������Ă��Ȃ��ꍇ
    exit;

  k := AnsiPos('*', ComboBox.Text);
  if k = 1 then   // 2�s�ȏ��AA�̏ꍇ
  begin
    for i := startline to endline do
      Config.aaAAList.Delete(startline);
    for j := 0 to Edit.Lines.Count - 1 do
      Config.aaAAList.Insert(startline + j, Edit.Lines.Strings[j]);
    Config.aaAAList.SaveToFile(Config.BasePath + 'AAlist.txt');
    ComboBoxSelect(nil);     //startline��endline������������
  end else       // 1�s��AA�̏ꍇ
  begin
    index := Config.aaAAList.IndexOf(ComboBox.Text);
    Config.aaAAList.Delete(index);
    Config.aaAAList.Insert(index, Edit.Lines.Strings[0]);
    Config.aaAAList.SaveToFile(Config.BasePath + 'AAlist.txt');

    ComboBox.Items.Delete(index - 1);
    ComboBox.Items.Insert(index - 1, Edit.Lines.Strings[0]);
    ComboBox.Text := Edit.Lines.Strings[0];

    JLWritePanel.UpdateAAComboBox;
  end;
end;

procedure TAAForm.MainWndOnShow;
begin
  if HideOnApplicationMinimize then begin
    HideOnApplicationMinimize := false;
    Show;
  end;
end;

procedure TAAForm.MainWndOnHide;
begin
  if Visible then begin
    HideOnApplicationMinimize := true;
    Hide;
  end;
end;

end.
