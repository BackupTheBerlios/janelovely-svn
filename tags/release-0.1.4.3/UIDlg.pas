unit UIDlg;
(* 検索とかのダイアログ *)
(* Copyright (c) 2001,2002 hetareprog@hotmail.com *)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  (*-------------------------------------------------------*)
  TInputDlg = class(TForm)
    Button: TButton;
    InputPanel: TPanel;
    Edit: TComboBoxEx;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  InputDlg: TInputDlg;

(*=======================================================*)
implementation
(*=======================================================*)

{$R *.dfm}

uses
  Main;

procedure TInputDlg.FormShow(Sender: TObject);
begin
  {beginner}
  //Top := MainWnd.Top;
  //Left := MainWnd.Left;
  {/beginner}
  if length(Edit.Text) > 256 then
     Edit.Text := Copy(Edit.Text, 1, 256);  Edit.SelectAll;
  Edit.SetFocus;
  //▼IME
  ImeMode := ImeMode;
  SetImeMode(Handle,userImeMode);
end;

procedure TInputDlg.EditKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
  #$1B: ModalResult := -1;
  #$0D:
    {beginner}
    if GetKeyState(VK_SHIFT) < 0 then
      ModalResult := -3
    else begin
      ModalResult := 3;
    end;
    {/beginner}
  end;
end;


procedure TInputDlg.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_ESCAPE: ModalResult := -1;
  VK_F3:
    begin
      if ssShift in Shift then
        ModalResult := -3
      else begin
        ModalResult := 3;
      end;
    end;
  end;
end;

procedure TInputDlg.FormCreate(Sender: TObject);
var
  font: TFont;
begin
  if Config.viewDefFontInfo.face <> '' then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewDefFontInfo);
    Self.Font.Assign(font);
    font.Free;
  end;
  {beginner}
  Top := MainWnd.Top;
  Left := MainWnd.Left;
  {/beginner}
end;

procedure TInputDlg.ButtonClick(Sender: TObject);
begin
  ModalResult := 3;
end;

procedure TInputDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //▼ダイアログを閉じる際にIME状態を保存
  SaveImeMode(handle);
end;

end.
