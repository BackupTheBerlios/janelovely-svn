unit JLDataBase;

(* DataBase関連 *)
(* aiwota Programer *)

interface

uses
  Windows, JLSqlite, SysUtils;

type
  TJLSQLiteNotifyEvent = procedure (Sender: TObject) of Object;

  TJLSQLite = class(TObject)
  private
    FSqlite: Pointer;
    FFileName: string;
    FOpened: Boolean;             (* already opened DataBase File or not yet *)
    FResultText: string;
    FResult: Boolean;
    FRefCount: Integer;
    FOnOpen: TJLSQLiteNotifyEvent;
    FOnClose: TJLSQLiteNotifyEvent;
    function GetVersion: string;
  protected
    procedure DoOpen;
    procedure DoClose;
  public
    constructor Create;
    destructor Destroy; override;
    function Open(const zFileName: PChar; mode: Integer; out errmsg: PChar): Boolean;
    function Close: Boolean;
    function Exec(const sql: PChar; sqlite_callback: Pointer; Sender: TObject; out errmsg: PChar): Integer;
    property Opened: Boolean read FOpened;
    property Version: string read GetVersion;
    property ResultText: string read FResultText write FResultText;
    property Result: Boolean read FResult write FResult;
    property RefCount: Integer read FRefCount;

    property OnOpen: TJLSQLiteNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TJLSQLiteNotifyEvent read FOnClose write FOnClose;
  end;

implementation

var
  SqliteVersion: string = '';


 { TJLSQLite }

constructor TJLSQLite.Create;
begin
  FSqlite := nil;
  FOpened := False;
  FRefCount := 0;
end;

destructor TJLSQLite.Destroy;
begin
  if FSqlite <> nil then
    sqlite_close(FSqlite);
  inherited;
end;

function TJLSQLite.GetVersion: string;
var
  p: PChar;
begin
  if Length(SqliteVersion) <= 0 then
  begin
    p := sqlite_libversion;
    SqliteVersion := Copy(p, 1, Length(p));
  end;
  Result := SqliteVersion;
end;

procedure TJLSQLite.DoOpen;
begin
  if Assigned(FOnOpen) then
    FOnOpen(Self);
end;

procedure TJLSQLite.DoClose;
begin
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

function TJLSQLite.Open(const zFileName: PChar; mode: Integer;
  out errmsg: PChar): Boolean;
begin
  if FSqlite = nil then
  begin
    FSqlite := sqlite_open(zFileName, mode, errmsg);
    FFileName := zFileName;
    DoOpen;
  end;
  FOpened := (FSqlite <> nil);
  Result := FOpened;
end;

function TJLSQLite.Close: Boolean;
begin
  if FSqlite <> nil then
  begin
    sqlite_close(FSqlite);
    FSqlite := nil;
    FOpened := False;
    Result := True;
    DoClose;
  end else
    Result := False;
end;

function TJLSQLite.Exec(const sql: PChar; sqlite_callback: Pointer; Sender:
  TObject; out errmsg: PChar): Integer;
var
  filename: string;
begin
  if not FOpened then
  begin
    if Length(FFileName) > 0 then
    begin
      filename := FFileName;
      Open(PChar(filename), 0, errmsg);
    end else
      raise Exception.Create('DataBaseを開けません!!!!' + #13#10 + 'ファイル名が不明です。');
  end;
  Result := sqlite_exec(FSqlite, sql, sqlite_callback, Sender, errmsg);
end;

end.
