unit UImageHint;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Types, StdCtrls, ExtCtrls, Forms, StrUtils, Menus,
  JConfig, StrSub, UAnimatedPaintBox, UXPHintWindow;

type
  //Bitmapを表示できるヒントポップアップ
  TImageHint = class(TXPHintWindow)
  protected
    FLastURL: String;
  public
    OwnBitmap: TBitmap;
    PaintBox:TAnimatedPaintBox;
    InfoText: TStaticText;
    Info:string;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer);override;
    procedure ReleaseHandle;
    procedure Paint; override;
  end;

implementation

uses
  CommCtrl, Main, UImageViewer;

{ TImageHint }
procedure TImageHint.ActivateHint(Rect: TRect; const AHint: string);
begin
  FLastURL := 'Not ThreadData';
  PaintBox.Bitmap:=nil;
  InfoText.Visible := False;
  Canvas.Font.Assign(Font);
  inherited;
end;

procedure TImageHint.ActivateHintData(Rect: TRect; const AHint: string;
  AData: Pointer);
begin
  inherited;
  FLastURL := 'Not ThreadData';
  if AHint <> '' then
    InfoText.Visible := True
  else
    InfoText.Visible := False;
  InfoText.Font := Font;
  InfoText.Caption := AHint;
  if TObject(AData) is TBitmap then
    PaintBox.Bitmap := TBitmap(AData);
end;

procedure TImageHint.ReleaseHandle;
begin
  PaintBox.Bitmap:=nil;//ID:ie1ZUXSN 2度目の起動以降エラー
  Info:='';

  OwnBitmap.ReleaseHandle;
  inherited;
end;


constructor TImageHint.Create(AOwner: TComponent);
begin
  inherited;
  InfoText := TStaticText.Create(Self);
  InfoText.Parent:=Self;
  InfoText.Align:=alTop;
  InfoText.Visible := False;

  PaintBox:=TAnimatedPaintBox.Create(Self);
  PaintBox.Parent:=Self;
  PaintBox.Align:=alClient;
  PaintBox.Enabled:=False;
  OwnBitmap := TBitmap.Create;
end;

destructor TImageHint.Destroy;
begin
  PaintBox.Free;
  OwnBitmap.Free;
  inherited;
end;

procedure TImageHint.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end;

end.
