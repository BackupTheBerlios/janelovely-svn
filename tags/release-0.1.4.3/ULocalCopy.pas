unit ULocalCopy;
(* Copyright (c) 2002 Twiddle <hetareprog@hotmail.com> *)

interface
uses
  Classes,
  SysUtils,
  FileSub,
  StrSub;

type
  TLocalCopy = class(TPSStream)
  protected
    FInfo: TStringList;
    FObjPath: string;
    FInfoPath: string;
    FUpdated: TDateTime;
  public
    constructor Create(const path, extention: string);
    destructor Destroy; override;
    function Load: boolean;
    function Save: boolean;
    procedure Clear;
    property Info: TStringList read FInfo write FInfo;
    property Updated: TDateTime read FUpdated;
  end;

implementation

constructor TLocalCopy.Create(const path, extention: string);
begin
  inherited Create('');
  FInfo := TStringList.Create;
  FObjPath := path;
  FInfoPath := ChangeFileExt(path, extention);
  FUpdated := 0;
end;

destructor TLocalCopy.Destroy;
begin
  FInfo.Free;
  inherited;
end;

function TLocalCopy.Load: boolean;
begin
  FUpdated := 0;
  try
    LoadFromFile(FObjPath);
    FInfo.LoadFromFile(FInfoPath);
    FUpdated := FileDateToDateTime(FileAge(FObjPath));
    result := true;
  except
    Size := 0;
    Position := 0;
    result := false;
  end;
end;

function TLocalCopy.Save: boolean;
begin
  FUpdated := 0;
  try
    RecursiveCreateDir(HogeExtractFileDir(FObjPath));
    SaveToFile(FObjPath);
    FInfo.SaveToFile(FInfoPath);
    FUpdated := FileDateToDateTime(FileAge(FObjPath));
    result := true;
  except
    result := false;
  end;
end;

procedure TLocalCopy.Clear;
begin
  FUpdated := 0;
  Size := 0;
  Position := 0;
  FInfo.Clear;
end;

end.
