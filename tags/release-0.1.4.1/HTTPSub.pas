unit HTTPSub;

(* Personal”Å‚É‚ÍHTTPEncode‚ª‚È‚¢‚©‚ç‚Ë *)
(* Copyright (c) 2001,2002 hetareprog@hotmail.com *)


interface

uses
  SysUtils;

function URLEncode(const str: string): string;

implementation

{$B-} (* short circuit *)

function URLEncode(const str: string): string;
var
  s: string;
  i: integer;
begin
  s := '';
  for i := 1 to length(str) do
  begin
    case str[i] of
    '0'..'9','A'..'Z','a'..'z':
      s := s + str[i];
    else
      s := s + Format('%%%2.2X', [Ord(str[i])]);
    end;
  end;
  result := s;
end;

end.
