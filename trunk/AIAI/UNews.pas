unit UNews;

interface

uses
  Classes,
  SysUtils,
  ExtCtrls,
  ComCtrls,
  Controls,
  JConfig,
  jconvert,
  ULocalCopy,
  U2chTicket,
  UAsync,
  UNewsSettingForm;

type
(* ----------------------------------------------*)
  TNews = class(TStatusBar)
    procedure ChangeNewsTimerOnTimer(Sender: TObject);
  protected
    FList: TStringList;
    FURLList: TStringList;
    FIndex: Integer;
    siteList: TStringList;
    siteIndex: Integer;
  private
    procGet: TAsyncReq;
    //storedSetting: TLocalCopy;
    procedure SetURIList;
    procedure LoadHtml(sender: TAsyncReq);
    procedure DisplayNews(News: String);
    procedure DownloadNews;
    procedure ChangeNewsTimerStart;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure resetChangeNewsTimer;
    procedure ChangeNewsTimerStop;
    procedure setChangeNewsTimerInterval(interval: Cardinal);
    function getChangeNewsTimerInterval: Cardinal;
    function getURI: String;
    procedure OpenSettingDlg;
  end;

(* ----------------------------------------------*)
implementation
(* ----------------------------------------------*)

uses
  Main;

var
  ChangeNewsTimer: TTimer;

(* ----------------------------------------------*)

constructor TNews.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  self.Parent := TWinControl(AOwner);
  self.SimplePanel := true;
  self.Anchors := [akLeft,akTop,akRight];
  self.Align := alBottom;

  FList := TStringList.Create;
  FURLList := TStringList.Create;
  FIndex := 0;

  ChangeNewsTimer := TTimer.Create(MainWnd);
  ChangeNewsTimer.Interval := Config.tstNewsInterval;
  ChangeNewsTimer.OnTimer := ChangeNewsTimerOnTimer;
  ChangeNewsTimer.Enabled := false;

  SetURIList;
end;

destructor TNews.Destroy;
begin
  FList.Free;
  FURLList.Free;
  siteList.Free;
  ChangeNewsTimer.Free;

  inherited Destroy;
end;

procedure TNews.SetURIList;
begin
  siteIndex := 0;
  siteList := TStringList.Create;
  siteList.Add('national');
  siteList.Add('sports');
  siteList.Add('business');
  siteList.Add('international');
  siteList.Add('science');
  siteList.Add('culture');
end;

procedure TNews.LoadHtml(sender: TAsyncReq);
  procedure parseHTML(TmpList: TStringList);
  var
    i: integer;
    startpos, endpos: integer;
    p, q: pchar;
    s, t: String;
  begin
    for i := 0 to TmpList.Count - 1 do
    begin
      p := PChar(TmpList.Strings[i]);
      t := '<a href="/' + siteList.Strings[siteIndex] + '/update/';
      if StrLComp(p, PChar(t), length(t)) = 0 then
      begin
        q := p + length(t);

        startpos   := length(t);
        endpos := startpos;
        //URLの末尾を取り出す
        while q^ <> '>' do begin Inc(q); Inc(endpos); end;
        s := Copy(p, startpos + 1, endpos - 1 - startpos);
        FURLList.Add(s);

        //本文を取り出す
        startpos := endpos + 1;
        while q^ <> '<' do begin Inc(q); Inc(endpos); end;
        s := Copy(p, startpos + 1, endpos - startpos);

        //日時を取り出す
        while q^ <> '(' do begin Inc(q); Inc(endpos); end;
        startpos := endpos;
        while q^ <> ')' do begin Inc(q); Inc(endpos); end;
        Inc(endpos);
        s := s + Copy(p, startpos + 1, endpos  - startpos);

        s := euc2sjis(s);
        FList.Add(s);
      end;
    end;
  end;
var
  TmpList: TStringList;
begin
  if Sender <> procGet  then exit;

  if Sender.IdHTTP.ResponseCode <> 200 then
  begin
   resetChangeNewsTimer;
  end;

  //storedSetting.Clear;
  //storedSetting.WriteString(sender.Content);
  //storedSetting.Info.Add('Sun, 14 Sep 1986 00:00:00 GMT');
  //storedSetting.Save;

  //if not FileExists(i2ch.GetLogDir + '\newsjane.tmp') then
  //begin
  //  Log(i2ch.GetLogDir + '\newsjane.tmp Not Fount');
  //  exit;
  //end;

  ChangeNewsTimerStop;

  if Flist.Count > 0 then begin
    Flist.Clear;
    FURLList.Clear;
    FIndex := 0;
  end;

  TmpList := TStringList.Create;
  //TmpList.LoadFromFile(i2ch.GetLogDir + '\newsjane.tmp');
  TmpList.Text := sender.Content;

  parseHTML(TmpList);
  TmpList.Free;

  ChangeNewsTimerOnTimer(nil);
  ChangeNewsTimerStart;
end;

procedure TNews.DownloadNews;
var
  URI: String;
begin
  //if storedSetting = nil then
  //begin
    //storedSetting := TLocalCopy.Create(i2ch.GetLogDir + '\newsjane.tmp', '.idb');
    //storedSetting.Load;
  //end;
  URI := 'http://www.asahi.com/' + siteList.Strings[siteIndex] + '/list.html';
  procGet := AsyncManager.Get(URI, LoadHTML, ticket2ch.OnKuroPreConnect,'');
end;

procedure TNews.DisplayNews(News: String);
begin
  self.SimpleText := News;
end;

procedure TNews.setChangeNewsTimerInterval(interval: Cardinal);
begin
  if ChangeNewsTimer <> nil then
    ChangeNewsTimer.Interval := interval;
end;

function TNews.getChangeNewsTimerInterval: Cardinal;
begin
  if ChangeNewsTimer <> nil then
    result := ChangeNewsTimer.Interval
  else
    result := 0;
end;

procedure TNews.resetChangeNewsTimer;
begin
  self.SimpleText := 'Please Wait';
  siteIndex :=  Random(siteList.Count);
  ChangeNewsTimerStop;
  DownloadNews;
end;

procedure TNews.ChangeNewsTimerOnTimer(Sender: TObject);
begin
  if Flist.Count < 1 then begin ChangeNewsTimerStop; exit; end;

  if FIndex > FList.Count - 1 then
  begin
    resetChangeNewsTimer;
    exit;
  end;

  DisplayNews('http://www.asahi.com/' + siteList.Strings[siteIndex] + '/' + FURLList.Strings[FIndex] + ' - ' + FList.Strings[FIndex]);

  Inc(FIndex);
end;

procedure TNews.ChangeNewsTimerStart;
begin
  if ChangeNewsTimer <> nil then
    ChangeNewsTimer.Enabled := true;
end;

procedure TNews.ChangeNewsTimerStop;
begin
  if ChangeNewsTimer <> nil then
    ChangeNewsTimer.Enabled := false;
end;

procedure TNews.OpenSettingDlg;
var
  dlg: TNewsSettingForm;
begin
  dlg := TNewsSettingForm.Create(MainWnd);
  dlg.ShowModal;
  dlg.Free;
end;

function TNews.getURI: String;
begin
  if FURLList.Count > 0 then
    result := 'http://www.asahi.com/' + siteList.Strings[siteIndex] + '/update/' + FURLList.Strings[FIndex - 1]
  else
    result := '';
end;

end.
