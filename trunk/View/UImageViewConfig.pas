unit UImageViewConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, FileCtrl, IniFiles, Mask,
  ToolWin, JConfig, UAnimatedPaintBox, UEditSaveLocation, UHttpManage,
  StrUtils, CheckLst, ARCHIVES, ImgList, JLXPStdCtrls, JLXPComCtrls,
  JLXPSpin, JLXPExtCtrls;


type

  TArchiveTypeRecord = record
    Ex:string;
    Ac:TArchiverType;
  end;


const
  ImageTabWidth=36;
  ImageTabHeight=27;
  TMPDIRNAME='ImageViewTmp';
  MenuConfigFileName='ViewMenuConfig.ini';
  ImeNu : array[0..2] of String =
        ( 'http://ime.nu/http://',
          'http://ime.nu/',
          'http://nun.nu/?http://');

  ArchiveTypeRecord:array [0..14] of TArchiveTypeRecord =
    ((Ex:'.lzh';Ac:atLha),(Ex:'.cab';Ac:atCab),(Ex:'.zip';Ac:atZip),
     (Ex:'.arj';Ac:atArj),(Ex:'.rar';Ac:atRar),(Ex:'.7z' ;Ac:at7z ),
     (Ex:'.z'  ;Ac:atTgz),(Ex:'.gz' ;Ac:atTgz),(Ex:'.tgz';Ac:atTgz),
     (Ex:'.taz';Ac:atTgz),(Ex:'.tar';Ac:atTar),(Ex:'.bz2';Ac:atBZ2),
     (Ex:'.gza';Ac:atBga),(Ex:'.bza';Ac:atBga),(Ex:'.gca';Ac:atGCA));

type
  TTabSelectAllType=(tsARCHIVE,tsEXTRACTEDIMAGE,tsIGNORE);

  TImageViewConfig = class(TObject)
  protected

    FDisableImageViewer: Boolean;

    FTabStyle:TTabStyle;
    FMultiLine: Boolean;
    FImageTab: Boolean;
    FContinuousTabChange: Boolean;
    FShowDialogToSaveHighlightTab: Boolean;
    FTabSelectAllType: TTabSelectAllType;
    FInvisibleTab:Boolean;
    FUseTabNavigateIcon:Boolean;
    FGoLeftWhenTabClose:Boolean;
    FConnectedTabEdge: Boolean;

    FAlwaysProtect:Boolean;
    FProtectMosaicSize:Integer;
    FAdjustToWindow:Boolean;
    FScrollOpposite:Boolean;
    FHiddenMode:Boolean;

    FCloseAllTabIfFormClosed:Boolean;
    FShrinkType:TShrinkType;
    FExternalViewer:String;
    FDisableAlartAtOpenWithRelation:Boolean;

    FUseIndividualStatusBar:Boolean;
    FSwapCtrlShift:Boolean;

    FEnableFolding:Boolean;
    FActivateViewerIfURLHasLoaded:Boolean;
    FKeepTabVisible:Boolean;
    FDisableTitleBar:Boolean;
    FOpenImagesOnly:Boolean;
    FOpenURLOnMouseOver: Boolean;

    FUseHTMLView:Boolean;
    FForceToUseViewer:Boolean;

    FShowImageHint:Boolean;
    FShowImageOnImageHint:Boolean;
    FShowCacheOnImageHint: Boolean;
    FImageHintHeight:Integer;
    FImageHintWidth:Integer;

    FUserAgent:string;
    FTimeOut:Integer;
    FRedirectMaximum:Integer;
    FConnectionLimit: Integer;

    FDeleteTmpOnStartUp:Boolean;
    FDisableDeleteTmpAlart:Boolean;

    FUseViewCache: Boolean;
    FCacheSelectedFileOnly: Boolean;
    FLifeSpanOfCache: Integer;
    FPrioryCacheWhole: Boolean;
    FPrioryCacheImage: Boolean;
    FPrioryCacheArchive: Boolean;
    FPrioryCacheExtention: String;
    FCachePath: String;

    FSpiEnabled: Boolean;  //aiai

    FEnableFlashMovie:Boolean;
  private
    (* Susieプラグイン読込情報の表示 (aiai) *)
    procedure PreviewSusiePluginPreference(CheckListBox: TCheckListBox);

  public
    Top, Left, Height, Width: Integer;

    (* キャッシュ一覧用 (aiai) *)
    CacheListRect: String;
    CacheListColumnWidth: String;
    CacheListSplit1, CacheListSplit2: Integer;

    QuickSavePoint:TStringList;

    ArchiveEnabled:array[Low(ArchiveTypeRecord)..High(ArchiveTypeRecord)] of Boolean;

    constructor Create;
    destructor Destroy;override;

    procedure GetIconBmp(const Name:String; var Bitmap:TBitmap);

    function ExamArchiveType(Name:String): TArchiverType;
    function ExamArchiveEnabled(Name:String): Boolean;
    function ExamImageFile(Name: String): Boolean;
    function ExamFileExt(Name:String): Boolean;

    procedure SavePreference;

    function OpenPreference(Sender:TComponent):Boolean;

    property DisableImageViewer: Boolean read FDisableImageViewer;

    property TabStyle:TTabStyle read FTabStyle;
    property MultiLine: Boolean read FMultiLine;
    property ImageTab:Boolean read FImageTab;
    property InvisibleTab:Boolean read FInvisibleTab;
    property ContinuousTabChange:Boolean read FContinuousTabChange;
    property ShowDialogToSaveHighlightTab: Boolean read FShowDialogToSaveHighlightTab;
    property TabSelectAllType: TTabSelectAllType read FTabSelectAllType;
    property UseTabNavigateIcon:Boolean read FUseTabNavigateIcon;
    property GoLeftWhenTabClose:Boolean read FGoLeftWhenTabClose;
    property ConnectedTabEdge:Boolean read FConnectedTabEdge;

    property AlwaysProtect:Boolean read FAlwaysProtect;
    property ProtectMosaicSize:Integer read FProtectMosaicSize;
    property AdjustToWindow:Boolean read FAdjustToWindow;
    property ScrollOpposite:Boolean read FScrollOpposite;
    property HiddenMode:Boolean read FHiddenMode;

    property CloseAllTabIfFormClosed:Boolean read FCloseAllTabIfFormClosed;
    property ShrinkType:TShrinkType read FShrinkType;
    property ExternalViewer:String read FExternalViewer;
    property DisableAlartAtOpenWithRelation:Boolean read FDisableAlartAtOpenWithRelation;

    property UseIndividualStatusBar:Boolean read FUseIndividualStatusBar;
    property SwapCtrlShift:Boolean read FSwapCtrlShift;

    property EnableFolding:Boolean read FEnableFolding write FEnableFolding;
    property ActivateViewerIfURLHasLoaded:Boolean read FActivateViewerIfURLHasLoaded;
    property KeepTabVisible:Boolean read FKeepTabVisible;
    property DisableTitleBar:Boolean read FDisableTitleBar;
    property OpenImagesOnly:Boolean read FOpenImagesOnly;
    property OpenURLOnMouseOver: Boolean read FOpenURLOnMouseOver;

    property ForceToUseViewer:Boolean read FForceToUseViewer;

    property ShowImageHint:Boolean read FShowImageHint;
    property ShowImageOnImageHint:Boolean read FShowImageOnImageHint;
    property ShowCacheOnImageHint:Boolean read FShowCacheOnImageHint;
    property ImageHintHeight:Integer read FImageHintHeight;
    property ImageHintWidth:Integer read FImageHintWidth;

    property UserAgent:string read FUserAgent;
    property TimeOut:Integer read FTimeOut;
    property RedirectMaximum:Integer read FRedirectMaximum;
    property ConnectionLimit: Integer read FConnectionLimit;

    property DeleteTmpOnStartUp:Boolean read FDeleteTmpOnStartUp;
    property DisableDeleteTmpAlart:Boolean read FDisableDeleteTmpAlart;

    property UseViewCache: Boolean read FUseViewCache;
    property CacheSelectedFileOnly: Boolean read FCacheSelectedFileOnly;
    property LifeSpanOfCache: Integer read FLifeSpanOfCache;
    property PrioryCacheWhole: Boolean read FPrioryCacheWhole;
    property PrioryCacheImage: Boolean read FPrioryCacheImage;
    property PrioryCacheArchive: Boolean read FPrioryCacheArchive;
    property PrioryCacheExtention: String read FPrioryCacheExtention;
    property CachePath: String read FCachePath;

    property EnableFlashMovie:Boolean read FEnableFlashMovie;

    property SpiEnabled: Boolean read FSpiEnabled;  //aiai

  end;

  //HTTP読み込み接続数,キャッシュ管理/設定基本クラス(カスタマイズは継承で)
  TConfigHttpManager = class(THttpManager)
  protected
    function CheckCachePriority(URL: String): Boolean; override;
    procedure MsgOut(S: String); override;
  public
    VConfig: TImageViewConfig;
    MConfig: TJaneConfig;
    function CachePath: String; override;
    function UserAgent: String; override;
    function ConnectionLimit: Integer; override;
    function ReadTimeout: Integer; override;
    function RedirectMaximum: Integer; override;
    function UseCache: Boolean; override;
    function SaveCacheEachTime: Boolean; override;
    function LifeSpanOfCache: Integer; override;
    function ProxyServer: String; override;
    function ProxyPort: Integer; override;
    function OffLine: Boolean; override;
  end;

  TImageViewPreference = class(TForm)
    btOK: TButton;
    btCancel: TButton;
    PageControl1: TPageControl;
    TabSheetGeneral: TJLXPTabSheet;
    TabSheetArchive: TJLXPTabSheet;
    cmbUserAgent: TComboBox;
    Label2: TLabel;
    Label1: TLabel;
    seRedirectMaximum: TJLXPSpinEdit;
    Label3: TLabel;
    seTimeOut: TJLXPSpinEdit;
    cbEnableFolding: TCheckBox;
    cbAdjustToWindow: TCheckBox;
    cbScrollOpposite: TCheckBox;
    btSelectExternalViewer: TButton;
    cbActivateViewerIfURLHasLoaded: TCheckBox;
    cbKeepTabVisible: TCheckBox;
    ebExternalViewer: TEdit;
    Label6: TLabel;
    TabSheetQuickSave: TJLXPTabSheet;
    ToolBar1: TJLXPToolBar;
    btnUp: TToolButton;
    btnDown: TToolButton;
    btnMakeNew: TToolButton;
    btnEdit: TToolButton;
    btnDelete: TToolButton;
    lvQuickSPList: TListView;
    TabSheetTab: TJLXPTabSheet;
    rgTabStyle: TJLXPRadioGroup;
    cbImageTab: TCheckBox;
    cbEnableMultiLineTab: TCheckBox;
    cbContinuousTabChange: TCheckBox;
    rgTabSelectAllType: TJLXPRadioGroup;
    cbShowDialogToSaveHighlightTab: TCheckBox;
    cbCloseAllTabIfFormClosed: TCheckBox;
    cbAlwaysProtect: TCheckBox;
    clbArchiveEnabled: TCheckListBox;
    Label7: TLabel;
    cbUseIndividualStatusBar: TCheckBox;
    rgShrinkType: TJLXPRadioGroup;
    cbHiddenMode: TCheckBox;
    Button1: TButton;
    cbUseTabNavigateIcon: TCheckBox;
    cbGoLeftWhenTabClose: TCheckBox;
    TabSheetDanger: TJLXPTabSheet;
    cbInvisibleTab: TCheckBox;
    TabSheetThread: TJLXPTabSheet;
    cbSwapShiftCtrl: TCheckBox;
    cbOpenImagesOnly: TCheckBox;
    cbShowImageHint: TCheckBox;
    cbShowImageOnImageHint: TCheckBox;
    Label4: TLabel;
    seImageHintHeigtht: TJLXPSpinEdit;
    Label5: TLabel;
    seImageHintWidth: TJLXPSpinEdit;
    cbDisableDeleteTmpAlart: TCheckBox;
    cbDeleteTmpOnStartUp: TCheckBox;
    cbForceToUseViewer: TCheckBox;
    cbDisableAlartAtOpenWithRelation: TCheckBox;
    seProtectMosaicSize: TJLXPSpinEdit;
    Label11: TLabel;
    cbEnableFlashMovie: TCheckBox;
    cbDisableTitleBar: TCheckBox;
    cbConnectedTabEdge: TCheckBox;
    seConnectionLimit: TJLXPSpinEdit;
    Label12: TLabel;
    cbOpenURLOnMouseOver: TCheckBox;
    TabSheetCache: TJLXPTabSheet;
    seLifeSpanOfCache: TJLXPSpinEdit;
    lbLifeSpanOfCache: TLabel;
    cbUseViewCache: TCheckBox;
    GroupBoxCachePriority: TJLXPGroupBox;
    cbPrioryCacheImage: TCheckBox;
    cbPrioryCacheArchive: TCheckBox;
    LabelCachePriority: TLabel;
    edPrioryCacheExtention: TEdit;
    cbPrioryCacheWhole: TCheckBox;
    edCachePath: TEdit;
    LabelCachePath: TLabel;
    btnSelectCachePath: TButton;
    cbCacheSelectedFileOnly: TCheckBox;
    cbShowCacheOnImageHint: TCheckBox;
    cbDisableImageViewer: TCheckBox;
    TabSheet1: TJLXPTabSheet;
    clbSusiePluginsEnabled: TCheckListBox;
    cbSusiePluginsEnabled: TCheckBox;              //aiai
    procedure SelectExternalViewer(Sender: TObject);
    procedure cbDeleteTmpOnStartUpClick(Sender: TObject);
    procedure DoOK(Sender: TObject);
    procedure cbEnableFoldingClick(Sender: TObject);
    procedure cbKeepTabVisibleClick(Sender: TObject);
    procedure cbShowImageOnImageHintClick(Sender: TObject);
    procedure btnMakeNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure lvQuickSPListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnEditClick(Sender: TObject);
    procedure cbContinuousTabChangeClick(Sender: TObject);
    procedure HitobashiraAlart(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbDisableAlartAtOpenWithRelationClick(Sender: TObject);
    procedure cbPrioryCacheWholeClick(Sender: TObject);
    procedure btnSelectCachePathClick(Sender: TObject);
    procedure edCachePathKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCachePathKeyPress(Sender: TObject; var Key: Char);
    procedure cbSusiePluginsEnabledClick(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;


function SeekSkipMacBin(Stream: TStream): Boolean;


var
  ImageViewConfig:TImageViewConfig;
  HttpManager: TConfigHttpManager;

implementation

{$R *.dfm}
{$R ViewIcon.Res}

uses UImageViewer, Menus, Main, SPIs;

constructor TImageViewConfig.Create;
var
  IniFileName:TFileName;
  IniFile:TMemIniFile;
  i:Integer;
  StringList:TStringList;
begin

  inherited;

  IniFileName := ExtractFilePath(Application.ExeName)+'ImageView.ini';

  QuickSavePoint:=TStringList.Create;
  IniFile:=TMemIniFile.Create(IniFileName);
  try

    FDisableImageViewer := IniFile.ReadBool('General', 'DisableImageViewer', False);

    Top:=IniFile.ReadInteger('Position','Top',0);
    Left:=IniFile.ReadInteger('Position','Left',0);
    Height:=IniFile.ReadInteger('Position','Height',400);
    Width:=IniFile.ReadInteger('Position','Width',400);

    FTabStyle:=TTabStyle(IniFile.ReadInteger('Tab','TabStyle',0));
    FMultiLine:=IniFile.ReadBool('Tab','MultiLine',False);
    FImageTab:=IniFile.ReadBool('Tab','ImageTab',True);
    FInvisibleTab:=IniFile.ReadBool('Tab','InvisibleTab',False);
    FContinuousTabChange:=IniFile.ReadBool('Tab','ContinuousTabChange',True);
    FShowDialogToSaveHighlightTab:=IniFile.ReadBool('Tab','ShowDialogToSaveHighlightTab',True);
    FTabSelectAllType:=TTabSelectAllType(IniFile.ReadInteger('Tab','TabSelectAllType',0));
    FUseTabNavigateIcon:=IniFile.ReadBool('Tab','UseTabNavigateIcon',True);
    FGoLeftWhenTabClose:=IniFile.ReadBool('Tab','GoLeftWhenTabClose',False);
    FConnectedTabEdge:=IniFile.ReadBool('Tab','ConnectedTabEdge',False);

    FAlwaysProtect:=IniFile.ReadBool('General','AlwaysProtect',False);
    FProtectMosaicSize:=IniFile.ReadInteger('General','ProtectMosaicSize',16);
    FAdjustToWindow:=IniFile.ReadBool('General','AdjustToWindow',True);
    FScrollOpposite:=IniFile.ReadBool('General','ScrollOpposite',False);
    FHiddenMode:=IniFile.ReadBool('General','HiddenMode',False);


    FCloseAllTabIfFormClosed:=IniFile.ReadBool('General','CloseAllTabIfFormClosed',False);
    FShrinkType:=TShrinkType(IniFile.ReadInteger('General','ShrinkType',0));
    FExternalViewer:=IniFile.ReadString('General','ExternalViewer','');
    FDisableAlartAtOpenWithRelation:=IniFile.ReadBool('General','DisableAlartAtOpenWithRelation',False);

    FUseIndividualStatusBar:=IniFile.ReadBool('General','UseIndividualStatusBar',True);
    FSwapCtrlShift:=IniFile.ReadBool('General','SwapCtrlShift',False);

    FEnableFolding:=IniFile.ReadBool('General','EnableFolding',True);
    FActivateViewerIfURLHasLoaded:=IniFile.ReadBool('General','ActivateViewerIfURLHasLoaded',True);
    FKeepTabVisible:=IniFile.ReadBool('General','KeepTabVisible',True);
    FDisableTitleBar:=IniFile.ReadBool('General','DisableTitleBar',False);
    FOpenImagesOnly:=IniFile.ReadBool('General','OpenImagesOnly',False);
    FOpenURLOnMouseOver := IniFile.ReadBool('General','OpenURLOnMouseOver',False);

    FUseHTMLView:=IniFile.ReadBool('General','UseHTMLView',True);
    FForceToUseViewer:=IniFile.ReadBool('General','ForceToUseViewer',False);

    FShowImageHint:=IniFile.ReadBool('PopUpHint','ShowImageHint',True);
    FShowImageOnImageHint:=IniFile.ReadBool('PopUpHint','ShowImageOnImageHint',True);
    FShowCacheOnImageHint:=IniFile.ReadBool('PopUpHint','ShowCacheOnImageHint',True);
    FImageHintHeight:=IniFile.ReadInteger('PopUpHint','ImageHintHeight',300);
    FImageHintWidth:=IniFile.ReadInteger('PopUpHint','ImageHintWidth',300);

    FUserAgent:=IniFile.ReadString('HTTP','UserAgent','Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0)');
    FTimeOut:=IniFile.ReadInteger('HTTP','TimeOut',30000);
    FRedirectMaximum:=IniFile.ReadInteger('HTTP','RedirectMaximum',0);
    FConnectionLimit := IniFile.ReadInteger('HTTP','ConnectionLimit',5);

    FDeleteTmpOnStartUp:=IniFile.ReadBool('StartUp','DeleteTmpOnStartUp',True);
    FDisableDeleteTmpAlart:=IniFile.ReadBool('StartUp','DisableDeleteTmpAlart',False);

    FUseViewCache := IniFile.ReadBool('Cache', 'UseViewCache', True);
    FCacheSelectedFileOnly := IniFile.ReadBool('Cache', 'CacheSelectedFileOnly', False);
    FLifeSpanOfCache := IniFile.ReadInteger('Cache', 'LifeSpanOfCache', 30);
    FPrioryCacheWhole := IniFile.ReadBool('Cache', 'PrioryCacheWhole', False);
    FPrioryCacheImage := IniFile.ReadBool('Cache', 'PrioryCacheImage', True);
    FPrioryCacheArchive := IniFile.ReadBool('Cache', 'PrioryCacheArchive', True);
    FPrioryCacheExtention := IniFile.ReadString('Cache', 'PrioryCacheExtention', ';;');
    FCachePath := IniFile.ReadString('Cache', 'CachePath', '');

    FEnableFlashMovie:=IniFile.ReadBool('FLASH','EnableFlashMovie',False);

    FSpiEnabled := IniFile.ReadBool('General', 'SpiEnabled', False);

    IniFile.ReadSectionValues('QuickSavePoint',QuickSavePoint);
    for i:=0 to QuickSavePoint.Count-1 do
      QuickSavePoint[i]:=QuickSavePoint.Values[IntToStr(i)];

    StringList:=TStringList.Create;
    IniFile.ReadSectionValues('ArchiveEnabled',StringList);
    for i:=Low(ArchiveTypeRecord) to High(ArchiveTypeRecord) do
      ArchiveEnabled[i]:=StrToBool(StringList.Values[ArchiveTypeRecord[i].Ex]);
    StringList.Free;

    (* キャッシュ一覧用 (aiai) *)
    CacheListRect := iniFile.ReadString('Histroy', 'Rect', '67, 48, 760, 514');
    CacheListColumnWidth
     := iniFile.ReadString('Histroy', 'ColumnWidth', '280, 132, 90, 115, 150');
    CacheListSplit1 := iniFile.ReadInteger('Histroy', 'Split1', 100);
    CacheListSplit2 := iniFile.readInteger('Histroy', 'Split2', 100);

  except

    FDisableImageViewer := False;

    Top:=0;
    Left:=0;
    Height:=400;
    Width:=400;

    FTabStyle:=tsTabs;
    FMultiLine:=False;
    FImageTab:=True;
    FInvisibleTab:=False;
    FContinuousTabChange:=True;
    FShowDialogToSaveHighlightTab:=True;
    FTabSelectAllType:=tsARCHIVE;
    FUseTabNavigateIcon:=True;
    FGoLeftWhenTabClose:=False;
    FConnectedTabEdge := False;

    FAlwaysProtect:=False;
    FProtectMosaicSize:=16;
    FAdjustToWindow:=True;
    FScrollOpposite:=False;
    FHiddenMode:=False;

    FCloseAllTabIfFormClosed:=False;
    FShrinkType:=stHighQuality;
    FExternalViewer:='';
    FDisableAlartAtOpenWithRelation:=False;

    FUseIndividualStatusBar:=True;
    FSwapCtrlShift:=False;

    FEnableFolding:=True;
    FActivateViewerIfURLHasLoaded:=True;
    FKeepTabVisible:=True;
    FDisableTitleBar:=False;
    FOpenImagesOnly:=False;
    FOpenURLOnMouseOver := False;

    FUseHTMLView:=True;
    FForceToUseViewer:=False;

    FShowImageHint:=True;
    FShowImageOnImageHint:=True;
    FShowCacheOnImageHint:=True;
    FImageHintHeight:=300;
    FImageHintWidth:=300;

    FUserAgent:='Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0)';
    FTimeOut:=30000;
    FRedirectMaximum:=0;
    FConnectionLimit := 5;

    FDeleteTmpOnStartUp:=True;
    FDisableDeleteTmpAlart:=False;

    FUseViewCache := True;
    FCacheSelectedFileOnly := False;
    FLifeSpanOfCache := 30;
    FPrioryCacheWhole := False;
    FPrioryCacheImage := True;
    FPrioryCacheArchive := True;
    FPrioryCacheExtention := ';;';
    FCachePath := '';

    FEnableFlashMovie:=False;

    for i:=Low(ArchiveTypeRecord) to High(ArchiveTypeRecord) do
      ArchiveEnabled[i]:=False;

    (* キャッシュ一覧用 (aiai) *)
    CacheListRect := '0, 0, 600, 500';
    CacheListColumnWidth := '200, 80, 50, 50, 150';
    CacheListSplit1 := 100;
    CacheListSplit2 := 100;

  end;

  IniFile.Free;

end;


destructor TImageViewConfig.Destroy;
begin
  SavePreference;
  QuickSavePoint.Free;
  inherited;
end;

procedure TImageViewConfig.SavePreference;
var
  IniFileName:TFileName;
  IniFile:TMemIniFile;
  Sections:TStringList;
  i:Integer;
begin

  IniFileName := ExtractFilePath(Application.ExeName)+'ImageView.ini';

  IniFile:=TMemIniFile.Create(IniFileName);

  Sections:=TStringList.Create;
  IniFile.ReadSections(Sections);
  for i:=0 to Sections.Count-1 do
    IniFile.EraseSection(Sections[i]);
  Sections.Free;

  IniFile.WriteBool('General','DisableImageViewer',DisableImageViewer);

  IniFile.WriteInteger('Position','Top',Top);
  IniFile.WriteInteger('Position','Left',Left);
  IniFile.WriteInteger('Position','Height',Height);
  IniFile.WriteInteger('Position','Width',Width);

  IniFile.WriteInteger('Tab','TabStyle',Ord(FTabStyle));
  IniFile.WriteBool('Tab','MultiLine',MultiLine);
  IniFile.WriteBool('Tab','ImageTab',ImageTab);
  IniFile.WriteBool('Tab','InvisibleTab',InvisibleTab);
  IniFile.WriteBool('Tab','ContinuousTabChange',ContinuousTabChange);
  IniFile.WriteBool('Tab','ShowDialogToSaveHighlightTab',ShowDialogToSaveHighlightTab);
  IniFile.WriteInteger('Tab','TabSelectAllType',Ord(TabSelectAllType));
  IniFile.WriteBool('Tab','UseTabNavigateIcon',UseTabNavigateIcon);
  IniFile.WriteBool('Tab','GoLeftWhenTabClose',GoLeftWhenTabClose);
  IniFile.WriteBool('Tab','ConnectedTabEdge',ConnectedTabEdge);

  IniFile.WriteBool('General','AlwaysProtect',AlwaysProtect);
  IniFile.WriteInteger('General','ProtectMosaicSize',ProtectMosaicSize);
  IniFile.WriteBool('General','AdjustToWindow',AdjustToWindow);
  IniFile.WriteBool('General','ScrollOpposite',ScrollOpposite);
  IniFile.WriteBool('General','HiddenMode',HiddenMode);

  IniFile.WriteBool('General','CloseAllTabIfFormClosed',CloseAllTabIfFormClosed);
  IniFile.WriteInteger('General','ShrinkType',Ord(FShrinkType));
  IniFile.WriteString('General','ExternalViewer',ExternalViewer);
  IniFile.WriteBool('General','DisableAlartAtOpenWithRelation',DisableAlartAtOpenWithRelation);

  IniFile.WriteBool('General','UseIndividualStatusBar',UseIndividualStatusBar);
  IniFile.WriteBool('General','SwapCtrlShift',SwapCtrlShift);

  IniFile.WriteBool('General','EnableFolding',EnableFolding);
  IniFile.WriteBool('General','ActivateViewerIfURLHasLoaded',ActivateViewerIfURLHasLoaded);
  IniFile.WriteBool('General','KeepTabVisible',KeepTabVisible);
  IniFile.WriteBool('General','DisableTitleBar',DisableTitleBar);
  IniFile.WriteBool('General','OpenImagesOnly',OpenImagesOnly);
  IniFile.WriteBool('General','OpenURLOnMouseOver',OpenURLOnMouseOver);

  IniFile.WriteBool('General','ForceToUseViewer',ForceToUseViewer);

  IniFile.WriteBool('PopUpHint','ShowImageHint',ShowImageHint);
  IniFile.WriteBool('PopUpHint','ShowImageOnImageHint',ShowImageOnImageHint);
  IniFile.WriteBool('PopUpHint','ShowCacheOnImageHint',ShowCacheOnImageHint);
  IniFile.WriteInteger('PopUpHint','ImageHintHeight',ImageHintHeight);
  IniFile.WriteInteger('PopUpHint','ImageHintWidth',ImageHintWidth);

  IniFile.WriteString('HTTP','UserAgent',UserAgent);
  IniFile.WriteInteger('HTTP','TimeOut',TimeOut);
  IniFile.WriteInteger('HTTP','RedirectMaximum',RedirectMaximum);
  IniFile.WriteInteger('HTTP','ConnectionLimit',ConnectionLimit);

  IniFile.WriteBool('StartUp','DeleteTmpOnStartUp',DeleteTmpOnStartUp);
  IniFile.WriteBool('StartUp','DisableDeleteTmpAlart',DisableDeleteTmpAlart);

  IniFile.WriteBool('Cache', 'UseViewCache', UseViewCache);
  IniFile.WriteBool('Cache', 'CacheSelectedFileOnly', CacheSelectedFileOnly);
  IniFile.WriteInteger('Cache', 'LifeSpanOfCache', LifeSpanOfCache);
  IniFile.WriteBool('Cache', 'PrioryCacheWhole', PrioryCacheWhole);
  IniFile.WriteBool('Cache', 'PrioryCacheImage', PrioryCacheImage);
  IniFile.WriteBool('Cache', 'PrioryCacheArchive', PrioryCacheArchive);
  IniFile.WriteString('Cache', 'PrioryCacheExtention', PrioryCacheExtention);
  IniFile.WriteString('Cache', 'CachePath', CachePath);

  IniFile.WriteBool('FLASH','EnableFlashMovie',EnableFlashMovie);

  IniFile.WriteBool('General', 'SpiEnabled', SpiEnabled);  //aiai

  for i:=0 to QuickSavePoint.Count-1 do
    IniFile.WriteString('QuickSavePoint',IntToStr(i),QuickSavePoint[i]);

  for i:=Low(ArchiveTypeRecord) to High(ArchiveTypeRecord) do
    IniFile.WriteBool('ArchiveEnabled',ArchiveTypeRecord[i].Ex,ArchiveEnabled[i]);

  (* キャッシュ一覧用 (aiai) *)
  IniFile.WriteString('Histroy', 'Rect', CacheListRect);
  IniFile.WriteString('Histroy', 'ColumnWidth', CacheListColumnWidth);
  IniFile.WriteInteger('Histroy', 'Split1', CacheListSplit1);
  IniFile.WriteInteger('Histroy', 'Split2', CacheListSplit2);

  IniFile.UpdateFile;
  IniFile.Free;

end;

function TImageViewConfig.OpenPreference(Sender:TComponent):Boolean;
var
  ImageViewPreference:TImageViewPreference;
  i,j:Integer;
  SPDelimiter:Integer;
  SPCaption,SPLocation:string;
begin

  ImageViewPreference:=TImageViewPreference.Create(Sender);

  ImageViewPreference.cbDisableImageViewer.Checked := DisableImageViewer;

  ImageViewPreference.rgTabStyle.ItemIndex:=Ord(TabStyle);
  ImageViewPreference.cbEnableMultiLineTab.Checked:=MultiLine;
  ImageViewPreference.cbImageTab.Checked:=ImageTab;
  ImageViewPreference.cbInvisibleTab.Checked:=InvisibleTab;
  ImageViewPreference.cbContinuousTabChange.Checked:=ContinuousTabChange;
  ImageViewPreference.cbShowDialogToSaveHighlightTab.Checked:=ShowDialogToSaveHighlightTab;
  ImageViewPreference.rgTabSelectAllType.Enabled:=not(ContinuousTabChange);
  ImageViewPreference.rgTabSelectAllType.ItemIndex:=Ord(TabSelectAllType);
  ImageViewPreference.cbUseTabNavigateIcon.Checked:=UseTabNavigateIcon;
  ImageViewPreference.cbGoLeftWhenTabClose.Checked:=GoLeftWhenTabClose;
  ImageViewPreference.cbConnectedTabEdge.Checked := ConnectedTabEdge;

  ImageViewPreference.cbAlwaysProtect.Checked:=AlwaysProtect;
  ImageViewPreference.seProtectMosaicSize.Value:=ProtectMosaicSize;
  ImageViewPreference.cbAdjustToWindow.Checked:=AdjustToWindow;
  ImageViewPreference.cbScrollOpposite.Checked:=ScrollOpposite;
  ImageViewPreference.cbHiddenMode.Checked:=HiddenMode;

  ImageViewPreference.cbCloseAllTabIfFormClosed.Checked:=CloseAllTabIfFormClosed;
  ImageViewPreference.rgShrinkType.ItemIndex:=Ord(FShrinkType);
  ImageViewPreference.ebExternalViewer.Text:=ExternalViewer;
  ImageViewPreference.cbDisableAlartAtOpenWithRelation.Checked:=DisableAlartAtOpenWithRelation;

  ImageViewPreference.cbUseIndividualStatusBar.Checked:=UseIndividualStatusBar;
  ImageViewPreference.cbSwapShiftCtrl.Checked:=SwapCtrlShift;

  ImageViewPreference.cbEnableFolding.Checked:=EnableFolding;
  ImageViewPreference.cbActivateViewerIfURLHasLoaded.Checked:=ActivateViewerIfURLHasLoaded;
  ImageViewPreference.cbKeepTabVisible.Checked:=FKeepTabVisible;
  ImageViewPreference.cbDisableTitleBar.Checked:=FDisableTitleBar;
  ImageViewPreference.cbOpenImagesOnly.Checked:=FOpenImagesOnly;
  ImageViewPreference.cbOpenURLOnMouseOver.Checked:=FOpenURLOnMouseOver;

  ImageViewPreference.cbForceToUseViewer.Checked:=ForceToUseViewer;

  ImageViewPreference.cbShowImageHint.Checked:=ShowImageHint;
  ImageViewPreference.cbShowImageOnImageHint.Checked:=ShowImageOnImageHint;
  ImageViewPreference.cbShowCacheOnImageHint.Checked:=ShowCacheOnImageHint;
  ImageViewPreference.seImageHintHeigtht.Value:=ImageHintHeight;
  ImageViewPreference.seImageHintWidth.Value:=ImageHintWidth;

  ImageViewPreference.cmbUserAgent.Text:=UserAgent;
  ImageViewPreference.seRedirectMaximum.Value:=RedirectMaximum;
  ImageViewPreference.seTimeOut.Value:=TimeOut div 1000;
  ImageViewPreference.seConnectionLimit.Value := ConnectionLimit;

  ImageViewPreference.cbDeleteTmpOnStartUp.Checked:=DeleteTmpOnStartUp;
  ImageViewPreference.cbDisableDeleteTmpAlart.Enabled:=DeleteTmpOnStartUp;

  ImageViewPreference.cbUseViewCache.Checked := UseViewCache;
  ImageViewPreference.cbCacheSelectedFileOnly.Checked := CacheSelectedFileOnly;
  ImageViewPreference.seLifeSpanOfCache.Value := LifeSpanOfCache;
  ImageViewPreference.cbPrioryCacheWhole.Checked := PrioryCacheWhole;
  ImageViewPreference.cbPrioryCacheImage.Checked := PrioryCacheImage;
  ImageViewPreference.cbPrioryCacheArchive.Checked := PrioryCacheArchive;
  ImageViewPreference.edPrioryCacheExtention.Text := Copy(PrioryCacheExtention, 2, Length(PrioryCacheExtention) - 2);
  ImageViewPreference.edCachePath.Text := CachePath;

  ImageViewPreference.cbEnableFlashMovie.Checked:=EnableFlashMovie;
  ImageViewPreference.cbEnableFlashMovie.Visible:=false;

  ImageViewPreference.cbSusiePluginsEnabled.Checked := SpiEnabled;
  ImageViewPreference.clbSusiePluginsEnabled.Enabled := SpiEnabled;

  if DeleteTmpOnStartUp then
    ImageViewPreference.cbDisableDeleteTmpAlart.Checked:=DisableDeleteTmpAlart
  else
    ImageViewPreference.cbDisableDeleteTmpAlart.Checked:=False;

  for i:=0 to QuickSavePoint.Count-1 do begin
    SPDelimiter:=LastDelimiter('/',QuickSavePoint[i]);
    SPCaption:=Copy(QuickSavePoint[i],1,SPDelimiter-1);
    SPLocation:=Copy(QuickSavePoint[i],SPDelimiter+1,65536);
    with ImageViewPreference.lvQuickSPList.Items.Add do begin
      Caption:=SPCaption;
      SubItems.Add(SPLocation);
    end;
  end;

  j:=0;
  for i:=Low(ArchiveTypeRecord) to High(ArchiveTypeRecord) do begin
    ImageViewPreference.clbArchiveEnabled.Items.Add(ArchiveTypeRecord[i].Ex);
    ImageViewPreference.clbArchiveEnabled.Checked[j]:=ArchiveEnabled[i];
    Inc(j);
  end;

  Result:=False;

  ImageViewPreference.PageControl1.ActivePageIndex := 0;

  (* Susieプラグイン読込情報の表示 (aiai) *)
  PreviewSusiePluginPreference(ImageViewPreference.clbSusiePluginsEnabled);

  if ImageViewPreference.ShowModal=mrOK then begin

    FDisableImageViewer := ImageViewPreference.cbDisableImageViewer.Checked;

    FTabStyle:=TTabStyle(ImageViewPreference.rgTabStyle.ItemIndex);
    FMultiLine:=ImageViewPreference.cbEnableMultiLineTab.Checked;
    FImageTab:=ImageViewPreference.cbImageTab.Checked;
    FInvisibleTab:=ImageViewPreference.cbInvisibleTab.Checked;
    FContinuousTabChange:=ImageViewPreference.cbContinuousTabChange.Checked;
    FShowDialogToSaveHighlightTab:=ImageViewPreference.cbShowDialogToSaveHighlightTab.Checked;
    FTabSelectAllType:=TTabSelectAllType(ImageViewPreference.rgTabSelectAllType.ItemIndex);
    FUseTabNavigateIcon:=ImageViewPreference.cbUseTabNavigateIcon.Checked;
    FGoLeftWhenTabClose:=ImageViewPreference.cbGoLeftWhenTabClose.Checked;
    FConnectedTabEdge:=ImageViewPreference.cbConnectedTabEdge.Checked;

    FAlwaysProtect:=ImageViewPreference.cbAlwaysProtect.Checked;
    FProtectMosaicSize:=ImageViewPreference.seProtectMosaicSize.Value;
    FAdjustToWindow:=ImageViewPreference.cbAdjustToWindow.Checked;
    FScrollOpposite:=ImageViewPreference.cbScrollOpposite.Checked;
    FHiddenMode:=ImageViewPreference.cbHiddenMode.Checked;

    FCloseAllTabIfFormClosed:=ImageViewPreference.cbCloseAllTabIfFormClosed.Checked;
    FShrinkType:=TShrinkType(ImageViewPreference.rgShrinkType.ItemIndex);
    FExternalViewer:=ImageViewPreference.ebExternalViewer.Text;
    FDisableAlartAtOpenWithRelation:=ImageViewPreference.cbDisableAlartAtOpenWithRelation.Checked;

    FUseIndividualStatusBar:=ImageViewPreference.cbUseIndividualStatusBar.Checked;
    FSwapCtrlShift:=ImageViewPreference.cbSwapShiftCtrl.Checked;

    FEnableFolding:=ImageViewPreference.cbEnableFolding.Checked;
    FActivateViewerIfURLHasLoaded:=ImageViewPreference.cbActivateViewerIfURLHasLoaded.Checked;
    FKeepTabVisible:=ImageViewPreference.cbKeepTabVisible.Checked;
    FDisableTitleBar:=ImageViewPreference.cbDisableTitleBar.Checked;
    FOpenImagesOnly:=ImageViewPreference.cbOpenImagesOnly.Checked;
    FOpenURLOnMouseOver := ImageViewPreference.cbOpenURLOnMouseOver.Checked;

    FForceToUseViewer:=ImageViewPreference.cbForceToUseViewer.Checked;

    FShowImageHint:=ImageViewPreference.cbShowImageHint.Checked;
    FShowImageOnImageHint:=ImageViewPreference.cbShowImageOnImageHint.Checked;
    FShowCacheOnImageHint:=ImageViewPreference.cbShowCacheOnImageHint.Checked;
    FImageHintHeight:=ImageViewPreference.seImageHintHeigtht.Value;
    FImageHintWidth:=ImageViewPreference.seImageHintWidth.Value;

    FUserAgent:=ImageViewPreference.cmbUserAgent.Text;
    FTimeOut:=ImageViewPreference.seTimeOut.Value*1000;
    FRedirectMaximum:=ImageViewPreference.seRedirectMaximum.Value;
    FConnectionLimit := ImageViewPreference.seConnectionLimit.Value;

    FDeleteTmpOnStartUp:=ImageViewPreference.cbDeleteTmpOnStartUp.Checked;
    FDisableDeleteTmpAlart:=ImageViewPreference.cbDisableDeleteTmpAlart.Checked;

    FUseViewCache := ImageViewPreference.cbUseViewCache.Checked;
    FCacheSelectedFileOnly := ImageViewPreference.cbCacheSelectedFileOnly.Checked;
    FLifeSpanOfCache := ImageViewPreference.seLifeSpanOfCache.Value;
    FPrioryCacheWhole := ImageViewPreference.cbPrioryCacheWhole.Checked;
    FPrioryCacheImage := ImageViewPreference.cbPrioryCacheImage.Checked;
    FPrioryCacheArchive := ImageViewPreference.cbPrioryCacheArchive.Checked;
    FPrioryCacheExtention := ';' + ImageViewPreference.edPrioryCacheExtention.Text + ';';
    FCachePath := ImageViewPreference.edCachePath.Text;

    FEnableFlashMovie:=ImageViewPreference.cbEnableFlashMovie.Checked;

    FSpiEnabled := ImageViewPreference.cbSusiePluginsEnabled.Checked;

    QuickSavePoint.Clear;
    for i:=0 to ImageViewPreference.lvQuickSPList.Items.Count-1 do
      with ImageViewPreference do
        QuickSavePoint.Add(lvQuickSPList.Items[i].Caption+'/'+lvQuickSPList.Items[i].SubItems[0]);

    j:=0;
    for i:=Low(ArchiveTypeRecord) to High(ArchiveTypeRecord) do begin
      ArchiveEnabled[i]:=ImageViewPreference.clbArchiveEnabled.Checked[j];
      Inc(j);
    end;

    {aiai}
    ImageForm.denyspilist := TStringList.Create;
    for i := 0 to ImageViewPreference.clbSusiePluginsEnabled.Count - 1 do
    begin
      if not ImageViewPreference.clbSusiePluginsEnabled.Checked[i] then
        ImageForm.denyspilist.Add(ImageForm.spilist.Strings[i])
    end;

    //プラグイン情報と消去
    for i := 0 to ImageForm.spilist.Count - 1 do
      TSPIINFO(ImageForm.spilist.Objects[i]).Free;
    ImageForm.spilist.Clear;
    //プラグインのオブジェクトを削除
    ImageForm.SPIs.Clear;
    //プラグインを読み込む
    ImageForm.SPIs.Search('*.spi');
    try //いちおtry
      ImageForm.denyspilist.SaveToFile(Config.BasePath + 'DeniedSPI.txt');
    finally
      FreeAndNil(ImageForm.denyspilist);
    end;
    {/aiai}

    Config.Save;
    SavePreference;
    Result:=True;
  end;

  ImageViewPreference.Free;

end;

procedure TImageViewConfig.GetIconBmp(const Name:String; var Bitmap:TBitmap);
begin
  Bitmap.LoadFromResourceName(HInstance,Name);
end;


//アーカイブの形式を判断
function TImageViewConfig.ExamArchiveType(Name:String):TArchiverType;
var
  i:Integer;
  Ext:string;
begin
  Result:=atNone;
  Ext:=ExtractFileExt(Name);
  if Ext<>'' then
    for i:=Low(ArchiveTypeRecord) to High(ArchiveTypeRecord) do
      if SameText(Ext,ArchiveTypeRecord[i].Ex) then begin
        Result:=ArchiveTypeRecord[i].Ac;
        Break;
      end;

end;

//拡張子が展開対象のアーカイブ拡張子か判定
function TImageViewConfig.ExamArchiveEnabled(Name:String):Boolean;
var
  i:Integer;
  Ext:string;
begin
  Result:=False;
  Ext:=ExtractFileExt(Name);
  if Ext<>'' then
    for i:=Low(ArchiveTypeRecord) to High(ArchiveTypeRecord) do
      if SameText(Ext,ArchiveTypeRecord[i].Ex) then begin
        Result:=ArchiveEnabled[i];
        Break;
      end;
end;

//拡張子が処理可能な画像ファイルか判定
function TImageViewConfig.ExamImageFile(Name: String): Boolean;
begin
  Result:=(AnsiPos('*'+LowerCase(ExtractFileExt(Name))+';',GraphicFileMask(TGraphic)+'*.jpg;*.jpeg;') > 0);
end;

//処理可能な拡張子か判定
function TImageViewConfig.ExamFileExt(Name:String): Boolean;
begin
  Result := ExamImageFile(Name) or ExamArchiveEnabled(Name);
end;

(* Susieプラグインの読込情報を表示する (aiai) *)
procedure TImageViewConfig.PreviewSusiePluginPreference(CheckListBox: TCheckListBox);
var
  i: Integer;
  spiinfo: TSPIINFO;
begin
  CheckListBox.Items.BeginUpdate;
  CheckListBox.Items.Clear;
  for i := 0 to ImageForm.spilist.Count - 1 do begin
    spiinfo := TSPIINFO(ImageForm.spilist.Objects[i]);
    CheckListBox.Items.Add(ImageForm.spilist.Strings[i] + ' [ ' + spiinfo.Extension + ' ]： ' + spiinfo.Infomation);
    CheckListBox.Checked[i] := spiinfo.Enabled;
  end;
  CheckListBox.Items.EndUpdate;
end;



{ TConfigHttpManager }

//キャッシュ優先かどうかの判定
function TConfigHttpManager.CheckCachePriority(URL: String): Boolean;
var
  Ext: String;
begin
  if VConfig.PrioryCacheWhole then
    Result := True
  else if VConfig.PrioryCacheImage and VConfig.ExamImageFile(URL) then
    Result := True
  else if VConfig.PrioryCacheArchive and VConfig.ExamArchiveEnabled(URL) then
    Result := True
  else begin
    Ext := ';' + ExtractFileExt(StringReplace(URL, '/','\', [rfReplaceAll])) + ';';
    if (Length(Ext) >= 4) and (Pos(Ext, VConfig.PrioryCacheExtention) > 0) then
      Result := True
    else
      Result := False;
  end;
end;
function TConfigHttpManager.CachePath: String;
begin
  if VConfig.CachePath <> '' then
    Result := VConfig.CachePath
  else
    Result := DefaultCachePath;
end;
function TConfigHttpManager.UserAgent: String;
begin
  Result := VConfig.UserAgent;
end;
function TConfigHttpManager.ConnectionLimit: Integer;
begin
  Result := VConfig.ConnectionLimit;
  if (Result > 5) or (Result < 1)  then
    Result := inherited ConnectionLimit;
end;
function TConfigHttpManager.ReadTimeout: Integer;
begin
  Result := VConfig.TimeOut;
  if (Result > 300000) or (Result < 1)  then
    Result := inherited ReadTimeout;
end;
function TConfigHttpManager.RedirectMaximum: Integer;
begin
  Result := VConfig.RedirectMaximum;
end;
function TConfigHttpManager.UseCache: Boolean;
begin
  Result := VConfig.UseViewCache;
end;
function TConfigHttpManager.SaveCacheEachTime: Boolean;
begin
  Result := not(VConfig.CacheSelectedFileOnly);
end;
function TConfigHttpManager.LifeSpanOfCache: Integer;
begin
  Result := VConfig.LifeSpanOfCache;
end;
function TConfigHttpManager.ProxyServer: String;
begin
  if MConfig.netUseProxy then
    Result := MConfig.netProxyServer
  else
    Result := '';
end;
function TConfigHttpManager.ProxyPort: Integer;
begin
  Result := MConfig.netProxyPort;
end;
procedure TConfigHttpManager.MsgOut(S: String);
begin
  Main.Log(S);
end;
function TConfigHttpManager.OffLine: Boolean;
begin
  Result := not MConfig.netOnline;
end;

{ TImageViewPreference }

procedure TImageViewPreference.SelectExternalViewer(Sender: TObject);
var
  ViewerName:string;
begin
  if PromptForFileName(ViewerName,'実行可能ファイル|*.exe;*.com;*.bat;*.vbs','','外部ビューアの選択') then
    ebExternalViewer.Text:=ViewerName;

end;

procedure TImageViewPreference.cbDeleteTmpOnStartUpClick(Sender: TObject);
begin
  if cbDeleteTmpOnStartUp.Checked then begin
    cbDisableDeleteTmpAlart.Enabled:=True;
  end else begin
    cbDisableDeleteTmpAlart.Enabled:=False;
    cbDisableDeleteTmpAlart.Checked:=False;
  end;
end;

procedure TImageViewPreference.DoOK(Sender: TObject);
begin
  if cmbUserAgent.Text='' then
    MessageDlg('ユーザーエージェントを設定してください',mtWarning,[mbOK],0)
  else
    ModalResult:=mrOK;
end;

procedure TImageViewPreference.cbEnableFoldingClick(Sender: TObject);
begin
  if cbEnableFolding.Checked then begin
    cbActivateViewerIfURLHasLoaded.Enabled:=True;
    cbKeepTabVisible.Enabled:=True;
  end else begin
    cbActivateViewerIfURLHasLoaded.Enabled:=False;
    cbKeepTabVisible.Enabled:=False;
  end;
end;

procedure TImageViewPreference.cbKeepTabVisibleClick(Sender: TObject);
begin
  if cbKeepTabVisible.Checked then begin
    cbDisableTitleBar.Enabled:=True;
  end else begin
    cbDisableTitleBar.Enabled:=False;
    cbDisableTitleBar.Checked:=False;
  end;
end;

procedure TImageViewPreference.cbShowImageOnImageHintClick(
  Sender: TObject);
begin
  if cbShowImageOnImageHint.Checked then begin
    seImageHintHeigtht.Enabled:=True;
    seImageHintWidth.Enabled:=True;
  end else begin
    seImageHintHeigtht.Enabled:=False;
    seImageHintWidth.Enabled:=False;
  end;
end;
procedure TImageViewPreference.btnMakeNewClick(Sender: TObject);
var
  NewItem:TListItem;
  SavePointDialog:TSavePointDialog;
begin
  SavePointDialog:=TSavePointDialog.Create(Self);
  if SavePointDialog.ShowDialog('','') then begin
    NewItem:=lvQuickSPList.Items.Add;
    NewItem.Caption:=SavePointDialog.SPCaption;
    NewItem.SubItems.Add(SavePointDialog.SPLocation);
    NewItem.Selected:=True;
    NewItem.Focused:=True;
  end;
  SavePointDialog.Free;
end;

procedure TImageViewPreference.btnDeleteClick(Sender: TObject);
begin
  lvQuickSPList.Selected.Free;
end;

procedure TImageViewPreference.btnUpClick(Sender: TObject);
var
  ListItem, SelItem :TListItem;
begin
  SelItem:=lvQuickSPList.Selected;
  ListItem:=lvQuickSPList.Items.Insert(SelItem.Index-1);
  ListItem.Assign(SelItem);
  SelItem.Free;
  ListItem.Selected:=True;
  ListItem.Focused:=True;
end;

procedure TImageViewPreference.btnDownClick(Sender: TObject);
var
  ListItem, SelItem :TListItem;
begin
  SelItem:=lvQuickSPList.Selected;
  ListItem:=lvQuickSPList.Items.Insert(SelItem.Index+2);
  ListItem.Assign(SelItem);
  SelItem.Free;
  ListItem.Selected:=True;
  ListItem.Focused:=True;
end;

procedure TImageViewPreference.lvQuickSPListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if lvQuickSPList.Selected=nil then begin
    btnEdit.Enabled:=False;
    btnUp.Enabled:=False;
    btnDown.Enabled:=False;
    btnDelete.Enabled:=False;
  end else begin
    btnEdit.Enabled:=True;
    btnDelete.Enabled:=True;
    if lvQuickSPList.Selected.Index=0 then
      btnUp.Enabled:=False
    else
      btnUp.Enabled:=True;

    if lvQuickSPList.Selected.Index=lvQuickSPList.Items.Count-1 then
      btnDown.Enabled:=False
    else
      btnDown.Enabled:=True;
  end;
end;

procedure TImageViewPreference.btnEditClick(Sender: TObject);
var
  SavePointDialog:TSavePointDialog;
begin
  SavePointDialog:=TSavePointDialog.Create(Self);
  if SavePointDialog.ShowDialog(lvQuickSPList.Selected.Caption,lvQuickSPList.Selected.SubItems[0]) then begin
    lvQuickSPList.Selected.Caption:=SavePointDialog.SPCaption;
    lvQuickSPList.Selected.SubItems[0]:=SavePointDialog.SPLocation;
  end;
  SavePointDialog.Free;
end;

procedure TImageViewPreference.cbContinuousTabChangeClick(Sender: TObject);
begin
  rgTabSelectAllType.Enabled:=not(cbContinuousTabChange.Checked);
end;

procedure TImageViewPreference.HitobashiraAlart(Sender: TObject);
begin
  if Visible and cbInvisibleTab.Checked then
    MessageDlg('「タブを表示しない」は動作検証をしていない人柱設定です。'#13#10#13#10+
                '書庫表示を使用する場合は、タブ動作の不具合防止のため必ず'#13#10+
                '「通常画像と書庫画像で連続的にタブ移動する」をチェックすること。',
                mtWarning,[mbOK],0);
end;

procedure TImageViewPreference.Button1Click(Sender: TObject);
var
  IniName: TFileName;
  MenuConfigFile: TMemIniFile;
  i,j:Integer;
begin
  IniName := ExtractFilePath(Application.ExeName) + MenuConfigFileName;
  try
    if FileExists(IniName) then DeleteFile(IniName);
    MenuConfigFile := TMemIniFile.Create(IniName);
    try
      with ImageForm.ImagePopUpMenu do begin
        for i := 0 to ImageForm.ImagePopUpMenu.Items.Count - 1 do begin
          if (Items[i].Name <> '') and (Items[i].Caption <> '-') then
            MenuConfigFile.WriteString('MENU', Items[i].Name,BoolToStr(not(Boolean(Items[i].Tag)), True)
                                       + #9 + ShortCutToText(Items[i].ShortCut) + #9 + Items[i].Caption);
          if Items[i].Count > 0 then
            for j := 0 to Items[i].Count - 1 do
              if (Items[i].Items[j].Name <> '') and (Items[i].Items[j].Caption <> '-') then
                MenuConfigFile.WriteString('MENU',Items[i].Items[j].Name,BoolToStr(
                     not(Boolean(Items[i].Items[j].Tag)), True) + #9 + ShortCutToText(
                     Items[i].Items[j].ShortCut) + #9 + Items[i].Items[j].Caption);
        end;
      end;
      MenuConfigFile.UpdateFile;
    finally
      MenuConfigFile.Free;
    end;
  except
    on e:Exception do
      MessageDlg('メニューコンフィグファイルの書き出しに失敗しました'#13#10 + e.Message, mtError, [mbOK], 0);
  end;
end;

procedure TImageViewPreference.cbDisableAlartAtOpenWithRelationClick(
  Sender: TObject);
begin
  if Visible and cbDisableAlartAtOpenWithRelation.Checked then begin
    if MessageDlg('「Windowsの関連づけで開く」はネット上のファイルを'#13#10+
                  'ローカル権限で開くコマンドです。警告なしでこのコマンドが'#13#10+
                  '実行される事の危険性を考慮して、チェックを外すか判断してください',mtWarning,[mbOk,mbCancel],0)<>mrOk then
      cbDisableAlartAtOpenWithRelation.Checked:=False;
  end;
end;

procedure TImageViewPreference.cbPrioryCacheWholeClick(Sender: TObject);
begin
  if cbPrioryCacheWhole.Checked then begin
    cbPrioryCacheImage.Checked := True;
    cbPrioryCacheArchive.Checked := True;
    cbPrioryCacheImage.Enabled := False;
    cbPrioryCacheArchive.Enabled := False;
    edPrioryCacheExtention.Enabled := False;
  end else begin
    cbPrioryCacheImage.Enabled := True;
    cbPrioryCacheArchive.Enabled := True;
    edPrioryCacheExtention.Enabled := True;
  end;
end;

procedure TImageViewPreference.btnSelectCachePathClick(Sender: TObject);
var
  SP:String;
begin
  if SelectDirectory('キャッシュ保存フォルダの選択', '', SP) then
    edCachePath.Text := SP;
end;

procedure TImageViewPreference.edCachePathKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE, VK_BACK: edCachePath.Text := '';
  end;
end;

procedure TImageViewPreference.edCachePathKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;


//マックバイナリ部分のスキップ
function SeekSkipMacBin(Stream: TStream): Boolean;
var
  Buf: array[1..128] of Char;
  Count: Integer;
  i:Integer;
begin
  Result := False;

  Stream.Seek(0, soFromBeginning);
  Count := Stream.Read(Buf, Length(Buf));

  if (Count >= 128) and (Buf[1]=#0) and (Buf[3]<>#0) and (Buf[75]=#0) then begin
    Result := True;
    for i := 3 to 64 do begin
      if (Buf[i] in [#1..#20]) or ((Buf[i] = #0) and (Buf[i+1] <> #0)) then begin
        Result := False;
        Break;
      end;
    end;
  end;

  if not Result then
    Stream.Seek(0, soFromBeginning);
end;

//aiai
procedure TImageViewPreference.cbSusiePluginsEnabledClick(Sender: TObject);
begin
  clbSusiePluginsEnabled.Enabled := cbSusiePluginsEnabled.Checked;
end;

initialization
  ImageViewConfig:=TImageViewConfig.Create;

finalization
  ImageViewConfig.Free;

end.
