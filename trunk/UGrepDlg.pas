unit UGrepDlg;
(* Grep検索ダイアログ *)
(* ※[457] *)
interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, StdCtrls,
  UIDlg, U2chCatList, UFavorite, U2chBoard, U2chCat, JLXPExtCtrls;

type
  TGrepDlg = class(TInputDlg)
    GrepPanel: TPanel;
    SettingPanel: TPanel;
    CheckBoxPopup: TCheckBox;
    PopupDetailPanel: TPanel;
    PopupMaxSeqEdit: TEdit;
    PopupEachThreMaxEdit: TEdit;
    RadioGroupSearchRange: TJLXPRadioGroup;
    RadioGroupTarget: TJLXPRadioGroup;
    TargetPanel: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    TreeView: TTreeView;
    ListBox: TListBox;
    Label4: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    ButtonAdd: TButton;
    ButtonDelete: TButton;
    ListPopupMenu: TPopupMenu;
    ListPopupDelete: TMenuItem;
    TreePopupMenu: TPopupMenu;
    TreePopupAdd: TMenuItem;
    N1: TMenuItem;
    ListPopupClear: TMenuItem;
    N2: TMenuItem;
    TreePopupExpand: TMenuItem;
    TreePopupCollapse: TMenuItem;
    ExtractPanel: TPanel;
    CheckBoxIncludeRef: TCheckBox;
    CheckBoxShowDirect: TCheckBox;
    CheckBoxSaveHistroy: TCheckBox;
    ComboBoxOption: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NumOnlyKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBoxPopupClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RadioGroupTargetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreePopupAddClick(Sender: TObject);
    procedure TreePopupExpandClick(Sender: TObject);
    procedure TreePopupCollapseClick(Sender: TObject);
    procedure ListPopupDeleteClick(Sender: TObject);
    procedure ListPopupClearClick(Sender: TObject);
    procedure TreeViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBoxExit(Sender: TObject);
    procedure TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TreeViewDblClick(Sender: TObject);
  	procedure ListBoxDblClick(Sender: TObject);
    procedure CheckBoxShowDirectClick(Sender: TObject);
    procedure CheckBoxIncludeRefClick(Sender: TObject);
  public
    grepMode: boolean;
    extractMode: boolean;
    targetBoardList: TList;
  end;

var
  GrepDlg: TGrepDlg;

implementation

uses Main, JConfig;

{$R *.dfm}

procedure TGrepDlg.FormCreate(Sender: TObject);
begin
  inherited;
  targetBoardList := TList.Create;
  GrepPanel.Visible := false;
  CheckBoxPopup.Checked := Config.grepPopup;
  CheckBoxShowDirect.Checked := Config.grepShowDirect;  //beginner
  PopupMaxSeqEdit.Text := IntToStr(Config.grepPopMaxSeq);
  PopupEachThreMaxEdit.Text := IntToStr(Config.grepPopEachThreMax);

  Edit.Items := Config.grepSearchList;  //aiai
end;

procedure TGrepDlg.FormDestroy(Sender: TObject);
begin
  targetBoardList.Free;
  inherited;
end;

procedure TGrepDlg.FormShow(Sender: TObject);
  procedure AddNode(node: TTreeNode; favs: TFavoriteList);
  var
    i: integer;
  begin
    for i := 0 to favs.Count -1 do
    begin
      if favs.Items[i] is TFavoriteList then
      begin
        AddNode(TreeView.Items.AddChildObject(node, TFavoriteList(favs.items[i]).name, TFavoriteList(favs.items[i])), TFavoriteList(favs.items[i]));
      end;
    end;
  end;
var
  node: TTreeNode;

begin
  inherited;
  targetBoardList.Clear;
  TreeView.Items.Clear;

  AutoSize := false;
  if grepMode then
  begin
    GrepPanel.Visible := true;
    if ListBox.Count <= 0 then
      RadioGroupTargetClick(Sender);
    TreeView.Items.Assign(MainWnd.TreeView.Items);
    node := TreeView.Items[0];
    node.DeleteChildren;
    node.Assign(MainWnd.FavoriteView.Items[0]);
    AddNode(node, TFavoriteList(node.Data));
    node.Expanded := true;
    GrepPanel.AutoSize := False;
    GrepPanel.AutoSize := True;
    CheckBoxIncludeRef.Enabled := CheckBoxShowDirect.Checked; //beginner
  end else {beginner} begin
    CheckBoxIncludeRef.Enabled := True;
    {/beginner}
    GrepPanel.Visible := false;
  end;

  {beginner}
  //if extractMode then
  //  ExtractPanel.Visible := True
  //else
  //  ExtractPanel.Visible := False;
  {/beginner}

  {aiai}
  if extractMode then
  begin
  end else
  begin
    CheckBoxIncludeRef.Enabled := false;
  end;

  CheckBoxSaveHistroy.Checked := Config.grepSaveHistroy;
  {/aiai}

  AutoSize := true;
end;

procedure TGrepDlg.NumOnlyKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9'])) and (Key <> #8{BS}) then
		Key := #0;
end;

procedure TGrepDlg.CheckBoxPopupClick(Sender: TObject);
begin
  PopupDetailPanel.Visible := CheckBoxPopup.Checked;
  {beginner}
  if CheckBoxPopup.Checked then
    CheckBoxShowDirect.Checked := False;
  {/beginner}
end;

procedure TGrepDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//var
//  i: integer;
begin
  inherited;
  if (abs(ModalResult) <> 3) then
    exit;

  //文字入力チェック
  {if Edit.Text = '' then
  begin
    ShowMessage('検索文字を入力してください');
    CanClose := false;
    exit;
  end;}

  //検索対象チェック
  if grepMode and (ListBox.Count <= 0) and (Edit.Text <> '') then
  begin
    ShowMessage('検索対象を選択してください');
    CanClose := false;
    exit;
  end;

  CanClose := true;
end;

procedure TGrepDlg.RadioGroupTargetClick(Sender: TObject);
var
  i, j: integer;
  board: TBoard;

  procedure FindBoard(parent: TFavoriteList);
  var
    fav: TFavorite;
    i: integer;
  begin
    for i := 0 to parent.Count -1 do
    begin
      if parent.Items[i] is TFavoriteList then
        FindBoard(TFavoriteList(parent.items[i]))
      else if (parent.Items[i] is TFavorite) then
      begin
        fav := TFavorite(parent.Items[i]);
        if fav.datName <> '' then
          continue;
        board := i2ch.FindBoard(fav.host, fav.bbs);
        if board <> nil then
          ListBox.AddItem(board.name, board);
      end;
    end;
  end;

begin
  inherited;
  ListBox.Items.Clear;
  case RadioGroupTarget.ItemIndex of
  0: (* アクティブな板 *)
    begin
      if MainWnd.currentBoard <> nil then
        ListBox.AddItem(MainWnd.currentBoard.name, MainWnd.currentBoard);
    end;
  1: (* タブで開いている板 *)
    begin
      for i := 0 to boardList.Count -1 do
        ListBox.AddItem(boardList.Items[i].name, boardList.Items[i]);
    end;
  2: (* お気に入りの板 *)
    begin
      FindBoard(favorites);
    end;
  3: (* 全取得ログ *)
    begin
      for i := 1 to i2ch.Count -1 do
      begin
        if not DirectoryExists(i2ch.Items[i].GetLogDir) then
          continue;
        for j := 0 to i2ch.Items[i].Count -1 do
        begin
          board := i2ch.Items[i].Items[j];
          if not DirectoryExists(board.GetLogDir) then
            continue;
          if ListBox.Items.IndexOfObject(board) < 0 then
            ListBox.AddItem(board.name, board);
        end;
      end;
    end;
  end;
end;

procedure TGrepDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i, j: integer;
  board: TBoard;
  fav: TFavorite;
begin
  inherited;
  GrepPanel.Visible := false;
  if ModalResult = -1 then
    exit;

  //検索履歴追加
  {aiai}
  if (ModalResult = 3) and CheckBoxSaveHistroy.Checked and (Edit.Items.IndexOf(Edit.Text) < 0) and (Edit.Text <> '') then begin
    Edit.Items.Insert(0, Edit.Text);
    Config.grepSearchList.Insert(0, Edit.Text);
    Config.Modified := true;
  end;
  Config.grepSaveHistroy := CheckBoxSaveHistroy.Checked;
  Config.Modified := true;
  {/aiai}

  if not grepMode then
    exit;

  //Grep設定保存
  Config.grepPopup := CheckBoxPopup.Checked;
  config.grepShowDirect :=  CheckBoxShowDirect.Checked; //beginner
  Config.grepPopMaxSeq := StrToIntDef(PopupMaxSeqEdit.Text, Config.grepPopMaxSeq);
  Config.grepPopEachThreMax := StrToIntDef(PopupEachThreMaxEdit.Text, Config.grepPopEachThreMax);
  Config.Modified := true;

  //Grepターゲットの決定
  for i := 0 to ListBox.Count -1 do
  begin
    if ListBox.Items.Objects[i] is TFavoriteList then
    begin
      (* お気に入り板の追加 *)
      board := FavoriteListBoardAdmin.GetBoard(TFavoriteList(ListBox.Items.Objects[i]));
      if (board <> nil) and (targetBoardList.IndexOf(board) < 0) then
        targetBoardList.Add(board);
      (* お気に入りフォルダに入っている板の追加 *)
      for j := 0 to TFavoriteList(ListBox.Items.Objects[i]).Count -1 do
      begin
        if not (TFavoriteList(ListBox.Items.Objects[i]).Items[j] is TFavorite) then
          continue;
        fav := TFavorite(TFavoriteList(ListBox.Items.Objects[i]).Items[j]);
        if fav.datName = '' then
        begin
          board := i2ch.FindBoard(fav.host, fav.bbs);
          if (board <> nil) and (targetBoardList.IndexOf(board) < 0) then
            targetBoardList.Add(board);
        end;
      end;
    end
    else if ListBox.Items.Objects[i] is TCategory then
    begin
      for j := 0 to TCategory(ListBox.Items.Objects[i]).Count -1 do
      begin
        board := TCategory(ListBox.Items.Objects[i]).Items[j];
        if targetBoardList.IndexOf(board) < 0 then
          targetBoardList.Add(board);
      end;
    end
    else if ListBox.Items.Objects[i] is TBoard then
    begin
      board := TBoard(ListBox.Items.Objects[i]);
      if targetBoardList.IndexOf(board) < 0 then
        targetBoardList.Add(board);
    end;
  end;
end;

procedure TGrepDlg.TreePopupAddClick(Sender: TObject);
var
  i, count: integer;
begin
  inherited;
  count := ListBox.Count;
  for i := 0 to TreeView.SelectionCount -1 do
  begin
    with TreeView.Selections[i] do
    begin
      if (Data <> nil) and (ListBox.Items.IndexOfObject(Data) < 0) then
      begin
        if (TObject(Data) is TFavoriteList) then
          ListBox.AddItem('[お気に入り] ' + Text, TObject(Data))
        else if (TObject(Data) is TCategory) then
          ListBox.AddItem('[カテゴリ] ' + Text, TObject(Data))
        else if (TObject(Data) is TBoard) then
          ListBox.AddItem(Text, TObject(Data));
        ListBox.ItemIndex := ListBox.Count -1;
      end;
    end;
  end;
  TreeView.ClearSelection;
  if count <> ListBox.Count then
    RadioGroupTarget.ItemIndex := -1;
end;

procedure TGrepDlg.TreePopupExpandClick(Sender: TObject);
var
  node: TTreeNode;
begin
  inherited;
  node := TreeView.TopItem;
  TreeView.FullExpand;
  TreeView.TopItem := node;
end;

procedure TGrepDlg.TreePopupCollapseClick(Sender: TObject);
var
  node: TTreeNode;
begin
  inherited;
  node := TreeView.TopItem;
  TreeView.FullCollapse;
  if node.Level = 0 then
    TreeView.TopItem := node
  else
    TreeView.TopItem := node.Parent;
end;

procedure TGrepDlg.ListPopupDeleteClick(Sender: TObject);
var
  count: integer;
begin
  inherited;
  count := ListBox.Count;
  ListBox.DeleteSelected;
  if count <> ListBox.Count then
    RadioGroupTarget.ItemIndex := -1;
end;

procedure TGrepDlg.ListPopupClearClick(Sender: TObject);
begin
  inherited;
  ListBox.Clear;
end;

procedure TGrepDlg.TreeViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
  VK_RETURN: TreePopupAddClick(Sender);
  end;
end;

procedure TGrepDlg.ListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
  VK_DELETE: ListPopupDeleteClick(Sender);
  end;
end;

procedure TGrepDlg.ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  index: integer;
begin
  inherited;
  (* 右クリック選択 ListBoxにはRightClickSelectプロパティがない *)
  if (Button = mbRight) then
  begin
    index := ListBox.ItemAtPos(Point(X, Y), true);
    if (index >= 0) and (index < ListBox.Count) then
    begin
      if not ListBox.Selected[index] then
      begin
        ListBox.ClearSelection;
        ListBox.Selected[index] := true;
      end;
    end;
  end;
end;

procedure TGrepDlg.ListBoxExit(Sender: TObject);
begin
  inherited;
  //ListBox.ClearSelection;
end;

procedure TGrepDlg.TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  node: TTreeNode;
begin
  inherited;
  (* RightClickSelectでもポップアップメニューが出た時点では選択されてない *)
  node := TreeView.GetNodeAt(MousePos.X, MousePos.Y);
  if node <> nil then
    node.Selected := true;
end;

procedure TGrepDlg.TreeViewDblClick(Sender: TObject);
var
  node: TTreeNode;
begin
  inherited;
  node := TreeView.Selected;
  if (node <> nil) and (node.Count = 0) then
    TreePopupAddClick(Sender);
end;

procedure TGrepDlg.ListBoxDblClick(Sender: TObject);
begin
  inherited;
  if ListBox.ItemIndex >= 0 then
    ListPopupDeleteClick(Sender);
end;

{beginner}
procedure TGrepDlg.CheckBoxShowDirectClick(Sender: TObject);
begin
  if CheckBoxShowDirect.Checked then begin
    CheckBoxPopup.Checked := False;
    CheckBoxIncludeRef.Enabled := True;
  end else begin
    CheckBoxIncludeRef.Enabled := False;
  end;
end;

procedure TGrepDlg.CheckBoxIncludeRefClick(Sender: TObject);
begin
end;
{/beginner}

end.
