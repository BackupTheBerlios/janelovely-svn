unit JLStatusBar;

interface

uses Windows, Messages, Classes, JLControls, CommCtrl;

type
  TJLDrawItemEvent = procedure (Sender: TObject; DIS: PDRAWITEMSTRUCT)
    of Object;

  TJLStatusBar = class(TJLWinControl)
  private

    FParts: Byte;
    FPartWidth: array[0..4] of Integer;
    FFontHeight: Integer;
    FOwnerDraw: Boolean;
    FCtlID: Integer;

    FClick: TNotifyEvent;
    FDbClick: TNotifyEvent;
    FRClick: TNotifyEvent;
    FRDbClick: TNotifyEvent;
    FDrawItem: TJLDrawItemEvent;

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

    procedure CreateWnd; override;

    procedure WmSize(var Msg: TMessage); message WM_SIZE;
    procedure WmNotify(var Msg: TMessage); message WM_NOTIFY;
    procedure WmDrawItem(var Msg: TWMDrawItem); message WM_DRAWITEM;

    procedure ON_CLICK;
    procedure ON_DBCLICK;
    procedure ON_RCLICK;
    procedure ON_RDBCLICK;
    function ON_DRAWITEM(DIS: PDRAWITEMSTRUCT): Boolean;

  public

    constructor Create(AParent: HWND; wID: Cardinal);
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

    property OnClick: TNotifyEvent read FClick write FClick;
    property OnDbClick: TNotifyEvent read FDbClick write FDbClick;
    property OnRClick: TNotifyEvent read FRClick write FRClick;
    property OnRDbClick: TNotifyEvent read FRDbClick write FRDbClick;
    property OnDrawItem: TJLDrawItemEvent read FDrawItem write FDrawItem;

  end;

implementation



 { TJLStatusBar }

constructor TJLStatusBar.Create(AParent: HWND; wID: Cardinal);
var
  i: Integer;
  hF: HFONT;
  hL: TLogFont;
begin
  FCtlID := wID;

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



procedure TJLStatusBar.CreateWnd;
begin
  Handle := CreateStatusWindow(WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or
                               WS_CLIPSIBLINGS, nil, Parent, FCtlID);
end;



procedure TJLStatusBar.WmSize(var Msg: TMessage);
begin
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
end.
