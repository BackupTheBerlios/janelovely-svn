unit UAutoReSc;

interface

uses
  Classes,
  SysUtils,
  ExtCtrls,
  ComCtrls,
  Controls,
  UViewItem,
  JConfig,
  JLWritePanel;

const
  scrProgressNormal        = 1;    //実行中
  scrPauseMouseEnter       = 2;    //マウスエンターによる一時停止
  scrPauseScrollEnd        = 3;    //最後までスクロールしたことによる一時停止
  scrPauseBrowserEnter     = 4;    //ブラウザーにエンターしたことにより一時停止
  scrPauseWriteProgress    = 5;    //書き込み中につき一時停止
  scrStopNormal            = 6;    //停止

  relPause    = 1;
  relProgress = 2;
  relStop     = 3;

type
(* ----------------------------------------------*)
  TAutoScroll = class(TObject)
    protected
    private
      Timer: TTimer;
      FScrollLines: Integer;
      FState: Integer;
      function GetInterval: Cardinal;
      procedure SetInterval(AInterval: Cardinal);
      procedure TimerOnTimer(Sender: TObject);
      function GetEnabled: Boolean;
      procedure SetEnabled(AEnabled: Boolean);
    public
      constructor Create;
      destructor Destroy; override;
      property State: Integer read FState;
      procedure Pause(opt: Integer);
    published
      property Interval: Cardinal read GetInterval write SetInterval;
      property ScrollLines: Integer read FScrollLines write FScrollLines;
      property Enabled: Boolean read GetEnabled write SetEnabled;
  end;
(* ----------------------------------------------*)
  TAutoReload = class
    protected
    private
      Timer: TTimer;
      Count: Integer;
      FState: Integer;
      function GetInterval: Cardinal;
      procedure SetInterval(AInterval: Cardinal);
      function GetEnabled: Boolean;
      procedure SetEnabled(AEnabled: Boolean);
      procedure TimerOnTimer(Sender: TObject);
    public
      constructor Create;
      destructor Destroy; override;
      procedure Counter(ACount: Integer = 0);
      property State: Integer read FState;
      procedure Pause;
    published
      property Interval: Cardinal read GetInterval write SetInterval;
      property Enabled: Boolean read GetEnabled write SetEnabled;
  end;
(* ----------------------------------------------*)
const
  AUTO_RELOAD_COUNT = 5;

(* ----------------------------------------------*)
implementation
(* ----------------------------------------------*)
uses
  Main;

(* --------以下オートスクロール------------------*)

(* public *)
constructor TAutoScroll.Create;
begin
  inherited Create;

  Timer := TTimer.Create(MainWnd);
  Timer.OnTimer := TimerOnTimer;
  Timer.Enabled := true;
  Log('ｵｰﾄｽｸﾛｰﾙ開始');
  FState := scrProgressNormal;
end;

destructor TAutoScroll.Destroy;
begin
  Timer.Free;

  inherited Destroy;
end;

procedure TAutoScroll.Pause(opt: Integer);
begin
  if FState <> scrProgressNormal then
    exit;

  FState := opt;

  if Timer.Enabled then
  begin
    Timer.Enabled := false;
    case FState of
    scrPauseMouseEnter:
      Log('ﾏｳｽｴﾝﾀｰによりｵｰﾄｽｸﾛｰﾙ一時停止');
    scrPauseScrollEnd:
      Log('最後ﾏﾃﾞｽｸﾛｰﾙｼﾀｺﾄﾆﾖﾘｽｸﾛｰﾙ一時停止');
    scrPauseBrowserEnter:
      Log('ﾌﾞﾗｳｻﾞｰｴﾝﾀｰによりｽｸﾛｰﾙ一時停止');
    scrPauseWriteProgress:
      Log('書き込み中によりｽｸﾛｰﾙ一時停止');
    else end;
  end;
end;

(* private *)
function TAutoScroll.GetInterval: Cardinal;
begin
  Result := Timer.Interval;
end;

procedure TAutoScroll.SetInterval(AInterval: Cardinal);
begin
  Timer.Interval := AInterval;
end;

function TAutoScroll.GetEnabled: Boolean;
begin
  Result := Timer.Enabled;
end;

procedure TAutoScroll.SetEnabled(AEnabled: Boolean);
begin

  if AEnabled then
  begin
    if FState = scrProgressNormal then
      exit;
    Timer.Enabled := true;
    FState := scrProgressNormal;
    Log('ｵｰﾄｽｸﾛｰﾙ開始');
  end else
  begin
    if FState = scrStopNormal then
      exit;
    Timer.Enabled := false;
    FState := scrStopNormal;
    Log('ｵｰﾄｽｸﾛｰﾙ停止');
  end;

end;

procedure TAutoScroll.TimerOnTimer(Sender: TObject);
var
  item: TViewItem;
begin
  item := MainWnd.GetActiveView;


  if (item = nil) or (item.browser = nil) or (item.thread = nil) then
    exit;

  if not item.thread.Downloading and not (item.Progress = tpsProgress) then
    item.browser.AutoScrollLines(FScrollLines);
end;


(* --------以上オートスクロール------------------*)


(* --------以下オートリロード--------------------*)
(* public *)
constructor TAutoReload.Create;
begin
  inherited Create;

  Timer := TTimer.Create(MainWnd);
  Timer.OnTimer := TimerOnTimer;
  Timer.Enabled := false;
end;

destructor TAutoReload.Destroy;
begin
  Timer.Free;

  inherited Destroy;
end;

procedure TAutoReload.Counter(ACount: Integer = 0);
begin
  if not Timer.Enabled then exit;

  if ACount = 0 then
  begin
    Count := 0;
    exit;
  end;

  Inc(Count, ACount);

  if Count >= AUTO_RELOAD_COUNT then begin
    Log('ｵｰﾄﾘﾛｰﾄﾞ停止');
    FState := relStop;
    Log('从＇v＇从ﾘﾛｰﾄﾞばっかりしないでよ');
    Timer.Enabled := false;
  end;
end;

procedure TAutoReload.Pause;
begin
  Timer.Enabled := false;
  FState := relPause;
  Log('書き込み中によりｵｰﾄﾘﾛｰﾄﾞ一時停止');
end;

(* private *)
function TAutoReload.GetInterval: Cardinal;
begin
  Result := Timer.Interval;
end;

procedure TAutoReload.SetInterval(AInterval: Cardinal);
begin
  Timer.Interval := AInterval;
end;

function TAutoReload.GetEnabled: Boolean;
begin
  Result := Timer.Enabled;
end;

procedure TAutoReload.SetEnabled(AEnabled: Boolean);
begin

  if AEnabled then
  begin
    if FState = relProgress then
      exit;
    Timer.Enabled := true;
    FState := relProgress;
    Count := 0;
    Log('ｵｰﾄﾘﾛｰﾄﾞ開始');
  end else
  begin
    if FState = relStop then
      exit;
    Timer.Enabled := false;
    FState := relStop;
    Count := 0;
    Log('ｵｰﾄﾘﾛｰﾄﾞ停止');
  end;
end;

procedure TAutoReload.TimerOnTimer(Sender: TObject);
var
  item: TViewItem;
begin
  item := MainWnd.GetActiveView;

  if (item <> nil) and (item.thread <> nil) then begin
    item.thread.anchorLine := item.thread.lines;
    MainWnd.TabControl.Refresh;
    item.NewRequest(item.thread, gotCHECK, -1, false, false);
    MainWnd.UpdateTabTexts;
    if Config.optSetFocusOnWriteMemo then
    SetFocusToWriteMemo;
  end
end;
(* --------以上オートリロード--------------------*)
end.
