unit UMigemo;

interface

uses
  Windows;

const
  MIGEMO_VERSION = '1.1';

  { for migemo_load() }
  MIGEMO_DICTID_INVALID	  =	0;
  MIGEMO_DICTID_MIGEMO	  = 1;
  MIGEMO_DICTID_ROMA2HIRA	= 2;
  MIGEMO_DICTID_HIRA2KATA	= 3;
  MIGEMO_DICTID_HAN2ZEN	  = 4;

  { for migemo_set_operator()/migemo_get_operator().  see: rxgen.h }
  MIGEMO_OPINDEX_OR         =	0;
  MIGEMO_OPINDEX_NEST_IN    = 1;
  MIGEMO_OPINDEX_NEST_OUT	  = 2;
  MIGEMO_OPINDEX_SELECT_IN  = 3;
  MIGEMO_OPINDEX_SELECT_OUT = 4;
  MIGEMO_OPINDEX_NEWLINE    = 5;

type
  TMigemo = class(TObject)
  private
    FCanUse: Boolean;
    FMigemo: Integer;
    function Load(dictpath, roma2hira, hira2kata, han2zen: String): Boolean;
    function Open: Boolean;
    procedure Close;
    function GetCanUse: Boolean;
    function IsEnable: Boolean;
  public
    constructor Create(dllpath, dictpath, roma2hira, hira2kata, han2zen: String);
    destructor Destroy; override;
    function Query(str: String): PChar;
    procedure Release(str: PChar);

    property CanUse: Boolean read GetCanUse;
  end;

implementation

var
  DLLHANDLE: THandle;

  migemo_open: function (dict: PChar): Integer; cdecl;
  migemo_close: procedure (obj: Integer); cdecl;
  migemo_load: function (obj: Integer; dict_id: Integer; dictfile: PChar): Integer; cdecl;
  migemo_is_enable: function (obj: Integer): Integer; cdecl;
  migemo_query: function (obj: Integer; query: PChar): PChar; cdecl;
  migemo_release: procedure (obj: Integer; str: PChar); cdecl;

function InitDLL(dllpath: String): Boolean;
begin
  if DLLHANDLE <> 0 then
  begin
    Result := True;
    exit;
  end;
  DLLHANDLE := LoadLibrary(PChar(dllpath));
  if DLLHANDLE = 0 then
  begin
    Result := False;
    exit;
  end;

  Result := True;

  @migemo_open := GetProcAddress(DLLHANDLE, 'migemo_open'); if @migemo_open = nil then Result := False;
  @migemo_close := GetProcAddress(DLLHANDLE, 'migemo_close'); if @migemo_close = nil then Result := False;
  @migemo_load := GetProcAddress(DLLHANDLE, 'migemo_load'); if @migemo_load = nil then Result := False;
  @migemo_is_enable := GetProcAddress(DLLHANDLE, 'migemo_is_enable'); if @migemo_is_enable = nil then Result := False;
  @migemo_query := GetProcAddress(DLLHANDLE, 'migemo_query'); if @migemo_query = nil then Result := False;
  @migemo_release := GetProcAddress(DLLHANDLE, 'migemo_release'); if @migemo_release = nil then Result := False;

  if Result = False then
  begin
    FreeLibrary(DLLHANDLE);
    DLLHANDLE := 0;
  end;

end;

procedure FinalDLL;
begin
  if DLLHANDLE <> 0 then
    FreeLibrary(DLLHANDLE);
end;



 { TMigemo }

constructor TMigemo.Create(dllpath, dictpath, roma2hira, hira2kata, han2zen: String);
begin
  FCanUse := InitDLL(dllpath);
  if not FCanUse then exit;
  FCanUse := Open;
  if not FCanUse then exit;
  Load(dictpath, roma2hira, hira2kata, han2zen);
end;

destructor TMigemo.Destroy;
begin
  Close;
  FinalDLL;
  inherited;
end;

function TMigemo.Open: Boolean;
begin
  FMigemo := migemo_open(nil);
  Result := FMigemo <> 0;
end;

procedure TMigemo.Close;
begin
  if FMigemo <> 0 then
    migemo_close(FMigemo);
end;

function TMigemo.Load(dictpath, roma2hira, hira2kata, han2zen: String): Boolean;
var
  fdict: String;
  hR: Integer;
begin
  Result := False;
  fdict := dictpath;
  hR := migemo_load(FMigemo, MIGEMO_DICTID_MIGEMO, PChar(fdict));
  if hR = MIGEMO_DICTID_INVALID then exit;
  fdict := roma2hira;
  hR := migemo_load(FMigemo, MIGEMO_DICTID_ROMA2HIRA, PChar(fdict));
  if hR = MIGEMO_DICTID_INVALID then exit;
  fdict := hira2kata;
  hR := migemo_load(FMigemo, MIGEMO_DICTID_HIRA2KATA, PChar(fdict));
  if hR = MIGEMO_DICTID_INVALID then exit;
  fdict := han2zen;
  hR := migemo_load(FMigemo, MIGEMO_DICTID_HAN2ZEN, PChar(fdict));
  if hR = MIGEMO_DICTID_INVALID then exit;
  Result := True;
end;

function TMigemo.GetCanUse: Boolean;
begin
  if not FCanUse then begin
    Result := False;
    exit;
  end;

  Result := IsEnable;
end;

function TMigemo.IsEnable: Boolean;
begin
  Result := migemo_is_enable(FMigemo) <> 0;
end;

function TMigemo.Query(str: String): PChar;
begin
  Result := migemo_query(FMigemo, PChar(str))
end;

procedure TMigemo.Release(str: PChar);
begin
  migemo_release(FMigemo, str);
end;

end.
