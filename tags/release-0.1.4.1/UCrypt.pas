unit UCrypt;
(* crypt(3)ƒ‹[ƒ`ƒ“ *)
(* Copyright (c) 2003 nonoŸMFAp1y4voQ *)

interface

function crypt(const pw, salt: string): string;

implementation
uses
  math;

const
  IP: array[1..64] of Byte =
  (58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6,
    64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17, 9, 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7);

  IP_1: array[1..64] of Byte =
  (40, 8, 48, 16, 56, 24, 64, 32,
    39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41, 9, 49, 17, 57, 25);

  E: array[1..48] of Byte =
  (32, 1, 2, 3, 4, 5,
    4, 5, 6, 7, 8, 9,
    8, 9, 10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32, 1);

  P: array[1..32] of Byte =
  (16, 7, 20, 21,
    29, 12, 28, 17,
    1, 15, 23, 26,
    5, 18, 31, 10,
    2, 8, 24, 14,
    32, 27, 3, 9,
    19, 13, 30, 6,
    22, 11, 4, 25);

  LS: array[1..16] of Byte =
  (1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1);

  RC1: array[1..56] of Byte =
  (57, 49, 41, 33, 25, 17, 9,
    1, 58, 50, 42, 34, 26, 18,
    10, 2, 59, 51, 43, 35, 27,
    19, 11, 3, 60, 52, 44, 36,
    63, 55, 47, 39, 31, 23, 15,
    7, 62, 54, 46, 38, 30, 22,
    14, 6, 61, 53, 45, 37, 29,
    21, 13, 5, 28, 20, 12, 4);

  RC2: array[1..48] of Byte =
  (14, 17, 11, 24, 1, 5,
    3, 28, 15, 6, 21, 10,
    23, 19, 12, 4, 26, 8,
    16, 7, 27, 20, 13, 2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32);

  S: array[1..8, 0..3, 0..15] of Byte =
  (((14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7),
    (0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8),
    (4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0),
    (15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13)),

    ((15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10),
    (3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5),
    (0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15),
    (13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9)),

    ((10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8),
    (13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1),
    (13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7),
    (1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12)),

    ((7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15),
    (13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9),
    (10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4),
    (3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14)),

    ((2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9),
    (14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6),
    (4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14),
    (11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3)),

    ((12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11),
    (10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8),
    (9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6),
    (4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13)),

    ((4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1),
    (13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6),
    (1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2),
    (6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12)),

    ((13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7),
    (1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2),
    (7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8),
    (2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11)));


type
  TBit64 = array[1..64] of Byte;
  TBit48 = array[1..48] of Byte;

var
  Kyes: array[1..16] of TBit48;
  Et: array[1..48] of Byte;

function StringToBit64(AStr: string): TBit64;
var
  i, j, p: Integer;
  c: Byte;
begin
  for i := 1 to 64 do
    Result[i] := 0;

  p := 1;
  for i := 1 to Min(Length(AStr), 8) do
  begin
    c := Ord(AStr[i]);
    for j := 0 to 7 do
    begin
      if (c and (1 shl (7 - j))) > 0 then
        Result[p] := 1
      else
        Result[p] := 0;
      Inc(p);
    end;
  end;
end;

type
  TBit28 = array[1..28] of Byte;

procedure LeftShift28(var AInput: TBit28; Count: Integer);
var
  tmp: Byte;
  i, j: Integer;
begin
  for i := 1 to Count do
  begin
    tmp := Ainput[1];
    for j := 1 to 27 do
      AInput[j] := AInput[j + 1];
    AInput[28] := tmp
  end;
end;

procedure SetKey(const K: TBit64);
var
  i, j: Integer;
  C, D: TBit28;
begin
  //‚d‚ğƒRƒs[
  for i := 1 to 48 do
    Et[i] := E[i];

  //k–ñŒ^“]’u‚q‚b-1
  for i := 1 to 28 do
  begin
    C[i] := K[RC1[i]];
  end;
  for i := 1 to 28 do
  begin
    D[i] := K[RC1[i + 28]];
  end;

  for i := 1 to 16 do
  begin
    //¶zŠÂƒVƒtƒg
    LeftShift28(C, LS[i]);
    LeftShift28(D, LS[i]);

    //k–ñŒ^“]’u‚q‚b-2
    for j := 1 to 24 do
    begin
      Kyes[i][j] := C[RC2[j]];
      Kyes[i][j + 24] := D[RC2[j + 24] - 28];
    end;
  end;
end;


type
  TBit32 = array[1..32] of Byte;

function XOR32(const A, B: TBit32): TBit32;
var
  i: Integer;
begin
  for i := 1 to 32 do
    Result[i] := A[i] xor B[i];
end;

function F(const R: TBit32; N: Integer): TBit32;
var
  tmp: TBit48;
  tmp32: TBit32;
  num: Cardinal;
  i, j, pt: Integer;
  row, column: Integer;
begin
  //Šg‘å“]’u‚d
  for i := 1 to 48 do
    tmp[i] := R[Et[i]];

  //Œ®‚j‚‚Æ”r‘¼“I˜_—˜a
  for i := 1 to 48 do
    tmp[i] := tmp[i] xor Kyes[N][i];

  pt := 1;
  for i := 1 to 8 do
  begin
    row := tmp[pt] * 2 + tmp[pt + 5];
    column := tmp[pt + 1] * 8 + tmp[pt + 2] * 4 + tmp[pt + 3] * 2 + tmp[pt + 4];

    num := S[i][row][column];

    for j := 1 to 4 do
      if ((num shr (4 - j)) and 1) = 1 then
        tmp32[j + (i - 1) * 4] := 1
      else
        tmp32[j + (i - 1) * 4] := 0;

    Inc(pt, 6);
  end;

  //“]’u‚o
  for i := 1 to 32 do
    Result[i] := tmp32[P[i]];
end;

function Encrypt(const AInput: TBit64): TBit64;
var
  L, R, Ln, Rn: TBit32;
  i: Integer;
begin
  //‰Šú“]’u‚h‚o
  for i := 1 to 32 do
  begin
    L[i] := AInput[IP[i]];
    R[i] := AInput[IP[i + 32]];
  end;

  for i := 1 to 16 do
  begin
    Ln := R;
    Rn := XOR32(L, F(R, i));
    L := Ln;
    R := Rn;
  end;

  //ÅI“]’u‚h‚o-1
  for i := 1 to 64 do
  begin
    if IP_1[i] > 32 then
      Result[i] := Ln[IP_1[i] - 32]
    else
      Result[i] := Rn[IP_1[i]];
  end;
end;

function crypt(const pw, salt: string): string;
var
  i, j: Integer;
  buf: array[1..2] of Byte;
  data: TBit64;
  tmp, c: Byte;
begin
  //ƒpƒXƒ[ƒh•¶š‚ğ¶‚É‚¸‚ç‚µ‚ÄŠi”[
  data := StringToBit64(pw);
  for i := 0 to 7 do
  begin
    for j := 1 to 7 do
    begin
      data[j + i * 8] := data[j + i * 8 + 1];
    end;
    data[8 + i * 8] := 0;
  end;

  //ƒL[‚ğì‚é
  SetKey(data);

  //salt‚ğ”š‚É•ÏŠ·
  for i := 1 to 2 do
  begin
//    buf[i] := Ord(salt[i]);{««•¶š”‚ª­‚È‚¢‚Æ”ÍˆÍŠOƒGƒ‰[‚ª‹N‚±‚é‚Ì‚Å‰ñ”ğ}
    buf[i] := Ord((PChar(salt) + i - 1)^);
    if (buf[i] > Ord('Z')) then Dec(buf[i], 6);
    if (buf[i] > Ord('9')) then Dec(buf[i], 7);
    Dec(buf[i], Ord('.'));
  end;

  //‚d‚”‚ğƒXƒƒbƒv Et[1~12]<-(salt)->Et[25~36]
  for i := 0 to 1 do
  begin
    for j := 1 to 6 do
    begin
      if ((buf[i + 1] shr (j - 1)) and 1) = 1 then
      begin
        tmp := Et[j + i * 6];
        Et[j + i * 6] := Et[j + i * 6 + 24];
        Et[j + i * 6 + 24] := tmp;
      end;
    end;
  end;

  //•½•¶‚ğ‚O‚É
  for i := 1 to 64 do
    data[i] := 0;

  //‚c‚d‚rˆÃ†‰»
  for i := 1 to 25 do
  begin
    data := Encrypt(data);
  end;

  //ˆÃ†•¶‚ğ"./‰p”š"‚Ö•ÏŠ·
  SetLength(Result, 16);
  Result[1] := salt[1];
  Result[2] := salt[2];
  if Ord(Result[2]) = 0 then
    Result[2] := Result[1];
  for i := 0 to 10 do
  begin
    c := 0;
    for j := 1 to 6 do
    begin
      if ((i * 6 + j) < 65) and (data[i * 6 + j] = 1) then
        c := c or (1 shl (6 - j));
    end;
    Inc(c, Ord('.'));
    if c > Ord('9') then Inc(c, 7);
    if c > Ord('Z') then Inc(c, 6);
    Result[3 + i] := Char(c);
  end;

  SetLength(Result, 13); //‚Ü‚Å
end;

end.

