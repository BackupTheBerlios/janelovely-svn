unit CheckURL;

interface

uses
  Windows, SysUtils, Classes;

type

  TProtocol=(pHTTP,pHTTPS,pFTP);

  TURLCheck = class(TObject)
  protected
    FText:String;
    FProtocol:TProtocol;
    HostStartAt:PChar;
    DirStartAt:PChar;
    FIsIPAddr:Boolean;
    procedure SetText(Value:String);
    function CheckHostName:Boolean;
  public
    function IsURL:Boolean;
    function URL:String;
    function DirLength:Integer;
    property IsIPAddr:Boolean read FIsIPAddr;
    property Text:String read FText write SetText;
    property Protocol:TProtocol read FProtocol;
  end;

implementation

const
  ProtocolStr:array[TProtocol] of String =('http://','https://','ftp://');
  gTLD:array[0..8] of String=('.biz','.com','.edu','.gov','.info','.int','.mil','.net','.org');

var
  GTDList:TStringList;

procedure TURLCheck.SetText(Value: String);
var
	i:TProtocol;
  j:Integer;
begin

  FText:=StringOfChar(#0,length(Value));
  LCMapString(LOCALE_SYSTEM_DEFAULT,LCMAP_HALFWIDTH,PChar(Value),Length(Value),PChar(FText),Length(FText));
  FText:=StringReplace(Trim(FText),' ','',[rfReplaceAll]);
  FText:=StringReplace(FText,#13#10,'',[rfReplaceAll]);

  //URL利用可能文字の途中からttpが始まるパターンへの対策 ttps://が来てもしらん
  j:=AnsiPos('ttp://',LowerCase(FText));
  if j>0 then FText:=copy(FText,j,High(Integer));

  HostStartAt:=nil;
  DirStartAt:=nil;
  FProtocol:=pHTTP;
  for i:=Low(TProtocol) to High(TProtocol) do begin
  	for j:=0 to Length(ProtocolStr[i])-1 do
  		if StrLIComp(PChar(ProtocolStr[i])+j,PChar(FText),Length(ProtocolStr[i])-j)=0 then begin
        FProtocol:=i;
  			HostStartAt:=PChar(FText)+Length(ProtocolStr[i])-j;
  			Break;
  		end;
    if Assigned(HostStartAt) then Break;
  end;

  if HostStartAt=nil then
    HostStartAt:=PChar(FText);

  if HostStartAt<=PChar(FText)+Length(FText) then begin
    DirStartAt:=AnsiStrPos(HostStartAt,'/');
    if DirStartAt=nil then
      DirStartAt:=PChar(FText)+Length(FText);
  end else
    DirStartAt:=HostStartAt;

end;

function TURLCheck.IsURL: Boolean;
begin
  Result:=(HostStartAt-PChar(FText)>=4) or CheckHostName;
end;

function TURLCheck.CheckHostName:Boolean;
const
  AlphaChar = ['A'..'Z','a'..'z'];
var
  IsDomainName: Boolean;
  TLD: String;
  i: PChar;
  Num: Integer;
  PeriodAt: PChar;
  PeriodCnt: Integer;
begin
  FIsIPAddr := True;
  IsDomainName := False;
  Result := True;

  PeriodCnt := 0;
  Num := 0;
  PeriodAt := HostStartAt-1;

  i := HostStartAt;
  while (i < DirStartAt) and Result do begin
    case i^ of
      '0'..'9': begin
        Num := Num * 10 + (Ord(i^) - Ord('0'));
        if Num > 255 then
          FIsIPAddr := False;
      end;
      'A'..'Z', 'a'..'z', '-': begin
        FIsIPAddr := False;
        IsDomainName := True;
      end;
      '.':begin
        Num:=0;
        if i = PeriodAt + 1 then
          Result := False;
        if i < DirStartAt - 1 then begin
          Inc(PeriodCnt);
          PeriodAt := i;
        end;
      end;
      else Result := False;
    end;
    Inc(i);
  end;

  if Result = False then begin
    FIsIPAddr := False;
    Exit;
  end;

  if PeriodCnt <> 3 then FIsIPAddr := False;
  if PeriodCnt <= 0 then IsDomainName := False;

  if IsDomainName then begin
    if (DirStartAt - PeriodAt = 3) or ((DirStartAt - PeriodAt = 4) and ((DirStartAt - 1)^ ='.')) then begin
      if not((PeriodAt + 1)^ in AlphaChar) or not((PeriodAt+2)^ in AlphaChar) then
        IsDomainName := False;
    end else begin
      TLD := Copy(PeriodAt, 1, DirStartAt - PeriodAt);
      if GTDList.IndexOf(TLD) = -1 then
        IsDomainName := False;
    end;
  end;

  Result := IsDomainName or FIsIPAddr;

end;

function TURLCheck.URL: String;
begin
  SetLength(Result, Length(ProtocolStr[Protocol]) + Length(FText) - (HostStartAt - PChar(FText)));
  StrCopy(StrECopy(PChar(Result), PChar(ProtocolStr[Protocol])), HostStartAt);
end;

function TURLCheck.DirLength:Integer;
begin
  Result := PChar(FText) + Length(FText) - DirStartAt;
end;

initialization
  GTDList := TStringList.Create;
  GTDList.Text:='.biz'#13#10'.com'#13#10'.edu'#13#10'.gov'#13#10'.info'#13#10
              +'.int'#13#10'.mil'#13#10'.net'#13#10'.org'#13#10;
finalization
  GTDList.Free;

end.
 