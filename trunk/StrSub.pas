unit StrSub;
(* 文字列サブルーチン *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.6, 2004/04/01 14:25:18 *)

interface

uses
  SysUtils, StrUtils, Classes, Windows, WinInet;

type
  (*-------------------------------------------------------*)
  TPSStream = class(TStringStream)
  public
    procedure SaveToFile(const fileName: string);
    procedure LoadFromFile(const fileName: string);
  end;

  {beginner}   //BM法によるテキストサーチクラス
  TBMSearch = class(TObject)
    FTable: array [0..255] of Cardinal;
  private
    FIgnoreCase: Boolean;
    FSubject: String;
    PESubject: PChar;
    FSubLen: Cardinal;
    Upper, Lower: String;
    PEUpper, PELower: PChar;
    procedure MakeTable;
    procedure SetIgnoreCase(const Value: Boolean);
    procedure SetSubject(const Value: String);
  public
    property Subject: String read FSubject write SetSubject;
    property IgnoreCase: Boolean read FIgnoreCase write SetIgnoreCase;
    function Search(Str: PChar; Len: Cardinal): PChar;
  end;

function FindPos(const substr: string;
                 const str: string;
                 offset: integer;
                 limit: integer = 0): integer;
function FindPosP(const substr: string;
                  str: Pchar;
                  len: integer): integer;
function FindPosIC(const substr: string;
                   const str: string;
                   offset: integer;
                   limit: integer = 0): integer;

function StartWith(const substr: string;
                   const str: string;
                   offset: integer): boolean;

function StartWithP(const substr: string;
                    str: PChar;
                    len: integer): boolean;

function ReplaceStr(const AString: string;
                    const AFrom: string;
                    const ATo: string): string;

function HexToInt(const AString: string): Integer;
function Str2Int(const AString: string): Integer;
function isAllNumber(str: PChar; startPos, endPos: integer): boolean;
function GetHex(str: PChar; size: integer; var val, len: integer): boolean;
function GetDecimal(str: PChar; size: integer; var val, len: integer): boolean;
function CountLines(const AString: string): Integer;
function Nth(const AString: string; target: Char; n: Integer): Integer;
function StrUnify(const AString: string): string; //※[457]

function CombineURI(const BaseURI, RelativeURI: String): String;

(*=======================================================*)
implementation
(*=======================================================*)

(* ファイル保存也 *)
procedure TPSStream.SaveToFile(const fileName: string);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(fileName, fmCreate);
  Position := 0;
  fs.CopyFrom(Self, Size);
  fs.Free;
end;

(* ファイル書出也 *)
procedure TPSStream.LoadFromFile(const fileName: string);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(fileName, fmOpenRead);
  CopyFrom(fs, fs.Size);
  fs.Free;
end;

(*=======================================================*)

{ TBMSearch }

procedure TBMSearch.MakeTable;
var
  i: Cardinal;
begin

  if FSubject = '' then
    Exit;

  if FIgnoreCase then begin
    Upper := AnsiUpperCase(FSubject);
    Lower := AnsiLowerCase(FSubject);
    PEUpper := PChar(Upper) + FSubLen;
    PELower := PChar(Lower) + FSubLen;
  end else begin
    Upper := '';
    Lower := '';
    PEUpper := nil;
    PELower := nil;
  end;

  For i := 0 to 255 do
    FTable[i] := Length(FSubject);
  for i := 1 to Length(FSubject) do
    if IgnoreCase then begin
      FTable[Ord(Upper[i])] := FSubLen - i + 1;
      FTable[Ord(Lower[i])] := FSubLen - i + 1;
    end else begin
      FTable[Ord(FSubject[i])] := FSubLen - i + 1;
    end;
end;

procedure TBMSearch.SetIgnoreCase(const Value: Boolean);
begin
  FIgnoreCase := Value;
  MakeTable;
end;

procedure TBMSearch.SetSubject(const Value: String);
begin
  FSubject := Value;
  FSubLen := Length(FSubject) - 1;
  PESubject := PChar(FSubject) + FSubLen;
  MakeTable;
end;

function TBMSearch.Search(Str: PChar; Len: Cardinal): PChar;
var
  p, pe: PChar;
  tmpResult, pa: PChar;
  dif: Boolean;
  i: Cardinal;
  c: Char;
  d: Cardinal;
begin

  Result := nil;
  c := #0;

  if str = nil then
    Exit;

  p  := Str + FSubLen;
  pe := Str + Len - 1;

  while p <= pe do begin
    dif := False;
    for i := 0 to FSubLen do begin
      c := (p - i)^;
      if FIgnoreCase then begin
        if (c <> (PELower - i)^) and (c <> (PEUpper - i)^) then begin
          dif := True;
          Break;
        end;
      end else begin
        if c <> (PESubject - i)^ then begin
          dif := True;
          Break;
        end;
      end;
    end;
    if dif then begin
      d := FTable[Ord(c)];
      if d > i then
        inc(p, d - i)
      else if d < i then
        inc(p, 2);
    end else begin
      tmpResult := p - FSubLen;
      pa := tmpResult;
      while pa>= str do begin
        Dec(pa);
        if not (pa^ in LeadBytes) then
          Break;
      end;
      if (tmpResult - pa) mod 2 = 1 then begin
        Result := tmpResult;
        Break;
      end else begin
        inc(p);
      end;
    end;
  end;
end;


(*  *)
function FindPos(const substr: string;
                 const str: string;
                 offset: integer;
                 limit: integer): integer;
var
  index: integer;
  off: integer;
  len, lenSub: integer;
label NEXT;
begin
{
  if 0 < limit then
    len := limit
  else
    len := Length(str);
}
  lenSub := Length(substr);
  {beginner}
  if (0 < limit) and (limit <= Length(str) - lenSub + 1) then
    len := limit
  else
    len := Length(str) - lenSub + 1;
  {/beginner}
  for index := offset to len do begin
    if (str[index] = substr[1]) then begin
      for off := 2 to lenSub do begin
        if (str[index + off -1] <> substr[off]) then
          goto NEXT;
      end;
      result := index;
      Exit;
    end;
    NEXT:
  end;
  result := 0;
end;

function FindPosP(const substr: string;
                  str: Pchar;
                  len: integer): integer;
var
  index: integer;
  off: integer;
  lenSub: integer;
label NEXT;
begin
  lenSub := Length(substr);
  Dec(str);
  Dec(len , lenSub - 1); //beginner
  for index := 1 to len do begin
    if ((str + index)^ = substr[1]) then begin
      for off := 2 to lenSub do begin
        if ((str + index + off -1)^ <> substr[off]) then
          goto NEXT;
      end;
      result := index;
      Exit;
    end;
    NEXT:
  end;
  result := 0;
end;

function FindPosIC(const substr: string;
                 const str: string;
                 offset: integer;
                 limit: integer): integer;
var
  index: integer;
  off: integer;
  len, lenSub: integer;
  tmpStr: string;
label NEXT;
{
begin
  if 0 < limit then
    len := limit
  else
    len := Length(str);
  tmpStr := UpperCase(substr);
  lenSub := Length(substr);
  for index := offset to len do begin
    if (UpCase(str[index]) = tmpStr[1]) then begin
      for off := 2 to lenSub do begin
        if (UpCase(str[index + off -1]) <> tmpStr[off]) then
          goto NEXT;
      end;
      result := index;
      Exit;
    end;
    NEXT:
  end;
  result := 0;
end;
}
begin

  if substr = '' then begin
    Result := 0;
    Exit;
  end;

  tmpStr := AnsiUpperCase(substr);
  lenSub := Length(substr);

  if (0 < limit) and (limit <= Length(str) - lenSub + 1) then
    len := limit
  else
    len := Length(str) - lenSub + 1;

  index := offset;
  while index <= len do begin
    if (UpCase(str[index]) = tmpStr[1]) then begin //Ａ－Ｚ、ａ－ｚはどちらも$82xxなので1byte目に特別な仕掛けは不要
      off := 1;
      while off <= lenSub do begin
        case str[index + off -1] of
          #$82, #$83, #$84: begin
            if str[index + off - 1] <> tmpStr[off] then
              goto NEXT;
            if (str[index + off -1] = #$82) and (Str[index + off] in [#$81..#$9a]) then begin
              if (Ord(Str[index + off]) - $21) <> Ord(tmpStr[off + 1]) then
                goto NEXT;
            end else if (str[index + off -1] = #$83) and (Str[index + off] in [#$bf..#$d6]) then begin
              if (Ord(Str[index + off]) - $20) <> Ord(tmpStr[off + 1]) then
                goto NEXT;
            end else if (str[index + off -1] = #$84) and (Str[index + off] in [#$70..#$7e]) then begin
              if (Ord(Str[index + off]) - $20) <> Ord(tmpStr[off + 1]) then
                goto NEXT;
            end else if (str[index + off -1] = #$84) and (Str[index + off] in [#$80..#$91]) then begin
              if (Ord(Str[index + off]) - $31) <> Ord(tmpStr[off + 1]) then
                goto NEXT;
            end else begin
              if Str[index + off] <> tmpStr[off + 1] then
                goto NEXT;
            end;
            Inc(off, 2);
          end;
          #$81, #$85..#$9f, #$e0..#$ef : begin
            if (Str[index + off - 1] <> tmpStr[off]) or (Str[index + off] <> tmpStr[off + 1]) then
              goto NEXT;
            Inc(off, 2);
          end;
        else
          if (UpCase(str[index + off -1]) <> tmpStr[off]) then
            goto NEXT;
          inc(off);
        end;
      end;
      result := index;
      Exit;
    end;
    NEXT:
    if str[index] in LeadBytes then
      Inc(index, 2)
    else
      Inc(index);
  end;
  Result := 0;
end;

(*  *)
function StartWith(const substr: string;
                   const str: string;
                   offset: integer): boolean;
var
  index, lenSub, len: integer;
begin
  lenSub := Length(substr);
  len := Length(str);
  if (len - offset) < lenSub then begin
    result := False;
    exit;
  end;
  Dec(offset);
  for index := 1 to lenSub do begin
    if substr[index] <> str[offset + index] then begin
      result := False;
      exit;
    end;
  end;
  result := True;
end;

function StartWithP(const substr: string;
                    str: PChar;
                    len: integer): boolean;
var
  index, lenSub: integer;
begin
  lenSub := Length(substr);
  if len < lenSub then begin
    result := False;
    exit;
  end;
  for index := 1 to lenSub do begin
    if substr[index] <> str^ then begin
      result := False;
      exit;
    end;
    Inc(str);
  end;
  result := True;
end;

(* AnsiReplaceStr(str, #0, ' ') って期待通りに動かない？  *)
function ReplaceStr(const AString: string;
                    const AFrom: string;
                    const ATo: string): string;
var
  startPos, endPos: integer;
  targetPos: integer;
  targetLen: integer;
begin
  startPos := 1;
  endPos := length(AString);
  targetLen := length(AFrom);
  result := '';
  while true do
  begin
    targetPos := FindPos(AFrom, AString, startPos, endPos);
    if 0 < targetPos then
    begin
      if startPos < targetPos then
        result := result + Copy(AString, startPos, targetPos - 1);
      result := result + ATo;
      startPos := targetPos + targetLen;
    end
    else begin
      result := result + Copy(AString, startPos, endPos);
      break;
    end;
  end;
end;

function HexToInt(const AString: string): Integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to length(AString) do
  begin
    case AString[i] of
    '0'..'9': result := result * 16 + Ord(AString[i]) - Ord('0');
    'A'..'F': result := result * 16 + Ord(AString[i]) - Ord('A') + 10;
    'a'..'f': result := result * 16 + Ord(AString[i]) - Ord('a') + 10;
    else break;
    end;
  end;
end;

function Str2Int(const AString: string): Integer;
var
  i, len, sign: integer;
begin
  result := 0;
  len := length(AString);
  if len <= 0 then
    exit;
  i := 1;
  if AString[i] = '-' then
  begin
    sign := -1;
    Inc(i);
  end
  else
    sign := 1;
  for i := i to len do
  begin
    case AString[i] of
    '0'..'9': result := result * 10 + Ord(AString[i]) - Ord('0');
    else break;
    end;
  end;
  result := result * sign;
end;

function isAllNumber(str: PChar; startPos, endPos: integer): boolean;
var
  i: integer;
begin
  i := startPos;
  result := false;
  while i < endPos do
  begin
    case (str +i)^ of
    '0'..'9': ;
    #$82:
      if (i < endPos) and ((str + i+1)^ in [#$4f..#$58]) then
        inc(i)
      else
        exit;
    else
      exit;
    end;
    Inc(i);
  end;
  result := true;
end;

function GetHex(str: PChar; size: integer; var val, len: integer): boolean;
var
  i: integer;
begin
  val := 0;
  i := 0;
  len:=size;
  while i < size do
  begin
    case (str + i)^ of
    '0'..'9': val := val * 16 + Ord((str + i)^) - Ord('0');
    'A'..'F': val := val * 16 + Ord((str + i)^) - Ord('A') + 10;
    'a'..'f': val := val * 16 + Ord((str + i)^) - Ord('a') + 10;
    else
      begin
        len := i;
        result := 0 < i;
        exit;
      end;
    end;
    Inc(i);
  end;
  result := 0 < i;
end;

function GetDecimal(str: PChar; size: integer; var val, len: integer): boolean;
var
  i: integer;
begin
  val := 0;
  i := 0;
  len:=size;
  while i < size do
  begin
    case (str + i)^ of
    '0'..'9': val := val * 10 + Ord((str + i)^) - Ord('0');
    else
      begin
        len := i;
        result := 0 < i;
        exit;
      end;
    end;
    Inc(i);
  end;
  result := 0 < i;
end;


function CountLines(const AString: string): Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 1 to length(AString) do
  begin
    if AString[i] = #10 then
      Inc(result);
  end;
end;

function Nth(const AString: string; target: Char; n: Integer): Integer;
var
  count: integer;
begin
  count := 0;
  for result := 0 to length(AString) do
  begin
    if AString[result] = target then
    begin
      Inc(count);
      if (n <= count) then
        exit;
    end;
  end;
  result := 0;
end;


//※[457] 文字の統一(半角・カタカナ(コメントアウト)・大文字に)
function StrUnify(const AString: string): string;
var
  pstr: PChar;
  len: Integer;
begin
  len := Length(AString) + 1;
  pstr := StrAlloc(len);
  LCMapString($411, LCMAP_HALFWIDTH(* or LCMAP_KATAKANA*), PChar(AString),
    -1, pstr, len);
  LCMapString($411, LCMAP_UPPERCASE, pstr, -1, pstr, len);
  result := pstr;
  StrDispose(pstr);
end;


//---------------------------------------------------------------------------

//WinInetを使った部分URI→フルURI変換
function CombineURI(const BaseURI, RelativeURI: String): String;
var
  len: Cardinal;
begin
  len := Length(BaseURI) + Length(RelativeURI) + 256;
  SetLength(Result, len);
  InternetCombineUrl(PChar(BaseURI), PChar(RelativeURI), PChar(Result), len, 0);
  Result := Copy(Result, 1, len);
end;

(*=======================================================*)

end.
