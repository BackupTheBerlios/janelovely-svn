unit UContentView;

interface

uses
  Windows, SysUtils, Forms, Classes, Controls, Graphics, ExtCtrls, FileCtrl, Dialogs, ComCtrls,
  ShellAPI, Messages, ApiBmp, SPIs, SPIBmp, UGIF, {GIFImage,} PNGImage, UMSPageControl, UAnimatedPaintBox, UCardinalList;

type

  //スクロールホイールが効かず、ドラッグで動かせるスクロールバーが付いたパネル
  TDragScrollPanel = class(TPanel)
  protected
    MouseOrigine:TPoint;
    HBarOrigin:Integer;
    VBarOrigin:Integer;
    MousePrevious:TPoint;
    FScrollOpposite:Boolean;
    procedure CMMouseLeave(var Message: TMessage); message CM_MouseLeave;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer);override;
    procedure ScrollBoxMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
  public
    ScrollBox:TScrollBox;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property ScrollOpposite:Boolean read FScrollOpposite write FScrollOpposite;
  end;

  TContentViewCompleteEvent = procedure (Sender:TObject; Error :Boolean) of object;

  //イマイチ役に立たないインターフェイス方式を採用。
  IContentView = Interface(IUnknown)
    procedure Action;
    procedure Hide;
    procedure Halt;
    procedure RequestCancel;
    procedure Highlight(Value:Boolean; FromOwnOriginTo:TPageControlDierction);
    procedure TerminateHighlight;
    procedure Scroll(const x,y:Integer);

    procedure AssignData(AData:TStringStream);

    function GetSmallBitmap:TBitmap;
    property SmallBitmap:TBitmap read GetSmallBitmap;

    function GetInfo:string;
    procedure SetInfo(AInfo:string);
    property Info:string read GetInfo write SetInfo;

    function GetProtect:boolean;
    procedure SetProtect(AProtect:boolean);
    property Protect:boolean read GetProtect write SetProtect;

    function GetScale:Integer;
    property Scale:Integer read GetScale;

    function GetOriginalSize:TPoint;
    property OriginalSize:TPoint read GetOriginalSize;

    function GetAdjustToWindow:Boolean;
    procedure SetAdjustToWindow(ASetAdjustToWindow:Boolean);
    property AdjustToWindow:Boolean read GetAdjustToWindow write SetAdjustToWindow;

    function GetOnComplete:TContentViewCompleteEvent;
    procedure SetOnComplete(AOnComplete:TContentViewCompleteEvent);
    property OnComplete:TContentViewCompleteEvent read GetOnComplete write SetOnComplete;

    function GetBitmap:TBitmap;
    property Bitmap:TBitmap read GetBitmap;

    function GetOnMouseDown:TMouseEvent;
    procedure SetOnMouseDown(AOnMouseDown:TMouseEvent);
    property OnMouseDown:TMouseEvent read GetOnMouseDown write SetOnMouseDown;

    function GetOnMouseUp:TMouseEvent;
    procedure SetOnMouseUp(AOnMouseUp:TMouseEvent);
    property OnMouseUp:TMouseEvent read GetOnMouseUp write SetOnMouseUp;

    function GetOnEdge:TPageControlOnEdgeEvent;
    procedure SetOnEdge(Value: TPageControlOnEdgeEvent);
    property OnEdge:TPageControlOnEdgeEvent read GetOnEdge write SetOnEdge;

    function GetOnSelectionTerminate:TNotifyEvent;
    procedure SetOnSelectionTerminate(Value: TNotifyEvent);
    property OnSelectionTerminate:TNotifyEvent read GetOnSelectionTerminate write SetOnSelectionTerminate;

    function GetOnContentClose:TNotifyEvent;
    procedure SetOnContentClose(Value: TNotifyEvent);
    property OnContentClose:TNotifyEvent read GetOnContentClose write SetOnContentClose;

  end;

  //画像表示の基本クラス
  //JpegViewとImageViewが統一されて現在は基本クラスの意味なし。
  TCustomImageView = class(TInterfacedObject,IContentView)
  protected
    FOwner:TWinControl;
    FInfo:string;
    FSmallBitmap:TBitmap;
    FData:TStringStream;
    Bitmap:TBitmap;
    Mosaic:TBitmap;
    FImageList:TBitmapList;
    FDelayTimeList:TCardinalList;
    FLoopLimit:Integer;
    Panel:TDragScrollPanel;
    PaintBox:TAnimatedPaintBox;
    FProtect:Boolean;
    FAdjustToWindow:Boolean;
    FOnComplete:TcontentviewcompleteEvent;
    FOnEdge:TPageControlOnEdgeEvent;
    FOnSelectionTerminate:TNotifyEvent;
    FOnContentClose:TNotifyEvent;
    function GetInfo:string;
    procedure SetInfo(AInfo:string);
    function GetProtect:boolean;
    procedure SetProtect(AProtect: Boolean); virtual;
    function GetOriginalSize:TPoint;
    function GetScale:Integer;
    procedure MakeSmallImage;
    function GetOnComplete:TContentViewCompleteEvent;
    procedure SetOnComplete(AOnComplete:TContentViewCompleteEvent);
    function GetAdjustToWindow:Boolean;
    procedure SetAdjustToWindow(AAdjustToWindow:Boolean);
    function GetOnMouseDown:TMouseEvent;
    procedure SetOnMouseDown(AOnMouseDown:TMouseEvent);
    function GetOnMouseUp:TMouseEvent;
    procedure SetOnMouseUp(AOnMouseUp:TMouseEvent);
    function GetOnEdge:TPageControlOnEdgeEvent;
    procedure SetOnEdge(Value: TPageControlOnEdgeEvent);
    function GetOnSelectionTerminate:TNotifyEvent;
    procedure SetOnSelectionTerminate(Value: TNotifyEvent);
    function GetOnContentClose:TNotifyEvent;
    procedure SetOnContentClose(Value: TNotifyEvent);
  public
    constructor Create(AOwner:TWinControl);
    destructor Destroy; override;
    procedure Action;virtual;
    procedure Hide;virtual;
    procedure Halt;virtual;
    procedure RequestCancel;virtual;
    procedure Highlight(Value:Boolean; FromOwnOriginTo:TPageControlDierction);virtual;
    procedure TerminateHighlight;virtual;
    procedure Scroll(const x,y:Integer);virtual;
    procedure AssignData(AData:TStringStream);virtual;abstract;
    function GetSmallBitmap:TBitmap;
    function GetBitmap:TBitmap;
    property SmallBitmap:TBitmap read GetSmallBitmap;
    property Protect:boolean read GetProtect write SetProtect;
    property OnMouseDown:TMouseEvent read GetOnMouseDown write SetOnMouseDown;
    property OnEdge:TPageControlOnEdgeEvent read GetOnEdge write SetOnEdge;
  end;

  //現在使用する唯一のCustomImageVew継承クラス
  TImageView = class(TCustomImageView)
  private
    GifData:TGifData;
    procedure GifDataOnComplete(Sender:TObject);
  public
    destructor Destroy;override;
    procedure Action;override;
    procedure Halt;override;
    procedure AssignData(AData:TStringStream);override;
  end;

implementation

uses
  UImageViewer, UImageViewConfig, Main;


{ TDragScrollPanel }


constructor TDragScrollPanel.Create(AOwner: TComponent);
begin
  inherited;
  ScrollBox:=TScrollBox.Create(AOwner);
  ScrollBox.Parent:=Self;
  ScrollBox.Align:=alClient;
  ScrollBox.DoubleBuffered:=True;
  ScrollBox.OnMouseMove:=Self.ScrollBoxMouseMove;
  ScrollBox.BorderStyle:=bsNone;
  ScrollBox.Color:=clWhite;
  ScrollBox.VertScrollBar.Tracking:=True;
  ScrollBox.VertScrollBar.Size:=14;
  ScrollBox.HorzScrollBar.Tracking:=True;
  ScrollBox.HorzScrollBar.Size:=14;
  ScrollBox.Enabled := False;
end;

destructor TDragScrollPanel.Destroy;
begin
  ScrollBox.Free;
  inherited;
end;

procedure TDragScrollPanel.CMMouseLeave(var Message: TMessage);
begin
  ScrollBox.Enabled:=False;
  inherited;
end;

procedure TDragScrollPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin

  if ssLeft in Shift then begin

    if (MousePrevious.x<>Mouse.CursorPos.x) or (MousePrevious.y<>Mouse.CursorPos.y) then begin
      if ImageViewConfig.ScrollOpposite then begin
        ScrollBox.HorzScrollBar.Position:=HBarOrigin + (Mouse.CursorPos.x - MouseOrigine.x)*ScrollBox.HorzScrollBar.Range div ScrollBox.ClientWidth;
        ScrollBox.VertScrollBar.Position:=VBarOrigin + (Mouse.CursorPos.y - MouseOrigine.y)*ScrollBox.VertScrollBar.Range div ScrollBox.ClientHeight;
      end else begin
        ScrollBox.HorzScrollBar.Position:=HBarOrigin - (Mouse.CursorPos.x - MouseOrigine.x);
        ScrollBox.VertScrollBar.Position:=VBarOrigin - (Mouse.CursorPos.y - MouseOrigine.y);
      end;
      MousePrevious:=Mouse.CursorPos;
    end;
  end else begin
    Point := ScrollBox.ScreenToClient(Mouse.CursorPos);
    if PtInRect(ScrollBox.ClientRect,Point) then
      ScrollBox.enabled:=False
    else if PtInRect(ScrollBox.BoundsRect,Point) then
      ScrollBox.enabled:=True
    else
      ScrollBox.enabled:=False;
  end;
end;

procedure TDragScrollPanel.ScrollBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  MouseMove(Shift,X,Y);
end;

procedure TDragScrollPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  if (Button=mbLeft) and ((ScrollBox.VertScrollBar.Range>ScrollBox.ClientHeight)
                              or (ScrollBox.HorzScrollBar.Range>ScrollBox.ClientWidth)) then begin
    MouseOrigine:=Mouse.CursorPos;
    HBarOrigin:=ScrollBox.HorzScrollBar.Position;
    VBarOrigin:=ScrollBox.VertScrollBar.Position;
    Screen.Cursor:=crSizeAll;
  end;
  inherited;
end;

procedure TDragScrollPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor:=crDefault;
  inherited;
end;


{ TCustomImageView }

//生成
constructor TCustomImageView.Create(AOwner:TWinControl);
begin
  inherited Create;

  FOwner:=AOwner;
  FAdjustToWindow:=ImageViewConfig.AdjustToWindow;

  Panel:=TDragScrollPanel.Create(AOwner);
  Panel.Parent:=AOwner;
  Panel.align:=alClient;
  Panel.BorderStyle:=bsNone;
  Panel.ScrollBox.Color:=clWhite;

end;


//破棄
destructor TCustomImageView.Destroy;
begin

  Mosaic.Free;
  if Assigned(PaintBox) then begin
    PaintBox.Hide;
    PaintBox.Free;
  end;
  Panel.Free;

  FSmallBitmap.Free;
  Bitmap.Free;
  FImageList.Free;
  FDelayTimeList.Free;

  inherited Destroy;
end;


//画像のスクロール
procedure TCustomImageView.Scroll(const x,y:Integer);
begin
  with panel.ScrollBox do begin
    if x>0 then HorzScrollBar.Position:=HorzScrollBar.Position+(ClientWidth div 5);
    if x<0 then HorzScrollBar.Position:=HorzScrollBar.Position-(ClientWidth div 5);
    if y>0 then VertScrollBar.Position:=VertScrollBar.Position+(ClientHeight div 5);
    if y<0 then VertScrollBar.Position:=VertScrollBar.Position-(ClientHeight div 5);
  end;
end;



//画像を表示／隠す／止める(上位クラスで使用)
procedure TCustomImageView.Action;
begin
  ;
end;
procedure TCustomImageView.Hide;
begin
  ;
end;
procedure TCustomImageView.Halt;
begin
  ;
end;
procedure TCustomImageView.Highlight;
begin
  ;
end;
procedure TCustomImageView.TerminateHighlight;
begin
  ;
end;


//プロパティ関係
function TCustomImageView.GetSmallBitmap:TBitmap;
begin
  Result:=FSmallBitmap;
end;
function TCustomImageView.GetBitmap:TBitmap;
begin
  if Protect and Assigned(Mosaic) then
    Result:=Mosaic
  else
    Result:=Bitmap;
end;
function TCustomImageView.GetInfo:string;
begin
  Result:=FInfo;
end;
procedure TCustomImageView.SetInfo(AInfo:string);
begin
  FInfo:=AInfo;
end;
function TCustomImageView.GetOnComplete:TContentViewCompleteEvent;
begin
  Result:=FOnComplete;
end;
procedure TCustomImageView.SetOnComplete(AOnComplete:TContentViewCompleteEvent);
begin
  FOnComplete:=AOnComplete;
end;
function TCustomImageView.GetAdjustToWindow:Boolean;
begin
  Result:=FAdjustToWindow;
end;
function TCustomImageView.GetOnEdge:TPageControlOnEdgeEvent;
begin
  Result:=FOnEdge;
end;
procedure TCustomImageView.SetOnEdge(Value: TPageControlOnEdgeEvent);
begin
  FOnEdge:=Value;
end;
function TCustomImageView.GetOnSelectionTerminate:TNotifyEvent;
begin
  Result:=FOnSelectionTerminate;
end;
procedure TCustomImageView.SetOnSelectionTerminate(Value: TNotifyEvent);
begin
  FOnSelectionTerminate:=Value;
end;
function TCustomImageView.GetOnContentClose:TNotifyEvent;
begin
  Result:=FOnContentClose;
end;
procedure TCustomImageView.SetOnContentClose(Value: TNotifyEvent);
begin
 FOnContentClose:=Value;
end;
procedure TCustomImageView.SetAdjustToWindow(AAdjustToWindow:Boolean);
begin
  FAdjustToWindow:=AAdjustToWindow;
  if FAdjustToWindow then begin
    PaintBox.Adjust:=ajBitmapResize;
    PaintBox.Align:=alClient;
  end else begin
    PaintBox.Align:=alNone;
    PaintBox.Adjust:=ajFieldResize;
  end;
end;
function TCustomImageView.GetOriginalSize:TPoint;
begin
  Result.X:=0;
  Result.Y:=0;
  if Assigned(Bitmap) then begin
    Result.X:=Bitmap.Width;
    Result.Y:=Bitmap.Height;
  end;
end;

function TCustomImageView.GetScale:Integer;
begin
  Result:=100;
  if Assigned(PaintBox) then Result:=PaintBox.Scale;
end;

function TCustomImageView.GetOnMouseDown:TMouseEvent;
begin
  Result:=Panel.OnMouseDown;
end;

procedure TCustomImageView.SetOnMouseDown(AOnMouseDown:TMouseEvent);
begin
  if Assigned(Panel) then Panel.OnMouseDown:=AOnMouseDown;
  if Assigned(PaintBox) then PaintBox.OnMouseDown:=AOnMouseDown;//一応
end;

function TCustomImageView.GetOnMouseUp:TMouseEvent;
begin
  Result:=Panel.OnMouseUp;
end;

procedure TCustomImageView.SetOnMouseUp(AOnMouseUp:TMouseEvent);
begin
  if Assigned(Panel) then Panel.OnMouseUp:=AOnMouseUp;
  if Assigned(PaintBox) then PaintBox.OnMouseUp:=AOnMouseUp;//一応
end;


//画像表示（モザイク処理など）
function TCustomImageView.GetProtect:Boolean;
begin
  Result:=FProtect;
end;
procedure TCustomImageView.SetProtect(AProtect:boolean);
var
  tmpImage:TBitmap;
begin
  FProtect:=AProtect;

  if not(Assigned(Bitmap)) or not(Assigned(Bitmap)) then Exit;

  FreeAndNil(Mosaic);

  if FProtect then begin
    tmpImage:=TBitmap.Create;
    tmpImage.Width:=Bitmap.Width div ImageViewConfig.ProtectMosaicSize;
    tmpImage.Height:=Bitmap.Height div ImageViewConfig.ProtectMosaicSize;
    if ImageViewConfig.ShrinkType=stHighQuality then begin
      SetStretchBltMode(tmpImage.Canvas.Handle,HALFTONE);
      SetBrushOrgEx(tmpImage.Canvas.Handle, 0, 0, nil);
    end else begin
      SetStretchBltMode(tmpImage.Canvas.Handle,COLORONCOLOR);
    end;
    tmpImage.Canvas.CopyRect(Rect(0,0,tmpImage.Width,tmpImage.Height),
                   Bitmap.Canvas,Rect(0,0,Bitmap.Width,Bitmap.Height));


    Mosaic:=TBitmap.Create;
    Mosaic.Width:=Bitmap.Width;
    Mosaic.Height:=Bitmap.Height;
    SetStretchBltMode(Mosaic.Canvas.Handle,COLORONCOLOR);
    Mosaic.Canvas.CopyRect(Rect(0,0,Mosaic.Width,Mosaic.Height),
                   tmpImage.Canvas,Rect(0,0,tmpImage.Width,tmpImage.Height));

    TAnimatedPaintBox(PaintBox).Bitmap:=Mosaic;
    tmpImage.Free;

  end else begin
    if Assigned(FImageList) then begin
      PaintBox.SetImageList(FImageList,FDelayTimeList);
      PaintBox.LoopLimit:=FLoopLimit;
      Action;
    end else
      TAnimatedPaintBox(PaintBox).Bitmap:=Bitmap;
  end;
end;


//縮小アイコンの作成（タブとモザイクで使用）
procedure TCustomImageView.MakeSmallImage;
var
  SmallImageWidth,SmallImageHeight:Integer;
begin
  if not Assigned(Bitmap) or (Bitmap.Width<=0) or (Bitmap.Height<=0) then Exit;

  if (BitMap.Height * ImageTabWidth) > (BitMap.Width*ImageTabHeight) then begin
    SmallImageWidth:=(ImageTabHeight*BitMap.Width) div BitMap.Height;
    SmallImageHeight:=ImageTabHeight;
  end else begin
    SmallImageWidth:=ImageTabWidth;
    SmallImageHeight:=(ImageTabWidth*BitMap.Height) div BitMap.Width;
  end;

  FSmallBitmap:=TBitmap.Create;
  FSmallBitmap.Width:=SmallImageWidth;
  FSmallBitmap.Height:=SmallImageHeight;
  if ImageViewConfig.ShrinkType=stHighQuality then begin
    SetStretchBltMode(FSmallBitmap.Canvas.Handle,HALFTONE);
    SetBrushOrgEx(FSmallBitmap.Canvas.Handle, 0, 0, nil);
  end else begin
    SetStretchBltMode(FSmallBitmap.Canvas.Handle,COLORONCOLOR);
  end;
  FSmallBitmap.Canvas.CopyRect(Rect(0,0,SmallImageWidth,SmallImageHeight),
             BitMap.Canvas,Rect(0,0,BitMap.Width,BitMap.Height));
end;


//時間がかかるタスクの途中でキャンセルのリクエスト
procedure TCustomImageView.RequestCancel;
begin
  ;
end;

{ TImageView }

destructor TImageView.Destroy;
begin
  GifData.Free;
  inherited;
end;

const
  PngHeader: Array[0..7] of Char = (#137, 'P', 'N', 'G', #13, #10, #26, #10);

//データの取り込み、必要に応じてデコードスレッド起動
procedure TImageView.AssignData(AData:TStringStream);
var
  ImageConv:TGraphic;
  HeaderPointer: PChar;
begin

  if AData.Size = 0 then begin
    Log('Null Data');
    if Assigned(FOnComplete) then FOnComplete(Self, True);
    Exit;
  end;
  FData := AData;

  if not Assigned(PaintBox) then begin
    PaintBox:=TAnimatedPaintBox.Create(Panel.ScrollBox);
    PaintBox.Bitmap:=nil;
    PaintBox.Parent:=Panel.ScrollBox;
    PaintBox.Enabled:=False;
    PaintBox.Align:=alClient;
    TAnimatedPaintBox(PaintBox).ShrinkType:=ImageViewConfig.ShrinkType;
    SetAdjustToWindow(FAdjustToWindow);
  end;

  if SeekSkipMacBin(FData) then
    HeaderPointer := Pchar(FData.Datastring) + 128
  else
    HeaderPointer := Pchar(FData.Datastring);

  if not Assigned(Bitmap) then Bitmap:=TBitmap.Create;

  ImageConv:=nil;
  if (StrLComp(HeaderPointer,'GIF',3)=0) and (AnsiPos('gif;',LowerCase(GraphicFileMask(TGraphic))) > 0) then begin

    FImageList:=TBitmapList.Create;
    FImageList.ShareImage:=False;
    FDelayTimeList:=TCardinalList.Create;

    GifData := TGifData.Create;
    GifData.Data := FData.ReadString(High(Integer));
    GifData.MakeImageList(FImageList, FDelayTimeList, GifDataOnComplete);

  end else begin

    if (StrLComp(HeaderPointer, #$FF#$D8#$FF#$E0#$00#$10'JFIF', 10)=0)
       or (StrLComp(HeaderPointer, #$FF#$D8#$FF#$E1,4) = 0) {or SameText(ExtractFileExt(FInfo), '.jpg')} then
      //ImageConv:=TJPEGImage.Create
      ImageConv := TApiBitmap.Create
    else if (StrLComp(HeaderPointer, PngHeader, 8)=0)  {SameText(ExtractFileExt(FInfo), '.png')} then
      (* pngの展開にPNGImageを使う (aiai) *)
      ImageConv := TPNGObject.Create
    else
      ImageConv:=TSPIBitmap.Create;

    try
      try
        ImageConv.LoadFromStream(FData);
        Bitmap.Assign(ImageConv);
        MakeSmallImage;
        SetProtect(FProtect);
        if Assigned(FOnComplete) then FOnComplete(Self, False);
      finally
        FreeAndNil(ImageConv);
      end;
    except
      on e:Exception do begin
        Log(e.Message);
        PaintBox.Bitmap:=nil;
        FreeAndNil(Bitmap);//エラーの時はビットマップを解放
        if Assigned(FOnComplete) then FOnComplete(Self, True);
      end;
    end;
  end;
end;


//GIFデータのデコード処理完了
procedure TImageView.GifDataOnComplete(Sender:TObject);
var
  i: Integer;
  MaxDelay: Cardinal;
begin
  if GifData.ErrorText<>'' then begin
    FreeAndNil(FImageList);
    FreeAndNil(FDelayTimeList);
    Bitmap:=nil;
    Log(GifData.ErrorText);
    if Assigned(FOnComplete) then FOnComplete(Self,True);
  end else begin
    FLoopLimit:=GifData.LoopCount;

    if FDelayTimeList.Count > 1 then begin
      MaxDelay := 0;
      for i := 0 to FDelayTimeList.Count -1 do
        if FDelayTimeList[i] > MaxDelay then
          MaxDelay := FDelayTimeList[i];

      if MaxDelay = 0 then
        for i := 0 to FDelayTimeList.Count -1 do
          FDelayTimeList[i] := 10;
    end;

    Bitmap.Assign(FImageList[0]);
    MakeSmallImage;
    SetProtect(FProtect);
    if Assigned(FOnComplete) then FOnComplete(Self,False);
  end;
  FreeAndNil(GifData);//イベントハンドラ中での自殺
end;


//アニメーションを再生／停止
procedure TImageView.Action;
begin
  if assigned(PaintBox) then begin
    PaintBox.Visible:=True;
    PaintBox.BeginAnimation;
  end;
  inherited;
end;
procedure TImageView.Halt;
begin
  if assigned(PaintBox) then
    PaintBox.EndAnimation;
  inherited;
end;

end.
