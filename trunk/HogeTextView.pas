unit HogeTextView;
(* version 0.0.5 *)
(* Copyright (C) 2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.17, Sun Oct 10 06:18:08 2004 UTC *)
(*
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the author be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose
  and to alter it and redistribute it freely.
 *)

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  CommCtrl,
  Graphics,
  Clipbrd,
  ExtCtrls,
  MMSystem, //beginner
  AppEvnts;

type
  (*-------------------------------------------------------*)
  TWallpaperVAlign = (walVTop, walVCenter, walVBottom);
  TWallpaperHAlign = (walHLeft, walHCenter, walHRight);

  THogeAttribute = 0..31;

  THogeTextView = class;

  (*-------------------------------------------------------*)
  THogePosition = record
    position: Integer;
    size    : Integer;
  end;

  (*-------------------------------------------------------*)
  (*-------------------------------------------------------*)

  THogeTVItem = class(TObject)
  private
    FOffsetLeft: Integer;
    FView: THogeTextView;
    FCharWidth: AnsiString;
    FLogicalLines: Integer;

    procedure CalcCharWidth;
    function GetCharWidth(index: Integer): Integer;
    function GetLogicalLines: Integer;

  public
    FText:   AnsiString;
    FAttrib: AnsiString;
    {aiai}
    BorderLine: Boolean;
    BorderCustom: Boolean;
    BorderColor: TColor;
    PictLine: Boolean;
    PictPos: Integer;
    Picture: TGraphic;
    {/aiai}

    constructor Create(view: THogeTextView);
    destructor Destroy; override;
    function GetLength: Integer;
    function GetWidthInfo: string;

    function IndexToLogicalPos(index: Integer): TPoint;
    function LogicalPosToIndex(var point: TPoint): Integer;
    function StartsWith(const AString: String; Index: Integer;
                        var matchEnd: Integer): Boolean;

    procedure Insert(index: Integer;
                     str: PChar;
                     cbStr: Integer;
                     attrib: Integer = 0);
    procedure IDInsert(index: Integer;
                       str: PChar;
                       cbStr: integer;
                       line: integer;
                       attrib: Integer = 0);
    procedure Add(str: PChar;
                  cbStr: Integer;
                  attrib: Integer = 0);

    procedure FontChanged;
    function HasEmbed(index: Integer): Boolean;
    function SkipToEmbed(index: Integer): Integer;
    function FetchEmbed(index: Integer): THogePosition;
    function GetEmbed(index: Integer): String;
    property OffsetLeft: Integer read FOffsetLeft write FOffsetLeft;
    property CharWidth[index: integer]: Integer read GetCharWidth;
    property LogicalLines: Integer read GetLogicalLines write FLogicalLines;
  end;

  (*-------------------------------------------------------*)

  THogeIDList = record
    bool: Boolean;
    Item: THogeTVItem;
    Position: Integer;
  end;

  THogeIDListArray = array of THogeIDList;
  THogeResNumArray = array of Boolean;

  (*-------------------------------------------------------*)
  THogeTVItems = class(TList)
  private
    FParent: THogeTextView;
  protected
    function GetItem(index: Integer): THogeTVitem;
    procedure SetItem(index: Integer; item: THogeTVItem);
  public
    constructor Create(parent: THogeTextView);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Add(Item: Pointer); overload;
    function GetLogicalLines: Integer;

    property Items[index: Integer]: THogeTVitem read GetItem write SetItem; default;
  end;

  (*-------------------------------------------------------*)
  THogeTextAttrib = record
    color: TColor;
    style: TFontStyles;
  end;
  THogeCharWidthTable = record
    Ascii_1 : array[$00..$80] of Byte;
    MB_1    : array[$81..$9F, $00..$FF] of Byte; // $40..$EC, of cource.
    Ascii_2 : array[$A0..$DF] of Byte;
    MB_2    : array[$E0..$FC, $00..$FF] of Byte; // $40..$EC
    Ascii_3 : array[$FD..$FF] of Byte;
  end;
  (*-------------------------------------------------------*)
  THogeTextView = class(TCustomControl)
  private
    { Private 宣言 }
    FCharWidthTable: THogeCharWidthTable;
    FBCharWidthTable: THogeCharWidthTable;
  protected
    { Protected 宣言 }

    FWidth: Integer;
    FHeight: Integer;

    FLeftMargin: Integer;
    FTopMargin: Integer;
    FRightMargin: Integer;
    //FMaxWidth: Integer;  //aiai
    FExternalLeading: Integer;
    FTopLine: Integer;
    FStrings: THogeTVItems;
    FTopLineOffset: Integer;
    FLogicalTopLine: Integer;
    FBottomLine: Integer;
    FVisibleLines: Integer;

    FVerticalCaretMargin: Integer;
    FVScrollLines: Integer;
    FWheelPageScroll: boolean;

    FCaretPos: TPoint;     (* Client-coordinates *)
    FEditPoint: TPoint;    (* physical line and column *)
    FLogicalCaret: TPoint; (* logical line and client X-coordinate *)
    FCaretSavedX: Integer; (* client X-coordinate *)
    FCaretVisible: Boolean;
    FConfCaretVisible: Boolean; //521
    FCaretScrollSync: Boolean; //aiai

    FSelecting: Boolean;
    FDragging: Boolean;
    FSelStart: TPoint;

    FBitmap: TBitmap;

    //改造▽ 追加 (スレビューに壁紙を設定する。Doe用)
    FWallpaper: TGraphic;
    FWallpaperVAlign: TWallpaperVAlign;
    FWallpaperHAlign: TWallpaperHAlign;
    //改造△ 追加 (スレビューに壁紙を設定する。Doe用)

    FBoldWidthModifier: Integer;

    FOwnCaret: Boolean;

    FTracking: Boolean;
    FIsMouseIn: Boolean;
    FHoverTime: Cardinal;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseHover: TMouseMoveEvent;
    FOnMouseEnter: TNotifyEvent;
    FTrackMouseEvent: TTrackMouseEvent;

    {beginner}
    FSmoothScroll: Boolean;
    FEnableAutoScroll: Boolean;
    FFraction: Integer;
    FFrames: Integer;
    FWaitTime: Cardinal;

    ASCursorOrigin: TPoint;
    ASCounter: Integer;

    Timer: TTimer;
    {/beginner}
    FRemind: Integer;

    {aiai}
    FOnScrollEnd: TNotifyEvent;

    FIDListArray: THogeIDListArray;
    FResNumArray: THogeResNumArray;

    FColordNumber: Boolean;
    FLinkedNumColor: TColor;

    FIDLinkColor :Boolean;
    FIDLinkColorNone: TColor;
    FIDLinkColorMany: TColor;
    FIDLinkThreshold: Integer;

    CanRepain: Boolean;
    FHighlightTarget: String;
    FKeywordBrushColor: TColor;
    {/aiai}

    function CharWidth(p: PChar; attrib: Integer): Integer;

    function BaselineSkip: Integer;
    procedure UpdateVisibleLines;
    function TopForBottom: Integer;
    function GetMargin: Integer;
    function CalcLogicalLine(line, offset: Integer): Integer;

    procedure ModifyLogicalLine(var logicalLine, physicalLine, offset: Integer);
    function  Normalize(point: TPoint): TPoint;
    procedure LogicalNormalize(var logical, physical: TPoint);

    procedure UpdateScreenCaret;
    procedure ScrollToViewCaret(Center: Boolean = False);
    function PhysicalToClient(X, Y: integer): TPoint;

    function NormalizeMinMax(point1, point2: TPoint): TRect;
    function RegionToText(point1, point2: TPoint): string;

    procedure UpdateScrollInfo(redraw: Boolean = True);
    procedure LineUpdated(startLine, endLine: Integer);
    procedure CaretVisible(visibleP: boolean);
    procedure SetSelecting(selectP: boolean);
    procedure SetConfCaretVisible(visibleP: boolean);

    function  RangeVisible(startPos, endPos: TPoint): Boolean;
    procedure InvalidateSize;
    procedure UpdateBottomLine;

    function GetHoverTime: Cardinal;
    procedure SetHoverTime(Value: Cardinal);

    procedure CreateWnd; override;
    procedure ON_WM_CREATE(var msg: TMsg); message WM_CREATE;
    procedure ON_WM_GETDLGCODE(var msg: TMessage); message WM_GETDLGCODE;
    procedure ON_WM_SIZE(var msg: TMessage); message WM_SIZE;
    procedure DoSize(newWidth, newHeight: Integer);

    procedure ON_WM_SETFOCUS (var msg: TMsg); message WM_SETFOCUS;
    procedure ON_WM_KILLFOCUS(var msg: TMsg); message WM_KILLFOCUS;

    procedure ON_WM_MOUSEACTIVATE(var msg: TWMMouse); message WM_MOUSEACTIVATE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseUp  (Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure ON_WM_MOUSEWHEEL   (var msg: TMessage); message WM_MOUSEWHEEL;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure ON_WM_HSCROLL(var msg: TMessage); message WM_HSCROLL;
    procedure ON_WM_VSCROLL(var msg: TMessage); message WM_VSCROLL;

    procedure ON_WM_PAINT(var msg: TWMPaint); message WM_PAINT;
    procedure PaintWindow(DC: HDC); override;
    procedure WmMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
    procedure WmMouseHover(var Message: TMessage); message WM_MOUSEHOVER;
    procedure MouseLeave;
    procedure MouseHover;
    procedure MouseEnter;

    {beginner}
    function GetAutoScroll: Boolean;
    procedure SetAutoScroll(Scroll: Boolean);
    property AutoScroll: Boolean read GetAutoScroll write SetAutoScroll;

    function GetFrameRate: Cardinal;
    procedure SetFrameRate(Value: Cardinal);

    procedure TimerOnTimer(Sender: TObject);
    {/beginner}
    {aiai}
    procedure AnalyzeScrollInfo;
    procedure DrawBorder(X1, X2, Y: Integer; Color: TColor; Custom: Boolean);
    {/aiai}
  public
    { Public 宣言 }
    TextAttrib: array[THogeAttribute] of THogeTextAttrib;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear;

    function  PhysicalToLogical(point: TPoint): TPoint;
    function  LogicalToPhysical(point: TPoint): TPoint;
    function  ClientToPhysicalCharPos(X, Y: integer): TPoint;
    function  ClientToLogical(X, Y: integer): TPoint;

    procedure SetPhysicalCaret(X, Y: integer; opt: Integer = 0); overload;
    procedure SetPhysicalCaret(point: TPoint; opt: Integer = 0); overload;
    procedure SetLogicalCaret(point: TPoint; opt: Integer = 0); overload;
    procedure SetLogicalCaret(X, Y: integer; opt: Integer = 0); overload;

    function InSelection(X, Y: integer): Boolean;

    procedure ForwardLine(advance: integer);
    procedure ForwardChar(advance: integer);
    procedure BeginningOfLine;
    procedure EndOfLine;
    procedure BeginningOfBuffer;
    procedure EndOfBuffer;
    procedure PageDown;
    procedure PageUp;
    procedure SetTop(line: integer);
    procedure ScrollLine(advance: integer);
    procedure ScrollPixel(advance: integer); //beginner
    procedure CopySelection;
    function  GetSelection: String;
    function  SearchForward (const AString: String): Boolean;
    function  SearchBackward(const AString: String): Boolean;
    procedure SetMarkCommand;

    function  Insert(point: TPoint;
                     const AString: string;
                     attrib: Integer = 0): TPoint;
    function  nInsert(point: TPoint;
                      pstr: PChar;
                      count: Integer;
                      attrib: Integer = 0): TPoint;
    function  Append(const AString: string;
                     attrib: Integer = 0): TPoint;
    function  nAppend(pstr: PChar;
                      count: Integer;
                      attrib: Integer = 0): TPoint;
    {aiai}
    function AppendPicture(Image: TGraphic; overlap: Boolean): Boolean;
    procedure AppendHR(Color: TColor; Custom: Boolean; OffsetLeft: Integer);
    function  newPara: TPoint;
    function  Insert2(point: TPoint;
                     const AString: string;
                     attrib: Integer = 0): TPoint;
    function  nInsert2(point: TPoint;
                       pstr: PChar;
                       count: Integer;
                       attrib: Integer = 0): TPoint;
    function  Append2(const AString: string;
                     attrib: Integer = 0): TPoint;
    function  nAppend2(pstr: PChar;
                      count: Integer;
                      attrib: Integer = 0): TPoint;
    (* IDポップアップ用 *)
    function nIDAppend(pstr: PChar;
                       count: integer;
                       attrib: integer = 0): TPoint;
    function nIDHrefAppend(pstr: PChar;
                           count: integer;
                           line: integer;
                           attrib: integer = 0): TPoint;
    {/aiai}
    procedure SetFont(FaceName: String; Size: Integer);
    procedure SelectWord(physicalPos: TPoint);

    {aiai}
    procedure AutoScrollLines(ScrollLines: Integer);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure DownLine;
    procedure SetIDList(bool: Boolean; Item: THogeTVItem;
                          Position, Line: Integer);
    procedure SetResNum(ResNumber: Integer);
    {/aiai}

    property Strings: THogeTVItems read FStrings;
    property TopLine: Integer read FTopLine;
    property LogicalTopLine: Integer read FLogicalTopLine;

    property Selection: String read GetSelection;
    property Caret: TPoint read FEditPoint stored False;
    property ScreenCaret: TPoint read FCaretPos;
    property LogicalCaret: TPoint read FLogicalCaret;
    property VisibleLines: Integer read FVisibleLines;
    property HoverTime: Cardinal read GetHoverTime write SetHoverTime;
    property Fraction: Integer read FFraction; //beginner
    property ResNumArray: THogeResNumArray read FResNumArray write FResNumArray;
    property IDListArray: THogeIDListArray read FIDListArray write FIDListArray;
    property HighlightTarget: String read FHighlightTarget write FHighlightTarget;  //aiai
  published
    { Published 宣言 }
    property LeftMargin: Integer read FLeftMargin write FLeftMargin;
    property TopMargin : Integer read FTopMargin  write FTopMargin;
    property RightMargin: Integer read FRightMargin write FRightMargin;
    //property MaxWidth: Integer read FMaxWidth write FMaxWidth;  //aiai
    property ExternalLeading: Integer read FExternalLeading write FExternalLeading;
    property VerticalCaretMargin: Integer read FVerticalCaretMargin write FVerticalCaretMargin;
    property VScrollLines: Integer read FVScrollLines write FVScrollLines default 3;
    property Selecting: Boolean read FSelecting write SetSelecting stored False;
    property WheelPageScroll: boolean read FWheelPageScroll write FWheelPageScroll;
    property ConfCaretVisible: boolean read FConfCaretVisible write SetConfCaretVisible;
    property CaretScrollSync: Boolean read FCaretScrollSync write FCaretScrollSync; //aiai

    //改造▽ 追加 (スレビューに壁紙を設定する。Doe用)
    property Wallpaper: TGraphic read FWallpaper write FWallpaper;
    property WallpaperVAlign: TWallpaperVAlign read FWallpaperVAlign write FWallpaperVAlign;
    property WallpaperHAlign: TWallpaperHAlign read FWallpaperHAlign write FWallpaperHAlign;
    //改造△ 追加 (スレビューに壁紙を設定する。Doe用)

    {aiai}
    property LinkedNumColor: TColor read FLinkedNumColor write FLinkedNumColor;
    property ColordNumber: Boolean read FColordNumber write FColordNumber;

    property IDLinkColor: Boolean read FIDLinkColor write FIDLinkColor;
    property IDLinkColorNone: TColor read FIDLinkColorNone write FIDLinkColorNone;
    property IDLinkColorMany: TColor read FIDLinkColorMany write FIDLinkColorMany;
    property IDLinkThreshold: Integer read FIDLinkThreshold write FIDLinkThreshold;

    property KeywordBrushColor: TColor read FKeywordBrushColor write FKeywordBrushColor default clYellow;
    {/aiai}

    property OnMouseHover: TMouseMoveEvent read FOnMouseHover write FOnMouseHover;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    {beginner}
    property Frames: Integer read FFrames write FFrames default 1;
    property FrameRate: Cardinal read GetFrameRate write SetFrameRate default 1;
    property EnableAutoScroll: Boolean read FEnableAutoScroll write FEnableAutoScroll default True;
    {/beginner}
    {aiai}
    property OnScrollEnd: TNotifyEvent read FOnScrollEnd write FOnScrollEnd;
    {/aiai}

    { inherited }
    property Align;
    property Color;
    property Cursor default crIBeam;
    property Font;
    property Enabled;
    property TabStop;
    property Visible;

    property OnKeyDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property PopupMenu;

    {aiai}
    property OnEnter;
    property OnExit;
    {/aiai}
  end;

  (*-------------------------------------------------------*)

procedure Register;

procedure AdjustToTextViewLine(var Point: TPoint; Rect: TRect);

const
  htvATTMASK  = $1F;

  htvASCII    = $00;
  htvUNICODE  = $40;
  htvCODEMASK = $40;

  htvVISIBLE  = $00;
  htvHIDDEN   = $80;
  htvVMASK    = $80;

  htvUSER     = $20;
  htvUSERMASK = $20;


  hscDONTSAVEX    = $01;
  hscDONTSCROLL   = $02;
  hscSCROLLCENTER = $04;

(*=======================================================*)
implementation
(*=======================================================*)

{$B-}
{$DEFINE IBEAM=1}

procedure Register;
begin
  RegisterComponents('Samples', [THogeTextView]);
end;

(*=======================================================*)

const
  ASCursorNon: TPoint = (X: -10000; Y: -10000);

var
  SleepMinimumResolution: Cardinal;


(*=======================================================*)
constructor THogeTVItem.Create(view: THogeTextView);
begin
  inherited Create;
  FOffsetLeft := 0;
  FView := view;
  BorderLine := False;  //aiai
  PictLine := False;  //aiai
end;

destructor THogeTVItem.Destroy;
begin
  SetLength(FText, 0);
  SetLength(FAttrib, 0);
  SetLength(FCharWidth, 0);
  inherited;
end;

function THogeTVItem.GetLength: Integer;
begin
  result := length(FText);
end;


procedure THogeTVItem.Insert(index: Integer;
                             str: PChar;
                             cbStr: integer;
                             attrib: Integer = 0);
var
  orgLen, insLen, size: integer;
begin
  insLen := cbStr;
  orgLen := length(FText);
  if index <= 0 then
    index := 1
  else if orgLen < index then
    index := orgLen + 1;
  size := orgLen + insLen;

  SetLength(FText, size);
  SetLength(FAttrib, size);
  if index <= orgLen then
  begin
    Move(FText[index], FText[index + insLen], orgLen - index +1);
    Move(FAttrib[index], FAttrib[index + insLen], orgLen - index +1);
  end;
  Move(str^, FText[index], insLen);
  FillChar(FAttrib[index], insLen, attrib);
end;

procedure THogeTVItem.IDInsert(index: Integer;
                             str: PChar;
                             cbStr: integer;
                             line: integer;
                             attrib: Integer = 0);
var
  orgLen, insLen, size: integer;
begin
  insLen := cbStr;
  orgLen := length(FText);
  if index <= 0 then
    index := 1
  else if orgLen < index then
    index := orgLen + 1;
  size := orgLen + insLen;

  SetLength(FText, size);
  SetLength(FAttrib, size);
  if index <= orgLen then
  begin
    Move(FText[index], FText[index + insLen], orgLen - index +1);
    Move(FAttrib[index], FAttrib[index + insLen], orgLen - index +1);
  end;
  Move(str^, FText[index], insLen);
  FillChar(FAttrib[index], insLen, attrib);

  FView.SetIDList(True, Self, index, line);
end;

procedure THogeTVItem.Add(str: PChar;
                          cbStr: Integer;
                          attrib: Integer = 0);
begin
  Insert(length(FText), str, cbStr, attrib);
end;


procedure THogeTVItem.CalcCharWidth;
var
  attCode: Integer;
  i, len: integer;
  secondByte: Boolean;
begin
  len := length(FText);
  SetLength(FCharWidth, len);
  if len <= 0 then
    exit;

  secondByte := False;
  for i := 1 to len do
  begin
    attCode := Ord(FAttrib[i]);
    if secondByte then
    begin
      secondByte := False;
      FCharWidth[i] := #0;
    end
    else if attCode and htvVMASK = htvHIDDEN then
      FCharWidth[i] := #0
    else begin
      if attCode and htvCODEMASK = htvUNICODE then
        secondByte := True
      else if FText[i] in LeadBytes then
        secondByte := True;
      FCharWidth[i] := Chr(FView.CharWidth(@FText[i], Ord(FAttrib[i])));
    end;
  end;
end;

function THogeTVItem.GetCharWidth(index: Integer): Integer;
begin
  if length(FCharWidth) <> length(FText) then
  begin
    CalcCharWidth;
    FLogicalLines := 0;
  end;
  result := Ord(FCharWidth[index]);
end;

function THogeTVItem.GetWidthInfo: string;
begin
  if length(FCharWidth) <> length(FText) then
  begin
    CalcCharWidth;
    FLogicalLines := 0;
  end;
  result := FCharWidth;
end;

function THogeTVItem.GetLogicalLines: Integer;
begin
  if FLogicalLines <= 0 then
    FLogicalLines := IndexToLogicalPos(High(integer)).Y + 1;
  result := FLogicalLines;
end;

function THogeTVItem.IndexToLogicalPos(index: Integer): TPoint;
var
  i, len: integer;
  cw: AnsiString;
  nchars, width, maxWidth: integer;
begin
  cw := GetWidthInfo;
  len := length(cw);
  nchars := 0;
  maxWidth := FView.ClientWidth - FView.RightMargin;
  result.X := FView.LeftMargin + FOffsetLeft;
  result.Y := 0;
  for i := 1 to len do
  begin
    width := Ord(cw[i]);
    if width <> 0 then
    begin
      Inc(nchars);
      if (maxWidth < result.X + width) and (1 < nchars) then
      begin
        Inc(result.Y);
        nchars := 0;
        result.X := FView.LeftMargin + FOffsetLeft;
        if index <= i then
          exit;
      end;
      if index <= i then
        exit;
      Inc(result.X, width);
    end;
  end;
end;

function THogeTVItem.LogicalPosToIndex(var point: TPoint): Integer;
var
  len, index, line: integer;
  cw: AnsiString;
  nchars, width, maxWidth: integer;
begin
  cw := GetWidthInfo;
  len := length(cw);
  nchars := 0;
  maxWidth := FView.ClientWidth - FView.RightMargin;
  width := FView.LeftMargin + FOffsetLeft;
  if point.X < width then
    point.X := width;
  if point.Y < 0 then
    point.Y := 0
  else begin
    line := LogicalLines;
    if line <= point.Y then
      point.Y := line - 1;
  end;
  line := 0;
  for index := 1 to len do
  begin
    if cw[index] <> #0 then
    begin
      if (point.Y <= line) and (point.X <= width + (Ord(cw[index]) div 2)) then
      begin
        point.X := width;
        result := index;
        exit;
      end;
      Inc(nchars);
      if (1 < nchars) and (maxWidth < width + Ord(cw[index])) then
      begin
        if point.Y <= line then
        begin
          point.X := width;
          result := index;
          exit;
        end;
        Inc(line);
        nchars := 0;
        width := FView.LeftMargin + FOffsetLeft;
        if (point.Y <= line) and (point.X <= width) then
        begin
          point.X := width;
          result := index;
          exit;
        end;
      end;
      Inc(width, Ord(cw[index]));
    end;
  end;
  point.X := width;
  result := len + 1;
end;


function THogeTVItem.StartsWith(const AString: String; Index: Integer;
                                var matchEnd: Integer): Boolean;
var
  bufIndex, bufEnd: Integer;
  tgtIndex, tgtEnd: Integer;
  cw: AnsiString;
begin
  result := False;
  bufEnd := length(FText);
  tgtIndex := 1;
  tgtEnd := length(AString);
  if tgtEnd <= 0 then
    exit;
  cw := GetWidthInfo;
  for bufIndex := Index to bufEnd do
  begin
    if (Ord(FAttrib[bufIndex]) and htvVMASK = htvVISIBLE) then
    begin
      if (tgtEnd < tgtIndex) and (cw[bufIndex] <> #0) then
      begin
        matchEnd := bufIndex;
        result := True;
        exit;
      end;
      if cw[bufIndex] <> #0 then
      begin
        if AString[tgtIndex] <> UpCase(FText[bufIndex]) then
          exit;
      end
      else begin
        if AString[tgtIndex] <> FText[bufIndex] then
          exit;
      end;
      Inc(tgtIndex);
    end;
  end;
  result := (tgtEnd < tgtIndex);
  if result then
    matchEnd := bufEnd + 1;
end;

procedure THogeTVitem.FontChanged;
begin
  FLogicalLines := 0;
  CalcCharWidth;
end;

function THogeTVitem.HasEmbed(index: Integer): Boolean;
begin
  result := (index <= GetLength) and
            (Ord(FAttrib[index]) and htvUSERMASK = htvUSER);
end;

function THogeTVItem.SkipToEmbed(index: Integer): Integer;
var
  i, len: integer;
begin
  result := -1;
  len := GetLength;
  for i := index to len do
  begin
    if (Ord(FAttrib[i]) and htvUSERMASK) <> htvUSER then
    begin
      if (Ord(FAttrib[i]) and htvVMASK) = htvHIDDEN then
        result := i;
      exit;
    end;
  end;
end;

function THogeTVItem.FetchEmbed(index: Integer): THogePosition;
var
  i, len: integer;
  attCode: integer;
begin
  result.position := index;
  result.size := 0;
  len := length(FAttrib);
  if len < index then
    exit;
  attCode := Ord(FAttrib[index]);
  for i := index to len do
  begin
    if Ord(FAttrib[i]) = attCode then
      Inc(result.size)
    else
      break;
  end;
end;

function THogeTVItem.GetEmbed(index: Integer): String;
var
  posInfo: THogePosition;
begin
  result := '';
  if HasEmbed(index) then
  begin
    index := SkipToEmbed(index);
    if 0 < index then
    begin
      posInfo := FetchEmbed(index);
      result := Copy(FText, posInfo.position, posInfo.size);
    end;
  end;
end;

(*=======================================================*)
constructor THogeTVItems.Create(parent: THogeTextView);
begin
  inherited Create;
  FParent := parent;
end;

destructor THogeTVItems.Destroy;
begin
  Clear;
  inherited;
end;

procedure THogeTVItems.Clear;
var
  i: integer;
begin
  for i := 0 to Count -1 do
    Items[i].Free;
  inherited;
end;

function THogeTVItems.GetItem(index: Integer): THogeTVitem;
begin
  result := inherited Items[index];
end;

procedure THogeTVItems.SetItem(index: Integer; item: THogeTVItem);
begin
  inherited Items[index] := item;
end;

procedure THogeTVItems.Add(Item: Pointer);
begin
  inherited Add(Item);
end;

function THogeTVItems.GetLogicalLines: Integer;
var
  line: integer;
begin
  result := 0;
  for line := 0 to Count -1 do
    Inc(result, Items[line].LogicalLines);
end;

(*=======================================================*)
(*=======================================================*)
constructor THogeTextView.Create(AOwner: TComponent);
  procedure InitializeAttrib;
  var
    i: integer;
  begin
    for i := 0 to SizeOf(TextAttrib) div SizeOf(THogeTextAttrib) -1 do
    begin
      with TextAttrib[i] do
      begin
        color := Font.Color;
        style := Font.Style;
      end;
    end;
  end;

  procedure CalcWidthModifier;
  var
    wM, wN, wMN: Integer;
    style: TFontStyles;
  begin
    style := FBitmap.Canvas.Font.Style;
    FBitmap.Canvas.Font.Style := [fsBold];
    wM  := FBitmap.Canvas.TextWidth('M');
    wN  := FBitmap.Canvas.TextWidth('N');
    wMN := FBitmap.Canvas.TextWidth('MN');
    FBoldWidthModifier := wMN - (wM + wN);
    FBitmap.Canvas.Font.Style := style;
  end;
var
  item: THogeTVItem;
begin
  FBitmap := TBitmap.Create;

  FWidth := 0;
  FHeight := 0;

  FBitmap.Width := 0;
  FBitmap.Height := 0;

  FillChar(FCharWidthTable,  SizeOf(FCharWidthTable),  0);
  FillChar(FBCharWidthTable, SizeOf(FBCharWidthTable), 0);

  inherited Create(AOwner);
  FCaretPos.x := FLeftMargin;
  FCaretPos.y := FTopMargin - FFraction; //beginner
  FStrings := THogeTVItems.Create(Self);
  FTopLine := 0;
  FBottomLine := 0;
  FVisibleLines := 1;
  if FVScrollLines <= 0 then
    FVScrollLines := 3;
  FWheelPageScroll := false;

  DoubleBuffered := True;
  ParentColor    := False;
  FEditPoint.X := 0;
  FEditPoint.Y := 0;
  FLogicalCaret.X := 0;
  FLogicalCaret.Y := 0;
  FCaretSavedX := 0;
  FCaretVisible := False;
  FOwnCaret := False;

  FSelecting := False;
  FDragging  := False;
  FSelStart.X := 0;
  FSelStart.Y := 0;

  {aiai}
  SetLength(FResNumArray, 0);
  FLinkedNumColor := $00CF00AF;
  FColordNumber := true;

  FIDLinkColor := false;
  FIDLinkColorNone := $00000000;
  FIDLinkColorMany := $000000FF;
  FIDLinkThreshold := 5;
  SetLength(FIDListArray, 0);

  FKeywordBrushColor := clYellow;

  CanRepain := True;
  //FMaxWidth := 0;
  FHighlightTarget := '';
  {/aiai}

  CalcWidthModifier;

  InitializeAttrib;
  item := THogeTVItem.Create(Self);
  FStrings.Add(item);

  Cursor := crIBeam;

  FTrackMouseEvent.cbSize := SizeOf(FTrackMouseEvent);
  HoverTime := 0;

  {beginner}
  FEnableAutoScroll := True;
  FFrames := 1;
  FWaitTime := 1000 div 60;

  ASCursorOrigin := ASCursorNon;
  Timer := TTimer.Create(Self);
  Timer.Interval := 10;
  Timer.Enabled := False;
  Timer.OnTimer := TimerOnTimer;
  {/beginner}
end;

destructor THogeTextView.Destroy;
begin
  Timer.Free; //beginner
  FStrings.Free;
  FBitmap.Free;
  inherited;
end;

function THogeTextView.BaselineSkip: Integer;
var
  tm: TEXTMETRIC;
begin
  {beginner}
  if Font.Height >= 0 then begin
    result := Abs(Font.Height) + FExternalLeading;
  end else begin
    GetTextMetrics(FBitmap.Canvas.Handle, tm);
    result := Abs(Font.Height) + tm.tmInternalLeading + FExternalLeading;
  end;
  {/beginner}
end;

procedure THogeTextView.UpdateVisibleLines;
begin
  FVisibleLines := (ClientRect.Bottom - FTopMargin) div BaselineSkip + 1;
  if FVisibleLines < 0 then
    FVisibleLines := 0;
end;

function THogeTextView.TopForBottom: Integer;
begin
  result := FStrings.GetLogicalLines - VisibleLines + 1;
  if result < 0 then
    result := 0;
end;

function THogeTextView.GetMargin: Integer;
var
  vLines: Integer;
begin
  vLines := VisibleLines;
  if vLines < FVerticalCaretMargin * 2 then
    result := vLines div 2
  else
    result := FVerticalCaretMargin;
end;

function THogeTextView.CalcLogicalLine(line, offset: Integer): Integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to line do
    Inc(result, FStrings[i].LogicalLines);
  Inc(result, offset);
end;

procedure THogeTextView.ModifyLogicalLine(var logicalLine,
                                              physicalLine,
                                              offset: Integer);
var
  i, len, lines: integer;
begin
  if logicalLine < 0 then
    logicalLine := 0;
  lines := 0;
  for i := 0 to FStrings.Count -1 do
  begin
    len := FStrings[i].LogicalLines;
    if logicalLine < lines + len then
    begin
      physicalLine := i;
      offset := logicalLine - lines;
      exit;
    end;
    Inc(lines, len);
  end;
  logicalLine := lines -1;
  physicalLine := FStrings.Count -1;
  offset := FStrings[physicalLine].LogicalLines -1;
end;


function THogeTextView.Normalize(point: TPoint): TPoint;
var
  i, len: integer;
  cw: AnsiString;
begin
  if point.Y < 0 then
  begin
    result.X := 0;
    result.Y := 0;
    exit;
  end
  else if FStrings.Count <= point.Y then
  begin
    result.Y := FStrings.Count -1;
    result.X := FStrings[result.Y].GetLength;
    exit;
  end
  else
    result.Y := point.Y;

  len := Length(FStrings[Result.Y].FText);
  if  len > point.X then
  begin
    cw := FStrings[result.Y].GetWidthInfo;
    len := length(cw);
    if len <= point.X then
      result.X := len
    else begin
      for i := 1 to len do
      begin
        if (cw[i] <> #0) and (point.X < i) then
        begin
          result.X := i - 1;
          exit;
        end;
      end;
      result.X := len;
    end;
  end else
    Result.X := len;
end;

procedure THogeTextView.LogicalNormalize(var logical, physical: TPoint);
var
  offset: Integer;
  point: TPoint;
begin
  ModifyLogicalLine(logical.Y, physical.Y, offset);
  point.X := logical.X;
  point.Y := offset;
  physical.X := FStrings[physical.Y].LogicalPosToIndex(point) -1;
  logical.X := point.X;
end;

function  THogeTextView.PhysicalToLogical(point: TPoint): TPoint;
var
  line, lines: integer;
begin
  lines := 0;
  for line := 0 to point.Y -1 do
    Inc(lines, FStrings[line].GetLogicalLines);
  result := FStrings[point.Y].IndexToLogicalPos(point.X + 1);
  Inc(result.Y, lines);
end;

function  THogeTextView.LogicalToPhysical(point: TPoint): TPoint;
var
  line, offset: Integer;
begin
  ModifyLogicalLine(point.Y, line, offset);
  point.Y := offset;
  result.X := FStrings[line].LogicalPosToIndex(point) -1;
  result.Y := line;
end;

procedure THogeTextView.CaretVisible(visibleP: boolean);
begin
  if FCaretVisible = FConfCaretVisible and visibleP then
    exit;
  FCaretVisible := (FConfCaretVisible and visibleP); //521
  if GetFocus <> Handle then
    exit;
  if FCaretVisible and FOwnCaret then
  begin
    SetCaretPos(FCaretPos.x, FCaretPos.y);
    ShowCaret(Handle)
  end
  else
    HideCaret(Handle);
end;

procedure THogeTextView.SetSelecting(selectP: boolean);
begin
  if selectP <> FSelecting then
    Invalidate;
  FSelecting := selectP;
end;

procedure THogeTextView.SetConfCaretVisible(visibleP: boolean);
begin
  FConfCaretVisible := visibleP;
  if visibleP then
  begin
    SetPhysicalCaret(0, FTopLine + FVerticalCaretMargin, hscDONTSCROLL);
    SetSelecting(false);
  end;
  CaretVisible(visibleP);
end;

procedure THogeTextView.SetPhysicalCaret(X, Y: integer; opt: Integer);
var
  point: TPoint;
begin
  point.X := X;
  point.Y := Y;
  SetPhysicalCaret(point, opt);
end;

procedure THogeTextView.SetPhysicalCaret(point: TPoint; opt: Integer);
begin
  FEditPoint := Normalize(point);
  FLogicalCaret := PhysicalToLogical(FEditPoint);
  if opt and hscDONTSAVEX <> hscDONTSAVEX then
    FCaretSavedX := FLogicalCaret.X;
  if opt and hscDONTSCROLL <> hscDONTSCROLL then
    ScrollToViewCaret(opt and hscSCROLLCENTER = hscSCROLLCENTER)
  else
    UpdateScreenCaret;
  if FSelecting then
    Invalidate;
end;

procedure THogeTextView.UpdateScreenCaret;
begin
  FCaretPos.X := FLogicalCaret.X;
  FCaretPos.Y := (FLogicalCaret.Y - FLogicalTopLine) * BaselineSkip + FTopMargin - FFraction; //beginner
  {$IFDEF IBEAM}
  Dec(FCaretPos.X);
  {$ENDIF}
  if FOwnCaret then
    SetCaretPos(FCaretPos.X, FCaretPos.Y);
end;

procedure THogeTextView.SetLogicalCaret(point: TPoint; opt: Integer);
begin
  SetLogicalCaret(point.X, point.Y, opt);
end;

procedure THogeTextView.SetLogicalCaret(X, Y: integer; opt: Integer);
begin
  FLogicalCaret.X := X;
  FLogicalCaret.Y := Y;
  LogicalNormalize(FLogicalCaret, FEditPoint);
  if opt and hscDONTSAVEX <> hscDONTSAVEX then
    FCaretSavedX := X;
  if opt and hscDONTSCROLL <> hscDONTSCROLL then
  begin
    ScrollToViewCaret(opt and hscSCROLLCENTER = hscSCROLLCENTER);
  end
  else begin
    UpdateScreenCaret;
  end;
  if FSelecting then
    Invalidate;

end;

(* Scroll *)
procedure THogeTextView.ScrollToViewCaret(Center: Boolean = False);
var
  vLines: Integer;
  margin: Integer;
  oldTop: Integer;
begin
  margin := GetMargin;
  vLines := VisibleLines;
  Dec(vLines);
  if vLines < 0 then
    vLines := 0;
  oldTop := FLogicalTopLine;
  if Center then
  begin
    FLogicalTopLine := FLogicalCaret.Y - (vLines div 2);
  end;

  if (0 < vLines) and (FLogicalTopLine + vLines - margin -1 <= FLogicalCaret.Y) then
    FLogicalTopLine := FLogicalCaret.Y + margin - vLines + 1
  else if FLogicalCaret.Y < FLogicalTopLine + margin then
    FLogicalTopLine := FLogicalCaret.Y - margin;
  if FLogicalTopLine < 0 then
    FLogicalTopLine := 0
  else if TopForBottom < FLogicalTopLine then
    FLogicalTopLine := TopForBottom;

  ModifyLogicalLine(FLogicalTopLine, FTopLine, FTopLineOffset);
  UpdateBottomLine;
  if oldTop <> FLogicalTopLine then
    Invalidate;
  UpdateScreenCaret;
end;

function THogeTextView.PhysicalToClient(X, Y: integer): TPoint;
var
  col: integer;
  wm: string;
begin
  if Y < FStrings.Count then
  begin
    result.X := FLeftMargin + FStrings[Y].OffsetLeft;
    wm := FStrings[Y].GetWidthInfo;
    for col := 1 to X do
      Inc(result.X, Ord(wm[col]));
  end;
  result.Y := FTopMargin - FFraction + (Y - FTopLine) * BaselineSkip; //beginner
end;


function THogeTextView.ClientToPhysicalCharPos(X, Y: integer): TPoint;
var
  logicalLine: integer;
  maxWidth: integer;
  point: TPoint;
  oldLine: integer;
begin
  logicalLine := ((Y - FTopMargin + FFraction) div BaselineSkip) + FLogicalTopLine; //beginner
  if FStrings.GetLogicalLines <= logicalLine then
  begin
    result.Y := -1;
    result.X := -1;
    exit;
  end;
  ModifyLogicalLine(logicalLine, result.Y, point.Y);
  maxWidth := ClientWidth - RightMargin;
  if (maxWidth <= X) or (X < FLeftMargin + FStrings[result.Y].OffsetLeft) then
  begin
    result.Y := -1;
    result.X := -1;
    exit;
  end;
  point.X := X;
  oldLine := point.Y;
  result.X := FStrings[result.Y].LogicalPosToIndex(point) -1;
  if (oldLine <> point.Y) or
     (FStrings[result.Y].GetLength <= result.X) then
  begin
    result.Y := -1;
    result.X := -1;
  end;
end;

function THogeTextView.ClientToLogical(X, Y: integer): TPoint;
begin
  result.Y := (Y - FTopMargin + FFraction) div BaselineSkip + FLogicalTopLine; //beginner
  result.X := X;
end;

procedure THogeTextView.ForwardLine(advance: integer);
begin
  SetLogicalCaret(FCaretSavedX, FLogicalCaret.Y + advance, hscDONTSAVEX);
end;


procedure THogeTextView.ForwardChar(advance: integer);
var
  cw: AnsiString;
  len: integer;
begin
  if advance = 0 then
    exit;
  with FEditPoint do
  begin
    cw := FStrings[Y].GetWidthInfo;
    len := length(cw);
    while 0 < advance do
    begin
      Inc(X);
      if X < len then
      begin
        if cw[X+1] <> #0 then
          Dec(advance);
      end
      else if X = len then
        Dec(advance)
      else if Y < FStrings.Count -1 then
      begin
        Dec(advance);
        Inc(Y);
        X := 0;
        cw := FStrings[Y].GetWidthInfo;
        len := length(cw);
        while (X < len) and (cw[X+1] = #0) do
          Inc(X);
      end
      else begin
        X := len;
        break;
      end;
    end;

    while advance < 0 do
    begin
      if 0 < X then
      begin
        if cw[X] <> #0 then
          Inc(advance);
        Dec(X);
      end
      else if 0 < Y then
      begin
        Inc(advance);
        Dec(Y);
        cw := FStrings[Y].GetWidthInfo;
        len := length(cw);
        X := len;
      end
      else
        break;
    end;
  end;
  SetPhysicalCaret(FEditPoint);
end;

procedure THogeTextView.BeginningOfLine;
begin
  SetLogicalCaret(0, FLogicalCaret.Y);
end;

procedure THogeTextView.EndOfLine;
begin
  SetLogicalCaret(High(integer), FLogicalCaret.Y);
end;

procedure THogeTextView.BeginningOfBuffer;
begin
  SetLogicalCaret(0, 0);
end;

procedure THogeTextView.EndOfBuffer;
begin
  SetPhysicalCaret(High(integer), FStrings.Count -1);
  if Assigned(FOnScrollEnd) then FOnScrollEnd(self);
end;

procedure THogeTextView.ScrollLine(advance: integer);
var
  i :Integer;
  Delta: Integer;
  Pixel: Integer;
  PixelMod: Integer;
  ModDelta: Integer;
  tFrames: Integer;

  bs: Integer;

  Wait: Cardinal;
  DoWait: Boolean;
begin
  if Abs(advance) + FVerticalCaretMargin >= VisibleLines then
    tFrames := 1
  else
    tFrames := FFrames;

  bs := BaselineSkip;
  Pixel := advance * bs - FFraction;

  Delta := Pixel div tFrames;
  PixelMod := Abs(Pixel mod tFrames);

  if advance >= 0 then
    ModDelta := 1
  else
    ModDelta := -1;

  if Delta = 0 then begin
    tFrames := PixelMod;
    Delta := ModDelta;
    PixelMod := 0;
  end;

  for i := 1 to tFrames do begin

    Wait := timeGetTime;
    DoWait := ((High(Cardinal) - FWaitTime * 10) > Wait) and (tFrames > 1);

    if i <= PixelMod then
      ScrollPixel(Delta + ModDelta)
    else
      ScrollPixel(Delta);
    {aiai}
    if not FCaretScrollSync then
      SetLogicalCaret(FLogicalCaret, hscDONTSCROLL)
    else
    {/aiai}
      SetLogicalCaret(FLogicalCaret);
    if i < tFrames then
      Update;

    if DoWait then begin
      Wait := Wait + FWaitTime;
      while Wait > timeGetTime + SleepMinimumResolution do
        Sleep(1);
      while Wait > timeGetTime do;
    end;
  end;
end;

{beginner}
procedure THogeTextView.ScrollPixel(advance: integer);
var
  bs: Integer;
  TopPixel: Integer;
  ScreenCurretLine: Integer;
begin
  bs := BaselineSkip;
  ScreenCurretLine := LogicalCaret.Y - FLogicalTopLine;

  TopPixel := FLogicalTopLine * bs + FFraction;
  Inc(TopPixel, advance);
  if TopPixel < 0 then
    TopPixel := 0
  else if TopPixel > TopForBottom * bs then
    TopPixel := TopForBottom * bs;

  FLogicalTopLine := TopPixel div bs;
  FFraction := TopPixel mod bs;
  if FCaretScrollSync then  //aiai
    FLogicalCaret.Y := FLogicalTopLine + ScreenCurretLine;

  ModifyLogicalLine(FLogicalTopLine, FTopLine, FTopLineOffset);
  UpdateBottomLine;
  if FCaretScrollSync then //aiai
    FLogicalCaret.X := FCaretSavedX;
  SetLogicalCaret(FLogicalCaret, hscDONTSCROLL);
  Invalidate;
end;
{/beginner}

procedure THogeTextView.PageDown;
begin
  ScrollLine(VisibleLines - GetMargin);
  AnalyzeScrollInfo;
end;

procedure THogeTextView.PageUp;
begin
  ScrollLine(GetMargin - VisibleLines);
end;

procedure THogeTextView.SetTop(line: integer);
begin
  Inc(FLogicalCaret.Y, line - FLogicalTopLine);
  FLogicalTopLine := line;
  SetLogicalCaret(FCaretSavedX, FLogicalCaret.Y, hscDONTSAVEX);
  Invalidate;
end;

procedure THogeTextView.UpdateScrollInfo(redraw: Boolean);
var
  si: SCROLLINFO;
begin
  si.cbSize := sizeof(si);
  si.fMask  := SIF_PAGE or SIF_RANGE or SIF_POS;
  si.nMin   := 0;
  si.nMax   := FStrings.GetLogicalLines - 1;
  si.nPage  := VisibleLines - 1;
  SetScrollInfo(Handle, SB_VERT, si, false);
  SetScrollPos(Handle, SB_VERT, FLogicalTopLine, redraw);
end;

procedure THogeTextView.CreateWnd;
begin
  inherited;
  FTrackMouseEvent.hwndTrack := Handle;
end;

procedure THogeTextView.ON_WM_CREATE(var msg: TMsg);
var
  si: SCROLLINFO;  //aiai
begin
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_CLIENTEDGE);
  ShowScrollBar(Handle, SB_VERT, True);
  {aiai} //スクロールバーを再描画する
  zeromemory(@si, sizeof(si));
  si.cbSize := sizeof(si);
  SetScrollInfo(Handle, SB_VERT, si, True);
  {/aiai}
  FEditPoint.X := 0;
  FEditPoint.Y := 0;
  FLogicalCaret.X := 0;
  FLogicalCaret.Y := 0;
  FCaretSavedX := 0;
end;

function THogeTextView.GetHoverTime: Cardinal;
begin
  Result := FTrackMouseEvent.dwHoverTime;
end;

procedure THogeTextView.SetHoverTime(Value: Cardinal);
begin
  FTrackMouseEvent.dwHoverTime := Value;
  if FTrackMouseEvent.dwHoverTime = 0 then
    FTrackMouseEvent.dwFlags := TME_LEAVE
  else
    FTrackMouseEvent.dwFlags := TME_LEAVE or TME_HOVER;
  if HandleAllocated then
    _TrackMouseEvent(@FTrackMouseEvent);
end;

procedure THogeTextView.ON_WM_GETDLGCODE(var msg: TMessage);
begin
  msg.Result := DLGC_WANTARROWS or DLGC_WANTALLKEYS (* or DLGC_WANTTAB *);
end;

procedure THogeTextView.ON_WM_SIZE(var msg: TMessage);
begin
  DoSize(msg.LParamLo, msg.LParamHi);
end;

procedure THogeTextView.DoSize(newWidth, newHeight: Integer);
var
  off: integer;
  vl: integer;
begin
  UpdateVisibleLines;
  off := (FLogicalCaret.Y - FLogicalTopLine);
  FWidth  := newWidth;
  FHeight := newHeight;
  InvalidateSize;

  FLogicalCaret := PhysicalToLogical(FEditPoint);
  vl := VisibleLines;
  if vl <= off then
    off := vl -1;
  if off < 0 then
    off := 0;
  FLogicalTopLine := FLogicalCaret.Y - off;
  vl := TopForBottom;
  if (vl < FLogicalTopLine) then
    FLogicalTopLine := vl;
  ModifyLogicalLine(FLogicalTopLine, FTopLine, FTopLineOffset);
  UpdateBottomLine;
  UpdateScreenCaret;
end;

procedure THogeTextView.ON_WM_SETFOCUS(var msg: TMsg);
begin
  {$IFDEF IBEAM}
  FOwnCaret := CreateCaret(Handle, 0, 1, Abs(Font.Height));
  {$ELSE}
  FOwnCaret := CreateCaret(Handle, 0, Abs(Font.Height) div 3 + 1, Abs(Font.Height));
  {$ENDIF}
  if FOwnCaret then
  begin
    SetCaretPos(FCaretPos.x, FCaretPos.y);
    if FCaretVisible and FConfCaretVisible then
      ShowCaret(Handle);
  end;
end;

procedure THogeTextView.ON_WM_KILLFOCUS(var msg: TMsg);
begin
  AutoScroll := False; //beginner
  if FCaretVisible then
    HideCaret(Handle);
  DestroyCaret;
  FOwnCaret := False;
end;

procedure THogeTextView.ON_WM_MOUSEACTIVATE(var msg: TWMMouse);
begin
  try
    Windows.SetFocus(Handle);
  except
  end;
end;


procedure THogeTextView.MouseDown(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  case Button of
  mbLeft:
    {beginner}
    if AutoScroll then begin
        AutoScroll := False;
    end else
    {/beginner}
    begin
      if ssDouble in Shift then
        SelectWord(ClientToPhysicalCharPos(X, Y))
      else
      {aiai}
      if ssShift in Shift then begin
        if not FSelecting then
          FSelStart := FEditPoint;
        SetLogicalCaret(ClientToLogical(X, Y), hscDONTSCROLL);
        FDragging  := True;
        CaretVisible(True);
      end else
      {/aiai}
      begin
        SetLogicalCaret(ClientToLogical(X, Y), hscDONTSCROLL);
        FSelStart := FEditPoint;
        SetSelecting(True);
        FDragging  := True;
        CaretVisible(True);
      end;
    end;
  mbRight:
    {beginner}
    if autoscroll then begin
      AutoScroll := False;
    end else
    {/beginner}
    if (not Selecting) or
       ((FSelStart.X = FEditPoint.X) and (FSelStart.Y = FEditPoint.Y)) then
    begin
      SetLogicalCaret(ClientToLogical(X, Y), hscDONTSCROLL);
      FSelStart := FEditPoint;
      SetSelecting(False);
      FDragging  := False;
      CaretVisible(True);
    end;
  mbMiddle: AutoScroll := not AutoScroll and FEnableAutoScroll;  //beginner
  end;
  inherited;
end;

{beginner}

function THogeTextView.GetAutoScroll: Boolean;
begin
  Result := (ASCursorOrigin.X <> ASCursorNon.X) or (ASCursorOrigin.Y <> ASCursorNon.Y);
end;

procedure THogeTextView.SetAutoScroll(Scroll: Boolean);
begin
  if Scroll <> AutoScroll then begin
    if Scroll then begin
      ASCursorOrigin := ScreenToClient(Mouse.CursorPos);
      Cursor := crSizeNS;
    end else begin
      ASCursorOrigin := ASCursorNon;
    end;
    Timer.Enabled := Scroll;
    MouseCapture := Scroll;
    Refresh;
  end;
end;

{/beginner}

procedure THogeTextView.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                X, Y: Integer);
begin
  case Button of
  mbLeft:
    begin
      FDragging := False;
    end;
  end;
  inherited;
end;

procedure THogeTextView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if not FTracking then
  begin
    _TrackMouseEvent(@FTrackMouseEvent);
    FTracking := True;
    if not FIsMouseIn then
    begin
      MouseEnter;
      FIsMouseIn := True;
    end;
  end;
  if not FSelecting then
    FDragging := False;
  if FDragging then
  begin
    SetLogicalCaret(ClientToLogical(X, Y));
  end;
  inherited;
end;

procedure THogeTextView.MouseEnter;
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure THogeTextView.ON_WM_MOUSEWHEEL(var msg: TMessage);
begin
  AutoScroll := False; //beginner
  {beginner} //後ろから移動
  {aiai}
  if FCaretScrollSync then
  begin
    SetSelecting(False);
    CaretVisible(False);
  end else
    CaretVisible(True);
  {/aiai}
  {/beginner}
  if FWheelPageScroll then
  case (msg.WParam < 0) of
    true:  PageDown;
    false: PageUp;
  end else
  begin
    ScrollLine(-FVScrollLines * SmallInt(HIWORD(msg.wParam)) div WHEEL_DELTA);
    if (msg.wParam < 0) then
      AnalyzeScrollInfo;
  end;
  msg.Result := 1;
{
  SetSelecting(False);
  CaretVisible(False);
}
end;

procedure THogeTextView.WmMouseHover(var Message: TMessage);
begin
  MouseHover;
  FTracking := False;
end;

procedure THogeTextView.WmMouseLeave(var Message: TMessage);
begin
  MouseLeave;
  FTracking := False;
  FIsMouseIn := False;
end;

procedure THogeTextView.MouseHover;
var
  Point: TPoint;
  Shift: TShiftState;
begin
  if Assigned(FOnMouseHover) then
  begin
    Point := ScreenToClient(Mouse.CursorPos);
    Shift := [];
    if GetKeyState(VK_SHIFT) < 0 then Include(Shift, ssShift);
    if GetKeyState(VK_CONTROL) < 0 then Include(Shift, ssCtrl);
    if GetKeyState(VK_LBUTTON) < 0 then Include(Shift, ssLeft);
    if GetKeyState(VK_RBUTTON) < 0 then Include(Shift, ssRight);
    if GetKeyState(VK_MBUTTON) < 0 then Include(Shift, ssMiddle);
    if GetKeyState(VK_MENU) < 0 then Include(Shift, ssAlt);
    FOnMouseHover(Self, Shift,  Point.X, Point.Y);
  end;
end;

procedure THogeTextView.MouseLeave;
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure THogeTextView.KeyDown(var Key: Word; Shift: TShiftState);
  procedure ProcSelection;
  begin
    if not (ssShift in Shift) then
      SetSelecting(False)
    else if not FSelecting then
    begin
      SetSelecting(True);
      FSelStart := FEditPoint;
    end;
  end;
begin
  AutoScroll := False; //beginner
  CaretVisible(True);
  inherited KeyDown(Key, Shift);
  if Key = 0 then
    exit;
  case Key of
  VK_DELETE, VK_INSERT:
    begin
      SetConfCaretVisible(not FConfCaretVisible);
      Key := 0;
    end;
  VK_DOWN:
    begin
      ProcSelection;
      if not FConfCaretVisible or (ssCtrl in Shift) then
      begin
        ScrollLine(FVScrollLines); //521
        AnalyzeScrollInfo;
      end
      else
        ForwardLine(1);
      Key := 0;
    end;
  VK_UP:
    begin
      ProcSelection;
      if not FConfCaretVisible or (ssCtrl in Shift) then
        ScrollLine(-FVScrollLines) //521
      else
        ForwardLine(-1);
      Key := 0;
    end;
  VK_RIGHT: begin ProcSelection; ForwardChar(1);  Key := 0; end;
  VK_LEFT:  begin ProcSelection; ForwardChar(-1); Key := 0; end;
  VK_NEXT:  begin ProcSelection; PageDown;        Key := 0; end;
  VK_PRIOR: begin ProcSelection; PageUp;          Key := 0; end;
  VK_HOME:
    begin
      ProcSelection;
      if (ssCtrl in Shift) or not FConfCaretVisible then
        BeginningOfBuffer
      else
        BeginningOfLine;
      Key := 0;
    end;
  VK_END:
    begin
      ProcSelection;
      if (ssCtrl in Shift) or not FConfCaretVisible then
        EndOfBuffer
      else
        EndOfLine;
      Key := 0;
    end;
  Ord('A'):
    begin
      BeginningOfBuffer;
      SetMarkCommand;
      EndOfBuffer;
      Selecting := True;
    end;
  Ord('C'):
    begin
      if ssCtrl in Shift then
      begin
        CopySelection;
        Key := 0;
      end;
    end;
  end;
end;


{beginner}
procedure THogeTextView.TimerOnTimer(Sender: TObject);
const
  IntervalParam = 1000;
var
  Speed: Integer;
  Pitch: Integer;
  Wait: Cardinal;
begin
  Speed := ScreenToClient(Mouse.CursorPos).Y - ASCursorOrigin.Y;

  if Abs(Speed) <= 10 then Exit;
  if Speed > 0 then
    Speed := Speed - 8
  else
    Speed := Speed + 8;

  Speed := Speed * Abs(Speed);
  Inc(ASCounter);
  if Speed = 0 then begin
    Exit;
  end else begin
    if FCaretScrollSync then //aiai
      FSelecting := False;
    if Abs(Speed) <= IntervalParam then begin
      Pitch := IntervalParam div Speed;
      if ASCounter >= Abs(Pitch) then begin
        ASCounter := 0;
        if Speed > 0 then
          ScrollPixel(1)
        else
          ScrollPixel(-1);
      end;
    end else begin
      ASCounter := 0;
      Speed := Speed div IntervalParam;
      if Abs(Speed div BaselineSkip) <= 2 then begin
        ScrollPixel(Speed);
      end else begin
        if Speed > 0 then
          ScrollLine(VisibleLines - GetMargin)
        else
          ScrollLine(GetMargin - FVisibleLines);

        Wait := timeGetTime;
        if ((High(Cardinal) - FWaitTime * 5) > Wait) then begin
          Wait := Wait + FWaitTime div 2;
          while Wait > timeGetTime + SleepMinimumResolution do
            Sleep(1);
          while Wait > timeGetTime do;
        end;
      end;
    end;
  end;
end;
{/beginner}


procedure THogeTextView.ON_WM_HSCROLL(var msg: TMessage);
begin
  if not FDragging then
    SetSelecting(False);
  CaretVisible(False);
end;

procedure THogeTextView.ON_WM_VSCROLL(var msg: TMessage);
  procedure ScrollLine2(advance: Integer);
  var
    i :Integer;
    Delta: Integer;
    Pixel: Integer;
    PixelMod: Integer;
    ModDelta: Integer;
    tFrames: Integer;

    bs: Integer;

    Wait: Cardinal;
    DoWait: Boolean;
  begin
    tFrames := 1;

    bs := BaselineSkip;
    Pixel := advance * bs - FFraction;

    Delta := Pixel div tFrames;
    PixelMod := Abs(Pixel mod tFrames);

    if advance >= 0 then
      ModDelta := 1
    else
      ModDelta := -1;

    if Delta = 0 then begin
      tFrames := PixelMod;
      Delta := ModDelta;
      PixelMod := 0;
    end;

    for i := 1 to tFrames do begin

      Wait := timeGetTime;
      DoWait := ((High(Cardinal) - FWaitTime * 10) > Wait) and (tFrames > 1);

      if i <= PixelMod then
        ScrollPixel(Delta + ModDelta)
      else
        ScrollPixel(Delta);
      SetLogicalCaret(FLogicalCaret, hscDONTSCROLL);
      if i < tFrames then
        Update;

      if DoWait then begin
        Wait := Wait + FWaitTime;
        while Wait > timeGetTime + SleepMinimumResolution do
          Sleep(1);
        while Wait > timeGetTime do;
      end;
    end;
  end;

var
  si: SCROLLINFO;
begin
  {aiai}
  //if not FDragging then
  //  SetSelecting(False);
  if not FDragging and FCaretScrollSync then
    SetSelecting(False);
  {/aiai}
  case msg.WParamLo of
  SB_TOP:      BeginningOfBuffer;
  SB_BOTTOM:   EndOfBuffer;
  SB_LINEDOWN:
    begin
      ScrollLine(FVScrollLines);
      AnalyzeScrollInfo;
    end;
  SB_LINEUP:   ScrollLine(-FVScrollLines);
  SB_PAGEDOWN: PageDown;
  SB_PAGEUP:   PageUp;
  SB_THUMBPOSITION,
  SB_THUMBTRACK:
    begin
      {beginner} //32bit Scroll
      si.cbSize := sizeof(si);
      si.fMask  := SIF_TRACKPOS;
      GetScrollInfo(Handle, SB_VERT, si);
      {aiai}
      if not FCaretScrollSync then
        ScrollLine2(si.nTrackPos - FLogicalTopLine)
      else
      {/aiai}
        SetTop(si.nTrackPos);
      {/beginner}
      AnalyzeScrollInfo;
    end;
  //SB_ENDSCROLL:
  end;
  msg.Result := 1;
  {aiai}
  //CaretVisible(False);
  CaretVisible(not FCaretScrollSync);
  {/aiai}
end;

procedure THogeTextView.ON_WM_PAINT(var msg: TWMPaint);
begin
  PaintHandler(msg);
end;

function THogeTextView.RangeVisible(startPos, endPos: TPoint): Boolean;
var
  vLines: Integer;
begin
  result := False;
  endPos   := PhysicalToLogical(endPos);
  if endPos.Y < FLogicalTopLine then
    exit;
  startPos := PhysicalToLogical(startPos);
  vLines := VisibleLines;
  if FLogicalTopLine + vLines <= startPos.Y then
    exit;
  result := True;
end;

function THogeTextView.InSelection(X, Y: integer): Boolean;
var
  rect: TRect;
begin
  result := False;
  if not FSelecting then
    exit;
  rect := NormalizeMinMax(FEditPoint, FSelStart);
  if Y < rect.Top then
    exit;
  if rect.Bottom < Y then
    exit;
  if (Y = rect.Top) and (X < rect.Left) then
    exit;
  if (Y = rect.Bottom) and (rect.Right <= X) then
    exit;
  result := True;
end;

//aiai
procedure THogeTextView.DrawBorder(X1, X2, Y: Integer; Color: TColor; Custom: Boolean);
begin
  With FBitmap.Canvas do
  begin
    if Custom then
    begin
      Pen.Color := Color;
      MoveTo(X1, Y);
      LineTo(X2, Y);
      MoveTo(X1, Y + 1);
      LineTo(X2, Y + 1);
    end else
    begin
      MoveTo(X1, Y + 1);
      Pen.Color := clBtnShadow;
      LineTo(X1, Y - 1);  //上へ
      LineTo(X2, Y - 1);  //右へ
      Pen.Color := clWhite;
      LineTo(X2, Y + 1);  //下へ
      LineTo(X1, Y + 1);  //左へ
    end;
  end;

end;

procedure THogeTextView.PaintWindow(DC: HDC);
{aiai}
type
  hlightrange = record   //1ベースインデックス
    startp: Integer;
    endp: Integer;
  end;
var
  len: integer;
  HighlightP: Boolean;
  hlightl: array of hlightrange;

  procedure SetNumberColor(item: THogeTVItem; startPos: integer);
  var
    ResNum, endPos: Integer;
  begin
    endPos := startPos + 5;
    while (Ord(item.FAttrib[endPos]) and htvVMASK = htvHIDDEN)
              and (endpos <= len) do
      Inc(endPos);
    if endPos > len then
      exit;
    ResNum := StrToIntDef(Copy(item.FText, startPos + 5, endPos - startPos - 5), 9999);
    if (ResNum <= Length(ResNumArray)) and ResNumArray[ResNum - 1] then
      FBitmap.Canvas.Font.Color := FLinkedNumColor;
  end;

  procedure SetIDColor(item: THogeTVItem; startPos: Integer);
  var
    endPos, IDFreq, ListCount, index, startPos2: Integer;
    item2: THogeTVItem;
    idp, idp2: PChar;
  begin
    endPos := startPos + 3;
    while (Ord(item.FAttrib[endPos]) and htvVMASK = htvHIDDEN)
           and (endpos <= len) do
      Inc(endPos);
    if endpos > len then
      exit;
    IDFreq := 0;
    ListCount := Length(FIDListArray);
    idp  := @item.FText[startPos + 3];
    for index := 0 to  ListCount - 1 do
    begin
      if not FIDListArray[index].bool then
        Continue;
      item2 := FIDListArray[index].Item;
      startPos2 := FIDListArray[index].Position;
      idp2 := @item2.FText[startPos2 + 3];
      if (0 = StrLComp(idp, idp2, endPos - startPos)) then
        Inc(IDFreq);
    end;
    if IDFreq = 1 then
      FBitmap.Canvas.Font.Color := FIDLinkColorNone
    else if IDFreq >= FIDLinkThreshold then
      FBitmap.Canvas.Font.Color := FIDLinkColorMany;
  end;


  procedure CreateHLightList(str: String);
  var
    sp, tlen, lsize: Integer;
  begin
    SetLength(hlightl, 0);
    lsize := 0;
    tlen := Length(FHighlightTarget);
    if tlen = 0 then exit;
    sp := 0;
    while sp <= len - tlen do
    begin
      if 0 <> StrLIComp(PChar(FHighlightTarget), PChar(str) + sp, tlen) then
      begin
        Inc(sp);
        Continue;
      end;
      Inc(lsize);
      SetLength(hlightl, lsize);
      hlightl[lsize - 1].startp := sp + 1;
      Inc(sp, tlen);
      hlightl[lsize - 1].endp := sp;
    end;
  end;

  function InHighlight(str: String; index: integer): Boolean;
  var
    p, lsize: integer;
  begin
    Result := False;
    lsize := Length(hlightl);
    for p := 0 to lsize - 1 do
    begin
      if (hlightl[p].startp <= index) and (index <= hlightl[p].endp) then
      begin
        Result := True;
        break;
      end;
    end;
  end;
{/aiai}

var
  screenLine, vLines: Integer;
  bs: Integer;
  X, Y: integer;
  width, maxX: Integer;
  index: Integer;
  point: TPoint;
  attrib, cw: AnsiString;
  item: THogeTVItem;
  next: integer;
  attCode: integer;
  selectionP: boolean;
  nchar: integer;
  physicalLine: integer;
  ws: WideString;
  Triangle: array[0..2] of TPoint;
  position: integer;
  WalX, WalY: Integer;
  PictY: Integer;
  PictArray: array of Integer;
  PictCount: Integer;
label
  DONE;
begin
  FBitmap.Width := FWidth;
  FBitmap.Height := FHeight;

  FBitmap.Canvas.Brush := Brush;
  FBitmap.Canvas.Font   := Font;
  FBitmap.Canvas.FillRect(ClientRect);

  //改造▽ 修正 (スレビューに壁紙を設定する。Doe用)
  if Assigned(FWallpaper) and not FWallpaper.Empty then
  begin
    Case FWallpaperVAlign of
      walVTop:    walY := 0;
      walVCenter: walY := (ClientHeight - FWallpaper.Height) div 2;
      walVBottom: walY := ClientHeight - FWallpaper.Height;
      else        walY := 0;
    end;  //Case
    Case FWallpaperHAlign of
      walHLeft:   walX := 0;
      walHCenter: walX := (ClientWidth - FWallpaper.Width) div 2;
      walHRight:  walX := ClientWidth - FWallpaper.Width;
      else        walX := 0;
    end;  //Case
    FBitmap.Canvas.Draw(walX, walY, FWallpaper);
  end;
  //改造△ 修正 (スレビューに壁紙を設定する。Doe用)

  bs := BaselineSkip;
  if FLogicalTopLine < TopForBottom then
    vLines := VisibleLines + 1
  else
    vLines := VisibleLines;
  physicalLine := FTopLine;
  item := FStrings[physicalLine];
  point.X := 0;
  point.Y := FTopLineOffset;
  index := item.LogicalPosToIndex(point);
  cw := item.GetWidthInfo;
  attrib := item.FAttrib;
  len := length(cw);
  screenLine := 0;
  maxX := ClientWidth - FRightMargin;
  //{aiai}
  //if (FMaxWidth > 0) and (FMaxWidth < maxX) then
  //  maxX := FMaxWidth;
  //{/aiai}

  X := FLeftMargin + item.OffsetLeft;
  Y := FTopMargin - FFraction; //beginner

  nchar := 0;

  SetLength(PictArray, 0);
  while screenLine < vLines do
  begin
    {aiai}
    if item.PictLine and Assigned(item.Picture) then
    begin
      PictY := Y - item.PictPos * bs;
      PictCount := Length(PictArray);
      if (PictCount > 0) then
      begin
        if PictArray[PictCount - 1] < PictY then
        begin
          SetLength(PictArray, PictCount + 1);
          PictArray[PictCount] := PictY;
          FBitmap.Canvas.Draw(FLeftMargin, PictY, item.Picture);
        end;
      end else
      begin
        SetLength(PictArray, 1);
        PictArray[0] := PictY;
        FBitmap.Canvas.Draw(FLeftMargin, PictY, item.Picture);
      end;
    end;

    //検索ハイライト
    CreateHLightList(item.FText);
    {/aiai}
    while index <= len do
    begin
      attCode := Ord(attrib[index]);
      if attCode and htvVMASK = htvVISIBLE then
      begin
        width := Ord(cw[index]);
        if (maxX < X + width) and (0 < nchar) then
        begin
          Inc(screenLine);
          if vLines <= screenLine then
            goto DONE;
          X := FLeftMargin + item.OffsetLeft;
          Inc(Y, bs);
          nchar := 0;
        end;
        Inc(nchar);
        selectionP := InSelection(index -1, physicalLine);
        HighlightP := InHighlight(item.FText, index);
        next := index + 1;
        while next <= len do
        begin
          if Ord(attrib[next]) <> attCode then
            break;
          if cw[next] <> #0 then
          begin
            if InSelection(next -1, physicalLine) <> selectionP then
              break;
            if InHighlight(item.FText, next) <> HighlightP then
              break;
            if (maxX < (X + width + Ord(cw[next]))) then
              break;
          end;
          Inc(width, Ord(cw[next]));
          Inc(next);
        end;
        with TextAttrib[attCode and htvATTMASK] do
        begin
          if selectionP then
          begin
            if FBitmap.Canvas.Font.Color <> clHighlightText then
              FBitmap.Canvas.Font.Color := clHighlightText;
            if FBitmap.Canvas.Brush.Color <> clHighlight then
              FBitmap.Canvas.Brush.Color := clHighlight;
            if FBitmap.Canvas.Font.Style <> style then
              FBitmap.Canvas.Font.Style := style;
          end
          else if HighlightP then
          begin
            if FBitmap.Canvas.Font.Color <> color then
              FBitmap.Canvas.Font.Color := color;
            if FBitmap.Canvas.Brush.Color <> FKeywordBrushColor then
              FBitmap.Canvas.Brush.Color := FKeywordBrushColor;
            if FBitmap.Canvas.Font.Style <> style then
              FBitmap.Canvas.Font.Style := style;
          end
          else begin
            if FBitmap.Canvas.Font.Color <> color then
              FBitmap.Canvas.Font.Color := color;
            if FBitmap.Canvas.Brush.Style <> bsClear then
               FBitmap.Canvas.Brush.Style := bsClear;
            if FBitmap.Canvas.Font.Style <> style then
              FBitmap.Canvas.Font.Style := style;
          end;
          //if FBitmap.Canvas.Font.Style <> style then
          //  FBitmap.Canvas.Font.Style := style;
        end;
        if attCode and htvCODEMASK = htvASCII then
        begin   //aiai
          if not SelectionP and (attCode and htvATTMASK in [2..3]) then
          begin
            if FColordNumber then
            begin
              position := Pos('menu:', item.FText);
              if (position > 0) and ((position - index) in [0..4])
                      and (Ord(attrib[position]) and htvVMASK = htvHIDDEN) then
                SetNumberColor(item, position);
            end;
            if CanRepain and FIDLinkColor then
            begin
              position := Pos('ID:ID:', item.FText);
              if (position > 0) and ((index - position) in [0..2])
                  and (Ord(attrib[position+3]) and htvVMASK = htvHIDDEN) then
                SetIDColor(item, position+3);
            end;
          end;
          Windows.TextOutA(FBitmap.Canvas.Handle, X, Y, @item.FText[index], next - index);
        end
        else begin
          SetLength(ws, (next - index) div 2);
          Move(item.FText[index], ws[1], next - index);
          Windows.TextOutW(FBitmap.Canvas.Handle , X, Y,
                           @ws[1], (next - index) div 2);
        end;
        Inc(X, width);
        index := next;
      end else
        Inc(index);
    end;
    {aiai}
    if item.BorderLine then
      DrawBorder(FLeftMargin + item.OffsetLeft,
                 MaxX,
                 Y + bs div 2,
                 item.BorderColor,
                 item.BorderCustom);
    {/aiai}
    Inc(screenLine);
    if vLines <= screenLine then
      break;
    Inc(physicalLine);
    if FStrings.Count <= physicalLine then
      break;
    Inc(Y, bs);
    item := FStrings[physicalLine];
    X := FLeftMargin + item.OffsetLeft;
    index := 1;
    attrib := item.FAttrib;
    len := length(attrib);
    cw := item.GetWidthInfo;
  end;
DONE:
  if (ASCursorOrigin.X <> ASCursorNon.X) or (ASCursorOrigin.Y <> ASCursorNon.Y) then begin
    FBitmap.Canvas.Pen.Color := clBlack;
    FBitmap.Canvas.Brush.Color := clWhite;
    FBitmap.Canvas.Ellipse(ASCursorOrigin.X - 14,
                           ASCursorOrigin.Y - 14,
                           ASCursorOrigin.X + 14,
                           ASCursorOrigin.Y + 14);

    FBitmap.Canvas.Brush.Color := clBlue;
    Triangle[0].X := ASCursorOrigin.X;
    Triangle[0].Y := ASCursorOrigin.Y - 10;
    Triangle[1].X := ASCursorOrigin.X - 3;
    Triangle[1].Y := ASCursorOrigin.Y - 7;
    Triangle[2].X := ASCursorOrigin.X + 3;
    Triangle[2].Y := ASCursorOrigin.Y - 7;
    FBitmap.Canvas.Polygon(Triangle);

    Triangle[0].X := ASCursorOrigin.X;
    Triangle[0].Y := ASCursorOrigin.Y + 9;
    Triangle[1].X := ASCursorOrigin.X + 3;
    Triangle[1].Y := ASCursorOrigin.Y + 6;
    Triangle[2].X := ASCursorOrigin.X - 3;
    Triangle[2].Y := ASCursorOrigin.Y + 6;
    FBitmap.Canvas.Polygon(Triangle);

  end;
  Canvas.CopyRect(ClientRect, FBitmap.Canvas, ClientRect);
  FBitmap.Width := 0;
  FBitmap.Height := 0;
  UpdateScrollInfo;
end;


procedure THogeTextView.LineUpdated(startLine, endLine: Integer);
begin
  if (startLine <= FTopLine + VisibleLines) and (FTopLine <= endLine) then
    Repaint;
end;

function THogeTextView.RegionToText(point1, point2: TPoint): string;
var
  region: TRect;
  Y, startPos, endPos: integer;
  txt, attr: AnsiString;
  i, code: integer;
  attCode: Integer;
  Position, Size: Integer;
  s: string;
begin
  region := NormalizeMinMax(FSelStart, FEditPoint);
  Size := 0;
  (* calculate size *)
  for Y := region.Top to region.Bottom do
  begin
    if FStrings.Count <= Y then
      break;
    if 0 < Size then
      Inc(Size, 2);
    txt := FStrings[Y].FText;
    attr:= FStrings[Y].FAttrib;
    if Y = region.Top then
      startPos := region.Left + 1
    else
      startPos := 1;
    if region.Bottom <= Y then
      endPos := region.Right
    else
      endPos := length(txt);
    i := startPos;
    while i <= endPos do
    begin
      attCode := Ord(attr[i]);
      if attCode and htvVMASK = htvHIDDEN then
      begin
        if startPos < i then
          Inc(Size, i - startPos);
        startPos := i + 1;
      end
      else if (attCode and htvCODEMASK) = htvUNICODE then
      begin
        if startPos < i then
          Inc(Size, i - startPos);
        code := Ord(txt[i]) + Ord(txt[i+1]) * 256;
        Inc(Size, Length('&#' + IntToStr(code) + ';'));
        startPos := i + 2;
        Inc(i);
      end;
      Inc(i);
    end;
    Inc(Size, endPos - startPos + 1);
  end;

  SetLength(result, Size);
  Position := 1;
  for Y := region.Top to region.Bottom do
  begin
    if FStrings.Count <= Y then
      break;
    if 1 < Position then
    begin
      Move(#13#10[1], result[Position], 2);
      Inc(Position, 2);
    end;
    txt := FStrings[Y].FText;
    attr:= FStrings[Y].FAttrib;
    if Y = region.Top then
      startPos := region.Left + 1
    else
      startPos := 1;
    if region.Bottom <= Y then
      endPos := region.Right
    else
      endPos := length(txt);
    i := startPos;
    while i <= endPos do
    begin
      attCode := Ord(attr[i]);
      if attCode and htvVMASK = htvHIDDEN then
      begin
        if startPos < i then
        begin
          Move(txt[startPos], result[Position], i - startPos);
          Inc(Position, i - startPos);
        end;
        startPos := i + 1;
      end
      else if (attCode and htvCODEMASK) = htvUNICODE then
      begin
        if startPos < i then
        begin
          Move(txt[startPos], result[Position], i - startPos);
          Inc(Position, i - startPos);
        end;
        code := Ord(txt[i]) + Ord(txt[i+1]) * 256;
        s := '&#' + IntToStr(code) + ';';
        Move(s[1], result[Position], length(s));
        Inc(Position, length(s));
        startPos := i + 2;
        Inc(i);
      end;
      Inc(i);
    end;
    Move(txt[startPos], result[Position], endPos - startPos + 1);
    Inc(Position, endPos - startPos + 1);
  end;

end;


procedure THogeTextView.CopySelection;
var
  txt: String;
begin
  if not FSelecting then
    exit;
  txt := RegionToText(FSelStart, FEditPoint);
  Clipboard.AsText := txt;
end;

function THogeTextView.GetSelection: String;
begin
  if not FSelecting then
    exit;
  result := RegionToText(FSelStart, FEditPoint);
end;


function THogeTextView.SearchForward (const AString: String): Boolean;
var
  s: String;
  col, line: integer;
  len, endPos: integer;
  item: THogeTVItem;
  cw: AnsiString;
  target: string;
  rect: TRect;
begin
  if FSelecting then
  begin
    rect := NormalizeMinMax(FEditPoint, FSelStart);
    FSelStart := rect.TopLeft;
    FEditPoint := rect.BottomRight;
  end;
  result := False;
  len := length(AString);
  if len <= 0 then
    exit;
  FHighlightTarget := AString;
  target := AnsiUpperCase(AString);
  col := FEditPoint.X + 1;
  for line := FEditPoint.Y to FStrings.Count -1 do
  begin
    item := FStrings[line];
    s := AnsiUpperCase(item.FText);
    endPos := item.GetLength - Length(target) + 1;
    cw := item.GetWidthInfo;
    if col <= 0 then
      col := 1;
    while col <= endPos do
    begin
      if (cw[col] <> #0) and
         (Ord(item.FAttrib[col]) and htvVMASK = htvVISIBLE) and
         (StrLComp(PChar(@s[col]), PChar(target), Length(target)) = 0) then
      begin
        FSelStart.X := col -1;
        FSelStart.Y := line;
        SetPhysicalCaret(col + Length(target) - 1, line, hscSCROLLCENTER);
        SetSelecting(True);
        result := True;
        exit;
      end;
      Inc(col);
    end;
    col := 0;
  end;
end;

function THogeTextView.SearchBackward(const AString: String): Boolean;
var
  s: String;
  col, line: integer;
  len: integer;
  item: THogeTVItem;
  cw: AnsiString;
  target: String;
  rect: TRect;
begin
  if FSelecting then
  begin
    rect := NormalizeMinMax(FEditPoint, FSelStart);
    FEditPoint := rect.TopLeft;
    FSelStart := rect.BottomRight;
  end;
  result := False;
  len := length(AString);
  if len <= 0 then
    exit;
  FHighlightTarget := AString;
  target := AnsiUpperCase(AString);
  col := FEditPoint.X;
  if col <= 0 then
    line := FEditPoint.Y -1
  else
    line := FEditPoint.Y;
  for line := line downto 0 do
  begin
    item := FStrings[line];
    s := AnsiUpperCase(item.FText);
    cw := item.GetWidthInfo;
    if col <= 0 then
      col := length(cw);
    while 0 < col do
    begin
      if (cw[col] <> #0) and
         (Ord(item.FAttrib[col]) and htvVMASK = htvVISIBLE) and
         (StrLComp(PChar(@s[col]), PChar(target), Length(target)) = 0) then
      begin
        FSelStart.X := col + Length(target) - 1;
        FSelStart.Y := line;
        SetPhysicalCaret(col - 1, line, hscSCROLLCENTER);
        SetSelecting(True);
        result := True;
        exit;
      end;
      Dec(col);
    end;
    col := 0;
  end;
end;

procedure THogeTextView.SetMarkCommand;
begin
  FSelStart := FEditPoint;
end;

function THogeTextView.NormalizeMinMax(point1, point2: TPoint): TRect;
var
  tmp: integer;
begin
  if point1.Y <= point2.Y then
  begin
    result.TopLeft := point1;
    result.BottomRight := point2;
  end
  else begin
    result.TopLeft := point2;
    result.BottomRight := point1;
  end;
  if (result.Top = result.Bottom) and (result.Right < result.Left) then
  begin
    tmp := result.Left;
    result.Left := result.Right;
    result.Right := tmp;
  end;
end;



function THogeTextView.nInsert(point: TPoint;
                               pstr: PChar;
                               count: Integer;
                               attrib: Integer = 0): TPoint;
var
  item: THogeTVItem;
  startPos: integer;
  endPos: integer;     (*  *)
  len: integer;        (* 挿入する文字のバイト *)
  p: PChar;            (* 挿入する文字の先頭アドレス *)
  wp: PWideChar;       (*  *)
  org: TPoint;         (* 挿入する位置 *)
  startLine: integer;  (* 挿入する行 *)
begin
  if count <= 0 then
    exit;
  point := Normalize(point);
  org := point;                  //挿入する位置
  len := count;                  //挿入する文字のバイト
  startLine := point.Y;          //挿入する行(Logical？)
  if (attrib and htvCODEMASK) = htvASCII then
  begin
    item := FStrings[point.Y];   //挿入する行のTHogeTVItem
    p := pstr;                   //挿入する文字の先頭アドレス
    startPos := 0;
    endPos := startPos;
    while endPos < len do
    begin
      if p^ = #10 then           //改行する
      begin
        if (startPos < endPos) and ((p -1)^ = #13) then  //#13#10なら
        begin
          item.Insert(point.X + 1, pstr + startPos, endPos - startPos -1,
                      attrib);                           //#13の前までTHogeTVItemに渡す
        end
        else begin                                       //#10なら
          item.Insert(point.X + 1, pstr + startPos, endPos - startPos,
                      attrib);                           //#10の前までTHogeTVItemに渡す
        end;
        Inc(point.Y);             //次の行へ
        point.X := 0;
        item := THogeTVItem.Create(Self);
        FStrings.Insert(point.Y, item);
        startPos := endPos + 1;
      end
      else begin
        Inc(point.X);
      end;
      Inc(p);
      Inc(endPos);
    end;
    if startPos < endPos then
      item.Insert(point.X + 1, pstr + startPos, endPos - startPos,
                  attrib);
  end
  else begin
    item := FStrings[point.Y];
    wp := PWideChar(pstr);
    startPos := 0;
    endPos := startPos;
    while endPos < len do
    begin
      if wp^ = WideChar(#10) then
      begin
        if (startPos < endPos) and ((wp -1)^ = WideChar(#13)) then
        begin
          item.Insert(point.X + 1, pstr + startPos, endPos - startPos -2,
                      attrib);
        end
        else begin
          item.Insert(point.X + 1, pstr + startPos, endPos - startPos,
                      attrib);
        end;
        Inc(point.Y);
        point.X := 0;
        item := THogeTVItem.Create(Self);
        FStrings.Insert(point.Y, item);
        startPos := endPos + 2;
      end
      else begin
        Inc(point.X, 2);
      end;
      Inc(wp);
      Inc(endPos, 2);
    end;
    if startPos < endPos then
      item.Insert(point.X + 1, pstr + startPos, endPos - startPos,
                  attrib);
  end;
  if (startLine <= FBottomLine) and (FTopLine <= point.Y) then
    Invalidate;
  result := point;
end;

function THogeTextView.Insert(point: TPoint;
                              const AString: string;
                              attrib: Integer = 0): TPoint;
begin
  result := nInsert(point, @AString[1], length(AString), attrib);
end;

function THogeTextView.nAppend(pstr: PChar;
                               count: Integer;
                               attrib: Integer = 0): TPoint;
var
  point: TPoint;
begin
  point.Y := FStrings.Count -1;
  point.X := length(FStrings[point.Y].FText);
  result := nInsert(point, pstr, count, attrib);
end;


function THogeTextView.Append(const AString: string;
                              attrib: Integer = 0): TPoint;
begin
  result := nAppend(@AString[1], length(AString), attrib);
end;

{aiai}
function THogeTextView.AppendPicture(Image: TGraphic;
    overlap: Boolean): Boolean;
var
  Point: TPoint;
  item: THogeTVItem;
  attrib, cw: AnsiString;
  linecount, bs, len, i, attCode: Integer;
begin
  Result := False;
  if Image = nil then
    exit;
  bs := BaseLineSkip;
  linecount := Image.Height div bs + 1;

  Point.Y := FStrings.Count - 1;
  item := FStrings[Point.Y];

  if overlap then
  begin
    item.PictLine := True;
    item.PictPos := 0;
    item.Picture := Image;
    Result := True;
    exit;
  end;

  attrib := item.FAttrib;
  cw := item.GetWidthInfo;
  len := Length(cw);
  for i := 1 to len do
  begin
    attCode := Ord(attrib[i]);
    if attCode and htvVMASK = htvVISIBLE then
    begin
      item := THogeTVItem.Create(Self);
      FStrings.Add(item);
      break;
    end;
  end;

  item.PictLine := True;
  item.PictPos := 0;
  item.Picture := Image;

  for i := 1 to linecount do
  begin
    item := THogeTVItem.Create(Self);
    FStrings.Add(item);
    item.PictLine := True;
    item.PictPos := i;
    item.Picture := Image;
  end;
  Result := True;
end;

procedure THogeTextView.AppendHR(Color: TColor;
  Custom: Boolean; OffsetLeft: Integer);
var
  Point: TPoint;
  item: THogeTVItem;
  attrib, cw: AnsiString;
  len, i, attCode: Integer;
begin
  Point.Y := FStrings.Count - 1;
  item := FStrings[Point.Y];
  attrib := item.FAttrib;
  cw := item.GetWidthInfo;
  len := Length(cw);
  for i := 1 to len do
  begin
    attCode := Ord(attrib[i]);
    if attCode and htvVMASK = htvVISIBLE then
    begin
      item := THogeTVItem.Create(Self);
      item.FOffsetLeft := OffsetLeft;
      FStrings.Add(item);
      break;
    end;
  end;
  item.BorderLine := True;
  if Custom then
  begin
    item.BorderCustom := True;
    item.BorderColor := Color
  end else
    item.BorderCustom := False;
  item := THogeTVItem.Create(Self);
  FStrings.Add(item);
end;


(* 改行するだけ *)
function THogeTextView.newPara: TPoint;
var
  point: TPoint;
  item: THogeTVItem;
  startLine: Integer;
begin
  point.Y := FStrings.Count - 1;
  point.X := length(FStrings[point.Y].FText);
  point := Normalize(point);

  startLine := point.Y;

  Inc(point.Y);
  item := THogeTVItem.Create(Self);
  FStrings.Insert(point.Y, item);
  point.X := 0;

  if (startLine <= FBottomLine) and (FTopLine <= point.Y) then
    Invalidate;

  result := point;
end;

function THogeTextView.nInsert2(point: TPoint;
                               pstr: PChar;
                               count: Integer;
                               attrib: Integer = 0): TPoint;
var
  item: THogeTVItem;
  startLine: integer;
begin
  if count <= 0 then
    exit;

  point := Normalize(point);
  startLine := point.Y;

  item := FStrings[point.Y];
  item.Insert(point.X + 1, pstr, count, attrib);

  if (startLine <= FBottomLine) and (FTopLine <= point.Y) then
    Invalidate;

  result := point;
end;

function THogeTextView.Insert2(point: TPoint;
                              const AString: string;
                              attrib: Integer = 0): TPoint;
begin
  result := nInsert2(point, @AString[1], length(AString), attrib);
end;

function THogeTextView.nAppend2(pstr: PChar;
                               count: Integer;
                               attrib: Integer = 0): TPoint;
var
  point: TPoint;
begin
  point.Y := FStrings.Count -1;
  point.X := length(FStrings[point.Y].FText);
  result := nInsert2(point, pstr, count, attrib);
end;

function THogeTextView.Append2(const AString: string;
                              attrib: Integer = 0): TPoint;
begin
  result := nAppend2(@AString[1], length(AString), attrib);
end;

(* IDポップアップ用 *)
function THogeTextView.nIDAppend(pstr: PChar;
                                 count: integer;
                                 attrib: integer = 0): TPoint;
var
  point: TPoint;
  item: THogeTVItem;
begin
  point.Y := FStrings.Count -1;
  point.X := length(FStrings[point.Y].FText);
  point := Normalize(point);

  item := FStrings[point.Y];
  item.Insert(point.X + 1, pstr, count, attrib);

  result := point;
end;

function THogeTextView.nIDHrefAppend(pstr: PChar;
                                    count: integer;
                                    line: integer;
                                    attrib: integer = 0): TPoint;
var
  point: TPoint;
  item: THogeTVItem;
begin
  point.Y := FStrings.Count -1;
  point.X := length(FStrings[point.Y].FText);
  point := Normalize(point);

  item := FStrings[point.Y];

  if FIDLinkColor then
    item.IDInsert(point.X + 1, pstr, count, line, attrib)
  else
    item.Insert(point.X + 1, pstr, count, attrib);

  result := point;
end;

{/aiai}

procedure THogeTextView.Clear;
var
  item: THogeTVItem;
begin
  FStrings.Clear;
  item := THogeTVItem.Create(Self);
  FStrings.Add(item);
  SetPhysicalCaret(0, 0);
  FSelStart := FEditPoint;
  SetSelecting(False);
  CaretVisible(False);
  {beginner}
  AutoScroll := False;
  FFraction := 0;
  {/beginner}
  SetLength(FResNumArray, 0); //aiai
  SetLength(FIDListArray, 0);  //aiai
  FHighlightTarget := '';
end;

function THogeTextView.CharWidth(p: PChar; attrib: Integer): Integer;
var
  style: TFontStyles;
  tbl: ^THogeCharWidthTable;
  size: TSize;
  code: Word;
  modifier: Integer;

  function GetCharWidth(ptr: PByte; len: integer): integer;
  begin
    if ptr^ <> 0 then
      result := ptr^
    else begin
      if FBitmap.Canvas.Font.Style <> style then
        FBitmap.Canvas.Font.Style := style;
      GetTextExtentPoint32A(FBitmap.Canvas.Handle, p, len, size);
      result := size.cx + modifier;
      ptr^ := result;
    end;
  end;
begin
  style := TextAttrib[attrib and htvATTMASK].style;
  if attrib and htvCODEMASK = htvUNICODE then
  begin
    if FBitmap.Canvas.Font.Style <> style then
      FBitmap.Canvas.Font.Style := style;
    code := PWord(p)^;
    GetTextExtentPoint32W(FBitmap.Canvas.Handle, PWideChar(@code), 1, size);
    result := size.cx;
    exit;
  end;
  if fsBold in style then
  begin
    tbl := @FBCharWidthTable;
    modifier := FBoldWidthModifier;
  end
  else begin
    tbl := @FCharWidthTable;
    modifier := 0;
  end;
  case p^ of
  #$00..#$80: result := GetCharWidth(@(tbl^.Ascii_1[Ord(p^)]), 1);
  #$81..#$9F: result := GetCharWidth(@(tbl^.MB_1[Ord(p^)][Ord((p+1)^)]), 2);
  #$A0..#$DF: result := GetCharWidth(@(tbl^.Ascii_2[Ord(p^)]), 1);
  #$E0..#$FC: result := GetCharWidth(@(tbl^.MB_2[Ord(p^)][Ord((p+1)^)]), 2);
  #$FD..#$FF: result := GetCharWidth(@(tbl^.Ascii_3[Ord(p^)]), 1);
  else        result := 0;
  end;
end;


procedure THogeTextView.InvalidateSize;
var
  i: integer;
begin
  for i := 0 to FStrings.Count -1 do
    with FStrings[i] do
    begin
      LogicalLines := 0;
      GetLogicalLines;
    end;
end;

procedure THogeTextView.UpdateBottomLine;
var
  i, vLines: integer;
begin
  vLines := VisibleLines;
  FBottomLine := FTopLine;
  for i := FTopLine to FStrings.Count -1 do
  begin
    FBottomLine := i;
    Dec(vLines, FStrings[i].LogicalLines);
    if vLines <= 0 then
      break;
  end;
end;



procedure THogeTextView.SetFont(FaceName: String; Size: Integer);
var
  i: integer;
begin
  if (Font.Name = FaceName) and (Font.Size = Size) and
    (FBitmap.Canvas.Font.Name = FaceName) and (FBitmap.Canvas.Font.Size = Size) then
    exit;
  Font.Name := FaceName;
  Font.Size := Size;
  FBitmap.Canvas.Font.Name := FaceName;
  FBitmap.Canvas.Font.Size := Size;
  FillChar(FCharWidthTable,  SizeOf(FCharWidthTable),  0);
  FillChar(FBCharWidthTable, SizeOf(FBCharWidthTable), 0);
  for i := 0 to FStrings.Count -1 do
    FStrings[i].FontChanged;
  if FCaretVisible and FConfCaretVisible then
  begin
    DestroyCaret;
    HideCaret(Handle);
    FOwnCaret := CreateCaret(Handle, 0, 1, Abs(Font.Height));
    ShowCaret(Handle);
  end;
  DoSize(Width, Height);
end;

procedure THogeTextView.SelectWord(physicalPos: TPoint);
var
  pp: TPoint;
  cw, tx: String;
  at: String;
  selS: Integer;
  i: Integer;
  charType1, charType2: (charNUMBER, charALPHA, charHALFKANA, charFULLKANA, charFULL, charUNICODE, charSPACE, charOTHER);
begin
  if (physicalPos.Y < 0) or (physicalPos.X < 0) then
    Exit;

  pp := Normalize(physicalPos);

  cw := FStrings[pp.Y].GetWidthInfo;
  at := FStrings[pp.Y].FAttrib;
  tx := FStrings[pp.Y].FText;

  charType1 := charSPACE;
  selS := 1;
  for i := 1 to Length(tx) do
  begin
    charType2 := charType1;
    if cw[i] > #0 then
    begin
      if ord(at[i]) and htvCODEMASK = htvUNICODE then
      begin
        if ((tx[i] = #$A0) and (i < Length(tx)) and (tx[i + 1] = #$00)) or
           ((tx[i] in [#$02, #$03, #$09]) and (i < Length(tx)) and (tx[i + 1] = #$20)) then
          charType1 := charSPACE
        else
          charType1 := charUNICODE;
      end else
      begin
        if tx[i] in ['0'..'9'] then
          charType1 := charNUMBER
        else if tx[i] in ['a'..'z','A'..'Z'] then
          charType1 := charALPHA
        else if tx[i] in ['ｦ'..'ﾝ'] then
          charType1 := charHALFKANA
        else if (tx[i] = ' ') or ((tx[i] = #$81) and (i < Length(tx)) and (tx[i + 1] = #$40)) then
          charType1 := charSPACE
        else if (tx[i] = #$81) then
        begin
          if (i < Length(tx)) and (tx[i + 1] = #$40) then
            charType1 := charSPACE
          else if (i < Length(tx)) and (tx[i + 1] in [#$5b, #$7c]) then
          begin
            if charType2 = charFULL then
              charType1 := charFULL
            else
              charType1 := charFULLKANA;
          end else
            charType1 := charOTHER;
        end else if (tx[i] = #$82) then
        begin
          if (i < Length(tx)) and (tx[i + 1] in [#$9f..#$f1]) then
            charType1 := charFULLKANA
          else
            charType1 := charFULL;
        end else if tx[i] in LeadBytes then
            charType1 := charFULL
        else
          charType1 := charOTHER;
      end;
      if (charType1 <> charType2) or (charType2 = charOTHER) then
      begin
        if i > pp.X + 1 then
        begin
          FSelStart := Point(selS, pp.Y);
          SetPhysicalCaret(i - 1, pp.Y, hscDONTSAVEX);
          SetSelecting(True);
          Exit;
        end;
        selS := i - 1;
      end;
    end;
  end;

  FSelStart := Point(selS, pp.Y);
  SetPhysicalCaret(Length(tx), pp.Y, hscDONTSAVEX);
  SetSelecting(True);

end;


//HogeTextViewの行間を探す補助手続き
procedure AdjustToTextViewLine(var Point: TPoint; Rect: TRect);
var
  VCLWindow: TWinControl;
  LaidView: THogeTextView;
begin
  VCLWindow := FindVCLWindow(Point);
  if Assigned(VCLWindow) and (VCLWindow is THogeTextView) then
  begin
    LaidView := THogeTextView(VCLWindow);
    Point := LaidView.ScreenToClient(Point);
    Dec(Point.Y, (Point.Y - LaidView.TopMargin) mod LaidView.BaseLineSkip + Rect.Bottom);
    Point := LaidView.ClientToScreen(Point);
  end else
    Dec(Point.Y, Rect.Bottom + 8);
end;

{beginner}
function THogeTextView.GetFrameRate: Cardinal;
begin
  Result := 1000 div FWaitTime;
end;

procedure THogeTextView.SetFrameRate(Value: Cardinal);
begin
  if Value <= 0 then
    FWaitTime := 0
  else
    FWaitTime := 1000 div Value;
end;
{/beginner}

{beginner}
procedure SetSleepMinimumResolution;
var
  TickCount1, TickCount2: Cardinal;
begin
  TickCount1 := timeGetTime;
  Sleep(0);
  TickCount2 := timeGetTime;

  if TickCount1 <= TickCount2 then
    SleepMinimumResolution := TickCount2 - TickCount1
  else
    SleepMinimumResolution := (High(Cardinal) - TickCount1) + TickCount2 + 1;
end;
{/beginner}

{aiai}
procedure THogeTextView.AnalyzeScrollInfo;
var
  si: SCROLLINFO;
  Point, LogicalPoint, PhysicalPoint: TPoint;
begin
  if not Assigned(FStrings) then
    exit;

  si.cbSize := sizeof(si);
  si.fMask := SIF_RANGE or SIF_POS or SIF_TRACKPOS;

  Point.X := 2;
  Point.Y := FStrings.Count;
  PhysicalPoint := Normalize(Point);
  LogicalPoint := PhysicalToLogical(PhysicalPoint);

  if ((LogicalTopLine + VisibleLines = LogicalPoint.Y + 2) or (LogicalPoint.Y < VisibleLines))
           and Assigned(FOnScrollEnd) then
    FOnScrollEnd(self);
end;

procedure THogeTextView.AutoScrollLines(ScrollLines: Integer);
begin
  SetSelecting(false);
  CaretVisible(false);
  ScrollLine(ScrollLines);
//  ScrollPixel(ScrollLines);
end;

procedure THogeTextView.SetIDList(bool: Boolean; Item: THogeTVItem;
                                                   Position, Line: Integer);
begin
  if not IDLinkColor then
    exit;
  if Length(FIDListArray) < Line then
    SetLength(FIDListArray, Line + 50);
  FIDListArray[Line - 1].Position := Position;
  FIDListArray[Line - 1].Item := Item;
  FIDListArray[Line - 1].bool := True;
end;

procedure THogeTextView.SetResNum(ResNumber: Integer);
begin
  if Length(FResNumArray) < ResNumber then
    SetLength(FResNumArray, ResNumber);
  FResNumArray[ResNumber - 1] := True;
end;

procedure THogeTextView.BeginUpdate;
begin
 CanRepain := false;
end;

procedure THogeTextView.EndUpdate;
begin
 CanRepain := true;
end;

procedure THogeTextView.DownLine;
begin
  SetSelecting(False);
  ForwardLine(1);
end;

{/aiai}

{beginner}
initialization
  SetSleepMinimumResolution;
{/beginner}

end.
