unit JLXPExtCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, ExtCtrls,
  JLTmschema, JLUxtheme;

type
  TJLXPRadioGroup = class(TRadioGroup)
  private
    FThemeHandle: THandle;
    procedure WMThemeChanged(var Msg: TMessage); message WM_THEMECHANGED;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DefaultHandler(var Message); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JaneLovely', [TJLXPRadioGroup]);
end;

 { TJLXPRadioGroup }

constructor TJLXPRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FThemeHandle := 0;
end;

destructor TJLXPRadioGroup.Destroy;
begin
  if OKLuna and (FThemeHandle <> 0) then
  begin
    CloseThemeData(FThemeHandle);
    FThemeHandle := 0;
  end;
  inherited Destroy;
end;

procedure TJLXPRadioGroup.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
	if OKLuna and IsThemeActive and IsAppThemed
      and not (csDesigning in ComponentState) then
  begin
    Params.WindowClass.style := Params.WindowClass.style or CS_HREDRAW;
  end;
end;

procedure TJLXPRadioGroup.CreateWnd;
begin
  inherited CreateWnd;
  if OKLuna then
    FThemeHandle := OpenThemeData(Handle, 'Button');
end;

procedure TJLXPRadioGroup.DestroyWnd;
begin
  if OKLuna and (FThemeHandle <> 0) then
  begin
    CloseThemeData(FThemeHandle);
    FThemeHandle := 0;
  end;
  inherited DestroyWnd;
end;

procedure TJLXPRadioGroup.WMThemeChanged(var Msg: TMessage);
begin
  DefaultHandler(Msg);
  if OKLuna then
  begin
    if FThemeHandle <> 0 then
      CloseThemeData(FThemeHandle);
    FThemeHandle := OpenThemeData(Handle, 'Button');
  end;
end;


procedure TJLXPRadioGroup.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  hb: HBRUSH;
  rc: TRect;
begin
  if OKLuna and IsThemeActive and IsAppThemed and (FThemeHandle <> 0)
    and not (csDesigning in ComponentState) and not FDoubleBuffered
    and (Message.DC <> 0) then
  begin
    rc := ClientRect;
    hb := SendMessage(Parent.Handle, WM_CTLCOLORSTATIC, Message.DC, Handle);
    FillRect(Message.DC, rc, hb);
    Message.Result := 1;
    exit;
  end;

  inherited;
end;

procedure TJLXPRadioGroup.Paint;
const
  LEFTMARGIN = 8;
var
  RC, TR: TRect;
  WS, WA: WideString;
  CH, SaveIndex: Integer;
begin
  if OKLuna and IsThemeActive and IsAppThemed and (FThemeHandle <> 0)
    and not (csDesigning in ComponentState) then
  begin

    WA := WideString('A');
    GetThemeTextExtent(FThemeHandle, Canvas.Handle, BP_GROUPBOX, GBS_NORMAL,
      PWChar(WA), -1, DT_CENTER or DT_SINGLELINE, nil, @TR);
    CH := TR.Bottom;

    WS := WideString(Caption);
    GetThemeTextExtent(FThemeHandle, Canvas.Handle, BP_GROUPBOX, GBS_NORMAL,
      PWChar(WS), -1, DT_CENTER or DT_SINGLELINE, nil, @TR);

    RC := ClientRect;
    RC.Top := CH div 2;
    TR.Left := TR.Left + LEFTMARGIN;
    TR.Right := TR.Right + LEFTMARGIN;

    SaveIndex := SaveDC(Canvas.Handle);
     ExcludeClipRect(Canvas.Handle, TR.Left, TR.Top, TR.Right, TR.Bottom);
     DrawThemeBackground(FThemeHandle, Canvas.Handle, BP_GROUPBOX, GBS_NORMAL, @RC, nil);
    RestoreDC(Canvas.Handle, SaveIndex);

    DrawThemeText(FThemeHandle, Canvas.Handle, BP_GROUPBOX, GBS_NORMAL, PWChar(WS),
      -1, DT_CENTER or DT_SINGLELINE, 0, @TR);
    exit;

  end;

  inherited Paint;
end;

procedure TJLXPRadioGroup.DefaultHandler(var Message);
//var
//  hr: HRESULT
begin
  if OKLuna and IsThemeActive and IsAppThemed and (FThemeHandle <> 0)
    and not (csDesigning in ComponentState) and HandleAllocated then
  With TMessage(Message) do
  begin
    Case Msg of
      WM_CTLCOLORBTN, WM_CTLCOLORSTATIC: begin
        //hr := DrawThemeParentBackGround(lParam, wParam, nil);
        //if hr = S_OK then
        //begin
        //  Result := GetStockObject(NULL_BRUSH);
        //  exit;
        //end;
        {hr = False Ç…Ç»ÇÈÇØÇ«OKÇ¡Ç€Ç¢ÅH}
        DrawThemeParentBackGround(HWND(lParam), HDC(wParam), nil);
        Result := GetStockObject(NULL_BRUSH);
        exit;
      end;
    end; //Case
  end;
  inherited DefaultHandler(Message);
end;

end.
