unit UAdvAboneRegist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls,
  UNGWordsAssistant;

type

  TChangeNameQueryEvent =
    procedure(Sender: TObject; OldName, NewName: String; CanChange: Boolean) of object;

  TAdvAboneRegist = class(TForm)
    EditNGName: TEdit;
    ComboBoxNGNameType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditNGMail: TEdit;
    ComboBoxNGMailType: TComboBox;
    Label4: TLabel;
    EditNGId: TEdit;
    ComboBoxNGIdType: TComboBox;
    Label5: TLabel;
    ComboBoxNGWordType: TComboBox;
    Label6: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ComboBoxAboneType: TComboBox;
    SpinEditLifeSpan: TSpinEdit;
    Label7: TLabel;
    EditName: TEdit;
    EditNGWord: TEdit;
    ButtonRename: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxNGChange(Sender: TObject);
    procedure EditNGChange(Sender: TObject);
    procedure MiscOnChange(Sender: TObject);
    procedure ButtonRenameClick(Sender: TObject);
    procedure EditNameExit(Sender: TObject);
  protected
    ComboBoxNGItems: array[TNGItemIdent] of TComboBox;
    EditNGItems    : array[TNGItemIdent] of TEdit;
    FItemName: String;
    FOnChangeNameQuery: TChangeNameQueryEvent;
    function Validate: Boolean;
    function ChangeNameQuery(OldName, NewName: String): Boolean;
  public
    function ShowModal(var ItemName: string; Item: TExNgItem): Integer; reintroduce;
  published
    property OnChangeNameQuery: TChangeNameQueryEvent read FOnChangeNameQuery write FOnChangeNameQuery;
  end;

var
  AdvAboneRegist: TAdvAboneRegist;

implementation

{$R *.dfm}


//Create���ɃR���|�[�l���g�z���ݒ�
procedure TAdvAboneRegist.FormCreate(Sender: TObject);
begin
  ComboBoxNGItems[NG_ITEM_NAME] := ComboBoxNGNameType;
  ComboBoxNGItems[NG_ITEM_MAIL] := ComboBoxNGMailType;
  ComboBoxNGItems[NG_ITEM_MSG]  := ComboBoxNGWordType;
  ComboBoxNGItems[NG_ITEM_ID]   := ComboBoxNGIdType;

  EditNGItems[NG_ITEM_NAME] := EditNGName;
  EditNGItems[NG_ITEM_MAIL] := EditNGMail;
  EditNGItems[NG_ITEM_MSG]  := EditNGWord;
  EditNGItems[NG_ITEM_ID]   := EditNGId;
end;


//�{�̕����@(Item�̓��e��\���A�ύX)
function TAdvAboneRegist.ShowModal(var ItemName: string; Item: TExNgItem): Integer;
var
  i: TNGItemIdent;
begin

  FItemName := ItemName;
  EditName.Text := FItemName;

  for i := Low(i) to High(i) do begin
    ComboBoxNGItems[i].ItemIndex := Item.SearchOpt[i] + 1;
    EditNGItems[i].Text := Item.SearchStr[i];
  end;

  case Item.AboneType of
    2: ComboBoxAboneType.ItemIndex := 1;
    4: ComboBoxAboneType.ItemIndex := 2;
    else
      ComboBoxAboneType.ItemIndex := -1;
  end;

  SpinEditLifeSpan.Value := Item.LifeSpan;

  ButtonOK.Enabled := False;

  Result := inherited ShowModal;

  ItemName := FItemName;

  if Result = mrOK then begin
    for i := Low(i) to High(i) do begin
      Item.SearchOpt[i] := ComboBoxNGItems[i].ItemIndex - 1;
      Item.SearchStr[i] := EditNGItems[i].Text;
    end;

    case ComboBoxAboneType.ItemIndex of
      1: Item.AboneType := 2;
      2: Item.AboneType := 4;
      else
        Item.AboneType := 0;
    end;
    Item.LifeSpan := SpinEditLifeSpan.Value;
  end;
end;


//��낵�{�^����Enable�ɂ��Ă�����������
function TAdvAboneRegist.Validate;
var
  i: TNGItemIdent;
  NotNop: Boolean;
begin
  Result := True;
  NotNop := False;
  for i := Low(i) to High(i) do
    case ComboBoxNGItems[i].ItemIndex of
      0:;
      3, 4: NotNop := True;
      else begin
        NotNop := True;
        Result := Result and (EditNGItems[i].Text <> ''); //�O�̂���(�v��Ȃ��͂�)
      end;
    end;
  Result := Result and NotNop;
end;


//�u�����v�ɂ�����L�[���[�h���k����
procedure TAdvAboneRegist.ComboBoxNGChange(Sender: TObject);
var
  i: TNGItemIdent;
begin
  if (Sender as TComboBox).ItemIndex = 0 then
    for i := Low(i) to High(i) do
      if (Sender = ComboBoxNGItems[i]) then
        EditNGItems[i].Text := '';
  ButtonOK.Enabled := Validate;
end;


//�L�[���[�h���k���łȂ��Ȃ�����u�����v����u�܂ށv��
procedure TAdvAboneRegist.EditNGChange(Sender: TObject);
var
  i: TNGItemIdent;
begin
  if (Sender as TEdit).Text <> '' then
    for i := Low(i) to High(i) do
      if (Sender = EditNGItems[i]) and (ComboBoxNGItems[i].ItemIndex = 0) then
        ComboBoxNGItems[i].ItemIndex := 1;

  ButtonOK.Enabled := Validate;
end;


//�����A���ځ[��^�C�v�̕ύX�ł���낵�{�^����Enable��
procedure TAdvAboneRegist.MiscOnChange(Sender: TObject);
begin
  ButtonOK.Enabled := Validate;
end;


//���O�̕ύX�J�n
procedure TAdvAboneRegist.ButtonRenameClick(Sender: TObject);
begin
  EditName.ReadOnly := False;
  EditName.Color := clWindow;
  EditName.SetFocus;
end;


//���O�̕ύX��̃`�F�b�N
procedure TAdvAboneRegist.EditNameExit(Sender: TObject);
begin
  if EditName.Text = '' then
    EditName.Text := FItemName
  else if EditName.Text <> FItemName then begin
    if ChangeNameQuery(FItemName, EditName.Text) then
      FItemName := EditName.Text
    else
      EditName.Text := FItemName;
  end;
  EditName.ReadOnly := True;
  EditName.Color := clBtnFace;
end;


//���O�ύX�C�x���g�̐���
function TAdvAboneRegist.ChangeNameQuery(OldName, NewName: String): Boolean;
begin
  Result := True;
  if Assigned(FOnChangeNameQuery) then
    FOnChangeNameQuery(Self, OldName, NewName, Result);
end;

end.
