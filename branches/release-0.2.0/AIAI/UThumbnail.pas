unit UThumbnail;

interface

uses
  Windows, Classes, Graphics, USynchro, HogeTextView;

type
  TThumbnailPack = class(TObject)
  public
    bmp: TBitmap;
    item: THogeTVItem;
    browser: THogeTextView;
  end;

  TCreateThumbnailThread = class(TThread)
  private
    logMutex: THogeMutex;
    synch: THogeCriticalSection;
    bmp: TBitmap;
    procedure SynchroExe;
  protected
    procedure Execute; override;
  public
    plist: TList;
    constructor Create;
    destructor Destroy; override;
    procedure Bitmapdesu(bmp: TBitmap; item: THogeTVItem; browser: THogeTextView);
  end;

implementation


 { TCreateThumbnailThread }

constructor TCreateThumbnailThread.Create;
begin
  FreeOnTerminate := False;
  logMutex := THogeMutex.Create(false);
  plist := TList.Create;
  synch := THogeCriticalSection.Create;
  inherited Create(false);
end;

destructor TCreateThumbnailThread.Destroy;
var
  i: integer;
begin
  logMutex.Free;
  synch.Free;
  for i := 0 to plist.Count - 1 do
    TThumbnailPack(plist.Items[i]).Free;
  plist.Free;
  inherited Destroy;
end;

procedure TCreateThumbnailThread.SynchroExe;
begin
  if Assigned(TThumbnailPack(plist.Items[0]).item) then
  begin
    TThumbnailPack(plist.Items[0]).bmp.assign(bmp);
    TThumbnailPack(plist.Items[0]).browser.Invalidate;
  end;
  TThumbnailPack(plist.Items[0]).Free;
  plist.Delete(0);
end;

procedure TCreateThumbnailThread.Execute;
var
  i: integer;
begin
  while not Terminated do
  begin
    i := 0;
    if (logMutex.Wait = WAIT_OBJECT_0) then
    begin
      i := plist.Count;
      logMutex.Release;
    end;
    if i > 0 then
    begin
      bmp := TBitmap.Create;
      bmp.Width := 64;
      bmp.Height := 64;
      synchronize(SynchroExe);
      bmp.Free;
    end else
      sleep(1);
  end;
end;

procedure TCreateThumbnailThread.Bitmapdesu(bmp: TBitmap; item: THogeTVItem; browser: THogeTextView);
var
  rec: TThumbnailPack;
begin
  logMutex.Wait;
  rec := TThumbnailPack.Create;
  rec.bmp := bmp;
  rec.item := item;
  rec.browser := browser;
  plist.Add(rec);
  logMutex.Release;
end;

end.
