unit UTVSub;
(* Copyright (c) 2002 Twiddle <hetareprog@hotmail.com> *)
(* 暫定ユニット？ *)

interface

uses
  Classes,
  Controls,
  Types,
  SysUtils,
  Forms,
  HogeTextView,
  UPtrStream,
  UDat2HTML,
  UXMLSub;

{$IFDEF XPARSER}
type
  (*-------------------------------------------------------*)
  THTML2TextView = class (TDatOut)
  protected
    FBrowser: THogeTextView;
    FRe_entrant: Integer;
    FCanceled: boolean;
    FAttribute: THogeAttribute;
    FBold: THogeAttribute;
    FUnderline: THogeAttribute;
    FUser: Integer;
    FStream: TPointerStream;
    flushCount: integer;
    FOffsetLeft: integer;
    FReplaceAnchor: Boolean;
  public
    constructor Create(browser: THogeTextView);
    destructor Destroy; override;

    procedure WriteItem(str: PChar; size: integer;
                        itemType: TDatItemType); override;
    procedure WriteText(str: PChar; size: integer); override;
    procedure WriteHiddenText(str: PChar; size: integer; attrib: integer);
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); override;
    procedure WriteChar(c: Char);
    procedure WriteUNICODE(str: PChar; size: integer);
    procedure WriteBR;
    procedure SetBold(boldP: boolean);
    procedure Flush;
    procedure Cancel;

    property ReplaceAnchor: Boolean read FReplaceAnchor write FReplaceAnchor;
    property re_entrant: Integer read FRe_entrant;
    property canceled: Boolean read FCanceled;
  end;
  (*-------------------------------------------------------*)
{$ENDIF}

const
  ATTRIB_BOLD = 1;
  ATTRIB_LINK = 2;

  ATTRIB_ANCHOR_NAME = 0;
  ATTRIB_ANCHOR_HREF = 1;

  DD_OFFSET_LEFT = 32;
  LI_OFFSET_LEFT = 16;

function TVMouseProc(Sender: THogeTextView; Shift: TShiftState;
                     X, Y: Integer): string;

(*=======================================================*)
implementation
(*=======================================================*)

(*=======================================================*)
{$IFDEF XPARSER}
constructor THTML2TextView.Create(browser: THogeTextView);
begin
  inherited Create;
  FBrowser := browser;
  FCanceled := false;
  FRe_entrant := 0;
  FAttribute := 0;
  FBold := 0;
  FUnderline := 0;
  FUser := 0;
  flushCount := 0;
  FOffsetLeft := 0;
end;

destructor THTML2TextView.Destroy;
begin
  inherited;
end;
procedure THTML2TextView.WriteItem(str: PChar;
                                   size: integer;
                                   itemType: TDatItemType);
  (* *)
  procedure WriteContents(elem: TXMLElement); forward;

  procedure WriteSubsidiary(elem: TXMLElement);
  var i: integer;
  begin
    for i := 0 to elem.Count -1 do
      WriteContents(elem[i]);
  end;

  procedure AnchorElement(elem: TXMLElement);
  var
    line, col: integer;
    text: string;
  begin
    FUnderline := ATTRIB_LINK;
    FUser := htvUSER;
    WriteSubsidiary(elem);
    line := elem.attrib.IndexOfName('name');
    if 0 <= line then
    begin
      text := elem.attrib[line];
      col := Pos('=', text);
      WriteHiddenText(@text[col+1], length(text) - col, ATTRIB_ANCHOR_NAME);
    end;
    line := elem.attrib.IndexOfName('href');
    if 0 <= line then
    begin
      text := elem.attrib[line];
      col := Pos('=', text);
      WriteHiddenText(@text[col+1], length(text) - col, ATTRIB_ANCHOR_HREF);
    end;
    FUser := 0;
    FUnderline := 0;
  end;

  procedure BoldElement(elem: TXMLElement);
  begin
    FBold := ATTRIB_BOLD;
    WriteSubsidiary(elem);
    FBold := 0;
  end;

  procedure BreakElement(elem: TXMLElement);
  begin
    WriteBR;
    WriteSubsidiary(elem);
  end;

  procedure ListElement(elem: TXMLElement);
  begin
    WriteBR;
    Inc(FOffsetLeft, LI_OFFSET_LEFT);
    WriteSubsidiary(elem);
    WriteBR;
    Dec(FOffsetLeft, LI_OFFSET_LEFT);
  end;

  procedure WriteContents(elem: TXMLElement);
  begin
    with elem do
    begin
      case elementType of
      xmleELEMENT:
        begin
          if 0 < length(text) then
          begin
            if AnsiCompareText(text, 'a') = 0 then
              AnchorElement(elem)
            else if AnsiCompareText(text, 'b') = 0 then
              BoldElement(elem)
            else if (AnsiCompareText(text, 'br') = 0) or
                    (AnsiCompareText(text, 'dd') = 0) or
                    (AnsiCompareText(text, 'hr') = 0) or
                    (AnsiCompareText(text, 'li') = 0) or
                    (AnsiCompareText(text, 'p') = 0) then
              BreakElement(elem)
            else if (AnsiCompareText(text, 'ul') = 0) then
              ListElement(elem)
            else
              WriteSubsidiary(elem);
          end
          else
            WriteSubsidiary(elem);
        end;
      xmleTEXT:
        begin
          WriteText(PChar(text), length(text));
        end;
      xmleENTITY:
        begin
          if text = 'amp' then
            WriteText('&')
          else if text = 'copy' then
            WriteUNICODE(#$A9#$00, 2)
          else if text = 'gt' then
            WriteText('>')
          else if text = 'hearts' then
            WriteUNICODE(#$65#$26, 2)
          else if text = 'lt' then
            WriteText('<')
          else if text = 'quot' then
            WriteText('"')
          else if text = 'nbsp' then
            WriteUNICODE(#$A0#$00, 2)
          else if text = 'ensp' then
            WriteUNICODE(#$02#$20, 2)
          else if text = 'emsp' then
            WriteUNICODE(#$03#$20, 2)
          else if text = 'thinsp' then
            WriteUNICODE(#$09#$20, 2)
          else
            WriteText('&' + text + ';');
        end;
      end;
    end;
  end;
var
  ptrStream: TPointerStream;
  doc: TXMLDoc;
begin
  ptrStream := TPointerStream.Create(str, size);
  doc := TXMLDoc.Create;
  try doc.LoadFromStream(ptrStream); except end;
  WriteContents(doc);
  ptrStream.Free;
  doc.Free;
  FBrowser.Invalidate;
end;

procedure THTML2TextView.WriteText(str: PChar; size: integer);
begin
  if 0 < size then
  begin
    FBrowser.Strings[FBrowser.Strings.Count -1].OffsetLeft := FOffsetLeft;
    FBrowser.nAppend(str, size, FBold or FUnderline or FUser);
  end;
end;

procedure THTML2TextView.WriteHiddenText(str: PChar; size: integer;
                                         attrib: integer);
begin
  if 0 < size then
    FBrowser.nAppend(str, size, htvHIDDEN or attrib);
end;

procedure THTML2TextView.WriteAnchor(const Name: string;
                                     const Href: string;
                                     str: PChar; size: integer);
var
  user: integer;
begin
  if 0 < length(Href) then
    user := htvUSER
  else
    user := 0;

  FBrowser.nAppend(str, size, FBold or ATTRIB_LINK or user);
  FBrowser.Append(Name, ATTRIB_ANCHOR_NAME or htvHIDDEN);
  FBrowser.Append(Href, ATTRIB_ANCHOR_HREF or htvHIDDEN);
end;

procedure THTML2TextView.WriteBR;
begin
  Flush;
  FBrowser.Append(#10);
end;

procedure THTML2TextView.SetBold(boldP: boolean);
begin
  Flush;
  if boldP then
    FBold := 1
  else
    FBold := 0;
end;

procedure THTML2TextView.WriteChar(c: Char);
begin
  FBrowser.nAppend(@c, 1, FBold or FAttribute)
end;

procedure THTML2TextView.WriteUNICODE(str: PChar; size: integer);
begin
  FBrowser.nAppend(str, size, FBold or FUnderline or FAttribute or htvUNICODE);
end;

procedure THTML2TextView.Flush;
begin
  Inc(flushCount);
  if (flushCount mod 256) = 0 then
  begin
    Inc(FRe_entrant);
    Application.ProcessMessages;
    Dec(FRe_entrant);
  end;
end;

procedure THTML2TextView.Cancel;
begin
  FCanceled := true;
end;


{$ENDIF}

(*=======================================================*)

function TVMouseProc(Sender: THogeTextView; Shift: TShiftState;
                     X, Y: Integer): string;
var
  point: TPoint;
  view: THogeTextView;
  item: THogeTVItem;
  index: integer;
  newCursor: TCursor;
begin
  result := '';
  view := THogeTextView(Sender);
  point := view.ClientToPhysicalCharPos(X, Y);
  newCursor := crDefault;
  if 0 <= point.X then
  begin
    newCursor := crIBeam;
    item := view.Strings[point.Y];
    index := point.X +1;
    with THogeTextView(Sender) do
    begin
      if InSelection(point.X, point.Y) then
      begin
        if Cursor <> crDefault then
          Cursor := crDefault;
        exit;
      end;
    end;
    result := item.GetEmbed(index);
    if 0 < length(result) then
      newCursor := crHandPoint;
  end;
  with THogeTextView(Sender) do
    if Cursor <> newCursor then
      Cursor := newCursor;
end;

end.
