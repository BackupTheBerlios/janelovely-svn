unit JLUxtheme;

interface

uses
  Windows, ComCtrls;

type
  HTHEME = THANDLE;

const
  WM_THEMECHANGED   = $031A;
  WM_DRAWPARENTRECT = $1000;



var
  OpenThemeData: function (hwnd: HWND; pszClassList: LPCWSTR): HTHEME; stdcall;
  CloseThemeData: function (hTheme: HTHEME): HRESULT; stdcall;
  DrawThemeBackground: function (hTheme: HTHEME; DC: HDC; iPartId: Integer;
    iStateId: Integer; const Rect: PRect; const pClipRect:  PRect): HRESULT;
    stdcall;
  DrawThemeEdge: function (hTheme: HTHEME; DC: HDC; iPartId: Integer;
    iStateId:  Integer; const Rect: PRect; uEdge: UINT; uFlags: UINT;
    pContentRect: PRect): HRESULT; stdcall;
  DrawThemeParentBackground: function (hwnd: HWND; DC: HDC; RECT: PRECT):
    HRESULT; stdcall;
  DrawThemeText: function (hTheme: HTHEME; hdc: HDC; iPartId: Integer;
    iStateId: Integer;  pszText: LPCWSTR; iCharCount: Integer;
    dwTextFlags: DWORD; dwTextFlag2: DWORD; const Rect: PRect):
    HRESULT; stdcall;
  IsThemeActive : function : Boolean; stdcall;
  GetThemeTextExtent: function (hTheme: HTHEME; DC: HDC; iPartId: Integer;
    iStateId: Integer; pszText: LPCWSTR; iCharCount: Integer;
    dwTextFlags: DWORD;  const pBoundingRect: PRect;  pExtentRect: PRect):
    HRESULT; stdcall;
  IsAppThemed: function :Boolean; stdcall;
  EnableTheming: function (fEnable: BOOL): HRESULT; stdcall;


function OKLuna: Boolean;

implementation

const
  UxthemeDLL        = 'Uxtheme.dll';

var
  Handle: THandle = 0;


function OKLuna: Boolean;
begin
  Result := (Handle <> 0);
end;

const
  ComCtlIEVersion = $00060000;

procedure LoadDLL;
var
  rs:  Boolean;
begin
  if GetComCtlVersion < ComCtlIEVersion then
    exit;

  Handle := LoadLibrary(UxthemeDLL);
  if Handle = 0 then
    exit;

  rs := True;

  @OpenThemeData := GetProcAddress(Handle, 'OpenThemeData');
  if @OpenThemeData = nil then rs := False;
  @CloseThemeData := GetProcAddress(Handle, 'CloseThemeData');
  if @CloseThemeData = nil then rs := False;
  @DrawThemeBackground := GetProcAddress(Handle, 'DrawThemeBackground');
  if @DrawThemeBackground = nil then rs := False;
  @DrawThemeEdge := GetProcAddress(Handle, 'DrawThemeEdge');
  if @DrawThemeEdge = nil then rs := False;
  @DrawThemeParentBackground := GetProcAddress(Handle, 'DrawThemeParentBackground');
  if @DrawThemeParentBackground = nil then rs := False;
  @DrawThemeText := GetProcAddress(Handle, 'DrawThemeText');
  if @DrawThemeText = nil then rs := False;
  @GetThemeTextExtent := GetProcAddress(Handle, 'GetThemeTextExtent');
  if @GetThemeTextExtent = nil then rs := False;
  @IsThemeActive := GetProcAddress(Handle, 'IsThemeActive');
  if @IsThemeActive = nil then rs := False;
  @IsAppThemed := GetProcAddress(Handle, 'IsAppThemed');
  if @IsAppThemed = nil then rs := False;
  @EnableTheming := GetProcAddress(Handle, 'EnableTheming');
  if @EnableTheming = nil then rs := False;

  if not rs then
  begin
    FreeLibrary(Handle);
    Handle := 0;
    exit;
  end;
end;

procedure FreeDLL;
begin
  if Handle <> 0 then
  begin
    FreeLibrary(Handle);
    Handle := 0;
  end;
end;

Initialization
  LoadDLL;

Finalization
  FreeDLL;

end.

