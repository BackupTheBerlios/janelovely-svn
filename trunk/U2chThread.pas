Unit U2chThread;
(* ２ちゃんねるスレッド *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.62, 2004/09/28 13:39:43 *)

interface

uses
  Classes, SysUtils, StrUtils, DateUtils, Windows,
  StrSub, FileSub, UAsync, USynchro, UXTime, UDat2HTML, U2chTicket, JConvert,
  IniFiles, MMSystem, JLSqlite;

const
  TThreAboneTypeMASK   = $07;
  TThreABNFLAG         = $08;

type
  (*-------------------------------------------------------*)
  TThreadItem = class;

  TThreadItemMark = (timNONE, timMARKER);
  TThreadItemNotify = procedure(sender: TThreadItem) of object; (* synchronized *)
  TThreadItemDone   = procedure(sender: TThreadItem) of object; (* synchronized *)

  TThreadReqResult = (trrSuccess, trrErrorProgress,
                      trrErrorTemporary, trrErrorTryLater, trrErrorPermanent);

  (*-------------------------------------------------------*)
  TAsyncObjHTMLState = (aosBeforeRes, aosInRes, aosAfterRes);
  (* HTTP参照時の為の情報: でかいから別にしてみた *)
  TThreadItemAsyncObj = class(TObject)
  public
    proc : TAsyncReq;           (* 非同期受信スレッド *)
    responseText : string;      (* HTTP応答のテキスト *)
    responseCode : integer;     (* HTTP応答コード *)
    lastModified : string;      (* 最終更新日時 *)
    rangeStr :     string;      (* 範囲 *)

    pumpCount: integer;         (* VCLスレッドでのポンプ数 *)

    OnNotify: TThreadItemNotify; (* 要求元通知 *)
    OnDone:   TThreadItemDone;   (* 要求元への通知 *)

    dataChunk: string;           (* 非同期受信チャンク *)
    synchro: THogeMutex;         (* 非同期受信チャンクの同期用 *)
    refCount: integer;           (*  *)
    notifyCount: integer;
    dropFirstLine: boolean;
    useCGI: boolean;             (*  *)
    discard: boolean;
    canceled: boolean;
    FForceReload: Boolean;

    htmlpositionstate: TAsyncObjHTMLState;

    FTimeStartDownload: TDateTime;
    constructor Create;
    destructor Destroy; override;
  end;

  (*-------------------------------------------------------*)
  TThreadState = (tsCurrency=0, tsHistory1=1, tsHistory2=2,
                  tsComplete=3,
                  tsTransition1=4, tsTransition2=5, tsTransition3=6);
  (*-------------------------------------------------------*)


  (*-------------------------------------------------------*)
  (* スレ *)
  TThreadItem = class(TObject)
  private
    refCount: integer;  (* 参照カウント *)
    logmoved: boolean;
  protected
    asyncObj: TThreadItemAsyncObj;    (* 受信用のレコード *)
    lastAccess: TDateTime;
    procedure OnAsyncNotifyProc(sender: TAsyncReq; code: TAsyncNotifyCode);
    procedure OnAsyncDoneProc(sender: TAsyncReq);
    procedure OnSynchroNotifyProc;
    procedure Activate;                (* 既読データを読む *)
    procedure Deactivate;              (* データを捨てる   *)
    function GetTransferedSize: Cardinal;
    function GetNeedConvert: Boolean;  //aiai
  public
    board: TObject;     (* これはTBoard型だ。文句はBoarlandに言ってくれ *)
    number: Integer;    (* 現行スレ(>0)か否か *)
    title: string;      (* = subject *)
    itemCount: integer; (* subject.txtに記述されてるレス数 *)
    previousitemCount: integer; (* スレ一覧を更新する前のitemCount *) //aiai
    datName: string;    (* datファイルの名前 *)
    dat: TThreadData;   (* datの中身 *)
    canclose: Boolean;  (* スレのタブを閉じるかどうか *) //aiai
    datbreak: Boolean;  //aiai

    (* index data *)
    lines: integer;         (* datの総行数 *)
    viewPos: integer;       (* 表示位置 *)
    lastModified: string;   (* datの最終更新日 *)
    mark: TThreadItemMark;  (* 印 *)
    URI: string;            (* URI *)
    state: TThreadState;    (* 所在みたいな *)
    UsedWriteName: string;      (* 記憶するコテハン *)//521
    UsedWriteMail: string;      (* 記憶するコテハン *)//521
    LastWrote: Int64;       (* 最終書込 UnixTime *)//521
    LastGot: Int64;         (* 最終取得 UnixTime *)//521
    readPos: integer;      (* ここまで読んだ *)//521

    idxModified: boolean;   (* indexデータの更新フラグ *)
    mayHaveInconsistency: boolean;
    oldLines: integer;      (* 既読行数 *)
    anchorLine: integer;    (* 新着レス番の最小値 *)
    queryState: TThreadState;

    //※[457]
    liststate: Integer;
    selectedaboneline: Integer;
    ABoneArray: TABoneArray;

    ThreAboneType: Byte;  //aiai (* $00: あぼ～んではない $01:通常 $02:透明 $04:重要 $08マスクはsubject.abnによるあぼ～ん*)

    constructor Create(board: TObject);
    destructor Destroy; override;

    procedure AddRef(load: boolean = true);   (* 参照カウントを増やす *)
    procedure Release;                 (* 参照カウントを減らす *)
    function Refered: boolean;         (* 参照されているか？   *)

    function GetFileName: string;
    procedure LoadIndexDataFromDataBase(ColumnValues: Pointer;
                                        loadTitle: boolean = true);//aiai
    function LoadIndexData(loadTitle: boolean = true): Boolean;
    procedure SaveIndexData;
    function LoadData: boolean;
    function SaveData: boolean;

    procedure InsertToTable;

    //※[457]
    function LoadAboneData: boolean;
    function SaveAboneData: boolean;

    procedure RemoveLog(deleteIdx: boolean = true);  (* 既読データファイルを消す *)
    procedure MoveLog; (* 再読み込み前にdatを退避させておく *)
    procedure SetViewPos(pos: integer); (* 表示位置を覚える *)

    function CalcLines: integer;        (* 件数計算 *)
    function GetSubject: string;        (* DATからSubject取得 *)

    function GetBoardName: string;
    function GetHost: string;
    function GetBBS: string;
    function GetURI: string;

    function StartAsyncRead(OnDone: TThreadItemDone;
                            OnNotify: TThreadItemNotify;
                            Reload: Boolean = False): TThreadReqResult;
    procedure StartQuery;
    procedure CancelAsyncRead;
    function Downloading: Boolean;
    procedure ChkConsistency;

    function DupData: TThreadData;
    function ToString(const body: string; startLine, lines: Integer): String;
    function ToURL(full: Boolean = true; last: Boolean = false; index: string = ''): string;

    property TransferedSize: Cardinal read GetTransferedSize;
    property NeedConvert: Boolean read GetNeedConvert; //aiai
  end;

  TRange = record
    st: Integer;
    ed: Integer;
  end;

  TRangeArray = array of TRange;

function SplitThreadURI(const URI: string; var host, bbs: string): integer;
procedure GetRangeFromText(range: string; var startIndex, endIndex: integer); overload;
procedure GetRangeFromText(range: string; var rangearray: TRangeArray); overload;
procedure Get2chInfo(const URI: string; var host, bbs, datnum: string;
                     var rangearray: TRangeArray; var oldLog: boolean); overload;
procedure Get2chInfo(const URI: string; var host, bbs, datnum: string;
                     var startIndex, endIndex: integer;
                     var oldLog: boolean); overload;
function ThreadIsNew(thread: TThreadItem): boolean;
function GetJBBSShitarabaCategory(URI: String): String;

(*=======================================================*)
implementation
(*=======================================================*)
{$B-} (* short circuit *)

uses
  U2chBoard, Main, UWriteForm;  //521-UWriteForm追加

const
  (* indexファイルの構造(行) *)
  IDX_TITLE    = 0; (* Subject of the thread *)
  IDX_MODIFIED = 1; (* Last-Modified: の値 *)
  IDX_LINES    = 2; (* スレ数 *)
  IDX_VIEWPOS  = 3; (* 最後に参照したスレ位置 *)
  IDX_MARK     = 4; (* 印 *)
  IDX_URI      = 5; (* URI  host/bbs *)
  IDX_STATE    = 6; (* TThreadState *)
  IDX_NEWLINES = 7; (* 未読スレ数 *)
  IDX_WRITENAME= 8; (* コテハン *) //521
  IDX_WRITEMAIL= 9; (* コテハン *) //521
  IDX_WROTE    = 10;(* 最終書込 *)
  IDX_GOT      = 11;(* 最終取得 *)
  IDX_READPOS = 12;(* ここまで読んだ *)

  EXT_DAT  = '.dat';
  EXT_IDX  = '.idx';
  EXT_ABONE= '.abn'; //※[457]
  EXT_BAKUP= '.bak';

  {aiai}
  MODIFIED_SOUND = 'new.wav';
  NOTMODIFIED_SOUND = 'no.wav';
  ERROR_SOUND = 'oth.wav';
  {/aiai}

  LIMIT_BYTES_PER_SEC = (64 div 8 * 1024);
 // THREAD_RELOAD_INTERVAL : integer = 5; (* seconds *)

function SplitThreadURI(const URI: string; var host, bbs: string): integer;
var
  tmpStr: TStringList;
  i: integer;
begin
  tmpStr := TStringList.Create;
  tmpStr.Delimiter := '/';
  tmpStr.DelimitedText := URI;
  host := '';
  if tmpStr[tmpStr.Count -1] ='' then
    tmpStr.Delete(tmpStr.Count -1);
  for i := 2 to tmpStr.Count -2 do
  begin
    if 0 < length(host) then
      host := host + '/';
    host := host + tmpStr.Strings[i];
  end;
  bbs := tmpStr.Strings[tmpStr.Count -1];
  result := tmpStr.Count;
  tmpStr.Free;
end;

procedure GetRangeFromText(range: string; var startIndex, endIndex: integer);
var
  rangearray: TRangeArray;
begin
  GetRangeFromText(range, rangearray);
  startIndex := rangearray[0].st;
  endIndex := rangearray[0].ed;
end;

procedure GetRangeFromText(range: string; var rangearray: TRangeArray);
var
  k: Integer;
  i: integer;
  st: TStringList;
begin
  SetLength(rangearray, 1);

  rangearray[0].st := -1;
  rangearray[0].ed := -1;

  if AnsiPos(' ', range) > 0 then
    exit;

  (* nを消す *)
  for i := length(range) downto 1 do
    if range[i] = 'n' then
      Delete(range, i, 1);

  st := TStringList.Create;
  st.Delimiter := '+';
  if (AnsiPos(',', range) <= 0) and (AnsiPos('+', range) > 0) then
    st.DelimitedText := range
  else
    st.CommaText := range;

  for k := 0 to st.Count -1 do begin
    SetLength(rangearray, k + 1);
    i := Pos('-', st[k]);
    if i > 0 then
    begin
      rangearray[k].st := StrToIntDef(LeftStr(st[k], i-1), -1);
      rangearray[k].ed := StrToIntDef(RightStr(st[k], length(st[k]) - i), -1);
    end else
    begin
      rangearray[k].st := StrToIntDef(st[k], -1);
      rangearray[k].ed := -1;
    end;
  end;
  st.Free;
end;

(* URIから2ch関連部抽出  *)
procedure Get2chInfo(const URI: string; var host, bbs, datnum: string;
                     var startIndex, endIndex: integer;
                     var oldLog: boolean);
var
  rangearray: TRangeArray;
begin
  Get2chInfo(URI, host, bbs, datnum, rangearray, oldLog);
  startIndex := rangearray[0].st;
  endIndex := rangearray[0].ed;
end;

procedure Get2chInfo(const URI: string; var host, bbs, datnum: string;
                     var rangearray: TRangeArray; var oldLog: boolean);
  function GetMulti(startPos, endPos: integer; strList: TStringList): string;
  var
    i: integer;
  begin
    result := '';
    for i := startPos to endPos do
    begin
      if 0 < length(result) then
        result := result + '/';
      result := result + strList.Strings[i];
    end;
  end;
var
  strList, tmp: TStringList;
  i: integer;
begin
  SetLength(rangearray, 1);
  host := '';
  bbs := '';
  datnum := '';
  rangearray[0].st := -1;
  rangearray[0].ed := -1;
  oldLog := false;
  strList := TStringList.Create;
  strList.Delimiter := '/';
  strList.DelimitedText := URI;

  (* sample format *)
  (* http://server.2ch.net/bbs/ *)
  (* http://server.2ch.net/test/read.cgi/bbs/?opt  *)
  (* http://server.2ch.net/test/read.cgi/bbs/dat/opt  *)
  (* http://server.2ch.net/bbs/dat/nnn.dat  *)
  (* http://server.2ch.net/bbs/kako/nnn/dat.html  *)
  (* http://server.2ch.net/bbs/kako/nnn/nnnn/dat.html  *)
  (* http://server.2ch.net/test/read.cgi?bbs=bbs&key=dat  *)
  (* http://server.2ch.net/sub/bbs/kako/nnn/dat.html  *)
  (* http://server.2ch.net/sub/test/read.cgi?bbs=bbs&key=dat  *)
  (* http://jbbs.livedoor.com/bbs/read.cgi/category/bbs/dat/ *)

  for i := 4 to strList.Count -1 do
  begin
    if strList.Strings[i] = 'kako' then
    begin
      oldLog := true;
      bbs := strList.Strings[i -1];
      host := GetMulti(2, i - 2, strList);
      datnum := ChangeFileExt(strList.Strings[strList.Count -1], '');
      break;
    end
    else if strList.Strings[i] = 'read.cgi' then
    begin
      (* JBBS@したらば新形式 *)
      if (strList.Strings[i-1] = 'bbs') and (i + 1 <= strList.Count -1) then
      begin
        host := GetMulti(2, i - 2, strList) + '/' + strList.Strings[i+1];
        if i + 2 <= strList.Count -1 then
        begin
          bbs := strList.Strings[i + 2];
          if (i + 3 <= strList.Count -1) and
             (not AnsiStartsStr('?', strList.Strings[i + 3])) then
          begin
            datnum := strList.Strings[i + 3];
            if (i + 4 <= strList.Count -1) then
              GetRangeFromText(strList.Strings[i+4], rangearray);
          end;
        end;
      end
      else begin
        host := GetMulti(2, i - 2, strList);
        if i + 1 <= strList.Count -1 then
        begin
          bbs := strList.Strings[i + 1];
          if (i + 2 <= strList.Count -1) and
             (not AnsiStartsStr('?', strList.Strings[i + 2])) then
          begin
            datnum := strList.Strings[i + 2];
            if (i + 3 <= strList.Count -1) then
              //startIndex := Str2Int(strList.Strings[i+3]);
              GetRangeFromText(strList.Strings[i+3], rangearray);
          end;
        end;
      end;
      break;
    end
    else if AnsiStartsStr('read.cgi?', strList.Strings[i]) or
            AnsiStartsStr('read.pl?', strList.Strings[i]) then
    begin
      host := GetMulti(2, i - 2, strList);
      tmp := TStringList.Create;
      tmp.Delimiter := '?';
      tmp.DelimitedText := strList.Strings[i];
      if 1 < tmp.Count then
      begin
        tmp.Delimiter := '&';
        tmp.DelimitedText := tmp.Strings[1];
        tmp.Delimiter := '=';
        bbs  := tmp.Values['bbs'];
        if length(bbs) <= 0 then
          bbs := tmp.Values['ampbbs'];
        datnum := tmp.Values['key'];
        if length(datnum) <= 0 then
          datnum := tmp.Values['ampkey'];
        if tmp.Count > 2 then
        begin
          rangearray[0].st := StrToIntDef(tmp.Values['st'], rangearray[0].st);
          if rangearray[0].st <= 0 then
            rangearray[0].st := StrToIntDef(tmp.Values['ampst'], rangearray[0].st);
          rangearray[0].st := StrToIntDef(tmp.Values['START'], rangearray[0].st);
          if rangearray[0].st <= 0 then
            rangearray[0].st := StrToIntDef(tmp.Values['ampSTART'], rangearray[0].st);
          rangearray[0].ed := StrToIntDef(tmp.Values['to'], rangearray[0].ed);
          if rangearray[0].ed <= 0 then
            rangearray[0].ed := StrToIntDef(tmp.Values['ampto'], rangearray[0].ed);
          rangearray[0].ed := StrToIntDef(tmp.Values['END'], rangearray[0].ed);
          if rangearray[0].ed <= 0 then
            rangearray[0].ed := StrToIntDef(tmp.Values['ampEND'], rangearray[0].ed);
        end;
      end;
      tmp.Free;
      break;
    end
    else if strList.Strings[i] = 'dat' then
    begin
      bbs := strList.Strings[i -1];
      host := GetMulti(2, i - 2, strList);
      datnum := ChangeFileExt(strList.Strings[strList.Count -1], '');
      break;
    end;
  end;
  if (length(host) <= 0) and (5 <= strList.Count) then
  begin
    bbs := strList.Strings[strList.Count -2];
    host := GetMulti(2, strList.Count -3, strList);
  end;
  strList.Free;
end;

function ThreadIsNew(thread: TThreadItem): boolean;
var
  board: TBoard;
begin
  board := TBoard(thread.board);
  result := (length(board.lastModified) <= 0) or
      (Str2DateTime(board.lastModified) <= UxTimeStr2DateTime(thread.datName));
end;

function GetJBBSShitarabaCategory(URI: String): String;
begin
  Result := copy(URI, AnsiPos('/', URI) + 1, High(Integer));
end;


(*=======================================================*)
constructor TThreadItemAsyncObj.Create;
begin
  inherited;
  synchro := THogeMutex.Create;
  refCount := 0;
  responseCode := -1;
  canceled := False;
end;

destructor TThreadItemAsyncObj.Destroy;
begin
  synchro.Free;
  inherited;
end;

(*=======================================================*)
(*  *)
constructor TThreadItem.Create(board: TObject);
begin
  inherited Create;
  self.board := board;
  number := 0; //false;
  itemCount := 0;
  dat := nil;
  lines := 0;
  oldLines := 0;
  anchorLine := 0;
  refCount := 0;
  idxModified := false;
  self.mark := timNONE;
  asyncObj := nil;
  state := tsCurrency;
  queryState := tsCurrency;
  lastAccess := 0;
  mayHaveInconsistency := False;
  liststate := 0; //※[457]
  AboneArray := TABoneArray.Create; //※[457]
  selectedaboneline := 0; //※[457]
  LastWrote := 0;
  LastGot := 0;
  logmoved := false;
  canclose := true;    //aiai
  datbreak := false;  //aiai
end;

(*  *)
destructor TThreadItem.Destroy;
begin
  if dat <> nil then
    dat.Free;
  if assigned(asyncObj) then
    asyncObj.Free;
  AboneArray.Free;
  inherited;
end;

(* 拡張子のないファイルの名前を返す *)
function TThreadItem.GetFileName: string;
begin
  result := TBoard(board).GetLogDir + '\' + datName;
end;

(* URLを返す *)
function TThreadItem.GetURI: string;
  function GetAddr4History(const Ext: string): string;
  begin
    if 9 < length(datName) then
    begin
      result := self.URI + '/kako/' + Copy(datName, 1, 4)
               + '/' + Copy(datName, 1, 5) + '/' + datName + Ext;
    end
    else begin
      result := self.URI + '/kako/' + Copy(datName, 1, 3) + '/' + datName + Ext;
    end;
  end;
var
  host, bbs: string;
  //i: integer;
begin
  if not AnsiStartsStr('http', self.URI) then
    self.URI := TBoard(board).GetURIBase;
  case TBoard(board).GetBBSType of
  bbsMachi:
    begin
      SplitThreadURI(self.URI, host, bbs);
      result := 'http://' + host + '/bbs/read.pl?BBS=' + bbs + '&KEY='
              + datName;
      //差分だけ読む
      if lines > 0 then
        result := result + '&START=' + IntToStr(lines+1) + '&NOFIRST=TRUE';
    end;
  bbsJBBSShitaraba:
    begin
      SplitThreadURI(self.URI, host, bbs);
      //▼ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      // したらばのURL対応を少し汎用的に
      result := 'http://' + Config.bbsJBBSServers[0] + '/bbs/rawmode.cgi/'
              + GetJBBSShitarabaCategory(host) + '/'
                      + bbs + '/'+ datName + '/';
      //▲ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      //差分だけ読む
      if lines > 0 then
        result := result + IntToStr(lines+1) + '-';
    end;
  bbsJBBS:
    begin
      SplitThreadURI(self.URI, host, bbs);
      result := 'http://' + host + '/bbs/read.cgi?BBS=' + bbs + '&KEY='
              + datName;
      //差分だけ読む
      if lines > 0 then
        result := result + '&START=' + IntToStr(lines+1) + '&NOFIRST=TRUE';
    end;
  else
    begin
      case self.queryState of
      tsCurrency:
        begin
          if asyncObj.useCGI then
          begin
            SplitThreadURI(self.URI, host, bbs);
            result := 'http://' + host + '/test/read.cgi/' + bbs + '/'
                    + datName + '/?raw=.' + IntToStr(dat.Size);
            {$IFDEF APPEND_SID}
            result := ticket2ch.AppendSID(result, '&');
            {$ENDIF}
          end
          else begin
            result := self.URI + '/dat/' + datName + EXT_DAT;
            {$IFDEF APPEND_SID}
            result := ticket2ch.AppendSID(result, '?');
            {$ENDIF}
          end;
        end;
      tsHistory1:
        begin
          (*  .dat.gz と.dat の両方をトライするケースは無いけど
           * .datじゃないと取れない鯖がある
           * けど、おおむね無駄なので旧鯖情報は別に持つことにしよう。
           *)
           (*
          if AnsiStartsStr('1', datName) and (TBoard(board).GetBBSType = bbs2ch) then
            queryState := tsHistory2;
          i := SplitThreadURI(self.URI, host, bbs);
          if (4 < i) and (TBoard(board).GetBBSType = bbs2ch) then
          begin
            queryState := tsHistory2;
            result := GetAddr4History('.dat');
          end
          else begin
            result := GetAddr4History('.dat.gz');
          end;
          *)
          // すべての鯖で .dat.gz -> .dat に変更
          result := GetAddr4History('.dat.gz');
          {$IFDEF APPEND_SID}
          result := ticket2ch.AppendSID(result, '?');
          {$ENDIF}
        end;
      tsHistory2:
        begin
          result := GetAddr4History('.dat');
          {$IFDEF APPEND_SID}
          result := ticket2ch.AppendSID(result, '?');
          {$ENDIF}
        end;
      tsTransition1, tsTransition3:
        begin
          SplitThreadURI(self.URI, host, bbs);
          result := 'http://' + host + '/test/offlaw.cgi/' + bbs + '/' + datName
                 + '/?raw=.' + IntToStr(dat.Size);
          result := ticket2ch.AppendSID(result, '&');
        end;
      else
        result := TBoard(board).GetURIBase + '/dat/' + datName + '.dat';
      end;
    end;
  end;
end;

(* 管理データをDataBaseから読む *) //aiai
procedure TThreadItem.LoadIndexDataFromDataBase(ColumnValues: Pointer;
                                               loadTitle: boolean);
var
  newLines: Integer;
  Value: ^PChar;
begin
  Value := ColumnValues;
  newLines := 0;
  try
    (* title *)
    if loadTitle then
      title := Value^;
    Inc(Value);

    (* lastModified *)
    lastModified := Value^;
    Inc(Value);

    (* lines *)
    lines := StrToIntDef(Value^, 0);
    Inc(Value);

    (* viewPos *)
    viewPos := StrToIntDef(Value^, 0);
    Inc(Value);

    (* mark *)
    self.mark := timNONE;
    if 0 < Pos('F', Value^) then
      self.mark := timMARKER;
    Inc(Value);

    (* URI *)
    self.URI := Value^;
    Inc(Value);

    (* state *)
    self.state := TThreadState(StrToIntDef(Value^, 0));
    Inc(Value);

    (* newLines *)
    newLines := StrToIntDef(Value^, 0);
    Inc(Value);

    (* WriteName *)
    UsedWriteName:= Value^;
    Inc(Value);

    (* WriteMail *)
    UsedWriteMail:= Value^;
    Inc(Value);

    (* lastWrote *)
    LastWrote:= StrToInt64Def(Value^, 0);
    Inc(Value);

    (* LastGot *)
    LastGot := StrToInt64Def(Value^, 0);
    Inc(Value);

    (* readPos *)
    readPos:= StrToIntDef(Value^, 0);

    self.queryState := self.state;
  except
  end;
  oldLines := lines - newLines;
  anchorLine := oldLines;
end;


(* 管理データを読む *)
function TThreadItem.LoadIndexData(loadTitle: boolean): Boolean;
var
  indexData: TStringList;
  fname: string;
  newLines: Integer;
begin
  Result := False;
  fname := GetFileName + EXT_IDX;
  lines := 0;
  newLines := 0;
  if not FileExists(fname) then
  begin
    if FileExists(ChangeFileExt(fname, '.dat')) then
    begin
      AddRef;
      lines := CalcLines;
      oldLines := lines;
      anchorLine := oldLines;
      title := self.GetSubject;
      SaveIndexData;
      Result := True;
      Release;
    end;
    exit;
  end;
  indexData := TStringList.Create;
  try
    indexData.LoadFromFile(fname);
    if loadTitle then
      title := indexData.Strings[IDX_TITLE];
    lastModified := indexData.Strings[IDX_MODIFIED];
    viewPos := StrToInt(indexData.Strings[IDX_VIEWPOS]);
    lines := StrToInt(indexData.Strings[IDX_LINES]);
    self.mark := timNONE;
    if IDX_MARK < indexData.Count then
    begin
      if 0 < Pos('F', indexData.Strings[IDX_MARK]) then
        self.mark := timMARKER;
    end;
    if IDX_URI < indexData.Count then
      self.URI := indexData.Strings[IDX_URI];
    if IDX_STATE < indexData.Count then
    begin
      try
        self.state := TThreadState(StrToInt(indexData.Strings[IDX_STATE]));
      except
      end;
    end;
    if IDX_NEWLINES < indexData.Count then
    begin
      try
        newLines := StrToInt(indexData[IDX_NEWLINES]);
      except
      end;
    end;
    if IDX_WRITENAME < indexData.Count then
      UsedWriteName:= indexData.Strings[IDX_WRITENAME];
    if IDX_WRITEMAIL < indexData.Count then
      UsedWriteMail:= indexData.Strings[IDX_WRITEMAIL];
    if IDX_WROTE < indexData.Count then
    begin
      try
        LastWrote:= StrToInt64(indexData.Strings[IDX_WROTE]);
      except
      end;
    end;
    if IDX_GOT < indexData.Count then
    begin
      try
        LastGot := StrToInt64(indexData.Strings[IDX_GOT]);
      except
      end;
    end;
    if IDX_READPOS < indexData.Count then
      readPos:= StrToInt(indexData.Strings[IDX_READPOS]);
    self.queryState := self.state;
  except
  end;
  oldLines := lines - newLines;
  anchorLine := oldLines;
  indexData.Free;
end;

(* DataBase (aiai) *)
procedure TThreadItem.InsertToTable;
var
  markp: String;
  msg: PChar;
  title2: String;
  sql: string;
  err: byte;
begin
  if not Config.ojvQuickMerge then exit;  //DataBaseを使わない場合は抜ける

  if self.mark = timMARKER then
    markp := 'F'
  else
    markp := '';
  if 0 < Pos('''', title) then
    title2 := AnsiReplaceStr(title, '''', '''''') //ｼﾝｸﾞﾙｸｫｰﾄがある場合はｼﾝｸﾞﾙｸｫｰﾄを二つ重ねる
  else
    title2 := title;
  TBoard(board).IdxDataBase.AddRef;
  sql := 'INSERT INTO idxlist '+
                    '(datname,title, last_modified, lines,view_pos, idx_mark, uri, state, new_lines, write_name, write_mail, last_wrote, last_got, read_pos) '+
                    'VALUES ('+
                    ''''+ datName +''', '+
                    ''''+title2+''', '+
                    ''''+ lastModified +''', '+
                    ''''+ IntToStr(lines) +''', '+
                    ''''+ IntToStr(viewPos) +''', '+
                    ''''+ markp +''', '+
                    ''''+ URI +''', '+
                    ''''+ IntToStr(Integer(state)) +''', '+
                    ''''+ IntToStr(lines - oldLines) +''', '+
                    ''''+ UsedWriteName +''', '+
                    ''''+ UsedWriteMail +''', '+
                    ''''+ IntToStr(LastWrote) +''', '+
                    ''''+ IntToStr(LastGot) +''', '+
                    ''''+ IntToStr(readPos) +''')';
  err := TBoard(board).IdxDataBase.Exec(PChar(sql), nil, nil, msg);
  SQLCheck(err, title2, sql, msg);
  TBoard(board).IdxDataBase.Release;
end;
(* //DataBase *)

(* 管理データを保存する *)

(* DataBase (aiai) *)
function CallBackSaveIndexData(Sender: TObject;
                               Columns: Integer;
                               ColumnValues: Pointer;
                               ColumnNames: Pointer): integer; cdecl;
begin
  (TThreadItem(Sender).board as TBoard).IdxDataBase.Result := True;
  Result := 0;
end;
(* //DataBase *)

procedure TThreadItem.SaveIndexData;
var
  indexData: TStringList;
  msg: PChar;
  markp: String;
  title2: String;
  sql: string;
  {$IFDEF DEVELBENCH}
  tickcnt: Cardinal;
  {$ENDIF}
  err: byte;
begin
  if lines <= 0 then
    exit;

  indexData := TStringList.Create;
  indexData.Add(title);
  indexData.Add(lastModified);
  indexData.Add(IntToStr(lines));
  indexData.Add(IntToStr(viewPos));
  case mark of
  timMARKER: markp := 'F';
  else markp := '';
  end; //case
  indexData.Add(markp);
  indexData.Add(URI);
  indexData.Add(IntToStr(Integer(state)));
  indexData.Add(IntToStr(lines - oldLines));
  indexData.Add(UsedWriteName); //521
  indexData.Add(UsedWriteMail); //521
  indexData.Add(IntToStr(LastWrote)); //521
  indexData.Add(IntToStr(LastGot)); //521
  indexData.Add(IntToStr(readPos));
  try
    indexData.SaveToFile(GetFileName + EXT_IDX);
    idxModified := false;
  except
  end;

  indexData.Free;

  (* DataBase (aiai) *)
  if not Config.ojvQuickMerge then exit;
  {$IFDEF DEVELBENCH}
  tickcnt := GetTickCount;
  {$ENDIF}
  With TBoard(board) do
  begin
    IdxDataBase.Result := False;
    IdxDataBase.AddRef;
    sql := 'SELECT datname FROM idxlist WHERE datname = ' + datName;
    err := IdxDataBase.Exec(PChar(sql), @CallBackSaveIndexData, Self, msg);
    SQLCheck(err, title, sql, msg);
    if IdxDataBase.Result then
    begin
      if 0 < Pos('''', title) then
        title2 := AnsiReplaceStr(title, '''', '''''') //ｼﾝｸﾞﾙｸｫｰﾄがある場合はｼﾝｸﾞﾙｸｫｰﾄを二つ重ねる
      else
        title2 := title;
      sql := 'UPDATE idxlist' +
                      ' SET title = '''+ title2 +''', ' +
                      'last_modified = '''+ self.lastModified +''', '+
                      'lines = '''+ IntToStr(lines) +''', ' +
                      'view_pos = '''+ IntToStr(viewPos) +''', ' +
                      'idx_mark ='''+ markp +''', ' +
                      'uri = '''+ URI +''', ' +
                      'state = '''+ IntToStr(Integer(state)) +''', ' +
                      'new_lines = '''+ IntToStr(lines - oldLines) +''', ' +
                      'write_name = '''+ UsedWriteName +''', ' +
                      'write_mail = '''+ UsedWriteMail +''', ' +
                      'last_wrote = '''+ IntToStr(LastWrote) +''', ' +
                      'last_got = '''+ IntToStr(LastGot) +''', ' +
                      'read_pos = '''+ IntToStr(readPos) +''' ' +
                      'WHERE datname = '''+ datName +'''';
    end else
    begin
      if 0 < Pos('''', title) then
        title2 := AnsiReplaceStr(title, '''', '''''') //ｼﾝｸﾞﾙｸｫｰﾄがある場合はｼﾝｸﾞﾙｸｫｰﾄを二つ重ねる
      else
        title2 := title;
      sql := 'INSERT INTO idxlist' +
                      ' (datname,title, last_modified, lines,view_pos, idx_mark, uri, state, new_lines, write_name, write_mail, last_wrote, last_got, read_pos) '+
                      'VALUES ('+
                      ''''+ datName +''', '+
                      ''''+ title2 +''', '+
                      ''''+ self.lastModified +''', '+
                      ''''+ IntToStr(lines) +''', '+
                      ''''+ IntToStr(viewPos) +''', '+
                      ''''+ markp +''', '+
                      ''''+ self.URI +''', '+
                      ''''+ IntToStr(Integer(state)) +''', '+
                      ''''+ IntToStr(lines - oldLines) +''', '+
                      ''''+ UsedWriteName +''', '+
                      ''''+ UsedWriteMail +''', '+
                      ''''+ IntToStr(LastWrote) +''', '+
                      ''''+ IntToStr(LastGot) +''', '+
                      ''''+ IntToStr(readPos) +''')';
    end;
    err := IdxDataBase.Exec(PChar(sql), nil, nil, msg);
    SQLCheck(err, title2, sql, msg);
    IdxDataBase.Release;
  end;
  {$IFDEF DEVELBENCH}
  Main.Log(title + ':' + IntToStr(GetTickCount - tickcnt));
  {$ENDIF}
  (* //DataBase *)
end;

(* datを読込む  *)
function TThreadItem.LoadData: boolean;
var
  path: string;
begin
  if dat <> nil then
    dat.Free;
  dat := TThreadData.Create;
  path := GetFileName + EXT_DAT;
  if not FileExists(path) then
  begin
    result := false;
    exit;
  end;
  try
    dat.LoadFromFile(path);
    result := True;
  except
    result := False;
  end;
end;

(* datを保存する *)
function TThreadItem.SaveData: boolean;
var
  path: string;
begin
  if dat = nil then
  begin
    result := false;
    exit;
  end;
  path := GetFileName + EXT_DAT;
  RecursiveCreateDir(HogeExtractFileDir(path));
  try
    dat.SaveToFile(path);
    result := True;
  except
    result := False;
  end;
end;

//※[457]
function TThreadItem.LoadAboneData: boolean;
begin
  result := AboneArray.Load(GetFileName + EXT_ABONE);
end;

//※[457]
function TThreadItem.SaveAboneData: boolean;
begin
  if ABoneArray.Size > dat.Lines then
    ABoneArray.Size := dat.Lines;
  result := AboneArray.Save(GetFileName + EXT_ABONE);
end;


(* 行数を計算する *)
function TThreadItem.CalcLines: integer;
begin
  result := dat.Lines;
end;

(*  *)
function TThreadItem.GetSubject: string;
var
  i: integer;
  pos: integer;
  datType: TDatType;
  DataString: String;
begin
  result := '';
  if dat = nil then
    exit;
  pos := 1;
  if dat.Count <= 0 then
    exit;
  DataString := dat.Strings[0];
  datType := GetDatType(dat);
  if datType = dtNormal then
  begin
    for i := 1 to 4 do
    begin
      pos := FindPos('<>', DataString, pos);
      inc(pos, 2);
    end;
  end
  else begin
    for i := 1 to 4 do
    begin
      pos := FindPos(',', DataString, pos);
      inc(pos, 1);
    end;
  end;
  (*  *)
  while pos < length(DataString) do
  begin
    if Ord(DataString[pos]) in [10, 13] then
      break;
    result := result + DataString[pos];
    inc(pos);
  end;
  {aiai}
  //if result = '' then
  //  result := title;
  //if 0 < System.Pos(#0, result) then
  //  result := ReplaceStr(result, #0, ' ');
  if result = '' then
  begin
    if GetNeedConvert and (InCodeCheck(title) in [EUC_IN, EUCorSJIS_IN]) then
      result := euc2sjis(title)
    else
      result := title;
  end else
  begin
    if 0 < System.Pos(#0, result) then
      result := ReplaceStr(result, #0, ' ');
    if GetNeedConvert and (InCodeCheck(result) in [EUC_IN, EUCorSJIS_IN]) then
      result := euc2sjis(result);
  end;
  {/aiai}
end;

(* 参照カウント増加 *)
procedure TThreadItem.AddRef(load: boolean = true);
begin
  if (dat = nil) and (load) then
    Activate;
  Inc(refCount);

  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
    TBoard(board).IdxDataBase.AddRef;
  (* //DataBase *)
end;

(* 参照カウント減少 *)
procedure TThreadItem.Release;
begin
  Dec(refCount);
  if refCount <= 0 then
    Deactivate;

  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
    TBoard(board).IdxDataBase.Release;
  (* //DataBase *)
end;

(* ログから取得 *)
procedure TThreadItem.Activate;
begin
  if dat = nil then
  begin
    LoadData;
    LoadAboneData; //※[457]
  end;
end;

(* メモリ解放 *)
procedure TThreadItem.Deactivate;
begin
  if Assigned(dat) then
  begin
    SaveAboneData; //※[457]  dat.freeの前に by beginner
    dat.Free;
    dat := nil;
//    SaveAboneData; //※[457]
  end;
end;


(*  *)
procedure TThreadItem.SetViewPos(pos: integer);
begin
  viewPos := pos;
  oldLines := lines;
  anchorLine := oldLines;
  idxModified := True;
end;

(*  *)
function TThreadItem.Refered: boolean;
begin
  result := (0 < refCount);
end;

(*  *)
procedure TThreadItem.RemoveLog(deleteIdx: boolean = true);
var
  fname: string;
  msg: PChar;
  sql: string;
  err: byte;
begin
  Deactivate;
  fname := GetFileName;
  SysUtils.DeleteFile(fname + EXT_DAT);
  SysUtils.DeleteFile(fname + EXT_DAT + EXT_BAKUP);
  SysUtils.DeleteFile(fname + EXT_IDX + EXT_BAKUP);
  if deleteIdx then
  begin

    (* DataBase (aiai) *)
    if Config.ojvQuickMerge then
    begin
      TBoard(board).IdxDataBase.AddRef;
      sql := 'DELETE FROM idxlist WHERE datname = '''+ datName +'''';
      err := TBoard(board).IdxDataBase.Exec(PChar(sql), nil, nil, msg);
      SQLCheck(err, title, sql, msg);
      TBoard(board).IdxDataBase.Release;
    end;
    (* //DataBase *)

    SysUtils.DeleteFile(fname + EXT_IDX);
    SysUtils.DeleteFile(fname + EXT_ABONE); //※[457]
    self.ABoneArray.Clear;
    self.mark := timNONE;
    self.LastWrote := 0;
    self.LastGot := 0;
    self.readPos := 0;
  end;
  self.lines := 0;
  self.lastModified := '';
  self.URI := '';
  self.state := tsCurrency;
  self.queryState := tsCurrency;
  self.oldLines := 0;
  self.anchorLine := 0;
  self.idxModified := false;
end;

procedure TThreadItem.MoveLog;
var
  fname: string;
begin
  Deactivate;
  fname := GetFileName;
  SysUtils.DeleteFile(fname + EXT_DAT + EXT_BAKUP);
  SysUtils.DeleteFile(fname + EXT_IDX + EXT_BAKUP);
  SysUtils.RenameFile(fname + EXT_DAT, fname + EXT_DAT + EXT_BAKUP);
  SysUtils.RenameFile(fname + EXT_IDX, fname + EXT_IDX + EXT_BAKUP);
  self.lines := 0;
  self.lastModified := '';
  self.URI := '';
  self.state := tsCurrency;
  self.queryState := tsCurrency;
  self.oldLines := 0;
  self.anchorLine := 0;
  self.idxModified := false;
  logmoved := true;
end;

function TThreadItem.GetBoardName: string;
begin
  result := TBoard(board).name;
end;

function TThreadItem.GetHost: string;
begin
  result := TBoard(board).host;
end;

function TThreadItem.GetBBS: string;
begin
  result := TBoard(board).bbs;
end;

(* これは非同期受信依頼のスレッドで走行する *)
procedure TThreadItem.OnAsyncNotifyProc(sender: TAsyncReq; code: TAsyncNotifyCode);
  procedure ConnectProc;
  begin
    asyncObj.synchro.Wait;
    if asyncObj.proc = sender then
    begin
      if (queryState in [tsTransition1, tsTransition3]) or
         ((queryState = tsHistory2) and
          ((not Config.tstAuthorizedAccess) or (not Is2ch(sender.URI)))) then
        sender.IdHTTP.Request.Connection := 'Close'
      else
        sender.IdHTTP.Request.Connection := '';
    end;
    asyncObj.synchro.Release;
  end;

  procedure ResponseProc;
  begin
    asyncObj.synchro.Wait;
    begin
      if asyncObj.proc = sender then
      begin
        asyncObj.notifyCount := 0;
        asyncObj.discard := false;
        asyncObj.responseText := sender.IdHTTP.ResponseText;
        asyncObj.responseCode := sender.GetAsyncResponseCode;
        asyncObj.lastModified := sender.IdHTTP.Response.RawHeaders.Values['Last-Modified'];
        asyncObj.rangeStr := sender.IdHTTP.Response.RawHeaders.Values['Content-Range'];
        if TBoard(board).timeValue <= 0 then
          TBoard(board).timeValue := DateTimeToUnix(Str2DateTime(sender.IdHTTP.Response.RawHeaders.Values['Date']));
        case asyncObj.responseCode of
        200, 206: (* 200 OK *)(* 206 Partial Content *)
          if asyncObj.useCGI and (queryState = tsCurrency) then
            asyncObj.FTimeStartDownload := Now;
        304:(* 304 Not Modified *)
          begin
            try
              sender.IdHTTP.Disconnect;
            except
            end;
          end;
        302:; (* Moved Temporary  *)
        404:  (* 404 Not Found *)
          if queryState <> tsHistory1 then
          begin
            queryState := tsTransition1;
            try
              sender.IdHTTP.Disconnect;
            except
            end;
          end;
        else
          begin
            queryState := tsTransition1;
            try
              sender.IdHTTP.Disconnect;
            except
            end;
          end;
        end;
        (*
        if ( queryState = tsTransition) or
           ((queryState = tsHistory2) and (not Config.tstAuthorizedAccess)) then
          sender.IdHTTP.CloseConnection := true;
        *)
      end;
    end;
    asyncObj.synchro.Release;
  end;

  (* データチャンク受信通知 *)
  procedure NotifyProc;
  var
    lastLF: integer;
    fl: string;
  begin
    LogEndQuery;
    asyncObj.synchro.Wait;
    if asyncObj.proc = sender then
    begin
      case asyncObj.responseCode of
      200, 206:(* 200 OK *)(* 206 Partial Content *)
        begin
          if asyncObj.discard then
            sender.GetString
          else
            asyncObj.dataChunk := asyncObj.dataChunk + sender.GetString;

          if (asyncObj.notifyCount <= 0) and
             (((asyncObj.useCGI) and (queryState = tsCurrency)) or
              (queryState in [tsTransition1, tsTransition3])) then
          begin
            lastLF := Pos(#10, asyncObj.dataChunk);
            if 0 < lastLF then
            begin
              fl := Copy(asyncObj.dataChunk, 1, lastLF -1);
              Log('( @_@) □ ﾅﾆﾅﾆ･･･  ' + fl);
              if AnsiStartsStr('+OK ', fl) or
                 AnsiStartsStr('-INCR ', fl) or
                 AnsiStartsStr('+PARTIAL ', fl) then
              begin
                inc(asyncObj.notifyCount);
              end
              else begin
                asyncObj.discard := true;
                asyncObj.dataChunk := '';
                if AnsiStartsStr('-ERR どこかであぼーん', fl) then
                  queryState := tsTransition3
                else if AnsiStartsStr('-ERR html化待ち', fl) then
                begin
                  if queryState in [tsCurrency, tsHistory1] then
                    queryState := tsHistory2;
                end
                else if AnsiStartsStr('-ERR 指定時間が過ぎました', fl) then
                begin
                  if Main.Config.tstAuthorizedAccess then
                  begin
                    if queryState = tsTransition1 then
                      queryState := tsTransition2;
                  end;
                end;
              end;
            end;
          end
          else
            Inc(asyncObj.notifyCount);
          (* 経過通知が必要ならdaemonに依頼する *)
          if assigned(asyncObj.OnNotify) and
             (0 < asyncObj.notifyCount) then
            daemon.Post(OnSynchroNotifyProc);
        end;
      else
        sender.GetString;
      end;
    end;
    asyncObj.synchro.Release;
  end;

  (* 終了前処理 *)
  procedure PreTerminateProc;
    procedure NextProc;
    begin
      sender.GetString;
      case queryState of
      tsCurrency:
        begin
          queryState := tsHistory1;
          sender.rangeStart := 0;
          sender.rangeEnd   := 0;
          sender.Restart(GetURI);
        end;
      tsHistory1:
        begin
          queryState := tsHistory2;
          if dat <> nil then
            sender.rangeStart := dat.Size
          else
            sender.rangeStart := 0;
          sender.rangeEnd   := 0;
          sender.Restart(GetURI);
        end;
      tsHistory2:
        if Config.tstAuthorizedAccess and Is2ch(sender.URI) then
        begin
          queryState := tsTransition1;
          sender.rangeStart := 0;
          sender.rangeEnd   := 0;
          sender.Restart(GetURI);
        end;
      tsTransition2:
        if Config.tstAuthorizedAccess and Is2ch(sender.URI) then
        begin
          ticket2ch.Reset;
          queryState := tsTransition3;
          sender.rangeStart := 0;
          sender.rangeEnd   := 0;
          sender.Restart(GetURI);
        end;
      end;
    end;

    procedure CheckDownloadRate;
    var
      thresholdTime: TDateTime;
      currentTime: TDateTime;
    begin
      if (not asyncObj.useCGI) or (queryState <> tsCurrency) then
        exit;
      currentTime := Now;
      (*
      if asyncObj.FTimeStartDownload < currentTime then
        Log(Format('%d Kbps',
                   [Trunc(asyncObj.proc.TransferedSize/((currentTime - asyncObj.FTimeStartDownload)*24*60*60)/1024*8)]));
      *)
      thresholdTime := asyncObj.FTimeStartDownload +
                       (asyncObj.proc.TransferedSize/LIMIT_BYTES_PER_SEC)/(24*60*60);
      if thresholdTime <= currentTime then
        exit;
      Config.netUseReadCGI := False;
      Config.Modified := True;
      Log('ヽ(`Д´)ﾉｳﾜｧｧｧﾝ');
    end;
  begin
    asyncObj.synchro.Wait;
    if asyncObj.proc = sender then
    begin
      case asyncObj.responseCode of
      200:  (* 200 OK *)
        if asyncObj.discard then
          NextProc
        else
          CheckDownloadRate;
      304:; (* 304 Not Modified *)
      206:  (* 206 Partial Content *)
        CheckDownloadRate;
      -1:;  (* Tiemout *)
      else
        NextProc;
      end;
    end;
    asyncObj.synchro.Release;
  end;

begin
  case code of
  ancPRECONNECT:
    begin
      ticket2ch.On2chPreConnect(sender, code);
      if asyncObj.proc = sender then
      begin
        asyncObj.synchro.Wait;
        if asyncObj.FForceReload and (queryState = tsCurrency) then
          sender.IdHTTP.Request.Pragma := 'no-cache';
        asyncObj.synchro.Release;
      end;
    end;
  ancCONNECT:  ConnectProc;
  ancRESPONSE: ResponseProc;
  ancPROGRESS: NotifyProc;
  ancPRETERMINATE: PreTerminateProc;
  end;
end;

(* VCLスレッド:受信依頼完了 *)
procedure TThreadItem.OnAsyncDoneProc(sender: TAsyncReq);

  function AsyncResult: boolean;
  var
    size: integer;
  begin
    if asyncObj.discard then
    begin
      result := False;
      exit;
    end;
    result := true;
    case asyncObj.responseCode of
    200: (* 200 OK *)
      begin
        if not asyncObj.canceled then
          self.lastModified := asyncObj.lastModified;
        if dat <> nil then
        begin
        //if TBoard(board).GetBBSType <> bbsMachi then
          title := GetSubject;
        end;
        if not asyncObj.discard then
        begin
          if (queryState in [tsTransition1, tsTransition3, tsHistory1, tsHistory2]) then
            state := tsComplete;
          if lines > anchorLine then
            LastGot := DateTimeToUnix(Now); //521
          SaveData;
          SaveIndexData;
        end;
        {Log(Format('（･∀･）新着 %d件', [lines - anchorLine]));}
        {ayaya}
        if useTrace[20] then
          Log(Format(traceString[20], [lines - anchorLine]));
        {//ayaya}
        {aiai} //Sound
        if FileExists(MODIFIED_SOUND) then
          MMSystem.PlaySound(PChar(MODIFIED_SOUND), 0, SND_FILENAME or SND_ASYNC);
        {/aiai}
         if (MainWnd.AutoReload <> nil) then
          MainWnd.AutoReload.Counter(0);  //aiai
      end;
    304: (* 304 Not Modified *)
      begin
        if queryState in [tsTransition1, tsTransition3, tsHistory1, tsHistory2] then
        begin
          state := tsComplete;
          SaveIndexData;
        end;
        case Random(4) of
       {0: Log('(ﾟДﾟ)　誰もｶｷｺしてないぞｺﾞﾙｧ!!');
        1: Log('（；´Д｀）　誰もカキコしてないよ');
        2: Log('（-＿-）　誰もカキコしてない･･･');
        3: Log('（　´∀｀）　誰も書いてないよ');}
        {ayaya}
        0: Log2(21, '');
        1: Log2(22, '');
        2: Log2(23, '');
        3: Log2(24, '');
        {/ayaya}
        end;
        {aiai} //Sound
        if FileExists(NOTMODIFIED_SOUND) then
          MMSystem.PlaySound(PChar(NOTMODIFIED_SOUND), 0, SND_FILENAME or SND_ASYNC);
        {/aiai}
        if (MainWnd.AutoReload <> nil) then
          MainWnd.AutoReload.Counter(1);  //aiai
      end;
    206: (* 206 Partial Content *)
      begin
        if assigned(dat) then
        begin
          try
            size := StrToInt(Copy(asyncObj.rangeStr,
                                  Pos('/', asyncObj.rangeStr)+1, 20));
          except
            size := 0;
          end;
          if dat.Size = longword(size) then
          begin
            if not asyncObj.canceled then
              self.lastModified := asyncObj.lastModified;
            if lines > anchorLine then
              LastGot := DateTimeToUnix(Now); //521
            SaveData;
            SaveIndexData;
           {Log(Format('（･∀･）新着 %d件', [lines - anchorLine]));}
            {ayaya}
            if useTrace[25] then
              Log(Format(traceString[25], [lines - anchorLine]));
            {//ayaya}
            {aiai} //Sound
            if FileExists(MODIFIED_SOUND) then
              MMSystem.PlaySound(PChar(MODIFIED_SOUND), 0, SND_FILENAME or SND_ASYNC);
            {/aiai}
            if (MainWnd.AutoReload <> nil) then
              MainWnd.AutoReload.Counter(0);  //aiai
          end
          else if not asyncObj.canceled then
          begin
           {StatLog('(；ﾟДﾟ)サイズが合わない･･･');}
            StatLog2(26, '');   //ayaya
            result := false;
            {aiai}
            self.datbreak := true;
            {aiai} //Sound
            if FileExists(ERROR_SOUND) then
              MMSystem.PlaySound(PChar(ERROR_SOUND), 0, SND_FILENAME or SND_ASYNC);
            {/aiai}
            if (MainWnd.AutoReload <> nil) then
              MainWnd.AutoReload.Counter(5);
            {/aiai}
          end;
        end;
      end;
    else (* その他のエラーコード *)
      begin
       {Log('（･∀･）ﾅﾝｶｴﾗｰﾀﾞｯﾃ  ' + asyncObj.responseText);}
        Log2(27, asyncObj.responseText);  //ayaya
        result := False;
        {aiai} //Sound
        if FileExists(ERROR_SOUND) then
          MMSystem.PlaySound(PChar(ERROR_SOUND), 0, SND_FILENAME or SND_ASYNC);
        {/aiai}
        if (MainWnd.AutoReload <> nil) then
          MainWnd.AutoReload.Counter(5);  //aiai
      end;
    end;
  end;

var
  rc: Boolean;
  fname: string;
begin
  LogEndQuery2;
  if assigned(asyncObj) then
  begin
    if asyncObj.proc = sender then
    begin
      OnSynchroNotifyProc;
      rc := AsyncResult;
      if rc then
        self.datbreak := false;
      queryState := tsCurrency;
      if assigned(asyncObj.OnDone) then
        asyncObj.OnDone(self);
      Dec(asyncObj.refCount);
      if (asyncObj.refCount <= 0) then
      begin
        asyncObj.Free;
        asyncObj := nil;
      end;
      lastAccess := Now;
      if logmoved then
      begin
        logmoved := false;
        fname := GetFileName;
        if rc then
        begin
          SysUtils.DeleteFile(fname + EXT_DAT + EXT_BAKUP);
          SysUtils.DeleteFile(fname + EXT_IDX + EXT_BAKUP);
        end
        else begin
          SysUtils.DeleteFile(fname + EXT_DAT);
          SysUtils.DeleteFile(fname + EXT_IDX);
          SysUtils.RenameFile(fname + EXT_DAT + EXT_BAKUP, fname + EXT_DAT);
          SysUtils.RenameFile(fname + EXT_IDX + EXT_BAKUP, fname + EXT_IDX);
          LoadIndexData(true);
          LoadData;
        end;
      end;
      if rc and (lines < itemCount) then
        mayHaveInconsistency := True;
    end;
    Release;
  end;
end;

(* VCLスレッド *)
procedure TThreadItem.OnSynchroNotifyProc;
var
  i, len, lastLF: integer;
  newContents: string;
  fl: string;

  function GetBetweenStr(const AString, leftstr, rightstr: string): string;
  var
    startpos, endpos: integer;
  begin
    startpos := AnsiPos(leftstr, AString) + length(leftstr);
    endpos := AnsiPos(rightstr, AString);
    if (0 < startpos)  and (0 < endpos) and (startpos < endpos) then
      result := Copy(AString, startpos, endpos - startpos)
    else
      result := '';
  end;

  function MachiBBSHTMLLineToDatLine(line: string): string;
  var
    linenum, abonelines, i: integer;
    name, mail, dateid, body: string;
  begin
    line := ReplaceStr(line, #10, '');
    line := ReplaceStr(line, #0, '');
    if line[Length(line)] = #10 then
      SetLength(line, Length(line) - 1);

    if TBoard(board).GetBBSType = bbsJBBSShitaraba then
      line := euc2sjis(line);

    i := 1;
    while true do
    begin
      if line[i] in ['0'..'9'] then
        Inc(i)
      else
        break;
    end;

    linenum := StrToInt(Copy(line, 1, i-1));


    if AnsiContainsStr(line, '</B>') then
    begin
      name := GetBetweenStr(line, '<b> ', ' </B></a>');
      mail := GetBetweenStr(line, '<a href="mailto:', '"><b>');
      Delete(line, 1, Pos('</a>', line) + 3); 
    end
    else
    begin
      name := GetBetweenStr(line, '"><b> ', ' </b></font>');
      mail := '';
      Delete(line, 1, Pos('</font>', line) + 5); 
    end;

    dateid := GetBetweenStr(line, '投稿日： ', '<br><dd>');
    Delete(line, 1, Pos('<br><dd>', line) + Length('<br><dd>') - 1);

    if (TBoard(board).GetBBSType = bbsMachi) and (line[1] = ' ') then
      Delete(line, 1, 1);

    body := line;
    if AnsiEndsStr('<br><br>', body) then
      SetLength(body, Length(body) - Length('<br><br>'));
    dateid := AnsiReplaceStr(dateid, '<font size=1>', '');
    dateid := AnsiReplaceStr(dateid, '</font>', '');

    result := '';
    abonelines := linenum - lines - 1;
    //番号がずれていたらずれている分あぼーんを追加
    for i:=0 to abonelines-1 do
      result := result + 'あぼーん<>あぼーん<>あぼーん<> あぼーん <>'#10;
    lines := lines + abonelines;

    result := result + name + '<>' + mail + '<>' + dateid + '<> ' + body + ' ' + '<>'#10;

  end;

  procedure MachiBBSConvert;
  var
    procpos: integer;
    //title: string;
  begin
    if asyncObj.htmlpositionstate = aosBeforeRes then
    begin
      procpos := Pos('<dt>', asyncObj.dataChunk);
      if 0 < procpos then
      begin
        //タイトルをsubject.txt等から取得できていない場合はHTMLから取得
        if self.title = '' then
        begin
          self.title := GetBetweenStr(asyncObj.dataChunk, '<title>', '</title>');
          if TBoard(board).GetBBSType = bbsJBBSShitaraba then
            self.title := StrictConvertJCode(self.title, EUC_IN, SJIS_OUT);
        end;
        {if lines > 0 then
          title := '';}
        Delete(asyncObj.dataChunk, 1, procpos + 3);
        asyncObj.htmlpositionstate := aosInRes;
      end
      else
      begin
        newContents := '';
        lastLF := 0;
      end;
    end;

    if asyncObj.htmlpositionstate = aosInRes then
    begin
      procpos := pos('<table', asyncObj.dataChunk);
      if 0 < procpos then
      begin
        Delete(asyncObj.dataChunk, procpos, High(integer));
        asyncObj.htmlpositionstate := aosAfterRes;
        asyncObj.dataChunk := asyncObj.dataChunk + '<dt>';
      end;
      newContents := '';
      while true do
      begin
        procpos := pos('<dt>', asyncObj.dataChunk);
        if procpos <= 0 then
          break;
        newContents := newContents + MachiBBSHTMLLineToDatLine(Copy(asyncObj.dataChunk, 1, procpos - 1));
        Delete(asyncObj.dataChunk, 1, procpos + 3);
        Inc(lines);
        lastLF := 1; //無理矢理
      end;
      {if Length(title) > 0 then
      begin
        Insert(title, newContents, Pos(#10, newContents));
        title := '';
      end;}
    end
    else if asyncObj.htmlpositionstate = aosAfterRes then
    begin
      lastLF := 0;
      asyncObj.dataChunk := '';
    end;
  end;

  procedure JBBSShitarabaConvert;
    function JBBSShitarabaConvertLine(ContentLine: String): String;
    const
      DivShi = '<>';
      Div2ch = '<>';
      DivID  = ' ID:';
    var
      items: array[0..6] of String;
      linenum: Integer;
      p1, p2: PChar;
      i: Integer;
    begin
      Result := '';
      ContentLine := euc2sjis(ContentLine);
      for i := 0 to 6 do
        items[i] := '';
      p1 := PChar(ContentLine);
      for i := 0 to 6 do
      begin
        p2 := AnsiStrPos(p1, DivShi);
        if Assigned(p2) then
        begin
          SetString(items[i], p1, p2 - p1);
          p1 := p2 + 2;
        end else
        begin
          items[i] := p1;
          break;
        end;
      end;

      linenum := StrToIntDef(items[0], 0);
      if lines < linenum then
      begin
        for i := lines to linenum - 1 do
          Result := Result + 'あぼーん<>あぼーん<>あぼーん<> あぼーん <>'#10;
        lines := linenum;
      end;

      if items[6] <> '' then
        Result := Result + items[1] + Div2ch + items[2] + Div2ch + items[3] +
                  DivID  + items[6] + Div2ch + items[4] + Div2ch + items[5]
      else
        Result := Result + items[1] + Div2ch + items[2] + Div2ch +
                  items[3] + Div2ch + items[4] + Div2ch + items[5];
    end;
  var
    pos1, pos2: Integer;
  begin
    newContents := '';
    pos1 := 1;
    while True do
    begin
      pos2 := FindPos(#10, asyncObj.dataChunk, pos1);
      if pos2 = 0 then
      begin
        lastLF := pos1 - 1;
        Delete(asyncObj.dataChunk, 1, lastLF);
        Break;
      end;
      inc(lines);
      newContents := newContents + JBBSShitarabaConvertLine(Copy(asyncObj.dataChunk, pos1, pos2 - pos1)) + #10;
      pos1 := pos2 + 1;
    end;
  end;

begin
  (*  *)
  if asyncObj = nil then
    exit;
  if asyncObj.discard then
    exit;
  if asyncObj.pumpCount <= 0 then
  begin
    if asyncObj.responseCode = 200 then
    begin
      if (queryState in [tsTransition1, tsTransition3]) or
         (asyncObj.useCGI and (queryState = tsCurrency)) then
        asyncObj.dropFirstLine := true
      else if (TBoard(board).GetBBSType = bbsMachi) or
              (TBoard(board).GetBBSType = bbsJBBSShitaraba) or
              (TBoard(board).GetBBSType = bbsJBBS) then
      begin
      end
      else begin
        Deactivate;
        lines := 0;
        lastModified := '';
      end;
    end;
  end;
  if not (asyncObj.responseCode in [200, 206]) then
  begin
    exit;
  end;
  Inc(asyncObj.pumpCount);
  lastLF := 0;

  asyncObj.synchro.Wait;
  begin
    if (TBoard(Board).GetBBSType = bbsMachi) or
       (TBoard(Board).GetBBSType = bbsJBBS) then
      MachiBBSConvert
    else if TBoard(Board).GetBBSType = bbsJBBSShitaraba then
      JBBSShitarabaConvert
    else
    begin
      len := length(asyncObj.dataChunk);
      for i := 1 to len do
      begin
        if asyncObj.dataChunk[i] = #10 then
        begin
          lastLF := i;
          Inc(lines);
        end;
      end;
      if 0 < lastLF then
      begin
        newContents := Copy(asyncObj.dataChunk, 1, lastLF);
        asyncObj.dataChunk := Copy(asyncObj.dataChunk, lastLF + 1, len - lastLF);
      end;
    end;
  end;
  asyncObj.synchro.Release;

  if lastLF <= 0 then
    exit;

  if asyncObj.dropFirstLine then
  begin
    Dec(lines);
    asyncObj.dropFirstLine := false;
    lastLF := Pos(#10, newContents);
    fl := Copy(newContents, 1, lastLF -1);
    if AnsiStartsStr('-INCR ', fl) then (* あぼ～んによる全取得 *)
    begin
      Deactivate;
      lines := 0;
      lastModified := '';
    end;
    newContents := Copy(newContents, lastLF +1, High(integer));
    if length(newContents) <= 0 then
      exit;
  end;

  if assigned(dat) then
  begin
    dat.Add(newContents);
  end
  else begin
    dat := TThreadData.Create;
    dat.Add(newContents);
  end;
  if lines <= 0 then
    lines := CalcLines;

  if assigned(asyncObj.OnNotify) then
    asyncObj.OnNotify(self);
end;

(* 非同期受信開始 *)
function TThreadItem.StartAsyncRead(OnDone: TThreadItemDone;
                                    OnNotify: TThreadItemNotify;
                                    Reload: Boolean = False): TThreadReqResult;
  procedure AdjustState;
  var
    board: TBoard;
  begin
    if 0 < number then
      exit;
    if queryState <> tsCurrency then
      exit;
    board := TBoard(self.board);
    if (0 < length(board.lastModified)) then
    begin
      if UxTimeStr2DateTime(self.datName) < Str2DateTime(board.lastModified) then
        queryState := tsHistory1;
    end;
  end;

var
  theTime: TDateTime;
  kbSpeed: Cardinal;
begin
  if state = tsComplete then
  begin
    {Log('（･∀･）ｶｺﾛｰｸﾞ!!');}
    Log2(28, '');  //ayaya
    result := trrErrorPermanent;
    exit;
  end;
  (*
  if (not Reload) and (Now < IncSecond(lastAccess, THREAD_RELOAD_INTERVAL)) and
     ((not mayHaveInconsistency) or (Assigned(dat) and (0 < dat.Size))) then
  *)
  if (not Reload) and (Now < IncSecond(lastAccess, Config.oprThreadReloadInterval)) and
     ((not mayHaveInconsistency) or (Assigned(dat) and (0 < dat.Size))) then
  begin
    SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @kbSpeed, 0);
    lastAccess := lastAccess + 1.2/((30-2.5)*kbSpeed/31 + 2.5)/(24*60*60);
    //theTime := IncSecond(Now, THREAD_RELOAD_INTERVAL);
    theTime := IncSecond(Now, Config.oprThreadReloadInterval);
    if theTime < lastAccess then
      lastAccess := theTime;
    //Log('（；´Д｀）焦らないで･･･');
    result := trrErrorTryLater;
    exit;
  end;
  if assigned(asyncObj) then
  begin
   {Log('（･∀･）ｲﾏﾔｯﾃﾙﾄｺﾛ!!');}
    Log2(29, '');  //ayaya
    result := trrErrorProgress;
    exit;
    (*
    asyncObj.synchro.Wait;
    if assigned(asyncObj.proc) then
      asyncObj.proc.Cancel;
    asyncObj.synchro.Release;
    *)
  end
  else begin
    if TBoard(board).past then
    begin
      if not Config.tstAuthorizedAccess then
      begin
      { Log(' (´-`).｡oO（IDが必要かと･･･）'); }
        Log2(30, '');   //ayaya      
        result := trrErrorPermanent;
        exit;
      end;
      queryState := tsTransition1;
    end;
    asyncObj := TThreadItemAsyncObj.Create;
  end;
  AddRef; (*  *)
  lines := CalcLines;
  //oldLines := lines;
  if lines <= 0 then
    lastModified := '';

  AdjustState;
  mayHaveInconsistency := False;

  asyncObj.synchro.Wait;
  asyncObj.OnNotify := OnNotify;
  asyncObj.OnDone   := OnDone;
  asyncObj.FForceReload := Reload;
  Inc(asyncObj.refCount);
  StartQuery;
  asyncObj.synchro.Release;
  if asyncObj.proc = nil then
  begin
    asyncObj.OnDone := nil;
    OnAsyncDoneProc(nil);
    result := trrErrorTemporary;
  end
  else
    result := trrSuccess;
end;

procedure TThreadItem.StartQuery;
var
  size: integer;
  expectedLineSize: integer;
begin
  LogBeginQuery;
  asyncObj.dataChunk := '';
  asyncObj.pumpCount := 0;
  asyncObj.dropFirstLine := false;
  if TBoard(board).GetBBSType in [bbsMachi, bbsJBBSShitaraba, bbsJBBS] then
  begin
    asyncObj.proc := AsyncManager.Get(GetURI,
                                      OnAsyncDoneProc, OnAsyncNotifyProc,
                                      lastModified);
  end
  else begin
    if Config.netUseReadCGI then
    begin
      expectedLineSize := 500;
      if 0 < lines then
        expectedLineSize := dat.Size div longword(lines);
      asyncObj.useCGI := ((itemCount <= 0) and (lines <= 0)) or
                         (14 * 1024 < (itemCount - lines) * expectedLineSize );
      //asyncObj.useCGI := true;
    end
    else
      asyncObj.useCGI := false;

    if asyncObj.useCGI then
      size := 0
    else
      size := dat.Size;

    (* datが圧縮されなくなったので常に差分取得
    if (itemCount * Config.compressRatio) <= (itemCount - lines) then
    begin
      asyncObj.proc := AsyncManager.Get(GetURI,
                                        OnAsyncDoneProc, OnAsyncNotifyProc,
                                        lastModified);
    end
    else begin
    *)
      asyncObj.proc := AsyncManager.Get(GetURI,
                                        OnAsyncDoneProc, OnAsyncNotifyProc,
                                        lastModified, size);
    (*
    end;
    *)
  end;
end;

(*  *)
procedure TThreadItem.CancelAsyncRead;
begin
  if assigned(asyncObj) and assigned(asyncObj.proc) then
  begin
    asyncObj.proc.Cancel;
//    asyncObj.synchro.Wait;
//    asyncObj.OnNotify := nil;
//    asyncObj.canceled := True;
//    asyncObj.synchro.Release;
    {Log('（･∀･）ﾁｭｰｼ!!');}
    Log2(31, '');  //ayaya
  end;
end;

function TThreadItem.Downloading: Boolean;
begin
  result := Assigned(asyncObj);
end;

function TThreadItem.GetTransferedSize: Cardinal;
begin
  if Assigned(asyncObj) and Assigned(asyncObj.proc) then
    result := asyncObj.proc.TransferedSize
  else
    result := 0;
end;

//aiai
function TThreadItem.GetNeedConvert: Boolean;
begin
  if Assigned(board) then
    result := TBoard(board).NeedConvert
  else
    result := False;
end;

procedure TThreadItem.ChkConsistency;
begin
  if Assigned(dat) and (not dat.Consistent) then
    mayHaveInconsistency := True;
end;

function TThreadItem.DupData: TThreadData;
begin
  result := nil;
  if Assigned(dat) then
  begin
    if Assigned(asyncObj) and Assigned(asyncObj.synchro) then
    begin
      asyncObj.synchro.Wait;
      result := dat.Dup;
      asyncObj.synchro.Release;
    end
    else
      result := dat.Dup;
  end;
end;

function TThreadItem.ToString(const body: string; startLine, lines: Integer): String;
var
  tmpDat: TThreadData;
  dat2html: TDat2HTML;
begin
  dat2html := TDat2HTML.Create(body, Config.SkinPath);
  tmpDat := DupData;
  if Assigned(tmpDat) then
  begin
    result := dat2html.ToString2(tmpDat, startLine, lines, GetNeedConvert);
    tmpDat.Free;
  end
  else
    result := '';
  dat2html.Free;
end;

(* full:cgiとhtmlのURLのセット, last:最新50件, index:特定レス番URL *)
function TThreadItem.ToURL(full: Boolean; last: Boolean; index: string): string;
var
  uri, host, bbs: string;
  s1, s2: string;
  Hyphen: Integer;
begin
  uri := Self.URI;
  if not AnsiStartsStr('http', uri) then
    uri := TBoard(board).GetURIBase;
  SplitThreadURI(uri, host, bbs);

  case TBoard(board).GetBBSType of
  bbs2ch, bbsOther:
    begin
      if (state <> tsCurrency) and (full or (index = '')) then
      begin
        if 9 < length(datName) then
          s2 := Self.URI + '/kako/' + Copy(datName, 1, 4) + '/'
            + Copy(datName, 1, 5) + '/' + ChangeFileExt(datName, '.html')
        else
          s2 := Self.URI + '/kako/' + Copy(datName, 1, 3) + '/' + ChangeFileExt(datName, '.html');
      end;
      if full or (s2 = '') then
      begin
        s1 := 'http://' + host + '/test/read.cgi/' + bbs
            + '/' + ChangeFileExt(datName, '/');
        if last then
          s1 := s1 + 'l50'
        else if length(index) > 0 then
          s1 := s1 + index;
      end;
    end;
  bbsMachi:
    begin
      s1 := 'http://' + host + '/bbs/read.pl?BBS=' + bbs
          + '&KEY=' + ChangeFileExt(datName, '');
      if last then
        s1 := s1 + '&LAST=50'
      else if length(index) > 0 then
      begin
        Hyphen := Pos('-', index);
        if Hyphen > 0 then
          s1 := s1 + '&START=' + copy(index, 1, Hyphen - 1) + '&END=' + copy(index, Hyphen + 1, length(index) - Hyphen)
        else
          s1 := s1 + '&START=' + index + '&END=' + index;
      end;
    end;
  bbsJBBSShitaraba:
    begin
      //▼ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      // したらばのURL対応を少し汎用的に
      s1 := 'http://' + Config.bbsJBBSServers[0] + '/bbs/read.cgi/'
              + GetJBBSShitarabaCategory(host) + '/' + bbs
                      + '/' + ChangeFileExt(datName, '') + '/';
      //▲ Nightly Tue Sep 28 13:39:43 2004 UTC by lxc
      if last then
        s1 := s1 + 'l50'
      else if length(index) > 0 then
        s1 := s1 + index;
    end;
  bbsJBBS:
    begin
      s1 := 'http://' + host + '/bbs/read.cgi?BBS=' + bbs
          + '&KEY=' + ChangeFileExt(datName, '');
      if last then
        s1 := s1 + '&LAST=50'
      else if length(index) > 0 then
      begin
        Hyphen := Pos('-', index);
        if Hyphen > 0 then
          s1 := s1 + '&START=' + copy(index, 1, Hyphen - 1) + '&END=' + copy(index, Hyphen + 1, length(index) - Hyphen)
        else
          s1 := s1 + '&START=' + index + '&END=' + index;
      end;
    end;
  {bbsOther:
    begin
      s1 := 'http://' + host + '/test/read.cgi?bbs=' + bbs
          + '&key=' + ChangeFileExt(thread.datName, '');
      if last then
        s1 := s1 + '&ls=50'
      else if length(index) > 0 then
        s1 := s1 + '&st=' + index + '&to=' + index;
    end;}
  end;

  if (length(s1) > 0) and (length(s2) > 0) then
    result := s1
  else
    result := s1 + s2;
end;


end.


