unit JLSqlite;

(* sqliteÇÃÉwÉbÉ_Å[Ç›ÇΩÇ¢Ç»Ç‡ÇÃ *)

(* aiwota Programmer *)

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

  {$IFDEF SQLITE3}
  SQLITE_DLL_NAME = 'sqlite3.dll';
  SQLITE_VERSION = '3.0.8';
  {$ELSE}
  SQLITE_DLL_NAME = 'sqlite.dll';
  SQLITE_VERSION = '2.8.16';
  {$ENDIF}

(* ------------------------------------------------------------------------- *)

var
  {$IFDEF SQLITE3}
  sqlite_open: function (const zFileName: PChar; ppDb: Pointer): Integer; cdecl;
  sqlite_close: function (sqlite: Pointer): Integer; cdecl;
  {$ELSE}
  sqlite_open: function (const zFileName: PChar; mode: Integer; out errmsg: PChar): Pointer; cdecl;
  (* in the current implementation, the second argument to sqlite_open is ignored. *)

  sqlite_close: procedure (sqlite: Pointer); cdecl;
  {$ENDIF}
  sqlite_exec: function (sqlite: Pointer; const sql: PChar; sqlite_callback: Pointer; Sender: TObject; out errmsg: PChar): integer; cdecl;
  sqlite_libversion: function (): PChar; cdecl;

function Initdll: Boolean;
procedure Finaldll;

(* ------------------------------------------------------------------------- *)
implementation
(* ------------------------------------------------------------------------- *)

var
  SQLiteDLL: THandle;

function Initdll: Boolean;
begin
  SQLiteDLL := LoadLibrary(SQLITE_DLL_NAME);
  if SQLiteDLL = 0 then
  begin
    Result := False;
    exit;
  end;

  Result := True;

  {$IFDEF SQLITE3}
  @sqlite_open := GetProcAddress(SQLiteDLL, 'sqlite3_open'); if @sqlite_open = nil then Result := False;
  @sqlite_exec := GetProcAddress(SQLiteDLL, 'sqlite3_exec'); if @sqlite_exec = nil then Result := False;
  @sqlite_close := GetProcAddress(SQLiteDLL, 'sqlite3_close'); if @sqlite_close = nil then Result := False;
  @sqlite_libversion := GetProcAddress(SQLiteDLL, 'sqlite3_libversion'); if @sqlite_libversion = nil then Result := False;
  {$ELSE}
  @sqlite_open := GetProcAddress(SQLiteDLL, 'sqlite_open'); if @sqlite_open = nil then Result := False;
  @sqlite_exec := GetProcAddress(SQLiteDLL, 'sqlite_exec'); if @sqlite_exec = nil then Result := False;
  @sqlite_close := GetProcAddress(SQLiteDLL, 'sqlite_close'); if @sqlite_close = nil then Result := False;
  @sqlite_libversion := GetProcAddress(SQLiteDLL, 'sqlite_libversion'); if @sqlite_libversion = nil then Result := False;
  {$ENDIF}

  if Result = False then
  begin
    FreeLibrary(SQLiteDLL);
    SQLiteDLL := 0;
  end;
end;

procedure Finaldll;
begin
  if SQLiteDLL <> 0 then
    FreeLibrary(SQLiteDLL);
end;

end.
