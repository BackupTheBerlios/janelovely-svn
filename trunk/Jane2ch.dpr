program Jane2ch;
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)

uses
  Windows,
  SysUtils,
  MMSystem,
  Forms,
  HogeListView,
  Main in 'Main.pas' {MainWnd},
  StrSub in 'StrSub.pas',
  JConfig in 'JConfig.pas',
  UDat2HTML in 'UDat2HTML.pas',
  FileSub in 'FileSub.pas',
  UConfig in 'UConfig.pas' {UIConfig},
  UAsync in 'UAsync.pas',
  UViewItem in 'UViewItem.pas',
  crc in '..\gzip_delphi2\crc.pas',
  zlib in '..\gzip_delphi2\zlib.pas',
  gzip in '..\gzip_delphi2\gzip.pas',
  USynchro in 'USynchro.pas',
  UHeadCache in 'UHeadCache.pas',
  UDaemon in 'UDaemon.pas',
  U2chThread in 'U2chThread.pas',
  U2chBoard in 'U2chBoard.pas',
  U2chCat in 'U2chCat.pas',
  U2chCatList in 'U2chCatList.pas',
  UIDlg in 'UIDlg.pas' {InputDlg},
  UFavorite in 'UFavorite.pas',
  UXMLSub in 'UXMLSub.pas',
  UUngetStream in 'UUngetStream.pas',
  UXTime in 'UXTime.pas',
  IdHTTP2 in '..\derived\IdHTTP2.pas',
  jconvert in '..\jconvert\jconvert.pas',
  USharedMem in 'USharedMem.pas',
  UDOLIB in 'UDoLib.pas',
  U2chTicket in 'U2chTicket.pas',
  ULocalCopy in 'ULocalCopy.pas',
  UBase64 in 'UBase64.pas',
  UCryptAuto in 'UCryptAuto.pas',
  HTTPSub in 'HTTPSub.pas',
  UPtrStream in 'UPtrStream.pas',
  UTVSub in 'UTVSub.pas',
  IdHTTP in '..\derived\IdHTTP.pas',
  UPopUpTextView in 'UPopUpTextView.pas',
  HTMLDocumentEvent in 'HTMLDocumentEvent.pas',
  UGrepDlg in 'UGrepDlg.pas' {GrepDlg},
  UCrypt in 'UCrypt.pas',
  CheckURL in 'View\CheckURL.pas',
  UAdvAboneRegist in 'View\UAdvAboneRegist.pas' {AdvAboneRegist},
  UAnimatedPaintBox in 'View\UAnimatedPaintBox.pas',
  UArchiveView in 'View\UArchiveView.pas',
  UCardinalList in 'View\UCardinalList.pas',
  UContentView in 'View\UContentView.pas',
  UEditSaveLocation in 'View\UEditSaveLocation.pas' {SavePointDialog},
  UHttpManage in 'View\UHttpManage.pas',
  UImageHint in 'View\UImageHint.pas',
  UImagePageControl in 'View\UImagePageControl.pas',
  UImageTabSheet in 'View\UImageTabSheet.pas',
  UImageViewConfig in 'View\UImageViewConfig.pas' {ImageViewPreference},
  UImageViewer in 'View\UImageViewer.pas' {ImageForm},
  UMSPageControl in 'View\UMSPageControl.pas',
  UNGWordsAssistant in 'View\UNGWordsAssistant.pas',
  UPopUpButtons in 'View\UPopUpButtons.pas' {TransparentForm},
  UQuickAboneRegist in 'View\UQuickAboneRegist.pas' {QuickAboneRegist},
  ARCHIVES in 'View\Arc\ARCHIVES.PAS',
  UAAForm in 'AIAI\UAAForm.pas' {AAForm},
  UAutoReloadSettingForm in 'AIAI\UAutoReloadSettingForm.pas' {AutoReloadSettingForm},
  UAutoReSc in 'AIAI\UAutoReSc.pas',
  UAutoScrollSettingForm in 'AIAI\UAutoScrollSettingForm.pas' {AutoScrollSettingForm},
  UGetBoardListForm in 'AIAI\UGetBoardListForm.pas' {GetBoardListForm},
  ULovelyWebForm in 'AIAI\ULovelyWebForm.pas' {LovelyWebForm},
  UNews in 'AIAI\UNews.pas',
  UNewsSettingForm in 'AIAI\UNewsSettingForm.pas' {NewsSettingForm},
  UAddAAForm in 'AIAI\UAddAAForm.pas' {AddAAForm},
  UChottoForm in 'AIAI\UChottoForm.pas' {ChottoForm},
  UImageViewCacheListForm in 'AIAI\UImageViewCacheListForm.pas' {ImageViewCacheListForm},
  UFormSplash in 'AIAI\UFormSplash.pas' {FormSplash},
  UTTSearch in 'AIAI\UTTSearch.pas',
  UCheckSeverDown in 'AIAI\UCheckSeverDown.pas',
  HogeTextView in 'HogeTextView.pas',
  UWritePanelControl in 'AIAI\UWritePanelControl.pas',
  UWriteForm in 'UWriteForm.pas' {WriteForm},
  sqlite in 'AIAI\sqlite.pas',
  ClipBrdSub in 'AIAI\ClipBrdSub.pas',
  UMDITextView in 'AIAI\UMDITextView.pas',
  UMigemo in 'AIAI\UMigemo.pas',
  UWriteWait in 'AIAI\UWriteWait.pas',
  WriteSub in 'AIAI\WriteSub.pas',
  VBScript_RegExp_55_TLB in 'C:\Program Files\Borland\Delphi6\Imports\VBScript_RegExp_55_TLB.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.Title := 'Jane';
  if not Main.OnStartup then
    exit;
  (* 起動サウンド (aiai) *)
  if SysUtils.FileExists('startup.wav') then
     MMSystem.PlaySound(PChar('startup.wav'), 0, SND_FILENAME or SND_ASYNC);
  (* スプラッシュスクリーン (aiai) *)
  if SysUtils.FileExists('splash.bmp') then begin
    UFormSplash.FormSplash := TFormSplash.Create(nil);
    UFormSplash.Formsplash.Show;
    UFormSplash.FormSplash.Refresh;
  end;
  Application.CreateForm(TMainWnd, MainWnd);
  Application.CreateForm(TAdvAboneRegist, AdvAboneRegist);
  Application.CreateForm(TImageForm, ImageForm);
  Application.CreateForm(TAAForm, AAForm);
  if Assigned(FormSplash) then
  begin
    UFormSplash.FormSplash.Release;
    UFormSplash.FormSplash := nil;
  end;

  Application.Run;

  (* 終了サウンド (aiai) *)
  //if SysUtils.FileExists('end.wav') then
  //   MMSystem.PlaySound(PChar('end.wav'), 0, SND_FILENAME or SND_SYNC);

end.
