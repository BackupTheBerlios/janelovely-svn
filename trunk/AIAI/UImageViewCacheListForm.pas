unit UImageViewCacheListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UHttpManage, UImageViewConfig, UImageViewer, ApiBmp, PNGImage, SPIs, SPIbmp,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, UAnimatedPaintBox, Menus,
  JLXPComCtrls{, GIFImage};

type
  TLoadCacheEvent = procedure (Item: TCacheItem) of Object;

  TLoadCacheThread = class;

  TCacheRecord = record
    Name: String;
    Date: Integer;
    URL: String;
    Status: String;
    LastModified: String;
    Size: Integer;
    ContentType: String;
    ResponseCode: Integer;
    ResponseText: String;
  end;

  TImageViewCacheListForm = class(TForm)
    ListViewCache: TListView;
    Memo: TMemo;
    Splitter2: TSplitter;
    PanelPreview: TPanel;
    Splitter1: TSplitter;
    StatusBar: TJLXPStatusBar;
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
    ProgressBar: TProgressBar;
    procedure FormShow(Sender: TObject);
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
    procedure ListViewCacheColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure ListViewCacheSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormResize(Sender: TObject);
  private
    { Private 宣言 }
    PaintBox: TAnimatedPaintBox;
    OwnBitmap: TBitmap;
    HideOnApplicationMinimize: Boolean;
    FIndex: integer;
    FItem: TListItem;
    LoadCacheThread: TLoadCacheThread;
    AlphaColumnSort: array[0..4] of boolean;  //昇順か否か
    procedure MakePreView(URL: String);
    procedure CreateList;
    procedure LoadCacheThreadTerminate(Sender: TObject);
  public
    { Public 宣言 }
    procedure MainWndOnShow;
    procedure MainWndOnHide;
  end;


  { キャッシュをLoadして一覧をつくるスレッド }

  TLoadCacheThread = class(TThread)
  private
    CachePath: String;
    CacheItem: TCacheRecord;
    FileCount: Cardinal;
    procedure SynchSetProgBar;
    procedure Synch;
    function FillCacheItem: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(ACachePath: String);
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
  PaintBox := TAnimatedPaintBox.Create(PanelPreView);
  PaintBox.Parent := PanelPreView;
  PaintBox.Align := alClient;
  PaintBox.ShrinkType := stHighQuality;//stHighSpeed;
  PaintBox.Enabled := False;

  PanelPreview.DoubleBuffered := True;

  FIndex := -1;
  FItem := nil;
  LoadCacheThread := nil;
  HideOnApplicationMinimize := false;
end;

(* 破棄 *)
procedure TImageViewCacheListForm.FormDestroy(Sender: TObject);
begin
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
  //if HideOnApplicationMinimize then
  //  exit;

  OwnBitmap := TBitmap.Create;
  LoadwindowPos;
  SetWindowLong(self.Handle, GWL_HWNDPARENT, MainWnd.Handle);

  CreateList;
end;

procedure TImageViewCacheListForm.FormHide(Sender: TObject);
var
  i: integer;
begin
  //if HideOnApplicationMinimize then
  // exit;

  if Assigned(LoadCacheThread) then
  begin
    LoadCacheThread.Suspend;
    LoadCacheThread.FreeOnTerminate := False;
    LoadCacheThread.OnTerminate := nil;
    LoadCacheThread.Terminate;
    LoadCacheThread.Resume;
    LoadCacheThread.WaitFor;
    FreeAndNil(LoadCacheThread);
  end;

  OwnBitmap.Free;
  PaintBox.Bitmap := nil;

  for i := 0 to ListViewCache.Items.Count - 1 do
    TCacheItem(ListViewCache.Items.Item[i].Data).Free;

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

(* リストを選択 *)
procedure TImageViewCacheListForm.ListViewCacheSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if item = nil then begin
    Memo.Clear;
    PaintBox.Bitmap := nil;
    FItem := nil;
    exit;
  end;
  if item = FItem then
    exit;
  FItem := item;
  With TCacheItem(item.Data) do
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

  (* ビューアで開く *)
  ImageForm.GetImage(TCacheItem(item.Data).URL);
end;

(* マウスオーバーで表示 *)
procedure TImageViewCacheListForm.ListViewCacheMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  item: TListItem;
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
  With TCacheItem(item.Data) do
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
  item, DelItem: TListItem;
  S: string;
  CacheItem: TCacheItem;
begin
  item := ListViewCache.Selected;
  while (item <> nil) do
  begin
    DelItem := item;
    item := ListViewCache.GetNextItem(item, sdBelow, [isSelected]);
    if item = DelItem then item := nil;
    S := DelItem.Caption;
    if HttpManager.CacheExists(S) then
    begin
      HttpManager.DeleteCache(S);
      CacheItem := TCacheItem(DelItem.Data);
      DelItem.Delete;
      CacheItem.Free;
    end;
  end;

  FIndex := -1;
  ImageViewCacheListForm.StatusBar.Panels.Items[0].Text
    := 'ファイル数: '
    + IntToStr(ImageViewCacheListForm.ListViewCache.Items.Count);
  //CreateList;
end;

(* ブラクラ登録 *)
procedure TImageViewCacheListForm.MenuItemBrocraClick(Sender: TObject);
var
  item, DelItem: TListItem;
  S: String;
  CacheItem: TCacheItem;
begin
  item := ListViewCache.Selected;
  while (item <> nil) do
  begin
    DelItem := item;
    item := ListViewCache.GetNextItem(item, sdBelow, [isSelected]);
    if item = DelItem then item := nil;
    S := DelItem.Caption;
    if (DelItem.SubItems[2] = 'BROCRA') then begin
      if HttpManager.CacheExists(S) then
      begin
        HttpManager.DeleteCache(S);
        CacheItem := TCacheItem(DelItem.Data);
        DelItem.Delete;
        CacheItem.Free;
      end;
    end else
    begin
      HttpManager.RegisterBrowserCrasher(S);
      DelItem.SubItems[2] := 'BROCRA';
      TCacheItem(DelItem.Data).Status := 'BROCRA';
      TCacheItem(DelItem.Data).Size := 0;
    end;
  end;
  PaintBox.Bitmap := nil;
  FIndex := -1;
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

const
  PngHeader: Array[0..7] of Char = (#137, 'P', 'N', 'G', #13, #10, #26, #10);

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
      else if (StrLComp(ImageHeaderPointer, PngHeader, 8) = 0) then
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


function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer;
  stdcall;
var
 Value: integer;
 Index: integer;
begin
 Index:=Abs(ParamSort);  //マイナスをとる

 case Index of
  1:
    //左端のカラム用
    Value := lstrcmp(PChar(TListItem(Item1).Caption),
                     PChar(TListItem(Item2).Caption));
  else
    //それ以外のカラム用
    Value := lstrcmp(PChar(TListItem(Item1).SubItems[Index-2]),
                     PChar(TListItem(Item2).SubItems[Index-2]));
 end;
 if ParamSort>0 then   //プラスだったら
  Result:=Value          //昇順にする
 else
  Result:=-Value;        //降順にする
end;

procedure TImageViewCacheListForm.ListViewCacheColumnClick(Sender: TObject;
  Column: TListColumn);
var
 Index: integer;
begin
  if not AlphaColumnSort[Column.Index] then
   Index:=Column.Index+1                     //昇順
  else
   Index:=-(Column.Index+1);                 //降順

  ListViewCache.CustomSort(@CustomSortProc, Index);
  AlphaColumnSort[Column.Index]:=not AlphaColumnSort[Column.Index];
  ListViewCache.DoubleBuffered := True;
  ListViewCache.Repaint;
  ListViewCache.DoubleBuffered := False;
end;

procedure TImageViewCacheListForm.FormResize(Sender: TObject);
begin
  ProgressBar.Left := ClientRect.Right - ProgressBar.Width - 20;
  ProgressBar.Top := ClientRect.Bottom - ProgressBar.Height - 2;
end;





(* リストを生成 *)
procedure TImageViewCacheListForm.CreateList;
var
  i: integer;
//  newItem: TListItem;
begin
  for i := 0 to ListViewCache.Items.Count - 1 do
    TCacheItem(ListViewCache.Items.Item[i].Data).Free;

  ListViewCache.Clear;

  LoadCacheThread := TLoadCacheThread.Create(HttpManager.CachePath);
  LoadCacheThread.FreeOnTerminate := True;
  LoadCacheThread.OnTerminate := LoadCacheThreadTerminate;
  LoadCacheThread.Resume;
end;

procedure TImageViewCacheListForm.LoadCacheThreadTerminate(Sender: TObject);
begin
  StatusBar.Panels.Items[1].Text := 'キャッシュファイル取得完了';
  LoadCacheThread := nil;
  //ProgressBar.Hide;
end;






 { TLoadCacheThread }

constructor TLoadCacheThread.Create(ACachePath: String);
begin
  CachePath := ACachePath;
  FileCount := 0;

  inherited Create(True);
end;

procedure TLoadCacheThread.Execute;
var
  Back: Integer;
  F: TSearchRec;
  Path: String;
begin
  Path := IncludeTrailingPathDelimiter(CachePath);
  if not DirectoryExists(Path) then Exit;
  try
    try
      Back := FindFirst(Path + '*.vch', faArchive, F);
      while (Back = 0) and not terminated do begin
        Inc(FileCount);
        Back := FindNext(F);
      end;
    finally
      FindClose(F);
    end;
    if terminated then
      exit;
    Synchronize(SynchSetProgBar);
    try
      Back := FindFirst(Path + '*.vch', faArchive, F);
      while (Back = 0) and not terminated do begin
        if (F.Name<>'.') and (F.Name<>'..') then
        begin
          CacheItem.Name := F.Name;
          CacheItem.Date := F.Time;
          CacheItem.Size := F.Size;
          FillCacheItem;
          Synchronize(Synch);
        end;
        Back := FindNext(F);
      end;
    finally
      FindClose(F);
    end;
  except
  end;
end;


function TLoadCacheThread.FillCacheItem: Boolean;
var
  FileName: String;
  FileStream: TFileStream;
  Header: TStringList;
  HeaderSize: Integer;
  Buf: String;
begin
  FileName := IncludeTrailingPathDelimiter(CachePath) + CacheItem.Name;
  try
    FileStream := nil;
    try
      FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
      FileStream.Read(HeaderSize, Sizeof(HeaderSize));
      SetLength(Buf, HeaderSize);
      FileStream.Read(Pchar(Buf)^, Length(Buf));
    finally
      FileStream.Free;
    end;
    Header := TStringList.Create;
    Header.Text := Buf;
    CacheItem.Size := CacheItem.Size - HeaderSize - 4;
    CacheItem.URL := Header.Values['URL'];
    CacheItem.ContentType := Header.Values['ContentType'];
    CacheItem.ResponseCode := StrToIntDef(Header.Values['ResCode'], -1);
    CacheItem.ResponseText := Header.Values['ResText'];
    CacheItem.LastModified := Header.Values['LastModified'];
    CacheItem.Status := Header.Values['STATUS'];
    Header.Free;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLoadCacheThread.SynchSetProgBar;
begin
  ImageViewCacheListForm.ProgressBar.Max := FileCount;
  ImageViewCacheListForm.ProgressBar.Position := 0;
  //ImageViewCacheListForm.ProgressBar.Show;
end;

procedure TLoadCacheThread.Synch;
var
  newItem: TListItem;
  CacheItem2: TCacheItem;
begin
  CacheItem2 := TCacheItem.Create;
  CacheItem2.Name := CacheItem.Name;
  CacheItem2.Date := CacheItem.Date;
  CacheItem2.URL := CacheItem.URL;
  if CacheItem.Status <> '' then
    CacheItem2.Status := CacheItem.Status
  else if CacheItem.ResponseText <> '' then
    CacheItem2.Status := CacheItem.ResponseText
  else
    CacheItem2.Status := '';
  CacheItem2.LastModified := CacheItem.LastModified;
  CacheItem2.Size := CacheItem.Size;
  CacheItem2.ContentType := CacheItem.ContentType;
  CacheItem2.ResponseCode := CacheItem.ResponseCode;

  newItem := ImageViewCacheListForm.ListViewCache.Items.Add;
  newItem.Caption := CacheItem2.URL;
  newItem.SubItems.Add(DateTimeToStr(FileDateToDateTime(CacheItem2.Date)));
  newItem.SubItems.Add(CacheItem2.ContentType);
  newItem.SubItems.Add(CacheItem2.Status);
  newItem.SubItems.Add(CacheItem2.Name);
  newItem.Data := CacheItem2;
  ImageViewCacheListForm.StatusBar.Panels.Items[0].Text
    := 'ファイル数: '
    + IntToStr(ImageViewCacheListForm.ListViewCache.Items.Count);
  ImageViewCacheListForm.ProgressBar.Position
    := ImageViewCacheListForm.ListViewCache.Items.Count;
end;

end.
