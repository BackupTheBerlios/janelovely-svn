unit UCheckSeverDown;

interface

uses
  windows,
  messages,
  Classes,
  Controls,
  SysUtils,
  U2chTicket,
  UAsync,
  StrSub,
  StrUtils;

type
  TCheckServerDown = class(TObject)
  protected
    lastModified: String;
    procGet: TAsyncReq;
    Content: TStringList;
    FResponse: TNotifyEvent;
    procedure OnDone(Sender: TASyncReq);
    procedure Response(AAsyncReq: TAsyncReq);
  public
    constructor Create;
    destructor Destroy; override;

    function InitInfo: Boolean;
    function CheckDown(Domain: String): Boolean;

    property OnResponse: TNotifyEvent read FResponse write FResponse;
  end;

var
  CheckServerDownInst: TCheckServerDown;

implementation

uses Main;

const
  SERVER_FOR_DOWNCHECK = 'http://users72.psychedance.com/imode.html';
  SERVER_OK = 'Åõ';
  SERVER_DOWN ='Å~';
  TMPFILENAME = 'serverdown';



{ TCheckServerDown }

constructor TCheckServerDown.Create;
begin
  lastModified := '';
  procGet := nil;
  Content := TStringList.Create;
end;

destructor TCheckServerDown.Destroy;
begin
  Content.Free;

  inherited;
end;

procedure TCheckServerDown.OnDone(Sender: TASyncReq);
var
  index: Integer;
  TmpList: TStringList;
  stream: TPSStream;
begin
  if Sender <> procGet then
    exit;

  procGet := nil;

  Main.Log('Åyusers72.psychedance.comÅz:' + Sender.IdHTTP.ResponseText);
  case Sender.IdHTTP.ResponseCode of
  200:
    begin
      TmpList := TStringList.Create;
      TmpList.Text := Sender.Content;
      TmpList.SaveToFile(i2ch.GetLogDir + '\' + TMPFILENAME + '.html');
      stream := TPSStream.Create(Sender.GetLastModified);
      try
        stream.SaveToFile(i2ch.GetLogDir + '\' + TMPFILENAME + '.idb');
      except
      end;
      stream.Free;

      Content.Clear;

      for index := 0 to TmpList.Count - 1 do
      begin
        if AnsiStartsStr(SERVER_OK, TmpList.Strings[index])
                or AnsiStartsStr(SERVER_DOWN, TmpList.Strings[index]) then
          Content.Add(TmpList.Strings[index]);
      end;

      TmpList.Free;
    end;
  304:
    begin
      if not FileExists(i2ch.GetLogDir + '\' + TMPFILENAME + '.html') then
        Content.Clear
      else begin
        TmpList := TStringList.Create;
        TmpList.LoadFromFile(i2ch.GetLogDir + '\' + TMPFILENAME + '.html');
        Content.Clear;

        for index := 0 to TmpList.Count - 1 do
        begin
          if AnsiStartsStr(SERVER_OK, TmpList.Strings[index])
                  or AnsiStartsStr(SERVER_DOWN, TmpList.Strings[index]) then
            Content.Add(TmpList.Strings[index]);
        end;

        TmpList.Free;
      end;
    end;
  else
    Content.Clear;
  end; //case

  Response(Sender);
end;

procedure TCheckServerDown.Response(AAsyncReq: TAsyncReq);
begin
  if Assigned(FResponse) then
    FResponse(Self);
end;

function TCheckServerDown.InitInfo: Boolean;
var
  stream: TPSStream;
begin
  if FileExists(i2ch.GetLogDir + '\' + TMPFILENAME + '.html')
          and FileExists(i2ch.GetLogDir + '\' + TMPFILENAME + '.idb') then
  begin
    stream := TPSStream.Create('');
    try
      stream.LoadFromFile(i2ch.GetLogDir + '\' + TMPFILENAME + '.idb');
      lastModified := stream.DataString;
    except
    end;
    stream.Free;
  end;

  procGet := AsyncManager.Get(SERVER_FOR_DOWNCHECK,
                              OnDone,
                              ticket2ch.OnChottoPreConnect,
                              lastModified);
  result := (procGet <> nil);
end;

function TCheckServerDown.CheckDown(Domain: String): Boolean;
var
  index: Integer;
  target: String;
begin
  if Domain = '' then begin
    result := false;
    exit;
  end;

  target := LeftStr(Domain, Pos('.', Domain) - 1);

  for index := 0 to Content.Count - 1 do
  begin
    if 0 < Pos(target, Content.Strings[index]) then
    begin

      if AnsiStartsStr(SERVER_OK, Content.Strings[index]) then
        result := true
      else if AnsiStartsStr(SERVER_DOWN, Content.Strings[index]) then
        result := false
      else
        result := true;

      exit;
    end;
  end;
  result := true;
end;

end.
