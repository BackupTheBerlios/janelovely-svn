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
  AppEvnts,
  VBScript_RegExp_55_TLB,
  Forms,
  Math;

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
  //aiai 検索ハイライト用のrecord startp,endpともに0からでなく1から
  THogeHighLightRecord = record   //1ベースインデックス
    startp: Integer;
    endp: Integer;
  end;

  THogeHighLight = array of THogeHighLightRecord;

  THighLightOption = (hloNone, hloNormal, hloReg);
  (*-------------------------------------------------------*)

  THogeTVItem = class(TObject)
  private
    FOffsetLeft: Integer;
    FView: THogeTextView;
    FCharWidth: AnsiString;
    FLogicalLines: Integer;
    FHighLight: THogeHighLight; //aiai
    FHighlightTargetList: TStringList;  //aiai
    FHighLightOption: THighLightOption; //aiai

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
    Picture: TGraphic;
    PictOverlap: Integer;
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

    FResNumArray: THogeResNumArray;
    FIDList: TStringList;

    FColordNumber: Boolean;
    FLinkedNumColor: TColor;

    FIDLinkColor :Boolean;
    FIDLinkColorNone: TColor;
    FIDLinkColorMany: TColor;
    FIDLinkThreshold: Integer;

    FHighlightTargetList: TStringList;
    FHighlightOption: THighLightOption;
    FKeywordBrushColor: TColor;

    re_enter: integer;
    Canceled: boolean;
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
    procedure ScrollLine(advance: integer; movecaret: Boolean = False);
    procedure ScrollPixel(advance: integer; movecaret: Boolean = False); //beginner
    procedure CopySelection;
    function  GetSelection: String;
    function  SearchForward (const AString: TStrings; Option: THighlightOption; JumpAfter: Boolean = True): Boolean;
    function  SearchBackward(const AString: TStrings; Option: THighlightOption): Boolean;
    function  SearchClear: Boolean;
    procedure SetMarkCommand;
    procedure SelectAll;

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
    function AppendPicture(Image: TGraphic; overlap: Boolean; offsetleft: integer): Boolean;
    procedure AppendHR(Color: TColor; Custom: Boolean; OffsetLeft: Integer);
    {/aiai}
    procedure SetFont(FaceName: String; Size: Integer);
    procedure SelectWord(physicalPos: TPoint);

    {aiai}
    procedure AutoScrollLines(ScrollLines: Integer);
    procedure DownLine;
    procedure SetResNum(ResNumber: Integer);
    property IDList: TStringList read FIDList write FIDList;
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
    property HighlightOption: THighlightOption read FHighlightOption write FHighlightOption;  //aiai
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

procedure AdjustToTextViewLine(const Point: TPoint; const Rect: TRect;
  var offset1: Integer; var offset2: Integer);

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
  SetLength(FHighLight, 0);  //aiai
  FHighLightOption := hloNone;  //aiai
end;

destructor THogeTVItem.Destroy;
begin
  SetLength(FText, 0);
  SetLength(FAttrib, 0);
  SetLength(FCharWidth, 0);
  SetLength(FHighLight, 0);  //aiai
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
  if insLen > 0 then
  begin
    Move(str^, FText[index], insLen);
    FillChar(FAttrib[index], insLen, attrib);
  end;
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
  {aiai}
  if PictLine and Assigned(Picture) and (PictOverlap = -1) then
  begin
    Result.X := FView.LeftMargin + FOffsetLeft;
    Result.Y := Ceil(Picture.Height / FView.BaselineSkip) - 1;
    exit;
  end;
  {/aiai}
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
  {aiai}
  if PictLine and Assigned(Picture) and (PictOverlap = -1) then
  begin
    Point.X := FView.LeftMargin + FOffsetLeft;
    Point.Y := Ceil(Picture.Height / FView.BaselineSkip) - 1;
    Result := Point.X;
    exit;
  end;
  {/aiai}
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
  FLeftMargin := 8;
  FTopMargin := 4;
  FExternalLeading := 1;
  //FCaretPos.x := FLeftMargin;
  //FCaretPos.y := FTopMargin - FFraction; //beginner
  FCaretPos.x := FLeftMargin;
  FCaretPos.y := FTopMargin;
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
  FIDList := TStringList.Create;

  FKeywordBrushColor := clYellow;

  //FMaxWidth := 0;
  FHighlightTargetList := TStringList.Create;
  FHighlightOption := hloNormal;
  re_enter := 0;
  Canceled := False;
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
  FIDList.Free;
  FHighlightTargetList.Free; //aiai
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
      {aiai}
      //if 0 < X then
      if (0 < X) and (X < len) then
      {/aiai}
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

procedure THogeTextView.ScrollLine(advance: integer; movecaret: Boolean = False);
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
      ScrollPixel(Delta + ModDelta, movecaret)
    else
      ScrollPixel(Delta, movecaret);
    {aiai}
    if FCaretScrollSync or movecaret then
      SetLogicalCaret(FLogicalCaret)
    else
      SetLogicalCaret(FLogicalCaret, hscDONTSCROLL);
    {/aiai}
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
procedure THogeTextView.ScrollPixel(advance: integer; movecaret: Boolean = False);
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
  if FCaretScrollSync or movecaret then  //aiai
    FLogicalCaret.Y := FLogicalTopLine + ScreenCurretLine;

  ModifyLogicalLine(FLogicalTopLine, FTopLine, FTopLineOffset);
  UpdateBottomLine;
  if FCaretScrollSync or movecaret then //aiai
    FLogicalCaret.X := FCaretSavedX;
  SetLogicalCaret(FLogicalCaret, hscDONTSCROLL);
  Invalidate;
end;
{/beginner}

procedure THogeTextView.PageDown;
begin
  FLogicalCaret.Y := FLogicalTopLine + 1;
  SetLogicalCaret(FCaretSavedX, FLogicalCaret.Y, hscDONTSAVEX);
  ScrollLine(VisibleLines - GetMargin, True);
  AnalyzeScrollInfo;
end;

procedure THogeTextView.PageUp;
begin
  FLogicalCaret.Y := FLogicalTopLine + 1;
  SetLogicalCaret(FCaretSavedX, FLogicalCaret.Y, hscDONTSAVEX);
  ScrollLine(GetMargin - VisibleLines, True);
end;

procedure THogeTextView.SetTop(line: integer);
begin
  SetSelecting(False);
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
  top: TPoint;
begin
  UpdateVisibleLines;
  off := (FLogicalCaret.Y - FLogicalTopLine);

  // リサイズ前のPhysicalなTopLine;
  top := LogicalToPhysical(Point(0, FLogicalTopLine));

  FWidth  := newWidth;
  FHeight := newHeight;
  InvalidateSize;

  FLogicalCaret := PhysicalToLogical(FEditPoint);
  if FCaretScrollSync then
  begin
    vl := VisibleLines;
    if vl <= off then
      off := vl -1;
    if off < 0 then
      off := 0;
    FLogicalTopLine := FLogicalCaret.Y - off;
  end else
    // リサイズ後のLogicalなTopLine;
    FLogicalTopLine := PhysicalToLogical(top).Y;

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
      FDragging := False;  //aiai
      FIsMouseIn := True;
    end;
  end;
  if not FSelecting then
    FDragging := False;
  if FDragging then
  begin
    SetLogicalCaret(ClientToLogical(X, Y));
  end;
  if not AutoScroll then //aiai
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
    ScrollLine(-FVScrollLines * SmallInt(msg.WParamHi) div WHEEL_DELTA);
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
      if not FConfCaretVisible or (ssCtrl in Shift) then
      begin
        if FCaretScrollSync then
          ProcSelection;
        ScrollLine(FVScrollLines); //521
        AnalyzeScrollInfo;
      end else
      begin
        ProcSelection;
        ForwardLine(1);
      end;
      Key := 0;
    end;
  VK_UP:
    begin
      if not FConfCaretVisible or (ssCtrl in Shift) then
      begin
        if FCaretScrollSync then
          ProcSelection;
        ScrollLine(-FVScrollLines) //521
      end else
      begin
        ProcSelection;
        ForwardLine(-1);
      end;
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
  SB_TOP:
    {aiai}
    //BeginningOfBuffer;
    if FCaretScrollSync then
      BeginningOfBuffer
    else
      ScrollLine2(-FLogicalTopLine);
    {/aiai}
  SB_BOTTOM:
    {aiai}
    begin
      //EndOfBuffer;
      if FCaretScrollSync then
        EndOfBuffer
      else
        ScrollLine2(PhysicalToLogical(Normalize(Point(0, FStrings.Count))).Y);
      if Assigned(FOnScrollEnd) then FOnScrollEnd(Self);
    end;
    {/aiai}
  SB_LINEDOWN:
    begin
      ScrollLine(FVScrollLines);
      AnalyzeScrollInfo;
    end;
  SB_LINEUP:   ScrollLine(-FVScrollLines);
  SB_PAGEDOWN:
    begin
      ScrollLine(VisibleLines - GetMargin);
      AnalyzeScrollInfo;
    end;
  SB_PAGEUP:
    begin
      SCrollLine(GetMargin - VisibleLines);
    end;
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

//hrタグ用のボーダーを描く (aiai)
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
var
  len: integer;
  HighlightP: Boolean;
  hlightl: THogeHighLight;

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
    endPos, IDFreq, ListCount, index: Integer;
    idp: PChar;
  begin
    if not Assigned(FIDList) then
      exit; 
    endPos := startPos + 3;
    while (Ord(item.FAttrib[endPos]) and htvVMASK = htvHIDDEN)
           and (endpos <= len) do
      Inc(endPos);
    if endpos > len then
      exit;
    IDFreq := 0;
    ListCount := FIDList.Count;
    idp  := @item.FText[startPos + 3];
    for index := 0 to  ListCount - 1 do
    begin
      if (0 = StrLComp(idp, PChar(FIDList.Strings[index]), endpos - startpos - 3)) then
      begin
        Inc(IDFreq);
        if IDFreq = FIDLinkThreshold then
          break;
      end;
    end;
    if IDFreq = 1 then
      FBitmap.Canvas.Font.Color := FIDLinkColorNone
    else if IDFreq >= FIDLinkThreshold then
      FBitmap.Canvas.Font.Color := FIDLinkColorMany;
  end;

  //indexがstartindexとendindexの間にあればハイライト
  function InHighlight(index: integer): Boolean;
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

  {aiai}
  if (item.PictLine and (item.PictOverlap = -1)) then
  begin
    Y := FTopMargin - FFraction - FTopLineOffset * bs;
    screenLine := - FTopLineOffset;
  end else
  {/aiai}
    Y := FTopMargin - FFraction; //beginner

  nchar := 0;

  while screenLine < vLines do
  begin
    {aiai}
    if item.PictLine and Assigned(item.Picture) then
    begin
      if item.PictOverlap = -1 then
      begin
        //<IMG>
        FBitmap.Canvas.Draw(FLeftMargin + item.OffsetLeft, Y, item.Picture);
        Inc(screenLine, item.LogicalLines);
        if vLines <= screenLine then
          break;
        Inc(physicalLine);
        if FStrings.Count <= physicalLine then
          break;
        Inc(Y, item.LogicalLines * bs);
        item := FStrings[physicalLine];
        X := FLeftMargin + item.OffsetLeft;
        index := 1;
        attrib := item.FAttrib;
        len := length(attrib);
        cw := item.GetWidthInfo;
        Continue;
      end else
      begin
        //<IMG align=overlap>
        point := item.IndexToLogicalPos(item.PictOverlap);
        if screenLine = 0 then
          point.Y := point.Y - FTopLineOffset;
        FBitmap.Canvas.Draw(point.X, point.Y * bs + Y, item.Picture);
      end;
    end;
    //検索ハイライト
    if FHighLightOption <> hloNone then
      hlightl := item.FHighLight;
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
        {aiai}
        //検索文字列ハイライト
        HighlightP := InHighlight(index);
        {/aiai}
        next := index + 1;
        while next <= len do
        begin
          if Ord(attrib[next]) <> attCode then
            break;
          if cw[next] <> #0 then
          begin
            if InSelection(next -1, physicalLine) <> selectionP then
              break;
            {aiai}
            //検索文字列ハイライト
            if InHighlight(next) <> HighlightP then
              break;
            {/aiai}
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
          {aiai}
          //検索文字列ハイライト
          else if HighlightP then
          begin
            if FBitmap.Canvas.Font.Color <> color then
              FBitmap.Canvas.Font.Color := color;
            if FBitmap.Canvas.Brush.Color <> FKeywordBrushColor then
              FBitmap.Canvas.Brush.Color := FKeywordBrushColor;
            if FBitmap.Canvas.Font.Style <> style then
              FBitmap.Canvas.Font.Style := style;
          end
          {/aiai}
          else begin
            if FBitmap.Canvas.Font.Color <> color then
              FBitmap.Canvas.Font.Color := color;
            {aiai}
            //文字の背景を透明に
            if FBitmap.Canvas.Brush.Style <> bsClear then
               FBitmap.Canvas.Brush.Style := bsClear;
            {/aiai}
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
            if FIDLinkColor then
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

// SearchForward, SearchBackward
// Option: 通常検索、正規表現
// by aiai
function THogeTextView.SearchForward (const AString: TStrings; Option: THighlightOption; JumpAfter: Boolean = True): Boolean;
var
  col, line: integer;
  len, endPos, count, i, j, k: integer;
  sp, sp2: integer;
  item: THogeTVItem;
  cw: AnsiString;
  rect: TRect;
  editpoint: TPoint;
  selandjump: Boolean;
  hlight: THogeHighLight;
  RegExp: TRegExp;
  Matches: MatchCollection;
  Mat: Match;
  matchcount: integer;
  selall: boolean;
Label
  loop;
begin
  Result := True;
  if re_enter > 0 then
    exit;
  Canceled := False;
  if FSelecting then
  begin
    rect := NormalizeMinMax(FEditPoint, FSelStart);
    FSelStart := rect.TopLeft;
    FEditPoint := rect.BottomRight;
  end;
  result := False;
  if not Assigned(AString) then
    exit;
  RegExp := nil;
  editpoint := FEditPoint;
  line := editpoint.Y;
  selall := False;
  for i := 0 to AString.Count - 1 do
    if (-1 = FHighlightTargetList.IndexOf(AString[i])) then
    begin
      selall := True;
      break;
    end;
  if not selall and (FHighlightOption = Option) then
  begin
    col := editpoint.X + 1;
    for line := line to FStrings.Count - 1 do
    begin
      item := FStrings[line];
      if col <= 0 then
        col := 1;
      count := Length(item.FHighLight);
      for i := 0 to count - 1 do
      begin
        if item.FHighLight[i].startp >= col then
        begin
          FSelStart.X := item.FHighLight[i].startp - 1;
          FSelStart.Y := line;
          SetPhysicalCaret(item.FHighLight[i].endp, line, hscSCROLLCENTER);
          SetSelecting(True);
          Result := True;
          exit;
        end;
      end;
      col := 1;
    end;
  end else
  begin
    FHighlightTargetList.Assign(AString);
    FHighlightOption := Option;
    selandjump := not JumpAfter;
    if Option = hloReg then
    begin
      RegExp := TRegExp.Create(nil);
      RegExp.IgnoreCase := True;
      RegExp.Global := True;
    end;
    repeat
      item := FStrings[line];
      endPos := item.GetLength - 1;
      cw := item.GetWidthInfo;
      SetLength(hlight, 0);
      if Option = hloNormal then
      begin
        col := 1;
        while col <= endPos do
        begin
          if (cw[col] <> #0) and
             (Ord(item.FAttrib[col]) and htvVMASK = htvVISIBLE) then
          begin
            for i := 0 to FHighlightTargetList.Count - 1 do
            begin
              len := Length(FHighlightTargetList[i]);
              if (StrLIComp(PChar(item.FText) + col - 1, PChar(FHighlightTargetList[i]), len) = 0) then
              begin
                if not selandjump and ((line > editpoint.Y) or ((line = editpoint.Y) and (col > editpoint.X))) then
                begin
                  FSelStart.X := col - 1;
                  FSelStart.Y := line;
                  SetPhysicalCaret(col + len - 1, line, hscSCROLLCENTER);
                  SetSelecting(True);
                  selandjump := true;
                end;
                SetLength(hlight, Length(hlight) + 1);
                hlight[Length(hlight) - 1].startp := col;
                hlight[Length(hlight) - 1].endp := col + len - 1;
                result := True;
                Inc(col, len - 1);
                break;
              end;
            end;
          end;
          Inc(col);
        end;
      end else
      begin
        for j := 0 to FHighLightTargetList.Count - 1 do
        begin
          try
            RegExp.Pattern := FHighLightTargetList[j];
            Matches := RegExp.Execute(item.FText);
          except
            RegExp.Free;
            FHighLightTargetList.Clear;
            FhighlightOption := hloNone;
            raise;
          end;
          matchcount := Matches.Count;
          sp := 0;
          i := 0;
          while i < matchcount do
          begin
            loop:
            SetLength(hlight, Length(hlight) + 1);
            Mat := Match(Matches.Item[i]);
            sp2 := AnsiPos(AnsiString(Mat.Value), PChar(item.FText) + sp);
            hlight[Length(hlight) - 1].startp := sp + sp2;
            sp := hlight[Length(hlight) - 1].startp;
            hlight[Length(hlight) - 1].endp := sp - 1 + Length(AnsiString(Mat.Value));
            if (sp2 <= 0) or ((cw[sp] = #0) and
               (Ord(item.FAttrib[sp]) and htvVMASK <> htvVISIBLE)) then
            begin
              Dec(matchcount);
              SetLength(hlight, Length(hlight) - 1);
              Continue;
            end;
            for k := 0 to Length(hlight) - 2 do
            begin
              if (hlight[k].startp <= hlight[Length(hlight) - 1].startp)
                and (hlight[k].endp >= hlight[Length(hlight) - 1].endp) then
              begin
                Dec(matchcount);
                SetLength(hlight, Length(hlight) - 1);
                goto loop;
              end;
            end;
            if not selandjump and ((line > editpoint.Y) or ((line = editpoint.Y) and (sp > editpoint.X))) then
            begin
              FSelStart.X := hlight[Length(hlight) - 1].startp - 1;
              FSelStart.Y := line;
              SetPhysicalCaret(hlight[Length(hlight) - 1].endp, line, hscSCROLLCENTER);
              SetSelecting(True);
              selandjump := true;
            end;
            Inc(i);
            result := True;
          end;
        end;
      end;
      item.FHighLight := hlight;
      item.FHighLightTargetList := FHighlightTargetList;
      item.FHighLightOption := Option;
      Inc(line);
      if line mod 50 = 0 then
      begin
        Inc(re_enter);
        Application.ProcessMessages;
        Dec(re_enter);
        if Canceled then
        begin
          Result := False;
          break;
        end;
      end;
      if line = FStrings.Count then
        line := 0;
    until line = editpoint.Y;
  end;
  if Assigned(RegExp) then
    RegExp.Free;
  if Result then
    Invalidate;
end;

function THogeTextView.SearchBackward(const AString: TStrings; Option: THighlightOption): Boolean;
var
  col, line: integer;
  len, i, j, k: integer;
  sp, sp2: integer;
  count: integer;
  item: THogeTVItem;
  cw: AnsiString;
  rect: TRect;
  editpoint: TPoint;
  selandjump: Boolean;
  hlight: THogeHighLight;
  RegExp: TRegExp;
  Matches: MatchCollection;
  Mat: Match;
  matchcount: integer;
  selall: Boolean;
label
  loop;
begin
  Result := True;
  if re_enter > 0 then
    exit;
  Canceled := False;
  if FSelecting then
  begin
    rect := NormalizeMinMax(FEditPoint, FSelStart);
    FEditPoint := rect.TopLeft;
    FSelStart := rect.BottomRight;
  end;
  result := False;
  if not Assigned(AString) then
    exit;
  RegExp := nil;
  editpoint := FEditPoint;
  if editpoint.X <= 0 then
    line := editpoint.Y - 1
  else
    line := editpoint.Y;
  selall := False;
  for i := 0 to AString.Count - 1 do
    if (-1 = FHighlightTargetList.IndexOf(AString[i])) then
    begin
      selall := True;
      break;
    end;
  if not selall and (FHighlightOption = Option) then
  begin
    col := editpoint.X;
    for line := line downto 0 do
    begin
      item := FStrings[line];
      cw := item.GetWidthInfo;
      if col <= 0 then
        col := length(cw);
      count := Length(item.FHighLight);
      for i := count - 1 downto 0 do
      begin
        if item.FHighLight[i].endp <= col then
        begin
          FSelStart.X := item.FHighLight[i].endp;
          FSelStart.Y := line;
          SetPhysicalCaret(item.FHighLight[i].startp - 1, line, hscSCROLLCENTER);
          SetSelecting(True);
          Result := True;
          exit;
        end;
      end;
      col := 0;
    end;
  end else
  begin
    FHighLightTargetList.Assign(AString);
    FhighlightOption := Option;
    selandjump := false;
    if Option = hloReg then
    begin
      RegExp := TRegExp.Create(nil);
      RegExp.IgnoreCase := True;
      RegExp.Global := True;
    end;
    repeat
      item := FStrings[line];
      cw := item.GetWidthInfo;
      SetLength(hlight, 0);
      if Option = hloNormal then
      begin
        col := length(cw);
        while 0 < col do
        begin
          if (cw[col] <> #0) and
             (Ord(item.FAttrib[col]) and htvVMASK = htvVISIBLE) then
          begin
            for i := 0 to FHighlightTargetList.Count - 1 do
            begin
              len := Length(FHighlightTargetList[i]);
              if (StrLIComp(PChar(item.FText) + col - 1, PChar(FHighlightTargetList[i]), len) = 0) then
              begin
                if not selandjump and ((line < editpoint.Y) or ((line = editpoint.Y) and (col < editpoint.X))) then
                begin
                  FSelStart.X := col + len - 1;
                  FSelStart.Y := line;
                  SetPhysicalCaret(col - 1, line, hscSCROLLCENTER);
                  SetSelecting(True);
                  selandjump := True;
                end;
                SetLength(hlight, Length(hlight) + 1);
                hlight[Length(hlight) - 1].startp := col;
                hlight[Length(hlight) - 1].endp := col + len - 1;
                result := True;
                Dec(col, len - 1);
              end;
            end;
          end;
          Dec(col);
        end;
      end else
      begin
        for j := 0 to FHighLightTargetList.Count - 1 do
        begin
          try
            RegExp.Pattern := FHighLightTargetList[j];
            Matches := RegExp.Execute(item.FText);
          except
            RegExp.Free;
            FHighLightTargetList.Clear;
            FhighlightOption := hloNone;
            raise;
          end;
          matchcount := Matches.Count;
          sp := 0;
          i := 0;
          while i < matchcount do
          begin
            loop:
            SetLength(hlight, Length(hlight) + 1);
            Mat := Match(Matches.Item[i]);
            sp2 := AnsiPos(AnsiString(Mat.Value), PChar(item.FText) + sp);
            hlight[Length(hlight) - 1].startp := sp + sp2;
            sp := hlight[Length(hlight) - 1].startp;
            hlight[Length(hlight) - 1].endp := sp - 1 + Length(AnsiString(Mat.Value));
            if (sp2 <= 0) or ((cw[sp] = #0) and
             (Ord(item.FAttrib[sp]) and htvVMASK <> htvVISIBLE)) then
            begin
              Dec(matchcount);
              SetLength(hlight, Length(hlight) - 1);
              Continue;
            end;
            for k := 0 to Length(hlight) - 2 do
            begin
              if (hlight[k].startp <= hlight[Length(hlight) - 1].startp)
                and (hlight[k].endp >= hlight[Length(hlight) - 1].endp) then
              begin
                Dec(matchcount);
                SetLength(hlight, Length(hlight) - 1);
                goto loop;
              end;
            end;
            if not selandjump and ((line < editpoint.Y) or ((line = editpoint.Y) and (sp < editpoint.X))) then
            begin
              FSelStart.X := hlight[Length(hlight) - 1].endp;
              FSelStart.Y := line;
              SetPhysicalCaret(hlight[Length(hlight) - 1].startp - 1, line, hscSCROLLCENTER);
              SetSelecting(True);
              selandjump := true;
            end;
            Inc(i);
            result := True;
          end;
        end;
      end;
      SetLength(item.FHighLight, Length(hlight));
      item.FHighLight := hlight;
      item.FHighLightTargetList := FHighlightTargetList;
      item.FHighLightOption := Option;
      Dec(line);
      if line mod 50 = 0 then
      begin
        Inc(re_enter);
        Application.ProcessMessages;
        Dec(re_enter);
        if Canceled then
        begin
          Result := False;
          break;
        end;
      end;
      if line = -1 then
        line := FStrings.Count - 1;
    until line = editpoint.Y;
  end;
  if Assigned(RegExp) then
    RegExp.Free;
  if Result then
    Invalidate;
end;

//検索結果のクリア aiai
function THogeTextView.SearchClear: Boolean;
var
  i: integer;
begin
  Result := False;
  Canceled := True;
  if FHighLightOption = hloNone then
    exit;
  for i := 0 to FStrings.Count - 1 do
    With FStrings.Items[i] do
    begin
      FHighlightTargetList := nil;
      FHighLightOption := hloNone;
      SetLength(FHighLight, 0);
    end;
  FHighLightOption := hloNone;
  FHighLightTargetList.Clear;
  Invalidate;
  Result := True;
end;

procedure THogeTextView.SetMarkCommand;
begin
  FSelStart := FEditPoint;
end;

//すべて選択する (aiai)
procedure THogeTextView.SelectAll;
begin
  BeginningOfBuffer;
  SetMarkCommand;
  EndOfBuffer;
  Selecting := True;
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
  endPos: integer;
  len: integer;
  p: PChar;
  wp: PWideChar;
  org: TPoint;
  startLine: integer;
begin
  if count <= 0 then
    exit;
  point := Normalize(point);
  org := point;
  len := count;
  startLine := point.Y;
  if (attrib and htvCODEMASK) = htvASCII then
  begin
    item := FStrings[point.Y];
    p := pstr;
    startPos := 0;
    endPos := startPos;
    while endPos < len do
    begin
      if p^ = #10 then
      begin
        if (startPos < endPos) and ((p -1)^ = #13) then
        begin
          item.Insert(point.X + 1, pstr + startPos, endPos - startPos -1,
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
  result := nInsert(point, PChar(AString), length(AString), attrib);
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
  result := nAppend(PChar(AString), length(AString), attrib);
end;

{aiai}
function THogeTextView.AppendPicture(Image: TGraphic;
    overlap: Boolean; offsetleft: integer): Boolean;
var
  Point: TPoint;
  item: THogeTVItem;
  attrib, cw: AnsiString;
  len, i, attCode: Integer;
begin
  Result := False;
  if Image = nil then
    exit;

  Point.Y := FStrings.Count - 1;
  item := FStrings[Point.Y];

  if overlap then
  begin
    item.PictLine := True;
    item.PictOverlap := length(item.FText) + 1;
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
      item.OffsetLeft := offsetleft;
      FStrings.Add(item);
      break;
    end;
  end;

  item.PictLine := True;
  item.PictOverlap := -1;
  item.Picture := Image;
  item.FLogicalLines := 0;
  item.GetLogicalLines;

  item := THogeTVItem.Create(Self);
  item.OffsetLeft := offsetleft;
  FStrings.Add(item);

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
  {aiai}
  SetLength(FResNumArray, 0);
  FHighlightOption := hloNone;
  FIDList.Clear;
  FHighlightTargetList.Clear;
  Canceled := True;
  {/aiai}
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
//カーソルの上に表示するときのオフセットと下に表示するときのオフセット (aiai)
procedure AdjustToTextViewLine(const Point: TPoint; const Rect: TRect;
  var offset1: Integer; var offset2: Integer);
var
  VCLWindow: TWinControl;
  LaidView: THogeTextView;
  ClientPt: TPoint;
begin
  VCLWindow := FindVCLWindow(Point);
  if Assigned(VCLWindow) and (VCLWindow is THogeTextView) then
  begin
    LaidView := THogeTextView(VCLWindow);
    ClientPt := LaidView.ScreenToClient(Point);
    offset1 := (ClientPt.Y - LaidView.TopMargin) mod LaidView.BaseLineSkip;
    offset2 := LaidView.BaselineSkip - offset1;
  end else
  begin
    offset1 := 8;
    offset2 := 8;
  end;
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
  Point, LogicalPoint, PhysicalPoint: TPoint;
begin
  if not Assigned(FStrings) then
    exit;

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

procedure THogeTextView.SetResNum(ResNumber: Integer);
begin
  if Length(FResNumArray) < ResNumber then
    SetLength(FResNumArray, ResNumber);
  FResNumArray[ResNumber - 1] := True;
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
