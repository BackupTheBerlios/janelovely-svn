unit JLXPComCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, JLTmschema,
  JLUxtheme, StdCtrls;

type

  { TJLXPToolBar }

  TJLXPToolBar = class(TToolBar)
  protected
    procedure WndProc(var Message: TMessage); override;
  end;


  { TJLXPStatusBar }

  TJLXPStatusBar = class(TStatusBar)
  private
    FThemeHandle: THandle;
    procedure WMThemeChanged(var Msg: TMessage); message WM_THEMECHANGED;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  
  { TJLXPTabSheet }

  TJLXPTabSheet = class(TTabSheet)
  private
    FThemeHandle: THandle;
    procedure WMThemeChanged(var Msg: TMessage); message WM_THEMECHANGED;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMCtlColorStatic(var Message: TWMCtlColorStatic); message WM_CTLCOLORSTATIC;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure Register;

implementation



procedure Register;
begin
  RegisterComponents('JaneLovely', [TJLXPStatusBar]);
  RegisterComponents('JaneLovely', [TJLXPToolBar]);
  RegisterComponents('JaneLovely', [TJLXPTabSheet]);
end;




 { TJLXPToolBar }

procedure TJLXPToolBar.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_USER + $0500 then
    exit;
  inherited WndProc(Message);
end;


{ TJLXPStatusBar }

constructor TJLXPStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FThemeHandle := 0;
  ControlStyle := ControlStyle - [csDoubleClicks];
end;

destructor TJLXPStatusBar.Destroy;
begin
  if OKLuna and (FThemeHandle <> 0) then
  begin
    CloseThemeData(FThemeHandle);
    FThemeHandle := 0;
  end;
  inherited Destroy;
end;

procedure TJLXPStatusBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
	if OKLuna and IsThemeActive and IsAppThemed
      and not (csDesigning in ComponentState) then
  begin
    Params.WindowClass.style := Params.WindowClass.style or CS_HREDRAW;
  end;
end;

procedure TJLXPStatusBar.CreateWnd;
begin
  inherited CreateWnd;
  if OKLuna then
    FThemeHandle := OpenThemeData(Handle, 'status');
end;

procedure TJLXPStatusBar.DestroyWnd;
begin
  if OKLuna and (FThemeHandle <> 0) then
  begin
    CloseThemeData(FThemeHandle);
    FThemeHandle := 0;
  end;
  inherited DestroyWnd;
end;

procedure TJLXPStatusBar.WMThemeChanged(var Msg: TMessage);
begin
  DefaultHandler(Msg);
  if OKLuna then
  begin
    if FThemeHandle <> 0 then
      CloseThemeData(FThemeHandle);
    FThemeHandle := OpenThemeData(Handle, 'status');
  end;
end;


procedure TJLXPStatusBar.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
var
  hr: HRESULT;
  rc: TRect;
begin
  if OKLuna and IsThemeActive and IsAppThemed and (FThemeHandle <> 0)
    and not (csDesigning in ComponentState) then
  begin
    rc := ClientRect;
    hr := DrawThemeBackground(FThemeHandle, Msg.DC, 0, 0, @rc, nil);
    if hr = S_OK then
    begin
      Msg.Result := 1;
      exit;
    end;
  end;

  inherited;
end;




 { TJLXPTabSheet }

constructor TJLXPTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FThemeHandle := 0;
end;

destructor TJLXPTabSheet.Destroy;
begin
  if OKLuna and (FThemeHandle <> 0) then
  begin
    CloseThemeData(FThemeHandle);
    FThemeHandle := 0;
  end;
  inherited Destroy;
end;

procedure TJLXPTabSheet.CreateWnd;
begin
  inherited CreateWnd;
  if OKLuna then
    FThemeHandle := OpenThemeData(Handle, 'tab');
end;

procedure TJLXPTabSheet.DestroyWnd;
begin
  if OKLuna and (FThemeHandle <> 0) then
  begin
    CloseThemeData(FThemeHandle);
    FThemeHandle := 0;
  end;
  inherited DestroyWnd;
end;

procedure TJLXPTabSheet.WMThemeChanged(var Msg: TMessage);
begin
  DefaultHandler(Msg);
  if OKLuna then
  begin
    if FThemeHandle <> 0 then
      CloseThemeData(FThemeHandle);
    FThemeHandle := OpenThemeData(Handle, 'tab');
  end;
end;

procedure TJLXPTabSheet.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  hr: HRESULT;
  rc: TRect;
begin
  if OKLuna and IsThemeActive and IsAppThemed and (FThemeHandle <> 0)
    and not (csDesigning in ComponentState)
    and not FDoubleBuffered and (Message.DC <> 0) then
  begin
    rc := ClientRect;
    hr := DrawThemeBackground(FThemeHandle, Message.DC, TABP_BODY, 0, @rc, nil);
    if hr = S_OK then
    begin
      Message.Result := 1;
      exit;
    end;
  end;

  inherited;
end;

procedure TJLXPTabSheet.WMCtlColorStatic(var Message: TWMCtlColorStatic);
var
//  hr: HRESULT;
  Control: TWinControl;
begin
  if OKLuna and IsThemeActive and IsAppThemed and (FThemeHandle <> 0)
    and not (csDesigning in ComponentState) and HandleAllocated then
  With Message do
    begin
      Control := FindControl(ChildWnd);
      if (Control <> nil) and
        ((Control is TCustomCheckBox) or
         (Control is TCustomGroupBox)) then
      begin
        DrawThemeParentBackGround(ChildWnd, ChildDC, nil);
        Result := GetStockObject(NULL_BRUSH);
        exit;
//        hr := DrawThemeParentBackGround(ChildWnd, ChildDC, nil);
//        if hr = S_OK then
//        begin
//          Result := GetStockObject(NULL_BRUSH);
//          exit;
//        end;
      end;
    end;

  inherited;
end;

end.
