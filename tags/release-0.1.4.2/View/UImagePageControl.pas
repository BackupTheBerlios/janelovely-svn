unit UImagePageControl;

interface

uses
  Messages, Classes, Controls, ComCtrls, Types, UMSPageControl, UImageTabSheet;

type

  TImagePageControl = class(TMSPageControl)
  protected
    ChangeFrom:Integer;
    FOnAllTabClosed:TNotifyEvent;
    FStatusBar: TStatusBar;
    procedure ImageTabMode(Value:Boolean);
    procedure SetOnAllTabClosed(Value:TNotifyEvent);
    procedure DoExit;override;
    procedure FixHighlight(Index:Integer);override;
    procedure DrawTab(DrawnTabIndex: Integer; const Rect: TRect; Active: Boolean);override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Resize;override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Change;override;//Change,CanChangeはページ追加などで外から呼び出さないといけない
    function CanChange:Boolean;override;
    procedure SetFocus;override;
    procedure UpdateStatusBar(Sender:TObject=nil);
    procedure CheckTabExist;
    property StatusBar:TStatusBar read FStatusBar write FStatusBar;
    property OnAllTabClosed:TNotifyEvent read FOnAllTabClosed write SetOnAllTabClosed;
    procedure Highlighten(Index:Integer;Value:Boolean);override;
    class procedure SetTabStyle(Value:TTabStyle);
    class procedure SetMultiLine(Value:Boolean);
    class procedure SetImageTabMode(Value:Boolean);
    class function PageControl(Index:Integer):TPageControl;
    class function PageControlCount:Integer;
    class procedure EnableSetFocus(Value:Boolean);
    class procedure SetOnHighlightChange(Value:TNotifyEvent);
  end;

implementation

uses Windows, SysUtils, Graphics, UImageViewConfig, UHttpManage, UImageViewer, UArchiveView, ARCHIVES;

const
  HighlightWidth=16;
  HighlightHeight=16;
  HighlightColor=clBlue;

var
  ImagePageList:TList;
  classTabStyle:TTabStyle=tsTabs;
  classMultiLine:Boolean=False;
  classImageTabMode:Boolean=True;
  classEnableSetFocus:Boolean=True;
  classOnHighlightChange:TNotifyEvent;

constructor TImagePageControl.Create(AOwner:TComponent);
begin
  inherited;
  ChangeFrom:=intUNDEFINED;
  with ImagePageList do begin
    Add(Self);
    if Capacity=Count then Capacity := Count * 2;
  end;

 //Parentの設定がないとTabHeight,TabWidthの設定でエラーになる
 if AOwner is TWinControl then
    Parent:=TWinControl(AOwner)
  else
    raise Exception.Create('TImagePageControlのOwnerにはTWinControl派生クラスを指定');

  HotTrack:=True;
  Align:=alClient;

  Images:=ImageForm.StatusIcons;
  PopupMenu:=ImageForm.ImagePopUpMenu;

  Style:=classTabStyle;
  MultiLine:=classMultiLine;
  ImageTabMode(classImageTabMode);
end;

destructor TImagePageControl.Destroy;
begin
  with ImagePageList do begin
    Remove(Self);
    if Capacity>Count*3 then Capacity := Count * 2;
  end;
  inherited;
end;


//ビューアにフォーカスがあるときだけ継承プロシージャを呼び出し
procedure TImagePageControl.SetFocus;
begin
  if ImageForm.Active then inherited;
end;

//フォーカスを失った場合の選択原点に関する処理
procedure TImagePageControl.DoExit;
begin
  inherited;
  if ImageViewConfig.ContinuousTabChange then begin
    if (GetKeyState(VK_SHIFT)<0) and (PushShiftAt=intUNDEFINED) then
      PushShiftAt:=ActivePageIndex;
  end else begin
    TerminateSelectionState;
  end;
end;


//ページ変更直前の処理(動画の停止など)
function TImagePageControl.CanChange:Boolean;
begin
  //GoForwad,BackWardを通っていない(クリックされた)場合は、
  //範囲選択なら変更前と変更後のページの関係からDirectionを定義する(残りの処理はChangeで)
  if GetKeyState(VK_SHIFT)<0 then
    ChangeFrom:=ActivePageIndex
  else
    ChangeFrom:=intUNDEFINED;

  if Assigned(ActivePage) then TImageTabSheet(ActivePage).HaltContentView;
  Result:=inherited CanChange;
end;


//ページ変更後の処理(動画の開始など)
procedure TImagePageControl.Change;
begin
  if CanFocus then SetFocus; //アーカイブのページコントロールとの切り替えをスムーズに
  if ChangeFrom<>intUNDEFINED then begin //クリックによる変更かつシフトキーあり
    if ActivePageIndex>ChangeFrom then
      FDirection:=pdFORWARD
    else if ActivePageIndex<ChangeFrom then
      FDirection:=pdBACKWARD
    else
      FDirection:=pdUNDEFINED;//起こりえない
    ChangeFrom:=intUNDEFINED;
  end;
  inherited Change;
  if Assigned(ActivePage) then TImageTabSheet(ActivePage).ActContentView;
  UpdateStatusBar;
end;


//マウスボタンへの応答
procedure TImagePageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  case Button of
    mbLeft: begin
      if Shift=[ssLeft,ssDouble] then begin
        if CanFocus then SetFocus;//Changeでフォーカスが移動している場合があるため
        ImageForm.CloseTab(Self);
      end;
    end;
    mbMiddle: begin
      if CanFocus then SetFocus;//Changeでフォーカスが移動している場合があるため
      if ssCtrl in Shift then begin
        ImageForm.QuickSavePopup.PopupComponent:=Self;
        ImageForm.QuickSavePopup.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y)
      end else begin
        ImageForm.SaveImage(Self);
      end;
    end;
    mbRight: begin
      if CanFocus then SetFocus;//Changeでフォーカスが移動している場合があるため
      ImageForm.ImagePopUpMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
    end;
  end;
  FDirection:=pdUNDEFINED;//Changeで定義されていたらここで消える
end;

//キーボードへの応答(処理が必要なのはアクティブページのスクロールのみ)
procedure TImagePageControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and Assigned(ActivePage) then begin
    case Key of
      VK_UP   :begin
        TImageTabSheet(ActivePage).ScrollContentView(0,-1);
        Key:=0;
      end;
      VK_DOWN :begin
        TImageTabSheet(ActivePage).ScrollContentView(0, 1);
        Key:=0;
      end;
      VK_LEFT :begin
        TImageTabSheet(ActivePage).ScrollContentView(-1,0);
        Key:=0;
      end;
      VK_RIGHT:begin
        TImageTabSheet(ActivePage).ScrollContentView( 1,0);
        Key:=0;
      end;
    else
      inherited KeyDown(Key, Shift);
    end;
  end else begin
    inherited KeyDown(Key, Shift);
  end;
end;


//ハイライト処理(書庫ページにも通知)
procedure TImagePageControl.Highlighten(Index:Integer;Value:Boolean);
begin
  if not(ImageViewConfig.ContinuousTabChange) or (ImageViewConfig.ExamArchiveType(TImageTabSheet(Pages[Index]).URI)=atNone) then
    inherited
  else begin
    if Index<>ActivePageIndex then begin
      if Index=PushShiftAt then begin
        TImageTabSheet(Pages[Index]).HighlightContentView(Value,SelectionDirectTo);
      end else begin
        TImageTabSheet(Pages[Index]).HighlightContentView(Value,pdUNDEFINED);
      end;
    end;
  end;
  if Assigned(classOnHighlightChange) then classOnHighlightChange(Self);
end;


//ハイライト確定処理(書庫ページにも通知)
procedure TImagePageControl.FixHighlight(Index:Integer);
begin
  inherited;
  TImageTabSheet(Pages[Index]).TerminateContentViewHighlight;
end;


//サイズ変更でステータスバーを更新
procedure TImagePageControl.Resize;
begin
  inherited;
  UpdateStatusBar(Self);
end;


//読み込みイベントなどによるステータス表示の更新
procedure TImagePageControl.UpdateStatusBar(Sender: TObject);
var
  TabSheet: TImageTabSheet;
begin

  if Sender is TWebLoaderSheet then
    ImageForm.UpdateImageHint(TImageTabSheet(Sender));

  if Assigned(StatusBar) then
    if Assigned(ActivePage) then begin
      TabSheet := TImageTabSheet(ActivePage);
      if (TabSheet.SubURI = '') or (TabSheet.URI = TabSheet.SubURI) then
        StatusBar.Panels[0].Text:=TabSheet.URI
      else
        StatusBar.Panels[0].Text:=TabSheet.URI + ' (' + TabSheet.SubURI +')';
      StatusBar.Panels[1].Text:=TabSheet.StatusText;
    end else begin
      StatusBar.Panels[0].Text:='';
      Statusbar.Panels[1].Text:='';
    end;
end;

procedure TImagePageControl.CheckTabExist;
begin
  if (PageCount=0) and Assigned(FOnAllTabClosed) then
    FOnAllTabClosed(Self);
end;

//イメージタブ描画
procedure TImagePageControl.DrawTab(DrawnTabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  DrawnPage:TImageTabSheet;
begin
  DrawnPage:=TImageTabSheet(Pages[DrawnTabIndex]);
  if (DrawnPage.ImageIndex=2) and Assigned(DrawnPage.TabBitmap) and (DrawnPage.TabBitmap.Width*DrawnPage.TabBitmap.Height > 0)then begin
    Canvas.Brush.Color:=clWhite;
    Canvas.FillRect(Rect);
    Canvas.Draw(Rect.Left + (Rect.Right-Rect.Left-DrawnPage.TabBitmap.Width) div 2,
                Rect.Top + (Rect.Bottom-Rect.Top-DrawnPage.TabBitmap.Height) div 2,DrawnPage.TabBitmap)
  end else begin
    Images.Draw(Canvas,Rect.Left+4,Rect.Top+4,DrawnPage.ImageIndex);
  end;

  if DrawnPage.Highlighted then begin
    Canvas.Pen.Color:=clWhite;
    Canvas.Brush.Color:=HighlightColor;
    if (Style=tsTabs) and Active then
      Canvas.Polygon([Point(Rect.Right-6,Rect.Bottom-6),
                      Point(Rect.Right-HighlightWidth-6,Rect.Bottom-6),
                      Point(Rect.Right-6,Rect.Bottom-HighlightHeight-6)])
    else
      Canvas.Polygon([Point(Rect.Right-2,Rect.Bottom-2),
                      Point(Rect.Right-HighlightWidth-2,Rect.Bottom-2),
                      Point(Rect.Right-2,Rect.Bottom-HighlightHeight-2)]);
  end;

end;


//イメージタブモードの選択
procedure TImagePageControl.ImageTabMode(Value:Boolean);
begin
  case Value of
    False:begin
      TabHeight:=0;
      TabWidth:=0;
      OwnerDraw:=False;
    end;
    True :begin
      TabHeight:=ImageTabHeight+2;
      TabWidth:=ImageTabWidth+2;
      OwnerDraw:=True;
    end;
  end;
end;


//プロパティ設定
procedure TImagePageControl.SetOnAllTabClosed(Value:TNotifyEvent);
begin
  FOnAllTabClosed:=Value;
end;


//ナビアイコンを正しく動かすためのおまじない
function TImagePageControl.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  SendMessage(Parent.Handle,WM_MOUSEACTIVATE,0,0);
  Result:=inherited DoMouseWheelDown(Shift,MousePos);
end;
function TImagePageControl.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  SendMessage(Parent.Handle,WM_MOUSEACTIVATE,0,0);
  Result:=inherited DoMouseWheelUp(Shift,MousePos);
end;

{ class TImagePageControl }

class procedure TImagePageControl.SetTabStyle(Value:TTabStyle);
var
  i:Integer;
begin
  for i:=0 to ImagePageList.Count-1 do
    TImagePageControl(ImagePageList[i]).Style:=Value;
  classTabStyle:=Value;
end;

class procedure TImagePageControl.SetMultiLine(Value:Boolean);
var
  i:Integer;
begin
  for i:=0 to ImagePageList.Count-1 do
    TImagePageControl(ImagePageList[i]).MultiLine:=Value;
  classMultiLine:=Value;
end;

class procedure TImagePageControl.SetImageTabMode(Value:Boolean);
var
  i:Integer;
begin
  for i:=0 to ImagePageList.Count-1 do
    TImagePageControl(ImagePageList[i]).ImageTabMode(Value);
  classImageTabMode:=Value;
end;

//作成順がIndexのタブシートを返す列挙用のクラス関数
class function TImagePageControl.PageControl(Index:Integer):TPageControl;
begin
  Result:=TPageControl(ImagePageList[Index]);
end;


//全てのTTabSheetCountの数を返す
class function TImagePageControl.PageControlCount:Integer;
begin
  Result:=ImagePageList.Count;
end;

class procedure TImagePageControl.EnableSetFocus(Value:Boolean);
begin
  classEnableSetFocus:=Value;
end;

class procedure TImagePageControl.SetOnHighlightChange(Value:TNotifyEvent);
begin
  classOnHighlightChange:=Value;
end;


initialization
  ImagePageList:=TList.Create;

finalization
  ImagePageList.Free;

end.
