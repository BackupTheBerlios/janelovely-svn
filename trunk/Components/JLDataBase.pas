unit JLDataBase;

(* DataBase関連 *)
(* aiwota Programer *)

interface

uses
  Windows, JLSqlite, SysUtils;

type
  ENotFileNameErr = class(Exception);
  EHandleErr = class(Exception);

  TJLSQLiteNotifyEvent = procedure (Sender: TObject) of Object;

  TJLSQLite = class(TObject)
  private
    FSqlite: Pointer;
    FFileName: string;
    FResultText: string;
    FResult: Boolean;
    FLastErrMsg: PChar;
    FOnOpen: TJLSQLiteNotifyEvent;
    FOnClose: TJLSQLiteNotifyEvent;
    function GetVersion: string;
    function GetOpened: Boolean;
    procedure SetFileName(AFileName: string);
  protected
    procedure DoOpen;
    procedure DoClose;
  public
    constructor Create;
    destructor Destroy; override;
    function Open: Boolean;
    function Close: Boolean;
    function Exec(const sql: PChar; sqlite_callback: Pointer; Sender: TObject): Integer;
    property Opened: Boolean read GetOpened; (* already opened DataBase File or not yet *)
    property Version: string read GetVersion;
    property ResultText: string read FResultText write FResultText;
    property Result: Boolean read FResult write FResult;
    property FileName: string read FFileName write SetFileName;
    property LastErrMsg: PChar read FLastErrMsg;

    property OnOpen: TJLSQLiteNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TJLSQLiteNotifyEvent read FOnClose write FOnClose;
  end;

implementation

const
  ENotFileNameErrMsg = 'DataBaseを開けません!!!!' + #13#10 + 'ファイル名が不明です。';
  EHandleErrMsg = 'ハンドルが無効です。';

var
  SqliteVersion: string = '';


 { TJLSQLite }

constructor TJLSQLite.Create;
begin
  FSqlite := nil;
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

function TJLSQLite.GetOpened: Boolean;
begin
  Result := FSqlite <> nil;
end;

procedure TJLSQLite.SetFileName(AFileName: string);
begin
  if FFileName <> AFileName then
  begin
    FFileName := AFileName;
    if FSqlite <> nil then
    begin
      Close;
      Open;
    end;
  end;
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

function TJLSQLite.Open: Boolean;
begin
  if FSqlite = nil then
  begin
    if Length(FFileName) <= 0 then
      raise ENotFileNameErr.Create(ENotFileNameErrMsg);
    FSqlite := sqlite_open(PChar(FFileName), 0, FLastErrMsg);
    DoOpen;
  end;
  Result := FSqlite <> nil;
end;

function TJLSQLite.Close: Boolean;
begin
  if FSqlite <> nil then
  begin
    sqlite_close(FSqlite);
    FSqlite := nil;
    Result := True;
    DoClose;
  end else
    Result := False;
end;

function TJLSQLite.Exec(const sql: PChar; sqlite_callback: Pointer; Sender:
  TObject): Integer;
begin
  Open;
  if FSqlite = nil then
    raise EHandleErr.Create(EHandleErrMsg);
  Result := sqlite_exec(FSqlite, sql, sqlite_callback, Sender, FLastErrMsg);
end;

end.
