unit UDat2HTML;
(* DAT→HTML変換ルーチン *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.48, 2004/07/03 14:03:38 *)

interface

uses
  SysUtils,
  StrUtils,
  Classes,
  Types,
  Windows,
  StrSub,
  UNGWordsAssistant;

type
  (*-------------------------------------------------------*)
  THogeMemoryStream = class(TMemoryStream)
  public
    procedure WriteString(const str: string);
    procedure WriteChar(c: Char);
    function ReadString: string;
    property Memory;
  end;

  (*-------------------------------------------------------*)
  TCachedThreadInfo = record
    FLineNumber: Integer;
    FBlockIndex: Integer;
    FIndex: Integer;
  end;

  TDatItem = (diName, diMail, diDate, diMsg); //nono

  TThreadData = class(TStringList)
  private
  protected
    FDirtyIndex: Integer;
    FCacheInfo: TCachedThreadInfo;
    FConsistent: Boolean;
    procedure ClearCacheInfo;
    function FindLine(lineNumber: integer): boolean;

    function CalcLines: Integer;
    function GetSize: Cardinal;
    function GetPosition: Cardinal;
    function GetDatItem(line: Integer; DatItem: TDatItem):string;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AString: string): Integer; override;
    function AddObject(const AString: string; AObject: TObject): Integer; override;
    procedure Clear; override;
    procedure LoadFromFile(const fileName: string); override;
    procedure SaveToFile(const fileName: string); override;
    function Contains(const target: string; NeedConvert: Boolean): boolean;
    function Dup: TThreadData;
    {nono}
    function FetchName(line: Integer):string;
    function FetchMail(line: Integer):string;
    function FetchID(line: Integer):string;
    function FetchMessage(line: Integer):string;
    {/nono}
    function MatchID(const target: PChar; line: Integer): Boolean;
    property Lines: Integer read CalcLines;
    property Size: Cardinal read GetSize;
    property Position: Cardinal read GetPosition;
    property Consistent: Boolean read FConsistent write FConsistent;
  end;
  (*-------------------------------------------------------*)
  TDatItemType = (ditNORMAL, ditNAME, ditDATE, ditMAIL, ditMSG, ditMAILNAME);
  (*-------------------------------------------------------*)
  TDatOut = class(TObject)
  protected
    FDisableLink: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteHTML(str: PChar; size: integer); overload; virtual;
    procedure WriteHTML(str: String); overload; virtual;
    procedure WriteText(str: PChar; size: integer); overload; virtual; abstract;
    procedure WriteText(str: String); overload; virtual;
    procedure WriteChar(c: Char); virtual;
    procedure WriteItem(str: PChar; size: integer;
                        itemType: TDatItemType); virtual; abstract;
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); virtual; abstract;
    procedure SetLine(line: integer); virtual; abstract;
    procedure Flush; virtual;
    property DisableLink: Boolean read FDisableLink write FDisableLink;
  end;
  (*-------------------------------------------------------*)
  TConvDatOut = class(TDatOut)
  protected
    str: PChar;
    index: integer;
    size: integer;
    line: integer;
    procedure EndOfTag;
    function GetTagName: string;
    function GetAttribPair(var name, value: string): Boolean;
    procedure SkipSpaces;
    function GetURL: string;
    function GetRange(var ANK: string): string;
    function DoRange(const prefix: string): boolean;
    function ProcRedirect: boolean; virtual;
    function ProcTag: boolean; virtual;
    function ProcURL: boolean; virtual;
    function ProcEntity: boolean; virtual;
    function ProcBlank: boolean; virtual;
    function ProcDayOfWeek: Boolean; virtual;  //aiai
    function ProcID: Boolean; virtual;  //aiai
    procedure ProcHTML; virtual;
    procedure ProcHTMLB;
    procedure ProcName;
    procedure ProcDate;  //aiai
    procedure AppendResNumList(num: Integer); overload; virtual;
    procedure AppendResNumList(num, num2: Integer); overload; virtual;
    function IsThisTag(substr, str: PChar; len: Integer): Boolean; virtual;

  public
    procedure WriteItem(str: PChar; size: integer;
                         itemType: TDatItemType); override;
    procedure SetLine(line: integer); override;
  end;
  (*-------------------------------------------------------*)
  TStrDatOut = class (TConvDatOut)
  protected
    FString: String;
    FPosition: integer;
    FSize: integer;
    FSupress: Boolean;
    function ProcTag: boolean; override;
    function ProcEntity: boolean; override;
    function ProcBlank: boolean; override;
    procedure ProcHTML; override;
    function GetText: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteText(str: PChar; size: integer); override;
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); override;
    procedure WriteItem(str: PChar; size: integer; itemType: TDatItemType); override;
    property Text: String read GetText;
  end;
  (*-------------------------------------------------------*)
  {aiai}
  //ID抽出用
  TIDDatOut = class(TConvDatOut)
    FString: String;
    FPosition: integer;
    FSize: integer;
    function ProcID: Boolean; override;
    function GetText: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteText(str: PChar; size: integer); override;
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); override;
    procedure WriteItem(str: PChar; size: integer; itemType: TDatItemType); override;
    property Text: String read GetText;
  end;
  {/aiai}
  (*-------------------------------------------------------*)
  TTmplType = (TYPE_TEXT,
               TYPE_NUMBER,
               TYPE_NAME,
               TYPE_MAILNAME,
               TYPE_MAIL,
               TYPE_SAGE,
               TYPE_SAGEONLY,
               TYPE_DATE,
               TYPE_MESSAGE,
               TYPE_PLAINNUMBER);
  TDatType = (dtUnknown, dtNormal, dtComma);
  (*-------------------------------------------------------*)
  //※[457]
  TABoneArray = class(TObject)
  protected

    FAboneArray: array of Byte;
    FModified: Boolean;
    //thread: TThreadItem;
    function GetAboneArray(ResNumber: Integer): Byte;
    Procedure SetAboneArray(ResNumber: Integer; Value: Byte);
    {beginner}
    function GetSize: Integer;
    procedure SetSize(Value: Integer);
    {/beginner}
  public
    //constructor Create;
    Procedure SetBlock(StartResNumber, EndResNumber: Integer; Value: Byte);
    function Load(Path: String): Boolean;
    function Save(Path: String): Boolean;
    Procedure Clear;
    function GetNearNotAboneResNumber(ResNumber: Integer): Integer;
    property AboneArray[Index: Integer]: Byte read GetAboneArray write SetAboneArray; default;
    property Size: Integer read GetSize write SetSize; //beginner
  end;
  (*-------------------------------------------------------*)
  TDat2HTML = class(TObject)
  private
    templateType: array of TTmplType;
    templateStr: TStringList;
  protected
    function _ToDatOut(dest: TDatOut;
                       const dataString: string;
                       startPos: integer;
                       line: integer;
                       datType: TDatType;
                       EnableNGToAbone: Boolean;       //beginner
                       AboneArray: TAboneArray = nil;
                       NeedConvert: Boolean = False  //aiai
                       ): Boolean;
  public
    NGItems: Array[TNGItemIdent] of TNGStringList; //beginner
{ beginner 消去
    NGnames: TStringList; (* 参照Only *)
    NGaddrs: TStringList; (* 参照Only *)
    NGwords: TStringList; (* 参照Only *)
    NGid:    TStringList;
}
    ExNGList: TExNGList; //beginner
    TransparencyAbone: Boolean; //※[457]
    VisibleAbone: Boolean;
    //thread: TObject; //521 readPos
    {beginner}
    AboneLevel:Integer;
    PermanentNG:Boolean;
    PermanentMarking:Boolean;
    {/beginner}
    LinkABone: Boolean;  //aiai
    constructor Create(body: string; skinpath: string);
    destructor Destroy; override;
    function ToDatOut(dest: TDatOut; dat: TThreadData;
                      startLine: Integer; lines: Integer;
                      AboneArray: TAboneArray = nil;
                      NeedConvert: Boolean = False //aiai
                      ): Integer;
    function PickUpRes(dest: TDatOut; dat: TThreadData; abonearray: TAboneArray; NeedConvert: Boolean;
                              startLine, endLine: integer): Integer;
    function ToString(dat: TThreadData; startLine, lines: Integer; NeedConvert: Boolean = False): String;
    function ToID(dat: TThreadData; line: Integer): String;  //aiai
  end;

  (*-------------------------------------------------------*)
  TPoorHTMLObjCode = (hocUNKNOWN, hocTEXT, hocTAG, hocENTITY, hocSCRIPT, hocSTYLE);
  TPoorHTMLParser = class(TObject)
  private
    FString: string;
    rangeStart: integer;
    rangeEnd:   integer;
    startPos:   integer;
    state: TPoorHTMLObjCode;
  public
    FLastChar: String;
    constructor Create(const AString: string;
                       RangeStart: integer = 0;
                       RangeSize : integer = 0);
    function GetBlock (var typeCode: TPoorHTMLObjCode;
                       var content: string): boolean;
  end;
  (*-------------------------------------------------------*)

(* datから指定行の位置情報を取得するナリ *)
function Dat2ChGetLine(const AString: string;
                       line: integer;
                       var startPos: integer;
                       var size:     integer): boolean;

(* dat文字列から区切りまでを取得するナリ *)
function Dat2ChGet2Delimiter(const AString: string;
                             startPos: integer;
                             var nextPos: integer): integer;

function Dat2ChGet2CommaDelimiter(const AString: string;
                             startPos: integer;
                             var nextPos: integer): integer;

procedure Dat2ChNextLine(dat: TThreadData);
function HTML2String(const AString: string): string;
function GetTagName(const AString: string): string;
function StripBlankLinesForHint(const AString: string; MaxLine: integer): string;
function GetDatType(const dat: TThreadData): TDatType;

var
  ABONE: string = 'あぼーん';

(*=======================================================*)
implementation
(*=======================================================*)

uses
  jconvert; //aiai

procedure THogeMemoryStream.WriteString(const str: string);
begin
  WriteBuffer(str[1], length(str));
end;

procedure THogeMemoryStream.WriteChar(c:Char);
begin
  WriteBuffer(c, 1);
end;

function THogeMemoryStream.ReadString: string;
var
  savePos: integer;
  count: integer;
  s: string;
begin
  count := Size;
  if count <= 0 then
  begin
    s := '';
  end
  else begin
    savePos := Position;
    Position := 0;
    SetLength(s, count);
    ReadBuffer(s[1], count);
    Position := savePos;
  end;
  result := s;
end;

(*=======================================================*)


function StripBlankLinesForHint(const AString: string;
                                   MaxLine: integer): string;
var
  ts: TStringList;
  i,j: integer;
  lines: integer;
  ws: WideString;
  count: integer;
begin
  ts := TStringList.Create;
  ts.Text := AString;
  result := '';
  lines := 0;
  for i := 0 to ts.Count -1 do
  begin
    ws := StringReplace(ts.Strings[i], #9, '', [rfReplaceAll]);
    count := 0;
    for j := length(ws) downto 1 do
    begin
      if (ws[j] = #13) or (ws[j] = #10) or (ws[j] = ' ') or (ws[j] = '　') then
      begin
      end
      else begin
        count := j;
        break;
      end;
    end;
    if 0 < count then
    begin
      result := result + Copy(ws, 1, count);
      Inc(lines);
      if MaxLine <= lines then
        break;
      result := result + #13#10;
    end;
  end;
  ts.Free;
end;

function GetTagName(const AString: string): string;
var
  i: integer;
begin
  result := '';
  for i := 2 to length(AString) do
  begin
    if AString[i] in ['A'..'Z','a'..'z','_','/'] then
      result := result + UpCase(AString[i])
    else
      break;
  end;
end;

(* datから指定行の位置情報を取得するナリ *)
function Dat2ChGetLine(const AString: string;
                       line: integer;
                       var startPos: integer;
                       var size:     integer): boolean;
var
  i, endPos, lcount: integer;
  p: PChar;
begin
  p := PChar(AString);
  endPos := length(AString);
  lcount := 1;
  startPos := 1;
  for i := 1 to endPos do
  begin
    if p^ = #10 then
    begin
      if line = lcount then
      begin
        size := i - startPos + 1;
        result := true;
        exit;
      end;
      Inc(lcount);
      startPos := i + 1;
    end;
    Inc(p);
  end;
  if (line = lcount) and (startPos <= endPos) then
  begin
    size := endPos - startPos + 1;
    result := true;
    exit;
  end;
  result := false;
end;

(* dat文字列から区切りまでを取得するナリ *)
function Dat2ChGet2Delimiter(const AString: string;
                             startPos: integer;
                             var nextPos: integer): integer;
var
  i, endPos: integer;
  p: PChar;
begin
  p := @AString[startPos];
  endPos := length(AString);
  for i := startPos to endPos do
  begin
    if p^ = '<' then
    begin
      if (i < endPos) and ((p+1)^ = '>') then
      begin
        result := i - startPos;
        nextPos := i + 2;
        exit;
      end;
    end
    else if p^ = #10 then
    begin
      result := i - startPos;
      nextPos := i;
      exit;
    end;
    Inc(p);
  end;
  result := 0;
  nextPos := endPos +1;
end;

function Dat2ChGet2CommaDelimiter(const AString: string;
                             startPos: integer;
                             var nextPos: integer): integer;
var
  i, endPos: integer;
  p: PChar;
begin
  p := @AString[startPos];
  endPos := length(AString);
  for i := startPos to endPos do
  begin
    if p^ = ',' then
    begin
      result := i - startPos;
      nextPos := i + 1;
      exit;
    end
    else if p^ = #10 then
    begin
      result := i - startPos;
      nextPos := i;
      exit;
    end;
    Inc(p);
  end;
  result := 0;
  nextPos := endPos +1;
end;

procedure Dat2ChNextLine(dat: TThreadData);
var
  i, block, start: integer;
  p: PChar;
begin
  with dat.FCacheInfo do
  begin
    p := @dat[FBlockIndex][FIndex];
    start := FIndex;
    for block := FBlockIndex to dat.Count -1 do
    begin
      if p = nil then
      begin
        p := @dat[block][1];
        start := 1;
      end;
      for i := start to length(dat[block]) do
      begin
        if p^ = #10 then
        begin
          if length(dat[block]) <= i then
          begin
            if dat.Count <= block then
            begin
              FIndex := -1;
              FBlockIndex := 0;
              FLineNumber := 0;
            end
            else begin
              FIndex := 1;
              FBlockIndex := block + 1;
              Inc(FLineNumber);
            end;
            exit;
          end;
          FIndex := i+1;
          FBlockIndex := block;
          Inc(FLineNumber);
          exit;
        end;
        Inc(p);
      end;
      p := nil;
    end;
  end;
end;


(*=======================================================*)
(*  *)
constructor TPoorHTMLParser.Create(
                const AString: string;
                RangeStart: integer;
                RangeSize:  integer);
begin
  FString := AString;
  if 0 < RangeStart then
    Self.rangeStart := RangeStart
  else
    Self.rangeStart := 1;
  if 0 < RangeSize then
    Self.rangeEnd := Self.rangeStart + RangeSize -1
  else
    Self.rangeEnd := length(AString);
  startPos := self.rangeStart;
  state := hocUNKNOWN;
end;

(*  *)
function TPoorHTMLParser.GetBlock(
                var typeCode: TPoorHTMLObjCode;
                var content:  string): boolean;
var
  i, size: integer;

  procedure CaseUNKNOWN;
    procedure CaseLT;
    var
      tagName: string;
    begin
      typeCode := hocTAG;
      if StartWith('<!--', FString, StartPos) then
      begin
        i := FindPos('-->', FString, StartPos + 4, rangeEnd);
        if 0 < i then
          inc(i, 3);
      end
      else begin
        i := FindPos('>', FString, StartPos + 1, rangeEnd);
        if 0 < i then
          inc(i);
      end;
      if 0 < i then
        size := i - StartPos
      else
        size := rangeEnd - StartPos + 1;
      typeCode := hocTAG;
      content := Copy(FString, startPos, size);
      tagName := GetTagName(content);
      if tagName = 'STYLE' then
        state := hocSTYLE
      else if tagName = 'SCRIPT' then
        state := hocSCRIPT;
    end;

    procedure CaseAmp;
    begin
      typeCode := hocENTITY;
      i := StartPos + 1;
      FLastChar := '';
      while i <= rangeEnd do
      begin
        case FString[i] of
        ';':
          begin
            size := i - StartPos + 1;
            content := Copy(FString, startPos+1, size -2);
            FLastChar := ';';
            exit;
          end;
        'A'..'Z','a'..'z','_','#','0'..'9': ;
        else
          begin
            size := i - StartPos;
            content := Copy(FString, startPos+1, size -1);
            exit;
          end;
        end;
        Inc(i);
      end;
      size := i - StartPos;
      content := Copy(FString, startPos+1, size-1);
      exit;
    end;

    function CopyNoCRLF(const str: string; startPos, size: integer): string;
    var
      src, dst: PChar;
      i: integer;
    begin
      SetLength(result, size);
      src := @str[startPos];
      dst := @result[1];
      for i := 1 to size do
      begin
        case src^ of
        #13, #10:;
        else
          begin
            dst^ := src^;
            Inc(dst);
          end;
        end;
        Inc(src);
      end;
      SetLength(result, dst - @result[1]);
    end;

  begin
    case FString[StartPos] of
    '<': CaseLT;
    '&': CaseAmp;
    else
      begin
        typeCode := hocTEXT;
        i := StartPos + 1;
        while i <= rangeEnd do
        begin
          case FString[i] of
          '<', '&':
            begin
              size := i - StartPos;
              content := CopyNoCRLF(FString, startPos, size);
              exit;
            end;
          end;
          Inc(i);
        end;
        size := i - StartPos;
        content := Copy(FString, startPos, size);
      end;
    end;
  end;

  procedure JumpTo(const tag: string);
  begin
    i := FindPosIC(tag, FString, startPos, rangeEnd);
    if 0 < i then
      size := i - startPos
    else
      size := rangeEnd - startPos + 1;
    content := Copy(FString, startPos, size);
  end;
begin
  if rangeEnd < StartPos then begin
    result := false;
    exit;
  end;
  case state of
  hocSTYLE:  begin JumpTo('</STYLE>'); state := hocUNKNOWN; typeCode := hocSTYLE; end;
  hocSCRIPT: begin JumpTo('</SCRIPT>'); state:= hocUNKNOWN; typeCode := hocSCRIPT; end; 
  else       CaseUNKNOWN;
  end;
  Inc(startPos, size);
  result := true;
end;

(*=======================================================*)

procedure Dat2ChFetchLine(const AString: string;
                          startPos: integer;
                          var nameStart, nameSize: integer;
                          var mailStart, mailSize: integer;
                          var dateStart, dateSize: integer;
                          var msgStart,  msgSize : integer);
var
  index: integer;
begin
  index := startPos;
  nameStart := index;
  nameSize := Dat2ChGet2Delimiter(AString, nameStart, index);
  mailStart := index;
  mailSize := Dat2ChGet2Delimiter(AString, mailStart, index);
  dateStart := index;
  dateSize := Dat2ChGet2Delimiter(AString, dateStart, index);
  msgStart := index;
  msgSize  := Dat2ChGet2Delimiter(AString, msgStart, index);
end;

procedure Dat2ChFetchCommaDelimitedLine(
                          const AString: string;
                          startPos: integer;
                          var nameStart, nameSize: integer;
                          var mailStart, mailSize: integer;
                          var dateStart, dateSize: integer;
                          var msgStart,  msgSize : integer);
var
  index: integer;
begin
  index := startPos;
  nameStart := index;
  nameSize := Dat2ChGet2CommaDelimiter(AString, nameStart, index);
  mailStart := index;
  mailSize := Dat2ChGet2CommaDelimiter(AString, mailStart, index);
  dateStart := index;
  dateSize := Dat2ChGet2CommaDelimiter(AString, dateStart, index);
  msgStart := index;
  msgSize  := Dat2ChGet2CommaDelimiter(AString, msgStart, index);
end;


{$IFNDEF OLD_PARSER}
procedure ProcTags(var outStr: THogeMemoryStream;
                  const str: string; startPos: integer; size: integer;
                  nameP: boolean);
var
  index, endPos: integer;

  function ProcStrip: boolean;
    function GetTagName: string;
    var
      i: integer;
      tag: string;
    begin
      for i := index+1 to endPos do
      begin
        case str[i] of
        '>', ' ', #1..#$1F: Break;
        else tag := tag + str[i];
        end;
      end;
      result := LowerCase(tag);
    end;
  var
    tag: string;
  begin
    (* <a href= xxx> </a> を除去 *)
    result := false;
    if str[index] = '<' then
    begin
      tag := GetTagName;
      if (tag = 'a') or (tag = '/a') then
      begin
        while (index <= endPos) and (str[index] <> '>') do
        begin
          Inc(index);
        end;
        Inc(index);
        result := true;
      end;
    end;
  end;

  function ProcHTTP: boolean;
    function GetURL: string;
    begin
      while index <= endPos do
      begin
        case str[index] of
        #$21, #$23..#$3B, #$3D, #$3F..#$7E: result := result + str[index];
        else break;
        end;
        Inc(index);
      end;
    end;
  var
    s: string;
  begin
    (* http://xxx or ttp://xxx *)
    if str[index] = 'h' then
    begin
      if StartWith('http://', str, index) or StartWith('https://', str, index) then //※[457]
      begin
        s := GetURL;
        outStr.WriteString('<a href=');
        outStr.WriteString(s);
        outStr.WriteString('>');
        outStr.WriteString(s);
        outStr.WriteString('</a>');
        result := true;
      end
      else if StartWith('htp://', str, index) then
      begin
        s := GetURL;
        outStr.WriteString('<a href=ht');
        outStr.WriteString(Copy(s, 2, high(integer)));
        outStr.WriteString('>');
        outStr.WriteString(s);
        outStr.WriteString('</a>');
        result := true;
      end
      else
        result := false;
    end
    else if StartWith('ttp://', str, index) then
    begin
      s := GetURL;
      outStr.WriteString('<a href=h');
      outStr.WriteString(s);
      outStr.WriteString('>');
      outStr.WriteString(s);
      outStr.WriteString('</a>');
      result := true;
    end else begin
      result := false;
    end;
  end;

    function GetRange(var ANK: string): string;
    var
      s: string;
    begin
      ANK := '';
      while index <= endPos do
      begin
        case str[index] of
        '0'..'9':
          begin
            s := s + str[index];
            ANK := ANK + str[index];
          end;
        '-':
          begin
            if length(s) <= 0 then
              break;
            s := s + str[index];
            ANK := ANK + str[index];
          end;
        #$81:
          begin
            if (index + 1 <= endpos) and (str[index+1] = #$7c) then
            begin (* － *)
              if length(s) <= 0 then
                break;
              s := s + '－';
              ANK := ANK + '-';
              inc(index);
            end
            else
              break;
          end;
        #$82:
          begin
            if (index + 1 <= endPos) and (str[index+1] in [#$4f..#$58]) then
            begin   (* 全角数字 *)
              inc(index);
              s := s + #$82 + str[index];
              ANK := ANK + Chr(Ord(str[index]) - $1f);
            end
            else
              break;
          end;
        else break;
        end;
        Inc(index);
      end;
      result := s;
    end;

    function DoRange(const prefix: string): boolean;
    var
      s, ANK: string;
      len: integer;
    begin
      len := length(prefix);
      Inc(index, len);
      s := GetRange(ANK);
      if 0 < length(s) then
      begin
        outStr.WriteString('<a href=#');
        outStr.WriteString(ANK);
        outStr.WriteString('>');
        outStr.WriteString(prefix);
        outStr.WriteString(s);
        outStr.WriteString('</a>');
        ProcStrip;
        while (index +2 < endPos) and (str[index] = ',') do
        begin
          inc(index);
          s := GetRange(ANK);
          if length(s) <= 0 then
          begin
            dec(index);
            break;
          end;
          outStr.WriteString(',<a href=#');
          outStr.WriteString(ANK);
          outStr.WriteString('>');
          outStr.WriteString(s);
          outStr.WriteString('</a>');
        end;
        result := true;
      end else begin
        Dec(index, len);
        result := false;
      end;
    end;
  function ProcRedirect: boolean;
  begin
    (* &gt;[&gt;]digit[,digit|-digit] *)
    result := false;
    if str[index] = '&' then
    begin
      if StartWith('&gt;&gt;', str, index) then
      begin
        result := DoRange('&gt;&gt;');
      end
      else if StartWith('&gt;', str, index) then
      begin
        result := DoRange('&gt;');
      end;
    end
    else if StartWith('＞＞', str, index) then
    begin
      result := DoRange('＞＞');
    end
    else if StartWith('＞', str, index) then
    begin
      result := DoRange('＞');
    end;
  end;

  function isAllNumber(startPos, endPos: integer): boolean;
  var
    i: integer;
  begin
    i := startPos;
    while i <= endPos do
    begin
      case str[i] of
      '0'..'9': ;
      #$82:
        begin
          if (i <= endPos) and (str[i+1] in [#$4f..#$58]) then
          begin
            inc(i);
          end
          else begin
            result := false;
            exit;
          end;
        end;
      else
        begin
          result := false;
          exit;
        end;
      end;
      Inc(i);
    end;
    result := true;
  end;

  procedure ProcName;
  var
    endTag: integer;
  begin
    if ProcRedirect then
    begin
      if index <= endPos then
        outStr.WriteString(Copy(str, index, endPos - index + 1));
    end
    else if isAllNumber(index, endPos) then
    begin
      DoRange('');
    end
    else if (index < endPos) and (str[index] = '<') and
         StartWith('<b>', str, index) then (* カンマ区切り形式 *)
    begin
      outStr.WriteString(Copy(str, index, 3));
      inc(index, 3);
      if ProcRedirect and (index <= endPos) then
      begin
        outStr.WriteString(Copy(str, index, endPos - index + 1));
      end
      else begin
        endTag := FindPos('</b>', str, index, endPos);
        if (endTag + 3 = endPos) and
           isAllNumber(index, endTag-1) then
          DoRange('');
        outStr.WriteString(Copy(str, index, endPos - index + 1));
      end;
    end
    else
      outStr.WriteString(Copy(str, startPos, size));
  end;
begin
  endPos := startPos + size -1;
  if length(str) < endPos then
    endPos := length(str);
  index := startPos;
  if nameP then
  begin
    ProcName;
  end
  else begin
    while (index <= endPos) do
    begin
      if not ((str[index] = '<') and ProcStrip) and
         not ((str[index] in ['h','t']) and ProcHTTP) and
         not ((str[index] in ['&', #$81]) and ProcRedirect) then
      begin
        outStr.WriteChar(str[index]);
        Inc(index);
      end;
    end;
  end;
end;
{$ENDIF}

function GetDatType(const dat: TThreadData): TDatType;
var
  i: integer;
begin
  result := dtComma;
  if dat.Count <= 0 then
    exit;
  i := Pos(#10, dat.Strings[0]);
  if 0 < FindPos('<>', dat.Strings[0], 1, i) then
    result := dtNormal;
end;

(*=======================================================*)

constructor TThreadData.Create;
begin
  inherited;
  FDirtyIndex := -1;
  FConsistent := True;
  ClearCacheInfo;
end;

destructor TThreadData.Destroy;
begin
  Clear;
  inherited;
end;

function TThreadData.Add(const AString: string): Integer;
begin
  result := AddObject(AString, Pointer(CountLines(AString)));
end;

function TThreadData.AddObject(const AString: string; AObject: TObject): Integer;
begin
  if FDirtyIndex < 0 then
    FDirtyIndex := Count;
  result := inherited AddObject(AString, AObject);
end;

procedure TThreadData.Clear;
begin
  inherited;
  FDirtyIndex := -1;
  FConsistent := True;
  ClearCacheInfo;
end;

procedure TThreadData.LoadFromFile(const fileName: string);
var
  fs: TFileStream;
  s: string;
  fileSize: cardinal;
begin
  Clear;
  fs := TFileStream.Create(fileName, fmOpenRead);
  fileSize := fs.Size;
  SetLength(s, fileSize);
  fs.ReadBuffer(s[1], fileSize);
  fs.Free;
  Add(s);
  FDirtyIndex := -1;
end;

procedure TThreadData.SaveToFile(const fileName: string);
var
  hFile: THandle;
  i: integer;
  written: Cardinal;
  procedure Write(const str: AnsiString);
  var
    p: PChar;
  begin
    p := PChar(str);
    Windows.WriteFile(hFile, p^, length(str), written, nil);
  end;
var
  offset: Cardinal;
begin
  hFile := Windows.CreateFile(PChar(fileName),
                              GENERIC_WRITE,
                              FILE_SHARE_READ,
                              nil,
                              OPEN_ALWAYS,
                              FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN,
                              0);
  if hFile = INVALID_HANDLE_VALUE then
    exit;
  offset := 0;
  for i := 0 to Count -1 do
  begin
    if FDirtyIndex <= i then
      Write(Strings[i])
    else begin
      Inc(offset, Length(Strings[i]));
      Windows.SetFilePointer(hFile, offset, nil, FILE_BEGIN);
    end;
  end;
  Windows.SetEndOfFile(hFile);
  Windows.CloseHandle(hFile);
  FDirtyIndex := Count;
end;

procedure TThreadData.ClearCacheInfo;
begin
  FCacheInfo.FLineNumber := 0;
end;

function TThreadData.FindLine(lineNumber: integer): Boolean;
var
  i, lines: integer;
begin
  if lineNumber <= 0 then
  begin
    result := False;
    exit;
  end;
  result := True;
  if lineNumber = FCacheInfo.FLineNumber then
    exit;
  lines := 0;
  for i := 0 to Count -1 do
  begin
    if lineNumber <= lines + Integer(Objects[i]) then
    begin
      FCacheInfo.FLineNumber := lineNumber;
      FCacheInfo.FBlockIndex := i;
      if lineNumber = lines + 1 then
        FCacheInfo.FIndex := 1
      else
        FCacheInfo.FIndex := Nth(Strings[i], #10, lineNumber - lines -1) + 1;
      exit;
    end;
    Inc(lines, Integer(Objects[i]));
  end;
  result := False;
end;

function TThreadData.CalcLines: Integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to Count -1 do
    Inc(result, Integer(Objects[i]));
end;

function TThreadData.GetSize: Cardinal;
var
  i: integer;
begin
  result := 0;
  for i := 0 to Count -1 do
    Inc(result, length(Strings[i]));
end;

function TThreadData.GetPosition: Cardinal;
var
  block: integer;
begin
  result := 0;
  if FCacheInfo.FLineNumber <= 0 then
    self.FindLine(1);
  if FCacheInfo.FLineNumber <= 0 then
    exit;
  for block := 0 to FCacheInfo.FBlockIndex -1 do
    Inc(result, length(Strings[block]));
  Inc(result, FCacheInfo.FIndex -1);
end;

function TThreadData.Contains(const target: string; NeedConvert: Boolean): boolean;
var
  i: integer;
  tmpbuffer: String;
begin
  for i := 0 to Count -1 do
  begin
    if NeedConvert then
    begin
      tmpbuffer := euc2sjis(Strings[i]);
      if 0 < FindPosIC(target, tmpbuffer, 1) then
      begin
        result := True;
        exit;
      end;
    end else
    begin
      if 0 < FindPosIC(target, Strings[i], 1) then
      begin
        result := True;
        exit;
      end;
    end;
  end;
  result := False;
end;

function TThreadData.Dup: TThreadData;
var
  i: integer;
begin
  result := TThreadData.Create;
  result.FDirtyIndex := FDirtyIndex;
  result.FCacheInfo := FCacheInfo;
  result.FConsistent := FConsistent;
  for i := 0 to Count -1 do
    result.Add(Strings[i]);
end;

{nono}
function TThreadData.GetDatItem(line: Integer; DatItem: TDatItem):string;
var
  datType: TDatType;
  dataString: string;
  startPos: integer;
  nameStart, nameSize: integer;
  mailStart, mailSize: integer;
  dateStart, dateSize: integer;
  msgStart,  msgSize : integer;
  strName, strMail, strDate, strMsg: string;
begin
  datType := GetDatType(Self);
  if not FindLine(line) then
  begin
    Result := '';
    exit;
  end;
  if Count <= FCacheInfo.FBlockIndex then
  begin
    Result := '';
    exit;
  end;

  dataString := Strings[FCacheInfo.FBlockIndex];
  startPos := FCacheInfo.FIndex;

  if datType = dtComma then
  begin
    Dat2ChFetchCommaDelimitedLine(
                  dataString, startPos,
                  nameStart, nameSize,
                  mailStart, mailSize,
                  dateStart, dateSize,
                  msgStart, msgSize);
    if 0 < FindPos('＠｀', dataString, nameStart, nameStart + nameSize -1) then
    begin
      strName := AnsiReplaceStr(Copy(dataString, nameStart, nameSize), '＠｀', ',');
      nameSize := length(strName);
    end
    else
      strName := Copy(dataString, nameStart, nameSize);
    if 0 < FindPos('＠｀', dataString, mailStart, mailStart + mailSize -1) then
    begin
      strMail := AnsiReplaceStr(Copy(dataString, mailStart, mailSize), '＠｀', ',');
      mailSize := length(strMail);
    end
    else
      strMail := Copy(dataString, mailStart, mailSize);
    if 0 < FindPos('＠｀', dataString, dateStart, dateStart + dateSize -1) then
    begin
      strDate := AnsiReplaceStr(Copy(dataString, dateStart, dateSize), '＠｀', ',');
      dateSize := length(strDate);
    end
    else
      strDate := Copy(dataString, dateStart, dateSize);
    if 0 < FindPos('＠｀', dataString, msgStart, msgStart + msgSize -1) then
    begin
      strMsg := AnsiReplaceStr(Copy(dataString, msgStart, msgSize), '＠｀', ',');
      msgSize := length(strMsg);
    end
    else
      strMsg := Copy(dataString, msgStart, msgSize);
  end
  else begin
    Dat2ChFetchLine(dataString, startPos,
                    nameStart, nameSize,
                    mailStart, mailSize,
                    dateStart, dateSize,
                    msgStart, msgSize);
    //strName := Copy(dataString, nameStart, nameSize);
    //strMail := Copy(dataString, mailStart, mailSize);
    //strDate := Copy(dataString, dateStart, dateSize);
    //strMsg := Copy(dataString, msgStart, msgSize);
    SetString(strName, PChar(dataString) + nameStart - 1, nameSize);
    SetString(strMail, PChar(dataString) + mailStart - 1, mailSize);
    SetString(strDate, PChar(dataString) + dateStart - 1, dateSize);
    SetString(strMsg, PChar(dataString) + msgStart - 1, msgSize);
  end;
  if dateSize <= 0 then
  begin
    strName := '';
    strMail := '';
    strDate := '';
    strMsg := '';
  end;

  case DatItem of
    diName: Result := strName;
    diMail: Result := strMail;
    diDate: Result := strDate;
    diMsg: Result := strMsg;
    else
      Result := '';
  end;
end;

function TThreadData.FetchName(line: Integer):string;
begin
  Result := GetDatItem(line, diName);
end;

function TThreadData.FetchMail(line: Integer):string;
begin
  Result := GetDatItem(line, diMail);
end;

function TThreadData.FetchID(line: Integer):string;
var
  source: String;
  p: PChar;
  i, startPos, endPos: integer;
begin
  source := GetDatItem(line, diDate);
  startPos := AnsiPos('ID:', source);
  if startPos > 0 then
  begin
    p := @source[startPos + 3];
    endPos := length(source);
    Result := '';
    for i := startPos + 3 to endPos do
    begin
      if p^ = ' ' then
        break;
      Result := Result + p^;
      Inc(p);
    end;
  end else
    Result := '';
end;

function TThreadData.FetchMessage(line: Integer):string;
begin
  Result := GetDatItem(line, diMsg);
end;
{/nono}

function TThreadData.MatchID(const target: PChar; line: Integer): Boolean;
var
  datType: TDatType;
  dataString: string;
  startPos: integer;
  nameStart, nameSize: integer;
  mailStart, mailSize: integer;
  dateStart, dateSize: integer;
  msgStart,  msgSize : integer;
  tmpbuffer: string;
  date, id: PChar;
  index, index2: integer;
begin
  Result := False;
  datType := GetDatType(Self);
  if not FindLine(line) then
  begin
    exit;
  end;
  if Count <= FCacheInfo.FBlockIndex then
  begin
    exit;
  end;

  dataString := Strings[FCacheInfo.FBlockIndex];
  startPos := FCacheInfo.FIndex;
  date := nil;
  if datType = dtComma then
  begin
    Dat2ChFetchCommaDelimitedLine(
                  dataString, startPos,
                  nameStart, nameSize,
                  mailStart, mailSize,
                  dateStart, dateSize,
                  msgStart, msgSize);
   if 0 < FindPos('＠｀', dataString, dateStart, dateStart + dateSize -1) then
    begin
      tmpbuffer := AnsiReplaceStr(Copy(dataString, dateStart, dateSize), '＠｀', ',');
      date := PChar(tmpbuffer);
      dateSize := length(tmpbuffer);
    end;
  end
  else begin
    Dat2ChFetchLine(dataString, startPos,
                    nameStart, nameSize,
                    mailStart, mailSize,
                    dateStart, dateSize,
                    msgStart, msgSize);
    date := PChar(dataString) + dateStart - 1;
  end;
  if dateSize <= 0 then
  begin
    Result := False;
    exit;
  end;

  index := 0;
  while index < dateSize do
  begin
    if (date + index)^ = 'I' then break;
    Inc(index);
  end;

  id := date + index;
  index2 := index;

  if ((index2 + 3) < dateSize) and ((date + index2 + 1)^ = 'D')
    and ((date + index2 + 2)^ = ':') and ((date + index2 + 3)^ <> '?')then
  begin
    Inc(index, 3);

    (* IDの末尾を探す *)
    while index2 < dateSize do
    begin
      if ((date + index2)^ in [' ']) then
        break;
      Inc(index2);
    end;

    //WriteID(id + index + 3, index - 3);
    Result := StrLComp(target, id + 3, index2 - index - 3) = 0;
  end;
end;

(*=======================================================*)
constructor TDatOut.Create;
begin
  inherited;
end;

destructor TDatOut.Destroy;
begin
  inherited;
end;

procedure TDatOut.WriteHTML(str: PChar; size: integer);
begin
  WriteItem(str, size, ditNORMAL);
end;

procedure TDatOut.WriteHTML(str: String);
begin
  WriteHTML(PChar(str), length(str));
end;

procedure TDatOut.WriteText(str: String);
begin
  WriteText(PChar(str), length(str));
end;

procedure TDatOut.WriteChar(c: Char);
begin
  WriteText(@c, 1);
end;

procedure TDatOut.Flush;
begin
end;

(*=======================================================*)
procedure TConvDatOut.EndOfTag;
var
  quote: boolean;
begin
  quote := false;
  while index < size do
  begin
    if (str + index)^ = '"' then
      quote := not quote
    else if (not quote) and ((str + index)^ = '>') then
    begin
      Inc(index);
      exit;
    end;
    Inc(index);
  end;
end;

(* タグ名取得(小文字化) *)
function TConvDatOut.GetTagName: string;
var
  i: integer;
  tag: string;
begin
  for i := index to size - 1 do
  begin
    case (str + i)^ of
    '>', ' ', #1..#$1F, '=':
      begin
        index := i;
        result := LowerCase(tag);
        exit;
      end;
    else tag := tag + (str + i)^;
    end;
  end;
  result := LowerCase(tag);
  index := size;
end;

//aiai
//substrとstrの先頭lenバイトを比較する
function TConvDatOut.IsThisTag(substr, str: PChar; len: Integer): Boolean;
var
  i, ord1, ord2: Integer;
begin
  Result := False;

  if index + len >=  size then
    exit;

  for i := 0 to len - 1 do
  begin
    ord1 := Ord((substr + i)^);
    ord2 := Ord((str + i)^);
    if ord1 = ord2 then
      Continue
    else if Abs(ord1 - ord2) = $20 then
      Continue
    else
      exit;
  end;
  if (str + len) ^ in ['>', ' ', #1..#$1F, '='] then
    Result := True;
end;


function TConvDatOut.GetAttribPair(var name, value: string): Boolean;
var
  i: integer;
label GOTVALUE;
begin
  while (index < size -1) and ((str + index)^ <> '>') do
  begin
    SkipSpaces;
    if (index < size -1) then
    begin
      name := GetTagName;
      SkipSpaces;
      if (index < size -1) and ((str + index)^ = '=') then
      begin
        Inc(index);
        SkipSpaces;
        value := '';
        if (index < size -1) and ((str + index)^ = '"') then
        begin
          for i := index + 1 to size -1 do
          begin
            case (str + i)^ of
            '>': begin index := i; goto GOTVALUE;; end;
            '"': begin index := i + 1; goto GOTVALUE; end;
            else value := value + (str + i)^;
            end;
          end;
          index := size -1;
        end
        else
        {aiai}
          //value := GetTagName;
        begin
          for i := index to size -1 do
          begin
            case (str + i)^ of
            '>': begin index := i; goto GOTVALUE;; end;
            ' ': begin index := i + 1; goto GOTVALUE; end;
            else value := value + (str + i)^;
            end;
          end;
          index := size -1;
        end;
        {/aiai}
        GOTVALUE:
          result := True;
          exit;
      end;
    end;
  end;
  result := False;
end;


procedure TConvDatOut.SkipSpaces;
var
  i: integer;
begin
  for i := index to size -1 do
  begin
    case (str + i)^ of
    #0..#$20:;
    else
      begin
        index := i;
        exit;
      end;
    end;
  end;
end;

function TConvDatOut.GetURL: string;
{beginner}   //URLで有効な文字への参照を解決する(それ以外はあえて無視)
var
  buf:string;
  code:Integer;
  power:Integer;
  refChar:Set of Char;
begin
  while index < size do
  begin
    case (str + index)^ of
    '&':begin
      inc(index);
      if StrLComp(str + index,'amp',3)=0 then begin
        inc(index,3);
        result := result + '&';
        if (str + index)^=';' then inc(index);
      end else if (str + index)^='#' then begin
        code:=0;
        inc(index);
        if (str + index)^='x' then begin
          buf:='&#x';
          inc(index);
          power:=16;
          refChar:=['0'..'9','a'..'f','A'..'F'];
        end else begin
          buf:='&#';
          power:=10;
          refChar:=['0'..'9'];
        end;
        while (str + index)^ in refChar do begin
          buf:=buf+(str + index)^;
          if code<256 then
            code := code * power + HexToInt((str + index)^);
          inc(index);
        end;
        if code in [$21, $23..$2f, $3a, $3B, $3D, $3F..$7E] then begin
          result := result + char(code);
          if (str + index)^=';' then inc(index);
        end else begin
          result := result + buf;
        end;
      end else
        result := result + '&';
    end;
    #$21, #$23..#$25,#$27..#$3B, #$3D, #$3F..#$7E:begin
      result := result + (str + index)^;
      Inc(index);
    end;
    else break;
    end;
  end;
{/beginner}
end;


function TConvDatOut.GetRange(var ANK: string): string;
var
  s, s2: string;
  num, num2: Integer;
  flag: Boolean;
begin
  ANK := '';
  s2 := '';
  flag := false;
  num := 0;
  while index < size do
  begin
    case (str + index)^ of
    '0'..'9':
      begin
        if flag then
          s2 := s2 + (str + index)^;
        s := s + (str + index)^;
        ANK := ANK + (str + index)^;
      end;
    '-':
      begin
        if length(s) <= 0 then
          break;
        num := StrToIntDef(ANK, 0);
        flag := true;
        s := s + (str + index)^;
        ANK := ANK + (str + index)^;
      end;
    #$81:
      begin
        if (index + 1 < size) and
           (((str + index+1)^ = #$7c) or
            ((str + index+1)^ = #$5d))  then
        begin (* － *)
          if length(s) <= 0 then
            break;
          num := StrToIntDef(ANK, 0);
          flag := true;
          s := s + #$81 + (str + index+1)^; //'－';
          ANK := ANK + '-';
          inc(index);
        end
        else
          break;
      end;
    #$82:
      begin
        if (index + 1 < size) and ((str + index+1)^ in [#$4f..#$58]) then
        begin   (* 全角数字 *)
          inc(index);
          s := s + #$82 + (str + index)^;
          ANK := ANK + Chr(Ord((str + index)^) - $1f);
          if flag then
            s2 := s2 + Chr(Ord((str + index)^) - $1f);
        end
        else
          break;
      end;
    else break;
    end;
    Inc(index);
  end;
  result := s;
  if length(s2) > 0 then
  begin
    num2 := StrToIntDef(s2, 0);
    AppendResNumList(num, num2);
  end else if length(s) > 0 then
  begin
    num := StrToIntDef(ANK, 0);
    AppendResNumList(num);
  end;
end;

function TConvDatOut.ProcTag: boolean;
begin
  result := False;
end;

function TConvDatOut.ProcEntity: boolean;
begin
  result := False;
end;

function TConvDatOut.ProcBlank: boolean;
begin
  result := False;
end;

//aiai
function TConvDatOut.ProcDayOfWeek: Boolean;
begin
  result := False;
end;

//aiai
function TConvDatOut.ProcID: Boolean;
begin
  result := False;
end;

function TConvDatOut.DoRange(const prefix: string): boolean;
var
  s, ANK: string;
  len: integer;
  c: Char;
begin
  len := length(prefix);
  Inc(index, len);
  s := GetRange(ANK);
  if 0 < length(s) then
  begin
    s := AnsiReplaceStr(prefix + s, '&gt;', '>');
    WriteAnchor('', '#' + ANK, PChar(s), length(s));
    ProcTag;
    while (index + 2 < size) and ((str + index)^ in [',', '=']) do
    begin
      c := (str + index)^;
      inc(index);
      s := GetRange(ANK);
      if length(s) <= 0 then
      begin
        dec(index);
        break;
      end;
      WriteChar(c);
      WriteAnchor('', '#' + ANK, PChar(s), length(s));
    end;
    result := true;
  end else
  begin
    Dec(index, len);
    result := false;
  end;
end;

function TConvDatOut.ProcRedirect: boolean;
begin
  (* &gt;[&gt;]digit[,digit|-digit] *)
  result := false;
  if (str + index)^ = '&' then
  begin
    if StartWithP('&gt;&gt;', str + index, size - index) then
      result := DoRange('&gt;&gt;')
    else if StartWithP('&gt;', str + index, size - index) then
      result := DoRange('&gt;');
  end
  else if StartWithP('＞＞', str + index, size - index) then
    result := DoRange('＞＞')
  else if StartWithP('＞', str + index, size - index) then
    result := DoRange('＞');
end;

function TConvDatOut.ProcURL: boolean;
var
  s: string;
begin
  (* http://xxx or ttp://xxx *)
  if FDisableLink then
  begin
    Result := False;
    Exit;
  end;
  result := true;

  if (str + index)^ = 'h' then
  begin
    if StartWithP('http://', str + index, size - index) or
       StartWithP('https://', str + index, size - index) then
    begin
      s := GetURL;
      WriteAnchor('', s, PChar(s), length(s));
    end
    else if StartWithP('htp://', str + index, size - index) then
    begin
      s := GetURL;
      WriteAnchor('', 'ht' + Copy(s, 2, high(integer)), PChar(s), length(s));
    end
    else
      result := false;
  end
  else if StartWithP('ttp://', str + index, size - index) then
  begin
    s := GetURL;
    WriteAnchor('', 'h' + s, PChar(s), length(s));
  end
  else
    result := false;
end;


procedure TConvDatOut.ProcHTML;
label
  ProcChar;
var
  idx2: Integer;
begin
  while (index < size) do
  begin
    case (str + index)^ of
      '<':
        if not ProcTag then
          goto ProcChar;
      'h', 't':
        if not ProcURL then
          goto ProcChar;
      #$81:
        if not ProcRedirect then
          goto ProcChar;
      '&':
        if not (ProcRedirect or ProcEntity) then
          goto ProcChar;
      ' ':
        if not ProcBlank then
          goto ProcChar;
      #0..#$1F:
        Inc(index);
    else
      ProcChar:
      idx2 := index + 1;
      while (idx2 < size) and not ((str + idx2)^ in ['<', 'h', 't', #$81, '&', ' ', #0..#$1f]) do
        Inc(idx2);
      WriteText(str + index, idx2 - index);
      index := idx2;
    end;
  end;
end;

procedure TConvDatOut.ProcHTMLB;
begin
  while (index < size) do
  begin
    if not ((((str + index)^ = '<') and ProcTag) or
           (((str + index)^ = '&') and ProcEntity) or
           (((str + index)^ = ' ') and ProcBlank)) then
    begin
      case (str + index)^ of
      #0..#$1F:;
      else
        WriteChar((str + index)^);
      end;
      Inc(index);
    end;
  end;
end;

procedure TConvDatOut.ProcName;
begin
  if isAllNumber(str, index, index + size) then
    DoRange('')
  else
    ProcHTML;
end;

{aiai}
procedure TConvDatOut.ProcDate;

  function ProcBE: Boolean;
  var
    sep, index2: Integer;
    BEID, BEPOINT: String;
  begin
    Result := False;
    index2 := index;
    if ((index2 + 3) < size) and ((str + index2 + 1)^ = 'E')
      and ((str + index2 + 2)^ = ':') then
    begin
      Inc(index2, 3);
      sep := 0;

      (* BEIDの'-'と末尾を探す *)
      while index2 < size do
      begin
        case (str + index2)^ of
        '-': sep := index2;
        ' ': break;
        end;
        Inc(index2);
      end;
      if (sep = 0) or ((index2 - sep - 1) <= 0) then
      begin
        SetString(BEID, str + index, index2 - index - 1);
        BEPOINT := ' '
      end else
      begin
        SetString(BEID, str + index, sep - index);
        SetString(BEPOINT, str + sep + 1, index2 - sep - 1);
      end;
      WriteAnchor('', BEID, PChar('?' + BEPOINT), Length(BEPOINT) + 1);
      index := index2;
      Result := True;
    end;
  end;

label
  ProcChar;
var
  idx2: Integer;
begin

  ProcDayOfWeek;

  while (index < size) do
  begin
    case (str + index)^ of
      'I': if not ProcID then
             goto ProcChar;
      'B': if not ProcBE then
             goto ProcChar;
      '<': if not ProcTag then
             goto ProcChar;
    else
      ProcChar:
      idx2 := index + 1;
      while (idx2 < size) and not ((str + idx2)^ in ['<', 'I', 'B']) do
        Inc(idx2);
      WriteText(str + index, idx2 - index);
      index := idx2;
    end;
  end;
end;
{/aiai}

procedure TConvDatOut.AppendResNumList(num: Integer);
begin
end;

procedure TConvDatOut.AppendResNumList(num, num2: Integer);
begin
end;

procedure TConvDatOut.WriteItem(str: PChar; size: integer; itemType: TDatItemType);
begin
  Self.str   := str;
  Self.index := 0;
  Self.size  := size;
  Case itemType of
    ditNAME: ProcName;
    ditMAILNAME: ProcHTMLB;
    ditDATE: ProcDATE; //aiai
  else
    ProcHTML;
  end;
end;

procedure TConvDatOut.SetLine(line: integer);
begin
 Self.line := line;
end;

(*=======================================================*)

constructor TStrDatOut.Create;
begin
  inherited;
  FString := '';
  FPosition := 0;
  FSize := 0;
  FSupress := False;
end;

destructor TStrDatOut.Destroy;
begin
  inherited;
end;

function TStrDatOut.ProcTag: boolean;
var
  tag: string;
begin
  if (str + index)^ = '<' then
  begin
    Inc(index);
    tag := GetTagName;
    if (tag = 'br') or (tag = 'hr') or (tag = '/p') or (tag = '/li') or
       (tag = 'ul') or (tag = 'dd') or (tag = '/title') then
      WriteText(#13#10)
    else if (tag = 'script') then
      FSupress := True
    else if (tag = '/script') then
      FSupress := False;
    EndOfTag;
    result := True;
  end
  else
    result := false;
end;

function TStrDatOut.ProcEntity: boolean;
var
  i: integer;
  s, sEnd: string;
{beginner}
var
  len, val: Integer;
  function OutCode: Boolean;
  begin
    if (val>=32) and (val<=127) then begin //koreawatcher
      WriteChar(char(val));
      Result := True;
    end else begin
      SetString(s, str + i - 1, len + 1); //koreawatcher
      Result := False;
    end;
    Inc(i, len);
  end;
{/beginner}

begin
  s := '';
  result := True;
  i := index + 1;

{beginner}
  if (str + i)^ = '#' then
  begin
    val := 0;
    Inc(i);
    if (str + i)^ in ['X','x'] then
    begin
      Inc(i);
      s := '#';
      if GetHex(str + i, size - i, val, len) then begin
        if OutCode then begin
          index := i;
          if (index < size) and ((str + index)^ = ';') then
            Inc(index);
          exit;
        end;
      end;
    end else begin

      if GetDecimal(str + i, size - i, val, len) then begin
        if OutCode then begin
          index := i;
          if (index < size) and ((str + index)^ = ';') then
            Inc(index);
          exit;
        end;
      end;
    end;
  end else
{/beginner}

  while i < size do
  begin
    case (str + i)^ of
    'A'..'Z','a'..'z':
      begin
        s := s + (str + i)^;
        if s = 'amp' then
        begin
          WriteChar('&');
          index := i + 1;
          if (index < size) and ((str + index)^ = ';') then
            Inc(index);
          exit;
        end;
      end;
    else
      begin
        if (str + i)^ = ';' then
        begin
          sEnd := (str + i)^;
          Inc(i);
        end;
        if (s = 'gt') then
          WriteChar('>')
        else if (s = 'lt') then
          WriteChar('<')
        else if (s = 'amp') then
          WriteChar('&')
        else if (s = 'quot') then
          WriteChar('"')
        else if (s = 'nbsp') or (s = 'ensp') or (s = 'thinsp') then
          WriteChar(' ')
        else if (s = 'copy') then
          WriteText('(c)')
        else
          WriteText('&' + s + sEnd);
        index := i;
        exit;
      end;
    end;
    Inc(i);
  end;
  WriteText('&' + s);
  index := i;
end;

function TStrDatOut.ProcBlank: boolean;
begin
  result := false;
end;

procedure TStrDatOut.WriteText(str: PChar; size: integer);
begin
  if FSupress then
    exit;
  if FSize < FPosition + size then
  begin
    FSize := FPosition + size + 1024;
    SetLength(FString, FSize);
  end;
  Move(str^, FString[FPosition+1], size);
  Inc(FPosition, size);
end;

procedure TStrDatOut.WriteAnchor(const Name: string;
                                 const HRef: string;
                                 str: PChar; size: integer);
begin
  WriteText(str, size);
end;

function TStrDatOut.GetText: String;
begin
  if FPosition <> FSize then
    SetLength(FString, FPosition);
  result := FString;
end;

procedure TStrDatOut.ProcHTML;
begin
  while (index < size) do
  begin
    if not ((((str + index)^ = '<') and ProcTag) or
           (((str + index)^ = '&') and ProcEntity) or
           (((str + index)^ = ' ') and ProcBlank)) then
    begin
      case (str + index)^ of
      #0..#$1F:;
      else
        WriteChar((str + index)^);
      end;
      Inc(index);
    end;
  end;
end;

procedure TStrDatOut.WriteItem(str: PChar; size: integer; itemType: TDatItemType);
begin
  Self.str   := str;
  Self.index := 0;
  Self.size  := size;
  case itemType of
  ditDATE: ProcDate;
  else
  ProcHTML;
  end;
end;
(*=======================================================*)

{aiai}
constructor TIDDatOut.Create;
begin
  inherited;
  FString := '';
  FPosition := 0;
  FSize := 0;
end;

destructor TIDDatOut.Destroy;
begin
  inherited;
end;

function TIDDatOut.GetText: String;
begin
  if FPosition <> FSize then
    SetLength(FString, FPosition);
  result := FString;
end;

function TIDDatOut.ProcID: boolean;
var
  index2: Integer;
begin
  Result := False;
  index2 := index;
  if ((index2 + 3) < size) and ((str + index2 + 1)^ = 'D')
    and ((str + index2 + 2)^ = ':') and ((str + index2 + 3)^ <> '?')then
  begin
    Inc(index2, 3);

    (* IDの末尾を探す *)
    while index2 < size do
    begin
      if ((str + index2)^ in [' ']) then
        break;
      Inc(index2);
    end;

    if FSize < FPosition + index2 - index - 3 then
    begin
      FSize := FPosition + index2 - index - 3 + 1024;
      SetLength(FString, FSize);
    end;
    Move((str + index + 3)^, FString[FPosition+1], index2 - index - 3);
    Inc(FPosition, index2 - index - 3);

    index := index2;
    Result := True;
  end;
end;

procedure TIDDatOut.WriteText(str: PChar; size: integer);
begin
end;

procedure TIDDatOut.WriteAnchor(const Name: string;
                                 const HRef: string;
                                 str: PChar; size: integer);
begin
end;

procedure TIDDatOut.WriteItem(str: PChar; size: integer; itemType: TDatItemType);
begin
  case itemType of
    ditDATE: begin
      Self.str   := str;
      Self.index := 0;
      Self.size  := size;
      ProcDate;
    end;
  end;
end;
{/aiai}

(*=======================================================*)
(*  *)
constructor TDat2HTML.Create(body: string; skinpath: string);
  procedure Analize;
  var
    i, len: integer;
    s: string;
    procedure Flush(typeCode: TTmplType);
    begin
      if (typeCode = TYPE_TEXT) and (Length(s) <= 0) then
        exit;
      TemplateStr.Add(s);
      SetLength(TemplateType, TemplateStr.Count);
      TemplateType[TemplateStr.Count -1] := typeCode;
      s := '';
    end;
  begin
    len := Length(body);
    if len <= 0 then
      exit;
    i := 1;
    while i <= len do
    begin
      if body[i] = '<' then
      begin
        if StartWith('<NUMBER/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_NUMBER);
          i := i + 8;
        end else if StartWith('<PLAINNUMBER/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_PLAINNUMBER);
          i := i + 13;
        end else if StartWith('<NAME/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_NAME);
          i := i + 6;
        end else if StartWith('<MAILNAME/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_MAILNAME);
          i := i + 10;
        end else if StartWith('<MAIL/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_MAIL);
          i := i + 6;
        end else if StartWith('<SAGE/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_SAGE);
          i := i + 6;
        end else if StartWith('<SAGEONLY/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_SAGEONLY);
          i := i + 10;
        end else if StartWith('<DATE/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_DATE);
          i := i + 6;
        end else if StartWith('<MESSAGE/>', body, i) then
        begin
          Flush(TYPE_TEXT);
          Flush(TYPE_MESSAGE);
          i := i + 9;
        end else if StartWith('<SKINPATH/>', body, i) then
        begin
          s := s + skinpath;
          i := i + 10;
        end
        else begin
          s := s + body[i];
        end;
      end else begin
        s := s + body[i];
      end;
      Inc(i);
    end;
    Flush(TYPE_TEXT);
  end;
begin
  inherited Create;
  {beginner}
  NGItems[NG_ITEM_NAME] := nil;
  NGItems[NG_ITEM_MAIL] := nil;
  NGItems[NG_ITEM_MSG]  := nil;
  NGItems[NG_ITEM_ID]   := nil;
  {/beginner}
  TransparencyAbone := false; //※[457]
  TemplateStr := TStringList.Create;
  Analize;
end;

destructor TDat2HTML.Destroy;
begin
  TemplateStr.Free;
  SetLength(TemplateType, 0);
  inherited;
end;

(*=======================================================*)
const
  msgBrokenRecord = '</b>ここ壊れてます<b>';


function TDat2HTML._ToDatOut(dest: TDatOut;
                             const dataString: string;
                             startPos: integer;
                             line: integer;
                             datType: TDatType;
                             EnableNGToAbone: Boolean;
                             AboneArray: TAboneArray = nil;
                             NeedConvert: Boolean = False //aiai
                             ): Boolean;
var
  {連鎖あぼーん}
  p, q: PChar;
  ref: string;
  intRef: Integer;
  {/連鎖あぼーん}
  nameStart, nameSize: integer;
  mailStart, mailSize: integer;
  dateStart, dateSize: integer;
  msgStart,  msgSize : integer;
  tmplen, i: integer;
  ns: string;
  name, mail, date, msg: PChar;
  strName, strMail, strDate, strMsg, strMailName: string;
  {beginner}
  ngi: TNGItemIdent;
  DateTime:TDateTime; //beginner
  MsgShow:Integer; //0:通常表示 0以下：ポップアップ　0以上:着色(色番号)
  AboneType:Integer;
  ResItems: TArrayOfNGItemPChar;
  {/beginner}
  {aiai}
  convname, convmail, convmsg: string;
  {/aiai}

  {beginner}
  function Arrest(AAboneType: Integer; NGItem: TBaseNGItem): Integer;
  begin
    Result := NGItem.AboneType;
    if Result = 0 then
      if TransparencyAbone then
        Result := 2
      else
        Result := 1;

    if (AAboneType >= Result) then
      Result := AAboneType
    else if PermanentNG and EnableNGToAbone then begin
      if (Result <> 4) or PermanentMarking then begin  //マークをスレに書き込まないオプション
        Inc(NGItem.Count);
        AboneArray[line]:=Result;
      end;
    end;
    try
      DateTime := StrToDateTime(copy(dataString, dateStart, dateSize));
      if DateTime > NGItem.LatestArresting then
        NGItem.LatestArresting := DateTime;
      if DateTime < NGItem.EarliestArresting then
        NGItem.EarliestArresting := DateTime;
    except
    end;
  end;
  {/beginner}

  procedure NG;
  begin
    name := @ABONE[1];
    mail := name;
    date := name;
    msg  := nil; //beginner
    nameSize := length(ABONE);
    mailSize := nameSize;
    dateSize := nameSize;
    msgSize := 0; //beginner
  end;

label PROC;
begin
  result := True;
  tmplen := TemplateStr.Count -1;
  dest.DisableLink := False;
  {beginner}
  MsgShow:=0;
  AboneType:=0;
  {/beginner}

  if datType = dtComma then
  begin
    Dat2ChFetchCommaDelimitedLine(
                  dataString, startPos,
                  nameStart, nameSize,
                  mailStart, mailSize,
                  dateStart, dateSize,
                  msgStart, msgSize);
    if 0 < FindPos('＠｀', dataString, nameStart, nameStart + nameSize -1) then
    begin
      strName := AnsiReplaceStr(Copy(dataString, nameStart, nameSize), '＠｀', ',');
      name := @strName[1];
      nameSize := length(strName);
    end
    else
      name := @dataString[nameStart];
    if 0 < FindPos('＠｀', dataString, mailStart, mailStart + mailSize -1) then
    begin
      strMail := AnsiReplaceStr(Copy(dataString, mailStart, mailSize), '＠｀', ',');
      mail := @strMail[1];
      mailSize := length(strMail);
    end
    else
      mail := @dataString[mailStart];
    if 0 < FindPos('＠｀', dataString, dateStart, dateStart + dateSize -1) then
    begin
      strDate := AnsiReplaceStr(Copy(dataString, dateStart, dateSize), '＠｀', ',');
      date := @strDate[1];
      dateSize := length(strDate);
    end
    else
      date := @dataString[dateStart];
    if 0 < FindPos('＠｀', dataString, msgStart, msgStart + msgSize -1) then
    begin
      strMsg := AnsiReplaceStr(Copy(dataString, msgStart, msgSize), '＠｀', ',');
      msg := @strMsg[1];
      msgSize := length(strMsg);
    end
    else
      msg  := @dataString[msgStart];
  end
  else begin
    Dat2ChFetchLine(dataString, startPos,
                    nameStart, nameSize,
                    mailStart, mailSize,
                    dateStart, dateSize,
                    msgStart, msgSize);
    name := @dataString[nameStart];
    mail := @dataString[mailStart];
    date := @dataString[dateStart];
    msg  := @dataString[msgStart];
  end;

  {aiai}
  if NeedConvert then
  begin
    SetString(convname, name, nameSize);
    if InCodeCheck(convname) in [EUC_IN, EUCorSJIS_IN] then
    begin
      convname := euc2sjis(convname);
      name := PChar(convname);
      nameSize := Length(convname);
    end;

    SetString(convmail, mail, mailSize);
    if InCodeCheck(convmail) in [EUC_IN, EUCorSJIS_IN] then
    begin
      convmail := euc2sjis(convmail);
      mail := PChar(convmail);
      mailSize := Length(mail);
    end;

    SetString(convmsg, msg, msgSize);
    if InCodeCheck(convmsg) in [EUC_IN, EUCorSJIS_IN] then
    begin
      convmsg := euc2sjis(convmsg);
      msg := PChar(convmsg);
      msgSize := Length(msg);
    end;
  end;
  {/aiai}

  if dateSize <= 0 then
  begin
    name := msgBrokenRecord;
    nameSize := length(msgBrokenRecord);
    mailSize := 0;
    dateSize := 0;
    msgSize := 0;
    result := False;
    EnableNGToAbone := False; //beginner
  end
  else begin
    {beginner}
    ResItems[NG_ITEM_NAME].pStart := name;//PChar(DataString) + nameStart - 1;
    ResItems[NG_ITEM_MAIL].pStart := mail;//PChar(DataString) + mailStart - 1;
    ResItems[NG_ITEM_MSG ].pStart := msg;//PChar(DataString) + msgStart  - 1;
    ResItems[NG_ITEM_ID  ].pStart := PChar(DataString) + dateStart - 1;

    ResItems[NG_ITEM_NAME].Size := nameSize;
    ResItems[NG_ITEM_MAIL].Size := mailSize;
    ResItems[NG_ITEM_MSG ].Size := msgSize;
    ResItems[NG_ITEM_ID  ].Size := dateSize;

    if AboneArray <> nil then AboneType := AboneArray[line];

    for ngi := Low(TNGItemIdent) to High(TNGItemIdent) do begin
      ResItems[ngi].NotMakeWideStr := True;
      if Assigned(NGItems[ngi]) then
        for i := 0 to NGItems[ngi].Count - 1 do
          if NGItems[ngi].NGData[i].BMSearch.Search(ResItems[ngi].pStart, ResItems[ngi].Size) <> nil then
            AboneType := Arrest(AboneType, NGItems[ngi].NGData[i]);
    end;

    if Assigned(ExNGList) then
      for i := 0 to ExNGList.Count - 1 do
        if ExNGList.NGData[i].Search(ResItems) then
          AboneType := Arrest(AboneType, ExNGList.NGData[i]);
    {連鎖あぼーん}
//koreawatcher ◆9iLyiaWJOQ
//OpenJane Nida を優しく見守るスレ
//http://jane.s28.xrea.com/test/read.cgi/bbs/1077287892/468,470
    // viewLinkAbone は jconfig.pas で Boolean で定義しておきます。
    //if Config.viewLinkAbone and (AboneArray <> nil) and (AboneType = 0) then
    {aiai}
    if LinkAbone and (AboneArray <> nil) and (AboneType = 0) then
    {/aiai}
    begin
      p := msg;
      q := msg + msgSize;
      ref := '';
      while p < q do
      begin
        if p^ = '&' then
        begin
          if StrLComp(p + 1, 'gt;', 3) = 0 then
          begin
            Inc(p, 4);
            if (p < q) and (StrLComp(p, '&gt;', 4) = 0) then
              Inc(p, 4);
            while (p < q) and (p^ in ['0'..'9']) do
            begin
              ref := ref + p^;
              Inc(p)
            end;
            intRef := StrToIntDef(ref, 0);
            if (intRef > 0) and (intRef < line) then
            begin
              if (AboneArray[intRef] in [1, 2]) then
              begin
                AboneArray[line] := AboneArray[intRef];
                AboneType := AboneArray[line]
              end;
              Break
            end;
            ref := '';
          end
        end;
        Inc(p)
      end
    end;
    {/連鎖あぼーん}

    case AboneLevel of
      -1: begin //透明
        case AboneType of
          1, 2: exit;
          4: MsgShow := 12; //重要レス
        end;
      end;
      0: begin //通常
        case AboneType of
          1: NG;
          2: exit;
          4: MsgShow := 12; //重要レス
        end;
      end;
      1: begin //ポップアップ
        case AboneType of
          1: begin
            NG;
            MsgShow := -1;
          end;
          2: exit;
          4: MsgShow := 12; //重要レス
        end;
      end;
      2: begin //さぼり
        case AboneType of
          1: MsgShow:=13;
          2: Exit;
          4: MsgShow := 12; //重要レス
        end;
      end;
      3: begin //よりごのみ
        case AboneType of
          4:;
          else exit;
        end;
      end;
      4: begin //はきだめ
        case AboneType of
          1:;
          2: MsgShow:=13;
          else Exit;
        end;
      end;
      255: begin //ヒント表示用
        case AboneType of
          1,2: MsgShow := 13;
        end;
      end;
    end;
    {/beginner}
  end;

  if (MsgShow = 13) or (AboneLevel = 4) then
    dest.DisableLink := True;

  ns := IntToStr(line);
  try
    dest.SetLine(line);
    dest.WriteAnchor(ns, '', '', 0); //HogeTextViewのみ必要(実際にはPopupでは使わない)
    for i := 0 to tmplen do
    begin
      case TemplateType[i] of
      TYPE_TEXT: dest.WriteItem(@TemplateStr.Strings[i][1], length(TemplateStr.Strings[i]), ditNORMAL);
      TYPE_PLAINNUMBER: begin dest.WriteText(@ns[1], length(ns)); end;
      TYPE_NAME:
        {beginner}
        if MsgShow < 0 then
          dest.WriteAnchor('','#'+ns, name, nameSize)
        else
        begin
          dest.WriteItem(name, nameSize, ditNAME);
        end;
        {/beginner}
      TYPE_NUMBER:
        begin
          dest.WriteAnchor('', 'menu:' + ns, PChar(ns), length(ns));
        end;
      TYPE_MAILNAME:
        begin
          if mailSize > 0 then
          begin
            SetString(strMailName, mail, mailSize);
            dest.WriteItem(PChar('<a href="mailto:' + strMailName + '">'), mailSize + 18, ditNORMAL);
            dest.WriteItem(name, nameSize, ditMAILNAME);
            dest.WriteItem('</a>', 4, ditNORMAL);
          end else
            dest.WriteItem(name, nameSize, ditNAME);
        end;
      TYPE_SAGE:
        begin
          if 0 < FindPosP('sage', mail, mailSize) then
            dest.WriteItem('<SA i=15/>', 10, ditNORMAL)
          else if mailSize > 0 then
            dest.WriteItem('<SA i=14/>', 10, ditNORMAL)
        end;
      TYPE_SAGEONLY:
        begin
          if (mailSize = 4) and StartWithP('sage', mail, 4) then
            dest.WriteItem('<SA i=15/>', 10, ditNORMAL)
          else if mailSize > 0 then
            dest.WriteItem('<SA i=14/>', 10, ditNORMAL)
        end;
      {beginner}
      TYPE_MAIL:
        begin
          if FindPosP('<', mail, mailSize) <= 0 then
            dest.WriteHTML(mail, mailSize)
          else
            dest.WriteText(mail, mailSize);
        end;
      TYPE_DATE:
        begin
          if MsgShow > 0 then
            dest.WriteItem(PChar('<SA i='+IntToStr(MsgShow)+'/>'), 8 + Length(IntToStr(MsgShow)), ditNORMAL);

          dest.WriteItem(date, dateSize, ditDATE); //aiai

          if MsgShow > 0 then
            dest.WriteItem('<SA i=0/>', 9, ditNORMAL);
        end;
      TYPE_MESSAGE:
        begin
          if MsgShow > 0 then
            dest.WriteItem(PChar('<SA i='+IntToStr(MsgShow)+'/>'), 8 + Length(IntToStr(MsgShow)), ditNORMAL);

          dest.WriteItem(msg, msgSize,ditMSG);

          if MsgShow > 0 then
            dest.WriteItem('<SA i=0/>', 9, ditNORMAL);
        end;
      {/beginner}
      end;
    end;
  except
    raise;
  end;
  dest.Flush;
end;

function TDat2HTML.ToDatOut(dest: TDatOut;
                            dat: TThreadData;
                            startLine: Integer; // 1 origin.
                            lines: Integer;
                            AboneArray: TAboneArray = nil;
                            NeedConvert: Boolean = False //aiai
                            ): Integer;
var
  datType: TDatType;
begin
  result := 0;
  if dat.Count <= 0 then
    exit;
  datType := GetDatType(dat);
  if not dat.FindLine(startLine) then
    exit;
  if dat.Count <= dat.FCacheInfo.FBlockIndex then
    exit;
  for result := 1 to lines do
  begin
    with dat.FCacheInfo do
    begin
      dat.Consistent := _ToDatOut(dest, dat.Strings[FBlockIndex],
                                  FIndex, FLineNumber, datType, dat.Consistent,
                                  AboneArray,
                                  NeedConvert  //aiai
                                  )
                        and dat.Consistent;
      Dat2chNextLine(dat);
      if dat.Count <= FBlockIndex then begin
        exit;
      end;
    end;
  end;
  result := lines;
end;


(* ポップアップ用の範囲指定レス抽出 *)   //　※datは必要に応じてあらかじめdupしておくこと
function TDat2HTML.PickUpRes(dest: TDatOut; dat: TThreadData; abonearray: TAboneArray; NeedConvert: Boolean;
                            startLine, endLine: integer): Integer;
var
  temp: integer;
begin

  Result := 0;

  if dat = nil then
    exit;

  if startLine <= 0 then
  begin
    if endLine > 0 then
      startLine := endLine
    else
      exit;
  end
  else begin
    if endLine <= 0 then
      endLine := startLine
    else if endLine < startLine then
    begin
      temp := startLine;
      startLine := endLine;
      endLine := temp;
    end;
  end;
  if endLine - startLine >= 20 then
    endLine := startLine + 19;

  Result := ToDatOut(dest, dat, startLine, endLine - startLine + 1, ABoneArray, NeedConvert);
end;



function TDat2HTML.ToString(dat: TThreadData; startLine, lines: Integer; NeedConvert: Boolean = False): String;
var
  strOut: TStrDatOut;
begin
  strOut := TStrDatOut.Create;
  ToDatOut(strOut, dat, startLine, lines, nil, NeedConvert);
  result := strOut.Text;
  strOut.Free;
end;

//aiai
//lineのIDをかえす
function TDat2HTML.ToID(dat: TThreadData; line: Integer): String;
var
  idOut: TIDDatOut;
begin
  idOut := TIDDatOut.Create;
  TodatOut(idOut, dat, line, 1);
  result := idOut.Text;
  idOut.Free;
end;

function HTML2String(const AString: string): string;
var
  strOut: TStrDatOut;
begin
  strOut := TStrDatOut.Create;
  strOut.WriteHTML(AString);
  result := strOut.Text;
  strOut.Free;
end;


//※[457]
function TABoneArray.Load(path: string): Boolean;
var
  stream: TFileStream;
begin
  result := false;
  if not FileExists(path) then
    exit;
  stream := nil;
  try
    stream := TFileStream.Create(path, fmOpenRead);
    SetLength(FAboneArray, stream.size);
    stream.Read(FAboneArray[0], stream.size);
    result := true;
    FModified := False;
  finally
    stream.Free;
  end;
end;

//※[457]
function TABoneArray.Save(path: string): boolean;
var
  stream: TFileStream;
begin
  result := false;
  if (Length(FAboneArray) = 0) or not FModified then
    exit;
  stream := nil;
  try
    stream := TFileStream.Create(path, fmCreate);
    stream.Write(FAboneArray[0], Length(FAboneArray));
    result := true;
    FModified := False;
  finally
    stream.Free;
  end;
end;

//※[457]
function TABoneArray.GetAboneArray(ResNumber: Integer): Byte;
begin
  if Length(FAboneArray) < ResNumber then
    result := 0
  else
    result := FAboneArray[ResNumber - 1];
end;

//※[457]
Procedure TABoneArray.SetAboneArray(ResNumber: Integer; Value: Byte);
begin
  if AboneArray[ResNumber] <> Value then
  begin
    if Length(FAboneArray) < ResNumber then
      SetLength(FAboneArray, ResNumber);
    FAboneArray[ResNumber - 1] := Value;
    FModified := True;
  end;
end;

//※[457]
Procedure TABoneArray.SetBlock(StartResNumber, EndResNumber: Integer; Value: Byte);
var
  tmp, i: Integer;
begin
  if StartResNumber > EndResNumber then
  begin
    tmp := StartResNumber;
    StartResNumber := EndResNumber;
    EndResNumber := tmp;
  end;
  if Length(FAboneArray) < EndResNumber then
    SetLength(FAboneArray, EndResNumber);
  for i := StartResNumber-1 to EndResNumber-1 do
    FAboneArray[i] := Value;
  FModified := True;
end;

//※[457]
Procedure TABoneArray.Clear;
begin
  SetLength(FAboneArray, 0);
  FModified := True;
end;

//※[457]
function TABoneArray.GetNearNotAboneResNumber(ResNumber: Integer): Integer;
var
 i: Integer;
begin
  result := ResNumber;
  if (ResNumber < 1) or (ResNumber > Length(FAboneArray)) then
    exit;

  for i:= ResNumber-1 to Length(FAboneArray)-1 do
  begin
    if (FAboneArray[i] <> 1) and (FAboneArray[i] <> 2) then
    begin
      result := i+1;
      exit;
    end;
  end;

  for i:= Length(FAboneArray)-1 to 0 do
  begin
    if (FAboneArray[i] <> 1) and (FAboneArray[i] <> 2) then
    begin
      result := i+1;
      exit;
    end;
  end;

end;

{beginner}
function TABoneArray.GetSize: Integer;
begin
  Result := Length(FAboneArray);
end;

procedure TABoneArray.SetSize(Value: Integer);
begin
  SetLength(FAboneArray, Value);
end;
{/beginner}

end.
