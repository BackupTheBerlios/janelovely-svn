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
  TNewsEvent = procedure (Sender: TObject; News: String) of Object;

  TNews = class(TObject)
  protected
    FList: TStringList;
    FURLList: TStringList;
    FIndex: Integer;
    siteList: TStringList;
    siteIndex: Integer;
    FNews: TNewsEvent;
    ChangeNewsTimer: TTimer;
    procGet: TAsyncReq;

    procedure SetURIList;
    procedure LoadHtml(sender: TAsyncReq);
    procedure DisplayNews(News: String);
    procedure DownloadNews;
    procedure ChangeNewsTimerStart;
    procedure ChangeNewsTimerOnTimer(Sender: TObject);

    function GetNewsText: String;
    function GetNewsURI: String;

  public
    TempBuffer: String;

    constructor Create;
    destructor Destroy; override;
    procedure resetChangeNewsTimer;
    procedure ChangeNewsTimerStop;
    procedure setChangeNewsTimerInterval(interval: Cardinal);
    function getChangeNewsTimerInterval: Cardinal;
    procedure OpenSettingDlg;

    property OnNews: TNewsEvent read FNews write FNews;
    property NewsText: String read GetNewsText;
    property NewsURI: String read GetNewsURI;
  end;

(* ----------------------------------------------*)
implementation
(* ----------------------------------------------*)

uses
  Main;

(* ----------------------------------------------*)

constructor TNews.Create;
begin
  FList := TStringList.Create;
  FURLList := TStringList.Create;
  FIndex := 0;

  ChangeNewsTimer := TTimer.Create(nil);
  ChangeNewsTimer.Interval := Config.tstNewsInterval;
  ChangeNewsTimer.OnTimer := ChangeNewsTimerOnTimer;
  ChangeNewsTimer.Enabled := false;

  TempBuffer := '';

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
    //resetChangeNewsTimer;
    DisplayNews('Error - ' + Sender.IdHTTP.ResponseText);
    exit;
  end;

  ChangeNewsTimer.Enabled := False;

  if Flist.Count > 0 then begin
    Flist.Clear;
    FURLList.Clear;
    FIndex := 0;
  end;

  TmpList := TStringList.Create;
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
  URI := 'http://www.asahi.com/' + siteList.Strings[siteIndex] + '/list.html';
  procGet := AsyncManager.Get(URI, LoadHTML, ticket2ch.OnKuroPreConnect,'');
end;

procedure TNews.DisplayNews(News: String);
begin
  if Assigned(FNews) then
    FNews(Self, News);
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
  if Assigned(FNews) then
    FNews(Self, 'Please Wait');
  siteIndex :=  Random(siteList.Count);
  ChangeNewsTimer.Enabled := False;
  DownloadNews;
end;

procedure TNews.ChangeNewsTimerOnTimer(Sender: TObject);
begin
  if Flist.Count < 1 then
    ChangeNewsTimer.Enabled := false;

  if FIndex > FList.Count - 1 then
  begin
    resetChangeNewsTimer;
    exit;
  end;

  DisplayNews(FList.Strings[FIndex]);

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
  dlg.Release;
end;




function TNews.GetNewsText: String;
begin
  Result := FList[FIndex - 1];
end;

function TNews.GetNewsURI: String;
begin
  if FURLList.Count > 0 then
    Result := 'http://www.asahi.com/'
            + siteList.Strings[siteIndex]
            + '/update/'
            + FURLList.Strings[FIndex - 1]
  else
    Result := '';
end;


end.
