unit UPopUpTextView;
(* Copyright (c) 2004 View◆tCDoSWbtb. *)

// ポップアップするHogeTextView

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, HogeTextView;

type

  TQueryContextEvent = procedure(Sender: TObject; var CanContext: Boolean) of object;

  TPopUpTextView = class(THogeTextView)
  protected
    FColorDisable: TColor;
    FColorEnable: TColor;
    FClickPos: TPoint;
    FPrevTop: Integer;
    FPrevLeft: Integer;
    FDragMoving: Boolean;
    FOnQueryContext: TQueryContextEvent;
    FOnEndContext: TNotifyEvent;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure ON_WM_CREATE(var msg: TMsg); message WM_CREATE;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure PaintWindow(DC: HDC); override;
    function GetEnabled: Boolean; reintroduce;
    procedure SetEnabled(Value: Boolean); reintroduce;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function QueryContext: Boolean;
    procedure EndContext;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PopUp(Rect: TRect);
    function CalcAdjstableSize(MaxHeight, MaxWidth: Integer): TRect;
    function Trim: Boolean;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property ColorDisable: TColor read FColorDisable write FColorDisable;
    property ColorEnable: TColor read FColorEnable write FColorEnable;
    property OnQueryContext: TQueryContextEvent read FOnQueryContext write FOnQueryContext;
    property OnEndContext: TNotifyEvent read FOnEndContext write FOnEndContext;
  end;

implementation

uses Types;

{ TPopUpTextView }

constructor TPopUpTextView.Create(AOwner: TComponent);
begin
  inherited;
  inherited Enabled := False;
  Width := 20;
  Height := 20;
  BorderWidth := 2;
  FDragMoving := False;
  Hide;
end;


//パラメータ設定：最前面、背景再描画のちらつき抑制
procedure TPopUpTextView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
  Params.WindowClass.style := Params.WindowClass.style or CS_SAVEBITS;
end;


//デフォルトの枠とスクロールバーを描かないようにオーバーライド
procedure TPopUpTextView.ON_WM_CREATE(var msg: TMsg);
begin
  FEditPoint.X := 0;
  FEditPoint.Y := 0;
  FLogicalCaret.X := 0;
  FLogicalCaret.Y := 0;
  FCaretSavedX := 0;
end;


//メインウィンドウからフォーカスを奪わないように設定
procedure TPopUpTextView.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;


//コンテキストメニューに関するイベント
procedure TPopUpTextView.WMContextMenu(var Message: TWMContextMenu);
begin
  if QueryContext then
  begin
    inherited;
    EndContext;
  end;
end;

function TPopUpTextView.QueryContext: Boolean;
begin
  Result := True;
  if Assigned(FOnQueryContext) then
    FOnQueryContext(Self, Result);
end;

procedure TPopUpTextView.EndContext;
begin
  if Assigned(FOnEndContext) then
    FOnEndContext(Self);
end;


//THintWindowに似せた枠を描く
procedure TPopUpTextView.PaintWindow(DC: HDC);
var
  DCE: HDC;
  HBR: HBRUSH;
  R: TRect;
  R2:TRect;
begin
  R := Rect(0, 0, Width, Height);
  R2 := Rect(1, 1, Width - 1, Height - 1);
  DCE := GetWindowDC(Handle);
  try
    HBR := CreateSolidBrush(ColorToRGB(Color));
    ExcludeClipRect(DCE, BorderWidth, BorderWidth, Width - BorderWidth, Height - BorderWidth);
    FillRect(DCE, R2, HBR);
    DrawEdge(DCE, R, BDR_RAISEDOUTER, BF_RECT);
    DeleteObject(HBR);
    inherited PaintWindow(DC);
  finally
    ReleaseDC(Handle, DCE);
  end;
end;


procedure TPopUpTextView.PopUp(Rect: TRect);
begin
  BoundsRect := Rect;
  Show;
end;


//きっちり内容を収めて表示できる寸法を返す
function TPopUpTextView.CalcAdjstableSize(MaxHeight, MaxWidth: Integer): TRect;
var
  i, j: Integer;
  LineBreak, LineWidth, WMax, MarginWidth: Integer;
  attrib, cw: AnsiString;
begin

  LineBreak := FStrings.Count;
  MarginWidth := FLeftMargin + FRightMargin + BorderWidth * 2 + 0;
  WMax := MarginWidth;
  FBitmap.Canvas.Font := Font;

  for i := 0 to FStrings.Count - 1 do
  begin
    cw := FStrings[i].GetWidthInfo;
    attrib := FStrings[i].FAttrib;
    LineWidth := MarginWidth + FStrings[i].OffsetLeft;

    for j := 1 to Length(cw) do begin
      if Ord(attrib[j]) and htvVMASK = htvVISIBLE then
      begin
        if Ord(cw[j]) + LineWidth >= MaxWidth then
        begin
          Inc(LineBreak);
          if LineWidth > WMax then WMax := LineWidth;
          LineWidth := MarginWidth + FStrings[i].OffsetLeft + Ord(cw[j]);
        end else
          Inc(LineWidth, Ord(cw[j]));
      end;
    end;
    if LineWidth > WMax then WMax := LineWidth;
  end;

  Result.Top := 0;
  Result.Left := 0;
  Result.Bottom := BaselineSkip * LineBreak + TopMargin * 2 + BorderWidth * 2;
  if Result.Bottom > MaxHeight then
  begin
    Result.Bottom := MaxHeight;
    Result.Right := WMax + GetSystemMetrics(SM_CXVSCROLL) + 2;
    if Result.Right > MaxWidth then
      Result.Right := MaxWidth;
  end else
    Result.Right := WMax;
end;


//末尾の空白行を削除
function TPopUpTextView.Trim: Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := FStrings.Count - 1 downto 0 do
  begin
    if Length(FStrings[i].FText) > 0 then
      Break;
    if i = 0 then
    begin
      Result := False;
      Break;
    end;
    FStrings[i].Free;
    FStrings.Delete(i);
  end;

  if Result then
    Refresh;
end;


//プロパティ関係
function TPopUpTextView.GetEnabled: Boolean;
begin
  Result := inherited Enabled;
end;


procedure TPopUpTextView.SetEnabled(Value: Boolean);
begin
  inherited Enabled := Value;
  if Enabled then
    Color := ColorEnable
  else
    Color := ColorDisable;
end;

procedure TPopUpTextView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssCtrl in Shift) then
  begin
    FDragMoving := True;
    FClickPos := ClientToScreen(Point(X, Y));
    FPrevLeft := Left;
    FPrevTop := Top;
  end;
  inherited;
end;

procedure TPopUpTextView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDragMoving := False;
  inherited;
end;

procedure TPopUpTextView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  CurrentPos: TPoint;
begin
  CurrentPos := ClientToScreen(Point(X, Y));
  if FDragMoving then
  begin
    Top := FPrevTop + (CurrentPos.Y - FClickPos.Y);
    Left := FPrevLeft + (CurrentPos.X - FClickPos.X);
  end;
  inherited;
end;

end.
