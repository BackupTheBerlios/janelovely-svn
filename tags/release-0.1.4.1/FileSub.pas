unit FileSub;
(* ファイル関連のサブルーチン *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* 1.5, Sun Oct 10 04:57:28 2004 UTC *)

interface

uses
  SysUtils, Classes;


type
  (*-------------------------------------------------------*)
  TTmpFile = class(TStringList)
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(index: integer); override;
  end;

(* 再帰的にディレクトリを作成する *)
procedure RecursiveCreateDir(path: string);

function HogeExtractFileDir(const path: string): string;
function Convert2FName(const fname: string): string;

(*=======================================================*)
implementation
(*=======================================================*)
(*  *)
destructor TTmpFile.Destroy;
begin
  Clear;
  inherited;
end;

(*  *)
procedure TTmpFile.Clear;
var
  i: integer;
begin
  for i := 0 to Count -1 do begin
    DeleteFile(Strings[i]);
  end;
  inherited;
end;

(*  *)
procedure TTmpFile.Delete(index: integer);
begin
  DeleteFile(Strings[index]);
  inherited;
end;

(*=======================================================*)
(* 'ニュース速報+' を含むパス名をExtractFileDirに渡すと  *)
(* +までとられた・・・(´Д｀） 　　　　　　　　　　　　 *)
(* UpdatePack1では起きない。Delphi 6 Personal無印固有かも  *)
function HogeExtractFileDir(const path: string): string;
var
  w: WideString;
  i: integer;
begin
  w := path;
  result := '';
  for i := length(w) -1 downto 1 do
  begin
    if (w[i] = '\') or (w[i] = '/') then
    begin
      if (i = 1) or (w[i-1] = ':') then
        result := Copy(w, 1, i)
      else
        result := Copy(w, 1, i -1);
      break;
    end;
  end;
end;

(* 再帰的にディレクトリを作成する *)
procedure RecursiveCreateDir(path: string);
begin
  if (length(path) <= 0) then
    exit;
  if AnsiLastChar(path) = '\' then
    exit;
  if DirectoryExists(path) then
    exit;
  RecursiveCreateDir(HogeExtractFileDir(path));
  CreateDir(path);
end;

function Convert2FName(const fname: string): string;
var
  wstr: WideString;
  i: integer;
begin
  if AnsiSameText(fname, 'CON') then
    result := '$CON'
  else if AnsiSameText(fname, 'AUX') then
    result := '$AUX'
  else if AnsiSameText(fname, 'NUL') then
    result := '$NUL'
  else begin
    wstr := fname;
    result := '';
    for i := 1 to length(wstr) do
    begin
      case wstr[i] of
      '\': result := result + '$Backslash';
      '/': result := result + '$Slash';
      ':': result := result + '$Colon';
      '*': result := result + '$Asterisk';
      '?': result := result + '$Question';
      '"': result := result + 'Quote';
      '<': result := result + 'LT';
      '>': result := result + 'GT';
      '|': result := result + 'Bar';
      else
        result := result + wstr[i];
      end;
    end;
  end;
  // ▼ Nightly Sun Oct 10 04:57:28 2004 UTC  by view
  //名前の末尾に空白が含まれる板でスレが保存されない不具合を修正
  if Length(Result) > 0 then
  begin
    Result := Trim(Result);
    if Length(Result) = 0 then
      Result := '$SPACE';
  end;
  // ▲ Nightly Sun Oct 10 04:57:28 2004 UTC  by view
end;



end.
