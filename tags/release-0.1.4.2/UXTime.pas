unit UXTime;
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* 時刻関連のサブルーチン *)

interface
uses
  SysUtils, Windows, DateUtils, Classes;

function UTC: longword;
function Str2DateTime(const str: string): TDateTime;
function UxTimeStr2DateTime(const str: string): TDateTime;

(*=======================================================*)
implementation
(*=======================================================*)

const
  MonthNames: array[1..12] of string = ('Jan','Feb','Mar','Apr','May','Jun',
                                        'Jul','Aug','Sep','Oct','Nov','Dec');

function UTC: longword;
var
  systemTime: _SYSTEMTIME;
begin
  GetSystemTime(systemTime);
  result := Trunc((EncodeDateTime(systemTime.wYear,
                                  systemTime.wMonth,
                                  systemTime.wDay,
                                  systemTime.wHour,
                                  systemTime.wMinute,
                                  systemTime.wSecond,
                                  systemTime.wMilliseconds)
                   - UnixDateDelta) * 24 * 60 * 60);
end;


(* ゾーンを気にしないでDateTimeに変換 *)
(* Ex.: Thu, 17 Jan 2002 16:32:44 GMT *)
function Str2DateTime(const str: string): TDateTime;

  function GetMonth(const mstr: string): integer;
  var
    i: integer;
  begin
    for i := 1 to 12 do
    begin
      if AnsiCompareText(MonthNames[i], mstr) = 0 then
      begin
        result := i;
        exit;
      end;
    end;
    raise Exception.Create('');
  end;
var
  strList: TStringList;
  day, month, year, hour, minute, second: integer;
begin
  result := 0;
  strList := TStringList.Create;
  try
    strList.Delimiter := ' ';
    strList.DelimitedText := str;
    if strList.Count = 6 then
    begin
      day := StrToInt(strList.Strings[1]);
      month := GetMonth(strList.Strings[2]);
      year := StrToInt(strList.Strings[3]);
      strList.Delimiter := ':';
      strList.DelimitedText := strList.Strings[4];
      if strList.Count = 3 then
      begin
        hour := StrToInt(strList.Strings[0]);
        minute := StrToInt(strList.Strings[1]);
        second := StrToInt(strList.Strings[2]);
        result := EncodeDateTime(year, month, day, hour, minute, second, 0);
      end;
    end;
  except
  end;
  strList.Free;
end;

function UxTimeStr2DateTime(const str: string): TDateTime;
var
  tim: integer;
begin
  try
    tim := StrToInt(str);
    result := (tim)/(24*60*60) + UnixDateDelta;
  except
    result := 0;
  end;
end;


end.
