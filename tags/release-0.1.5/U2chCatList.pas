Unit U2chCatList;
(* ２ちゃんねる　カテゴリ一覧 *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)

interface

uses
  Classes, StrUtils, SysUtils,
  U2chCat, U2chBoard, U2chThread, StrSub, FileSub, UDat2HTML;

type

  (*-------------------------------------------------------*)
  (* BBS MENU *)
  TCategoryList = class(TList)
  private
    bbsMenu: string;
    function GetItems(index: integer): TCategory;
    procedure Setitems(index: integer; value: TCategory);
  public
    RootDir: string; (* 作業ルートディレクトリ: \附き *)
    lastModified: string; (* 最終更新日時 *)

    topIndex: integer; (*  *)
    selIndex: integer;

    constructor Create(root: string);
    destructor Destroy; override;
    procedure Clear; override;
    function Load: boolean;
    function Save: boolean;
    function Analyze(const contents: string; const lastModified: string): boolean;
    property Items[index: integer]: TCategory read GetItems write SetItems;
    function GetLogDir: string;
    procedure SafeClear;
    function FindBoard(const HOST, BBS: string; strict: Boolean = False): TBoard;
    function FindBoardByName(const catName, boardName: string): TBoard;
    function FindThread(const catName, boardName, datName: string): TThreadItem;
    procedure SearchLogDir(List: TStrings);
  end;


(*=======================================================*)
implementation
(*=======================================================*)
{$B-}

uses
  Main;

const
  LOG2CH       = 'Logs\2ch';
  BOARDFILE    = 'jane2ch.brd';
  LOGBBSMENU   = '\bbsmenu.dat';
  IDXBBSMENU   = '\bbsmenu.idx';

  IDX_BOARD_NAME    = 0;
  IDX_LAST_MODIFIED = 1;
  IDX_TOP_INDEX     = 2;
  IDX_EXPANDED      = 3;

(* ボード一覧系の生成とか *)
constructor TCategoryList.Create(root: string);
begin
  inherited Create;
  RootDir := root;
  topIndex := 0;
  selIndex := 0;
end;

(* ボード一覧系の廃棄とか *)
destructor TCategoryList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

(* 内部のボード一覧の廃棄とか *)
procedure TCategoryList.Clear;
var
  i: integer;
  node: TCategory;
begin
  for i := 0 to Count -1 do
  begin
    node := Items[i];
    if node <> nil then
      node.Free;
  end;
  inherited;
end;

(* アイテムオーバーライド *)
function TCategoryList.GetItems(index: integer): TCategory;
begin
  result := TCategory(inherited Items[index]);
end;

(* アイテムオーバーライド *)
procedure TCategoryList.SetItems(index: integer; value: TCategory);
begin
  inherited Items[index] := value;
end;


(* ボード一覧情報をファイルから読込み *)
function TCategoryList.Load: boolean;
  procedure LoadBBSMenuInfo;
  var
    strList: TStringList;
  begin
    strList := TStringList.Create;
    lastModified := '';
    try
      strList.LoadFromFile(GetLogDir + IDXBBSMENU);
      if 2 <= strList.Count then
        lastModified := strList.Strings[1];
    except
    end;
    strList.Free;
  end;
var
  strList, tmpList: TStringList;
  i: integer;
  category: TCategory;
  board: TBoard;
  startPos, endPos: integer;
begin
  category := nil;
  strList := TStringList.Create;
  try
    strList.LoadFromFile(RootDir + BOARDFILE);
    tmpList := TStringList.Create;
    tmpList.CommaText := strList.Strings[0];
    try
      topIndex := StrToInt(tmpList.Strings[0]);
      selIndex := StrToInt(tmpList.Strings[1]);
    except
    end;
    tmpList.Free;

    for i := 1 to StrList.Count -1 do
    begin
      if StrList[i][1] = #9 then
      begin (* タブで始るのは板 *)
        board := TBoard.Create(category);
        startPos := 2;
        endPos := FindPos(#9, StrList[i], 2);
        board.host := Copy(StrList[i], startPos, endPos - startPos);
        startPos := endPos + 1;
        endPos := FindPos(#9, StrList[i], startPos);
        board.bbs := Copy(StrList[i], startPos, endPos - startPos);
        startPos := endPos + 1;
        endPos := FindPos(#9, StrList[i], startPos);
        if endPos <= 0 then
        begin
          board.Name := Copy(StrList[i], startPos, Length(StrList[i]) - startPos + 1);
          board.past := False;
        end
        else begin
          board.name := Copy(StrList[i], startPos, endPos - startPos);
          board.past := True;
        end;
        if category <> nil then
          category.Add(board)
        else
          board.Free;
      end
      else begin
        category := TCategory.Create(self);
        startPos := 1;
        endPos := FindPos(#9, StrList[i], startPos);
        category.Name := Copy(StrList[i], startPos, endPos - startPos);
        if StrList[i][endPos+1] = '1' then
          category.expanded := true;
        if (endPos + 2 <= length(StrList[i])) and
           (StrList[i][endPos + 2] = 'C') then
          category.custom := true;
        Add(category);
      end;
    end;

    Load := True;
  except
    Load := False;
  end;


  if (strList.Count > 1) and AnsiStartsStr('【機能】', strList[1]) then
    Delete(0);
  strList.Free;

  //▼機能カテゴリを追加
  category := TCategory.Create(self);
  category.Name := '【機能】';
  category.expanded := false;
  category.custom := true;
  Insert(0, category);
  board := TLogListBoard.Create(category);
  category.Add(board);
  board := TFavoriteListBoard.Create(category);
  category.Add(board);

  board := TOpenThreadsBoard.Create(category);
  category.Add(board);

  LoadBBSMenuInfo;
end;

(* ボード一覧情報を保存：何かの時に安心な かちゅ～しゃもどき *)
function TCategoryList.Save: boolean;
  procedure SaveBBSMenuInfo;
  var
    stream: TPSStream;
    strList: TStringList;
  begin
    if 0 < length(bbsMenu) then
    begin
      stream := TPSStream.Create(bbsMenu);
      RecursiveCreateDir(GetLogDir);
      try
        stream.SaveToFile(GetLogDir + LOGBBSMENU);
      except
      end;
      stream.Free;
    end;
    strList := TStringList.Create;
    strList.Add('2ch');
    strList.Add(lastModified);
    try
      strList.SaveToFile(GetLogDir + IDXBBSMENU);
    except
    end;
    strList.Free;
  end;
var
  strList: TStringList;
  i, j: integer;
  category: TCategory;
  board: TBoard;
  str: string;
begin
  strList := TStringList.Create;
  strList.Add(IntToStr(topIndex) + ',' + IntToStr(selIndex));
  for i := 1 to Count -1 do begin //【機能】を除外
    category := Items[i];
    str := category.name + #9;
    if category.expanded then
      str := str + '1'
    else
      str := str + '0';
    if category.custom then
      str := str + 'C';
    strList.Add(str);
    for j := 0 to category.Count -1 do
    begin
      board := category.Items[j];
      if board.past then
        str := #9'past'
      else
        str := '';
      strList.Add(#9 + board.host + #9 + board.bbs + #9 + board.Name + str);
    end;
  end;
  try
    strList.SaveToFile(rootDir + BOARDFILE);
    result := True;
  except
    result := False;
  end;
  strList.Free;
  SaveBBSMenuInfo;
end;

(* 'BBSMENU'のHTMLをカッコわるく解析する *)
function TCategoryList.analyze(const contents: string;
                               const lastModified: string): boolean;
  function GetToken(const str: string; index, endPos: integer): string;
  begin
    while index <= endPos do
    begin
      case str[index] of
      #$21, #$23..#$3B, #$3D, #$3F..#$7E: result := result + str[index];
      else break;
      end;
      Inc(index);
    end;
  end;
  procedure extractParts(const uri: string;
                         var hostPart: string;
                         var bbsPart: string);
  var
    strList: TStringList;
    i, len: integer;
  begin
    (* http://hogehoge/bbs1/index.html が普通の2ch *)
    (* http://hogehoge/bbs1/bbs2/ は　まちBBS *)
    hostPart := '';
    bbsPart  := '';
    len := length(uri);
    i := FindPosIC('href', uri, 1, len);
    if i <= 0 then
      exit;
    i := FindPosIC('http://', uri, i, len);
    if i <= 0 then
      exit;
    strList := TStringList.Create;
    strList.Delimiter := '/';
    strList.DelimitedText := GetToken(uri, i + 7, length(uri));
    if strList.Count < 3 then
    begin
      strList.Free;
      exit;
    end;
    bbsPart := strList.Strings[strList.Count -2];
    for i := 0 to strList.Count -3 do
    begin
      if 0 < length(hostPart) then
        hostPart := hostPart + '/';
      hostPart := hostPart + strList.Strings[i];
    end;
    strList.Free;
  end;

var
  refered: TList;
  refBoards: TList;
  target: string;  (* ターゲットURI *)
  boardName: string; (* 板名 *)
  hostPart: string;
  bbsPart: string;
  category: TCategory;
  board: TBoard;
  i: integer;
  parser: TPoorHTMLParser;
  typeCode: TPoorHTMLObjCode;
  tmp: string;

  procedure ReserveRefered;
  var
    i: integer;
  begin
    if 0 < Count then
    begin
      for i := 0 to Count -1 do
      begin
        if not Items[i].custom then
        begin
          refered.Add(Items[i]);
          Items[i] := nil;
        end;
      end;
      Pack;
      //inherited Clear;
    end;
  end;

  procedure AddRefBoard;
  var
    i: integer;
  begin
    for i := 0 to refBoards.Count -1 do
      category.Add(refBoards.Items[i]);
    refBoards.Clear;
  end;

  function FindFromRefered: TCategory;
  var
    i: integer;
  begin
    result := nil;
    for i := 0 to refered.Count -1 do
    begin
      if AnsiCompareStr(TCategory(refered.Items[i]).name, target) = 0 then
      begin
        result := TCategory(refered.Items[i]);
        refered.Delete(i);
        break;
      end;
    end;
  end;

begin
  (*  *)
  SafeClear;
  refered := TList.Create;
  refBoards := TList.Create;
  (* 参照中のカテゴリをreferedに退避する *)
  ReserveRefered;
  category := nil;

  parser := TPoorHTMLParser.Create(contents);
  while parser.GetBlock(typeCode, tmp) do
  begin
    if typeCode = hocTAG then
    begin
      target := GetTagName(tmp);
      if (target = 'B') then
      begin
        if parser.GetBlock(typeCode, target) then
        begin
          if typeCode = hocTEXT then
          begin
            //if (target = 'チャット') then
            //  break;
            (* 直前のカテゴリの後始末 *)
            if category <> nil then
              AddRefBoard;
            category := nil;
            if (target = 'おすすめ') or
               (target = '特別企画') or
               (target = 'チャット') or
               (target = '運営案内') or
               (target = 'ツール類') or
               (target = '他のサイト') then
              continue;
            category := FindFromRefered;
            if category <> nil then
            begin
              for i := 0 to category.Count -1 do
              begin
                refBoards.Add(category.Items[i]);
                category.Items[i] := nil;
              end;
              category.Clear;
            end
            else begin
              category := TCategory.Create(self);
              category.Name := target;
            end;
            Add(category);
          end;
        end;
      end
      else if (category <> nil) and (target = 'A') then
      begin
        (*  *)
        extractParts(tmp, hostPart, bbsPart);
        if (0 < length(bbsPart)) and
          parser.GetBlock(typeCode, boardName) then
        begin
          if (typeCode = hocTEXT) then
          begin
            board := nil;
            for i := 0 to refBoards.Count -1 do
            begin
              if AnsiCompareStr(TBoard(refBoards.Items[i]).name, boardName) = 0 then
              begin
                board := TBoard(refBoards.Items[i]);
                refBoards.Delete(i);
                break;
              end;
            end;
            if ((board <> nil) or (FindBoard(hostPart, bbsPart, True) = nil)) and
               (hostPart <> 'info.2ch.net') then
            begin
              if board = nil then
                board := TBoard.Create(category);
              board.Name := boardName;
              board.host := hostPart;
              board.bbs  := bbsPart;
              category.Add(board);
            end;
          end;
        end;
      end;
    end;
  end;

  if category <> nil then
  begin
    for i := 0 to refBoards.Count -1 do
      category.Add(refBoards.Items[i]);
    refBoards.Clear;
  end;
  (* 残ったカテゴリを追加 *)
  for i := 0 to refered.Count -1 do
    Add(refered.Items[i]);

  for i := Count -1 downto 0 do
  begin
    if Items[i].Count <= 0 then
    begin
      Items[i].Free;
      Delete(i);
    end;
  end;

  refered.Free;
  refBoards.Free;
  parser.Free;

  self.bbsMenu := contents;
  self.lastModified := lastModified;
  result := true;
end;

(* ログディレクトリを返す *)
function TCategoryList.GetLogDir: string;
begin
  result := RootDir + LOG2CH;
end;

(* 参照ブツを残してクリアする *)
procedure TCategoryList.SafeClear;
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    Items[i].SafeClear;
    if Items[i].Count <= 0 then
    begin
      Items[i].Free;
      Items[i] := nil;
    end;
  end;
  Pack;
end;

function TCategoryList.FindBoard(const HOST, BBS: string; strict: Boolean): TBoard;
var
  category: TCategory;
  board, substitute: TBoard;
  i, j, k: integer;
begin
  result := nil;
  substitute := nil;
  if (BBS = '') or (Pos('?', HOST) > 0) then
    exit;
  for i := 0 to Count -1 do
  begin
    category := Items[i];
    for j := 0 to category.Count -1 do
    begin
      board := category.Items[j];
      if (AnsiCompareStr(board.bbs, BBS) = 0) then
      begin
        if AnsiCompareText(board.host, HOST) = 0 then
        begin
          result := board;
          exit;
        end;
        case board.BBSType of
        bbs2ch:
          for k := 0 to Config.bbs2chServers.Count -1 do
          begin
            if (0 < Pos(Config.bbs2chServers[k], HOST)) then
            begin
              substitute := board;
              break;
            end;
          end;
        bbsMachi:
          for k := 0 to Config.bbsMachiServers.Count -1 do
          begin
            if (0 < Pos(Config.bbsMachiServers[k], HOST)) then
            begin
              substitute := board;
              break;
            end;
          end;
        bbsJBBSShitaraba:
          for k := 0 to Config.bbsJBBSServers.Count -1 do
          begin
            if (0 < Pos(Config.bbsJBBSServers[k], HOST)) then
            begin
              substitute := board;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
  if not strict then
    result := substitute;
end;

function TCategoryList.FindBoardByName(const catName, boardName: string): TBoard;
var
  cat: TCategory;
  i, j: integer;
begin
  result := nil;
  for i := 0 to Count -1 do
  begin
    if Items[i].name = catName then
    begin
      cat := Items[i];
      for j := 0 to cat.Count -1 do
      begin
        if cat.Items[j].name = boardName then
        begin
          result := cat.Items[j];
          exit;
        end;
      end;
      exit;
    end;
  end;
end;


function TCategoryList.FindThread(const catName, boardName, datName: string): TThreadItem;
var
  board: TBoard;
begin
  result := nil;
  board := FindBoardByName(catName, boardName);
  if board <> nil then
  begin
    board.Activate;
    result := board.Find(datName);
  end;
end;


procedure TCategoryList.SearchLogDir(List: TStrings);
  function FindCategory(catName: String): TCategory;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to Count - 1 do
    begin
      if Items[i].name = catName then
      begin
        Result := Items[i];
        Break;
      end;
    end;
  end;
  function FindBrd(cat: TCategory; boardName: String): TBoard;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to cat.Count - 1 do
    begin
      if cat.Items[i].name = boardName then
      begin
        Result := cat.Items[i];
        Break;
      end;
    end;
  end;
const
  faForDirSearch = faAnyFile - faSysFile - faVolumeID;
var
  FindPath: String;
  DirRec1, DirRec2: TSearchRec;
  FindResult1, FindResult2: Integer;
  cat: TCategory;
  LogDir: String;
begin
  LogDir := GetLogDir + '\';
  FindPath := LogDir + '*.*';
  FindResult1 := FindFirst(FindPath, faForDirSearch, DirRec1);
  while FindResult1 = 0 do
  begin
    if ((DirRec1.Attr and faDirectory) <> 0) and (DirRec1.Name <> '.')
      and (DirRec1.Name <> '..') then
    begin
      cat := FindCategory(DirRec1.Name);
      if cat = nil then
        List.Add(DirRec1.Name);
      FindResult2 := FindFirst(LogDir + DirRec1.Name + '\*.*', faForDirSearch, DirRec2);
      while FindResult2 = 0 do
      begin
        if ((DirRec2.Attr and faDirectory) <> 0) and (DirRec2.Name <> '.')
          and (DirRec2.Name <> '..') then
          if (cat = nil) or (FindBrd(cat, DirRec2.Name) = nil) then
            List.Add(DirRec1.Name + '\' + DirRec2.Name);
        FindResult2 := FindNext(DirRec2);
      end;
    end;
    FindResult1 := FindNext(DirRec1);
  end;
end;

end.
