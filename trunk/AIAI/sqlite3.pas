unit sqlite3;

interface

uses Windows;

(* ------------------------------------------------------------------------- *)
const
  SQLITE_OK =          0;   (* Successful result *)
  SQLITE_ERROR =       1;   (* SQL error or missing database *)
  SQLITE_INTERNAL =    2;   (* An internal logic error in SQLite *)
  SQLITE_PERM =        3;   (* Access permission denied *)
  SQLITE_ABORT =       4;   (* Callback routine requested an abort *)
  SQLITE_BUSY =        5;   (* The database file is locked *)
  SQLITE_LOCKED =      6;   (* A table in the database is locked *)
  SQLITE_NOMEM =       7;   (* A malloc() failed *)
  SQLITE_READONLY =    8;   (* Attempt to write a readonly database *)
  SQLITE_INTERRUPT =   9;   (* Operation terminated by sqlite_interrupt() *)
  SQLITE_IOERR =      10;   (* Some kind of disk I/O error occurred *)
  SQLITE_CORRUPT =    11;   (* The database disk image is malformed *)
  SQLITE_NOTFOUND =   12;   (* (Internal Only) Table or record not found *)
  SQLITE_FULL =       13;   (* Insertion failed because database is full *)
  SQLITE_CANTOPEN =   14;   (* Unable to open the database file *)
  SQLITE_PROTOCOL =   15;   (* Database lock protocol error *)
  SQLITE_EMPTY =      16;   (* (Internal Only) Database table is empty *)
  SQLITE_SCHEMA =     17;   (* The database schema changed *)
  SQLITE_TOOBIG =     18;   (* Too much data for one row of a table *)
  SQLITE_CONSTRAINT = 19;   (* Abort due to contraint violation *)
  SQLITE_MISMATCH =   20;   (* Data type mismatch *)
  SQLITE_MISUSE =     21;   (* Library used incorrectly *)
  SQLITE_NOLFS =      22;   (* Uses OS features not supported on host *)
  SQLITE_AUTH =       23;   (* Authorization denied *)
  SQLITE_ROW =        100;  (* sqlite_step() has another row ready *)
  SQLITE_DONE =       101;  (* sqlite_step() has finished executing *)

(* ------------------------------------------------------------------------- *)
type
(* ------------------------------------------------------------------------- *)
  TSQLite = class(TObject)
  private
    db: Pointer;
  public
    Result: Boolean;
    Opened: Boolean; (* already opened DataBase File or not yet*)
    ResultText: String;
    constructor Create;
    destructor Destroy; override;
    function Open(dbname: PChar; mode: Integer; var ErrMsg: PChar): Boolean;
    procedure Close;
    function Exec(SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): Integer;
    function Version: PChar;
  end;
(* ------------------------------------------------------------------------- *)
var
  SQLiteHandle: THandle;
  sqlite_open: function (dbname: PChar; var db: Pointer): Pointer; cdecl;
  sqlite_close: procedure (db: Pointer);  cdecl;
  sqlite_exec: function (db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): integer;  cdecl;
  sqlite_version: function: PChar cdecl;

function Initdll: Boolean;
procedure Finaldll;

(* ------------------------------------------------------------------------- *)
implementation
(* ------------------------------------------------------------------------- *)

function Initdll: Boolean;
begin
  SQLiteHandle := LoadLibrary('sqlite3.dll');
  if SQLiteHandle = 0 then
  begin
    Result := False;
    exit;
  end;

  Result := True;

  @sqlite_open := GetProcAddress(SQLiteHandle, 'sqlite3_open');
  if @sqlite_open = nil then Result := False;
  @sqlite_exec := GetProcAddress(SQLiteHandle, 'sqlite3_exec');
  if @sqlite_exec = nil then Result := False;
  @sqlite_close := GetProcAddress(SQLiteHandle, 'sqlite3_close');
  if @sqlite_close = nil then Result := False;
  @sqlite_version := GetProcAddress(SQLiteHandle, 'sqlite3_libversion');
  if @sqlite_version = nil then Result := False;

  if Result = False then
  begin
    FreeLibrary(SQLiteHandle);
    SQLiteHandle := 0;
  end;
end;

procedure Finaldll;
begin
  if SQLiteHandle <> 0 then
    FreeLibrary(SQLiteHandle);
end;


(* ------------------------------------------------------------------------- *)
(* ------------------------------------------------------------------------- *)

 { TSQLite }

constructor TSQLite.Create;
begin
  inherited;

  db := nil;
  Opened := False;
end;

destructor TSQLite.Destroy;
begin
  if db <> nil then
    sqlite_close(db);

  inherited;
end;

function TSQLite.Open(dbname: PChar; mode: Integer; var ErrMsg: PChar): Boolean;
begin
  sqlite_open(dbname, db);

  Result := (db <> nil);
end;

procedure TSQLite.Close;
begin
  if db <> nil then
  begin
    sqlite_close(db);
    db := nil;
  end;
end;

function TSQLite.Exec(SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): Integer;
begin
  Result := sqlite_exec(db, SQLStatement, CallbackPtr, Sender, ErrMsg);
end;

function TSQLite.Version: PChar;
begin
  Result := sqlite_version;
end;

end.
