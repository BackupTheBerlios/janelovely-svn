unit UConfig;
(* 設定画面 *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.70, 2004/08/13 06:33:57 *)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, StrUtils, ShlObj, ActiveX, HTMLDocumentEvent,
  JConfig, ExtCtrls, U2chTicket, UBase64, UCryptAuto, IniFiles, Menus,
  Grids, ValEdit,HogeTextView, JLWritePanel,
  UNGWordsAssistant, UAdvAboneRegist, Spin, Buttons, ExtDlgs;//beginner

const
{  NG_NAMES_FILE         = 'NGnames.txt';
  NG_ADDRS_FILE         = 'NGaddrs.txt';
  NG_WORDS_FILE         = 'NGwords.txt';
  NG_ID_FILE            = 'NGid.txt';
}
  GESTURE_PLACE_CHAR    = '◯▽■★☆'; //beginner

type
  TUIConfig = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    OpenDialog: TOpenDialog;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    PopupNGWord: TPopupMenu;
    MenuDeleteNGWord: TMenuItem;
    PageControl: TPageControl;
    SheetNet: TTabSheet;
    Label6: TLabel;
    Label9: TLabel;
    EditReadTimeout: TEdit;
    EditBBSMenuURL: TEdit;
    CheckBoxNetOnline: TCheckBox;
    CheckBoxNetUseReadCGI: TCheckBox;
    GroupBoxProxy: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label22: TLabel;
    CheckBoxNetUseProxy: TCheckBox;
    EditProxyServer: TEdit;
    EditProxyPort: TEdit;
    EditProxyPortForWriting: TEdit;
    EditProxyServerForWriting: TEdit;
    EditProxyServerForSSL: TEdit;
    EditProxyPortForSSL: TEdit;
    SheetPath: TTabSheet;
    Label7: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    CheckBoxBrowserSpecified: TCheckBox;
    EditBrowserPath: TEdit;
    ButtonSelBrowser: TButton;
    EditLogBasePath: TEdit;
    ButtonSelLogBaseFolder: TButton;
    ButtonSelSkinFolder: TButton;
    SheetAction: TTabSheet;
    GroupBox2: TGroupBox;
    CheckBoxOprSelPreviousThread: TCheckBox;
    CheckBoxOprShowSubjectCache: TCheckBox;
    CheckBoxOprOpenThreWNewView: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBoxOprScrollToNewRes: TCheckBox;
    RadioButtonOprScrollTop: TRadioButton;
    RadioButtonOprScrollBottom: TRadioButton;
    CheckBoxOprJumpToPrev: TCheckBox;
    GroupBox6: TGroupBox;
    CheckBoxOprOpenFavWNewView: TCheckBox;
    SheetOperation: TTabSheet;
    GroupBox4: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    ComboBoxOprBrdClick: TComboBox;
    ComboBoxOprBrdDblClk: TComboBox;
    ComboBoxOprBrdOther: TComboBox;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    ComboBoxOprThrClick: TComboBox;
    ComboBoxOprThrDblClk: TComboBox;
    ComboBoxOprThrOther: TComboBox;
    CheckBoxCatSingleClick: TCheckBox;
    SheetHint: TTabSheet;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label23: TLabel;
    CheckBoxUseHint4URL: TCheckBox;
    EditMaxHintWidth: TEdit;
    EditMaxHintHeight: TEdit;
    RadioGroupMethod: TRadioGroup;
    RadioButtonHintUseGet: TRadioButton;
    RadioButtonHintUseHead: TRadioButton;
    EditHintMaxSize: TEdit;
    EditHintWaitTime: TEdit;
    EditHintCancelGetExt: TEdit;
    CheckBoxHintEnabled: TCheckBox;
    SheetForTest: TTabSheet;
    CheckBoxComm: TCheckBox;
    CheckBoxOprDisableTabInView: TCheckBox;
    CheckBoxOptEnableBoardMenu: TCheckBox;
    SheetDangerous: TTabSheet;
    CheckBoxDatDelOOTLog: TCheckBox;
    Memo1: TMemo;
    SheetUserInfo: TTabSheet;
    GroupBoxUser: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    EditUserID: TEdit;
    EditPassword: TEdit;
    CheckBoxAutoAuth: TCheckBox;
    ButtonManualConnect: TButton;
    GroupBoxRem: TGroupBox;
    Label21: TLabel;
    EditPassphrase: TEdit;
    ButtonRemenberPasswd: TButton;
    PanelStat: TPanel;
    CheckBoxSetPassphrase: TCheckBox;
    SheetTab: TTabSheet;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    CheckBoxStlTabMultiline: TCheckBox;
    EditStlTabHeight: TEdit;
    EditStlTabWidth: TEdit;
    EditStlListTabWidth: TEdit;
    EditStlListTabHeight: TEdit;
    RadioGroupTreeTabStyle: TRadioGroup;
    RadioGroupListTabStyle: TRadioGroup;
    RadioGroupThreadTabStyle: TRadioGroup;
    SheetMouse: TTabSheet;
    Label27: TLabel;
    EditMseGestureMargin: TEdit;
    CheckBoxMseUseWheelTabChange: TCheckBox;
    SheetColors: TTabSheet;
    GroupBox7: TGroupBox;
    MemoLog: TMemo;
    MemoTextView: TMemo;
    MemoList: TMemo;
    MemoFavorite: TMemo;
    MemoTree: TMemo;
    MemoDefault: TMemo;
    MemoThreadTitle: TMemo;
    GroupBox8: TGroupBox;
    ButtonTraceFont: TButton;
    ButtonListFont: TButton;
    ButtonDefFont: TButton;
    ButtonTreeFont: TButton;
    ButtonAllFonts: TButton;
    ButtonThreadTitleFont: TButton;
    GroupBox9: TGroupBox;
    ButtonTextColor: TButton;
    ButtonListColor: TButton;
    ButtonFavoriteColor: TButton;
    ButtonLogColor: TButton;
    ButtonTreeColor: TButton;
    ButtonAllColors: TButton;
    ButtonThreadTitleColor: TButton;
    SheetWrite: TTabSheet;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    CheckBoxWrtRecordWriting: TCheckBox;
    MemoWrtNameList: TMemo;
    MemoWrtMailList: TMemo;
    CheckBoxWrtDefaultSage: TCheckBox;
    EditWrtReplyMark: TEdit;
    CheckBoxTstCloseOnSuccess: TCheckBox;
    SheetAbone: TTabSheet;
    ButtonAddNGWord: TButton;
    ButtonDeleteNGWord: TButton;
    EditNG: TEdit;
    PageControlNGWord: TPageControl;
    Sheet_NGName: TTabSheet;
    ListBoxNGName: TListBox;
    Sheet_NGAddr: TTabSheet;
    ListBoxNGAddr: TListBox;
    Sheet_NGWord: TTabSheet;
    ListBoxNGWord: TListBox;
    CheckBoxViewTransparencyAbone: TCheckBox;
    SheetCommand: TTabSheet;
    Label35: TLabel;
    ValueListCommand: TValueListEditor;
    SheetStyle: TTabSheet;
    CheckBoxStlThreadToolBar: TCheckBox;
    CheckBoxStlThreadTitle: TCheckBox;
    Label18: TLabel;
    EditOptCharsInTab: TEdit;
    CheckBoxStlLinkBarIcons: TCheckBox;
    CheckBoxStlTreeIcons: TCheckBox;
    CheckBoxStlTabIcons: TCheckBox;
    CheckBoxStlListMarkIcons: TCheckBox;
    CheckBoxOptSaveLastItems: TCheckBox;
    CheckBoxOptAllowFavoriteDuplicate: TCheckBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    CheckBoxOprBoardExpandOneCategory: TCheckBox;
    CheckBoxStlListExtraBackColor: TCheckBox;
    MemoListOdd: TMemo;
    MemoListEven: TMemo;
    Button1: TButton;
    Button2: TButton;
    CheckBoxOprOpenBoardWNewTab: TCheckBox;
    CheckBoxStlShowTreeMarks: TCheckBox;
    CheckBoxStlListTitleIcons: TCheckBox;
    ButtonMseLeft: TButton;
    ButtonMseUp: TButton;
    ButtonMseClear: TButton;
    ButtonMseDown: TButton;
    ButtonMseRight: TButton;
    ComboBoxMseGestures: TComboBox;
    ComboBoxMseMenus: TComboBox;
    Label39: TLabel;
    Label40: TLabel;
    GroupBox12: TGroupBox;
    ValueListMouseGesture: TValueListEditor;
    ComboBoxMseSubMenus: TComboBox;
    ButtonMseAdd: TButton;
    ButtonMseDelete: TButton;
    Label38: TLabel;
    ComboBoxOprThrMenu: TComboBox;
    Label41: TLabel;
    ComboBoxOprBrdMenu: TComboBox;
    CheckBoxStlMenuIcons: TCheckBox;
    Label42: TLabel;
    EditRecvBufferSize: TEdit;
    CheckBoxHint4OtherThread: TCheckBox;
    CheckBoxWrtShowThreadTitle: TCheckBox;
    MemoWrite: TMemo;
    Label43: TLabel;
    ButtonWriteFont: TButton;
    Label44: TLabel;
    Label45: TLabel;
    SkinPathBox: TComboBox;
    CheckBoxOptEnableFavMenu: TCheckBox;
    TreeView: TTreeView;
    Sheet_NGid: TTabSheet;
    ListBoxNGid: TListBox;
    CheckBoxOprCheckNewWRedraw: TCheckBox;
    SheetDoe: TTabSheet;
    Label46: TLabel;
    EditViewVerticalCaretMargin: TEdit;
    GroupBox13: TGroupBox;
    RadioButtonViewLineScroll: TRadioButton;
    RadioButtonViewPageScroll: TRadioButton;
    EditViewScrollLines: TEdit;
    Label48: TLabel;
    CheckBoxWrtFmUseTaskBar: TCheckBox;
    SheetColumn: TTabSheet;
    ListBoxClmnRest: TListBox;
    ListBoxClmnSelected: TListBox;
    ButtonClmnAdd: TButton;
    ButtonClmnDel: TButton;
    Label50: TLabel;
    Label51: TLabel;
    ButtonClmnUp: TButton;
    ButtonClmnDown: TButton;
    ButtonCmdAdd: TButton;
    ButtonCmdDel: TButton;
    EditCmdName: TLabeledEdit;
    EditCmdExe: TLabeledEdit;
    ButtonCmdIns: TButton;
    ButtonCmdUp: TButton;
    ButtonCmdDown: TButton;
    ButtonResetSID: TButton;
    CheckBoxWrtUseDefaultName: TCheckBox;
    CheckBoxNetNoCache: TCheckBox;
    CheckBoxCaretVisible: TCheckBox;
    ComboBoxOprDrawLines: TComboBox;
    Label47: TLabel;
    SheetTabOperation: TTabSheet;
    GroupBox14: TGroupBox;
    Label49: TLabel;
    Label53: TLabel;
    ComboBoxOprAddPosNormal: TComboBox;
    ComboBoxOprAddPosRelative: TComboBox;
    Label54: TLabel;
    ComboBoxOprClosePos: TComboBox;
    GroupBox15: TGroupBox;
    CheckBoxOprThreBgOpen: TCheckBox;
    CheckBoxOprFavBgOpen: TCheckBox;
    CheckBoxOprClosedBgOpen: TCheckBox;
    CheckBoxOprAddrBgOpen: TCheckBox;
    CheckBoxOprUrlBgOpen: TCheckBox;
    Label55: TLabel;
    EditZoomPoint0: TEdit;
    EditZoomPoint1: TEdit;
    EditZoomPoint2: TEdit;
    EditZoomPoint3: TEdit;
    EditZoomPoint4: TEdit;
    SpinEditRecyclableCount: TSpinEdit;
    LabelRecyclableCount: TLabel;
    CheckBoxDiscrepancyWarning: TCheckBox;
    CheckBoxDisableStatusBar: TCheckBox;
    ButtonHintFont: TButton;
    ButtonHintFontLink: TButton;
    MemoHint: TMemo;
    MemoHintFix: TMemo;
    ButtonHintColor: TButton;
    ButtonHintColorFix: TButton;
    CheckBoxNestingPopUp: TCheckBox;
    LabelAutoEnableNesting: TLabel;
    SpinEditHintHoverTime: TSpinEdit;
    CheckBoxAutoEnableNesting: TCheckBox;
    SpinEditHintHintHoverTime: TSpinEdit;
    CheckBoxHintAutoEnableNesting: TCheckBox;
    LabelHoverTime: TLabel;
    {beginner}
    MenuNGWordNormal: TMenuItem;
    MenuNGWordTransparent: TMenuItem;
    MenuNGWordMarking: TMenuItem;
    N1: TMenuItem;
    MenuNGWordLife: TMenuItem;
    MenuNGWordLifeDef: TMenuItem;
    MenuNGWordLife3: TMenuItem;
    MenuNGWordLife14: TMenuItem;
    MenuNGWordLife60: TMenuItem;
    MenuNGWordLifeForever: TMenuItem;
    LabelMsePlace: TLabel;
    ComboBoxMsePlace: TComboBox;
    seCheckNewThreadInHour: TSpinEdit;
    LabelCheckNewThreadInHour: TLabel;
    CheckBoxStlSmallLogPanel: TCheckBox;
    SheetForView: TTabSheet;
    CheckBoxAllowTreeDup: TCheckBox;
    SpinEditLenofOutLineRes: TSpinEdit;
    LabelLenofOutLineRes: TLabel;
    RadioButtonLogPanelUnderBoard: TRadioButton;
    RadioButtonLogPanelUnderThread: TRadioButton;
    SpinEditViewScrollSmoothness: TSpinEdit;
    LabelViewScrollSmoothness: TLabel;
    LabelViewScrollFrameRate: TLabel;
    SpinEditViewScrollFrameRate: TSpinEdit;
    CheckBoxViewEnableAutoScroll: TCheckBox;
    TabSheet1: TTabSheet;
    ListBoxNGEx: TListBox;
    SheetTabColor: TTabSheet;
    MemoDefaultActive: TMemo;
    MemoNewActive: TMemo;
    ButtonActiveBack: TButton;
    ButtonNoActiveBack: TButton;
    MemoProcessActive: TMemo;
    MemoDefaultNoActive: TMemo;
    MemoNewNoActive: TMemo;
    ButtonDefaultText: TButton;
    ButtonNewText: TButton;
    ButtonProcessText: TButton;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    MemoProcessNoActive: TMemo;
    Label56: TLabel;
    MemoDisableWriteActive: TMemo;
    MemoDisableWriteNoAcitve: TMemo;
    ButtonDisableWriteText: TButton;
    MemoWriteWait: TMemo;
    ButtonWriteWait: TButton;
    ShowDayOfWeekCheckBox: TCheckBox;
    MemoAutoReload: TMemo;
    ButtonAutoReload: TButton;
    Label57: TLabel;
    EditOptChottoView: TEdit;
    ButtonNew2Text: TButton;
    MemoNew2Active: TMemo;
    MemoNew2NoActive: TMemo;
    Sheet_Option: TTabSheet;
    CheckBoxLinkAbone: TCheckBox;
    CheckBoxoptSetFocusOnWriteMemo: TCheckBox;
    CheckBoxIDPopUp: TCheckBox;
    SpinEditIDPopUpMaxCount: TSpinEdit;
    Label58: TLabel;
    Label59: TLabel;
    SpinEditOpenNewResThreadLimit: TSpinEdit;
    CheckBoxOldOnCheckNew: TCheckBox;
    CheckBoxReadIfScrollBottom: TCheckBox;
    cbPermanentNG: TCheckBox;
    cbPermanentMarking: TCheckBox;
    seNGItemLifeSpan: TSpinEdit;
    Label60: TLabel;
    seNGIDLifeSpan: TSpinEdit;
    cmbAboneLevel: TComboBox;
    Label61: TLabel;
    Label62: TLabel;
    CheckBoxHideInTaskTray: TCheckBox;
    CheckBoxColordNumber: TCheckBox;
    MemoLinkedNumColor: TMemo;
    ButtonColordNumber: TButton;
    CheckBoxIDPopOnMOver: TCheckBox;
    CheckBoxIDLinkColor: TCheckBox;
    MemoIDLinkColorMany: TMemo;
    MemoIDLinkColorNone: TMemo;
    ButtonIDLinkColorMany: TButton;
    ButtonIDLinkColorNone: TButton;
    Label63: TLabel;
    SpinEditIDLinkThreshold: TSpinEdit;
    CheckBoxQuickMerge: TCheckBox;
    MemoWriteMemo: TMemo;
    ButtonWriteMemoFont: TButton;
    ButtonWriteMemoColor: TButton;
    SheetFavPatrol: TTabSheet;
    CheckBoxFavPatrolOpenNewResThread: TCheckBox;
    CheckBoxCheckThreadMadeAfterLstMdfy2: TCheckBox;
    GroupBox19: TGroupBox;
    Label65: TLabel;
    Label66: TLabel;
    SpinEditListReloadInterval: TSpinEdit;
    SpinEditThreadReloadInterval: TSpinEdit;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    ComboBoxDefSortColumn: TComboBox;
    Label70: TLabel;
    ComboBoxDefFuncSortColumn: TComboBox;
    CheckBoxFavPatrolMessageBox: TCheckBox;
    CheckBoxFavPatrolOpenBack: TCheckBox;
    CheckBoxFavPatrolCheckServerDown: TCheckBox;
    CheckBoxoptCheckNewResSingleClick: TCheckBox;
    CheckBoxWheelScrollUnderCursor: TCheckBox;
    NGThread: TTabSheet;
    ListBoxNGThread: TListBox;
    procedure FormShow(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ButtonSelBrowserClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure ButtonSelFolderClick(Sender: TObject);
    (* User設定画面操作 *)
    procedure ButtonManualConnectClick(Sender: TObject);
    procedure ButtonResetSIDClick(Sender: TObject);
    procedure EditPassphraseChange(Sender: TObject);
    procedure ButtonRemenberPasswdClick(Sender: TObject);
    procedure CheckBoxAutoAuthClick(Sender: TObject);
    (* NG設定画面操作 *)
    procedure ButtonAddNGWordClick(Sender: TObject);
    procedure ButtonDeleteNGWordClick(Sender: TObject);
    procedure ListBoxNGWordClick(Sender: TObject);
    (* フォント設定画面操作 *)
    procedure ButtonColorClick(Sender: TObject);
    procedure ButtonFontClick(Sender: TObject);
    procedure SetMainwndColors;
    procedure SetFonts;
    (* マウスジェスチャー設定画面操作 *)
    procedure ButtonMseClearClick(Sender: TObject);
    procedure ButtonMseArrowClick(Sender: TObject);
    procedure ComboBoxMseSubMenusDropDown(Sender: TObject);
    procedure ButtonMseAddClick(Sender: TObject);
    procedure ButtonMseDeleteClick(Sender: TObject);
    procedure ComboBoxMseGesturesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    (* スレ覧カラム設定画面操作 *)
    procedure ButtonClmnAddClick(Sender: TObject);
    procedure ButtonClmnDelClick(Sender: TObject);
    procedure ButtonClmnUpClick(Sender: TObject);
    procedure ButtonClmnDownClick(Sender: TObject);
    procedure ListBoxClmnRestKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxClmnSelectedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    (* コマンド設定画面操作 *)
    procedure ButtonCmdAddClick(Sender: TObject);
    procedure ButtonCmdInsClick(Sender: TObject);
    procedure ButtonCmdDelClick(Sender: TObject);
    procedure ValueListCommandSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure ButtonCmdUpClick(Sender: TObject);
    procedure ButtonCmdDownClick(Sender: TObject);
    procedure ValueListCommandKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBoxAutoEnableNestingClick(Sender: TObject);
    procedure CheckBoxHintAutoEnableNestingClick(Sender: TObject);
    {beginner}
    procedure ListBoxNGWordMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ListBoxNGNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MenuNGWordTypeClick(Sender: TObject);
    procedure NGWordLifeClick(Sender: TObject);
    procedure PopupNGWordPopup(Sender: TObject);
    procedure ListBoxNGNameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBoxMsePlaceSelect(Sender: TObject);
    procedure ComboBoxMseGesturesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxMseGesturesDropDown(Sender: TObject);
    procedure ComboBoxMseGesturesSelect(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    {/beginner}
    {aiai}
    procedure ButtonBackColorClick(Sender: TObject);
    procedure ButtonTextColorClick(Sender: TObject);
    procedure cbPermanentNGClick(Sender: TObject);
    procedure ButtonColordNumberClick(Sender: TObject);
    procedure ButtonIDLinkColorManyClick(Sender: TObject);
    procedure ButtonIDLinkColorNoneClick(Sender: TObject);
    {/aiai}
  private
    AboneListOnHint:TObject;
    AboneListIndexOnHint:Integer;
    {beginner}
    PreserveMseGesture: string;
    procedure CustomWndProc(var Message: TMessage);
    procedure AdvAboneRegistChangeName(Sender: TObject; OldName, NewName: String; CanChange: Boolean);
    {/beginner}
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  UIConfig: TUIConfig;

function BrowseCallback(hWnd: HWND; uMsg: UINT; lParam: LPARAM; lpData: LPARAM): integer; stdcall; export;


implementation

{$R *.dfm}

uses
  Main, UDat2HTML, UImageHint;

const
  UM_CHANGECOMBOBOX = WM_USER + 1;

procedure TUIConfig.OkButtonClick(Sender: TObject);
  function MakePassphrased: boolean;
  var
    crypt: THogeCryptAuto;
    inStream, outStream: TStringStream;
    phrase: string;
  begin
    result := false;
    phrase := self.EditPassphrase.Text;
    if length(phrase) < 6 then
      exit;
    crypt := THogeCryptAuto.Create;
    inStream := TStringStream.Create(self.EditPassword.Text);
    outStream:= TStringStream.Create('');
    if crypt.Encrypt(inStream, phrase, outStream) then
    begin
      Main.Config.accPassphrasedPasswd := HogeBase64Encode(outStream.DataString);
      result := true;
    end;
    crypt.Free;
    inStream.Free;
    outStream.Free;
  end;
  {beginner}
  procedure SaveNGWords(fn:String; lb:TListBox; Ex: Boolean);
  var
    nglist:TBaseNGStringList;
  begin
    if (lb.Items.Count > 0) or FileExists(config.basepath + fn) then begin
      if Ex then
        nglist := TExNGList.Create
      else
        nglist:=TNGStringList.Create;
      nglist.Assign(lb.items);
      nglist.SaveToFile(config.basepath + fn);
      nglist.Free;
    end;
  end;
  {/beginner}
  procedure SaveNGThreadList(fn: String; lb: TListBox);
  begin
    if (lb.Items.Count > 0) or FileExists(Config.BasePath + fn) then
    begin
      lb.Items.SaveToFile(Config.BasePath + fn);
    end;
  end;

var
  port: integer;
  port4write: integer;
  port4SSL: integer;
  maxwidth, maxheight, maxsize, timeout, buffersize: integer;
  clearCache: boolean;
  waitTime: integer;
  charsInTab: integer;
  i: integer;
begin
  Main.Config.LogConfPath := self.EditLogBasePath.Text;
  Main.Config.SkinConfPath := self.SkinPathBox.Text;

  port := 0;
  if 0 < length(EditProxyServer.Text) then
  begin
    try
      port := StrToInt(EditProxyPort.Text);
    except
      self.PageControl.ActivePageIndex := 0;
      self.EditProxyPort.SetFocus;
      MessageDlg('port', mtError, [mbOK], 0);
      exit;
    end;
  end;
  port4write := 0;
  if 0 < length(EditProxyServerForWriting.Text) then
  begin
    try
      port4write := StrToInt(EditProxyPortForWriting.Text);
    except
      self.PageControl.ActivePageIndex := 0;
      self.EditProxyPortForWriting.SetFocus;
      MessageDlg('port(書込み用)', mtError, [mbOK], 0);
      exit;
    end;
  end;
  port4SSL := 0;
  if 0 < length(self.EditProxyPortForSSL.Text) then
  begin
    try
      port4SSL := StrToInt(self.EditProxyPortForSSL.Text);
    except
      self.PageControl.ActivePageIndex := 0;
      self.EditProxyPortForSSL.SetFocus;
      MessageDlg('port(SSL)', mtError, [mbOK], 0);
      exit;
    end;
  end;
  try
    timeout := StrToInt(self.EditReadTimeout.Text);
  except
    self.PageControl.ActivePageIndex := 0;
    self.EditReadTimeout.SetFocus;
    MessageDlg('受信タイムアウト', mtError, [mbOK], 0);
    exit;
  end;
  try
    buffersize := StrToInt(self.EditRecvBufferSize.Text);
    if buffersize <= 0 then
      raise Exception.Create('');
  except
    self.PageControl.ActivePageIndex := 0;
    self.EditRecvBufferSize.SetFocus;
    MessageDlg('受信バッファサイズ', mtError, [mbOK], 0);
    exit;
  end;
  try
    maxsize := StrToInt(self.EditHintMaxSize.Text);
  except
    self.PageControl.ActivePageIndex := 4;
    self.EditHintMaxSize.SetFocus;
    MessageDlg('最大バイト数', mtError, [mbOK], 0);
    exit;
  end;
  try
    maxwidth := StrToInt(self.EditMaxHintWidth.Text);
  except
    self.PageControl.ActivePageIndex := 4;
    self.EditMaxHintWidth.SetFocus;
    MessageDlg('最大表示幅', mtError, [mbOK], 0);
    exit;
  end;
  try
    maxheight := StrToInt(self.EditMaxHintHeight.Text);
  except
    self.PageControl.ActivePageIndex := 4;
    self.EditMaxHintHeight.SetFocus;
    MessageDlg('最大表示高', mtError, [mbOK], 0);
    exit;
  end;
  try
    waitTime := StrToInt(self.EditHintWaitTime.Text);
  except
    self.PageControl.ActivePageIndex := 4;
    self.EditHintWaitTime.SetFocus;
    MessageDlg('ヒント表示待ち時間', mtError, [mbOK], 0);
    exit;
  end;
  try
    charsInTab := StrToInt(self.EditOptCharsInTab.Text);
    if charsInTab <= 0 then
      raise ERangeError.Create('');
  except
    self.PageControl.ActivePageIndex := 13;
    self.EditOptCharsInTab.SetFocus;
    MessageDlg('タブ文字数', mtError, [mbOK], 0);
    exit;
  end;

  Main.Config.proxyCrt.Enter;
  if Main.Config.accUserID <> self.EditUserID.Text then
  begin
    Main.Config.accUserID := self.EditUserID.Text;
    Main.Config.tmpChanged := true;
  end;
  if Main.Config.accPasswd <> self.EditPassword.Text then
  begin
    Main.Config.accPasswd := self.EditPassword.Text;
    Main.Config.tmpChanged := true;
  end;
  if Main.Config.accAutoAuth <> self.CheckBoxAutoAuth.Checked then
  begin
    Main.Config.accAutoAuth := self.CheckBoxAutoAuth.Checked;
    Main.Config.tmpChanged := true;
  end;
  if MakePassphrased then
    Main.Config.tmpChanged := true;
  if Main.Config.netUseProxy <> self.CheckBoxNetUseProxy.Checked then
  begin
    Main.Config.netUseProxy := self.CheckBoxNetUseProxy.Checked;
    Main.Config.tmpChanged := true;
  end;
  if Main.Config.netNoCache <> self.CheckBoxNetNoCache.Checked then
  begin
    Main.Config.netNoCache := self.CheckBoxNetNoCache.Checked;
    Main.Config.tmpChanged := true;
  end;
  if Main.Config.netProxyServerForSSL <> self.EditProxyServerForSSL.Text then
  begin
    Main.Config.netProxyServerForSSL := self.EditProxyServerForSSL.Text;
    Main.Config.tmpChanged := true;
  end;
  if Main.Config.netProxyPortForSSL <> port4SSL then
  begin
    Main.Config.netProxyPortForSSL := port4SSL;
    Main.Config.tmpChanged := true;
  end;
  Main.Config.proxyCrt.Leave;

  Main.Config.netProxyServer := EditProxyServer.Text;
  Main.Config.netProxyPort := port;
  Main.Config.netReadTimeout := timeout;
  Main.Config.netRecvBufferSize := buffersize;
  (*
  Main.Config.netProxyServerForWriting := Main.Config.netProxyServer;
  Main.Config.netProxyPortForWriting   := Main.Config.netProxyPort;
  *)
  Main.Config.netProxyServerForWriting := EditProxyServerForWriting.Text;
  Main.Config.netProxyPortForWriting   := port4write;
  Main.Config.netOnline := self.CheckBoxNetOnline.Checked;
  Main.Config.netUseReadCGI := self.CheckBoxNetUseReadCGI.Checked;

  Main.Config.extBrowserSpecified := self.CheckBoxBrowserSpecified.Checked;
  Main.Config.extBrowserPath := self.EditBrowserPath.Text;
  Main.Config.tstCommHeaders := self.CheckBoxComm.Checked;

  clearCache := false;
  if (Main.Config.hintForURLMaxSize <> maxsize) or
     (Main.Config.hintForURLUseHead <> self.RadioButtonHintUseHead.Checked) then
    clearCache := true;

  Main.Config.hintEnabled := self.CheckBoxHintEnabled.Checked;
  Main.Config.hintHoverTime := Self.SpinEditHintHoverTime.Value;
  Main.Config.hintHintHoverTime := Self.SpinEditHintHintHoverTime.Value;
  Main.Config.hintForOtherThread := self.CheckBoxHint4OtherThread.Checked;
  Main.Config.hintNestingPopUp := self.CheckBoxNestingPopUp.Checked;
  Main.Config.hintAutoEnableNesting := self.CheckBoxAutoEnableNesting.Checked;
  Main.Config.hintHintAutoEnableNesting := self.CheckBoxHintAutoEnableNesting.Checked;
  Main.Config.hintForURL := self.CheckBoxUseHint4URL.Checked;
  Main.Config.hintForURLMaxSize := maxsize;
  Main.Config.hintForURLWidth := maxwidth;
  Main.Config.hintForURLHeight := maxheight;
  Main.Config.hintForURLUseHead := self.RadioButtonHintUseHead.Checked;
  Main.Config.hintForURLWaitTime := waitTime;
  Main.Config.hintCancelGetExt.CommaText := self.EditHintCancelGetExt.Text;

  Main.Config.oprCatBySingleClick := self.CheckBoxCatSingleClick.Checked;
  Main.Config.oprShowSubjectCache := self.CheckBoxOprShowSubjectCache.Checked;
  Main.Config.oprSelPreviousThread := self.CheckBoxOprSelPreviousThread.Checked;
  Main.Config.oprScrollToNewRes := self.CheckBoxOprScrollToNewRes.Checked;
  Main.Config.oprScrollTop := self.RadioButtonOprScrollTop.Checked;
  Main.Config.oprScrollToPreviousRes := self.CheckBoxOprJumpToPrev.Checked;
  //Main.Config.oprToggleRView := not self.CheckBox3PaneMode.Checked;
  //Main.Config.oprTabStopOnTracePane := self.CheckBoxTabStopOnTracePane.Checked;
  Main.Config.oprDisableTabKeyInView := self.CheckBoxOprDisableTabInView.Checked;
  Main.Config.oprBoardTreeExpandOneCategory := self.CheckBoxOprBoardExpandOneCategory.Checked;
  Main.Config.oprCheckNewWRedraw  := self.CheckBoxOprCheckNewWRedraw.Checked;
  Main.Config.oprOpenThreWNewView := self.CheckBoxOprOpenThreWNewView.Checked;
  Main.Config.oprOpenFavWNewView  := self.CheckBoxOprOpenFavWNewView.Checked;
  Main.Config.oprOpenBoardWNewTab := self.CheckBoxOprOpenBoardWNewTab.Checked;
  Main.Config.oprDrawLines := self.ComboBoxOprDrawLines.ItemIndex;

  //Main.Config.oprAlwaysCheck := not self.CheckBoxDblClkMode.Checked;
  Main.Config.oprGestureBrdClick := TGestureOprType(self.ComboBoxOprBrdClick.ItemIndex);
  Main.Config.oprGestureBrdDblClk := TGestureOprType(self.ComboBoxOprBrdDblClk.ItemIndex);
  Main.Config.oprGestureBrdMenu := TGestureOprType(self.ComboBoxOprBrdMenu.ItemIndex);
  Main.Config.oprGestureBrdOther := TGestureOprType(self.ComboBoxOprBrdOther.ItemIndex);
  Main.Config.oprGestureThrClick := TGestureOprType(self.ComboBoxOprThrClick.ItemIndex);
  Main.Config.oprGestureThrDblClk := TGestureOprType(self.ComboBoxOprThrDblClk.ItemIndex);
  Main.Config.oprGestureThrMenu := TGestureOprType(self.ComboBoxOprThrMenu.ItemIndex);
  Main.Config.oprGestureThrOther := TGestureOprType(self.ComboBoxOprThrOther.ItemIndex);

  Main.Config.oprThreBgOpen   := self.CheckBoxOprThreBgOpen.Checked;
  Main.Config.oprFavBgOpen    := self.CheckBoxOprFavBgOpen.Checked;
  Main.Config.oprClosedBgOpen := self.CheckBoxOprClosedBgOpen.Checked;
  Main.Config.oprAddrBgOpen   := self.CheckBoxOprAddrBgOpen.Checked;
  Main.Config.oprUrlBgOpen    := self.CheckBoxOprUrlBgOpen.Checked;

  Main.Config.oprAddPosNormal := TTabAddPos(self.ComboBoxOprAddPosNormal.ItemIndex);
  Main.Config.oprAddPosRelative := TTabAddPos(self.ComboBoxOprAddPosRelative.ItemIndex);
  Main.Config.oprClosetPos := TTabClosePos(self.ComboBoxOprClosePos.ItemIndex);

  Main.Config.optEnableBoardMenu := self.CheckBoxOptEnableBoardMenu.Checked;
  Main.Config.optEnableFavMenu := self.CheckBoxOptEnableFavMenu.Checked;
  Main.Config.optCharsInTab := charsInTab;
  //Main.Config.optShowCacheOnBoot := self.CheckBoxOptShowCache.Checked;
  Main.Config.optSaveLastItems := self.CheckBoxOptSaveLastItems.Checked;
  //Main.Config.optAutoSort := self.CheckBoxOptAutoSort.Checked;
  Main.Config.optAllowFavoriteDuplicate := Self.CheckBoxOptAllowFavoriteDuplicate.Checked;

  Main.Config.optChottoView := Self.EditOptChottoView.Text;  //rika

  {beginner}
  //Main.Config.optCheckNewThreadInHour := Self.seCheckNewThreadInHour.Value;
  {aiai}
  if Main.Config.optCheckNewThreadInHour
          <> Self.seCheckNewThreadInHour.Value then
  begin
    Main.Config.optCheckNewThreadInHour := Self.seCheckNewThreadInHour.Value;
    Main.Config.StyleChanged := True;
  end;
  if Main.Config.optCheckThreadMadeAfterLstMdfy
          <> (Main.Config.optCheckNewThreadInHour <> 0) then
  begin
    Main.Config.optCheckThreadMadeAfterLstMdfy
            := (Main.Config.optCheckNewThreadInHour <> 0);
    Main.Config.StyleChanged := True;
  end;
  if Main.Config.optCheckThreadMadeAfterLstMdfy2
          <> Self.CheckBoxCheckThreadMadeAfterLstMdfy2.Checked then
  begin
    Main.Config.optCheckThreadMadeAfterLstMdfy2
            := Self.CheckBoxCheckThreadMadeAfterLstMdfy2.Checked;
    Main.Config.StyleChanged := True;
  end;
  {/aiai}
  Main.Config.ojvAllowTreeDup := Self.CheckBoxAllowTreeDup.Checked;
  Main.Config.ojvLenofOutLineRes := Self.SpinEditLenofOutLineRes.Value;
  {/beginner}

  Main.Config.datDeleteOutOfTime := self.CheckBoxDatDelOOTLog.Checked;

  Main.Config.bbsMenuURL := self.EditBBSMenuURL.Text;

  Main.Config.tstAuthorizedAccess := Main.Config.accAutoAuth;
  Main.Config.tstCloseAfterWriting := self.CheckBoxTstCloseOnSuccess.Checked;

  Main.Config.brdRecyclableCount := self.SpinEditRecyclableCount.Value;

  Main.Config.viewTransparencyAbone := self.CheckBoxViewTransparencyAbone.Checked;

  {aiai}
  //ImageViewPreferenceから移動 + 連鎖あぼーん
  Main.Config.viewLinkAbone        := self.CheckBoxLinkAbone.Enabled and self.CheckBoxLinkAbone.Checked;
  Main.Config.viewPermanentNG      := self.cbPermanentNG.Checked;
  Main.Config.viewPermanentMarking := self.cbPermanentMarking.Checked;
  Main.Config.viewNGLifeSpan[0]    := self.seNGItemLifeSpan.Value;
  Main.Config.viewNGLifeSpan[1]    := self.seNGItemLifeSpan.Value;
  Main.Config.viewNGLifeSpan[2]    := self.seNGItemLifeSpan.Value;
  Main.Config.viewNGLifeSpan[3]    := self.seNGIDLifeSpan.Value;
  Main.Config.viewNGLifeSpan[4]    := self.seNGItemLifeSpan.Value;
  Main.Config.viewAboneLevel       := self.cmbAboneLevel.ItemIndex-1;
  MainWnd.SetupNGConfig;

  Main.Config.optOldOnCheckNew := self.CheckBoxOldOnCheckNew.Checked;
  Main.Config.viewReadIfScrollBottom := self.CheckBoxReadIfScrollBottom.Checked;

  Main.Config.optFavPatrolCheckServerDown := self.CheckBoxFavPatrolCheckServerDown.Checked;  
  Main.Config.optFavPatrolOpenNewResThread := self.CheckBoxFavPatrolOpenNewResThread.Checked;
  Main.Config.optFavPatrolOpenBack := self.CheckBoxFavPatrolOpenBack.Checked;
  Main.Config.optFavPatrolMessageBox := Self.CheckBoxFavPatrolMessageBox.Checked;

  Main.Config.optSetFocusOnWriteMemo := self.CheckBoxoptSetFocusOnWriteMemo.Checked;
  Main.Config.optCheckNewResSingleClick := self.CheckBoxoptCheckNewResSingleClick.Checked;
  Main.Config.optHideInTaskTray := self.CheckBoxHideInTaskTray.Checked;

  Main.Config.ojvOpenNewResThreadLimit := self.SpinEditOpenNewResThreadLimit.Value;

  Main.Config.ojvIDPopUp := self.CheckBoxIDPopUp.Checked;
  Main.Config.ojvIDPopOnMOver := self.CheckBoxIDPopOnMOver.Checked;
  //Main.Config.ojvIDPopOnMOver := (self.RadioGroupIDPopOnMOver.ItemIndex = 0);
  Main.Config.ojvIDPopUpMaxCount := self.SpinEditIDPopUpMaxCount.Value;
  Main.Config.ojvQuickMergeTemp := self.CheckBoxQuickMerge.Checked;

  Main.Config.oprListReloadInterval := self.SpinEditListReloadInterval.Value;
  Main.Config.oprThreadReloadInterval := self.SpinEditThreadReloadInterval.Value;

  Main.Config.stlDefSortColumn := self.ComboBoxDefSortColumn.ItemIndex;
  Main.Config.stlDefFuncSortColumn := self.ComboBoxDefFuncSortColumn.ItemIndex;
  {/aiai}

  Main.Config.stlTabMaltiline := self.CheckBoxStlTabMultiline.Checked;
  Main.Config.stlTabWidth := StrToIntDef(self.EditStlTabWidth.Text, Main.Config.stlTabWidth);
  Main.Config.stlTabHeight := StrToIntDef(self.EditStlTabHeight.Text, Main.Config.stlTabHeight);
  Main.Config.stlListTabWidth := StrToIntDef(self.EditStlListTabWidth.Text, Main.Config.stlListTabWidth);
  Main.Config.stlListTabHeight := StrToIntDef(self.EditStlListTabHeight.Text, Main.Config.stlListTabHeight);
  Main.Config.stlTabStyle := self.RadioGroupThreadTabStyle.ItemIndex;
  Main.Config.stlListTabStyle := self.RadioGroupListTabStyle.ItemIndex;
  Main.Config.stlTreeTabStyle := self.RadioGroupTreeTabStyle.ItemIndex;

  Main.Config.stlMenuIcons := self.CheckBoxStlMenuIcons.Checked;
  Main.Config.stlLinkBarIcons := self.CheckBoxStlLinkBarIcons.Checked;
  Main.Config.stlTreeIcons := self.CheckBoxStlTreeIcons.Checked;
  Main.Config.stlTabIcons := self.CheckBoxStlTabIcons.Checked;
  Main.Config.stlListMarkIcons := self.CheckBoxStlListMarkIcons.Checked;
  Main.Config.stlListTitleIcons := self.CheckBoxStlListTitleIcons.Checked;
  Main.Config.stlThreadToolBarVisible := self.CheckBoxStlThreadToolBar.Checked;
  Main.Config.stlThreadTitleLabelVisible := self.CheckBoxStlThreadTitle.Checked;
  Main.Config.stlListViewUseExtraBackColor := self.CheckBoxStlListExtraBackColor.Checked;
  Main.Config.stlShowTreeMarks := self.CheckBoxStlShowTreeMarks.Checked;
  {beginner}
  Main.Config.stlSmallLogPanel:= self.CheckBoxStlSmallLogPanel.Checked;
  Main.Config.stlLogPanelUnderThread:= self.RadioButtonLogPanelUnderThread.Checked;
  {/beginner}

  Main.Config.wrtRecordWriting := self.CheckBoxWrtRecordWriting.Checked;
  Main.Config.wrtDefaultSageCheck := self.CheckBoxWrtDefaultSage.Checked;
  Main.Config.wrtReplyMark := self.EditWrtReplyMark.Text;
  Main.Config.wrtShowThreadTitle := self.CheckBoxWrtShowThreadTitle.Checked;
  Main.Config.wrtNameList.Text := self.MemoWrtNameList.Text;
  Main.Config.wrtMailList.Text := self.MemoWrtMailList.Text;
  Main.Config.wrtFmUseTaskBar := self.CheckBoxWrtFmUseTaskBar.Checked;
  Main.Config.wrtUseDefaultName := self.CheckBoxWrtUseDefaultName.Checked;

  Main.Config.wrtDiscrepancyWarning := self.CheckBoxDiscrepancyWarning.Checked;
  Main.Config.wrtDisableStatusBar   := self.CheckBoxDisableStatusBar.Checked;

  {$IFNDEF IE}
  Main.Config.viewVerticalCaretMargin := StrToIntDef(self.EditViewVerticalCaretMargin.Text, Main.Config.viewVerticalCaretMargin);
  Main.Config.viewScrollLines := StrToIntDef(self.EditViewScrollLines.Text, Main.Config.viewScrollLines);
  Main.Config.viewPageScroll := self.RadioButtonViewPageScroll.Checked;
  {beginner}
  Main.Config.viewEnableAutoScroll := self.CheckBoxViewEnableAutoScroll.Checked;
  Main.Config.viewScrollSmoothness := self.SpinEditViewScrollSmoothness.Value;
  Main.Config.viewScrollFrameRate := self.SpinEditViewScrollFrameRate.Value;
  {/beginner}
  for i := 0 to Main.viewList.Count -1 do
  begin
    Main.viewList.Items[i].browser.VerticalCaretMargin := Main.Config.viewVerticalCaretMargin;
    Main.viewList.Items[i].browser.WheelPageScroll := Main.Config.viewPageScroll;
    Main.viewList.Items[i].browser.VScrollLines := Main.Config.viewScrollLines;
    Main.viewList.Items[i].browser.HoverTime := Main.Config.hintHoverTime;
    {beginner}
    Main.viewList.Items[i].browser.EnableAutoScroll := Main.Config.viewEnableAutoScroll;
    Main.viewList.Items[i].browser.Frames := Main.Config.viewScrollSmoothness;
    Main.viewList.Items[i].browser.FrameRate := Main.Config.viewScrollFrameRate;
    {/beginner}
  end;
  if Main.Config.viewCaretVisible <> self.CheckboxCaretVisible.Checked then
  begin
    Main.Config.viewCaretVisible := self.CheckboxCaretVisible.Checked;
    for i := 0 to Main.viewList.Count -1 do
      Main.viewList.Items[i].browser.ConfCaretVisible := self.CheckboxCaretVisible.Checked;
  end;
  Config.viewZoomPointArray[0] := StrToIntDef(EditZoomPoint0.Text, Config.viewZoomPointArray[0]);
  Config.viewZoomPointArray[1] := StrToIntDef(EditZoomPoint1.Text, Config.viewZoomPointArray[1]);
  Config.viewZoomPointArray[2] := StrToIntDef(EditZoomPoint2.Text, Config.viewZoomPointArray[2]);
  Config.viewZoomPointArray[3] := StrToIntDef(EditZoomPoint3.Text, Config.viewZoomPointArray[3]);
  Config.viewZoomPointArray[4] := StrToIntDef(EditZoomPoint4.Text, Config.viewZoomPointArray[4]);
  {$ENDIF}

  Main.Config.mseUseWheelTabChange := self.CheckBoxMseUseWheelTabChange.Checked;
  Main.Config.mseGestureMargin := StrToIntDef(self.EditMseGestureMargin.Text, Main.Config.mseGestureMargin);
  Main.Config.mseWheelScrollUnderCursor := self.CheckBoxWheelScrollUnderCursor.Checked;
  if SheetMouse.Tag = 1 then
  begin
    Main.Config.mseGestureList.Clear;
    with ValueListMouseGesture.Strings do
      for i := 0 to Count -1 do
      begin
        Main.Config.mseGestureList.AddObject(Names[i] + '=' + TMenuItem(Objects[i]).Name, Objects[i]);
    end;
  end;

  Main.Config.cmdConfigList.Text := self.ValueListCommand.Strings.Text;

  Main.Config.clListViewOddBackColor  := self.MemoListOdd.Color;
  Main.Config.clListViewEvenBackColor := self.MemoListEven.Color;

  if Config.ColorChanged then
    SetMainwndColors;
  if Config.FontChanged then
  begin
    Config.SetFontInfo(Config.viewTreeFontInfo, MemoTree.Font);
    Config.SetFontInfo(Config.viewListFontInfo, MemoList.Font);
    Config.SetFontInfo(Config.viewTraceFontInfo, MemoLog.Font);
    Config.SetFontInfo(Config.viewDefFontInfo, MemoDefault.Font);
    Config.SetFontInfo(Config.viewThreadTitleFontInfo, MemoThreadTitle.Font); //※[457]
    Config.SetFontInfo(Config.viewWriteFontInfo, MemoWrite.Font);
    {beginner}
    Config.SetFontInfo(Config.viewHintFontInfo, MemoHint.Font);
    Config.viewHintFontLinkColor := MemoHintFix.Font.Color;
    {beginner}
    Config.SetFontInfo(Config.viewMemoFontInfo, MemoWriteMemo.Font); //aiai
    SetFonts;
  end;

  if SheetColumn.Tag = 1 then
  begin
    for i := 0 to ListBoxClmnSelected.Count -1 do
      Main.Config.stlClmnArray[i] := StrToIntDef(Trim(ListBoxClmnSelected.Items.Names[i]), -1);
    if ListBoxClmnSelected.Count < High(Main.Config.stlClmnArray) +1 then
      Main.Config.stlClmnArray[ListBoxClmnSelected.Count] := -1; //打ち切り

    MainWnd.UpdateListViewColumns; //aiai
  end;

  Main.Config.ojvShowDayOfWeek := self.ShowDayOfWeekCheckBox.Checked; //aiai

  Main.Config.Save;

  UDat2HTML.ABONE := Main.Config.viewNGMsgMarker;
  if clearCache then
    Main.urlHeadCache.Clear;

  //※[457](ListBoxに何かあるか、元々ファイルがある場合は保存)
  if SheetAbone.Tag = 1 then
  begin
    {beginner}//NGタイプなどの保存
    SaveNGWords(NG_FILE[NG_ITEM_NAME],ListBoxNGName, False);
    SaveNGWords(NG_FILE[NG_ITEM_MAIL],ListBoxNGAddr, False);
    SaveNGWords(NG_FILE[NG_ITEM_MSG],ListBoxNGWord, False);
    SaveNGWords(NG_FILE[NG_ITEM_ID],ListBoxNGid, False);
    SaveNGWords(NG_EX_FILE, ListBoxNGEx, True);
    {/beginner}
    SaveNGThreadList(NG_THREAD_FILE, ListBoxNGThread);  //aiai
  end;

  {aiai}
  if Main.Config.TabColorChanged then begin
    Main.Config.tclActiveBack     := self.MemoDefaultActive.Color;
    Main.Config.tclNoActiveBack   := self.MemoDefaultNoActive.Color;
    Main.Config.tclWriteWaitBack  := self.MemoWriteWait.Color;
    Main.Config.tclAutoReloadBack := self.MemoAutoReload.Color;

    Main.Config.tclDefaultText      := self.MemoDefaultActive.Font.Color;
    Main.Config.tclNewText          := self.MemoNewActive.Font.Color;
    Main.Config.tclNew2Text         := self.MemoNew2Active.Font.Color;
    Main.Config.tclProcessText      := self.MemoProcessActive.Font.Color;
    Main.Config.tclDisableWriteText := self.MemoDisableWriteActive.Font.Color;

    Main.Config.SaveTabColor;

    if MainWnd.TabControl <> nil then MainWnd.TabControl.Refresh;
    Main.Config.TabColorChanged := false;
  end;

  if (Main.Config.ojvColordNumber <> self.CheckBoxColordNumber.Checked)
  or (Main.Config.ojvLinkedNumColor <> self.MemoLinkedNumColor.Font.Color) then
  begin
    Main.Config.ojvColordNumber := self.CheckBoxColordNumber.Checked;
    Main.Config.ojvLinkedNumColor := self.MemoLinkedNumColor.Font.Color;
    MainWnd.LoadColordNumberSetting;
    Main.Config.Modified := true;
  end;

  if (Main.Config.ojvIDLinkColor <> self.CheckBoxIDLinkColor.Checked)
  or (Main.Config.ojvIDLinkColorMany <> self.MemoIDLinkColorMany.Font.Color)
  or (Main.Config.ojvIDLinkColorNone <> self.MemoIDLinkColorNone.Font.Color)
  or (Main.Config.ojvIDLinkThreshold <> self.SpinEditIDLinkThreshold.Value) then
  begin
    Main.Config.ojvIDLinkColor := self.CheckBoxIDLinkColor.Checked;
    Main.Config.ojvIDLinkColorMany := self.MemoIDLinkColorMany.Font.Color;
    Main.Config.ojvIDLinkColorNone := self.MemoIDLinkColorNone.Font.Color;
    Main.Config.ojvIDLinkThreshold := self.SpinEditIDLinkThreshold.Value;
    MainWnd.LoadColordIDSetting;
    Main.Config.Modified := true;
  end;
  {/aiai}

  ModalResult := mrOK;
end;

procedure TUIConfig.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TUIConfig.FormClose(Sender: TObject; var Action: TCloseAction);
  procedure FreeObject(sr:TStrings);
  var
    i: Integer;
  begin
    for i := 0 to sr.Count - 1 do
      sr.Objects[i].Free;
  end;
begin
  FreeObject(ListBoxNGName.Items);
  FreeObject(ListBoxNGAddr.Items);
  FreeObject(ListBoxNGWord.Items);
  FreeObject(ListBoxNGid.Items);
  FreeObject(ListBoxNGEx.Items);
end;

procedure TUIConfig.FormShow(Sender: TObject);
begin
  self.CheckBoxNetUseProxy.Checked := Main.Config.netUseProxy;
  self.CheckBoxNetNoCache.Checked := Main.Config.netNoCache;
  EditProxyServer.Text := Main.Config.netProxyServer;
  if 0 < Main.Config.netProxyPort then
    EditProxyPort.Text := IntToStr(Main.Config.netProxyPort)
  else
    EditProxyPort.Text := '';
  EditProxyServerForWriting.Text := Main.Config.netProxyServerForWriting;
  if 0 < Main.Config.netProxyPortForWriting then
    EditProxyPortForWriting.Text := IntToStr(Main.Config.netProxyPortForWriting)
  else
    EditProxyPortForWriting.Text := '';
  self.EditProxyServerForSSL.Text := Main.Config.netProxyServerForSSL;
  if 0 < Main.Config.netProxyPortForSSL then
    self.EditProxyPortForSSL.Text := IntToStr(Main.Config.netProxyPortForSSL)
  else
    self.EditProxyPortForSSL.Text := '';
  self.EditReadTimeout.Text := IntToStr(Main.Config.netReadTimeout);
  self.EditRecvBufferSize.Text := IntToStr(Main.Config.netRecvBufferSize);
  self.CheckBoxNetOnline.Checked := Main.Config.netOnline;
  self.CheckBoxNetUseReadCGI.Checked := Main.Config.netUseReadCGI;

  self.CheckBoxBrowserSpecified.Checked := Main.Config.extBrowserSpecified;
  self.EditBrowserPath.Text := Main.Config.extBrowserPath;
  self.EditLogBasePath.Text := Main.Config.LogConfPath;
  self.SkinPathBox.Text := Main.Config.SkinConfPath;

  self.CheckBoxComm.Checked := Main.Config.tstCommHeaders;

  self.CheckBoxHintEnabled.Checked := Main.Config.hintEnabled;
  Self.SpinEditHintHoverTime.Value := Main.Config.hintHoverTime;
  Self.SpinEditHintHintHoverTime.Value := Main.Config.hintHintHoverTime;
  self.CheckBoxHint4OtherThread.Checked := Main.Config.hintForOtherThread;
  self.CheckBoxNestingPopUp.Checked := Main.Config.hintNestingPopUp;
  self.CheckBoxAutoEnableNesting.Checked := Main.Config.hintAutoEnableNesting;
  self.CheckBoxHintAutoEnableNesting.Checked := Main.Config.hintHintAutoEnableNesting;
  CheckBoxUseHint4URL.Checked := Main.Config.hintForURL;
  self.EditMaxHintWidth.Text := IntToStr(Main.Config.hintForURLWidth);
  self.EditMaxHintHeight.Text := IntToStr(Main.Config.hintForURLHeight);
  if Main.Config.hintForURLUseHead then
    self.RadioButtonHintUseHead.Checked := true
  else
    self.RadioButtonHintUseGet.Checked := true;
  self.EditHintMaxSize.Text := IntToStr(Main.Config.hintForURLMaxSize);
  self.EditHintWaitTime.Text := IntToStr(Main.Config.hintForURLWaitTime);
  self.EditHintCancelGetExt.Text := Main.Config.hintCancelGetExt.CommaText;

  self.CheckBoxCatSingleClick.Checked := Main.Config.oprCatBySingleClick;
  self.CheckBoxOprShowSubjectCache.Checked := Main.Config.oprShowSubjectCache;
  self.CheckBoxOprSelPreviousThread.Checked := Main.Config.oprSelPreviousThread;
  self.CheckBoxOprScrollToNewRes.Checked := Main.Config.oprScrollToNewRes;
  self.RadioButtonOprScrollTop.Checked := Main.Config.oprScrollTop;
  self.RadioButtonOprScrollBottom.Checked := not Main.Config.oprScrollTop;
  self.CheckBoxOprJumpToPrev.Checked := Main.Config.oprScrollToPreviousRes;
  //self.CheckBox3PaneMode.Checked := not Main.Config.oprToggleRView;
  //self.CheckBoxDblClkMode.Checked := not Main.Config.oprAlwaysCheck;
  //self.CheckBoxTabStopOnTracePane.Checked := Main.Config.oprTabStopOnTracePane;
  self.CheckBoxOprDisableTabInView.Checked := Main.Config.oprDisableTabKeyInView;
  self.CheckBoxOprBoardExpandOneCategory.Checked := Main.Config.oprBoardTreeExpandOneCategory;
  self.CheckBoxOprCheckNewWRedraw.Checked := Main.Config.oprCheckNewWRedraw;
  //self.CheckBoxOprAlwaysCreateNewView.Checked := Main.Config.oprAlwaysCreateNewView;
  self.CheckBoxOprOpenThreWNewView.Checked := Main.Config.oprOpenThreWNewView;
  self.CheckBoxOprOpenFavWNewView.Checked  := Main.Config.oprOpenFavWNewView;
  self.CheckBoxOprOpenBoardWNewTab.Checked := Main.Config.oprOpenBoardWNewTab;
  self.ComboBoxOprDrawLines.ItemIndex := Main.Config.oprDrawLines;

  self.ComboBoxOprBrdClick.ItemIndex := Ord(Main.Config.oprGestureBrdClick);
  self.ComboBoxOprBrdDblClk.ItemIndex:= Ord(Main.Config.oprGestureBrdDblClk);
  self.ComboBoxOprBrdMenu.ItemIndex  := Ord(Main.Config.oprGestureBrdMenu);
  self.ComboBoxOprBrdOther.ItemIndex := Ord(Main.Config.oprGestureBrdOther);
  self.ComboBoxOprThrClick.ItemIndex := Ord(Main.Config.oprGestureThrClick);
  self.ComboBoxOprThrDblClk.ItemIndex:= Ord(Main.Config.oprGestureThrDblClk);
  self.ComboBoxOprThrMenu.ItemIndex  := Ord(Main.Config.oprGestureThrMenu);
  self.ComboBoxOprThrOther.ItemIndex := Ord(Main.Config.oprGestureThrOther);

  self.CheckBoxOprThreBgOpen.Checked   := Main.Config.oprThreBgOpen;
  self.CheckBoxOprFavBgOpen.Checked    := Main.Config.oprFavBgOpen;
  self.CheckBoxOprClosedBgOpen.Checked := Main.Config.oprClosedBgOpen;
  self.CheckBoxOprAddrBgOpen.Checked   := Main.Config.oprAddrBgOpen;
  self.CheckBoxOprUrlBgOpen.Checked    := Main.Config.oprUrlBgOpen;

  self.ComboBoxOprAddPosNormal.ItemIndex   := Ord(Main.Config.oprAddPosNormal);
  self.ComboBoxOprAddPosRelative.ItemIndex := Ord(Main.Config.oprAddPosRelative);
  self.ComboBoxOprClosePos.ItemIndex       := Ord(Main.Config.oprClosetPos);

  self.CheckBoxOptEnableBoardMenu.Checked := Main.Config.optEnableBoardMenu;
  self.CheckBoxOptEnableFavMenu.Checked := Main.Config.optEnableFavMenu;
  self.EditOptCharsInTab.Text := IntToStr(Main.Config.optCharsInTab);
  //self.CheckBoxOptShowCache.Checked := Main.Config.optShowCacheOnBoot;
  self.CheckBoxOptSaveLastItems.Checked := Main.Config.optSaveLastItems;
  //self.CheckBoxOptAutoSort.Checked := Main.Config.optAutoSort;
  self.CheckBoxOptAllowFavoriteDuplicate.Checked := Main.Config.optAllowFavoriteDuplicate;

  self.EditOptChottoView.Text := Main.Config.optChottoView;  //rika

  self.CheckBoxDatDelOOTLog.Checked := Main.Config.datDeleteOutOfTime;
  self.CheckBoxTstCloseOnSuccess.Checked := Main.Config.tstCloseAfterWriting;

  self.SpinEditRecyclableCount.Value := Main.Config.brdRecyclableCount;

  self.EditUserID.Text := Main.Config.accUserID;
  self.EditPassword.Text := Main.Config.accPasswd;
  self.CheckBoxAutoAuth.Checked := Main.Config.accAutoAuth;
  self.ButtonResetSID.Enabled := ticket2ch.Authorized;

  self.EditBBSMenuURL.Text := Main.Config.bbsMenuURL;

//  self.CheckBoxNetUseReadCGI.Enabled := self.CheckBoxAutoAuth.Checked;

  self.CheckBoxComm.Visible := Config.tstDebugEnabled;

  self.CheckBoxViewTransparencyAbone.Checked := Main.Config.viewTransparencyAbone;

  {aiai}
  self.CheckBoxOldOnCheckNew.Checked := Main.Config.optOldOnCheckNew;
  self.CheckBoxReadIfScrollBottom.Checked := Main.Config.viewReadIfScrollBottom;

  self.CheckBoxFavPatrolCheckServerDown.Checked := Main.Config.optFavPatrolCheckServerDown;
  self.CheckBoxFavPatrolOpenNewResThread.Checked := Main.Config.optFavPatrolOpenNewResThread;
  self.CheckBoxFavPatrolOpenBack.Checked := Main.Config.optFavPatrolOpenBack;
  self.CheckBoxFavPatrolMessageBox.Checked := Main.Config.optFavPatrolMessageBox;

  self.CheckBoxoptSetFocusOnWriteMemo.Checked := Main.Config.optSetFocusOnWriteMemo;
  self.CheckBoxoptCheckNewResSingleClick.Checked := Main.Config.optCheckNewResSingleClick;
  self.CheckBoxHideInTaskTray.Checked := Main.Config.optHideInTaskTray;

  self.CheckBoxColordNumber.Checked := Main.Config.ojvColordNumber;
  self.MemoLinkedNumColor.Font.Color := Main.Config.ojvLinkedNumColor;
  self.CheckBoxIDLinkColor.Checked := Main.Config.ojvIDLinkColor;
  self.MemoIDLinkColorMany.Font.Color := Main.Config.ojvIDLinkColorMany;
  self.MemoIDLinkColorNone.Font.Color := Main.Config.ojvIDLinkColorNone;
  self.SpinEditIDLinkThreshold.Value := Main.Config.ojvIDLinkThreshold;
  self.CheckBoxQuickMerge.Checked := Main.Config.ojvQuickMerge;

  self.SpinEditOpenNewResThreadLimit.Value := Main.Config.ojvOpenNewResThreadLimit;

  self.CheckBoxIDPopUp.Checked := Main.Config.ojvIDPopUp;
  self.CheckBoxIDPopOnMOver.Checked := Main.Config.ojvIDPopOnMOver;
  //if Main.Config.ojvIDPopOnMOver then self.RadioGroupIDPopOnMOver.ItemIndex := 0
  //else self.RadioGroupIDPopOnMOver.ItemIndex := 1;
  self.SpinEditIDPopUpMaxCount.Value := Main.Config.ojvIDPopUpMaxCount;

  //ImageViewPreferenceから移動 + 連鎖あぼーん
  self.cbPermanentNG.Checked      := Config.viewPermanentNG;
  self.cbPermanentMarking.Checked := Config.viewPermanentMarking and Config.viewPermanentNG;
  self.cbPermanentMarking.Enabled := Config.viewPermanentNG;
  self.CheckBoxLinkAbone.Checked  := Config.viewLinkAbone and Config.viewPermanentNG;
  self.CheckBoxLinkAbone.Enabled  := Config.viewPermanentNG;
  self.seNGItemLifeSpan.Value     := Config.viewNGLifeSpan[0];
  self.seNGIDLifeSpan.Value       := Config.viewNGLifeSpan[3];
  self.cmbAboneLevel.ItemIndex    := Config.viewAboneLevel+1;

  self.SpinEditListReloadInterval.Value := Config.oprListReloadInterval;
  self.SpinEditThreadReloadInterval.Value := Config.oprThreadReloadInterval;

  self.ComboBoxDefSortColumn.ItemIndex := Config.stlDefSortColumn;
  self.ComboBoxDefFuncSortColumn.ItemIndex := Config.stlDefFuncSortColumn;
  {/aiai}

  self.CheckBoxStlTabMultiline.Checked := Main.Config.stlTabMaltiline;
  self.EditStlTabWidth.Text := IntToStr(Main.Config.stlTabWidth);
  self.EditStlTabHeight.Text := IntToStr(Main.Config.stlTabHeight);
  self.EditStlListTabWidth.Text := IntToStr(Main.Config.stlListTabWidth);
  self.EditStlListTabHeight.Text := IntToStr(Main.Config.stlListTabHeight);
  self.RadioGroupTreeTabStyle.ItemIndex := Main.Config.stlTreeTabStyle;
  self.RadioGroupListTabStyle.ItemIndex := Main.Config.stlListTabStyle;
  self.RadioGroupThreadTabStyle.ItemIndex := Main.Config.stlTabStyle;

  self.CheckBoxStlMenuIcons.Checked := Main.Config.stlMenuIcons;
  self.CheckBoxStlLinkBarIcons.Checked := Main.Config.stlLinkBarIcons;
  self.CheckBoxStlTreeIcons.Checked := Main.Config.stlTreeIcons;
  self.CheckBoxStlTabIcons.Checked := Main.Config.stlTabIcons;
  self.CheckBoxStlListMarkIcons.Checked := Main.Config.stlListMarkIcons;
  self.CheckBoxStlListTitleIcons.Checked := Main.Config.stlListTitleIcons;
  self.CheckBoxStlThreadToolBar.Checked := Main.Config.stlThreadToolBarVisible;
  self.CheckBoxStlThreadTitle.Checked := Main.Config.stlThreadTitleLabelVisible;
  self.CheckBoxStlListExtraBackColor.Checked := Main.Config.stlListViewUseExtraBackColor;
  self.CheckBoxStlShowTreeMarks.Checked := Main.Config.stlShowTreeMarks;
  {beginner}
  self.CheckBoxStlSmallLogPanel.Checked := Main.Config.stlSmallLogPanel;
  if Main.Config.stlLogPanelUnderThread then begin
    self.RadioButtonLogPanelUnderThread.Checked := True;
    self.RadioButtonLogPanelUnderBoard.Checked := False;
  end else begin
    self.RadioButtonLogPanelUnderThread.Checked := False;
    self.RadioButtonLogPanelUnderBoard.Checked := True;
  end;
  {/beginner}

  self.CheckBoxWrtRecordWriting.Checked := Main.Config.wrtRecordWriting;
  self.CheckBoxWrtDefaultSage.Checked := Main.Config.wrtDefaultSageCheck;
  self.EditWrtReplyMark.Text := Main.Config.wrtReplyMark;
  self.CheckBoxWrtShowThreadTitle.Checked := Main.Config.wrtShowThreadTitle;
  self.MemoWrtNameList.Text := Main.Config.wrtNameList.Text;
  self.MemoWrtMailList.Text := Main.Config.wrtMailList.Text;
  self.CheckBoxWrtFmUseTaskBar.Checked := Main.Config.wrtFmUseTaskBar;
  self.CheckBoxWrtUseDefaultName.Checked := Main.Config.wrtUseDefaultName;
  self.CheckBoxDiscrepancyWarning.Checked := Main.Config.wrtDiscrepancyWarning;
  self.CheckBoxDisableStatusBar.Checked := Main.Config.wrtDisableStatusBar;

  {$IFNDEF IE}
  self.EditViewVerticalCaretMargin.Text := IntToStr(Main.Config.viewVerticalCaretMargin);
  self.RadioButtonViewPageScroll.Checked := Main.Config.viewPageScroll;
  self.EditViewScrollLines.Text := IntToStr(Main.Config.viewScrollLines);
  {beginner}
  self.CheckBoxViewEnableAutoScroll.Checked := Main.Config.viewEnableAutoScroll;
  self.SpinEditViewScrollSmoothness.Value := Main.Config.viewScrollSmoothness;
  self.SpinEditViewScrollFrameRate.Value := Main.Config.viewScrollFrameRate;
  {/beginner}
  self.CheckBoxCaretVisible.Checked := Main.Config.viewCaretVisible;

  self.EditZoomPoint0.Text := IntToStr(Main.Config.viewZoomPointArray[0]);
  self.EditZoomPoint1.Text := IntToStr(Main.Config.viewZoomPointArray[1]);
  self.EditZoomPoint2.Text := IntToStr(Main.Config.viewZoomPointArray[2]);
  self.EditZoomPoint3.Text := IntToStr(Main.Config.viewZoomPointArray[3]);
  self.EditZoomPoint4.Text := IntToStr(Main.Config.viewZoomPointArray[4]);
  {$ENDIF}

  self.CheckBoxMseUseWheelTabChange.Checked := Main.Config.mseUseWheelTabChange;
  self.EditMseGestureMargin.Text := IntToStr(Main.Config.mseGestureMargin);
  self.CheckBoxWheelScrollUnderCursor.Checked := Main.Config.mseWheelScrollUnderCursor;
  //self.MemoMouseGesture.Lines.Text := Main.Config.mseGestureList.Text;

  self.MemoListOdd.Text  := '奇数行';
  self.MemoListEven.Text := '偶数行';
  self.MemoListOdd.Color  := Config.clListViewOddBackColor;
  self.MemoListEven.Color := Config.clListViewEvenBackColor;

  self.ValueListCommand.Strings.Text := Config.cmdConfigList.Text;

  {beginner}
  {aiai}
  if Main.Config.optCheckThreadMadeAfterLstMdfy then
    self.seCheckNewThreadInHour.Value:=Main.Config.optCheckNewThreadInHour
  else
    self.seCheckNewThreadInHour.Value:=0;
  self.CheckBoxCheckThreadMadeAfterLstMdfy2.Checked:=Main.Config.optCheckThreadMadeAfterLstMdfy2;
  {/aiai}
  self.SpinEditLenofOutLineRes.Value := Main.Config.ojvLenofOutLineRes;
  self.CheckBoxAllowTreeDup.Checked := Main.Config.ojvAllowTreeDup;
  {/beginner}

  {aiai}
  self.ShowDayOfWeekCheckBox.Checked := Main.Config.ojvShowDayOfWeek;
  {/aiai}

  Config.ColorChanged := false;
  Config.FontChanged  := false;
  Config.StyleChanged := false;
  Config.TabColorChanged := false;  //aiai
end;


procedure TUIConfig.ButtonSelBrowserClick(Sender: TObject);
begin
  OpenDialog.FileName := EditBrowserPath.Text;
  if not OpenDialog.Execute then
    exit;
  EditBrowserPath.Text := OpenDialog.FileName;
end;

procedure TUIConfig.FormCreate(Sender: TObject);
var
  font: TFont;
begin
  WindowProc := CustomWndProc;
  if Config.viewDefFontInfo.face <> '' then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewDefFontInfo);
    Self.Font.Assign(font);
    PageControl.Font.Assign(font);
    font.Free;
  end;
  TreeView.Items.BeginUpdate;
  TreeView.Items.AddChildObject(TreeView.Items.Item[2], SheetColumn.Caption, SheetColumn);
  TreeView.Items.AddChildObject(TreeView.Items.Item[2], SheetTab.Caption, SheetTab);
  TreeView.Items.AddChildObject(TreeView.Items.Item[2], SheetStyle.Caption, SheetStyle);
  TreeView.Items.AddChildObject(TreeView.Items.Item[2], SheetColors.Caption, SheetColors);
  TreeView.Items.AddChildObject(TreeView.Items.Item[2], SheetTabColor.Caption, SheetTabColor);  //aiai
  TreeView.Items.AddChildObject(TreeView.Items.Item[1], SheetHint.Caption, SheetHint);
  TreeView.Items.AddChildObject(TreeView.Items.Item[1], SheetAbone.Caption, SheetAbone);
  TreeView.Items.AddChildObject(TreeView.Items.Item[1], SheetCommand.Caption, SheetCommand);
  TreeView.Items.AddChildObject(TreeView.Items.Item[1], SheetMouse.Caption, SheetMouse);
  TreeView.Items.AddChildObject(TreeView.Items.Item[1], SheetDangerous.Caption, SheetDangerous);
  TreeView.Items.AddChildObject(TreeView.Items.Item[1], SheetFavPatrol.Caption, SheetFavPatrol); //aiai
  TreeView.Items.AddChildObject(TreeView.Items.Item[1], SheetForView.Caption, SheetForView);    //Beginner
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetNet.Caption, SheetNet);
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetPath.Caption, SheetPath);
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetAction.Caption, SheetAction);
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetOperation.Caption, SheetOperation);
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetTabOperation.Caption, SheetTabOperation);
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetWrite.Caption, SheetWrite);
  {$IFNDEF IE}
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetDoe.Caption, SheetDoe);
  {$ENDIF}
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetForTest.Caption, SheetForTest);
  TreeView.Items.AddChildObject(TreeView.Items.Item[0], SheetUserInfo.Caption, SheetUserInfo);
  TreeView.FullExpand;
  TreeView.Selected := TreeView.Items[1];
  TreeView.Items.EndUpdate;
end;

{beginner}
procedure TUIConfig.FormDestroy(Sender: TObject);
begin
  WindowProc := WndProc; //一応
  FreeAndNil(AdvAboneRegist);
end;
{/beginner}

procedure TUIConfig.ButtonManualConnectClick(Sender: TObject);
begin
  Config.tmpChanged := true;
  Main.Config.tstAuthorizedAccess := true;
end;

procedure TUIConfig.ButtonResetSIDClick(Sender: TObject);
begin
  ticket2ch.Reset;
  AsyncUpdateConfig;
  ButtonResetSID.Enabled := false;
  CheckBoxAutoAuth.Checked := false;
end;

procedure TUIConfig.EditPassphraseChange(Sender: TObject);
var
  en: boolean;
begin
  en := 6 <= length(self.EditPassphrase.Text);
  self.CheckBoxSetPassphrase.Enabled := en;
  self.ButtonRemenberPasswd.Enabled := en;
  if not en then
    self.CheckBoxSetPassphrase.Checked := false;
end;

procedure TUIConfig.ButtonRemenberPasswdClick(Sender: TObject);
var
  crypt: THogeCryptAuto;
  inStream, outStream: TStringStream;
  phrase: string;
  binary: string;
begin
  crypt := nil;
  inStream := nil;
  outStream := nil;
  phrase := self.EditPassphrase.Text;
  try
    if length(phrase) < 6 then
      raise Exception.Create('もっと長く');
    try
      binary := HogeBase64Decode(Main.Config.accPassphrasedPasswd);
    except
      raise Exception.Create('違う');
    end;
    crypt := THogeCryptAuto.Create;
    inStream := TStringStream.Create(binary);
    outStream := TStringStream.Create('');
    if crypt.Decrypt(inStream, phrase, outStream) then
    begin
      if 0 < length(outStream.DataString) then
      begin
        self.EditPassword.Text := outStream.DataString;
        raise Exception.Create('戻せた');
      end;
    end;
    raise Exception.Create('違う');
  except
    On e: Exception do
    begin
      self.PanelStat.Caption := e.Message;
    end;
  end;
  if inStream <> nil then inStream.Free;
  if outStream<> nil then outStream.Free;
  if crypt <> nil then crypt.Free;
end;

procedure TUIConfig.CheckBoxAutoAuthClick(Sender: TObject);
begin
//  CheckBoxNetUseReadCGI.Enabled := self.CheckBoxAutoAuth.Checked;
end;

//※[457]
procedure TUIConfig.ButtonAddNGWordClick(Sender: TObject);
var
  lb: TListBox;
  {beginner}
  NewName: String;
  NewItem: TBaseNGItem;
  tmp:string;
  {/beginner}
begin
  if EditNG.Text = '' then
    exit;
  case PageControlNGWord.ActivePageIndex of
    0 : lb := ListBoxNGName;
    1 : lb := ListBoxNGAddr;
    2 : lb := ListBoxNGWord;
    3 : lb := ListBoxNGid;
    4 : lb := ListBoxNGEx;
    5 : lb := ListBoxNGThread;  //aiai
  else
    exit;
  end;
  if lb.Items.IndexOf(EditNG.Text) = -1 then
  begin
    {beginner}
    if lb = ListBoxNGEx then begin
      NewName := EditNG.Text;
      NewItem := TExNgItem.Create;
      if AdvAboneRegist = nil then begin
        AdvAboneRegist := TAdvAboneRegist.Create(Self);
        AdvAboneRegist.OnChangeNameQuery := AdvAboneRegistChangeName;
      end;
      if AdvAboneRegist.ShowModal(NewName, NewItem as TExNgItem) <> mrOK then begin
        NewItem.Free;
        Exit;
      end;
      lb.Items.AddObject(NewName, NewItem);
    {aiai}
    end else if lb = ListBoxNGThread then begin
      lb.Items.Add(EditNG.Text);
    {/aiai}
    end else begin
      NewItem := TNGItemData.Create('', tmp);
      lb.Items.AddObject(EditNG.Text, NewItem);
    end;
    {/beginner}
    EditNG.Text := '';
  {beginner}
  end else
  begin
    MessageDlg('登録済みです', mtWarning, [mbOK], 0);
  {/beginner}
  end;
end;
//※[457]
procedure TUIConfig.ButtonDeleteNGWordClick(Sender: TObject);
var
  lb: TListBox;
  i: Integer;
begin
  case PageControlNGWord.ActivePageIndex of
    0 : lb := ListBoxNGName;
    1 : lb := ListBoxNGAddr;
    2 : lb := ListBoxNGWord;
    3 : lb := ListBoxNGid;
    4 : lb := ListBoxNGEx;
    5 : lb := ListBoxNGThread;  //aiai
  else
    exit;
  end;
  for i := lb.Items.Count - 1 downto 0 do
  begin
    {beginner}
    if lb.Selected[i] then begin
      lb.Items.Objects[i].Free;
      lb.Items.Delete(i);
    end;
    {/beginner}
  end;
end;

{beginner}
procedure TUIConfig.AdvAboneRegistChangeName(Sender: TObject; OldName, NewName: String; CanChange: Boolean);
var
  Old: Integer;
begin
  if ListBoxNGEx.Items.IndexOf(NewName) >= 0 then begin
    MessageDlg('すでに使用されています', mtWarning, [mbOK], 0);
    CanChange := False;
  end else begin
    Old := ListBoxNGEx.Items.IndexOf(OldName);
    if Old >= 0 then //Old < 0は新規
      ListBoxNGEx.Items[Old] := NewName;
  end;
end;


//※[457]
procedure TUIConfig.ListBoxNGWordClick(Sender: TObject);
var
  lb: TListBox;
  ItemName: String;
begin
  case PageControlNGWord.ActivePageIndex of
    0 : lb := ListBoxNGName;
    1 : lb := ListBoxNGAddr;
    2 : lb := ListBoxNGWord;
    3 : lb := ListBoxNGid;
    4 : lb := ListBoxNGEx; //beginner
  else
    exit;
  end;
  EditNG.Text := lb.Items[lb.ItemIndex];
  if (lb = ListBoxNGEx) and (lb.ItemIndex >= 0) then begin
    if AdvAboneRegist = nil then begin
      AdvAboneRegist := TAdvAboneRegist.Create(Self);
      AdvAboneRegist.OnChangeNameQuery := AdvAboneRegistChangeName;
    end;
    ItemName := lb.Items[lb.ItemIndex];
    AdvAboneRegist.ShowModal(ItemName, lb.Items.Objects[lb.ItemIndex] as TExNgItem);
  end;

end;

{beginner} //NGワードの作動状況ポップアップ
procedure TUIConfig.ListBoxNGWordMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  o: TBaseNGItem;
  str, tmp: String;
  ls: Integer;
begin
  i := (Sender as TListBox).ItemAtPos(Point(X, Y), True);

  if (Sender = AboneListOnHint) and (i = AboneListIndexOnHint) then //前回と同じ
    Exit;

  Application.CancelHint;

  if i >= 0 then begin
    o := ((Sender as TListBox).Items.Objects[i] as TBaseNGItem);
    if Assigned(o) then begin
      str := StringReplace((Sender as TListBox).Items[i], '|', '│',[rfReplaceAll])
           + #13#10'種別　： '       + NGTypeStr[o.AboneType]
           + #13#10'登録時刻　： '   + DateTimeToFmtStr(o.Registered)
           + #13#10'あぼ～ん回数： ' + IntToStr(o.Count);

      if o.EarliestArresting<54789 then
        str := str + #13#10'レス確認期間： ' + DateTimeToFmtStr(o.EarliestArresting)
                   + ' ～ ' + DateTimeToFmtStr(o.LatestArresting);

      ls := Config.viewNGLifeSpan[PageControlNGWord.ActivePageIndex];
      tmp := ' [デフォルト]';
      if o.LifeSpan >= 0 then begin
        ls := o.LifeSpan;
        tmp := '';
      end;

      if ls = 0 then
        str := str + #13#10'有効期限：　無期限' + tmp
      else begin
        if o.Registered >= o.LatestArresting then
          str := str + #13#10'有効期限: 最終あぼーんより' + IntToStr(ls)
                     + '日 (' + DateTimeToFmtStr(o.Registered+ls) + ')' + tmp
        else
          str := str + #13#10'有効期限: 最終あぼーんより' + IntToStr(ls)
                     + '日 (' + DateTimeToFmtStr(o.LatestArresting+ls)+')' + tmp;
      end;
      TListBox(Sender).Hint := str;
      TListBox(Sender).ShowHint := True;
    end else begin
      TListBox(Sender).ShowHint := False;
      TListBox(Sender).Hint := '';
    end;
  end else begin
    TListBox(Sender).ShowHint := False;
    TListBox(Sender).Hint := '';
  end;

  AboneListOnHint := Sender;
  AboneListIndexOnHint := i;

end;
{/beginner}


{beginner} //右クリックで選択(ミス防止) ジェスチャーあると効かない...
procedure TUIConfig.ListBoxNGNameMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lb:TListBox;
  i:Integer;
  p:Integer;
begin
  if (Button<>mbRight) or (ssShift in Shift) then Exit;

  lb:=TListBox(Sender);
  p:=lb.ItemAtPos(Point(X,Y),True);

  if p>=0 then begin
    if not(ssCtrl in Shift) and not(lb.Selected[p]) then
      for i:=0 to lb.Items.Count-1 do
        lb.Selected[i]:=False;
    lb.Selected[p]:=True;
  end;
end;
{/beginner}


{beginner} //ポップアップメニューのチェック位置を設定
procedure TUIConfig.PopupNGWordPopup(Sender: TObject);
var
  lb: TListBox;
  i:Integer;
  f:Boolean;
  ls:Integer;
  tp:Integer;
begin
  case PageControlNGWord.ActivePageIndex of
    0 : lb := ListBoxNGName;
    1 : lb := ListBoxNGAddr;
    2 : lb := ListBoxNGWord;
    4 : lb := ListBoxNGid;
  else
    exit;
  end;

  if lb.SelCount=0 then begin
    for i:=0 to PopupNGWord.Items.Count-1 do
      PopupNGWord.Items[i].Enabled:=False
  end else begin
    for i:=0 to PopupNGWord.Items.Count-1 do
      PopupNGWord.Items[i].Enabled:=True;

    f:=False;
    ls:=-10000;
    tp:=-10000;

    for i:=0 to lb.Items.Count-1 do begin
      if lb.Selected[i] then begin
        if f=False then begin
          f:=True;
          ls:=TNGItemData(lb.Items.Objects[i]).LifeSpan;
          tp:=TNGItemData(lb.Items.Objects[i]).AboneType;
        end else begin
          if TNGItemData(lb.Items.Objects[i]).LifeSpan<>ls then begin
            f:=False;
            break;
          end;
          if TNGItemData(lb.Items.Objects[i]).AboneType<>tp then begin
            f:=False;
            break;
          end;
        end;
      end;
    end;

    if f then begin
      if tp=0 then MenuNGWordNormal.Checked:=True;
      if tp=1 then MenuNGWordNormal.Checked:=True;
      if tp=2 then MenuNGWordTransparent.Checked:=True;
      if tp=4 then MenuNGWordMarking.Checked:=True;

      for i:=0 to MenuNGWordLife.Count-1 do
        if MenuNGWordLife.Items[i].Tag=ls then
          MenuNGWordLife.Items[i].Checked:=True;
    end else begin
      MenuNGWordNormal.Checked:=True;
      MenuNGWordNormal.Checked:=False;
      MenuNGWordLife.Items[0].Checked:=True;
      MenuNGWordLife.Items[0].Checked:=False;
    end;
  end;

end;

{beginner} //NGワードの種別を選ぶ
procedure TUIConfig.MenuNGWordTypeClick(Sender: TObject);
var
  lb: TListBox;
  i: Integer;
begin
  case PageControlNGWord.ActivePageIndex of
    0 : lb := ListBoxNGName;
    1 : lb := ListBoxNGAddr;
    2 : lb := ListBoxNGWord;
    3 : lb := ListBoxNGid;
  else
    exit;
  end;

  for i := lb.Items.Count - 1 downto 0 do
  begin
    if lb.Selected[i] then begin
      TNGItemData(lb.Items.objects[i]).AboneType:=TMenuItem(Sender).Tag;
    end;
  end;

  lb.Refresh;

end;
{/beginner}


{beginner} //NGワードの寿命を選ぶ
procedure TUIConfig.NGWordLifeClick(Sender: TObject);
var
  lb: TListBox;
  i: Integer;
begin
  case PageControlNGWord.ActivePageIndex of
    0 : lb := ListBoxNGName;
    1 : lb := ListBoxNGAddr;
    2 : lb := ListBoxNGWord;
    3 : lb := ListBoxNGid;
  else
    exit;
  end;

  for i := lb.Items.Count - 1 downto 0 do
  begin
    if lb.Selected[i] then
      TNGItemData(lb.Items.objects[i]).LifeSpan:=TMenuItem(Sender).Tag;
  end;
end;
{/beginner}


{beginner} //NGワードの種別ごとに色を変える
procedure TUIConfig.ListBoxNGNameDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  col:TColor;
begin

  col:=0;
  case TNGItemData(TListBox(Control).Items.Objects[Index]).AboneType of
    2:col:=clGreen;
    4:col:=clRed;
  end;

  if odSelected in State then begin
    if col<>0 then
      TListBox(Control).Canvas.Brush.Color:=col
  end else begin
    if col<>0 then
      TListBox(Control).Canvas.Font.Color:=col;
  end;
  TListBox(Control).Canvas.TextRect(Rect,Rect.Left,Rect.Top,TListBox(Control).Items[Index]);

end;
{/beginner}


//※[457]//▼背景色設定
procedure TUIConfig.ButtonColorClick(Sender: TObject);
var
  tag: integer;
  Memo: TMemo;
begin
  tag := TButton(Sender).Tag;
  case tag of
    1: Memo := MemoTree;
    2: Memo := MemoFavorite;
    3: Memo := MemoList;
    4: Memo := MemoLog;
    {$IFNDEF IE}
    5: Memo := MemoTextView;
    {$ENDIF}
    10:Memo := MemoTree;
    11: Memo := MemoThreadTitle; //※[457]
    101: Memo := MemoListOdd;
    102: Memo := MemoListEven;
    200: Memo := MemoHint; //beginner
    201: Memo := MemoHintFix; //beginner
    300: Memo := MemoWriteMemo; //aiai
    else exit;
  end;

  ColorDialog.Color := Memo.Color;
  if not ColorDialog.Execute then
    exit;

  Memo.Color := ColorDialog.Color;

  if tag = 10 then
  begin
    MemoFavorite.Color := ColorDialog.Color;
    MemoList.Color := ColorDialog.Color;
    MemoLog.Color := ColorDialog.Color;
    {$IFNDEF IE}
    MemoTextView.Color := ColorDialog.Color;
    {$ENDIF}
    MemoThreadTitle.Color := ColorDialog.Color;
    MemoHint.Color := ColorDialog.Color;  //beginner
    MemoWriteMemo.Color := ColorDialog.Color; //aiai
  end;

  Config.ColorChanged := true;
end;

//▼フォント設定
procedure TUIConfig.ButtonFontClick(Sender: TObject);
var
  tag: integer;
  Memo: TMemo;
begin
  tag := TButton(Sender).Tag;
  case tag of
    1:  Memo := MemoTree;
    2:  Memo := MemoList;
    3:  Memo := MemoLog;
    4:  Memo := MemoDefault;
    5:  Memo := MemoWrite;
    10: Memo := MemoTree;
    11: Memo := MemoThreadTitle; //※[457]
    200: Memo := MemoHint; //beginner
    201: Memo := MemoHintFix; //beginner
    300: Memo := MemoWriteMemo; //aiai
    else exit;
  end;

  {beginner}
  if tag = 201 then begin
    if not ColorDialog.Execute then
      exit;
    Memo.Font.Color := ColorDialog.Color;
    Config.FontChanged := true;
    Exit;
  end;
  {/beginner}

  FontDialog.Font := Memo.Font;
  if not FontDialog.Execute then
    exit;

  FontDialog.Font.Charset := SHIFTJIS_CHARSET;//beginner
  Memo.Font := FontDialog.Font;

  if tag =1 then
     MemoFavorite.Font := FontDialog.Font
  else if tag = 10 then
  begin
    MemoFavorite.Font := FontDialog.Font;
    MemoList.Font := FontDialog.Font;
    MemoLog.Font := FontDialog.Font;
    MemoDefault.Font := FontDialog.Font;
    MemoThreadTitle.Font := FontDialog.Font;
    MemoWrite.Font := FontDialog.Font;
    MemoHint.Font := FontDialog.Font;  //beginner
    MemoWriteMemo.Font := FontDialog.Font; //aiai
  end;
  {beginner}
  MemoHintFix.Font.Name := MemoHint.Font.Name;
  MemoHintFix.Font.Charset := MemoHint.Font.Charset;
  MemoHintFix.Font.Size := MemoHint.Font.Size;
  {/beginner}

  Config.FontChanged := true;
end;

//※[457]//▼
procedure TUIConfig.SetMainwndColors;
{$IFNDEF IE}
var
  i: integer;
{$ENDIF}
begin
  if self.MemoList.Text = '' then
    exit;
  MainWnd.ListView.Color := self.MemoList.Color;
  MainWnd.TreeView.Color := self.MemoTree.Color;
  MainWnd.FavoriteView.Color := self.MemoFavorite.Color;
  MainWnd.Memo.Color := self.MemoLog.Color;
  MainWnd.ThreadToolPanel.Color := self.MemoThreadTitle.Color;
  Config.wrtWritePanelColor := self.MemoWriteMemo.Color; //aiai
  {$IFNDEF IE}
  Config.clViewColor := self.MemoTextView.Color;
  Mainwnd.WebPanel.Color := Config.clViewColor;
  for i := 0 to viewList.Count -1 do
    viewList.Items[i].browser.Color := Config.clViewColor;
  {$ENDIF}
  {beginner}
  MainWnd.PopupHint.Color := Self.MemoHint.Color;
  Config.clHintOnFix := Self.MemoHintFix.Color;
  Config.viewHintFontLinkColor := Self.MemoHintFix.Font.Color;
  {/beginner}

end;

//▼フォント設定反映
procedure TUIConfig.SetFonts;
var
  font: TFont;
begin
  if MemoTree.Font <> MainWnd.TreeView.Font then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewTreeFontInfo);
    MainWnd.TreeView.Font.Assign(font);
    MainWnd.FavoriteView.Font.Assign(font);
    font.Free;
  end;
  if MemoDefault.Font <> MainWnd.Font then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewDefFontInfo);
    MainWnd.Font.Assign(font);
    MainWnd.StatusBar.Font.Assign(font);
    MainWnd.TabControl.Font.Assign(font);
    MainWnd.ListTabControl.Font.Assign(font);
    //MainWnd.TreeTabControl.Font.Assign(font); //aiai
    self.Font.Assign(font);
    font.Free;
  end;
  if MemoLog.Font <> MainWnd.Memo.Font then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewTraceFontInfo);
    MainWnd.Memo.Font.Assign(font);
    font.Free;
  end;
  if MemoList.Font <> MainWnd.ListView.Font then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewListFontInfo);
    MainWnd.ListView.Font.Assign(font);
    font.Free;
  end;
  //※[457]
  if MemoThreadTitle.Font <> MainWnd.ThreadTitleLabel.Font then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewThreadTitleFontInfo);
    MainWnd.ThreadTitleLabel.Font.Assign(font);
    font.Free;
  end;
  {beginner}
  if MemoHint.Font <> MainWnd.PopupHint.Font then
  begin
    font := TFont.Create;
    Config.SetFont(font, Config.viewHintFontInfo);
    MainWnd.PopupHint.Font.Assign(font);
    MainWnd.PopupHint.Canvas.Font.Assign(font);
    font.Free;
  end;
  config.viewHintFontLinkColor := MemoHintFix.Font.Color;
  {/beginner}
end;

procedure TUIConfig.ButtonSelFolderClick(Sender: TObject);
var
  path: string;
  pszPath: PChar;
  bi: TBrowseInfo;
  pidl: PItemIdList;
begin
  case TButton(Sender).Tag of
  1: path := EditLogBasePath.Text;
  2: path := SkinPathBox.Text;
  else exit;
  end;

  bi.hwndOwner := Handle;
  bi.pidlRoot := nil;
  bi.pszDisplayName := nil;
  bi.lpszTitle := 'フォルダを選択してください';
  bi.ulFlags := BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT;
  bi.lpfn := @BrowseCallBack;
  bi.lParam := integer(PChar(path));
  bi.iImage := 0;

  pidl := SHBrowseForFolder(bi);
  if pidl <> nil then
  begin
    pszPath := StrAlloc(MAX_PATH);
    try
      SHGetPathFromIDList(pidl, pszPath);
      path := string(pszPath);
    finally
      StrDispose(pszPath);
    end;
    CoTaskMemFree(pidl);
    if not AnsiEndsStr('\', path) then
      path := path + '\';
  end;

  case TButton(Sender).Tag of
  1: EditLogBasePath.Text := path;
  2: SkinPathBox.Text := path;
  end;
end;


//▼フォルダ選択ダイアログ用コールバック関数
function BrowseCallback(hWnd: HWND; uMsg: UINT; lParam: LPARAM; lpData: LPARAM): integer;
var
  path: array[0..MAX_PATH] of Char;
begin
  result := 0;

  case uMsg of
  BFFM_INITIALIZED:
    SendMessage(hwnd, BFFM_SETSELECTION, 1, integer(lpData));
  BFFM_SELCHANGED:
    begin
      SHGetPathFromIDList(PItemIDList(lParam), path);
      SendMessage(hWnd, BFFM_SETSTATUSTEXT, 0, integer(@path));
    end;
  end;
end;


procedure TUIConfig.ButtonMseClearClick(Sender: TObject);
begin
  ComboBoxMseGestures.Text := '';
end;

procedure TUIConfig.ButtonMseArrowClick(Sender: TObject);
begin
  if not AnsiEndsStr(TButton(Sender).Caption, ComboBoxMseGestures.Text) then
    ComboBoxMseGestures.Text := ComboBoxMseGestures.Text + TButton(Sender).Caption;
end;

procedure TUIConfig.ComboBoxMseSubMenusDropDown(Sender: TObject);
  procedure AddSubMenuRecursive(item: TMenuItem);
  var
    i: integer;
  begin
    if (item.Caption <> '-') and (item.Name <> '') and
       (item.Visible or item.Enabled) then
    begin
      ComboBoxMseSubMenus.AddItem(item.Caption, item);
    end;
    for i := 0 to item.Count -1 do
      AddSubMenuRecursive(item.Items[i]);
  end;
var
  i: integer;
  item: TMenuItem;
begin
  ComboBoxMseSubMenus.Clear;
  item := nil;
  if ComboBoxMseMenus.ItemIndex >= 0 then
    item := ComboBoxMseMenus.Items.Objects[ComboBoxMseMenus.ItemIndex] as TMenuItem;
  if item = nil then
    exit;
  for i := 0 to item.Count -1 do
    AddSubMenuRecursive(item[i]);
//  for i := 0 to
end;

procedure TUIConfig.ButtonMseAddClick(Sender: TObject);
var
  index: integer;
  addItem: TMenuItem;
begin
  if ComboBoxMseGestures.Text = '' then
    exit;

  addItem := nil;
  index := ComboBoxMseSubMenus.ItemIndex;
  if index >= 0 then
    addItem := ComboBoxMseSubMenus.Items.Objects[index] as TMenuItem
  else begin
    index := ComboBoxMseMenus.ItemIndex;
    if index >= 0 then
      addItem := ComboBoxMseMenus.Items.Objects[index] as TMenuItem;
  end;
  if addItem = nil then
    exit;

  try
    ValueListMouseGesture.Strings.AddObject(ComboBoxMseGestures.Text + '='
                                          + addItem.Caption, addItem);
    ComboBoxMseGestures.Text := '';
    ValueListMouseGesture.TopRow := ValueListMouseGesture.RowCount - ValueListMouseGesture.VisibleRowCount;
  except
  end;
end;

procedure TUIConfig.ButtonMseDeleteClick(Sender: TObject);
var
  index: integer;
begin
  index := ValueListMouseGesture.Row -1;
  if (index >= 0) and (index < ValueListMouseGesture.Strings.Count) then
    ValueListMouseGesture.Strings.Delete(index);
end;

procedure TUIConfig.ComboBoxMseGesturesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not (ssCtrl in Shift) then
    exit;

  case Key of
  VK_UP:   begin ButtonMseArrowClick(ButtonMseUp);   key := 0; end;
  VK_DOWN: begin ButtonMseArrowClick(ButtonMseDown); key := 0; end;
  VK_LEFT: begin ButtonMseArrowClick(ButtonMseLeft); key := 0; end;
  VK_RIGHT:begin ButtonMseArrowClick(ButtonMseRight);key := 0; end;
  else exit;
  end;
  ComboBoxMseGestures.SelStart := length(ComboBoxMseGestures.Text);
end;

procedure TUIConfig.ComboBoxMsePlaceSelect(Sender: TObject);
var
  s:string;
begin
  if ComboBoxMsePlace.ItemIndex=0 then
    s := ''
  else
    s := copy(GESTURE_PLACE_CHAR, (ComboBoxMsePlace.ItemIndex-1) * 2 + 1, 2);

  if AnsiPos(copy(ComboBoxMseGestures.Text,1,2), GESTURE_PLACE_CHAR) = 0 then
    ComboBoxMseGestures.Text := s + ComboBoxMseGestures.Text
  else
    ComboBoxMseGestures.Text := s + copy(ComboBoxMseGestures.Text, 3, high(word));
end;

procedure TUIConfig.ComboBoxMseGesturesChange(Sender: TObject);
begin
  ComboBoxMsePlace.ItemIndex := AnsiPos(copy(ComboBoxMseGestures.Text,1,2), GESTURE_PLACE_CHAR) div 2 + 1;
end;

(* 設定ページごとの初期化:初期化が重そうなページに使用 *)
procedure TUIConfig.PageControlChange(Sender: TObject);
var
  i, index: integer;
  item: TMenuItem;
  font: TFont;
  sr: TSearchRec;
  {beginner}
  procedure LoadNGWord(fn:string; lb:TListbox; Ex: Boolean);
  var
    nglist:TBaseNGStringList;
  begin
    if FileExists(config.basepath + fn) then begin
      if ex then
        nglist := TExNGList.Create
      else
        nglist := TNGStringList.Create;
      try
        nglist.LoadFromFile(config.basepath + fn);
        lb.items.Assign(nglist);
      except
      end;
      nglist.Free;
    end;
  end;
  {/beginner}
  {aiai}
  procedure LoadNGThreadList(fn: String; lb: TListBox);
  begin
    if FileExists(Config.BasePath + fn) then
    begin
      try
        lb.Items.LoadFromFile(Config.BasePath + fn);
      except
      end;
    end;
  end;
  {/aiai}

begin
  self.Caption := '設定 - 【' + PageControl.ActivePage.Caption + '】';
  if PageControl.ActivePage.Tag = 1 then  // 初期化済み
    exit;

  if PageControl.ActivePage = SheetPath then
  begin
    if FindFirst(Config.BasePath + '*', faDirectory, sr) = 0 then
    repeat
      if (sr.Attr = faDirectory) and
         (sr.Name <> '.') and (sr.Name <> '..') and (sr.Name <> 'Logs') then
        SkinPathBox.AddItem(sr.Name + '\', nil);
    until FindNext(sr) <> 0;
    FindClose(sr);

  end
  else if (PageControl.ActivePage = SheetTab) or (PageControl.ActivePage = SheetStyle) then
  begin
    Main.Config.StyleChanged := true;
  end
  else if PageControl.ActivePage = SheetColors then
  begin
    self.MemoTree.Text := '板覧';
    self.MemoFavorite.Text := 'お気に入り';
    self.MemoList.Text := 'スレ覧';
    self.MemoLog.Text := 'トレース画面';
    self.MemoTextView.Text := 'スレビュー';
    self.MemoDefault.Text := 'その他';
    self.MemoThreadTitle.Text := 'スレタイトル'; //※[457]
    self.MemoWrite.Text := '書き込み';
    self.MemoWriteMemo.Text := 'メモ欄';
    self.MemoTree.Color := MainWnd.TreeView.Color;
    self.MemoFavorite.Color := MainWnd.FavoriteView.Color;
    self.MemoList.Color := MainWnd.ListView.Color;
    self.MemoLog.Color := MainWnd.Memo.Color;
    self.MemoThreadTitle.Color := MainWnd.ThreadToolPanel.Color; //※[457]
    {$IFDEF IE}
    self.ButtonTextColor.Enabled :=false;
    self.ButtonTextColor.Visible :=false;
    {$ELSE}
    self.MemoTextView.Color := Config.clViewColor;
    {$ENDIF}
    self.MemoTree.Font := MainWnd.FavoriteView.Font;
    self.MemoFavorite.Font := MainWnd.FavoriteView.Font;
    self.MemoList.Font := MainWnd.ListView.Font;
    self.MemoLog.Font := MainWnd.Memo.Font;
    self.MemoThreadTitle.Font := MainWnd.ThreadTitleLabel.Font;
    {beginner}
    self.MemoHint.Text := 'ヒント';
    self.MemoHint.Color := MainWnd.PopupHint.Color;
    self.MemoHint.Font := MainWnd.PopupHint.Font;
    self.MemoHintFix.Text := 'Lnk';
    self.MemoHintFix.Color := Config.clHintOnFix;
    self.MemoHintFix.Font := self.MemoHint.Font;
    self.MemoHintFix.Font.Color := Config.viewHintFontLinkColor;
    self.MemoHintFix.Font.Style := [fsUnderLine];
    {/beginner}
    self.MemoWriteMemo.Color := Config.wrtWritePanelColor; //aiai
    if Config.viewWriteFontInfo.face <> '' then
    begin
      font := TFont.Create;
      Config.SetFont(font, Config.viewWriteFontInfo);
      MemoWrite.Font.Assign(font);
      font.Free;
    end;
  end
  {aiai}
  else if PageControl.ActivePage = SheetTabColor then
  begin
    self.MemoDefaultActive.Text        := 'デフォルト';
    self.MemoDefaultNoActive.Text      := 'デフォルト';
    self.MemoNewActive.Text            := '新着ある';
    self.MemoNewNoActive.Text          := '新着ある';
    self.MemoNew2Active.Text           := '更新ある';
    self.MemoNew2NoActive.Text         := '更新ある';
    self.MemoProcessActive.Text        := '更新中';
    self.MemoProcessNoActive.Text      := '更新中';
    self.MemoDisableWriteActive.Text   := '書き込めない';
    self.MemoDisableWriteNoAcitve.Text := '書き込めない';
    self.MemoWriteWait.Text            := 'WriteWait中';
    self.MemoAutoReload.Text           := 'オートリロード中';

    self.MemoDefaultActive.Color        := Main.Config.tclActiveBack;
    self.MemoNewActive.Color            := Main.Config.tclActiveBack;
    self.MemoNew2Active.Color           := Main.Config.tclActiveBack;
    self.MemoProcessActive.Color        := Main.Config.tclActiveBack;
    self.MemoDisableWriteActive.Color   := Main.Config.tclActiveBack;
    self.MemoDefaultNoActive.Color      := Main.Config.tclNoActiveBack;
    self.MemoNewNoActive.Color          := Main.Config.tclNoActiveBack;
    self.MemoNew2NoActive.Color         := Main.Config.tclNoActiveBack;
    self.MemoProcessNoActive.Color      := Main.Config.tclNoActiveBack;
    self.MemoDisableWriteNoAcitve.Color := Main.Config.tclNoActiveBack;
    self.MemoWriteWait.Color            := Main.Config.tclWriteWaitBack;
    self.MemoAutoReload.Color           := Main.Config.tclAutoReloadBack;

    self.MemoDefaultActive.Font.Color        := Main.Config.tclDefaultText;
    self.MemoDefaultNoActive.Font.Color      := Main.Config.tclDefaultText;
    self.MemoNewActive.Font.Color            := Main.Config.tclNewText;
    self.MemoNewNoActive.Font.Color          := Main.Config.tclNewText;
    self.MemoNew2Active.Font.Color           := Main.Config.tclNew2Text;
    self.MemoNew2NoActive.Font.Color         := Main.Config.tclNew2Text;
    self.MemoProcessActive.Font.Color        := Main.Config.tclProcessText;
    self.MemoProcessNoActive.Font.Color      := Main.Config.tclProcessText;
    self.MemoDisableWriteActive.Font.Color   := Main.Config.tclDisableWriteText;
    self.MemoDisableWriteNoAcitve.Font.Color := Main.Config.tclDisableWriteText;
  end
  {/aiai}
  else if PageControl.ActivePage = SheetMouse then
  begin
    with MainWnd.MainMenu do
    begin
      for i := 0 to Items.Count -1 do
        if (Items[i].Caption <> '-') and (Items[i].Name <> '') and
           (Items[i].Visible or Items[i].Enabled) then
          ComboBoxMseMenus.AddItem(Items[i].Caption, Items[i]);
    end;
    for i := 0 to Main.Config.mseGestureList.Count -1 do
    begin
      item := Main.Config.mseGestureList.Objects[i] as TMenuItem;
      if item <> nil then
        self.ValueListMouseGesture.Strings.AddObject(Main.Config.mseGestureList.Names[i] + '=' +
                                                     item.Caption, item);
    end;
  end
  else if PageControl.ActivePage = SheetAbone then
  begin
    //※[457]
    {beginner}//NG補助データ関連の追加,OwnerDraw設定
    ListBoxNGName.ItemHeight:=Abs(ListBoxNGName.Font.Height);
    ListBoxNGAddr.ItemHeight:=Abs(ListBoxNGAddr.Font.Height);
    ListBoxNGWord.ItemHeight:=Abs(ListBoxNGWord.Font.Height);
    ListBoxNGid.ItemHeight:=Abs(ListBoxNGid.Font.Height);
    ListBoxNGEx.ItemHeight:=Abs(ListBoxNGEx.Font.Height);
    LoadNGWord(NG_FILE[NG_ITEM_NAME],ListBoxNGName, False);
    LoadNGWord(NG_FILE[NG_ITEM_MAIL],ListBoxNGAddr, False);
    LoadNGWord(NG_FILE[NG_ITEM_MSG],ListBoxNGWord, False);
    LoadNGWord(NG_FILE[NG_ITEM_ID],ListBoxNGid, False);
    LoadNGWord(NG_EX_FILE, ListBoxNGEx, True);
    {aiai}
    ListBoxNGThread.ItemHeight := Abs(ListBoxNGThread.Font.Height);
    LoadNGThreadList(NG_THREAD_FILE, ListBoxNGThread);
    {/aiai}
    {beginner}
  end
  else if PageControl.ActivePage = SheetColumn then
  begin
    for i := 0 to High(Main.Config.stlClmnArray) do
    begin
      index := ListBoxClmnRest.Items.IndexOfName(IntToStr(Main.Config.stlClmnArray[i]) + ' ');
      if index < 0 then
        break;
      ListBoxClmnSelected.Items.Add(ListBoxClmnRest.Items[index]);
      ListBoxClmnRest.Items.Delete(index);
    end;
  end;
  PageControl.ActivePage.Tag := 1; // 初期化した
end;

procedure TUIConfig.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if not (TObject(Node.Data) is TTabSheet) then
    exit;
  PageControl.ActivePage := TTabSheet(Node.Data);
  PageControlChange(Sender);
end;

procedure TUIConfig.ButtonClmnAddClick(Sender: TObject);
var
  index: integer;
begin
  with ListBoxClmnRest do
  begin
    if ItemIndex >= 0 then
    begin
      index := ItemIndex;
      CopySelection(ListBoxClmnSelected);
      DeleteSelected;
      if index <= Count -1 then
        Selected[index] := true
      else if Count > 0 then
        Selected[Count -1] := true;
    end;
  end;
end;

procedure TUIConfig.ButtonClmnDelClick(Sender: TObject);
var
  index: integer;
begin
  with ListBoxClmnSelected do
  begin
    if ItemIndex >= 0 then
    begin
      index := ItemIndex;
      CopySelection(ListBoxClmnRest);
      DeleteSelected;
      if index <= Count -1 then
        Selected[index] := true
      else if Count > 0 then
        Selected[Count -1] := true;
    end;
  end;
end;

procedure TUIConfig.ButtonClmnUpClick(Sender: TObject);
var
  index: integer;
begin
  with ListBoxClmnSelected do
  begin
    if ItemIndex > 0 then
    begin
      index := ItemIndex;
      Items.Move(index, index -1);
      Selected[index -1] := true;
    end;
  end;
end;

procedure TUIConfig.ButtonClmnDownClick(Sender: TObject);
var
  index: integer;
begin
  with ListBoxClmnSelected do
  begin
    if ItemIndex < Items.Count -1 then
    begin
      index := ItemIndex;
      Items.Move(index, index +1);
      Selected[index +1] := true;
    end;
  end;
end;

procedure TUIConfig.ListBoxClmnRestKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  VK_RIGHT:
    begin
      ButtonClmnAddClick(Sender);
      key := 0;
    end;
  end;
end;

procedure TUIConfig.ListBoxClmnSelectedKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
  VK_LEFT, VK_DELETE:
    begin
      ButtonClmnDelClick(Sender);
      key := 0;
    end;
  VK_UP:
    begin
      if (ssCtrl in Shift) or (ssAlt in Shift) then
        ButtonClmnUpClick(Sender);
    end;
  VK_DOWN:
    begin
      if (ssCtrl in Shift) or (ssAlt in Shift) then
        ButtonClmnDownClick(Sender);
    end;
  end;
end;

procedure TUIConfig.ButtonCmdAddClick(Sender: TObject);
begin
  ValueListCommand.InsertRow(EditCmdName.Text, EditCmdExe.Text, true);
  ValueListCommand.TopRow := ValueListCommand.RowCount - ValueListCommand.VisibleRowCount;
end;

procedure TUIConfig.ButtonCmdInsClick(Sender: TObject);
begin
  ValueListCommand.InsertRow(EditCmdName.Text, EditCmdExe.Text, false);
end;

procedure TUIConfig.ButtonCmdDelClick(Sender: TObject);
begin
  if ValueListCommand.Strings.Count > 0 then
    ValueListCommand.DeleteRow(ValueListCommand.Row);
end;

procedure TUIConfig.ValueListCommandSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  EditCmdName.Text := ValueListCommand.Keys[ARow];
  EditCmdExe.Text  := ValueListCommand.Values[ValueListCommand.Keys[ARow]];
end;

procedure TUIConfig.ButtonCmdUpClick(Sender: TObject);
begin
  with ValueListCommand do
    if Row > 1 then
    begin
      Strings.Move(Row -1, Row -2);
      Row := Row -1;
    end;
end;

procedure TUIConfig.ButtonCmdDownClick(Sender: TObject);
begin
  with ValueListCommand do
    if Row < RowCount -1 then
    begin
      Strings.Move(Row -1, Row);
      Row := Row +1;
    end;
end;

procedure TUIConfig.ValueListCommandKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  VK_DELETE:
    begin
      ButtonCmdDelClick(Sender);
      key := 0;
    end;
  VK_UP:
    begin
      if (ssAlt in Shift) then
      begin
        ButtonCmdUpClick(Sender);
        key := 0;
      end;
    end;
  VK_DOWN:
    begin
      if (ssAlt in Shift) then
      begin
        ButtonCmdDownClick(Sender);
        key := 0;
      end;
    end;
  end;
end;

procedure TUIConfig.CheckBoxAutoEnableNestingClick(Sender: TObject);
begin
  SpinEditHintHoverTime.Enabled := CheckBoxAutoEnableNesting.Checked;
end;

procedure TUIConfig.CheckBoxHintAutoEnableNestingClick(Sender: TObject);
begin
  SpinEditHintHintHoverTime.Enabled := CheckBoxHintAutoEnableNesting.Checked;
end;

{beginner}
procedure TUIConfig.ComboBoxMseGesturesDropDown(Sender: TObject);
begin
  PreserveMseGesture := ComboBoxMseGestures.Text;
end;

procedure TUIConfig.ComboBoxMseGesturesSelect(Sender: TObject);
var
  PlaceChar: String;
begin
  PlaceChar := Copy(PreserveMseGesture, 1, 2);
  if AnsiContainsStr(GESTURE_PLACE_CHAR, PlaceChar) then begin
    PreserveMseGesture := PlaceChar + ComboBoxMseGestures.Text;
    PostMessage(Self.Handle, UM_CHANGECOMBOBOX, 0, 0);
  end;
end;

procedure TUIConfig.CustomWndProc(var Message: TMessage);
begin
  case Message.Msg of
    UM_CHANGECOMBOBOX: begin
      ComboBoxMseGestures.Text := PreserveMseGesture;
      ComboBoxMseGestures.SelectAll;
      Message.Result := 1;
    end;
    else WndProc(Message);
  end;
end;
{/beginner}


{aiai}
//タブの背景色の設定
procedure TUIConfig.ButtonBackColorClick(Sender: TObject);
var
  tag: integer;
begin
  tag := TButton(Sender).Tag;
  case tag of
    1:  //アクティブの時のタブの背景色
      begin
        ColorDialog.Color := MemoDefaultActive.Color;
        if not ColorDialog.Execute then exit;

        MemoDefaultActive.Color      := ColorDialog.Color;
        MemoNewActive.Color          := ColorDialog.Color;
        MemoNew2Active.Color         := ColorDialog.Color;
        MemoProcessActive.Color      := ColorDialog.Color;
        MemoDisableWriteActive.Color := ColorDialog.Color;
      end;
    2: //アクティブじゃない時のタブの背景色
      begin
        ColorDialog.Color := MemoDefaultNoActive.Color;
        if not ColorDialog.Execute then exit;

        MemoDefaultNoActive.Color      := ColorDialog.Color;
        MemoNewNoActive.Color          := ColorDialog.Color;
        MemoNew2NoActive.Color         := ColorDialog.Color;
        MemoProcessNoActive.Color      := ColorDialog.Color;
        MemoDisableWriteNoAcitve.Color := ColorDialog.Color;
      end;
    3: //WriteWait中のタブの背景色
      begin
        ColorDialog.Color := MemoWriteWait.Color;
        if not ColorDialog.Execute then exit;

        MemoWriteWait.Color := ColorDialog.Color;
      end;
    4: //AutoReload中のタブの背景色
      begin
        Colordialog.Color := MemoAutoReload.Color;
        if not ColorDialog.Execute then exit;

        MemoAutoReload.Color := ColorDialog.Color;
      end;
  else exit;
  end;
  Main.Config.TabColorChanged := true;
end;

//タブの文字の色の設定
procedure TUIConfig.ButtonTextColorClick(Sender: TObject);
var
  tag: integer;
begin
  tag := TButton(Sender).Tag;
  case tag of
    1: //デフォルトの文字の色
      begin
        ColorDialog.Color := MemoDefaultActive.Font.Color;

        if not ColorDialog.Execute then exit;

        MemoDefaultActive.Font.Color := ColorDialog.Color;
        MemoDefaultNoActive.Font.Color := ColorDialog.Color;
      end;
    2: //新着があるの文字の色
      begin
        ColorDialog.Color := MemoNewActive.Font.Color;

        if not ColorDialog.Execute then exit;

        MemoNewActive.Font.Color := ColorDialog.Color;
        MemoNewNoActive.Font.Color := ColorDialog.Color;
      end;
    3: //更新があるの文字の色
      begin
        ColorDialog.Color := MemoNew2Active.Font.Color;

        if not ColorDialog.Execute then exit;

        MemoNew2Active.Font.Color := ColorDialog.Color;
        MemoNew2NoActive.Font.Color := ColorDialog.Color;

      end;
    4: //更新中の文字の色
      begin
        ColorDialog.Color := MemoProcessActive.Font.Color;

        if not ColorDialog.Execute then exit;

        MemoProcessActive.Font.Color := ColorDialog.Color;
        MemoProcessNoActive.Font.Color := ColorDialog.Color;
      end;
    5: //書き込めないの文字の色
      begin
        ColorDialog.Color := MemoDisableWriteActive.Font.Color;

        if not ColorDialog.Execute then exit;

        MemoDisableWriteActive.Font.Color := ColorDialog.Color;
        MemoDisableWriteNoAcitve.Font.Color := ColorDialog.Color;
      end;
  else exit;
  end;
  Main.Config.TabColorChanged := true;
end;

//aiai ImageViewPreferenceから移動 + 連鎖あぼーん
procedure TUIConfig.cbPermanentNGClick(Sender: TObject);
begin
  cbPermanentMarking.Enabled := cbPermanentNG.Checked;
  cbPermanentMarking.Checked := cbPermanentMarking.Checked and cbPermanentNG.Checked;
  CheckBoxLinkAbone.Enabled  := cbPermanentNG.Checked;
  CheckBoxLinkAbone.Checked  := CheckBoxLinkAbone.Checked and cbPermanentNG.Checked;
end;

//aiai
procedure TUIConfig.ButtonColordNumberClick(Sender: TObject);
begin
   ColorDialog.Color := self.MemoLinkedNumColor.Font.Color;
   if ColorDialog.Execute then
     self.MemoLinkedNumColor.Font.Color := ColorDialog.Color;
end;

//aiai
procedure TUIConfig.ButtonIDLinkColorManyClick(Sender: TObject);
begin
   ColorDialog.Color := self.MemoIDLinkColorMany.Font.Color;
   if ColorDialog.Execute then
     self.MemoIDLinkColorMany.Font.Color := ColorDialog.Color;
end;

//aiai
procedure TUIConfig.ButtonIDLinkColorNoneClick(Sender: TObject);
begin
   ColorDialog.Color := self.MemoIDLinkColorNone.Font.Color;
   if ColorDialog.Execute then
     self.MemoIDLinkColorNone.Font.Color := ColorDialog.Color;
end;

end.
