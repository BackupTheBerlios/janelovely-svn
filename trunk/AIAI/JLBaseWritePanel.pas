unit JLBaseWritePanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, ComCtrls, StdCtrls,
  Graphics, Buttons, HogeTextView, UViewItem, JLXPComCtrls, JLXPButtons;

const
  TABSHEET_WRITE      = 0;
  TABSHEET_PREVIEW    = 1;
  TABSHEET_SETTINGTXT = 2;
  TABSHEET_RESULT     = 3;

type
  // リサイズ可能なListBox
  TRSListBox = class(TListBox)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;


  TJLBaseWritePanel = class(TCustomPanel)
  private
    KeyCtrl: Boolean;
    procedure CreateMainPageControl;
    procedure CreateBottomPanel;
    procedure CreateStatusBar;
    procedure SageCheckBoxClick(Sender: TObject);
    procedure WriteButtonClick(Sender: TObject);
    procedure ToolButtonClick(Sender: TObject);
    procedure NameMailComboBoxSelect(Sender: TObject);
    procedure WStatusBarDrawPanel(StatusBar: TStatusBar;
                Panel: TStatusPanel; const Rect: TRect);
    procedure MemoChange(Sender: TObject);
    procedure NameComboBoxChange(Sender: TObject);
    procedure MailComboboxChange(Sender: TObject);
    procedure MemoExit(Sender: TObject);
    procedure MemoEnter(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemoKeyPress(Sender: TObject; var Key: Char);
    procedure writeActShowAAListExecute(Sender: TObject);
    procedure AAListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AAListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AAListExit(Sender: TObject);
  protected
    MainPageControl: TPageControl;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    BottomPanel: TPanel;
    WriteButton: TButton;
    AAList: TRSListBox;
    ToolBar: TJLXPToolBar;
    ToolButton: array[0..7] of TToolButton;
    Memo: TMemo;
    NameComboBox: TComboBoxEx;
    MailComboBox: TComboBoxEx;
    SageCheckBox: TCheckBox;
    PreView: THogeTextView;
    PreViewItem: TFlexViewItem;
    Result: TMemo;
    SettingTxt: TMemo;
    WStatusBar: TJLXPStatusBar;
    PanelColor: array[0..2] of TColor;  //パネルの数だけ確保
    AAComboDropDown: Boolean;
    procedure CreatePreView; virtual;
    procedure Post; virtual;
    procedure PasteAA; virtual;
    procedure ToolButtonHandle(Sender: TToolButton; tag: integer); virtual;
    procedure SetUp(AParent: TWinControl); virtual;
    procedure ChangeStatusBar; virtual;
    procedure ChangeMainPageControlActiveTab(newTab: integer); virtual;
    procedure ChangeNameComboBoxColor; virtual;
    procedure ChangeMailComboBoxColor; virtual;
    procedure ChangeMemoIme; virtual;
    procedure SaveMemoIme; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

//{$DEFINE WRITEPANEL_FLOAT}


 { TRSListBox }
procedure TRSListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_THICKFRAME;
end;


 { TJLBaseWritePanel }

constructor TJLBaseWritePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

destructor TJLBaseWritePanel.Destroy;
begin
  PreViewItem.Free;

  inherited;
end;

procedure TJLBaseWritePanel.SetUp(AParent: TWinControl);
begin
  Parent := AParent;
  BevelOuter := bvNone;
  Ctl3D := True;
  ControlStyle := ControlStyle - [csSetCaption];

  CreateMainPageControl;
  CreateStatusBar;
  CreateBottomPanel;

  AAList := TRSListBox.Create(Self);
  With AAList do begin
    Parent := Self;
    Hide;
    Align := alCustom;
    Constraints.MinWidth := 50;
    Constraints.MinHeight := 50;
    OnMouseUp := AAListMouseUp;
    OnExit := AAListExit;
    OnKeyDown := AAListKeyDown;
  end;
end;



(* ページコントロールを作る *)
procedure TJLBaseWritePanel.CreateMainPageControl;
var
  TabSheet: TTabSheet;

  function CreateTabSheet: TTabSheet;
  begin
    Result := TTabSheet.Create(Self);
    With Result do
    begin
      TabVisible := False;
      PageControl := MainPageControl;
    end;
  end;

  (* 編集用タブシート *)
  procedure CreateMemoTabSheet;
  var
    NameMailPanel: TPanel;
  begin
    TabSheet := CreateTabSheet;
    NameMailPanel := TPanel.Create(Self);
    With NameMailPanel do
    begin
      Parent := TabSheet;
      Align := alTop;
      BevelOuter := bvNone;
      Height := 22;
    end;

    NameComboBox := TComboBoxEx.Create(Self);

    With TLabel.Create(Self) do
    begin
      Parent := NameMailPanel;
      Align := alLeft;
      Alignment := taCenter;
      Anchors := [akTop, akLeft];
      AutoSize := False;
      Caption := '&Name:';
      FocusControl := NameComboBox;
      Hint := '名前';
      LayOut := tlCenter;
      Left := 0;
      Width := 40;
    end;

    With NameComboBox do
    begin
      Parent := NameMailPanel;
      Align := alClient;
      TabOrder := 0;
      Hint := '名前';
      OnChange := NameComboBoxChange;
      OnSelect := NameMailComboBoxSelect;
    end;

    MailComboBox := TComboBoxEx.Create(Self);

    With TLabel.Create(Self) do
    begin
      Parent := NameMailPanel;
      Align := alRight;
      Alignment := taCenter;
      AutoSize := False;
      Caption := '&Mail:';
      FocusControl := MailComboBox;
      Hint := 'メール';
      LayOut := tlCenter;
      Width := 40;
    end;

    With MailComboBox do
    begin
      Parent := NameMailPanel;
      Align := alRight;
      Hint := 'メール';
      Width := 70;
      TabOrder := 1;
      OnChange := MailComboboxChange;
      OnSelect := NameMailComboBoxSelect;
    end;

    SageCheckBox := TCheckBox.Create(Self);
    With SageCheckBox do
    begin
      Parent := NameMailPanel;
      Align := alRight;
      Alignment := taLeftJustify;
      Caption := ' &sage';
      Left := NameMailPanel.ClientWidth - 60;
      TabOrder := 2;
      Width := 45;
      OnClick := SageCheckBoxClick;
    end;

    With TPanel.Create(Self) do
    begin
      Parent := NameMailPanel;
      Align := alRight;
      BevelOuter := bvNone;
      Width := 10;
    end;

    Memo := TMemo.Create(Self);
    With Memo do
    begin
      Parent := TabSheet;
      Align := alClient;
      ScrollBars := ssBoth;
      OnChange := MemoChange;
      OnEnter := MemoEnter;
      OnExit := MemoExit;
      OnKeyDown := MemoKeyDown;
      OnKeyPress := MemoKeyPress;
    end;
  end;

  (* プレビュー用タブシート *)
  procedure CreatePreViewTabSheet;
  begin
    TabSheet := CreateTabSheet;
    PreView := THogeTextView.Create(Self);
    With PreView do
    begin
      Parent := TabSheet;
      Align := alClient;
      LeftMargin := 8;
      TopMargin := 4;
      RightMargin := 8;
      ExternalLeading := 1;
    end;
    PreViewItem := TFlexViewItem.Create;
    PreViewItem.browser := PreView;
    PreViewItem.RootControl := MainPageControl;
  end;

  (* SETTING.TXT表示用タブシート *)
  procedure CreateSettingTxtTabSheet;
  begin
    TabSheet := CreateTabSheet;
    SettingTxt := TMemo.Create(Self);
    With SettingTxt do
    begin
      Parent := TabSheet;
      Align := alClient;
      ReadOnly := True;
      ScrollBars := ssBoth;
    end;
  end;

  (* 書込み結果表示用タブシート *)
  procedure CreateResultTabSheet;
  begin
    TabSheet := CreateTabSheet;
    With TLabel.Create(Self) do
    begin
      Parent := TabSheet;
      Caption := '書込み結果表示用タブシート'
    end;
    Result := TMemo.Create(Self);
    With Result do
    begin
      Parent := TabSheet;
      Align := alClient;
      ReadOnly := True;
      ScrollBars := ssVertical;
    end;
  end;

begin
  MainPageControl := TPageControl.Create(Self);
  With MainPageControl do
  begin
    Parent := Self;
    align := alClient;
  end;

  CreateMemoTabSheet;
  CreatePreViewTabSheet;
  CreateSettingTxtTabSheet;
  CreateResultTabSheet;

  MainPageControl.ActivePageIndex := 0;
end;

(* ステータスバーを作る *)
procedure TJLBaseWritePanel.CreateStatusBar;
begin
  WStatusBar := TJLXPStatusBar.Create(Self);
  With WStatusBar do
  begin
    Parent := Self;
    Align := alBottom;
    OnDrawPanel := WStatusBarDrawPanel;
  end;
  With TStatusPanel.Create(WStatusBar.Panels) do
  begin
    Width := 110;
    Style := psOwnerDraw;
  end;
  With TStatusPanel.Create(WStatusBar.Panels) do
  begin
    Width := 110;
    Style := psOwnerDraw;
  end;
  With TStatusPanel.Create(WStatusBar.Panels) do
  begin
    Width := 50;
    Style := psText;
  end;
end;

(* ツールパネルを作る *)
procedure TJLBaseWritePanel.CreateBottomPanel;
var
  index: integer;
begin
  BottomPanel := TPanel.Create(Self);
  With BottomPanel do
  begin
    Parent := Self;
    Align := alBottom;
    Height := 24;
    BevelOuter := bvNone;
  end;

  With TJLXPSpeedButton.Create(Self) do
  begin
    Parent := BottomPanel;
    Align := alLeft;
    Alignment := taCenter;
    AutoSize := False;
    Caption := 'AA';
    OnClick := writeActShowAAListExecute;
    Width := 30;
  end;

  ToolBar := TJLXPToolBar.Create(Self);
  With ToolBar do
  begin
    Parent := BottomPanel;
    Align := alClient;
    EdgeBorders := [];
    Flat := True;
    Wrapable := False;
  end;

  for index := 7 downto 0 do
  begin
    ToolButton[index] := TToolButton.Create(Self);
    ToolButton[index].Parent := ToolBar;
    ToolButton[index].ImageIndex := index;
    ToolButton[index].tag := index;
    ToolButton[index].OnClick := ToolButtonClick;
  end;
  ToolButton[0].Hint := 'メモ欄の内容をファイルに保存';
  ToolButton[1].Hint := 'ファイルの内容をメモ欄に読込む';
  ToolButton[2].Hint := 'メモ欄の内容を消去';
  ToolButton[3].Hint := 'コテハン記憶';
  ToolButton[4].Hint := '末尾整形';
  ToolButton[5].Hint := 'WriteWait有効';
  ToolButton[6].Hint := 'コテハン警告';
  ToolButton[7].Hint := 'BeLogin';

  WriteButton := TButton.Create(Self);
  With WriteButton do
  begin
    Parent := BottomPanel;
    Align := alRight;
    Caption := '書込(Shift+Enter)';
    Enabled := False;
    Font.Name := 'ＭＳ Ｐゴシック';
    Width := 100;
    OnClick := WriteButtonClick;
  end;
end;


//------------------- Event Handler -----------------------------------------//

procedure TJLBaseWritePanel.ToolButtonClick(Sender: TObject);
begin
  ToolButtonHandle(TToolButton(Sender) , TComponent(Sender).Tag);
end;

(* AA入力支援 *)
procedure TJLBaseWritePanel.AAListMouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if  (AAList.ItemIndex > -1) then
    begin
      PasteAA;
    end;
    AAList.Hide;
    Memo.SetFocus;
  end;
end;

procedure TJLBaseWritePanel.writeActShowAAListExecute(Sender: TObject);
var
  point: TPoint;
begin
  try Memo.SetFocus; except end;
  if 0 < AAList.Count then
  begin
    GetCaretPos(point);
    AAList.Top  :=  MainPageControl.Pages[0].Top + Memo.Top + point.Y - Memo.Font.Height;
    if (self.Height < AAList.Top + AAList.Height + 30) and
       (AAlist.Height < AAList.Top) then
      AAList.Top  := Self.Top + Memo.Top + point.Y - AAList.Height;
    AAList.Left := MainPageControl.Pages[0].Left + point.X;
    //if Memo.Width < point.X + AAList.Width + 30 then
    //  AAList.Left := AAlist.Left - point.X + Memo.Width - AAList.Width - 30;
    AAList.ItemIndex := 0;
    AAList.Show;
    AAList.SetFocus;
  end;
end;

procedure TJLBaseWritePanel.AAListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
  begin
    AAList.Hide;
    Memo.SetFocus;
  end else
  if (Key = VK_RETURN) then
  begin
    if (AAList.ItemIndex > -2) then
    begin
      PasteAA;
    end;
    AAList.Hide;
    Memo.SetFocus;
  end;
end;

procedure TJLBaseWritePanel.AAListExit(Sender: TObject);
begin
  AAList.Hide;
end;


procedure TJLBaseWritePanel.SageCheckBoxClick(Sender: TObject);
begin
  MailComboBox.Enabled := not SageCheckBox.Checked;
  if MailComboBox.Enabled then
    MailComboBox.Text := ''
  else
    MailComboBox.Text := 'sage';
  try Memo.SetFocus; except end;
end;

procedure TJLBaseWritePanel.WriteButtonClick(Sender: TObject);
begin
  Post;
end;

procedure TJLBaseWritePanel.NameMailComboBoxSelect(Sender: TObject);
begin
  try Memo.SetFocus; except end;
end;

procedure TJLBaseWritePanel.WStatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
  function RealHeight(Font: TFont): Integer;
  var
    tm: TEXTMETRIC;
  begin
    if Font.Height >= 0 then
      result := Abs(Font.Height)
    else
    begin
      GetTextMetrics(StatusBar.Canvas.Handle, tm);
      result := Abs(Font.Height) + tm.tmInternalLeading;
    end;
  end;
var
  i: Integer;
  X, Y: Integer;
begin
  StatusBar.Canvas.Brush.Color := WStatusBar.Color;
  for i := Low(PanelColor) to High(PanelColor) do
  begin
    if Panel = StatusBar.Panels[i] then
    begin
      StatusBar.Canvas.Brush.Color := PanelColor[i];
      Break;
    end;
  end;
  X := Rect.Left + 4;
  Y := (Rect.Top + Rect.Bottom - RealHeight(StatusBar.Canvas.Font)) div 2 + 1;
  StatusBar.Canvas.TextRect(Rect, X, Y, Panel.Text);
end;

procedure TJLBaseWritePanel.MemoChange(Sender: TObject);
begin
  ChangeStatusBar;
end;

procedure TJLBaseWritePanel.NameComboBoxChange(Sender: TObject);
begin
  ChangeNameComboBoxColor;
end;

procedure TJLBaseWritePanel.MailComboboxChange(Sender: TObject);
begin
  ChangeMailComboBoxColor;
end;

procedure TJLBaseWritePanel.MemoExit(Sender: TObject);
begin
  SaveMemoIme;
end;

procedure TJLBaseWritePanel.MemoEnter(Sender: TObject);
begin
  ChangeMemoIme;
end;

procedure TJLBaseWritePanel.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (Key = VK_RETURN) then
  begin
    Memo.WantReturns := false;
    if WriteButton.Enabled then
      WriteButtonClick(nil)
    else
      MessageBeep($FFFFFFFF);
  end else
  begin
    Memo.WantReturns := true;
    if (ssCtrl in Shift) then begin
      if (Key = Ord('A')) then
        Memo.SelectAll;
        KeyCtrl := True;
        exit;
      end;
  end;
  KeyCtrl := False;
end;

procedure TJLBaseWritePanel.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = ' ') and KeyCtrl then begin
    Key := #0;
    writeActShowAAListExecute(Self);
  end;
end;

//------------------- Helper Procedure --------------------------------------//

procedure TJLBaseWritePanel.ChangeMainPageControlActiveTab(newTab: integer);
//var
//  i: integer;
begin
  MainPageControl.ActivePageIndex := newTab;

  if newTab = TABSHEET_WRITE then
    try Memo.SetFocus; except end
  else begin
    if newTab = TABSHEET_PREVIEW then
      CreatePreView;
    try Self.SetFocus; except end;
  end;
end;

procedure TJLBaseWritePanel.CreatePreView;
begin
end;

procedure TJLBaseWritePanel.Post;
begin
end;

procedure TJLBaseWritePanel.PasteAA;
begin
end;

procedure TJLBaseWritePanel.ToolButtonHandle(Sender: TToolButton; tag: integer);
begin
end;

procedure TJLBaseWritePanel.ChangeStatusBar;
begin
end;

procedure TJLBaseWritePanel.ChangeNameComboBoxColor;
begin
end;

procedure TJLBaseWritePanel.ChangeMailComboBoxColor;
begin
end;

procedure TJLBaseWritePanel.ChangeMemoIme;
begin
end;

procedure TJLBaseWritePanel.SaveMemoIme;
begin
end;

end.
