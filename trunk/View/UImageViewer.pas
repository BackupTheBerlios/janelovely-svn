unit UImageViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ExtCtrls,
  Math, Dialogs, StdCtrls, ComCtrls, Contnrs, Menus, Clipbrd, StrUtils, ExtDlgs,
  ImgList, ApiBmp, SyncObjs, AppEvnts,
  SPIs, SPIbmp, {GIFImage,} PNGImage, Idhttp, RegExpr,
  UViewITem,
  UImageViewConfig, UAnimatedPaintBox, UHttpManage, UArchiveView, UImageHint,
  UImagePageControl, UImageTabSheet, UPopUpButtons, CheckURL;

const
  ViewGesturePrefix='ImageViewGesture';

type

  TViewerStatus = (vsNormal, vsMinimize, vsFolding, vsMaximize);
  TPageToOperation = (poThisPage, poMarkedPage, poCancel);
  TRootPageControl = class(TImagePageControl);

  TQuickSaveMenuItem = class(TMenuItem);//�N�C�b�N�Z�[�u���j���[�̎��ʗp

  TImageForm = class(TForm)
    StatusBar: TStatusBar;
    SPIs: TSPIs;
    ImagePopUpMenu: TPopupMenu;
    miCloseTab: TMenuItem;
    miOpenWithBrowser: TMenuItem;
    N1: TMenuItem;
    miSavePicture: TMenuItem;
    N2: TMenuItem;
    miCloseErrorTab: TMenuItem;
    StatusIcons: TImageList;
    N3: TMenuItem;
    miCloseAllTab: TMenuItem;
    N4: TMenuItem;
    miEnableFolding: TMenuItem;
    miOpenPreference: TMenuItem;
    miReloadImage: TMenuItem;
    miHideWindow: TMenuItem;
    StatusBarPopupMenu: TPopupMenu;
    miStatusbarURLCopy: TMenuItem;
    miSaveArcive: TMenuItem;
    miShowContentInfo: TMenuItem;
    ArchiveInfoPopUp: TPopupMenu;
    miStatusMemoCopySelection: TMenuItem;
    miStatusMemoSelectAll: TMenuItem;
    miExtractArchive: TMenuItem;
    N5: TMenuItem;
    miArchiveInfoCloseTab: TMenuItem;
    miCloseArchive: TMenuItem;
    miAdjustToWindow: TMenuItem;
    miArchiveInfoSaveArchive: TMenuItem;
    miOpenWithViewer: TMenuItem;
    miOpenWithRelation: TMenuItem;
    miOpenArchiveWithRelation: TMenuItem;
    miOpenRefererThread: TMenuItem;
    miArchiveInfoOpenWithMisc: TMenuItem;
    miArchiveInfoOpenRefererThread: TMenuItem;
    miQuickSave: TMenuItem;
    QuickSavePopup: TPopupMenu;
    miHilight: TMenuItem;
    miHighlightAll: TMenuItem;
    miLolightAll: TMenuItem;
    miHighlightThisRegion: TMenuItem;
    N6: TMenuItem;
    miCloseHilightTab: TMenuItem;
    miCloseUnHilightTab: TMenuItem;
    N7: TMenuItem;
    miHilightTab: TMenuItem;
    miToggleProtect: TMenuItem;
    TabNavigateImageList: TImageList;
    miUnHighlightThisRegion: TMenuItem;
    miSaveAllImage: TMenuItem;
    DummyTitlebar: TPanel;
    btnDummyTitlebarClose: TButton;
    btnDummyTitlebarMaximize: TButton;
    btnDummyTitlebarMinimize: TButton;
    miRegisterBroCra: TMenuItem;
    miReopenArchive: TMenuItem;
    N8: TMenuItem;
    miCacheControlMenu: TMenuItem;
    miDeleteCache: TMenuItem;
    miWriteCache: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure CloseTab(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OpenWithBrowser(Sender: TObject);
    procedure SaveImage(Sender: TObject);
    procedure RelodadImage(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CloseErrorTab(Sender: TObject);
    procedure CloseAllTab(Sender: TObject);
    procedure miEnableFoldingClick(Sender: TObject);
    procedure OpenPreference(Sender: TObject);
    procedure SPIsPictureRegister(Sender: TObject; ASPI: TInSPI;
      const AExtension, ADescription: String;
      var AGraphicClass: TGraphicClass);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImagePopUpMenuPopup(Sender: TObject);
    procedure OpenImageView(Sender: TObject);
    procedure StatusBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CopyStatusBarURL(Sender:TObject);
    procedure HideWindow(Sender: TObject);
    procedure MainWndOnShow;
    procedure MainWndOnHide;
    procedure ShowContentInfo(Sender: TObject);
    function Hook(var Message: TMessage): Boolean;
    procedure StatusMemoSelectAll(Sender: TObject);
    procedure StatusMemoCopySelection(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FlipAdjustToWindow(Sender: TObject);
    procedure OpenWithMisc(Sender: TObject);
    procedure OpenRefererThread(Sender: TObject);
    procedure WMMouseLeave(var Message: TMessage); message WM_MouseLeave;
    procedure HighlightAll(Sender: TObject);
    procedure LowlightAll(Sender: TObject);
    procedure CloseHilightTab(Sender: TObject);
    procedure HighlightThisRegion(Sender: TObject);
    procedure UnHighlightThisRegion(Sender: TObject);
    procedure HilightTab(Sender: TObject);
    procedure ToggleProtect(Sender: TObject);
    procedure SaveAllImage(Sender: TObject);
    procedure btnDummyTitlebarSystemMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnDummyTitlebarSystemMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControlOnEdge(Sender:TObject ;GoForward:Boolean);
    procedure RegisterBrowserCrasher(Sender: TObject);
    procedure CacheControl(Sender: TObject);
    procedure DecodeContent(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormHide(Sender: TObject);
  private
    savedLeft:Integer;
    savedTop:Integer;
    savedWidth:Integer;
    savedHeight:Integer;
    HideOnApplicationMinimize:Boolean;
    ImagePageControl:TImagePageControl;
    ClickDummyTitlebarCloseAt: TPoint;
    function ActivePageControl:TPageControl;
    procedure DeleteTemporaryDirectry(WithFile:Boolean=False);
    procedure MakeQuickSaveMenu;
    procedure GestureMenuClick(Sender:TObject);
    procedure NaviIconClick(Sender:TObject);
    procedure OnHighlightChange(Sender:TObject);
    procedure DisableTitlebar(Value: Boolean);
    function GetPageToOperation(Prompt: String): TPageToOperation;
    procedure PopUpTextHint(S: String);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure NcHitTest(var message:TWMNCHitTest); message WM_NCHITTEST;
  public
    PopUpHint: TImageHint;
    TabNavigateIcon:TPopUpButtons;
    procedure AddMenuItemToMainWnd;
    function GetImage(URL:string; ViewItem:TBaseViewItem=nil; CallFrom:TTabSheet=nil; ForceOpen:Boolean=False):Boolean;
    function ShowImageHint(Text:String; ForSelf:Boolean):Boolean;
    procedure UpdateImageHint(TabSheet:TImageTabSheet);
  end;


function ProofURL(const Original:string; WantEditBox:boolean=True):string;
function ProofURLwithRef(const Original:String; var Ref: string; WantEditBox:boolean=True):string;
procedure ExtractURLs(const Text:string; URLs:TStrings);
function MakeThreadTitleString(ThreadURI:string):string;


var
  ImageForm: TImageForm;


implementation

uses IniFiles, Main, UConfig, UIDlg, U2chBoard, U2chThread, U2chCat, JConfig, ARCHIVES, Types;

var
  RegExpList: TList;
  RegExpReplace:TStringList;
  RegExpReplaceRef:TStringList;

{$R *.dfm}


{ TImageForm }


//Form�̏�����
procedure TImageForm.FormCreate(Sender: TObject);
  procedure LoadMenuConfig;
  var
    i: Integer;
    MenuConfigFile: TMemIniFile;
    MenuConfigFilePath: String;
    MenuList: TStringList;
    tmpString: String;
    Delimit1, Delimit2: PChar;
  begin
    MenuConfigFilePath := ExtractFilePath(Application.ExeName) + MenuConfigFileName;
    if FileExists(MenuConfigFilePath) then begin
      MenuList := TStringList.Create;
      try
        MenuConfigFile := TMemIniFile.Create(MenuConfigFilePath);
        try
          MenuConfigFile.ReadSectionValues('MENU', MenuList);
        finally
          MenuConfigFile.Free;
        end;
        for i := 0 to MenuList.Count - 1 do
          with TMenuItem(FindComponent(MenuList.Names[i])) do begin
            tmpString := MenuList.Values[MenuList.Names[i]];
            UniqueString(tmpString);
            Delimit1 := AnsiStrPos(PChar(tmpString), #9);
            Delimit2 := AnsiStrPos(Delimit1 + 1, #9);
            Visible := StrToBool(Trim(copy(tmpString, 1, Delimit1 - PChar(tmpString))));
            ShortCut := TextToShortCut(Trim(Copy(Delimit1 + 1, 1, Delimit2 - Delimit1 - 1)));
            Caption := Trim(Delimit2 + 1);
            Tag := Integer(not(Visible));
          end;
      except
        MessageDlg('���j���[�R���t�B�O�t�@�C���̓ǂݍ��݂Ɏ��s',mtError,[mbOk],0);
      end;
      MenuList.Free;
    end;
  end;

begin

  Top:=ImageViewConfig.Top;
  Left:=ImageViewConfig.Left;
  Height:=ImageViewConfig.Height;
  Width:=ImageViewConfig.Width;

  TImagePageControl.SetTabStyle(ImageViewConfig.TabStyle);
  TImagePageControl.SetMultiLine(ImageViewConfig.MultiLine);
  TImagePageControl.SetImageTabMode(ImageViewConfig.ImageTab);
  TImagePageControl.SetOnHighlightChange(OnHighlightChange);

  ImagePageControl:=TRootPageControl.Create(Self);
  ImagePageControl.StatusBar:=StatusBar;
  ImagePageControl.OnAllTabClosed:=HideWindow;
  ImagePageControl.OnEdge := PageControlOnEdge;

  TImageTabSheet.SetInvisibleTab(ImageViewConfig.InvisibleTab);

  HttpManager := TConfigHttpManager.Create;
  HttpManager.VConfig := ImageViewConfig;
  HttpManager.MConfig := Config;
  HttpManager.DeleteExpiredCaches;

  LoadMenuConfig;
  MakeQuickSaveMenu;
  AddMenuItemToMainWnd;

  TabNavigateIcon:=TPopUpButtons.Create(Self);
  TabNavigateIcon.Parent:=Self;
  TabNavigateIcon.MakeButton(TabNavigateImageList);
  TabNavigateIcon.OnClick:=NaviIconClick;
  TabNavigateIcon.Column:=3;
  TabNavigateIcon.ShowTerm:=8000;

  HideOnApplicationMinimize:=False;

  MainWnd.MenuOpenURLOnMouseOver.Checked := ImageViewConfig.OpenURLOnMouseOver;

  PopUpHint := MainWnd.PopupHint;

  //�A�N�Z�����[�^�[�𖳌��ɂ���A�炵��
  Application.HookMainWindow(hook);

  //�e���|�����f�B���N�g�����`�F�b�N���āA�t�@�C����f�B���N�g��������΍폜
  if ImageViewConfig.DeleteTmpOnStartUp then DeleteTemporaryDirectry(True);

  Font:=MainWnd.Font;

  DisableTitlebar(ImageViewConfig.DisableTitleBar);

end;


//SUSIE�v���O�C���ǂݍ��ݏ��O(JPEG��)
procedure TImageForm.SPIsPictureRegister(Sender: TObject; ASPI: TInSPI;
  const AExtension, ADescription: String;
  var AGraphicClass: TGraphicClass);
begin
  if (LowerCase(AExtension) = 'jpg') or (LowerCase(AExtension) = 'jpeg')
     or (LowerCase(AExtension) = 'png')   //aiai
  then begin
    AGraphicClass := nil;
  end;
  if AExtension = '*' then begin
    AGraphicClass := nil;
  end;
end;


//���C���E�B���h�E�̉A�ɉB��Ȃ��ݒ�
//WriteForm�Ɠ�������(fsStayOnTop)�ɂ���Ǝ������̓��m�łԂ��������ߋ���̍�
procedure TImageForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := MainWnd.Handle;
end;


//Form�̔j��
procedure TImageForm.FormDestroy(Sender: TObject);
var
  i:Integer;
begin
  if Assigned(TabNavigateIcon) then
    FreeAndNil(TabNavigateIcon);  //aiai

  //�e���|�����f�B���N�g�����`�F�b�N���āA�f�B���N�g��������΍폜
  if ImageViewConfig.DeleteTmpOnStartUp then DeleteTemporaryDirectry(False);

  Application.UnhookMainWindow(Hook);

  for i:=ImagePageControl.PageCount-1 downto 0 do ImagePageControl.Pages[i].Free;

  HttpManager.Free;

  ImageViewConfig.Top:=Top;
  ImageViewConfig.Left:=Left;
  ImageViewConfig.Height:=Height;
  if 0 < savedHeight then ImageViewConfig.Height := savedHeight;
  ImageViewConfig.Width:=Width;
  if 0 < savedWidth then ImageViewConfig.Width := savedWidth;

  ImagePageControl.OnResize:=nil; //�j�����AccesViolation�΍�

end;



//�ǂݍ��ݎ�t���[�`��
function TImageForm.GetImage(URL:string; ViewItem:TBaseViewItem=nil; CallFrom:TTabSheet=nil; ForceOpen:Boolean=False):Boolean;
var
  i:Integer;
  ImagePage:TWebLoaderSheet;
  OpenExtentExchangeKey ,ProtectKey:Integer;
  ModifiedURL: string;
  RefererThread:string;
  RefToSend: string;
  CacheHeader: TStringList;
  OffLine: Boolean;
begin
  if ImageViewConfig.DisableImageViewer then begin
    Result := False;
    Exit;
  end;

  if ImageViewConfig.SwapCtrlShift then begin
    OpenExtentExchangeKey:=VK_SHIFT;
    ProtectKey:=VK_CONTROL;
  end else begin
    OpenExtentExchangeKey:=VK_CONTROL;
    ProtectKey:=VK_SHIFT;
  end;

  if (CompareText(ExtractFileExt(URL), '.vch') = 0) and FileExists(URL) then begin
    OffLine := True;
    CacheHeader := TStringList.Create;
    HttpManager.ReadCache(URL, nil, CacheHeader);
    URL := CacheHeader.Values['URL'];
    CacheHeader.Free;
    if URL = '' then begin
      Result := False;
      Exit;
    end;
  end else begin
    OffLine := False;
  end;

  ModifiedURL:=ProofUrlwithRef(URL, RefToSend, False);

  if MainWnd.NavigateIntoView(ModifiedURL,gtOther) then begin
    Result := True;
    Exit;
  end;

  //CallFrom���ݒ肳��Ă���Ƃ���View�ǂݍ��݋���
  if (CallFrom = nil) and not(ForceOpen) then
    if not ImageViewConfig.ExamFileExt(ModifiedURL) and not(ImageViewConfig.ForceToUseViewer) then begin
      if GetKeyState(OpenExtentExchangeKey)>=0 then begin
        Result:=False;
        Exit;
      end;
    end else begin
      if GetKeyState(OpenExtentExchangeKey)<0 then begin
        Result:=False;
        Exit;
      end;
    end;

  Result:=True;

  for i:=0 to ImagePageControl.PageCount-1 do begin
    if ModifiedURL=TWebLoaderSheet(ImagePageControl.Pages[i]).URI then begin
      ImagePageControl.CanChange;
      ImagePageControl.ActivePage := ImagePageControl.Pages[i];
      ImagePageControl.TerminateSelectionState;
      ImagePageControl.Change;
      ImagePageControl.UpdateStatusBar;
      if not(ImageViewConfig.HiddenMode) or ImageViewConfig.ActivateViewerIfURLHasLoaded then
        Show;
      if Visible and (WindowState = wsMinimized) then
        WindowState := wsNormal;
      if not ImageViewConfig.ActivateViewerIfURLHasLoaded then
        MainWnd.SetFocus;
      Exit;
    end;
  end;

  if not(Visible or ImageViewConfig.HiddenMode) then
    Show;

  if Visible and (WindowState = wsMinimized) then
    WindowState := wsNormal;

  RefererThread := '';
  if assigned(ViewItem) and assigned(ViewItem.thread) then
    RefererThread := ViewItem.thread.ToURL;

  ImagePage := TWebLoaderSheet.CreatePage(ImagePageControl);
  ImagePage.PopupMenu:=ImageForm.ImagePopUpMenu;
  if (GetKeyState(ProtectKey) < 0) or ImageViewConfig.AlwaysProtect then
    ImagePage.Protect:=True;
  if ImagePage.OpenURL(ModifiedURL, URL, RefererThread, RefToSend, OffLine) then begin
    if Visible then SetFocus;
  end else if CallFrom = nil then
    MainWnd.SetFocus;

  ImagePageControl.CanChange;
  ImagePage.PageControl := ImagePageControl;
  ImagePageControl.ActivePage := ImagePage;
  if Assigned(CallFrom) and (CallFrom.PageControl = ImagePageControl) then
    ImagePage.PageIndex := CallFrom.PageIndex + 1;  //�r���[�A����Ă΂ꂽURL�͌Ăяo���y�[�W�̎��ɑ}��
  ImagePageControl.TerminateSelectionState;
  ImagePageControl.Change;

end;


//ImagePageControl�ŃA�N�e�B�u�^�u�����[�ɓ��B
procedure TImageForm.PageControlOnEdge(Sender:TObject ;GoForward:Boolean);
begin
  if ImageViewConfig.ConnectedTabEdge and (ImagePageControl.PageCount > 1) then
    if ImagePageControl.CanChange then begin
      if GoForward then
        ImagePageControl.ActivePageIndex := 0
      else
        ImagePageControl.ActivePageIndex := ImagePageControl.PageCount - 1;
      ImagePageControl.Change;
    end;
end;


//�X�e�[�^�X�o�[�T�C�Y�ύX
procedure TImageForm.StatusBarResize(Sender: TObject);
begin
  TStatusBar(Sender).Panels[0].Width:=TStatusBar(Sender).Width-180;
end;


//�^�u��I��/����
procedure TImageForm.HilightTab(Sender: TObject);
var
  ActivePage:TImageTabSheet;
begin
  ActivePage:=TImageTabSheet(ActivePageControl.ActivePage);
  if Assigned(ActivePage) then
    if  (ImageViewConfig.ExamArchiveType(ActivePage.URI)=atNone) or not(ImageViewConfig.ContinuousTabChange) then begin
      TImagePageControl(ActivePageControl).Highlighten(ActivePageControl.ActivePageIndex,not ActivePage.Highlighted);
      ActivePage.Tag:=Integer(ActivePage.Highlighted);
    end;
  OnHighlightChange(Sender);
end;


//�S�đI��
procedure TImageForm.HighlightAll(Sender: TObject);
var
  i:Integer;
  TabSheet:TImageTabSheet;
begin
  for i:=0 to TImageTabSheet.TabCount-1 do begin
    TabSheet:=TImageTabSheet(TImageTabSheet.TabSheet(i));
    if TabSheet is TArchiveTabSheet then begin
      if ImageViewConfig.ContinuousTabChange then
        TabSheet.Highlighted:=True
      else
        case ImageViewConfig.TabSelectAllType of
          tsARCHIVE       :TabSheet.Highlighted:=False;
          tsIGNORE        :TabSheet.Highlighted:=False;
          tsEXTRACTEDIMAGE:TabSheet.Highlighted:=True;
        end;
    end else if ImageViewConfig.ExamArchiveType(TabSheet.URI)<>atNone then begin
      if ImageViewConfig.ContinuousTabChange then
        TabSheet.Highlighted:=False
      else
        case ImageViewConfig.TabSelectAllType of
          tsARCHIVE       :TabSheet.Highlighted:=True;
          tsIGNORE        :TabSheet.Highlighted:=False;
          tsEXTRACTEDIMAGE:TabSheet.Highlighted:=False;
        end;

    end else begin
      TabSheet.Highlighted:=True;
    end;
    TabSheet.Tag:=Integer(TabSheet.Highlighted);
  end;
  if Sender<>miSaveAllImage then OnHighlightChange(Sender);
end;


//�S�đI������
procedure TImageForm.LowlightAll(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to TImageTabSheet.TabCount-1 do
    TImageTabSheet.TabSheet(i).Highlighted:=False;
  ImagePageControl.TerminateSelectionState;
end;


//��̏��ɓ��S�āA�܂��͔񏑌ɉ摜�S�Ă�I��
//�񏑌ɉ摜�̑I���ŁA���Ƀt�@�C�����I������邩�͐ݒ�ɂ��
procedure TImageForm.HighlightThisRegion(Sender: TObject);
var
  PageControl:TPageControl;
  TabSheet:TImageTabSheet;
  i:Integer;
begin
  PageControl:=ActivePageControl;
  for i:=0 to PageControl.PageCount-1 do begin
    TabSheet:=TImageTabSheet(PageControl.Pages[i]);
    if (ImageViewConfig.ExamArchiveType(TabSheet.URI)=atNone) or
       (not(ImageViewConfig.ContinuousTabChange) and (ImageViewConfig.TabSelectAllType=tsARCHIVE)) then begin
      TabSheet.Highlighted:=True;
      TabSheet.Tag:=Integer(TabSheet.Highlighted);
    end;
  end;
  OnHighlightChange(Sender);
end;

//��̏��ɓ��S�āA�܂��͔񏑌ɉ摜�S�Ă�I������
procedure TImageForm.UnHighlightThisRegion(Sender: TObject);
var
  PageControl:TPageControl;
  i:Integer;
begin
  PageControl:=ActivePageControl;
  for i:=0 to PageControl.PageCount-1 do begin
    PageControl.Pages[i].Highlighted:=False;
    PageControl.Pages[i].Tag:=Integer(False);
  end;
end;


//�A�N�e�B�u�^�u���폜(PageControl�ėp)
procedure TImageForm.CloseTab(Sender: TObject);
var
  PageControl:TPageControl;
begin
  if (Sender=miArchiveInfoCloseTab) or (Sender=miCloseArchive) then
    PageControl:=ImagePageControl
  else
    PageControl:=ActivePageControl;
  if Assigned(PageControl.ActivePage) then
    TImageTabSheet(PageControl.ActivePage).RequestClose;//�^�u������Ă΂��̂�Free���g��Ȃ�
end;


//�G���[�̃^�u�����(ImagePageControl����)
procedure TImageForm.CloseErrorTab(Sender: TObject);
var
  ActivePage,tmpPage:TWebLoaderSheet;
  i:Integer;
begin
  if Assigned(ImagePageControl.ActivePage) then begin
    ActivePage:=TWebLoaderSheet(ImagePageControl.ActivePage);
    ImagePageControl.ActivePage:=nil; //�A�N�e�B�u�̂܂܍폜����ƃC���[�W�^�u�������
    if ActivePage.PageStatus in [htERROR,htCONTENTERROR] then ActivePage:=nil;//�A�N�e�B�u���G���[�Ȃ�đI�����Ȃ�

    for i:=ImagePageControl.PageCount-1 downto 0 do begin
      tmpPage:=TWebLoaderSheet(ImagePageControl.Pages[i]);
      if tmpPage.PageStatus in [htERROR,htCONTENTERROR] then FreeAndNil(tmpPage);
    end;

    if ImagePageControl.PageCount>0 then begin
      if Assigned(ActivePage) then
        ImagePageControl.ActivePage:=ActivePage
      else
        ImagePageControl.ActivePage:=nil;
    end;
    ImagePageControl.UpdateStatusBar;
    ImagePageControl.CheckTabExist;
  end;

end;


//�S�Ẵ^�u�����(ImagePageControl����)
procedure TImageForm.CloseAllTab(Sender: TObject);
var
  i:Integer;
begin
  Hide;
  for i:=0 to ImagePageControl.PageCount-1 do
    TImageTabSheet(ImagePageControl.Pages[0]).Free;
end;


//�u���E�U�ŊJ��
procedure TImageForm.OpenWithBrowser(Sender: TObject);
begin
  if Assigned(ImagePageControl.ActivePage) then
    MainWnd.OpenByBrowser(TWebLoaderSheet(ImagePageControl.ActivePage).URI);
end;


//�֘A�Â��A�r���[�A�ȂǂŃ��[�J���ɊJ��
procedure TImageForm.OpenWithMisc(Sender: TObject);
var
  ActivePage:TImageTabSheet;
begin
  if (Sender=miOpenArchiveWithRelation) or (Sender=miArchiveInfoOpenWithMisc) then
    ActivePage:=TImageTabSheet(ImagePageControl.ActivePage)
  else
    ActivePage:=TImageTabSheet(ActivePageControl.ActivePage);

  if Assigned(ActivePage) then
    if Sender=miOpenWithViewer then
      ActivePage.OpenWithExternalResource(True)
    else
      ActivePage.OpenWithExternalResource(False);
end;


//�Q�ƌ��̃X���b�h���J��
procedure TImageForm.OpenRefererThread(Sender: TObject);
var
  URL:String;
begin

  if ImagePageControl.ActivePage is TWebLoaderSheet then begin
    URL:=TWebLoaderSheet(ImagePageControl.ActivePage).RefererThread;
    if URL<>'' then MainWnd.NavigateIntoView(URL,gtMenu);
  end;

end;


//���ɏ��̕\��
procedure TImageForm.ShowContentInfo(Sender: TObject);
var
  PageControl:TPageControl;
begin
  PageControl:=ActivePageControl;
  if PageControl is TArchivePageControl then PageControl.ActivePage:=nil;
end;


//�摜���E�B���h�E�ɍ��킹��ݒ�̐؂�ւ�
procedure TImageForm.FlipAdjustToWindow(Sender: TObject);
begin
  if Assigned(ActivePageControl.ActivePage) then
    TImageTabSheet(ActivePageControl.ActivePage).AdjustToWindow:=not(TImageTabSheet(ActivePageControl.ActivePage).AdjustToWindow);
  TImagePageControl(ActivePageControl).UpdateStatusBar;
end;

//�C���[�W�̕ۑ�(PageControl�ėp)(���ۂ̕ۑ��̓^�u�V�[�g���s��)
procedure TImageForm.SaveImage(Sender: TObject);
var
  ActivePage: TImageTabSheet;
  SaveModeFlag: TSaveModeFlag;
  Path: String;
  i: Integer;
  Mode: TPageToOperation;
begin

  Path := '';
  if Sender is TQuickSaveMenuItem then
    Path := IncludeTrailingPathDelimiter(Copy(ImageViewConfig.QuickSavePoint[TMenuItem(Sender).Tag],
          LastDelimiter('/',ImageViewConfig.QuickSavePoint[TMenuItem(Sender).Tag]) + 1, 65535));

  SaveModeFlag := smNotDefine;

  if (Sender = TabNavigateIcon) or (Sender = miSaveAllImage) then begin
    Mode := poMarkedPage
  end else if ((Sender is TQuickSaveMenuItem) and (TMenuItem(Sender).Parent = QuickSavePopup.Items)
              and (QuickSavePopup.PopupComponent = TabNavigateIcon)) then begin
    Mode := poMarkedPage
  end else begin
    Mode := GetPageToOperation('�}�[�N���ꂽ�摜/���ɂ�ۑ����܂����H');
  end;

  case Mode of
    poMarkedPage:begin
      for i:=0 to TImageTabSheet.TabCount - 1 do begin
        ActivePage := TImageTabSheet(TImageTabSheet.TabSheet(i));
        if ActivePage.Highlighted and (ActivePage.PageStatus = htCOMPLETED) then begin
          if Path = '' then begin
            if ActivePage.QuerySaveImage then
              Path:=ExtractFilePath(SavePictureDialog.FileName)
              else
              Break;
          end else begin
            if not ActivePage.SaveImage(Path,SaveModeFlag) then
              Break;
          end;
        end;
      end;
      if Sender<>miSaveAllImage then OnHighlightChange(nil);
    end;
    poThisPage:begin
      //�\�����̉摜�̕ۑ�
      if (Sender=miSaveArcive) or (Sender=miArchiveInfoSaveArchive) then
        ActivePage:=TImageTabSheet(ImagePageControl.ActivePage)
      else
        ActivePage:=TImageTabSheet(ActivePageControl.ActivePage);
      if Assigned(ActivePage) then begin
        if Path='' then
          ActivePage.QuerySaveImage
        else
          ActivePage.SaveImage(Path, SaveModeFlag);
      end;
    end;
    poCancel:;
  end;
end;



//�}�[�N���ꂽ�^�u������ꍇ�A�A�N�e�B�u�y�[�W�ƃ}�[�N�y�[�W���瑀��Ώۂ�I��
function TImageForm.GetPageToOperation(Prompt: String): TPageToOperation;
var
  DialogResult: Integer;
  HighlightCount: Integer;
begin
  HighlightCount := TImageTabSheet.HighlightCount;
  if HighlightCount > 0 then begin
    if not(ImageViewConfig.ShowDialogToSaveHighlightTab) then begin
      Result := poMarkedPage
    end else begin
      DialogResult := MessageDlg(IntToStr(HighlightCount)
                    +'�̃}�[�N���ꂽ�摜/���ɂ�����܂��B'#13#10
                    + Prompt + #13#10'(�������̏ꍇ�͕\�����̉摜/���ɂ��Ώ�)',
                    mtConfirmation,mbYesNoCancel,0);
      case DialogResult of
         mrYes   : Result := poMarkedPage;
         mrNo    : Result := poThisPage;
      else
        Result := poCancel;
      end;
    end;
  end else begin
    Result := poThisPage;
  end;
end;


//�S�ĕۑ�
procedure TImageForm.SaveAllImage(Sender: TObject);
begin
  HighlightAll(Sender);
  SaveImage(Sender);
  LowlightAll(Sender);
end;


//���U�C�N����
procedure TImageForm.ToggleProtect(Sender: TObject);
var
  ActivePage:TWebLoaderSheet;
begin
  ActivePage:=TWebLoaderSheet(ActivePageControl.ActivePage);
  ActivePage.Protect:=not(ActivePage.Protect);
end;


//�u���N���o�^
procedure TImageForm.RegisterBrowserCrasher(Sender: TObject);
var
  i: Integer;
begin
  case GetPageToOperation('�}�[�N���ꂽ�摜/���ɂ��u���N���o�^���܂����H') of
    poThisPage: begin
      if Assigned(ImagePageControl.ActivePage) then
        TWebLoaderSheet(ImagePageControl.ActivePage).RegisterBrowserCrasher;
    end;
    poMarkedPage: begin
      ImagePageControl.Hide;
      TImageTabSheet.SetMultipleDelete(True);
      for i := TImageTabSheet.TabCount - 1 downto 0 do begin
        if TImageTabSheet.TabSheet(i) is TWebLoaderSheet and TImageTabSheet.TabSheet(i).Highlighted then begin
          TWebLoaderSheet(TImageTabSheet.TabSheet(i)).RegisterBrowserCrasher;
          TImageTabSheet.ExecuteRequestClose;
        end;
      end;
      TImageTabSheet.SetMultipleDelete(False);
      ImagePageControl.Show;
      ImagePageControl.SetFocus;
      If ImagePageControl.ActivePage <> nil then
        TImageTabSheet(ImagePageControl.ActivePage).ActContentView;
    end;
  end;
end;


//�L���b�V���ۑ��A�폜
procedure TImageForm.CacheControl(Sender: TObject);
const
  Prompt: Array[Boolean] of String =
         ('�}�[�N���ꂽ�摜/���ɂ��L���b�V�����܂����H',
          '�}�[�N���ꂽ�摜/���ɂ��L���b�V������폜���܂����H');
var
  DeleteMode: Boolean;
  i: Integer;
begin

  DeleteMode := (Sender = miDeleteCache);


  case GetPageToOperation(Prompt[DeleteMode]) of
    poThisPage: begin
      if Assigned(ImagePageControl.ActivePage) then
        TWebLoaderSheet(ImagePageControl.ActivePage).CacheControl(DeleteMode);
    end;
    poMarkedPage: begin
      for i := TImageTabSheet.TabCount - 1 downto 0 do
        if TImageTabSheet.TabSheet(i) is TWebLoaderSheet and TImageTabSheet.TabSheet(i).Highlighted then
          TWebLoaderSheet(TImageTabSheet.TabSheet(i)).CacheControl(DeleteMode);
    end;
  end;
end;


//�����[�h(ImagePageControl����)
procedure TImageForm.RelodadImage(Sender: TObject);
var
  ActivePage:TWebLoaderSheet;
begin
  ActivePage:=TWebLoaderSheet(ImagePageControl.ActivePage);
  if Assigned(ActivePage) then
    ActivePage.ReloadImage(GetKeyState(VK_SHIFT) < 0);
end;


//�R���e���c�̍ăf�R�[�h(���ɂ̍ēW�J�Ɏg�p)
procedure TImageForm.DecodeContent(Sender: TObject);
var
  ActivePage:TImageTabSheet;
begin
  ActivePage:=TImageTabSheet(ImagePageControl.ActivePage);
  if Assigned(ActivePage) then
    ActivePage.DecodeContent;
end;


//�^�C�g���o�[�̕\���A��\����ύX
procedure TImageForm.DisableTitlebar(Value: Boolean);
begin
  if Value then begin
    SetWindowLong(Handle, GWL_STYLE, (GetWindowLong(Handle,GWL_STYLE) and not(WS_CAPTION)));
    DummyTitlebar.Height:=0;
    DummyTitlebar.Visible:=False;
  end else begin
    SetWindowLong(Handle, GWL_STYLE, (GetWindowLong(Handle,GWL_STYLE) or WS_CAPTION));
    DummyTitlebar.Height:=6;
  end;
  SetWindowPos(Handle, 0, 0, 0, 0, 0, 0
               or SWP_FRAMECHANGED
               or SWP_NOACTIVATE
               or SWP_NOMOVE
               or SWP_NOOWNERZORDER
               or SWP_NOSIZE
               or SWP_NOZORDER);
end;


//�t�H�[�J�X���Ȃ����͍ŏ���
procedure TImageForm.FormDeactivate(Sender: TObject);
const
  TabBorderRevision = 8;
begin
  if (WindowState<>wsMinimized) and ImageViewConfig.EnableFolding then begin
    savedLeft := Left;
    savedTop  := Top;
    savedWidth:= Width;
    savedHeight:= Height;
    if ImageViewConfig.KeepTabVisible and not(ImageViewConfig.InvisibleTab) then begin
      SetWindowLong(Handle, GWL_STYLE, (GetWindowLong(Handle,GWL_STYLE) and not(WS_CAPTION)));
      if not ImageViewConfig.DisableTitleBar then
        DummyTitlebar.Visible:=True;
      Height := ImagePageControl.Top + ImagePageControl.TabHeight + TabBorderRevision + 2 * BorderWidth ;
      StatusBar.Visible:=False;
    end else begin
      ClientHeight := 0;
    end;
  end;
end;


//�ŏ��������ɖ߂�
procedure TImageForm.FormActivate(Sender: TObject);
begin
  StatusBar.Visible:=True;

  //�|�b�v�A�b�v���o�Ă�����B��
  PopupHint.ReleaseHandle;

  //��A�N�e�B�u���̓t�H�[�J�X�ړ����֎~���Ă���̂ŁA
  //�t�H�[�J�X�𐳂����ꏊ�Ɉړ�������
  if Assigned(ImagePageControl.ActivePage) then
    TImageTabSheet(ImagePageControl.ActivePage).ActContentView;

  DummyTitlebar.Visible:=False;
  if not ImageViewConfig.DisableTitleBar then
    SetWindowLong(Handle, GWL_STYLE, (GetWindowLong(Handle,GWL_STYLE) or WS_CAPTION));

  if 0 < savedWidth then begin
    Width := savedWidth;
    savedWidth:=0;
  end;
  if 0 < savedHeight then begin
    Height := savedHeight;
    savedHeight:=0;

  end;

  if assigned(ImagePageControl.ActivePage) then

    StatusBar.Panels[1].Text:=TWebLoaderSheet(ImagePageControl.ActivePage).StatusText;

end;


//�_�~�[�^�C�g���o�[��̃V�X�e���{�^���������ꂽ��A�ʒu���L�����ă}�E�X�L���v�`��
procedure TImageForm.btnDummyTitlebarSystemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Mouse.Capture := TButton(Sender).Handle;
  ClickDummyTitlebarCloseAt.X:=Mouse.CursorPos.X;
  ClickDummyTitlebarCloseAt.Y:=Mouse.CursorPos.Y;
end;

//����{�^�����������ʒu�Ń}�E�X�������ꂽ�����
//�E�B���h�E���A�N�e�B�u�ȏ�Ԃ̂Ƃ����̃{�^���͌����Ȃ��̂ŁA
//�����ɔ��ł���Ƃ��͕K���}�E�X�L���v�`����ԂŁA���O�̃N���b�N�ʒu���L������Ă���

procedure TImageForm.btnDummyTitlebarSystemMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  if (Mouse.CursorPos.X = ClickDummyTitlebarCloseAt.X) and
     (Mouse.CursorPos.Y = ClickDummyTitlebarCloseAt.Y)
  then begin
    if Sender = btnDummyTitlebarMinimize then WindowState:=wsMinimized;
    if Sender = btnDummyTitlebarMaximize then WindowState:=wsMaximized;
    if Sender = btnDummyTitlebarClose then Close;
  end;
end;


//�t�H�[�����B��
procedure TImageForm.HideWindow(Sender: TObject);
begin
  Hide;
end;


//�A�v���ŏ������Ɏ������B��(Main.pas��TMainWnd.OnAboutToShow�Q��)
procedure TImageForm.MainWndOnHide;
begin
  if Visible then begin
    HideOnApplicationMinimize:=True;
    Hide;
  end;
end;


//�A�v���������ɕK�v�Ȃ畜��(Main.pas��TMainWnd.OnAboutToShow�Q��)
procedure TImageForm.MainWndOnShow;
begin
  if HideOnApplicationMinimize then Self.Show;
  HideOnApplicationMinimize:=False;

end;


//�t�H�[����(�G�b�W����)�Ƀ}�E�X��������|�b�v�A�b�v�q���g������
procedure TImageForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  MainWnd.PopupHint.ReleaseHandle;
end;



//�t�H�[�����B����鎞�A�R���g���[����������Ă�����S�Ẵ^�u�����
procedure TImageForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i:Integer;
begin
  CanClose:=True;
  if HideOnApplicationMinimize then Exit;

  if (ImagePageControl.PageCount>0) and ((GetKeyState(VK_CONTROL)<0) xor ImageViewConfig.CloseAllTabIfFormClosed) then begin
    ImagePageControl.Hide;
    for i:=0 to ImagePageControl.PageCount-1 do
      TImageTabSheet(ImagePageControl.Pages[0]).Free;
    ImagePageControl.Show;
    if ImagePageControl.PageCount>0 then CanClose:=False;
  end;
end;


//�n�C���C�g�i���ꂽ�b����Ă��Ȃ��j�^�u�����
procedure TImageForm.CloseHilightTab(Sender: TObject);
var
  i:Integer;
  TabSheet:TTabSheet;
  DelHilight:Boolean;
begin
  if (Sender=miCloseHilightTab) or (Sender=TabNavigateIcon) then
    DelHilight:=True
  else if Sender=miCloseUnHilightTab then
    DelHilight:=False
  else
    raise Exception.Create('�Ăяo���G���[');

  ImagePageControl.Hide;
  TImageTabSheet.SetMultipleDelete(True);
  for i:=TImageTabSheet.TabCount-1 downto 0 do begin
    TabSheet:=TImageTabSheet.TabSheet(i);
    //��n�C���C�g�^�u�̍폜�ł͏��ɍ폜��CheckTabExist����
    if Assigned(TabSheet) and (TabSheet.Highlighted=DelHilight) and
             (DelHilight or (ImageViewConfig.ExamArchiveType(TImageTabSheet(TabSheet).URI)=atNone)) then begin
      if TabSheet is TArchiveTabSheet then begin
        FreeImageTabSheet(TabSheet);
        TImageTabSheet.ExecuteRequestClose;//FreeImageTabSheet�ŏ��Ƀ^�u��RequestClose���o��ꍇ����
      end else begin
        FreeImageTabSheet(TabSheet);
      end;
    end;
  end;
  TImageTabSheet.SetMultipleDelete(False);
  ImagePageControl.Show;
  ImagePageControl.SetFocus;
  If ImagePageControl.ActivePage <> nil then
    TImageTabSheet(ImagePageControl.ActivePage).ActContentView;
end;


//�|�b�v�A�b�v���J������
procedure TImageForm.ImagePopUpMenuPopup(Sender: TObject);
var
  FullMenu: Boolean;
begin

  FullMenu := (GetKeyState(VK_CONTROL) < 0);

  miEnableFolding.Checked:=ImageViewConfig.EnableFolding;

  if Assigned(ImagePageControl.ActivePage) then begin
    if ((TImageTabSheet(ImagePageControl.ActivePage).PageStatus = htERROR)
                 or TWebLoaderSheet(ImagePageControl.ActivePage).FromCache) then
      miReloadImage.Enabled:=True
    else
      miReloadImage.Enabled:=False;

    if TWebLoaderSheet(ImagePageControl.ActivePage).CacheExists then begin
      miDeleteCache.Enabled := True;
      miWriteCache.Enabled := False;
    end else begin
      miDeleteCache.Enabled := False;
      miWriteCache.Enabled := True;
    end;
  end;

  if ActivePageControl is TArchivePageControl then begin

    if Assigned(ActivePageControl.ActivePage) and
               TImageTabSheet(ActivePageControl.ActivePage).Protect then begin
      miToggleProtect.Visible:=not Boolean(miToggleProtect.Tag);
      miToggleProtect.Enabled:=True;
    end else begin
      miToggleProtect.Visible:=False;
      miToggleProtect.Enabled:=False;
    end;

    miCacheControlMenu.Visible := False; miCacheControlMenu.Enabled := False;

    miSaveArcive.Visible:=not Boolean(miSaveArcive.Tag) or FullMenu;
    miSaveArcive.Enabled:=True;

    miCloseArchive.Visible:=not Boolean(miCloseArchive.Tag) or FullMenu;
    miCloseArchive.Enabled:=True;

    miCloseErrorTab.Visible:=False;
    miCloseErrorTab.Enabled:=False;

    miOpenWithBrowser.Visible:=False;
    miOpenWithBrowser.Enabled:=False;

    miShowContentInfo.Visible:=not Boolean(miShowContentInfo.Tag);
    miShowContentInfo.Enabled:=True;

    miOpenArchiveWithRelation.Visible := not Boolean(miOpenArchiveWithRelation.Tag) or FullMenu;

    miReloadImage.Caption := '���ɂ̍ēǍ�(&R)';
    miReopenArchive.Visible := not Boolean(miReopenArchive.Tag) or FullMenu;
    miReopenArchive.Enabled := True;

    miSavePicture.Caption:='���̉摜�𒊏o���ĕۑ�(&S)';
    miSavePicture.Enabled:=True;
    miQuickSave.Enabled:=True;

    miOpenWithViewer.Visible:=not Boolean(miOpenWithViewer.Tag) or FullMenu;
    miOpenWithViewer.Enabled:=True;
    miOpenWithRelation.Visible:=not Boolean(miOpenWithRelation.Tag) or FullMenu;
    miOpenWithRelation.Enabled:=True;

  end else if ActivePageControl is TRootPageControl then begin

    if ImageViewConfig.UseViewCache then begin
      miCacheControlMenu.Visible := not Boolean(miCacheControlMenu.Tag) or FullMenu;
      miCacheControlMenu.Enabled := True;
    end else begin
      miCacheControlMenu.Visible := False;
      miCacheControlMenu.Enabled := False;
    end;

    miSaveArcive.Visible:=False;      miSaveArcive.Enabled:=False;
    miCloseArchive.Visible:=False;    miCloseArchive.Enabled:=False;
    miCloseErrorTab.Visible:=True;    miCloseErrorTab.Enabled:=True;

    miReloadImage.Caption:='�ēǍ�(&R)';
    miReopenArchive.Visible := False; miReopenArchive.Enabled := False;

    miSavePicture.Caption:='���O��t���ĕۑ�(&S)';

    miOpenWithBrowser.Visible := not Boolean(miOpenWithBrowser.Tag) or FullMenu;
    miOpenWithBrowser.Enabled := True;

    miShowContentInfo.Visible := False; miShowContentInfo.Enabled := False;
    miOpenArchiveWithRelation.Visible := False;    miOpenArchiveWithRelation.Enabled := False;

    //�ۑ��A�֘A�Â��ȂǂŊJ����������̂͊����܂��̓R���e���g�G���[�̃^�u�̂�
    if Assigned(ImagePageControl.ActivePage) and
          (TImageTabSheet(ImagePageControl.ActivePage).PageStatus in [htCOMPLETED, htCONTENTERROR]) then begin
      if TImageTabSheet(ImagePageControl.ActivePage).Protect then begin
        miToggleProtect.Visible:=not Boolean(miToggleProtect.Tag) or FullMenu;
        miToggleProtect.Enabled:=True;
      end else begin
        miToggleProtect.Visible:=False;
        miToggleProtect.Enabled:=False;
      end;

      miSavePicture.Enabled := True;
      miQuickSave.Enabled:=True;

      miOpenWithViewer.Visible := not Boolean(miOpenWithViewer.Tag) or FullMenu;
      miOpenWithViewer.Enabled := True;
      miOpenWithRelation.Visible:=not Boolean(miOpenWithRelation.Tag) or FullMenu;
      miOpenWithRelation.Enabled:=True;

    end else begin
      miToggleProtect.Visible:=False;      miToggleProtect.Enabled:=False;
      miSavePicture.Enabled:=False;
      miQuickSave.Enabled:=False;
      miOpenWithViewer.Visible:=False;     miOpenWithViewer.Enabled:=False;
      miOpenWithRelation.Visible:=False;   miOpenWithRelation.Enabled:=False;
    end;
  end;

  miAdjustToWindow.Checked:=TImageTabSheet(ActivePageControl.ActivePage).AdjustToWindow;

end;

//�ȈՕۑ��̂��߂̃��j���[����
procedure TImageForm.MakeQuickSaveMenu;
var
  MenuItem,MenuItem2:TMenuItem;
  Delimiter:Integer;
  i:Integer;
begin
  for i:=0 to miQuickSave.Count-1 do miQuickSave.Items[0].Free;
  for i:=0 to QuickSavePopup.Items.Count-1 do QuickSavePopup.Items[0].Free;
  if ImageViewConfig.QuickSavePoint.Count=0 then begin
    miQuickSave.Visible:=False;
  end else begin
    miQuickSave.Visible:=True;
    for i:=0 to ImageViewConfig.QuickSavePoint.Count-1 do begin
      Delimiter:=LastDelimiter('/',ImageViewConfig.QuickSavePoint[i]);
      MenuItem:=TQuickSaveMenuItem.Create(Self);
      MenuItem2:=TQuickSaveMenuItem.Create(Self);
      MenuItem.Caption:=copy(ImageViewConfig.QuickSavePoint[i],1,Delimiter-1);
      MenuItem2.Caption:=copy(ImageViewConfig.QuickSavePoint[i],1,Delimiter-1);
      if i<10 then begin
        MenuItem.ShortCut:=ShortCut(VK_NUMPAD0+i,[ssCtrl]);
        MenuItem2.ShortCut:=ShortCut(VK_NUMPAD0+i,[ssCtrl]);//�_�~�[
      end;
      MenuItem.Tag:=i;
      MenuItem2.Tag:=i;
      MenuItem.OnClick:=SaveImage;
      MenuItem2.OnClick:=SaveImage;
      miQuickSave.Add(MenuItem);
      QuickSavePopup.Items.Add(MenuItem2);
    end;
  end;
end;


//�n�C���C�g�ɕύX�����������̓i�r�A�C�R����\��
procedure TImageForm.OnHighlightChange(Sender:TObject);
begin

  if not ImageViewConfig.UseTabNavigateIcon then Exit;

  if TImageTabSheet.HighlightCount>0 then
    TabNavigateIcon.PopUp(Mouse.CursorPos,(Sender=nil)) //nil�͑O�Ɉ�x�\������Ă���ꍇ�B�A�C�R�����ړ����Ȃ�
  else
    TabNavigateIcon.Hide;
end;


//�i�r�A�C�R�����N���b�N���ꂽ�ꍇ�̏���
procedure TImageForm.NaviIconClick(Sender:TObject);
begin
  case TabNavigateIcon.Index of
    0:LowlightAll(Sender);
    1:SaveImage(Sender);
    2:begin
      QuickSavePopup.PopupComponent:=TComponent(Sender);
      QuickSavePopup.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
    end;
    3:CloseHilightTab(Sender);
  end;
end;


//Deactive���̓���(�܂肽���݂���Ȃ�)�؂�ւ�
procedure TImageForm.miEnableFoldingClick(Sender: TObject);
begin
  ImageViewConfig.EnableFolding:=not(ImageViewConfig.EnableFolding);
  if miEnableFolding.Checked then begin
    savedWidth:=0;
    savedHeight:=0;
  end;
end;


//�v���t�@�����X�_�C�A���O���J��
procedure TImageForm.OpenPreference(Sender: TObject);
var
  tmpShrinkType:TShrinkType;
  i:Integer;
begin
  ArchiverManager.ModalDialogAppear:=True;
  try
    tmpShrinkType:=ImageViewConfig.ShrinkType;
    if ImageViewConfig.OpenPreference(Self) then begin
      miEnableFolding.Checked:=ImageViewConfig.EnableFolding;
      if tmpShrinkType<>ImageViewConfig.ShrinkType then
        for i:=0 to ImagePageControl.PageCount-1 do
          TWebLoaderSheet(ImagePageControl.Pages[i]).HideContentView;
      TImagePageControl.SetTabStyle(ImageViewConfig.TabStyle);
      //�^�u�X�^�C���̕ύX�Ńn�C���C�g���������悤�Ɍ����錻�ۂ̑΍�
      for i:=0 to TImageTabSheet.TabCount-1 do
        TImageTabSheet.TabSheet(i).Highlighted:=TImageTabSheet.TabSheet(i).Highlighted;
      TImagePageControl.SetMultiLine(ImageViewConfig.MultiLine);
      TImagePageControl.SetImageTabMode(ImageViewConfig.ImageTab);

      TImageTabSheet.SetInvisibleTab(ImageViewConfig.InvisibleTab);

      MakeQuickSaveMenu;
      DisableTitlebar(ImageViewConfig.DisableTitleBar);
      ImagePageControl.UpdateStatusBar;
    end;
  finally
    ArchiverManager.ModalDialogAppear:=False;
  end;
  if Visible then SetFocus;
end;


//�L�[�{�[�h�ɂ�鑀��
procedure TImageForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Hide;
    Ord('I'),Ord('i'):if ssCtrl	in Shift then MainWnd.SetFocus;
    VK_F10:begin
      if ssShift in Shift then
        with ActivePageControl do
          ImagePopUpMenu.Popup(ClienttoScreen(TabRect(ActivePageIndex).TopLeft).X,ClienttoScreen(TabRect(ActivePageIndex).BottomRight).Y);
    end;
    VK_APPS: with ActivePageControl do
      ImagePopUpMenu.Popup(ClienttoScreen(TabRect(ActivePageIndex).TopLeft).X,ClienttoScreen(TabRect(ActivePageIndex).BottomRight).Y);
  end;
end;


//�X�e�[�^�X�o�[�ł̃q���g�\��
procedure TImageForm.StatusBarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  RefTitle:String;
  tmp: string;
begin
  if StatusBar.Width-180>X then begin
    if Assigned(ImagePageControl.ActivePage) then begin

      RefTitle:=MakeThreadTitleString(TWebLoaderSheet(ImagePageControl.ActivePage).RefererThread);
      if RefTitle<>'' then RefTitle:=RefTitle+#13#10;

      tmp := TWebLoaderSheet(ImagePageControl.ActivePage).URI+#13#10;
      if TWebLoaderSheet(ImagePageControl.ActivePage).URI<>TWebLoaderSheet(ImagePageControl.ActivePage).SubURI then
        tmp := tmp + 'Original�F' + TWebLoaderSheet(ImagePageControl.ActivePage).SubURI+#13#10;

      StatusBar.Hint:=tmp +'From  �F' +RefTitle
                      +TWebLoaderSheet(ImagePageControl.ActivePage).RefererThread
    end else begin
      StatusBar.Hint:=''
    end;
  end else begin
    StatusBar.Hint:=StatusBar.Panels[1].Text;
  end;
end;


//�X�e�[�^�X�o�[��URL���N���b�v�{�[�h�ɃR�s�[
procedure TImageForm.CopyStatusBarURL(Sender:TObject);
begin
  Clipboard.AsText:=StatusBar.Panels[0].Text;
end;


//�A�N�e�B�u�R���g���[����������C���[�W�y�[�W�R���g���[����T��
//������Ȃ����̓��[�g�̃y�[�W�R���g���[����Ԃ�
function TImageForm.ActivePageControl:TPageControl;
var
  Control:TWinControl;
begin
  Control:=ActiveControl;
  Result:=ImagePageControl;
  while (Control<>Self) and (Control<>nil) do begin
    if Control is TImagePageControl then begin
      Result:=TPageControl(Control);
      Break;
    end;
    Control:=Control.Parent;
  end;
end;


//�A�N�Z�����[�^�[�𖳌����iUWriteForm�̂܂�܃R�s�[�j
function TImageForm.Hook(var Message: TMessage): Boolean;
begin
  case Message.Msg of
  CM_APPKEYDOWN:
     Result := True;  // �V���[�g�J�b�g�𖳌��ɂ���
  CM_APPSYSCOMMAND:
     Result := True;  // �A�N�Z�����[�^�𖳌��ɂ���
  else
     Result := False;
  end;
end;


//�e���|�����f�B���N�g���̑|�� WithFile�����Ȃ�t�@�C�����폜
procedure TImageForm.DeleteTemporaryDirectry(WithFile:Boolean=False);
var
  TempFileList, TempDirList:TStringList;
  i:Integer;
begin
  TempFileList:=TStringList.Create;
  TempDirList:=TStringList.Create;

  EnumDir(ExtractFilePath(Application.ExeName)+TMPDIRNAME,TempDirList,TempFileList);

  if WithFile and (TempFileList.Count>0)
        and (ImageViewConfig.DisableDeleteTmpAlart
        or (MessageDlg('OpenJane-View �e���|�����t�@�C���폜�̊m�F'#13#10#13#10+
                       'OpenJane-View�̃e���|�����f�B���N�g��'#13#10+
                       '('+ExtractFilePath(Application.ExeName)+TMPDIRNAME+')��'#13#10+
                       IntToStr(TempFileList.Count)+'�̃t�@�C����'+
                       IntToStr(TempDirList.Count)+'�̃f�B���N�g��������܂��B'#13#10+
                       '�����͒ʏ�͑O��̎g�p�ō폜���ꂸ�Ɏc�����s�v�ȃt�@�C���ł��B'#13#10+
                       '�폜���܂����H',mtWarning,mbOKCancel,0)=mrOK)) then begin
    try
      try
        for i:=0 to TempFileList.Count-1 do
          if LowerCase(copy(TempFileList[i],1,length(ExtractFilePath(Application.ExeName))+Length(TMPDIRNAME)+1))<>LowerCase(ExtractFilePath(Application.ExeName)+TMPDIRNAME+'\') then
            Raise Exception.Create('�t�@�C���폜���[�`�������͈͊O�̃t�@�C�����폜���悤�Ƃ��܂���')
          else if AnsiPos('..',TempFileList[i])>0 then
            Raise Exception.Create('�t�@�C���폜���[�`���Ɍ�����t�@�C�������n����܂���')
          else
            DeleteFile(TempFileList[i]);
      finally
        FreeAndNil(TempFileList);
      end;
    except
      raise;
    end;
  end else
    {aiai}
    if Assigned(TempFileList) then
      FreeAndNil(TempFileList);
    {/aiai}


  try
    try
      for i:=0 to TempDirList.Count-1 do
        if LowerCase(copy(TempDirList[i],1,length(ExtractFilePath(Application.ExeName))+Length(TMPDIRNAME)+1))<>LowerCase(ExtractFilePath(Application.ExeName)+TMPDIRNAME+'\') then
          Raise Exception.Create('�f�B���N�g���폜���[�`�������͈͊O�̃f�B���N�g�����폜���悤�Ƃ��܂���')
        else if AnsiPos('..',TempDirList[i])>0 then
          Raise Exception.Create('�f�B���N�g���폜���[�`���Ɍ�����f�B���N�g�������n����܂���')
        else
          RemoveDir(TempDirList[i]);
    finally
      FreeAndNil(TempDirList);
    end;
  except
    raise;
  end;

end;


//���ɏ��̃|�b�v�A�b�v���j���[�Ɋ֘A���鏈��
procedure TImageForm.StatusMemoSelectAll(Sender: TObject);
begin
  TMemo(ArchiveInfoPopUp.PopupComponent).SelectAll;
end;
//
procedure TImageForm.StatusMemoCopySelection(Sender: TObject);
begin
  TMemo(ArchiveInfoPopUp.PopupComponent).CopyToClipboard;
end;

//�}�E�X���r���[�A�ɓ�������|�b�v�A�b�v�q���g������
procedure TImageForm.WMMouseLeave(var Message: TMessage);
begin
  PopupHint.ReleaseHandle;
end;


//NonClient�̈�̃q�b�g�e�X�g(�^�X�N�o�[��\���̎��A��ӂ��^�X�N�o�[�Ƃ��Ĉ���)
procedure TImageForm.NcHitTest(var message:TWMNCHitTest);
begin
  inherited;
  if (message.Result = HTTOP) and ImageViewConfig.DisableTitleBar then
    message.Result:=HTCAPTION;
end;


//2ch�̃X���b�hURL����^�C�{�X���^�C�̕�����𐶐�
function MakeThreadTitleString(ThreadURI:string):string;
var
  host, bbs, datnum: string;
  board: TBoard;
  thread: TThreadItem;
  oldLog: boolean;
  StartIndex, EndIndex: integer;
begin
  Result:='';
  Get2chInfo(ThreadURI, host, bbs, datnum, StartIndex, EndIndex, oldLog);
  board := i2ch.FindBoard(host, bbs);
  if Assigned(board) then begin
    Result:=TCategory(board.category).name+' [' + board.name + '] ';
    board.AddRef;
    thread := board.Find(datnum);
    if  Assigned(thread) then
      Result:=Result+thread.title;
    board.Release;
  end;
end;





{���C���E�B���h�E�Ɋւ��鑀��}


//���C���E�C���h�E�ւ̃��j���[�o�^
procedure TImageForm.AddMenuItemToMainWnd;
var
  GestureMenuItem,GestureSubMenuItem:TMenuItem;
  i, j: Integer;
begin

  GestureMenuItem:=TMenuItem.Create(MainWnd);
  GestureMenuItem.Name:=ViewGesturePrefix+'Root';
  GestureMenuItem.Caption:='�r���[�A�p';
  GestureMenuItem.Visible:=False;

  GestureSubMenuItem:=TMenuItem.Create(MainWnd);
  GestureSubMenuItem.Caption:='�t�H�[�J�X�؂�ւ�';
  GestureSubMenuItem.Name:=ViewGesturePrefix+'ActivateImageViewer';
  GestureSubMenuItem.OnClick:=GestureMenuClick;
  GestureMenuItem.Add(GestureSubMenuItem);

  GestureSubMenuItem:=TMenuItem.Create(MainWnd);
  GestureSubMenuItem.Caption:='�N�C�b�N�ۑ��̕\��';
  GestureSubMenuItem.Name:=ViewGesturePrefix+'ShowQuickSaveDog';
  GestureSubMenuItem.OnClick:=GestureMenuClick;
  GestureMenuItem.Add(GestureSubMenuItem);

  for i:=0 to ImagePopUpMenu.Items.Count-1 do
    if ImagePopUpMenu.Items[i].Count>0 then begin
      for j:=0 to ImagePopUpMenu.Items[i].Count-1 do
        if ImagePopUpMenu.Items[i].Items[j].Name<>'' then begin
          GestureSubMenuItem:=TMenuItem.Create(MainWnd);
          GestureSubMenuItem.Caption:=ImagePopUpMenu.Items[i].Items[j].Caption;
          GestureSubMenuItem.Name:=ViewGesturePrefix+ImagePopUpMenu.Items[i].Items[j].Name;
          GestureSubMenuItem.OnClick:=GestureMenuClick;
          GestureMenuItem.Add(GestureSubMenuItem);
        end;
    end else begin
      if ImagePopUpMenu.Items[i].Name<>'' then begin
        GestureSubMenuItem:=TMenuItem.Create(MainWnd);
        GestureSubMenuItem.Caption:=ImagePopUpMenu.Items[i].Caption;
        GestureSubMenuItem.Name:=ViewGesturePrefix+ImagePopUpMenu.Items[i].Name;
        GestureSubMenuItem.OnClick:=GestureMenuClick;
        GestureMenuItem.Add(GestureSubMenuItem);
      end;
    end;

  MainWnd.MainMenu.Items.Add(GestureMenuItem);

end;

//�C���[�W�q���g�̕\��
function TImageForm.ShowImageHint(Text:String; ForSelf:Boolean):Boolean;
var
  i: Integer;
  TabSheet: TImageTabSheet;
  CacheStream: TStringStream;
  ImageConv: TGraphic;
  Header: TStringList;
  ImageHeaderPointer: PChar;
  CPos: TPoint;
begin

  CPos := Mouse.CursorPos;

  //�}�E�X�������̏�ɂ���Ƃ��͕\�����Ȃ�
  //(�r���[�A���g�債���Ƃ��A��x�������q���g���ĕ\�������̂�h��)
  if not(ForSelf) and Visible and (WindowState <> wsMinimized) and PtInRect(BoundsRect, CPos) then begin
    Result:=True;
    Exit;
  end;



  Text:=ProofURL(Text, False);

  Result:=False;

  if not ImageViewConfig.ShowImageHint then Exit;

  PopupHint.PaintBox.ShrinkType := ImageViewConfig.ShrinkType;
  for i := 0 to ImagePageControl.PageCount - 1 do begin
    TabSheet := TImageTabSheet(ImagePageControl.Pages[i]);
    if TabSheet.URI = Text then begin
      if TabSheet.PageStatus = htCOMPLETED then begin
        if ImageViewConfig.ExamArchiveType(Text) <> atNone then begin
          PopUpTextHint('���Ƀt�@�C���F�ǂݍ��ݍς�');
        end else begin
          if ImageViewConfig.ShowImageOnImageHint then begin
            PopupHint.ActivateHintData(Bounds(CPos.X, CPos.Y + 20,
                              ImageViewConfig.ImageHintWidth, ImageViewConfig.ImageHintHeight),
                              '', TabSheet.Bitmap)
          end else begin
            PopUpTextHint(TabSheet.StatusText);
          end;
        end;
      end else begin
        PopUpTextHint(TabSheet.StatusText);
      end;
      PopupHint.Info := Text;
      Result := True;
      Break;
    end;
  end;

  if not ImageViewConfig.ShowCacheOnImageHint then
    Exit;

  Header := TStringList.Create;
  CacheStream := TStringStream.Create('');

  if (Result = False) and (HttpManager.ReadCache(Text, CacheStream, Header) >= 0) then begin

    Result := True;

    if Header.Values['STATUS'] = 'BROCRA' then begin
      PopUpTextHint('�u���N���댯');
    end else if ImageViewConfig.ExamArchiveEnabled(Text) then begin
      PopUpTextHint('���Ƀt�@�C���F�L���b�V���ς�');
    end else if Header.Values['STATUS'] = 'PROTECT' then begin
      PopUpTextHint('���U�C�N�������t�@�C���F�L���b�V���ς�');
    end else begin

      SeekSkipMacBin(CacheStream);
      ImageHeaderPointer := PChar(CacheStream.DataString) + CacheStream.Position;

      if (StrLComp(ImageHeaderPointer, #$FF#$D8#$FF#$E0#$00#$10'JFIF',10) = 0)
          or (StrLComp(ImageHeaderPointer, #$FF#$D8#$FF#$E1, 4) = 0)
          {or SameText(ExtractFileExt(Text), '.jpg') or SameText(ExtractFileExt(Text), '.jpeg')} then
        //ImageConv:=TJPEGImage.Create
        ImageConv := TApiBitmap.Create
      (* png�̓W�J��PNGImage���g�� (aiai) *)
      else if (StrLComp(ImageHeaderPointer, #$89#$50#$4E#$47#$0D#$0A#$1A#$0A#$00#$00#$00#$0D#$49#$48#$44#$52, 16)=0)  {SameText(ExtractFileExt(FInfo), '.png')} then
        ImageConv := TPNGObject.Create
      else
        ImageConv:=TSPIBitmap.Create;

      try
        ImageConv.LoadFromStream(CacheStream);
        PopupHint.OwnBitmap.Assign(ImageConv);
        PopupHint.ActivateHintData(Bounds(CPos.X, CPos.Y+20,
                          ImageViewConfig.ImageHintWidth, ImageViewConfig.ImageHintHeight),
                          '�L���b�V���摜', PopupHint.OwnBitmap);
      except
        on e:Exception do PopUpTextHint('Decode�s�F�L���b�V���ς�');
      end;
      ImageConv.Free;
    end;
  end;

  CacheStream.Free;
  Header.Free;

  //�`���Ă���ԂɃJ�[�\�����r���[�A�⏑�����݃_�C�A���O�ɓ��邱�Ƃ���B�d���Ȃ�����L�����Z��
  if not(ForSelf) and Visible and (WindowState <> wsMinimized) and PtInRect(BoundsRect, Mouse.CursorPos) then
    PopupHint.ReleaseHandle;

end;


//�\�����̃C���[�W�q���g�̃A�b�v�f�[�g
procedure TImageForm.UpdateImageHint(TabSheet:TImageTabSheet);
begin
  if not ImageViewConfig.ShowImageHint then Exit;

  if TabSheet.URI = PopupHint.info then begin
    PopupHint.ReleaseHandle;
    PopupHint.PaintBox.ShrinkType:=ImageViewConfig.ShrinkType;
    if TabSheet.PageStatus=htCOMPLETED then begin
      if ImageViewConfig.ExamArchiveType(TabSheet.URI)<>atNone then begin
        PopUpTextHint('���Ƀt�@�C���F�ǂݍ��ݍς�');
      end else begin
        if ImageViewConfig.ShowImageOnImageHint then begin
          PopupHint.ActivateHintData(Bounds(Mouse.CursorPos.X,Mouse.CursorPos.Y+20,
                            ImageViewConfig.ImageHintWidth, ImageViewConfig.ImageHintHeight),
                            '',TabSheet.Bitmap)
        end else begin
          PopUpTextHint(TabSheet.StatusText);
        end;
      end;
    end else begin
      PopUpTextHint(TabSheet.StatusText);
    end;
    PopupHint.Info:=TabSheet.URI;
  end;
end;


//�e�L�X�g�q���g�̃|�b�v�A�b�v
procedure TImageForm.PopUpTextHint(S: String);
var
  HintRect: TRect;
begin
  HintRect := PopupHint.CalcHintRect(ImageViewConfig.ImageHintWidth,S ,nil);
  PopupHint.ActivateHint(Bounds(Mouse.CursorPos.X,Mouse.CursorPos.Y+20,HintRect.Right,HintRect.Bottom), S);
end;


//�C���[�W�r���[���J��
procedure TImageForm.OpenImageView(Sender: TObject);
begin
  if Visible then
    hide
  else
    if ImagePageControl.PageCount<>0
      then ImageForm.Show;
end;


//�W�F�X�`���[�p���j���[�A�C�e���̃N���b�N
procedure TImageForm.GestureMenuClick(Sender:TObject);
begin

  if TMenuItem(Sender).Name=ViewGesturePrefix+'ActivateImageViewer' then begin
    if Active then
      MainWnd.SetFocus
    else
      if ImagePageControl.PageCount>0 then Show;
  end else begin
    if Active then begin
      if TMenuItem(Sender).Name=ViewGesturePrefix+'ShowQuickSaveDog' then begin
        QuickSavePopup.PopupComponent:=nil;
        QuickSavePopup.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
      end else begin
        TMenuItem(FindComponent(copy(TMenuItem(Sender).Name,length(ViewGesturePrefix)+1,65535))).Click;
      end;
    end;
  end;
end;


//URL�u�����X�g�̔j��
procedure DestructRegExp;
var
  i:Integer;
begin
  FreeAndNil(RegExpReplace);
  FreeAndNil(RegExpReplaceRef);
  if Assigned(RegExpList) then begin
    for i :=0 to RegExpList.Count - 1 do
      TObject(RegExpList[i]).Free;
    FreeAndNil(RegExpList);
  end;
end;

//URL�u�����X�g�̓ǂݍ���
procedure LoadRegExp;
var
  i: Integer;
  RegExp: TRegExpr;
  RegExpFile:TStringList;
  RegExpStr: TstringList;
  FileName: string;
  ErrorList: TstringList;
begin

  DestructRegExp;

  Filename := ExtractFilePath(Application.ExeName)+'ImageViewURLReplace.dat';

  if not FileExists(FileName) then
    Exit;

  RegExpFile := TStringList.Create;
  try
    RegExpFile.LoadFromFile(FileName);
  except
    RegExpFile.Free;
    MessageDlg('�u��������t�@�C���̓ǂݍ��݂Ɏ��s', mtError, [mbOK], 0);
    Exit;
  end;

  RegExpList := TList.Create;
  RegExpReplace := TStringList.Create;
  RegExpReplaceRef := TStringList.Create;

  Errorlist := TStringList.Create;
  ErrorList.Text := '�ȉ��̒u��������͖����ł�';

  RegExpStr := TStringList.Create;
  RegExpStr.Delimiter := #9;

  for i:=0 to RegExpFile.Count - 1 do begin
    RegExpStr.DelimitedText := RegExpFile[i];
    if (RegExpStr.Count<2) or (RegExpStr[0]='') or ((RegExpStr.Count>2) and (Length(Trim(RegExpStr[2]))=2) and (Trim(RegExpStr[2])[1]='$')) then begin
      ErrorList.Add(StringReplace(RegExpFile[i],#9,' ',[rfReplaceAll]));
      Continue;
    end;
    RegExp := TRegExpr.Create;
    try
      RegExp.Expression := RegExpStr[0];
      RegExpList.Add(RegExp);
      RegExpReplace.Add(RegExpStr[1]);
      if RegExpStr.Count>2 then
        RegExpReplaceRef.Add(RegExpStr[2])
      else
        RegExpReplaceRef.Add('');
    except
      ErrorList.Add(StringReplace(RegExpFile[i],#9,' ',[rfReplaceAll]));
    end;
  end;

  if ErrorList.Count > 1 then
    MessageDlg(ErrorList.Text, mtError, [mbOK], 0);

  ErrorList.Free;
  RegExpStr.Free;
  RegExpFile.Free;

end;


//URL�u������
function ApplyRegExp(const Original:String; var Ref: String): string;
var
  i: Integer;
begin
  Result := Original;
  Ref := '';

  if (RegExpList=nil) or (RegExpList.Count =0) then
    Exit;

  try
    for i:=0 to RegExpList.Count - 1 do
      if TRegExpr(RegExpList[i]).Exec(Result) then begin
        Result := TRegExpr(RegExpList[i]).Substitute(RegExpReplace[i]);
        Ref := TRegExpr(RegExpList[i]).Substitute(RegExpReplaceRef[i]);
      end;
  except
  end;
end;

const
  URLChar=[#$21,#$23..#$3B,#$3D,#$3F..#$5A,#$5F,#$61..#$7A,#$7E];

//URL�̕␳(Referer����)
function ProofURLwithRef(const Original:String; var Ref: string; WantEditBox:boolean=True): string;
var
  URLCheck:TURLCheck;
  ImeNuHeader:Integer;
  NoImeNuHeader:Boolean;
begin
  URLCheck:=TURLCheck.Create;
  URLCheck.Text:=Original;
  Result:=URLCheck.URL;
  URLCheck.Free;

  repeat
    NoImeNuHeader:=True;
    for ImeNuHeader:=low(ImeNu) to High(ImeNu) do
      if (Length(Result) >= Length(ImeNu[ImeNuHeader])) and (AnsiStrLIComp(PChar(ImeNu[ImeNuHeader]), PChar(Result), Length(ImeNu[ImeNuHeader])) = 0) then begin
        Result:='http://'+copy(Result,Length(ImeNu[ImeNuHeader])+1,Length(Result));
        NoImeNuHeader:=False;
        Break;
      end;
  until NoImeNuHeader;

  Result := ApplyRegExp(Result, Ref);

  if WantEditBox and (GetKeyState(VK_CONTROL) < 0) then begin
    if InputDlg = nil then
      InputDlg := TInputDlg.Create(MainWnd);
    InputDlg.Caption := '�I��͈͂�URL�Ƃ��ĊJ��';
    InputDlg.Edit.Font.Name:='�l�r �S�V�b�N';
    InputDlg.Edit.Text := Result;

    Result:='';

    if InputDlg.ShowModal = 3 then result:=InputDlg.Edit.Text;
    FreeAndNil(InputDlg);

  end;

end;

//URL�̕␳(Referer�����Ȃ�)
function ProofURL(const Original:String; WantEditBox:boolean=True):string;
var
  tmp: string;
begin
  Result := ProofURLwithRef(Original, tmp, WantEditBox)
end;


//URL�Ƃ��ڂ���������̒��o
procedure ExtractURLs(const Text:string; URLs:TStrings);
var
  URLCheck:TURLCheck;
  CurPos:Integer;
  URLBegin: Integer;
  PeriodPos:Integer;
  procedure AddUrlIfNecessary;
  begin
    if (URLBegin>=0) and (CurPos>URLBegin+6) then begin
      URLCheck.Text:=Copy(Text,URLBegin,CurPos-URLBegin);
      if URLCheck.IsURL and (URLCheck.DirLength>0) then
        URLs.Add(URLCheck.URL);
    end;
  end;
begin
  URLCheck:=TURLCheck.Create;
  CurPos:=1;
  URLBegin:=-1;
  PeriodPos:=-1;
  while CurPos<=Length(Text) do begin
    if Text[CurPos] in URLChar then begin
      if URLBegin=-1 then URLBegin:=CurPos;
      if (Text[CurPos]='.') and (PeriodPos<0) then PeriodPos:=CurPos;
      Inc(CurPos);
    end else begin
      AddUrlIfNecessary;
      URLBegin:=-1;
      PeriodPos:=-1;
      if Text[CurPos] in LeadBytes then begin
        Inc(CurPos,2);
      end else begin
        Inc(CurPos);
      end;
    end;
  end;
  AddUrlIfNecessary;
  URLCheck.Free;
end;

procedure TImageForm.FormHide(Sender: TObject);
begin
  MainWnd.SetFocus;
end;

initialization
  LoadRegExp;
finalization
  DestructRegExp;

end.
