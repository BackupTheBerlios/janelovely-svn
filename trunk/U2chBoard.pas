unit U2chBoard;
(* 2ちゃんねる　ボード（スレッド一覧）情報 *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.57, 2004/09/24 14:42:31 *)

interface

uses
  Windows, Classes, SysUtils, StrUtils, DateUtils, U2chThread, FileSub, StrSub
  (*※[457]*), UFavorite, IniFiles, UXTime, UAsync, USynchro, U2chTicket,
  ULocalCopy, jconvert, Dialogs, JLDataBase, JLSqlite, UNGWordsAssistant,
  Forms;

const
  THREAD_CURRENT_LIST    = 'subject.txt';
  THREAD_PAST_LIST       = 'subkako.txt.gz';

type
  TPatrolType = (patFavorite, patTab, patBoardList);
  TProgState = (tpsNone, tpsWorking, tpsChecking, tpsDone);
  (*-------------------------------------------------------*)
  TBBSType = (bbsNone, bbs2ch, bbsJBBS, bbsShitaraba, bbsJBBSShitaraba, bbsMachi, bbsOther);
  (*-------------------------------------------------------*)

  TBBSCount = packed record
    linenumber: Integer;
    messagecount: Integer;
    subjectcount: Integer;
    namecount: Integer;
    mailcount: Integer;
  end;

  TBoard = class;

  TBoardSubjectEndNotifyEvent = procedure (Sender: TBoard) of Object;
  TBoardCheckEndEvent = procedure (Sender: TBoard; Count: Integer;
    PatrolType: TPatrolType) of Object;

  (* 板 = スレ一覧 *)
  TBoard = class(TList)
  private
    FRedirect: TBoard;       (* 「おすすめ」とかの重複用。 *)
    FCategory: TObject;
    FIDXDataBase: TJLSQLite;
    FName: string;
    FBBS:  string;
    FHost: string;
    FBBSType: TBBSType;
    FSelDatName: string;
    FLastModified: string;
    FLast2Modified: string; //beginner
    FPast: Boolean;
    FLastAccess: TDateTime;
    FSortColumn: integer;
    FThreadSearched: Boolean;
    FNeedConvert: Boolean;
    FHideHistoricalLog: Boolean;
    FUma: boolean;
    FCustomSkinIndex: Integer;
    FCustomHeader: string;
    FBBSCount: TBBSCount;
    FRefCount: integer;
    FSubjectText: string;
    FMergingList: TList;
    FDatModified : boolean;
    FIdxModified : boolean;
    FMoved: boolean;
    FStoredSettingText: TLocalCopy;
    FSettingText: string;
    FGotSettingTxt: TProgState;
    FProcGetSettingTxt: TAsyncReq;
    FSettingTxtLoaded: Boolean;
    FDatList: THashedStringList;  (* subject.txtにあるスレのdatのリスト TBoard.FindFirstでTThreadの検索に使う (aiai) *)
    FProcGetSubject: TAsyncReq;
    FPRocState: TProgState;
    FFavPatrolData: String;
    FFavPatrolType: TPatrolType; 
    FOnSubjectEnd: TBoardSubjectEndNotifyEvent;
    FOnCheckEnd: TBoardCheckEndEvent;

    function GetItems(index: integer): TThreadItem;
    function GetURIBase: string;
    function GetBBSType: TBBSType;
    function GetLogDir: string;
    function GetRefered: boolean;
    procedure SetItems(index: integer; value: TThreadItem);
    procedure SetSelDatName(const datName: string);
    procedure SetCustomHeader(const str: string);
    procedure SetUma(val: boolean);
    procedure SetHost(newHost: string); virtual;

    function FindThreadFirst(const datName: string): TThreadItem;
    procedure MergeCache;
    procedure MergeCacheFast;
    procedure InitialDBOpen;
    procedure IdxDataBaseOpen(Sender: TObject);
    procedure IdxDataBaseClose(Sender: TObject);
    procedure ChangeThreadItemURI;
    procedure OnMovedSubject(sender: TAsyncReq);
    procedure OnAsyncDoneProc(Sender: TASyncReq);
    procedure GetSettingTxt;
    procedure OnSettingTxt(sender: TAsyncReq);
    class procedure PutToRecyleList(Board: TBoard);
    class function  RemoveFromRecyleList(Board: TBoard): Boolean;
    class procedure FlushRecyleList;
  public
    TimeValue: Int64;        (* サーバ時間 bbs.cgiへのPOST時に使用 *)
    constructor Create(category: TObject);
    destructor Destroy; override;
    function Find(const datName: string): TThreadItem;
    function ThreadAbone(ABoneList: TList; AboneType: Byte): boolean; (* スレッドあぼ～ん *)
    procedure Clear; override;
    procedure SafeClear; virtual;
    procedure AddRef; virtual;
    procedure Release; virtual;
    procedure Analyze(txt: string; const lstModified: string; refresh: boolean);
    procedure LoadIndex; virtual;
    procedure LoadSettingTXT;
    procedure Load(refresh: Boolean = False); virtual;
    procedure SaveIndex; virtual;
    procedure Save; virtual;
    procedure Activate;
    procedure ResetListState; virtual;
    procedure MergeCacheFrequency(fnamelist: TStringList);
    function StartAsyncRead(OnCheckDone: TBoardCheckEndEvent;
      Data: String; PatrolType: TPatrolType): Boolean;
    function StartQuery(OnProcDone: TBoardSubjectEndNotifyEvent): Boolean;   (* 非同期通信開始 *)
    function HomoMovedQuery(OnProcDone: TBoardSubjectEndNotifyEvent): Boolean;

    property Category: TObject read Fcategory;         (* 本当はTCategoryだ。環境上、メンドイのでキャストして使う  *)
    property Name: string read FName write FName;      (* 板名 *)   // ex. '狼','ニュース速報'
    property Host: string read FHost write SetHost;    (* host名 *) // ex. 'ex7.2ch.net'
    property BBS:  string read FBBS write FBBS;        (* bbs名 *)  // ex.  'morningcoffee','news'
    property URIBase: string read GetURIBase;          (* uri *)    // ex. 'http://ex7.2ch.net/morningcoffee'
    property BBSType: TBBSType read GetBBSType;        (* bbsの分類 *)
    property LogDir: string read GetLogDir;            (* ログフォルダへのパス *)
    property Refered: Boolean read GetRefered;         (* 参照中かどうか 参照中でなければSafeClear *)
    property IdxDataBase: TJLSQLite read FIDXDataBase; (* スレの管理データを扱うデータベース *)
    property NeedConvert: Boolean read FNeedConvert;   (* EUCtoSJISが必要かどうか *)
    property Uma: boolean read FUma write SetUma;      (* ログ整理から除外するかどうか *)
    property Past: Boolean read FPast write FPast;     (* 過去ログボード *)
    property HideHistoricalLog: Boolean read FHideHistoricalLog write FHideHistoricalLog; (* 過去ログを表示するかどうか *)
    property CustomHeader: string read FCustomHeader write SetCustomHeader;               (* カスタムHeader.html *)
    property CustomSkinIndex: Integer read FCustomSkinIndex write FCustomSkinIndex;       (* カスタムスキンリストのインデックス *)
    property SelDatName: string read FSelDatName write SetSelDatName;                     (* スレ一覧で選択中のスレッド *)
    property SortColumn: integer read FSortColumn write FSortColumn;                      (* スレ一覧でのソート状態 *)
    property threadSearched: Boolean read FThreadSearched write FThreadSearched;          (* スレ一覧でのスレ絞込み状態 *)
    property Items[index: integer]: TThreadItem read GetItems write SetItems;             (* 只のキャスト *)
    property SubjectText: string read FSubjectText;                                       (* subject.txt *)
    property SettingText: string read FSettingText write FSettingText;                    (* SETTING.TXT *)
    property LastModified: string read FLastModified write FLastModified;
    property Last2Modified: string read FLast2Modified write FLast2Modified;
    property LastAccess: TDateTime read FLastAccess write FLastAccess;
    property BBSCount: TBBSCount read FBBSCount write FBBSCount;                          (* SETTING.TXTに記述されているバイト数制限 *)
  end;

  (*-------------------------------------------------------*)
  //※[457]
  TFunctionalBoard = class(TBoard)
  public
    procedure LoadIndex; override;
    procedure Load(refresh: Boolean = False); override; abstract;
    procedure SaveIndex; override;
    procedure Save; override;
    procedure Clear; override;
    procedure SafeClear; override;
    procedure SetHost(newHost: string); override;
    procedure Release; override;
    procedure ResetListState; override; //aiai
  end;

  (*-------------------------------------------------------*)
  //※[457]
  TFavoriteListBoard = class(TFunctionalBoard)
  protected
    favs: TFavoriteList;
    favChanged: boolean;
  public
    constructor Create(category: TObject; favs: TFavoriteList = nil);
    procedure Load(refresh: Boolean = False); override;
    procedure SetFavList(favList: TFavoriteList);
  end;

  (*-------------------------------------------------------*)
  //※[457]
  TLogListBoard = class(TFunctionalBoard)
  public
    constructor Create(category: TObject);
    procedure Load(refresh: Boolean = False); override;
  end;

  (*-------------------------------------------------------*)
  // 現在開いているスレッドの一覧 ( by aiai )
  TOpenThreadsBoard = class(TFunctionalBoard)
  public
    constructor Create(category: TObject);
    procedure Load(refresh: Boolean = False); override;
  end;

  (*-------------------------------------------------------*)
  //※[457]
  (* 板として開いたお気に入り板を保持する *)
  TFavoriteListBoardAdmin = class(TObject)
  protected
    objlist: TList;
    category: TObject;
  public
    constructor Create(category: TObject);
    destructor Destroy; override;
    function GetBoard(favs: TFavoriteList): TFavoriteListBoard;
    procedure GarbageCollect();
  end;

  (*-------------------------------------------------------*)
  (* スレ覧タブに開いている板を保持する *)
  TBoardList = class(TList)
  private
    procedure Open(board: TBoard);
    procedure Close(board: TBoard);
    function GetItems(index: integer): TBoard;
    procedure SetItems(index: integer; board: TBoard);
  public
    procedure Add(board: TBoard);
    procedure Insert(index: integer; board: TBoard);
    procedure Delete(index: integer);
    property Items[index: integer]: TBoard read GetItems write SetItems;
  end;

//error check
procedure SQLCheck(errcode: Byte; const name, sql, msg: string);

(*=======================================================*)
implementation
(*=======================================================*)

uses
  U2chCat, Main, UWritePanelControl;

const
  SUBJECT_TXT = '\subject.txt';
  SUBJECT_IDX = '\subject.idb';
  //改造▽ 追加 (スレッドあぼ～ん)
  SUBJECT_ABN = '\subject.abn'; (* スレッドあぼ～んファイル *)
  //改造△ 追加 (スレッドあぼ～ん)

  IDX_TITLE        = 0; (* Subject of the board *)
  IDX_MODIFIED     = 1; (* Last-Modified: の値 *)
  IDX_SELECTED     = 2; (* 選択中のdat名 *)
  IDX_CUSTOMHEADER = 3;
  IDX_MARKER       = 4;

  BBS_LINE_NUMBER   = 'BBS_LINE_NUMBER';
  BBS_MESSAGE_COUNT = 'BBS_MESSAGE_COUNT';
  BBS_SUBJECT_COUNT = 'BBS_SUBJECT_COUNT';
  BBS_NAME_COUNT    = 'BBS_NAME_COUNT';
  BBS_MAIL_COUNT    = 'BBS_MAIL_COUNT';

  (* DataBase (aiai) *)
  BOARD_VERSION     = '00000008';
  IDXLIST_VERSION   = '00000012';

  BOARD_DB = '\Board.db';

  CREATE_TABLE_STATEMENT = 'CREATE TABLE idxlist (datname TEXT PRIMARY KEY, title TEXT, last_modified TEXT, lines TEXT, view_pos TEXT, idx_mark TEXT, uri TEXT, state TEXT, new_lines TEXT, write_name TEXT, write_mail TEXT, last_wrote TEXT, last_got TEXT, read_pos TEXT)';
  (* //DataBase *)

(*=======================================================*)

procedure SQLCheck(errcode: Byte; const name, sql, msg: string);
begin
  if (errcode <> SQLITE_OK) and Config.tstDataBaseDebug then
  begin
    Main.BeginMultiLog;
    Main.Log(name);
    Main.Log('SQL: ' + sql);
    Main.Log('errcode: ' + IntToStr(errcode));
    Main.Log(msg);
    Main.EndMultiLog;
  end;
end;

(* TBoardの破棄待ちリスト処理用クラス関数群 *) // beginner

var
  RecycleList: TList;

{破棄処理}
class procedure TBoard.PutToRecyleList(Board: TBoard);
begin
  if RecycleList.IndexOf(Board) < 0 then
  begin
    RecycleList.Add(Board);
  end;
  FlushRecyleList;
end;

class function TBoard.RemoveFromRecyleList(Board: TBoard): Boolean;
begin
  Result := (RecycleList.Remove(Board) >= 0);
end;

class procedure TBoard.FlushRecyleList;
begin
  while RecycleList.Count > Config.brdRecyclableCount do
  begin
    TBoard(RecycleList[0]).SafeClear;
  end;
end;

(*=======================================================*)

(* 構築 *)
constructor TBoard.Create(category: TObject);
begin
  inherited Create;

  FRedirect := nil;
  FCategory := category;
  FRefCount := 0;
  FUma := false;
  FDatModified := false;
  FIdxModified := false;
  FPast := false;
  FLastAccess := 0;
  FBBSType := bbsNone;
  FMoved := false;
  FPRocState := tpsNone;
  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin
    FIDXDataBase := TJLSQLite.Create;
    if Config.tstDataBaseDebug then
    begin
      FIDXDataBase.OnOpen := IdxDataBaseOpen;
      FIDXDataBase.OnClose := IdxDataBaseClose;
    end;
  end;
  (* //DataBase *)
  FSettingTxtLoaded := false;
  FHideHistoricalLog := Config.stlHideHistoricalLog;
  FOnSubjectEnd := nil;
  FOnCheckEnd := nil;
end;

(* 破棄 *)
destructor TBoard.Destroy;
begin
  Save;
  Clear;
  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
    FreeAndNil(FIDXDataBase);
  (* //DataBase *)
  inherited;
end;

(* 掃除 *)
procedure TBoard.Clear;
var
  index: integer;
begin
  for index := 0 to Count -1 do
  begin
    Items[index].Free;
  end;
  RemoveFromRecyleList(Self);
  inherited;
end;

(* おかたづけ *)
procedure TBoard.SafeClear;
var
  i: integer;
  {$IFDEF DEVELBENCH}
  tickcnt: Cardinal;
  {$ENDIF}
begin
  {$IFDEF DEVELBENCH}
  tickcnt := GetTickCount;
  {$ENDIF}
  for i := 0 to Count -1 do
  begin
    if not Items[i].Refered then
    begin
      Items[i].Free;
      Items[i] := nil;
    end;
  end;
  Pack;
  if Count <= 0 then
  begin
    FSubjectText := '';
    FLastModified := '';
    FDatModified := false;
    FIdxModified := false;
  end;
  RemoveFromRecyleList(Self);
  {$IFDEF DEVELBENCH}
  Main.Log(FName + ':safeClear ' + IntToStr(GetTickCount - tickcnt));
  {$ENDIF}
end;


(* 参照増加 *)
procedure TBoard.AddRef;
begin
  if (FRefCount = 0) and not(RemoveFromRecyleList(Self)) then
    Load;
  Inc(FRefCount);
  {$IFDEF DEBUG}
  if not Application.Terminated then
    Main.Log(FName + ': AddRef(' + IntToStr(FRefCount) + ')');
  {$ENDIF}
end;

(* もう見ない *)
procedure TBoard.Release;
begin
  Dec(FRefCount);
  if FRefCount <= 0 then
    PutToRecyleList(Self);
  {$IFDEF DEBUG}
  if not Application.Terminated then
    Main.Log(FName + ': Release(' + IntToStr(FRefCount) + ')');
  {$ENDIF}
end;

(* 参照中？ *)
function TBoard.GetRefered: boolean;
begin
  if 0 < FRefCount then
  begin
    result := true;
  end
  else begin
    SafeClear;
    result := (0 < Count);
  end;
end;

function CallBackAnalyze(Sender: TObject;
                                   Columns: Integer;
                                   ColumnValues: Pointer;
                                   ColumnNames: Pointer): integer; cdecl;
begin
  (Sender as TBoard).IdxDataBase.Result := True;
  Result := 0;
end;

(* スレッド一覧を解析する *)
procedure TBoard.Analyze(txt: string; const lstModified: string; refresh: boolean);
var
  refered: TStringList;  //aiai GetReferedThreadItemの効率化
  threadABoneList: THashedStringList;
  threadABoneNext: THashedStringList; //ヒットしたスレを加える

  (* 指定されたdatのスレを探す *)
  //aiai TStringList.Findを使って効率化
  function GetReferedThreadItem(const datName: string): TThreadItem;
  var
    i: integer;
  begin
    if refered.Find(datName, i) then
    begin
      result := TThreadItem(refered.Objects[i]);
      refered.Delete(i);
      exit;
    end;
    result := nil;
  end;

  (* 区切りを探す *)
  function findDelimiter(i: integer; endOfRec: integer): integer;
  begin
    while (i <= endOfRec) do
    begin
      case txt[i] of
      ',': begin result := i; exit; end;
      '<': begin result := i; exit; end;
      end;
      Inc(i);
    end;
    result := 0;
  end;

  (*  *)
  function topOfSubject(i: integer): integer;
  begin
    case txt[i] of
    ',': result := i + 1;
    '<':
      begin
        if (i < length(txt) -1) and (txt[i+1] = '>') then
          result := i + 2
        else
          result := i + 1;
      end;
    else
      result := 0;
    end;
  end;

  (*  *)
  function endOfSubject(index, endOfRec: integer): integer;
  var
    i: integer;
  begin
    for i := endOfRec downto index do
    begin
      if (txt[i] = '(') or (txt[i] = '<') or
         ((i < endOfRec) and (txt[i] = #$81) and (txt[i+1] = #$69))then
      begin
        if (index <= i -1) and (txt[i-1] = ' ') then
          result := i -1
        else
          result := i;
        exit;
      end;
    end;
    result := 0;
  end;

  (* 番号の先頭 *)
  function topOfNums(index, endOfRec: integer): integer;
  var
    i: integer;
  begin
    for i := index to endOfRec do begin
      case Ord(txt[i]) of
      $30..$39: begin result := i; exit; end;
      end;
    end;
    result := 0;
  end;

  function endOfNums(index, endOfRec: integer): integer;
  var
    i: integer;
  begin
    for i := index to endOfRec do begin
      case Ord(txt[i]) of
      $30..$39:;
      else
        begin result := i; exit; end;
      end;
    end;
    result := endOfRec;
  end;

  function endOfRecord(i: integer): integer;
  var
    len: integer;
  begin
    len := Length(txt);
    while (i <= len) do begin
      if (Ord(txt[i]) = 10) then begin
        result := i;
        exit;
      end;
      Inc(i);
    end;
    result := 0;
  end;

  procedure addRecord(i: integer; endOfRec: integer);
  var
    refPos, refEnd: integer;
    item: TThreadItem;
    datName: string;
    subject: string;
    nums: string;
    num: integer;
    idx: integer;
    abone: ShortInt;
  begin
    (* dat-name delimiter subject space (num) *)
    (* dat *)
    refPos := i;
    refEnd := findDelimiter(i, endOfRec);
    if (refEnd <= 0) then
      exit;
    datName := ChangeFileExt(Copy(txt, refPos, refEnd - refPos), '');
    abone := 0;
    //スレッドあぼ～ん
    idx := threadABoneList.IndexOfName(datName);
    if idx >= 0 then
    begin
      if Length(threadABoneList.Values[datName]) > 0 then
      begin
        abone := StrToIntDef(threadAboneList.Values[datName][1], 1) or TThreABNFLAG;
      end else
        abone := 1 or TThreABNFLAG;
      threadABoneNext.Add(threadAboneList.Strings[idx]);
    end;
    (* subject *)
    refPos := topOfSubject(refEnd);
    refEnd := endOfSubject(refPos, endOfRec);
    subject := Copy(txt, refPos, refEnd - refPos);
    //NGThread
    if abone = 0 then
      for idx := 0 to Main.ThreNGList.Count - 1 do
      begin
        if ThreNGList.NGData[idx].BMSearch.Search(PChar(subject), Length(subject)) <> nil then
        begin
          Inc(ThreNGList.NGData[idx].Count);
          case ThreNGList.NGData[idx].AboneType of
          0: //通常
            abone := 1;
          2: //透明
            abone := 2;
          4: //重要
            abone := 4;
          end;
          //threadABoneNext.Add(datName + '=' + IntToStr(abone) + ' ' + subject); //ヒットしたスレを加える
          break;
        end;
      end;
    (* numを取得 *)
    refPos := topOfNums(refEnd, endOfRec);
    refEnd := endOfNums(refPos, endOfRec);
    nums := Copy(txt, refPos, refEnd - refPos);
    try
      num := StrToInt(nums);
    except
      num :=0;
    end;
    (* *)
    item := GetReferedThreadItem(datName);
    if item = nil then
      item := TThreadItem.Create(self);
    if 0 < Pos(#0, subject) then
      subject := ReplaceStr(subject, #0, ' ');
    item.title := subject;
    item.datName := datName;
    item.previousitemCount := item.itemCount;
    item.itemCount := num;
    item.ThreAboneType := abone;
    Add(item);
    item.number := Count;
    //item.contemporary := true;
    {aiai}
    if refresh then
      FDatList.Add(datName);
    {/aiai}
  end;

var
  i, len: integer;
  endOfRec: integer;
  firstline: string;
  tickcnt: Cardinal;
  filename: string;
begin
  tickcnt := GetTickCount;

  if refresh then
    SafeClear;

  refered := THashedStringList.Create;
  refered.Sorted := True;
  for i := 0 to Count - 1 do
  begin
    refered.AddObject(TThreadItem(items[i]).datName, items[i]);
  end;

  inherited Clear;

  if GetBBSType = bbsShitaraba then
    txt := AnsiReplaceStr(txt, '<><>NULL<>'#10, #10);
  len := length(txt);
  if GetBBSType in [bbsJBBSShitaraba, bbsJBBS] then
  begin
    firstline := Copy(txt, 1, Pos(#10, txt));
    {aiai}  //スレがひとつだけの場合はスルーする
    //if AnsiEndsStr(firstline, txt) then
    if (firstline <> txt) and AnsiEndsStr(firstline, txt) then
    {/aiai}
    begin
      len := len - Length(firstline);
      SetLength(txt, len);
    end;
  end;

  {aiai}
  //あぼ～んリスト
  threadABoneList := THashedStringList.Create;

  //threadABoneListのスレッドのうち、subject.txtにあったスレッドをいれておく
  threadABoneNext := THashedStringList.Create;

  filename := GetLogDir + SUBJECT_ABN;
  if FileExists(filename) then
    threadABoneList.LoadFromFile(filename);

  if refresh then
    FDatList := THashedStringList.Create;
  {/aiai}

  i := 1;
  while i < len do
  begin
    endOfRec := endOfRecord(i);
    if (endOfRec <= 0) then
      break;
    addRecord(i, endOfRec);
    i := endOfRec + 1;
  end;

  {aiai} //スレッドあぼ～ん
  if threadABoneNext.Count > 0 then
    threadABoneNext.SaveToFile(filename)
  else
    SysUtils.DeleteFile(filename);
  FreeAndNil(threadABoneNext);
  FreeAndNil(threadABoneList);
  {/aiai}

  for i := 0 to refered.Count -1 do
  begin
    if not refresh and (TThreadItem(refered.Objects[i]).lines <= 0) and
       not TThreadItem(refered.Objects[i]).Refered then
      TThreadItem(refered.Objects[i]).Free
    else begin
      TThreadItem(refered.Objects[i]).number := 0; //false;
      Add(refered.Objects[i]);
      {aiai}
      if refresh then
        FDatList.Add(refered.Strings[i]);
      {/aiai}
    end;
  end;
  refered.Free;
  {$IFDEF DEVELBENCH}
  Main.Log(FName + ':Analyze subject.txt ' + IntToStr(GetTickCount - tickcnt));
  {$ENDIF}

  if refresh then
  begin
    if Config.ojvQuickMerge then
      MergeCacheFast
    else
      MergeCache;
    FreeAndNil(FDatList);
  end;
  if FMoved then
    ChangeThreadItemURI;
  FSubjectText := txt;
  if lstModified <> '' then begin
    FLastModified := lstModified;
  end;
  FDatModified := true;
  FIdxModified := true;
  Main.Log('スレ一覧取得時間: ' + IntToStr(GetTickCount - tickcnt) + 'msec');
end;

(*  *)
function TBoard.GetItems(index: integer): TThreadItem;
begin
  result := inherited Items[index];
end;

(*  *)
procedure TBoard.SetItems(index: integer; value: TThreadItem);
begin
  inherited Items[index] := value;
end;

(* 指定されたdatのスレを探す *)
function TBoard.Find(const datName: string): TThreadItem;
var
  i, endPos: integer;
  thread: TThreadItem;
begin
  endPos := Count -1;
  for i := 0 to endPos do begin
    thread := Items[i];
    if (thread <> nil)
      and (datName = thread.datName) then begin
      result := thread;
      exit;
    end;
  end;
  result := nil;
end;

//aiai
function TBoard.FindThreadFirst(const datName: String): TThreadItem;
var
  i: integer;
  thread: TThreadItem;
begin
  i := FDatList.IndexOf(datName);
  if i > -1 then
  begin
    thread := items[i];
    if (thread <> nil) and (datName = thread.datName) then
    begin
      result := items[i];
      exit;
    end;
  end;
  result := nil;
end;


(* キャッシュをマージする *)
procedure TBoard.MergeCache;
var
  path: string;
  sr: TSearchRec;
  item: TThreadItem;
  datName: string;
  URI: string;
  MergingList: TList;
  msg: PChar;
  save: Boolean;
  {$IFDEF DEVELBENCH}
  tickcnt: Cardinal;
  {$ENDIF}
  sql: string;
  err: byte;
begin
  {$IFDEF DEVELBENCH}
  tickcnt := GetTickCount;
  Main.Log(FName + ':idx全ｽﾚ読込開始');
  {$ENDIF}

  MergingList := TList.Create;
  path := self.GetLogDir + '\*.dat';

  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin

    // transaction

    sql := 'BEGIN';
    err := IdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, name, sql, msg);
  end;
  (* //DataBase *)

  if FindFirst(path, faArchive, sr) = 0 then begin
    URI := GetURIBase;
    repeat
      datName := ChangeFileExt(sr.Name, '');
      item := FindThreadFirst(datName);
      if item <> nil then
      begin (* 現行スレッド *)
        if not item.Refered then
        begin
          save := item.LoadIndexData(true);
          (* DataBase (aiai) *)
          if not save and Config.ojvQuickMerge then
            item.InsertToTable;
          (* //DataBase *)
        end;
        if (item.URI <> URI) and ((item.state <> tsComplete) and (item.itemCount > 0)) then
        begin
          item.URI := URI;
          item.state := tsCurrency;
          item.SaveIndexData;
        end;
      end else
      begin
        item := TThreadItem.Create(self);
        item.datName := datName;
        save := item.LoadIndexData;
        (* DataBase (aiai) *)
        if not save and Config.ojvQuickMerge then
          item.InsertToTable;
        (* //Database *)
        if (Main.Config.datDeleteOutOfTime) and (not FUma) and
           (item.mark = timNONE) then
        begin
          (* DataBase (aiai) *)
          if Config.ojvQuickMerge then
          begin

            // commit

            sql := 'COMMIT';
            err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
            SQLCheck(err, 'In Delete Log'+#13#10+FName, sql, msg);
          end;
          (* //Database *)

          item.RemoveLog;
          item.Free;

          (* DataBase (aiai) *)
          if Config.ojvQuickMerge then
          begin

            // transaction

            sql := 'BEGIN';
            err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
            SQLCheck(err, 'In Delete Log'+#13#10+FName, sql, msg);
          end;
          (* //Database *)
        end
        else
          MergingList.Add(item);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  Assign(MergingList, laOr);
  MergingList.Free;

  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin
    sql := 'COMMIT';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);
  end;
  (* //DataBase *)

  {$IFDEF DEVELBENCH}
  if Config.ojvQuickMerge then
    Main.Log(FName + ':CreateTable ' + IntToStr(GetTickCount - tickcnt) + 'ms')
  else
    Main.Log(FName + ':Load *.idx' + IntToStr(GetTickCount - tickcnt) + 'ms');
  {$ENDIF}
end;

(* DataBase (aiai) *)

function LoadTable(Sender: TObject;
                   Columns: Integer;
                   ColumnValues: Pointer;
                   ColumnNames: Pointer): integer; cdecl;
var
  Value : ^PChar;
  item: TThreadItem;
  datName: string;
  URI: string;
begin
  Value := ColumnValues;

  With Sender as TBoard do
  begin
    datName := Value^;
    Inc(Value);
    item := FindThreadFirst(datName);
    if item <> nil then
    begin (* 現行スレッド *)
      if not item.Refered then
        item.LoadIndexDataFromDataBase(Value , true);
      if (item.URI <> GetURIBase) and ((item.state <> tsComplete) and (item.itemCount > 0)) then
      begin
        item.URI := URI;
        item.state := tsCurrency;
        item.SaveIndexData;
      end;
    end
    else begin
      item := TThreadItem.Create(Sender);
      item.datName := datName;
      item.LoadIndexDataFromDataBase(Value, true);
      if (Main.Config.datDeleteOutOfTime) and (not FUma) and
           (item.mark = timNONE) then
      begin
        item.RemoveLog;
        item.Free;
      end
      else
        FMergingList.Add(item);
    end;
  end; //With

  result := 0;
end;

//この板のテーブルを読み込む
function CallBackCheckTableVersion(Sender: TObject;
                                   Columns: Integer;
                                   ColumnValues: Pointer;
                                   ColumnNames: Pointer): integer; cdecl;
var
  Value: ^PChar;
begin
  Value := ColumnValues;
  TJLSQLite(Sender).ResultText := Value^;
  Result := 0;
end;

procedure TBoard.MergeCacheFast;
var
  msg: PChar;
  {$IFDEF DEVELBENCH}
  tickcnt: Cardinal;
  {$ENDIF}
  sql: string;
  err: byte;
begin
  {$IFDEF DEVELBENCH}
  tickcnt := GetTickCount;
  {$ENDIF}

  // check idxlist's version

  FIdxDataBase.ResultText := '';
  sql := 'SELECT version FROM tableversion WHERE tablename = ''idxlist''';
  err := FIdxDataBase.Exec(PChar(sql), @CallBackCheckTableVersion, IdxDataBase, msg);
  SQLCheck(err, FName, sql, msg);
  if FIdxDataBase.ResultText <> IDXLIST_VERSION then
  begin

    // if idxlist's version not match, then recreate the table

    sql := 'DROP TABLE idxlist';
    FIdxDataBase.Exec(PChar(sql), nil, nil, msg);

    sql := 'DELETE FROM tableversion WHERE tablename = ''idxlist''';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);

    sql := CREATE_TABLE_STATEMENT;
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);

    sql := 'INSERT INTO tableversion (tablename, version) VALUES (''idxlist'', '''+IDXLIST_VERSION+''')';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);

    MergeCache;
    exit;
  end;

  // OK! Let's Load Data!

  FMergingList := TList.Create;

  sql := 'SELECT * FROM idxlist';
  err := FIdxDataBase.Exec(PChar(sql), @LoadTable, Self, msg);
  if (0 < Pos('no such table', msg)) then
  begin

    // if no table exists, then create a new table

    FMergingList.Free;
    sql := CREATE_TABLE_STATEMENT;
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);
    MergeCache;
    exit;
  end;
  SQLCheck(err, FName, sql, msg);
  Assign(FMergingList, laOr);

  FMergingList.Free;
  {$IFDEF DEVELBENCH}
  Main.Log(FName + ':LoadTable ' + IntToStr(GetTickCount - tickcnt));
  {$ENDIF}
end;

(* For Debug *)
procedure TBoard.IdxDataBaseOpen(Sender: TObject);
begin
  if not Application.Terminated then
    Main.Log(FName + ': db open(' + IntToStr(IdxDataBase.RefCount) + ')');
end;

(* For Debug *)
procedure TBoard.IdxDataBaseClose(Sender: TObject);
begin
  if not Application.Terminated then
    Main.Log(FName + ': db close(' + IntToStr(IdxDataBase.RefCount) + ')');
end;


(* //DataBase *)

function TBoard.GetLogDir: string;
begin
  if assigned(FRedirect) then
    result := FRedirect.GetLogDir
  else
    result := TCategory(FCategory).GetLogDir + '\' + Convert2FName(FName);
end;

function TBoard.GetURIBase:string;
begin
  result := 'http://' + FHost + '/' + FBBS;
end;

(* DataBase (aiai) *)
procedure TBoard.InitialDBOpen;
var
  db: String;
  msg: PChar;
  sql: string;
  err: byte;

  procedure FirstSetUp;
  begin
    sql := 'PRAGMA default_synchronous = OFF';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);

    sql := 'CREATE TABLE tableversion (tablename PRIMARY KEY, version)';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);

    sql := 'INSERT INTO tableversion (tablename, version) VALUES (''board_db'', '''+BOARD_VERSION+''')';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, FName, sql, msg);
  end;

begin
  if FIdxDataBase.Opened then
    exit;

  db := GetLogDir + BOARD_DB;
  if not FileExists(db) then
  begin
    RecursiveCreateDir(GetLogDir);  //板のログフォルダの作成
    if not FIdxDataBase.Open(PChar(db), 0, msg) then
    begin
      ShowMessage('Unable Open '+db +#13#10+ msg);
      MainWnd.Close;
      exit;
    end;
    FirstSetUp;
    exit;
  end;

  if not FIdxDataBase.Open(PChar(db), 0, msg) then
  begin
    Main.Log(FName +':Cannot Open DataBase');
    if not SysUtils.DeleteFile(db) then
    begin
      ShowMessage('Unable Delete '+db);
      MainWnd.Close;
      exit;
    end else
      Main.Log(FName + ':Delete ' + db);

    if not IdxDataBase.Open(PChar(db), 0, msg) then
    begin
      ShowMessage('Unable Open '+db +#13#10+ msg);
      MainWnd.Close;
      exit;
    end;
    FirstSetUp;
    exit;
  end;

  // check board_db version

  IdxDataBase.ResultText := '';
  sql := 'SELECT version FROM tableversion WHERE tablename = ''board_db''';
  err := FIdxDataBase.Exec(PChar(sql), @CallBackCheckTableVersion, FIdxDataBase, msg);
  SQLCheck(err, FName, sql, msg);
  if FIdxDataBase.ResultText <> BOARD_VERSION then
  begin

    // if not board_db version not match, then recreate db file

    Main.Log(FName + ':DataBase Version Change ' + '『' + FIdxDataBase.ResultText + '』' + ' to ' + '『' + BOARD_VERSION + '』');
    if IdxDataBase.Close then
      Main.Log(FName +':DataBase Close');
    if not SysUtils.DeleteFile(db) then
    begin
      ShowMessage('Unable Delete '+db);
      MainWnd.Close;
      exit;
    end else
      Main.Log(FName +':Delete ' + db);
    if not FIdxDataBase.Open(PChar(db), 0, msg) then
    begin
      ShowMessage('Unable Open ' + db +#13#10+ msg);
      MainWnd.Close;
      exit;
    end;
    FirstSetUp;
  end;
end;
(* //DataBase *)

procedure TBoard.LoadIndex;
var
  filename: string;
  strList: TStringList;
begin
  filename := GetLogDir + SUBJECT_IDX;
  strList := TStringList.Create;
  FLastModified := '';
  FSelDatName := '';
  FUma := false;
  if FileExists(filename) then
  begin
    try
      strList.LoadFromFile(filename);
      FLastModified  := strList.Strings[IDX_MODIFIED];
      FSelDatName   := strList.Strings[IDX_SELECTED];
      FCustomHeader := strList.Strings[IDX_CUSTOMHEADER];
      try FUma := Boolean(StrToInt(strList.Strings[IDX_MARKER])); except end;
    except
    end;
  end;

  strList.Free;
end;

(* 保存したスレ一覧を取得する *)
procedure TBoard.Load(refresh: Boolean = False);
var
  stream: TPSStream;
  filename: string;
  txt, modified: string;
begin
  filename := GetLogDir + SUBJECT_TXT;
  FSubjectText := '';
  if FileExists(filename) then
  begin
    stream := TPSStream.Create('');
    try
      stream.LoadFromFile(filename);
      Txt := stream.DataString;
    except
    end;
    stream.Free;
  end;

  LoadIndex;
  
  (* DataBase *)
  if Config.ojvQuickMerge then
  begin
    InitialDBOpen
  end else
    SysUtils.DeleteFile(GetLogDir + BOARD_DB);
  (* //DataBase *)
  {/aiai}

  modified := FLastModified;

  Analyze(Txt, modified, (FRefcount <= 0) or refresh);
  FDatModified := false;
  FIdxModified := false;
end;


procedure TBoard.SaveIndex;
var
  strList: TStringList;
begin
  if FIdxModified then
  begin
    RecursiveCreateDir(GetLogDir);
    strList := TStringList.Create;
    strList.Add(FName);
    strList.Add(FLastModified);
    strList.Add(FSelDatName);
    strList.Add(FCustomHeader);
    strList.Add(IntToStr(Integer(FUma)));
    try
      strList.SaveToFile(GetLogDir + SUBJECT_IDX);
    except
    end;
    strList.Free;
    FIdxModified := false;
  end;
end;

(* スレ一覧を保存する *)
procedure TBoard.Save;
var
  stream: TPSStream;
begin
  if FDatModified then
  begin
    RecursiveCreateDir(GetLogDir);
    stream := TPSStream.Create(FSubjectText);
    try
      stream.SaveToFile(GetLogDir + SUBJECT_TXT);
    except
    end;
    stream.Free;
    FDatModified := false;
  end;
  SaveIndex;
end;

(*  *)
procedure TBoard.Activate;
begin
  if length(FSubjectText) <= 0 then
    Load;
end;

procedure TBoard.SetSelDatName(const datName: string);
begin
  FSelDatName := datName;
  FIdxModified := true;
end;

procedure TBoard.SetCustomHeader(const str: string);
begin
  FCustomHeader := str;
  FIdxModified := true;
end;

procedure TBoard.SetUma(val: boolean);
begin
  FUma := val;
  FIdxModified := true;
end;

function TBoard.GetBBSType: TBBSType;
var
  i: integer;
begin
  if FBBSType = bbsNone then
  begin
    for i := 0 to Config.bbs2chServers.Count -1 do
    begin
      if AnsiEndsStr(Config.bbs2chServers[i], FHost) then
      begin
        FBBSType := bbs2ch;
        result := bbs2ch;
        exit;
      end;
    end;
    for i := 0 to Config.bbsMachiServers.Count -1 do
    begin
      if AnsiEndsStr(Config.bbsMachiServers[i], FHost) then
      begin
        FBBSType := bbsMachi;
        result := bbsMachi;
        exit;
      end;
    end;
    //▼ Nightly Fri Sep 24 14:42:31 2004 UTC by lxc
    (* したらばのURL対応を少し汎用的に *)
    for i := 0 to Config.bbsJBBSServers.Count -1 do
    begin
      if AnsiStartsStr(Config.bbsJBBSServers[i], FHost) then
      begin
        FBBSType := bbsJBBSShitaraba;
        result := bbsJBBSShitaraba;
        exit;
      end;
    end;
    if AnsiStartsStr('www.jbbs.net', FHost)
            or AnsiStartsStr('green.jbbs.net', FHost) then
    //▲ Nightly Fri Sep 24 14:42:31 2004 UTC by lxc
      FBBSType := bbsJBBS
    else if AnsiStartsStr('www.shitaraba.com', FHost) then
      FBBSType := bbsShitaraba
    else
      FBBSType := bbsOther
  end;
  result := FBBSType;
end;

(* スレ一覧での状態をリセット *)
procedure TBoard.ResetListState;
var
  i: integer;
begin
  if not Config.oprSelPreviousThread then //最後に見てた位置へジャンプしなければクリア
    FSelDatName := '';
  (* 板のソート (aiai) *)
  FSortColumn := Config.stlDefSortColumn;

  if threadSearched then //絞込検索をしていたらスレの検索状態をクリア
  begin
    for i := 0 to Count -1 do
      Items[i].liststate := 0;
    threadSearched := false;
  end;
end;

(* hostを変更する際に子のスレッドのURIを修正 *)
procedure TBoard.SetHost(newHost: string);
begin
  if StartWith('jbbs.',  newHost, 1) and
          not StartWith(Config.bbsJBBSServers[0], newHost, 1) then
      newHost := Config.bbsJBBSServers[0]
              + Copy(newHost, FindPos('/', newHost, 5), High(Integer));
  if newHost = FHost then
    exit;
  FHost := newHost;
  {aiai}
  if FHost = 'be.2ch.net' then
    FNeedConvert := True;
  {/aiai}
  if Count > 0 then
    FMoved := true;  //AnalyzeからChangeThreadItemURIを呼び出す
end;

(* hostを変更する際にこのスレッドのURIを修正 *)
procedure TBoard.ChangeThreadItemURI;
var
  URI: String;
  i: Integer;
begin
  URI := GetURIBase;
  for i := 0 to Count - 1 do
    if Assigned(Items[i]) and (Items[i].URI <> '') and (Items[i].number > 0) and
       ((Items[i].state <> tsComplete) and (Items[i].itemCount > 0)) then
    begin
      Items[i].URI := URI;
      Items[i].state := tsCurrency;
      Items[i].SaveIndexData;
    end;
  FMoved := false;
end;

//改造▽ 追加 (スレッドあぼ～ん)
(* スレッドあぼ～ん *)
function TBoard.ThreadAbone(ABoneList: TList; AboneType: Byte): boolean;
var
  i, intIndex: integer;
  threadABoneList: TStringList;
  thread: TThreadItem;

  procedure FindIndex;
  var
    j: Integer;
    ti: TThreadItem;
  begin
    for j := 0 to Count - 1 do
    begin
      ti := Items[j];
      if (ti <> nil) and (thread = ti) then
      begin
        intIndex := j;
        exit;
      end;
    end;
    intIndex := -1;
  end;


begin
  result := False;

  //subject.abnをLoad
  threadABoneList := TStringList.Create;

  if FileExists(GetLogDir + SUBJECT_ABN) then
    threadABoneList.LoadFromFile(GetLogDir + SUBJECT_ABN);

  for i := 0 to ABoneList.Count - 1 do
  begin

    thread := TThreadItem(ABoneList.Items[i]);

    //このスレッドのインデックスを探す
    FindIndex;

    if intIndex = -1 then
      Continue;

    //すでに登録されているかどうか
    intIndex := threadABoneList.IndexOfName(thread.datName);
    if intIndex >= 0 then
      threadABoneList.Delete(intIndex); 

    //あぼ～んリストに加える
    threadABoneList.Add(thread.datName + '=' + IntToStr(AboneType) + ' ' + thread.title);

    //スレッドを削除
    //thread.Free;
    thread.ThreAboneType := AboneType or TThreABNFLAG;

    //板から削除
    //Self.Delete(intIndex);

    Result := True;
    
  end;

  //subject.abnをsave、あぼ～んリストが空ならsubject.abnを削除
  if threadABoneList.Count > 0 then
    try threadABoneList.SaveToFile(GetLogDir + SUBJECT_ABN); except end
  else
    SysUtils.DeleteFile(GetLogDir + SUBJECT_ABN);

  threadABoneList.Free;
end;
//改造△ 追加 (スレッドあぼ～ん)

(* 非同期通信への窓口 *)
function TBoard.StartQuery(OnProcDone: TBoardSubjectEndNotifyEvent): Boolean;
var
  URI: string;
  threadlist: string;
  theTime: TDateTime;
  kbSpeed: Cardinal;
begin
  Result := False;
  if not (FProcState in [tpsNone, tpsDone]) then
    exit;

  if Now <= IncSecond(FLastAccess, Config.oprListReloadInterval) then
  begin
    SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @kbSpeed, 0);
    FLastAccess := FLastAccess + 1.2/((30-2.5)*kbSpeed/31 + 2.5)/(24*60*60);
    theTime := IncSecond(Now, Config.oprListReloadInterval);
    if theTime < FLastAccess then
      FLastAccess := theTime;
    exit;
  end;

  if FPast then
    threadlist := THREAD_PAST_LIST
  else
    threadlist := THREAD_CURRENT_LIST;
//  if Config.tstAuthorizedAccess then
  {$IFDEF APPEND_SID}
    URI := ticket2ch.AppendSID(board.GetURIBase + '/' + threadList, '?')
  {$ELSE}
    URI := GetURIBase + '/' + threadList;
  {$ENDIF}
//  else
//    URI := 'http://' + FHost + '/test/read.cgi/' + FBBS + '/?raw=0.0';

  FPRocState := tpsWorking;
  FOnSubjectEnd := OnProcDone;

  AddRef;

  LogBeginQuery2;
  FProcGetSubject := AsyncManager.Get(URI, OnAsyncDoneProc,
    ticket2ch.On2chPreConnect, FLastModified);
  Result := True;
end;

(* サーバ移転検出用 *)
function TBoard.HomoMovedQuery(OnProcDone: TBoardSubjectEndNotifyEvent): Boolean;
begin
  Result := False;
  if not (Self.FProcState in [tpsNone, tpsDone]) then
    exit;

  if usetrace[16] then Log(traceString[16]) else Log('川*’∀’）ｲﾃﾝﾂｲﾋ');

  AddRef;

  FProcState := tpsWorking;
  FOnSubjectEnd := OnProcDone;

  FProcGetSubject := AsyncManager.Get(GetURIBase + '/', OnMovedSubject,
      ticket2ch.On2chPreConnect, '');
  Result := True;
end;

(* 更新チェック用 *)
function TBoard.StartAsyncRead(OnCheckDone: TBoardCheckEndEvent;
  Data: String; PatrolType: TPatrolType): Boolean;
var
  URI: string;
  threadlist: string;
  theTime: TDateTime;
  kbSpeed: Cardinal;
begin
  Result := False;
  if not (FProcState in [tpsNone, tpsDone]) then
  begin
    FOnCheckEnd(Self, -1, PatrolType);
    exit;
  end;

  if Now <= IncSecond(FLastAccess, Config.oprListReloadInterval) then
  begin
    SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @kbSpeed, 0);
    FLastAccess := FLastAccess + 1.2/((30-2.5)*kbSpeed/31 + 2.5)/(24*60*60);
    theTime := IncSecond(Now, Config.oprListReloadInterval);
    if theTime < FLastAccess then
      FLastAccess := theTime;
    FOnCheckEnd(Self, -1, PatrolType);
    exit;
  end;

  if FPast then
    threadlist := THREAD_PAST_LIST
  else
    threadlist := THREAD_CURRENT_LIST;
//  if Config.tstAuthorizedAccess then
  {$IFDEF APPEND_SID}
    URI := ticket2ch.AppendSID(board.GetURIBase + '/' + threadList, '?')
  {$ELSE}
    URI := GetURIBase + '/' + threadList;
  {$ENDIF}
//  else
//    URI := 'http://' + FHost + '/test/read.cgi/' + FBBS + '/?raw=0.0';

  FFavPatrolType := PatrolType;
  FFavPatrolData := Data;
  FPRocState := tpsChecking;
  FOnCheckEnd := OnCheckDone;

  AddRef;

  FProcGetSubject := AsyncManager.Get(URI, OnAsyncDoneProc,
    ticket2ch.On2chPreConnect, FLastModified);
end;

procedure TBoard.OnAsyncDoneProc(Sender: TASyncReq);
  procedure HomeMovedBoard;
  begin
    if usetrace[16] then Log(traceString[16]) else Log('川*’∀’）ｲﾃﾝﾂｲﾋ');
    LogBeginQuery2;
    FProcState := tpsWorking;
    FProcGetSubject := AsyncManager.Get(
      copy(Sender.URI, 1, LastDelimiter('/', Sender.URI)), OnMovedSubject,
      ticket2ch.On2chPreConnect, '');
  end;

  procedure GotSuccessfully(const content: string);
  begin
    Analyze(content, Sender.GetLastModified, false);
    Save;
    if timeValue <= 0 then
      timeValue := DateTimeToUnix(Str2DateTime(Sender.GetDate));
    if Assigned(FOnSubjectEnd) then
      FOnSubjectEnd(Self);
    UpdateTabColor;
  end;

var
  content, s: string;
  i: integer;
begin
  LogEndQuery2;
  if Sender <> FProcGetSubject then
    exit;
  FLastAccess := Now;
  FProcGetSubject := nil;
  FPRocState := tpsDone;

  Main.Log(Sender.IdHTTP.ResponseText);

  Case Sender.IdHTTP.ResponseCode of

    200: begin (* 200 OK *)
      if (Length(Sender.Content) <= 0) and Config.optHomeIfSubjectIsEmpty then
      begin
        HomeMovedBoard;
        exit;
      end;
      FLast2Modified := FLastModified;

      Case GetBBSType of
        bbsJBBSShitaraba, bbsShitaraba: content := euc2sjis(Sender.Content);
      else
        if FNeedConvert then
          content := euc2sjis(Sender.Content)
        else
          content := Sender.Content;
      end; //Case

      if AnsiStartsStr('+', content) or AnsiStartsStr('-', content) then
      begin
        i := Pos(#10, content);
        if 0 < i then
        begin
          s := AnsiReplaceStr(Copy(content, 1, i - 1), #13, '');
          if usetrace[15] then Log(traceString[15] + s) else Log('( @_@) □ ﾅﾆﾅﾆ･･･  ' + s);
          content := Copy(content, i + 1, high(integer));
          if s[1] = '+' then
            GotSuccessfully(content);
        end;
      end
      else
        GotSuccessfully(content);
    end;

    302: begin (* 302 Found *)
      HomeMovedBoard;
      exit;
    end;

    304: begin (* 304 Not Modified *)
      FLast2Modified := FLastModified;
      if usetrace[17] then Log(traceString[17]) else Log('川 ’ー’川新着ﾅｼ');
      if Assigned(FOnSubjectEnd) then
        FOnSubjectEnd(Self);
    end;

  else

    WriteStatus(Sender.IdHTTP.ResponseText);

  end; //Case

  Release;

  FOnSubjectEnd := nil;
  if Assigned(FOnCheckEnd) then
  begin
    FOnCheckEnd(Self, -1, FFavPatrolType);
    FOnCheckEnd := nil;
    Main.Log('(' + FFavPatrolData + ') 【' + FName + '】');
  end;
end;

procedure TBoard.OnMovedSubject(Sender: TASyncReq);
var
  URI, host2, bbs2: string;
  startpos, endpos: Integer;
label FAILED;
begin
  LogEndQuery2;

  if sender <> FProcGetSubject then
    exit;

  FProcGetSubject := nil;
  FPRocState := tpsDone;
  WriteStatus(sender.IdHTTP.ResponseText);

  case sender.IdHTTP.ResponseCode of

  200: (* 200 OK *)
    begin
      startpos := Pos('href="', sender.Content) + 6;
      if startpos <= 6 then
        goto FAILED;
      endpos := FindPos('/"</script>', sender.Content, startpos);
      if endpos <= startpos then
        goto FAILED;
      URI := copy(sender.Content, startpos, endpos - startpos);
      SplitThreadURI(URI, host2, bbs2);
      if bbs2 <> Self.bbs then
        goto FAILED;
      Self.host := host2;
      Log(sender.URI + ' -> ' + URI + '/');
      if useTrace[12] then Log(traceString[12]) else Log('川*’∀’）ﾀﾌﾞﾝｾｲｺｳ');
      if usetrace[13] then Log(traceString[13]) else Log('川*’∀’）ｱﾄﾃﾞﾓｳｲﾁﾄﾞｺｳｼﾝｼﾃﾐﾙｶﾞｼ');
      WriteStatus('板移転検出');
      Self.lastAccess := 0;
    end;
  else
    FAILED:
      if usetrace[14] then Log(traceString[14]) else Log('ﾂｲﾋﾞｼｯﾊﾟｲ川 - 。- 川');

  end;
  Release;
  if Assigned(FOnCheckEnd) then
  begin
    FOnCheckEnd(Self, -1, FFavPatrolType);
    FOnCheckEnd := nil;
    Main.Log('(' + FFavPatrolData + ') 【' + FName + '】');
  end;
end;

//SETTING.TXT処理

procedure TBoard.LoadSettingTXT;
var
  NeedSETTINGTXT: Boolean;
  sl: TStringList;
begin
  if FSettingTxtLoaded then exit;

  {$IFDEF DEBUG2}
  Main.Log(FName + ':SETTING.TXT読込');
  {$ENDIF}

  FSettingTxtLoaded := True;
  FProcGetSettingTxt := nil;
  FGotSettingTxt := tpsNone;
  FreeAndNil(FStoredSettingText);
  NeedSETTINGTXT := False;
  FBBSCount.linenumber := 0;
  FBBSCount.messagecount := 0;
  FBBSCount.subjectcount := High(Integer);
  FBBSCount.namecount := High(Integer);
  FBBSCount.mailcount := High(Integer);
  FSettingText := '';
  try
    FStoredSettingText := TLocalCopy.Create(GetLogDir + '\setting.txt', '.idb');
    if FStoredSettingText.Load then
    begin
      FSettingText := FStoredSettingText.DataString;
      sl := TStringList.Create;
      sl.Text := FSettingText;
      FBBSCount.linenumber := StrToIntDef(sl.Values[BBS_LINE_NUMBER], 0);
      FBBSCount.messagecount := StrToIntDef(sl.Values[BBS_MESSAGE_COUNT], 0);
      FBBSCount.subjectcount := StrToIntDef(sl.Values[BBS_SUBJECT_COUNT], High(Integer));
      FBBSCount.namecount := StrToIntDef(sl.Values[BBS_NAME_COUNT], High(Integer));
      FBBSCount.mailcount := StrToIntDef(sl.Values[BBS_MAIL_COUNT], High(Integer));
      sl.Free;
      if (FStoredSettingText.Info.Count = 0) or
         (FStoredSettingText.Info[0] <> GetURIBase + '/SETTING.TXT') then
        NeedSETTINGTXT := True;
      if FStoredSettingText.Updated + 30 < Now then
        NeedSETTINGTXT := True;
    end else
      NeedSETTINGTXT := True;
  finally
    FreeAndNil(FStoredSettingText);
  end;
  if (GetBBSType = bbs2ch) and NeedSETTINGTXT then
    GetSettingTxt;
end;

procedure TBoard.GetSettingTxt;
var
  URI: string;
  lastModified: string;
begin
  if FGotSettingTxt <> tpsNone then
    exit;
  Main.Log('川*’ー’）' + name + 'ﾉSETTING.TXTｦ取ﾘﾆ行ｸﾖ');
  lastModified := '';
  if FStoredSettingText = nil then
  begin
    FStoredSettingText := TLocalCopy.Create(GetLogDir + '\setting.txt', '.idb');
    FStoredSettingText.Load;
    if 2 <= FStoredSettingText.Info.Count then
      lastModified := FStoredSettingText.Info.Strings[1];
  end;
  FGotSettingTxt := tpsWorking;
  URI := GetURIBase + '/SETTING.TXT';
  FProcGetSettingTxt := AsyncManager.Get(URI, OnSettingTxt, ticket2ch.On2chPreConnect,
                              lastModified);
end;

procedure TBoard.OnSettingTxt(sender: TAsyncReq);
var
  lastModified: string;
  sl: TStringList;
begin
  if FProcGetSettingTxt = sender then
  begin
    Main.Log(name + ':SETTING.TXT:' + sender.IdHTTP.ResponseText);
    case sender.IdHTTP.ResponseCode of
      200: (* OK *)
        begin
          FStoredSettingText.Clear;
          if FNeedConvert then
            FStoredSettingText.WriteString(StringReplace(euc2sjis(sender.Content), #10, #13#10, [rfReplaceAll]))
          else
            FStoredSettingText.WriteString(StringReplace(sender.Content, #10, #13#10, [rfReplaceAll]));
          FStoredSettingText.Info.Add(GetURIBase + '/SETTING.TXT');
          FStoredSettingText.Info.Add(sender.GetLastModified);
          FStoredSettingText.Save;
          FSettingText := FStoredSettingText.DataString;
          sl := TStringList.Create;
          sl.Text := FSettingText;
          FBBSCount.linenumber := StrToIntDef(sl.Values[BBS_LINE_NUMBER], 0);
          FBBSCount.messagecount := StrToIntDef(sl.Values[BBS_MESSAGE_COUNT], 0);
          FBBSCount.subjectcount := StrToIntDef(sl.Values[BBS_SUBJECT_COUNT], High(Integer));
          FBBSCount.namecount := StrToIntDef(sl.Values[BBS_NAME_COUNT], High(Integer));
          FBBSCount.mailcount := StrToIntDef(sl.Values[BBS_MAIL_COUNT], High(Integer));
          sl.Free;
          ChangeWriteMemoSettingText(Self);
        end;
      304: (* NotModifiedの時も再保存することで最終チェック時刻を更新 *)
        begin
          lastModified := '';
          if FStoredSettingText.Info.Count >= 2 then
            lastModified := FStoredSettingText.Info.Strings[1];
          FStoredSettingText.Info.Clear;
          FStoredSettingText.Info.Add(GetURIBase + '/SETTING.TXT');
          FStoredSettingText.Info.Add(lastModified);
          FStoredSettingText.Save;
          ChangeWriteMemoSettingText(Self);
        end;
      302: (* Not Foundの時はそのことを保存 *)
        begin
          FStoredSettingText.Clear;
          FStoredSettingText.Info.Add(GetURIBase + '/SETTING.TXT');
          FStoredSettingText.Info.Add(sender.GetLastModified);
          FStoredSettingText.Save;
          FSettingText := FStoredSettingText.DataString;
          sl := TStringList.Create;
          sl.Text := FSettingText;
          FBBSCount.linenumber := StrToIntDef(sl.Values[BBS_LINE_NUMBER], 0);
          FBBSCount.messagecount := StrToIntDef(sl.Values[BBS_MESSAGE_COUNT], 0);
          FBBSCount.subjectcount := StrToIntDef(sl.Values[BBS_SUBJECT_COUNT], High(Integer));
          FBBSCount.namecount := StrToIntDef(sl.Values[BBS_NAME_COUNT], High(Integer));
          FBBSCount.mailcount := StrToIntDef(sl.Values[BBS_MAIL_COUNT], High(Integer));
          sl.Free;
          ChangeWriteMemoSettingText(Self);
        end;
    end;
    FreeAndNil(FStoredSettingText);
    FProcGetSettingTxt := nil;
    FGotSettingTxt := tpsDone;
  end;
end;

(* Drag and Drop でログ追加 (aiai) *)
procedure TBoard.MergeCacheFrequency(fnamelist: TStringList);
var
  item: TThreadItem;
  datName, URI: String;
  i: Integer;
  msg: PChar;
  save: Boolean;
  sql: string;
  err: byte;
begin
  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin
    sql := 'BEGIN';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg); //トランザクション
    SQLCheck(err, FName, sql, msg);
  end;
  (* //DataBase *)

  for i := 0 to fnamelist.Count - 1 do
  begin
    URI := GetURIBase;
    datName := ChangeFileExt(ExtractFileName(fnamelist.Strings[i]), '');
    item := Find(datName);
    if item <> nil then
    begin
      save := item.LoadIndexData(true);
      (* DataBase (aiai) *)
      if not save and Config.ojvQuickMerge then
        item.InsertToTable;
      (* //DataBase *)
      if (item.URI <> URI) and ((item.state <> tsComplete) and (item.itemCount > 0)) then
      begin
        item.URI := URI;
        item.state := tsCurrency;
        item.SaveIndexData;
      end;
    end else
    begin
      item := TThreadItem.Create(Self);
      item.datName := datName;
      save := item.LoadIndexData;
      (* DataBase (aiai) *)
      if not save and Config.ojvQuickMerge then
        item.InsertToTable;
      (* //Database *)

      Add(item);
    end;
  end; //for

  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin
    sql := 'COMMIT';
    err := FIdxDataBase.Exec(PChar(sql), nil, nil, msg); //トランザクション
    SQLCheck(err, FName, sql, msg);
  end;
  (* //DataBase *)

end;
(* //Drag and Drop でログ追加 *)

(*=======================================================*)
procedure TFunctionalBoard.LoadIndex;
begin
end;

procedure TFunctionalBoard.SaveIndex;
begin
end;

procedure TFunctionalBoard.Save;
begin
end;

procedure TFunctionalBoard.Clear;
begin
  SafeClear;
  inherited;
end;

//参照中のスレは本来の板に返す
procedure TFunctionalBoard.SafeClear;
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    if Items[i] <> nil then
    begin
      Items[i].Release;
      Items[i] := nil;
    end;
  end;
  Pack;
//  RemoveFromRecyleList(Self);
end;

procedure TFunctionalBoard.Release;
begin
  Dec(FRefCount);
  if FRefCount <= 0 then
    SafeClear;
end;

procedure TFunctionalBoard.SetHost(newHost: string);
begin
  FHost := newHost;
end;

//aiai
procedure TFunctionalBoard.ResetListState;
var
  i: integer;
begin
  if not Config.oprSelPreviousThread then //最後に見てた位置へジャンプしなければクリア
    FSelDatName := '';
  FSortColumn := Config.stlDefFuncSortColumn; //スレ一覧、お気に入り用ソート設定

  if threadSearched then //絞込検索をしていたらスレの検索状態をクリア
  begin
    for i := 0 to Count -1 do
      Items[i].liststate := 0;
    threadSearched := false;
  end;
end;

(*=======================================================*)

//▼ログ一覧
procedure TLogListBoard.Load;
var
  i, j, k:integer;
  datcount: integer;
  board: TBoard;
  path: string;
  sr: TSearchRec;
  item: TThreadItem;
begin
  for i := 0 to i2ch.Count -1 do
  begin
    for j := 0 to i2ch.Items[i].Count -1 do
    begin
      board := i2ch.Items[i].Items[j];
      path := board.GetLogDir + '\*.dat';

      //datファイル検索
      if FindFirst(path, faArchive, sr) <> 0 then
        continue;
      if (Main.Config.optLogListLimitCount > 0) then //制限つき
      begin
        datCount := 0;
        repeat
          Inc(datCount);
          if (Main.Config.optLogListLimitCount <= datCount) then
          begin
            datCount := 0;
            break;
          end;
        until (FindNext(sr) <> 0);
      end else  //制限なし
        datCount := 1;

      FindClose(sr);
      if datcount = 0 then
        continue;

      board.AddRef;
      for k := 0 to board.Count -1 do
      begin
        item := board.items[k];
        if item.lines > 0 then //既得スレ
        begin
          item.AddRef(false); //ログ一覧で参照中に
          self.Add(item);
        end;
      end;
      board.Release;
    end;
  end;
end;

//※[457]
constructor TLogListBoard.Create(category: TObject);
begin
  inherited;
  //▼test
  FHost := 'Jane';   //適当だけどお気に入りで使うために
  bbs := 'Log';
  Name := 'ログ一覧';
end;

(*=======================================================*)
// 現在開いているスレッドの一覧 ( by aiai )
constructor TOpenThreadsBoard.Create(category: TObject);
begin
  inherited Create(category);

  FHost := 'Jane';
  bbs := 'OpenThreads';
  Name := 'OpenThreads';
end;

procedure TOpenThreadsBoard.Load;
var
  i: integer;
  item: TThreadItem;
begin
  for i := 0 to viewList.Count - 1 do
  begin
    item := viewList.Items[i].thread;
    if item <> nil then
    begin
      item.AddRef(false);
      Add(item);
    end;
  end;
end;

(*=======================================================*)
//※[457]
constructor TFavoriteListBoard.Create(category: TObject; favs: TFavoriteList);
begin
  inherited Create(category);
  if favs = nil then
    favs := favorites;
  FHost := 'Jane';
  bbs := favs.name;// 'fav';
  SetFavList(favs);
end;

//※[457]
procedure TFavoriteListBoard.Load;
var
  //list: TList;
  refBoard: TList;

  //ログフォルダ名でソート
  {function CompareFunc(Item1, Item2: Pointer): integer;
  begin
    result := AnsiCompareFileName(TBoard(TThreadItem(Item1).board).GetLogDir,
                                  TBoard(TThreadItem(Item2).board).GetLogDir);
  end;}
  //boardでソート
  {function CompareFunc(Item1, Item2: Pointer): integer;
  var
    cat: TCategory;
  begin
    result := i2ch.IndexOf(TBoard(TThreadItem(Item1).board).category)
            - i2ch.IndexOf(TBoard(TThreadItem(Item2).board).category);
    if result <> 0 then
      exit;
    cat := TBoard(TThreadItem(Item1).board).category as TCategory;
    result := cat.IndexOf(TBoard(TThreadItem(Item1).board))
            - cat.IndexOf(TBoard(TThreadItem(Item2).board));
  end;

  //subject.txtからレス数を取得する
  procedure LoadSubjectData;
  var
    subject: TStringList;

    //指定datのレス数を取得
    function GetItemCountFromSubject(datName: string): integer;
    var
      index, len, i: integer;
    begin
      result := 0;
      subject.Find(datName, index);
      if not AnsiStartsStr(datName, subject[index]) then
        exit;
      len := length(subject[index]);
      for i := len downto 0 do
      begin
        if subject[index][i]= '(' then
        begin
          result := StrToIntDef(copy(subject[index], i+1, len - (i+1)), 0);
          exit;
        end;
      end;
    end;

  var
    i: Integer;
    prevsubjectname, tmpsubjectname: string;
    item: TThreadItem;
  begin
    subject := TStringList.Create;
    for i:=0 to list.Count-1 do
    begin
      item := TThreadItem(list.Items[i]);
      tmpsubjectname := TBoard(item.board).GetLogDir + SUBJECT_TXT;
      if prevsubjectname <> tmpsubjectname then
      begin
        try
          prevsubjectname := tmpsubjectname;
          subject.LoadFromFile(tmpsubjectname);
          //Log(tmpsubjectname);
          subject.Sort;
        except
          continue;
        end;
      end;
      item.itemCount := GetItemCountFromSubject(item.datName);
    end;
    subject.Free;
  end;
  }
  procedure AddItem(fav: TFavorite);
  var
    item: TThreadItem;
    board: TBoard;
  begin
    //スレでない、登録済み、ボードのデータがないお気に入りは無視
    if fav.datName = '' then
      exit;
    item := self.Find(fav.datName);
    if (item <> nil) and (TBoard(item.board).bbs = fav.bbs) then
      exit;
    board := i2ch.FindBoard(fav.host, fav.bbs);
    if board = nil then
      exit;
    //板情報をロードする
    if refBoard.IndexOf(board) < 0 then
    begin
      board.AddRef;
      refBoard.Add(board);
    end;
    //スレをロードした板から探してお気に入り板に加える
    item := board.Find(fav.datName);
    if item = nil then
    begin
      item := TThreadItem.Create(board);
      item.datName := fav.datName;
      item.LoadIndexData;
      if item.title = '' then
        item.title := fav.name;
      board.Add(item)
    end;
    item.AddRef(false); //お気に入り板で参照中に
    //list.Add(item);
    self.Add(item);
  end;

  procedure AddFavList(favs: TFavoriteList);
  var
    i: Integer;
  begin
  for i := 0 to favs.Count - 1 do
    if (favs.Items[i] is TFavorite) then
      AddItem(TFavorite(favs.Items[i]))
    else if (favs.Items[i] is TFavoriteList) then
    begin
      AddFavList(TFavoriteList(favs.Items[i]));
    end;
  end;
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    Items[i].Release;
    if not Items[i].Refered then
    Items[i] := nil;
  end;
  Pack;
  //list := TList.Create;
  refBoard := TList.Create;
  AddFavList(favs);
  //list.Sort(@CompareFunc);
  //LoadSubjectData;
  //list.Free;
  for i := 0 to refBoard.Count -1 do
    TBoard(refBoard.Items[i]).Release;
  refBoard.Free;
  favChanged :=false;
end;

procedure TFavoriteListBoard.SetFavList(favList: TFavoriteList);
begin
  favChanged := favs <> favList;
  if favChanged then
  begin
    favs := favList;
    name := favList.name;
  end;
end;

(*=======================================================*)
//※[457]
function TFavoriteListBoardAdmin.GetBoard(favs: TFavoriteList): TFavoriteListBoard;
var
  i: Integer;
  favsboard: TFavoriteListBoard;
begin
  result := nil;
  for i := 0 to objlist.Count - 1 do
  begin
    if TFavoriteListBoard(objlist.Items[i]).bbs = favs.name then
    begin
      result := TFavoriteListBoard(objlist.Items[i]);
      break;
    end;
  end;

  if not Assigned(result) then
  begin
    favsboard := TFavoriteListBoard.Create(category, favs);
    objlist.Add(favsboard);
    result := favsboard;
  end
end;

//※[457]
constructor TFavoriteListBoardAdmin.Create(category: TObject);
begin
  inherited Create;
  self.category := category;
  objlist := TList.Create;
end;

//※[457]
destructor TFavoriteListBoardAdmin.Destroy;
var
  i: Integer;
begin
  for i:=objlist.Count-1 downto 0 do
  begin
    TFavoriteListBoard(objlist.Items[i]).Free;
    objlist.Delete(i);
  end;
  objlist.Free;
  inherited;
end;

//※[457]
procedure TFavoriteListBoardAdmin.GarbageCollect;
var
  i: integer;
begin
  for i:=objlist.Count-1 downto 0 do
  begin
    if (TFavoriteListBoard(objlist.Items[i]).FRefCount <= 0) and
       (boardList.IndexOf(objlist.Items[i]) < 0) then
    begin
      TFavoriteListBoard(objlist.Items[i]).Free;
      objlist.Delete(i);
    end;
  end;
end;


(*=======================================================*)
(* スレ覧タブに板を開く *)
procedure TBoardList.Open(board: TBoard);
begin
  board.AddRef; //スレ覧タブでの参照増加
  board.ResetListState;
end;

(* スレ覧タブから板を開じる *)
procedure TBoardList.Close(board: TBoard);
var
  i: integer;
begin
  if board.threadSearched then //絞込検索をしていたら残ったスレの検索状態をクリア
  begin
    for i := 0 to Count -1 do
      board.Items[i].liststate := 0;
    board.threadSearched := false;
  end;
  board.Release; //スレ覧タブでの参照終了
end;

(* キャスト *)
function TBoardList.GetItems(index:integer): TBoard;
begin
  result := inherited Items[index];
end;

(* 板の入れ替え *)
procedure TBoardList.SetItems(index: integer; board: TBoard);
begin
  Close(Items[index]);
  Open(board);
  inherited Items[index] := board;
end;

(* 項目追加 *)
procedure TBoardList.Add(board: TBoard);
begin
  Open(board);
  inherited Add(board);
end;

procedure TBoardList.Insert(index: integer; board: TBoard);
begin
  Open(board);
  inherited Insert(index, board);
end;

(* 項目削除 *)
procedure TBoardList.Delete(index: integer);
begin
  Close(Items[index]);
  inherited Delete(index);
end;

initialization
  RecycleList := TList.Create;
finalization
  RecycleList.Free;
end.
