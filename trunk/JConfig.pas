unit JConfig;
(* Jane2ch のコンフィグレーション情報 *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.80, 2004/09/23 05:47:00 *)

interface

uses
  SysUtils, Forms, Classes, IniFiles, Windows, Graphics,
  UDoLib,
  UCryptAuto,
  USynchro,
  {$IFNDEF IE}
  HogeTextView,
  {$ENDIF}
  StrSub,
  UBase64;

type
  TGestureOprType = (gotNOP=0, gotLOCAL=1, gotGRACEFUL=2, gotCHECK=3);
  TGestureType = (gtClick, gtDblClk, gtMenu, gtOther);
  TTabAddPos = (tapFirst, tapLeft, tapRight, tapEnd);
  TTabClosePos = (tcpLeft, tcpRight);

  TFontInfo = record
    face: string;
    charset: integer;
    height: integer;
    size: integer;
    style: integer;
    color: integer; //▼色情報を追加
  end;

  TJaneConfig = class(TObject)
  private
    function GetFullPath(path: string): string;
  protected
    AccPath: string;
  public
    BasePath: string; (* \ 附き *)
    IniPath: string;
    LogBasePath: string; (* \ 附き *)
    LogConfPath: string;
    SkinPath: string; (* \ 附き *)
    SkinConfPath: string;

    proxyCrt: THogeCriticalSection;

    netUseProxy: boolean;
    netProxyServer: string;
    netProxyPort: integer;
    netProxyServerForWriting: string;
    netProxyPortForWriting  : integer;
    netProxyServerForSSL: string;
    netProxyPortForSSL: integer;
    netReadTimeout: integer;
    netOnline: boolean;
    netUseReadCGI: boolean;
    netRecvBufferSize: integer;
    netNoCache: boolean;

    extBrowserSpecified: boolean;
    extBrowserPath: string;

    bbsMenuURL: string;
    bbs2chServers: TStringList;
    bbsMachiServers: TStringList;
    bbsJBBSServers: TStringList;
    (*
    bbsMenuFetchOnStart: boolean;
    *)

    hintEnabled: boolean;
    hintHoverTime: Cardinal;
    hintHintHoverTime: Cardinal;
    hintForOtherThread: boolean;
    hintNestingPopUp: boolean;       (* 多重ポップアップ *)
    hintAutoEnableNesting: boolean;
    hintHintAutoEnableNesting: boolean;
    hintForURL: boolean;             (* URLポイント時にちょびっと取得 *)
    hintForURLMaxLine: integer;      (* そのときの行数 *)
    hintForURLMaxSize: integer;
    hintForURLWidth:  integer;
    hintForURLHeight: integer;
    hintForURLUseHead: boolean;
    hintForURLWaitTime: integer;
    hintCancelGetExt: TStringList;

    oprCatBySingleClick: boolean;
    oprShowSubjectCache: boolean;  (* スレ一覧のキャッシュを表示 *)
    oprSelPreviousThread: boolean; (* スレ一覧で以前のスレを選択 *)
    oprScrollToPreviousRes: boolean;    (* 最後見た所にジャンプ *)
    oprScrollToNewRes: boolean;    (* 新着レスにジャンプ *)
    oprScrollTop: boolean;         (* true:上に表示／false:下段に表示 *)
    oprToggleRView: boolean;
    //oprAlwaysCheck: boolean;       (* obsoleted by oprGesture.* *)
    //oprTabStopOnTracePane: boolean;
    oprDisableTabKeyInView: boolean;     (* ブラウザのTABキーを頃す *)
    oprBoardTreeExpandOneCategory: boolean;
    oprCheckNewWRedraw: boolean;

    //oprAlwaysCreateNewView: boolean; (* renamed. 0.2.0.2 *)
    oprOpenThreWNewView: boolean; (* 新しいタブでスレを開く 0.2.0.2 *)
    oprOpenFavWNewView: boolean;  (* 新しいタブでお気に入りスレを開く0.2.0.2 *)
    oprOpenBoardWNewTab: boolean;
    oprDrawLines: integer;

    oprGestureBrdClick:  TGestureOprType;
    oprGestureBrdDblClk: TGestureOprType;
    oprGestureBrdMenu:   TGestureOprType;
    oprGestureBrdOther:  TGestureOprType;
    oprGestureThrClick:  TGestureOprType;
    oprGestureThrDblClk: TGestureOprType;
    oprGestureThrMenu:   TGestureOprType;
    oprGestureThrOther:  TGestureOprType;

    oprThreBgOpen  : boolean;
    oprFavBgOpen   : boolean;
    oprClosedBgOpen: boolean;
    oprAddrBgOpen  : boolean;
    oprUrlBgOpen   : boolean;

    oprAddPosNormal: TTabAddPos;
    oprAddPosRelative: TTabAddPos;
    oprClosetPos: TTabClosePos;

    optEnableBoardMenu: boolean;
    optEnableFavMenu: boolean;
    optDateTimeFormat: string;
    optMonthNames: string;
    optDayOfWeek: string;
    optDayOfWeekForThreView: string;  //aiai
    optDayOfWeekListForThreView: TStringList; //aiai

    optCharsInTab: integer;
    //optShowCacheOnBoot: boolean;
    optSaveLastItems: boolean;
    //optAutoSort: boolean;
    optAllowFavoriteDuplicate: boolean;
    optLogListLimitCount: integer;
    optHomeIfSubjectIsEmpty: Boolean;
    {beginner}
    optCheckNewThreadInHour:Integer;
    optCheckThreadMadeAfterLstMdfy:Boolean;
    {/beginner}
    (* 新たに立てられたスレッドのマーク追加 (aiai) *)
    optCheckThreadMadeAfterLstMdfy2: Boolean;

    tstCommHeaders: boolean;
    tstCloseAfterWriting: boolean;
    tstWrtCookie: string;

    brdRecyclableCount: Integer;

    compressRatio: double;
    compressRatioSamples: cardinal;

    datDeleteOutOfTime: boolean;

    tstAuthorizedAccess: boolean; (* *)
    tstEnableHTTPTrace: boolean;
    tstDebugEnabled: boolean;
    tmpPassphrase: string;

    viewZoomSize: integer;

    viewTreeFontInfo: TFontInfo;
    viewTraceFontInfo: TFontInfo;
    viewDefFontInfo: TFontInfo;
    viewListFontInfo: TFontInfo; //▼スレ覧を別に設定
    viewThreadTitleFontInfo: TFontInfo; //※[457]
    viewWriteFontInfo: TFontInfo;
    viewHintFontInfo: TFontInfo;
    viewHintFontLinkColor: TColor;
    viewMemoFontInfo: TFontInfo; (* aiai メモ欄のフォント *)
    viewNGMsgMarker: string;
    viewTransparencyAbone: boolean;
    {beginner}
    viewAboneLevel:Integer;
    viewNGLifeSpan: array[0..4] of Integer;
    viewPermanentNG:Boolean;
    viewPermanentMarking:Boolean;
    {/beginner}
    viewListMarkerNone: string;
    viewListMarkerRead: string;
    viewListMarkerReadWNewMsg: string;
    viewListMarkerReadWMsg: string;
    viewListMarkerReadNoUpdate: string;
    viewListMarkerMarked: string;
    viewListMarkerMarkedWNewMsg: string;
    viewListMarkerMarkedWMsg: string;
    viewListMarkerMarkedNoUpdate: string;
    viewListMarkerNewThread: string; //beginner
    viewListMarkerNewThread2: string; //aiai
    {$IFNDEF IE}
    viewVerticalCaretMargin: integer;
    viewScrollLines: integer;
    viewPageScroll: boolean;
    {beginner}
    viewEnableAutoScroll: Boolean;
    viewScrollSmoothness: Integer;
    viewScrollFrameRate: Integer;
    {/beginner}
    viewTextAttrib: array[THogeAttribute] of THogeTextAttrib;
    viewCaretVisible : boolean;
    {$ENDIF}
    viewZoomPointArray: array[0..5] of integer;
    viewKeywordBrushColor: TColor;  //aiai

    stlVerticalDivision: boolean;
    stlToolBarVisible: boolean;
    stlLinkBarVisible: boolean;
    stlAddressBarVisible: boolean;
    //stlTreeVisible: boolean;
    stlThreadToolBarVisible: boolean;
    stlThreadTitleLabelVisible: boolean;
    stlClmnArray: array[0..11] of Integer;  //aiai

    stlTabStyle: integer;
    stlListTabStyle: integer;
    stlTreeTabStyle: integer;
    stlTabMaltiline: boolean;
    stlTabWidth: integer;
    stlTabHeight: integer;
    stlListTabWidth: integer;
    stlListTabHeight: integer;

    stlMenuIcons: boolean;
    stlLinkBarIcons: boolean;
    stlTabIcons: boolean;
    stlTreeIcons: boolean;
    stlListMarkIcons: boolean;
    stlListTitleIcons: boolean;
    stlListViewUseExtraBackColor: boolean;
    stlShowTreeMarks: boolean;
    {beginner}
    stlSmallLogPanel:Boolean;
    stlLogPanelUnderThread:Boolean;
    {/beginner}

    wrtFormTop:Integer;
    wrtFormLeft:Integer;
    wrtFormHeight:Integer;
    wrtFormWidth:Integer;

    {beginner}
    ojvAllowTreeDup: Boolean;
    ojvLenofOutLineRes: Integer;
    {/beginner}

    wrtRecordWriting: boolean;
    wrtRecordNameMail: boolean; //521
    wrtFormStayOnTop: boolean; //521
    wrtDefaultSageCheck: boolean;
    wrtReplyMark: string;
    wrtShowThreadTitle: boolean;
    wrtNameList: TStringList;
    wrtMailList: TStringList;
    wrtFmUseTaskBar: boolean;
    wrtUseDefaultName: boolean;
    wrtDiscrepancyWarning: Boolean;
    wrtDisableStatusBar: Boolean;
    wrtTrimRight: Boolean; //aiai
    wrtUseWriteWait: Boolean; //aiai
    wrtNameMailWarning: Boolean; //aiai
    wrtWritePanelColor: TColor; //aiai
    wrtBeLogin: Boolean; //aiai
    wrtBEIDDMDM: String; //aiai
    wrtBEIDMDMD: String; //aiai

    grepPopup: boolean;
    grepShowDirect: Boolean; //beginner
    grepPopMaxSeq: integer;
    grepPopEachThreMax: integer;

    mseUseWheelTabChange: boolean;
    mseGestureMargin: integer;
    mseGestureList: TStringList;
    mseWheelScrollUnderCursor: boolean;

    {$IFNDEF IE}
    clViewColor: TColor;
    {$ENDIF}
    clListViewOddBackColor: TColor;
    clListViewEvenBackColor: TColor;
    clHintOnFix: TColor;

    optChottoView: string; //rika

    {aiai}
    tstUseNews: Boolean;
    tstNewsInterval: integer;
    tstNewsBarSize: Integer;

    viewLinkAbone: Boolean;
    viewReadIfScrollBottom: Boolean;

    optWriteMemoImeMode: Boolean;
    optShowOrHideOld: Boolean;
    optHideInTaskTray: Boolean;

    optFavPatrolCheckServerDown: Boolean;
    optFavPatrolOpenNewResThread: Boolean;
    optFavPatrolOpenBack: Boolean;
    optFavPatrolMessageBox: Boolean;


    optCheckNewResSingleClick: Boolean;
    optSetFocusOnWriteMemo: Boolean;
    optOldOnCheckNew: Boolean;

    oprListReloadInterval: integer;
    oprThreadReloadInterval: integer;
    oprAutoReloadInterval: integer;
    oprAutoScrollSpeed: integer;
    oprAutoScrollInterval: array[1..8] of Cardinal;
    oprAutoScrollLines: array[1..8] of integer;
    
    ojvShowDayOfWeek: Boolean;
    ojvOpenNewResThreadLimit: integer;
    ojvIDPopUp: Boolean;
    ojvIDPopOnMOver: Boolean;
    ojvIDPopUpMaxCount: Integer;
    ojvColordNumber: Boolean;
    ojvLinkedNumColor: TColor;
    ojvQuickMerge: Boolean;
    ojvQuickMergeTemp: Boolean;

    ojvIDLinkColor :Boolean;
    ojvIDLinkColorNone: TColor;
    ojvIDLinkColorMany: TColor;
    ojvIDLinkThreshold: Integer;

    grepSearchList: TStringList;
    grepSaveHistroy: Boolean;

    tclActiveBack: TColor;
    tclNoActiveBack: TColor;
    tclWriteWaitBack: TColor;
    tclAutoReloadBack: Tcolor;

    tclDefaultText: TColor;
    tclNewText: TColor;
    tclNew2Text: TColor;
    tclProcessText: TColor;
    tclDisableWriteText: TColor;

    aaAAList: TStringList;

    aaFormTop: integer;
    aaFormLeft: integer;
    aaFormHeight: integer;
    aaFormWidth: integer;

    lovelyWebFormTop: integer;
    lovelyWebFormLeft: integer;
    lovelyWebFormHeight: integer;
    lovelyWebFormWidth: integer;

    ojvchottoViewerTop: integer;
    ojvchottoViewerLeft: integer;
    ojvchottoViewerHeight: integer;
    ojvchottoViewerWidth: integer;

    stlDefSortColumn: integer;
    stlDefFuncSortColumn: integer;

    schDefaultSearch: integer;
    schMigemoPath: String;
    schMigemoDic: String;
    schMigemoPathTmp: String;
    schMigemoDicTmp: String;
    schUseSearchBar: Boolean;
    schUseSearchBarTmp: Boolean;
    {/aiai}

    {$IFNDEF IE}
    //改造▽ 追加 (スレビューに壁紙を設定する。Doe用)
    //viewBrowserWallpaperEnabled: Boolean;
    //viewBrowserWallpaperAlign: TWallpaperAlign;
    //viewBrowserWallpaperName: string;
    //改造△ 追加 (スレビューに壁紙を設定する。Doe用)
    {$ENDIF}

    cmdExecuteList: TStringList;
    cmdConfigList:  TStringList;

    accUserID: string;
    accPasswd: string;
    accAutoAuth: boolean;
    tmpChanged: boolean;
    accPassphrasedPasswd: string;

    ColorChanged: boolean;
    FontChanged: boolean;
    StyleChanged: boolean;

    TabColorChanged: boolean; //aiai

    Modified: boolean;

    waitTimeList: TStringList; //aiai

    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    procedure Load;
    procedure Save;
    procedure SaveTabColor;    //aiai
    procedure SaveAAFormPos(Rect: TRect); //aiai
    procedure SaveChottoFormPos(Rect: TRect); //aiai
    procedure SaveLovelyFormPos(Rect: TRect); //aiai
    procedure SaveWriteFormPos(Rect: TRect); //beginner

    procedure AddSample(compressed, uncompressed: cardinal);
    procedure SetDateTimeFormat;
    procedure SetFontInfo(var info: TFontInfo; font: TFont);
    procedure SetFont(var font: TFont; info: TFontInfo);

    procedure SetAutoScrollSpeed(tag: integer);
  end;

const
  INI_WIN_SECT: string = 'WINDOW';
  INI_PATH_SECT: string = 'PATH';
  INI_NET_SECT: string = 'NET';
  INI_LOG_SECT: string = 'LOGS';
  INI_BBS_SECT: string = 'BBSMENU';
  INI_EXT_SECT: string = 'EXTERNAL';
  INI_OPT_SECT: string = 'OPTIONS';
  INI_OPR_SECT: string = 'OPERATION';
  INI_VIEW_SECT:string = 'VIEW';
  INI_TEST_SECT: string = 'TEST';
  INI_DAT_SECT: string = 'DAT';
  INI_USER_SECT: string = 'USER2CH';
  INI_STL_SECT: string = 'STYLE';
  INI_WRT_SECT: string = 'WRITE';
  INI_GREP_SECT: string = 'GREP';
  INI_CL_SECT: string = 'COLOR';
  INI_MSE_SECT: string = 'MOUSE';
  INI_OJV_SECT: string = 'OJVIEW';
  INI_TCL_SECT: string = 'TABCOLOR';  //aiai
  INI_AA_SECT: string = 'AA';         // aiai
  INI_SCH_SECT: string = 'SEARCH';  //aiai

  MOUSE_FILE: string = 'mouse.dat';
  COMMAND_FILE: string = 'command.dat';
  ATTRIBUTE_FILE: string = 'attrib.ini';
  INI_ATTRIB_SECT: string = 'ATTRIBUTE';
  AALIST_FILE: string = 'AAlist.txt';
  WRITEWAIT_FILE: string = 'WriteWait.ini'; //aiai

(*=======================================================*)
implementation
(*=======================================================*)
uses
  Main, JLWritePanel;

function BitToFontStyles(bit: integer): TFontStyles;
begin
  result := [];
  if (bit and $1) <> 0 then
    Include(result, fsBold);
  if (bit and $2) <> 0 then
    Include(result, fsItalic);
  if (bit and $4) <> 0 then
    Include(result, fsUnderline);
  if (bit and $8) <> 0 then
    Include(result, fsStrikeOut);
end;

function StylesToBit(Style: TFontStyles): Integer;
begin
  result := 0;
  if fsBold in Style then
    Inc(result, $1);
  if fsItalic in Style then
    Inc(result, $2);
  if fsUnderline in Style then
    Inc(result, $4);
  if fsStrikeOut in Style then
    Inc(result, $8);
end;


(*  *)
constructor TJaneConfig.Create;
begin
  inherited;
  proxyCrt :=THogeCriticalSection.Create;
  Initialize;
end;

destructor TJaneConfig.Destroy;
begin
  proxyCrt.Free;
  bbs2chServers.Free;
  bbsMachiServers.Free;
  bbsJBBSServers.Free;
  hintCancelGetExt.Free;
  wrtNameList.Free;
  wrtMailList.Free;
  cmdExecuteList.Free;
  cmdConfigList.Free;
  mseGestureList.Free;
  {aiai}
  aaAAList.Free;
  waitTimeList.Free;
  grepSearchList.Free;
  optDayOfWeekListForThreView.Free;
  {/aiai}
  inherited;
end;

(*  *)
procedure TJaneConfig.Initialize;
var
  i: integer;
  {$IFNDEF IE}
  procedure InitTextAttrib;
  var
    i: integer;
  begin
    for i := 0 to SizeOf(viewTextAttrib) div SizeOf(THogeTextAttrib) -1 do
    begin
      with viewTextAttrib[i] do
      begin
        color := clWindowText;
        style := [];
      end;
    end;
    viewTextAttrib[1].style := [fsBold];
    viewTextAttrib[2].color := clBlue;
    viewTextAttrib[2].style := [fsUnderline];
    viewTextAttrib[3].color := clBlue;
    viewTextAttrib[3].style := [fsBold, fsUnderline];
    viewTextAttrib[4].color := RGB($22,$8B,$22);
    viewTextAttrib[5].color := RGB($22,$8B,$22);
    viewTextAttrib[5].style := [fsBold];
  end;
  {$ENDIF}
begin
  BasePath := ExtractFilePath(Application.ExeName);
  IniPath := ChangeFileExt(Application.ExeName, '.ini');
  LogBasePath := BasePath;
  LogConfPath := '';
  SkinPath := BasePath;
  SkinConfPath := '';
  AccPath := BasePath + 'account.cfg';

  netUseProxy := false;
  netProxyPort   := 0;
  netProxyPortForWriting := 0;
  netProxyPortForSSL := 0;
  netReadTimeout := 30000;
  netRecvBufferSize := 32; (* GRecvBufferSizeDefault==1024*32 *)
  netOnline := true;
  netUseReadCGI := False;
  netNoCache := false;

  extBrowserSpecified:= false;
  extBrowserPath:='';

//  bbsMenuURL        := 'http://www.dd.iij4u.or.jp/~cap/bbsmenu.html';
//  bbsMenuURL        := 'http://www.2ch.net/newbbsmenu.html';
//  bbsMenuURL        := 'http://www6.ocn.ne.jp/~mirv/2chmenu.html';
//  bbsMenuURL := 'http://www.ff.iij4u.or.jp/~ch2/bbsmenu.html';
  bbsMenuURL := 'http://azlucky.s25.xrea.com/2chboard/bbsmenu.html'; //aiai
  bbs2chServers := TStringList.Create;
  bbsMachiServers := TStringList.Create;
  bbsJBBSServers := TStringList.Create;
  (*
  bbsMenuFetchOnStart := true;
  *)

  hintEnabled := true;
  hintHoverTime := 0;  //aiai
  hintHintHoverTime := 300;
  hintForOtherThread := true;
  hintNestingPopUp := true;
  hintAutoEnableNesting := true;      //aiai
  hintHintAutoEnableNesting := true;  //aiai
  hintForURL := false;
  hintForURLMaxLine := 30;
  hintForURLMaxSize:= 2048;
  hintForURLWidth:= 400;
  hintForURLHeight:= 200;
  hintForURLUseHead:= true;
  hintForURLWaitTime := 1000;
  hintCancelGetExt := TStringList.Create;

  oprCatBySingleClick := true;
  oprShowSubjectCache := false;
  oprSelPreviousThread := false;
  oprScrollToPreviousRes := true;
  oprScrollToNewRes := false;
  oprScrollTop := true;
  oprToggleRView := false;
  //oprAlwaysCheck := false;
  //oprTabStopOnTracePane := false;
  oprDisableTabKeyInView := true;
  oprBoardTreeExpandOneCategory := false;
  oprCheckNewWRedraw := false;
  oprDrawLines := 0;

  //oprAlwaysCreateNewView := false;
  oprOpenThreWNewView := true;  //aiai
  oprOpenFavWNewView := true;
  oprOpenBoardWNewTab := true;  //aiai

  oprGestureBrdClick := gotCHECK;  //aiai
  oprGestureBrdDblClk:= gotCHECK;
  oprGestureBrdMenu  := gotCHECK;
  oprGestureBrdOther := gotGRACEFUL;
  oprGestureThrClick := gotGRACEFUL;
  oprGestureThrDblClk:= gotCHECK;
  oprGestureThrMenu  := gotGRACEFUL;
  oprGestureThrOther := gotGRACEFUL;

  oprThreBgOpen   := false;
  oprFavBgOpen    := false;
  oprClosedBgOpen := false;
  oprAddrBgOpen   := false;
  oprUrlBgOpen    := false;

  oprAddPosNormal := tapEnd;
  oprAddPosRelative := tapEnd;
  oprClosetPos := tcpRight;

  optEnableBoardMenu := true;
  optEnableFavMenu := true;
  optDateTimeFormat := 'yy/mm/dd hh:mm';
  optMonthNames := 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
  optDayOfWeek  := 'Sun,Mon,Tue,Wed,Thu,Fri,Sat';
  optDayOfWeekForThreView := '(月),(火),(水),(木),(金),(土),(日)'; //aiai
  optHomeIfSubjectIsEmpty := True;

  optCharsInTab := 10;
  //optShowCacheOnBoot := true;
  optSaveLastItems := true;   //aiai
  //optAutoSort := false;
  optAllowFavoriteDuplicate := false;
  optLogListLimitCount := 0;
  {beginner}
  optCheckNewThreadInHour :=24;
  optCheckThreadMadeAfterLstMdfy:=True;
  {/beginner}
  (* 新たに立てられたスレッドのマーク追加 (aiai) *)
  optCheckThreadMadeAfterLstMdfy2 := true;

  tstCommHeaders := false;
  tstCloseAfterWriting := true;
  tstEnableHTTPTrace := false;
  tstDebugEnabled := false;

  brdRecyclableCount := 5;

  compressRatio := 0.5;
  compressRatioSamples := 0;

  datDeleteOutOfTime := false;

  tstAuthorizedAccess := false; (* 対応 *)

  accUserID := '';
  accPasswd := '';
  accAutoAuth := false;
  tmpChanged := false;
  accPassphrasedPasswd := '';

  viewZoomSize := 2; (*  *)

  viewNGMsgMarker := 'あぼ～ん';
  viewTransparencyAbone := false;
  {beginner}
  viewAboneLevel:=0;
  viewNGLifeSpan[0]:=0; //NGName
  viewNGLifeSpan[1]:=0; //NGAddr
  viewNGLifeSpan[2]:=0; //NGWord
  viewNGLifeSpan[3]:=3; //NGID
  viewNGLifeSpan[4]:=0; //NGEX
  viewPermanentNG:=false;  //aiai
  viewPermanentMarking:=False;
  {/beginner}
  viewLinkAbone := false; //aiai
  viewListMarkerNone := '';
  viewListMarkerRead := '・';
  viewListMarkerReadWNewMsg := '！';
  viewListMarkerReadWMsg    := '？';
  viewListMarkerReadNoUpdate:= '↓';
  viewListMarkerMarked   := '■';
  viewListMarkerMarkedWNewMsg := '★';
  viewListMarkerMarkedWMsg    := '☆';
  viewListMarkerMarkedNoUpdate:= '▼';
  viewListMarkerNewThread :='○';   //beginner
  viewListMarkerNewThread2 := '●'; //aiai

  {$IFNDEF IE}
  viewVerticalCaretMargin := 1;
  viewScrollLines := 3;
  viewPageScroll := false;
  {beginner}
  viewEnableAutoScroll := True;
  viewScrollSmoothness := 3;
  viewScrollFrameRate := 60;
  {/beginner}
  viewCaretVisible := true;

  //改造▽ 追加 (スレビューに壁紙を設定する。Doe用)
  //viewBrowserWallpaperEnabled := false;
  //viewBrowserWallpaperAlign := walRightBottom;
  //viewBrowserWallpaperName    := '';
  //改造△ 追加 (スレビューに壁紙を設定する。Doe用)

  InitTextAttrib;
  {$ENDIF}

  {beginner} //上のifndefから移動
  viewZoomPointArray[0] := -9;
  viewZoomPointArray[1] := -10;
  viewZoomPointArray[2] := -12;
  viewZoomPointArray[3] := -14;
  viewZoomPointArray[4] := -15;
  {/beginner}

  viewKeywordBrushColor := clYellow;  //aiai


  stlVerticalDivision := true;
  stlToolBarVisible := true;
  stlLinkBarVisible := true;
  stlAddressBarVisible := true;
  //stlTreeVisible := false;
  stlThreadToolBarVisible := true;
  stlThreadTitleLabelVisible := true;

  for i := 0 to High(stlClmnArray) do
    stlClmnArray[i] := i;

  stlTabStyle     := 2;  // tsFlatButtons
  stlListTabStyle := 2;  // tsFlatButtons
  stlTreeTabStyle := 0;  // tsTabs
  stlTabMaltiline := true;
  stlTabWidth := 0;
  stlTabHeight := 20;
  stlListTabWidth := 0;
  stlListTabHeight := 20;

  stlMenuIcons := false;
  stlLinkBarIcons := false;
  stlTabIcons := false;
  stlTreeIcons := true;
  stlListMarkIcons := true;
  stlListTitleIcons := false;            //aiai
  stlListViewUseExtraBackColor := true;  //aiai
  stlShowTreeMarks := true;
  {beginner}
  stlSmallLogPanel:=true;               //aiai
  stlLogPanelUnderThread:=false;         //aiai
  {/beginner}

  wrtFormTop:=145;
  wrtFormLeft:=274;
  wrtFormHeight:=339;
  wrtFormWidth:=491;

  {beginner}
  ojvAllowTreeDup := False;
  ojvLenofOutLineRes := 80;
  {/beginner}

  wrtRecordWriting := false;
  wrtRecordNameMail := false; //521
  wrtFormStayOnTop := false; //521
  wrtDefaultSageCheck := true;
  wrtReplyMark := '>>';
  wrtShowThreadTitle := true;
  wrtNameList := TStringList.Create;
  wrtMailList := TStringList.Create;
  wrtFmUseTaskBar := false;
  wrtUseDefaultName := false;
  wrtDiscrepancyWarning := True;
  wrtDisableStatusBar := False;
  wrtTrimRight := false;
  wrtUseWriteWait := True;
  wrtNameMailWarning := False;
  wrtBeLogin := False;  //aiai
  wrtBEIDDMDM := '';  //aiai
  wrtBEIDMDMD := '';  //aiai

  grepPopup := true;
  grepShowDirect := False; //beginner
  grepPopMaxSeq := 5;
  grepPopEachThreMax := 10;

  mseUseWheelTabChange := false;
  mseGestureMargin := Screen.Height div 40;
  mseGestureList := TStringList.Create;
  mseWheelScrollUnderCursor := true;

  {$IFNDEF IE}
  clViewColor := clWindow;
  {$ENDIF}
  clListViewOddBackColor := $00FFEFFF;  //aiai
  clListViewEvenBackColor := $00FFFFFF;   //aiai
  clHintOnFix := $00efffef;

  cmdExecuteList := TStringList.Create;
  cmdConfigList :=  TStringList.Create;

  ColorChanged := false;
  FontChanged  := false;
  StyleChanged := false;

  optChottoView := 'l30'; //rika

  {aiai}
  tstUseNews := false;
  tstNewsInterval := 10;
  tstNewsBarSize := 500;

  optWriteMemoImeMode := true;
  optShowOrHideOld := true;
  optHideInTaskTray := false;

  optFavPatrolCheckServerDown := false;
  optFavPatrolOpenNewResThread := false;
  optFavPatrolOpenBack := false;
  optFavPatrolMessageBox := false;

  viewReadIfScrollBottom := false;

  optCheckNewResSingleClick := true;
  optSetFocusOnWriteMemo := false;
  optOldOnCheckNew := false;

  oprListReloadInterval := 15;
  oprThreadReloadInterval := 5;
  oprAutoReloadInterval := 5;
  oprAutoScrollSpeed := 5;

  ojvShowDayOfWeek := true;
  ojvOpenNewResThreadLimit := 20;
  ojvIDPopUp := true;
  ojvIDPopOnMOver := true;
  ojvIDPopUpMaxCount := 7;
  ojvColordNumber := true;
  ojvIDLinkColor := true;
  ojvIDLinkThreshold := 5;
  ojvQuickMerge := false;

  grepSearchList := TStringList.Create;
  grepSaveHistroy := true;

  TabColorChanged := false;

  waitTimeList := TStringList.Create;
  aaAAList := TStringList.Create;

  aaFormTop := 80;
  aaFormLeft := 80;
  aaFormHeight := 350;
  aaFormWidth := 300;

  lovelyWebFormTop := 165;
  lovelyWebFormLeft := 221;
  lovelyWebFormHeight := 480;
  lovelyWebFormWidth := 696;

  ojvchottoViewerTop := 80;
  ojvchottoViewerLeft := 80;
  ojvchottoViewerHeight := 300;
  ojvchottoViewerWidth := 400;

  stlDefSortColumn := 1;
  stlDefFuncSortColumn := 1;

  schDefaultSearch := 1;
  schMigemoPath := '';
  schMigemoDic := '';
  schMigemoPathTmp := '';
  schMigemoDicTmp := '';
  schUseSearchBar := True;
  schUseSearchBarTmp := True;
  {/aiai}

  Modified := False;

end;

procedure TJaneConfig.SetDateTimeFormat;
var
  strList: TStringList;
  i: integer;
begin
  strList := TStringList.Create;
  strList.CommaText := self.optMonthNames;
  for i := 0 to strList.Count -1 do
  begin
    if 12 <= i then
      break;
    ShortMonthNames[i + 1] := strList.Strings[i];
  end;
  strList.Clear;
{  strList.CommaText := self.optDayOfWeek;
  for i := 0 to strList.Count -1 do
  begin
    if 7 <= i then
      break;
    ShortDayNames[i + 1] := strList.Strings[i];
  end;}
  {aiai}
  strList.CommaText := self.optDayOfWeekForThreView;

  optDayOfWeekListForThreView := TStringList.Create;

  ShortDayNames[1] := strList.Strings[6];
  optDayOfWeekListForThreView.Append(strList.Strings[6]);
  for i := 1 to strList.Count - 1 do
  begin
    if 7 <= i then
      break;
    ShortDayNames[i + 1] := strList.Strings[i - 1];
    optDayOfWeekListForThreView.Append(strList.Strings[i - 1]);
  end;
  {/aiai}
  strList.Free;
end;

(*  *)
procedure TJaneConfig.Load;
  procedure ExtractFontInfo(var info: TFontInfo; const str: string);
  var
    strList: TStringList;
  begin
    info.face := ''; //'ＭＳ Ｐゴシック';
    info.charset := SHIFTJIS_CHARSET;
    info.height := -12;
    info.size := -9;
    info.style := 0;
    info.color := clWindowText;
    strList := TStringList.Create;
    try
      strList.CommaText := str;
      info.face := strList.Strings[0];
      info.charset := StrToInt(strList.Strings[1]);
      info.height := StrToInt(strList.Strings[2]);
      info.size  := StrToInt(strList.Strings[3]);
      info.style := StrToInt(strList.Strings[4]);
      info.color := HexToInt(strList.Strings[5]);
    except
    end;
    strList.Free;
  end;

  {$IFNDEF IE}
  procedure LoadTextAttribute(ini: TMemIniFile);
  var
    sl: TStringList;
    s: string;
    index: integer;
  begin
    sl := TStringList.Create;
    for index := 0 to High(THogeAttribute) div 2 do
    begin
      s := ini.ReadString(INI_ATTRIB_SECT, 'TextAttrib' + IntToStr(index), '');
      if length(s) <= 0 then
        continue;
      with viewTextAttrib[index*2] do
      begin
        color := clWindowText;
        style := [];
      end;
      with viewTextAttrib[index*2+1] do
      begin
        color := clWindowText;
        style := [fsBold];
      end;
      sl.CommaText := s;
      if 2 <= sl.Count then
      begin
        try
          with viewTextAttrib[index*2] do
          begin
            color := HexToInt(sl[0]);
            style := BitToFontStyles(StrToInt(sl[1]));
          end;
          with viewTextAttrib[index*2+1] do
          begin
            color := viewTextAttrib[index*2].color;
            style := viewTextAttrib[index*2].style + [fsBold];
          end;
        except
        end;
      end;
    end;
    sl.Free;
  end;
  {$ENDIF}

  procedure LoadAccount;
  var
    ini: TMemIniFile;
    cryptObj: THogeCryptAuto;
    plainStream, cryptedStream: TStringStream;
    savePasswd: string;
  begin
    ini := TMemIniFile.Create(AccPath);
    accUserID := ini.ReadString(INI_USER_SECT, 'UserID', accUserID);
    savePasswd := ini.ReadString(INI_USER_SECT, 'Passwd', '');
    accPassphrasedPasswd := ini.ReadString(INI_USER_SECT, 'ALT', accPassphrasedPasswd);
    accAutoAuth := ini.ReadBool(INI_USER_SECT, 'Auto', accAutoAuth);

    accPasswd := ini.ReadString(INI_USER_SECT, 'Password', accPasswd);

    cryptObj := nil;
    plainStream := nil;
    cryptedStream := nil;
    if (0 < length(accPasswd)) then
    begin
      ; (* テスト用アカウント *)
    end
    else if (length(savePasswd) <= 0) or (length(accUserID) <= 0) then
    begin
      ;(* アカウントは設定されていない *)
    end
    else begin
      cryptObj := THogeCryptAuto.Create;
      plainStream := TStringStream.Create('');
      try
        cryptedStream := TStringStream.Create(HogeBase64Decode(savePasswd));
        if cryptObj.Decrypt(cryptedStream, '', plainStream) then
          accPasswd := plainStream.DataString
        else
          raise Exception.Create('');
      except
        Application.MessageBox('パスワードが分んなくなっちゃいました'#13#10'[設定]-[User]へ','あれ？');
      {
      // 暗号化して保存
      if Assigned(cryptedStream) then
        cryptedStream.Free;
      cryptedStream := TStringStream.Create('');
      if Assigned(plainStream) then
        plainStream.Free;
      plainStream := TStringStream.Create(accPasswd);
      if cryptObj.Encrypt(plainStream, '', cryptedStream) then
        ini.WriteString(INI_USER_SECT, 'Password',
                        HogeBase64Encode(cryptedStream.DataString));
      }
      end;
    end;
    tstAuthorizedAccess := accAutoAuth;

    if plainStream <> nil then plainStream.Free;
    if cryptedStream <> nil then cryptedStream.Free;
    if cryptObj <> nil then cryptObj.Free;
    ini.Free;
  end;

  //(clWindowColor = $80000005, clBtnFace = $8000000F)
  procedure LoadColors(ini: TMemIniFile);
  var
    c: string;
  begin
    MainWnd.TreeView.Color := HexToInt(ini.ReadString(INI_CL_SECT, 'TreeViewColor', '80000005'));
    MainWnd.FavoriteView.Color := HexToInt(ini.ReadString(INI_CL_SECT, 'FavoriteViewColor', '80000005'));
    MainWnd.ListView.Color := HexToInt(ini.ReadString(INI_CL_SECT, 'ListViewColor', '80000005'));
    MainWnd.Memo.Color := HexToInt(ini.ReadString(INI_CL_SECT, 'TraceViewColor', '80000005'));
    MainWnd.ThreadToolPanel.Color := HexToInt(ini.ReadString(INI_CL_SECT, 'ThreadTitleViewColor', '00ACACAC'));  //aiai
    MainWnd.ThreadToolPanel.Tag := MainWnd.ThreadToolPanel.Color; //beginner
    wrtWritePanelColor := HexToInt(ini.ReadString(INI_CL_SECT, 'MemoColor', '80000005')); //aiai
    {$IFNDEF IE}
    clViewColor := HexToInt(ini.ReadString(INI_CL_SECT, 'TextViewColor', '00EFEFEF'));   //aiai
    //MainWnd.WebPanel.Color := clViewColor;
    MainWnd.MDIClientPanel.Color := clViewColor;  //aiai
    {$ENDIF}
    c := ini.ReadString(INI_CL_SECT, 'ListViewOddBackColor', '');
    if c <> '' then
      clListViewOddBackColor  := HexToInt(c);
    c := ini.ReadString(INI_CL_SECT, 'ListViewEvenBackColor', '');
    if c <> '' then
      clListViewEvenBackColor := HexToInt(c);
    {beginner}
    c := ini.ReadString(INI_CL_SECT, 'HintColor', '');
    if c <> '' then
      MainWnd.PopupHint.Color := HexToInt(c)
    else
      MainWnd.PopupHint.Color := clInfoBk;
    clHintOnFix := HexToInt(ini.ReadString(INI_CL_SECT, 'HintColorFix', '00efffef'));
    {/beginner}
  end;

  procedure LoadCommand;
  var
    datFile: string;
    i: integer;
  begin
    datFile := BasePath + COMMAND_FILE;
    if not FileExists(datFile) then
      exit;
    cmdConfigList.LoadFromFile(datFile);
    with cmdConfigList do
    begin
      for i := 0 to Count -1 do
        cmdExecuteList.Add(Values[Names[i]]);
    end;
  end;

  procedure LoadColumnArray(ini: TMemIniFile);
  var
    sl: TStringList;
    i: integer;
  begin
    sl := TStringList.Create;
    try
      sl.CommaText := ini.ReadString(INI_STL_SECT, 'ColumnArray', '');
      if sl.Count > 0 then
      begin
        for i := 0 to sl.Count -1 do
          stlClmnArray[i] := StrToInt(sl[i]);
        for i := sl.Count to High(stlClmnArray) do // 負は非表示
          stlClmnArray[i] := -1;
      end else
        for i := 0 to High(stlClmnArray) do
          stlClmnArray[i] := i;
    except // デフォルト順
      for i := 0 to High(stlClmnArray) do
        stlClmnArray[i] := i;
    end;
    sl.Free;
  end;
  procedure LoadZoomPoint(ini: TMemIniFile);
  var
    sl: TStringList;
    i: integer;
  begin
    sl := TStringList.Create;
    try
      sl.CommaText := ini.ReadString(INI_VIEW_SECT, 'ZoomPoint', '');
      if sl.Count = 5 then
      begin
        for i := 0 to 4 do
          viewZoomPointArray[i] := StrToInt(sl[i]);
      end;
    except
    end;
    sl.Free;
  end;

  procedure setAutoScrollArray(ini: TMemIniFile);
  var
    i: Integer;
    s: String;
    strList: TStringList;
  begin
    strList := TStringList.Create;
    s := ini.ReadString(INI_OPR_SECT, 'AutoScrollIntervalArray', '3000,2500,2000,1500,1000,800,600,400');
    strList.CommaText := s;
    for i := 0 to strList.Count - 1 do
    begin
      if 8 <= i then
        break;
      Config.oprAutoScrollInterval[i + 1] := StrToInt(strList.Strings[i]);
    end;
    strList.Clear;
    s := ini.ReadString(INI_OPR_SECT, 'AutoScrollLinesArray', '2,2,2,2,3,3,3,3');
    strList.CommaText := s;
    for i := 0 to strList.Count - 1 do
    begin
      if 8 <= i then
        break;
      Config.oprAutoScrollLines[i + 1] := StrToInt(strList.Strings[i]);
    end;
    strList.Free;
  end;

var
  ini: TMemIniFile;
  //oprAlwaysCheck: boolean;
  s: string;
begin
  ini := TMemIniFile.Create(IniPath);

  LogConfPath := ini.ReadString(INI_PATH_SECT, 'LogBasePath', LogConfPath);
  if (LogConfPath <> '') then
    LogBasePath := GetFullPath(LogConfPath);

  SkinConfPath := ini.ReadString(INI_PATH_SECT, 'SkinPath', SkinConfPath);
  if (SkinConfPath <> '') then
    SkinPath := GetFullPath(SkinConfPath);

  netUseProxy    := ini.ReadBool   (INI_NET_SECT, 'UseProxy', netUseProxy);
  netProxyServer := ini.ReadString (INI_NET_SECT, 'ProxyServer', '');
  netProxyPort   := ini.ReadInteger(INI_NET_SECT, 'ProxyPort', netProxyPort);
  netReadTimeout := ini.ReadInteger(INI_NET_SECT, 'ReadTimeout', netReadTimeout);
  netRecvBufferSize := ini.ReadInteger(INI_NET_SECT, 'RecvBufferSize', netRecvBufferSize);
  netProxyServerForWriting := netProxyServer;
  netProxyPortForWriting := netProxyPort;
  netProxyServerForWriting := ini.ReadString (INI_NET_SECT, 'ProxyServerForWriting', '');
  netProxyPortForWriting   := ini.ReadInteger(INI_NET_SECT, 'ProxyPortForWriting', netProxyPortForWriting);
  netProxyServerForSSL     := ini.ReadString (INI_NET_SECT, 'ProxyServerForSSL', '');
  netProxyPortForSSL       := ini.ReadInteger(INI_NET_SECT, 'ProxyPortForSSL', 0);
  netOnline := ini.ReadBool(INI_NET_SECT, 'Online', netOnline);
  //netUseReadCGI := ini.ReadBool(INI_NET_SECT, 'UseReadCGI', netUseReadCGI);
  netNoCache := ini.ReadBool(INI_NET_SECT, 'NoCache', netNoCache);

  extBrowserSpecified := ini.ReadBool  (INI_EXT_SECT, 'BrowserSpecified', extBrowserSpecified);
  extBrowserPath      := ini.ReadString(INI_EXT_SECT, 'BrowserPath', extBrowserPath);

  bbsMenuURL          := ini.ReadString(INI_BBS_SECT, 'URL', bbsMenuURL);
  bbs2chServers.CommaText := ini.ReadString(INI_BBS_SECT, '2chServers',
                                            '.2ch.net,.bbspink.com');
  bbsMachiServers.CommaText := ini.ReadString(INI_BBS_SECT, 'MachiServers',
                                              '.machibbs.com,.machi.to');
  (* したらば jbbs.livedoor.jp　に対応 (aiai) *)
  bbsJBBSServers.CommaText := ini.ReadString(INI_BBS_SECT, 'JBBSServers',
                      'jbbs.livedoor.jp,jbbs.livedoor.com,jbbs.shitaraba.com');
  (*
  bbsJBBSServers.CommaText := ini.ReadString(INI_BBS_SECT, 'JBBSServers',
                                       'jbbs.livedoor.com,jbbs.shitaraba.com');
  *)
  (*
  bbsMenuFetchOnStart := ini.ReadBool  (INI_BBS_SECT, 'FetchOnStart', bbsMenuFetchOnStart);
  *)

  hintEnabled       := ini.ReadBool   (INI_OPT_SECT, 'HintEnabled', hintEnabled);
  hintHoverTime     := ini.ReadInteger(INI_OPT_SECT, 'HintHoverTime', hintHoverTime);
  hintHintHoverTime := ini.ReadInteger(INI_OPT_SECT, 'HintHintHoverTime', hintHintHoverTime);
  hintForOtherThread:= ini.ReadBool   (INI_OPT_SECT, 'HintForOtherThread', hintForOtherThread);
  hintNestingPopUp  := ini.ReadBool   (INI_OPT_SECT, 'HintNestingPopUp', hintNestingPopUp);
  hintAutoEnableNesting  := ini.ReadBool   (INI_OPT_SECT, 'AutoEnableNesting', hintAutoEnableNesting);
  hintHintAutoEnableNesting  := ini.ReadBool   (INI_OPT_SECT, 'HintAutoEnableNesting', hintHintAutoEnableNesting);
  hintForURL        := ini.ReadBool   (INI_OPT_SECT, 'HintForURL', hintForURL);
  hintForURLMaxLine := ini.ReadInteger(INI_OPT_SECT, 'HintForURLMaxLine', hintForURLMaxLine);
  hintForURLMaxSize := ini.ReadInteger(INI_OPT_SECT, 'HintForURLMaxSize', hintForURLMaxSize);
  hintForURLWidth   := ini.ReadInteger(INI_OPT_SECT, 'HintForURLWidth', hintForURLWidth);
  hintForURLHeight  := ini.ReadInteger(INI_OPT_SECT, 'HintForURLHeight', hintForURLHeight);
  hintForURLUseHead := ini.ReadBool   (INI_OPT_SECT, 'HintForURLUseHead', hintForURLUseHead);
  hintForURLWaitTime:= ini.ReadInteger(INI_OPT_SECT, 'HintForURLWaitTime', hintForURLWaitTime);
  hintCancelGetExt.CommaText := ini.ReadString(INI_OPT_SECT, 'HintCancelExt', '');

  oprCatBySingleClick := ini.ReadBool(INI_OPR_SECT, 'CategoryOprBySingleClick', oprCatBySingleClick);
  oprShowSubjectCache := ini.ReadBool(INI_OPR_SECT, 'ShowSubjectCache', oprShowSubjectCache);
  oprSelPreviousThread := ini.ReadBool(INI_OPR_SECT, 'SelectPreviousThread', oprSelPreviousThread);
  oprScrollToPreviousRes := ini.ReadBool(INI_OPR_SECT, 'ScrollToPreviousRes', oprScrollToPreviousRes);
  oprScrollToNewRes   := ini.ReadBool(INI_OPR_SECT, 'ScrollToNewRes', oprScrollToNewRes);
  oprScrollTop        := ini.ReadBool(INI_OPR_SECT, 'ScrollTop', oprScrollTop);
  oprToggleRView    := ini.ReadBool(INI_OPR_SECT, 'ToggleRView', oprToggleRView);
  //oprTabStopOnTracePane := ini.ReadBool(INI_OPR_SECT, 'TabStopOnTracePane', oprTabStopOnTracePane);
  oprDisableTabKeyInView := ini.ReadBool(INI_OPR_SECT, 'DisableTabKeyInVew', oprDisableTabKeyInView);
  oprBoardTreeExpandOneCategory := ini.ReadBool(INI_OPR_SECT, 'BoardTreeExpandOneCategory', oprBoardTreeExpandOneCategory);
  oprCheckNewWRedraw := ini.ReadBool(INI_OPR_SECT, 'CheckNewWithRedraw', oprCheckNewWRedraw);
  oprDrawLines := ini.ReadInteger(INI_OPR_SECT, 'DrawLines', oprDrawLines);

  (* 移行 *)
  //oprAlwaysCreateNewView := ini.ReadBool(INI_OPR_SECT, 'AlwaysCreateNewView', oprAlwaysCreateNewView);
  oprOpenThreWNewView := ini.ReadBool(INI_OPR_SECT, 'AlwaysCreateNewView', oprOpenThreWNewView);
  oprOpenThreWNewView := ini.ReadBool(INI_OPR_SECT, 'OpenThreadWithNewView', oprOpenThreWNewView);
  oprOpenFavWNewView  := ini.ReadBool(INI_OPR_SECT, 'OpenFavoriteWithNewView', oprOpenFavWNewView);
  oprOpenBoardWNewTab := ini.ReadBool(INI_OPR_SECT, 'OpenBoardWithNewTab', oprOpenBoardWNewTab);

{  if 0 < length(ini.ReadString(INI_OPR_SECT, 'AlwaysCheck', '')) then
  begin
    oprAlwaysCheck   := ini.ReadBool(INI_OPR_SECT, 'AlwaysCheck', false);
    if oprAlwaysCheck then
    begin
      oprGestureBrdClick  := gotCHECK;
      oprGestureBrdDblClk := gotCHECK;
      oprGestureBrdOther  := gotCHECK;
      oprGestureThrClick  := gotCHECK;
      oprGestureThrDblClk := gotCHECK;
      oprGestureThrOther  := gotCHECK;
    end
    else begin
      oprGestureBrdClick  := gotLOCAL;
      oprGestureBrdDblClk := gotCHECK;
      oprGestureBrdOther  := gotLOCAL;
      oprGestureThrClick  := gotGRACEFUL;
      oprGestureThrDblClk := gotCHECK;
      oprGestureThrOther  := gotGRACEFUL;
    end;
  end;}
  oprGestureBrdClick := TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureBrdClick', Ord(oprGestureBrdClick)));
  oprGestureBrdDblClk:= TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureBrdDblClk', Ord(oprGestureBrdDblClk)));
  oprGestureBrdMenu  := TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureBrdMenu', Ord(oprGestureBrdMenu)));
  oprGestureBrdOther := TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureBrdOther', Ord(oprGestureBrdOther)));

  oprGestureThrClick := TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureThrClick', Ord(oprGestureThrClick)));
  oprGestureThrDblClk:= TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureThrDblClk', Ord(oprGestureThrDblClk)));
  oprGestureThrMenu  := TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureThrMenu', Ord(oprGestureThrMenu)));
  oprGestureThrOther := TGestureOprType(ini.ReadInteger(INI_OPR_SECT, 'GestureThrOther', Ord(oprGestureThrOther)));

  oprThreBgOpen   := ini.ReadBool(INI_OPR_SECT, 'ThreBgOpen', oprThreBgOpen);
  oprFavBgOpen    := ini.ReadBool(INI_OPR_SECT, 'FavBgOpen', oprFavBgOpen);
  oprClosedBgOpen := ini.ReadBool(INI_OPR_SECT, 'ClosedBgOpen', oprClosedBgOpen);
  oprAddrBgOpen   := ini.ReadBool(INI_OPR_SECT, 'AddrBgOpen', oprAddrBgOpen);
  oprUrlBgOpen    := ini.ReadBool(INI_OPR_SECT, 'UrlBgOpen', oprUrlBgOpen);

  oprAddPosNormal := TTabAddPos(ini.ReadInteger(INI_OPR_SECT, 'AddPosNormal', Ord(oprAddPosNormal)));
  oprAddPosRelative := TTabAddPos(ini.ReadInteger(INI_OPR_SECT, 'AddPosRelative', Ord(oprAddPosRelative)));
  oprClosetPos := TTabClosePos(ini.ReadInteger(INI_OPR_SECT, 'ClosePos', Ord(oprClosetPos)));

  optEnableBoardMenu:= ini.ReadBool(INI_OPT_SECT, 'EnableBoardMenu', optEnableBoardMenu);
  optEnableFavMenu  := ini.ReadBool(INI_OPT_SECT, 'EnableFavMenu', optEnableFavMenu);
  optDateTimeFormat := ini.ReadString(INI_OPT_SECT, 'DateTimeFormat', self.optDateTimeFormat);
  optMonthNames     := ini.ReadString(INI_OPT_SECT, 'MonthNames', self.optMonthNames);
  optDayOfWeek      := ini.ReadString(INI_OPT_SECT, 'DayOfWeek', self.optDayOfWeek);
  optDayOfWeekForThreView := ini.ReadString(INI_OPT_SECT, 'DayOfWeekForThreView', self.optDayOfWeekForThreView);  //aiai

  SetDateTimeFormat;

  optCharsInTab := ini.ReadInteger(INI_OPT_SECT, 'CharsInTab', optCharsInTab);
  //optShowCacheOnBoot := ini.ReadBool(INI_OPT_SECT, 'ShowCacheOnBoot', optShowCacheOnBoot);
  optSaveLastItems := ini.ReadBool(INI_OPT_SECT, 'SaveLastItems', optSaveLastItems);
  //optAutoSort := ini.ReadBool(INI_OPT_SECT, 'AutoSort', optAutoSort);
  optAllowFavoriteDuplicate := ini.ReadBool(INI_OPT_SECT, 'AllowFavoriteDuplicate', optAllowFavoriteDuplicate);
  optLogListLimitCount := ini.ReadInteger(INI_OPT_SECT, 'LogListLimitCount', optLogListLimitCount);
  optHomeIfSubjectIsEmpty := ini.ReadBool(INI_OPT_SECT, 'HomeIfSubjectIsEmpty', optHomeIfSubjectIsEmpty);
  
  {beginner}
  optCheckNewThreadInHour := ini.ReadInteger(INI_OPT_SECT,'CheckNewThreadInHour',optCheckNewThreadInHour);
  optCheckThreadMadeAfterLstMdfy := ini.ReadBool(INI_OPT_SECT, 'CheckThreadMadeAfterLstMdfy', optCheckThreadMadeAfterLstMdfy);
  {/beginner}
  (* 新たに立てられたスレッドのマーク追加 (aiai) *)
  optCheckThreadMadeAfterLstMdfy2 := ini.ReadBool(INI_OPT_SECT, 'CheckThreadMadeAfterLstMdfy2', optCheckThreadMadeAfterLstMdfy2);

  compressRatio := ini.ReadFloat(INI_TEST_SECT, 'CompressRatio', compressRatio);
  compressRatioSamples := ini.ReadInteger(INI_TEST_SECT, 'CompressRatioSamples', compressRatioSamples);
  tstCommHeaders := ini.ReadBool(INI_TEST_SECT, 'HEADERS', tstCommHeaders);
  tstCloseAfterWriting := ini.ReadBool(INI_TEST_SECT, 'CloseAfterWriting', tstCloseAfterWriting);
  tstEnableHTTPTrace := ini.ReadBool(INI_TEST_SECT, 'EnableHTTPTrace', tstEnableHTTPTrace);
  tstDebugEnabled := ini.ReadBool(INI_TEST_SECT, 'DebugEnabled', tstDebugEnabled);
  tstWrtCookie := ini.ReadString(INI_TEST_SECT, 'WrtCookie', '');
  s := ini.ReadString(INI_TEST_SECT, 'AccountDir', '');
  if 0 < length(s) then
    AccPath := self.BasePath + s + 'account.cfg';

  brdRecyclableCount := ini.ReadInteger(INI_TEST_SECT, 'RecyclableCount', brdRecyclableCount);

  datDeleteOutOfTime := ini.ReadBool(INI_DAT_SECT, 'DeleteOutOfTime', datDeleteOutOfTime);

  //tstAuthorizedAccess := ini.ReadBool(INI_TEST_SECT, 'AuthorizedAccess', tstAuthorizedAccess);

  viewZoomSize := ini.ReadInteger(INI_VIEW_SECT, 'ZoomSize', viewZoomSize);

  s := ini.ReadString(INI_VIEW_SECT, 'TreeViewFont', '"MS UI Gothic",128,-12,9,0,80000008');
  ExtractFontInfo(viewTreeFontInfo, s);
  s := ini.ReadString(INI_VIEW_SECT, 'TraceFont', '"ＭＳ Ｐゴシック",128,-12,9,0,80000008');  //aiai
  ExtractFontInfo(viewTraceFontInfo, s);
  s := ini.ReadString(INI_VIEW_SECT, 'DefaultFont', '"ＭＳ Ｐゴシック",128,-12,9,0,80000008');
  ExtractFontInfo(viewDefFontInfo, s);
  //▼スレ覧を別に設定
  s := ini.ReadString(INI_VIEW_SECT, 'ListViewFont', '"ＭＳ Ｐゴシック",128,12,-9,0,80000008');
  ExtractFontInfo(viewListFontInfo, s);
  //※[457]
  s := ini.ReadString(INI_VIEW_SECT, 'ThreadTitleFont', '"MS UI Gothic",128,-12,9,0,00FFFFFF');
  ExtractFontInfo(viewThreadTitleFontInfo, s);
  s := ini.ReadString(INI_VIEW_SECT, 'WriteFont', '"ＭＳ Ｐゴシック",128,-12,9,0,80000008');
  ExtractFontInfo(viewWriteFontInfo, s);
  {beginner}
  s := ini.ReadString(INI_VIEW_SECT, 'HintFont', '"MS UI Gothic",1,-12,9,0,80000017');
  ExtractFontInfo(viewHintFontInfo, s);
  //▼メモ欄のフォント(aiai)
  s := ini.ReadString(INI_VIEW_SECT, 'MemoFont', '"ＭＳ Ｐゴシック",128,-12,9,0,80000008');
  ExtractFontInfo(viewMemoFontInfo, s);

  viewHintFontLinkColor := ini.ReadInteger(INI_VIEW_SECT, 'HintFontLinkColor', clBlue);
  {/beginner}


  viewNGMsgMarker := ini.ReadString(INI_VIEW_SECT, 'NGMsgMarker', viewNGMsgMarker);
  viewTransparencyAbone := ini.ReadBool(INI_VIEW_SECT, 'TransparencyAbone', viewTransparencyAbone);
  {beginner}
  viewAboneLevel := ini.ReadInteger(INI_VIEW_SECT, 'AboneLevel', viewAboneLevel);
  viewNGLifeSpan[0] := ini.ReadInteger(INI_VIEW_SECT, 'NGNameLifeSpan', viewNGLifeSpan[0]);
  viewNGLifeSpan[1] := ini.ReadInteger(INI_VIEW_SECT, 'NGAddrLifeSpan', viewNGLifeSpan[1]);
  viewNGLifeSpan[2] := ini.ReadInteger(INI_VIEW_SECT, 'NGWordLifeSpan', viewNGLifeSpan[2]);
  viewNGLifeSpan[3] := ini.ReadInteger(INI_VIEW_SECT, 'NGIdLifeSpan', viewNGLifeSpan[3]);
  viewNGLifeSpan[4] := ini.ReadInteger(INI_VIEW_SECT, 'NGExLifeSpan', viewNGLifeSpan[4]);
  viewPermanentNG := ini.ReadBool(INI_VIEW_SECT, 'PermanentNG', viewPermanentNG);
  viewPermanentMarking := ini.ReadBool(INI_VIEW_SECT, 'PermanentMarking', viewPermanentMarking);
  {//beginner}
  viewLinkAbone := ini.ReadBool(INI_VIEW_SECT, 'LinkAbone', viewLinkAbone);  //aiai
  viewListMarkerNone := ini.ReadString(INI_VIEW_SECT, 'ListMarkerNone', viewListMarkerNone);
  viewListMarkerRead := ini.ReadString(INI_VIEW_SECT, 'ListMarkerRead', viewListMarkerRead);
  viewListMarkerReadWNewMsg := ini.ReadString(INI_VIEW_SECT, 'ListMarkerReadWNewMsg', viewListMarkerReadWNewMsg);
  viewListMarkerReadWMsg    := ini.ReadString(INI_VIEW_SECT, 'ListMarkerReadWMsg', viewListMarkerReadWMsg);
  viewListMarkerReadNoUpdate:= ini.ReadString(INI_VIEW_SECT, 'ListMarkerReadNoUpdate', viewListMarkerReadNoUpdate);
  viewListMarkerMarked   := ini.ReadString(INI_VIEW_SECT, 'ListMarkerMarked', viewListMarkerMarked);
  viewListMarkerMarkedWNewMsg := ini.ReadString(INI_VIEW_SECT, 'ListMarkerMarkedWNewMsg', viewListMarkerMarkedWNewMsg);
  viewListMarkerMarkedWMsg    := ini.ReadString(INI_VIEW_SECT, 'ListMarkerMarkedWMsg', viewListMarkerMarkedWMsg);
  viewListMarkerMarkedNoUpdate:= ini.ReadString(INI_VIEW_SECT, 'ListMarkerMarkedNoUpdate', viewListMarkerMarkedNoUpdate);
  viewListMarkerNewThread := ini.ReadString(INI_VIEW_SECT, 'ListMarkerNewThread', viewListMarkerNewThread); //aiai
  viewListMarkerNewThread2:= ini.ReadString(INI_VIEW_SECT, 'ListMarkerNewThread2',viewListMarkerNewThread2);//aiai
  {$IFNDEF IE}
  viewVerticalCaretMargin := ini.ReadInteger(INI_VIEW_SECT, 'CaretMargin', viewVerticalCaretMargin);
  viewScrollLines := ini.ReadInteger(INI_VIEW_SECT, 'ScrollLines', viewScrollLines);
  viewPageScroll := ini.ReadBool(INI_VIEW_SECT, 'PageScroll', viewPageScroll);
  {beginner}
  viewEnableAutoScroll := ini.ReadBool(INI_VIEW_SECT, 'EnableAutoScroll', viewEnableAutoScroll);
  viewScrollSmoothness  := ini.ReadInteger(INI_VIEW_SECT, 'ScrollSmoothness', viewScrollSmoothness);
  viewScrollFrameRate  := ini.ReadInteger(INI_VIEW_SECT, 'ScrollFrameRate', viewScrollFrameRate);
  {/beginner}
  viewCaretVisible := ini.ReadBool(INI_VIEW_SECT, 'CaretVisible', viewCaretVisible);

  viewKeywordBrushColor := ini.ReadInteger(INI_VIEW_SECT, 'KeywordBrushColor', clYellow);  //aiai

  //改造▽ 追加 (スレビューに壁紙を設定する。Doe用)
  //viewBrowserWallpaperEnabled := ini.ReadBool(INI_VIEW_SECT, 'BrowserWallpaperEnabled', viewBrowserWAllpaperEnabled);
  //viewBrowserWallpaperAlign := TWallpaperAlign(ini.ReadInteger(INI_VIEW_SECT, 'BrowserWallpaperAlign', Integer(viewBrowserWallpaperAlign)));
  //viewBrowserWallpaperName := ini.ReadString(INI_VIEW_SECT, 'BrowserWallpaperName', viewBrowserWallpaperName);
  //改造△ 追加 (スレビューに壁紙を設定する。Doe用)

  {$ENDIF}
  LoadZoomPoint(ini); //コンパイル条件式の外に移動

  stlVerticalDivision := ini.ReadBool(INI_STL_SECT, 'VerticalDivision', stlVerticalDivision);
  stlToolBarVisible := ini.ReadBool(INI_STL_SECT, 'ToolBarVisible', stlToolBarVisible);
  stlLinkBarVisible := ini.ReadBool(INI_STL_SECT, 'LinkBarVisible', stlLinkBarVisible);
  stlAddressBarVisible := ini.ReadBool(INI_STL_SECT, 'AddressBarVisible', stlAddressBarVisible);
  //stlTreeVisible := ini.ReadBool(INI_STL_SECT, 'TreeVisible', stlTreeVisible);
  stlThreadToolBarVisible := ini.ReadBool(INI_STL_SECT, 'ThreadToolBarVisible', stlThreadToolBarVisible);
  stlThreadTitleLabelVisible := ini.ReadBool(INI_STL_SECT, 'ThreadTitleVisible', stlThreadTitleLabelVisible);

  stlTabStyle := ini.ReadInteger(INI_STL_SECT, 'TabStyle', stlTabStyle);
  stlListTabStyle := ini.ReadInteger(INI_STL_SECT, 'ListTabStyle', stlListTabStyle);
  stlTreeTabStyle := ini.ReadInteger(INI_STL_SECT, 'TreeTabStyle', stlTreeTabStyle);
  stlTabMaltiline := ini.ReadBool(INI_STL_SECT, 'TabMultiline', stlTabMaltiline);
  stlTabWidth := ini.ReadInteger(INI_STL_SECT, 'TabWidth', stlTabWidth);
  stlTabHeight := ini.ReadInteger(INI_STL_SECT, 'TabHeight', stlTabHeight);
  stlListTabWidth := ini.ReadInteger(INI_STL_SECT, 'ListTabWidth', stlListTabWidth);
  stlListTabHeight := ini.ReadInteger(INI_STL_SECT, 'ListTabHeight', stlListTabHeight);

  stlMenuIcons    := ini.ReadBool(INI_STL_SECT, 'MenuIcons', stlMenuIcons);
  stlLinkBarIcons := ini.ReadBool(INI_STL_SECT, 'LinkBarIcons', stlLinkBarIcons);
  stlTabIcons     := ini.ReadBool(INI_STL_SECT, 'TabIcons', stlTabIcons);
  stlTreeIcons    := ini.ReadBool(INI_STL_SECT, 'TreeIcons', stlTreeIcons);
  stlListMarkIcons    := ini.ReadBool(INI_STL_SECT, 'ListMarkIcons', stlListMarkIcons);
  stlListTitleIcons    := ini.ReadBool(INI_STL_SECT, 'ListTitleIcons', stlListTitleIcons);
  stlListViewUseExtraBackColor := ini.ReadBool(INI_STL_SECT, 'ListViewUseExtraBackColor', stlListViewUseExtraBackColor);
  stlShowTreeMarks := ini.ReadBool(INI_STL_SECT, 'ShowTreeMarks', stlShowTreeMarks);
  {beginner}
  stlSmallLogPanel := ini.ReadBool(INI_STL_SECT, 'SmallLogPanel', stlSmallLogPanel);
  stlLogPanelUnderThread := ini.ReadBool(INI_STL_SECT, 'LogPanelUnderThread', stlLogPanelUnderThread);
  {/beginner}
  wrtFormTop := ini.ReadInteger(INI_WRT_SECT, 'WriteFormTop', wrtFormTop);
  wrtFormLeft := ini.ReadInteger(INI_WRT_SECT, 'WriteFormLeft', wrtFormLeft);
  wrtFormHeight := ini.ReadInteger(INI_WRT_SECT, 'WriteFormHeight', wrtFormHeight);
  wrtFormWidth := ini.ReadInteger(INI_WRT_SECT, 'WriteFormWidth', wrtFormWidth);

  {beginner}
  ojvAllowTreeDup := ini.ReadBool(INI_OJV_SECT, 'AllowTreeDup', ojvAllowTreeDup);
  ojvLenofOutLineRes := ini.ReadInteger(INI_OJV_SECT, 'LenofOutLineRes', ojvLenofOutLineRes);
  {/beginner}

  wrtRecordWriting := ini.ReadBool(INI_WRT_SECT, 'RecordWriting', wrtRecordWriting);
  wrtRecordNameMail := ini.ReadBool(INI_WRT_SECT, 'RecordNameMail', wrtRecordNameMail); //521
  wrtFormStayOnTop := ini.ReadBool(INI_WRT_SECT, 'WriteFormStayOnTop', wrtFormStayOnTop); //521
  wrtDefaultSageCheck := ini.ReadBool(INI_WRT_SECT, 'DefaultSageCheck', wrtDefaultSageCheck);
  wrtReplyMark := ini.ReadString(INI_WRT_SECT, 'ReplyMark', wrtReplyMark);
  wrtShowThreadTitle := ini.ReadBool(INI_WRT_SECT, 'ShowThreadTitle', wrtShowThreadTitle);
  wrtFmUseTaskBar := ini.ReadBool(INI_WRT_SECT, 'FormUseTaskBar', wrtFmUseTaskBar);
  wrtUseDefaultName := ini.ReadBool(INI_WRT_SECT, 'UseDefaultName', wrtUseDefaultName);
  wrtDiscrepancyWarning := ini.ReadBool(INI_WRT_SECT, 'DiscrepancyWarning', wrtDiscrepancyWarning);
  wrtDisableStatusBar := ini.ReadBool(INI_WRT_SECT, 'DisableStatusBar', wrtDisableStatusBar);
  wrtTrimRight := ini.ReadBool(INI_WRT_SECT, 'TrimRight', wrtTrimRight); //aiai
  wrtUseWriteWait := ini.ReadBool(INI_WRT_SECT, 'UseWriteWait', wrtUseWriteWait); //aiai
  wrtNameMailWarning := ini.ReadBool(INI_WRT_SECT, 'NameMailWarning', wrtNameMailWarning); //aiai
  wrtBeLogin := ini.ReadBool(INI_WRT_SECT, 'BeLogin', wrtBeLogin);  //aiai
  wrtBEIDDMDM := ini.ReadString(INI_WRT_SECT, 'BEID_DMDM', wrtBEIDDMDM); //aiai
  wrtBEIDMDMD := ini.ReadString(INI_WRT_SECT, 'BEID_MDMD', wrtBEIDMDMD); //aiai

  grepPopup := ini.ReadBool(INI_GREP_SECT, 'Popup', grepPopup);
  grepShowDirect := ini.ReadBool(INI_GREP_SECT, 'ShowDirect', grepShowDirect); //beginner
  grepPopMaxSeq := ini.ReadInteger(INI_GREP_SECT, 'PopMaxSequence', grepPopMaxSeq);
  grepPopEachThreMax := ini.ReadInteger(INI_GREP_SECT, 'PopEachThreMax', grepPopEachThreMax);

  mseUseWheelTabChange := ini.ReadBool(INI_MSE_SECT, 'WheelTabChange', mseUseWheelTabChange);
  mseGestureMargin := ini.ReadInteger(INI_MSE_SECT, 'GestureMargin', mseGestureMargin);
  mseWheelScrollUnderCursor := ini.ReadBool(INI_MSE_SECT, 'WheelScrollUnderCursor', mseWheelScrollUnderCursor);

  LoadColors(ini);
  LoadColumnArray(ini);

  optChottoView := ini.ReadString(INI_OPT_SECT,'ChottoView',optChottoView); //rika

  {aiai}
  grepSaveHistroy := ini.ReadBool(INI_GREP_SECT, 'SaveHistroy', grepSaveHistroy);

  tstUseNews := ini.ReadBool(INI_TEST_SECT, 'UseNews', tstUseNews);
  tstNewsInterval := ini.ReadInteger(INI_TEST_SECT, 'NewsInterval', tstNewsInterval);
  tstNewsBarSize :=  ini.ReadInteger(INI_TEST_SECT, 'NewsBarSize', tstNewsBarSize);
  optWriteMemoImeMode := ini.ReadBool(INI_WRT_SECT, 'MemoImeMode', optWriteMemoImeMode);
  //optShowOrHideOld := ini.ReadBool(INI_OPT_SECT, 'ShowOrHideOld', optShowOrHideOld);
  optHideInTaskTray := ini.ReadBool(INI_OPT_SECT, 'HideInTaskTray', optHideInTaskTray);

  viewReadIfScrollBottom := ini.ReadBool(INI_VIEW_SECT, 'ReadIfScrollBottom', viewReadIfScrollBottom);

  optCheckNewResSingleClick := ini.ReadBool(INI_OPT_SECT, 'CheckNewResSingleClick', optCheckNewResSingleClick);
  optSetFocusOnWriteMemo := ini.ReadBool(INI_OPT_SECT, 'SetFocusOnWriteMemo', optSetFocusOnWriteMemo);
  optOldOnCheckNew := ini.ReadBool(INI_OPT_SECT, 'OldOnCheckNew', optOldOnCheckNew);

  optFavPatrolCheckServerDown := ini.ReadBool(INI_OPT_SECT, 'FavPatrolCheckServerDown', optFavPatrolCheckServerDown);
  optFavPatrolOpenNewResThread := ini.ReadBool(INI_OPT_SECT, 'FavPatrolOpenNewResThread', optFavPatrolOpenNewResThread);
  optFavPatrolOpenBack := ini.ReadBool(INI_OPT_SECT, 'FavPatrolOpenBack', optFavPatrolOpenBack);
  optFavPatrolMessageBox := ini.ReadBool(INI_OPT_SECT, 'FavPatrolMessageBox', optFavPatrolMessageBox);

  oprListReloadInterval := ini.ReadInteger(INI_OPR_SECT, 'ListReloadInterval', oprListReloadInterval);
  oprThreadReloadInterval := ini.ReadInteger(INI_OPR_SECT, 'ThreadReloadInterval', oprThreadReloadInterval);
  oprAutoReloadInterval := ini.ReadInteger(INI_OPR_SECT, 'AutoReloadInterval', oprAutoReloadInterval);
  oprAutoScrollSpeed := ini.ReadInteger(INI_OPR_SECT, 'AutoScrollSpeed', oprAutoScrollSpeed);
  SetAutoScrollSpeed(oprAutoScrollSpeed);

  ojvShowDayOfWeek := ini.ReadBool(INI_OJV_SECT, 'ShowDayOfWeek', ojvShowDayOfWeek);
  ojvOpenNewResThreadLimit := ini.ReadInteger(INI_OJV_SECT, 'OpenNewResThreadLimit', ojvOpenNewResThreadLimit);
  ojvIDPopUp := ini.ReadBool(INI_OJV_SECT, 'IDPopUp', ojvIDPopUp);
  ojvIDPopOnMOver := ini.ReadBool(INI_OJV_SECT, 'IDPopOnMOver', ojvIDPopOnMOver);
  ojvIDPopUpMaxCount := ini.ReadInteger(INI_OJV_SECT, 'IDPopUpMaxCount', ojvIDPopUpMaxCount);
  ojvColordNumber := ini.ReadBool(INI_OJV_SECT, 'ColordNumber', ojvColordNumber);
  ojvLinkedNumColor := HexToInt(ini.ReadString(INI_OJV_SECT, 'LinkedNumColor', '00CF00AF'));

  ojvIDLinkColor := ini.ReadBool(INI_OJV_SECT, 'IDLinkColor', ojvIDLinkColor);
  ojvIDLinkColorNone := HexToInt(ini.ReadString(INI_OJV_SECT, 'IDLinkColorNone', '00000000'));
  ojvIDLinkColorMany := HexToInt(ini.ReadString(INI_OJV_SECT, 'IDLinkColorMany', '000000FF'));
  ojvIDLinkThreshold := ini.ReadInteger(INI_OJV_SECT, 'IDLinkThreshold', ojvIDLinkThreshold);

  ojvQuickMerge := ini.ReadBool(INI_OJV_SECT, 'QuickMerge', ojvQuickMerge);
  ojvQuickMergeTemp := ojvQuickMerge;

  tclActiveBack       := HexToInt(ini.ReadString(INI_TCL_SECT, 'ActiveBack', '80000005'));
  tclNoActiveBack     := HexToInt(ini.ReadString(INI_TCL_SECT, 'NoActiveBack', '8000000F'));
  tclWriteWaitBack    := HexToInt(ini.ReadString(INI_TCL_SECT, 'WriteWaitBack', '00FFEFFF'));
  tclAutoReloadBack   := HexToInt(ini.ReadString(INI_TCL_SECT, 'AutoReloadBack', '00B193F4'));

  tclDefaultText      := HexToInt(ini.ReadString(INI_TCL_SECT, 'DefaultText', '80000008'));
  tclNewText          := HexToInt(ini.ReadString(INI_TCL_SECT, 'NewText', '00FF0000'));
  tclNew2Text         := HexToInt(ini.ReadString(INI_TCL_SECT, 'New2Text', '0000FF00'));
  tclProcessText      := HexToInt(ini.ReadString(INI_TCL_SECT, 'ProcessText', '0000BCFF'));
  tclDisableWriteText := HexToInt(ini.ReadString(INI_TCL_SECT, 'DisableWriteText', '00808080'));

  aaFormTop := ini.ReadInteger(INI_AA_SECT, 'AAFormTop', aaFormTop);
  aaFormLeft := ini.ReadInteger(INI_AA_SECT, 'AAFormLeft', aaFormLeft);
  aaFormHeight := ini.ReadInteger(INI_AA_SECT, 'AAFormHeight', aaFormHeight);
  aaFormWidth := ini.ReadInteger(INI_AA_SECT, 'AAFormWidth', aaFormWidth);

  lovelyWebFormTop := ini.ReadInteger(INI_OJV_SECT, 'lovelyWebFormTop', lovelyWebFormTop);
  lovelyWebFormLeft := ini.ReadInteger(INI_OJV_SECT, 'lovelyWebFormLeft', lovelyWebFormLeft);
  lovelyWebFormHeight := ini.ReadInteger(INI_OJV_SECT, 'lovelyWebFormHeight', lovelyWebFormHeight);
  lovelyWebFormWidth := ini.ReadInteger(INI_OJV_SECT, 'lovelyWebFormWidth', lovelyWebFormWidth);

  ojvchottoViewerTop    := ini.ReadInteger(INI_OJV_SECT, 'ChottoViewerTop', ojvchottoViewerTop);
  ojvchottoViewerLeft   := ini.ReadInteger(INI_OJV_SECT, 'ChottoViewerLeft', ojvchottoViewerLeft);
  ojvchottoViewerHeight := ini.ReadInteger(INI_OJV_SECT, 'ChottoViewerHeight', ojvchottoViewerHeight);
  ojvchottoViewerWidth  := ini.ReadInteger(INI_OJV_SECT, 'ChottoViewerWidth', ojvchottoViewerWidth);

  stlDefSortColumn := ini.ReadInteger(INI_STL_SECT, 'DefSortColumn', stlDefSortColumn);
  stlDefFuncSortColumn := ini.ReadInteger(INI_STL_SECT, 'DefFuncSortColumn', stlDefFuncSortColumn);

  schDefaultSearch := ini.ReadInteger(INI_SCH_SECT, 'DefaultSearch', schDefaultSearch);
  schMigemoPath := ini.ReadString(INI_SCH_SECT, 'MigemoPath', schMigemoPath);
  schMigemoDic := ini.ReadString(INI_SCH_SECT, 'MigemoDic', schMigemoDic);
  schMigemoPathTmp := schMigemoPath;
  schMigemoDicTmp := schMigemoDic;
  schUseSearchBar := ini.ReadBool(INI_SCH_SECT, 'UseSearchBar', schUseSearchBar);
  schUseSearchBarTmp := schUseSearchBar;
  {/aiai}

  setAutoScrollArray(ini);

  ini.Free;

  {$IFNDEF IE}
  ini := TMemIniFile.Create(GetFullPath(SkinPath) + ATTRIBUTE_FILE);
  LoadTextAttribute(ini);
  if ini.SectionExists(INI_CL_SECT) then
    clViewColor := HexToInt(ini.ReadString(INI_CL_SECT, 'TextViewColor', IntToHex(clViewColor, 6)));
  ini.Free;
  {$ENDIF}


  try
    wrtNameList.LoadFromFile(Config.BasePath + 'name.dat');
  except
  end;
  try
    wrtMailList.LoadFromFile(Config.BasePath + 'mail.dat');
  except
  end;
  {aiai}
  try
    grepSearchList.LoadFromFile(Config.BasePath + 'search.dat')
  except
  end;
  {/aiai}
  if FileExists(BasePath + MOUSE_FILE) then
    mseGestureList.LoadFromFile(BasePath + MOUSE_FILE);

  LoadCommand;
  LoadAccount;

  // 以前のバージョンのゴミを消す
  Windows.WritePrivateProfileString(PChar(INI_OPR_SECT), 'AlwaysCheck', nil, PChar(IniPath));
  Windows.WritePrivateProfileString(PChar(INI_OPR_SECT), 'AlwaysCreateNewView', nil, PChar(IniPath));
  Windows.WritePrivateProfileString(PChar(INI_TEST_SECT), 'ReadPengings', nil, PChar(IniPath));
  //Windows.WritePrivateProfileString(PChar(INI_WIN_SECT), 'Column6', nil, PChar(IniPath));
  Windows.WritePrivateProfileString(PChar(INI_TEST_SECT), 'AuthorizedAccess', nil, PChar(IniPath));
  Windows.WritePrivateProfileString(PChar(INI_NET_SECT), 'UseReadCGI', nil, PChar(IniPath));

  {aiai} // WriteWait.iniを読み込む
  if FileExists(Config.BasePath + WRITEWAIT_FILE) then
    waitTimeList.LoadFromFile(Config.BasePath + WRITEWAIT_FILE)
  else
    waitTimeList.Add('no');
  if FileExists(Config.BasePath + AALIST_FILE) then
    aaAAList.LoadFromFile(Config.BasePath + AALIST_FILE);
  //else
  //  aaAAList.Add('no');
  {/aiai}
end;

(*  *)
procedure TJaneConfig.Save;
  function FontInfoToStr(info: TFontInfo): string;
  var
    strList: TStringList;
  begin
    strList := TStringList.Create;
    strList.Add(info.face);
    strList.Add(IntToStr(info.charset));
    strList.Add(IntToStr(info.height));
    strList.Add(IntToStr(info.size));
    strList.Add(IntToStr(info.style));
    strList.Add(IntToHex(info.color, 8)); //▼色情報を追加
    result := strList.CommaText;
    strList.Free;
  end;

  {$IFNDEF IE}
  procedure SaveTextAttrib(ini: TMemIniFile);
  var
    index: integer;
    s: string;
  begin
    for index := 0 to High(THogeAttribute) div 2 do
    begin
      with viewTextAttrib[index*2] do
      begin
        s := Format('%08.8x,%d', [color, StylesToBit(style)]);
        ini.WriteString(INI_ATTRIB_SECT, 'TextAttrib' + IntToStr(index), s);
      end;
    end;
  end;
  {$ENDIF}

  procedure SaveAccount;
  var
    ini: TMemIniFile;
    cryptObj: THogeCryptAuto;
    plainStream, cryptedStream: TStringStream;
    savePasswd: string;
  begin
    cryptObj := THogeCryptAuto.Create;
    plainStream := TStringStream.Create(accPasswd);
    cryptedStream := TStringStream.Create('');
    if cryptObj.Encrypt(plainStream, '', cryptedStream) then
      savePasswd := HogeBase64Encode(cryptedStream.DataString)
    else
      savePasswd := accPasswd;
    plainStream.Free;
    cryptedStream.Free;
    cryptObj.Free;

    ini := TMemIniFile.Create(AccPath);
    ini.WriteString(INI_USER_SECT, 'UserID', accUserID);
    ini.WriteString(INI_USER_SECT, 'Passwd', savePasswd);
    ini.WriteString(INI_USER_SECT, 'ALT', accPassphrasedPasswd);
    ini.WriteBool  (INI_USER_SECT, 'Auto', accAutoAuth);
    ini.UpdateFile;
    ini.Free;

    Windows.WritePrivateProfileString(PChar(INI_USER_SECT), 'Password', nil, PChar(AccPath));
  end;

  //▼色
  procedure SaveColors(ini: TMemIniFile);
  begin
    ini.WriteString(INI_CL_SECT, 'TreeViewColor', IntToHex(MainWnd.TreeView.Color, 8));
    ini.WriteString(INI_CL_SECT, 'FavoriteViewColor', IntToHex(MainWnd.FavoriteView.Color, 8));
    ini.WriteString(INI_CL_SECT, 'ListViewColor', IntToHex(MainWnd.ListView.Color, 8));
    ini.WriteString(INI_CL_SECT, 'TraceViewColor', IntToHex(MainWnd.Memo.Color, 8));
    ini.WriteString(INI_CL_SECT, 'ThreadTitleViewColor', IntToHex(MainWnd.ThreadToolPanel.Color, 8)); //※[457]
    ini.WriteString(INI_CL_SECT, 'MemoColor', IntToHex(wrtWritePanelColor, 8)); //aiai
    {$IFNDEF IE}
    ini.WriteString('COLOR', 'TextViewColor', IntToHex(Config.clViewColor, 8));
    {$ENDIF}
    ini.WriteString(INI_CL_SECT, 'ListViewOddBackColor', IntToHex(clListViewOddBackColor, 8));
    ini.WriteString(INI_CL_SECT, 'ListViewEvenBackColor', IntToHex(clListViewEvenBackColor, 8));
    ini.WriteString(INI_CL_SECT, 'HintColor', IntToHex(MainWnd.PopupHint.Color, 8));
    ini.WriteString(INI_CL_SECT, 'HintColorFix', IntToHex(clHintOnFix, 8));
  end;

  procedure SaveCommand;
  begin
    if cmdConfigList.Text <> '' then
      cmdConfigList.SaveToFile(BasePath + COMMAND_FILE);
  end;

  procedure SaveMouseGesture;
  begin
    if (mseGestureList.Text <> '') or FileExists(BasePath + MOUSE_FILE) then
      mseGestureList.SaveToFile(BasePath + MOUSE_FILE);
  end;

  procedure SaveColumnArray(ini: TMemIniFile);
  var
    sl: TStringList;
    i: integer;
  begin
    sl := TStringList.Create;
    for i := 0 to High(stlClmnArray) do
    begin
      if stlClmnArray[i] < 0 then
        break;
      sl.Add(IntToStr(stlClmnArray[i]));
    end;
    ini.WriteString(INI_STL_SECT, 'ColumnArray', sl.CommaText);
    sl.Free;
  end;

  procedure SaveZoomPoint(ini: TMemIniFile);
  var
    s: string;
  begin
    s := IntToStr(viewZoomPointArray[0]) + ','
       + IntToStr(viewZoomPointArray[1]) + ','
       + IntToStr(viewZoomPointArray[2]) + ','
       + IntToStr(viewZoomPointArray[3]) + ','
       + IntToStr(viewZoomPointArray[4]);
    ini.WriteString(INI_VIEW_SECT, 'ZoomPoint', s);
  end;

  procedure setScrollSpeedArray(ini: TMemIniFile);
  var
    s: String;
  begin
    s := IntToStr(oprAutoScrollInterval[1]) + ','
       + IntToStr(oprAutoScrollInterval[2]) + ','
       + IntToStr(oprAutoScrollInterval[3]) + ','
       + IntToStr(oprAutoScrollInterval[4]) + ','
       + IntToStr(oprAutoScrollInterval[5]) + ','
       + IntToStr(oprAutoScrollInterval[6]) + ','
       + IntToStr(oprAutoScrollInterval[7]) + ','
       + IntToStr(oprAutoScrollInterval[8]);
    ini.WriteString(INI_OPR_SECT, 'AutoScrollIntervalArray', s);

    s := IntToStr(oprAutoScrollLines[1]) + ','
       + IntToStr(oprAutoScrollLines[2]) + ','
       + IntToStr(oprAutoScrollLines[3]) + ','
       + IntToStr(oprAutoScrollLines[4]) + ','
       + IntToStr(oprAutoScrollLines[5]) + ','
       + IntToStr(oprAutoScrollLines[6]) + ','
       + IntToStr(oprAutoScrollLines[7]) + ','
       + IntToStr(oprAutoScrollLines[8]);
    ini.WriteString(INI_OPR_SECT, 'AutoScrollLinesArray', s);
  end;

var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(IniPath);

  ini.WriteString(INI_PATH_SECT, 'LogBasePath', LogConfPath);
  ini.WriteString(INI_PATH_SECT, 'SkinPath', SkinConfPath);

  ini.WriteBool   (INI_NET_SECT, 'UseProxy', netUseProxy);
  ini.WriteString (INI_NET_SECT, 'ProxyServer', netProxyServer);
  ini.WriteInteger(INI_NET_SECT, 'ProxyPort', netProxyPort);
  ini.WriteInteger(INI_NET_SECT, 'ReadTimeout', netReadTimeout);
  ini.WriteInteger(INI_NET_SECT, 'RecvBufferSize', netRecvBufferSize);
  ini.WriteString (INI_NET_SECT, 'ProxyServerForWriting', netProxyServerForWriting);
  ini.WriteInteger(INI_NET_SECT, 'ProxyPortForWriting', netProxyPortForWriting);
  ini.WriteString (INI_NET_SECT, 'ProxyServerForSSL', netProxyServerForSSL);
  ini.WriteInteger(INI_NET_SECT, 'ProxyPortForSSL', netProxyPortForSSL);
  ini.WriteBool   (INI_NET_SECT, 'Online', netOnline);
  //ini.WriteBool   (INI_NET_SECT, 'UseReadCGI', netUseReadCGI);
  ini.WriteBool   (INI_NET_SECT, 'NoCache', netNoCache);

  ini.WriteBool  (INI_EXT_SECT, 'BrowserSpecified', extBrowserSpecified);
  ini.WriteString(INI_EXT_SECT, 'BrowserPath', extBrowserPath);

  ini.WriteString(INI_BBS_SECT, 'URL', bbsMenuURL);
  (*
  ini.WriteBool  (INI_BBS_SECT, 'FetchOnStart', bbsMenuFetchOnStart);
  *)

  ini.WriteBool   (INI_OPT_SECT, 'HintEnabled', hintEnabled);
  ini.WriteInteger(INI_OPT_SECT, 'HintHoverTime', hintHoverTime);
  ini.WriteInteger(INI_OPT_SECT, 'HintHintHoverTime', hintHintHoverTime);
  ini.WriteBool   (INI_OPT_SECT, 'HintForOtherThread', hintForOtherThread);
  ini.WriteBool   (INI_OPT_SECT, 'HintNestingPopUp', hintNestingPopUp);
  ini.WriteBool   (INI_OPT_SECT, 'AutoEnableNesting', hintAutoEnableNesting);
  ini.WriteBool   (INI_OPT_SECT, 'HintAutoEnableNesting', hintHintAutoEnableNesting);
  ini.WriteBool   (INI_OPT_SECT, 'HintForURL', hintForURL);
  ini.WriteInteger(INI_OPT_SECT, 'HintForURLMaxLine', hintForURLMaxLine);
  ini.WriteInteger(INI_OPT_SECT, 'HintForURLMaxSize', hintForURLMaxSize);
  ini.WriteInteger(INI_OPT_SECT, 'HintForURLWidth', hintForURLWidth);
  ini.WriteInteger(INI_OPT_SECT, 'HintForURLHeight', hintForURLHeight);
  ini.WriteBool   (INI_OPT_SECT, 'HintForURLUseHead', hintForURLUseHead);
  ini.WriteInteger(INI_OPT_SECT, 'HintForURLWaitTime', hintForURLWaitTime);
  ini.WriteString(INI_OPT_SECT, 'HintCancelExt', hintCancelGetExt.CommaText);

  ini.WriteBool(INI_OPR_SECT, 'CategoryOprBySingleClick', oprCatBySingleClick);
  //ini.WriteBool(INI_OPR_SECT, 'ShowSubjectCache', oprShowSubjectCache);
  ini.WriteBool(INI_OPR_SECT, 'SelectPreviousThread', oprSelPreviousThread);
  ini.WriteBool(INI_OPR_SECT, 'ScrollToPreviousRes', oprScrollToPreviousRes);
  ini.WriteBool(INI_OPR_SECT, 'ScrollToNewRes', oprScrollToNewRes);
  ini.WriteBool(INI_OPR_SECT, 'ScrollTop', oprScrollTop);
  ini.WriteBool(INI_OPR_SECT, 'ToggleRView', oprToggleRView);
  //ini.WriteBool(INI_OPR_SECT, 'AlwaysCheck', oprAlwaysCheck);
  //ini.WriteBool(INI_OPR_SECT, 'TabStopOnTracePane', oprTabStopOnTracePane);
  ini.WriteBool(INI_OPR_SECT, 'DisableTabKeyInVew', oprDisableTabKeyInView);
  ini.WriteBool(INI_OPR_SECT, 'BoardTreeExpandOneCategory', oprBoardTreeExpandOneCategory);
  ini.WriteBool(INI_OPR_SECT, 'CheckNewWithRedraw', oprCheckNewWRedraw);
  ini.WriteInteger(INI_OPR_SECT, 'DrawLines', oprDrawLines);

  //ini.WriteBool(INI_OPR_SECT, 'AlwaysCreateNewView', oprAlwaysCreateNewView);
  ini.WriteBool(INI_OPR_SECT, 'OpenThreadWithNewView', oprOpenThreWNewView);
  ini.WriteBool(INI_OPR_SECT, 'OpenFavoriteWithNewView', oprOpenFavWNewView);
  ini.WriteBool(INI_OPR_SECT, 'OpenBoardWithNewTab', oprOpenBoardWNewTab);

  ini.WriteInteger(INI_OPR_SECT, 'GestureBrdClick', Ord(oprGestureBrdClick));
  ini.WriteInteger(INI_OPR_SECT, 'GestureBrdDblClk', Ord(oprGestureBrdDblClk));
  ini.WriteInteger(INI_OPR_SECT, 'GestureBrdMenu', Ord(oprGestureBrdMenu));
  ini.WriteInteger(INI_OPR_SECT, 'GestureBrdOther', Ord(oprGestureBrdOther));

  ini.WriteInteger(INI_OPR_SECT, 'GestureThrClick', Ord(oprGestureThrClick));
  ini.WriteInteger(INI_OPR_SECT, 'GestureThrDblClk', Ord(oprGestureThrDblClk));
  ini.WriteInteger(INI_OPR_SECT, 'GestureThrMenu', Ord(oprGestureThrMenu));
  ini.WriteInteger(INI_OPR_SECT, 'GestureThrOther', Ord(oprGestureThrOther));

  ini.WriteBool(INI_OPR_SECT, 'ThreBgOpen', oprThreBgOpen);
  ini.WriteBool(INI_OPR_SECT, 'FavBgOpen', oprFavBgOpen);
  ini.WriteBool(INI_OPR_SECT, 'ClosedBgOpen', oprClosedBgOpen);
  ini.WriteBool(INI_OPR_SECT, 'AddrBgOpen', oprAddrBgOpen);
  ini.WriteBool(INI_OPR_SECT, 'UrlBgOpen', oprUrlBgOpen);

  ini.WriteInteger(INI_OPR_SECT, 'AddPosNormal', Ord(oprAddPosNormal));
  ini.WriteInteger(INI_OPR_SECT, 'AddPosRelative', Ord(oprAddPosRelative));
  ini.WriteInteger(INI_OPR_SECT, 'ClosePos', Ord(oprClosetPos));

  ini.WriteBool(INI_OPT_SECT, 'EnableBoardMenu', optEnableBoardMenu);
  ini.WriteBool(INI_OPT_SECT, 'EnableFavMenu', optEnableFavMenu);
  ini.WriteString(INI_OPT_SECT, 'DateTimeFormat', self.optDateTimeFormat);
  ini.WriteString(INI_OPT_SECT, 'MonthNames', self.optMonthNames);
  ini.WriteString(INI_OPT_SECT, 'DayOfWeek', self.optDayOfWeek);
  ini.WriteString(INI_OPT_SECT, 'DayOfWeekForThreView', self.optDayOfWeekForThreView);  //aiai
  ini.WriteInteger(INI_OPT_SECT, 'CharsInTab', optCharsInTab);
  //ini.WriteBool   (INI_OPT_SECT, 'ShowCacheOnBoot', optShowCacheOnBoot);
  ini.WriteBool   (INI_OPT_SECT, 'SaveLastItems', optSaveLastItems);
  //ini.WriteBool(INI_OPT_SECT, 'AutoSort', optAutoSort);
  ini.WriteBool(INI_OPT_SECT, 'AllowFavoriteDuplicate', optAllowFavoriteDuplicate);
  ini.WriteInteger(INI_OPT_SECT, 'LogListLimitCount', optLogListLimitCount);
  {beginner}
  ini.WriteInteger(INI_OPT_SECT,'CheckNewThreadInHour',optCheckNewThreadInHour);
  ini.WriteBool(INI_OPT_SECT, 'CheckThreadMadeAfterLstMdfy', optCheckThreadMadeAfterLstMdfy);
  {/beginner}
  (* 新たに立てられたスレッドのマーク追加 (aiai) *)
  ini.WriteBool(INI_OPT_SECT, 'CheckThreadMadeAfterLstMdfy2', optCheckThreadMadeAfterLstMdfy2);

  //ini.WriteBool   (INI_TEST_SECT, 'ShowWritingResult', debugWriting);
  ini.WriteFloat  (INI_TEST_SECT, 'CompressRatio', compressRatio);
  ini.WriteInteger(INI_TEST_SECT, 'CompressRatioSamples', compressRatioSamples);
  ini.WriteBool   (INI_TEST_SECT, 'HEADERS', tstCommHeaders);
  ini.WriteString (INI_TEST_SECT, 'WrtCookie', tstWrtCookie);

  ini.WriteInteger(INI_TEST_SECT, 'RecyclableCount', brdRecyclableCount);

  ini.WriteBool(INI_DAT_SECT, 'DeleteOutOfTime', datDeleteOutOfTime);

  //ini.WriteBool(INI_TEST_SECT, 'AuthorizedAccess', tstAuthorizedAccess);
  ini.WriteBool(INI_TEST_SECT, 'CloseAfterWriting', tstCloseAfterWriting);

  ini.WriteInteger(INI_VIEW_SECT, 'ZoomSize', viewZoomSize);
  ini.WriteString(INI_VIEW_SECT, 'TreeViewFont', FontInfoToStr(viewTreeFontInfo));
  ini.WriteString(INI_VIEW_SECT, 'TraceFont', FontInfoToStr(viewTraceFontInfo));
  ini.WriteString(INI_VIEW_SECT, 'DefaultFont', FontInfoToStr(viewDefFontInfo));
  ini.WriteString(INI_VIEW_SECT, 'ListViewFont', FontInfoToStr(viewListFontInfo)); //▼スレ覧を別に設定
  ini.WriteString(INI_VIEW_SECT, 'ThreadTitleFont', FontInfoToStr(viewThreadTitleFontInfo)); //※[457]
  ini.WriteString(INI_VIEW_SECT, 'WriteFont', FontInfoToStr(viewWriteFontInfo));
  ini.WriteString(INI_VIEW_SECT, 'HintFont', FontInfoToStr(viewHintFontInfo));
  ini.WriteString(INI_VIEW_SECT, 'MemoFont', FontInfoToStr(viewMemoFontInfo)); //aiai
  ini.WriteInteger(INI_VIEW_SECT, 'HintFontLinkColor', viewHintFontLinkColor);


  ini.WriteString(INI_VIEW_SECT, 'NGMsgMarker', viewNGMsgMarker);
  ini.WriteBool(INI_VIEW_SECT, 'TransparencyAbone', viewTransparencyAbone);
  {beginner}
  ini.WriteInteger(INI_VIEW_SECT, 'AboneLevel', viewAboneLevel);
  ini.WriteInteger(INI_VIEW_SECT, 'NGNameLifeSpan', viewNGLifeSpan[0]);
  ini.WriteInteger(INI_VIEW_SECT, 'NGAddrLifeSpan', viewNGLifeSpan[1]);
  ini.WriteInteger(INI_VIEW_SECT, 'NGWordLifeSpan', viewNGLifeSpan[2]);
  ini.WriteInteger(INI_VIEW_SECT, 'NGIdLifeSpan', viewNGLifeSpan[3]);
  ini.WriteInteger(INI_VIEW_SECT, 'NGExLifeSpan', viewNGLifeSpan[4]);
  ini.WriteBool(INI_VIEW_SECT, 'PermanentNG', viewPermanentNG);
  ini.WriteBool(INI_VIEW_SECT, 'PermanentMarking', viewPermanentMarking);

  ini.WriteBool(INI_OJV_SECT, 'AllowTreeDup', ojvAllowTreeDup);
  ini.WriteInteger(INI_OJV_SECT, 'LenofOutLineRes', ojvLenofOutLineRes);
  {/beginner}

  ini.WriteBool(INI_VIEW_SECT, 'LinkAbone', viewLinkAbone);  //aiai

  ini.WriteString(INI_VIEW_SECT, 'ListMarkerNone', viewListMarkerNone);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerRead', viewListMarkerRead);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerReadWNewMsg', viewListMarkerReadWNewMsg);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerReadWMsg', viewListMarkerReadWMsg);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerReadNoUpdate', viewListMarkerReadNoUpdate);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerMarked', viewListMarkerMarked);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerMarkedWNewMsg', viewListMarkerMarkedWNewMsg);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerMarkedWMsg', viewListMarkerMarkedWMsg);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerMarkedNoUpdate', viewListMarkerMarkedNoUpdate);
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerNewThread', viewListMarkerNewThread); //aiai
  ini.WriteString(INI_VIEW_SECT, 'ListMarkerNewThread2',viewListMarkerNewThread2);//aiai
  {$IFNDEF IE}
  ini.WriteInteger(INI_VIEW_SECT, 'CaretMargin', viewVerticalCaretMargin);
  ini.WriteInteger(INI_VIEW_SECT, 'ScrollLines', viewScrollLines);
  ini.WriteBool(INI_VIEW_SECT, 'PageScroll', viewPageScroll);
  {beginner}
  ini.WriteBool(INI_VIEW_SECT, 'EnableAutoScroll', viewEnableAutoScroll);
  ini.WriteInteger(INI_VIEW_SECT, 'ScrollSmoothness', viewScrollSmoothness);
  ini.WriteInteger(INI_VIEW_SECT, 'ScrollFrameRate', viewScrollFrameRate);
  {/beginner}
  ini.WriteBool(INI_VIEW_SECT, 'CaretVisible', viewCaretVisible);

  ini.WriteInteger(INI_VIEW_SECT, 'KeywordBrushColor', viewKeywordBrushColor);

  //改造▽ 追加 (スレビューに壁紙を設定する。Doe用)
  //ini.WriteBool(INI_VIEW_SECT, 'BrowserWallpaperEnabled', viewBrowserWallpaperEnabled);
  //ini.WriteInteger(INI_VIEW_SECT, 'BrowserWallpaperAlign', Integer(viewBrowserWallpaperAlign));
  //ini.WriteString(INI_VIEW_SECT, 'BrowserWallpaperName', viewBrowserWallpaperName);
  //改造△ 追加 (スレビューに壁紙を設定する。Doe用)

  {$ENDIF}
  SaveZoomPoint(ini); //beginner コンパイル条件式の外に

  ini.WriteBool(INI_STL_SECT,'VerticalDivision', stlVerticalDivision);
  ini.WriteBool(INI_STL_SECT, 'ToolBarVisible', stlToolBarVisible);
  ini.WriteBool(INI_STL_SECT, 'LinkBarVisible', stlLinkBarVisible);
  ini.WriteBool(INI_STL_SECT, 'AddressBarVisible', stlAddressBarVisible);
  //ini.WriteBool(INI_STL_SECT, 'TreeVisible', stlTreeVisible);
  ini.WriteBool(INI_STL_SECT, 'ThreadToolBarVisible', stlThreadToolBarVisible);
  ini.WriteBool(INI_STL_SECT, 'ThreadTitleVisible', stlThreadTitleLabelVisible);
  {beginner}
  ini.WriteBool(INI_STL_SECT, 'SmallLogPanel', stlSmallLogPanel);
  ini.WriteBool(INI_STL_SECT, 'LogPanelUnderThread', stlLogPanelUnderThread);
  {/beginner}

  ini.WriteInteger(INI_STL_SECT, 'TabStyle', stlTabStyle);
  ini.WriteInteger(INI_STL_SECT, 'ListTabStyle', stlListTabStyle);
  ini.WriteInteger(INI_STL_SECT, 'TreeTabStyle', stlTreeTabStyle);
  ini.WriteBool(INI_STL_SECT, 'TabMultiline', stlTabMaltiline);
  ini.WriteInteger(INI_STL_SECT, 'TabWidth', stlTabWidth);
  ini.WriteInteger(INI_STL_SECT, 'TabHeight', stlTabHeight);
  ini.WriteInteger(INI_STL_SECT, 'ListTabWidth', stlListTabWidth);
  ini.WriteInteger(INI_STL_SECT, 'ListTabHeight', stlListTabHeight);

  ini.WriteBool(INI_STL_SECT, 'MenuIcons', stlMenuIcons);
  ini.WriteBool(INI_STL_SECT, 'LinkBarIcons', stlLinkBarIcons);
  ini.WriteBool(INI_STL_SECT, 'TabIcons', stlTabIcons);
  ini.WriteBool(INI_STL_SECT, 'TreeIcons', stlTreeIcons);
  ini.WriteBool(INI_STL_SECT, 'ListMarkIcons', stlListMarkIcons);
  ini.WriteBool(INI_STL_SECT, 'ListTitleIcons', stlListTitleIcons);
  ini.WriteBool(INI_STL_SECT, 'ListViewUseExtraBackColor', stlListViewUseExtraBackColor);
  ini.WriteBool(INI_STL_SECT, 'ShowTreeMarks', stlShowTreeMarks);

  ini.WriteBool(INI_WRT_SECT, 'RecordWriting', wrtRecordWriting);
  ini.WriteBool(INI_WRT_SECT, 'DefaultSageCheck', wrtDefaultSageCheck);
  ini.WriteString(INI_WRT_SECT, 'ReplyMark', wrtReplyMark);
  ini.WriteBool(INI_WRT_SECT, 'ShowThreadTitle', wrtShowThreadTitle);
  ini.WriteBool(INI_WRT_SECT, 'FormUseTaskBar', wrtFmUseTaskBar);
  ini.WriteBool(INI_WRT_SECT, 'UseDefaultName', wrtUseDefaultName);
  ini.WriteBool(INI_WRT_SECT, 'DiscrepancyWarning', wrtDiscrepancyWarning);
  ini.WriteBool(INI_WRT_SECT, 'DisableStatusBar', wrtDisableStatusBar);
  ini.WriteString(INI_WRT_SECT, 'BEID_DMDM', wrtBEIDDMDM); //aiai
  ini.WriteString(INI_WRT_SECT, 'BEID_MDMD', wrtBEIDMDMD); //aiai

  ini.WriteBool(INI_MSE_SECT, 'WheelTabChange', mseUseWheelTabChange);
  ini.WriteInteger(INI_MSE_SECT, 'GestureMargin', mseGestureMargin);
  ini.WriteBool(INI_MSE_SECT, 'WheelScrollUnderCursor', mseWheelScrollUnderCursor);

  ini.WriteBool(INI_GREP_SECT, 'Popup', grepPopup);
  ini.WriteBool(INI_GREP_SECT, 'ShowDirect', grepShowDirect); //beginner
  ini.WriteInteger(INI_GREP_SECT, 'PopMaxSequence', grepPopMaxSeq);
  ini.WriteInteger(INI_GREP_SECT, 'PopEachThreMax', grepPopEachThreMax);

  ini.WriteString(INI_OPT_SECT, 'ChottoView', optChottoView); //rika

  {aiai}
  ini.WriteBool(INI_GREP_SECT, 'SaveHistroy', grepSaveHistroy);

  ini.WriteBool(INI_TEST_SECT, 'UseNews', tstUseNews);
  ini.WriteInteger(INI_TEST_SECT, 'NewsInterval', tstNewsInterval);
  ini.WriteInteger(INI_TEST_SECT, 'NewsBarSize', tstNewsBarSize);

  ini.WriteBool(INI_VIEW_SECT, 'ReadIfScrollBottom', viewReadIfScrollBottom);

  //ini.WriteBool(INI_OPT_SECT, 'MemoImeMode', optWriteMemoImeMode);
  //ini.WriteBool(INI_OPT_SECT, 'ShowOrHideOld', optShowOrHideOld);
  ini.WriteBool(INI_OPT_SECT, 'HideInTaskTray', optHideInTaskTray);

  ini.WriteBool(INI_OPT_SECT, 'CheckNewResSingleClick', optCheckNewResSingleClick);
  ini.WriteBool(INI_OPT_SECT, 'SetFocusOnWriteMemo', optSetFocusOnWriteMemo);
  ini.WriteBool(INI_OPT_SECT, 'OldOnCheckNew', optOldOnCheckNew);

  ini.WriteBool(INI_OPT_SECT, 'FavPatrolCheckServerDown', optFavPatrolCheckServerDown);
  ini.WriteBool(INI_OPT_SECT, 'FavPatrolOpenNewResThread', optFavPatrolOpenNewResThread);
  ini.WriteBool(INI_OPT_SECT, 'FavPatrolOpenBack', optFavPatrolOpenBack);
  ini.WriteBool(INI_OPT_SECT, 'FavPatrolMessageBox', optFavPatrolMessageBox);

  ini.WriteBool(INI_OJV_SECT, 'ShowDayOfWeek', ojvShowDayOfWeek);
  ini.WriteInteger(INI_OJV_SECT, 'OpenNewResThreadLimit', ojvOpenNewResThreadLimit);
  ini.WriteBool(INI_OJV_SECT, 'IDPopUp', ojvIDPopUp);
  ini.WriteBool(INI_OJV_SECT, 'IDPopOnMOver', ojvIDPopOnMOver);
  ini.WriteInteger(INI_OJV_SECT, 'IDPopUpMaxCount', ojvIDPopUpMaxCount);
  ini.WriteBool(INI_OJV_SECT, 'ColordNumber', ojvColordNumber);
  ini.WriteString(INI_OJV_SECT, 'LinkedNumColor', IntToHex(ojvLinkedNumColor, 8));

  ini.WriteBool(INI_OJV_SECT, 'IDLinkColor', ojvIDLinkColor);
  ini.WriteString(INI_OJV_SECT, 'IDLinkColorNone', IntToHex(ojvIDLinkColorNone, 8));
  ini.WriteString(INI_OJV_SECT, 'IDLinkColorMany', IntToHex(ojvIDLinkColorMany, 8));
  ini.WriteInteger(INI_OJV_SECT, 'IDLinkThreshold', ojvIDLinkThreshold);
  ini.WriteBool(INI_OJV_SECT, 'QuickMerge', ojvQuickMergeTemp);

  ini.WriteInteger(INI_OPR_SECT, 'ListReloadInterval', oprListReloadInterval);
  ini.WriteInteger(INI_OPR_SECT, 'ThreadReloadInterval', oprThreadReloadInterval);
  ini.WriteInteger(INI_OPR_SECT, 'AutoReloadInterval', oprAutoReloadInterval);
  ini.WriteInteger(INI_OPR_SECT, 'AutoScrollSpeed', oprAutoScrollSpeed);

  ini.WriteInteger(INI_STL_SECT, 'DefSortColumn', stlDefSortColumn);
  ini.WriteInteger(INI_STL_SECT, 'DefFuncSortColumn', stlDefFuncSortColumn);

  ini.WriteInteger(INI_SCH_SECT, 'DefaultSearch', schDefaultSearch);
  ini.WriteString(INI_SCH_SECT, 'MigemoPath', schMigemoPathTmp);
  ini.WriteString(INI_SCH_SECT, 'MigemoDic', schMigemoDicTmp);
  ini.WriteBool(INI_SCH_SECT, 'UseSearchBar', schUseSearchBarTmp);

  setScrollSpeedArray(ini);
  {/aiai}

  if ColorChanged then
    SaveColors(ini);
  SaveColumnArray(ini);
  ini.UpdateFile;
  ini.Free;

  {$IFNDEF IE}
  if DirectoryExists(SkinPath) and not FileExists(SkinPath + ATTRIBUTE_FILE) then
  begin
    ini := TMemIniFile.Create(SkinPath + ATTRIBUTE_FILE);
    SaveTextAttrib(ini);
    ini.UpdateFile;
    ini.Free;
  end;
  {$ENDIF}

  if wrtNameList.Text <> '' then
    wrtNameList.SaveToFile(BasePath + 'name.dat');
  if wrtMailList.Text <> '' then
    wrtMailList.SaveToFile(BasePath + 'mail.dat');
  if grepSearchList.Text <> '' then
    grepSearchList.SaveToFile(BasePath + 'search.dat'); // aiai

  SaveMouseGesture;
  SaveCommand;
  if tmpChanged then
    SaveAccount;

  Modified := False;
end;

{aiai}
//AAエディタの位置を保存
procedure TJaneConfig.SaveAAFormPos(Rect:TRect);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(IniPath);

  ini.WriteInteger(INI_AA_SECT, 'AAFormTop', Rect.Top);
  ini.WriteInteger(INI_AA_SECT, 'AAFormLeft', Rect.Left);
  ini.WriteInteger(INI_AA_SECT, 'AAFormHeight', Rect.Bottom - Rect.Top);
  ini.WriteInteger(INI_AA_SECT, 'AAFormWidth', Rect.Right - Rect.Left);

  ini.UpdateFile;
  ini.Free;
end;

procedure TJaneConfig.SaveChottoFormPos(Rect: TRect);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(IniPath);

  ini.WriteInteger(INI_OJV_SECT, 'ChottoViewerTop', Rect.Top);
  ini.WriteInteger(INI_OJV_SECT, 'ChottoViewerLeft', Rect.Left);
  ini.WriteInteger(INI_OJV_SECT, 'ChottoViewerHeight', Rect.Bottom - Rect.Top);
  ini.WriteInteger(INI_OJV_SECT, 'ChottoViewerWidth', Rect.Right - Rect.Left);

  ini.UpdateFile;
  ini.Free;
end;

procedure TJaneConfig.SaveLovelyFormPos(Rect: TRect);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(IniPath);

  ini.WriteInteger(INI_OJV_SECT, 'lovelyWebFormTop', Rect.Top);
  ini.WriteInteger(INI_OJV_SECT, 'lovelyWebFormLeft', Rect.Left);
  ini.WriteInteger(INI_OJV_SECT, 'lovelyWebFormHeight', Rect.Bottom - Rect.Top);
  ini.WriteInteger(INI_OJV_SECT, 'lovelyWebFormWidth', Rect.Right - Rect.Left);

  ini.UpdateFile;
  ini.Free;
end;

//タブの色の保存
procedure TJaneConfig.SaveTabColor;
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(IniPath);

  ini.WriteString(INI_TCL_SECT, 'ActiveBack',     IntToHex(tclActiveBack, 8));
  ini.WriteString(INI_TCL_SECT, 'NoActiveBack',   IntToHex(tclNoActiveBack, 8));
  ini.WriteString(INI_TCL_SECT, 'WriteWaitBack',  IntToHex(tclWriteWaitBack, 8));
  ini.WriteString(INI_TCL_SECT, 'AutoReloadBack', IntToHex(tclAutoReloadBack, 8));

  ini.WriteString(INI_TCL_SECT, 'DefaultText',          IntToHex(tclDefaultText, 8));
  ini.WriteString(INI_TCL_SECT, 'NewText',          IntToHex(tclNewText, 8));
  ini.WriteString(INI_TCL_SECT, 'New2Text',         IntToHex(tclNew2Text, 8));
  ini.WriteString(INI_TCL_SECT, 'ProcessText',      IntToHex(tclProcessText, 8));
  ini.WriteString(INI_TCL_SECT, 'DisableWriteText', IntToHex(tclDisableWriteText, 8));

  ini.UpdateFile;
  ini.Free;
end;
{/aiai}

{beginner}  //書き込みダイアログの位置を保存
procedure TJaneConfig.SaveWriteFormPos(Rect:TRect);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(IniPath);

  ini.WriteInteger(INI_WRT_SECT, 'WriteFormTop', Rect.Top);
  ini.WriteInteger(INI_WRT_SECT, 'WriteFormLeft', Rect.Left);
  ini.WriteInteger(INI_WRT_SECT, 'WriteFormHeight', Rect.Bottom-Rect.Top);
  ini.WriteInteger(INI_WRT_SECT, 'WriteFormWidth', Rect.Right-Rect.Left);

  ini.UpdateFile;
  ini.Free;
end;

(* 圧縮率の統計情報を更新する *)
procedure TJaneConfig.AddSample(compressed, uncompressed: cardinal);
var
  ratio: double;
begin
  if uncompressed = 0 then
    exit;
  if compressed = 0 then (* 圧縮されてなかった *)
    exit;
  ratio := compressed / uncompressed;
  compressRatio := (compressRatio * compressRatioSamples + ratio)/(compressRatioSamples + 1);
  Inc(compressRatioSamples);
  if cardinal(100000) <= compressRatioSamples then
    compressRatioSamples := 100000;
end;


procedure TJaneConfig.SetFontInfo(var info: TFontInfo; font: TFont);
begin
  info.face := font.Name;
  info.charset := font.Charset;
  info.height := font.Height;
  info.size := font.Size;
  info.style := StylesToBit(font.Style);
  info.color := font.Color; //▼色情報を追加
end;

procedure TJaneConfig.SetFont(var font: TFont; info: TFontInfo);
begin
  font.Name := info.face;
  font.Charset := info.charset;
  font.Height := info.height;
  if info.size <> 0 then
    font.Size := info.size;
  font.Style := BitToFontStyles(info.style);
  font.Color := info.color; //▼色情報を追加
end;

(* \付きフルパスに変換 *)
function TJaneConfig.GetFullPath(path: string): string;
begin
  if (length(path) >= 2) and
     ((path[2] = ':') or (Copy(path, 1, 2) = '\\')) and
     DirectoryExists(path) then
    result := path
  else
    result := BasePath + path;
  if (path[length(path)] <> '\') then
    result := result + '\';
  if (result = '\') or not DirectoryExists(result) then
    result := BasePath;
end;

//aiai
procedure TJaneConfig.SetAutoScrollSpeed(tag: integer);
begin
{  case tag of
  1: begin Config.oprAutoScrollInterval := 1500; Config.oprAutoScrollLine := 2; end;
  2: begin Config.oprAutoScrollInterval := 1000; Config.oprAutoScrollLine := 2; end;
  3: begin Config.oprAutoScrollInterval := 1000; Config.oprAutoScrollLine := 3; end;
  4: begin Config.oprAutoScrollInterval :=  500; Config.oprAutoScrollLine := 4; end;
  5: begin Config.oprAutoScrollInterval :=  100; Config.oprAutoScrollLine := 2; end;
  6: begin Config.oprAutoScrollInterval :=   50; Config.oprAutoScrollLine := 2; end;
  7: begin Config.oprAutoScrollInterval :=   50; Config.oprAutoScrollLine := 4; end;
  8: begin Config.oprAutoScrollInterval :=   30; Config.oprAutoScrollLine := 4; end;
  1: begin Config.oprAutoScrollLine := 2; end;
  2: begin Config.oprAutoScrollLine := 2; end;
  3: begin Config.oprAutoScrollLine := 2; end;
  4: begin Config.oprAutoScrollLine := 2; end;
  5: begin Config.oprAutoScrollLine := 2; end;
  6: begin Config.oprAutoScrollLine := 3; end;
  7: begin Config.oprAutoScrollLine := 3; end;
  8: begin Config.oprAutoScrollLine := 3; end;
  else exit;
  end;}
end;

end.
