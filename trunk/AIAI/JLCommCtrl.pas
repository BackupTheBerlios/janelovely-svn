unit JLCommCtrl;

interface

uses
  Windows, Messages, Classes, JLControls, CommCtrl;


const
  RBBS_USECHEVRON = $00000200;
  RBN_CHEVRONPUSHED = RBN_FIRST - 10;



type
  PNMREBARCHEVRON = ^TNMREBARCHEVRON;
  tagNMREBARCHEVRON = packed record
    hdr: NMHDR;
    uBand: UINT;
    wID: UINT;
    lParam: LPARAM;
    rc: TRECT;
    lParamNM: LPARAM;
  end;
  TNMREBARCHEVRON = tagNMREBARCHEVRON;





  TJLCommControl = class(TJLWinControl)
  protected

    procedure CreateHandle; override;
    procedure CreateWnd; override;
   // procedure CreateParams(var Params: TCreateWinParams); override;
    procedure CreateWindowHandle(const Params: TCreateWinParams); override;

  public

    constructor Create(AParent: HWND);

  end;




  TJLDrawItemEvent = procedure (Sender: TObject; DIS: PDRAWITEMSTRUCT)
    of Object;
  TJLReSizeEvent = procedure (Sender: TObject; Width: Integer) of Object;


  TJLStatusBar = class(TJLCommControl)
  private

    FParts: Byte;
    FPartWidth: array[0..4] of Integer;
    FFontHeight: Integer;
    FOwnerDraw: Boolean;
    FMenuID: Integer;

    FClick: TNotifyEvent;
    FDbClick: TNotifyEvent;
    FRClick: TNotifyEvent;
    FRDbClick: TNotifyEvent;
    FDrawItem: TJLDrawItemEvent;
    FReSize: TJLReSizeEvent;

    procedure SetParts(AParts: Byte);
    function GetParts: Byte;
    procedure SetPartWidth(i: Byte; AWidth: Integer);
    function GetPartWidth(i: Byte): Integer;
    procedure SetText(i: Byte; AText: String);
    function GetText(i: Byte): String;
    procedure SetHeight(AHeight: Integer);
    function GetHeight: Integer;
    function GetRect(i: Byte): TRect;
    procedure SetOwnerDraw(AValue: Boolean);
    function GetOwnerDraw: Boolean;


  protected

    procedure CreateParams(var Params: TCreateWinParams); override;

    procedure WmSize(var Msg: TMessage); message WM_SIZE;
    procedure WmNotify(var Msg: TMessage); message WM_NOTIFY;
    procedure WmDrawItem(var Msg: TWMDrawItem); message WM_DRAWITEM;

    procedure ON_CLICK;
    procedure ON_DBCLICK;
    procedure ON_RCLICK;
    procedure ON_RDBCLICK;
    function ON_DRAWITEM(DIS: PDRAWITEMSTRUCT): Boolean;

  public

    constructor Create(AParent: HWND);
    destructor Destroy; override;

    procedure Invalidate; virtual;

    procedure SetColor(color: Cardinal);

    property Parts: Byte read GetParts write SetParts;
    property PartWidth[i: Byte]: Integer read GetPartWidth write SetPartWidth;
    property Text[i: Byte]: String read GetText write SetText;
    property Height: Integer read GetHeight write SetHeight;
    property Rect[i: Byte]: TRect read GetRect;
    property OwnerDraw: Boolean read GetOwnerDraw write SetOwnerDraw;
    property FontHeight: Integer read FFontHeight;
    property MENUID: Integer read FMenuID;

    property OnClick: TNotifyEvent read FClick write FClick;
    property OnDbClick: TNotifyEvent read FDbClick write FDbClick;
    property OnRClick: TNotifyEvent read FRClick write FRClick;
    property OnRDbClick: TNotifyEvent read FRDbClick write FRDbClick;
    property OnDrawItem: TJLDrawItemEvent read FDrawItem write FDrawItem;
    property OnReSize: TJLReSizeEvent read FReSize write FReSize;

  end;



  TJLToolBar = class(TJLCommControl)
  private

    FMenuID: Integer;

  protected

    procedure CreateParams(var Params: TCreateWinParams); override;

  public

    procedure CreateButton(Text: Pointer; bStyle: Byte; wID: Integer);
  end;





  TJLReBar = class(TJLCommControl)
  private

    FMenuID: Integer;
    //procedure UpdateChevron(hwndChild: HWND);

  protected

    procedure CreateParams(var Params: TCreateWinParams); override;

    procedure WmSize(var Msg: TMessage); message WM_SIZE;
    procedure WmNotify(var Msg: TMessage); message WM_NOTIFY;

  public

    constructor Create(AParent: HWND);
    procedure CreateBand(hwndChild: HWND; Height: Integer; Chevron: Boolean);

    property MENUID: Integer read FMenuID;


  end;



implementation



var
  ID_MENU: Integer = 1000;






  { TJLCommControl }

constructor TJLCommControl.Create(AParent: HWND);
begin
  inherited Create(AParent);

end;

procedure TJLCommControl.CreateHandle;
begin
  CreateWnd;
end;

procedure TJLCommControl.CreateWnd;
var
  Params: TCreateWinParams;
begin
  CreateParams(Params);
  CreateWindowHandle(Params);
end;


procedure TJLCommControl.CreateWindowHandle(const Params: TCreateWinParams);
begin
  Handle := CreateWindowEx(Params.dwExStyle, Params.lpClassName,
                           Params.lpWindowName, Params.dwStyle,
                           Params.X, Params.Y, Params.nWidth,
                           Params.nHeight, Params.hWndParent,
                           Params.hMenu, Params.hInstance,
                           Params.lpParam);
end;











 { TJLStatusBar }

constructor TJLStatusBar.Create(AParent: HWND);
var
  i: Integer;
  hF: HFONT;
  hL: TLogFont;
begin
  inherited Create(AParent);

  for i := 0 to 4 do
    FPartWidth[i] := 50;
  FParts := 1;
  FOwnerDraw := False;

  //FontÇÃçÇÇ≥
  hF := GetStockObject(SYSTEM_FONT);
  GetObject(hF, SizeOf(TLogFont), @hL);
  FFontHeight := hL.lfHeight;
end;

destructor TJLStatusBar.Destroy;
begin
  inherited Destroy;
end;


procedure TJLStatusBar.CreateParams(var Params: TCreateWinParams);
begin
  With Params do
  begin
    dwExStyle := 0;
    lpClassName := STATUSCLASSNAME;
    lpWindowName := nil;
    dwStyle := WS_CHILD or WS_VISIBLE or
               WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
    X := 0;
    Y := 0;
    nWidth := 0;
    nHeight := 0;
    hWndParent := Parent;
    hMenu := ID_MENU;
    hInstance := hInstance;
    lpParam := nil;
  end;
  FMenuID := ID_MENU;
  Inc(ID_MENU);
end;



procedure TJLStatusBar.WmSize(var Msg: TMessage);
begin
  if Assigned(FReSize) then
    FReSize(Self, LOWORD(Msg.LParam));

  SendMessage(Handle, WM_SIZE, Msg.WParam, Msg.LParam);
end;

procedure TJLStatusBar.WmNotify(var Msg: TMessage);
var
  pHdr: PNMHdr;
begin
  pHdr := Pointer(Msg.LParam);

  if pHdr^.hwndFrom <> Handle then
    exit;

  Case phdr^.code of

    NM_CLICK:   ON_CLICK;
    NM_DBLCLK:  ON_DBCLICK;
    NM_RCLICK:  ON_RCLICK;
    NM_RDBLCLK: ON_RDBCLICK;

    //SBN_SIMPLEMODECHANGE:

  end; //Case
end;

procedure TJLStatusBar.WmDrawItem(var Msg: TWMDrawItem);
begin
  if Msg.DrawItemStruct.hwndItem = Handle then
    Msg.Result := Integer(ON_DRAWITEM(Msg.DrawItemStruct));
end;




procedure TJLStatusBar.Invalidate;
begin
  SendMessage(Handle, WM_SIZE, 0, 0);
end;





procedure TJLStatusBar.ON_CLICK;
begin
  if Assigned(FClick) then
    FClick(Self);
end;

procedure TJLStatusBar.ON_DBCLICK;
begin
  if Assigned(FDBClick) then
    FDBClick(Self);
end;

procedure TJLStatusBar.ON_RCLICK;
begin
  if Assigned(FRClick) then
    FRClick(Self);
end;

procedure TJLStatusBar.ON_RDBCLICK;
begin
  if Assigned(FRDBClick) then
    FRDBClick(Self);
end;

function TJLStatusBar.ON_DRAWITEM(DIS: PDRAWITEMSTRUCT): Boolean;
begin
  Result := False;
  if Assigned(FDrawItem) then
  begin
    FDrawItem(Self, DIS);
    Result := True;
  end;
end;



procedure TJLStatusBar.SetParts(AParts: Byte);
var
  PW: array[0..4] of Integer;
  i: Byte;
begin
  if (AParts > 5) or (AParts = 0) then
    exit
  else if AParts = 1 then
    PW[0] := -1
  else
  begin
    PW[0] := FPartWidth[0];
    for i := 1 to AParts - 2 do
    begin
      PW[i] := PW[i - 1] + FPartWidth[i];
    end;
    PW[AParts - 1] := -1
  end;
  FParts := AParts;
  SendMessage(Handle, SB_SETPARTS, AParts, Integer(@PW[0]));
end;

function TJLStatusBar.GetParts: Byte;
begin
  Result := FParts;
end;

procedure TJLStatusBar.SetPartWidth(i: Byte; AWidth: Integer);
begin
  if i in [0..4] then
  begin
    FPartWidth[i] := AWidth;
    SetParts(FParts);
  end;
end;

function TJLStatusBar.GetPartWidth(i: Byte): Integer;
begin
  if i < FParts then
    Result := FPartWidth[i]
  else
    Result := 0;
end;

procedure TJLStatusBar.SetText(i: Byte; AText: String);
begin
  if not FOwnerDraw and (i < FParts) then
    SendMessage(Handle, SB_SETTEXT, i, Integer(PChar(AText)));
end;

function TJLStatusBar.GetText(i: Byte): String;
var
  len: Integer;
begin
  if not FOwnerDraw and (i < FParts) then
  begin
    SetLength(Result, 255);
    len := LOWORD(SendMessage(Handle, SB_GETTEXT, i, Integer(PChar(Result))));
    SetLength(Result, Len);
  end else
    Result := '';
end;

procedure TJLStatusBar.SetHeight(AHeight: Integer);
var
  br: array[0..2] of Integer;
begin
  SendMessage(Handle, SB_GETBORDERS, 0, Integer(@br));
  SendMessage(Handle, SB_SETMINHEIGHT, AHeight - br[1] * 2, 0);
  Invalidate;
end;

function TJLStatusBar.GetHeight: Integer;
var
  rc: TRect;
  br: array[0..2] of Integer;
begin
  rc := Rect[0];
  SendMessage(Handle, SB_GETBORDERS, 0, Integer(@br));
  Result := rc.Bottom - rc.Top + br[1] * 2;
end;

function TJLStatusBar.GetRect(i: Byte): TRect;
begin
  SendMessage(Handle, SB_GETRECT, i, Integer(@Result));
end;

procedure TJLStatusBar.SetOwnerDraw(AValue: Boolean);
var
  i: integer;
begin
  if AValue then
    for i := 0 to FParts - 1 do
      SendMessage(Handle, SB_SETTEXT, i or SBT_OWNERDRAW, 0)
  else
    for i := 0 to FParts - 1 do
      SendMessage(Handle, SB_SETTEXT, i, 0);
  FOwnerDraw := AValue;
end;

function TJLStatusBar.GetOwnerDraw: Boolean;
begin
  Result := FOwnerDraw;
end;

procedure TJLStatusBar.SetColor(color: Cardinal);
var
  hB: HBRUSH;
  DC: HDC;
begin
  hB := CreateSolidBrush(color);
   DC := GetDC(Handle);
    FillRect(DC, Rect[0], hB);
   ReleaseDC(Handle, DC);
  DeleteObject(hB);
end;






















 { TJLToolBar }

procedure TJLToolBar.CreateParams(var Params: TCreateWinParams);
begin
  With Params do
  begin
    dwExStyle := WS_EX_TOOLWINDOW;
    lpClassName := TOOLBARCLASSNAME;
    lpWindowName := nil;
    dwStyle := WS_CHILD or WS_VISIBLE or
               WS_CLIPCHILDREN or WS_CLIPSIBLINGS or CCS_NODIVIDER or
               CCS_NORESIZE or TBSTYLE_FLAT or TBSTYLE_LIST;
    X := 0;
    Y := 0;
    nWidth := 0;
    nHeight := 0;
    hWndParent := Parent;
    hMenu := ID_MENU;
    hInstance := hInstance;
    lpParam := nil;
  end;
  FMenuID := ID_MENU;
  Inc(ID_MENU);
end;


procedure TJLToolBar.CreateButton(Text: Pointer; bStyle: Byte; wID: Integer);
var
  p: Integer;
  tbb: TTBBUTTON;
begin
  tbb.iBitmap := -2;
  tbb.idCommand := wID;
  tbb.dwData := 0;
  tbb.fsState := TBSTATE_ENABLED;
  tbb.fsStyle := bStyle;
  tbb.iString := 0;

  if bStyle and TBSTYLE_BUTTON = TBSTYLE_BUTTON then
  begin
    p := SendMessage(Handle, TB_ADDSTRING, 0, Integer(Text));
    tbb.iString := p;
  end;


  SendMessage(Handle, TB_ADDBUTTONS, 1, Integer(@tbb));
end;




























 { TJLReBar }

constructor TJLReBar.Create(AParent: HWND);
var
  RBInfo: TReBarInfo;
begin
  inherited Create(AParent);

   ZeroMemory(@RBInfo, SizeOf(TReBarInfo));
   RBInfo.cbSize := SizeOf(TReBarInfo);
   SendMessage(Handle, RB_SETBARINFO, 0, Integer(@RBInfo));
end;

procedure TJLReBar.CreateParams(var Params: TCreateWinParams);
begin
  With Params do
  begin
    dwExStyle := WS_EX_TOOLWINDOW;
    lpClassName := REBARCLASSNAME;
    lpWindowName := nil;
    dwStyle := WS_CHILD or WS_VISIBLE or
               WS_CLIPCHILDREN or WS_CLIPSIBLINGS or
               CCS_NODIVIDER or RBS_BANDBORDERS;
    X := 0;
    Y := 0;
    nWidth := 0;
    nHeight := 0;
    hWndParent := Parent;
    hMenu := ID_MENU;
    hInstance := hInstance;
    lpParam := nil;
  end;
  FMenuID := ID_MENU;
  Inc(ID_MENU);
end;

//procedure TJLReBar.UpdateChevron(hwndChild: HWND);
//begin
//end;

procedure TJLReBar.CreateBand(hwndChild: HWND; Height: Integer; Chevron: Boolean);
var
  hBandInfo: TReBarBandInfo;
  bc: Integer;
  rc: TRect;
begin
  ZeroMemory(@hBandInfo, SizeOF(TReBarBandInfo));
  hBandInfo.cbSize := SizeOf(TReBarBandInfo);

  hBandInfo.hwndChild := hwndChild;
  hBandInfo.fMask := RBBIM_CHILD or RBBIM_CHILDSIZE or RBBIM_STYLE;
  hBandInfo.fStyle := {RBBS_CHILDEDGE or }RBBS_GRIPPERALWAYS;
  hBandInfo.cyMinChild := Height;

  if Chevron then
  begin
    bc := SendMessage(hwndChild, TB_BUTTONCOUNT, 0, 0);
    SendMessage(hwndChild, TB_GETITEMRECT, bc - 1, Integer(@rc));
    hBandInfo.fMask := hBandInfo.fMask or RBBIM_IDEALSIZE;
    hBandInfo.fStyle := hBandInfo.fStyle or RBBS_USECHEVRON;
    hBandInfo.cxIdeal := rc.Right;
  end;

  SendMessage(Handle, RB_INSERTBAND, -1, Integer(@hBandInfo));
end;












procedure TJLReBar.WmSize(var Msg: TMessage);
begin
  SendMessage(Handle, WM_SIZE, Msg.WParam, Msg.LParam);
end;

procedure TJLReBar.WmNotify(var Msg: TMessage);
var
  hM, hPop, hSub: HMENU;
  phdr: PNMHdr;
  pnmchevron: PNMREBARCHEVRON;
  rcBand, rcButton, rcDest: TRect;
  pt: TPoint;
  bc: Integer;
  rbBandInfo: TReBarBandInfo;
  i, j: Integer;
  szBuf: array[0..255] of Char;
begin
  phdr := PNMHdr(Msg.LParam);
  if phdr.hwndFrom <> Handle then exit;

  Case phdr.code of

    RBN_CHEVRONPUSHED: begin

      pnmchevron := PNMREBARCHEVRON(Msg.LParam);

      SendMessage(Handle, RB_GETRECT, pnmchevron.uBand, Integer(@rcBand));

      ClientToScreen(Handle, rcBand.TopLeft);
      ClientToScreen(Handle, rcBand.BottomRight);

      ZeroMemory(@rbBandInfo, SizeOf(TReBarBandInfo));
      rbBandInfo.cbSize := SizeOf(TReBarBandInfo);
      rbBandInfo.fMask := RBBIM_CHILD;
      SendMessage(Handle, RB_GETBANDINFO, pnmchevron.uBand, Integer(@rbBandInfo));
      bc := SendMessage(rbBandInfo.hwndChild, TB_BUTTONCOUNT, 0, 0);

      for i := 0 to bc - 1 do
      begin
        SendMessage(rbBandInfo.hwndChild, TB_GETITEMRECT, i, Integer(@rcButton));
        ClientToScreen(rbBandInfo.hwndChild, rcButton.TopLeft);
        ClientToScreen(rbBandInfo.hwndChild, rcButton.BottomRight);
        IntersectRect(rcDest, rcBand, rcButton);
        if not EqualRect(rcButton, rcDest) then
        begin
          pt.X := pnmchevron.rc.Left;
          pt.Y := pnmchevron.rc.Bottom;
          ClientToScreen(Handle, pt);
          hM := CreateMenu;
          hPop := CreateMenu;

          for j := i to bc - 1 do
          begin
            SendMessage(rbBandInfo.hwndChild, TB_GETSTRING, MakeWParam(255, j), Integer(@szBuf[0]));
            AppendMenu(hPop, MF_STRING, 1002, szBuf);
          end;
          
          AppendMenu(hM, MF_POPUP, hPop, nil);
          hSub := GetSubMenu(hM, 0);
          TrackPopupMenu(hSub, TPM_LEFTALIGN, pt.X, pt.Y, 0, Parent, nil);
          DestroyMenu(hM);
          break;
        end;
      end;

    end;

  end; //Case

end;









end.
