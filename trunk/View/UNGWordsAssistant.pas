unit UNGWordsAssistant;

{beginner} //NGワードの補助データ管理

interface

uses
  Classes, JConfig, IniFiles, Variants, StrSub, VBScript_RegExp_55_TLB;

type

  TNGItemIdent = (NG_ITEM_NAME = 0, NG_ITEM_MAIL = 1, NG_ITEM_MSG = 2, NG_ITEM_ID = 3);
  TNGExItemIdent = (NGEX_ITEM_NAME = 0, NGEX_ITEM_MAIL = 1, NGEX_ITEM_MSG = 2, NGEX_ITEM_ID = 3, NGEX_ITEM_URL = 4);

  TNGItemPChar = Record
    pStart: PChar;
    Size: Integer;
    WideStr: WideString;
    NotMakeWideStr: Boolean;
  end;

  TArrayOfNGItemPChar = Array[TNGItemIdent] of TNGItemPChar;
  TArrayOfNGExItemPChar = Array[TNGExItemIdent] of TNGItemPChar;

  TBaseNGItem = class(TObject)
  public
    Registered:TDateTime;
    EarliestArresting:TDateTime;
    LatestArresting:TDateTime;
    Count:Integer;
    LifeSpan:Integer;   //寿命 ゼロならばデフォルト設定に従う
    AboneType:Integer;  //種別　0:デフォルトに従う 1以上はAboneArrayのコードに対応
    constructor Create;
  end;

  TExNgItem = class(TBaseNGItem)
  private
    FTargetURL: Integer;
    FTargetURLBody: string;
  protected
    SearchObj: array[TNGExItemIdent] of TObject;
  public
    SearchOpt: array[TNGExItemIdent] of Integer;
    SearchStr: array[TNGExItemIdent] of string;
    constructor Create;
    destructor Destroy; override;
    procedure GetValue(Name: String; Ini: TCustomIniFile);
    procedure SetValue(Name: String; Ini: TCustomIniFile);
    procedure MakeSearchObj;
    function Search(NGItem: TArrayOfNGItemPChar; const URL, Title: string): Boolean;
  end;

  TNGItemData = class(TBaseNGItem)
  public
    BMSearch: TBMSearch;
    constructor Create(const Text:String; var Word:String);
    destructor Destroy; override;
    function ConnectedStr:String;
  end;

  TBaseNGStringList = class(TStringList)
  public
    procedure FreeItems;
    procedure CheckLifeSpan(DefaultLifeSpan: Integer);
  end;

  TNGStringList = class(TBaseNGStringList)
  protected
    procedure SetNGData(Index: Integer; Value:TNgItemData);
    function GetNGData(Index: Integer):TNGItemData;
  public
    procedure SaveToFile(const FileName: string);override;
    procedure LoadFromFile(const FileName: string);override;
    property NGData[Index: Integer]:TNGItemData read GetNGData write SetNGData;
  end;

  TExNGList = class(TBaseNGStringList)
  protected
    procedure SetNGData(Index: Integer; Value: TExNGItem);
    function GetNGData(Index: Integer): TExNGItem;
  public
    procedure SaveToFile(const FileName: string); override;
    procedure LoadFromFile(const FileName: string); override;
    property NGData[Index: Integer]:TExNGItem read GetNGData write SetNGData;
  end;

  Type
    TNGList = Array[TNGItemIdent] of TNGStringList;

function DateTimeToFmtStr(DateTime:TDateTime):String;

const
  NGTypeStr  : array[0..4] of string =
                    ('通常あぼーん','通常あぼーん','透明あぼーん','','重要キーワード');

  NG_FILE: array[TNGItemIdent] of String =
                    ('NGnames.txt', 'NGaddrs.txt', 'NGwords.txt', 'NGid.txt');

  NG_THREAD_FILE = 'NGThread.txt';  //aiai

  NG_EX_FILE = 'NGEx.txt';

//  NGItemStr:     array[TNGItemIdent] of String =
//                    ('Name',        'Mail',        'Msg',         'ID');
//  NGItemBodyStr: array[TNGItemIdent] of String =
//                    ('NameBody',    'MailBody',    'MsgBody',     'IDBody');

  NGExItemStr:     array[TNGExItemIdent] of String =
                    ('Name',        'Mail',        'Msg',         'ID',     'TargetURL');
  NGExItemBodyStr: array[TNGExItemIdent] of String =
                    ('NameBody',    'MailBody',    'MsgBody',     'IDBody', 'TargetURLBody');
{
  NGItemSearchTypeStr: array[0..5] of String =  //偶数はNOT
                    ('Contain',  'NotContain',
                     'Same',     'NotSame',
                     'RegExp',   'NotRegExp');
}
  NG_REGISTER        = 'Regist';
  NG_EARLY_ARRESTING = 'Earliest';
  NG_LAST_ARRESTING  = 'Last';
  NG_COUNT           = 'Count';
  NG_LIFESPAN        = 'LifeSpan';
  NG_ABONETYPE       = 'AboneType';

  NG_TARGETURL       = 'TargetURL';
  NG_TARGETURLBODY   = 'TargetURLBody';




implementation

uses
  SysUtils,main;

function DateTimeToFmtStr(DateTime:TDateTime):String;
begin
  DateTimeToString(Result,'yy/mm/dd hh:nn',DateTime);
end;

function DateTimeToFmtStrLong(DateTime:TDateTime):String;
begin
  DateTimeToString(Result,'yyyy/mm/dd hh:nn',DateTime);
end;

{ TBaseNGItem }

//初期化
constructor TBaseNGItem.Create;
begin
  inherited;
  Registered := Now;
  EarliestArresting := 54789; // = StrToDateTime('2050/01/01 00:00:00');
  LatestArresting   := 18264; // = StrToDateTime('1950/01/01 00:00:00');
  Count := 0;
  LifeSpan  := -1;
  AboneType :=  0;
end;


{ TExNGItem }

constructor TExNgItem.Create;
var
  i: TNGExItemIdent;
begin
  inherited;
  for i := Low(i) to High(i) do
    SearchOpt[i] := -1;
end;

//破棄
destructor TExNgItem.Destroy;
var
  i: TNGExItemIdent;
begin
  for i := low(TNGExItemIdent) to high(TNGExItemIdent) do
    SearchObj[i].Free;
  inherited;
end;


//IniFileにデータを出力
procedure TExNgItem.GetValue(Name: String; Ini: TCustomIniFile);
var
  i: TNGExItemIdent;
begin
  Ini.WriteFloat(Name, NG_REGISTER,        Registered);
  Ini.WriteFloat(Name, NG_EARLY_ARRESTING, EarliestArresting);
  Ini.WriteFloat(Name, NG_LAST_ARRESTING , LatestArresting);

  Ini.WriteInteger(Name, NG_LIFESPAN  , LifeSpan);
  Ini.WriteInteger(Name, NG_COUNT     , Count);
  Ini.WriteInteger(Name, NG_ABONETYPE , AboneType);

  for i := Low(TNGExItemIdent) to High(TNGExItemIdent) do
    if SearchOpt[i] >= 0 then begin
      Ini.WriteInteger(Name, NGExItemStr[i], SearchOpt[i]);
      Ini.WriteString(Name, NGExItemBodyStr[i], '"' + SearchStr[i] + '"');
    end;

end;


//IniFileからデータを受け取る
procedure TExNgItem.SetValue(Name: String; Ini: TCustomIniFile);
var
  i: TNGExItemIdent;
  tmp: String;
begin

  Registered        := Ini.ReadFloat(Name, NG_REGISTER, Now);
  EarliestArresting := Ini.ReadFloat(Name, NG_EARLY_ARRESTING, 54789);
  LatestArresting   := Ini.ReadFloat(Name, NG_LAST_ARRESTING, 18264);

  LifeSpan  := Ini.ReadInteger(Name, NG_LIFESPAN, -1);
  Count     := Ini.ReadInteger(Name, NG_COUNT, 0);
  AboneType := Ini.ReadInteger(Name, NG_ABONETYPE, 0);

  FTargetURL := Ini.ReadInteger(Name, NG_TARGETURL, -1);
  FTargetURLBody := Ini.ReadString(Name, NG_TARGETURLBODY, '');

  for i := Low(TNGExItemIdent) to High(TNGExItemIdent) do begin
    SearchOpt[i] := Ini.ReadInteger(Name, NGExItemStr[i], -1);
    if SearchOpt[i] >= 0 then begin
      tmp := Ini.ReadString(Name, NGExItemBodyStr[i], '');
      if Length(tmp) > 2 then
        SearchStr[i] := copy(tmp, 2, Length(tmp) - 2)
      else
        SearchStr[i] := '';
    end else begin
      SearchStr[i] := '';
    end;
  end;
end;


//検索用のオブジェクトを準備する
procedure TExNgItem.MakeSearchObj;
var
  i: TNGExItemIdent;
begin
  for i := Low(TNGExItemIdent) to High(TNGExItemIdent) do begin
    FreeAndNil(SearchObj[i]);
    if SearchStr[i] <> '' then begin
      case SearchOpt[i] of
        0, 1: begin //含む、含まない
          SearchObj[i] := TBMSearch.Create;
          with TBMSearch(SearchObj[i]) do begin
            IgnoreCase := (i <> NGEx_ITEM_ID);
            Subject := SearchStr[i];
          end;
        end;
        2,3:;       //一致/不一致
        4, 5: begin //正規検索 Hit/Hitなし
          SearchObj[i] := TRegExp.Create(nil);
          with TRegExp(SearchObj[i]) do begin
            IgnoreCase := (i <> NGEx_ITEM_ID);
            Pattern := SearchStr[i];
          end;
        end;
      end;
    end;
  end;
end;


//名前、メアド、ID、メッセージを検索
//対象URL,Titleで事前にフィルタリング by aiai
function TExNgItem.Search(NGItem: TArrayOfNGItemPChar; const URL, Title: string): Boolean;
var
  i: TNGItemIdent;
  tmpResult :Boolean;
  {aiai}
  wide: WideString;
  {/aiai}
begin
  Result := True;

  {aiai}
  tmpResult := False;
  case SearchOpt[High(TNGExItemIdent)] of
    0, 1: begin //BM
      tmpResult := Assigned(TBMSearch(SearchObj[High(TNGExItemIdent)]).Search(PChar(URL), Length(URL)));
      tmpResult := tmpResult or Assigned((TBMSearch(SearchObj[High(TNGExItemIdent)]).Search(PChar(Title), Length(Title))));
    end;
    2, 3: begin //完全一致
      tmpResult := (Length(URL) = Length(SearchStr[High(TNGExItemIdent)])) and
                   StartWithP(SearchStr[High(TNGExItemIdent)], PChar(URL), Length(URL));
      tmpResult := tmpResult or (Length(Title) = Length(SearchStr[High(TNGExItemIdent)])) and
                   StartWithP(SearchStr[High(TNGExItemIdent)], PChar(Title), Length(Title));
    end;
    4, 5: begin //正規表現
      wide := WideString(URL);
      tmpResult := TRegExp(SearchObj[High(TNGExItemIdent)]).Test(wide);
      wide := WideString(Title);
      tmpResult := tmpResult or TRegExp(SearchObj[High(TNGExItemIdent)]).Test(wide);
    end;
  end;
  if (SearchOpt[High(TNGExItemIdent)] >=0) then begin
    if (SearchOpt[High(TNGExItemIdent)] mod 2 = 0) then
      Result := tmpResult
    else
      Result := not tmpResult;
  end;
  if not Result then
    exit;
  {/aiai}


  for i := Low(TNGItemIdent) to NG_ITEM_ID do begin
    tmpResult := False;
    case SearchOpt[TNGExItemIdent(i)] of
      0, 1: //BM
        tmpResult := Assigned(TBMSearch(SearchObj[TNGExItemIdent(i)]).Search(NGItem[i].pStart, NGItem[i].Size));
      2, 3: //完全一致
        tmpResult := (NGItem[i].Size = Length(SearchStr[TNGExItemIdent(i)])) and
                     StartWithP(SearchStr[TNGExItemIdent(i)], NGItem[i].pStart, NGItem[i].Size);
      4, 5: begin //正規表現
        if NGItem[i].NotMakeWideStr then begin
          SetString(NGItem[i].WideStr, NGItem[i].pStart, NGItem[i].Size);
          NGItem[i].NotMakeWideStr := False;
        end;
        tmpResult := TRegExp(SearchObj[TNGExItemIdent(i)]).Test(NGItem[i].WideStr);
      end;
    end;
    if (SearchOpt[TNGExItemIdent(i)] >=0) then begin
      if (SearchOpt[TNGExItemIdent(i)] mod 2 = 0) then
        Result := Result and tmpResult
      else
        Result := Result and not tmpResult;
    end;
    if not Result then Break;
  end;
end;


{ TNGItemData }

constructor TNGItemData.Create(const Text:String; var Word:String);
var
  Delimiter1,Delimiter2:PChar;
  i:Integer;
  tmp:String;
begin
  inherited Create;
  Word:=Text;

  if Text='' then exit;

  Delimiter1:=PChar(Text)-1;
  for i:=0 to 6 do begin
    Delimiter2:=AnsiStrScan(Delimiter1+1,#9);
    if Delimiter2=nil then
      tmp:=string(Delimiter1+1)
    else
      SetString(tmp,Delimiter1+1,Delimiter2-Delimiter1-1);
    case i of
      0:Word:=tmp;
      1:Registered:=VarToDateTime(Trim(tmp));
      2:EarliestArresting:=VarToDateTime(Trim(tmp));
      3:LatestArresting:=VarToDateTime(Trim(tmp));
      4:Count:=StrToInt(Trim(tmp));
      5:LifeSpan:=StrToInt(Trim(tmp));
      6:AboneType:=StrToInt(Trim(tmp));
    end;
    if Delimiter2=nil then
      Break
    else
      Delimiter1:=Delimiter2;
  end;
end;

destructor TNGItemData.Destroy;
begin
  BMSearch.Free;
  inherited;
end;

function TNGItemData.ConnectedStr:String;
begin
  Result:=DateTimeToFmtStrLong(Registered)
          +#9+DateTimeToFmtStrLong(EarliestArresting)
          +#9+DateTimeToFmtStrLong(LatestArresting)
          +#9+IntToStr(Count)
          +#9+IntToStr(LifeSpan)
          +#9+IntToStr(AboneType);
end;


{ TBaseNGStringList }


//追加オブジェクトの解放
procedure TBaseNGStringList.FreeItems;
var
  i:Integer;
begin
  for i:=0 to Count-1 do Objects[i].Free;
end;


//期限の来たNGワードを削除
procedure TBaseNGStringList.CheckLifeSpan(DefaultLifeSpan: Integer);
var
  i: Integer;
  LifeSpan: Integer;
  NGData: TBaseNGItem;
begin

  for i := Count - 1 downto 0 do begin

    NGData := (Objects[i] as TBaseNGItem);
    LifeSpan := DefaultLifeSpan;
    if NGData.LifeSpan >= 0 then
       LifeSpan := NGData.LifeSpan;
    if (LifeSpan > 0) and (NGData.Registered + LifeSpan < Now)
        and (NGData.LatestArresting + LifeSpan < Now) then begin
      NGData.Free;
      Delete(i);
    end;
  end;

end;

{ TNGStringList }

procedure TNGStringList.SetNGData(Index:Integer; Value:TNgItemData);
begin
  Objects[Index]:=Value;
end;

function TNGStringList.GetNGData(Index:Integer):TNGItemData;
begin
  Result:=TNGItemData(Objects[Index]);
end;

//通常NGファイルとNG情報を含むファイルを保存
procedure TNGStringList.SaveToFile(const FileName: string);
var
  i:Integer;
  tmp:TStringList;
begin

  tmp:=TStringList.Create;

  //重要レスワードは普通のNGワードファイルには保存しない
  for i:=0 to Count-1 do
    if NGData[i].AboneType<>4 then
      tmp.Add(Strings[i]);
  tmp.SaveToFile(FileName);

  tmp.Clear;

  //NG情報をタブ区切りテキストとして保存
  for i:=0 to Count-1 do
    tmp.Add(Strings[i]+#9+NGData[i].ConnectedStr);
  tmp.SaveToFile(ChangeFileExt(ChangeFileExt(FileName,'')+'2',ExtractFileExt(FileName)));

  tmp.Free;

end;

//NG情報をタブ区切りテキストから読み出し、ついで通常NGファイルの情報をマージ
procedure TNGStringList.LoadFromFile(const FileName: string);
var
  i:Integer;
  NGWord:string;
  tmp:TStringList;
  Filename2:string;
begin

  for i:=Count-1 downto 0 do
    Objects[i].Free;

  Clear;

  Filename2:=ChangeFileExt(ChangeFileExt(FileName,'')+'2',ExtractFileExt(FileName));

  if FileExists(FileName2) then
    inherited LoadFromFile(FileName2);

  for i := Count-1 downto 0 do
    if length(Strings[i]) <= 0 then
      Delete(i)
    else begin
      NGData[i]:=TNGItemData.Create(Strings[i],NGWord);
      Strings[i]:=NGWord;
    end;

  tmp:=TStringList.Create;

  tmp.LoadFromFile(FileName);
  for i:=0 to tmp.Count-1 do
    if (length(tmp[i])>0) and (IndexOf(tmp[i])<0) then
      AddObject(tmp[i],TNGItemData.Create(tmp[i],NGWord));

  tmp.Free;

end;

{ TExNGList }


procedure TExNGList.SetNGData(Index:Integer; Value: TExNGItem);
begin
  Objects[Index] := Value;
end;

function TExNGList.GetNGData(Index:Integer):TExNGItem;
begin
  Result := TExNGItem(Objects[Index]);
end;

procedure TExNGList.SaveToFile(const FileName: string);
var
  Ini: TMemIniFile;
  i: Integer;
begin
  Ini := TMemIniFile.Create(FileName);
  try
    Ini.Clear;
    for i := 0 to Count - 1 do
      NGData[i].GetValue(Strings[i], Ini);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

procedure TExNGList.LoadFromFile(const FileName: string);
var
  Ini: TMemIniFile;
  i: Integer;
begin

  {aiai}
  FreeItems;
  Clear;
  {/aiai}

  Ini := TMemIniFile.Create(FileName);
  try
    Ini.ReadSections(Self);
    for i := 0 to Count - 1 do begin
      NGData[i] := TExNgItem.Create;
      NGData[i].SetValue(Strings[i], Ini);
    end;
  finally
    Ini.Free;
  end;
end;


end.

