unit UImageViewCacheListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UHttpManage, UImageViewConfig, UImageViewer, ApiBmp, PNGImage, SPIs, SPIbmp,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, UAnimatedPaintBox, Menus{, GIFImage};

type
  TImageViewCacheListForm = class(TForm)
    ListViewCache: TListView;
    Memo: TMemo;
    Splitter2: TSplitter;
    PanelPreview: TPanel;
    Splitter1: TSplitter;
    StatusBar: TStatusBar;
    PopupMenu: TPopupMenu;
    MenuItemOpen: TMenuItem;
    N1: TMenuItem;
    MenuItemCopyURL: TMenuItem;
    MenuItemCopyCacheName: TMenuItem;
    MenuItemDelCache: TMenuItem;
    MenuItemBrocra: TMenuItem;
    N2: TMenuItem;
    MenuItemRelease: TMenuItem;
    MenuItemSelectAll: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure ListViewCacheClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewCacheDblClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemCopyURLClick(Sender: TObject);
    procedure MenuItemCopyCacheNameClick(Sender: TObject);
    procedure MenuItemDelCacheClick(Sender: TObject);
    procedure MenuItemBrocraClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure MenuItemReleaseClick(Sender: TObject);
    procedure MenuItemSelectAllClick(Sender: TObject);
    procedure ListViewCacheMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Private 宣言 }
    CacheList: TList;
    PaintBox: TAnimatedPaintBox;
    OwnBitmap: TBitmap;
    HideOnApplicationMinimize: Boolean;
    FIndex: integer;
    FItem: TListItem;
    procedure MakePreView(URL: String);
    procedure CreateList;
  public
    { Public 宣言 }
    procedure MainWndOnShow;
    procedure MainWndOnHide;
  end;

var
  ImageViewCacheListForm: TImageViewCacheListForm;

implementation

{$R *.dfm}

uses
  Main, Clipbrd;

{ TImageViewCacheListForm }

(* 初期化 *)
procedure TImageViewCacheListForm.FormCreate(Sender: TObject);
begin
  CacheList := TList.Create;

  PaintBox := TAnimatedPaintBox.Create(PanelPreView);
  PaintBox.Parent := PanelPreView;
  PaintBox.Align := alClient;
  PaintBox.ShrinkType := stHighQuality;//stHighSpeed;
  PaintBox.Enabled := False;

  FIndex := -1;
  FItem := nil;
  HideOnApplicationMinimize := false;
end;

(* 破棄 *)
procedure TImageViewCacheListForm.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to CacheList.Count - 1 do
    TCacheItem(CacheList.Items[i]).Free;

  CacheList.Free;
  PaintBox.Free;
end;

(* 閉じた時 *)
procedure TImageViewCacheListForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ImageViewCacheListForm := nil;
end;


procedure TImageViewCacheListForm.FormShow(Sender: TObject);
  procedure LoadWindowPos;
  var
    strList: TStringList;
    i: integer;
  begin
    strList := TStringList.Create;

    strList.CommaText := ImageViewConfig.CacheListRect;
    SetBounds(StrToInt(strList[0]), StrToInt(strList[1]),
                      StrToInt(strList[2]), strToInt(strList[3]));
    strList.Clear;
    strList.CommaText := ImageViewConfig.CacheListColumnWidth;
    for i := 0 to strList.Count - 1 do
      ListViewCache.Columns[i].Width := StrToInt(strList[i]);
    strList.Clear;
    PanelPreView.Height := ImageViewConfig.CacheListSplit1;
    Memo.Width := PanelPreView.ClientWidth - ImageViewConfig.CacheListSplit2;

    strList.Free;
  end;

begin
  if HideOnApplicationMinimize then
    exit;

  OwnBitmap := TBitmap.Create;
  LoadwindowPos;
  SetWindowLong(self.Handle, GWL_HWNDPARENT, MainWnd.Handle);

  CreateList;
end;

procedure TImageViewCacheListForm.FormHide(Sender: TObject);
var
  i: integer;
begin
  if HideOnApplicationMinimize then
    exit;

  OwnBitmap.Free;
  PaintBox.Bitmap := nil;

  for i := 0 to CacheList.Count - 1 do
    TCacheItem(CacheList.Items[i]).Free;

  CacheList.Clear;
  ListViewCache.Clear;

  ImageViewConfig.CacheListRect
   := IntToStr(BoundsRect.Left) + ', '
    + IntToStr(BoundsRect.Top) + ', '
    + IntToStr(BoundsRect.Right - BoundsRect.Left) + ', '
    + IntToStr(BoundsRect.Bottom - BoundsRect.Top);

  ImageViewConfig.CacheListColumnWidth
   := IntToStr(ListViewCache.Columns[0].Width) + ', '
    + IntToStr(ListViewCache.Columns[1].Width) + ', '
    + IntToStr(ListViewCache.Columns[2].Width) + ', '
    + IntToStr(ListViewCache.Columns[3].Width) + ', '
    + IntToStr(ListViewCache.Columns[4].Width);

  ImageViewConfig.CacheListSplit1 := PanelPreView.Height;
  ImageViewConfig.CacheListSplit2 := PanelPreView.ClientWidth - Memo.Width;
end;

(* リストをクリック *)
procedure TImageViewCacheListForm.ListViewCacheClick(Sender: TObject);
var
  item: TListItem;
  index: integer;
begin
  if ListViewCache.SelCount > 1 then
    item := ListViewCache.ItemFocused
  else
    item := ListViewCache.Selected;

  if item = nil then begin
    Memo.Clear;
    PaintBox.Bitmap := nil;
    FItem := nil;
    exit;
  end;
  if item = FItem then
    exit;
  FItem := item;
  index := item.Index;
  With TCacheItem(CacheList.Items[index]) do
  begin
    Memo.Clear;
    Memo.Lines.Add('URL: ' + URL);
    Memo.Lines.Add('LastModified: ' + LastModified);
    Memo.Lines.Add('LastAccess: ' + DateTimeToStr(FileDateToDateTime(Date)));
    Memo.Lines.Add('Content-Type: ' + ContentType);
    Memo.Lines.Add('Size: ' + IntToStr(Size) + ' byte');
    Memo.Lines.Add('Status: ' + Status);
    Memo.Lines.Add('Cache File: ' + Name);

    MakePreView(URL);
  end;
end;

(* リストをダブルクリック *)
procedure TImageViewCacheListForm.ListViewCacheDblClick(Sender: TObject);
var
  index: integer;
  item: TListItem;
begin
  if ListViewCache.SelCount > 1 then
    Item := ListViewCache.ItemFocused
  else
    Item := ListViewCache.Selected;

  if Item = nil then begin
    Memo.Clear;
    PaintBox.Bitmap := nil;
    exit;
  end;

  index := item.Index;

  (* ビューアで開く *)
  ImageForm.GetImage(TCacheItem(CacheList.Items[index]).URL);
end;

(* マウスオーバーで表示 *)
procedure TImageViewCacheListForm.ListViewCacheMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  item: TListItem;
  index: integer;
begin
  if ListViewCache.SelCount > 0 then
    exit;
  item := ListViewCache.GetItemAt(X, Y);
  if item = nil then begin
    Memo.Clear;
    PaintBox.Bitmap := nil;
    FItem := nil;
    exit;
  end;
  if item = FItem then
    exit;
  FItem := item;
  index := FItem.Index;
  With TCacheItem(CacheList.Items[index]) do
  begin
    Memo.Clear;
    Memo.Lines.Add('URL: ' + URL);
    Memo.Lines.Add('LastModified: ' + LastModified);
    Memo.Lines.Add('LastAccess: ' + DateTimeToStr(FileDateToDateTime(Date)));
    Memo.Lines.Add('Content-Type: ' + ContentType);
    Memo.Lines.Add('Size: ' + IntToStr(Size) + ' byte');
    Memo.Lines.Add('Status: ' + Status);
    Memo.Lines.Add('Cache File: ' + Name);

    MakePreView(URL);
  end;
end;

procedure TImageViewCacheListForm.PopupMenuPopup(Sender: TObject);
var
  b: Boolean;
begin
  b := (ListViewCache.Items.Count > 0) and (ListViewCache.SelCount > 0);
  MenuItemRelease.Visible := b;
  MenuItemSelectAll.Visible := b;
  MenuItemOpen.Visible := b;
  MenuItemCopyURL.Visible := b;
  MenuItemCopyCacheName.Visible := b;
  MenuItemDelCache.Visible := b;
  MenuItemBrocra.Visible := b;
end;

{ 右クリックメニューのハンドラー群 }
(* ビューアで開く *)
procedure TImageViewCacheListForm.MenuItemOpenClick(Sender: TObject);
var
  item: TListItem;
begin
  item := ListViewCache.Selected;
  while (item <> nil) do
  begin
    ImageForm.GetImage(item.Caption);
    item := ListViewCache.GetNextItem(item, sdBelow, [isSelected]);
  end;
end;

(* URLをコピー *)
procedure TImageViewCacheListForm.MenuItemCopyURLClick(Sender: TObject);
var
  item: TListItem;
begin
  item := ListViewCache.ItemFocused;

  if (item = nil) then
    exit;
  Clipboard.AsText := item.Caption;
end;

(* キャッシュのファイル名をコピー *)
procedure TImageViewCacheListForm.MenuItemCopyCacheNameClick(
  Sender: TObject);
var
  item: TListItem;
begin
  item := ListViewCache.ItemFocused;
  if (item = nil) then
    exit;
  Clipboard.AsText := item.SubItems[3];
end;

(* キャッシュ削除 *)
procedure TImageViewCacheListForm.MenuItemDelCacheClick(Sender: TObject);
var
  item: TListItem;
  NextItem: TListItem;
  S: string;
begin
  item := ListViewCache.Selected;
  while (item <> nil) do
  begin
    S := item.Caption;
    if HttpManager.CacheExists(S) then
      HttpManager.DeleteCache(S);
    NextItem := ListViewCache.GetNextItem(item, sdBelow, [isSelected]);
    if NextItem = item then
      break
    else
      item := NextItem;
  end;
  FIndex := -1;
  CreateList;
end;

(* ブラクラ登録 *)
procedure TImageViewCacheListForm.MenuItemBrocraClick(Sender: TObject);
var
  item: TListItem;
  NextItem: TListItem;
  S: String;
begin
  item := ListViewCache.Selected;
  while (item <> nil) do
  begin
    S := item.Caption;
    if (item.SubItems[2] = 'BROCRA') then begin
      if HttpManager.CacheExists(S) then
        HttpManager.DeleteCache(S);
    end else
      HttpManager.RegisterBrowserCrasher(S);
    NextItem := ListViewCache.GetNextItem(item, sdBelow, [isSelected]);
    if NextItem = item then
      break
    else
      item := NextItem;
  end;
  FIndex := -1;
  CreateList;
end;

(* 選択解除 *)
procedure TImageViewCacheListForm.MenuItemReleaseClick(Sender: TObject);
begin
  ListViewCache.Selected := nil;
end;

(* 全て選択 *)
procedure TImageViewCacheListForm.MenuItemSelectAllClick(Sender: TObject);
begin
  ListViewCache.SelectAll;
end;

//アプリ最小化時に自分を隠す(Main.pasのTMainWnd.OnAboutToShow参照)
procedure TImageViewCacheListForm.MainWndOnHide;
begin
  if Visible then
  begin
    HideOnApplicationMinimize := True;
    Hide;
  end;
end;

//アプリ復元時に必要なら復元(Main.pasのTMainWnd.OnAboutToShow参照)
procedure TImageViewCacheListForm.MainWndOnShow;
begin
  if HideOnApplicationMinimize then
    Self.Show;
  HideOnApplicationMinimize := False;
end;

(* リストを生成 *)
procedure TImageViewCacheListForm.CreateList;
var
  i: integer;
  newItem: TListItem;
begin
  for i := 0 to CacheList.Count - 1 do
   TCacheItem(CacheList.Items[i]).Free;

  CacheList.Clear;

  HttpManager.GetCacheFileList(CacheList);

  for i := 0 to CacheList.Count - 1 do
  begin
    HttpManager.FillCacheItem(TCacheItem(CacheList.Items[i]));
  end;

  StatusBar.Panels.Items[0].Text := 'ファイル数: ' + IntToStr(CacheList.Count);

  ListViewCache.Clear;
  for i := 0 to CacheList.Count - 1 do
  begin
    newItem := ListViewCache.Items.Add;
    newItem.Caption := TCacheItem(CacheList.Items[i]).URL;
    newItem.SubItems.Add(DateTimeToStr(FileDateToDateTime(TCacheItem(CacheList.Items[i]).Date)));
    newItem.SubItems.Add(TCacheItem(CacheList.Items[i]).ContentType);
    newItem.SubItems.Add(TCacheItem(CacheList.Items[i]).Status);
    newItem.SubItems.Add(TCacheItem(CacheList.Items[i]).Name);
  end;
end;


(* PaintBoxに画像を表示 *)
procedure TImageViewCacheListForm.MakePreView(URL: String);
var
  Header: TStringList;
  CacheStream: TStringStream;
  ImageConv: TGraphic;
  ImageHeaderPointer: PChar;
begin
  Header := TStringList.Create;
  CacheStream := TStringStream.Create('');
  PaintBox.Bitmap := nil;

  if (HttpManager.ReadCache(URL, CacheStream, Header) >= 0) then begin

    if Header.Values['STATUS'] = 'BROCRA' then begin
      Memo.Lines.Add('ブラクラ危険');
    end else if ImageViewConfig.ExamArchiveEnabled(Text) then begin
      Memo.Lines.Add('書庫ファイル：キャッシュ済み');
    end else if Header.Values['STATUS'] = 'PROTECT' then begin
      Memo.Lines.Add('モザイク未解除ファイル：キャッシュ済み');
    end else begin

      SeekSkipMacBin(CacheStream);
      ImageHeaderPointer
              := PChar(CacheStream.DataString) + CacheStream.Position;

      if (StrLComp(ImageHeaderPointer, #$FF#$D8#$FF#$E0#$00#$10'JFIF',10) = 0)
          or (StrLComp(ImageHeaderPointer, #$FF#$D8#$FF#$E1, 4) = 0) then
        ImageConv := TApiBitmap.Create
      (* pngの展開にPNGImageを使う (aiai) *)
      else if (StrLComp(ImageHeaderPointer,
              #$89#$50#$4E#$47#$0D#$0A#$1A#$0A#$00#$00#$00#$0D#$49#$48#$44#$52,
                      16) = 0) then
        ImageConv := TPNGObject.Create
      else
        ImageConv := TSPIBitmap.Create;

      try
        ImageConv.LoadFromStream(CacheStream);
        OwnBitmap.Assign(ImageConv);
        PaintBox.Bitmap := OwnBitmap;
      except
        PaintBox.Bitmap := nil;
        Memo.Lines.Add('Decode Error');
      end;
      ImageConv.Free;
    end;
  end;

  CacheStream.Free;
  Header.Free;
end;

end.
