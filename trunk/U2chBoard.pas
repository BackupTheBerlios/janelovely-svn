unit U2chBoard;
(* 2ちゃんねる　ボード（スレッド一覧）情報 *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.57, 2004/09/24 14:42:31 *)

interface

uses
  Classes, SysUtils, StrUtils, DateUtils,
  U2chThread, FileSub, StrSub
  (*※[457]*), UFavorite, IniFiles,
  UXTime, UAsync, U2chTicket, ULocalCopy, jconvert,Dialogs,
  {$IFDEF SQLITE3}
  sqlite3,
  {$ELSE}
  sqlite,
  {$ENDIF}
  UNGWordsAssistant;

type
  TPatrolType = (patFavorite, patTab, patBoardList);
  TProgState = (tpsNone, tpsProgress, tpsReady, tpsWorking, tpsDone);
  (*-------------------------------------------------------*)
  TBBSType = (bbsNone, bbs2ch, bbsJBBS, bbsShitaraba, bbsJBBSShitaraba, bbsMachi, bbsOther);
  (*-------------------------------------------------------*)
  (* 板 = スレ一覧 *)
  TBoard = class(TList)
  protected
    refCount: integer;
    subjectTxt: string;
    datModified : boolean;
    idxModified : boolean;
    bbstype: TBBSType;
    FHost: string;
    moved: boolean;
    FSelDatName: string;
    FCustomHeader: string;
    FUma: boolean;
    procGetSubject: TAsyncReq;   (* 通信用 (aiai) *) //テスト
    FavPatrolData: String;       (* 通信用 (aiai) *) //テスト
    FavPatrolType: TPatrolType;  (* 通信用 (aiai) *) //テスト
    (* Setting.txt処理用 *)
    storedSettingTxt: TLocalCopy;
    gotSettingTxt: TProgState;
    procGetSettingTxt: TAsyncReq;
    SettingTxtLoaded: Boolean;
    SettingTxt: TStringList;
    datList: THashedStringList; //aiai subject.txtにあるスレのdatのリスト
                                //     TBoard.FindFirstでTThreadの検索に使う
    //ngthreadlist: TStringList;  //aiai NGThread
    FNeedConvert: Boolean;  //aiai
    FHideHistoricalLog: Boolean;  //aiai
    function GetItems(index: integer): TThreadItem;
    procedure SetItems(index: integer; value: TThreadItem);
    procedure MergeCache;
    function FindThreadFirst(const datName: string): TThreadItem; //aiai
    (* DataBase (aiai) *)
    procedure LoadDataBase;
    procedure MergeCacheFast;
    (* //DataBase *)
    procedure ChangeThreadItemURI;
    procedure SetSelDatName(const datName: string);
    procedure SetCustomHeader(const str: string);
    procedure SetUma(val: boolean);
    procedure SetHost(newHost: string); virtual;
    procedure OnDone(Sender: TAsyncReq);           (* 通信用 (aiai) *) //テスト
    procedure OnMovedSubject(sender: TAsyncReq);   (* 通信用 (aiai) *) //テスト
    procedure GetSettingTxt;
    procedure OnSettingTxt(sender: TAsyncReq);
    class procedure PutToRecyleList(Board: TBoard);
    class function  RemoveFromRecyleList(Board: TBoard): Boolean;
    class procedure FlushRecyleList;
  public
    redirect: TBoard;       (* 「おすすめ」とかの重複用。しかし未使用  *)
    category: TObject;      (* 本当はTCategoryだ。環境上、メンドイのでキャストして使う  *)
    name: string;           (* 板名 *)
    bbs:  string;
    lastModified: string;
    last2Modified: string; //beginner
    //previouslastModified: integer; //aiai
    past: Boolean;          (* 過去ログボード *)
    lastAccess: TDateTime;
    sortColumn: integer;    (* スレ一覧でのソート状態 *)
    threadSearched: Boolean; (* スレ一覧でのスレ絞込み状態 *)
    timeValue: Int64;       (* サーバ時間 bbs.cgiへのPOST時に使用 *)
    BBSLineNumuber: Integer;
    BBSMessageCount: Integer;
    BBSSubjectCount: Integer;
    BBSNameCount: Integer;
    BBSMailCount: Integer;
    (* DataBase (aiai) *)
    board_id: String;
    MergingList: TList;
    URIBase: String;
    IdxDataBase: TSQLite;
    (* //DataBase *)
    constructor Create(category: TObject);
    destructor Destroy; override;
    procedure Clear; override;
    procedure SafeClear; virtual;
    procedure AddRef; virtual;
    procedure Release; virtual;
    procedure Analyze((*const*) txt: string; const lstModified: string; refresh: boolean);
    property Items[index: integer]: TThreadItem read GetItems write SetItems;
    function Find(const datName: string): TThreadItem; overload;
    function GetLogDir: string;
    function GetURIBase: string;
    function Refered: boolean;
    function GetBBSType: TBBSType;
    procedure LoadIndex; virtual;
    procedure LoadSettingTXT;
    (* DataBase (aiai) *)
    //procedure Load; virtual;
    procedure Load(refresh: Boolean = False); virtual;
    (* //DataBase *)
    procedure SaveIndex; virtual;
    procedure Save; virtual;
    procedure Activate;
    procedure ResetListState; virtual; (* 仮想メソッドにする (aiai) *)
    //改造▽ 追加 (スレッドあぼ～ん)
    function ThreadAbone(ABoneList: TList): boolean; (* スレッドあぼ～ん *)
    //改造△ 追加 (スレッドあぼ～ん)
    (* Drag and Drop でログ追加 (aiai) *)
    procedure MergeCacheFrequency(fnamelist: TStringList);
    (* //Drag and Drop でログ追加 *)
    procedure StartAsyncRead(Data: String; PatrolType: TPatrolType);   (* 通信用 (aiai) *) //テスト
    property selDatName: string read FSelDatName write SetSelDatName;
    property customHeader: string read FCustomHeader write SetCustomHeader;
    property subjectText: string read subjectTxt;
    property uma: boolean read FUma write SetUma;
    property host: string read FHost write SetHost;
    property settingText: TStringList read settingTXT write settingTXT;
    property NeedConvert: Boolean read FNeedConvert; //aiai
    property HideHistoricalLog: Boolean read FHideHistoricalLog write FHideHistoricalLog;  //aiai
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
    //favs: TFavoriteList; // publicへ移動 更新チェック
    favChanged: boolean;
  public
    favs: TFavoriteList; // protectedから移動 更新チェック
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

(*=======================================================*)
implementation
(*=======================================================*)

uses
  U2chCat, Main, JLWritePanel;

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
  (* //DataBase *)

(*=======================================================*)

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
  self.redirect := nil;
  self.category := category;
  self.refCount := 0;
  self.FUma := false;
  datModified := false;
  idxModified := false;
  past := false;
  lastAccess := 0;
  bbstype := bbsNone;
  moved := false;
  //ngthreadlist := TStringList.Create;  //aiai NGThread
  SettingTxt := TStringList.Create;
  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
    IdxDataBase := TSQLite.Create;
  (* //DataBase *)
  SettingTxtLoaded := Config.stlHideHistoricalLog;
end;

(* 破棄 *)
destructor TBoard.Destroy;
begin
  Save;
  Clear;
  FreeAndNil(SettingTxt);
  //FreeAndNil(ngthreadlist);  //aiai NGThread
  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
    FreeAndNil(IdxDataBase);
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
begin
  {$IFDEF BENCH}
  {$IFDEF DEVELBENCH}
  Main.Bench3(0);
  {$ENDIF}
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
    self.subjectTxt := '';
    self.lastModified := '';
    self.datModified := false;
    self.idxModified := false;
    //改造▽ 追加 (スレッドあぼ～ん)
    //self.abnModified := false;
    //改造△ 追加 (スレッドあぼ～ん)
  end;
  RemoveFromRecyleList(Self);
  {$IFDEF BENCH}
  {$IFDEF DEVELBENCH}
  Main.Log(name + ':safeClear ' + Main.Bench3(1));
  {$ENDIF}
  {$ENDIF}
end;


(* 参照増加 *)
procedure TBoard.AddRef;
begin
  if (refCount = 0) and not(RemoveFromRecyleList(Self)) then
    Load;
  Inc(refCount);
end;

(* もう見ない *)
procedure TBoard.Release;
begin
  Dec(refCount);
  if refCount <= 0 then
    PutToRecyleList(Self);
end;

(* 参照中？ *)
function TBoard.Refered: boolean;
begin
  if 0 < refCount then
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
procedure TBoard.Analyze((*const*) txt: string; const lstModified: string; refresh: boolean);
var
  refered: TStringList;  //aiai GetReferedThreadItemの効率化
  //改造▽ 追加 (スレッドあぼ～ん)
  threadABoneList: THashedStringList;
  threadABoneCount: integer;  //スレッドあぼ～んカウンタ
  threadABoneNext: THashedStringList; //ヒットしたスレを加える
  //改造△ 追加 (スレッドあぼ～ん)

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
  begin
    (* dat-name delimiter subject space (num) *)
    (* dat *)
    refPos := i;
    refEnd := findDelimiter(i, endOfRec);
    if (refEnd <= 0) then
      exit;
    datName := ChangeFileExt(Copy(txt, refPos, refEnd - refPos), '');
    //改造▽ 追加 (スレッドあぼ～ん)
    idx := threadABoneList.IndexOfName(datName);
    if idx >= 0 then
    begin
      threadABoneNext.Add(threadABoneList.Strings[idx]); //ヒットしたスレを加える
      //threadABoneList.Delete(idx);  //ヒットしたスレはリストから削除
      Inc(threadABoneCount);  //スレッドあぼ～んカウンタをインクリメント
      Exit;
    end;
    //改造△ 追加 (スレッドあぼ～ん)
    (* subject *)
    refPos := topOfSubject(refEnd);
    refEnd := endOfSubject(refPos, endOfRec);
    subject := Copy(txt, refPos, refEnd - refPos);
    {aiai} //NGThread
    for idx := 0 to Main.NGThreadItems.Count - 1 do
    begin
      if 0 < AnsiPos(Main.NGThreadItems.Strings[idx], subject) then
      begin
        Inc(threadABoneCount);  //スレッドあぼ～んカウンタをインクリメント
       exit;
      end;
    end;
    {/aiai}
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
    item.previousitemCount := item.itemCount;    //aiai
    item.itemCount := num;
    //item.contemporary := true;
    Add(item);
    {aiai}
    if refresh then
      datList.Add(datName);
    {/aiai}
    //改造▽ 修正 (スレッドあぼ～ん)
    item.number := Count  + threadABoneCount; //スレッドあぼ～んの分のカウントを加算する
    //オリジナル
    //item.number := Count;
    //改造△ 修正 (スレッドあぼ～ん)
  end;

var
  i, len: integer;
  endOfRec: integer;
  firstline: string;
begin
  {$IFDEF BENCH}
  Main.Bench2(0);
  {$IFDEF DEVELBENCH}
  Main.Bench3(0);
  {$ENDIF}
  {$ENDIF}

  //改造▽ 追加 (スレッドあぼ～ん)
  threadABoneCount := 0;  //スレッドあぼ～んカウンタの初期化
  //改造△ 追加 (スレッドあぼ～ん)
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

  if FileExists(GetLogDir + SUBJECT_ABN) then
    threadABoneList.LoadFromFile(GetLogDir + SUBJECT_ABN);

  if refresh then
    datList := THashedStringList.Create;
  //if FileExists(GetLogDir + '\NGThread.txt') then  //NGThread
  //  ngthreadlist.LoadFromFile(GetLogDir + '\NGThread.txt');
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

  {aiai}
  //ngthreadlist.Clear;  //NGThread
  {aiai} //スレッドあぼ～ん
  if threadABoneNext.Count > 0 then
    threadABoneNext.SaveToFile(GetLogDir + SUBJECT_ABN)
  else
    SysUtils.DeleteFile(GetLogDir + SUBJECT_ABN);
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
        datList.Add(refered.Strings[i]);
      {/aiai}
    end;
  end;
  refered.Free;
  {$IFDEF BENCH}
  {$IFDEF DEVELBENCH}
  Main.Log(name + ':Analyze subject.txt ' + Main.Bench3(1));
  {$ENDIF}
  {$ENDIF}

  if refresh then
  begin
    if Config.ojvQuickMerge then
      MergeCacheFast
    else
      MergeCache;
    FreeAndNil(datList);
  end;
  if moved then
    ChangeThreadItemURI;
  self.subjectTxt := txt;
  if lstModified <> '' then begin
    self.lastModified := lstModified;
  end;
  self.datModified := true;
  self.idxModified := true;
  {$IFDEF BENCH}
  Main.Log('スレ一覧取得時間: ' + IntToStr(Bench2(1)) + 'msec');
  {$ENDIF}
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
  i := datList.IndexOf(datName);
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
  //idx: integer;
begin
  {$IFDEF BENCH}
  {$IFDEF DEVELBENCH}
  Main.Bench3(0);
  Main.Log(self.name + ':idx全ｽﾚ読込開始');
  {$ENDIF}
  {$ENDIF}

  MergingList := TList.Create;
  path := self.GetLogDir + '\*.dat';

  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin
    IdxDataBase.Exec(PChar('BEGIN'), nil, nil, msg); //トランザクション
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':BEGIN - ' + msg);
    {$ENDIF}
  end;
  (* //DataBase *)

  if FindFirst(path, faArchive, sr) = 0 then begin
    URI := GetURIBase;
    repeat
      datName := ChangeFileExt(sr.Name, '');
      //item := Find(datName);
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
            IdxDataBase.Exec(PChar('COMMIT'), nil, nil, msg);   //コミット
            {$IFDEF DATABASEDEBUG}
            if msg <> nil then Main.Log(name + ':COMMIT - ' + msg);
            {$ENDIF}
          end;
          (* //Database *)

          item.RemoveLog;
          item.Free;

          (* DataBase (aiai) *)
          if Config.ojvQuickMerge then
          begin
            IdxDataBase.Exec(PChar('BEGIN'), nil, nil, msg); //トランザクション
            {$IFDEF DATABASEDEBUG}
            if msg <> nil then Main.Log(name + ':BEGIN - ' + msg);
            {$ENDIF}
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
    IdxDataBase.Exec(PChar('COMMIT'), nil, nil, msg);   //コミット
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':COMMIT - ' + msg);
    {$ENDIF}
  end;
  (* //DataBase *)
  {$IFDEF BENCH}
  {$IFDEF DEVELBENCH}
  if Config.ojvQuickMerge then
    Main.Log(name + ':CreateTable ' + Main.Bench3(1))
  else
    Main.Log(name + ':Load *.idx' + Main.Bench3(1));
  {$ENDIF}
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
  //idx: integer;
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
      if (item.URI <> URIBase) and ((item.state <> tsComplete) and (item.itemCount > 0)) then
      begin
        item.URI := URI;
        item.state := tsCurrency;
        item.SaveIndexData;
      end;
    end
    else begin
      item := TThreadItem.Create(Sender);
      item.datName := datName;
      {スレッドあぼ～ん}
      //idx := threadABoneList.IndexOfName(datName);
      //if idx >= 0 then
      //begin
      //  item.RemoveLog;
      //  item.Free;
      //  result := 0;
      //  exit;
      //end;
      {/スレッドあぼ～ん}
      item.LoadIndexDataFromDataBase(Value, true);
      if (Main.Config.datDeleteOutOfTime) and (not FUma) and
           (item.mark = timNONE) then
      begin
        item.RemoveLog;
        item.Free;
      end
      else
        MergingList.Add(item);
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
  TSQLite(Sender).ResultText := Value^;
  Result := 0;
end;

procedure TBoard.MergeCacheFast;
var
  msg: PChar;
begin
  {$IFDEF BENCH}
  {$IFDEF DEVELBENCH}
  Main.Bench3(0);
  {$ENDIF}
  {$ENDIF}

  IdxDataBase.ResultText := '';
  IdxDataBase.Exec(PChar('SELECT version FROM tableversion WHERE tablename = ''idxlist'''), @CallBackCheckTableVersion, IdxDataBase, msg);
  {$IFDEF DATABASEDEBUG}
  if msg <> nil then Main.Log(name + ':DataBase - ' + msg);
  {$ENDIF}
  if IdxDataBase.ResultText <> IDXLIST_VERSION then
  begin
    IdxDataBase.Exec(PChar('DROP TABLE idxlist'), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':DROP TABLE idxlist - ' + msg);
    {$ENDIF}
    IdxDataBase.Exec(PChar('DELETE FROM tableversion WHERE tablename = ''idxlist'''), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':DELETE FROM tableversion WHERE tablename = ''idxlist'' - ' + msg);
    {$ENDIF}
    IdxDataBase.Exec(PChar('CREATE TABLE idxlist (datname TEXT PRIMARY KEY, title TEXT, last_modified TEXT, lines TEXT, view_pos TEXT, idx_mark TEXT, uri TEXT, state TEXT, new_lines TEXT, write_name TEXT, write_mail TEXT, last_wrote TEXT, last_got TEXT, read_pos TEXT)'), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':CREATE TABLE idxlist - ' + msg);
    {$ENDIF}
    IdxDataBase.Exec(PChar('INSERT INTO tableversion (tablename, version) VALUES (''idxlist'', '''+IDXLIST_VERSION+''')'), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':INSERT INTO tableversion (tablename, version) VALUES (''idxlist'', '''+IDXLIST_VERSION+''') - ' + msg);
    {$ENDIF}
    //IdxDataBase.Exec(PChar('CREATE INDEX idx_idxlist ON idxlist (datname)'), nil, nil, msg);
    MergeCache;
    exit;
  end;

  MergingList := TList.Create;

  URIBase := GetURIBase;

  if (0 <> IdxDataBase.Exec(PChar('SELECT * FROM idxlist'), @LoadTable, Self, msg))
      and (0 < Pos('no such table', msg)) then
  begin
    MergingList.Free;
    IdxDataBase.Exec(PChar('CREATE TABLE idxlist (datname TEXT PRIMARY KEY, title TEXT, last_modified TEXT, lines TEXT, view_pos TEXT, idx_mark TEXT, uri TEXT, state TEXT, new_lines TEXT, write_name TEXT, write_mail TEXT, last_wrote TEXT, last_got TEXT, read_pos TEXT)'), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':CREATE TABLE idxlist - ' + msg);
    {$ENDIF}
    MergeCache;
    exit;
  end;
  {$IFDEF DATABASEDEBUG}
  if msg <> nil then Main.Log(name + ':SELECT * FROM idxlist - ' + msg);
  {$ENDIF}

  Assign(MergingList, laOr);

  MergingList.Free;
  {$IFDEF BENCH}
  {$IFDEF DEVELBENCH}
  Main.Log(name + ':LoadTable ' + Main.Bench3(1));
  {$ENDIF}
  {$ENDIF}
end;

(* //DataBase *)

function TBoard.GetLogDir: string;
begin
  if assigned(redirect) then
    result := redirect.GetLogDir
  else
    result := TCategory(category).GetLogDir + '\' + Convert2FName(name);
end;

function TBoard.GetURIBase:string;
begin
  result := 'http://' + FHost + '/' + bbs;
end;

(* DataBase (aiai) *)
procedure TBoard.LoadDataBase;
var
  db: String;
  msg: PChar;
  err: Boolean;

  procedure FirstSetUp;
  begin
    IdxDataBase.Exec(PChar('PRAGMA default_synchronous = OFF'), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':PRAGMA default_synchronous = OFF - ' + msg);
    {$ENDIF}
    IdxDataBase.Exec(PChar('CREATE TABLE tableversion (tablename PRIMARY KEY, version)'), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':CREATE TABLE tableversion (tablename PRIMARY KEY, version) - ' + msg);
    {$ENDIF}
    IdxDataBase.Exec(PChar('INSERT INTO tableversion (tablename, version) VALUES (''board_db'', '''+BOARD_VERSION+''')'), nil, nil, msg);
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':INSERT INTO tableversion (tablename, version) VALUES (''board_db'', '''+BOARD_VERSION+''') - ' + msg);
    {$ENDIF}
    //IdxDataBase.Exec(PChar('INSERT INTO tableversion (tablename, version) VALUES (''idxlist'', '''+IDXLIST_VERSION+''')'), nil, nil, msg);
  end;

begin
  if IdxDataBase.Opened then
    exit;

  db := GetLogDir + BOARD_DB;
  if not FileExists(db) then
  begin
    RecursiveCreateDir(GetLogDir);  //板のログフォルダの作成
    {$IFDEF DATABASEDEBUG}
    err := IdxDataBase.Open(PChar(db), 0, msg);
    if err then
      Main.Log(name + ':DataBase Open');
    {$ELSE}
    IdxDataBase.Open(PChar(db), 0, msg);
    {$ENDIF}
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':Open' + ' ' + db + ' - ' + msg);
    {$ENDIF}
    FirstSetUp;
    exit;
  end;

  err := IdxDataBase.Open(PChar(db), 0, msg);
  if not err then
  begin
    {$IFDEF DATABASEDEBUG}
    Main.Log(name +':Cannot Open DataBase');
    {$ENDIF}
    if not SysUtils.DeleteFile(db) then
    begin
      ShowMessage('Unable Delete '+db);
      MainWnd.Close;
      exit;
    end else
      Main.Log(name + ':Delete ' + db);

    {$IFDEF DATABASEDEBUG}
    err := IdxDataBase.Open(PChar(db), 0, msg);
    if err then
      Main.Log(name + ':DataBase Open');
    {$ELSE}
    IdxDataBase.Open(PChar(db), 0, msg);
    {$ENDIF}
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':Open' + ' ' + db + ' - ' + msg);
    {$ENDIF}
    FirstSetUp;
    exit;
  {$IFDEF DATABASEDEGUB}
  end else
    Main.Log(name + ':DataBase Open');
  {$ELSE}
  end;
  {$ENDIF}

  IdxDataBase.ResultText := '';
  IdxDataBase.Exec(PChar('SELECT version FROM tableversion WHERE tablename = ''board_db'''), @CallBackCheckTableVersion, IdxDataBase, msg);
  {$IFDEF DATABASEDEBUG}
  if msg <> nil then Main.Log(name + ':SELECT version FROM tableversion - ' + msg);
  {$ENDIF}
  if IdxDataBase.ResultText <> BOARD_VERSION then
  begin
    Main.Log(name + ':DataBase Version Change ' + IdxDataBase.ResultText + ' -> ' + BOARD_VERSION);
    if IdxDataBase.Close then
      Main.Log(name +':DataBase Close');
    if not SysUtils.DeleteFile(db) then
    begin
      ShowMessage('Unable Delete '+db);
      MainWnd.Close;
      exit;
    end else
      Main.Log(name +':Delete ' + db);
    {$IFDEF DATABASEDEBUG}
    err := IdxDataBase.Open(PChar(db), 0, msg);
    if err then
      Main.Log(name + ':DataBase Open');
    {$ELSE}
    IdxDataBase.Open(PChar(db), 0, msg);
    {$ENDIF}
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':Open' + ' ' + db + ' - ' + msg);
    {$ENDIF}
    FirstSetUp;
  end;
end;
(* //DataBase *)

procedure TBoard.LoadIndex;
var
  fname: string;
  strList: TStringList;
begin
  fname := GetLogDir + SUBJECT_IDX;
  strList := TStringList.Create;
  lastModified := '';
  selDatName := '';
  FUma := false;
  if FileExists(fname) then
  begin
    try
      strList.LoadFromFile(fname);
      lastModified  := strList.Strings[IDX_MODIFIED];
      selDatName   := strList.Strings[IDX_SELECTED];
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
  fname: string;
  txt, modified: string;
begin
  fname := GetLogDir + SUBJECT_TXT;
  subjectTxt := '';
  if FileExists(fname) then
  begin
    stream := TPSStream.Create('');
    try
      stream.LoadFromFile(fname);
      Txt := stream.DataString;
    except
    end;
    stream.Free;
  end;

  LoadIndex;
  
  //LoadSettingTXT;
  (* DataBase *)
  if Config.ojvQuickMerge then
    LoadDataBase
  else
    SysUtils.DeleteFile(GetLogDir + BOARD_DB);
  (* //DataBase *)
  {/aiai}

  modified := lastModified;

  Analyze(Txt, modified, (refcount <= 0) or refresh);
  datModified := false;
  idxModified := false;
end;


procedure TBoard.SaveIndex;
var
  strList: TStringList;
begin
  if idxModified then
  begin
    RecursiveCreateDir(GetLogDir);
    strList := TStringList.Create;
    strList.Add(self.name);
    strList.Add(self.lastModified);
    strList.Add(self.selDatName);
    strList.Add(self.FCustomHeader);
    strList.Add(IntToStr(Integer(self.FUma)));
    try
      strList.SaveToFile(GetLogDir + SUBJECT_IDX);
    except
    end;
    strList.Free;
    idxModified := false;
  end;
end;

(* スレ一覧を保存する *)
procedure TBoard.Save;
var
  stream: TPSStream;
begin
  if datModified then
  begin
    RecursiveCreateDir(GetLogDir);
    stream := TPSStream.Create(subjectTxt);
    try
      stream.SaveToFile(GetLogDir + SUBJECT_TXT);
    except
    end;
    stream.Free;
    datModified := false;
  end;
  SaveIndex;
end;

(*  *)
procedure TBoard.Activate;
begin
  if length(subjectTxt) <= 0 then
    Load;
end;

procedure TBoard.SetSelDatName(const datName: string);
begin
  FSelDatName := datName;
  idxModified := true;
end;

procedure TBoard.SetCustomHeader(const str: string);
begin
  FCustomHeader := str;
  idxModified := true;
end;

procedure TBoard.SetUma(val: boolean);
begin
  FUma := val;
  idxModified := true;
end;

function TBoard.GetBBSType: TBBSType;
var
  i: integer;
begin
  if bbstype = bbsNone then
  begin
    for i := 0 to Config.bbs2chServers.Count -1 do
    begin
      if AnsiEndsStr(Config.bbs2chServers[i], FHost) then
      begin
        bbstype := bbs2ch;
        result := bbs2ch;
        exit;
      end;
    end;
    for i := 0 to Config.bbsMachiServers.Count -1 do
    begin
      if AnsiEndsStr(Config.bbsMachiServers[i], FHost) then
      begin
        bbstype := bbsMachi;
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
        bbstype := bbsJBBSShitaraba;
        result := bbsJBBSShitaraba;
        exit;
      end;
    end;
    if AnsiStartsStr('www.jbbs.net', FHost)
            or AnsiStartsStr('green.jbbs.net', FHost) then
    //▲ Nightly Fri Sep 24 14:42:31 2004 UTC by lxc
      bbstype := bbsJBBS
    else if AnsiStartsStr('www.shitaraba.com', FHost) then
      bbstype := bbsShitaraba
    else
      bbstype := bbsOther
  end;
  result := bbstype;
end;

(* スレ一覧での状態をリセット *)
procedure TBoard.ResetListState;
var
  i: integer;
begin
  if not Config.oprSelPreviousThread then //最後に見てた位置へジャンプしなければクリア
    selDatName := '';
  (* 板のソート (aiai) *)
  sortColumn := Config.stlDefSortColumn;

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
    moved := true;  //AnalyzeからChangeThreadItemURIを呼び出す
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
  moved := false;
end;

//改造▽ 追加 (スレッドあぼ～ん)
(* スレッドあぼ～ん *)
function TBoard.ThreadAbone(ABoneList: TList): boolean;
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
    //if threadABoneList.IndexOfName(thread.datName) >= 0 then
    //  Continue;

    //あぼ～んリストに加える
    threadABoneList.Add(thread.datName + '=' + thread.title);

    //スレッドを削除
    thread.Free;

    //板から削除
    Self.Delete(intIndex);

    Result := True;
    
  end;

  //subject.abnをsave、あぼ～んリストが空ならsubject.abnを削除
  if threadABoneList.Count > 0 then
    threadABoneList.SaveToFile(GetLogDir + SUBJECT_ABN)
  else
    SysUtils.DeleteFile(GetLogDir + SUBJECT_ABN);

  threadABoneList.Free;
end;
//改造△ 追加 (スレッドあぼ～ん)

(* 通信用 (aiai) *) //テスト
procedure TBoard.StartAsyncRead(Data: String; PatrolType: TPatrolType);
var
  URI: string;
begin
  if Past then
    URI := 'http://' + FHost + '/' + bbs + '/' + 'subkako.txt.gz'
  else
    URI := 'http://' + FHost + '/' + bbs + '/' + 'subject.txt';

  FavPatrolType := PatrolType;
  FavPatrolData := Data;

  procGetSubject := AsyncManager.Get(URI, OnDone, ticket2ch.On2chPreConnect,
                                     lastModified);
end;

procedure TBoard.OnDone(Sender: TASyncReq);
  procedure HomeMovedBoard;
  begin
    if usetrace[16] then
      Log(traceString[16])
    else
      Log('川*’∀’）ｲﾃﾝﾂｲﾋ');
    LogBeginQuery;
    procGetSubject := AsyncManager.Get(
      copy(sender.URI, 1, LastDelimiter('/', sender.URI)), OnMovedSubject,
      ticket2ch.On2chPreConnect, '');
  end;

  procedure GotSuccessfully(const content: string);
  begin
    Analyze(content, sender.GetLastModified, false);
    Save;
    if timeValue <= 0 then
      timeValue := DateTimeToUnix(Str2DateTime(sender.GetDate));
    MainWnd.FavPtrlManager(-1, FavPatrolType, Self);
    LogDone;
  end;

var
  content, s: string;
  i: integer;
begin
  if sender <> procGetSubject then
    exit;
  lastAccess := Now;
  procGetSubject := nil;

  Main.Log('(' + FavPatrolData + ') 【' + Self.name + '】'
                         + sender.IdHTTP.ResponseText);

  case sender.IdHTTP.ResponseCode of

  200: (* 200 OK *)
    begin
      if (sender.Content = '') and Config.optHomeIfSubjectIsEmpty then
      begin
        HomeMovedBoard;
        Exit;
      end;
      last2Modified := lastModified;
      case GetBBSType of
      bbsJBBSShitaraba, bbsShitaraba:
        content := euc2sjis(sender.Content);
      else
        if FNeedConvert then
          content := euc2sjis(sender.Content)
        else
          content := sender.Content;
      end;
      if AnsiStartsStr('+', content) or
         AnsiStartsStr('-', content) then
      begin
        i := Pos(#10, content);
        if 0 < i then
        begin
          s := AnsiReplaceStr(Copy(content, 1, i - 1), #13, '');
          //Log('( @_@) □ ﾅﾆﾅﾆ･･･  ' + s);   //aiai
          if usetrace[15] then Log(traceString[15] + s)
          else Log('( @_@) □ ﾅﾆﾅﾆ･･･  ' + s);
          content := Copy(content, i + 1, high(integer));
          if s[1] = '+' then
            GotSuccessfully(content);
        end;
      end
      else
        GotSuccessfully(content);
      exit;
    end;

  302: (* 302 Found *)
    begin
      HomeMovedBoard;
      exit;
    end;

  304: (* 304 Not Modified *)
    begin
      last2Modified := lastModified;
      if usetrace[17] then
        Log(traceString[17])
      else
        Log('川 ’ー’川新着ﾅｼ');
      //MainWnd.FavPtrlManager(-1, FavPatrolType, Self);
      //Self.Release;
      MainWnd.FavPtrlManager(-1, FavPatrolType, nil);
      WriteStatus('新着なし');
      exit;
    end;

  else
    begin
      //Release;
      MainWnd.FavPtrlManager(-1, FavPatrolType, Self);
    end;

  end; //case
end;

procedure TBoard.OnMovedSubject(Sender: TASyncReq);
var
  URI, host2, bbs2: string;
  startpos, endpos: Integer;
label FAILED;
begin
  LogEndQuery2;

  if sender <> procGetSubject then
    exit;

  procGetSubject := nil;
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
      if useTrace[12] then
        Log(traceString[12])
      else
        Log('川*’∀’）ﾀﾌﾞﾝｾｲｺｳ');
      if usetrace[13] then
        Log(traceString[13])
      else
        Log('川*’∀’）ｱﾄﾃﾞﾓｳｲﾁﾄﾞｺｳｼﾝｼﾃﾐﾙｶﾞｼ');
      WriteStatus('板移転検出');
      Self.lastAccess := 0;
    end;
  else
    FAILED:
      if usetrace[14] then
        Log(traceString[14])
      else
        Log('ﾂｲﾋﾞｼｯﾊﾟｲ川 - 。- 川');

  end;
  Self.Release;
  MainWnd.FavPtrlManager(-1, FavPatrolType, Self);
end;


//SETTING.TXT処理

procedure TBoard.LoadSettingTXT;
var
  NeedSETTINGTXT: Boolean;
begin
  if SettingTxtLoaded then exit;

  {$IFDEF DEBUG2}
  Main.Log(self.name + ':SETTING.TXT読込');
  {$ENDIF}

  SettingTxtLoaded := True;
  procGetSettingTxt := nil;
  gotSettingTxt := tpsNone;
  FreeAndNil(storedSettingTxt);
  NeedSETTINGTXT := False;
  BBSLineNumuber := 0;
  BBSMessageCount := 0;
  BBSSubjectCount := High(Integer);
  BBSNameCount := High(Integer);
  BBSMailCount := High(Integer);
  SettingTxt.Clear;
  try
    storedSettingTxt := TLocalCopy.Create(GetLogDir + '\setting.txt', '.idb');
    if storedSettingTxt.Load then
    begin
      SettingTxt.Text := storedSettingTxt.DataString;
      BBSLineNumuber := StrToIntDef(SettingTxt.Values[BBS_LINE_NUMBER], 0);
      BBSMessageCount := StrToIntDef(SettingTxt.Values[BBS_MESSAGE_COUNT], 0);
      BBSSubjectCount := StrToIntDef(SettingTxt.Values[BBS_SUBJECT_COUNT], BBSSubjectCount);
      BBSNameCount := StrToIntDef(SettingTxt.Values[BBS_NAME_COUNT], BBSNameCount);
      BBSMailCount := StrToIntDef(SettingTxt.Values[BBS_MAIL_COUNT], BBSMailCount);
      if (storedSettingTxt.Info.Count = 0) or
         (storedSettingTxt.Info[0] <> GetURIBase + '/SETTING.TXT') then
        NeedSETTINGTXT := True;
      if storedSettingTxt.Updated + 30 < Now then
        NeedSETTINGTXT := True;
    end else
      NeedSETTINGTXT := True;
  finally
    FreeAndNil(storedSettingTxt);
  end;
  if (GetBBSType = bbs2ch) and NeedSETTINGTXT then
    GetSettingTxt;
end;

procedure TBoard.GetSettingTxt;
var
  URI: string;
  lastModified: string;
begin
  if gotSettingTxt <> tpsNone then
    exit;
  Main.Log('川*’ー’）' + name + 'ﾉSETTING.TXTｦ取ﾘﾆ行ｸﾖ');
  lastModified := '';
  if storedSettingTxt = nil then
  begin
    storedSettingTxt := TLocalCopy.Create(GetLogDir + '\setting.txt', '.idb');
    storedSettingTxt.Load;
    if 2 <= storedSettingTxt.Info.Count then
      lastModified := storedSettingTxt.Info.Strings[1];
  end;
  gotSettingTxt := tpsWorking;
  URI := GetURIBase + '/SETTING.TXT';
  procGetSettingTxt := AsyncManager.Get(URI, OnSettingTxt, ticket2ch.On2chPreConnect,
                              lastModified);
end;

procedure TBoard.OnSettingTxt(sender: TAsyncReq);
var
  lastModified: string;
begin
  if procGetSettingTxt = sender then
  begin
    Main.Log(name + ':SETTING.TXT:' + sender.IdHTTP.ResponseText);
    case sender.IdHTTP.ResponseCode of
      200: (* OK *)
        begin
          storedSettingTxt.Clear;
          if FNeedConvert then
            storedSettingTxt.WriteString(StringReplace(euc2sjis(sender.Content), #10, #13#10, [rfReplaceAll]))
          else
            storedSettingTxt.WriteString(StringReplace(sender.Content, #10, #13#10, [rfReplaceAll]));
          storedSettingTxt.Info.Add(GetURIBase + '/SETTING.TXT');
          storedSettingTxt.Info.Add(sender.GetLastModified);
          storedSettingTxt.Save;
          SettingTxt.Text := storedSettingTxt.DataString;
          BBSLineNumuber  := StrToIntDef(SettingTxt.Values[BBS_LINE_NUMBER], 0);
          BBSMessageCount := StrToIntDef(SettingTxt.Values[BBS_MESSAGE_COUNT], 0);
          BBSSubjectCount := StrToIntDef(SettingTxt.Values[BBS_SUBJECT_COUNT], High(Integer));
          BBSNameCount    := StrToIntDef(SettingTxt.Values[BBS_NAME_COUNT], High(Integer));
          BBSMailCount    := StrToIntDef(SettingTxt.Values[BBS_MAIL_COUNT], High(Integer));
          ChangeWriteMemoSettingText(Self);
        end;
      304: (* NotModifiedの時も再保存することで最終チェック時刻を更新 *)
        begin
          lastModified := '';
          if storedSettingTxt.Info.Count >= 2 then
            lastModified := storedSettingTxt.Info.Strings[1];
          storedSettingTxt.Info.Clear;
          storedSettingTxt.Info.Add(GetURIBase + '/SETTING.TXT');
          storedSettingTxt.Info.Add(lastModified);
          storedSettingTxt.Save;
          ChangeWriteMemoSettingText(Self);
         end;
    end;
    FreeAndNil(storedSettingTxt);
    procGetSettingTxt := nil;
    gotSettingTxt := tpsDone;
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
begin
  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin
    IdxDataBase.Exec(PChar('BEGIN'), nil, nil, msg); //トランザクション
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':BEGIN - ' + msg);
    {$ENDIF}
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
    IdxDataBase.Exec(PChar('COMMIT'), nil, nil, msg);   //コミット
    {$IFDEF DATABASEDEBUG}
    if msg <> nil then Main.Log(name + ':COMMIT - ' + msg);
    {$ENDIF}
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
  Dec(refCount);
  if refCount <= 0 then
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
    selDatName := '';
  sortColumn := Config.stlDefFuncSortColumn; //スレ一覧、お気に入り用ソート設定

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
    if (TFavoriteListBoard(objlist.Items[i]).refCount <= 0) and
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
