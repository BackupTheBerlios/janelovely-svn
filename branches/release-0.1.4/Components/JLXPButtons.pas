unit JLXPButtons;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Buttons, Graphics,
  JLTmschema, JLUxtheme;

type
  TJLXPSpeedButton = class(TSpeedButton)
  private
    FThemeHandle: THandle;
    FMouseEntered: Boolean;
    procedure WMThemeChanged(var Msg: TMessage); message WM_THEMECHANGED;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMMouseEnter(var Message: TWMMouse); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TWMMouse); message CM_MOUSELEAVE;
  protected
    procedure MouseUp(Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JaneLovely', [TJLXPSpeedButton]);
end;


 { TJLXPSpeedButton }

constructor TJLXPSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMouseEntered := False;
  if OkLuna then
    FThemeHandle := OpenThemeData(0, 'Button')
  else
    FThemeHandle := 0;
end;

destructor TJLXPSpeedButton.Destroy;
begin
  if OKLuna and (FThemeHandle <> 0) then
  begin
    CloseThemeData(FThemeHandle);
    FThemeHandle := 0;
  end;
  inherited Destroy;
end;

procedure TJLXPSpeedButton.WMThemeChanged(var Msg: TMessage);
begin
  DefaultHandler(Msg);
  if OKLuna then
  begin
    if FThemeHandle <> 0 then
      CloseThemeData(FThemeHandle);
    FThemeHandle := OpenThemeData(0, 'status')
  end;
end;

procedure TJLXPSpeedButton.WMPaint(var Message: TWMPaint);
var
  CR: TRect;
  hr: HRESULT;
  GlyphPos: TPoint;
  GlyphWidth: Integer;
  GlyphMask: TBitmap;
  GlyphSourceX: Integer;
  S: WideString;
begin
  if not OKLuna or (FThemeHandle = 0) or not IsThemeActive
    or not IsAppThemed or (csDesigning in ComponentState) then
  begin
    inherited;
    exit;
  end;

  CR := ClientRect;

  Canvas.FillRect(CR);

  if FState = bsDown then begin
    hr := DrawThemeBackground(FThemeHandle, Canvas.Handle,
      BP_PUSHBUTTON, PBS_PRESSED, @CR, nil);
  end else if FState = bsExclusive then begin
    hr := DrawThemeBackground(FThemeHandle, Canvas.Handle,
      BP_PUSHBUTTON, PBS_NORMAL, @CR, nil);
  end else if MouseCapture or FMouseEntered then begin
    hr := DrawThemeBackground(FThemeHandle, Canvas.Handle,
      BP_PUSHBUTTON, PBS_HOT, @CR, nil);
  end else
    hr := DrawThemeBackground(FThemeHandle, Canvas.Handle,
      BP_PUSHBUTTON, PBS_NORMAL, @CR, nil);

  if hr <> S_OK then
  begin
    inherited;
    exit;
  end;

  With Glyph do
  begin
    if not Empty then
    begin
    GlyphWidth := Glyph.Width div NumGlyphs;
    GlyphSourceX := 0;
    GlyphPos.X := (Self.Width - GlyphWidth) div 2;
    GlyphPos.Y := (Self.Height - Height) div 2;
    if not Enabled and (NumGlyphs > 1) then
      GlyphSourceX := GlyphWidth
    else
      case FState of
        bsDown:
          if NumGlyphs > 2 then
            GlyphSourceX := 2 * GlyphWidth;
        bsExclusive: 
          if NumGlyphs > 3 then
            GlyphSourceX := 3 * GlyphWidth;
      end;
    GlyphMask := TBitmap.Create;
    GlyphMask.Assign(Glyph);
    GlyphMask.Mask(Glyph.TransparentColor);
    TransparentStretchBlt(Self.Canvas.Handle, GlyphPos.X, GlyphPos.Y, Width, Height,
      Glyph.Canvas.Handle, GlyphSourceX, 0,  GlyphWidth, Glyph.Height,
      GlyphMask.Canvas.Handle, GlyphSourceX, 0);
    GlyphMask.Free;
    exit;
    end;
  end;

  if Caption <> '' then
  begin
    S := WideString(Caption);
    hr := DrawThemeText(FThemeHandle, Canvas.Handle,
      BP_PUSHBUTTON, PBS_NORMAL, PWChar(S), -1,
      DT_CENTER or DT_VCENTER or DT_SINGLELINE, 0, @CR);
    if hr <> S_OK then
    begin
      inherited;
      exit;
    end;
  end;
end;

procedure TJLXPSpeedButton.CMMouseEnter(var Message: TWMMouse);
begin
  if OKLuna and (FThemeHandle <> 0) and IsThemeActive
    and IsAppThemed and not (csDesigning in ComponentState) then
  begin
    FMouseEntered := True;
    if not MouseCapture then
      Invalidate;
  end;
  inherited;
end;

procedure TJLXPSpeedButton.CMMouseLeave(var Message: TWMMouse);
begin
  if OKLuna and (FThemeHandle <> 0) and IsThemeActive
    and IsAppThemed and not (csDesigning in ComponentState) then
  begin
    FMouseEntered := False;
    if not MouseCapture then
      Invalidate;
  end;
  inherited;
end;

procedure TJLXPSpeedButton.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if OKLuna and (FThemeHandle <> 0) and IsThemeActive and IsAppThemed
    and not (csDesigning in ComponentState) and (Button = mbLeft) then
    Invalidate;
  inherited;
end;

end.
