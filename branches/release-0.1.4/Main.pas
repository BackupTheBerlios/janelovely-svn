unit Main;
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(*
 * Contributors:
 * Portions of this software are copyright (c) 2002 by ◆816/bwNE (816=817)
 *)
(* 1.382, Mon Oct 11 17:00:24 2004 UTC *)

(* Jane2ch メイン画面 *)
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, OleCtrls, ToolWin, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, StdCtrls, StrUtils, IniFiles,
  IdException, DateUtils, imm, Clipbrd, ImgList, ShellAPI, ActiveX, ActnList,
  Tabs, Buttons, Math, AppEvnts,
  IdHTTP, jconvert, HogeTextView, HogeListView, FileSub, StrSub,
  HTTPSub, JConfig, UConfig, UTVSub, UPopUpTextView, U2chBoard, UDat2HTML,
  UAsync, UViewItem, UWriteForm, USynchro, UHeadCache, UDaemon, U2chThread,
  U2chCat,  U2chCatList, UIDlg, UFavorite, USharedMem, UXTime, U2chTicket,
  UGrepDlg,

  {beginner}
  UNGWordsAssistant,UQuickAboneRegist, UImageViewer, UImageHint,
  UImageViewConfig,
  {/beginner}

  {aiai}
  UMigemo, VBScript_RegExp_55_TLB, JLSqlite,
  ApiBmp, PNGImage, GIFImage, ClipBrdSub,
  UAAForm, UAddAAForm, UAutoReSc, UAutoReloadSettingForm,
  UAutoScrollSettingForm, ULovelyWebForm, UNews, UGetBoardListForm,
  UChottoForm, UImageViewCacheListForm,
  UCheckSeverDown, UMDITextView, UWriteWait, UXPHintWindow,
  UWritePanelControl, JLToolButton, JLSideBar, JLXPComCtrls, TntStdCtrls,
  JLTrayIcon;
  {/aiai}

const
  VERSION  = '0.1.4.3';      (* Printable ASCIIコード厳守。')'はダメ *)
  JANE2CH  = 'JaneLovely 0.1.4.3';
  KEYWORD_OF_USER_AGENT = 'JaneLovely';      (*  *)

  DISTRIBUTORS_SITE = 'http://www.geocities.jp/openjane4714/';

  Copyrights: array[0..20] of string
    = ('Copyright (c) 2002 Project Open Jane - <a href="http://sakots.pekori.jp/OpenJane/">http://sakots.pekori.jp/OpenJane/</a> (<a href="https://sourceforge.jp/projects/jane/">SourceForge.jp</a>)',
       'Portions of this software are Copyright (c) 2001,2002 by Twiddle (Jane Classic) - <a href="http://hogehoge2001.tripod.co.jp/">http://hogehoge2001.tripod.co.jp/</a>',
       'Portions of this software are Copyright (c) 1993 - 2001, Chad Z. Hower (Kudzu) and the Indy Pit Crew - <a href="http://www.nevrona.com/Indy/">http://www.nevrona.com/Indy/</a>',
       'Portions of this software are Copyright (C) 1995-1998 Jean-loup Gailly and Mark Adler - <a href="http://www.gzip.org/zlib/">http://www.gzip.org/zlib/</a>',
       'Portions of this software are Copyright (C) 2001 by <a href="http://pc.2ch.net/test/read.cgi/tech/981726544/931-">931</a> (Monazilla Project) - <a href="http://www.monazilla.org/">http://www.monazilla.org/</a>',
       'Portions of this software are Copyright (C) 1998 EarthWave Soft(IKEDA Takahiro) - <a href="http://www.os.rim.or.jp/~ikeda/">http://www.os.rim.or.jp/~ikeda/</a>',
       'Portions of this software are Copyright (C) 1999-2001 by Andrey V. Sorokin &lt;anso@mail.ru&gt; - <a href="http://anso.virtualave.net/">http://anso.virtualave.net/</a>',
       'Portions of this software are Copyright (C) 2004 Gustavo Huffenbacher Daud - <a href="http://pngdelphi.sourceforge.net/">http://pngdelphi.sourceforge.net/</a>',
       'Portions of this software are Copyright (C) 1997-99 Anders Melander - <a href="http://www.melander.dk/delphi/gifimage/">http://www.melander.dk/delphi/gifimage/</a>',
       'Portions of this software are Copyright (C) 2002-2004, Troy Wolbrink (troy.wolbrink@ccci.org) - <a href="http://www.tntware.com/delphicontrols/unicode/">Tnt Delphi Unicode Controls</a>',
       'Portions of this software are Copyright (C) 2002 by <a href="http://pc.2ch.net/test/read.cgi/software/1008762486/816-817">◆816/bwNE</a>',
       'Portions of this software are Copyright (C) 2002 by <a href="http://www.geocities.co.jp/SiliconValley-Cupertino/2486/">◆test.lxc</a>',
       'Portions of this software are Copyright (C) 2002 by <a href="http://pc.2ch.net/test/read.cgi/software/1016729822/630-">630</a>',
       'Portions of this software are Copyright (C) 2002 by <a href="http://tokyo.cool.ne.jp/ymf754/">◆457.PK..</a>',
       'Portions of this software are Copyright (C) 2002 by <a href="http://members.tripod.co.jp/T521mOts/">◆aO521.mOts</a>',
       'Portions of this software are Copyright (C) 2003 by <a href="http://pc2.2ch.net/test/read.cgi/win/1044212032/366">View ◆tCDoSWbtb.</a>',
       'Portions of this software are Copyright (C) 2003 by <a href="http://pc2.2ch.net/test/read.cgi/win/1044212032/638">nono ◆MFAp1y4voQ</a>',
       'Portions of this software are Copyright (C) 2004 by <a href="http://pc5.2ch.net/test/read.cgi/win/1093163924/172">蜜柑 ◆Mikan70j12</a>',
       'Portions of this software are Copyright (C) 2004 by <a href="http://pc5.2ch.net/test/read.cgi/win/1093163924/176">◆....Ep7prs</a>',
       'Portions of this software are Copyright (C) 2004 by <a href="http://pc5.2ch.net/test/read.cgi/win/1093163924/621">おさ＠J典 ◆JtenNG/SWE </a>',
       'Portions of this software are Copyright (C) 2004 by <a href="http://pc5.2ch.net/test/read.cgi/win/1093163924/670">◆184NBKmVW6</a>');

type
  (*-------------------------------------------------------*)
  TPaneType = (ptView, ptList);
  (*-------------------------------------------------------*)
  TMainWnd = class(TForm)
    MainMenu: TMainMenu;
    Panel1: TPanel;
    ListView: THogeListView;
    ThreadSplitter: TSplitter;
    WebPanel: TPanel;
    MenuBoardGetList: TMenuItem;
    MenuToolsOptions: TMenuItem;
    LogPanel: TPanel;
    Memo: TMemo;
    Panel0: TPanel;
    TreeView: TTreeView;
    MenuBoard: TMenuItem;
    ListPopupMenu: TPopupMenu;
    ListPopupOpen: TMenuItem;
    N3: TMenuItem;
    ListPopupDel: TMenuItem;
    MenuList: TMenuItem;
    MenuListLogDel: TMenuItem;
    MenuListToggleMarker: TMenuItem;
    N2: TMenuItem;
    ListPopupSetFavorite: TMenuItem;
    HintTimer: TTimer;
    MenuThreadRefresh: TMenuItem;
    MenuWindow: TMenuItem;
    ZoomG: TMenuItem;
    ZoomL: TMenuItem;
    ZoomM: TMenuItem;
    ZoomS: TMenuItem;
    ZoomA: TMenuItem;
    ViewZoom: TMenuItem;
    ThreadPopupMenu: TPopupMenu;
    ViewPopupMark: TMenuItem;
    ViewPopupRes: TMenuItem;
    ViewPopupReload: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    MenuThre: TMenuItem;
    ListPopupNew: TMenuItem;
    ViewPopupClose: TMenuItem;
    ViewPopupCloseOthers: TMenuItem;
    N9: TMenuItem;
    ViewPopupCheckNew: TMenuItem;
    ActionList: TActionList;
    actWriteRes: TAction;
    MenuThreClose: TMenuItem;
    MenuThreCloseOtherTabs: TMenuItem;
    MenuThreToggleMarker: TMenuItem;
    N5: TMenuItem;
    MenuThreCheckNew: TMenuItem;
    MenuThreReload: TMenuItem;
    N11: TMenuItem;
    MenuReplay: TMenuItem;
    actCheckNewRes: TAction;
    actScrollToNew: TAction;
    actCloseThisTab: TAction;
    Panel2: TPanel;
    actCloseOtherTabs: TAction;
    actToggleMarker: TAction;
    Find1: TMenuItem;
    MenuFind: TMenuItem;
    FindNext: TMenuItem;
    FindPrev: TMenuItem;
    FindGrep: TMenuItem;
    FindNavigate: TMenuItem;
    N8: TMenuItem;
    TreePanel: TPanel;
    FavoriteView: TTreeView;
    ViewPopupFavorite: TMenuItem;
    PopupFavorites: TPopupMenu;
    PopupFavNew: TMenuItem;
    PopupFavDelete: TMenuItem;
    N13: TMenuItem;
    PopupFavEdit: TMenuItem;
    ListPopupRegFavorite: TMenuItem;
    PopupFavOpenNew: TMenuItem;
    N12: TMenuItem;
    N14: TMenuItem;
    ViewPopupURLCopy: TMenuItem;
    MenuToggleRPane: TMenuItem;
    ListViewPanel: TPanel;
    Panel9: TPanel;
    MenuCopyURL: TMenuItem;
    actCopyURL: TAction;
    ViewPopupOpenBoard: TMenuItem;
    MenuOpenBoard: TMenuItem;
    actOpenBoard: TAction;
    ViewPopupTUCopy: TMenuItem;
    actCopyTU: TAction;
    MenuCopyTU: TMenuItem;
    DblClkTimer: TTimer;
    N10: TMenuItem;
    N15: TMenuItem;
    ViewPopupDel: TMenuItem;
    PopupTree: TPopupMenu;
    PopupTreeAddFav: TMenuItem;
    MenuViewNextPane: TMenuItem;
    MenuViewPrevPane: TMenuItem;
    N16: TMenuItem;
    MenuThreAddFav: TMenuItem;
    N17: TMenuItem;
    MenuThreScrollToNew: TMenuItem;
    actAddFavorite: TAction;
    actScrollToPrev: TAction;
    MenuThreScrollToPrev: TMenuItem;
    actReload: TAction;
    N18: TMenuItem;
    actRemvoeLog: TAction;
    MenuThreLogDel: TMenuItem;
    MenuWindowSep: TMenuItem;
    MenuWndBoard: TMenuItem;
    MenuWndFav: TMenuItem;
    MenuWndThList: TMenuItem;
    MenuWndThread: TMenuItem;
    MenuListOpenNew: TMenuItem;
    MenuListOpenCurrent: TMenuItem;
    MenuListAddFav: TMenuItem;
    N21: TMenuItem;
    MenuListRefresh: TMenuItem;
    actListRefresh: TAction;
    actListOpenNew: TAction;
    actListOpenCurrent: TAction;
    actListToggleMarker: TAction;
    actListAddFav: TAction;
    actListDelLog: TAction;
    N22: TMenuItem;
    MenuWndNextTab: TMenuItem;
    MenuWndPrevTab: TMenuItem;
    N24: TMenuItem;
    PopupTreeSetHeader: TMenuItem;
    PopupViewMenu: TPopupMenu;
    PopupViewReply: TMenuItem;
    PopupViewReplyWithQuotation: TMenuItem;
    actGeneralUpdate: TAction;
    PopupTreeUMA: TMenuItem;
    N23: TMenuItem;
    PopupFavOpenCurrent: TMenuItem;
    actListCopyURL: TAction;
    actListCopyTU: TAction;
    N25: TMenuItem;
    ListPopupCopyURL: TMenuItem;
    ListPopupCopyTU: TMenuItem;
    N26: TMenuItem;
    MenuListCopyURL: TMenuItem;
    MenuListCopyTU: TMenuItem;
    N20: TMenuItem;
    PopupFavCopyURL: TMenuItem;
    PopupFavCopyTU: TMenuItem;
    N27: TMenuItem;
    PopupTreeCopyURL: TMenuItem;
    PopupTreeCopyTU: TMenuItem;
    DebugTmp: TMenuItem;
    PopupTextMenu: TPopupMenu;
    TextPopupCopy: TMenuItem;
    TextPopupCopyLink: TMenuItem;
    TextPopupSelectAll: TMenuItem;
    MenuThreCloseWOSave: TMenuItem;
    N28: TMenuItem;
    N4: TMenuItem;
    ViewPopupCloseWOSave: TMenuItem;
    TextPopupCmdSep: TMenuItem;
    MenuThreStop: TMenuItem;
    actStop: TAction;
    ViewPopupStop: TMenuItem;
    MenuWndRecently: TMenuItem;
    N30: TMenuItem;
    SystemKey: TMenuItem;
    ArrowUp: TMenuItem;
    ArrowDown: TMenuItem;
    ArrowRight: TMenuItem;
    ArrowLeft: TMenuItem;
    SysEnter: TMenuItem;
    N31: TMenuItem;
    MenuThreJumpRes: TMenuItem;
    MenuCommand: TMenuItem;
    MenuBoardFavorites: TMenuItem;
    SysPgUp: TMenuItem;
    SysPgDn: TMenuItem;
    SysHome: TMenuItem;
    SysEnd: TMenuItem;
    N32: TMenuItem;
    MenuListSort: TMenuItem;
    SortMarker: TMenuItem;
    SortNumber: TMenuItem;
    SortTitle: TMenuItem;
    SortItem: TMenuItem;
    SortLines: TMenuItem;
    SortNew: TMenuItem;
    SortGot: TMenuItem;
    SortWrote: TMenuItem;
    SortSince: TMenuItem;
    SortBoard: TMenuItem;
    actCloseRightTabs: TAction;
    actCloseLeftTabs: TAction;
    MenuThreCloseLeftTabs: TMenuItem;
    MenuThreCloseRightTabs: TMenuItem;
    ViewPopupCloseLeft: TMenuItem;
    ViewPopupCloseRight: TMenuItem;
    MenuThrePopupRes: TMenuItem;
    ListTabControl: TTabControl;
    ListTabPanel: TPanel;
    MenuListTabMenuSep: TMenuItem;
    MenuListClose: TMenuItem;
    N34: TMenuItem;
    MenuListCloseOtherTabs: TMenuItem;
    actListCloseThisTab: TAction;
    actListCloseOtherTabs: TAction;
    actListCloseLeftTabs: TAction;
    actListCloseRightTabs: TAction;
    MenuListCloseLeftTabs: TMenuItem;
    MenuListCloseRightTabs: TMenuItem;
    N36: TMenuItem;
    PopupTreeClose: TMenuItem;
    PopupTreeCloseOthers: TMenuItem;
    PopupTreeCloseLeft: TMenuItem;
    PopupTreeTabMenuSep: TMenuItem;
    PopupTreeCloseRight: TMenuItem;
    N35: TMenuItem;
    PopupTreeOpenByBrowser: TMenuItem;
    N38: TMenuItem;
    ViewPopupOpenByBrowser: TMenuItem;
    N39: TMenuItem;
    ListPopupOpenByBrowser: TMenuItem;
    actListOpenByBrowser: TAction;
    actOpenByBrowser: TAction;
    N40: TMenuItem;
    MenuThreOpenByBrowser: TMenuItem;
    N41: TMenuItem;
    MenuListOpenByBrowser: TMenuItem;
    MenuWndTabMenuSep: TMenuItem;
    N43: TMenuItem;
    MenuWndClose: TMenuItem;
    MenuWndCloseOtherTabs: TMenuItem;
    MenuWndCloseLeftTabs: TMenuItem;
    MenuWndCloseRightTabs: TMenuItem;
    N44: TMenuItem;
    PopupTreeOpenNew: TMenuItem;
    PopupTreeOpenCurrent: TMenuItem;
    MenuWndLastClosed: TMenuItem;
    ListImages: TImageList;
    CoolBar: TCoolBar;
    ToolBarMain: TJLXPToolBar;
    DivisionChangeButton: TToolbutton;
    ToolButton8: TToolbutton;
    ToggleTreeButton: TToolbutton;
    ToggleRPaneButton: TToolbutton;
    PaneModeChangeButton: TToolbutton;
    ToolButton10: TToolbutton;
    ToolOptionsButton: TToolbutton;
    ToolButton11: TToolbutton;
    ThreadRefreshButton: TToolbutton;
    LinkBar: TJLXPToolBar;
    TabPanel: TPanel;
    Panel3: TPanel;
    TabControl: TTabControl;
    ThreadToolPanel: TPanel;
    ThreadToolBar: TJLXPToolBar;
    JumpBottun: TToolbutton;
    ThreCheckNewResButton: TToolbutton;
    ToolButton4: TToolbutton;
    ToolButton5: TToolbutton;
    ThreadTitleLabel: TLabel;
    actTreeToggleVisible: TAction;
    UrlEdit: TEdit;
    ToolButton12: TToolbutton;
    ToolButton13: TToolbutton;
    ToolButton14: TToolbutton;
    MainToolImages: TImageList;
    ThreadToolImages: TImageList;
    ToolButton15: TToolbutton;
    actCloseTab: TAction;
    N45: TMenuItem;
    MenuBoardLogListLimit: TMenuItem;
    MenuFindThread: TMenuItem;
    MenuClearFindThreadResult: TMenuItem;
    N46: TMenuItem;
    PopupViewCopyReference: TMenuItem;
    JSN1: TMenuItem;
    PopupViewAbone: TMenuItem;
    PopupViewBlockAbone: TMenuItem;
    PopupViewBlockAbone2: TMenuItem;
    PopupFavOpenFolderByBoard: TMenuItem;
    PopupAddFavorite: TPopupMenu;
    MenuView: TMenuItem;
    MenuViewToolBarToggleVisible: TMenuItem;
    MenuViewLinkBarToggleVisible: TMenuItem;
    MenuViewAddressBarToggleVisible: TMenuItem;
    MenuViewTreeToggleVisible: TMenuItem;
    N47: TMenuItem;
    MenuViewDivisionChange: TMenuItem;
    MenuViewPaneModeChange: TMenuItem;
    Panel8: TPanel;
    TabBarPanel: TPanel;
    SysCtrlHome: TMenuItem;
    SysCtrlEnd: TMenuItem;
    MenuThreDelFav: TMenuItem;
    actDeleteFavorite: TAction;
    ViewPopupDelFav: TMenuItem;
    actListDelFav: TAction;
    ListPopupDelFav: TMenuItem;
    MenuListDelFav: TMenuItem;
    MenuViewMenuToggleVisible: TMenuItem;
    MenuThreCloseAllTabs: TMenuItem;
    actCloseAllTabs: TAction;
    ViewPopupCloseAll: TMenuItem;
    actListCloseAllTabs: TAction;
    PopupTreeCloseAll: TMenuItem;
    MenuListCloseAllTabs: TMenuItem;
    MenuWndCloseAllTabs: TMenuItem;
    actDivisionChange: TAction;
    actPaneModeChange: TAction;
    PopupTreeDelFav: TMenuItem;
    FindGrepButton: TToolbutton;
    ThreBuildButton: TToolbutton;
    FindThreadButton: TToolbutton;
    ToolButton9: TToolbutton;
    ThreStopButton: TToolbutton;
    ToolButton17: TToolbutton;
    ResFindButton: TToolbutton;
    ToolButton19: TToolbutton;
    MenuListThreBuild: TMenuItem;
    N33: TMenuItem;
    N37: TMenuItem;
    actBuildThread: TAction;
    MenuOptOnline: TMenuItem;
    MenuOptLogin: TMenuItem;
    MenuHelp: TMenuItem;
    HelpButton: TToolbutton;
    OnlineButton: TToolbutton;
    MenuListOpenHide: TMenuItem;
    ListPopupHide: TMenuItem;
    actListOpenHide: TAction;
    PopupTreeCategory: TPopupMenu;
    PopupCatAddFav: TMenuItem;
    MenuItem13: TMenuItem;
    PopupCatAddBoard: TMenuItem;
    PopupCatAddCategory: TMenuItem;
    MenuItem1: TMenuItem;
    PopupCatDelCategory: TMenuItem;
    actOnLine: TAction;
    actLogin: TAction;
    N42: TMenuItem;
    PopupTreeDelBoard: TMenuItem;
    N48: TMenuItem;
    PopupFavOpenByBrowser: TMenuItem;
    PopupViewTransParencyAbone: TMenuItem;
    PopupViewBlockAbone3: TMenuItem;
    N49: TMenuItem;
    TextPopupDownload: TMenuItem;
    N50: TMenuItem;
    PopupViewSetReadPos: TMenuItem;
    PopupViewSetCheckRes: TMenuItem;
    N52: TMenuItem;
    actCheckResPopup: TAction;
    actCheckResSubMenu: TAction;
    actJumpToReadPos: TAction;
    actCheckResAllClear: TAction;
    actReadPosClear: TAction;
    actSetReadPos: TAction;
    MenuThreReadPos: TMenuItem;
    MenuThreCheckRes: TMenuItem;
    N51: TMenuItem;
    MenuThreSetReadPos: TMenuItem;
    MenuThreJumpToReadPos: TMenuItem;
    MenuThreReadPosClear: TMenuItem;
    MenuThreCheckResAllClear: TMenuItem;
    ResJumpTimer: TTimer;
    DrawLinesButton: TToolbutton;
    PopupDrawLines: TPopupMenu;
    DrawAll: TMenuItem;
    Draw50: TMenuItem;
    Draw100: TMenuItem;
    Draw250: TMenuItem;
    Draw500: TMenuItem;
    MenuThreChangeDrawLines: TMenuItem;
    MenuDrawAll: TMenuItem;
    MenuDraw50: TMenuItem;
    MenuDraw100: TMenuItem;
    MenuDraw250: TMenuItem;
    MenuDraw500: TMenuItem;
    actKeywordExtraction: TAction;
    MenuExtractKeyword: TMenuItem;
    MenuWndHideInTaskTray: TMenuItem;
    N55: TMenuItem;
    MenuOptDumpShortcut: TMenuItem;
    MenuHelpAbout: TMenuItem;
    MenuHelps: TMenuItem;
    N57: TMenuItem;
    ViewPopupReadPos: TMenuItem;
    ViewPopupCheckRes: TMenuItem;
    N58: TMenuItem;
    ViewPopupSetReadPos: TMenuItem;
    ViewPopupJumpToReadPos: TMenuItem;
    ViewPopupReadPosClear: TMenuItem;
    ViewPopupCheckResAllClear: TMenuItem;
    N53: TMenuItem;
    PopupTreeBuildThread: TMenuItem;
    actBack: TAction;
    actForword: TAction;
    MenuThreBack: TMenuItem;
    MenuThreForword: TMenuItem;
    N54: TMenuItem;
    FavTreeScrlTimer: TTimer;
    FavTreeExpndTimer: TTimer;
    N59: TMenuItem;
    N60: TMenuItem;
    MenuFindThreadNew: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    PopupViewJump: TMenuItem;
    N61: TMenuItem;
    MenuListHomeMovedBoard: TMenuItem;
    N62: TMenuItem;
    TextPopupExtractPopup: TMenuItem;
    MenuBoardCheckLogFolder: TMenuItem;
    {beginner}
    TextPopupOpenSelectionURL: TMenuItem;
    TextPopUpOpenSelectionURLs: TMenuItem;
    MenuImageView: TMenuItem;
    MenuOpenImageView: TMenuItem;
    MenuImageViewPreference: TMenuItem;
    PopupViewAddNgName: TMenuItem;
    PopupViewAddNgAddr: TMenuItem;
    PopupViewAddNgId: TMenuItem;
    TextPopupAddNGWord: TMenuItem;
    PopupViewAddNgWord: TMenuItem;
    PopupViewOpenImage: TMenuItem;
    MenuChangeAboneLevel: TMenuItem;
    VN55: TMenuItem;
    actTransparencyAbone: TAction;
    actNormalAbone: TAction;
    actHalfAbone: TAction;
    actIgnoreAbone: TAction;
    actImportantResOnly: TAction;
    VN2: TMenuItem;
    MenuTransparencyAbone: TMenuItem;
    MenuNormalAbone: TMenuItem;
    MenuHalfAbone: TMenuItem;
    MenuIgnoreAbone: TMenuItem;
    MenuImportantResOnly: TMenuItem;
    MenuItemTransparencyAbone: TMenuItem;
    MenuItemNormalAbone: TMenuItem;
    MenuItemHalfAbone: TMenuItem;
    MenuItemIgnoreAbone: TMenuItem;
    MenuItemImportantResOnly: TMenuItem;
    VN3: TMenuItem;
    PopupTrush: TPopupMenu;
    PopupTrushDeleteFile: TMenuItem;
    TextPopupOpenByBrowser: TMenuItem;
    TextPopupOpenByViewer: TMenuItem;
    VN1: TMenuItem;
    PopupViewShowResTree: TMenuItem;
    MenuShowResTree: TMenuItem;
    MenuShowOutLine: TMenuItem;
    NV001: TMenuItem;
    PopupViewShowOutLine: TMenuItem;
    actShowResTree: TAction;
    actShowOutLine: TAction;
    MenuOpenURLOnMouseOver: TMenuItem;
    TextPopupTrensferToWriteForm: TMenuItem;
    MenuWatchClipboard: TMenuItem;
    TextPopupRegisterBroCra: TMenuItem;
    TextPopupDeleteCache: TMenuItem;
    actAboneOnly: TAction;
    MenuItemAboneOnly: TMenuItem;
    MenuAboneOnly: TMenuItem;
    TextPopupExtractRes: TMenuItem;
    actSelectedKeywordExtraction: TAction;
    FindThreadSep: TMenuItem;
    MemoImageList: TImageList;
    ViewPopupCheckNewAll: TMenuItem;
    MenuAA: TMenuItem;
    MenuAAEdit: TMenuItem;
    MenuClearHistory: TMenuItem;
    MenuClearSearchHistory: TMenuItem;
    MenuClearName: TMenuItem;
    MenuClearMail: TMenuItem;
    ViewPopupSaveDat: TMenuItem;
    ViewPopupTITLECopy: TMenuItem;
    AutoReScButton: TToolbutton;
    N63: TMenuItem;
    ViewPopupOpenAutoReloadSettingForm: TMenuItem;
    ViewPopupAutoScrollSpeed: TMenuItem;
    Scroll1: TMenuItem;
    Scroll2: TMenuItem;
    Scroll3: TMenuItem;
    Scroll4: TMenuItem;
    Scroll5: TMenuItem;
    Scroll6: TMenuItem;
    Scroll7: TMenuItem;
    Scroll8: TMenuItem;
    ListPopupChottoView: TMenuItem;
    TextPopupChottoView: TMenuItem;
    MenuFavPatrol: TMenuItem;
    ViewPopupSetAlready: TMenuItem;
    PopupViewReplyOnWriteMemo: TMenuItem;
    ViewPopupNotClose: TMenuItem;
    N65: TMenuItem;
    MenuViewWriteMemoToggleVisible: TMenuItem;
    TextPopupAddNGID: TMenuItem;
    TextPopupExtractID: TMenuItem;
    TextPopupCopyID: TMenuItem;
    PopupTreeOpenNewResThreads: TMenuItem;
    PopupTreeOpenNewResFavorites: TMenuItem;
    N64: TMenuItem;
    PopupOpenFavorites: TMenuItem;
    TextPopupOpenByLovelyBrowser: TMenuItem;
    LovelyBrowser1: TMenuItem;
    MenuThreCheckNewAll: TMenuItem;
    TabPtrlButton: TToolbutton;
    MenuThrePtrl: TMenuItem;
    actAutoReSc: TAction;
    N67: TMenuItem;
    actCheckNewResAll: TAction;
    actTabPtrl: TAction;
    actListAlready: TAction;
    ListPopupAlready: TMenuItem;
    MenuFindeThreadTitle: TMenuItem;
    MenuOptNews: TMenuItem;
    MenuOptUseNews: TMenuItem;
    MenuOptSetNewsInterval: TMenuItem;
    actListCopyTITLE: TAction;
    E1: TMenuItem;
    E2: TMenuItem;
    PopupTreeCopyTITLE: TMenuItem;
    PopupFavCopyTITLE: TMenuItem;
    actCopyTITLE: TAction;
    MenuCopyTITLE: TMenuItem;
    N68: TMenuItem;
    ViewPopupCopyDAT: TMenuItem;
    ViewPopupCopyDI: TMenuItem;
    N69: TMenuItem;
    actListCopyDat: TAction;
    actListCopyDI: TAction;
    N70: TMenuItem;
    datD1: TMenuItem;
    datidx1: TMenuItem;
    N71: TMenuItem;
    MenuListCopys: TMenuItem;
    datD2: TMenuItem;
    datidxI1: TMenuItem;
    N73: TMenuItem;
    actSaveDat: TAction;
    actCopyDat: TAction;
    actCopyDI: TAction;
    datS1: TMenuItem;
    datD3: TMenuItem;
    datidxI2: TMenuItem;
    ViewPopupToggleAutoScroll: TMenuItem;
    ViewPopupAutoScrollAtAnyTime: TMenuItem;
    N74: TMenuItem;
    ViewPopupAutoScrollSetting: TMenuItem;
    ViewPopupToggleAutoReload: TMenuItem;
    ViewPopupToggleAutoReSc: TMenuItem;
    MenuThreToggleAutoReload: TMenuItem;
    MenuThreToggleAutoScroll: TMenuItem;
    MenuThreAutoReSc: TMenuItem;
    N76: TMenuItem;
    MenuListCloseBoards: TMenuItem;
    N78: TMenuItem;
    N80: TMenuItem;
    MenuBoardList: TMenuItem;
    N75: TMenuItem;
    TextPopupAddAAList: TMenuItem;
    N79: TMenuItem;
    PopupViewAddAAlist: TMenuItem;
    c1: TMenuItem;
    PopupViewCopyData: TMenuItem;
    PopupViewCopyRD: TMenuItem;
    PopupViewReplyWithQuotationOnWriteMemo: TMenuItem;
    ToolBarUrlEdit: TJLXPToolBar;
    PopupTreeRefreshIdxList: TMenuItem;
    actRefreshIdxList: TAction;
    MenuListRefreshIdxList: TMenuItem;
    actThreadAbone: TAction;
    A1: TMenuItem;
    N81: TMenuItem;
    MenuListOpenAll: TMenuItem;
    MenuListOpenNewResThreads: TMenuItem;
    MenuListOpenNewResFavorites: TMenuItem;
    MenuListOpenFavorites: TMenuItem;
    N72: TMenuItem;
    TextPopupIDAbone: TMenuItem;
    TextPopupIDAbone2: TMenuItem;
    MenuImageViewOpenCacheList: TMenuItem;
    SortSpeed: TMenuItem;
    SortGain: TMenuItem;
    PopupBar: TPopupMenu;
    MenuPopupBarToolBar: TMenuItem;
    MenuPopupBarLinkBar: TMenuItem;
    MenuPopupBarAdressBar: TMenuItem;
    MenuPopupBarMenu: TMenuItem;
    N82: TMenuItem;
    ToolButton1: TToolbutton;
    MenuListRefreshAll: TMenuItem;
    PopupTaskTray: TPopupMenu;
    PopupTaskTrayClose: TMenuItem;
    PopupTaskTrayRestore: TMenuItem;
    ToolBarTreeTitle: TJLXPToolBar;
    ToolButtonTreeTitle: TJLToolButton;
    LabelTreeTitle: TLabel;
    ToolButtonTreeTitleCanMove: TJLToolButton;
    ToolButtonTreeTitleClose: TJLToolButton;
    PanelTreeTitle: TPanel;
    LogSplitter: TSplitter;
    Panel4: TPanel;
    ool1: TMenuItem;
    N1: TMenuItem;
    N66: TMenuItem;
    N83: TMenuItem;
    N29: TMenuItem;
    SideBar: TJLSideBar;
    PopupStatusBar: TPopupMenu;
    MenuStatusOpenByBrowser: TMenuItem;
    N56: TMenuItem;
    MenuStatusOpenByLovelyBrowser: TMenuItem;
    BoardSplitter: TSplitter;
    MenuBoardCanMove: TMenuItem;
    WritePanel: TPanel;
    WritePanelTitle: TPanel;
    LabelWriteTitle: TLabel;
    ToolBarWriteTitle: TJLXPToolBar;
    ToolButtonWriteTitle: TJLToolButton;
    ToolButtonWriteTitleAutoHide: TJLToolButton;
    ToolButtonWriteTitleClose: TJLToolButton;
    WritePanelSplitter: TSplitter;
    PopupWritePanel: TPopupMenu;
    MenuWritePanelPos: TMenuItem;
    MenuWritePanelCanMove: TMenuItem;
    MenuWritePanelDisableStatusBar: TMenuItem;
    MenuMemo: TMenuItem;
    MenuMemoCanMove: TMenuItem;
    MenuMemoPos: TMenuItem;
    MenuMemoDisableStatusBar: TMenuItem;
    MenuStatusCopyURI: TMenuItem;
    MenuWritePanelDisableTopBar: TMenuItem;
    MenuWriteMemoDisableTopBar: TMenuItem;
    MenuOptSetNewsSize: TMenuItem;
    StatusBar: TJLXPStatusBar;
    MDIClientPanel: TPanel;
    ThreMaxButton: TToolButton;
    actMaxView: TAction;
    MenuWindowTileVertically: TMenuItem;
    MenuWindowTileHorizontally: TMenuItem;
    MenuWindowCascade: TMenuItem;
    N19: TMenuItem;
    MenuWindowMaximizeAll: TMenuItem;
    PopupThreSys: TPopupMenu;
    MenuThreSysMove: TMenuItem;
    MenuThreSysResize: TMenuItem;
    MenuThreSysCascade: TMenuItem;
    MenuThreSysTileVertically: TMenuItem;
    MenuThreSysTileHorizontally: TMenuItem;
    MenuThreSysMaximizeAll: TMenuItem;
    MenuWindowRestoreAll: TMenuItem;
    MenuThreSysRestoreAll: TMenuItem;
    N84: TMenuItem;
    N85: TMenuItem;
    Image1: TImage;
    N86: TMenuItem;
    MenuMemoRestore: TMenuItem;
    N87: TMenuItem;
    MenuBoardRestore: TMenuItem;
    SearchTimer: TTimer;
    ListViewSearchToolBar: TJLXPToolBar;
    ListViewSearchCloseButton: TToolButton;
    ListViewSearchToolButton: TToolButton;
    SearchImages: TImageList;
    PopupSearch: TPopupMenu;
    MenuSearchNormal: TMenuItem;
    MenuSearchMigemo: TMenuItem;
    ListViewSearchEditBox: TComboBox;
    MenuSearchRegExp: TMenuItem;
    N88: TMenuItem;
    MenuSearchMultiWord: TMenuItem;
    MenuSearchIncremental: TMenuItem;
    N90: TMenuItem;
    MenuSearchClose: TMenuItem;
    MenuSearchIgnoreFullHalf: TMenuItem;
    ThreViewSearchToolBar: TJLXPToolBar;
    ThreViewSearchToolButton: TToolButton;
    ThreViewSearchEditBox: TComboBox;
    ThreViewSearchCloseButton: TToolButton;
    ListViewSearchSep: TToolButton;
    ThreViewSearchSep1: TToolButton;
    ThreViewSearchSep2: TToolButton;
    ThreViewSearchResFindButton: TToolButton;
    ThreViewSearchSep3: TToolButton;
    TreeViewSearchToolBar: TJLXPToolBar;
    TreeViewSearchToolButton: TToolButton;
    TreeViewSearchEditBox: TComboBox;
    PopupUrlEdit: TPopupMenu;
    MenuUrlEditUndo: TMenuItem;
    N89: TMenuItem;
    MenuUrlEditCut: TMenuItem;
    MenuUrlEditCopy: TMenuItem;
    MenuUrlEditPaste: TMenuItem;
    MenuUrlEditDelete: TMenuItem;
    N91: TMenuItem;
    MenuUrlEditSelectAll: TMenuItem;
    MenuUrlEditPasteAndGo: TMenuItem;
    MenuSearchCut: TMenuItem;
    MenuSearchCopy: TMenuItem;
    MenuSearchPaste: TMenuItem;
    N92: TMenuItem;
    MenuSearchClear: TMenuItem;
    MenuSearchSelectAll: TMenuItem;
    N95: TMenuItem;
    ViewPopupCmdSep: TMenuItem;
    MenuStatusCmdSep: TMenuItem;
    MenuListHideHistoricalLog: TMenuItem;
    PopupTreeHideHistoricalLog: TMenuItem;
    actHideHistoricalLog: TAction;
    N96: TMenuItem;
    actThreadAbone2: TAction;
    MenuListThreadAboneSetting: TMenuItem;
    MenuListAboneTranseparency: TMenuItem;
    MenuListAboneIgnore: TMenuItem;
    MenuListAboneOnly: TMenuItem;
    actThreadAboneTranseparency: TAction;
    actThreadAboneIgnore: TAction;
    actThreadAboneOnly: TAction;
    PopupTreeSetCustomSkin: TMenuItem;
    PopupTreeCustomSkinDefault: TMenuItem;
    PopupViewCopyURL: TMenuItem;
    TextPopupTrensferToWriteMemo: TMenuItem;
    N77: TMenuItem;
    MenuListAboneNormal: TMenuItem;
    actThreadAboneNormal: TAction;
    actThreadAboneImportantResOnly: TAction;
    N99: TMenuItem;
    actThreadAbone3: TAction;
    N100: TMenuItem;
    actThreadAbone4: TAction;
    N101: TMenuItem;
    N102: TMenuItem;
    N103: TMenuItem;
    N104: TMenuItem;
    N105: TMenuItem;
    PageControlWrite: TPageControl;
    TabSheetWriteMain: TTabSheet;
    TabSheetWritePreview: TTabSheet;
    TabSheetWriteSettingTxt: TTabSheet;
    TabSheetWriteResult: TTabSheet;
    StatusBarWrite: TJLXPStatusBar;
    MemoWriteResult: TMemo;
    MemoWriteSettingTxt: TMemo;
    PanelWriteNameMail: TPanel;
    LabelWriteName: TLabel;
    ComboBoxWriteName: TComboBox;
    LabelWriteMail: TLabel;
    ComboBoxWriteMail: TComboBox;
    CheckBoxWriteSage: TCheckBox;
    MemoWriteMain: TTntMemo;
    PanelWriteTool: TPanel;
    ToolBarWriteTool: TJLXPToolBar;
    ToolButtonWriteAA: TToolButton;
    ToolButtonWriteSave: TToolButton;
    ToolButtonWriteLoad: TToolButton;
    ToolButtonWriteClear: TToolButton;
    ToolButtonWriteRecordNameMail: TToolButton;
    ToolButtonWriteTrim: TToolButton;
    ToolButton20: TToolButton;
    ToolButtonWriteUseWriteWait: TToolButton;
    ToolButtonWriteNameMailWarning: TToolButton;
    ToolButtonWriteBelogin: TToolButton;
    ButtonWriteWrite: TButton;
    Button2: TButton;
    TreeTabControl: TTabControl;
    N98: TMenuItem;
    MenuStatusReset: TMenuItem;
    ThreViewSearchUpDown: TUpDown;
    MenuSearchNext: TMenuItem;
    MenuSearchPrev: TMenuItem;
    N111: TMenuItem;
    MenuSearchExtract: TMenuItem;
    MenuSearchExtractTree: TMenuItem;
    N109: TMenuItem;
    TrayIcon: TJLTrayIcon;
    MenuBoardSep: TMenuItem;
    {/aiai}
    procedure FormCreate(Sender: TObject);
    procedure MenuToolsOptionsClick(Sender: TObject);
    procedure GetBoard2ch(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure HintTimerTimer(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure MenuThreadRefreshClick(Sender: TObject);
    procedure ZoomClick(Sender: TObject);
    procedure ThreadChkNewResButtonClick(Sender: TObject);
    procedure ThreadWriteButtonClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure TabControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TabControlMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actCloseThisTabExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actCloseOtherTabsExecute(Sender: TObject);
    procedure MenuThreCloseClick(Sender: TObject);
    procedure MenuThreCloseOtherTabsClick(Sender: TObject);
    procedure actToggleMarkerExecute(Sender: TObject);
    procedure ThreadPopupMenuPopup(Sender: TObject);
    procedure ViewPopupCheckNewClick(Sender: TObject);
    procedure ViewPopupReloadClick(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ViewPopupResClick(Sender: TObject);
    procedure FindGrepClick(Sender: TObject);
    procedure MenuFindClick(Sender: TObject);
    procedure FindNextClick(Sender: TObject);
    procedure FindPrevClick(Sender: TObject);
    procedure FindNavigateClick(Sender: TObject);
    //procedure TreeTabSetChange(Sender: TObject; NewTab: Integer;
    //  var AllowChange: Boolean);
    procedure PopupFavNewClick(Sender: TObject);
    procedure PopupFavDeleteClick(Sender: TObject);
    procedure FavoriteViewEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure FavoriteViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FavoriteViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FavoriteViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure FavoriteViewCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure FavoriteViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PopupFavoritesPopup(Sender: TObject);
    procedure PopupFavEditClick(Sender: TObject);
    procedure ViewPopupFavoriteClick(Sender: TObject);
    procedure FavoriteViewClick(Sender: TObject);
    procedure PopupFavOpenNewClick(Sender: TObject);
    procedure ViewPopupURLCopyClick(Sender: TObject);
    procedure MenuToggleRPaneClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actCopyURLExecute(Sender: TObject);
    procedure ViewPopupOpenBoardClick(Sender: TObject);
    procedure actOpenBoardExecute(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure ViewPopupTUCopyClick(Sender: TObject);
    procedure actCopyTUExecute(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure TreeViewDblClick(Sender: TObject);
    procedure DblClkTimerTimer(Sender: TObject);
    procedure FavoriteViewDblClick(Sender: TObject);
    procedure ListViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MemoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FavoriteViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TreeViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ThreadToolBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ViewPopupDelClick(Sender: TObject);
    procedure PopupTreePopup(Sender: TObject);
    procedure PopupTreeAddFavClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuViewNextPaneClick(Sender: TObject);
    procedure MenuViewPrevPaneClick(Sender: TObject);
    procedure actAddFavoriteExecute(Sender: TObject);
    procedure ThreadToggleMarker(Sender: TObject);
    procedure MenuThreClick(Sender: TObject);
    procedure actScrollToPrevExecute(Sender: TObject);
    procedure actReloadExecute(Sender: TObject);
    procedure actRemvoeLogExecute(Sender: TObject);
    procedure MenuWindowClick(Sender: TObject);
    procedure WindowShortcutClick(Sender: TObject);
    procedure MenuWndBoardClick(Sender: TObject);
    procedure MenuWndThListClick(Sender: TObject);
    procedure MenuWndThreadClick(Sender: TObject);
    procedure actListRefreshExecute(Sender: TObject);
    procedure actListOpenNewExecute(Sender: TObject);
    procedure actListOpenCurrentExecute(Sender: TObject);
    procedure actListToggleMarkerExecute(Sender: TObject);
    procedure actListAddFavExecute(Sender: TObject);
    procedure actListDelLogExecute(Sender: TObject);
    procedure MenuWndNextTabClick(Sender: TObject);
    procedure MenuWndPrevTabClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure PopupTreeSetHeaderClick(Sender: TObject);
    procedure OnBoardShortcutMenuClick(Sender: TObject);
    procedure OnFavoriteShortcutMenuClick(Sender: TObject);
    procedure PopupViewReplyClick(Sender: TObject);
    procedure PopupViewReplyWithQuotationClick(Sender: TObject);
    procedure actGeneralUpdateExecute(Sender: TObject);
    procedure PopupTreeUMAClick(Sender: TObject);
    procedure PopupFavOpenCurrentClick(Sender: TObject);
    procedure actListCopyURLExecute(Sender: TObject);
    procedure actListCopyTUExecute(Sender: TObject);
    procedure PopupFavOpenByBrowserClick(Sender: TObject);
    procedure PopupFavCopyURLClick(Sender: TObject);
    procedure PopupFavCopyTUClick(Sender: TObject);
    procedure PopupTreeCopyURLClick(Sender: TObject);
    procedure PopupTreeCopyTUClick(Sender: TObject);
    procedure ListViewData(Sender: TObject; Item: TListItem);
    procedure ListPopupMenuPopup(Sender: TObject);
    procedure DebugTmpClick(Sender: TObject);
    procedure MenuListClick(Sender: TObject);
    procedure PopupTextMenuPopup(Sender: TObject);
    procedure TextPopupCopyClick(Sender: TObject);
    procedure TextPopupCopyLinkClick(Sender: TObject);
    procedure TextPopupSelectAllClick(Sender: TObject);
    {beginner}
    procedure TextPopupOpenSelectionURLClick(Sender: TObject);
    procedure TextPopupOpenSelectionURLsClick(Sender: TObject);
    {/beginner}
    procedure actCloseThisTabWOSaveExecute(Sender: TObject);
    procedure MenuThreCloseWOSaveClick(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure MenuThreStopClick(Sender: TObject);
    //▼test
    procedure FormActivate(Sender: TObject);
    procedure WebPanelResize(Sender: TObject);
    function IsShortCut(var Message: TWMKey): Boolean; override;
    procedure actCloseRightTabsExecute(Sender: TObject);
    procedure actCloseLeftTabsExecute(Sender: TObject);
    procedure MenuThreCloseLeftTabsClick(Sender: TObject);
    procedure MenuThreCloseRightTabsClick(Sender: TObject);
    procedure SortMenuClick(Sender: TObject);
    procedure MenuThrePopupResClick(Sender: TObject);
    procedure MenuThreJumpResClick(Sender: TObject);
    procedure ListTabControlChange(Sender: TObject);
    procedure ListTabControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewPanelResize(Sender: TObject);
    procedure actListCloseThisTabExecute(Sender: TObject);
    procedure actListCloseOtherTabsExecute(Sender: TObject);
    procedure actListCloseLeftTabsExecute(Sender: TObject);
    procedure actListCloseRightTabsExecute(Sender: TObject);
    procedure MenuListCloseLeftTabsClick(Sender: TObject);
    procedure MenuListCloseRightTabsClick(Sender: TObject);
    procedure MenuListCloseOtherTabsClick(Sender: TObject);
    procedure MenuListCloseClick(Sender: TObject);
    procedure PopupTreeOpenByBrowserClick(Sender: TObject);
    procedure ViewPopupOpenByBrowserClick(Sender: TObject);
    procedure actListOpenByBrowserExecute(Sender: TObject);
    procedure actOpenByBrowserExecute(Sender: TObject);
    procedure MenuWndCloseClick(Sender: TObject);
    procedure MenuWndCloseOtherTabsClick(Sender: TObject);
    procedure MenuWndCloseLeftTabsClick(Sender: TObject);
    procedure MenuWndCloseRightTabsClick(Sender: TObject);
    procedure ListTabPanelDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListTabPanelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TabPanelDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TabPanelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListTabControlDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ListTabControlDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure TabControlDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TabControlDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListTabControlMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure TabPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListTabPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupTreeOpenCurrentClick(Sender: TObject);
    procedure PopupTreeOpenNewClick(Sender: TObject);
    procedure MenuWndLastClosedClick(Sender: TObject);
    procedure MenuBoardLogListLimitClick(Sender: TObject);
    procedure PopupViewCopyReferenceClick(Sender: TObject);

    //※[JS]
    procedure ListTabControlGetImageIndex(Sender: TObject;
      TabIndex: Integer; var ImageIndex: Integer);
    procedure TabControlGetImageIndex(Sender: TObject; TabIndex: Integer;
      var ImageIndex: Integer);
    procedure LinkBarResize(Sender: TObject);
    procedure actCloseTabExecute(Sender: TObject);

    //※[457]
    procedure MenuFindThreadClick(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListTabControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure MenuClearFindThreadResultClick(Sender: TObject);
    procedure ThreadTitleLabelClick(Sender: TObject);
    procedure PopupViewAboneClick(Sender: TObject);
    procedure PopupViewBlockAboneClick(Sender: TObject);
    procedure PopupFavOpenFolderByBoardClick(Sender: TObject);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure MenuCommandExeClick(Sender: TObject);
    procedure KeyEmulateClick(Sender: TObject);
    procedure KeyEmulateCtrlClick(Sender: TObject);
    procedure UrlEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopupAddFavoritePopup(Sender: TObject);
    procedure MenuViewToolBarToggleVisibleClick(Sender: TObject);
    procedure MenuViewLinkBarToggleVisibleClick(Sender: TObject);
    procedure MenuViewAddressBarToggleVisibleClick(Sender: TObject);
    procedure MenuViewTreeToggleVisibleClick(Sender: TObject);
    procedure MenuViewDivisionChangeClick(Sender: TObject);
    procedure MenuViewPaneModeChangeClick(Sender: TObject);
    procedure TreeTabControlChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actDeleteFavoriteExecute(Sender: TObject);
    procedure ViewPopupDelFavClick(Sender: TObject);
    procedure actListDelFavExecute(Sender: TObject);
    procedure MenuViewMenuToggleVisibleClick(Sender: TObject);
    procedure actCloseAllTabsExecute(Sender: TObject);
    procedure actListCloseAllTabsExecute(Sender: TObject);
    procedure MenuWndCloseAllTabsClick(Sender: TObject);
    procedure UrlEditExit(Sender: TObject);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FavMenuCreate(Sender: TObject);
    procedure PopupTreeDelFavClick(Sender: TObject);
    procedure ListViewPanelEnter(Sender: TObject);
    procedure WebPanelEnter(Sender: TObject);
    procedure ThreadTitleLabelMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure actBuildThreadExecute(Sender: TObject);
    procedure MenuHelpClick(Sender: TObject);
    procedure actListOpenHideExecute(Sender: TObject);
    procedure PopupCatAddFavClick(Sender: TObject);
    procedure PopupCatAddBoardClick(Sender: TObject);
    procedure PopupCatAddCategoryClick(Sender: TObject);
    procedure PopupCatDelCategoryClick(Sender: TObject);
    procedure PopupTreeCategoryPopup(Sender: TObject);
    procedure TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure actOnLineExecute(Sender: TObject);
    procedure actLoginExecute(Sender: TObject);
    procedure PopupTreeDelBoardClick(Sender: TObject);
    procedure TextPopupDownloadClick(Sender: TObject);
    procedure actScrollToNewExecute(Sender: TObject);
    procedure actCheckResPopupExecute(Sender: TObject);
    procedure actCheckResSubMenuExecute(Sender: TObject);
    procedure PopupViewSetReadPosClick(Sender: TObject);
    procedure actJumpToReadPosExecute(Sender: TObject);
    procedure actCheckResAllClearExecute(Sender: TObject);
    procedure ResJumpTimerTimer(Sender: TObject);
    procedure MenuDrawAllClick(Sender: TObject);
    procedure actKeywordExtractionExecute(Sender: TObject);
    {beginner}
    procedure actSelectedKeywordExtractionExecute(Sender: TObject);
    procedure KeywordExtraction(Sender: TObject; UseSelection: Boolean);
    {/beginner}
    procedure OnAboutToFormShow(var Message: TMessage); message WM_SHOWWINDOW;
    procedure MenuWndHideInTaskTrayClick(Sender: TObject);
    procedure MenuOptDumpShortcutClick(Sender: TObject);
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuThreCheckResClick(Sender: TObject);
    procedure actSetReadPosExecute(Sender: TObject);
    procedure actReadPosClearExecute(Sender: TObject);
    procedure MenuThreReadPosClearClick(Sender: TObject);
    procedure MenuThreJumpToReadPosClick(Sender: TObject);
    procedure ViewPopupReadPosClick(Sender: TObject);
    procedure ViewPopupCheckResClick(Sender: TObject);
    procedure MenuThreCheckResAllClearClick(Sender: TObject);
    procedure PopupTreeBuildThreadClick(Sender: TObject);
    procedure actBackExecute(Sender: TObject);
    procedure actForwordExecute(Sender: TObject);
    procedure FavTreeScrlTimerTimer(Sender: TObject);
    procedure FavTreeExpndTimerTimer(Sender: TObject);
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    procedure Find1Click(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure MenuCommandClick(Sender: TObject);
    procedure PopupViewJumpClick(Sender: TObject);
    procedure MenuListHomeMovedBoardClick(Sender: TObject);
    procedure ExtractPopupClick(Sender: TObject);
    procedure MenuBoardCheckLogFolderClick(Sender: TObject);
   {beginner}
    procedure OpenImageView(Sender: TObject);
    procedure OpenImageViewPreference(Sender: TObject);
    procedure PopupViewAddNgClick(Sender: TObject);
    procedure TextPopupNGWordClick(Sender: TObject);
    procedure PopupViewOpenImageClick(Sender: TObject);
    procedure actAboneLevelExecute(Sender: TObject);
    procedure TextPopupOpenByBrowserClick(Sender: TObject);
    procedure MakeCheckNewThreadAfter(Sender: TObject; StartIndex,EndIndex: Integer);
    procedure TextPopupOpenByViewerClick(Sender: TObject);
    procedure PopupViewShowResTreeClick(Sender: TObject);
    procedure MenuOpenURLOnMouseOverClick(Sender: TObject);
    procedure TextPopupTrensferToWriteFormClick(Sender: TObject);
    procedure MenuWatchClipboardClick(Sender: TObject);
    procedure DrawClipboard(var Message: TMessage); message WM_DRAWCLIPBOARD;
    procedure ChangeCBChain(var Message: TWMChangeCBChain); message WM_CHANGECBCHAIN;
    procedure TextPopupRegisterBroCraClick(Sender: TObject);
    procedure TextPopupDeleteCacheClick(Sender: TObject);
    procedure UrlEditEnter(Sender: TObject);
    procedure FindThreadButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DrawLinesButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    {/beginner}
    procedure OnFind(sender: TAsyncReq); //rika
    {aiai}
    procedure TabControlDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure ThreCheckNewResButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuAAEditClick(Sender: TObject);
    procedure MenuClearHistroy(Sender: TObject);
    procedure ViewPopupSaveDatClick(Sender: TObject);
    procedure ViewPopupTITLECopyClick(Sender: TObject);
    procedure AutoReloadCount(Count: Integer = 0);
    procedure ViewPopupOpenAutoReloadSettingFormClick(Sender: TObject);
    procedure ViewPopupScrollSpeedClick(Sender: TObject);
    procedure ListPopupChottoViewClick(Sender: TObject);  //rika
    procedure TextPopupChottoViewClick(Sender: TObject);  //rika
    procedure MenuFavPatrolClick(Sender: TObject);
    procedure ViewPopupSetAlreadyClick(Sender: TObject);
    procedure ViewPopupNotCloseClick(Sender: TObject);
    procedure TextPopupExtractIDClick(Sender: TObject);        //更新チェック
    procedure PopupTreeOpenNewResThreadsClick(Sender: TObject);
    procedure PopupTreeOpenNewResFavoritesClick(Sender: TObject);
    procedure PopupOpenFavoritesClick(Sender: TObject);
    procedure TextPopupOpenByLovelyBrowserClick(Sender: TObject);
    procedure LovelyBrowser1Click(Sender: TObject);
    procedure ThreadTitleLabelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure actAutoReScExecute(Sender: TObject);
    procedure actCheckNewResAllExecute(Sender: TObject);
    procedure actTabPtrlExecute(Sender: TObject);
    procedure MenuThreCloseAndAlreadyClick(Sender: TObject);
    procedure actListAlreadyExecute(Sender: TObject);
    procedure MenuFindeThreadTitleClick(Sender: TObject);
    procedure MenuOptUseNewsClick(Sender: TObject);
    procedure MenuOptSetNewsIntervalClick(Sender: TObject);
    procedure actListCopyTITLEExecute(Sender: TObject);
    procedure PopupTreeCopyTITLEClick(Sender: TObject);
    procedure PopupFavCopyTITLEClick(Sender: TObject);
    procedure actCopyTITLEExecute(Sender: TObject);
    procedure ViewPopupCopyDATClick(Sender: TObject);
    procedure ViewPopupCopyDIClick(Sender: TObject);
    procedure actListCopyDatExecute(Sender: TObject);
    procedure actListCopyDIExecute(Sender: TObject);
    procedure actSaveDatExecute(Sender: TObject);
    procedure actCopyDatExecute(Sender: TObject);
    procedure actCopyDIExecute(Sender: TObject);
    procedure ViewPopupToggleAutoScrollClick(Sender: TObject);
    procedure ViewPopupAutoScrollAtAnyTimeClick(Sender: TObject);
    procedure ViewPopupAutoScrollSettingClick(Sender: TObject);
    procedure ViewPopupToggleAutoReloadClick(Sender: TObject);
    procedure TextPopupAddAAListClick(Sender: TObject);
    procedure PopupViewAddAAlistClick(Sender: TObject);
    procedure PopupViewCopyDataClick(Sender: TObject);
    procedure PopupViewCopyRDClick(Sender: TObject);
    procedure PopupViewReplyWithQuotationOnWriteMemoClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure TextPopupAddNGIDClick(Sender: TObject);
    procedure ToolBarUrlEditResize(Sender: TObject);
    procedure actRefreshIdxListExecute(Sender: TObject);
    procedure MenuListRefreshIdxListClick(Sender: TObject);
    procedure MenuBoardListClick(Sender: TObject);
    procedure actThreadAboneExecute(Sender: TObject);
    procedure MenuListOpenNewResThreadsClick(Sender: TObject);
    procedure MenuListOpenNewResFavoritesClick(Sender: TObject);
    procedure MenuListOpenFavoritesClick(Sender: TObject);
    procedure TextPopupIDAboneClick(Sender: TObject);
    procedure MenuImageViewOpenCacheListClick(Sender: TObject);
    procedure ThreadRefreshButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuListRefreshAllClick(Sender: TObject);
    procedure PopupTaskTrayCloseClick(Sender: TObject);
    procedure PopupTaskTrayRestoreClick(Sender: TObject);
    procedure MenuViewClick(Sender: TObject);
    procedure PanelTitlePanelClick(Sender: TObject);
    procedure ToolButtonWriteTitleAutoHideClick(Sender: TObject);
    procedure ToolButtonWriteTitleCloseClick(Sender: TObject);
    procedure WritePanelEnter(Sender: TObject);
    procedure WritePanelExit(Sender: TObject);
    procedure TreePanelExit(Sender: TObject);
    procedure TreePanelEnter(Sender: TObject);
    procedure LabelTreeTitleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LabelWriteTitleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListViewDropFiles(Sender: TObject; FileList: TStringList);
    procedure LabelWriteTitleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure LabelWriteTitleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonWriteTitleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ToolButtonTreeTitleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LabelTreeTitleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure LabelTreeTitleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreePanelResize(Sender: TObject);
    procedure MenuBoardCanMoveClick(Sender: TObject);
    procedure PopupStatusBarPopup(Sender: TObject);
    procedure MenuStatusOpenByBrowserClick(Sender: TObject);
    procedure MenuStatusOpenByLovelyBrowserClick(Sender: TObject);
    procedure MenuWritePanelPosClick(Sender: TObject);
    procedure MenuWritePanelDisableStatusBarClick(Sender: TObject);
    procedure PopupWritePanelPopup(Sender: TObject);
    procedure MenuMemoClick(Sender: TObject);
    procedure MenuStatusCopyURIClick(Sender: TObject);
    procedure MenuWritePanelDisableTopBarClick(Sender: TObject);
    procedure MenuOptSetNewsSizeClick(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure actMaxViewExecute(Sender: TObject);
    procedure MenuWindowCascadeClick(Sender: TObject);
    procedure MenuWindowTileVerticallyClick(Sender: TObject);
    procedure MenuWindowTileHorizontallyClick(Sender: TObject);
    procedure MenuWindowMaximizeAllClick(Sender: TObject);
    procedure MenuThreSysMoveClick(Sender: TObject);
    procedure MenuThreSysResizeClick(Sender: TObject);
    procedure PopupThreSysPopup(Sender: TObject);
    procedure MenuWindowRestoreAllClick(Sender: TObject);
    procedure MenuMemoRestoreClick(Sender: TObject);
    procedure MenuBoardRestoreClick(Sender: TObject);
    procedure SearchEditBoxChange(Sender: TObject);
    procedure ListViewSearchToolBarResize(Sender: TObject);
    procedure PopupSearchPopup(Sender: TObject);
    procedure ListViewSearchToolButtonClick(Sender: TObject);
    procedure SearchTimerTimer(Sender: TObject);
    procedure ThreViewSearchToolBarResize(Sender: TObject);
    procedure ThreViewSearchToolButtonClick(Sender: TObject);
    procedure TreeViewSearchToolBarResize(Sender: TObject);
    procedure TreeViewSearchToolButtonClick(Sender: TObject);
    procedure PopupUrlEditPopup(Sender: TObject);
    procedure MenuUrlEditUndoClick(Sender: TObject);
    procedure MenuUrlEditCutClick(Sender: TObject);
    procedure MenuUrlEditCopyClick(Sender: TObject);
    procedure MenuUrlEditPasteClick(Sender: TObject);
    procedure MenuUrlEditPasteAndGoClick(Sender: TObject);
    procedure MenuUrlEditDeleteClick(Sender: TObject);
    procedure MenuUrlEditSelectAllClick(Sender: TObject);
    procedure MenuSearchItemClick(Sender: TObject);
    procedure SearchEditBoxKeyPress(Sender: TObject;
      var Key: Char);
    procedure MenuListHideHistoricalLogClick(Sender: TObject);
    procedure actHideHistoricalLogExecute(Sender: TObject);
    procedure actThreadAbone2Execute(Sender: TObject);
    procedure actThreadAboneShowExecute(Sender: TObject);
    procedure PopupTreeCustomSkinClick(Sender: TObject);
    procedure PopupViewCopyURLClick(Sender: TObject);
    procedure ButtonWriteWriteClick(Sender: TObject);
    procedure ToolButtonWriteClick(Sender: TObject);
    procedure PageControlWriteChange(Sender: TObject);
    procedure MemoWriteMainEnter(Sender: TObject);
    procedure MemoWriteMainExit(Sender: TObject);
    procedure ToolButtonWriteAAClick(Sender: TObject);
    procedure MemoWriteMainChange(Sender: TObject);
    procedure MemoWriteMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoWriteMainKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBoxWriteSageClick(Sender: TObject);
    procedure MenuStatusResetClick(Sender: TObject);
    procedure ThreViewSearchUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure ListViewSearchCloseButtonClick(Sender: TObject);
    procedure ThreViewSearchCloseButtonClick(Sender: TObject);
    procedure TrayIconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    {/aiai}
  private
  { Private 宣言 }
    UILock: Boolean;
    AlreadySetMouseGesture:Boolean;  //beginner
    requestingBoard: TBoard;
    procGetCategoryList: TAsyncReq;
    procGetSubject: TAsyncReq;
    hintURI: string;
    subjectReadyEvent: THogeEvent;
    tabRightClickedIndex: integer;
    mdRPane: TPaneType;
    currentView: TViewItem;
    currentViewHandle: HWND;
    currentSortColumn: integer;
    currentBoardIsFunction: boolean;
    FStatusText: string;
    proccessingPopupFromContext: Boolean;
    loginIndicator: string;
    FRecentlyClosedThreads: TStringList;
    //▼test
    //マウスジェスチャー
    prevPoint: TPoint;
    mouseGestureEnable: Boolean;
    restrainContext: Boolean;

    clickGestureStandby: boolean;
    moveGestureTemp: string;
    //D&D
    tabDragSourceIndex: integer;

    ///※[457]
    //threadsearched: Boolean;

    savedListHeight: integer;
    savedListWidth: integer;

    FResJumpNormalPopup: Boolean;
    FHovering: Boolean;

    {beginner}
    NextClipBoardViewer: HWND;
    {/beginner}

    procGet: TAsyncReq; //rika
    //storedSetting: TLocalCopy; //rika
    {aiai}
    FavBrdList: TList;
    FavPtrlFavs: TFavoriteList;
    FavPtrlCount: Integer;
    LovelyWebForm: TLovelyWebForm;

    TreePanelVisible: Boolean;
    TreePanelCanMove: Boolean;
    TreePanelMouseDowned: Boolean;
    TreePanelOriginalX: Integer;
    TreePanelOriginalY: Integer;
    TreePanelHoverRect: TRect;
    TreePanelFixedWidth: Integer;

    WritePanelCanMove: Boolean;
    WritePanelMouseDowned: Boolean;
    WritePanelOriginalX: Integer;
    WritePanelOriginalY: Integer;
    WritePanelPos: Boolean;
    WritePanelHoverRect: TRect;
    WritePanelFixedHeight: Integer;

    CanAutoCheckNewRes: Boolean; //更新のあるスレを選択するだけでリロード可能にしてよいかどうか
    {/aiai}

    procedure SaveWindowPos;
    procedure LoadWindowPos;
    procedure UpdateTreeView;
    procedure UpdateBoardMenu;
    procedure UpdateFavoritesMenu;
    procedure SaveTreeViewState;
    procedure OnGetBoardList(sender: TAsyncReq);
    procedure TreeViewSelected(Sender: TObject; Node: TTreeNode;
                               cmdType: TGestureOprType);
    procedure ListViewNavigate(board: TBoard; oprType: TGestureOprType;
                                              newTab: boolean = false);
    procedure HomeMovedBoard(board: TBoard);
    procedure OpenBoard(board: TBoard; newTab: boolean; active: boolean = true); (* スレ覧タブに板を追加 *)
    procedure CloseBoard(index: integer; update: boolean = true); (* スレ覧タブから板を閉じる *)
    procedure SaveListViewState;
    procedure OnSubject(sender: TAsyncReq);
    procedure OnMovedSubject(sender: TAsyncReq);
    procedure UpdateListView;
    procedure ThreadAboneFilter;
    function NewView(relative: boolean = false; background: boolean = false;
      Left: integer = 0; Top: integer = 0;
      Right: integer = 0; Bottom: integer = 0;
      wndstate: TMTVState = MTV_MAX): TViewItem;
    function NewPopUpView(OwnerView: TBaseViewItem): TPopUpViewItem;
    procedure DeleteView(index: integer; savePos: boolean = True);
//    function GetActiveView: TViewItem; publicへ移動 by beginner
    function GetViewOf(browser: TComponent): TBaseViewItem;
    procedure AppDeactivate(Sender: TObject);
    procedure SetZoomState(zoom: integer);
    procedure LocalNavigate(const URI: string; activate: boolean = false;
      Left: integer = 0; Top: integer = 0; Right: integer = 0;
      Bottom: Integer = 0;
      wndstate: TMTVState = MTV_MAX; canclose: boolean = true); overload;
    procedure LocalNavigate(const host, bbs, datnum: string;
      activate: boolean = false; Left: integer = 0; Top: integer = 0;
      Right: integer = 0; Bottom: Integer = 0;
      wndstate: TMTVState = MTV_MAX; canclose: boolean = true); overload;
    procedure UpdateFavorites;
    procedure SaveFavorites(save: boolean = true);
    function  IsFavorite(thread: TThreadItem): boolean; overload;
    function  IsFavorite(board: TBoard): boolean; overload;
    procedure RegisterFavorite(thread: TThreadItem;
                               parent: TFavoriteList = nil; index: integer = 0); overload;
    procedure RegisterFavorite(board: TBoard; parent:
                               TFavoriteList = nil; index: integer = 0;
                               dosaveandupdate: boolean = true); overload;
    procedure UnRegisterFavorite(thread: TThreadItem); overload;
    procedure UnRegisterFavorite(board: TBoard); overload;
    procedure ShowSpecifiedThread(thread: TThreadItem;
                                  oprType: TGestureOprType;
                                  newViewP: Boolean;
                                  relative: boolean = false;
                                  background: boolean = false;
                                  number: Integer = -1;
                                  Left: integer = 0; Top: integer = 0;
                                  Right: integer = 0; Bottom: integer = 0;
                                  wndstate: TMTVState = MTV_MAX);
    procedure SetRPane(paneType: TPaneType);
    function TreeViewGetNode(sender: TObject): TTreeNode;
    procedure SetCaption(const BoardName: string);
    procedure FindInTree(forwardP: boolean);
    procedure FindInList(forwardP: boolean);
    procedure FindInView(forwardP: boolean);
    procedure ListViewSelectIntoView(item: TListItem);
    procedure ViewItemStateChanged;
    procedure SetThreadMenuContext(viewItem: TViewItem);
    function OpenURL(Msg: TMessage): Boolean;
    procedure SetCurrentView(index: integer);
    procedure UpdateCurrentView(index: integer);
    function ProcessKeyForBrowser(Msg: TMsg): boolean;
    procedure OpenWriteForm(Sender: TObject; const AString: string);
    procedure ChangeCurrentBoard(board: TBoard);
    procedure ToggleSortColumn;
    procedure ON_WM_SYSCOMMAND(var msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure ON_WM_USER(var msg: TMessage); message WM_USER;
    procedure ON_WM_COPYDATA(var msg: TWMCopyData); message WM_COPYDATA;
    procedure OnLogin(var msg: TMessage);
    procedure OnAbout;
    function FavoriteToURL(node: TTreeNode; const titleP: boolean): string;
    procedure KeyConf; (* 9 Feb. 2002 by 816=817 *)
    procedure SaveKeyConf;
    procedure OpenConfigDlg(PanelSpec: Integer = -1);
    procedure WindowRecentlyClosedClick(Sender: TObject);
    procedure CopyResToClipBrd(title, uri, res: boolean; num: integer);
    //▼test
    procedure SetMouseGesture;
    procedure OpenStartupThread;
    procedure SaveLastThread;
    procedure CommandExecute(command: string; replace: boolean = true;
      name: string = '');  //aiai nameパラメータ追加
    procedure CommandCreate;
    procedure ThreadTabLineAdjust;
    procedure ListTabLineAdjust;
    procedure UpdateListTab; (* スレ覧タブとboardList,currentBoardの同期 *)
    function PopupRes(Sender: TObject; Extract: Boolean): boolean;
    procedure OnGestureMessage(var Msg: TMsg; var Handled: boolean);
    procedure MoveGesture(pt: TPoint);
    procedure GestureExecute(Name: string);
    //※[457]
    procedure LoadSkin(skinPath: string);
    procedure SetCustomSkinToBoard;

    procedure SetDivision(vertical: boolean);
    procedure SetPaneType(toggle: boolean);
    procedure SetStyle;
    procedure OnFavoritesOprMsg(var msg: TMessage);
    procedure SetUrlEdit(viewItem: TViewItem); overload;
    procedure SetUrlEdit(board: TBoard); overload;
    procedure ListViewColumnSort(columnIndex: Integer); // カラムの種類を指定してソート
    procedure SetUpColumns; // カラムの順序・表示/非表示設定
    function ProtocolCheck(const S: string):Boolean;
    function CutImenu(const s: string):string;
    procedure RedrawFavoriteButton;
    procedure PopupViewListChange(Sender: TObject);
    procedure SetTracePosition;  //beginner

    {ayaya}
    procedure LoadTraceString();
    {//ayaya}

    {aiai}
    procedure StartAutoReSc;
    procedure FavCheckServerDownEnd(Sender: TObject);
    procedure FavBrdOpen;
    procedure FavPatrol(PatrolType: TPatrolType);
    procedure TabPtrlStart;
    procedure ThreadListRefreshAll;
    procedure CreateNewsBar;
    procedure BrowserScrollEnd(Sender: TObject);
    procedure BrowserEnter(Sender: TObject);
    procedure BrowserExit(Sender: TObject);
    procedure OpenChottoForm(chottoURL: String);
    procedure MainWndRestore;
    procedure CloseThisTab(refresh: Boolean = True);
    //▼ 板ツリー表示関連
    procedure SetTabSetIndex(index: integer);
    procedure ToggleTreePanel(AVisible: Boolean);
    procedure ToggleTreePanelCanMove(ACanMove: Boolean);
    //▲ 板ツリー表示関連
    //▼ 書き込みパネル
    procedure ToggleWritePanelVisible(AVisible: Boolean);
    procedure ToggleWritePanelTabSheet(AIndex: Integer);
    procedure ToggleWritePanelCanMove(ACanMove: Boolean);
    procedure ToggleWritePanelPos(APos: Boolean);
    //▲ 書き込みパネル
    //▼ ステータスバー
    procedure MyNewsNews(Sender: TObject; News: String);
    //▲ ステータスバー
    procedure BrowserActive(Sender: TObject);
    //▼ 検索
    procedure InitMigemo;
    procedure ListViewSearchNarrowing;
    procedure SearchSetSearch(index: integer; EditBox: TComboBox;
      Button: TToolButton);
    procedure ListviewSearchEnd(error: Boolean);
    procedure ExtractRes(IncludeRef: Boolean);
    //▲ 検索
    //▼ WriteWaitTimerのイベントハンドラ
    procedure WriteWaitTimerNotify(Sender: TObject; DomainName: String; Remainder: Integer);
    procedure WriteWaitTimerEnd(Sender: TObject);
    //▲ WriteWaitTimerのイベントハンドラ
    {/aiai}
  public
    { Public 宣言 }
    //ListFontColor: TColor; //※[457]
    currentBoard: TBoard;
    PopupHint: TImageHint; // by beginner氏 Publicに移動
    QuickAboneRegist: TQuickAboneRegist; //beginner

    {aiai}
    AutoScroll: TAutoScroll;
    AutoReload: TAutoReload;

    WriteWaitTimer: TWriteWaitTimer;
    {/aiai}

    function NavigateIntoView(const URI: string; oprType: TGestureType; relative: boolean = false;
                              background: boolean = false): boolean; overload;
    function NavigateIntoView(const host, bbs, datnum: string;
                              index: integer; oldLog: boolean; oprType: TGestureType;
                              anotherTab: boolean = true; relative: boolean = false;
                              background: boolean = false): boolean; overload;
    procedure OnBrowserMouseMove(Sender: TObject; Shift: TShiftState;
                                 X, Y: Integer);
    procedure OnBrowserMouseHover(Sender: TObject; Shift: TShiftState;
                                 X, Y: Integer);
    procedure OnBrowserMouseDown(Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
    procedure OnBrowserKeyDown(Sender: TObject; var Key: Word;
                               Shift: TShiftState);
    procedure BrowserMouseEnter(Sender: TObject);
    procedure BrowserBeforeNavigate(Sender: TObject; const URL: String;
      Point: TPoint; var Cancel: WordBool; MustGo: Boolean);
    procedure BrowserStatusTextChange(Sender: TObject; Text: String; Point: TPoint);
    procedure BrowserQueryContext(Sender: TObject; var CanContext: Boolean);
    procedure BrowserEndContext(Sender: TObject);
    procedure PopupViewItemEnabled(Sender: TObject);
    function GetActiveView: TViewItem; //privateから移動 by beginner
    procedure WriteLog(const str: string);
    procedure UpdateThreadInfo(thread: TThreadItem);
    procedure ShowHint(Point: TPoint; const str: string; MaxWidth: integer = 0;
      MaxHeight: integer = 0; ForceCursorPos: boolean=False); // beginner氏
    function ShowTreeHint(Sender: TObject; OutLine: Boolean): Boolean; //beginner
    procedure WriteStatus(const s: string);
    procedure OpenByBrowser(const URI: string);
    procedure UpdateTabTexts(refresh: boolean = false);//▼
    procedure UpdateIndicator;
    procedure UpdateIndicatorEx(index: integer);
    procedure ThreadClosing(const thread: TThreadItem);
    procedure PopupAddFavClick(Sender: TObject);
    //※[457]
    procedure SetupNGWords; //(configから使うので移動)
    function Show2chInfo(const Point: TPoint; const IdStr: String; const URI: string;
      OwnerView: TBaseViewItem; Nesting: Boolean): boolean;
    function ShowIDInfo(const Point: TPoint; const IDStr: String; const URI: string;
      OwnerView: TBaseViewITem; Nesting: Boolean): boolean; //aiai
    procedure ReleasePopupHint(viewItem: TBaseViewItem = nil; Force: Boolean = False);
    procedure SetviewListItemsColor;
    {aiai}
    procedure StopAutoReSc;
    procedure PauseToggleAutoReSc(bool: Boolean);
    procedure OpenByLovelyBrowser(URI: String = '');
    function  MyMessageDlg(messageLabel: String): Word;
    procedure FavPtrlManager(Count: Integer;
                  PatrolType: TPatrolType; board: TBoard);
    procedure UpdateListViewColumns;
    procedure ListViewRepaint;
    {/aiai}
  end;

const
  SW_SHOWNORMAL     : integer = 1;
  SW_SHOWMINIMIZED  : integer = 2;
  SW_SHOWMAXIMIZED  : integer = 3;
  SW_SHOWNOACTIVATE : integer = 4;
  SW_SHOW           : integer = 5;
  SW_SHOWMINNOACTIVE: integer = 7;
  SW_SHOWNA         : integer = 8;
  SW_SHOWDEFAULT    : integer =10;

var
  MainWnd: TMainWnd;
  Config: TJaneConfig;
  SkinCollectionList: TSkinCollectionList;
  AboneLevel: ShortInt;
  ThreAboneLevel: ShortInt;
  AsyncManager: TAsyncManager;
  HeaderFile: string;
  urlHeadCache: TUrlHeadCache;
  daemon: TDaemon;
  viewList: TViewList;
  popupviewList: TPopUpViewList;
  viewListLock: THogeMutex;
  boardList: TBoardList;
  i2ch: TCategoryList;
  searchTarget: string;
  //▼test
  userImeMode: TImeMode;
  favorites: TFavorites;
  FavoriteListBoardAdmin: TFavoriteListBoardAdmin; //※[457]
  timeValue: Int64;
  DrawLinesArray: Array[0..4] of integer = (0,50,100,250,500);

  CheckNewThreadAfter: Integer; //beginner
  CheckNewThreadAfter2: Integer; //aiai (* 前回subject.txtを取りに行った時間 *)
  NowTimeUnix: Integer;      //aiai (* TimeZoneBiasを考慮したUnixTime *)

  {$IFDEF BENCH}
  benchfreq: Int64;
  benchstart: Int64;
  benchend: Int64;
  {$IFDEF DEVELBENCH}
  benchstart3: Int64;
  benchend3: Int64;
  {$ENDIF}
  {$ENDIF}
  PrevPos: TPoint;

  {ayaya}
  traceString: array[0..51] of String;
  useTrace: array[0..51] of Boolean;
  {//ayaya}

  {aiai}
  writing: Boolean;      //現在書き込み中かどうか
  MyNews: TNews;
  MigemoOBJ: TMigemo;
  NGItems: TNGList;
  ExNGList: TExNGList;
  ThreNGList: TNGStringList;
  WritePanelControl: TWritePanelControl;
  {/aiai}

procedure SaveImeMode(wnd: HWND);
procedure Log(const str: string);
procedure BeginMultiLog;
procedure EndMultiLog;
procedure UpdateThreadInfo(thread: TThreadItem);
procedure LogBeginQuery;
procedure LogBeginQuery2;
procedure LogEndQuery;
procedure LogEndQuery2;
procedure LogDone(writeTrace: Boolean = True);
procedure StatLog(const str: string);

{ayaya}
procedure Log2(i:Integer; const str: String);
procedure StatLog2(i:Integer; const str: String);
{//ayaya}

function IsPrimaryInstance: Boolean;
function OnStartup: Boolean;
procedure DlgTooManyConn;
function MouseInPane(control: TControl): boolean;
procedure WriteStatus(const str: string);
procedure ResetDaemon;
{$IFDEF BENCH}
procedure Bench(i: Integer);
function Bench2(i: Integer): Integer;
{$IFDEF DEVELBENCH}
function Bench3(i: Integer): String;
{$ENDIF}
procedure InitBench();
{$ENDIF}
//Windowsのバージョン文字列を返す
function GetWin32Version: string;

const
  CMD_OPEN  = 1;
  INF_LOGIN = 100;
  FAV_OPR   = 1000;

{ 配列化してNGWordsAssistantに移動 by beginner
  NG_NAMES_FILE         = 'NGnames.txt';
  NG_ADDRS_FILE         = 'NGaddrs.txt';
  NG_WORDS_FILE         = 'NGwords.txt';
  NG_ID_FILE            = 'NGid.txt';
}
  FAVORITES_DAT         = 'favorites.dat';
  KEYCONF_FILE          = 'keyconf.ini';
  SESSION_DAT           = 'session.dat';  //aiai

(*=======================================================*)
implementation

uses Types, UTTSearch;
(*=======================================================*)

{$R *.dfm}

(* どうもやり過ぎの気がしなくもないのだが･･･ *)
{$DEFINE ENABLE_DOWNLOAD_BY_MOUSE}

type TDummyToolButton = class(TToolbutton); //beginner


const
  HTML_HEADER_TEMPLATE  = 'Header.html';
  HTML_BODY_TEMPLATE    = 'Res.html';
  HTML_NEWBODY_TEMPLATE = 'NewRes.html';
  HTML_POPUP_TEMPLATE   = 'PopupRes.html';
  HTML_BOOKMARK_TEMPLATE = 'BookMark.html';
  HTML_NEWMARK_TEMPLATE = 'NewMark.html';

  THREAD_CURRENT_LIST    = 'subject.txt';
  THREAD_PAST_LIST       = 'subkako.txt.gz';

  LVSC_NUMBER = 1;
  LVSC_TITLE  = 2;
  LVSC_ITEMS  = 3;
  LVSC_LINES  = 4;
  LVSC_NEW    = 5;
  LVSC_GOT    = 6;
  LVSC_WROTE  = 7;
  LVSC_DATE   = 8;
  LVSC_BOARD  = 9;
  LVSC_SPEED  = 10;
  LVSC_GAIN   = 11;
  // obsoleted LVSC_DAT    = 5;

  MENU_ID_ABOUT     = 10;
  MENU_ID_DUMP_KEYS = 11;
  MENU_ID_MENUTOGGLE= 12;

  WND_SUFFIX = 'WND';
  URL_SUFFIX = 'URL';
  CLI_SUFFIX = 'CLI';
  MAX_URL_LEN = 1024;

  WM_XBUTTONDOWN   = $020B;
  WM_XBUTTONUP     = $020C;
  WM_XBUTTONDBLCLK = $020D;
  MK_XBUTTON1 = $0001;
  MK_XBUTTON2 = $0002;

  WM_MY_TRAYICON = WM_APP + $300;

  DEF_HEADER_HTML = '<html><body><font face="ＭＳ Ｐゴシック"><dl>';
  DEF_REC_HTML    = '<dt><NUMBER/> 名前：<SA i=2><b><NAME/></b></b><SA i=0>[<MAIL/>] 投稿日：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10;
  DEF_NEWREC_HTML = '<dt><b><NUMBER/></b> 名前：<SA i=2><b><NAME/></b></b><SA i=0>[<MAIL/>] 投稿日：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10;
  DEF_BOOKMARK_HTML = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━<br>' +
                      '　　　　　　　　　　　　　　　　　　　ここまで読んだ<br>' +
                      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━<br><br>';
  DEF_NEWMARK_HTML = '';

var
  HogeMutex: THogeMutex;  (* 二重起動防止用 *)
  TabSwitchList: TList;
  TimeZoneBias: integer;
  (*==================*)
  sharedResourceName: string;
  initialURL: TStringList;
  MyWindowHandle: THogeSharedMem;



(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)

(* 準備中。 *)
function OnStartup: Boolean;
var
  wnd: HWND;
  i: integer;
  cd: TCopyDataStruct;
  s: string;
  active: boolean;
begin
  sharedResourceName := StringReplace(HogeExtractFileDir(Application.ExeName),
                                      '\', '-', [rfReplaceAll]);
  initialURL := TStringList.Create;
  active := true;
  if 0 < System.ParamCount then
    for i := 1 to System.ParamCount do
    begin
      if MAX_URL_LEN < length(System.ParamStr(i)) then
        continue;
      if not StartWith('-', System.ParamStr(i), 1) then
        initialURL.Add(System.ParamStr(i));
      if CompareStr('-h', System.ParamStr(i)) = 0 then
        active := false
      else
        s := s + System.ParamStr(i) + #13;
    end;
  if IsPrimaryInstance then
    result := true
  else begin
    FreeAndNil(initialURL);
    result := false;
    wnd := FindWindow('TMainWnd', nil);
    if wnd = 0 then
      exit;
    if 0 < System.ParamCount then
    begin
      cd.cbData := Length(s) + 1;
      cd.lpData := StrAlloc(cd.cbData);
      try
        StrCopy(cd.lpData, PChar(s));
        SendMessage(wnd, WM_COPYDATA, WPARAM(wnd), LPARAM(@cd));
      finally
        StrDispose(cd.lpData);
      end;
    end;
    if active then
      SetForegroundWindow(wnd);
  end;
end;

{aiai}
var
  //Windowsのバージョン文字列を入れておく
  // ex. Windows NT 5.1
  Win32Version: String;

//Windowsのバージョン文字列を返す
function GetWin32Version: string;
begin
  if Length(Win32Version) = 0 then
  begin
    Win32Version := 'Windows';
    case Win32Platform of
      VER_PLATFORM_WIN32_NT: begin
        Win32Version := 'Windows NT ' + IntToStr(Win32MajorVersion) + '.'
          + IntToStr(Win32MinorVersion);
      end;
      VER_PLATFORM_WIN32_WINDOWS:
        // Windows MEでMinorVersionが10の場合があるが無視する
        case Win32MinorVersion of
          0..9: Win32Version := 'Windows 95';
          10..89: Win32Version := 'Windows 98';
          90: Win32Version := 'Windows ME';
        end;
      VER_PLATFORM_WIN32s: begin
        Win32Version := 'Win32s';
      end;
    end;
  end;
  result := Win32Version;
end;
{/aiai}

(*=======================================================*)
(*=======================================================*)


//※[457] 簡易ベンチ

////////////////////////////////////////////////////////////////////////////////
//
//InitBench(): benchfreqを初期化、Bench(),Bench2(),Bench3()を使う前に
//             一度実行する必要がある
//Bench():     benchstartに開始時間を記録し、benchendに終了時間を記録し、
//             経過時間をdaemonにとばす
//Bench2():    benchstartに開始時間を記録し、benchendに終了時間を記録し、
//             経過時間をIntegerで返す
//Bench3():    enchstart3に開始時間を記録し、benchend3に終了時間を記録し、
//             経過時間をstringで返す
//
// commented by aiai

{$IFDEF BENCH}
procedure InitBench;
begin
	QueryPerformanceFrequency(benchfreq);
end;

procedure Bench(i: Integer);
begin
  if i = 0 then  begin
    QueryPerformanceCounter(benchstart);
  end else begin
    QueryPerformanceCounter(benchend);
    Log(LeftStr(FloatToStr((benchend - benchstart) / benchfreq * 1000), 8)
            + 'ms');
  end;
end;

function Bench2(i: Integer): Integer;
begin
  result := 0;
  if i = 0 then begin
    QueryPerformanceCounter(benchstart);
  end else begin
    QueryPerformanceCounter(benchend);
    result := Trunc((benchend - benchstart) / benchfreq * 1000);
  end;
end;

{$IFDEF DEVELBENCH}
function Bench3(i: Integer): String;
begin
  result := '';
  if i = 0 then begin
    QueryPerformanceCounter(benchstart3);
  end else begin
    QueryPerformanceCounter(benchend3);
    result := LeftStr(FloatToStr((benchend3-benchstart3) / benchfreq * 1000), 8)
                                                                        + 'ms';
  end;
end;
{$ENDIF}
{$ENDIF}

function MouseInPane(control: TControl): boolean;
var
  point: TPoint;
begin
  Result := False;
  if GetCursorPos(point) and not InvalidPoint(point) then
  begin
    point := control.ScreenToClient(point);
    result := (0 <= point.X) and (point.X < control.Width) and
              (0 <= point.Y) and (point.Y < control.Height);
  end;
end;

function IsPrimaryInstance: Boolean;
begin
  HogeMutex := THogeMutex.Create(false, PChar(sharedResourceName));
  if HogeMutex.lastError <> 0 then
  begin
    HogeMutex.Free;
    result := false;
  end
  else
    result := true;
end;

////////////////////////////////////////////////////////////////////////////////
//
//WriteStatus(): ステータスバーの左から2番目のブロックにstrを表示する
//
//
// commented by aiai

procedure WriteStatus(const str: string);
begin
  MainWnd.WriteStatus(str);
end;

////////////////////////////////////////////////////////////////////////////////
//
// トレース画面表示関連
//

procedure LogBeginQuery;
begin
  MainWnd.WriteStatus('通信中');
{ Log('（･∀･∀･）');
  Log('（･∀･）ｻﾃｵｼｺﾞﾄ･･･　　　　　　　　　　ε三三三三（; ･∀･）鯖ﾏﾃﾞｵﾂｶｲ');}
  Log2(0, '');  //ayaya
  Log2(1, '');  //ayaya
end;

procedure LogBeginQuery2;
begin
  MainWnd.WriteStatus('通信中');
  {Log('（･∀･）ｵﾙｽﾊﾞﾝ　　　　　　　　　　　　ε三三三三（; ･∀･）鯖ﾏﾃﾞｵﾂｶｲ');}
  Log2(2, '');  //ayaya
end;

procedure LogEndQuery;
begin
  {Log('（　･∀･）　　　 鯖ｶﾗﾍﾝｼﾞ（･∀･ ;）つ□　三三三三３');}
  Log2(3, '');  //ayaya
end;
procedure LogEndQuery2;
begin
  MainWnd.WriteStatus('受信完了');
 {Log('（ ･∀･）（･∀･ ）ｵﾂｶｲｵﾜﾘ　三三三三３');
  Log('（･∀･∀･）');}
  Log2(4, '');  //ayaya
  Log2(5, '');  //ayaya
end;

procedure LogDone(writeTrace: Boolean);
begin
{  if writeTrace then
    Log('（･∀･）ｶﾝﾘｮｳ!!');}
  Log2(6, '');  //ayaya
  MainWnd.WriteStatus('完了');
  MainWnd.Tabcontrol.Refresh;  //aiai ここでいいや　
end;

procedure StatLog(const str: string);
begin
  Log(str);
  MainWnd.StatusBar.Panels.Items[2].Text := str;
  //MainWnd.StatusBar2.Text[2] := str;    //aiai
end;

procedure Log(const str: string);
begin
  daemon.Log(str);
end;

procedure BeginMultiLog;
begin
  daemon.LogLock;
end;

procedure EndMultiLog;
begin
  daemon.LogFree;
end;

{ayaya}
procedure Log2(i:Integer; const str: String);
begin
  if useTrace[i] then daemon.Log(traceString[i] + str);
end;

procedure StatLog2(i:Integer; const str: String);
begin
  if useTrace[i] then
  begin
    daemon.Log(traceString[i] + str);
    MainWnd.StatusBar.Panels.Items[2].Text := traceString[i] + str;
  end;
end;
{//ayaya}

procedure UpdateThreadInfo(thread: TThreadItem);
begin
  MainWnd.UpdateThreadInfo(thread);
end;

procedure DlgTooManyConn;
begin
  MessageDlg('（；´∀｀）同時接続数超過', mtWarning, [mbOK], 0);
end;

procedure ResetDaemon;
begin
  if assigned(daemon) then
  begin
    daemon.Terminate;
    daemon.WaitFor;
    daemon.Free;
  end;
  daemon := TDaemon.Create;
end;
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
(*=======================================================*)
var
  boardNameOfCaption: string;

procedure TMainWnd.OpenByBrowser(const URI: string);
begin
  if Config.extBrowserSpecified then
  begin
    ShellExecute(Handle, 'open', PChar(Config.extBrowserPath), PChar(URI), nil, SW_SHOW);
  end
  else begin
    ShellExecute(Handle, 'open', PChar(URI), nil, nil, SW_SHOW);
  end;
end;

procedure TMainWnd.WriteStatus(const s: string);
begin
  StatusBar.Panels.Items[1].Text := s;
end;

(* 確認ダイアログ デフォルトで「キャンセル」を選択 (aiai) *)
function TMainwnd.MyMessageDlg(messageLabel: String): Word;
var
  dlg: TForm;
begin
  MessageBeep(MB_ICONEXCLAMATION);    //SystemExclamation
  dlg := CreateMessageDialog(#13#10 + messageLabel, mtConfirmation, mbOKCancel);
  dlg.ActiveControl := TWinControl(dlg.FindComponent('Cancel'));
  result := dlg.ShowModal;
  dlg.Free;
end;

procedure TMainWnd.SetCaption(const BoardName: string);
var
  board, offline: string;
begin
  boardNameOfCaption := BoardName;
  board := '';
  offline := '';
  if 0 < length(BoardName) then
    board := ' 【' + BoardName + '】';
  if not Config.netOnline then
    offline := ' 《オフライン》';
  Caption := Jane2ch + board + offline;
end;

procedure TMainWnd.ON_WM_SYSCOMMAND(var msg: TWMSysCommand);
begin
  case Msg.CmdType of
  MENU_ID_ABOUT: OnAbout;
  MENU_ID_DUMP_KEYS: SaveKeyConf;
  MENU_ID_MENUTOGGLE: MenuViewMenuToggleVisibleClick(Self);
  end;
  inherited;
end;

(* 9 Feb. 2002 by 816=817 *)
(* キーボード設定を読込む *)
(* 第３階層があったので再帰に変更させていただきました 10 Feb. 2002 Twiddle *)
procedure TMainWnd.KeyConf;
var
  ini: TMemIniFile;
  procedure LoadKeyConfRecursive(item: TMenuItem);
  var
    key, caption: String; j: integer;
  begin
    key := ini.ReadString('KEY',item.Name,'');
    if key <> '' then
    begin
      item.ShortCut := TextToShortCut(key);
      //▼by ◆816/bwNEさん
      //>TextToShortCutの仕様では割り当て不能なキーがあるので…
      //>２桁以上の数値が指定されたらキーコード直接指定と見なしてみるテスト
      if item.ShortCut = 0 then
      try
        if length(key) > 1 then
          item.ShortCut := StrToInt(key);
      except
      end;
    end;
    caption := ini.ReadString('CAPTION',item.Name,'');
    if caption <> '' then
    begin
      item.Caption := caption;
    end;
    for j := 0 to item.Count -1 do
    begin
      LoadKeyConfRecursive(item.Items[j]);
    end;
  end;
var
  inifile: String;
  i: integer;
begin
  inifile := Config.BasePath + KEYCONF_FILE;
  if not FileExists(inifile) then
    exit;
  ini := TMemIniFile.Create(inifile);
  for i := 0 to MainMenu.Items.Count -1 do
  begin
    LoadKeyConfRecursive(MainMenu.Items[i]);
  end;
  ini.Free;

  //まずいショートカット割り当ての削除
  for i := 0 to SystemKey.Count -3 do
  begin
    if SystemKey.Items[i].ShortCut = SystemKey.Items[i].Tag then
      SystemKey.Items[i].ShortCut := 0;
  end;
  if SysCtrlHome.ShortCut = 16420 {TextToShortCut('^Home')} then
    SysCtrlHome.ShortCut := 0;
  if SysCtrlEnd.ShortCut = 16419 {TextToShortCut('^End')} then
    SysCtrlEnd.ShortCut := 0;
end;

(* サンプル用にキーボード設定を保存する *)
procedure TMainWnd.SaveKeyConf;
var
  ini: TMemIniFile;
  procedure SaveKeyRecursive(item: TMenuItem);
  var
    i: integer;
  begin
    if (item.Caption <> '-') and (item.Name <> '') and
       (item.Visible or item.Enabled) then
    begin
      if StrToIntDef(ini.ReadString('KEY', item.Name, ''), 0) < 10 then
        ini.WriteString('KEY', item.Name, ShortCutToText(item.ShortCut));
      ini.WriteString('CAPTION', item.Name, item.Caption);
    end;
    for i := 0 to item.Count -1 do
      SaveKeyRecursive(item.Items[i]);
  end;
var
  i: integer;
  fileName: string;
begin
  ini := nil;
  fileName := Config.BasePath + KEYCONF_FILE;
  ini := TMemIniFile.Create(fileName);
  for i := 0 to MainMenu.Items.Count -1 do
    SaveKeyRecursive(MainMenu.Items[i]);
  if WriteForm = nil then
    WriteForm := TWriteForm.Create(Self);
  with WriteForm.ActionList do
  begin
    for i := 0 to ActionCount -1 do
      if StrToIntDef(ini.ReadString('KEY', Actions[i].Name, ''), 0) < 10 then
        ini.WriteString('KEY', Actions[i].Name, ShortCutToText(TAction(Actions[i]).ShortCut));
  end;
  ini.UpdateFile;
  Log('ショートカット設定を ' + fileName + ' に保存しました');
  ini.Free;
end;


procedure TMainWnd.LoadSkin(skinPath: string);
var
  toolbarResized: boolean;

  (* 各ボタンをカスタマイズ *)
  procedure LoadCustomToolBarConf(str: string; parent: TToolBar);
    function FindCommandMenu(parent: TMenuItem; number: integer): TMenuItem;
    var
      i: integer;
    begin
      result := nil;
      for i := parent.Count -1 downto 0 do
      begin
        if parent.Items[i].Tag = number -1 then
          result := parent.Items[i]
        else if (parent.Count > 0) and (number > parent.Items[i].Tag) then
          result := FindCommandMenu(parent.Items[i], number);
        if result <> nil then
          exit;
      end;
    end;
  var
    Button: TToolbutton;
    idx, j: Integer;
    item : TMenuItem;
  begin
    (* セパレータ *)
    if str = '-' then
    begin
      Button := TToolbutton.Create(parent);
      Button.Parent := parent;
      Button.Style := tbsSeparator;
      Button.Width := 8;
      exit;
    end;

    j := Pos(',', str);
    if j < 0 then
      exit;
    try
      idx := StrToInt(RightStr(str, Length(str) - j));
      str := LeftStr(str, j-1);
      item := FindComponent(str) as TMenuItem;
      if (item = nil) and AnsiStartsText('MenuCommand', str) then
        item := FindCommandMenu(MenuCommand, StrToInt(copy(str, 12, 2)));
    except
      exit;
    end;
    if item = nil then
        exit;

    (* 通常ボタン *)
    Button := TToolbutton.Create(parent);
    Button.Parent := parent;
    //Button.Style := tbsButton;
    if item.Action <> nil then
    begin
      Button.Action := item.Action;
      if item.Action = actAddFavorite then
      begin
        Button.Style := tbsDropDown;
        Button.DropdownMenu := PopupAddFavorite;
      end;
    end
    else begin
      Button.MenuItem := item;
    end;
    Button.Hint := item.Caption;
    Button.ImageIndex := idx;
    Button.Enabled := true;
  end;

  (* ツールバーをカスタマイズ *)
  procedure CreateToolBar(toolbar: TToolBar; datfile: string);
  var
    i: integer;
    list: TStrings;
  begin
    if not FileExists(datfile) then
      exit;
    toolbar.Visible := false;
    for i := 0 to toolbar.ButtonCount -1 do
    begin
      if toolbar.Buttons[i].Name <> '' then //最初からあるボタン
        toolbar.Buttons[i].Visible := false
      else
        toolbar.Buttons[i].Free;
    end;
    list := TStringList.Create;
    list.LoadFromFile(datfile);
    for i := list.Count - 1 downto 0 do
      LoadCustomToolBarConf(list.Strings[i], toolbar);
    list.Free;
    if toolbar = ThreadToolBar then
      toolbarResized := true;
    toolbar.Visible := true;
  end;

  //※[457]
  procedure LoadCustomImageListSub(const path: string; var ImageList: TImageList);
  var
    bmpl, bmps: TBitmap;
    size, i, j: Integer;
  begin
    if not FileExists(path) then
      exit;
    bmpl := TBitmap.Create;
    bmpl.LoadFromFile(path);
    size := bmpl.Height;
    bmps := TBitmap.Create;
    bmps.Height := size;
    bmps.Width := size;
    ImageList.Clear;
    ImageList.Height := size;
    ImageList.Width := size;
    j := 0;
    for i := 0 to bmpl.width div size - 1 do
    begin
      BitBlt(bmps.Canvas.Handle,0,0,size,size,bmpl.Canvas.Handle,j,0,SRCCOPY);
      ImageList.AddMasked(bmps, clFuchsia);
      j := j + size;
    end;
    bmpl.Free;
    bmps.Free;
    //FileLoadでまとめ読めしようとすると色化け(´･ω･`)ｼｮﾎﾞｰﾝ
    //ListImages.FileLoad(rtBitmap, Config.BasePath + 'listimg.bmp', clFuchsia);
    if ImageList = ThreadToolImages then
      toolbarResized := true;
  end;

  //※[457]
  procedure LoadCustomImageList;
  begin
    LoadCustomImageListSub(skinPath + 'listimg.bmp', ListImages);
    LoadCustomImageListSub(skinPath + 'ttoolimg.bmp', ThreadToolImages);
    LoadCustomImageListSub(skinPath + 'mtoolimg.bmp', MainToolImages);
    LoadCustomImageListSub(skinPath + 'memoimg.bmp', MemoImageList);
    LoadCustomImageListSub(skinPath + 'searchimg.bmp', SearchImages);
  end;

  (* 新しいボタン数とアイコンサイズにツールバーをあわせる *)
  procedure ThreadToolBarResize;
  var
    i: integer;
  begin
    ThreadToolBar.Visible := false;
    ThreadToolBar.ButtonHeight := ThreadToolImages.Height;
    ThreadToolBar.ButtonWidth  := ThreadToolImages.Width;
    ThreadToolBar.Width := 0;
    for  i := 0 to ThreadToolBar.ButtonCount -1 do
      if ThreadToolBar.Buttons[i].Visible then
        ThreadToolBar.Width := ThreadToolBar.Width + ThreadToolBar.Buttons[i].Width;
    ThreadToolBar.Visible := true;
    ThreadToolPanel.Height := ThreadToolBar.ButtonHeight;
  end;

  //
  // TMainWndのPrivateメソッドでしたがここでしか使われていないので移動しました
  // by aiai
  //
  (* 何だこれは。まあいいか *)
  procedure LoadString(const fname: string; var str: string);
  var
    pss: TPSStream;
  begin
    pss := TPSStream.Create('');
    try
      pss.LoadFromFile(fname);
      str := pss.DataString;
    except
    end;
    pss.Free;
  end;

var
  Skin: TSkinCollection;
  ini: TMemIniFile;
  i: integer;
  SectionList: TStringList;
  MenuItem: TMenuItem;
  HeaderHTML: string;
  RecHTML: string;
  NewRecHTML: string;
  PopupRecHTML: string;
  BookMarkHTML: string;
  NewMarkHTML: string;
begin
  SkinCollectionList := TSkinCollectionList.Create;

  Skin := TSkinCollection.Create;

  HeaderHTML := DEF_HEADER_HTML;
  RecHTML    := DEF_REC_HTML;
  NewRecHTML := DEF_NEWREC_HTML;
  BookMarkHTML := DEF_BOOKMARK_HTML;
  NewMarkHTML  := DEF_NEWMARK_HTML;
  LoadString(skinPath + HTML_HEADER_TEMPLATE, HeaderHTML);
  LoadString(skinPath + HTML_BODY_TEMPLATE, RecHTML);
  LoadString(skinPath + HTML_NEWBODY_TEMPLATE, NewRecHTML);
  LoadString(skinPath + HTML_BOOKMARK_TEMPLATE, BookMarkHTML);
  LoadString(skinPath + HTML_NEWMARK_TEMPLATE, NewMarkHTML);
  PopupRecHTML := RecHTML;
  LoadString(skinPath + HTML_POPUP_TEMPLATE, PopupRecHTML);

  Skin.HeaderHTML := HeaderHTML;
  Skin.RecHTML := RecHTML;
  Skin.NewRecHTML := NewRecHTML;
  Skin.BookMarkHTML := BookMarkHTML;
  Skin.NewMarkHTML := NewMarkHTML;
  Skin.PopupRecHTML := PopupRecHTML;

  SkinCollectionList.Add(Skin);

  (* カスタムスキン *)
  if FileExists(Config.SkinPath + 'CustomSkin.ini') then
  begin
    ini := TMemIniFile.Create(Config.SkinPath + 'CustomSkin.ini');
    SectionList := TStringList.Create;
    ini.ReadSections(SectionList);
    for i := 0 to SectionList.Count - 1 do
    begin
      Skin := TSkinCollection.Create;
      Skin.Section := SectionList.Strings[i];
      Skin.HeaderHTML := ini.ReadString(SectionList.Strings[i], 'Header', HeaderHTML);
      Skin.RecHTML := ini.ReadString(SectionList.Strings[i], 'Res', RecHTML);
      Skin.NewRecHTML := ini.ReadString(SectionList.Strings[i], 'NewRes', NewRecHTML);
      Skin.BookMarkHTML := ini.ReadString(SectionList.Strings[i], 'BookMark', BookMarkHTML);
      Skin.NewMarkHTML := ini.ReadString(SectionList.Strings[i], 'NewMark', NewMarkHTML);
      Skin.PopupRecHTML := ini.ReadString(SectionList.Strings[i], 'PopupRes', PopupRecHTML);
      SkinCollectionList.Add(Skin);
      MenuItem := TMenuItem.Create(PopupTreeSetCustomSkin);
      MenuItem.Caption := SectionList.Strings[i];
      MenuItem.Tag := i + 1;
      MenuItem.GroupIndex := 1;
      MenuItem.RadioItem := True;
      PopupTreeSetCustomSkin.Add(MenuItem);
      MenuItem.OnClick := PopupTreeCustomSkinClick;
    end;
    SectionList.Free;
    ini.Free;
  end;

  LoadCustomImageList;
  CreateToolBar(ToolBarMain, skinPath + 'mtoolbar.txt');
  CreateToolBar(ThreadToolBar, skinPath + 'ttoolbar.txt');

  ThreadToolBarResize;
end;

procedure TMainWnd.SetCustomSkinToBoard;
var
  boardlist: TStringList;
  i, j: integer;
  str, uri, section: string;
  board: TBoard;
  host, bbs, datnum: string;
  startIndex, endIndex: integer;
  oldLog: Boolean;
begin
  if (SkinCollectionList.Count <= 1) //必ずデフォルトのスキンがある
    or not FileExists(Config.SkinPath + 'BoardToSkin.ini') then
    exit;
  boardlist := TStringList.Create;
  try
    boardlist.LoadFromFile(Config.SkinPath + 'BoardToSkin.ini');
  except
    boardlist.Free;
    exit;
  end;
  for i := 0 to boardlist.Count - 1 do
  begin
    str := boardlist.Strings[i];
    if length(str) <= 0 then
      continue;
    uri := boardlist.Names[i];
    if uri[length(uri)] <> '/' then
      uri := uri + '/';
    Get2chInfo(uri, host, bbs, datnum, startIndex, endIndex, oldLog);
    board := i2ch.FindBoard(host, bbs);
    if board = nil then
      continue;
    section := boardlist.Values[boardlist.Names[i]];
    if length(section) <= 0 then
      continue;
    for j := 1 to SkinCollectionList.Count - 1 do
    begin
      if AnsiSameText(section, TSkinCollection(SkinCollectionList.Items[j]).Section) then
      begin
        board.CustomSkinIndex := j;
        continue;
      end;
    end;
  end;
  boardlist.Free;
end;



//※[457](TMainWnd.OnCreateから外に出した)
procedure TMainWnd.SetupNGWords;
{beginner} //(寿命管理など)
  procedure SetupNGStringList(words: TBaseNGStringList; fname: string; num:Integer);
  begin
    if FileExists(Config.BasePath + fname) then begin
      words.LoadFromFile(Config.BasePath + fname);
      words.CheckLifeSpan(config.viewNGLifeSpan[num]);
    end;
    //try
    //  words.LoadFromFile(Config.BasePath + fname);
    //except
    //end;
    //words.CheckLifeSpan(config.viewNGLifeSpan[num]);
//２ちゃんねるブラウザ「OpenJane」改造総合スレ9
//http://jane.cun.jp/test/read.cgi/win/1064951726/342

    words.SaveToFile(Config.BasePath + fname);
  end;
  procedure SetupBMSearch(words: TNGStringList; IgnoreCase: Boolean);
  var
    i: Integer;
    bms: TBMSearch;
  begin
    for i := 0 to words.Count -1 do begin
      bms := TBMSearch.Create;
      bms.IgnoreCase := IgnoreCase;
      bms.Subject := words[i];
      words.NGData[i].BMSearch.Free;
      words.NGData[i].BMSearch := bms;
    end;
  end;
var
  i: TNGItemIdent;
  j: Integer;
begin
  for i := low(TNGItemIdent) to High(TNGItemIdent) do begin
    SetupNGStringList(NGItems[i], NG_FILE[i], Ord(i));
    SetupBMSearch(NGItems[i], (i <> NG_ITEM_ID));
  end;

  SetupNGStringList(ExNGList, NG_EX_FILE, Ord(High(TNGItemIdent)) + 1);
  for j := 0 to ExNGList.Count - 1 do
    ExNGList.NGData[j].MakeSearchObj;

  {aiai}
  SetupNGStringList(ThreNGList, NG_THREAD_FILE, Ord(High(TNGItemIdent)) + 2);
  SetupBMSearch(ThreNGList, true);
  {/aiai}

{/beginner}
end;

{beginner} //トレース画面の場所を設定する
procedure TMainWnd.SetTracePosition;
begin
  if Config.stlSmallLogPanel then begin
    if Config.stlLogPanelUnderThread then begin
      if Config.stlVerticalDivision then begin
        LogSplitter.Parent:=ListViewPanel;
        LogPanel.Parent:=ListViewPanel;
      end else begin
        LogSplitter.Parent:=Panel2;
        LogPanel.Parent:=Panel2;
      end;
    end else begin
      LogSplitter.Parent:=TreePanel;
      LogPanel.Parent:=TreePanel;
      Panel9.BringToFront;
      PanelTreeTitle.BringToFront;
    end;
  end else begin
    LogSplitter.Parent:=Panel0;
    LogPanel.Parent:=Panel0;
  end;
  LogPanel.Top := LogPanel.Parent.BoundsRect.Bottom - LogPanel.Height + 1;
  LogSplitter.Top := LogPanel.Top - LogSplitter.Height + 1;
end;
{/beginner}

(* フォーム生成時 *)
procedure TMainWnd.FormCreate(Sender: TObject);
  procedure AddAboutMenu;
  var
    hSysMenu: integer;
  begin
    hSysMenu := GetSystemMenu(Handle, False);
    AppendMenu(hSysMenu, MF_SEPARATOR, 0, nil);
    AppendMenu(hSysMenu, MF_STRING, MENU_ID_MENUTOGGLE, 'メニューの表示(&V)');
    //AppendMenu(hSysMenu, MF_STRING, MENU_ID_ABOUT, '&About...');
    //AppendMenu(hSysMenu, MF_SEPARATOR, 0, nil);
    //AppendMenu(hSysMenu, MF_STRING, MENU_ID_DUMP_KEYS, '&Dump shortcuts');
  end;

  //※[457]
  procedure AddLinkToFavorites;
  var
    fav: TFavoriteList;
    i: Integer;
  begin
    for i := 0 to favorites.Count - 1 do
    begin
      if favorites.Items[i].name = 'リンク' then
        exit;
    end;
    fav := TFavoriteList.Create(favorites);
    fav.name := 'リンク';
    favorites.Insert(0, fav);
  end;

var
  boardLoaded: boolean;
  TimeZoneInfo: _TIME_ZONE_INFORMATION;
  font: TFont;
  wnd: HWND;
  p: Pointer;
  dlg: TGetBoardListForm; //aiai
  error: Boolean;  //aiai
begin
  error := false;
  {$IFDEF BENCH}
  InitBench;
  {$ENDIF}
  MyWindowHandle := nil;
  try
    MyWindowHandle
        := THogeSharedMem.Create(sharedResourceName + WND_SUFFIX, SizeOf(wnd));
    p := MyWindowHandle.Memory;
    Move(wnd, p^, SizeOf(wnd));
  except
  end;

  Randomize;
  GetTimeZoneInformation(TimeZoneInfo);
  TimeZoneBias := TimeZoneInfo.Bias * 60;
  daemon := TDaemon.Create;
  currentSortColumn := 1;

  currentView := nil;

  (*  *)
  AddAboutMenu;

  TabSwitchList := TList.Create;
  TabSwitchList.Add(TreeView);
  TabSwitchList.Add(FavoriteView);
  TabSwitchList.Add(ListView);
  //TabSwitchList.Add(TabControl);
  TabSwitchList.Add(nil);
  TabSwitchList.Add(Memo);

  Application.UpdateFormatSettings := false;

  PopupHint := TImageHint.Create(Self); //Font,Color設定のため前に移動

  (* コンフィグレーション *)
  Config := TJaneConfig.Create;
  Config.Load;

  (* DataBase (aiai) *)
  if Config.ojvQuickMerge then
  begin
    if not FileExists(Config.BasePath + SQLITE_DLL_NAME) then
    begin
      MessageBox(Handle, SQLITE_DLL_NAME + ' が見つからなかったため、このアプリケーションを開始できませんでした。アプリケーションをインストールし直すとこの問題は解決される場合があります。', 'Jane2ch.exe - コンポーネントが見つかりません', MB_ICONERROR or MB_OK);
      Application.Terminate;
      Application.ShowMainForm := false;
      if initialURL <> nil then
        FreeAndNil(Main.initialURL);
      error := true;
    end;
    if not Initdll then
    begin
      MessageBox(Handle, SQLITE_DLL_NAME + ' の初期化に失敗したため、このアプリケーションを開始できませんでした。アプリケーションをインストールし直すとこの問題は解決される場合があります。', 'Jane2ch.exe - dllを初期化できません', MB_ICONERROR or MB_OK);
      Application.Terminate;
      Application.ShowMainForm := false;
      if initialURL <> nil then
        FreeAndNil(Main.initialURL);
      error := true;
    end;
  end;
  (* //DataBase *)

  UDat2HTML.ABONE := Config.viewNGMsgMarker;

  AsyncInitialize;
  AsyncUpdateConfig;

  timeValue := UTC;

  (* フォント *)  //fontを使いまわす by aiai
  font := TFont.Create;
  if Config.viewDefFontInfo.face <> '' then
  begin
    Config.SetFont(font, Config.viewDefFontInfo);
    Self.Font.Assign(font);
    StatusBar.Font.Assign(font);
    TabControl.Font.Assign(font);
    ListTabControl.Font.Assign(font);
    TreeTabControl.Font.Assign(font);
  end;
  if Config.viewTreeFontInfo.face <> '' then
  begin
    Config.SetFont(font, Config.viewTreeFontInfo);
    TreeView.Font.Assign(font);
    FavoriteView.Font.Assign(font);
  end;
  if Config.viewTraceFontInfo.face <> '' then
  begin
    Config.SetFont(font, Config.viewTraceFontInfo);
    Memo.Font.Assign(font);
  end;
  //▼スレ覧のフォントを独立に設定
  if Config.viewTraceFontInfo.face <> '' then
  begin
    Config.SetFont(font, Config.viewListFontInfo);
    ListView.Font.Assign(font);
  end;
  //※[457]
  if Config.viewThreadTitleFontInfo.face <> '' then
  begin
    Config.SetFont(font, Config.viewThreadTitleFontInfo);
    ThreadTitleLabel.Font.Assign(font);
  end;
  {beginner}
  if Config.viewHintFontInfo.face <> '' then
  begin
    Config.SetFont(font, Config.viewHintFontInfo);
    PopupHint.Font.Assign(font);
    PopupHint.Canvas.Font.Assign(font);
  end else
  begin
    PopupHint.Font := Screen.HintFont;
    PopupHint.Canvas.Font := Screen.HintFont;
  end;
  font.Free;
  SetCaption('');

  //Memo.TabStop := Config.oprTabStopOnTracePane;

  //▼コマンドの読み込みとメニューの作成
  CommandCreate;

  (* Window位置復元はOnShowでやる *)
  //LoadWindowPos;
  KeyConf; (* 9 Feb. 2002 by 816=817 *)

  {beginner}
//SetMouseGesture;
  Application.HintHidePause:=30000;
  AlreadySetMouseGesture:=False;
  {/beginner}

  (* スレ一覧 *)
  subjectReadyEvent := THogeEvent.Create;
  boardList := TBoardList.Create;


  (* ビューア設定 *)
  LoadSkin(Config.SkinPath);

  NGItems[NG_ITEM_NAME] := TNGStringList.Create;
  NGItems[NG_ITEM_MAIL] := TNGStringList.Create;
  NGItems[NG_ITEM_MSG ] := TNGStringList.Create;
  NGItems[NG_ITEM_ID  ] := TNGStringList.Create;
  ExNGList := TExNGList.Create;
  ThreNGList := TNGStringList.Create;  //aiai

  SetupNGWords;

  ThreAboneLevel := Config.viewThreAboneLevel; //スレッドあぼ～ん表示レベルの初期設定 by aiai
  AboneLevel := Config.viewAboneLevel;  //あぼーん表示レベルの初期設定

  {aiai}
  case ThreAboneLevel of
   -1: actThreadAboneTranseparency.Checked := True;
    0: actThreadAboneNormal.Checked := True;
    1: actThreadAboneIgnore.Checked := True;
  end;
  {/aiai}
  {beginner}
  case AboneLevel of
    -1 :actTransparencyAbone.Checked:=True;
     0 :actNormalAbone.Checked:=True;
     1 :actHalfAbone.Checked:=True;
     2 :actIgnoreAbone.Checked:=True;
     3 :actImportantResOnly.Checked:=True;
  end;
  {/beginner}

  (* ヒント *)
  urlHeadCache := TUrlHeadCache.Create;
  Application.OnDeactivate := AppDeactivate; (* ヘンなタイミングでのポップアップ対策 *)
  HintTimer.Interval := Config.hintForURLWaitTime;
  popupviewList := TPopupViewList.Create;
  popupviewList.OnChange := PopupViewListChange;

  (* 非同期取得 *)
  AsyncManager := TAsyncManager.Create;
  procGetSubject := nil;

  (* ビューアのリスト（予定） *)
  viewList := TViewList.Create;
  viewListLock:= THogeMutex.Create();

  FRecentlyClosedThreads := TStringList.Create;

  (*  *)
  SetZoomState(Config.viewZoomSize);

  (* ボード＝スレ一覧 *)
  currentBoard  := nil;
  requestingBoard     := nil;

  (*  *)
  SetTracePosition; //トレース画面の場所を設定する

  {ayaya}
  (* トレース画面データ読み込み *)
  LoadTraceString();
  Log2(7, '');
  Log2(8, '');
  {/ayaya}

 {Log('（･∀･）ｺｺﾊ ﾄﾚｰｽｶﾞﾒｰﾝ!!');
  Log('(ﾟДﾟ)　＜ﾃﾞﾊﾞｯｸﾞ用');}

  (* お気に入り *)
  favorites := TFavorites.Create;
  favorites.name := 'お気に入り';
  if not favorites.Load(Config.BasePath + FAVORITES_DAT) then
  begin
    Application.Terminate;
    Application.ShowMainForm := false;
    if initialURL <> nil then
      FreeAndNil(Main.initialURL);
    exit;
  end;

  //※[457]リンクバー表示でリンクフォルダがなければ作る
  if Config.stlLinkBarVisible then
    AddLinkToFavorites;
  UpdateFavorites;

  (* ボード一覧読込み *)
  //▼ログフォルダ指定
  i2ch := TCategoryList.Create(Config.LogBasePath);
  boardLoaded := i2ch.Load;

  SetCustomSkinToBoard;  //aiai

  UpdateTreeView;

  //UpdateBoardMenu;
  (* aiai 板覧メニューへの板一覧の展開は板一覧を表示するときにする*)

  //UpdateFavoritesMenu;
  SetStyle;

  //※[457]
  FavoriteListBoardAdmin := TFavoriteListBoardAdmin.Create(i2ch.Items[0]);

  UILock := False;

  if not boardLoaded then
  begin
    {aiai}
    Log2(9, '');
    dlg := TGetBoardListForm.Create(self);
    if dlg.ShowModal = mrOK then
    begin
      Log2(10, '');
      GetBoard2ch(Self);
    end;
    dlg.Free;
    {/aiai}
  end;

  SetPaneType(Config.oprToggleRView);
  if not Config.stlToolBarVisible then
    MenuViewToolBarToggleVisibleClick(Self);
  if not Config.stlLinkBarVisible then
    MenuViewLinkBarToggleVisibleClick(Self);
  if not Config.stlAddressBarVisible then
    MenuViewAddressBarToggleVisibleClick(Self);

  actOnline.Checked := Config.netOnline;
  if actOnline.Checked then
    OnlineButton.ImageIndex := 12
  else
    OnlineButton.ImageIndex := 13;
  actLogin.Checked := Config.tstAuthorizedAccess;
  actLogin.Enabled := (Config.accUserID <> '') and (Config.accPasswd <> '');

  WebPanel.DoubleBuffered := True;
  MDIClientPanel.DoubleBuffered := True;
  Panel3.DoubleBuffered := True;
  TabPanel.DoubleBuffered := True;
  TabControl.DoubleBuffered := True;
  Panel9.DoubleBuffered := True;
  //Panel1.DoubleBuffered := True;
  //Panel2.DoubleBuffered := True;
  //ListViewPanel.DoubleBuffered := True;
  //ListView.SmartoubleBuffered := True;
  //LogPanel.DoubleBuffered := True;

  {aiai}
  if Config.schEnableMigemo then
  begin
    InitMigemo;  //Migemo初期化
  end;
  SearchSetSearch(Config.schDefaultSearch, ListViewSearchEditBox, ListViewSearchToolButton);
  SearchSetSearch(Config.schDefaultSearch, TreeViewSearchEditBox, TreeViewSearchToolButton);
  SearchSetSearch(Config.schDefaultSearch, ThreViewSearchEditBox, ThreViewSearchToolButton);
  ListViewSearchToolBar.Visible := Config.schShowListToolbarOnStartup;
  ThreViewSearchToolBar.Visible := Config.schShowToolbarOnStartup;
  TreeViewSearchToolBar.Visible := Config.schShowTreeToolbarOnStartup;
//  ListViewSearchEditBox.Items := Config.grepSearchList;
//  ThreViewSearchEditBox.Items := Config.grepSearchList;
//  TreeViewSearchEditBox.Items := Config.grepSearchList;

  (* WriteWaitTimer *)
  WriteWaitTimer := TWriteWaitTimer.Create;
  WriteWaitTimer.OnNotify := WriteWaitTimerNotify;
  WriteWaitTimer.OnEnd := WriteWaitTimerEnd;

  (* メモ欄のセットアップ *)
  WritePanelControl := TWritePanelControl.Create;
  With WritePanelControl do
  begin
    EditNameBox := ComboboxWriteName;
    EditMailBox := ComboBoxWriteMail;
    Memo := MemoWriteMain;
    SettingTxt := MemoWriteSettingTxt;
    Result := MemoWriteResult;
    PageControl := PageControlWrite;
    WStatusBar := StatusBarWrite;
    ButtonWrite := ButtonWriteWrite;
    CheckBoxSage := CheckBoxWriteSage;
    SetUp;
    SetAAList;
  end;
  {/aiai}

  if not error then
    OpenStartupThread;
  UpdateTabTexts;

  userImeMode := imDontCare;

  {aiai}
  MenuOptUseNews.Checked := Config.tstUseNews;
  CreateNewsBar;
  {/aiai}

//  Application.OnMessage := Self.OnMessage;
end;

procedure TMainWnd.FormShow(Sender: TObject);
var
  i: integer;
begin
  {beginner}
  if not AlreadySetMouseGesture then begin
    SetMouseGesture;
    AlreadySetMouseGesture:=True;
  end;
  {/beginner}

  if TrayIcon.Visible then
    TrayIcon.Hide
  else begin
    LoadWindowPos;

    if viewList.Count > 0 then
    begin
      //スタートアップで開いたスレのちらつき回避用
      for i := 0 to viewList.Count -1 do
        viewList.Items[i].browser.Visible := true;
      SetCurrentView(0);
      SetRPane(ptView);
    end else
      SetRPane(ptList);

    CanAutoCheckNewRes := True;  //aiai

    try
      DebugTmp.Visible := Config.tstDebugEnabled;
      DebugTmp.Enabled := Config.tstDebugEnabled;
    except
    end;
  end;
end;

//▼保存処理を移行
procedure TMainWnd.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: integer;
begin
  CanClose := true;
  try
    ReleasePopupHint(nil, True);
    (* Window位置保存 *)
    SaveWindowPos;

    if Config.Modified then
      Config.Save;

    SaveLastThread;
    SaveTreeViewState;
    //SaveListViewState;
    SaveFavorites;
    for i := 0 to viewList.Count -1 do
      viewList.Items[i].FreeThread;
    SaveListViewState;

    //書き込みフォームの位置保存 (beginner氏)
    if Assigned(WriteForm) then
      Config.SaveWriteFormPos(WriteForm.SavedBoundsRect);
    //aiai AAエディタフォームの位置保存
    if Assigned(AAForm) then
      Config.SaveAAFormPos(AAForm.SavedBoundsRect);
    //aiai LovelyBrowserの位置保存
    if Assigned(LovelyWebForm) then
      Config.SaveLovelyFormPos(LovelyWebForm.SavedBoundsRect);
    //aiai ChottoFormの位置保存
    if Assigned(ChottoForm) then
      Config.SaveChottoFormPos(ChottoForm.SavedBoundsRect);
  except
    if MessageDlg('設定の保存に失敗しました', mtError, mbAbortIgnore, 0) = mrAbort then
      CanClose := false;
  end;
end;

(* フォーム破棄 *)
procedure TMainWnd.FormDestroy(Sender: TObject);
var
  i: TNGItemIdent;
  j: integer;
begin
  for j := 0 to SkinCollectionList.Count - 1 do
    TSkinCollection(SkinCollectionList.Items[j]).Free;
  SkinCollectionList.Free;

  UILock := True;
  {aiai}
  MyNews.Free;
  WritePanelControl.Free;
  WriteWaitTimer.Free;
  {/aiai}

  {beginner}
  if MenuWatchClipboard.Checked then
    MenuWatchClipboardClick(nil);
  {/beginner}

//  Application.OnMessage := nil;
  if MyWindowHandle <> nil then
    MyWindowHandle.Free;

  (* バックグラウンド処理を強制終了 *)
  AsyncManager.WaitForTerminateAll;
  AsyncManager.Free;
  AsyncUninitialize;

  if Assigned(WriteForm) then
    WriteForm.Close;

  {aiai}
  if Assigned(LovelyWebForm) then
    LovelyWebForm.Close;

  if Assigned(ImageViewCacheListForm) then
    ImageViewCacheListForm.Close;
  {/aiai}

  daemon.Terminate;
  daemon.Log('');
  daemon.WaitFor;
  daemon.Free;

  viewListLock.Free;
  viewList.Free;
  viewList := nil;
  popupviewList.Free;

  {beginner}
  for i := Low(TNGItemIdent) to High(TNGItemIdent) do begin
    NGItems[i].SaveToFile(config.basepath + NG_FILE[i]);
    NGItems[i].FreeItems;
    NGItems[i].Free;
  end;
  {/beginner}

  {aiai}
  ThreNGList.SaveToFile(Config.BasePath + NG_THREAD_FILE);
  ThreNGList.FreeItems;
  ThreNGList.Free;
  {/aiai}

  {ゐ}
  ExNGList.SaveToFile(config.basepath + NG_EX_FILE);
  ExNGList.FreeItems;
  ExNGList.Free;
  {/ゐ}

  PopupHint.Free;
  FRecentlyClosedThreads.Free;

//  SaveFavorites;
  favorites.Free;

  urlHeadCache.Free;

  //※[457]後始末
  FavoriteListBoardAdmin.Free; // i2chより先
  boardList.Free;

  i2ch.Free;
  Config.Free;

  HogeMutex.Free;
  subjectReadyEvent.Free;
  TabSwitchList.Free;

  {aiai}
  if Assigned(AutoReload) then
    AutoReload.Free;
  if Assigned(AutoScroll) then
    AutoScroll.Free;

  (* DataBase *)
  if Config.ojvQuickMerge then
    Finaldll;
  (* //DataBase *)
  if Config.schEnableMigemo then
    MigemoOBJ.Free;
  {/aiai}
end;


(* ログ表示 *)
procedure TMainWnd.WriteLog(const str: string);
var
  txt: String;
  SelPos: Integer;
begin
  while 256 <= Memo.Lines.Count do
  begin
    memo.SelStart := 0;
    memo.SelLength := SendMessage(Memo.Handle, EM_LINEINDEX, 96, 0);
    memo.SelText := '';
  end;
  if 0 < Memo.Lines.Count then
    txt := #13#10 + str
  else
    txt := str;
  SelPos := SendMessage(Memo.Handle, WM_GETTEXTLENGTH, 0, 0);
  SendMessage(Memo.Handle, EM_SETSEL, SelPos, SelPos);
  SendMessage(Memo.Handle, EM_REPLACESEL, 0, Longint(PChar(txt)));
  SendMessage(Memo.Handle, EM_SETSEL, SelPos, SelPos);
  Memo.SelStart := SelPos;
  Memo.SelLength := 0;
  //StatusBar.Panels.Items[2].Text := str;
end;


(* ウィンドウ位置保存 *)
procedure TMainWnd.SaveWindowPos;
var
  iniFile: TMemIniFile;
  i: integer;
  Placement: TWindowPlacement;
  R: PRect;
  wh: TWidthHeight;
begin
  //※[JS] 通常時のウィンドウ位置とサイズを取得
  Placement.length := SizeOf(Placement);
  R := @Placement.rcNormalPosition;
  GetWindowPlacement(Self.Handle, @Placement);

  iniFile := TMemIniFile.Create(Config.IniPath);

  (* MainWindow *)
  if Monitor.Primary then begin
    iniFile.WriteInteger(INI_WIN_SECT, 'Top',
            R^.Top + Monitor.WorkareaRect.Top);
    iniFile.WriteInteger(INI_WIN_SECT, 'Left',
            R^.Left + Monitor.WorkareaRect.Left);
  end else begin
    iniFile.WriteInteger(INI_WIN_SECT, 'Top',   R^.Top);
    iniFile.WriteInteger(INI_WIN_SECT, 'Left',  R^.Left);
  end;
  iniFile.WriteInteger(INI_WIN_SECT, 'Width', R^.Right - R^.Left);
  iniFile.WriteInteger(INI_WIN_SECT, 'Height',R^.Bottom - R^.Top);
  iniFile.WriteInteger(INI_WIN_SECT, 'WindowState', Ord(WindowState)); //※[JS]

  (* LogArea *)
  iniFile.WriteInteger(INI_WIN_SECT, 'LogTop', LogPanel.Top);
  iniFile.WriteInteger(INI_WIN_SECT, 'LogHeight', LogPanel.Height);

  (* TreeView / board list *)
  {aiai}
  iniFile.WriteInteger(INI_WIN_SECT, 'TreeTab', TreeTabControl.TabIndex);
  iniFile.WriteBool(INI_STL_SECT, 'TreeVisible', TreePanel.Visible);
  iniFile.WriteBool(INI_WIN_SECT, 'TreePanelCanMove', TreePanelCanMove);
  if TreePanelCanMove then
  begin
    iniFile.WriteInteger(INI_WIN_SECT, 'TreeWidth', TreePanelFixedWidth);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverLeft', TreePanel.BoundsRect.Left);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverTop', TreePanel.BoundsRect.Top);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverRight', TreePanel.BoundsRect.Right);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverBottom', TreePanel.BoundsRect.Bottom);
  end else begin
    iniFile.WriteInteger(INI_WIN_SECT, 'TreeWidth', TreePanel.Width);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverLeft', TreePanelHoverRect.Left);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverTop', TreePanelHoverRect.Top);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverRight', TreePanelHoverRect.Right);
    iniFile.WriteInteger(INI_WIN_SECT, 'TreePanelHoverBottom', TreePanelHoverRect.Bottom);
  end;
  {/aiai}

  (* ListView / thread list *)
  if Config.oprToggleRView then
  begin
    iniFile.WriteInteger(INI_WIN_SECT, 'ListHeight', savedListHeight);
    iniFile.WriteInteger(INI_WIN_SECT, 'ListWidth', savedListWidth);
  end
  else if Config.stlVerticalDivision then
  begin
    iniFile.WriteInteger(INI_WIN_SECT, 'ListWidth', ListViewPanel.Width);
    iniFile.WriteInteger(INI_WIN_SECT, 'ListHeight', savedListHeight);
    iniFile.WriteInteger(INI_WIN_SECT, 'WebWidth', WebPanel.Width);
  end
  else begin
    iniFile.WriteInteger(INI_WIN_SECT, 'ListWidth', savedListWidth);
    iniFile.WriteInteger(INI_WIN_SECT, 'ListHeight', ListViewPanel.Height);
    iniFile.WriteInteger(INI_WIN_SECT, 'WebHeight', WebPanel.Height);
  end;

  (* WritePanel (aiai) *)
  iniFile.WriteBool(INI_WIN_SECT, 'WriteMemoVisible', WritePanel.Visible);
  iniFile.WriteBool(INI_WIN_SECT, 'WriteMemoPos', WritePanelPos);
  iniFile.WriteBool(INI_WIN_SECT, 'WriteMemoCanMove', WritePanelCanMove);
  wh.Width := 0;
  wh.Height := 0;
  wh := WritePanelControl.SaveAAListBoundsRect(wh);
  iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoAAWidth', wh.Width);
  iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoAAHeight', wh.Height);
  iniFile.WriteBool(INI_WIN_SECT, 'WriteMemoTopBar', WritePanelTitle.Visible);
  if WritePanelCanMove then
  begin
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHeight', WritePanelFixedHeight);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverLeft', WritePanel.BoundsRect.Left);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverTop', WritePanel.BoundsRect.Top);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverRight', WritePanel.BoundsRect.Right);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverBottom', WritePanel.BoundsRect.Bottom);
  end else begin
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHeight', WritePanel.Height);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverLeft', WritePanelHoverRect.Left);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverTop', WritePanelHoverRect.Top);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverRight', WritePanelHoverRect.Right);
    iniFile.WriteInteger(INI_WIN_SECT, 'WriteMemoHoverBottom', WritePanelHoverRect.Bottom);
  end;

  (* Columns *)
  for i := 0 to ListView.Columns.Count -1 do
    iniFile.WriteInteger(INI_WIN_SECT, 'Column' + IntToStr(ListView.Column[i].Tag), ListView.Column[i].Width);

  (* CoolBar *) //※[457]
  for i := 0 to CoolBar.Bands.Count - 1 do
  begin
    iniFile.WriteInteger(INI_WIN_SECT, 'Band' + IntToStr(i) + 'ID', CoolBar.Bands[i].id);
    iniFile.WriteInteger(INI_WIN_SECT, 'Band' + IntToStr(i) + 'Width', CoolBar.Bands[i].Width);
    iniFile.WriteBool(INI_WIN_SECT, 'Band' + IntToStr(i) + 'Break', CoolBar.Bands[i].Break);
  end;

  (* Style *)
  iniFile.WriteBool(INI_OPR_SECT, 'ToggleRView',       Config.oprToggleRView);
  iniFile.WriteBool(INI_STL_SECT, 'VerticalDivision',  Config.stlVerticalDivision);
  iniFile.WriteBool(INI_STL_SECT, 'ToolBarVisible',    Config.stlToolBarVisible);
  iniFile.WriteBool(INI_STL_SECT, 'LinkBarVisible',    Config.stlLinkBarVisible);
  iniFile.WriteBool(INI_STL_SECT, 'AddressBarVisible', Config.stlAddressBarVisible);
  iniFile.WriteBool(INI_STL_SECT, 'MenuVisible',       assigned(MainWnd.Menu));

  (* Write *)
  iniFile.WriteBool(INI_WRT_SECT, 'RecordNameMail', Config.wrtRecordNameMail); //521
  iniFile.WriteBool(INI_WRT_SECT, 'WriteFormStayOnTop', Config.wrtFormStayOnTop); //521
  iniFile.WriteBool(INI_WRT_SECT, 'TrimRight', Config.wrtTrimRight);  //aiai
  iniFile.WriteBool(INI_WRT_SECT, 'UseWriteWait', Config.wrtUseWriteWait); //aiai
  iniFile.WriteBool(INI_WRT_SECT, 'NameMailWarning', Config.wrtNameMailWarning); //aiai
  iniFile.WriteBool(INI_WRT_SECT, 'MemoImeMode', Config.optWriteMemoImeMode); //aiai
  iniFile.WriteBool(INI_WRT_SECT, 'BeLogin', Config.wrtBeLogin); //aiai

  (* Menu *)
  iniFile.WriteBool(INI_NET_SECT, 'Online', Config.netOnline);

  (* Search (aiai) *)
  iniFile.WriteBool(INI_SCH_SECT, 'MultiWord', Config.schMultiWord);
  iniFile.WriteBool(INI_SCH_SECT, 'Incremental', Config.schIncremental);
  iniFile.WriteBool(INI_SCH_SECT, 'IgnoreFullHalf', Config.schIgnoreFullHalf);

  //LoginはaccAutoAuth,account.cfg管理なのでとりあえずパス
  (*  *)
  iniFile.UpdateFile;
  iniFile.Free;
end;

(* ウィンドウ位置復元 *)
procedure TMainWnd.LoadWindowPos;
var
  iniFile: TMemIniFile;
  procedure SetTreeTab;
  var
    i: integer;
  begin
    i := iniFile.ReadInteger(INI_WIN_SECT, 'TreeTab', 0);
    if (i > 1) then
      i := 0;
    TreeTabControl.TabIndex := i;
    TreePanelVisible := iniFile.ReadBool(INI_STL_SECT, 'TreeVisible', True);  //aiai
    TreePanelCanMove := iniFile.ReadBool(INI_WIN_SECT, 'TreePanelCanMove', True);
    TreePanelHoverRect.Left := iniFile.ReadInteger(INI_WIN_SECT, 'TreePanelHoverLeft', 10);
    TreePanelHoverRect.Top := iniFile.ReadInteger(INI_WIN_SECT, 'TreePanelHoverTop', 10);
    TreePanelHoverRect.Right := iniFile.ReadInteger(INI_WIN_SECT, 'TreePanelHoverRight', 150);
    TreePanelHoverRect.Bottom := iniFile.ReadInteger(INI_WIN_SECT, 'TreePanelHoverBottom', 300);

    ToggleTreePanel(TreePanelVisible);
    if TreePanel.Visible then
      SetTabSetIndex(TreeTabControl.TabIndex);
    if TreePanelCanMove then
      ToggleTreePanelCanMove(TreePanelCanMove);

    //if 0 < Main.initialURL.Count then
    if Assigned(Main.initialURL) then //aiai
    begin
      for i := 0 to Main.initialURL.Count - 1 do
        {beginner}
        if not NavigateIntoView(Main.initialURL[i], gtOther) then begin
          if ImageForm.GetImage(Main.initialURL[i]) then
            Application.ProcessMessages
          else
            OpenByBrowser(Main.initialURL[i]);
        end;
        {/beginner}
      Main.initialURL.Free;
      exit;
    end;
  end;

var
  i, h: integer;
  wh: TWidthHeight;
begin
  iniFile := TMemIniFile.Create(Config.IniPath);

  (* MainWindow *)
  SetBounds(iniFile.ReadInteger(INI_WIN_SECT, 'Left',  Left),
            iniFile.ReadInteger(INI_WIN_SECT, 'Top',   Top),
            iniFile.ReadInteger(INI_WIN_SECT, 'Width', Width),
            iniFile.ReadInteger(INI_WIN_SECT, 'Height',Height));
  WindowState := TWindowState(iniFile.ReadInteger(INI_WIN_SECT,
    'WindowState', Ord(WindowState))); //※[JS]

  (* LogArea *)
  h := iniFile.ReadInteger(INI_WIN_SECT, 'LogHeight', LogPanel.Height);
  if h <= 0 then
    h := 1;
  LogPanel.Top := LogPanel.Parent.ClientHeight - h;
  LogPanel.Height := h;

  (* TreeView / board list *)
  TreePanel.Width := iniFile.ReadInteger(INI_WIN_SECT, 'TreeWidth', TreePanel.Width);
  TreePanelFixedWidth := TreePanel.Width;
  SetTreeTab;

  (* ListView / thread list *)
  if Config.oprToggleRView then
  begin
    savedListHeight := iniFile.ReadInteger(INI_WIN_SECT, 'ListHeight', Panel2.Height div 2);
    savedListWidth := iniFile.ReadInteger(INI_WIN_SECT, 'ListWidth', Panel2.Width div 2);
  end
  else if Config.stlVerticalDivision then
  begin
    SetDivision(true);
    ListViewPanel.Width := iniFile.ReadInteger(INI_WIN_SECT, 'ListWidth', ListViewPanel.Width);
    ThreadSplitter.Left := ListViewPanel.Left + ListViewPanel.Width;
    WebPanel.Left := ThreadSplitter.Left + ThreadSplitter.Width;
    WebPanel.Width := iniFile.ReadInteger(INI_WIN_SECT, 'WebWidth', WebPanel.Width);
    savedListHeight := iniFile.ReadInteger(INI_WIN_SECT, 'ListHeight', Panel2.Height div 2);
  end
  else begin
    ListViewPanel.Height := iniFile.ReadInteger(INI_WIN_SECT, 'ListHeight', ListViewPanel.Height);
    ThreadSplitter.Top := ListView.Top + ListViewPanel.Height;
    WebPanel.Top := ThreadSplitter.Top + ThreadSplitter.Height;
    WebPanel.Height := iniFile.ReadInteger(INI_WIN_SECT, 'WebHeight', WebPanel.Height);
    savedListWidth := iniFile.ReadInteger(INI_WIN_SECT, 'ListWidth', Panel2.Width div 2);
  end;

  (* Memo (aiai) *)
  WritePanel.Height := iniFile.ReadInteger(INI_WIN_SECT, 'WriteMemoHeight', WritePanel.Height);
  WritePanelFixedHeight := WritePanel.Height;
  WritePanel.Visible := iniFile.ReadBool(INI_WIN_SECT, 'WriteMemoVisible', True);
  WritePanelPos := iniFile.ReadBool(INI_WIN_SECT, 'WriteMemoPos', True);
  wh.Width := iniFile.ReadInteger(INI_WIN_SECT, 'WriteMemoAAWidth', 100);
  wh.Height := iniFile.ReadInteger(INI_WIN_SECT, 'WriteMemoAAHeight', 50);
  WritePanelControl.SaveAAListBoundsRect(wh);
  WritePanelTitle.Visible := iniFile.ReadBool(INI_WIN_SECT, 'WriteMemoTopBar', True);
  WritePanelCanMove := iniFile.ReadBool(INI_WIN_SECT, 'WriteMemoCanMove', True);
  WritePanelHoverRect.Left := iniFile.ReadInteger(INI_WIN_SECT, 'WriteMemoHoverLeft', 10);
  WritePanelHoverRect.Top := iniFile.ReadInteger(INI_WIN_SECT, 'WriteMemoHoverTop', 10);
  WritePanelHoverRect.Right := iniFile.ReadInteger(INI_WIN_SECT, 'WriteMemoHoverRight', 200);
  WritePanelHoverRect.Bottom := iniFile.ReadInteger(INI_WIN_SECT, 'WriteMemoHoverBottom', 150);
  ToggleWritePanelPos(WritePanelPos);
  if WritePanelCanMove then
    ToggleWritePanelCanMove(WritePanelCanMove);
  ToggleWritePanelVisible(WritePanel.Visible);
  MenuViewWriteMemoToggleVisible.Checked := WritePanel.Visible;

  (* Columns *)
  ListView.Items.BeginUpdate;
  SetupColumns;
  for i := 0 to ListView.Columns.Count -1 do
    ListView.Column[i].Width := iniFile.ReadInteger(INI_WIN_SECT, 'Column' + IntToStr(ListView.Column[i].Tag), ListView.Column[i].Width);
  ListView.Show;
  ListView.Items.EndUpdate;
  ListView.Repaint;

  (* CoolBar *) //※[457]
  //CoolBar.Bands.BeginUpdate;
   for i:=0 to CoolBar.Bands.Count - 1 do
   begin
     CoolBar.Bands.FindItemID(iniFile.ReadInteger(INI_WIN_SECT, 'Band' + IntToStr(i) + 'ID', i)).Index := i;
     CoolBar.Bands[i].Break := iniFile.ReadBool(INI_WIN_SECT, 'Band' + IntToStr(i) + 'Break', CoolBar.Bands[i].Break);
     CoolBar.Bands[i].Width := iniFile.ReadInteger(INI_WIN_SECT, 'Band' + IntToStr(i) + 'Width', CoolBar.Bands[i].Width);
   end;
   {aiai}
   CoolBar.Visible := Config.stlLinkBarVisible or Config.stlToolBarVisible
     or Config.stlAddressBarVisible;
   {/aiai}

  //CoolBar.Bands.EndUpdate;

  (* Menu *)
  if not iniFile.ReadBool(INI_STL_SECT, 'MenuVisible', true) then
    MenuViewMenuToggleVisibleClick(Self);

  (*  *)
  iniFile.Free;
end;

(* カラムの順序・表示/非表示を設定する *)
procedure TMainWnd.SetupColumns;
var
  i: integer;
begin
  for i := 0 to High(Config.stlClmnArray) do
  begin
    if Config.stlClmnArray[i] < 0 then
      break;
    with ListView.Columns[i] do
    if Tag <> Config.stlClmnArray[i] then
    begin
      Tag := Config.stlClmnArray[i];
      case Tag of
      0          : begin Caption := '！';       Alignment := taLeftJustify;  end;
      LVSC_NUMBER: begin Caption := '番号';     Alignment := taRightJustify; end;
      LVSC_TITLE : begin Caption := 'タイトル'; Alignment := taLeftJustify;  end;
      LVSC_ITEMS : begin Caption := 'レス';     Alignment := taRightJustify; end;
      LVSC_LINES : begin Caption := '取得';     Alignment := taRightJustify; end;
      LVSC_NEW   : begin Caption := '新着';     Alignment := taRightJustify; end;
      LVSC_GOT   : begin Caption := '最終取得'; Alignment := taLeftJustify;  end;
      LVSC_WROTE : begin Caption := '最終書込'; Alignment := taLeftJustify;  end;
      LVSC_DATE  : begin Caption := 'since';    Alignment := taLeftJustify;  end;
      LVSC_BOARD : begin Caption := '板';       Alignment := taLeftJustify;  end;
      LVSC_SPEED : begin Caption := '勢い';     Alignment := taRightJustify; end;
      LVSC_GAIN  : begin Caption := '増レス';   Alignment := taRightJustify; end;
      else Caption := '';
      end;
    end;
  end;
  while i < ListView.Columns.Count do
    ListView.Columns.Delete(ListView.Columns.Count -1);
end;

(* オプションボタン処理 *)
procedure TMainWnd.MenuToolsOptionsClick(Sender: TObject);
begin
  OpenConfigDlg;
end;

procedure TMainWnd.OpenConfigDlg(PanelSpec: Integer = -1);
var
  rc: integer;
  i: TNGItemIdent; //beginner
begin
  if UIConfig = nil then
    UIConfig := TUIConfig.Create(self);
  {beginner}
  for i := Low(TNGItemIdent) to High(TNGItemIdent) do
    NGItems[i].SaveToFile(config.basepath + NG_FILE[i]);
  ExNGList.SaveToFile(Config.BasePath + NG_EX_FILE);
  {/beginner}
  Config.tmpChanged := false;
  if 0 < PanelSpec then
    UIConfig.PageControl.TabIndex := PanelSpec;
  rc := UIConfig.ShowModal;
  UIConfig.Free;
  UIConfig := nil;

  if not Config.tstAuthorizedAccess then
    loginIndicator := ''
  else if ticket2ch.Authorized then
    loginIndicator := '='
  else
    loginIndicator := 'X';
  UpdateIndicator;

  if rc <> mrOK then
  begin
    if Config.tmpChanged then
      AsyncUpdateConfig;
    exit;
  end;
  AsyncUpdateConfig;
  actLogin.Enabled := (Config.accUserID <> '') and (Config.accPasswd <> '');

  if WriteForm <> nil then
    WriteForm.freeReserve := true;
  if Config.FontChanged then
  begin
    InputDlg.Free;
    InputDlg := nil;
  end;

  actOnline.Checked := Config.netOnline;
  if MenuOptOnline.Checked then
    OnlineButton.ImageIndex := 12
  else
    OnlineButton.ImageIndex := 13;
  actLogin.Checked := Config.tstAuthorizedAccess;

  if Config.StyleChanged then
    SetStyle;

  HintTimer.Interval := config.hintForURLWaitTime;
  SetCaption(boardNameOfCaption);

  ListViewSelectItem(ListView, ListView.Selected, ListView.Selected <> nil);
  UpdateFavoritesMenu;

  mouseGestureEnable := Config.mseGestureList.Text <> '';
  SetupNGWords;
  Config.StyleChanged := false;
  SetTracePosition; //beginner
  ChangeWriteMemoStyle;  //aiai
end;

(* 2chのボード一覧を取得するもの也 *)
procedure TMainWnd.GetBoard2ch(Sender: TObject);
begin
  (* *)
  SaveTreeViewState;

  if not Config.netOnline then
  begin
    Log('(ﾟДﾟ)オフライン･･･');
    exit;
  end;

  LogBeginQuery;
  procGetCategoryList := AsyncManager.Get(Config.bbsMenuURL,
                                          OnGetBoardList,
                                          ticket2ch.On2chPreConnect, i2ch.lastModified);
  if not Assigned(procGetCategoryList) then
    DlgTooManyConn
  else
    MenuBoard.Enabled := false;
end;

(* ボード一覧取得完了ハンドラ *)
procedure TMainWnd.OnGetBoardList(sender: TAsyncReq);
var
  res: string;
begin
  LogEndQuery2;
  res := sender.Content;
  if length(res) <= 0 then
  begin
  {aiai}
  if usetrace[41] then Log(traceString[41])
  else
  {/aiai}
  Log('ボード一覧更新無し');
    MenuBoard.Enabled := true;
    exit;
  end;
  UILock := True;
  Main.Log(sender.IdHTTP.ResponseText);
  i2ch.analyze(res, sender.GetLastModified);
  UpdateTreeView;
  UpdateBoardMenu;
  MenuBoard.Enabled := true;
  UILock := False;
  LogDone;
  i2ch.Save;
  MainWnd.TabControl.Refresh;   //aiai
end;

procedure TMainWnd.UpdateBoardMenu;
  procedure RemoveOldItem;
  begin
    while 0 < MenuBoardList.Count do
    begin
      if MenuBoardList.Items[0] = MenuBoardSep then
        break;
      MenuBoardList.Items[0].Free;
    end;
  end;
var
  i, j: integer;
  category: TCategory;
  board: TBoard;
  menuCategory: TMenuItem;
  menuItem: TMenuItem;
begin
  RemoveOldItem;

  // ※[JS]
  if Config.optEnableBoardMenu then
    for i := 0 to i2ch.Count -1 do
    begin
      category := i2ch.Items[i];
      menuCategory := TMenuItem.Create(MenuBoardList);
      menuCategory.Caption := category.name;
      menuCategory.ImageIndex := 0; // ※[JS]
      MenuBoardList.Insert(i, menuCategory);
      for j := 0 to category.Count -1 do
      begin
        board := category.Items[j];
        menuItem := TMenuItem.Create(menuCategory);
        menuItem.Caption := board.name;
        menuItem.Tag := Integer(board);
        menuItem.ImageIndex := 1; // ※[JS]
        menuItem.OnClick := OnBoardShortcutMenuClick;
        menuCategory.Add(menuItem);
      end;
    end;
end;

procedure TMainWnd.UpdateFavoritesMenu;
  procedure UpdateLinkMenu(favList: TFavoriteList; parent: TMenuItem);
  var
    item, child: TMenuItem;
    i, j: integer;
    favChild: TFavoriteList;
  begin
    for i := 0 to favList.Count -1 do
    begin
      item := TMenuItem.Create(parent);
      item.Caption := StringReplace(favList.Items[i].name, '&', '&&', [rfReplaceAll]) ;
      parent.Add(item);
      if favList.Items[i] is TFavoriteList then
      begin
        item.ImageIndex := 0; // ※[JS]
        item.Tag := Integer(favList.Items[i]);
        item.OnClick := FavMenuCreate;
        favChild := TFavoriteList(favList.Items[i]);
        for j := 0 to favChild.Count -1 do
        begin
          child := TMenuItem.Create(item);
          child.Caption := StringReplace(favChild.Items[j].name, '&', '&&', [rfReplaceAll]) ;
          item.Add(child);
          if favChild.Items[j] is TFavoriteList then
          begin
            child.ImageIndex := 0; // ※[JS]
            child.Tag := Integer(favChild.Items[j]);
            child.OnClick := FavMenuCreate;
          end else
          begin
            if Length(TFavorite(favChild.Items[j]).datName) > 0 then
              child.ImageIndex := 3
            else
              child.ImageIndex := 1;
            child.Tag := Integer(favChild.Items[j]);
            child.OnClick := OnFavoriteShortcutMenuClick;
          end;
        end;
      end else
      begin
        if Length(TFavorite(favList.Items[i]).datName) > 0 then
         item.ImageIndex := 3
        else
          item.ImageIndex := 1;
        item.Tag := Integer(favList.Items[i]);
        item.OnClick := OnFavoriteShortcutMenuClick;
      end;
    end;
  end;

  procedure UpdateLinkBar;
  var
    i: Integer;
    item: TMenuItem;
  begin
    item := nil;
    for i := 0 to MenuBoardFavorites.Count -1 do
    begin
      if (MenuBoardFavorites[i].Count > 0) and
         (MenuBoardFavorites[i].Caption = 'リンク') then
      begin
        item := MenuBoardFavorites[i];
        break;
      end;
    end;
    if item = nil then
    begin
      while LinkBar.ButtonCount > 0 do
        LinkBar.Buttons[0].Free;
      exit;
    end;

    CoolBar.Bands.BeginUpdate;
    LinkBar.AutoSize := false;
    while (LinkBar.ButtonCount > item.Count) do
      LinkBar.Buttons[LinkBar.ButtonCount -1].Free;
    while (LinkBar.ButtonCount < item.Count) do
    begin
      with TToolbutton.Create(LinkBar) do
      begin
        Parent := LinkBar;
        //Style := tbsButton;
        AutoSize := true;
      end;
    end;
    for i := 0 to LinkBar.ButtonCount -1 do
    begin
      LinkBar.Buttons[i].MenuItem := item.Items[i];
      LinkBar.Buttons[i].Caption := StringReplace(item[i].Caption, '&&', '&', [rfReplaceAll]);
      LinkBar.Buttons[i].Grouped := (0 < LinkBar.Buttons[i].MenuItem.Count);
    end;
    LinkBar.AutoSize := true;
    CoolBar.Bands.EndUpdate;
    LinkBar.Refresh;
  end;
var
  i: integer;
  item: TMenuItem;
begin
  MenuBoardFavorites.Clear;
  MenuBoardFavorites.Tag := 0;
  MenuBoardFavorites.Visible := Config.optEnableFavMenu;

  if not Config.optEnableFavMenu then
  begin
    if Config.stlLinkBarVisible then
    begin
      for i := 0 to favorites.Count -1 do
        if (favorites.Items[i] is TFavoriteList) and
           (favorites.Items[i].name = 'リンク') then
        begin
          item := TMenuItem.Create(MenuBoardFavorites);
          item.Caption := 'リンク';
          MenuBoardFavorites.Add(item);
          UpdateLinkMenu(TFavoriteList(favorites.Items[i]), item);
          UpdateLinkBar;
          exit;
        end;
    end else
      exit;
  end;

  for i := 0 to favorites.Count -1 do
  begin
    item := TMenuItem.Create(MenuBoardFavorites);
    item.Caption := StringReplace(favorites.Items[i].name, '&', '&&', [rfReplaceAll]) ;
    MenuBoardFavorites.Add(item);
    if favorites.Items[i] is TFavoriteList then
    begin
      item.ImageIndex := 0;
      item.OnClick := FavMenuCreate;
      if item.Caption = 'リンク' then
      begin
        item.Tag := -1;
        UpdateLinkMenu(TFavoriteList(favorites.Items[i]), item);
      end else
        item.Tag := Integer(favorites.Items[i]);
    end else
    begin
      if Length(TFavorite(favorites.Items[i]).datName) > 0 then
        item.ImageIndex := 3
      else
        item.ImageIndex := 1;
      item.Tag := Integer(favorites.Items[i]);
      item.OnClick := OnFavoriteShortcutMenuClick;
    end;
  end;

  UpdateLinkBar;
end;

procedure TMainWnd.FavMenuCreate(Sender: TObject);
  procedure AddFavItem(favList: TFavoriteList; parent: TMenuItem);
  var
    item: TMenuItem;
    i: integer;
  begin
    for i := 0 to favList.Count -1 do
    begin
      item := TMenuItem.Create(parent);
      item.Caption := StringReplace(favList.Items[i].name, '&', '&&', [rfReplaceAll]) ;
      parent.Add(item);
      if favList.Items[i] is TFavoriteList then
      begin
        item.ImageIndex := 0; // ※[JS]
        item.Tag := Integer(favList.Items[i]);
        item.OnClick := FavMenuCreate;
      end else
      begin
        if Length(TFavorite(favList.Items[i]).datName) > 0 then
         item.ImageIndex := 3
        else
          item.ImageIndex := 1;
        item.Tag := Integer(favList.Items[i]);
        item.OnClick := OnFavoriteShortcutMenuClick;
      end;
    end;
  end;

var
  i: integer;
  favList: TFavoriteList;
begin
  if not (Sender is TMenuItem) then
    exit;

  with TMenuItem(Sender) do
  begin
    if Tag = -1 then
      exit
    else if Tag = 0 then
      favList := favorites
    else
      favList := TFavoriteList(Tag);

    for i := 0 to Count -1 do
    begin
      if (items[i].ImageIndex = 0) and (items[i].Count = 0) then
        AddFavItem(TFavoriteList(favList.Items[i]), items[i]);
    end;
    Tag := -1;
  end;
end;


procedure TMainWnd.OnBoardShortcutMenuClick(Sender: TObject);
begin
  (* xxxxx *)
  if (Sender is TMenuItem) and
     (TObject((Sender as TMenuItem).Tag) is TBoard) then
    ListViewNavigate(TBoard(TMenuItem(Sender).Tag), Config.oprGestureBrdMenu,
                     //▼新しいタブで開くか,Shiftで逆転
                     (Config.oprOpenBoardWNewTab xor (GetKeyState(VK_SHIFT) < 0)));
end;

procedure TMainWnd.OnFavoriteShortcutMenuClick(Sender: TObject);
begin
  if (Sender is TMenuItem) and
     (TObject((Sender as TMenuItem).Tag) is TFavorite) then
  begin
    with TFavorite(TObject((Sender as TMenuItem).Tag)) do
    begin
      NavigateIntoView(host, bbs, datName, -1, false, gtMenu,
        (Config.oprOpenFavWNewView xor (GetKeyState(VK_SHIFT) < 0)),
        false, Config.oprFavBgOpen);
    end;
  end;
end;

(* ボード一覧の木表示を更新する也 *)
procedure TMainWnd.UpdateTreeView ;
var
  node: TTreeNode;
  leaf: TTreeNode;
  i, j: integer;
  category: TCategory;
  board: TBoard;
begin
  TreeView.Items.BeginUpdate;
  TreeView.Items.Clear;
  for i := 0 to i2ch.Count -1 do
  begin
    category := i2ch.Items[i];
    node := TreeView.Items.AddChild(nil, category.name);
    node.Data := category;
    //※[JS]
    node.ImageIndex := 0;
    node.SelectedIndex := 0;

    for j := 0 to category.Count -1 do
    begin
      board := category.Items[j];
      leaf := TreeView.Items.AddChild(node, board.name);
      leaf.Data := board;
      //※[JS]
      leaf.ImageIndex := 1;
      leaf.SelectedIndex := 1;
    end;
  end;

  node := nil;
  (* ノードを追加すると展開情報忘れるんかいな *)
  for i := 0 to TreeView.Items.Count -1 do
  begin
    if TObject(TreeView.Items[i].Data) is TCategory then
    begin
      TreeView.Items[i].Expanded := TCategory(TreeView.Items[i].Data).expanded;
    end;
    if i = i2ch.topIndex then
      node := TreeView.Items[i];
    if i = i2ch.selIndex then
    begin
      TreeView.Items[i].Selected := true;
      TreeView.Items[i].Focused  := true;
      (*
      if TObject(TreeView.Items[i].Data) is TBoard then
        TreeViewSelected(TreeView, TreeView.Items[i], false);
      *)
    end;
  end;
  (* 表示先頭位置 *)
  if node <> nil then
    TreeView.TopItem := node;
  TreeView.Items.EndUpdate;
end;

(* ボード一覧状態を保存する *)
procedure TMainWnd.SaveTreeViewState;
var
  node: TTreeNode;
  i: integer;
begin
  for i := 0 to TreeView.Items.Count -1 do
  begin
    node := TreeView.Items[i];
    if TObject(node.Data) is TCategory then
      TCategory(node.Data).expanded := node.Expanded;
    if TreeView.TopItem = node then
      i2ch.topIndex := i;
    if node.Selected then
      i2ch.selIndex := i;
  end;
  i2ch.Save;
end;

function TMainWnd.TreeViewGetNode(sender: TObject): TTreeNode;
var
  pos : TPoint;
  HT: THitTests;
begin
  result := TTreeView(Sender).Selected;
  if result <> nil then
  begin
    pos := TTreeView(Sender).ScreenToClient(Mouse.CursorPos);
    if config.stlShowTreeMarks then
    begin
      HT := TTreeView(Sender).GetHitTestInfoAt(pos.X, pos.Y);
      if (HT  - [htOnItem, htOnIcon] = HT) then
        result := nil;
    end
    else
      result := TTreeView(Sender).GetNodeAt(pos.X, pos.Y);
  end;
end;

procedure TMainWnd.TreeViewDblClick(Sender: TObject);
var
  node: TTreeNode;
begin
  node := TreeViewGetNode(Sender);
  if node <> nil then
  begin
    if TObject(Node.Data) is TBoard then
    begin
      TreeViewSelected(Sender, node, Config.oprGestureBrdDblClk);
    end;
  end;
end;


(*  *)
procedure TMainWnd.TreeViewClick(Sender: TObject);
var
  node: TTreeNode;
begin
  (*  *)
  node := TreeViewGetNode(Sender);
  if node <> nil then
  begin
    if TObject(Node.Data) is TCategory then
    begin
      if Config.oprCatBySingleClick then
        node.Expanded := not node.Expanded;
    end
    else if TObject(Node.Data) is TBoard then
    begin
      TreeViewSelected(Sender, node, Config.oprGestureBrdClick);
    end;
  end;
end;

procedure TMainWnd.TreeViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  node: TTreeNode;
begin
  (*  *)
  case Key of
  VK_RETURN:
    begin
      node := TreeView.Selected;
      if (node <> nil) and
         (TObject(node.Data) is TBoard) then
      begin
        TreeViewSelected(Sender, node, Config.oprGestureBrdOther);
        Key := 0;
      end;
    end;
  VK_PRIOR:
    begin
      if ssCtrl	in Shift then
      begin
        SetTabSetIndex(TreeTabControl.TabIndex - 1);
        Key := 0;
      end;
    end;
  VK_NEXT:
    begin
      if ssCtrl in Shift then
      begin
        SetTabSetIndex(TreeTabControl.TabIndex + 1);
        Key := 0;
      end;
    end;
  //▼Ctrl+Tabでツリー切り替えを追加
  VK_TAB:
    begin
      if ssCtrl in Shift then
      begin
        SetTabSetIndex(TreeTabControl.TabIndex + 1);
        Key := 0;
      end;
    end;
  end;
end;


(* ボード一覧で板を選択された時の処理をするもの也 *)
procedure TMainWnd.TreeViewSelected(Sender: TObject; Node: TTreeNode;
                                    cmdType: TGestureOprType);
var
  board: TBoard;
begin
  if cmdType = gotNOP then
    exit;

  board := TBoard(Node.Data);
  ListViewNavigate(board, cmdType,  //▼新しいタブで開くか
                   (Config.oprOpenBoardWNewTab xor (GetKeyState(VK_SHIFT) < 0)));
end;

procedure TMainWnd.ListViewNavigate(board: TBoard; oprType: TGestureOprType;
                                                   newTab: boolean = false);
var
  uri: string;
  call: boolean;
  threadList: string;
  theTime: TDateTime;
  kbSpeed: Cardinal;
begin
  board.AddRef;
  call := false;
  if Config.netOnline then
  begin
    case oprType of
    gotNOP: exit;
    gotLOCAL: call := false;
    gotGRACEFUL: call := (length(board.subjectText) <= 0);
    gotCHECK: call := true;
    else begin board.Release; exit; end;
    end;
    //▼call時のみ判定
    if call and (board is TFunctionalBoard) then
    begin
      //再構築
      if currentboard = board then
      begin
        ListView.OnData := nil;
        currentBoard.SafeClear;
        currentBoard.Load;
        currentBoard.ResetListState;
        ListView.OnData := ListViewData;
        UpdateListView;
        exit;
      end else
        call := false;
    end;
  end;

  if assigned(requestingBoard) then
  begin
    requestingBoard.Release;
    requestingBoard := nil;
  end;

  (*  *)
  subjectReadyEvent.ResetEvent;
  //if call and (Now <= IncSecond(board.lastAccess, LIST_RELOAD_INTERVAL)) then
  if call and (Now <= IncSecond(board.lastAccess, Config.oprListReloadInterval)) then
  begin
    SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @kbSpeed, 0);
    board.lastAccess := board.lastAccess + 1.2/((30-2.5)*kbSpeed/31 + 2.5)/(24*60*60);
    //theTime := IncSecond(Now, LIST_RELOAD_INTERVAL);
    theTime := IncSecond(Now, Config.oprListReloadInterval);
    if theTime < board.lastAccess then
      board.lastAccess := theTime;
    //Log('（　´_ゝ`）');
    call := False;
  end;
  if call then
  begin
    requestingBoard := board;
    requestingBoard.AddRef;
    if board.past then
      threadList := THREAD_PAST_LIST
    else
      threadList := THREAD_CURRENT_LIST;
//    if Config.tstAuthorizedAccess then
    {$IFDEF APPEND_SID}
      uri := ticket2ch.AppendSID(board.URIBase + '/' + threadList, '?')
    {$ELSE}
      uri := board.URIBase + '/' + threadList;
    {$ENDIF}
//    else
//      uri := 'http://' + board.host + '/test/read.cgi/' + board.bbs + '/?raw=0.0';
    LogBeginQuery;
    procGetSubject := AsyncManager.Get(uri, OnSubject,
                                       ticket2ch.On2chPreConnect, board.lastModified);


    if procGetSubject = nil then
    begin
      call := false;
      requestingBoard.Release;
      requestingBoard := nil;
      DlgTooManyConn;
    end;
  end;
  if Config.oprShowSubjectCache or (not call) then //currentBoardをすぐに切り替えるどうか(両方trueでもいいかも)
    OpenBoard(board, newTab, true)
  else begin
    OpenBoard(board, newTab, false);
    ListTabControl.TabIndex := boardList.IndexOf(board);  //とりあえずタブの見た目だけごまかしておく
  end;

  SetRPane(ptList);
  board.Release;
end;

procedure TMainWnd.HomeMovedBoard(board: TBoard);
begin
  board.AddRef;

  if assigned(requestingBoard) then
  begin
    requestingBoard.Release;
    requestingBoard := nil;
  end;

  requestingBoard := board;
  requestingBoard.AddRef;
  if usetrace[16] then
    Log(traceString[16])
  else
    Log('川*’∀’）ｲﾃﾝﾂｲﾋ');
  LogBeginQuery;
  procGetSubject := AsyncManager.Get(board.URIBase + '/', OnMovedSubject,
      ticket2ch.On2chPreConnect, '');

  if procGetSubject = nil then
  begin
    requestingBoard.Release;
    requestingBoard := nil;
    DlgTooManyConn;
  end;

  SetRPane(ptList);
  board.Release;
end;

function AddPosToIndex(relative: boolean; list: TList; activeItem: Pointer): integer;
var
  addPos: TTabAddPos;
begin
  result := 0;
  if (list = nil) or (activeItem = nil) then
    exit;

  if relative then
    addPos := Config.oprAddPosRelative
  else
    addPos := Config.oprAddPosNormal;

  case addPos of
  tapFirst:
    begin
      result := 0;
    end;
  tapLeft:
    begin
      result := list.IndexOf(activeItem);
      if result < 0 then
        result := 0;
    end;
  tapRight:
    begin
      result := list.IndexOf(activeItem) +1;
    end;
  tapEnd:
    begin
      result := list.Count
    end;
  end;
end;

procedure TMainWnd.OpenBoard(board: TBoard; newTab: boolean; active: boolean = true);
var
  index: integer;
begin
  if boardList.IndexOf(board) < 0 then
  begin
    //ListTab非表示時はnewTabをキャンセル、ただし1つ目は必ず新タブ
    newTab := (newTab and ListTabPanel.Visible) or (currentBoard = nil);

    if newTab then
    begin
      index := AddPosToIndex(false, boardList, currentBoard);
      boardList.Insert(index, board);
      ListTabControl.Tabs.Insert(index, '');
    end else
      boardList.Items[boardList.IndexOf(currentBoard)] := board;
  end;

  //タブがひとつのときもactive
  active := active or (boardList.Count = 1);

  if active and (board <> currentBoard) then
  begin
    UILock := true;
    ChangeCurrentBoard(board);
    UpdateListView;
    UILock := false;
  end else //タブだけ更新
    UpdateListTab;
end;

procedure TMainWnd.CloseBoard(index: integer; update: boolean = true);
var
  nextBoard: TBoard;
begin
  if (index < 0) or (index >= boardList.Count) then
    exit;

  boardList.Delete(index);
  ListTabControl.Tabs.Delete(index);
  if not update then
    exit;

  UILock := true;
  if boardList.Count = 0 then
  begin
    ChangeCurrentBoard(nil);
    UpdateListTab;
  end
  else if boardList.IndexOf(currentBoard) < 0 then
  begin
    case Config.oprListClosePos of
    tcpLeft:
      begin
        if index > 0 then
          nextBoard := boardList.Items[index-1]
        else
          nextBoard := boardList.Items[0];
      end;
    else // tcpRight:
      begin
        if index <= boardList.Count -1 then
          nextBoard := boardList.Items[index]
        else
          nextBoard := boardList.Items[boardList.Count -1];
      end;
    end;
    ChangeCurrentBoard(nextBoard);
    UpdateListView;
  end;
  UILock := false;
  ListTabLineAdjust;
end;

procedure TMainWnd.OnMovedSubject(sender: TAsyncReq);
var
  URI, host, bbs: string;
  startpos, endpos: Integer;
label FAILED;
begin
  LogEndQuery2;
  if sender <> procGetSubject then
    exit;
  if requestingBoard = nil then
    exit;
  procGetSubject := nil;
  WriteStatus(sender.IdHTTP.ResponseText);
  case sender.IdHTTP.ResponseCode of
  200: (* 200 OK *)
    begin
      startpos := Pos('href="', sender.Content) + 6;
      if startpos <= 6 then
        goto FAILED;
      endpos := FindPos('/"</script>', sender.Content, startpos);
      if endpos <= startpos then
        goto FAILED;
      URI := copy(sender.Content, startpos, endpos - startpos);
      SplitThreadURI(URI, host, bbs);
      if bbs <> requestingBoard.bbs then
        goto FAILED;
      requestingBoard.host := host;
      Log(sender.URI + ' -> ' + URI + '/');
      if useTrace[12] then
        Log(traceString[12])
      else
        Log('川*’∀’）ﾀﾌﾞﾝｾｲｺｳ');
      if usetrace[13] then
        Log(traceString[13])
      else
        Log('川*’∀’）ｱﾄﾃﾞﾓｳｲﾁﾄﾞｺｳｼﾝｼﾃﾐﾙｶﾞｼ');
      WriteStatus('板移転検出');
      requestingBoard.lastAccess := 0;
    end;
    else
      FAILED:
        if usetrace[14] then
          Log(traceString[14])
        else
          Log('ﾂｲﾋﾞｼｯﾊﾟｲ川 - 。- 川');

  end;
  requestingBoard.Release;
  requestingBoard := nil;
end;


(* スレ一覧取得結果 *)
procedure TMainWnd.OnSubject(sender: TAsyncReq);
  procedure HomeMovedBoard;
  begin
    if usetrace[16] then
      Log(traceString[16])
    else
      Log('川*’∀’）ｲﾃﾝﾂｲﾋ');
    LogBeginQuery;
    procGetSubject := AsyncManager.Get(
      copy(sender.URI, 1, LastDelimiter('/', sender.URI)), OnMovedSubject,
      ticket2ch.On2chPreConnect, '');
  end;
  procedure GotSuccessfully(const content: string);
  begin
    requestingBoard.Analyze(content, sender.GetLastModified, false);
    if requestingBoard.timeValue <= 0 then
      requestingBoard.timeValue := DateTimeToUnix(Str2DateTime(sender.GetDate));
    if usetrace[42] then Log(traceString[42])
    else
    Log('スレ一覧更新中');
    //ListView.Enabled := false;
    UILock := true;
    ChangeCurrentBoard(requestingBoard);
    requestingBoard.Release;
    requestingBoard := nil;
    currentBoard.ResetListState;

    UpdateListView;
    //ListView.Enabled := true;
    UILock := false;
    LogDone;
  end;
var
  content, s: string;
  i: integer;
begin
  LogEndQuery2;
  subjectReadyEvent.ResetEvent;
  if sender <> procGetSubject then
    exit;
  if requestingBoard = nil then
    exit;

  requestingBoard.lastAccess := Now;
  procGetSubject := nil;
  Main.Log(sender.IdHTTP.ResponseText);
  case sender.IdHTTP.ResponseCode of
  200: (* 200 OK *)
    begin
      if (sender.Content = '') and Config.optHomeIfSubjectIsEmpty then
      begin
        HomeMovedBoard;
        Exit;
      end;
      requestingBoard.last2Modified:=requestingBoard.lastModified;  //beginner
      case requestingBoard.BBSType of
      bbsJBBSShitaraba, bbsShitaraba:
        content := euc2sjis(sender.Content);
      else
        {aiai}
        if requestingBoard.NeedConvert then
          content := euc2sjis(sender.Content)
        else
        {/aiai}
        content := sender.Content;
      end;
      if AnsiStartsStr('+', content) or
         AnsiStartsStr('-', content) then
      begin
        i := Pos(#10, content);
        if 0 < i then
        begin
          s := AnsiReplaceStr(Copy(content, 1, i - 1), #13, '');
          //Log('( @_@) □ ﾅﾆﾅﾆ･･･  ' + s);   //aiai
          if usetrace[15] then Log(traceString[15] + s)
          else Log('( @_@) □ ﾅﾆﾅﾆ･･･  ' + s);
          content := Copy(content, i + 1, high(integer));
          if s[1] = '+' then
            GotSuccessfully(content);
        end;
      end
      else
        GotSuccessfully(content);;
      exit;
    end;
  302: (* 302 Found *)
    begin
      HomeMovedBoard;
      exit;
    end;
  304: (* 304 Not Modified *)
    begin
      requestingBoard.last2Modified:=requestingBoard.lastModified;  //beginner
      if usetrace[17] then Log(traceString[17])
      else Log('川 ’ー’川新着ﾅｼ');
      if currentBoard <> requestingBoard then
      begin
        //ListView.Enabled := false;
        UILock := true;
        ChangeCurrentBoard(requestingBoard);
        requestingBoard.Release;
        requestingBoard := nil;
        UpdateListView;
        //ListView.Enabled := true;
       UILock := false;
      end
      else begin
        requestingBoard.Release;
        requestingBoard := nil;
      end;
      WriteStatus('新着なし');
      exit;
    end;
  else
    begin
      WriteStatus(sender.IdHTTP.ResponseText);
    end;
  end;
  requestingBoard.Release;
  requestingBoard := nil;
end;

function Dat2DateTime(const str: string): TDateTime;
var
  tim: integer;
begin
  try
    tim := StrToInt(str);
  except
    result := 0;
    exit;
  end;
  result := (tim - TimeZoneBias)/(24*60*60) + UnixDateDelta;
end;

procedure TMainWnd.ChangeCurrentBoard(board: TBoard);
begin
  if assigned(currentBoard) then
  begin
    SaveListViewState;
    currentBoard.sortColumn := currentSortColumn;
    currentBoard.Release;
  end else
    ListView.MultiSelect := true;
  currentBoard := board;
  if assigned(board) then
  begin
    board.AddRef;
    SetCaption(board.name);
    SetUrlEdit(board);
    currentBoardIsFunction := board is TFunctionalBoard;
    actBuildThread.Enabled := not currentBoardIsFunction;
  end
  else begin
    SetCaption('');
    ListView.List := nil;
    ListView.MultiSelect := false;
    ListView.Selected := nil;
    ListView.PopupMenu := nil;
    UrlEdit.Clear;
    actBuildThread.Enabled := false;
  end;
end;

{beginner} //スレ一覧のOnDataイベントやソートの前に新規スレッド判定用の時間情報を作成しておく
procedure TMainWnd.MakeCheckNewThreadAfter(Sender: TObject; StartIndex,
  EndIndex: Integer);
begin
  CheckNewThreadAfter := Trunc((24*60*60)
          * (Now - Config.optCheckNewThreadInHour/24 - UnixDateDelta))
                  + TimeZoneBias;

  {aiai}
  if currentBoard.last2Modified <> '' then
  begin
    CheckNewThreadAfter2 := Trunc((24*60*60)
      * (Str2DateTime(currentBoard.last2Modified) - UnixDateDelta));
    if CheckNewThreadAfter2 < CheckNewThreadAfter then
      CheckNewThreadAfter := CheckNewThreadAfter2;
  end;

  NowTimeUnix := DateTimeToUnix(Now) + TimeZoneBias;
  {/aiai}
end;
{/beginner}

procedure TMainWnd.ListViewData(Sender: TObject; Item: TListItem);
var
  thread: TThreadItem;

  function GetThreadMaxNum: integer;
  begin
    case TBoard(thread.board).BBSType of
    bbs2ch:   result := 1000;
    bbsMachi: result := 300;
    else      result := 100000;
    end;
  end;

  function GetAddString(column: integer): string;
  var
    tmp: int64;
  begin
    result := '';
    case column of
    0:
      begin
        if Config.stlListMarkIcons then
          exit;
        if (0 < thread.lines) then
        begin
          if (thread.oldLines < thread.lines) then
          begin
            if thread.mark = timMARKER then
              result := Config.viewListMarkerMarkedWMsg // '☆'
            else
              result := Config.viewListMarkerReadWMsg; // '？';
          end
          else if (thread.lines < thread.itemCount) then
          begin
            if thread.mark = timMARKER then
              result := Config.viewListMarkerMarkedWNewMsg // '★'
            else
              result := Config.viewListMarkerReadWNewMsg; // '！';
          end
          else if (thread.state = tsComplete) or
                  (thread.oldLines >= GetThreadMaxNum) then
          begin
            if thread.mark = timMARKER then
              result := Config.viewListMarkerMarkedNoUpdate // '▼'
            else
              result := Config.viewListMarkerReadNoUpdate // '↓'
          end
          else begin
            if thread.mark = timMARKER then
              result := Config.viewListMarkerMarked  //'■'
            else
              result := Config.viewListMarkerRead; //'･';
          end;
        end else
        {beginner}
        begin
        (* マーク非表示対応、新たに立てられたスレッドのマーク追加　(aiai) *)
          try
            result := Config.viewListMarkerNone; // ''
            if Config.optCheckThreadMadeAfterLstMdfy
                    and (StrToInt(thread.datName) > CheckNewThreadAfter) then
              result := Config.viewListMarkerNewThread;  //'○'
            if Config.optCheckThreadMadeAfterLstMdfy2
                and (CurrentBoard.last2Modified <> '')
                    and (StrToInt(thread.datName) > CheckNewThreadAfter2) then
              result := Config.viewListMarkerNewThread2; //'●'
          except
          end;
        end;
        {/beginner}
      end;
    LVSC_NUMBER:
      begin
        if currentBoardIsFunction then //機能板では各threadのnumberは使えない
          result := IntToStr(currentBoard.IndexOf(thread) +1)
        else if 0 < thread.number then
          result := IntToStr(thread.number);
      end;
    LVSC_TITLE:
      begin
        if (ThreAboneLevel = 0) and (thread.ThreAboneType and TThreAboneTypeMASK = 1) then
          result := 'あぼ～ん'
        else
          result := HTML2String(thread.title);
      end;
    LVSC_ITEMS:
      begin
        if {(0 < thread.number) and} (0 < thread.itemCount) then //▼ログ一覧は全て番号つき
          result := IntToStr(thread.itemCount);
      end;
    LVSC_LINES:
      begin
        if 0 < thread.lines then
          result := IntToStr(thread.lines);
      end;
    LVSC_NEW://521
      begin
        if {(0 < thread.number) and} (0 < thread.itemCount) and
           (0 < thread.lines) and (thread.itemCount > thread.lines) then
          result := IntToStr(thread.itemCount - thread.lines);
      end;
    LVSC_GOT:
      begin
        if thread.LastGot > 0 then
          try
            result := FormatDateTime(Config.optDateTimeFormat, UnixToDateTime(thread.LastGot));
          except
          end;
      end;
    LVSC_WROTE:
      begin
        if thread.LastWrote > 0 then
          try
            result := FormatDateTime(Config.optDateTimeFormat, UnixToDateTime(thread.LastWrote));
          except
          end;
      end;
    LVSC_DATE:  result := FormatDateTime(Config.optDateTimeFormat, Dat2DateTime(thread.datName));
    LVSC_BOARD: result := thread.GetBoardName; //▼板カラム
    LVSC_SPEED: //aiai
      try
        if thread.itemCount > 0 then
        begin
          tmp :=  NowTimeUnix - StrToInt(thread.datName);
          if tmp <= -86400 then
            result := '0'        (* sinceが一年以上未来の場合は勢いを0にする *)
          else begin
            if tmp <= 0 then tmp := 1;
            result := IntToStr((thread.itemCount * 60 * 60 * 24) div tmp);
          end;
        end;
      except
        result := '0';
      end;
    LVSC_GAIN: //aiai
      try
        if (0 < thread.number) and (thread.itemCount >= thread.previousitemCount) then
          (* 新規に立ったスレの増しレス数はレス数と同じ *)
          if (CurrentBoard.last2Modified <> '') then
          begin
            if (CheckNewThreadAfter2 < StrToInt(thread.datName)) then
              result := IntToStr(thread.itemCount)
            else
              result := IntToStr(thread.itemCount - thread.previousitemCount);
          end;
      except
      end;
    end;
  end;

  function GetAddImageIndex(column: integer): integer;
  begin
    result := -1;
    case column of
    0:
      begin
        if not Config.stlListMarkIcons then
          exit;
        if (0 < thread.lines) then //開いたことがあるスレ
        begin
        {aiai} //新着がある時と未読がある時の判定順を逆に
          if (thread.lines < thread.itemCount) then  //新着がある時
            if thread.mark = timMARKER then
              result := 6
            else
              result := 4
          else if (thread.oldLines < thread.lines) then  //未読がある時
            if thread.mark = timMARKER then
              result := 11
            else
              result := 10
        {/aiai}
          //※[457]
          else if (thread.state = tsComplete) or
                  (thread.oldLines >= GetThreadMaxNum) then  //
          begin
            if thread.mark = timMARKER then
              result := 9
            else
              result := 8;
          end
          else begin
            if thread.mark = timMARKER then
              result := 7
            else
              result := 5;
          end;
        {beginner}
        end else begin
        (* マーク非表示対応、新たに立てられたスレッドのマーク追加 (aiai) *)
          try
            if Config.optCheckThreadMadeAfterLstMdfy
                    and (StrToInt(thread.datName) > CheckNewThreadAfter) then
              result := 12;
            if Config.optCheckThreadMadeAfterLstMdfy2
                and (CurrentBoard.last2Modified <> '')
                    and (StrToInt(thread.datName) > CheckNewThreadAfter2) then
              result := 13    //aiai
          except
          end;
        {/beginner}
        end;
      end;
    LVSC_TITLE:
      begin
        if Config.stlListTitleIcons then
        begin
          if 0 < thread.lines then
            result := 3
          else
            result := 2;
        end;
      end;
    end;
  end;

var
  i: integer;
begin
  (*  *)
  thread := ListView.List[Item.Index];
  if thread = nil then
    exit;
  Item.Data := thread;

  Item.Caption := GetAddString(ListView.Columns[0].Tag);
  Item.ImageIndex := GetAddImageIndex(ListView.Columns[0].Tag);

  for i := 1 to ListView.Columns.Count -1 do
  begin
    Item.SubItems.Add(GetAddString(ListView.Columns[i].Tag));
    Item.SubItemImages[i-1] := GetAddImageIndex(ListView.Columns[i].Tag);
  end;
end;


procedure TMainWnd.ListViewSelectIntoView(item: TListItem);
begin
  ListView.SelectIntoView(item);
end;

(* リストビューの状態を保存する *)
procedure TMainWnd.SaveListViewState;
begin
  if currentBoard = nil then
    exit;

  currentBoard.Save;
end;

procedure TMainWnd.ListViewDblClick(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
begin
  (* *)
  if GetKeyState(VK_CONTROL) < 0 then
    exit;

  if ListView.SelCount > 1 then
    item := ListView.ItemFocused
  else
    item := ListView.Selected;
  if item = nil then
    exit;
  if UILock then
    exit;
  if Config.oprGestureThrDblClk = gotNOP then
    exit;
  DblClkTimer.Enabled := false;
  thread := TThreadItem(item.Data);
  ShowSpecifiedThread(thread, Config.oprGestureThrDblClk,  //▼Shiftで逆転
                      (Config.oprOpenThreWNewView xor (GetKeyState(VK_SHIFT) < 0)));
  SetRPane(ptView);
end;

(* スレが選択された  *)
procedure TMainWnd.ListViewClick(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
begin
  (* *)
  if GetKeyState(VK_CONTROL) < 0 then
    exit;
{  if (GetKeyState(VK_SHIFT) < 0) and (ListView.SelCount > 1) then //Shiftで複数選択するとき
    exit;
}
  if GetKeyState(VK_MENU) < 0 then
  begin
    actListOpenHideExecute(Sender);
    exit;
  end;

  if ListView.SelCount > 1 then
    item := ListView.ItemFocused
  else
    item := ListView.Selected;
  if item = nil then
    exit;
  if UILock then
    exit;
  if Config.oprGestureThrClick = gotNOP then
    exit;
  thread := TThreadItem(item.Data);
  ShowSpecifiedThread(thread, Config.oprGestureThrClick,  //▼Shiftで逆転
                      (Config.oprOpenThreWNewView xor (GetKeyState(VK_SHIFT) < 0)),
                      false, Config.oprThreBgOpen);
  if Config.oprThreBgOpen then
    SetRPane(ptList)
  else if (Config.oprGestureThrClick = gotCHECK) or
     (Config.oprGestureThrDblClk = gotNOP) then
    SetRPane(ptView)
  else begin
    DblClkTimer.Interval := GetDoubleClickTime;
    DblClkTimer.Enabled := true;
  end;
end;

procedure TMainWnd.ListViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ListView.Selected <> nil then
    ListView.PopupMenu := ListPopupMenu
  else
    ListView.PopupMenu := nil;
end;

procedure TMainWnd.actListOpenHideExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
begin
  (* *)
  if ListView.SelCount > 1 then
    item := ListView.ItemFocused
  else
    item := ListView.Selected;
  if item = nil then
    exit;
  if UILock then
    exit;
  thread := TThreadItem(item.Data);
  ShowSpecifiedThread(thread, gotCHECK, true, false, true);
  SetRPane(ptList);
end;

procedure TMainWnd.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_RETURN:
    begin
      if Config.oprGestureThrClick = gotNOP then
        ListViewDblClick(Sender)
      else
        ListViewClick(Sender);
    end;
  VK_DELETE:
    begin
      actListDelLogExecute(Sender);
    end;
  Ord('A'):
    if (Shift - [ssShift]) = [] then
    begin
      actListAddFavExecute(Sender);
    end;
  Ord('E'):  //aiai
    if (Shift - [ssShift]) = [] then
    begin
      actListCopyTITLEExecute(Sender);
    end;
  Ord('O'):
    if (Shift - [ssShift]) = [] then
    begin
      actListOpenCurrentExecute(Sender);
    end;
  Ord('L'):
    if (Shift - [ssShift]) = [] then
    begin
      actListCopyURLExecute(Sender);
    end;
  Ord('M'):
    if (Shift - [ssShift]) = [] then
    begin
      actListToggleMarkerExecute(Sender);
    end;
  Ord('N'):
    if (Shift - [ssShift]) = [] then
    begin
      actListOpenNewExecute(Sender);
    end;
  Ord('S'):
    if (Shift - [ssShift]) = [] then
    begin
      self.ToggleSortColumn ;
    end;
  Ord('T'):
    if (Shift - [ssShift]) = [] then
    begin
      actListCopyTUExecute(Sender);
    end;
  Ord('H'):
    if (Shift - [ssShift]) = [] then
    begin
      actListOpenHideExecute(Sender);
    end;
  VK_APPS:
    begin
      if ListView.Selected <> nil then
        ListView.PopupMenu := ListPopupMenu;
    end;
  VK_ESCAPE:
    begin
      ListView.Selected := nil;
    end;
  end;
end;

procedure TMainWnd.ShowSpecifiedThread(thread: TThreadItem;
                                       oprType: TGestureOprType;
                                       newViewP: Boolean;
                                       relative: boolean = false;
                                       background: boolean = false;
                                       number: integer = -1;
                                       Left: integer = 0; Top: integer = 0;
                                       Right: integer = 0; Bottom: integer = 0;
                                       wndstate: TMTVState = MTV_MAX);
var
  viewItem: TViewItem;
begin
  if oprType = gotNOP then
    exit;
  WriteStatus('');
  if thread = nil then
    exit;
  viewItem := viewList.FindViewItem(thread);
  if viewItem <> nil then
  begin
    if not background then
      SetCurrentView(viewList.IndexOf(viewItem));
  end
  else begin
    if not newViewP then
      viewItem := GetActiveView;
    if (viewItem = nil) or (viewItem.thread = nil) then
      viewItem := NewView(relative, background, Left, Top, Right, Bottom, wndstate)
    {aiai} //viewItemが「このタブは閉じない」のスレの場合は新しいタブで開く
    else if not viewItem.thread.canclose then
      viewItem := NewView(relative, background, Left, Top, Right, Bottom, wndstate);
    {/aiai}
  end;
  viewItem.NewRequest(thread, oprType, number, false, Config.oprCheckNewWRedraw);
  UpdateTabTexts;
end;




(*  *)
procedure TMainWnd.UpdateThreadInfo(thread: TThreadItem);
begin
  //▼ログ一覧時も更新
  if (thread.board = currentBoard) or (currentBoardIsFunction) then
  begin
    ListView.DoubleBuffered := True;
    ListView.Repaint;
    ListView.DoubleBuffered := False;
  end;
end;

(*  *)
procedure TMainWnd.ShowHint(Point: TPoint; const str: string;
  MaxWidth: integer; MaxHeight: integer; ForceCursorPos: Boolean);
var
  rect: TRect;
  i: integer;
  s: string;
  {aiai}
  yoffset1, yoffset2: integer;
  Monitor: TMonitor;
  MonitorRect: TRect;
  {/aiai}
begin
  if not Application.Active then
    exit;
  s := str;
  i := length(s);
  while 0 < i do
  begin
    case s[i] of
    #13,#10:;
    else
      break;
    end;
    Dec(i);
  end;
  SetLength(s, i);

  {aiai}
  Monitor := Screen.MonitorFromPoint(Point);
  if Assigned(Monitor) then
    MonitorRect := Monitor.WorkareaRect
  else
    MonitorRect := Screen.WorkAreaRect;

  if MaxWidth <= 0 then
    MaxWidth := MonitorRect.Right - MonitorRect.Left;

  rect := PopupHint.CalcHintRect(MaxWidth, s, nil);
  AdjustToTextViewLine(point, rect, yoffset1, yoffset2);

  Dec(Point.X, 32);
  //Dec(Point.Y, 5);

  if Point.X < MonitorRect.Left then
    Point.X := MonitorRect.Left
  else if Rect.Right + Point.X > MonitorRect.Right then
    Point.X := MonitorRect.Right - Rect.Right;

  if Point.Y - (Rect.Bottom - Rect.Top) - yoffset1 - 5 < MonitorRect.Top then
  begin
    if Point.Y + (Rect.Bottom - Rect.Top) + yoffset2 < MonitorRect.Bottom then
      Inc(Point.Y, yoffset2)
    else
      Point.Y := MonitorRect.Top - Rect.Top;
  end else
    Dec(Point.Y, (Rect.Bottom - Rect.Top) + yoffset1 + 5);

  OffsetRect(Rect, Point.X, Point.Y);
  {/aiai}
  PopupHint.ActivateHint(rect, s);
end;

function NeedHover(Obj: TObject): Boolean;
begin
  if Obj is THogeTextView then
    Result := (THogeTextView(Obj).HoverTime > 0)
  else
    Result := (Config.hintHoverTime > 0);
end;

function GetAutoEnableNesting(Obj: TObject): Boolean;
begin
  if Obj is TPopUpTextView then
    Result := Config.hintHintAutoEnableNesting
  else
    Result := Config.hintAutoEnableNesting;
end;

{beginner}
function TMainWnd.ShowTreeHint(Sender: TObject; OutLine: Boolean): Boolean;
var
  ref: string;
  viewItem: TBaseViewItem;
  Index: Integer;
  newView: TPopupViewItem;
begin
  Result := False;
  if (Sender is THogeTextView) then
    viewItem := GetViewOf(TComponent(Sender))
  else
    viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;

  ref := viewItem.GetLinkUnderCursor; //aiai

  if not StartWith('menu:', ref, 1) then
    Exit;

  Index := StrToIntDef(copy(ref, 6, High(Integer)), -1);

  newView := NewPopUpView(viewItem);
  try
    newView.Lock;
    Result := NewView.ThreadTree(ref, viewitem.thread, Index, OutLine, Mouse.CursorPos);
    if Assigned(viewItem.PossessionView) then
    begin
      viewItem.PossessionView.Enabled := True;
      viewItem.PossessionView.OwnerCofirmation := True
    end
  finally
    newView.UnLock
  end;
end;
{/beginner}

(*  *)

procedure TMainWnd.BrowserStatusTextChange(Sender: TObject; Text: AnsiString; Point: TPoint);
var
  s: string;
  i: integer;
  viewItem: TBaseViewItem;
  newviewItem: TPopupViewItem;
  IdStr: String;
  AutoEnableNesting: Boolean;
  {beginner}
  host, bbs, datnum: string;
  oldLog: boolean;
  StartIndex, EndIndex: integer;
  {/beginner}
begin
  (*  *)
  if not Config.hintEnabled then
    exit;
  viewItem := GetViewOf(TControl(Sender));
  if viewItem = nil then
    Exit;

  viewItem.Lock;
  try
    if Assigned(viewItem.PossessionView) and viewItem.PossessionView.Enabled
            and (viewItem.PossessionView.HadPointed or (Text = '')) then
    begin
      viewItem.PossessionView.OwnerCofirmation := False;
      Exit;
    end;

    AutoEnableNesting
            := GetAutoEnableNesting(Sender) and not NeedHover(Sender);

    IdStr := Text;
    if Assigned(viewItem) and (Length(Text) > 0) then
      viewItem.ValidateURI(Text, Text);
    HintTimer.Enabled := false;

    if AnsiStartsStr('http://', Text) then
    begin
      if Show2chInfo(Point, IdStr, Text, viewItem, Config.hintNestingPopUp and
        (GetKeyState(VK_SHIFT) >= 0)) then
      begin
        if Assigned(viewItem.PossessionView) then
        begin
          viewItem.PossessionView.Enabled := AutoEnableNesting;
          viewItem.PossessionView.OwnerCofirmation := AutoEnableNesting;
        end;
        exit;
      end else
        ReleasePopupHint(viewItem, True);

      {beginner}
      if MenuOpenURLOnMouseOver.Checked then begin
        if assigned(viewItem) then begin
          Get2chInfo(Text, host, bbs, datnum, StartIndex, EndIndex, oldLog);
          if i2ch.FindBoard(host, bbs) = nil then
            ImageForm.GetImage(Text, viewitem);
        end;
      end;
      if ImageForm.ShowImageHint(Text,False) then
      begin
        exit;
      end;
      {/beginner}

      if not Config.hintForURL then
        exit;
      self.hintURI := Text;
      s := urlHeadCache.GetCache(hintURI);
      if 0 < length(s) then
      begin
        ShowHint(Point, s, Config.hintForURLWidth, Config.hintForURLHeight);
        Exit;
      end;
      if 0 < HintTimer.Interval then
      begin
        HintTimer.Enabled := true
      end
      else begin
        s := urlHeadCache.GetContents(Text);
        if 0 < length(s) then
          ShowHint(Point, s, Config.hintForURLWidth, Config.hintForURLHeight);
      end;
    end else
    if (AnsiStartsStr('file://', Text) or AnsiStartsStr('about:', Text) or
      AnsiStartsStr('#', Text)) then
    begin
      if (viewItem = nil) or (viewItem.thread = nil) then
        exit;
      for i := Length(Text) downto 1 do
      begin
        if Text[i] = '#' then
        begin
          s := Copy(Text, i + 1, Length(Text) - i);
          break;
        end;
      end;
      if length(s) <= 0 then
      begin
        ReleasePopupHint(viewItem);
        exit;
      end;
      if Show2chInfo(Point, IdStr, s, viewItem, Config.hintNestingPopUp
        and (GetKeyState(VK_SHIFT) >= 0)) then
      begin
        if Assigned(viewItem.PossessionView) then
        begin
          viewItem.PossessionView.Enabled := AutoEnableNesting;
          viewItem.PossessionView.OwnerCofirmation := AutoEnableNesting;
        end;
      end else
        ReleasePopupHint(viewItem, True);
    end
    else if AnsiStartsStr('mailto:', Text) then
    begin
      s := copy(Text, 8, length(Text));
      if 0 < length(s) then
        if Config.hintNestingPopUp then
        begin
          newviewItem := NewPopUpView(viewItem);
          try
            newviewItem.Lock;
            newviewItem.ShowTextInfo(IdStr, s, viewItem.thread, True, Point);
          finally
            newviewItem.UnLock;
          end;
          if Assigned(viewItem.PossessionView) then
          begin
            viewItem.PossessionView.Enabled := AutoEnableNesting;
            viewItem.PossessionView.OwnerCofirmation := AutoEnableNesting;
          end;
        end else
          ShowHint(Point, s);
    end
    {aiai}  //IDポップアップ
    else if Config.ojvIDPopUp and Config.ojvIDPopOnMOver
              and AnsiStartsStr('ID:', Text) then
    begin
      if (viewItem.thread = nil) then
        exit;
      try
        SetString(s, PChar(Text) + 3, Length(Text) - 3);
        if Length(s) <= 0 then
          exit;
        if ShowIDInfo(Point, IdStr, s, viewItem,
                Config.hintNestingPopUp and (GetKeyState(VK_SHIFT) >= 0)) then
        begin
          if Assigned(viewItem.PossessionView) then
          begin
            viewItem.PossessionView.Enabled := AutoEnableNesting;
            viewItem.PossessionView.OwnerCofirmation := AutoEnableNesting;
          end;
        end else
          ReleasePopupHint(viewItem, True);
      finally
      end;
    end
    {/aiai}
    else
      ReleasePopupHint(viewItem);
  finally
    viewItem.UnLock;
  end;
end;

(*  *)
function TMainWnd.NewView(relative: boolean = false;
  background: boolean = false; Left: integer = 0; Top: integer = 0;
  Right: integer = 0; Bottom: integer = 0;
  wndstate: TMTVState = MTV_MAX): TViewItem;
var
  //browser: THogeTextView;
  browser: TMDITextView;
  index: integer;
begin
  index := AddPosToIndex(relative, viewList, currentView);
  result := viewList.GetGarbage(index);
  if result = nil then
  begin
    {aiai} //MDI化
    browser := TMDITextView.Create(self.MDIClientPanel);
    browser.Parent := self.MDIClientPanel;
    browser.Align := alClient;
    if not ((Left = 0) and (Top = 0) and (Right = 0) and (Bottom = 0)) then
      browser.NorRect := Bounds(Left, Top, Right - Left, Bottom - Top);
    browser.WndState := wndstate;
    browser.OnCloseWindow := actCloseTabExecute;
    browser.OnMaximizeWindow := actMaxViewExecute;
    browser.OnDbClickTBar := actMaxViewExecute;
    browser.OnActive := BrowserActive;
    browser.OnScrollEnd := BrowserScrollEnd;
    browser.OnEnter     := BrowserEnter;
    browser.OnExit      := BrowserExit;
    {/aiai}
    Move(Config.viewTextAttrib, browser.TextAttrib, SizeOf(browser.TextAttrib));
    browser.SetFont(Font.Name, Font.Size);
    browser.OnMouseMove := OnBrowserMouseMove;
    browser.OnMouseHover := OnBrowserMouseHover;
    browser.OnMouseDown := OnBrowserMouseDown;
    browser.OnKeyDown   := OnBrowserKeyDown;
    browser.PopupMenu := PopupTextMenu;
    browser.Invalidate;
    result := viewList.NewView(browser, index);
    Result.RootControl := browser;
  end;
  //▼ブラウザ部の色指定
  result.browser.Color := Config.clViewColor;
  {aiai}
  result.browser.LeftMargin := 8;
  result.browser.RightMargin := 8;
  result.browser.Wallpaper := nil;
  result.browser.WallpaperVAlign := walVTop;
  result.browser.WallpaperHAlign := walHLeft;
  result.browser.ColordNumber := Config.ojvColordNumber;       //レス番着色
  result.browser.LinkedNumColor := Config.ojvLinkedNumColor;   //レス番着色
  result.browser.IDLinkColor := Config.ojvIDLinkColor;         //ID着色
  result.browser.IDLinkColorMany := Config.ojvIDLinkColorMany; //ID着色
  result.browser.IDLinkColorNone := Config.ojvIDLinkColorNone; //ID着色
  result.browser.IDLinkThreshold := Config.ojvIDLinkThreshold; //ID着色
  result.browser.KeywordBrushColor := Config.viewKeywordBrushColor; //ハイライトの色
  {/aiai}
  result.browser.VerticalCaretMargin := Config.viewVerticalCaretMargin;
  result.browser.WheelPageScroll := Config.viewPageScroll;
  result.browser.VScrollLines := Config.viewScrollLines;
  {beginner}
  result.browser.EnableAutoScroll := Config.viewEnableAutoScroll;
  result.browser.Frames := Config.viewScrollSmoothness;
  result.browser.FrameRate := Config.viewScrollFrameRate;
  {/beginner}
  //result.browser.Visible := true;
  //result.browser.BringToFront;
  result.browser.ConfCaretVisible := Config.viewCaretVisible;
  result.browser.CaretScrollSync := Config.viewCaretScrollSync; //aiai
  result.Browser.HoverTime := Config.hintHoverTime;
  Result.PopUpViewList := popupviewList;

  Result.HintText := ''; //beginner

  TabControl.Tabs.Insert(index, '  ');
  if background then
    UpdateCurrentView(TabControl.TabIndex)
  else begin
    SetCurrentView(index);
    UpdateCurrentView(index);
  end;
  //result.browser.TabStop := True;

  UpdateTabTexts;
end;


function TMainWnd.NewPopUpView(OwnerView: TBaseViewItem): TPopUpViewItem;
var
  Browser: TPopUpTextView;
  i: Integer;
  c: Integer;
  fRGB: Integer;
  phRGB: Integer;
  pfRGB: Integer;
begin
  Browser := TPopUpTextView.Create(Self);
  Browser.Parent := OwnerView.RootControl;
  Browser.PopupMenu := PopUpMenu;
  Browser.SetFont(PopupHint.Font.Name, PopupHint.Font.Size);
  Browser.ColorEnable := Config.clHintOnFix; //???
  Browser.ColorDisable := PopupHint.Color;
  Browser.Color := Browser.ColorDisable;
  Browser.TopMargin := 2;
  Browser.LeftMargin := 2;
  Browser.RightMargin := 2;
  Browser.VScrollLines := Config.viewScrollLines;
  for i := 0 to 31 do begin
    Browser.TextAttrib[i].color := PopupHint.Font.Color;
    Browser.TextAttrib[i].style := PopupHint.Font.Style; //ヒントでboldは使わない
  end;
  Browser.TextAttrib[2].color := Config.viewHintFontLinkColor;
  Browser.TextAttrib[2].style := [fsUnderline];
  Browser.TextAttrib[3].color := Config.viewHintFontLinkColor;
  Browser.TextAttrib[3].style := [fsUnderline];
  fRGB := ColorToRGB(PopupHint.Font.Color);
  phRGB := ColorToRGB(PopupHint.Color);
  pfRGB := ColorToRGB(Config.clHintOnFix);
  c := (Font.color and $ff0000) or
       ((((fRGB and $ff) * 2 + (phRGB and $ff) + (pfRGB and $ff)) div 4) and $ff) or
       ((((fRGB and $ff00) * 2 + (phRGB and $ff00) + (pfRGB and $ff00)) div 4) and $ff00) or
       ((((fRGB and $ff0000) * 2 + (phRGB and $ff0000) + (pfRGB and $ff0000)) div 4) and $ff0000);
  Browser.TextAttrib[26].color := c;
  Browser.TextAttrib[26].style := PopupHint.Font.Style;
  Browser.TextAttrib[27].color := c;
  Browser.TextAttrib[27].style := PopupHint.Font.Style;
  Browser.OnMouseMove := OnBrowserMouseMove;
  Browser.OnMouseHover := OnBrowserMouseHover;
  Browser.OnMouseDown := OnBrowserMouseDown;
  Browser.OnMouseEnter := BrowserMouseEnter;
  Browser.OnQueryContext := BrowserQueryContext;
  Browser.OnEndContext := BrowserEndContext;
  Browser.PopupMenu := PopupTextMenu;
  Browser.HoverTime := Config.hintHintHoverTime;
  {aiai}
  Browser.CaretScrollSync := Config.viewCaretScrollSync;
  Browser.KeywordBrushColor := Config.viewKeywordBrushColor;
  {/aiai}

  Browser.SetPhysicalCaret(0, 0);

  Result := TPopupViewItem.Create(Browser, OwnerView);
  Result.OnEnabled := PopupViewItemEnabled;
end;

(* 手抜関数群 *)
procedure TMainWnd.SetCurrentView(index: integer);
begin
  if TabControl.Tabs.Count <= index then
    index := TabControl.Tabs.Count -1;
  if (0 <= index) and (index < TabControl.Tabs.Count) then
  begin
    TabControl.TabIndex := index;
    TabControlChange(TabControl);
    //MenuViewNextPaneClick(Self);
    //MenuViewPrevPaneClick(Self);
    try
      WebPanel.SetFocus;
      viewList.Items[index].browser.SetFocus;
    except
    end;
  end;
end;

procedure TMainWnd.UpdateCurrentView(index: integer);

  procedure CheckNewResSingleClick(viewItem: TViewItem);
  begin
    if (viewItem <> nil) and (viewItem.thread <> nil)
        and (viewItem.thread.lines > 0)
            and (viewItem.thread.itemCount > viewItem.thread.lines) then
    begin
      viewItem.thread.anchorLine := viewItem.thread.lines;
      viewItem.NewRequest(viewItem.thread, gotCHECK, -1, false,
                     Config.oprCheckNewWRedraw xor (GetKeyState(VK_SHIFT) < 0));
      //TabControl.Refresh;
      UpdateTabTexts;
      SetRPane(ptView);
      //if Config.optSetFocusOnWriteMemo then
      //  try WritePanel.SetFocus except end;
    end;
  end;

var
  i: integer;
  hWindow: HWND;
  browser: THogeTextView;
begin
  if (0 <= index) and (index < viewList.Count) then
  begin
    currentView := viewList.Items[index];
    currentViewHandle := currentView.browser.Handle;
    currentView.browser.BringToFront;

    {aiai}

    hWindow := currentViewHandle; //Zオーダーが一番上のウィンドウ
    while hWindow <> 0 do
    begin
      browser := nil;

      (* このウィンドウをShow *)
      for i := 0 to viewList.Count - 1 do
        if (hWindow = viewList.Items[i].browser.Handle) then
        begin
          browser := viewList.Items[i].browser;
          browser.Visible := True;
          break;
        end;

      (* このウィンドウが最大化状態ならこれより下のウィンドウをすべてHide *)
      if (browser <> nil) and (browser.Align = alClient) then
      begin
        hWindow := GetWindow(hWindow, GW_HWNDNEXT);

        while hWindow <> 0 do
        begin
          for i := 0 to viewList.Count - 1 do
            if (hWindow = viewList.Items[i].browser.Handle) then
            begin
              viewList.Items[i].browser.Visible := False;
              break;
            end;
          hWindow := GetWindow(hWindow, GW_HWNDNEXT);
        end;

        break;
      end;

      hWindow := GetWindow(hWindow, GW_HWNDNEXT);
    end;

    {/aiai}

    if GetFocus() = 0 then
      try
        currentView.browser.SetFocus
      except
      end
    else begin
      viewList.UpdateFocus(index);
    end;

    {aiai}
    if Config.optCheckNewResSingleClick and CanAutoCheckNewRes then
      CheckNewResSingleClick(currentView);
    {/aiai}
  end
  else begin
    currentView := nil;
    currentViewHandle := 0;
  end;
end;

function TMainWnd.GetActiveView: TViewItem;
begin
  //result := currentView;
  if TabControl.TabIndex < 0 then
    result := nil
  {beginner}
  else if TabControl.TabIndex < viewList.Count then
    result := viewList.Items[TabControl.TabIndex]
  else
    result := nil;
  {/beginner}
end;

(*  *)
function TMainWnd.GetViewOf(browser: TComponent): TBaseViewItem;
begin
//  result := viewList.FindViewItem(browser);
  try
    Result := TObject(browser.tag) as TBaseViewItem;
  except
    Result := nil;
  end;
end;



function TMainWnd.NavigateIntoView(const URI: string; oprType: TGestureType; relative: boolean = false;
                                   background: boolean = false): boolean;
var
  host, bbs, datnum: string;
  oldLog: boolean;
  startIndex, endIndex: integer;
begin
  Get2chInfo(URI, host, bbs, datnum, startIndex, endIndex, oldLog);
  result := NavigateIntoView(host, bbs, datnum, startIndex, oldLog, oprType, true, relative, background);
end;

  function BoardGesture2Opt(oprType: TGestureType): TGestureOprType;
  begin
    case oprType of
    gtClick:  result := Config.oprGestureBrdClick;
    gtDblClk: result := Config.oprGestureBrdDblClk;
    gtMenu:   result := Config.oprGestureBrdMenu;
    else      result := Config.oprGestureBrdOther;
    end;
  end;

  function ThreadGesture2Opt(oprType: TGestureType): TGestureOprType;
  begin
    case oprType of
    gtClick:  result := Config.oprGestureThrClick;
    gtDblClk: result := Config.oprGestureThrDblClk;
    gtMenu:   result := Config.oprGestureThrMenu;
    else      result := Config.oprGestureThrOther;
    end;
  end;


function TMainWnd.NavigateIntoView(const host, bbs, datnum: string;
                                   index: integer;
                                   oldLog: boolean;
                                   oprType: TGestureType;
                                   anotherTab: boolean = true;
                                   relative: boolean = false;
                                   background: boolean = false): boolean;
var
  board: TBoard;
  thread: TThreadItem;
begin
  result := false;
  board := i2ch.FindBoard(host, bbs);
  if board <> nil then
  begin
    if length(datnum) <= 0 then
    begin
      SetRPane(ptList);
      ListViewNavigate(board, BoardGesture2Opt(oprType), anotherTab);
      result := true;
      exit;
    end;
    board.AddRef;
    thread := board.Find(datnum);
    if thread = nil then
    begin
      thread := TThreadItem.Create(board);
      thread.datName := datnum;
      thread.URI := 'http://' + host + '/' + bbs;
      board.Add(thread);
    end;
    if oldLog and (thread.state <> tsComplete) then
      thread.queryState := tsHistory1;
    Dec(index);
    ShowSpecifiedThread(thread, ThreadGesture2Opt(oprType), anotherTab, relative,
                        background, index);
    if not background then
      SetRPane(ptView);
    board.Release;
    result := true;
  end;
end;

procedure TMainWnd.LocalNavigate(const URI: string; activate: boolean = false;
  Left: integer = 0; Top: integer = 0; Right: integer = 0; Bottom: Integer = 0;
  wndstate: TMTVState = MTV_MAX; canclose: boolean = true);
var
  host, bbs, datnum: string;
  oldLog: boolean;
  startIndex, endIndex: integer;
begin
  Get2chInfo(URI, host, bbs, datnum, startIndex, endIndex, oldLog);
  LocalNavigate(host, bbs, datnum, activate, Left, Top, Right, Bottom, wndstate, canclose);
end;

procedure TMainWnd.LocalNavigate(const host, bbs, datnum: string;
  activate: boolean = false; Left: integer = 0; Top: integer = 0;
  Right: integer = 0; Bottom: Integer = 0; wndstate: TMTVState = MTV_MAX;
  canclose: boolean = true);
var
  board: TBoard;
  thread: TThreadItem;
begin
  board := i2ch.FindBoard(host, bbs);
  if board <> nil then
  begin
    if length(datnum) <= 0 then
    begin
      OpenBoard(board, true, active);
      exit;
    end;
    board.AddRef;
    thread := board.Find(datnum);
    if thread = nil then
    begin
      thread := TThreadItem.Create(board);
      thread.datName := datnum;
      thread.URI := 'http://' + host + '/' + bbs;
      board.Add(thread);
    end;
    thread.canclose := canclose;
    ShowSpecifiedThread(thread, gotLOCAL, true, false, false, -1,
      Left, Top, Right, Bottom, wndstate);
    board.Release;
  end;
end;

procedure TMainWnd.BrowserBeforeNavigate(Sender: TObject; const URL: String;
  Point: TPoint; var Cancel: WordBool; MustGo: Boolean);
var
  viewItem: TBaseViewItem;
  activeView: TViewItem;
  URI: string;
  newviewItem: TPopupViewItem; //aiai

  procedure Scroll(viewItem: TBaseViewItem);
  var
    i, j, num: integer;
  begin
    if (viewItem = nil) or (viewItem.thread = nil) then
      Exit;
    for i := length(URI) downto 1 do
    begin
      if URI[i] = '#' then
      begin
        for j := i + 1 to length(uri) do
        begin
          if not (URI[j] in ['0'..'9']) then
            break;
        end;
        try
          num := StrToInt(Copy(URI, i + 1, j - i -1));
          if num >= 1 then   //▼
          begin
            ShowSpecifiedThread(viewItem.thread, gotGRACEFUL, true, false, false, num - 1);
            ReleasePopupHint(nil, True);
          end;
        except
        end;
        exit;
      end;
    end;
  end;

  {aiai}
  procedure ShowProfile(BEID: String); // ex. BEID = BE:xxxxxxxx
  var
    id: string;
    viewitem: TViewItem;
  begin
    viewItem := GetActiveView;
    if Assigned(viewItem) and Assigned(viewItem.thread) then
    begin
      id := Copy(BEID, 4, Length(BEID) - 3);
      if Length(id) > 0 then
        OpenByBrowser('http://be.2ch.net/test/p.php?i=' + id + '&u=d:' + viewItem.thread.ToURL(true, true));
    end;
  end;
  {/aiai}

begin
  viewItem := GetViewOf(TComponent(Sender));
  if viewItem = nil then
    exit;
  if Assigned(viewItem.PossessionView) and (not viewItem.PossessionView.Enabled)
    and (not GetAutoEnableNesting(Sender)) then
  begin
    viewItem.PossessionView.Enabled := True;
    Cancel := true;
    exit;
  end;

  if Assigned(viewItem) and (Length(URL) > 0) and (not viewItem.ValidateURI(URL, URI)) then
    Cancel := True
  else if AnsiStartsStr('http://', URI) or AnsiStartsStr('https://', URI) then
  begin
    Cancel := true;
    if (not Config.hintNestingPopUp) or Assigned(viewItem.PossessionView) or
      GetAutoEnableNesting(Sender) or MustGo then
    begin
      if not NavigateIntoView(URI, gtOther, true, Config.oprUrlBgOpen) then
      begin
        {beginner}
        if ImageForm.GetImage(URI,viewitem) then
          ImageForm.ShowImageHint(URI,False)
        else
        {/beginner}
        begin //koreawatcher
          OpenByBrowser(URI);
          ReleasePopupHint(nil, True);
      {koreawatcher}
        end
      end
      else
        ReleasePopupHint(nil, True)
      {/koreawatcher}
    end else
    begin
      if Show2chInfo(Point, URL, URI, viewItem, Config.hintNestingPopUp and
        (GetKeyState(VK_SHIFT) >= 0)) then
      begin
        if Assigned(viewItem.PossessionView) then
          viewItem.PossessionView.Enabled := True;
      end else
      {beginner}
      if ImageForm.GetImage(URI,viewitem) then
        ImageForm.ShowImageHint(URI,False)
      else
      {/beginner}
        OpenByBrowser(URI);
    end;
  end
  else if AnsiCompareStr('about:blank', URI) = 0 then
  begin end
  else if AnsiStartsStr('file://', URI) or AnsiStartsStr('about:', URI) or
          AnsiStartsStr('#', URI) then
  begin
    Cancel := true;
    if (not Config.hintNestingPopUp) or Assigned(viewItem.PossessionView) or
      GetAutoEnableNesting(Sender) or MustGo then
      Scroll(viewItem)
    else
    begin
      BrowserStatusTextChange(Sender, URL, Point); //URIでもたぶんOK
      if Assigned(viewItem.PossessionView) then
        viewItem.PossessionView.Enabled := True;
    end;
  end
  else if AnsiStartsStr('menu:', URI) and (viewItem.thread <> nil) then
  begin
    Cancel := true;
    try
      PopupViewMenu.PopupComponent := TComponent(Sender);
      PopupTextMenu.PopupComponent := nil; //コマンドの誤動作防止

      PopupViewReply.Tag := StrToInt(Copy(URI, 6, High(integer)));
      PopupViewReply.Enabled := (viewItem.thread.state = tsCurrency) and
                                ((0 < viewItem.thread.number) or ThreadIsNew(viewItem.thread));
      PopupViewReplyWithQuotation.Tag := PopupViewReply.Tag;
      PopupViewReplyWithQuotation.Enabled := PopupViewReply.Enabled;
      {aiai}
      PopupViewReplyWithQuotationOnWriteMemo.Tag := PopupViewReply.Tag;
      PopupViewReplyWithQuotationOnWriteMemo.Enabled := PopupViewReply.Enabled;
      PopupViewReplyOnWriteMemo.Tag := PopupViewReply.Tag;
      PopupViewReplyOnWriteMemo.Enabled := PopupViewReply.Enabled;
      PopupViewAddAAList.Tag := PopupViewReply.Tag;
      PopupViewCopyData.Tag := PopupViewReply.Tag;
      PopupViewCopyRD.Tag := PopupViewReply.Tag;
      PopupViewCopyURL.Tag := PopupViewReply.Tag;
      {/aiai}
      PopupViewCopyReference.Tag := PopupViewReply.Tag;//▼
      PopupViewAbone.Tag := PopupViewReply.Tag;//※[457]
      PopupViewTransParencyAbone.Tag := PopupViewReply.Tag;
      PopupViewBlockAbone.Tag := PopupViewReply.Tag;//※[457]
      PopupViewBlockAbone2.Tag := PopupViewReply.Tag;//※[457]
      PopupViewBlockAbone3.Tag := PopupViewReply.Tag;
      PopupViewSetReadPos.Tag := PopupViewReply.Tag;
      PopupViewSetCheckRes.Tag := PopupViewReply.Tag;
      PopupViewJump.Tag := PopupViewReply.Tag;
      PopupViewJump.Visible := viewItem is TPopupViewItem;
      {beginner}
      if viewItem.thread.AboneArray[PopupViewSetCheckRes.Tag] = 4 then
        PopupViewSetCheckRes.Caption := 'このレスをチェック解除(&K)'
      else
        PopupViewSetCheckRes.Caption := 'このレスをチェック(&K)';
      PopupViewAddNgName.Tag := PopupViewReply.Tag;
      PopupViewAddNgAddr.Tag := PopupViewReply.Tag;
      PopupViewAddNgWord.Tag := PopupViewReply.Tag;
      PopupViewAddNgId.Tag := PopupViewReply.Tag;
      PopupViewOpenImage.Tag := PopupViewReply.Tag;
      PopupViewShowResTree.Tag := PopupViewReply.Tag;
      PopupViewShowOutLine.Tag := PopupViewReply.Tag;

      if viewItem.thread.AboneArray[PopupViewReply.Tag] = 2 then
        PopupViewTransParencyAbone.Caption := '透明あぼ～ん解除(&T)'
      else
        PopupViewTransParencyAbone.Caption := '透明あぼ～ん(&A)';
      {/beginner}

      {beginner} //あぼーんのレスをチェック可能に(NGを例外的にあぼーん解除するため)
      if viewItem.thread.AboneArray[PopupViewReply.Tag] = 1 then
        PopupViewAbone.Caption := 'あぼ～ん解除(&A)'
      else
        PopupViewAbone.Caption := 'あぼ～ん(&A)';
      {/beginner}

      if viewItem.thread.AboneArray[PopupViewReply.Tag] = 4 then
        PopupViewSetCheckRes.Caption := 'ここのチェックを解除(&K)'
      else
        PopupViewSetCheckRes.Caption := 'このレスをチェック(&K)';

      PopupViewSetReadPos.Visible := (viewItem is TViewItem);
      if viewItem.thread.ReadPos = PopupViewReply.Tag then
        PopupViewSetReadPos.Caption := '「ここまで読んだ」を解除(&B)'
      else
        PopupViewSetReadPos.Caption := 'ここまで読んだ(&B)';

      activeView := GetActiveView;
      PopupViewBlockAbone.Visible := (Assigned(activeView) and (viewItem.thread = activeView.thread));
      if (not (PopupViewBlockAbone.Visible)) or (viewItem.thread.selectedaboneline = 0) then
      begin
        PopupViewBlockAbone.Caption := 'ここからあぼ～ん(&S)';
        PopupViewBlockAbone2.Visible := false;
        PopupViewBlockAbone3.Visible := false;
      end
      else
      begin
        PopupViewBlockAbone.Caption :=
          IntToStr(viewItem.thread.selectedaboneline) + 'からここまであぼ～ん(&S)';
        PopupViewBlockAbone2.Caption :=
          IntToStr(viewItem.thread.selectedaboneline) + 'からここまであぼ～ん解除(&C)';
        PopupViewBlockAbone2.Visible := true;
        PopupViewBlockAbone3.Caption :=
          IntToStr(viewItem.thread.selectedaboneline) + 'からここまで透明あぼ～ん(&P)';
        PopupViewBlockAbone3.Visible := true;
      end;
      try
        viewItem.Lock;
        PopupViewMenu.Popup(Point.X, Point.Y);
      finally
        viewItem.UnLock;
      end;
    except
    end;
  end else
  {aiai}
  //IDポップアップ
  if Config.ojvIDPopUp and not Config.ojvIDPopOnMOver
     and  AnsiStartsStr('ID:', URI) then
  begin
    cancel := true;
    if (viewItem.thread = nil) then
      exit;
    SetString(URI, PChar(URL) + 3, Length(URL) - 3);
    if Length(URI) <= 0 then
      exit;
    newViewItem := NewPopUpView(viewItem);
    try
      newViewItem.ExtractID(URL, viewItem.thread , URI,
                             Config.ojvIDPopUpMaxCount, Point);
      if Assigned(viewItem.PossessionView) then
      begin
        viewItem.PossessionView.Enabled := true;
        viewItem.PossessionView.OwnerCofirmation := true;
      end;
    finally
    end;
  //BE
  end else if AnsiStartsStr('BE:', URI) then
  begin
    cancel := true;
    ShowProfile(URI);
  end else
  {/aiai}
  ReleasePopupHint(viewItem, True);
end;

procedure TMainWnd.ListPopupMenuPopup(Sender: TObject);
var
  item: TListItem;
begin
  (*  *)
  item := ListView.Selected;
  if item = nil then
    exit;
  ListViewSelectItem(ListView, item, true);
end;


(*  *)
procedure TMainWnd.ListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  haveData: boolean;
  thread: TThreadItem;
begin
  if Selected then
  begin
    ListView.PopupMenu := ListPopupMenu;
    if ListView.SelCount > 1 then
    begin
      self.actListOpenNew.Enabled := false;
      self.actListOpenCurrent.Enabled := false;
      self.actListOpenHide.Enabled := false;
      self.actListToggleMarker.Enabled := true;
      self.actListAddFav.Enabled := true;
      self.actListAddFav.Checked := false;
      self.actListDelFav.Enabled := true;
      self.actListOpenByBrowser.Enabled := false;
      self.actListDelLog.Enabled := true;
      self.actListToggleMarker.Checked := false;
      {aiai}
      self.actListAlready.Enabled := false;
      self.actListCopyDat.Enabled := true;
      self.actListCopyDI.Enabled := true;
      self.actThreadAbone2.Enabled := true;
      {/aiai}
    end
    else begin
      thread := TThreadItem(Item.Data);
      haveData := (0 < thread.lines);
      self.actListOpenNew.Enabled := true;
      self.actListOpenCurrent.Enabled := true;
      self.actListOpenHide.Enabled := true;
      self.actListToggleMarker.Enabled := haveData;
      self.actListAddFav.Enabled := haveData;
      self.actListAddFav.Checked := IsFavorite(thread);
      self.actListDelFav.Enabled := actListAddFav.Checked;
      self.actListOpenByBrowser.Enabled := true;
      self.actListDelLog.Enabled := haveData;
      self.actListToggleMarker.Checked := (TThreadItem(Item.Data).mark = timMARKER);
      {aiai}
      self.actListAlready.Enabled := haveData and (thread.lines > thread.oldlines);
      self.actListCopyDat.Enabled := haveData;
      self.actListCopyDI.Enabled := haveData;
      self.actThreadAbone2.Enabled := thread.ThreAboneType and TThreABNFLAG = TThreABNFLAG;
      {/aiai}
    end;
    self.actListCopyURL.Enabled := true;
    self.actListCopyTITLE.Enabled := true; //aiai
    self.actListCopyTU.Enabled := true;
    self.actThreadAbone.Enabled := not (CurrentBoard is TFunctionalBoard); //aiai
    self.actThreadAbone3.Enabled := not (CurrentBoard is TFunctionalBoard); //aiai
    self.actThreadAbone4.Enabled := not (CurrentBoard is TFunctionalBoard);  //aiai
    self.actThreadAbone2.Visible := not (CurrentBoard is TFunctionalBoard);  //aiai
    currentBoard.selDatName := TThreadItem(Item.Data).datName;
  end
  else begin
    ListView.PopupMenu := nil;
    self.actListOpenNew.Enabled := false;
    self.actListOpenCurrent.Enabled := false;
    self.actListOpenHide.Enabled := false;
    self.actListToggleMarker.Enabled := false;
    self.actListAddFav.Enabled := false;
    self.actListAddFav.Checked := false;
    self.actListDelFav.Enabled := false;
    self.actListDelLog.Enabled := false;
    self.actListToggleMarker.Checked := false;
    self.actListOpenByBrowser.Enabled := false;
    self.actListCopyURL.Enabled := false;
    self.actListCopyTU.Enabled := false;
    self.actListOpenByBrowser.Enabled := false;
    {aiai}
    self.actListCopyTITLE.Enabled := false;
    self.actListAlready.Enabled := false;
    self.actListCopyDat.Enabled := false;
    self.actListCopyDI.Enabled := false;
    self.actThreadAbone.Enabled := false;
    self.actThreadAbone3.Enabled := false;
    self.actThreadAbone4.Enabled := false;
    self.actThreadAbone2.Visible := false;
    {/aiai}
  end;
end;

(*  *)
procedure TMainWnd.AppDeactivate(Sender: TObject);
begin
  ReleasePopupHint;
end;

(*  *)
procedure TMainWnd.FormDeactivate(Sender: TObject);
begin
  AppDeactivate(Sender);
end;


(*  *)
procedure TMainWnd.HintTimerTimer(Sender: TObject);
var
  s: string;
begin
  Self.HintTimer.Enabled := false;
  s := urlHeadCache.GetContents(self.hintURI);
  if 0 < length(s) then
    ShowHint(Mouse.CursorPos, s, Config.hintForURLWidth, Config.hintForURLHeight);
end;


(*  *)
procedure TMainWnd.MenuThreadRefreshClick(Sender: TObject);
begin
  if currentBoard <> nil then
    ListViewNavigate(currentBoard, gotCHECK);
end;

(*  *)
procedure TMainWnd.ZoomClick(Sender: TObject);
var
  i: integer;
begin
  Config.viewZoomSize := 4 - TMenuItem(Sender).MenuIndex;
  SetZoomState(Config.viewZoomSize);

  viewListLock.Wait;
  for i := 0 to viewList.Count -1 do
  begin
    viewList.Items[i].ZoomBrowser(Config.viewZoomSize);
  end;
  viewListLock.Release;
  Config.Save;
end;

(*  *)
procedure TMainWnd.SetZoomState(zoom: integer);
var
  i, idx: integer;
begin
  idx := 4 - zoom;
  for i := 0 to 4 do
  begin
    if i = idx then
      {ViewZoom}ZoomG.Parent.items[i].Checked := true
    else
      {ViewZoom}ZoomG.Parent.items[i].Checked := false;
  end;
end;

(* オートリロード and オートスクロール *)
procedure TMainWnd.actAutoReScExecute(Sender: TObject);
begin
  if sender is TToolbutton then
    Log('ToolButton');

  actAutoReSc.Checked := not actAutoReSc.Checked;

  if actAutoReSc.Checked then begin
    StartAutoReSc;
    TabControl.Refresh;
  end else begin
    StopAutoReSc;
    TabControl.Refresh;
  end;
end;

procedure TMainWnd.actScrollToNewExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  viewItem := GetActiveView;
  if viewItem <> nil then
  begin
    viewItem.ScrollToNewRes;
  end;
end;

procedure TMainWnd.ThreadChkNewResButtonClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  WriteStatus('');
  viewItem := GetActiveView;
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    viewItem.thread.anchorLine := viewItem.thread.lines;
    viewItem.NewRequest(viewItem.thread, gotCHECK, -1, false,
                         Config.oprCheckNewWRedraw xor (GetKeyState(VK_SHIFT) < 0));
    //TabControl.Refresh;
    UpdateTabTexts;
    SetRPane(ptView);
    {aiai}
    if Config.optSetFocusOnWriteMemo then
       try MemoWriteMain.SetFocus; except end;
    {/aiai}
  end;
end;

procedure TMainWnd.ThreadWriteButtonClick(Sender: TObject);
begin
  (*  *)
  OpenWriteForm(GetActiveView, '');
end;

procedure TMainWnd.actBuildThreadExecute(Sender: TObject);
{var
  viewItem: TViewItem;}
begin
  if not Config.oprToggleRView or (mdRPane = ptList) then
  {begin
    viewItem := GetActiveView;
    if assigned(viewItem) and assigned(viewItem.thread) then
      OpenWriteForm(viewItem.thread.board, '')
  end else}
    OpenWriteForm(currentBoard, '');
end;

procedure TMainWnd.PopupTreeBuildThreadClick(Sender: TObject);
begin
  OpenWriteForm(TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex]),'');
end;

(* 実験 *)
function TMainWnd.Show2chInfo(const Point: TPoint; const IdStr: String;
  const URI: string; OwnerView: TBaseViewItem; Nesting: Boolean): boolean;
var
  newView: TPopupViewItem;
  dest: TStrDatOutForHint;  //aiai
  host, bbs, datnum: string;
  board: TBoard;
  thread: TThreadItem;
  baseThread: TThreadItem;
  oldLog: boolean;
  rangearray: TRangeArray;
begin
  result := false;

  if not Application.Active then
    exit;

  baseThread := nil;
  if StartWith('http:', URI, 1) then
  begin
    Get2chInfo(URI, host, bbs, datnum, rangearray, oldLog);
    board := i2ch.FindBoard(host, bbs);
    thread := nil;
  end else if Assigned(OwnerView) then
  begin
    GetRangeFromText(URI, rangearray);
    if rangearray[0].st >= 0 then
    begin
      baseThread := OwnerView.thread;
      thread := baseThread;
      board :=  thread.board as TBoard;
    end else
      exit;
  end else
    exit;

  if board <> nil then
  begin
    board.AddRef;
    try
      if thread = nil then
        thread := board.Find(datnum);
      if Nesting then
      begin
        newView := NewPopUpView(OwnerView);
        newView.Show2chInfo(IdStr, URI, board, thread, rangearray, Point);
      end else
      begin
        if Assigned(OwnerView) then
          OwnerView.ReleasePossessionView;
        dest := TStrDatOutForHint.Create;  //aiai
        try
          if Assigned(thread) and (not Assigned(thread.dat)) then
          begin
            thread.AddRef;
            Make2chInfo(dest, URI, baseThread, board, thread, rangearray);
            thread.Release;
          end else
            Make2chInfo(dest, URI, baseThread, board, thread, rangearray);
          with dest as TStrDatOutForHint do  //aiai
          begin
            if Text <> '' then
              ShowHint(Point, Text);
          end;
        finally
          dest.Free;
        end;
      end;
    finally
      board.Release;
    end;
    result := true;
  end;
end;

//aiai (* IDポップアップ *)
function TMainWnd.ShowIDInfo(const Point: TPoint; const IDStr: String;
        const URI: string; OwnerView: TBaseViewITem;
                Nesting: Boolean): boolean;
var
  newviewItem: TPopupViewItem;
  dest: TStrDatOutForHint;
  thread: TThreadItem;
begin
  result := false;
  if not Application.Active then
    exit;
  if not Assigned(OwnerView) then
    exit;
  if Nesting then begin
    newViewItem := NewPopUpView(OwnerView);
    newViewItem.ExtractID(IDStr, OwnerView.thread, URI,
              Config.ojvIDPopUpMaxCount, Point);
  end else begin
    OwnerView.ReleasePossessionView;
    thread := OwnerView.thread;
    if thread <> nil then begin
      dest := TStrDatOutForHint.Create;
      try
        thread.AddRef;
        MakeIDInfo(dest, URI, OwnerView.thread, Config.ojvIDPopUpMaxCount);
        thread.Release;
        with dest as TStrDatOutForHint do
          if Text <> '' then ShowHint(Point, Text);
      finally
        dest.Free;
      end;
    end;
  end;
  result := true;
end;

(*  *)
procedure TMainWnd.TabControlChange(Sender: TObject);
var
  newTab: integer;
begin
  if viewList = nil then
    exit;
  newTab := TTabControl(Sender).TabIndex;
  if (newTab < 0) or (viewList.Count <= newTab) then
    exit;
  UpdateCurrentView(newTab);
  ViewItemStateChanged;


  StopAutoReSc;
end;

(* タブクリック *)
procedure TMainWnd.TabControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  viewItem: TViewItem;
begin
  case Button of
  mbLeft:
    begin
      if ListTabControl.Style <> tsTabs then //※[457] tsTabsだとOnChangeでタブの絶対座標が変わる事があるので
        tabDragSourceIndex := TabControl.IndexOfTabAt(X, Y)
      else
        tabDragSourceIndex := TabControl.TabIndex;
      TabControl.BeginDrag(false, 5);
    end;
  mbMiddle:
    begin
      tabRightClickedIndex := TabControl.IndexOfTabAt(X, Y);
      if ssAlt in Shift then
        actCloseThisTabWOSaveExecute(Sender)
      else
        actCloseThisTabExecute(Sender);
    end;
  mbRight:
    begin
      tabRightClickedIndex := TabControl.IndexOfTabAt(X, Y);
    end;
  end;
  viewItem := GetActiveView;
  if viewItem <> nil then
  try
    viewItem.browser.SetFocus;
  except
  end;
end;

(* ビューを削除する *)
procedure TMainWnd.DeleteView(index:integer; savePos: boolean = True);
begin
  if (0 <= index) then
  begin
    ThreadClosing(viewList.Items[index].thread);
    TabControl.Tabs.Delete(index);
    viewListLock.Wait;
    viewList.Items[index].browser.TabStop := false;
    if savePos then
      viewList.Items[index].Cancel;
    viewList.Items[index].FreeThread(savePos);
    viewList.Delete(index);
    viewListLock.Release;
    ListView.Invalidate;
    //UpdateTabTexts;
  end;
end;

(* タブのヒント *)
procedure TMainWnd.TabControlMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
  function toHintString(const str: WideString): string;
  var
    i: integer;
  begin
    for i := 1 to length(str) do
    begin
      if str[i] = '|' then
        result := result + '｜'
      else
        result := result + str[i];
    end;
  end;
var
  index: integer;
  thread: TThreadItem;
  s, datSize: string;
begin
  (*  *)
  ReleasePopupHint;
  index := TabControl.IndexOfTabAt(X, Y);
  TabControl.Hint := '';
  s := '';
  if 0 <= index then
  begin
    thread := viewList.Items[index].thread;
    if thread <> nil then
    begin
      if thread.oldLines < thread.lines then
        s := Format(#13#10'   －新着 %d件－', [thread.lines - thread.anchorLine]);
      if thread.state = tsComplete then
        s := s + #13#10'   －過去ログ－';
      if assigned(thread.dat) then
        datSize := '   －' + IntToStr(thread.dat.Size div 1024) + 'KB －'
      else
        datSize := '   －dat削除済み－';
      TabControl.Hint := ToHintString(
                          TCategory(TBoard(thread.board).category).name
                        + ' [' + TBoard(thread.board).name + ']'#13#10
                        + HTML2String(thread.title) + s + #13#10 + datSize);
    end
    else if viewList.Items[index].HintText <> '' then
    begin
      TabControl.Hint := viewList.Items[index].HintText;
    end;
  end;
end;

(* タブ周りの設定：名前はそのうち変えよう *)
procedure TMainWnd.UpdateTabTexts(refresh: boolean = false);
  function TabString(const str: WideString): string;
  begin
    if Config.optCharsInTab < length(str) then
      result := Copy(str, 1, Config.optCharsInTab) + '...'
    else
      result := str;
  end;

var
  i: integer;
begin
  ViewItemStateChanged;
  //▼タブ幅固定のときは文字数制限しない
  if (viewList.Count = 1) or (TabControl.TabWidth > 0) then
    for i := 0 to viewList.Count -1 do
    begin
      if (viewList.Items[i].thread <> nil) and
         ((TabControl.Tabs.Strings[i] = '') or refresh) then
      begin
        TabControl.Tabs.Strings[i] := Copy(AnsiReplaceText(HTML2String(viewList.Items[i].thread.title),
                                                    '&', '&&'), 1, 4095);
        SetWindowText(viewList.Items[i].browser.Handle, PChar(TabControl.Tabs.Strings[i]));
      end;
    end
  else
    for i := 0 to viewList.Count -1 do
    begin
      if (viewList.Items[i].thread <> nil) and
         (not AnsiEndsStr('...', TabControl.Tabs.Strings[i]) or refresh) then
      begin
        TabControl.Tabs.Strings[i] := AnsiReplaceText(TabString(HTML2String(viewList.Items[i].thread.title)),
                                                    '&', '&&');
        SetWindowText(viewList.Items[i].browser.Handle, PChar(Copy(AnsiReplaceText(HTML2String(viewList.Items[i].thread.title),
                                                    '&', '&&'), 1, 4095)));
      end;
  	end;

  //※[JS]タブ行の調節
  ThreadTabLineAdjust;
end;

(* タブを閉じる *)
procedure TMainWnd.CloseThisTab(refresh: Boolean = True);
var
  actvTab: boolean;
  viewItem: TViewItem; //aiai
  index: Integer;
begin
  {aiai}
  viewItem := viewList.Items[tabRightClickedIndex];

  //このタブは閉じない
  if (viewItem <> nil) and (viewItem.thread <> nil) and not viewItem.thread.canclose then
    exit;

  //オートリロード中のスレを閉じた時
  StopAutoReSc;
  {/aiai}

  actvTab := (tabRightClickedIndex = TabControl.TabIndex);
  DeleteView(tabRightClickedIndex);
  //▼連続で閉じたときタブが見えなくなる問題の対策
  if not TabControl.MultiLine then
    TabControl.ScrollTabs(-1);
  if actvTab then
    case Config.oprViewClosePos of
    tcpLeft:
      begin
        if tabRightClickedIndex > 0 then
          SetCurrentView(tabRightClickedIndex -1)
        else
          SetCurrentView(0);
      end;
    tcpRight:
      SetCurrentView(tabRightClickedIndex);
    else //tcpPrev;
      begin
        index := viewList.FindFirstViewItem;
        if index >= 0 then
          SetCurrentView(index)
        else
          SetCurrentView(tabRightClickedIndex);
      end;
    end;
  if refresh then
  begin
    UpdateTabTexts;
    ListView.DoubleBuffered := True;
    ListView.Update;
    ListView.DoubleBuffered := False;
  end;
end;

procedure TMainWnd.actCloseThisTabExecute(Sender: TObject);
begin
  CloseThisTab;
end;

procedure TMainWnd.actCloseOtherTabsExecute(Sender: TObject);
var
  i :integer; //aiai
  index: integer; //aiai
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  TabControl.TabIndex := -1;
  {aiai}//「このタブは閉じない」は閉じない
 {while tabRightClickedIndex +1 < TabControl.Tabs.Count do
  begin
    DeleteView(tabRightClickedIndex+1);
  end;
  while 1 < TabControl.Tabs.Count do
  begin
    DeleteView(0);
  end;
  TabControl.TabIndex := 0;}

  index := tabRightClickedIndex + 1;   //このタブより右を閉じる
  while index < TabControl.Tabs.Count do
    if (viewList.Items[index].thread = nil)
       or viewList.Items[index].thread.canclose then
      DeleteView(index)
    else Inc(index);
  index := 0;                          //このタブより左を閉じる
  for i := 0 to tabRightClickedIndex - 1 do
    if (viewList.Items[index].thread = nil)
        or viewList.Items[index].thread.canclose then
      DeleteView(index)
    else Inc(index);
  TabControl.TabIndex := index;
  {/aiai}
  UpdateCurrentView(0);
  UpdateTabTexts;
  ListView.DoubleBuffered := True;
  ListView.Update;
  ListView.DoubleBuffered := False;
end;

procedure TMainWnd.actCloseThisTabWOSaveExecute(Sender: TObject);
begin
  (*  *)
  {aiai} //このタブは閉じない
  if (viewList.Items[tabRightClickedIndex].thread <> nil) and not viewList.Items[tabRightClickedIndex].thread.canclose then
    exit;
  {/aiai}
  DeleteView(tabRightClickedIndex, False);
  SetCurrentView(tabRightClickedIndex);
  UpdateTabTexts;
  ListView.DoubleBuffered := True;
  ListView.Update;
  ListView.DoubleBuffered := False;
end;

procedure TMainWnd.actStopExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  if tabRightClickedIndex >= viewList.Count then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    viewItem.thread.CancelAsyncRead;
  end;
end;


procedure TMainWnd.MenuThreCloseClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actCloseThisTabExecute(Sender);
end;

(* 既読にして閉じる *) //aiai
procedure TMainWnd.MenuThreCloseAndAlreadyClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actCloseThisTabExecute(Sender);
end;

procedure TMainWnd.MenuThreCloseOtherTabsClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actCloseOtherTabsExecute(Sender);
end;

procedure TMainWnd.MenuThreCloseWOSaveClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actCloseThisTabWOSaveExecute(Sender);
end;


procedure TMainWnd.MenuThreStopClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  actStopExecute(Sender);
end;

procedure TMainWnd.actToggleMarkerExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ThreadToggleMarker(Sender);
end;

procedure TMainWnd.ThreadToggleMarker(Sender: TObject);
var
  thread: TThreadItem;
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  thread := viewList.Items[tabRightClickedIndex].thread;
  if thread = nil then
    exit;
  if IsFavorite(thread) and (thread.mark = timMARKER) then
    exit;
  case thread.mark of
  timNONE:     thread.mark := timMARKER;
  timMARKER: thread.mark := timNONE;
  end;
  UpdateThreadInfo(thread);
end;

procedure TMainWnd.ThreadPopupMenuPopup(Sender: TObject);
var
  viewItem: TViewItem;
begin
  if (tabRightClickedIndex < 0) or (tabRightClickedIndex >= viewList.Count) then
  begin
    with TabControl.ScreenToClient(mouse.CursorPos) do
      tabRightClickedIndex := TabControl.IndexOfTabAt(X, Y);
  end;
  viewItem := viewList.Items[tabRightClickedIndex];
  SetThreadMenuContext(viewItem);
  actStop.Enabled := Assigned(viewItem) and Assigned(viewItem.thread) and
                     viewItem.thread.Downloading;
end;

procedure TMainWnd.SetThreadMenuContext(viewItem: TViewItem);
begin
  if (viewItem = nil) or (viewItem.thread = nil) then
  begin
    actToggleMarker.Checked := false;
    ViewPopupMark.Checked := false;
    ViewPopupMark.Enabled := false;
    ViewPopupRes.Enabled := false;
    ViewPopupCheckNew.Enabled := false;
    ViewPopupReload.Enabled := false;
    ViewPopupStop.Enabled := false;
    ViewPopupFavorite.Enabled := false;
    ViewPopupFavorite.Checked := false;
    ViewPopupDelFav.Enabled := false;
    ViewPopupURLCopy.Enabled := false;
    ViewPopupTUCopy.Enabled := false;
    ViewPopupDel.Enabled := false;
    ViewPopupOpenBoard.Enabled := false;
    {aiai}
    ViewPopupTITLECopy.Enabled := false;
    ViewPopupSaveDat.Enabled := false;
    ViewPopupCopyDAT.Enabled := false;
    ViewPopupCopyDI.Enabled  := false;
    ViewPopupSetAlready.Enabled := false;
    ViewPopupNotClose.Enabled := false;
    ViewPopupNotclose.Checked := false;
    ViewPopupToggleAutoScroll.Enabled := false;
    ViewPopupToggleAutoScroll.Checked := false;
    ViewPopupToggleAutoReload.Enabled := false;
    ViewPopupToggleAutoReload.Checked := false;
    ViewPopupToggleAutoReSc.Enabled := false;
    ViewPopupToggleAutoReSc.Checked := false;
    {/aiai}
  end
  else begin
    actToggleMarker.Checked := (viewItem.thread.mark = timMARKER);
    ViewPopupMark.Checked := (viewItem.thread.mark = timMARKER);

    ViewPopupMark.Enabled := assigned(viewItem.thread.dat);
    ViewPopupRes.Enabled := (viewItem.thread.state = tsCurrency) and
                            ((0 < viewItem.thread.number) or
                             ThreadIsNew(viewItem.thread));
    ViewPopupCheckNew.Enabled := viewItem.thread.state = tsCurrency;
    ViewPopupReload.Enabled := true;
    ViewPopupFavorite.Enabled := assigned(viewItem.thread.dat);
    ViewPopupFavorite.Checked := IsFavorite(viewItem.thread);
    ViewPopupDelFav.Enabled := ViewPopupFavorite.Checked;
    ViewPopupURLCopy.Enabled := true;
    ViewPopupTUCopy.Enabled := true;
    ViewPopupDel.Enabled := assigned(viewItem.thread.dat);
    ViewPopupOpenBoard.Enabled := true;
    {aiai}
    ViewPopupTITLECopy.Enabled := true;
    ViewPopupSaveDat.Enabled := assigned(viewItem.thread.dat);
    ViewPopupCopyDat.Enabled := assigned(viewItem.thread.dat);
    ViewPopupCopyDI.Enabled  := assigned(viewItem.thread.dat);
    ViewPopupSetAlready.Enabled := (viewItem.thread.oldLines < viewItem.thread.lines);
    ViewPopupNotClose.Enabled := true;
    ViewPopupNotClose.Checked := not viewItem.thread.canclose;
    ViewPopupToggleAutoScroll.Enabled := true;
    ViewPopupToggleAutoScroll.Checked := (AutoScroll <> nil) and (AutoScroll.State <> scrStopNormal);
    ViewPopupToggleAutoReload.Enabled := true;
    ViewPopupToggleAutoReload.Checked := (AutoReload <> nil) and (AutoReload.State <> relStop);
    ViewPopupToggleAutoReSc.Enabled := true;
    ViewPopupToggleAutoReSc.Checked := ViewPopupToggleAutoScroll.Checked and ViewPopupToggleAutoReload.Checked
    {/aiai}
  end;
  {aiai}
  case Config.oprAutoScrollSpeed of
    1: Scroll1.Checked := true;
    2: Scroll2.Checked := true;
    3: Scroll3.Checked := true;
    4: Scroll4.Checked := true;
    5: Scroll5.Checked := true;
    6: Scroll6.Checked := true;
    7: Scroll7.Checked := true;
    8: Scroll8.Checked := true;
  else exit;
  end;
  {/aiai}
end;

procedure TMainWnd.ViewPopupCheckNewClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  WriteStatus('');
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    viewItem.thread.anchorLine := viewItem.thread.lines;
    viewItem.NewRequest(viewItem.thread, gotCHECK, -1, false,
                         Config.oprCheckNewWRedraw xor (GetKeyState(VK_SHIFT) < 0));
    UpdateTabTexts;
    SetRPane(ptView);
  end;
end;


procedure TMainWnd.ViewPopupReloadClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  WriteStatus('');
  if tabRightClickedIndex < 0 then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    viewItem.Reload;
    UpdateThreadInfo(viewItem.thread);
    SetRPane(ptView);
  end;
end;

procedure TMainWnd.actReloadExecute(Sender: TObject);
begin
  (*  *)
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupReloadClick(Sender);
end;

{function ListCompare(lParam1, lParam2: TListItem; index: Integer): Integer stdcall;
  function ToInt(const s: string): integer;
  var
    i: integer;
  begin
    if length(s) <= 0 then
    begin
      result := high(integer);
      exit;
    end;
    result := 0;
    for i := 1 to length(s) do
    begin
      if Ord(s[i]) in [Ord('0')..Ord('9')] then
        result := result * 10 + Ord(s[i]) - Ord('0')
      else
        break;
    end;
  end;
begin
  if index = 0 then
  begin
    result := Integer(0 < TThreadItem(lParam2.Data).lines)
            - Integer(0 < TThreadItem(lParam1.Data).lines);
    if result = 0 then
      result := Integer(TThreadItem(lParam2.Data).lines < TThreadItem(lParam2.Data).itemCount)
              - Integer(TThreadItem(lParam1.Data).lines < TThreadItem(lParam1.Data).itemCount);
    if result = 0 then
      result := Ord(TThreadItem(lParam2.Data).mark) - Ord(TThreadItem(lParam1.Data).mark);
  end
  else begin
    dec(index);
    if index = LVSC_TITLE then
    begin
      result := AnsiCompareText(lParam1.SubItems.Strings[index], lParam2.SubItems.Strings[index]);
    end
    else if index = LVSC_DATE then
    begin
      try
        result := ToInt(TThreadItem(lParam1.Data).datName) - ToInt(TThreadItem(lParam2.Data).datName);
      except
        result := 0;
      end;
    end
    else begin
      result := ToInt(lParam1.SubItems.Strings[index]) - ToInt(lParam2.SubItems.Strings[index]);
    end;
  end;
end;}

function XVAL(i:integer):integer;
begin
  if i <= 0 then
    result := high(integer)
  else
    result := i;
end;

function ListCompareFuncNumber(Item1, Item2: Pointer): integer;
begin
  if MainWnd.currentSortColumn = -1 then
    result := (TThreadItem(Item2).number) - (TThreadItem(Item1).number)
  else
    result := XVAL(TThreadItem(Item1).number) - XVAL(TThreadItem(Item2).number);
end;

function ListCompareFuncIndex(Item1, Item2: Pointer): integer;
begin
  result := MainWnd.currentBoard.IndexOf(Item1) - MainWnd.currentBoard.IndexOf(Item2);
  if MainWnd.currentSortColumn = -1 then
    result := -result;
end;

  function GetThreadMaxNum(thread: TThreadItem): integer;
  begin
    case TBoard(thread.board).BBSType of
    bbs2ch:   result := 1000;
    bbsMachi: result := 300;
    else      result := 100000;
    end;
  end;

function ListCompareFuncMarker(Item1, Item2: Pointer): integer;
var
  t1, t2: TThreadItem;
  current: Boolean;
begin
  t1 := Item1;
  t2 := Item2;

  (* Over 1000 とか *)
  current := t2.oldLines < GetThreadMaxNum(t2);
  result := Integer(current) - Integer(t1.oldLines < GetThreadMaxNum(t1));
  if result <> 0 then
    exit;
  (* dat落ちが上がってこないように (aiai) *)
  current := current or (t2.number > 0);
  result := Integer(t2.number > 0) - Integer(t1.number > 0);
  if result <> 0 then
    exit;
  (* 取得レスがあるかどうか *)
  if current then
  begin
    result := Integer(0 < t2.lines) - Integer(0 < t1.lines);
    if result <> 0 then
      exit;
  end;
  (* 更新があるかどうか *)
  result := Integer(t2.lines < t2.itemCount)
          - Integer(t1.lines < t1.itemCount);
  if result <> 0 then
    exit;
  (* 未読があるかどうか *)
  if (0 < t2.lines) and (t2.lines >= t2.itemCount) then
  begin
    result := Integer(t2.oldLines < t2.lines) - Integer(t1.oldLines < t1.lines);
    if result <> 0 then
      exit;
  end;
  (* 印があるかどうか *)
  result := Ord(t2.mark) - Ord(t1.mark);
  if result <> 0 then
    exit;
  result := Ord(t1.state) - Ord(t2.state); //※[457]
  if result <> 0 then
    exit;

  (* 現役で取得レスがない場合 *)
  if current and (0 >= t2.lines) then
  begin
    {aiai}  //新規スレッド
    if Config.optCheckThreadMadeAfterLstMdfy2
          and (MainWnd.CurrentBoard.last2Modified <> '') then
    try
      result := Integer(StrToInt(t2.datName) > CheckNewThreadAfter2)
              - Integer(StrToInt(t1.datName) > CheckNewThreadAfter2);
    except
      result := 0;
    end;
    if result <> 0 then exit;
    {/aiai}
    {beginner}  //新着スレッド
    if Config.optCheckThreadMadeAfterLstMdfy then
    try
      result := Integer(StrToInt(t2.datName) > CheckNewThreadAfter)
              - Integer(StrToInt(t1.datName) > CheckNewThreadAfter);
    except
      Result:=0;
    end;
    {/beginner}
  end;

  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);
end;

function ListCompareFuncTitle(Item1, Item2: Pointer): integer;
begin
  result := AnsiCompareStr(TThreadItem(Item1).title, TThreadItem(Item2).title);
  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);
  //▼逆順
  if MainWnd.currentSortColumn = -LVSC_TITLE then
    result := -result;
end;

function ListCompareFuncItems(Item1, Item2: Pointer): integer;
begin
  if MainWnd.currentSortColumn = -LVSC_ITEMS then
  begin
    result := (TThreadItem(Item2).itemCount) - (TThreadItem(Item1).itemCount);
    if result = 0 then
      result := -ListCompareFuncNumber(Item1, Item2);
  end else
  begin
    result := XVAL(TThreadItem(Item1).itemCount) - XVAL(TThreadItem(Item2).itemCount);
    if result = 0 then
      result := ListCompareFuncNumber(Item1, Item2);
  end;
end;

function ListCompareFuncLines(Item1, Item2: Pointer): integer;
begin
  if MainWnd.currentSortColumn = -LVSC_LINES then
  begin
    result := (TThreadItem(Item2).lines) - (TThreadItem(Item1).lines);
    if result = 0 then
      result := -ListCompareFuncNumber(Item1, Item2);
  end else
  begin
    result := XVAL(TThreadItem(Item1).lines) - XVAL(TThreadItem(Item2).lines);
    if result = 0 then
      result := ListCompareFuncNumber(Item1, Item2);
  end;
end;

function ListCompareFuncNew(Item1, Item2: Pointer): integer;//521
var i1, i2: integer;
begin
  if (0 < TThreadItem(Item1).itemCount) and (0 < TThreadItem(Item1).lines) and (TThreadItem(Item1).itemCount > TThreadItem(Item1).lines) then
    i1 := (TThreadItem(Item1).itemCount - TThreadItem(Item1).lines)
  else
    i1 := 0;
  if (0 < TThreadItem(Item2).itemCount) and (0 < TThreadItem(Item2).lines) and (TThreadItem(Item2).itemCount > TThreadItem(Item2).lines) then
    i2 := (TThreadItem(Item2).itemCount - TThreadItem(Item2).lines)
  else
    i2 := 0;
  //▼逆順
  if MainWnd.currentSortColumn = -LVSC_NEW then
    result := XVAL(i1) - XVAL(i2)
  else
    result := i2 - i1;
  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);
end;

function ListCompareFuncGot(Item1, Item2: Pointer): integer;//521
begin
  if MainWnd.currentSortColumn = -LVSC_GOT then
    result := XVAL(TThreadItem(Item1).LastGot) - XVAL(TThreadItem(Item2).LastGot)
  else
    result := (TThreadItem(Item2).LastGot) - (TThreadItem(Item1).LastGot);
  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);
end;

function ListCompareFuncWrote(Item1, Item2: Pointer): integer;//521
begin
  if MainWnd.currentSortColumn = -LVSC_WROTE then
    result := XVAL(TThreadItem(Item1).LastWrote) - XVAL(TThreadItem(Item2).LastWrote)
  else
    result := (TThreadItem(Item2).LastWrote) - (TThreadItem(Item1).LastWrote);
  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);
end;

function ListCompareFuncSince(Item1, Item2: Pointer): integer;
begin
  try
    result := StrToInt(TThreadItem(Item2).datName)
            - StrToInt(TThreadItem(Item1).datName);
  except
    result := 0;
  end;
  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);
  //▼逆順
  if MainWnd.currentSortColumn = -LVSC_DATE then
    result := -result;
end;

//▼板カラムでのソート
function ListCompareFuncBoard(Item1, Item2: Pointer): integer;
begin
  result := i2ch.IndexOf(TBoard(TThreadItem(Item1).board).category)
          - i2ch.IndexOf(TBoard(TThreadItem(Item2).board).category);
  if result = 0 then
    result := TCategory(TBoard(TThreadItem(Item1).board).category).IndexOf(TThreadItem(Item1).board)
            - TCategory(TBoard(TThreadItem(Item2).board).category).IndexOf(TThreadItem(Item2).board);

  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);

  if MainWnd.currentSortColumn = -LVSC_BOARD then
    result := -result;
end;

//aiai 勢いカラムでのソート
function ListCompareFuncSpeed(Item1, Item2: Pointer): integer;
  function duringtime(Item: Pointer): Integer;
  begin
    result := NowTimeUnix - StrToInt(TThreadItem(Item).datName);
  end;

  function speed(Item: Pointer): integer;
  var
    time: Integer;
  begin
    try
      time := duringtime(Item);
      if time <= -86400 then    (* sinceが一年以上未来の場合勢いを0にする *)
        result := 0
      else begin
        if time <= 0 then
          time := 1;
        result := (TThreadItem(Item).itemCount * 60 * 60 * 24) div time;
      end;
    except
      result := 1;
    end;
  end;

begin
  if MainWnd.currentSortColumn = -LVSC_SPEED then
  begin
    if (TThreadItem(Item1).itemCount = 0) and (TThreadItem(Item2).itemCount = 0) then
      result := ListCompareFuncNumber(Item1, Item2)
    else if TThreadItem(Item1).itemCount = 0 then
      result := 1
    else if TThreadItem(Item2).itemCount = 0 then
      result := -1
    else
      result := speed(Item1) - speed(Item2);
    if result = 0 then
      result := ListCompareFuncNumber(Item1, Item2);
  end else
  begin
    result := speed(Item2) - speed(Item1);
    if result = 0 then
      result := ListCompareFuncNumber(Item1, Item2);
  end;
end;

//aiai 増レスカラムでのソート
function ListCompareFuncGain(Item1, Item2: Pointer): integer;
  function itemcountgain(thread: TThreadItem): integer;
  begin
    if CheckNewThreadAfter2 < StrToIntDef(thread.datName, 0) then
      result := thread.itemCount
    else
      result := thread.itemCount - thread.previousitemCount;
  end;

var
  t1, t2: TThreadItem;
begin
  t1 := TThreadItem(Item1);
  t2 := TThreadItem(Item2);

  if MainWnd.currentBoard.Last2Modified = '' then
  begin
    result := ListCompareFuncNumber(Item1, Item2);
    exit;
  end;
  (* Over 1000 とか *)
  result := Integer(t2.oldLines < GetThreadMaxNum(t2)) - Integer(t1.oldLines < GetThreadMaxNum(t1));
  if result <> 0 then
    exit;
  (* dat落ち *)
  result := Integer(t2.number > 0) - Integer(t1.number > 0);
  if result <> 0 then
    exit;

  result := Integer(t2.itemCount >= t2.previousitemCount) - Integer(t1.itemCount >= t1.itemCount);
  if result <> 0 then
    exit;

  result := itemcountgain(t1) - itemcountgain(t2);

  if MainWnd.currentSortColumn = LVSC_GAIN then
    result := - result;

  if result = 0 then
    result := ListCompareFuncNumber(Item1, Item2);
end;

//スレ絞込みでのソート
function ListCompareFuncSearchState(Item1, Item2: Pointer): integer;
begin
  Result := TThreadItem(Item2).liststate - TThreadItem(Item1).liststate;
  if Result = 0 then
    {aiai}
    Case Config.stlDefSortColumn of
      0          : Result := ListCompareFuncMarker(Item1, Item2);
      LVSC_NUMBER: Result := ListCompareFuncNumber(Item1, Item2);
      LVSC_TITLE : Result := ListCompareFuncTitle(Item1, Item2);
      LVSC_ITEMS : Result := ListCompareFuncItems(Item1, Item2);
      LVSC_LINES : Result := ListCompareFuncLines(Item1, Item2);
      LVSC_NEW   : Result := ListCompareFuncNew(Item1, Item2);
      LVSC_GOT   : Result := ListCompareFuncGot(Item1, Item2);
      LVSC_WROTE : Result := ListCompareFuncWrote(Item1, Item2);
      LVSC_DATE  : Result := ListCompareFuncSince(Item1, Item2);
      LVSC_BOARD : Result := ListCompareFuncBoard(Item1, Item2);
      LVSC_SPEED : Result := ListCompareFuncSpeed(Item1, Item2);
      LVSC_GAIN  : Result := ListCompareFuncGain(Item1, Item2);
    end;
    {/aiai}
end;


procedure TMainWnd.ListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  (* *)
  ListViewColumnSort(Column.Tag);
end;

procedure TMainWnd.ListViewColumnSort(columnIndex: Integer);
begin
  if CurrentBoard = nil then (* 板を一つも開いていない時はソートしない (aiai) *)
    exit;

  //▼すでにソートされていたら逆順(負号)に設定する
  if columnIndex = currentSortColumn then
  begin
    if currentSortColumn = 0 then
      currentSortColumn := 1
    else
      currentSortColumn := -columnIndex
  end else
    currentSortColumn := columnIndex;

  case abs(currentSortColumn) of
  {beginner}
  0          : begin
                 MakeCheckNewThreadAfter(nil,0,0);
                 ListView.Sort(@ListCompareFuncMarker);
               end;
  {/beginner}

  LVSC_NUMBER:
    begin
      if currentBoardIsFunction then //numberが使えないのでindexでソート
        ListView.Sort(@ListCompareFuncIndex)
      else
        ListView.Sort(@ListCompareFuncNumber);
    end;
  LVSC_TITLE : ListView.Sort(@ListCompareFuncTitle);
  LVSC_ITEMS : ListView.Sort(@ListCompareFuncItems);
  LVSC_LINES : ListView.Sort(@ListCompareFuncLines);
  LVSC_NEW   : ListView.Sort(@ListCompareFuncNew); //521
  LVSC_GOT   : ListView.Sort(@ListCompareFuncGot); //521
  LVSC_WROTE : ListView.Sort(@ListCompareFuncWrote); //521
  LVSC_DATE  : ListView.Sort(@ListCompareFuncSince);
  LVSC_BOARD : ListView.Sort(@ListCompareFuncBoard);
  LVSC_SPEED : ListView.Sort(@ListCompareFuncSpeed); //aiai
  LVSC_GAIN  : ListView.Sort(@ListCompareFuncGain);  //aiai
  end;
end;

procedure TMainWnd.ToggleSortColumn;
begin
  {if self.currentSortColumn = 0 then
    self.currentSortColumn := 1
  else
    self.currentSortColumn := 0;
  ListViewColumnClick(Self, ListView.Columns[self.currentSortColumn]);}

  //▼currentSortColumnはListViewColumnClickで設定
  if self.currentSortColumn = 0 then
    ListViewColumnSort(LVSC_NUMBER)
  else
    ListViewColumnSort(0);
end;

(* スレッド一覧表示を更新するもの也 *)
procedure TMainWnd.UpdateListView;
var
  thread: TThreadItem;
  index: integer;
begin
  MakeCheckNewThreadAfter(nil,0,0); //beginner

  ListView.List := currentBoard;

  {aiai} //過去ログ非表示
  if not (currentBoard is TFunctionalBoard)
    and currentBoard.HideHistoricalLog then
  begin
    index := 0;
    while index < ListView.List.Count do
      if TThreadItem(ListView.List.Items[index]).number <= 0 then
        ListView.List.Delete(index)
      else
        Inc(index);
    ListView.Items.Count := ListView.List.Count;
  end;

  //あぼ～ん非表示
  ThreadAboneFilter;

  currentSortColumn := 1;

  if currentBoard.sortColumn <> 1 then //ソート状態の設定
  begin
    if currentBoard.sortColumn = 100 then
    begin
      ListView.Sort(@ListCompareFuncSearchState);
      currentSortColumn := 100;
    end else
      ListViewColumnSort(currentBoard.sortColumn);
  end;

  //if Config.oprSelPreviousThread then
  if currentBoard.selDatName <> '' then
  begin
    thread := currentBoard.Find(currentBoard.selDatName);
    if thread <> nil then
    begin
      index := ListView.List.IndexOf(thread);
      if 0 <= index then
        ListView.SelectIntoView(ListView.Items[index]);
    end;
  end;
  UpdateListTab;
end;

procedure TMainWnd.ThreadAboneFilter;
var
  index: Integer;
begin
  index := 0;
  case ThreAboneLevel of
   -1: begin //透明
      while index < ListView.List.Count do
        if TThreadItem(ListView.List.Items[index]).ThreAboneType and TThreAboneTypeMASK in [1,2] then //通常、透明
          ListView.List.Delete(index)
        else
          Inc(index);
      ListView.Items.Count := ListView.List.Count;
    end;

    0, 1: begin //通常,さぼり
      while index < ListView.List.Count do
        if TThreadItem(ListView.List.Items[index]).ThreAboneType and TThreAboneTypeMASK = 2 then //透明
          ListView.List.Delete(index)
        else
          Inc(index);
      ListView.Items.Count := ListView.List.Count;
    end;

    2: begin  //よりごのみ
      while index < ListView.List.Count do
        if TThreadItem(ListView.List.Items[index]).ThreAboneType and TThreAboneTypeMASK = 4 then //重要
          Inc(index)
        else
          ListView.List.Delete(index);
      ListView.Items.Count := ListView.List.Count;
    end;

    3: begin //はきだめ
      while index < ListView.List.Count do
        if TThreadItem(ListView.List.Items[index]).ThreAboneType and TThreAboneTypeMASK in [1,2] then //通常、透明
          Inc(index)
        else
          ListView.List.Delete(index);
      ListView.Items.Count := ListView.List.Count;
    end;

  end;
end;

procedure TMainWnd.ViewPopupResClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  OpenWriteForm(viewItem, '');
end;

(* ログから検索 *)
procedure TMainWnd.FindGrepClick(Sender: TObject);
var
  rc: integer;
  target: string;
  viewItem: TViewItem;
begin
  WriteStatus('');
  if GrepDlg = nil then
    GrepDlg := TGrepDlg.Create(self);
  GrepDlg.Caption := 'ログから検索';

  viewItem := GetActiveView;
  if viewItem <> nil then
    GrepDlg.Edit.Text := viewItem.GetSelection;
  if length(GrepDlg.Edit.Text) <= 0 then
    GrepDlg.Edit.Text := searchTarget;
  if (length(GrepDlg.Edit.Text) <= 0) and (GrepDlg.Edit.Items.Count > 0) then
    GrepDlg.Edit.Text := GrepDlg.Edit.Items.Strings[0];  //aiai

  GrepDlg.grepMode := true;
  GrepDlg.extractMode := true; //beginner
  rc := GrepDlg.ShowModal;
  if rc <> 3 then
    exit;
  target := Trim(GrepDlg.Edit.Text);
//  if length(target) <= 0 then
//    exit;
  searchTarget := target;
  SetRPane(ptView);
  NewView.Grep(target, GrepDlg.targetBoardList, GrepDlg.ComboBoxOption.ItemIndex, GrepDlg.RadioGroupSearchRange.ItemIndex=1,
               GrepDlg.CheckBoxPopup.Checked, GrepDlg.CheckBoxShowDirect.Checked, GrepDlg.CheckBoxIncludeRef.Checked,
               StrToInt(GrepDlg.PopupMaxSeqEdit.Text), StrToInt(GrepDlg.PopupEachThreMaxEdit.Text));
  UpdateTabTexts;
end;

{beginner} // キーワード抽出
procedure TMainWnd.actKeywordExtractionExecute(Sender: TObject);
begin
  KeywordExtraction(Sender, False);
end;

{beginner} // 選択キーワードの抽出
procedure TMainWnd.actSelectedKeywordExtractionExecute(Sender: TObject);
begin
  KeywordExtraction(Sender, True);
end;

{aiai} //このIDでレス抽出
procedure TMainWnd.TextPopupExtractIDClick(Sender: TObject);
var
  target, tmp: string;
  viewItem: TBaseViewItem;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  tmp := viewItem.LinkText;
  if not AnsiStartsStr('ID:', tmp) then
    exit;
  SetString(target, PChar(tmp) + 3, Length(tmp) - 3);
  if Length(target) <= 0 then
    exit;
  searchTarget := target;

  NewView(true).ExtractKeyword(target, viewItem.thread, GREP_OPTION_NORMAL, false);
end;

{beginner} // キーワード抽出の実体
procedure TMainWnd.KeywordExtraction(Sender: TObject; UseSelection: Boolean);
var
  rc: integer;
  target:string;
  {aiai}
  //viewItem: TViewItem;
  viewItem: TBaseViewItem;
  {/aiai}
begin
  {aiai}
  if UseSelection and (PopupTextMenu.PopupComponent is THogeTextView) then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if (viewItem=nil) or (viewItem.thread=nil) then
    exit;
  {/aiai}

  if GrepDlg = nil then
    GrepDlg := TGrepDlg.Create(self);
  GrepDlg.Caption := 'レス抽出';

  GrepDlg.Edit.Text := viewItem.GetSelection;

  if length(GrepDlg.Edit.Text) <= 0 then
    GrepDlg.Edit.Text := searchTarget;

  if (length(GrepDlg.Edit.Text) <= 0) and (GrepDlg.Edit.Items.Count > 0) then
    GrepDlg.Edit.Text := GrepDlg.Edit.Items.Strings[0];  //aiai

  GrepDlg.grepMode := false;
  GrepDlg.extractMode := true;

  if not UseSelection then begin
    rc := GrepDlg.ShowModal;
    if Abs(rc) <> 3 then exit; //beginner
  end;

  target := Trim(GrepDlg.Edit.Text);
  searchTarget := target;

  if length(target) <= 0 then
    exit;

  if UseSelection then
    NewView(true).ExtractKeyword(target, viewItem.thread, GREP_OPTION_NORMAL,
      False)
  else
    NewView(true).ExtractKeyword(target, viewItem.thread,
      GrepDlg.ComboBoxOption.ItemIndex, GrepDlg.CheckBoxIncludeRef.Checked);
end;

procedure TMainWnd.FindNavigateClick(Sender: TObject);
var
  rc: integer;
  target: string;
begin
  (*  *)
  if InputDlg = nil then
    InputDlg := TInputDlg.Create(self);

  InputDlg.Caption := 'URLで指定されたスレを表示';
  InputDlg.Edit.Text := Clipboard.AsText;
  rc := InputDlg.ShowModal;
  if rc <> 3 then
    exit;
  target := Trim(InputDlg.Edit.Text);
  if GetKeyState(VK_CONTROL) < 0 then
    OpenByBrowser(target)
  else
    NavigateIntoView(target, gtOther, false, Config.oprAddrBgOpen);
end;

(* お気に入りの表示 *)
procedure TMainWnd.UpdateFavorites;
var
  node: TTreeNode;
  procedure AddNodes(parent: TTreeNode; favs: TFavoriteList);
  var
    i: integer;
    me: TTreeNode;
  begin
    me := FavoriteView.Items.AddChild(parent, favs.name);
    me.Data := favs;
    me.Expanded := favs.expanded;
    if favs is TFavoriteList then
    begin
      //※[JS]
      me.ImageIndex := 0;
      me.SelectedIndex := 0;
    end;
    for i := 0 to favs.Count -1 do
    begin
      if TObject(favs.Items[i]) is TFavorite then
      begin
        node := FavoriteView.Items.AddChild(me, TFavorite(favs.Items[i]).name);
        node.Data := favs.Items[i];
        //※[JS]
        if Length(TFavorite(favs.Items[i]).datName) <= 0 then
        begin
          node.ImageIndex := 1;
          node.SelectedIndex := 1;
        end else
        begin
          node.ImageIndex := 3;
          node.SelectedIndex := 3;
        end;
      end
      else if TObject(favs.Items[i]) is TFavoriteList then
      begin
        AddNodes(me, TFavoriteList(favs.Items[i]));
      end;
    end;
  end;

  function GetVisibleIndex(node: TTreeNode): integer;
  begin
    result := -1;
    while node <> nil do
    begin
      node := node.GetPrevVisible;
      Inc(result);
    end;
  end;

var
  i: integer;
begin
  FavoriteView.Items.BeginUpdate;
  FavoriteView.Items.Clear;
  AddNodes(nil, favorites);
  FavoriteView.Items[0].Expanded := true;
  for i := 0 to FavoriteView.Items.Count -1 do
  begin
    if TObject(FavoriteView.Items[i].Data) is TFavoriteList then
    begin
      FavoriteView.Items[i].Expanded := TFavoriteList(FavoriteView.Items[i].Data).expanded;
    end;
    if i = favorites.selected then
      FavoriteView.Selected := FavoriteView.Items[i];
    {if i = favorites.top then
      FavoriteView.TopItem := FavoriteView.Items[i];}
  end;
  // 水平位置の補正の為だがTop位置への移動にTopItemを止めてSendMessage->WM_VSCROLLしてみた
  SendMessage(FavoriteView.Handle, WM_VSCROLL, SB_TOP, 0);
  SendMessage(FavoriteView.Handle, WM_VSCROLL,
              MakeLong(SB_THUMBPOSITION, GetVisibleIndex(FavoriteView.Items[favorites.top])), 0);
  FavoriteView.Items.EndUpdate;
  UpdateFavoritesMenu;
end;

//※[457] リンクバードラッグ時に表示がおかしくならないようにする
procedure TMainWnd.LinkBarResize(Sender: TObject);
begin
  LinkBar.Wrapable := false;
  LinkBar.Wrapable := true;
end;

procedure TMainWnd.SaveFavorites(save: boolean = true);
var
  i, top, sel: integer;
  node: TTreeNode;
begin
  top := 0;
  sel := -1;
  for i := 0 to FavoriteView.Items.Count -1 do
  begin
    node := FavoriteView.Items[i];
    if TObject(node.Data) is TFavoriteList then
      TFavoriteList(node.Data).expanded := node.Expanded;
    if FavoriteView.TopItem = node then
      top := i;
    if FavoriteView.Selected = node then
      sel := i;
  end;
  favorites.top := top;
  favorites.selected := sel;
  if save then
  begin
    favorites.Save(Config.BasePath + FAVORITES_DAT);
  end;
end;

procedure TMainWnd.PopupFavNewClick(Sender: TObject);
  function NewFolder(var parent: TFavoriteList): TFavoriteList;
  begin
    result := TFavoriteList.Create(parent);
    result.name := 'New Folder';
    result.expanded := false;
    parent.expanded := true;
  end;
var
  node: TTreeNode;
  parent: TFavoriteList;
begin
  node := FavoriteView.Selected;
  SaveFavorites(false);
  if node = nil then
  begin
    parent := favorites;
    parent.Insert(0, NewFolder(parent));
  end
  else if (TObject(node.Data) is TFavoriteList) and (0 <= GetKeyState(VK_CONTROL)) then
  begin
    parent := node.Data;
    parent.Insert(0, NewFolder(parent));
  end
  else begin
    parent := TFavoriteList(node.Parent.Data);
    parent.Insert(parent.IndexOf(node.Data), NewFolder(parent));
  end;
  UpdateFavorites;
end;

procedure TMainWnd.PopupFavDeleteClick(Sender: TObject);
var
  node, tgt: TTreeNode;
begin
  node := FavoriteView.Selected;
  if node = nil then
    exit;
  if node.Data = favorites then
    exit;
  if node.Index = node.Parent.Count -1 then
  begin
    if 0 < node.Index then
      tgt := node.Parent.Item[node.index - 1]
    else
      tgt := node.Parent;
    FavoriteView.Selected := tgt;
    tgt.Selected := true;
    tgt.Focused := true;
  end;
  TObject(node.Data).Free;
  node.Free;
  UpdateFavoritesMenu;
  MenuThreClick(MainWnd);
  daemon.Post(RedrawFavoriteButton);
end;

procedure TMainWnd.FavoriteViewEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  TFavBase(Node.Data).name := S;
  UpdateFavoritesMenu;
  //▼お気に入りの名前変更終了時にIME状態を保存
  SaveImeMode(handle);
  FavoriteView.ReadOnly := True; //beginner
end;

procedure TMainWnd.FavoriteViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  node, node2: TTreeNode;
begin
  //▼アイテム名変更時は無効
  if FavoriteView.IsEditing then
   	exit;

  case Key of
  VK_F2:
    begin
      if FavoriteView.Selected <> nil then
      begin
        FavoriteView.ReadOnly := False; //aiai
        FavoriteView.Selected.EditText;
      end;
    end;
  //▼Deleteを警告付きで復活
  VK_DELETE:
    begin
      if (FavoriteView.Selected <> nil) and
         (FavoriteView.Selected.Data <> favorites) and
         (MessageDlg('削除します', mtWarning, mbOKCancel, -1) = mrOk) then
        PopupFavDeleteClick(Sender);
    end;
  VK_INSERT:
    begin
      PopupFavNewClick(Sender);
    end;
  VK_RETURN:
    begin
      node := FavoriteView.Selected;
      if (node <> nil) and
         (TObject(node.Data) is TFavorite) then
      begin
        with TFavorite(node.Data) do
        begin
          NavigateIntoView(host, bbs, datName, -1, false, gtOther, //▼Shiftで逆転
                           (Config.oprOpenFavWNewView xor (GetKeyState(VK_SHIFT) < 0)),
                           false, Config.oprFavBgOpen);
        end;
      end;
    end;
  VK_PRIOR:
    begin
      if ssCtrl	in Shift then
      begin
        SetTabSetIndex(TreeTabControl.TabIndex - 1);
        Key := 0;
      end;
    end;
  VK_NEXT:
    begin
      if ssCtrl in Shift then
      begin
        SetTabSetIndex(TreeTabControl.TabIndex + 1);
        Key := 0;
      end;
    end;
  //▼Ctrl+Tabでツリー切り替えを追加
  VK_TAB:
    begin
      if ssCtrl	in Shift then
      begin
        SetTabSetIndex(TreeTabControl.TabIndex - 1);
        Key := 0;
      end;
    end;
  //▼お気に入りの順序がえ
  VK_UP:
    begin
      if ssAlt in Shift then
      begin
        key := 0;
        node := FavoriteView.Selected;
        if node = nil then
          exit;
        node2 := node.getPrevSibling;
        if node2 = nil then
          exit;
        TFavBase(node.Data).Remove;
        with TFavoriteList(node.Parent.Data) do
          Insert(IndexOf(node2.Data), TFavBase(node.Data));
        FavoriteView.Items.BeginUpdate;
        node.MoveTo(node2, naInsert);
        FavoriteView.Selected := node;
      	node.Focused := true;
      	SaveFavorites(false);
        UpdateFavoritesMenu;
        FavoriteView.Items.EndUpdate;
      end;
    end;
  VK_DOWN:
    begin
      if ssAlt in Shift then
      begin
        key := 0;
        node := FavoriteView.Selected;
        if node = nil then
          exit;
        node2 := node.getNextSibling;
        if node2 = nil then
          exit;
        TFavBase(node2.Data).Remove;
        with TFavoriteList(node.Parent.Data) do
          Insert(IndexOf(node.Data), TFavBase(node2.Data));
        FavoriteView.Items.BeginUpdate;
        node2.MoveTo(node, naInsert);
        FavoriteView.Selected := node;
        node.Focused := true;
        SaveFavorites(false);
        UpdateFavoritesMenu;
        FavoriteView.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TMainWnd.FavoriteViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if Node.Data = favorites then
    AllowEdit := false;
  //▼IME
  SetImeMode(FavoriteView.Selected.Handle, userImeMode);
end;

(* ドラッグ時の自動展開 *)
procedure TMainWnd.FavTreeExpndTimerTimer(Sender: TObject);
begin
  if MouseInPane(FavoriteView) then
  begin
    FavoriteView.Items[FavTreeExpndTimer.Tag].Expanded := True;
    SaveFavorites(false);
    UpdateFavorites;
  end;
  //FavoriteView.Invalidate;
  FavTreeExpndTimer.Enabled := False;
end;

(* 端までドラッグするとスクロール *)
procedure TMainWnd.FavTreeScrlTimerTimer(Sender: TObject);
var
  nextTarget: TTreeNode;
begin
  if not MouseInPane(FavoriteView) then
  begin
    FavTreeScrlTimer.Enabled := false;
    exit;
  end;

  if (0 < FavoriteView.DropTarget.AbsoluteIndex) and
     (FavoriteView.DropTarget.AbsoluteIndex < FavoriteView.Items.Count - 1) then
  begin
    Case FavTreeScrlTimer.Tag of
      0: nextTarget := FavoriteView.DropTarget.GetPrevVisible;
      1: nextTarget := FavoriteView.DropTarget.GetNextVisible;
      else nextTarget := nil;
    end;
    if nextTarget <> nil then
      FavoriteView.DropTarget := nextTarget;
  end else
    FavTreeScrlTimer.Enabled := false;
  Case FavTreeScrlTimer.Tag of
    0: PostMessage(FavoriteView.Handle, WM_VSCROLL, SB_LINEUP, 0);
    1: PostMessage(FavoriteView.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  end;
  //FavoriteView.Invalidate;
end;

(*  *)
procedure TMainWnd.FavoriteViewCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  AllowCollapse := not (TObject(Node.Data) is TFavorites);
end;

(* ドラッグ時の処理 *)
procedure TMainWnd.FavoriteViewDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  node: TTreeNode;
  si: TScrollInfo;
begin
  FavTreeScrlTimer.Enabled := false;
  FavTreeExpndTimer.Enabled := false;
  Accept := true;

  // 自動スクロール
  si.cbSize := sizeof(TScrollInfo);
  si.fMask := SIF_RANGE or SIF_POS;
  GetScrollInfo(FavoriteView.Handle, SB_VERT, si);
  if (si.nPos > si.nMin) and (Y < 25) then
  begin
    FavTreeScrlTimer.Tag := 0; //UP
    FavTreeScrlTimer.Enabled := true;
    exit;
  end
  else if (si.nPos < si.nMax) and (Y > FavoriteView.Height -45) then
  begin
    FavTreeScrlTimer.Tag := 1; //DOWN
    FavTreeScrlTimer.Enabled := true;
    exit;
  end;

  // 自動展開
  node := FavoriteView.GetNodeAt(X, Y);
  if (node <> nil) and (not node.Expanded) and (0 < node.Count) then
  begin
    FavTreeExpndTimer.Tag := node.AbsoluteIndex;
    FavTreeExpndTimer.Enabled := true;
  end;
end;

(* ドロップ時の処理 *)
procedure TMainWnd.FavoriteViewDragDrop(Sender, Source: TObject; X,
  Y: Integer);
  function IsPosterity(target: TTreeNode; node: TTreeNode): boolean;
  begin
    if target.Parent = nil then
      result := false
    else if target.Parent = node then
      result := true
    else
      result := IsPosterity(target.Parent, node);
  end;
var
  node, src: TTreeNode;
  board: TBoard;
  thread: TThreadItem;
  viewItem: TViewItem;
begin
  FavTreeScrlTimer.Enabled := False;
  FavTreeExpndTimer.Enabled :=false;
  node := FavoriteView.DropTarget;
  if node = nil then
    exit;

  //▼タブドロップでお気に入りのその位置に登録
  if Source = ListTabControl then
  begin
    board := ListTabControl.Tabs.Objects[tabDragSourceIndex] as TBoard;
    //▼重複許可
    if not Config.optAllowFavoriteDuplicate and IsFavorite(board) then
      exit;
    if TObject(node.Data) is TFavoriteList then
      RegisterFavorite(board, TFavoriteList(node.Data), 0)
    else
      RegisterFavorite(board, TFavoriteList(node.Parent.Data), node.Index);
    exit;
  end
  else if Source = TabControl then
  begin
    viewItem := viewList.Items[tabDragSourceIndex];
    thread := viewItem.thread;
    if thread = nil then
      exit;
    //▼重複許可
    if not Config.optAllowFavoriteDuplicate and IsFavorite(thread) then
      exit;
    if TObject(node.Data) is TFavoriteList then
      RegisterFavorite(thread, TFavoriteList(node.Data), 0)
    else
      RegisterFavorite(thread, TFavoriteList(node.Parent.Data), node.Index);
    UpdateThreadInfo(thread);
    exit;
  end;

  src := FavoriteView.Selected;
  if (src = nil) or (src = node) then
    exit;
  if src.Data = favorites then
    exit;
  if IsPosterity(node, src) then
    exit;
  TFavBase(src.Data).Remove;
  if (TObject(node.Data) is TFavoriteList) and
     ((0 <= GetKeyState(VK_CONTROL)) or (TFavoriteList(node.Data) = favorites))
  then
  begin
    TFavoriteList(node.Data).Insert(0, TFavBase(src.Data));
    src.MoveTo(node, naAddChildFirst);
  end
  else begin
    TFavoriteList(node.Parent.Data)
      .Insert(TFavoriteList(node.Parent.Data).IndexOf(node.Data),
              TFavBase(src.Data));
    src.MoveTo(node, naInsert);
  end;
  FavoriteView.Selected := src;
  src.Focused := true;
  SaveFavorites(false);
  if TObject(src.Data) is TFavoriteList then
    UpdateFavorites
  else
    UpdateFavoritesMenu;
end;

procedure TMainWnd.PopupFavoritesPopup(Sender: TObject);
var
  node: TTreeNode;
  b: boolean;
begin
  FavoriteView.Selected := FavoriteView.Selected;
  node := FavoriteView.Selected;
  if node = nil then
    exit;
  PopupFavDelete.Enabled := node.Data <> favorites;
  PopupFavEdit.Enabled   := node.Data <> favorites;
  b := not (TObject(node.Data) is TFavoriteList);
  PopupFavOpenNew.Enabled := b;
  PopupFavOpenCurrent.Enabled := b;
  PopupFavOpenByBrowser.Enabled := b;
  PopupFavCopyURL.Enabled := b;
  PopupFavCopyTITLE.Enabled := b; //aiai
  PopupFavCopyTU.Enabled  := b;
  //▼フォルダだけ有効
  PopupFavOpenFolderByBoard.Enabled := not b; //※[457]
end;

procedure TMainWnd.PopupFavEditClick(Sender: TObject);
begin
  if FavoriteView.Selected <> nil then begin
    FavoriteView.ReadOnly := False; //beginner
    FavoriteView.Selected.EditText;
  end;
end;

procedure TMainWnd.actAddFavoriteExecute(Sender: TObject);
begin
  (*  *)
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupFavoriteClick(self);
end;

procedure TMainWnd.actDeleteFavoriteExecute(Sender: TObject);
begin
  (*  *)
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupDelFavClick(self);
end;

procedure TMainWnd.ViewPopupFavoriteClick(Sender: TObject);
var
  thread: TThreadItem;
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  thread := viewList.Items[tabRightClickedIndex].thread;
  if thread = nil then
    exit;
  RegisterFavorite(thread);
  UpdateThreadInfo(thread);
  MenuThreClick(MainWnd);
  daemon.Post(RedrawFavoriteButton);
end;

procedure TMainWnd.RedrawFavoriteButton;
begin
  ToolButton12.Down := actAddFavorite.Checked;

  // ▼ Nightly Mon Oct 11 07:23:21 2004 UTC by view
  // お気に入りへの追加がただちにスレ一覧に反映されない不具合を修正
  ListView.DoubleBuffered := True;
  ListView.Repaint;
  ListView.DoubleBuffered := False;
  // ▲ Nightly Mon Oct 11 07:23:21 2004 UTC by view
end;

procedure TMainWnd.ViewPopupDelFavClick(Sender: TObject);
var
  thread: TThreadItem;
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  thread := viewList.Items[tabRightClickedIndex].thread;
  if thread = nil then
    exit;
  UnRegisterFavorite(thread);
  UpdateThreadInfo(thread);
  MenuThreClick(MainWnd);
  daemon.Post(RedrawFavoriteButton);
end;

function TMainWnd.IsFavorite(thread: TThreadItem): boolean;
begin
  with TBoard(thread.board) do
    result := (favorites.Find(host, bbs, thread.datName) <> nil);
end;

function TMainWnd.IsFavorite(board: TBoard): boolean;
begin
  with board do
    result := (favorites.Find(host, bbs, '') <> nil);
end;

//▼登録場所を指定できるように
procedure TMainWnd.RegisterFavorite(thread: TThreadItem;
                                    parent: TFavoriteList =nil; index: integer =0);
var
  fav: TFavorite;
  host, bbs: string;
begin
  //▼重複許可
  if not Config.optAllowFavoriteDuplicate and IsFavorite(thread) then
    exit;
  if thread.mark <> timMARKER then
  begin
    thread.mark := timMARKER;
    thread.SaveIndexData;
  end;
  //UpdateThreadInfo(thread);
  if AnsiStartsStr('http', thread.URI) then
  begin
    SplitThreadURI(thread.URI, host, bbs)
  end
  else begin
    host := TBoard(thread.board).host;
    bbs  := TBoard(thread.board).bbs;
  end;

  fav := TFavorite.Create(favorites);
  fav.category := TCategory(TBoard(thread.board).category).name;
  fav.board    := TBoard(thread.board).name;
  fav.datName  := thread.datName;
  fav.name     := HTML2String(thread.title);
  fav.host     := host;
  fav.bbs      := bbs;
  if parent = nil then
    favorites.Add(fav)
  else
    parent.Insert(index, fav);
  SaveFavorites(true);
  UpdateFavorites;
  MenuThreClick(MainWnd);
  daemon.Post(RedrawFavoriteButton);
end;

procedure TMainWnd.RegisterFavorite(board: TBoard;
                                    parent: TFavoriteList = nil; index: integer = 0;
                                    dosaveandupdate: boolean = true);//※[457]連続追加用
var
  fav: TFavorite;
begin
  //▼重複許可
  if not Config.optAllowFavoriteDuplicate and IsFavorite(board) then
    exit;
  fav := TFavorite.Create(favorites);
  fav.category := TCategory(board.category).name;
  fav.board    := board.name;
  fav.datName  := '';
  fav.name     := HTML2String(board.name);
  fav.host     := board.host;
  fav.bbs      := board.bbs;
  if parent = nil then
    favorites.Add(fav)
  else
    parent.Insert(index, fav);
  if dosaveandupdate then
  begin
    SaveFavorites(true);
    UpdateFavorites;
  end;
end;

procedure TMainWnd.UnRegisterFavorite(thread: TThreadItem);
begin
  if (thread = nil) or not IsFavorite(thread) then
    exit;
  SaveFavorites(false); //Tree展開情報保存
  with thread do
  begin
    favorites.FindDelete(GetHost, GetBBS, datName);
    if thread.mark = timMARKER then
    begin
      mark := timNONE;
      SaveIndexData;
    end;
  end;
  //UpdateThreadInfo(thread);
  UpdateFavorites; //Treeに削除されたTFavoriteのポインタが含まれるため保存前に行う
  SaveFavorites(true); //削除後の保存
end;

procedure TMainWnd.UnRegisterFavorite(board: TBoard);
begin
  if (board = nil) or not IsFavorite(board) then
    exit;
  SaveFavorites(false);  //Tree展開情報保存
  with board do
    favorites.FindDelete(host, bbs, '');

  UpdateFavorites; //Treeに削除されたTFavoriteのポインタが含まれるため保存前に行う
  SaveFavorites(true); //削除後の保存
end;

procedure TMainWnd.FavoriteViewDblClick(Sender: TObject);
var
  node: TTreeNode;
begin
  node := TreeViewGetNode(Sender);
  if node <> nil then
  begin
    if TObject(node.Data) is TFavorite then
    begin
      with TFavorite(node.Data) do
      begin
        NavigateIntoView(host, bbs, datName, -1, false, gtDblClk);
      end;
    end;
  end;
end;

procedure TMainWnd.FavoriteViewClick(Sender: TObject);
var
  node: TTreeNode;
begin
  if not FavoriteView.IsEditing then FavoriteView.ReadOnly := True; //beginner
  {if (GetKeyState(VK_SHIFT) < 0) or
     (GetKeyState(VK_CONTROL) < 0) then
    exit;}
  //▼ドラッグ開始時に開くのを抑止
  if GetKeyState(VK_LBUTTON) < 0 then
    exit;
  (*  *)
  node := TreeViewGetNode(Sender);
  if node <> nil then
  begin
    if TObject(node.Data) is TFavorite then
    begin
      with TFavorite(node.Data) do
      begin
        NavigateIntoView(host, bbs, datName, -1, false, gtClick, //▼Shiftで逆転
                         (Config.oprOpenFavWNewView xor (GetKeyState(VK_SHIFT) < 0)),
                         false, Config.oprFavBgOpen);
      end;
    end
    else begin
      if Config.oprCatBySingleClick then
        node.Expanded := not node.Expanded;
    end;
  end;
end;

procedure TMainWnd.PopupFavOpenNewClick(Sender: TObject);
var
  node: TTreeNode;
begin
  node := FavoriteView.Selected;
  if node = nil then
    exit;
  if TObject(node.Data) is TFavorite then
  begin
    with TFavorite(node.Data) do
    begin
      NavigateIntoView(host, bbs, datName, -1, false, gtOther, true, false, Config.oprFavBgOpen);
      //▼板も開くので
      if datName = '' then
        SetRPane(ptList)
      else
        SetRPane(ptView);
    end;
  end;
end;

procedure TMainWnd.PopupFavOpenCurrentClick(Sender: TObject);
var
  node: TTreeNode;
begin
  node := FavoriteView.Selected;
  if node = nil then
    exit;
  if TObject(node.Data) is TFavorite then
  begin
    with TFavorite(node.Data) do
    begin
      NavigateIntoView(host, bbs, datName, -1, false, gtMenu, false);
      //▼板も開くので
      if datName = '' then
        SetRPane(ptList)
      else
        SetRPane(ptView);
    end;
  end;
end;

function TMainWnd.FavoriteToURL(node: TTreeNode; const titleP: boolean): string;
var
  fav: TFavorite;
  board: TBoard;
  thread: TThreadItem;
  prefix: string;
begin
  if node = nil then
    exit;
  if TObject(node.Data) is TFavorite then
  begin
    fav := TFavorite(node.Data);
    if length(fav.datName) <= 0 then
    begin
      board := i2ch.FindBoardByName(fav.category, fav.board);
      if board <> nil then
      begin
        if titleP then
          prefix := HTML2String(board.name) + #13#10
        else
          prefix := '';
        result := prefix + board.URIBase + '/' ;
      end;
    end
    else begin
      thread := i2ch.FindThread(fav.category, fav.board, fav.datName);
      if thread <> nil then
      begin
        if titleP then
          prefix := HTML2String(thread.title) + #13#10
        else
          prefix := '';
        result := prefix + thread.ToURL;
      end;
    end;
  end;
end;

procedure TMainWnd.PopupFavOpenByBrowserClick(Sender: TObject);
begin
  OpenByBrowser(FavoriteToURL(FavoriteView.Selected, false));
end;

//URLをコピー
procedure TMainWnd.PopupFavCopyURLClick(Sender: TObject);
begin
  Clipboard.AsText := FavoriteToURL(FavoriteView.Selected, false);
end;

//タイトルをコピー //aiai
procedure TMainWnd.PopupFavCopyTITLEClick(Sender: TObject);
var
  node: TTreeNode;
  fav: TFavorite;
  board: TBoard;
  thread: TThreadItem;
begin
  node := FavoriteView.Selected;
  if node = nil then
    exit;
  if TObject(node.Data) is TFavorite then
  begin
    fav := TFavorite(node.Data);
    if length(fav.datName) <= 0 then
    begin
      board := i2ch.FindBoardByName(fav.category, fav.board);
      if board <> nil then
        Clipboard.AsText := HTML2String(board.name);
    end
    else begin
      thread := i2ch.FindThread(fav.category, fav.board, fav.datName);
      if thread <> nil then
        Clipboard.AsText := HTML2String(thread.title);
    end;
  end;
end;

//タイトルとURLをコピー
procedure TMainWnd.PopupFavCopyTUClick(Sender: TObject);
begin
  Clipboard.AsText := FavoriteToURL(FavoriteView.Selected, true);
end;

(* オートスクロール *) //aiai
procedure TMainWnd.ViewPopupToggleAutoScrollClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem :=GetActiveView;

  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;

  if (AutoScroll = nil) or (AutoScroll.State = scrStopNormal) then
  begin
    if AutoScroll = nil then
      AutoScroll := TAutoScroll.Create;
    AutoScroll.Interval := Config.oprAutoScrollInterval[Config.oprAutoScrollSpeed];
    AutoScroll.ScrollLines := Config.oprAutoScrollLines[Config.oprAutoScrollSpeed];
    AutoScroll.Enabled := true;
    if (AutoReload <> nil) and AutoReload.Enabled then
      actAutoReSc.Checked := true;
    if MemoWriteMain.Visible then
      try MemoWriteMain.SetFocus; except end;
  end else if (AutoScroll <> nil) then
  begin
    AutoScroll.Enabled := false;
    actAutoReSc.Checked := false;
  end;
end;

(* オートリロード *) //aiai
procedure TMainWnd.ViewPopupToggleAutoReloadClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := GetActiveView;

  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;


  if (AutoReload <> nil) and (AutoReload.State <> relStop) then
  begin
    AutoReload.Enabled := false;
    actAutoReSc.Checked := false;
    TabControl.Refresh;
  end else
  begin
    if (AutoReload = nil) then
      AutoReload := TAutoReload.Create;
    AutoReload.Interval := Config.oprAutoReloadInterval * 1000;
    AutoReload.Enabled := true;
    if (AutoScroll <> nil) and (AutoScroll.State <> scrStopNormal) then
      actAutoReSc.Checked := true;
    TabControl.Refresh;
  end;
end;

procedure TMainWnd.ViewPopupAutoScrollAtAnyTimeClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  ViewPopupAutoScrollAtAnyTime.Checked := not ViewPopupAutoScrollAtAnyTime.Checked;


  if AutoScroll = nil then
    exit;

  viewItem := GetActiveView;

  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;

  AutoScroll.Enabled := ViewPopupAutoScrollAtAnyTime.Checked;
end;

procedure TMainWnd.ViewPopupOpenAutoReloadSettingFormClick(
  Sender: TObject);
var
  dlg: TAutoReloadSettingForm;
begin
  dlg := TAutoReloadSettingForm.Create(self);
  if (dlg.ShowModal = mrOK) and (AutoReload <> nil) then
    AutoReload.Interval := Config.oprAutoReloadInterval * 1000;
  dlg.Free;
end;

procedure TMainWnd.ViewPopupAutoScrollSettingClick(Sender: TObject);
var
  dlg: TAutoScrollSettingForm;
begin
  dlg := TAutoScrollSettingForm.Create(self);
  if (dlg.ShowModal = mrOK) and (AutoScroll <> nil) then
  begin
    AutoScroll.Interval := Config.oprAutoScrollInterval[Config.oprAutoScrollSpeed];
    AutoSCroll.ScrollLines := Config.oprAutoScrollLines[Config.oprAutoScrollSpeed];
  end;
  dlg.Free;
end;

procedure TMainWnd.ViewPopupTUCopyClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    Clipboard.AsText := HTML2String(viewItem.thread.title) + #13#10
                      + viewItem.thread.ToURL;
  end;
end;

(* URLをクリップボードにコピー *)
procedure TMainWnd.ViewPopupURLCopyClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    Clipboard.AsText := viewItem.thread.ToURL;
  end;
end;

{
function ToCanonicalURL(const uri, datName: string;
                        retired: boolean = false): string;
var
  host, bbs: string;
begin
  SplitThreadURI(uri, host, bbs);
  if retired then
  begin
    if 9 < length(datName) then
      result := uri + '/kako/'
              + Copy(datName, 1, 4) + '/'
              + Copy(datName, 1, 5) + '/'
              + datName + '.html'
    else
      result := uri + '/kako/'
          + Copy(datName, 1, 3)
          + '/' + datName + '.html';
  end
  else begin
    result := host + 'test/read.cgi/' + bbs + '/' + datName + '/';
  end;
end;
}


procedure TMainWnd.MenuToggleRPaneClick(Sender: TObject);
begin
  if (mdRPane = ptList) then
    SetRPane(ptView)
  else
    SetRPane(ptList);
end;

procedure TMainWnd.FormResize(Sender: TObject);
begin
  {if Assigned(StatusBar2) then
  begin
    Panel0.Width := ClientWidth;
    Panel0.Height := ClientHeight - StatusBar2.Height;
  end else
  begin
    Panel0.Width := ClientWidth;
    Panel0.Height := ClientHeight - 26;
  end;}

  if Config.oprToggleRView then
  begin
    if mdRPane = ptList then
    begin
      if Config.stlVerticalDivision then
        ListViewPanel.Width  := Panel2.Width
      else
        ListViewPanel.Height := Panel2.Height;
    end;
  end;
end;

//スレッドのURLをコピー
procedure TMainWnd.actCopyURLExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupURLCopyClick(Self);
end;

//スレッドのタイトルをコピー //aiai
procedure TMainWnd.actCopyTITLEExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupTITLECopyClick(Self);
end;

//スレッドのタイトルをURLをコピー
procedure TMainWnd.actCopyTUExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupTUCopyClick(Self);
end;



procedure TMainWnd.ViewPopupOpenBoardClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    TBoard(viewItem.thread.board).selDatName := viewItem.thread.datName;
    ListViewNavigate(TBoard(viewItem.thread.board), Config.oprGestureBrdOther,  //▼Shiftで逆転
                     (Config.oprOpenBoardWNewTab xor (GetKeyState(VK_SHIFT) < 0)));
  end;
end;

procedure TMainWnd.actOpenBoardExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupOpenBoardClick(self);
end;

procedure TMainWnd.Panel1Resize(Sender: TObject);
var
  newTop, newLeft, newBottom, newRight: Integer;
begin
  if Config.oprToggleRView and (mdRPane = ptList) then
  begin
    if 0 < Height then
      ListViewPanel.Height := Panel1.Height;
  end;

  {aiai}
  if TreePanelCanMove then
  begin
  newBottom := TreePanel.Top + TreePanel.Height;
  if newBottom > Panel1.ClientHeight then
  begin
    newTop := Panel1.ClientHeight - TreePanel.Height;
    if newTop < 0 then
      TreePanel.Top := 0
    else
      TreePanel.Top := newTop;
  end;
  newRight := TreePanel.Left + TreePanel.Width;
  if newRight > Panel1.ClientWidth then
  begin
    newLeft := Panel1.ClientWidth - TreePanel.Width;
    if newLeft < 0 then
      TreePanel.Left := 0
    else
      TreePanel.Left := newLeft;
  end;
  end;

  newBottom := WritePanel.Top + WritePanel.Height;
  if newBottom > Panel1.ClientHeight then
  begin
    newTop := Panel1.ClientHeight - WritePanel.Height;
    if newTop < 0 then
      WritePanel.Top := 0
    else
      WritePanel.Top := newTop;
  end;
  newRight := WritePanel.Left + WritePanel.Width;
  if newRight > Panel1.ClientWidth then
  begin
    newLeft := Panel1.ClientWidth - WritePanel.Width;
    if newLeft < 0 then
      WritePanel.Left := 0
    else
      WritePanel.Left := newLeft;
  end;
  {/aiai}
end;

procedure TMainWnd.SetRPane(paneType: TPaneType);
var
  viewItem: TViewItem;
begin
  if not Config.oprToggleRView or not Visible then
    exit;
//  if mdRPane = paneType then
//    exit;

  mdRPane := paneType;
  case mdRPane of
  ptList:
    begin
      ListViewPanel.Visible := true;
      ListViewPanel.Height := Panel2.Height;
      ListViewPanel.Width  := Panel2.Width;
      ListView.TabStop := (0 < ListView.Items.Count);
      WebPanel.Visible := false;
      actBuildThread.Enabled := (currentBoard <> nil) and not (currentBoardIsFunction);
      try
        ListView.SetFocus;
      except
      end;
    end;
  ptView:
    begin
      WebPanel.Visible := true;
      ListViewPanel.Visible := false;
      ListView.TabStop := false;
      actBuildThread.Enabled := false;
      viewItem := GetActiveView;
      if viewItem <> nil then
        try
          viewItem.browser.SetFocus;
        except
        end;
    end;
  end;
end;

procedure TMainWnd.DblClkTimerTimer(Sender: TObject);
begin
  DblClkTimer.Enabled := false;
  SetRPane(ptView);
end;

procedure TMainWnd.ListViewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;

procedure TMainWnd.MemoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;

procedure TMainWnd.FavoriteViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;

procedure TMainWnd.TreeViewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;

procedure TMainWnd.ThreadToolBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;
//▼
procedure TMainWnd.TabPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;

procedure TMainWnd.ListTabPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;

procedure TMainWnd.ListTabControlMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  ReleasePopupHint;
end;

procedure TMainWnd.ViewPopupDelClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  StopAutoReSc; //aiai
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    viewItem.thread.CancelAsyncRead;
    viewItem.thread.RemoveLog;
    UnRegisterFavorite(viewItem.thread);
    UpdateThreadInfo(viewItem.thread);
    viewItem.thread.canclose := True;
    actCloseThisTabExecute(Sender);
  end;
end;

procedure TMainWnd.actRemvoeLogExecute(Sender: TObject);
begin
  (*  *)
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupDelClick(Sender);
end;

//datを名前を付けて保存 //aiai
procedure TMainWnd.actSaveDatExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupSaveDatClick(Sender);
end;

//datをクリップボードにコピー //aiai
procedure TMainWnd.actCopyDatExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupCopyDatClick(Sender);
end;

//datとidxをクリップボードにコピー //aiai
procedure TMainWnd.actCopyDIExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupCopyDIClick(Sender);
end;

procedure TMainWnd.actCloseTabExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  actCloseThisTabExecute(Sender);
end;

procedure TMainWnd.PopupTreePopup(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
  b: boolean;
  i: integer;
begin
  (*  *)
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PtInRect(ListTabPanel.ClientRect, ListTabPanel.ScreenToClient(PopupTree.PopupPoint)) then
  begin
    if (tabRightClickedIndex < 0) or (tabRightClickedIndex >= boardList.Count) then
    begin
      with ListTabControl.ScreenToClient(mouse.CursorPos) do
        tabRightClickedIndex := ListTabControl.IndexOfTabAt(X, Y);
    end;
    board := boardList.Items[tabRightClickedIndex];
    for i :=0 to PopupTree.Items.IndexOf(PopupTreeTabMenuSep) -1 do
    begin
      PopupTree.Items[i].Visible := true;
      PopupTree.Items[i].Enabled := true;
    end;
    PopupTreeBuildThread.Visible := true;
    PopupTreeOpenNew.Visible := false;
    PopupTreeOpenCurrent.Visible := false;
    PopupTreeDelBoard.Visible := false;
  end
  else begin
    node := TreeView.Selected;
    TreeView.Selected := node;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
    for i :=0 to PopupTree.Items.IndexOf(PopupTreeTabMenuSep) -1 do
    begin
      PopupTree.Items[i].Visible := false;
      PopupTree.Items[i].Enabled := false;
    end;
    PopupTreeBuildThread.Visible := false;
    if ListTabPanel.Visible then
    begin
      PopupTreeOpenNew.Visible := true;
      PopupTreeOpenCurrent.Visible := true;
    end;
    PopupTreeDelBoard.Visible := true;
  end;

  if board <> nil then
  begin
    PopupTreeAddFav.Enabled := true;
    PopupTreeAddFav.Checked := IsFavorite(board);
    PopupTreeDelFav.Enabled := PopupTreeAddFav.Checked;
    //▼
    b := not (board is TFunctionalBoard);
    PopupTreeSetHeader.Enabled := b;
    PopupTreeUMA.Enabled :=  b;
    PopupTreeCopyURL.Enabled := b;
    PopupTreeCopyTITLE.Enabled := b; //aiai
    PopupTreeCopyTU.Enabled := b;
    PopupTreeOpenNew.Enabled := true;
    PopupTreeOpenCurrent.Enabled := true;
    PopupTreeOpenByBrowser.Enabled := b;
    {aiai}
    actRefreshIdxList.Enabled := b;
    actHideHistoricalLog.Enabled := b;
    actHideHistoricalLog.Checked := b and board.HideHistoricalLog;
    //actShowThreadAbone.Enabled := b;
    ///actShowThreadAbone.Checked := b and board.ShowThreadAbone;
    PopupTreeSetCustomSkin.Enabled := b;
    if board.CustomSkinIndex < PopupTreeSetCustomSkin.Count then
      PopupTreeSetCustomSkin.Items[board.CustomSkinIndex].Checked := True;
    {/aiai}
    PopupTreeDelBoard.Enabled := not (board is TFunctionalBoard) and not board.Refered;
    with board do
    begin
      if length(lastModified) <= 0 then
        LoadIndex;
      PopupTreeSetHeader.Checked := (0 < length(customHeader));
      PopupTreeUMA.Checked := uma;
    end;
  end
  else begin
    PopupTreeAddFav.Enabled := false;
    PopupTreeAddFav.Checked := false;
    PopupTreeDelFav.Enabled := false;
    PopupTreeSetHeader.Enabled := false;
    PopupTreeSetHeader.Checked := false;
    PopupTreeUMA.Enabled := false;
    PopupTreeUMA.Checked := false;
    PopupTreeCopyURL.Enabled := false;
    PopupTreeCopyTITLE.Enabled := false; //aiai
    PopupTreeCopyTU.Enabled := false;
    PopupTreeOpenNew.Enabled := false;
    PopupTreeOpenCurrent.Enabled := false;
    PopupTreeOpenByBrowser.Enabled := false;
    PopupTreeDelBoard.Enabled := false;
    {aiai}
    actRefreshIdxList.Enabled := false;
    actHideHistoricalLog.Enabled := false;
    actHideHistoricalLog.Checked := false;
    //actShowThreadAbone.Enabled := false;
    //actShowThreadAbone.Checked := false;
    PopupTreeSetCustomSkin.Enabled := false;
    {/aiai}
  end;
end;

procedure TMainWnd.PopupTreeAddFavClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PopupTreeClose.Visible or (Sender = ListTabControl) then
    board := boardList.Items[tabRightClickedIndex]
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board <> nil then
    RegisterFavorite(board);
end;

procedure TMainWnd.PopupTreeDelFavClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PopupTreeClose.Visible or (Sender = ListTabControl) then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board <> nil then
    UnRegisterFavorite(board);
end;

procedure TMainWnd.ViewItemStateChanged;
  procedure DisableAll;
  begin
    actWriteRes.Enabled := false;
    actCheckNewRes.Enabled := false;
    actStop.Enabled := false;
    actScrollToNew.Enabled := false;
    actScrollToPrev.Enabled := false;
    actBack.Enabled := false;
    actForword.Enabled := false;
    actOpenByBrowser.Enabled := false;
    actCopyURL.Enabled := false;
    actCopyTITLE.Enabled := false; //aiai
    actOpenBoard.Enabled := false;
    actAddFavorite.Enabled := false;
    actDeleteFavorite.Enabled := false;
    actRemvoeLog.Enabled := false;
    actSaveDat.Enabled := false; //aiai
    actCopyDat.Enabled := false; //aiai
    actCopyDI.Enabled := false;  //aiai
    actReload.Enabled := false;
    actCloseTab.Enabled := false;
    actMaxView.Enabled := false;  //aiai
    actKeywordExtraction.Enabled:=false; //beginner
    actSetReadPos.Enabled := false;
    actJumpToReadPos.Enabled := false;
    actReadPosClear.Enabled := false;
    actCheckResAllClear.Enabled := false;
    DrawLinesButton.Enabled := false;
    {beginner}
    actShowResTree.Enabled := False;
    actShowOutLine.Enabled := False;
    {/beginner}
    ResFindButton.Enabled := false;
    JumpBottun.Enabled := false;
    MenuThreClose.Enabled := false;
    MenuThreCloseWOSave.Enabled := false;
    MenuThreCloseOtherTabs.Enabled := false;
    MenuThreCloseAllTabs.Enabled := false;
    MenuThreCloseLeftTabs.Enabled := false;
    MenuThreCloseRightTabs.Enabled := false;
    MenuThreToggleMarker.Enabled := false;
    MenuThreToggleMarker.Checked := false;
    MenuCopyURL.Enabled := false;
    MenuCopyTITLE.Enabled := false; //aiai
    MenuCopyTU.Enabled := false;
    MenuThreJumpRes.Enabled := false;
    MenuThrePopupRes.Enabled := false;
    MenuThreChangeDrawLines.Enabled := false;
    MenuThreReadPos.Enabled := false;
    MenuThreCheckRes.Enabled := false;
    StatusBar.Panels.Items[2].Text := '';
    //StatusBar2.Text[2] := '';  //aiai
    SetCaption(boardNameOfCaption);  //aiai
    {２ちゃんねるブラウザ「OpenJane」改造総合スレ
    http://pc3.2ch.net/test/read.cgi/win/1033913790/949から引用}
    UrlEdit.Text := '';
	  ThreadTitleLabel.Caption := '';   //※[JS]
    ThreadTitleLabel.Transparent := True; //koreawatcher
    {aiai}
    ButtonWriteWrite.Enabled := False;
    actAutoReSc.Enabled := false;
    actAutoReSc.Checked := false;
    StopAutoReSc;
    actCheckNewResAll.Enabled := false;
    actTabPtrl.Enabled := false;
    {/aiai}
  end;

  procedure ShowThreadStatus(thread: TThreadItem);
  var
    s, datSize: string;
  begin
    if thread = nil then
    begin
      StatusBar.Panels.Items[2].Text := '';
      //StatusBar2.Text[2] := '';  //aiai
      ThreadTitleLabel.Caption := '';   //※[JS]
      UrlEdit.Text := '';               //※[JS]
      exit;
    end;
    if thread.state = tsComplete then
      s := ' －過去ログ－ '
    else
      s := ' ';
    if assigned(thread.dat) then
      datSize := IntToStr(thread.dat.Size div 1024) + 'KB'
    else
      datSize := '';
    StatusBar.Panels.Items[2].Text
      := '[新' + IntToStr(thread.lines - thread.anchorLine) + ': 未' //aiai 未読数表示
      +  IntToStr(thread.lines - thread.oldLines) + ': 全'
      +  IntToStr(thread.lines) + '] ' + HTML2String(thread.title)
      +  s
      + ' [' + TBoard(thread.board).name + '/'
      + TCategory(TBoard(thread.board).category).name + ']  '
      + datSize;
    {StatusBar2.Text[2]
      := '[新' + IntToStr(thread.lines - thread.anchorLine) + ': 全'
      +  IntToStr(thread.lines) + '] ' + HTML2String(thread.title)
      +  s
      + ' [' + TBoard(thread.board).name + '/'
      + TCategory(TBoard(thread.board).category).name + ']  '
      + datSize;}  //aiai
    //※[JS]
    {beginner}
    if thread.mayHaveInconsistency then
      ThreadTitleLabel.Transparent := False
    else
      ThreadTitleLabel.Transparent := True;
    {/beginner}

    ThreadTitleLabel.Caption :=
      '【' + TBoard(thread.board).name + '】 - ' + HTML2String(thread.title);
    Caption := Jane2ch + ' ' + ThreadTitleLabel.Caption;   //aiai
    {２ちゃんねるブラウザ「OpenJane」改造総合スレ
    http://pc3.2ch.net/test/read.cgi/win/1033913790/949から引用}
  end;
var
  viewItem: TViewitem;
//  wnd: HWND;
begin
  if viewList.Count <= 0 then
  begin
    DisableAll;
    if Config.oprToggleRView and (mdRPane <> ptList) then
      SetRPane(ptList);

    exit;
  end
  else begin
    viewItem := GetActiveView;
    SetUrlEdit(viewItem);
    if viewItem = nil then
    begin
      StatusBar.Panels.Items[2].Text := '';
      ThreadTitleLabel.Caption := '';   //※[JS]
      exit;
    end;
    ShowThreadStatus(viewItem.thread);
    with viewItem do
    begin
      actWriteRes.Enabled := (thread <> nil) and (thread.state = tsCurrency) and
                                 ((0 < thread.number) or ThreadIsNew(thread));
      actCheckNewRes.Enabled  := (thread <> nil) and (thread.state <> tsComplete);
      actAutoReSc.Enabled     := actCheckNewRes.Enabled;  //aiai
      actAutoReSc.Checked     := actCheckNewRes.Enabled and (AutoReload <> nil) and (AutoScroll <> nil) and (AutoReload.State <> relStop) and (AutoScroll.State <> scrStopNormal);
      actStop.Enabled         := (thread <> nil) and thread.Downloading and (Progress = tpsProgress); {(thread.state <> tsComplete);}
      actScrollToNew.Enabled  := (thread <> nil);// and (thread.oldLines < thread.lines);
      actScrollToPrev.Enabled := (thread <> nil) and (0 < thread.oldLines);
      actBack.Enabled         := true;//CanGoBack;
      actForword.Enabled      := true;//CanGoForword;
      actCopyURL.Enabled      := true;
      actCopyTITLE.Enabled    := true;   //aiai
      actOpenByBrowser.Enabled := true;
      actOpenBoard.Enabled := true;
      actAddFavorite.Enabled  := true;
      actDeleteFavorite.Enabled := false;
      actRemvoeLog.Enabled    := true;
      actReload.Enabled       := true;
      actCloseTab.Enabled     := true;
      {aiai}
      actSaveDat.Enabled := true;
      actCopyDat.Enabled := true;
      actCopyDI.Enabled  := true;
      if Assigned(browser) then begin
        actMaxView.Enabled := true;
        if TMDITextView(browser).WndState = MTV_NOR then begin
          actMaxView.ImageIndex := 12;
          actMaxView.Hint := '最大化';
        end else begin
          actMaxView.ImageIndex := 11;
          actMaxView.Hint := '元のサイズに戻す';
        end;
      end else
        actMaxView.Enabled := False;
      {/aiai}
      actKeywordExtraction.Enabled := (thread <> nil); //beginner
      //actSetReadPos.Enabled := (thread <> nil);
      //actJumpToReadPos.Enabled := (thread <> nil) and (thread.ReadPos <> 0);
      //actReadPosClear.Enabled := (thread <> nil) and (thread.ReadPos <> 0);
      actCheckResAllClear.Enabled := (thread <> nil);
      {beginner}
      actShowResTree.Enabled := actKeywordExtraction.Enabled;
      actShowOutLine.Enabled := actKeywordExtraction.Enabled;
      {/beginner}
      ResFindButton.Enabled := true;
      DrawLinesButton.Enabled := true;
      JumpBottun.Enabled := true;
      MenuThreClose.Enabled := true;
      MenuThreCloseWOSave.Enabled := true;
      MenuThreCloseOtherTabs.Enabled := true;
      MenuThreCloseAllTabs.Enabled := true;
      MenuThreCloseLeftTabs.Enabled := true;
      MenuThreCloseRightTabs.Enabled := true;
      MenuThreToggleMarker.Enabled := true;
      MenuThreToggleMarker.Checked := (thread <> nil) and (thread.mark = timMARKER);
      MenuCopyURL.Enabled := true;
      MenuCopyTITLE.Enabled := true;  //aiai
      MenuCopyTU.Enabled := true;
      MenuThreJumpRes.Enabled := (thread <> nil);
      MenuThrePopupRes.Enabled := (thread <> nil);
      MenuThreOpenByBrowser.Enabled := true;
      MenuThreChangeDrawLines.Enabled := true;
      MenuThreReadPos.Enabled := true;
      MenuThreSetReadPos.Enabled := (thread <> nil);
      MenuThreJumpToReadPos.Enabled := (thread <> nil) and (thread.ReadPos <> 0);
      MenuThreReadPosClear.Enabled := (thread <> nil) and (thread.ReadPos <> 0);
      MenuThreCheckRes.Enabled := (thread <> nil);

      WritePanelControl.SetThread(thread); //aiai
      if (thread <> nil) then
        LabelWriteTitle.Caption := '  『' + HTML2String(thread.title) + '』'
            + 'にレス'
      else
        LabelWriteTitle.Caption := '  レス';
    end;
    actCheckNewResAll.Enabled := true;
    actTabPtrl.Enabled := true;

    {wnd := GetFocus;
    try
      if (wnd <> ListView.Handle) and (viewItem.browser.Handle <> 0) then
        viewItem.browser.SetFocus;
    except
    end;}
    MenuThreClick(MainWnd); //※[457] お気に入りボタン表示等アップデートのため
    //viewList.UpdateFocus(viewItem);
  end;
end;


(* なんか関数がありそうで前から探してんだけど見つからないタブ移動 *)
{まだテスト中
function CanTabStop(wnd: HWND): boolean;
var
  style: Longword;
begin
  style := GetWindowLong(wnd, GWL_STYLE);
  result := ((style and WS_TABSTOP) <> 0) and IsWindowEnabled(wnd);
end;

(*  *)
procedure ForwardFocus(root: HWND);
  function ExpForward(wnd: HWND): boolean;
  begin
    if wnd = 0 then
      result := false
    else if CanTabStop(wnd) then
    begin
      SetFocus(wnd);
      result := true;
    end
    else
      result := ExpForward(GetWindow(wnd, GW_CHILD)) or
                ExpForward(GetWindow(wnd, GW_HWNDNEXT));
  end;
var
  wnd, parent: HWND;
begin
  wnd := GetFocus();
  if (wnd <> 0) then
  begin
    if (ExpForward(GetWindow(wnd, GW_CHILD)) or
        ExpForward(GetWindow(wnd, GW_HWNDNEXT))) then
      exit;
    while true do
    begin
      parent := GetParent(wnd);
      if (parent = 0) or (parent = root) then
        break;
      wnd := GetWindow(parent, GW_HWNDNEXT);
      if GetWindow(parent, GW_HWNDFIRST) = wnd then
        break;
      if ExpForward(wnd) then
        exit;
    end;
  end;
  ExpForward(root);
end;
}
procedure TMainWnd.MenuViewNextPaneClick(Sender: TObject);
  procedure SetFocusForward(index: integer);
    function sub(startPos, endPos: integer): boolean;
    var
      i: integer;
      viewItem: TViewItem;
    begin
      result := true;
      for i := startPos to endPos do
      begin
        if TabSwitchList.Items[i] = nil then
        begin
          viewItem := GetActiveView;
          if (viewItem <> nil) and WebPanel.Visible then
          begin
            try
              viewItem.browser.SetFocus;
            except
            end;
            exit;
          end;
        end
        else if (TWinControl(TabSwitchList.Items[i]).TabStop) and
                (0 < TWinControl(TabSwitchList.Items[i]).Height) then
        begin
          try
            TWinControl(TabSwitchList.Items[i]).SetFocus;
          except
          end;
          exit;
        end;
      end;
      result := false;
    end;
  begin
    if not sub(index + 1, TabSwitchList.Count -1) then
      sub(0, index);
  end;
var
  activeControl: HWND;
  i: integer;
begin
  activeControl := GetFocus();
  if activeControl = 0 then
  begin
    SetFocusForward(0);
    exit;
  end;
  for i := 0 to TabSwitchList.Count -1 do
  begin
    if (TabSwitchList.Items[i] <> nil ) and
       (TWinControl(TabSwitchList.Items[i]).Handle = activeControl) then
    begin
      SetFocusForward(i);
      exit;
    end;
  end;
  SetFocusForward(TabSwitchList.IndexOf(nil));
end;

procedure TMainWnd.MenuViewPrevPaneClick(Sender: TObject);
  procedure SetFocusBackward(index: integer);
    function sub(startPos, endPos: integer): boolean;
    var
      i: integer;
      viewItem: TViewItem;
    begin
      result := true;
      for i := startPos downto endPos do
      begin
        if TabSwitchList.Items[i] = nil then
        begin
          viewItem := GetActiveView;
          if (viewItem <> nil) and WebPanel.Visible then
          begin
            try
              viewItem.browser.SetFocus;
            except
            end;
            exit;
          end;
        end
        else if TWinControl(TabSwitchList.Items[i]).TabStop and
                (0 < TWinControl(TabSwitchList.Items[i]).Height) then
        begin
          try
            TWinControl(TabSwitchList.Items[i]).SetFocus;
          except
          end;
          exit;
        end;
      end;
      result := false;
    end;
  begin
    if not sub(index - 1, 0) then
      sub(TabSwitchList.Count -1, index);
  end;
var
  activeControl: HWND;
  i: integer;
begin
  activeControl := GetFocus();
  if activeControl = 0 then
  begin
    SetFocusBackward(0);
    exit;
  end;
  for i := 0 to TabSwitchList.Count -1 do
  begin
    if (TabSwitchList.Items[i] <> nil ) and
       (TWinControl(TabSwitchList.Items[i]).Handle = activeControl) then
    begin
      SetFocusBackward(i);
      exit;
    end;
  end;
  SetFocusBackward(TabSwitchList.IndexOf(nil));
end;

procedure TMainWnd.MenuThreClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  //SetThreadMenuContext(GetActiveView);
  viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
  begin
    actToggleMarker.Checked := false;
    actAddFavorite.Checked  := false;
    MenuThreStop.Enabled := false;
    {aiai}
    MenuCopyURL.Enabled := false;
    MenuCopyTITLE.Enabled := false;
    MenuCopyTU.Enabled := false;
    actOpenByBrowser.Enabled := false;
    actRemvoeLog.Enabled := false;
    actReload.Enabled := false;
    actSaveDat.Enabled := false;
    actCopyDat.Enabled := false;
    actCopyDI.Enabled := false;
    MenuThreToggleAutoReload.Enabled := false;
    MenuThreToggleAutoReload.Checked := false;
    MenuThreToggleAutoScroll.Enabled := false;
    MenuThreToggleAutoScroll.Checked := false;
    {/aiai}
  end
  else begin
    actToggleMarker.Checked := (viewItem.thread.mark = timMARKER);
    actAddFavorite.Checked := IsFavorite(viewItem.thread);
    MenuThreStop.Enabled := viewItem.thread.Downloading;
    {aiai}
    MenuCopyURL.Enabled := true;
    MenuCopyTITLE.Enabled := true;
    MenuCopyTU.Enabled := true;
    actOpenByBrowser.Enabled := true;
    actRemvoeLog.Enabled := true;
    actReload.Enabled := true;
    actSaveDat.Enabled := true;
    actCopyDat.Enabled := true;
    actCopyDI.Enabled := true;
    MenuThreToggleAutoReload.Enabled := true;
    MenuThreToggleAutoReload.Checked := (AutoReload <> nil) and (AutoReload.State <> relStop);
    MenuThreToggleAutoScroll.Enabled := true;
    MenuThreToggleAutoScroll.Checked := (AutoScroll <> nil) and (AutoScroll.State <> scrStopNormal);
    {/aiai}
  end;
  actDeleteFavorite.Enabled := actAddFavorite.Checked;
end;

{beginner}
procedure TMainWnd.Find1Click(Sender: TObject);
begin
  if Assigned(currentBoard) and currentBoard.threadSearched then
  begin
    MenuFindThread.Caption := 'さらにスレ絞り込み(&T)...';
    MenuFindThreadNew.Enabled := True;
    MenuFindThreadNew.Visible := True;
    MenuClearFindThreadResult.Enabled := True;
  end else
  begin
    MenuFindThread.Caption := 'スレ絞り込み(&T)...';
    MenuFindThreadNew.Enabled := False;
    MenuFindThreadNew.Visible := False;
    MenuClearFindThreadResult.Enabled := False;
  end;
end;

procedure TMainWnd.actScrollToPrevExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  if viewItem.thread = nil then
    exit;
  viewItem.ScrollToAnchor(viewItem.thread.viewPos, True, False);
end;

var
  menuWndSepTagPos: Integer = 4;

procedure TMainWnd.MenuWindowClick(Sender: TObject);
  function FindSep: integer;
  var
    i: integer;
  begin
    for i := 0 to MenuWindow.Count -1 do
    begin
      if MenuWindow.Items[i] = MenuWindowSep then
      begin
        result := i;
        exit;
      end;
    end;
    result := -1;
  end;

  procedure RemoveViewList(sep: integer);
  begin
    while sep + 1 <= MenuWindow.Count -1 do
    begin
      MenuWindow.Items[sep + 1].Free;
    end;
  end;

var
  i: integer;
  menuItem: TMenuItem;
  viewItem: TViewItem;
  s: string;
begin
  (* *)
  menuWndSepTagPos := FindSep;
  RemoveViewList(menuWndSepTagPos);
  for i := 0 to viewList.Count -1 do
  begin
    viewItem := viewList.Items[i];
    menuItem := TMenuItem.Create(MenuWindow);
    MenuWindow.Add(menuItem);
    try
      if viewItem.thread <> nil then
        s := AnsiReplaceStr(HTML2String(viewItem.thread.title), '&', '&&')
      else begin
        s := '検索';
        s := TabControl.Tabs.Strings[i];
      end;
    except
    end;
    if i < 9 then
      menuItem.Caption := '&' + IntToStr(i+1) + ' ' + s
    else
      menuItem.Caption := '　' + s;
    menuItem.Tag := menuWndSepTagPos + i + 1;
	menuItem.ImageIndex := 3;
    menuItem.OnClick := WindowShortcutClick;
  end;

  (* 最近閉じたスレ *)
  MenuWndRecently.Enabled := (0 < FRecentlyClosedThreads.Count);
  MenuWndRecently.Clear;
  for i := 0 to FRecentlyClosedThreads.Count -1 do
  begin
    menuItem := TMenuItem.Create(MenuWndRecently);
    menuItem.Caption := Format('&%d %s',
                               [i+1,
                                Copy(FRecentlyClosedThreads[i], 1,
                                     Pos(#10, FRecentlyClosedThreads[i]) -1)]);
    MenuWndRecently.Add(menuItem);
    menuItem.Tag := i;
	menuItem.ImageIndex := 3;
    menuItem.OnClick := WindowRecentlyClosedClick;
  end;
end;

procedure TMainWnd.WindowShortcutClick(Sender: TObject);
var
  index: integer;
  viewItem: TViewItem;
begin
  (*  *)
  index := TMenuItem(Sender).Tag - menuWndSepTagPos - 1;
  if (0 <= index) and (index <= TabControl.Tabs.Count -1) then
  begin
    //TabControl.TabIndex := index;
    SetCurrentView(index);
    TabControlChange(TabControl);
    SetRPane(ptView);
    viewItem := GetActiveView;
    if (viewItem <> nil) and (viewItem.browser <> nil) then
      try
        viewItem.browser.SetFocus;
      except
      end;
  end;
end;

procedure TMainWnd.MenuWndThListClick(Sender: TObject);
var
  item: TListItem;
begin
  (*  *)
  SetRPane(ptList);
  if ListView.TabStop then
  begin
    try
      ListView.SetFocus;
    except
    end;
    item := ListView.Selected;
    if item <> nil then
      ListViewSelectIntoView(item);
  end;
end;

procedure TMainWnd.MenuWndThreadClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  (*  *)
  SetRPane(ptView);
  viewItem := GetActiveView;
  if (viewitem <> nil) and (viewItem.browser <> nil) then
    try
      viewItem.browser.SetFocus;
    except
    end;
end;

procedure TMainWnd.actListRefreshExecute(Sender: TObject);
begin
  if currentBoard <> nil then
    ListViewNavigate(currentBoard, gotCHECK);
  SetRPane(ptList);
end;

procedure TMainWnd.MenuListHomeMovedBoardClick(Sender: TObject);
begin
  if currentBoard <> nil then
    HomeMovedBoard(currentBoard);
  SetRPane(ptList);
end;

procedure TMainWnd.actListOpenNewExecute(Sender: TObject);
var
  thread: TThreadItem;
begin
  (*  *)
  if (ListView.Selected = nil) or (ListView.SelCount > 1) then
    exit;
  if UILock then
    exit;
  thread := TThreadItem(ListView.Selected.Data);
  ShowSpecifiedThread(thread, Config.oprGestureThrOther, True);
  SetRPane(ptView);
end;

procedure TMainWnd.actListOpenCurrentExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
begin
  (* *)
  item := ListView.Selected;
  if (item = nil) or (ListView.SelCount > 1) then
    exit;
  if UILock then
    exit;
  thread := TThreadItem(item.Data);
  ShowSpecifiedThread(thread, Config.oprGestureThrOther, False);
  SetRPane(ptView);
end;

procedure TMainWnd.actListToggleMarkerExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
begin
  item := ListView.Selected;
  thread := nil;
  while (item <> nil) and (item.Data <> thread) do
  begin
    thread := TThreadItem(item.Data);
    item := ListView.GetNextItem(item, sdBelow, [isSelected]);
    if IsFavorite(thread) and (thread.mark = timMARKER) then
      continue;//exit;
    if thread.mark = timNONE then
      thread.mark := timMARKER
    else
      thread.mark := timNONE;
    thread.SaveIndexData;
    //UpdateThreadInfo(thread);
  end;
  ListView.DoubleBuffered := True;
  ListView.Refresh;
  ListView.DoubleBuffered := False;
end;

procedure TMainWnd.actListAddFavExecute(Sender: TObject);
var
  listItem: TListItem;
  thread: TThreadItem;
begin
  listItem := ListView.Selected;
  thread := nil;
  while (listItem <> nil) and (listItem.Data <> thread) do
  begin
    thread := TThreadItem(listItem.Data);
    if thread.lines > 0 then
      RegisterFavorite(thread);
    listItem := ListView.GetNextItem(listItem, sdBelow, [isSelected]);
  end;
  ListView.DoubleBuffered := True;
  ListView.Repaint;
  ListView.DoubleBuffered := False;
end;

procedure TMainWnd.actListDelFavExecute(Sender: TObject);
var
  listItem: TListItem;
  thread: TThreadItem;
begin
  listItem := ListView.Selected;
  thread := nil;
  while (listItem <> nil) and (listItem.Data <> thread) do
  begin
    thread := TThreadItem(listItem.Data);
    UnRegisterFavorite(thread);
    listItem := ListView.GetNextItem(listItem, sdBelow, [isSelected]);
  end;
  ListView.DoubleBuffered := True;
  ListView.Repaint;
  ListView.DoubleBuffered := False;
end;

(* 選択中のログを削除 *)
procedure TMainWnd.actListDelLogExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
  index: Integer;
begin
  item := ListView.Selected;
  thread := nil;

  UILock := True;
  StopAutoReSc;

  while (item <> nil) and (item.Data <> thread) do
  begin
    thread := TThreadItem(item.Data);
    {aiai}  //開いている場合は閉じる
    index := viewList.FindViewItemIndex(thread);
    if index <> -1 then
    begin
      thread.canclose := True;
      tabRightClickedIndex := index;
      CloseThisTab(False);
    end;
    {/aiai}
    thread.CancelAsyncRead;
    thread.RemoveLog;
    UnRegisterFavorite(thread);
    //UpdateThreadInfo(thread);
    item := ListView.GetNextItem(item, sdBelow, [isSelected]);
  end;

  ListView.DoubleBuffered := True;
  ListView.Repaint;
  ListView.DoubleBuffered := False;
  UpdateTabTexts;

  UILock := False;
end;

//datをクリップボードにコピー   //aiai
procedure TMainWnd.actListCopyDatExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
  fname, s: String;
begin
  item := ListView.Selected;
  thread := nil;

  s := '';
  while (item <> nil) and (item.Data <> thread) do
  begin
    thread := TThreadItem(item.Data);
    if thread.lines > 0 then
    begin
      fname := thread.GetFileName + '.dat';
      if FileExists(fname) then
        s := s + fname + #0;
    end;
    item := ListView.GetNextItem(item, sdBelow, [isSelected]);
  end;
  if s <> '' then
    CopyToClipboard(s, DROPEFFECT_COPY);
end;

//datとidxをクリップボードにコピー   //aiai
procedure TMainWnd.actListCopyDIExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
  fname, s: string;
begin
  item := ListView.Selected;
  thread := nil;
  s := '';

  while (item <> nil) and (item.Data <> thread) do
  begin
    thread := TThreadItem(item.Data);
    if thread.lines > 0 then
    begin
      fname := thread.GetFileName + '.dat';
      if FileExists(fname) then
        s := s + fname + #0;
      fname := thread.GetFileName + '.idx';
      if FileExists(fname) then
        s := s + fname + #0;
    end;
    item := ListView.GetNextItem(item, sdBelow, [isSelected]);
  end;

  if s <> '' then
    CopyToClipboard(s, DROPEFFECT_COPY);
end;



procedure TMainWnd.MenuWndNextTabClick(Sender: TObject);
  procedure NextTab;
  var
    index: integer;
  begin
    index := TabControl.TabIndex + 1;
    //▼ループ化
    if index >= TabControl.Tabs.Count then
      index := 0;

    if  (0 <= index) and (index <= TabControl.Tabs.Count -1) then
    begin
      //TabControl.TabIndex := index;
      SetCurrentView(index);
      TabControlChange(TabControl);
      SetRPane(ptView);
    end;
  end;
begin
  (*  *)
  if TreeView.Focused or FavoriteView.Focused then
  begin
    SetTabSetIndex(TreeTabControl.TabIndex + 1);
  end
  //▼スレ覧のタブ切り替え
  else if ListTabPanel.Visible and ListView.Focused then
  begin
    if ListTabControl.TabIndex >= ListTabControl.Tabs.Count-1 then
      ListTabControl.TabIndex := 0
    else
      ListTabControl.TabIndex := ListTabControl.TabIndex +1;
    ListTabControlChange(Sender);
  end
  else if Config.oprToggleRView then
  begin
    if mdRPane <> ptList then
      NextTab;
  end
  else begin
    NextTab;
  end;
end;

procedure TMainWnd.MenuWndPrevTabClick(Sender: TObject);
  procedure PrevTab;
  var
    index: integer;
  begin
    index := TabControl.TabIndex - 1;
    //▼ループ化
    if index < 0 then
      index := TabControl.Tabs.Count -1;

    if  (0 <= index) and (index <= TabControl.Tabs.Count -1) then
    begin
      //TabControl.TabIndex := index;
      SetCurrentView(index);
      TabControlChange(TabControl);
      SetRPane(ptView);
    end;
  end;
begin
  (*  *)
  if TreeView.Focused or FavoriteView.Focused then
  begin
    SetTabSetIndex(TreeTabControl.TabIndex - 1);
  end
  //▼スレ覧のタブ切り替え
  else if ListTabPanel.Visible and ListView.Focused then
  begin
    if ListTabControl.TabIndex <= 0 then
      ListTabControl.TabIndex := ListTabControl.Tabs.Count -1
    else
      ListTabControl.TabIndex := ListTabControl.TabIndex -1;
    ListTabControlChange(Sender);
  end

  else if Config.oprToggleRView then
  begin
    if mdRPane <> ptList then
      PrevTab;
  end
  else begin
    PrevTab;
  end;
end;


function TMainWnd.OpenURL(Msg: TMessage): Boolean;
var
  shMem: THogeSharedMem;
  i: integer;
  p: PChar;
  s: string;
begin
  shMem := nil;
  try
    shMem := THogeSharedMem.Create(sharedResourceName + URL_SUFFIX, MAX_URL_LEN);
    p := shMem.Memory;
    for i := 0 to MAX_URL_LEN -1 do
    begin
      if p^ = #0 then
      begin
        SetLength(s, i);
        Move(shMem.Memory^, s[1], i);
        NavigateIntoView(s, gtOther);
        break;
      end;
      Inc(p);
    end;
    result := true;
  except
    result := false;
  end;
  if shMem <> nil then
    shMem.Free;
end;

procedure TMainWnd.ON_WM_COPYDATA(var msg: TWMCopyData);
var
  buf: PChar;
  option: TStringList;
  i: integer;
  background: boolean;
begin
  //option := nil;
  background := false;
  buf := StrAlloc(msg.CopyDataStruct.cbData);
  option := TStringList.Create;
  try
    StrCopy(buf, msg.CopyDataStruct.lpData);
    option.Text := buf;
    if msg.CopyDataStruct.dwData = 1 then
      background := true;
    for i := 0 to option.Count - 1 do // スレを非アクティブで開く
      if CompareStr('-b', option[i]) = 0 then begin
        background := true;;
        option.Delete(i);
        break;
      end;
    {for i := 0 to option.Count - 1 do
      if StartWith('-', option[i], 1) then begin
        option.Delete(i);
        break;
      end;}
    for i := 0 to option.Count - 1 do
      {beginner}
      if not NavigateIntoView(option[i], gtOther, false, background) then begin
        if ImageForm.GetImage(option[i]) then
          OpenByBrowser(option[i])
        else
          Application.ProcessMessages;
      end;
      {/beginner}
  finally
    StrDispose(buf);
  end;
  option.Free;
end;

procedure TMainWnd.OnLogin(var msg: TMessage);
begin
  if Bool(msg.lParam) then
  begin
    loginIndicator := '=';
  end
  else begin
    loginIndicator := 'X';
    WriteStatus('LOGIN FAILED');
  end;
  UpdateIndicator;
end;

procedure TMainWnd.OnFavoritesOprMsg(var msg: TMessage);
begin
  if Bool(msg.lParam) then
  begin
    SaveFavorites(true);
    WriteStatus('お気に入り保存');
  end
  else begin
    if favorites.Load(Config.BasePath + FAVORITES_DAT) then
    begin
      updatefavorites;
      WriteStatus('お気に入り更新');
    end;
  end;
end;

procedure TMainWnd.UpdateIndicator;
begin
  StatusBar.Panels[0].Text := loginIndicator + IntToStr(AsyncManager.Count);
end;

procedure TMainWnd.UpdateIndicatorEx(index: integer);
begin
  StatusBar.Panels[0].Text := loginIndicator
    + IntToStr(index) + '/' + IntToStr(AsyncManager.Count);
end;

procedure TMainWnd.ON_WM_USER(var msg: TMessage);
begin
  case msg.wParam of
  CMD_OPEN:  OpenURL(msg);
  INF_LOGIN: OnLogin(msg);
  FAV_OPR:   OnFavoritesOprMsg(msg);
  end;
end;

procedure TMainWnd.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);

var
  Wnd: HWND;
begin
  case Msg.message of
  WM_KEYDOWN:
    if FavoriteView.IsEditing and (msg.wParam = VK_ESCAPE) then
      //▼お気に入り名前編集キャンセル時にIME状態を保存
      SaveImeMode(handle)
    else
    if (currentView <> nil) and
       (currentView.browser <> nil) and
       (IsChild(currentView.browser.Handle, Msg.hwnd)) then
    begin
      Handled := ProcessKeyForBrowser(Msg);
    end;
  WM_LBUTTONDBLCLK:
    if TabControl.Handle = Msg.hwnd then
    begin
      ThreadChkNewResButtonClick(Self);
      Handled := true;
    end
    //リストタブでの更新
    else if ListTabControl.Handle = Msg.hwnd then
    begin
      if (tabDragSourceIndex >= 0) and (tabDragSourceIndex < ListTabControl.Tabs.Count) and
         (ListTabControl.Tabs.Objects[tabDragSourceIndex] <> nil) then
        ListViewNavigate(TBoard(ListTabControl.Tabs.Objects[tabDragSourceIndex]), gotCHECK);
      Handled := true;
    end;
  //▼タブ上ホイール回転でタブ切り替え
  WM_MOUSEWHEEL:
    begin
      if Config.mseUseWheelTabChange and self.Active
                                    and (LoWord(Msg.wParam) <> MK_RBUTTON) then
      begin
        //if (Msg.hwnd = TabPanel.Handle) or (Msg.hwnd = TabControl.Handle) then
        if WebPanel.Visible and MouseInPane(TabPanel) then
        begin
          if viewList.Count > 1 then
          begin
            MenuWndThreadClick(Self);
            if Msg.wParam < 0 then
              MenuWndNextTabClick(Self)
            else
              MenuWndPrevTabClick(Self);
          end;
          Handled := true;
        end
        //else if (Msg.hwnd = ListTabPanel.Handle) or (Msg.hwnd = ListTabControl.Handle) then
        else if ListViewPanel.Visible and MouseInPane(ListTabPanel) then
        begin
          if boardList.Count > 1 then
          begin
            MenuWndThListClick(Self);
            if Msg.wParam < 0 then
              MenuWndNextTabClick(Self)
            else
              MenuWndPrevTabClick(Self);
          end;
          Handled := true;
        end
        //else if (Msg.hwnd = TreeTabControl.Handle) then
        {else if TreePanel.Visible and MouseInPane(TreeTabControl) then
        begin
          if Msg.wParam < 0 then
            MenuWndFavClick(Self)
          else
            MenuWndBoardClick(Self);
          Handled := true;
        end;} //aiai
      end;
      //【初心者】Janeを弄るスレ【歓迎】　その2
      //http://jane.s28.xrea.com/test/read.cgi/bbs/1067059929/604
      (* ホイールメッセージをマウスカーソル下のコントロールに送る *)
      if Config.mseWheelScrollUnderCursor and not Handled then
      begin
        Wnd := WindowFromPoint(Point(LOWORD(Msg.lParam), HIWORD(Msg.lParam)));
        if (Wnd <> 0) and (Msg.hwnd <> Wnd) then
        begin
          Handled := true;
          SendMessage(Wnd, Msg.message, Msg.wParam, Msg.lParam);
        end;
      end;
    end;
  end; //case

  //▼マウスジェスチャー
  if mouseGestureEnable then
    OnGestureMessage(Msg, Handled);

  //ポップアップメニュー抑止
  if restrainContext and (Msg.message = WM_RBUTTONUP) then
  begin
    Handled := True;
    restrainContext := False;
  end;
end;

(* 最小化時、タスクトレイに格納 *) //aiai
procedure TMainWnd.ApplicationEventsMinimize(Sender: TObject);
begin
  if Config.optHideInTaskTray then
  begin
    if Assigned(WriteForm) then
      WriteForm.MainWndOnHide;
    if Assigned(AAForm) then
      AAForm.MainWndOnHide;
    if Assigned(LovelyWebForm) then
      LovelyWebForm.MainWndOnHide;
    if Assigned(ImageForm) then
      ImageForm.MainWndOnHide;
    if Assigned(ImageViewCacheListForm) then
      ImageViewCacheListForm.MainWndOnHide;
    Hide;
    ShowWindow(Application.Handle, SW_HIDE);
    TrayIcon.Show;
  end;
end;

function TMainWnd.ProcessKeyForBrowser(Msg: TMsg): boolean;
var
  wmKey: TWMKey;
begin
  wmKey.Msg    := Msg.message;
  wmKey.CharCode := msg.wParam;
  wmKey.KeyData  := msg.lParam;
  wmKey.Result   := 0;
  result := self.IsShortCut(wmKey);
  if result then
    exit;
  case Msg.wParam of
    VK_CONTROL, VK_SHIFT:;
    else
      ReleasePopupHint(nil, True);
  end;
  case Msg.wParam of
  VK_BACK:
    begin
      if GetKeyState(VK_SHIFT) < 0 then
        actForwordExecute(Self)
      else
        actBackExecute(Self);
    end;
  VK_TAB:
    begin
      if not Config.oprDisableTabKeyInView then
        exit;
      if 0 <= GetKeyState(VK_SHIFT) then
        MenuViewNextPaneClick(Self)
      else
        MenuViewPrevPaneClick(Self);
      result := true;
    end;
  Ord('F'):
    begin
      if (GetKeyState(VK_CONTROL) < 0) then
      begin
        MenuFindClick(Self);
        result := true;
      end;
    end;
  VK_PRIOR:
    begin
      if (GetKeyState(VK_CONTROL) < 0) then
      begin
        SetCurrentView(TabControl.TabIndex - 1);
        result := true;
      end;
    end;
  VK_NEXT:
    begin
      if (GetKeyState(VK_CONTROL) < 0) then
      begin
        SetCurrentView(TabControl.TabIndex + 1);
        result := true;
      end;
    end;
  Ord('0')..Ord('9'), VK_NUMPAD0..VK_NUMPAD9:
    begin
      ResJumpTimer.Enabled := false;
      if (ResJumpTimer.Tag = 0) and ((Msg.wParam = Ord('0')) or
        (Msg.wParam = VK_NUMPAD0)) then
        FResJumpNormalPopup := True;
      if Msg.wParam <= Ord('9') then
        ResJumpTimer.Tag := ResJumpTimer.Tag * 10 + (Msg.wParam - Ord('0'))
      else
        ResJumpTimer.Tag := ResJumpTimer.Tag * 10 + (Msg.wParam - VK_NUMPAD0);
      ResJumpTimer.Enabled := true;
    end;
  end;
end;

//aiai
procedure TMainWnd.PopupTreeSetHeaderClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
  rc: integer;
begin
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PopupTreeClose.Visible then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board = nil then
    exit;

  if InputDlg = nil then
    InputDlg := TInputDlg.Create(self);

  InputDlg.Caption := 'HeaderのHTMLを直接指定してみたりとか-pre-α';

  with board do
  begin
    InputDlg.Edit.Text := customHeader;
    rc := InputDlg.ShowModal;
    if rc = 3 then
    begin
      AddRef;
      customHeader := InputDlg.Edit.Text;
      Save;
      Release;
    end;
  end;
end;

procedure TMainWnd.PopupViewReplyClick(Sender: TObject);
begin
  {aiai} //メモ欄で
  if (Sender = PopupViewReplyOnWriteMemo) then
  begin
    WritePanelControl.SetMemoText(Config.wrtReplyMark + IntToStr(TMenuItem(Sender).Tag) + #13#10);
    ToggleWritePanelVisible(True);
    try MemoWriteMain.SetFocus; except end;
  end else
  {/aiai}
  //▼開いているときは番号追加
  if (WriteForm <> nil) and WriteForm.Visible then
  begin
    WriteForm.Memo.SelText := Config.wrtReplyMark + IntToStr(TMenuItem(Sender).Tag) + #13#10;
    WriteForm.SetFocus;
  end else
    OpenWriteForm(GetViewOf(PopupViewMenu.PopupComponent), Config.wrtReplyMark + IntToStr(TMenuItem(Sender).Tag) + #13#10);
end;

procedure TMainWnd.OpenWriteForm(Sender: TObject; const AString: string);
begin
  (*  *)
  if (WriteForm <> nil) and WriteForm.freeReserve and not WriteForm.Visible then
  begin
    WriteForm.Free;
    WriteForm := nil;
  end;
  if WriteForm = nil then
  begin
    WriteForm := TWriteForm.Create(Self);
  end;
  if WriteForm.Visible then
  begin
    WriteForm.SetFocus;
    exit;
  end;
  if (WriteForm.thread <> nil) or (WriteForm.board <> nil) then
  begin
    WriteForm.Visible := true;
    exit;
  end;

  if (Sender is TBaseViewItem) and assigned(TBaseViewItem(Sender).thread) then
  begin
    WriteForm.Memo.Clear;
    WriteForm.Memo.Text := AString;
    WriteForm.Memo.SelStart := length(AString);
    WriteForm.Show(TViewItem(Sender).thread);
  end
  else if (Sender is TBoard) and not (Sender is TFunctionalBoard) then
  begin
    WriteForm.Memo.Clear;
    WriteForm.Show(TBoard(Sender));
  end;
  ReleasePopupHint(nil, True);
end;

procedure TMainWnd.PopupViewReplyWithQuotationClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  strList: TStringList;
  s: string;
  i: integer;
begin
  if PopupViewMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(TComponent(PopupViewMenu.PopupComponent))
  else
    viewItem := GetActiveView;
  if not assigned(viewItem.thread.dat) then
    exit;
  strList := TStringList.Create;
  strList.Text := StripBlankLinesForHint(viewItem.thread.ToString('<MESSAGE/><br>', TMenuItem(Sender).Tag, 1), High(Integer));
  s := Config.wrtReplyMark + IntToStr(TMenuItem(Sender).Tag) + #13#10;
  for i := 0 to strList.Count - 1 do
    s := s + '> ' + strList.Strings[i] + #13#10;
  strList.Free;

  //▼開いているときは引用文を追加
  if (WriteForm <> nil) and WriteForm.Visible then
  begin
    WriteForm.Memo.Lines.Add(Copy(s, 1, Length(s)-2));
    WriteForm.SetFocus;
  end else
    OpenWriteForm(viewItem, s);

end;

//aiai メモ欄で引用つきレス
procedure TMainWnd.PopupViewReplyWithQuotationOnWriteMemoClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  strList: TStringList;
  s: string;
  i: integer;
begin
  if PopupViewMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(TComponent(PopupViewMenu.PopupComponent))
  else
    viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) or (viewItem.thread.dat = nil) then
    exit;

  strList := TStringList.Create;
  strList.Text := viewItem.thread.ToString('<MESSAGE/><br>', TMenuItem(Sender).Tag, 1);
  s := Config.wrtReplyMark + IntToStr(TMenuItem(Sender).Tag) + #13#10;
  for i := 0 to strList.Count -1 do
    s := s + '> ' + strList.Strings[i] + #13#10;
  strList.Free;

  WritePanelControl.SetMemoText(Copy(s, 1, Length(s)));
  ToggleWritePanelVisible(True);
  try MemoWriteMain.SetFocus; except end;
end;

(* 既読にする *)//aiai
procedure TMainWnd.actListAlreadyExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
begin
  item := ListView.Selected;
  if item = nil then
    exit;
  thread := TThreadItem(item.Data);
  if thread = nil then
    exit;
  thread.oldLines := thread.lines;
  thread.SaveIndexData;
end;

procedure TMainWnd.actGeneralUpdateExecute(Sender: TObject);
begin
  (*  *)
  if (not Config.oprToggleRView) or (mdRPane = ptList) then
    MenuThreadRefreshClick(Sender)
  else
    ThreadChkNewResButtonClick(Sender);
end;

procedure TMainWnd.ThreadRefreshButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
  begin
    restrainContext := True;
    if (not Config.oprToggleRView) or (mdRPane = ptList) then
      ThreadListRefreshAll
    else
      actCheckNewResAllExecute(Sender);
  end;
end;

procedure TMainWnd.OnAbout;
begin
  SetRPane(ptView);
  NewView.About;
end;

procedure TMainWnd.PopupTreeUMAClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PopupTreeClose.Visible then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board <> nil then
  begin
    with board do
    begin
      uma := not uma;
      SaveIndex;
    end;
  end;
end;

//スレッドのURLをコピー
procedure TMainWnd.actListCopyURLExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
  urlList: string;
begin
  item := ListView.Selected;
  if item = nil then
    exit;
  thread := TThreadItem(item.Data);
  if thread = nil then
    exit;
  urlList := thread.ToURL;
  while true do
  begin
    item := ListView.GetNextItem(item, sdBelow, [isSelected]);
    if (item = nil) or (item.Data = thread) then
      break;
    thread := TThreadItem(item.Data);
    urlList := urlList + #13#10 + thread.ToURL;
  end;
  if urlList <> '' then
    Clipboard.AsText := urlList;
end;

//スレッドのタイトルをコピー //aiai
procedure TMainWnd.actListCopyTITLEExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
  titleList: string;
begin
  item := ListView.Selected;
  if item = nil then
    exit;
  thread := TThreadItem(item.Data);
  if thread = nil then
    exit;
  titleList := HTML2String(thread.title);
  while true do
  begin
    item := ListView.GetNextItem(item, sdBelow, [isSelected]);
    if (item = nil) or (item.Data = thread) then
      break;
    thread := TThreadItem(item.Data);
    titleList := titleList + #13#10
             + HTML2String(thread.title);
  end;
  if titleList <> '' then
    Clipboard.AsText := titleList;
end;

//スレッドのタイトルとURLをコピー
procedure TMainWnd.actListCopyTUExecute(Sender: TObject);
var
  item: TListItem;
  thread: TThreadItem;
  urlList: string;
begin
  item := ListView.Selected;
  if item = nil then
    exit;
  thread := TThreadItem(item.Data);
  if thread = nil then
    exit;
  urlList := HTML2String(thread.title) + #13#10
           + thread.ToURL;
  while true do
  begin
    item := ListView.GetNextItem(item, sdBelow, [isSelected]);
    if (item = nil) or (item.Data = thread) then
      break;
    thread := TThreadItem(item.Data);
    urlList := urlList + #13#10
             + HTML2String(thread.title) + #13#10
             + thread.ToURL;
  end;
  if urlList <> '' then
    Clipboard.AsText := urlList;
end;

//スレッドのURLをコピー
procedure TMainWnd.PopupTreeCopyURLClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PopupTreeClose.Visible then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board <> nil then
    Clipboard.AsText := board.URIBase + '/' ;
end;

//スレッドのタイトルをコピー  //aiai
procedure TMainWnd.PopupTreeCopyTITLEClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PopupTreeClose.Visible then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board <> nil then
    with board do
      Clipboard.AsText := HTML2String(name);
end;

//スレッドのタイトルとURLをコピー
procedure TMainWnd.PopupTreeCopyTUClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  //▼スレ覧タブのポップアップメニューに使えるように変更
  if PopupTreeClose.Visible then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board <> nil then
    with board do
      Clipboard.AsText := HTML2String(name) + #13#10 + URIBase + '/' ;
end;


procedure TMainWnd.DebugTmpClick(Sender: TObject);
var
  hs: THeapStatus;
begin
  Log(Format('AllocMemCount: %d, AllocMemSize: %d',
             [AllocMemCount, AllocMemSize]));
  hs := GetHeapStatus;
//  if hs <> nil then
  begin
    with hs do
    begin
//      Log(Format('TotalAddrSpace: %d, TotalUncommitted: %d, TotalCommitted: %d',
//                 [TotalAddrSpace, TotalUncommitted, TotalCommitted]));
      Log(Format('TotalAllocated: %d, TotalFree: %d, FreeSmall: %d, FreeBig: %d, Unused: %d, Overhead: %d, HeapErrorCode: %d',
                 [TotalAllocated, TotalFree, FreeSmall, FreeBig, Unused, Overhead, HeapErrorCode]));
    end;
  end;
  viewList.Debug;
  {$IFDEF DEBUG}
  AsyncManager.Dump;
  {$ENDIF}
end;

procedure TMainWnd.MenuListClick(Sender: TObject);
var
  item: TListItem;
begin
  {aiai}
  if (CurrentBoard <> nil) and not (CurrentBoard is TFunctionalBoard) then begin
    self.MenuListRefreshIdxList.Visible := true;
  end else begin
    self.MenuListRefreshIdxList.Visible := false;
  end;

  if CurrentBoard <> nil then begin
    self.MenuListOpenAll.Enabled := true;
    self.MenuListCloseBoards.Enabled := true;
    self.MenuListClose.Enabled := true;
    self.MenuListRefresh.Enabled := true;
    self.MenuListHomeMovedBoard.Enabled := true;
    self.MenuListThreBuild.Enabled := true;
    self.MenuListSort.Enabled := true;
    self.MenuListCopys.Enabled := true;
    self.MenuListRefreshAll.Enabled := true;
    self.MenuListHideHistoricalLog.Enabled := true;
    self.MenuListHideHistoricalLog.Checked := CurrentBoard.HideHistoricalLog;
  end else begin
    self.MenuListOpenAll.Enabled := false;
    self.MenuListCloseBoards.Enabled := false;
    self.MenuListClose.Enabled := false;
    self.MenuListRefresh.Enabled := false;
    self.MenuListHomeMovedBoard.Enabled := false;
    self.MenuListThreBuild.Enabled := false;
    self.MenuListSort.Enabled := false;
    self.MenuListCopys.Enabled := false;
    self.MenuListRefreshAll.Enabled := false;
    self.MenuListHideHistoricalLog.Enabled := false;
    self.MenuListHideHistoricalLog.Checked := false;
  end;
  {/aiai}

  item := ListView.Selected;
  if item = nil then
    exit;
  ListViewSelectItem(ListView, item, true);
end;


procedure TMainWnd.OnBrowserMouseMove(Sender: TObject; Shift: TShiftState;
                                      X, Y: Integer);
var
  viewItem: TBaseViewItem;
  st: String;
  Pos: TPoint;
begin
  Pos := TControl(Sender).ClientToScreen(Point(X, Y));
  if (prevPos.X = Pos.X) and (PrevPos.Y = Pos.Y) then
    exit;
  PrevPos.X := Pos.X;
  PrevPos.Y := Pos.Y;
  viewItem := GetViewOf(TComponent(Sender));
  st := TVMouseProc(THogeTextView(Sender), Shift, X, Y);
  if FStatusText = '' then
    PopupHint.ReleaseHandle;

  if (st <> FStatusText) or (Assigned(viewItem)
          and Assigned(viewItem.PossessionView)
              and (not viewItem.PossessionView.Enabled)
                  and (viewItem.PossessionView.IdStr <> FStatusText)
                      and not proccessingPopupFromContext) then
  begin
    FStatusText := st;
    BrowserStatusTextChange(Sender, FStatusText, Mouse.CursorPos);
    FHovering := False;
  end;
end;

procedure TMainWnd.OnBrowserMouseHover(Sender: TObject; Shift: TShiftState;
                                       X, Y: Integer);
var
  viewItem: TBaseViewItem;
begin
  if GetAutoEnableNesting(Sender) and NeedHover(Sender) then
  begin
    viewItem := GetViewOf(TComponent(Sender));
    if assigned(viewItem.PossessionView) and not viewItem.PossessionView.Enabled then
    begin
      viewItem.PossessionView.Enabled := true;
      viewItem.PossessionView.OwnerCofirmation := True;
    end;
  end;
end;

procedure TMainWnd.OnBrowserMouseDown(Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X, Y: Integer);
var
  Cancel: WordBool;
  viewItem: TBaseViewItem;
  tmpPopup: TPopupMenu;
  CursorPos: TPoint;  //aiai
begin
  viewItem := GetViewOf(TComponent(Sender));
  if Assigned(viewItem) then
    viewItem.Lock;
  try
    case Button of
    mbLeft:
      if (ssDouble in Shift) and Assigned(viewItem) and
        not (Assigned(viewItem.PossessionView) and viewItem.PossessionView.Enabled) and
        viewItem.BrowserQueryClose then
      begin
        //Nothing To Do
      end else
      begin
        Cancel := False;
        OnBrowserMouseMove(Sender, Shift, X, Y);
        BrowserBeforeNavigate(Sender, FStatusText, Mouse.CursorPos, Cancel, False);
        if Cancel then
          THogeTextView(Sender).Selecting := False;
      end;
    mbRight:
      begin
        tmpPopup := nil;
        if Sender is THogeTextView then
        begin
          tmpPopup := THogeTextView(Sender).PopupMenu;
          THogeTextView(Sender).PopupMenu := nil;
        end;
        try

          {aiai}
          //////////////////////////////////////////////////////////////////////
          //選択範囲右クリック→レス番ポップアップ
          //レス番右クリック→ツリー・アウトラインポップアップ
          //ポップアップメニュー
          //リンクが'menu:xx'ならばおそらくShowTreeHintはTrueをかえす
          //////////////////////////////////////////////////////////////////////

          CursorPos := THogeTextView(Sender).ClientToPhysicalCharPos(X, Y);
          if not InvalidPoint(CursorPos)
            and THogeTextView(Sender).InSelection(CursorPos.X, CursorPos.Y)
              and Popupres(Sender, GetKeyState(VK_CONTROL) < 0) then
          begin
            FStatusText := '';
            restrainContext := true;  //ポップアップメニューを消す
          end else if ShowTreeHint(Sender, GetKeyState(VK_CONTROL) >= 0) then
            restrainContext := true  //ポップアップメニューを消す
          else
            ReleasePopupHint(viewItem, True); //ポップアップヒントを消す
          {/aiai}

        finally
          if Assigned(tmpPopup) then
            THogeTextView(Sender).PopupMenu := tmpPopup;
        end;
      end;
    end;
  finally
    if Assigned(viewItem) then
      viewItem.UnLock;
  end;
end;

(*  *)
procedure TMainWnd.BrowserEnter(Sender: TObject);
begin
  if ViewPopupAutoScrollAtAnyTime.Checked then
    exit;

  if (AutoScroll <> nil) then AutoScroll.Pause(scrPauseBrowserEnter);
end;

(*  *)
procedure TMainWnd.BrowserExit(Sender: TObject);
begin
  if ViewPopupAutoScrollAtAnyTime.Checked then
    exit;

  if (AutoScroll <> nil) and (AutoScroll.State = scrPauseBrowserEnter) then AutoScroll.Enabled := true;
end;

procedure TMainwnd.BrowserScrollEnd(Sender: TObject);
var
  viewItem: TViewItem;
  s, datSize: String;
begin
  if not Config.viewReadIfScrollBottom then
    exit;

  viewItem := GetActiveView;
  If (viewItem <> nil) and (viewItem.thread <> nil)
     and (viewItem.thread.lines > viewItem.thread.oldLines) then
  with viewItem.thread do
  begin

    if Config.oprCheckNewWRedraw then
      viewItem.NewRequest(viewItem.thread, gotLocal, viewItem.thread.lines - 1, false, true, false);

    oldLines := lines;
    anchorLine := lines;

    if state = tsComplete then s := ' －過去ログ－ '
    else s := ' ';
    if assigned(dat) then datSize := IntToStr(dat.Size div 1024) + 'KB'
    else datSize := '';
    StatusBar.Panels.Items[2].Text
      := '[新0: 未0: 全'
      +  IntToStr(lines) + '] ' + HTML2String(title)
      +  s
      + ' [' + TBoard(board).name + '/'
      + TCategory(TBoard(board).category).name + ']  '
      + datSize;
    {StatusBar2.Text[2]
      := '[新0: 全'
      +  IntToStr(lines) + '] ' + HTML2String(title)
      +  s
      + ' [' + TBoard(board).name + '/'
      + TCategory(TBoard(board).category).name + ']  '
      + datSize;}  //aiai
    TabControl.Refresh;
    if not Config.oprCheckNewWRedraw then
    begin
      ListView.DoubleBuffered := True;
      ListView.Repaint;
      ListView.DoubleBuffered := False;
    end;
  end;
end;


procedure TMainWnd.BrowserMouseEnter(Sender: TObject);
var
  viewItem: TBaseViewItem;
begin
  viewItem := GetViewOf(TComponent(Sender));
  if Assigned(viewItem) and (viewItem is TPopupViewItem) then
    TPopupViewItem(viewItem).HadPointed := True;
end;

procedure TMainWnd.OnBrowserKeyDown(Sender: TObject; var Key: Word;
                                    Shift: TShiftState);
  function GetCaretPoint: TPoint;
  begin
    GetCaretPos(Result);
    Result := (Sender as THogeTextView).ClientToScreen(Result);
  end;
var
  view: THogeTextView;
  item: THogeTVItem;
  point: TPoint;
  index: integer;
  ref: string;
  Cancel: WordBool;
begin
  view := THogeTextView(Sender);
  case Key of
    VK_CONTROL, VK_SHIFT {beginner}, VK_APPS{/beginner}:;
    else
      ReleasePopupHint(nil, True);
  end;
  case Key of
  VK_BACK:
    begin
      if ssShift in Shift then
        actForwordExecute(Self)
      else
        actBackExecute(Self);
    end;
  VK_SPACE:
    begin
      view.Selecting := False;
      if ssShift in Shift then
        view.PageUp
      else
        view.PageDown;
    end;
  VK_RETURN, Ord('P'):
    begin
      point := view.Caret;
      item :=view.Strings[point.Y];
      index := point.X + 1;
      ref := item.GetEmbed(index);
      case Key of
      VK_RETURN:
        BrowserBeforeNavigate(Sender, ref, GetCaretPoint, Cancel, True);
      Ord('P'):
        BrowserStatusTextChange(Sender, ref, GetCaretPoint);
      end;
      Key := 0;
    end;
  Ord('0')..Ord('9'), VK_NUMPAD0..VK_NUMPAD9:
    begin
      ResJumpTimer.Enabled := false;
      if (ResJumpTimer.Tag = 0) and ((Key = Ord('0')) or
        (Key = VK_NUMPAD0)) then
        FResJumpNormalPopup := True;
      if Key <= Ord('9') then
        ResJumpTimer.Tag := ResJumpTimer.Tag * 10 + (Key - Ord('0'))
      else
        ResJumpTimer.Tag := ResJumpTimer.Tag * 10 + (Key - VK_NUMPAD0);
      ResJumpTimer.Enabled := true;
    end;
  end;
end;


procedure TMainWnd.BrowserQueryContext(Sender: TObject; var CanContext: Boolean);
var
  viewItem: TBaseViewItem;
begin
  viewItem := GetViewOf(TComponent(Sender));
  if Assigned(viewItem) then
    viewItem.Lock;
  CanContext := True
end;


procedure TMainWnd.BrowserEndContext(Sender: TObject);
var
  viewItem: TBaseViewItem;
begin
  viewItem := GetViewOf(TComponent(Sender));
  if Assigned(viewItem) then
    viewItem.UnLock;
end;


procedure TMainWnd.PopupViewItemEnabled(Sender: TObject);
begin
  if (Sender as TPopupViewItem).IsMouseInPane then
    FStatusText := '';
end;


procedure TMainWnd.PopupTextMenuPopup(Sender: TObject);
var
  viewItem: TBaseViewItem;
  s: String;
  {aiai}
  selecting: Boolean; (* 選択範囲があるかどうか *)
  linking: Boolean;   (* リンクかどうか *)
  iding: Boolean;     (* IDかどうか *)
  protocol: Boolean;  (* http or https or ftp *)
  threading: Boolean; (* スレかどうか *)
  i: integer;
  {/aiai}
begin

  PopupViewMenu.PopupComponent := nil; //コマンドの誤動作防止
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(TComponent(PopupTextMenu.PopupComponent))
  else
  begin
    viewItem := GetActiveView;
    (Sender as TPopupMenu).PopupComponent := (viewItem as TViewItem).browser;
  end;
  if viewItem = nil then
    exit;

  {aiai}
  s := viewItem.GetSelection;
  selecting := Length(s) > 0;
  s := viewItem.GetLinkUnderCursor;
  linking := Length(s) > 0;
  iding := linking and AnsiStartsStr('ID:', s);
  protocol := linking and not iding and ProtocolCheck(s);
  threading := Assigned(viewItem.thread);

  TextPopupCopy.Enabled := selecting;
  TextPopupCopyLink.Enabled := linking;
  TextPopupExtractPopup.Enabled := TextPopupCopy.Enabled;

  TextPopupCopy.Visible := selecting or not iding;
  TextPopupCopyLink.Visible :=TextPopupCopy.Visible;
  TextPopupSelectAll.Visible := not linking;
  TextPopupExtractPopup.Visible := TextPopupCopy.Visible and threading;

  TextPopupTrensferToWriteForm.Visible := TextPopupCopy.Enabled;
  TextPopupTrensferToWriteMemo.Visible := TextPopupCopy.Enabled;
  TextPopupAddNGWord.Visible := TextPopupCopy.Enabled;
  TextPopupExtractRes.Visible := TextPopupCopy.Enabled and threading;
  TextPopupAddAAList.Visible := TextPopupCopy.Enabled;
  TextPopupOpenSelectionURL.Visible := TextPopupCopy.Enabled;
  TextPopUpOpenSelectionURLs.Visible := TextPopupCopy.Enabled;

  TextPopupOpenByViewer.Visible := protocol;
  TextPopupOpenByLovelyBrowser.Visible := TextPopupOpenByViewer.Visible ;
  TextPopupOpenByBrowser.Visible := TextPopupOpenByViewer.Visible ;
  TextPopupDownload.Visible := TextPopupOpenByViewer.Visible ;
  TextPopupRegisterBroCra.Visible := TextPopupOpenByViewer.Visible ;
  TextPopupChottoView.Visible := TextPopupOpenByViewer.Visible ;

  TextPopupDeleteCache.Visible := protocol and HttpManager.CacheExists(ProofURL(s));

  TextPopupExtractID.Visible := iding and threading;
  TextPopupCopyID.Visible := iding;
  TextPopupAddNGID.Visible := iding;
  TextPopupIDAbone.Visible := TextPopupExtractID.Visible;
  TextPopupIDAbone2.Visible := TextPopupExtractID.Visible;

  //ID:の場合は外部コマンド遮断
  With PopupTextMenu do
  begin
    i := Items.IndexOf(TextPopupCmdSep);
    for i := i + 1 to Items.Count - 1 do
      Items[i].Visible := not iding;
  end;
  {/aiai}
end;

procedure TMainWnd.TextPopupCopyClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  Clipboard.AsText := viewItem.GetSelection;
end;

{beginner} //選択範囲を書き込みダイアログに送る
procedure TMainWnd.TextPopupTrensferToWriteFormClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  SelString: String;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;

  SelString := viewItem.GetSelection;
  if SelString = '' then
    exit;

  If SelString[Length(SelString)] = #10 then
    SelString := copy(SelString, 1, Length(SelString) - 2);

  {aiai}
  if TMenuItem(Sender).Tag = 1 then
  begin
    WritePanelControl.SetMemoText('> ' + StringReplace(SelString, #13#10, #13#10'> ', [rfReplaceAll]) + #13#10);
    ToggleWritePanelVisible(True);
    try MemoWriteMain.SetFocus; except end;
  end else
  {/aiai}
  if (WriteForm <> nil) and WriteForm.Visible then
  begin
    WriteForm.Memo.Lines.Add('> ' + StringReplace(SelString, #13#10, #13#10'> ', [rfReplaceAll]));
    WriteForm.SetFocus;
  end else begin
    if viewItem.thread <> nil then
      OpenWriteForm(viewItem, '> ' + StringReplace(SelString, #13#10, #13#10'> ', [rfReplaceAll]) + #13#10);
  end;
end;
{/beginner}


{beginner} //選択範囲をNGワードに登録
procedure TMainWnd.TextPopupNGWordClick(Sender: TObject);
var
  BaseViewItem: TBaseViewItem; //スレビューorポップアップ
  viewItem: TViewItem; //スレビュー
  Item:string;
  i:Integer;
  tmp:string;
  NGItemData: TNGItemData;
begin
  //スレビューを取得
  viewItem  := GetActiveView;
  if viewItem = nil then
    exit;

  //キーワード選択をしたスレビューorポップアップを取得
  if PopupTextMenu.PopupComponent is THogeTextView then
    BaseViewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    BaseViewItem := GetActiveView;

  Item := BaseViewItem.GetSelection;

  if Item = '' then Exit;

  Item := StringReplace(Item,'>','&gt;',[rfReplaceAll]);
  Item := StringReplace(Item,'<','&lt;',[rfReplaceAll]);
  Item := StringReplace(Item,#13#10,' <br> ',[rfReplaceAll]);

  i := NGItems[NG_ITEM_MSG].IndexOf(item);
  if i < 0 then begin
    MessageBeep(MB_ICONEXCLAMATION);  //aiai
    if MessageDlg('キーワード ”' + Item + '” をNGWordに追加します', mtInformation, [mbOk, mbCancel], 0) <> mrOk then
      Exit;
    tmp := '';
    NGItemData := TNGItemData.Create('', tmp);
    NGItemData.BMSearch := TBMSearch.Create;
    NGItemData.BMSearch.IgnoreCase := True;
    NGItemData.BMSearch.Subject := Item;

    NGItems[NG_ITEM_MSG].AddObject(Item, NGItemData);
    NGItems[NG_ITEM_MSG].SaveToFile(config.basepath + NG_FILE[NG_ITEM_MSG]);
    if Assigned(viewItem.thread) then //aiai 条件追加
      viewItem.LocalReload(viewItem.GetTopRes);
  end else begin
    MessageDlg('キーワード"'+Item+'"は登録済み',mtWarning,[mbOk],0);
  end;
end;

(* 選択範囲をAAListに登録 *) //aiai
procedure TMainWnd.TextPopupAddAAListClick(Sender: TObject);
var
  dlg: TAddAAForm;
  viewItem: TBaseViewItem;
  s: String;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;

  if viewItem = nil then exit;

  s := viewItem.GetSelection;

  if not (length(s) > 0) then exit;

  dlg := TAddAAForm.Create(self);
  dlg.Text := s;
  dlg.ShowModal;
  dlg.Release;
end;



//選択範囲をURLとして開く
procedure TMainWnd.TextPopupOpenSelectionURLClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  URI:String;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;

  if viewItem.GetSelection = '' then
    exit;
  URI:=UImageViewer.ProofURL(viewItem.GetSelection);

  if URI='' then Exit;

  if sender=TextPopupOpenByBrowser then
    OpenByBrowser(URI)
  else if not NavigateIntoView(URI, gtOther) then
    if not ImageForm.GetImage(URI,viewItem) then OpenByBrowser(URI);

end;

//選択範囲のURLを全て開く
procedure TMainWnd.TextPopupOpenSelectionURLsClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  URI:String;
  URIs:TStringList;
  i:Integer;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;

  if viewItem.GetSelection='' then
    exit;

  URIs:=TStringList.Create;
  try
    UImageViewer.ExtractURLs(viewItem.GetSelection,URIs);

    for i:=0 to URIs.Count-1 do begin
      URI:=UImageViewer.ProofURL(URIs[i]);
      if URI<>'' then
        if ImageViewConfig.OpenImagesOnly then begin
          if ImageViewConfig.ExamFileExt(URI) then
            ImageForm.GetImage(URI,viewItem);
        end else begin
          if not NavigateIntoView(URI, gtOther) then
            if not ImageForm.GetImage(URI,viewItem) then
              OpenByBrowser(URI);
        end;
    end;
  finally
    URIs.Free; //ゐ
  end
end;

//aiai Lovely Web Browserで開く
procedure TMainWnd.TextPopupOpenByLovelyBrowserClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  S: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  S := viewItem.LinkText;
  S := CutImenu(S);
  if ProtocolCheck(S) then
    OpenByLovelyBrowser(S);
end;

//ブラウザで開く
procedure TMainWnd.TextPopupOpenByBrowserClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  S: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  S := viewItem.LinkText;
  S := CutImenu(S);
  if ProtocolCheck(S) then
    OpenByBrowser(S);
end;

//強制的にビューアで開く
procedure TMainWnd.TextPopupOpenByViewerClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  S: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  S := viewItem.LinkText;
  S := CutImenu(S);
  if not NavigateIntoView(S, gtOther) then
    if not ImageForm.GetImage(S,viewItem,nil,True) then
end;


//ブラクラ登録
procedure TMainWnd.TextPopupRegisterBroCraClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  S: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  S := viewItem.LinkText;
  S := ProofURL(CutImenu(S));
  HttpManager.RegisterBrowserCrasher(S);
end;

//画像キャッシュの削除
procedure TMainWnd.TextPopupDeleteCacheClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  S: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  S := viewItem.LinkText;
  if Length(S) <= 0 then
    exit;
  S := ProofURL(CutImenu(S));
  if HttpManager.CacheExists(S) then
    HttpManager.DeleteCache(S);
end;


{//beginner}

procedure TMainWnd.TextPopupCopyLinkClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  link: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  link := viewItem.LinkText;
  if (viewItem = nil) or (viewItem.thread = nil) then
  begin
     Clipboard.AsText := link;
    exit;
  end;
  if AnsiStartsStr('#', link) then
  begin
    link := Copy(link, 2, Length(link) - 1);
    Clipboard.AsText := viewItem.thread.ToURL(true, false, link);
  end else if AnsiStartsStr('BE:', link) then
    Clipboard.AsText := 'http://be.2ch.net/test/p.php?i='
      + Copy(link, 4, Length(link) - 3)
        + '&u=d:'
          + viewItem.thread.ToURL(true, true)
  else
    Clipboard.AsText := link;
end;


procedure TMainWnd.TextPopupSelectAllClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if Assigned(viewItem) then
    viewItem.SelectAll;
end;

procedure TMainWnd.ThreadClosing(const thread: TThreadItem);
var
  s: string;
  index: integer;
begin
  if thread = nil then
    exit;
  s := AnsiReplaceStr(HTML2String(thread.title), '&', '&&') + #10 + thread.ToURL(false);
  with FRecentlyClosedThreads do
  begin
    index := IndexOf(s);
    if index = 0 then
      exit;
    if 0 < index then
      Delete(index);
    while 9 <= Count do
      Delete(Count -1);
    Insert(0, s);
  end;
end;

procedure TMainWnd.WindowRecentlyClosedClick(Sender: TObject);
var
  index: integer;
begin
  (*  *)
  index := TMenuItem(Sender).Tag;
  if (0 <= index) and (index <= FRecentlyClosedThreads.Count -1) then
  begin
    NavigateIntoView(Copy(FRecentlyClosedThreads[index],
                          Pos(#10, FRecentlyClosedThreads[index])+1,
                              High(integer)),
                     gtOther, false, Config.oprClosedBgOpen);
    FRecentlyClosedThreads.Delete(index);
  end;
end;











//▼マウスジェスチャー関係
//------------------------------------------------------------------------------
procedure TMainWnd.OnGestureMessage(var Msg: TMsg; var Handled: boolean);
  function StartPlace:string;
  var
    ControlAtCursor:TWinControl;
  begin
    if assigned(WriteForm) and WriteForm.Visible and (WriteForm.WindowState <> wsMinimized)
                                               and PtInRect(WriteForm.BoundsRect,Msg.pt) then
      Result:='★'
    else if ImageForm.Visible and (ImageForm.WindowState <> wsMinimized)
                                               and PtInRect(ImageForm.BoundsRect,Msg.pt) then
      Result:='☆'
    else begin
      ControlAtCursor:=Self;
      while ControlAtCursor.ControlAtPos(ControlAtCursor.ScreenToClient(Msg.pt),True,True) is TWinControl do
        ControlAtCursor:=TWinControl(ControlAtCursor.ControlAtPos(ControlAtCursor.ScreenToClient(Msg.pt),True,True));
      if ControlAtCursor is THogeTextView then
        Result:='■'
      else if ControlAtCursor is THogeListView then
        Result:='▽'
      else if ControlAtCursor is TTreeView then
        Result:='◯'
      else
        Result:='';
    end;
  end;

begin
  case Msg.message of
  WM_MOUSEMOVE:
    if Msg.wParam = MK_RBUTTON then
    begin
      MoveGesture(Msg.pt);
      Handled := true;
    end;
  WM_LBUTTONUP:
  	if clickGestureStandby then
    begin
      clickGestureStandby := false;
      Handled := true;
      GestureExecute(StartPlace + 'LeftClick'); //beginner
    end;
  WM_MBUTTONUP:
    if clickGestureStandby then
    begin
      clickGestureStandby := false;
      Handled := true;
      GestureExecute(StartPlace + 'WheelClick'); //beginner
    end;
  WM_XBUTTONUP:
    if clickGestureStandby then
    begin
      clickGestureStandby := false;
      Handled := true;
      if (GetKeyState(VK_RBUTTON) < 0) then
      case HiWord(Msg.wParam) of
        MK_XBUTTON1: GestureExecute(StartPlace + 'Side1R'); //beginner
        MK_XBUTTON2: GestureExecute(StartPlace + 'Side2R'); //beginner
      end
      else begin
        case HiWord(Msg.wParam) of
          MK_XBUTTON1: GestureExecute(StartPlace + 'Side1'); //beginner
          MK_XBUTTON2: GestureExecute(StartPlace + 'Side2'); //beginner
        end;
       	restrainContext := false;
      end;
    end;
  WM_LBUTTONDOWN:
  	if Msg.wParam = (MK_RBUTTON + MK_LBUTTON) then
    begin
      clickGestureStandby := true;
      Handled := true;
    end;
  WM_MBUTTONDOWN:
  	if Msg.wParam = (MK_RBUTTON + MK_MBUTTON) then
    begin
      clickGestureStandby := true;
      Handled := true;
    end;
  WM_XBUTTONDOWN:
    if (HiWord(Msg.wParam) = MK_XBUTTON1) or
       (HiWord(Msg.wParam) = MK_XBUTTON2) then
    begin
      clickGestureStandby := true;
      Handled := (GetKeyState(VK_RBUTTON) < 0);
    end;
  WM_MOUSEWHEEL:
    if LoWord(Msg.wParam) = MK_RBUTTON then
    begin
      if (Msg.wParam > 0) then
        GestureExecute(StartPlace + 'WheelUp')   //beginner
      else
        GestureExecute(StartPlace + 'WheelDown'); //beginner
      Handled := true;
    end;
  WM_RBUTTONDOWN:
    begin
      moveGestureTemp := StartPlace; //beginner
      prevPoint := Msg.pt;
      Handled := false;
    end;
  WM_RBUTTONUP:
    begin
     	if (moveGestureTemp <> '') and (AnsiPos(moveGestureTemp, GESTURE_PLACE_CHAR) = 0) and (Msg.wParam = 0) then  //beginner
        GestureExecute(moveGestureTemp);
      if clickGestureStandby then
       	clickGestureStandby := false;
    end;
  end;
end;

//移動の処理
procedure TMainWnd.MoveGesture(pt: TPoint);
var
  temp: Extended;
  distance: TPoint;
  arrow: string;
begin
  distance.X := Abs(pt.X - prevPoint.X);
  distance.Y := Abs(pt.Y - prevPoint.Y);
  if (distance.X > Config.mseGestureMargin) or
     (distance.Y > Config.mseGestureMargin) then
  begin
    ReleasePopupHint(nil, True);
    temp := distance.Y / (distance.X + 0.001);
    if temp >= 1 then
    begin
      if pt.Y > prevPoint.Y then
        arrow := '↓'
      else
        arrow := '↑';
    end else
    begin
      if pt.X > prevPoint.X then
        arrow := '→'
      else
        arrow := '←';
    end;
    if not AnsiEndsStr(arrow, moveGestureTemp) then
      moveGestureTemp := moveGestureTemp + arrow;
    WriteStatus(moveGestureTemp);
    prevPoint := pt;
  end;
end;

//ジェスチャー実行
procedure TMainWnd.GestureExecute(Name: string);
var
  index: integer;
  menu: TMenuItem;//Object;
begin
   PopupViewMenu.PopupComponent := nil;
   PopupTextMenu.PopupComponent := nil;

  ReleasePopupHint(nil, True);
  index := Config.mseGestureList.IndexOfName(Name);
  {beginner}
  if (index < 0) and (AnsiPos(copy(Name, 1, 2), GESTURE_PLACE_CHAR) > 0) then begin
    Name:=copy(Name,3,High(Word));
    index := Config.mseGestureList.IndexOfName(Name);
  end;
  {/beginner}
  WriteStatus(Name);
  if (index >= 0) and (index < Config.mseGestureList.Count) then
  begin
    menu := Config.mseGestureList.Objects[index] as TMenuItem;
    if assigned(menu) and menu.Enabled and assigned(menu.OnClick) then
      menu.Click; //beginner
  end;
  restrainContext := true;
  moveGestureTemp := ''; //beginner
end;
//------------------------------------------------------------------------------

procedure TMainWnd.MenuCommandClick(Sender: TObject);
begin
  PopupTextMenu.PopupComponent := nil;
  PopupViewMenu.PopupComponent := nil;
end;

//▼外部コマンド関係
//------------------------------------------------------------------------------
//指定されたコマンドの実行
procedure TMainWnd.CommandExecute(command: string; replace: boolean = true;
  name: string = ''); //aiai nameパラメータ追加
  {beginner} //置換のための入力ダイアログ
  function CommandDialog:String;
  var
    rc: Integer;
  begin
    if InputDlg = nil then
       InputDlg := TInputDlg.Create(self);
    InputDlg.Caption := '外部コマンド';
    InputDlg.Edit.Text :='';

    rc := InputDlg.ShowModal;
    if (rc <> 3) then
      Result:=''
    else
      Result := Trim(InputDlg.Edit.Text);
  end;
  {/beginner}

  //テキストの置換
  function TextReplace(inText: string): string;
  var
    viewItem: TBaseViewItem;
    outText, select, url, repText: string;
    link: string;
  begin
    outText := inText;
    if Assigned(PopupTextMenu.PopupComponent) then
      viewItem := GetViewOf(PopupTextMenu.PopupComponent)
    else if Assigned(PopupViewMenu.PopupComponent) then
      viewItem := GetViewOf(PopupViewMenu.PopupComponent)
    else
      viewItem := GetActiveView;

    if AnsiContainsStr(inText, '$TITLE') then
    begin
      if assigned(viewItem) and assigned(viewItem.thread) then
        repText := viewItem.thread.title
      else
        repText := '';
      outText := AnsiReplaceStr(outText, '$TITLE', repText);
    end;

    if AnsiContainsStr(inText, '$BOARDNAME') then
    begin
      if assigned(viewItem) and assigned(viewItem.thread) and assigned(viewitem.thread.board) then
        repText := TBoard(viewitem.thread.board).name
      else
        repText := '';
      outText := AnsiReplaceStr(outText, '$BOARDNAME', repText);
    end;

    if AnsiContainsStr(inText, '$BURL') then
    begin
      if assigned(viewItem) and assigned(viewItem.thread) and assigned(viewitem.thread.board) then
        repText := TBoard(viewitem.thread.board).URIBase + '/'
      else
        repText := '';
      outText := AnsiReplaceStr(outText, '$BURL', repText);
    end;

    if AnsiContainsStr(inText, '$URL') then
    begin
      if assigned(viewItem) and assigned(viewItem.thread) then
        url := viewItem.thread.ToURL(false)
      else
        url := '';
      outText := AnsiReplaceStr(outText, '$URL', url);
    end;

    if AnsiContainsStr(inText, '$LINK') then
    begin
      {aiai}
      if AnsiStartsStr('StatusCommand', name) and Assigned(MyNews) then
        link := MyNews.TempBuffer
      else
      {/aiai}
      if assigned(viewItem) then
      begin
        link := viewItem.LinkText;  //aiai
        if (link <> '') and not AnsiStartsStr('http://', link) and
           assigned(viewItem.thread) and assigned(viewItem.thread.board) then
        begin
          if AnsiStartsStr('#', link) then
            link := viewItem.thread.ToURL(false, false, copy(link, 2, length(link)))
          else if AnsiStartsStr('menu:', link) then
            link := viewItem.thread.ToURL(false, false, copy(link, 6, length(link)))
          {aiai}
          else if AnsiStartsStr('BE:', link) then
            link := 'http://be.2ch.net/test/p.php?i=' + Copy(link, 4, Length(link) - 3) + '&u=d:' + viewItem.thread.ToURL(true, true)
          {/aiai}
        end;
      end else
        link := '';
      outText := AnsiReplaceStr(outText, '$LINK', link);
    end;

    if AnsiContainsStr(inText, '$TEXT') then
    begin
      if assigned(viewItem) then
        select := viewItem.GetSelection
      else
        select := '';

      {beginner}

      //$TEXTI系は選択がないときはダイアログ表示
      if AnsiContainsStr(inText,'$TEXTI') and (select='') then
        select:=CommandDialog;

      if AnsiContainsStr(inText, '$TEXTE') or AnsiContainsStr(inText, '$TEXTIE') then
      begin
        select := URLEncode(select);
        outText := AnsiReplaceStr(outText, '$TEXTE', select);
        outText := AnsiReplaceStr(outText, '$TEXTIE', select);
      end
      {aiai}
      else if AnsiContainsStr(inText, '$TEXTX') or AnsiContainsStr(inText, '$TEXTIX') then
      begin
        select := URLEncode(sjis2euc(select));
        outText := AnsiReplaceStr(outText, '$TEXTX', select);
        outText := AnsiReplaceStr(outText, '$TEXTIX', select);
      end
      else if AnsiContainsStr(inText, '$TEXTU') or AnsiContainsStr(inText, '$TEXTIU') then
      begin
        select := URLEncode(AnsiToUTF8(select));
        outText := AnsiReplaceStr(outText, '$TEXTU', select);
        outText := AnsiReplaceStr(outText, '$TEXTIU', select);
      end
      {/aiai}
      else if AnsiContainsStr(inText, '$TEXTI') then
        outText := AnsiReplaceStr(outText, '$TEXTI', select)
      {/beginner}
      else
        outText := AnsiReplaceStr(outText, '$TEXT', select);
    end;

    {beginner} //ダイアログ表示
    if AnsiContainsStr(inText, '$INPUT') then
    begin
      repText := CommandDialog;
      if repText='' then
        outText:=''
      else begin
        outText := AnsiReplaceStr(outText, '$INPUTE', URLEncode(repText));
        outText := AnsiReplaceStr(outText, '$INPUT', repText);
      end;
    end;
    {/beginner}

    {beginner} //DATファイル
    if AnsiContainsStr(inText, '$LOCALDAT') then
    begin
      if assigned(viewItem) then
        repText := viewItem.thread.GetFileName + '.dat'
      else
        repText := '';
      outText := AnsiReplaceStr(outText, '$LOCALDAT', repText);
    end;
    {/beginner}

    {beginner} //IDXファイル
    if AnsiContainsStr(inText, '$LOCALIDX') then
    begin
      if assigned(viewItem) then
        repText := viewItem.thread.GetFileName + '.idx'
      else
        repText := '';
      outText := AnsiReplaceStr(outText, '$LOCALIDX', repText);
    end;
    {/beginner}

    {aiai}
    //レス番置換
    if AnsiContainsStr(inText, '$NUMBER') then
    begin
      if AnsiStartsStr('ResNum', name) then
        repText := IntToStr(PopupViewReply.Tag)
      else
        repText := '';
      outText := AnsiReplaceStr(outText, '$NUMBER', repText);
    end;

    //アプリケーションフォルダ
    if AnsiContainsStr(inText, '$BASEPATH') then
      outText := AnsiReplaceStr(outText, '$BASEPATH', Config.BasePath);

    //ログベースのフォルダ
    if AnsiContainsStr(inText, '$LOGPATH') then
      outText := AnsiReplaceStr(outText, '$LOGPATH', Config.LogBasePath);
    {/aiai}

    result := outText;
  end;
var
  Si:TStartupInfo;
  Pi:TProcessInformation;
begin
  if command = '' then
    exit;

  if replace then
    command :=TextReplace(command);

  {beginner}
  if command = '' then
    exit;
  {/beginner}

  if AnsiStartsStr('http://', command) then
  begin
    OpenByBrowser(command);
    exit;
  end;

  {beginner}
  if AnsiStartsStr('$VIEW', command) then
  begin
    command:=Trim(copy(command,6,High(Integer)));
    if AnsiStartsStr('http://', command) then
      if not NavigateIntoView(command, gtOther) then
        ImageForm.GetImage(command,nil,nil,True);
    exit;
  end
  {/beginner}
  {aiai}
  else if AnsiStartsStr('$LOVELY', command) then
  begin
    command := Trim(Copy(command, 8, High(Integer)));
    if AnsiStartsStr('http://', command) then
      if not NavigateIntoView(command, gtOther) then
        OpenByLovelyBrowser(command);
    exit;
  end;
  {/aiai}

  GetStartupInfo(Si);
  CreateProcess(nil, PAnsiChar(command), nil, nil, false, 0, nil, nil, Si, Pi);
  CloseHandle(Pi.hProcess);
  CloseHandle(Pi.hThread);
end;

procedure TMainWnd.MenuCommandExeClick(Sender: TObject);
var
  command: String;
begin
  if Sender is TMenuItem then
  begin
    command := Config.cmdExecuteList[TMenuItem(Sender).Tag];
    CommandExecute(command, true, TComponent(Sender).Name); //aiai nameパラメータ追加
  end;
end;

//コマンドの作成
procedure TMainWnd.CommandCreate;
const
  cmdMAIN    = $01;
  cmdThre    = $02;
  cmdResNum  = $04;
  cmdStatus  = $08;

var
  i: integer;
  item: TMenuItem;
  name: string;
  child: boolean;
  MenuFlag: Byte;  //aiai
begin
  if Config.cmdConfigList.Text = '' then
  begin
    MenuCommand.Enabled := false;
    MenuCommand.Visible := false;
    exit;
  end;

  for i := 0 to Config.cmdConfigList.Count -1 do
  begin
    name := Config.cmdConfigList.Names[i];
    child := (length(name) > 0) and (name[1] = #9);
    if child then
      Delete(name, 1, 1);

    {beginner} //先頭が*の時は、スレビューのポップアップに表示しない
    //DisableAtPopUp := (length(name) > 0) and (name[1] = '*');
    //if DisableAtPopUp then
    //  Delete(name, 1, 1);
    {/beginner}

    MenuFlag := cmdMain or cmdThre;  //デフォルトではMainMenuとスレビュー右クリックメニュー

    if length(name) > 0 then //プレフィックスの処理
    begin
      case name[1] of

      '*': // MainMenuだけ
        begin MenuFlag := cmdMain; Delete(name, 1, 1); end;

      '/': // スレビュー右クリックメニューだけ
        begin MenuFlag := cmdThre; Delete(name, 1, 1); end;

      '+': // レス番クリックメニューだけ
        begin MenuFlag := cmdResNum; Delete(name, 1, 1); end;

      '!': // ステータスバー右クリックメニュー
        begin MenuFlag := cmdStatus; Delete(name, 1, 1); end;

      end; //case
    end;

    // $LINKがある場合はMainMenuには出さない、ない場合はStatusbarに出さない
    if AnsiContainsStr(Config.cmdExecuteList[i], '$LINK') then
       MenuFlag := MenuFlag and not cmdMain
    else
      MenuFlag := MenuFlag and not cmdStatus;

    (* MainMenu *)
    if MenuFlag and cmdMain = cmdMain then begin
      item := TMenuItem.Create(MenuCommand);
      item.Name := 'MenuCommand' + IntToStr(i+1);
      item.Caption := name;
      item.Tag := i;
      if length(Config.cmdExecuteList[i]) > 0 then
        item.OnClick := MenuCommandExeClick;
      if child and (MenuCommand.Count > 0) then
        MenuCommand[menucommand.Count -1].Add(item)
      else
        MenuCommand.Add(item);
    end;

    (* スレビュー右クリックメニュー *)
    if MenuFlag and cmdThre = cmdThre then begin
      item := TMenuItem.Create(PopupTextMenu);
      item.Name := 'ThreViewCommand' + IntToStr(i+1);
      item.Caption := name;
      item.Tag := i;
      if length(Config.cmdExecuteList[i]) > 0 then
        item.OnClick := MenuCommandExeClick;
      with PopupTextMenu do
      begin
        if child and (Items.Count > Items.IndexOf(TextPopupCmdSep) +1) then
          Items[PopupTextMenu.items.Count -1].Add(item)
        else
          Items.Add(item);
      end;
    end;

    (* レス番クリックメニュー *)
    if MenuFlag and cmdResNum = cmdResNum then begin
      item := TMenuItem.Create(PopupViewMenu);
      item.Name := 'ResNumCommand' + IntToStr(i+1);
      item.Caption := name;
      item.Tag := i;
      if length(Config.cmdExecuteList[i]) > 0 then
        item.OnClick := MenuCommandExeClick;
      with PopupViewMenu do
      begin
        if child and (Items.Count > Items.IndexOf(ViewPopupCmdSep) + 1) then
          Items[PopupViewMenu.items.Count - 1].Add(item)
        else
          Items.Add(item);
      end;
    end;

    (* ステータスバー右クリックメニュー *)
    if MenuFlag and cmdStatus = cmdStatus then begin
      item := TMenuItem.Create(PopupStatusBar);
      item.Name := 'StatusCommand' + IntToStr(i+1);
      item.Caption := name;
      item.Tag := i;
      if length(Config.cmdExecuteList[i]) > 0 then
        item.OnClick := MenuCommandExeClick;
      with PopupStatusBar do
      begin
        if child and (Items.Count > Items.IndexOf(MenuStatusCmdSep) + 1) then
          Items[PopupStatusBar.items.Count - 1].Add(item)
        else
          Items.Add(item);
      end;
    end;

  end;
end;

//------------------------------------------------------------------------------



//▼ソートメニュー
procedure TMainWnd.SortMenuClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    ListViewColumnSort(TMenuItem(Sender).Tag);
end;


//▼IME・文字入力制御関係
//------------------------------------------------------------------------------
//メインウィンドウアクティブ時にIMEオフ
procedure TMainWnd.FormActivate(Sender: TObject);
begin
  SetImeMode(MainWnd.Handle, imClose);
end;

//ショートカット抑止
function TMainWnd.IsShortCut(var Message: TWMKey): Boolean;
begin
  if FavoriteView.IsEditing or UrlEdit.Focused
    or ComboBoxWriteName.Focused or ComboBoxWriteMail.Focused
      or MemoWriteMain.Focused
      or ListViewSearchEditBox.Focused or ThreViewSearchEditBox.Focused
        or TreeViewSearchEditBox.Focused then
  begin
    result :=false;
    exit;
  end;
  result := inherited IsShortCut(Message) or MainMenu.IsShortCut(Message);
end;

//IME状態を保存してオフに
procedure SaveImeMode(wnd: HWND);
var
  imc: HIMC;
begin
  imc := ImmGetContext(wnd);
  if ImmGetOpenStatus(imc) then
    userImeMode := imOpen
  else
    userImeMode := imClose;
  ImmReleaseContext(wnd, imc);
  SetImeMode(wnd, imClose);
end;
//------------------------------------------------------------------------------



//▼ジャンプとポップアップ
//------------------------------------------------------------------------------
//指定レス番号にジャンプ
procedure TMainWnd.MenuThreJumpResClick(Sender: TObject);
var
  rc, num: integer;
  viewItem: TViewItem;
begin
  WriteStatus('');
  viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;

  if InputDlg = nil then
    InputDlg := TInputDlg.Create(self);
  InputDlg.Caption := '指定レス番号にジャンプ';

  InputDlg.Edit.Text := viewItem.GetSelection;

  rc := InputDlg.ShowModal;
  if rc <> 3 then
    exit;
  num := StrToIntDef(StrUnify(Trim(InputDlg.Edit.Text)), -1);
  if num >= 1 then
    viewItem.ScrollToAnchor(num -1, true, true);
end;

//選択番号のレスをポップアップ
procedure TMainWnd.MenuThrePopupResClick(Sender: TObject);
begin
  PopupRes(Sender, False);
end;

function TMainWnd.PopupRes(Sender: TObject; Extract: Boolean): boolean;
var
  ref: String;
  viewItem: TBaseViewItem;
  newView: TPopupViewItem;
begin
  result := false;
  if (Sender is THogeTextView) then
    viewItem := GetViewOf(TComponent(Sender))
  else
    viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;

  ReleasePopupHint(viewItem, True);

  ref := viewItem.GetSelection;
  if ref <> '' then
  begin
    if Extract then
    begin
      newView := NewPopUpView(viewItem);
      try
        newView.Lock;
        Result := (NewView.ExtractKeyword('extract:' + ref, viewItem.thread , ref, 20, Mouse.CursorPos) > 0);
        if Assigned(viewItem.PossessionView) then
          viewItem.PossessionView.Enabled := True;
      finally
        newView.UnLock;
      end;
    end else
    begin
      ref := StrUnify(LeftStr(ref, 1024));   //長いと重い
      Result := Show2chInfo(Mouse.CursorPos, '#' + ref, ref, viewItem,
        Config.hintNestingPopUp and (GetKeyState(VK_SHIFT) >= 0));
      if Assigned(viewItem.PossessionView) then
        viewItem.PossessionView.Enabled := True;
    end;
    FStatusText := '';
  end;
end;


//メニューから抽出ポップアップ
procedure TMainWnd.ExtractPopupClick(Sender: TObject);
begin
  proccessingPopupFromContext := True;
  PopupRes(PopupTextMenu.PopupComponent, True);
  proccessingPopupFromContext := False;
end;

// 521 ジャンプ関係メニューのポップアップ時の処理
procedure TMainWnd.ViewPopupReadPosClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  actSetReadPos.Enabled := false;
  actJumpToReadPos.Enabled := false;
  actReadPosClear.Enabled := false;
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  actSetReadPos.Enabled := true;
  if viewItem.thread.readPos <> 0 then
  begin
    actJumpToReadPos.Enabled := true;
    actReadPosClear.Enabled := true;
  end;
end;

procedure TMainWnd.ReleasePopupHint(viewItem: TBaseViewItem; Force: Boolean);
begin
  PopupHint.ReleaseHandle;
  if Assigned(viewItem) then
  begin
    if Assigned(viewItem.PossessionView) and (Force or (not viewItem.PossessionView.Enabled)) then
      viewItem.ReleasePossessionView;
  end else
    popupviewList.Clear(Force);
end;


procedure TMainWnd.PopupViewListChange(Sender: TObject);
begin
  PopupHint.ReleaseHandle;
end;


procedure TMainWnd.MenuThreCheckResClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupCheckResClick(Sender);
end;

procedure TMainWnd.ViewPopupCheckResClick(Sender: TObject);
var
  viewItem: TViewItem;
  line: integer;

  // 521 レスのチェックのサブメニューにレス番等のアイテムを追加
  procedure CheckResItemAdd;
  var
    line: integer;
    item, child1, child2: TMenuItem;
  begin
    while TmenuItem(Sender).Count > 1 do
      TmenuItem(Sender).Items[1].Destroy;
    for line := 1 to viewItem.thread.lines do
      if (viewItem.thread.AboneArray[line] = 4) then
      begin
        item := TMenuItem.Create(self);
        item.Caption := IntToStr(line) + ' のチェック';
        item.Tag := line;
        item.OnClick := actCheckResPopupExecute;
        TmenuItem(Sender).Add(item);

        child1 := TMenuItem.Create(item);
        child1.Caption := 'ジャンプ';
        child1.Tag := line;
        child1.OnClick := actCheckResSubMenuExecute;
        item.Add(child1);

        child2 := TMenuItem.Create(item);
        child2.Caption := '解除';
        child2.Tag := line;
        child2.OnClick := actCheckResSubMenuExecute;
        item.Add(child2);
      end;
  end;

begin
  actCheckResAllClear.Enabled := false;
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  for line := 1 to viewItem.thread.lines do
    if (viewItem.thread.AboneArray[line] = 4) then
      actCheckResAllClear.Enabled := true;
  ReleasePopupHint;
  CheckResItemAdd;
end;

// 521 レスのチェックでレスの内容をポップアップさせる
procedure TMainWnd.actCheckResPopupExecute(Sender: TObject);
var
  viewItem: TViewItem;
  s: String;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  s := PickUpRes(viewItem.thread, TMenuItem(Sender).Tag, TMenuItem(Sender).Tag);
  if 0 < length(s) then
    ShowHint(Mouse.CursorPos, s);
end;

// 521 レスのチェック、ジャンプと解除
procedure TMainWnd.actCheckResSubMenuExecute(Sender: TObject);
var
  viewItem: TViewItem;
  line: integer;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  line := TmenuItem(Sender).Tag;
  if StartWith('ジャンプ', TMenuItem(Sender).Caption, 1) then
  begin
    viewItem.ScrollToAnchor(line - 1, true, true);
    if viewItem <> currentView then
    begin
      SetCurrentView(tabRightClickedIndex);
      UpdateCurrentView(tabRightClickedIndex);
    end;
  end
  else if StartWith('解除', TMenuItem(Sender).Caption, 1) then
    viewItem.thread.AboneArray[line] := 0;
end;

// 521 レスのチェックを全て解除
procedure TMainWnd.MenuThreCheckResAllClearClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  Self.actCheckResAllClearExecute(Sender);
end;

procedure TMainWnd.actCheckResAllClearExecute(Sender: TObject);
var
  viewItem: TViewItem;
  line: integer;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  for line := 1 to viewItem.thread.lines do
    if (viewItem.thread.AboneArray[line] = 4) then
      viewItem.thread.AboneArray[line] := 0;
end;

// 521 ここまで読んだ
procedure TMainWnd.PopupViewSetReadPosClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actSetReadPosExecute(Sender);
end;

procedure TMainWnd.actSetReadPosExecute(Sender: TObject);
var
  viewItem: TViewItem;
  line: integer;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  if Sender = PopupViewSetReadPos then
    line := TmenuItem(Sender).Tag
  else begin
    line := viewItem.GetTopRes + 1;
  end;
  if line = viewItem.thread.readPos then
    viewItem.thread.readPos := 0
  else
    viewItem.thread.readPos := line;
  dec(line);
  if 1 < Length(TSkinCollection(SkinCollectionList.Items[TBoard(viewItem.thread.board).CustomSkinIndex]).BookMarkHTML) then
    viewItem.LocalReload(line);
end;


// 521 ここまで読んだ、ジャンプと解除
procedure TMainWnd.MenuThreJumpToReadPosClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actJumpToReadPosExecute(Sender);
end;

procedure TMainWnd.actJumpToReadPosExecute(Sender: TObject);
var
  viewItem: TViewItem;
  line: integer;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  line := viewItem.thread.readPos;
  if (0 < viewItem.thread.readPos) then
    viewItem.ScrollToAnchor(line - 1, true, true);
  if viewItem <> currentView then
  begin
    UpdateCurrentView(tabRightClickedIndex);
    SetCurrentView(tabRightClickedIndex);
  end;
end;

procedure TMainWnd.MenuThreReadPosClearClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actReadPosClearExecute(Sender);
end;

procedure TMainWnd.actReadPosClearExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  if (0 < viewItem.thread.readPos) then
  begin
    viewItem.thread.readPos := 0;
    if 1 < Length(TSkinCollection(SkinCollectionList.Items[TBoard(viewItem.thread.board).CustomSkinIndex]).BookMarkHTML) then
      viewItem.LocalReload(viewItem.GetTopRes);
  end;
end;

//------------------------------------------------------------------------------


//▼タブ複数段関係
//------------------------------------------------------------------------------
//スレのタブ行の調整
procedure TMainWnd.ThreadTabLineAdjust;
var
  h: integer;
begin
  if TabControl.Visible and TabControl.MultiLine then
  begin
    if TabControl.RowCount <= 1 then
      h := TabControl.TabHeight +4
    else
      h := TabControl.RowCount * (TabControl.TabHeight +3);
    if h <> TabControl.Height then
      TabBarPanel.Height := h;
  end;
end;

//スレ覧のタブ行の調整
procedure TMainWnd.ListTabLineAdjust;
var
  h: integer;
begin
  if ListTabPanel.Visible and ListTabControl.MultiLine then
  begin
    if ListTabControl.RowCount <= 1 then
      h := ListTabControl.TabHeight +4
    else
      h := ListTabControl.RowCount * (ListTabControl.TabHeight +3);
    if h <> ListTabPanel.Height then
      ListTabPanel.Height := h;
  end;
end;


//リサイズ時のタブ行の調整
procedure TMainWnd.WebPanelResize(Sender: TObject);
begin
  ThreadTabLineAdjust;
end;

procedure TMainWnd.ListViewPanelResize(Sender: TObject);
begin
  ListTabLineAdjust;
end;
//------------------------------------------------------------------------------



//▼「閉じる」関係
//------------------------------------------------------------------------------

//「これより左を閉じる」メニュー(cf.MenuThreCloseOtherTabs)
procedure TMainWnd.MenuThreCloseLeftTabsClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actCloseLeftTabsExecute(Sender);
end;

//「これより右を閉じる」メニュー(cf.MenuThreCloseOtherTabs)
procedure TMainWnd.MenuThreCloseRightTabsClick(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  self.actCloseRightTabsExecute(Sender);
end;

procedure TMainWnd.actCloseAllTabsExecute(Sender: TObject);
{aiai}
var
  index: integer;
  remain: Boolean;
{/aiai}
begin
 {while TabControl.Tabs.Count > 0 do
   DeleteView(0)}
  {aiai}  //「このタブは閉じない」は閉じない
  index := 0;
  remain := False;
  while TabControl.Tabs.Count > index do
    if (viewList.Items[index].thread = nil)
        or viewList.Items[index].thread.canclose then
      DeleteView(index)
    else
    begin
      Inc(index);
      if not remain then remain := True;
    end;
  if remain then //閉じないスレがある場合
  begin
    index := viewList.FindFirstViewItem;
    if index >= 0 then
      SetCurrentView(index);
  end;
  {/aiai}
  UpdateTabTexts;
  ListView.DoubleBuffered := True;
  ListView.Update;
  ListView.DoubleBuffered := False;
end;

//これより左を閉じる(cf.actCloseOtherTabsExecute)
procedure TMainWnd.actCloseLeftTabsExecute(Sender: TObject);
var
  i: integer;
  index: integer; //aiai
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;
  if tabRightClickedIndex > TabControl.TabIndex then
  begin
    TabControl.TabIndex := tabRightClickedIndex;
    UpdateCurrentView(tabRightClickedIndex);
  end;
  {aiai}//「このタブは閉じない」は閉じない
 {for i := 0 to tabRightClickedIndex -1 do
  begin
    DeleteView(0);
  end;}
  index := 0;
  for i := 0 to tabRightClickedIndex - 1 do
    if (viewList.Items[index].thread = nil)
        or viewList.Items[index].thread.canclose then
      DeleteView(index)
    else Inc(index);
  {/aiai}
  UpdateTabTexts;
  ListView.DoubleBuffered := True;
  ListView.Update;
  ListView.DoubleBuffered := False;
end;

//これより右を閉じる(cf.actCloseOtherTabsExecute)
procedure TMainWnd.actCloseRightTabsExecute(Sender: TObject);
var
  index: integer; //aiai
begin
  (*  *)
  if tabRightClickedIndex < 0 then
    exit;

  if tabRightClickedIndex < TabControl.TabIndex then
  begin
    TabControl.TabIndex := tabRightClickedIndex;
    UpdateCurrentView(tabRightClickedIndex);
  end;
 {aiai}//「このタブは閉じない」は閉じない
 {while tabRightClickedIndex < TabControl.Tabs.Count -1 do
  begin
    DeleteView(tabRightClickedIndex+1);
  end;}
  index := tabRightClickedIndex + 1;
  while index < TabControl.Tabs.Count do
    if (viewList.Items[index].thread = nil)
        or viewList.Items[index].thread.canclose then
      DeleteView(index)
    else Inc(index);
  {/aiai}
  UpdateTabTexts;
  ListView.DoubleBuffered := True;
  ListView.Update;
  ListView.DoubleBuffered := False;
end;
//------------------------------------------------------------------------------


//▼起動時にスレを開く
//------------------------------------------------------------------------------
//last.dat、スタートアップフォルダで指定のスレを開く
procedure TMainWnd.OpenStartupThread;
var
  i: integer;
  urlList: TStringList;
  urlListSub: TStringList;
  favlist: TFavoriteList;
  tmpTap: TTabAddPos;
  wndstate: TMTVState;
begin
  //開き順が変わるので無理矢理修正
  tmpTap := Config.oprAddPosNormal;
  Config.oprAddPosNormal := tapEnd;

  favlist := nil;
  for i := 0 to favorites.Count -1 do
  begin
    if (TObject(favorites.Items[i]) is TFavoriteList) and
       (favorites.Items[i].name = 'スタートアップ') then
    begin
      favlist := favorites.Items[i] as TFavoriteList;
      break;
    end;
  end;
  if favlist <> nil then
    for i := 0 to favlist.Count -1 do
    begin
      if (TObject(favlist.Items[i]) is TFavorite) then
        with TFavorite(favlist.Items[i]) do
          LocalNavigate(host, bbs, datName);
    end;

  if Config.optSaveLastItems then begin
    if FileExists(Config.BasePath + SESSION_DAT) then
    begin
      urlList := TStringList.Create;
      urlListSub := TStringList.Create;
      try
        urlList.LoadFromFile(Config.BasePath + SESSION_DAT);
        for i := 0 to urlList.Count - 1 do
        begin
          urlListSub.Delimiter := #9;
          urlListSub.DelimitedText := urlList.Strings[i];
          if urlListSub.Count = 7 then
          begin
            if urlListSub[5] = '0' then
              wndstate := MTV_NOR
            else
              wndstate := MTV_MAX;
            LocalNavigate(urlListSub[0],
              False,
              StrToIntDef(urlListSub[1], 0),
              StrToIntDef(urlListSub[2], 0),
              StrToIntDef(urlListSub[3], 0),
              StrToIntDef(urlListSub[4], 0),
              wndstate,
              (urlListSub[6] = '1'));
          end else
            LocalNavigate(urlListSub[0]);
          urlListSub.Clear;
        end;
      finally
        urlList.Free;
        urlListSub.Free;
      end;
    end
    else if FileExists(Config.BasePath + 'last.dat') then
    begin
      urlList := TStringList.Create;
      try
        urlList.LoadFromFile(Config.BasePath + 'last.dat');
        for i := 0 to urlList.Count -1 do
          LocalNavigate(urlList[i]);
      finally
        urlList.Free;
      end;
    end;
  end;

  if currentBoard <> nil then
    ListView.TabStop := true;
  Config.oprAddPosNormal := tmpTap;
end;

//最後に開いていたスレを保存
procedure TMainWnd.SaveLastThread;
var
  i: integer;
  urlList: TStringList;
  thread: TThreadItem;
  browser: TMDITextView;
  canclose: string;
begin
  //if not FileExists(Config.BasePath + 'last.dat') then
  if not Config.optSaveLastItems then
    exit;
  urlList := TStringList.Create;
  try
    if ListTabPanel.Visible then
    begin
      for i := 0 to ListTabControl.Tabs.Count -1 do
        with ListTabControl.Tabs.Objects[i] as TBoard do
          urlList.Add(URIBase + '/');
    end
    else if currentBoard <> nil then
      urlList.Add(currentBoard.URIBase + '/');
    for i := 0 to viewList.Count -1 do begin
      thread := viewList.Items[i].thread;
      if thread <> nil then begin
        if thread.canclose then canclose := '1' else canclose := '0';
        browser := TMDITextView(viewList.Items[i].browser);
        if browser.WndState = MTV_MAX then begin
          urlList.Add(viewList.Items[i].thread.ToURL(false)
            + #9
            + IntToStr(browser.NorRect.Left) + #9
            + IntToStr(browser.NorRect.Top) + #9
            + IntToStr(browser.NorRect.Right) + #9
            + IntToStr(browser.NorRect.Bottom) + #9
            + '1' + #9
            + canclose);
        end else
          urlList.Add(viewList.Items[i].thread.ToURL(false)
            + '='
            + IntToStr(browser.BoundsRect.Left) + #9
            + IntToStr(browser.BoundsRect.Top) + #9
            + IntToStr(browser.BoundsRect.Right) + #9
            + IntToStr(browser.BoundsRect.Bottom) + #9
            + '0' + #9
            + canclose);
      end;
    end;
    SysUtils.DeleteFile(Config.BasePath + SESSION_DAT + '.back');
    SysUtils.RenameFile(Config.BasePath + SESSION_DAT, Config.BasePath + SESSION_DAT + '.back');
    urlList.SaveToFile(Config.BasePath + SESSION_DAT);
  finally
    urlList.Free;
  end;
end;
//------------------------------------------------------------------------------



//▼スレ覧のタブ
//------------------------------------------------------------------------------
//選択したタブの板を開く
procedure TMainWnd.ListTabControlChange(Sender: TObject);
var
  board: TBoard;
begin
  if ListTabControl.TabIndex < 0 then
    exit;
  board := boardList.Items[ListTabControl.TabIndex];
  OpenBoard(board, false);
end;

//マウス操作
procedure TMainWnd.ListTabControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  index: integer;
begin
  case Button of
  mbLeft:
    begin
      index := ListTabControl.IndexOfTabAt(X, Y);
      tabDragSourceIndex := index;
      ListTabControl.BeginDrag(false, 5);
      if ListTabControl.TabIndex <> index then
      begin
        if ListTabControl.Style <> tsTabs then //※[457] tsTabsだとOnChangeでタブの絶対座標が変わる事があるので
        begin
          ListTabControl.TabIndex := index;
          ListTabControlChange(Sender);
        end
        else
          tabDragSourceIndex := ListTabControl.TabIndex;
      end;
    end;
  mbMiddle:
    begin
      tabRightClickedIndex := ListTabControl.IndexOfTabAt(X, Y);
      actListCloseThisTabExecute(Sender);
    end;
  mbRight:
    begin
      tabRightClickedIndex := ListTabControl.IndexOfTabAt(X, Y);
    end;
  end;
  try
    ListView.SetFocus;
  except
  end;
end;

//以下、閉じる系
procedure TMainWnd.actListCloseThisTabExecute(Sender: TObject);
begin
  if ListTabControl.Tabs.Count <= 0 then
    exit;

  CloseBoard(tabRightClickedIndex);
end;

procedure TMainWnd.actListCloseOtherTabsExecute(Sender: TObject);
begin
  if tabRightClickedIndex < 0 then
    exit;

  while tabRightClickedIndex +1 < ListTabControl.Tabs.Count do
    CloseBoard(ListTabControl.Tabs.Count -1, false);
  while 1 < ListTabControl.Tabs.Count do
    CloseBoard(0, false);
  UpdateListTab;  //板が変わらないのでタブだけ更新
end;


procedure TMainWnd.actListCloseAllTabsExecute(Sender: TObject);
begin
  if ListTabControl.Tabs.Count <= 0 then
    exit;

  while 0 < ListTabControl.Tabs.Count do
   	CloseBoard(0, ListTabControl.Tabs.Count <= 1); //最後の1つだけupdate
end;

procedure TMainWnd.actListCloseLeftTabsExecute(Sender: TObject);
var
  board: TBoard;
begin
  if tabRightClickedIndex < 0 then
    exit;

  board := boardList.Items[tabRightClickedIndex];
  while board <> boardList.Items[0] do
    CloseBoard(0, boardList.Items[1] = board); //最後の1つだけupdate
end;

procedure TMainWnd.actListCloseRightTabsExecute(Sender: TObject);
begin
  if tabRightClickedIndex < 0 then
    exit;

  while tabRightClickedIndex +1 < ListTabControl.Tabs.Count do
    CloseBoard(ListTabControl.Tabs.Count -1, (tabRightClickedIndex +2 = ListTabControl.Tabs.Count));
end;

procedure TMainWnd.MenuListCloseLeftTabsClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  actListCloseLeftTabsExecute(Sender);
end;

procedure TMainWnd.MenuListCloseRightTabsClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  actListCloseRightTabsExecute(Sender);
end;

procedure TMainWnd.MenuListCloseOtherTabsClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  actListCloseOtherTabsExecute(Sender);
end;

procedure TMainWnd.MenuListCloseClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  actListCloseThisTabExecute(Sender);
end;

(* 更新のあるスレッドをすべて開く *) //aiai
procedure TMainWnd.MenuListOpenNewResThreadsClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  PopupTreeOpenNewResThreadsClick(Sender);
end;

(* お気に入りで更新のあるスレッドをすべて開く *) //aiai
procedure TMainWnd.MenuListOpenNewResFavoritesClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  PopupTreeOpenNewResFavoritesClick(Sender);
end;

(* お気に入りをすべて開く *) //aiai
procedure TMainWnd.MenuListOpenFavoritesClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  PopupOpenFavoritesClick(Sender);
end;

(* IdxListを再構築 *) //aiai
procedure TMainWnd.MenuListRefreshIdxListClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  actRefreshIdxListExecute(sender);
end;

//過去ログ非表示のメニューハンドラ
procedure TMainWnd.MenuListHideHistoricalLogClick(Sender: TObject);
begin
  tabRightClickedIndex := ListTabControl.TabIndex;
  actHideHistoricalLogExecute(sender);
end;

//スレとスレ覧でアクティブな方を閉じる
procedure TMainWnd.MenuWndCloseClick(Sender: TObject);
begin
  if (not Config.oprToggleRView and ListView.Focused) or
     (Config.oprToggleRView and (mdRPane = ptList)) then
    MenuListCloseClick(Sender)
  else
    MenuThreCloseClick(Sender);
end;

procedure TMainWnd.MenuWndCloseOtherTabsClick(Sender: TObject);
begin
  if (not Config.oprToggleRView and ListView.Focused) or
     (Config.oprToggleRView and (mdRPane = ptList)) then
    MenuListCloseOtherTabsClick(Sender)
  else
    MenuThreCloseOtherTabsClick(Sender);
end;

procedure TMainWnd.MenuWndCloseAllTabsClick(Sender: TObject);
begin
  if (not Config.oprToggleRView and ListView.Focused) or
     (Config.oprToggleRView and (mdRPane = ptList)) then
    actListCloseAllTabsExecute(Sender)
  else
    actCloseAllTabsExecute(Sender);
end;

procedure TMainWnd.MenuWndCloseLeftTabsClick(Sender: TObject);
begin
  if (not Config.oprToggleRView and ListView.Focused) or
     (Config.oprToggleRView and (mdRPane = ptList)) then
    MenuListCloseLeftTabsClick(Sender)
  else
    MenuThreCloseLeftTabsClick(Sender);
end;

procedure TMainWnd.MenuWndCloseRightTabsClick(Sender: TObject);
begin
  if (not Config.oprToggleRView and ListView.Focused) or
     (Config.oprToggleRView and (mdRPane = ptList)) then
    MenuListCloseRightTabsClick(Sender)
  else
    MenuThreCloseRightTabsClick(Sender);
end;

//▼板ツリーでタブの上書き・新規の使い分け
procedure TMainWnd.PopupTreeOpenCurrentClick(Sender: TObject);
var
  node: TTreeNode;
begin
  node := TreeView.Selected;
  if node = nil then
    exit;
  if TObject(node.Data) is TBoard then
    ListViewNavigate(TBoard(node.Data), config.oprGestureBrdOther, false);
end;

procedure TMainWnd.PopupTreeOpenNewClick(Sender: TObject);
var
  node: TTreeNode;
begin
  node := TreeView.Selected;
  if node = nil then
    exit;
  if TObject(node.Data) is TBoard then
    ListViewNavigate(TBoard(node.Data), config.oprGestureBrdOther, true);
end;
//------------------------------------------------------------------------------


//▼ブラウザで開く(cf.URLをコピー)
//------------------------------------------------------------------------------
procedure TMainWnd.PopupTreeOpenByBrowserClick(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  if PopupTreeClose.Visible then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board <> nil then
    OpenByBrowser(board.URIBase + '/');
end;

procedure TMainWnd.ViewPopupOpenByBrowserClick(Sender: TObject);
var
  viewItem: TViewItem;
  url: string;
begin
  if tabRightClickedIndex < 0 then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    url := viewItem.thread.ToURL(false, true);
    OpenByBrowser(url)
  end;
end;

procedure TMainWnd.actListOpenByBrowserExecute(Sender: TObject);
var
  item: TListItem;
  url: string;
begin
  item := ListView.Selected;
  if (item = nil) or (ListView.SelCount > 1) then
    exit;
  url := TThreadItem(item.Data).ToURL(false, true);
  OpenByBrowser(url);
end;

procedure TMainWnd.actOpenByBrowserExecute(Sender: TObject);
begin
  tabRightClickedIndex := TabControl.TabIndex;
  ViewPopupOpenByBrowserClick(Self);
end;
//------------------------------------------------------------------------------


{beginner} //画像ビューアを開く
procedure TMainWnd.OpenImageView(Sender: TObject);
begin
  ImageForm.OpenImageView(Sender);
end;
{/beginner}


{beginner} //画像ビューアの設定を開く
procedure TMainWnd.OpenImageViewPreference(Sender: TObject);
begin
  ImageForm.OpenPreference(Self);
end;
{/beginner}

//▼タブのD&D
//------------------------------------------------------------------------------
procedure TMainWnd.ListTabPanelDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  accept := (Source = ListTabControl);
end;

procedure TMainWnd.ListTabPanelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  index: integer;
  pt: integer;
begin
  pt := X +10;
  index := ListTabControl.IndexOfTabAt(pt, Y);

  if index < 0 then
  repeat
    Dec(pt, 20);
    index := ListTabControl.IndexOfTabAt(pt, Y) +1;
  until (pt < 0) or (index > 0);

  if index > tabDragSourceIndex then
    Dec(index);
  if index >= 0 then
  begin
    ListTabControl.Tabs.Move(tabDragSourceIndex, index);
    boardList.Move(tabDragSourceIndex, index);
  end;
end;

procedure TMainWnd.TabPanelDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  accept := (Source = TabControl)
end;

procedure TMainWnd.TabPanelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  index: integer;
  pt: integer;
begin
  pt := X +10;
  index := TabControl.IndexOfTabAt(pt, Y);

  if index < 0 then
  repeat
    Dec(pt, 20);
    index := TabControl.IndexOfTabAt(pt, Y) +1;
  until (pt < 0) or (index > 0);

 if index > tabDragSourceIndex then
    Dec(index);
  if index >= 0 then
  begin
    TabControl.Tabs.Move(tabDragSourceIndex, index);
    viewList.Move(tabDragSourceIndex, index);
  end;
end;

procedure TMainWnd.ListTabControlDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  accept := (Source = ListTabControl);
end;

procedure TMainWnd.ListTabControlDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  index: integer;
begin
  index := ListTabControl.IndexOfTabAt(X, Y);
  if index >= 0 then
  begin
    ListTabControl.Tabs.Move(tabDragSourceIndex, index);
    boardList.Move(tabDragSourceIndex, index);
  end;
end;

procedure TMainWnd.TabControlDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  accept := (Source = TabControl);
end;

procedure TMainWnd.TabControlDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  index: integer;
begin
  index := TabControl.IndexOfTabAt(X, Y);
  if index >= 0 then
  begin
    TabControl.Tabs.Move(tabDragSourceIndex, index);
    viewList.Move(tabDragSourceIndex, index);
  end;
end;
//------------------------------------------------------------------------------



//▼ログ一覧
//------------------------------------------------------------------------------
//ログ一覧に表示する板を制限するdat数を変更する
procedure TMainWnd.MenuBoardLogListLimitClick(Sender: TObject);
var
  rc: integer;
begin
  if InputDlg = nil then
    InputDlg := TInputDlg.Create(self);

  InputDlg.Caption := 'これ以上スレを取得した板はログ一覧に表示しない';
  InputDlg.Edit.Text := IntToStr(Config.optLogListLimitCount);
  rc := InputDlg.ShowModal;
  if rc <> 3 then
    exit;
  Config.optLogListLimitCount := StrToIntDef(InputDlg.Edit.Text, Config.optLogListLimitCount);
  Config.Modified := true;
  //再構築
  if currentBoard is TLogListBoard then
  begin
    ListView.OnData := nil;
    currentBoard.SafeClear;
    currentBoard.Load;
    ListView.OnData := ListViewData;
    UpdateListView;
  end;
end;
//------------------------------------------------------------------------------

procedure TMainWnd.KeyEmulateClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    keybd_event(TMenuItem(Sender).Tag, 0, 0, 0);
end;

procedure TMainWnd.KeyEmulateCtrlClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then
    exit;
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(TMenuItem(Sender).Tag, 0, 0, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
end;


(* スレ覧タブとboardList,currentBoardの同期 *)
procedure TMainWnd.UpdateListTab;
var
  i: integer;
begin
  for i := 0 to boardList.Count -1 do
  begin
    if boardList.Items[i] <> ListTabControl.Tabs.Objects[i] then
    begin
      ListTabControl.Tabs.Strings[i] := boardList.Items[i].name;
      ListTabControl.Tabs.Objects[i] := boardList.Items[i];
    end;
  end;
  ListTabLineAdjust;
  ListTabControl.TabIndex := boardList.IndexOf(currentBoard);
end;

//▼最後に閉じたスレ
procedure TMainWnd.MenuWndLastClosedClick(Sender: TObject);
begin
  WindowRecentlyClosedClick(Sender);
end;


//ポップアップのレス番からジャンプ
procedure TMainWnd.PopupViewJumpClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
begin
  if PopupViewMenu.PopupComponent is THogeTextView then
  begin
    viewItem := GetViewOf(TComponent(PopupViewMenu.PopupComponent));
    if Assigned(viewItem) and Assigned(viewItem.thread) then
      ShowSpecifiedThread(viewItem.thread, gotGRACEFUL, true,
        false, false, TMenuItem(Sender).Tag - 1);
    ReleasePopupHint(nil, True);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//このレスをコピー
//CopyResToClipBrd()
//PopupViewCopyReferenceClick()
//PopupViewCopyDataClick()
//PopupViewCopyURLClick()
//PopupViewCopyRDClick()
//

procedure TMainWnd.CopyResToClipBrd(title, uri, res: boolean; num: integer);
var
  viewItem: TBaseViewItem;
  list: string;
begin
  if PopupViewMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(TComponent(PopupViewMenu.PopupComponent))
  else
    viewItem := GetActiveView;
  if not assigned(viewItem.thread) then
    exit;

  if title then
    list := HTML2String(viewItem.thread.title) + #13#10;
  if uri then
  begin
    list := list + viewItem.thread.ToURL(true, false, IntToStr(num)) + #13#10;
    if res then
      list := list + #13#10;
  end;
  if res then
    list := list + viewItem.thread.ToString(DEF_REC_HTML, num, 1);
  ClipBoard.AsText := list;
end;

//スレタイとレスのURLをコピー
procedure TMainWnd.PopupViewCopyReferenceClick(Sender: TObject);
begin
  CopyResToClipBrd(true, true, false, TMenuItem(Sender).Tag);
end;

//レスの内容をコピー
procedure TMainWnd.PopupViewCopyDataClick(Sender: TObject);
begin
  CopyResToClipBrd(false, false, true, TMenuItem(Sender).Tag);
end;

//レスのURLをコピー
procedure TMainWnd.PopupViewCopyURLClick(Sender: TObject);
begin
  CopyResToClipBrd(false, true, false, TMenuItem(Sender).Tag);
end;

//スレタイとレスのURLとレスの内容をコピー
procedure TMainWnd.PopupViewCopyRDClick(Sender: TObject);
begin
  CopyResToClipBrd(true, true, true, TMenuItem(Sender).Tag);
end;



procedure TMainWnd.SetMouseGesture;
  function FindCommandMenu(parent: TMenuItem; number: integer): TMenuItem;
  var
    i: integer;
  begin
    result := nil;
    for i := parent.Count -1 downto 0 do
    begin
      if parent.Items[i].Tag = number -1 then
        result := parent.Items[i]
      else if (parent.Count > 0) and (number > parent.Items[i].Tag) then
        result := FindCommandMenu(parent.Items[i], number);
      if result <> nil then
        exit;
    end;
  end;

var
  menuName: String;
  i: integer;
begin
  mouseGestureEnable := (Config.mseGestureList.Text <> '');
  if not mouseGestureEnable then
    exit;

  for i := 0 to Config.mseGestureList.Count -1 do
  begin
    menuName := Config.mseGestureList.Values[Config.mseGestureList.Names[i]];
    if length(menuName) = 0 then
      continue;
    try
      Config.mseGestureList.Objects[i] := FindComponent(menuName) as TMenuItem;
    except
    end;
    if (Config.mseGestureList.Objects[i] = nil) and AnsiStartsText('MenuCommand', menuName) then
      try
        Config.mseGestureList.Objects[i] := FindCommandMenu(MenuCommand, StrToInt(copy(menuName, 12, 2)));
      except
      end;
  end;
end;


//※[JS]
procedure TMainWnd.ListTabControlGetImageIndex(Sender: TObject;
  TabIndex: Integer; var ImageIndex: Integer);
begin
  ImageIndex := 1;
end;

//※[JS]
procedure TMainWnd.TabControlGetImageIndex(Sender: TObject;
  TabIndex: Integer; var ImageIndex: Integer);
begin
  ImageIndex := 3;
end;

//※[457]
procedure TMainWnd.SetviewListItemsColor;
var
  i: Integer;
begin
  for i := 0 to viewList.Count -1 do
    viewList.Items[i].browser.Color := WebPanel.Color;
end;

//aiai
procedure TMainWnd.MenuFindThreadClick(Sender: TObject);
//var
//  rc, i: integer;
//  target: string;
begin
//  if Config.schUseSearchBar then
//  begin
    ListViewSearchToolBar.Visible := not ListViewSearchToolBar.Visible;
    if ListViewSearchToolBar.Visible then
      try
        ListViewSearchEditBox.SetFocus;
      except end;
    exit;
//  end;
//
//  if currentBoard = nil then
//    exit;
//
//  if GrepDlg = nil then
//    GrepDlg := TGrepDlg.Create(self);
//
//  if not currentBoard.threadSearched or (Sender = MenuFindThreadNew) then
//    GrepDlg.Caption := 'スレ絞り込み強調'
//  else
//    GrepDlg.Caption := 'スレ絞り込み強調(現在の結果から更に絞り込む)';
//  GrepDlg.Edit.Text := searchTarget;
//  if (length(GrepDlg.Edit.Text) <= 0) and (GrepDlg.Edit.Items.Count > 0) then
//    GrepDlg.Edit.Text := GrepDlg.Edit.Items.Strings[0];  //aiai
//
//  GrepDlg.grepMode := false;
//  GrepDlg.extractMode := false; //beginner
//
//  rc := GrepDlg.ShowModal;
//  if (rc <> 3) then
//    exit;
//
//  searchTarget := Trim(GrepDlg.Edit.Text);
//  target := StrUnify(searchTarget);
//
//  if currentBoard.threadSearched and (Sender = MenuFindThreadNew) then
//    for i := 0 to ListView.Items.Count -1 do
//      TThreadItem(LIstView.List[i]).liststate := 0;
//
//  if not currentBoard.threadSearched or (Sender = MenuFindThreadNew) then
//  begin
//    if target <> '' then
//      for i := 0 to ListView.Items.Count -1 do
//        with TThreadItem(LIstView.List[i]) do
//          if 0 < AnsiPos(target, StrUnify(HTML2String(title))) then
//            liststate := 1;
//  end else //絞り込み済みの場合更に絞り込む
//  begin
//    currentBoard.threadSearched := False;
//    for i := 0 to ListView.Items.Count -1 do
//      with TThreadItem(LIstView.List[i]) do
//        if (liststate <> 0) then
//        begin
//          if ((target = '') or (0 >= AnsiPos(target, StrUnify(HTML2String(title))))) then
//            liststate := 0
//          else
//            currentBoard.threadSearched := True;
//        end;
//  end;
//
//  ListView.Sort(@ListCompareFuncSearchState);
//  ListView.SetTopItem(ListView.Items[0]);
//  //ListView.Refresh;
//
//  currentBoard.threadSearched := (TThreadItem(ListView.Items[0].Data).liststate <> 0);
//  if currentBoard.threadSearched then
//    currentSortColumn := 100
//  else begin
//    currentSortColumn := 1;
//  end;
end;

(* スレッドタイトル検索 *) //aiai
procedure TMainWnd.MenuFindeThreadTitleClick(Sender: TObject);
var
  rc: integer;
  target: string;
begin
//  if currentBoard = nil then
//    exit;

  if GrepDlg = nil then
    GrepDlg := TGrepDlg.Create(self);

  GrepDlg.Caption := 'スレッドタイトル検索';
  GrepDlg.Edit.Text := searchTarget;

  if (length(GrepDlg.Edit.Text) <= 0) and (GrepDlg.Edit.Items.Count > 0) then
    GrepDlg.Edit.Text := GrepDlg.Edit.Items.Strings[0];

  GrepDlg.grepMode := false;
  GrepDlg.extractMode := false;

  rc := GrepDlg.ShowModal;
  if (rc <> 3) then
    exit;

  searchTarget := Trim(GrepDlg.Edit.Text);
  target := StrUnify(searchTarget);

  if length(target) <= 0 then
    exit;
  searchTarget := target;

  //target := 'http://www2.ttsearch.net/s.cgi?k='+URLEncode(target)+'&o=s&A=t';
  target := 'http://ttsearch.net/s.cgi?k='+URLEncode(target)+'&o=s&A=t';
  if usetrace[47] then Log(traceString[47])
  else Log('スレッドタイトル検索中');
  procGet := AsyncManager.Get(target, OnFind, ticket2ch.OnChottoPreConnect,'');
end;

//検索結果のhtmlを加工してViewItemに送る
procedure TMainWnd.OnFind(sender: TAsyncReq);
var
  findhtml: string;
begin
  if procGet = sender then
  begin

    case sender.IdHTTP.ResponseCode of
    200,304: (* OK *)
      begin
        Log('取得完了');
        Log('分析中');

        findhtml := TTSearchOnFind(procGet.Content);
        SetRPane(ptView);
        NewView.Viewidx(findhtml,'検索結果');
        Log('分析終了');
      end;
    else
      Log('取得ﾃﾞｷﾅｲ');
    end; //case

    procGet := nil;
  end;
end;

//※[457]
procedure TMainWnd.MenuClearFindThreadResultClick(Sender: TObject);
var
  i: Integer;
begin
  if (currentBoard = nil) or not currentBoard.threadSearched then
    exit;
  for i := 0 to ListView.Items.Count - 1 do
    TThreadItem(ListView.Items[i].Data).liststate := 0;
  ListViewColumnSort(Config.stlDefSortColumn);
  currentBoard.threadSearched := false;
end;

//※[457]
procedure TMainWnd.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  Sender.Canvas.Brush.Style := bsClear; //aiai (下線が残るのを避ける。特に意味はない)

  if config.stlListViewUseExtraBackColor then
  begin
    if Item.Index and 1 = 0 then
      Sender.Canvas.Brush.Color := config.clListViewOddBackColor
    else
      Sender.Canvas.Brush.Color := config.clListViewEvenBackColor;
  end else
    Sender.Canvas.Brush.Color := ListView.Color;

  if TThreadItem(Item.Data).liststate <> 0 then
  begin
    Sender.Canvas.Font.Color := clRed;
  end else if (TThreadItem(Item.Data).ThreAboneType and TThreAboneTypeMASK in [1, 2]) then
  begin
    Sender.Canvas.Font.Color := clGray;
  end else if (TThreadItem(Item.Data).ThreAboneType and TThreAboneTypeMASK = 4) then
  begin
    Sender.Canvas.Font.Color := clBlue;
  end;

  if (cdsHot in state) then
  begin
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsUnderline];
    Sender.Canvas.Font.Color := clHotLight;
  end;

  DefaultDraw := true;
end;

//※[457]
procedure TMainWnd.ListTabControlChanging(Sender: TObject;
  var AllowChange: Boolean);
{var
  i: Integer;
  //f: TLVOwnerDataEvent;}
begin
  //viewlist.Items.Progress
{  ListView.Items.BeginUpdate;
  if threadsearched then
  //  for i:= 0 to viewList.Count - 1 do
  //    viewList.Items[i]
  //f := ListView.OnData;
  //ListView.OnData := nil;
    for i := 0 to ListView.Items.Count - 1 do
      TThreadItem(ListView.Items[i].Data).liststate := 0;
  //ListView.OnData := f;
  ListView.Items.EndUpdate;
  threadsearched := false;}
end;
//※[457]
procedure TMainWnd.ThreadTitleLabelClick(Sender: TObject);
var
  textwidth, cursorx: Integer;
begin
  if (currentView = nil) or (currentView.thread = nil) then
    exit;
  textwidth := ThreadTitleLabel.Canvas.TextWidth('【' + TBoard(currentView.thread.board).name + '】');
  cursorx := ThreadTitleLabel.ScreenToClient(Mouse.CursorPos).X;
  if cursorx <= textwidth then
  begin
    ListViewNavigate(TBoard(currentView.thread.board), Config.oprGestureBrdOther,
                   (Config.oprOpenBoardWNewTab xor (GetKeyState(VK_SHIFT) < 0)));
  end;
end;

procedure TMainWnd.ThreadTitleLabelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (currentView <> nil) and (currentView.thread <> nil) and
     (X <= ThreadTitleLabel.Canvas.TextWidth('【' + TBoard(currentView.thread.board).name + '】')) then
    ThreadTitleLabel.Cursor := crHandPoint
  else
    ThreadTitleLabel.Cursor := crDefault;
end;

//※[457] レスあぼーん
procedure TMainWnd.PopupViewAboneClick(Sender: TObject);
var
  viewItem: TBaseViewItem;
  changedItem: TViewItem;
  line: integer;
begin
  viewItem := GetViewOf(PopupViewMenu.PopupComponent);
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  line := TMenuItem(Sender).Tag;

  if Sender = PopupViewAbone then
  begin
    if viewItem.thread.AboneArray[line] <> 1 then
      viewItem.thread.AboneArray[line] := 1
    else
      viewItem.thread.AboneArray[line] := 0;
  end else
  if Sender = PopupViewTransParencyAbone then
  begin
    if viewItem.thread.AboneArray[line] <> 2 then
      viewItem.thread.AboneArray[line] := 2
    else
      viewItem.thread.AboneArray[line] := 0;
  end else
  if Sender = PopupViewSetCheckRes then
    if viewItem.thread.AboneArray[line] <> 4 then
    begin
      viewItem.thread.AboneArray[line] := 4;
      //exit;  koreawatcher ｺﾒﾝﾄｱｳﾄ
    end else begin
      viewItem.thread.AboneArray[line] := 0;
      //exit;  koreawatcher ｺﾒﾝﾄｱｳﾄ
    end;

  changedItem := viewList.FindViewItem(viewItem.thread);
  if Assigned(changedItem) then
    changedItem.LocalReload(changedItem.GetTopRes);
end;

//※[457] 範囲指定レスあぼーん(解除も)
procedure TMainWnd.PopupViewBlockAboneClick(Sender: TObject);
var
  viewItem: TViewItem;
  line, gopos: integer;
  abonevalue: Byte;
begin
  viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  line := TMenuItem(Sender).Tag;
  if viewItem.thread.selectedaboneline = 0 then
    viewItem.thread.selectedaboneline := line
  else
  begin
    if Sender = PopupViewBlockAbone then
    begin
      abonevalue := 1;
      gopos := Max(line, viewItem.thread.selectedaboneline);
      if viewItem.thread.lines = gopos then
       dec(gopos);
    end
    else if Sender = PopupViewBlockAbone3 then
    begin
      abonevalue := 2;
      gopos := Max(line, viewItem.thread.selectedaboneline);
      if viewItem.thread.lines = gopos then
       dec(gopos);
    end
    else //if Sender = PopupViewBlockAbone2 then
    begin
      abonevalue := 0;
      gopos := Min(line, viewItem.thread.selectedaboneline) - 1;
    end;

    viewItem.thread.ABoneArray.SetBlock(line, viewItem.thread.selectedaboneline, abonevalue);
    viewItem.thread.selectedaboneline := 0;

    viewItem.LocalReload(gopos);
  end;
end;

{beginner} //スレ欄からのNGワードの追加
procedure TMainWnd.PopupViewAddNgClick(Sender: TObject);
var
  baseViewItem: TBaseViewItem;
  viewItem: TViewItem;
  dat:TThreadData;
  Item:string;
  i:Integer;
  tmp:string;
  NgList:TNGItemIdent;
  NGItemData:TNGItemData;
  AboneType:Integer;
  LifeSpan:Integer;
  MResult: Integer;
  p: PChar;
  size: integer;
  rc: Boolean;
begin
  if (PopupViewMenu.PopupComponent is THogeTextView) then
    baseViewItem := GetViewOf(PopupViewMenu.PopupComponent)
  else
    baseViewItem := GetActiveView;

  if (baseViewItem.thread = nil) or (baseViewItem.thread.dat = nil) then
    exit;

  //viewItemがTPopupViewItemの可能性があるのでviewListからTViewItemを探す
  // by aiai
  //
  viewItem := viewList.FindViewItem(baseViewItem.thread);

  if viewItem = nil then
    exit;

  dat := viewItem.thread.DupData;

  if sender = PopupViewAddNgName then begin
    rc := dat.FetchNameP(TMenuItem(Sender).Tag, p, size);
    NgList := NG_ITEM_NAME;
  end else if sender = PopupViewAddNgAddr then begin
    rc := dat.FetchMailP(TMenuItem(Sender).Tag, p, size);
    NgList := NG_ITEM_MAIL;
  end else if sender=PopupViewAddNgWord then begin
    rc := dat.FetchMessageP(TMenuItem(Sender).Tag, p, size);
    NgList := NG_ITEM_MSG;
  end else if sender=PopupViewAddNgId then begin
    rc := dat.FetchIDP(TMenuItem(Sender).Tag, p, size);
    NgList := NG_ITEM_ID;
  end else begin
    dat.Free;
    Exit;
  end;

  if not rc or (p = nil) or (size = 0) then begin
    dat.Free;
    Exit;
  end;

  SetString(Item, p, size);

  tmp := TMenuItem(Sender).Caption;

  QuickAboneRegist := TQuickAboneRegist.Create(Self);
  QuickAboneRegist.Font := Self.Font;
  QuickAboneRegist.Caption := tmp;
  QuickAboneRegist.ItemView.Append(StringReplace(Item, ' <br> ', #13#10, [rfReplaceAll]));
  QuickAboneRegist.ItemView.SelectAll;

  Repeat
    MResult := QuickAboneRegist.ShowModal;
    if MResult = mrCancel then
    begin
      dat.Free;
      QuickAboneRegist.Release;
      QuickAboneRegist := nil;
      Exit;
    end;
    //if MResult = mrCancel then
    //  Exit;
//２ちゃんねるブラウザ「OpenJane」改造総合スレ9
//http://jane.cun.jp/test/read.cgi/win/1064951726/217
//2-293氏

  until QuickAboneRegist.ItemView.GetSelection <> '';

  Item := StringReplace(QuickAboneRegist.ItemView.GetSelection,#13#10,' <br> ',[rfReplaceAll]);

  case QuickAboneRegist.cmbAboneType.ItemIndex of
    1: AboneType := 2;
    2: AboneType := 4;
    else
      AboneType := 0;
  end;

  LifeSpan := QuickAboneRegist.seLifeSpan.Value;
  QuickAboneRegist.Release;
  QuickAboneRegist := nil;

  case MResult of
    mrOk: begin //NGに登録する
      i := NgItems[NGList].IndexOf(item);
      if i < 0 then begin
        tmp := '';
        NGItemData := TNGItemData.Create('', tmp);
        NGItemData.AboneType := AboneType;
        NGItemData.LifeSpan := LifeSpan;
        NGItemData.BMSearch := TBMSearch.Create;
        NGItemData.BMSearch.IgnoreCase := not(Sender = PopupViewAddNgId);
        NGItemData.BMSearch.Subject := Item;

        NGItems[NgList].AddObject(item, NGItemData);
        NGItems[NgList].SaveToFile(config.basepath + NG_FILE[NgList]);
        viewItem.LocalReload(viewItem.GetTopRes);
      end else begin
        MessageDlg('キーワード"'+Item+'"は登録済み',mtWarning,[mbOk],0);
      end;
    end;
    mrYes: begin //直接あぼーんする
      for i := 1 to viewItem.thread.lines do begin
        if (((sender = PopupViewAddNgName) and dat.FetchNameP(i, p, size) and (SearchBuf(p, size, 0, 0, Item, [soDown]) <> nil)) or
            ((sender = PopupViewAddNgAddr) and dat.FetchMailP(i, p, size) and (SearchBuf(p, size, 0, 0, Item, [soDown]) <> nil)) or
            ((sender = PopupViewAddNgWord) and dat.FetchMessageP(i, p, size) and (SearchBuf(p, size, 0, 0, Item, [soDown]) <> nil)) or
            ((sender = PopupViewAddNgId)  and dat.FetchIDP(i, p, size) and (SearchBuf(p, size, 0, 0, Item, [soDown]) <> nil)
           ) and (AboneType >= viewItem.thread.ABoneArray[i])) then begin
           if AboneType = 0 then
             viewItem.thread.ABoneArray[i] := 1
           else
             viewItem.thread.ABoneArray[i] := AboneType;
        end;
      end;
      viewItem.LocalReload(viewItem.GetTopRes);
    end;
  end;

  dat.Free;

end;
{/beginner}


//aiai
//TextPopupNGWordClickとほとんど同じ
procedure TMainWnd.TextPopupAddNGIDClick(Sender: TObject);
var
  baseViewItem: TBaseViewItem;
  viewItem: TViewItem;
  Item: string;
  i: Integer;
  tmp: string;
  NGItemData: TNGItemData;
begin
  //スレビューを取得
  viewItem  := GetActiveView;
  if viewItem = nil then
    exit;

  //IDを取得したスレビューorポップアップを取得
  if PopupTextMenu.PopupComponent is THogeTextView then
    baseViewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    baseViewItem := GetActiveView;

  if baseViewItem = nil then
    exit;

  tmp := baseViewItem.LinkText;
  if not AnsiStartsStr('ID:', tmp) then
    exit;
  SetString(Item, PChar(tmp) + 3, Length(tmp) - 3);
  if Length(Item) <= 0 then
    exit;

  i := NgItems[NG_ITEM_ID].IndexOf(item);
  if i < 0 then begin
    if MessageDlg('ID:”' + Item + '” をNGIDに追加します', mtInformation, [mbOk, mbCancel], 0) <> mrOk then
      Exit;
    tmp := '';
    NGItemData := TNGItemData.Create('', tmp);
    NGItemData.BMSearch := TBMSearch.Create;
    NGItemData.BMSearch.IgnoreCase := False;
    NGItemData.BMSearch.Subject := Item;

    NGItems[NG_ITEM_ID].AddObject(item, NGItemData);
    NGItems[NG_ITEM_ID].SaveToFile(config.basepath + NG_FILE[NG_ITEM_ID]);

    if viewItem.thread <> nil then
      viewItem.LocalReload(viewItem.GetTopRes);
  end else begin
    MessageDlg('キーワード"'+Item+'"は登録済み',mtWarning,[mbOk],0);
  end;
end;

//このIDをあぼーん・このIDを透明あぼーん
procedure TMainWnd.TextPopupIDAboneClick(Sender: TObject);
var
  baseViewItem: TBaseViewItem;
  viewItem: TViewItem;
  Item, tmp: String;
  i: Integer;
  dat: TThreadData;
  AboneType: Integer;
  p: PChar;
  size: integer;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    baseViewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    baseViewItem := GetActiveView;
  if (baseViewItem = nil) or (baseViewItem.thread = nil)
    or (baseViewItem.thread.dat = nil) then
    exit;
  tmp := baseViewItem.LinkText;
  viewItem := viewList.FindViewItem(baseViewItem.thread);
  if viewItem = nil then
    exit;
  if not AnsiStartsStr('ID:', tmp) then
    exit;
  SetString(Item, PChar(tmp) + 3, Length(tmp) - 3);
  if Length(Item) <= 0 then
    exit;

  AboneType := TMenuItem(Sender).Tag;
  dat := viewItem.thread.DupData;
  for i := 1 to viewItem.thread.lines do begin
    if dat.FetchIDP(i, p, size) and (SearchBuf(p, size, 0, 0, item, [soDown]) <> nil)
          and (AboneType >= viewItem.thread.ABoneArray[i]) then
    begin
      viewItem.thread.ABoneArray[i] := AboneType;
    end;
  end;
  viewItem.LocalReload(viewItem.GetTopRes);

  dat.Free;
end;

//aiai レスの内容をAAlistに登録
procedure TMainWnd.PopupViewAddAAlistClick(Sender: TObject);
var
  dlg: TAddAAForm;
  viewItem: TBaseViewItem;
  strList: TStringList;
begin
  if PopupViewMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(TComponent(PopupViewMenu.PopupComponent))
  else
    viewItem := GetActiveView;

  if (viewItem = nil) or
     (viewItem.thread = nil) or
     (viewItem.thread.dat = nil) then
    exit;

  strList := TStringList.Create;
  strList.Text := viewItem.thread.ToString('<MESSAGE/><br>', TMenuItem(Sender).Tag, 1);

  if strList.Text = '' then
  begin
    strList.Free;
    exit;
  end;

  dlg := TAddAAForm.Create(self);
  dlg.Text := strList.Text;
  strList.Free;
  dlg.ShowModal;
  dlg.Release;

end;

{beginner} //レスが含む画像URLを全て開く
procedure TMainWnd.PopupViewOpenImageClick(Sender: TObject);
var
  viewItem: TViewItem;
  item:string;
  URI:string;
  URIs:TStringList;
  i:integer;
begin
  viewItem := GetActiveView;
  if not Assigned(viewItem.thread.dat) then
    exit;

  item := PickUpRes(viewItem.thread, TMenuItem(Sender).Tag, TMenuItem(Sender).Tag);
  if Item='' then Exit;

  URIs:=TStringList.Create;
  try
    UImageViewer.ExtractURLs(item, URIs);

    for i:=0 to URIs.Count-1 do begin
      URI:=UImageViewer.ProofURL(URIs[i]);
      if URI<>'' then
          if not ImageForm.GetImage(URI,viewItem) then
            if not ImageViewConfig.OpenImagesOnly then
              if not NavigateIntoView(URI, gtOther) then
                OpenByBrowser(URI);
    end;
  finally
    URIs.Free; //ゐ
  end
end;
{/beginner}


{beginner} //このレスを起点にツリー表示(エントリ)
procedure TMainWnd.PopupViewShowResTreeClick(Sender: TObject);
var
  viewItem: TViewItem;
  outline: boolean;
begin
  viewItem := GetActiveView;
  if (viewItem = nil) or(viewItem.thread = nil) then
    Exit;

  outline := (Sender = actShowOutLine) or (Sender = PopupViewShowOutLine);

  NewView.ThreadTree(viewItem.thread, TMenuItem(Sender).Tag, outline);
end;
{/beginner}


//※[457]
procedure TMainWnd.PopupFavOpenFolderByBoardClick(Sender: TObject);
var
  node: TTreeNode;
  FavoriteListBoard: TFavoriteListBoard;
begin
    node := FavoriteView.Selected;
    if (node = nil) or not (TObject(node.Data) is TFavoriteList) then exit;

    FavoriteListBoardAdmin.GarbageCollect;

    if node.Data = favorites then
      //お気に入り全体はi2chに板として登録済み
      FavoriteListBoard := TFavoriteListBoard(i2ch.Items[0].Items[1]) //  i2ch.FindBoard('Jane', 'fav'));
    else
      //その他のフォルダの板はFavoriteListBoardAdminで管理
      FavoriteListBoard := FavoriteListBoardAdmin.GetBoard(TFavoriteList(node.Data));
  if FavoriteListBoard <> nil then
  begin
    //FavoriteListBoard.SetFavList(TFavoriteList(node.data));
    {if currentBoard = FavoriteListBoard then
      SetRPane(ptList)
    else}
    ListViewNavigate(FavoriteListBoard, gotLOCAL,  //▼新しいタブで開くか
                    (Config.oprOpenBoardWNewTab xor (GetKeyState(VK_SHIFT) < 0)));
  end;
end;


//※[457]
procedure TMainWnd.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if config.oprBoardTreeExpandOneCategory then
    TreeView.FullCollapse;
end;

procedure TMainWnd.UrlEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  url: string;
begin
  url := Trim(UrlEdit.Text);
  case key of
  VK_RETURN:
    begin
{beginner}
      if ImageForm.GetImage(url) then begin
        Key:=0;
        Exit;
      end;
{//beginner}
      if ssCtrl in Shift then
        OpenByBrowser(url)
      else
        NavigateIntoView(url, gtOther, false, Config.oprAddrBgOpen);
      Key := 0;
    end;
  Ord('A'):
    begin
      if ssCtrl in Shift then
        UrlEdit.SelectAll;
    end;
  end;
end;

procedure TMainWnd.PopupAddFavClick(Sender: TObject);
var
  favlist: TFavoriteList;
  thread: TThreadItem;
begin
  favlist := TFavoriteList(TMenuItem(Sender).Tag);
  if currentView = nil then
    exit;
  thread := currentView.thread;
  if thread <> nil then
    RegisterFavorite(thread, favlist);

  // ▼ Nightly Mon Oct 11 07:23:21 2004 UTC by view
  // お気に入りへの追加がただちにスレ一覧に反映されない不具合を修正
  daemon.Post(RedrawFavoriteButton);
  // ▲ Nightly Mon Oct 11 07:23:21 2004 UTC by view
end;

procedure TMainWnd.PopupAddFavoritePopup(Sender: TObject);
  procedure AddFavItem(favList: TFavoriteList; parent: TMenuItem);
  var
    item, itemparent: TMenuItem;
    i: integer;
    childfavlist: TFavoriteList;
  begin
    for i := 0 to favList.Count -1 do
    begin
      if favList.Items[i] is TFavoriteList then
      begin
        childfavlist := TFavoriteList(favList.Items[i]);
        itemparent := TMenuItem.Create(parent);
        //itemparent.Caption := StringReplace(childfavlist.name, '&', '&&', [rfReplaceAll]);
        parent.Add(itemparent);
        AddFavItem(childfavlist, itemparent);
      end;
    end;
    if parent.Count > 0 then
    begin
      parent.Caption := StringReplace(favlist.name, '&', '&&', [rfReplaceAll]);
      item := TMenuItem.Create(parent);
      item.Caption := '「' + StringReplace(favList.name, '&', '&&', [rfReplaceAll]) + '」に追加';
      item.Tag := Integer(favList);
      item.OnClick := PopupAddFavClick;
      parent.Insert(0, item);
      item := TMenuItem.Create(parent);
      item.Caption := '-';
      parent.Insert(1, item);
    end
    else begin
      parent.Caption := '「' + StringReplace(favList.name, '&', '&&', [rfReplaceAll]) + '」に追加';
      parent.Tag := Integer(favList);
      parent.OnClick := PopupAddFavClick;
    end;
  end;
begin
  PopupAddFavorite.Items.Clear;
  AddFavItem(favorites, PopupAddFavorite.Items);
end;

procedure TMainWnd.SetPaneType(toggle: boolean);
var
  control: TWinControl;
begin
  control := ActiveControl;
  Panel2.Visible := false;
  Config.oprToggleRView := toggle;
  if toggle then
  begin
    if Config.stlVerticalDivision then
      savedListWidth := ListViewPanel.Width
    else
      savedListHeight := ListViewPanel.Height;
    ListViewPanel.Align := alClient;
    ThreadSplitter.Visible := false;
    // 現在のフォーカスにあわせて切り替え先を変更
    if control = ListView then
      SetRPane(ptList)
    else if control is THogeTextView then
      SetRPane(ptView)
    else
      SetRPane(mdRPane);
    actDivisionChange.Enabled := false;
    MenuToggleRPane.Visible := true;
    ThreadSplitter.Visible := false;
    ToggleRPaneButton.Enabled := true;
  end
  else begin
    ListViewPanel.Visible := true;
    ThreadSplitter.Visible := true;
    WebPanel.Visible := true;
    ThreadSplitter.Visible := true;
    SetDivision(Config.stlVerticalDivision);
    actDivisionChange.Enabled := true;
    MenuToggleRPane.Visible := false;
    ToggleRPaneButton.Enabled := false;
  end;

  Panel2.Visible := true;
  ListView.TabStop := ListView.CanFocus and (0 < ListView.Items.Count);
  if (control <> nil) and control.CanFocus then
  try
    control.SetFocus;
  except
  end;
end;



procedure TMainWnd.MenuViewPaneModeChangeClick(Sender: TObject);
begin
  SetPaneType(not Config.oprToggleRView);
end;

procedure TMainWnd.SetDivision(vertical: Boolean);
var
  control: TWinControl;
begin
  control := ActiveControl;
  Panel2.Visible := false;
  if vertical then
  begin
    if not Config.stlVerticalDivision then
      savedListHeight := ListViewPanel.Height;
    ListViewPanel.Align := alLeft;
    if savedListWidth > 0 then
      ListViewPanel.Width := savedListWidth
    else
      ListViewPanel.Width := Panel2.Width div 2;
    if ListViewPanel.Width <= 0 then
      ListViewPanel.Width := 1;
    ThreadSplitter.Align := alLeft;
    ThreadSplitter.Left := WebPanel.Left;
    DivisionChangeButton.ImageIndex := 1;
  end else
  begin
    if Config.stlVerticalDivision then
      savedListWidth := ListViewPanel.Width;
    ListViewPanel.Align := alTop;
    if savedListHeight > 0 then
      ListViewPanel.Height := savedListHeight
    else
      ListViewPanel.Height := Panel2.Height div 2;
    if ListViewPanel.Height <= 0 then
      ListViewPanel.Height := 1;
    ListView.Width :=ListViewPanel.Width;
    ThreadSplitter.Align := alTop;
    ThreadSplitter.Top := WebPanel.Top;
    DivisionChangeButton.ImageIndex := 0;
  end;
  Config.stlVerticalDivision := vertical;
  Panel2.Visible := true;
  if (control <> nil) and control.CanFocus then
  try
    control.SetFocus;
  except
  end;
  SetTracePosition; //beginner
end;


procedure TMainWnd.MenuViewDivisionChangeClick(Sender: TObject);
begin
  SetDivision(not Config.stlVerticalDivision);
end;

procedure TMainWnd.MenuViewToolBarToggleVisibleClick(Sender: TObject);
var
  b: boolean;
begin
  b := not MenuViewToolBarToggleVisible.Checked;
  Config.stlToolBarVisible := b;
  CoolBar.Bands.FindBand(ToolBarMain).Visible := b;
  MenuViewToolBarToggleVisible.Checked := b;
  CoolBar.Visible := b or Config.stlLinkBarVisible
                       or Config.stlAddressBarVisible;

  MenuPopupBarToolBar.Checked := b; //aiai
end;

procedure TMainWnd.MenuViewLinkBarToggleVisibleClick(Sender: TObject);
var
  b: boolean;
begin
  b := not MenuViewLinkBarToggleVisible.Checked;
  Config.stlLinkBarVisible := b;
  CoolBar.Bands.FindBand(LinkBar).Visible := b;
  MenuViewLinkBarToggleVisible.Checked := b;
  CoolBar.Visible := b or Config.stlToolBarVisible
                       or Config.stlAddressBarVisible;
  if Config.stlLinkBarVisible and not Config.optEnableFavMenu then
    UpdateFavoritesMenu;

  MenuPopupBarLinkBar.Checked := b; //aiai
end;

procedure TMainWnd.MenuViewAddressBarToggleVisibleClick(Sender: TObject);
var
  b: boolean;
begin
  b  := not MenuViewAddressBarToggleVisible.Checked;
  Config.stlAddressBarVisible := b;
  //CoolBar.Bands.FindBand(urledit).Visible := b;
  CoolBar.Bands.FindBand(ToolBarUrlEdit).Visible := b; //aiai
  MenuViewAddressBarToggleVisible.Checked := b;
  CoolBar.Visible := b or Config.stlToolBarVisible
                       or Config.stlLinkBarVisible;

  MenuPopupBarAdressBar.Checked := b; //aiai
end;

procedure TMainWnd.MenuViewMenuToggleVisibleClick(Sender: TObject);
begin
  //▼ Nightly  Sun Oct 10 04:58:28 2004 UTC by view
  //表示－メニューのチェックが状態を反映するように修正
  (*
  if MainWnd.Menu = nil then
    MainWnd.Menu := MainMenu
  else
    MainWnd.Menu := nil;
  *)
  if MainWnd.Menu = nil then
  begin
    MainWnd.Menu := MainMenu;
    MenuViewMenuToggleVisible.Checked := True;
  end else
  begin
    MainWnd.Menu := nil;
    MenuViewMenuToggleVisible.Checked := False
  end;
  //▲ Nightly  Sun Oct 10 04:58:28 2004 UTC by view

  MenuPopupBarMenu.Checked := MenuViewMenuToggleVisible.Checked; //aiai
end;

procedure TMainWnd.SetStyle;
var
  i: integer;
begin
  ThreadToolBar.Visible    := Config.stlThreadToolBarVisible;
  ThreadTitleLabel.Visible := Config.stlThreadTitleLabelVisible;
  ThreadToolPanel.Visible  := ThreadToolBar.Visible or ThreadTitleLabel.Visible;

  if Config.stlTabStyle = 3 then
  begin
    TabPanel.Visible := false;
    TabBarPanel.Visible := false;
  end
  else begin
    TabBarPanel.Visible := true;
    TabPanel.Visible := true;
    TabControl.Style := ComCtrls.TTabSTyle(Config.stlTabStyle);
  end;
  if Config.stlListTabStyle = 3 then
    ListTabPanel.Visible := false
  else begin
    ListTabControl.Style := ComCtrls.TTabSTyle(Config.stlListTabStyle);
    ListTabPanel.Visible := true;
  end;
  if Config.stlTreeTabStyle = 3 then
    TreeTabControl.Visible := false
  else begin
    TreeTabControl.Style   := ComCtrls.TTabSTyle(Config.stlTreeTabStyle);
    TreeTabControl.Visible := true;
  end;

  if TabPanel.Visible then
  begin
    TabControl.TabWidth  := Config.stlTabWidth;
    TabControl.TabHeight := Config.stlTabHeight;
    TabControl.MultiLine   := Config.stlTabMaltiline;
    TabControl.RaggedRight := Config.stlTabMaltiline;
    UpdateTabTexts(true);
    if Config.stlTabMaltiline then
      ThreadTabLineAdjust
    else
      TabBarPanel.Height := Config.stlTabHeight + 4;
  end;

  if ListTabPanel.Visible then
  begin
    ListTabControl.TabWidth  := Config.stlListTabWidth;
    ListTabControl.TabHeight := Config.stlListTabHeight;
    ListTabControl.MultiLine   := Config.stlTabMaltiline;
    ListTabControl.RaggedRight := Config.stlTabMaltiline;
    if not MenuList[0].Visible then
    begin
      for i := 0 to MenuList.IndexOf(MenuListTabMenuSep) -1 do
      begin
        MenuList.Items[i].Visible := true;
        MenuList.Items[i].Enabled := true;
      end;
      for i := 0 to MenuWindow.IndexOf(MenuWndTabMenuSep) -1 do
      begin
        MenuWindow[i].Visible := true;
        MenuWindow[i].Enabled := true;
      end;
    end;
    if Config.stlTabMaltiline then
      ListTabLineAdjust
    else
      ListTabPanel.Height := Config.stlListTabHeight + 4;
  end
  else begin
    if MenuList[0].Visible then
    begin
      for i := 0 to MenuList.IndexOf(MenuListTabMenuSep) -1 do
      begin
        MenuList.Items[i].Visible := false;
        MenuList.Items[i].Enabled := false;
      end;
      for i := 0 to MenuWindow.IndexOf(MenuWndTabMenuSep) -1 do
      begin
        MenuWindow[i].Visible := false;
        MenuWindow[i].Enabled := false;
      end;
    end;
  end;

  if Config.stlMenuIcons then
  begin
    MainMenu.Images := ListImages;
  end else
  begin
    MainMenu.Images := nil;
  end;
  if Config.stlTabIcons then
  begin
    ListTabControl.Images := ListImages;
    TabControl.Images := ListImages;
  end else
  begin
    ListTabControl.Images := nil;
    TabControl.Images := nil;
  end;
  if Config.stlLinkBarIcons then
  begin
    LinkBar.Images := ListImages;
  end else
  begin
    LinkBar.Images := nil;
  end;
  if Config.stlTreeIcons then
  begin
    TreeView.Images := ListImages;
    FavoriteView.Images := ListImages;
  end else
  begin
    TreeView.Images := nil;
    FavoriteView.Images := nil;
  end;
  if Config.stlListMarkIcons or Config.stlListTitleIcons then
    ListView.SmallImages := ListImages
  else
    ListView.SmallImages := nil;

  ListView.Refresh;

  TreeView.ShowButtons := Config.stlShowTreeMarks;
  TreeView.ShowLines := Config.stlShowTreeMarks;
  FavoriteView.ShowButtons := Config.stlShowTreeMarks;
  FavoriteView.ShowLines := Config.stlShowTreeMarks;
end;

procedure TMainWnd.UrlEditExit(Sender: TObject);
begin
  //SetImeMode(Handle, imClose);
  SaveImeMode(Handle);
end;

{beginner}
procedure TMainWnd.UrlEditEnter(Sender: TObject);
begin
  PostMessage(UrlEdit.Handle, EM_SETSEL, 0, -1);
end;
{/beginner}

{procedure TMainWnd.ListViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ListView.Selected <> nil then
    ListView.PopupMenu := ListPopupMenu
  else
    ListView.PopupMenu := nil;
end;}

procedure TMainWnd.SetUrlEdit(viewItem: TViewItem);
begin
  if Config.oprToggleRView and (mdRPane = ptList) then
    exit;
  if (viewItem = nil) or (viewItem.thread = nil) then
    UrlEdit.Clear
  else
    UrlEdit.Text := viewItem.thread.ToURL(false);
end;

procedure TMainWnd.SetUrlEdit(board: TBoard);
begin
  if Config.oprToggleRView and (mdRPane = ptView) then
    exit;
  if (board = nil) or (board is TFunctionalBoard) then
    UrlEdit.Clear
  else
    UrlEdit.Text := board.URIBase + '/';
end;

procedure TMainWnd.ListViewPanelEnter(Sender: TObject);
begin
  SetUrlEdit(currentBoard);
end;

procedure TMainWnd.WebPanelEnter(Sender: TObject);
begin
  SetUrlEdit(GetActiveView);
end;

procedure TMainWnd.actLoginExecute(Sender: TObject);
begin
  Config.tstAuthorizedAccess := not Config.tstAuthorizedAccess;
  actLogin.Checked := Config.tstAuthorizedAccess;
  if Config.tstAuthorizedAccess and ticket2ch.Authorized then
    loginIndicator := '='
  else if Config.tstAuthorizedAccess then
    loginIndicator := 'X'
  else
    loginIndicator := '';
  UpdateIndicator;
end;

procedure TMainWnd.actOnLineExecute(Sender: TObject);
begin
  Config.netOnline := not Config.netOnline;
  actOnline.Checked := Config.netOnline;
  if MenuOptOnline.Checked then
    OnlineButton.ImageIndex := 12
  else
    OnlineButton.ImageIndex := 13;
  SetCaption(boardNameOfCaption);
end;


procedure TMainWnd.MenuHelpClick(Sender: TObject);
var
  S: string;
//  Si: TStartupInfo;
//  Pi: TProcessInformation;
begin
  S := 'hh.exe ' + Config.BasePath + 'OpenJane.chm';
  CommandExecute(S, false);
//  GetStartupInfo(Si);
//  CreateProcess(nil, PAnsiChar(S), nil, nil, false, 0, nil, nil, Si, Pi);
end;


//※[457]カテゴリまるごとお気に入りに追加
procedure TMainWnd.PopupCatAddFavClick(Sender: TObject);
var
  node: TTreeNode;
  cat: TCategory;
  i: Integer;
  flist: TFavoriteList;
begin
  node := TreeView.Selected;
  if (node = nil) or not (TObject(node.data) is TCategory) then
    exit;

  cat := TCategory(node.Data);
  flist := TFavoriteList.Create(favorites);
  flist.name := cat.name;
  flist.expanded := false;
  FavoriteView.Items.BeginUpdate; //気休め
  try
    favorites.Insert(0, flist);
    for i := cat.Count - 1 downto 0 do
    begin
      RegisterFavorite(cat.Items[i], flist, 0, false);
    end;
  finally
    FavoriteView.Items.EndUpdate;
  end;
  SaveFavorites(true);
  UpdateFavorites;
end;

procedure TMainWnd.PopupCatAddBoardClick(Sender: TObject);
var
  node: TTreeNode;
  rc: integer;
  name, url, host, bbs, datnum: string;
  startIndex, endIndex: integer;
  oldLog: boolean;
  board: TBoard;
  cat: TCategory;
label
  CANCEL;
begin
  node := TreeView.Selected;
  if (node <> nil) and (TObject(node.Data) is TCategory) then
    cat := TCategory(node.Data)
  else
    exit;

  if InputDlg = nil then
    InputDlg := TInputDlg.Create(self);
  InputDlg.Caption := '新規板作成 : 板名を入力';
  //InputDlg.Edit.Clear;
  rc := InputDlg.ShowModal;
  if (rc <> 3) then
    exit;
  name := InputDlg.Edit.Text;
  if length(name) <= 0 then
    exit;

  InputDlg.Caption := '新規板作成 : 板URLを入力';
  InputDlg.Edit.Clear;
  rc := InputDlg.ShowModal;
  if (rc <> 3) then
    exit;
  url := Trim(InputDlg.Edit.Text);
  if length(url) <= 0 then
    exit;
  if not AnsiStartsStr('http://', url) then
    url := 'http://' + url;
  //SplitThreadURI(url, host, bbs);
  Get2chInfo(url, host, bbs, datnum, startIndex, endIndex, oldLog);
  if (host = '') or (bbs = '') then
  begin
    ShowMessage('URLの解釈に失敗しました');
    exit;
  end;
  SaveTreeViewState;
  board := TBoard.Create(cat);
  board.name := name;
  board.host := host;
  board.bbs  := bbs;
  cat.Add(board);
  i2ch.Save;
  UpdateTreeView;

  Log('新規板 [' + board.name + '] (' + board.URIBase + '/) を作成しました');
end;

procedure TMainWnd.PopupCatAddCategoryClick(Sender: TObject);
var
  cat: TCategory;
  rc: integer;
begin
  if InputDlg = nil then
    InputDlg := TInputDlg.Create(self);
  InputDlg.Caption := '新規カテゴリ作成 : カテゴリ名を入力';
  InputDlg.Edit.Clear;
  rc := InputDlg.ShowModal;
  if (rc <> 3) then
    exit;
  if length(InputDlg.Edit.Text) <= 0 then
    exit;
  SaveTreeViewState;
  cat := TCategory.Create(i2ch);
  cat.name := InputDlg.Edit.Text;
  cat.custom := true;
  i2ch.Add(cat);
  i2ch.Save;
  UpdateTreeView;

  Log('新規カテゴリ [' + cat.name + '] を作成しました');
end;

procedure TMainWnd.PopupCatDelCategoryClick(Sender: TObject);
var
  node: TTreeNode;
  cat: TCategory;
begin
  node := TreeView.Selected;
  if (node = nil) or not (TObject(node.Data) is TCategory) then
    exit;
  cat := TCategory(node.Data);
  if (cat <> nil) and (cat.Count = 0) and
     (MyMessageDlg('「' + cat.name + '」を消しても(・∀・)ｲｲ？') = mrOk) then   //aiai
  begin
    Log('カテゴリ [' + cat.name + '] を削除しました');
    i2ch.Delete(i2ch.IndexOf(cat));
    node.Delete;
    cat.Free;
    SaveTreeViewState;
    UpdateTreeView;
  end;
end;

procedure TMainWnd.PopupTreeDelBoardClick(Sender: TObject);
var
  node: TTreeNode;
  board: TBoard;
begin
  node := TreeView.Selected;
  if (node = nil) or not (TObject(node.Data) is TBoard) then
    exit;
  board := TBoard(node.Data);
  if (board <> nil) and not board.Refered and
     (MyMessageDlg('「' + board.name + '」を消しても(・∀・)ｲｲ？') = mrOk) then //aiai
  begin
    Log('板 [' + board.name + '] を削除しました');
    TCategory(board.category).Delete(TCategory(board.category).IndexOf(board));
    node.Delete;
    board.Free;
    SaveTreeViewState;
    UpdateTreeView;
  end;
end;


(* IdxList再構築 *) //aiai
procedure TMainWnd.actRefreshIdxListExecute(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
  msg: PChar;
  sql: string;
  err: byte;
begin
  if not Config.ojvQuickMerge then
    exit;

  if PopupTreeClose.Visible or (Sender = MenuListRefreshIdxList) then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board = nil then
    exit;

  UILock := True;

  sql := 'DROP TABLE idxlist';
  err := board.IdxDataBase.Exec(PChar(sql), nil, nil, msg);
  SQLCheck(err, board.name, sql, msg);

  ListView.OnData := nil;

   board.Load(True);
   board.ResetListState;

  ListView.OnData := ListViewData;

  UpdateListView;
  UpdateTabTexts;

  UILock := False;
end;

(* 過去ログ非表示 *) //aiai
procedure TMainWnd.actHideHistoricalLogExecute(Sender: TObject);
var
  board: TBoard;
  node: TTreeNode;
begin
  if PopupTreeClose.Visible or (Sender = MenuListHideHistoricalLog) then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if (board = nil) or (board is TFunctionalBoard) then
    exit;

  board.HideHistoricalLog := not board.HideHistoricalLog;

  if (currentBoard <> nil) and (board = currentBoard) then
  begin
    UILock := true;
    UpdateListView;
    UpdateTabTexts;
    UILock := false;
  end;
end;

(* あぼ～んを表示 *) //aiai
procedure TMainWnd.actThreadAboneShowExecute(Sender: TObject);
begin
  if TAction(Sender).Checked then
    exit;

  TAction(Sender).Checked := True;
  ThreAboneLevel := TAction(Sender).Tag;

  if (currentBoard <> nil) then
  begin
    UILock := true;
    //board.Load(False);
    UpdateListView;
    UpdateTabTexts;
    //TabControl.Refresh;
    UILock := false;
  end;
end;

procedure TMainWnd.PopupTreeCategoryPopup(Sender: TObject);
var
  node: TTreeNode;
  cat: TCategory;
begin
  node := TreeView.Selected;
  TreeView.Selected := node;
  if node = nil then
    exit;
  if TObject(node.Data) is TCategory then
  begin
    cat := TCategory(node.Data);
    PopupCatAddFav.Enabled := true;
    PopupCatAddBoard.Enabled := (cat <> i2ch.Items[0]);
    PopupCatAddCategory.Enabled := true;
    PopupCatDelCategory.Enabled := (cat.Count <= 0);
  end
  else begin
    PopupCatAddFav.Enabled := false;
    PopupCatAddBoard.Enabled := false;
    PopupCatAddCategory.Enabled := false;
    PopupCatDelCategory.Enabled := false;
  end;
end;


procedure TMainWnd.TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  node: TTreeNode;
begin
  node := TreeView.Selected;
  if node <> nil then
  begin
    if TObject(node.Data) is TCategory then
      TreeView.PopupMenu := PopupTreeCategory
    else
      TreeView.PopupMenu := PopupTree;
  end;
end;

// 対象をファイルに保存
//------------------------------------------------------------------------------
// by nono ◆MFAp1y4voQ 2003/01/15

function DoFileDownload(var lpszFile :WideChar): LONGBOOL; stdcall; external 'shdocvw.dll';

function TMainWnd.ProtocolCheck(const S: string):Boolean;
begin
  if AnsiStartsText('http://', S) or
     AnsiStartsText('https://', S) or
     AnsiStartsText('ftp://', S) then
    Result := True
  else
    Result := False;
end;

function TMainWnd.CutImenu(const s: string):string;
const
  IMENUHTTP = 'http://ime.nu/http://';
  IMENU = 'http://ime.nu/';
  NUNNU = 'http://nun.nu/?http://';
begin
  if AnsiPos(IMENUHTTP, s) = 1 then
    Result := 'http://' + Copy(s, Length(IMENUHTTP)+1, Length(s)-Length(IMENUHTTP))
  else if AnsiPos(IMENU, s) = 1 then
    Result := 'http://' + Copy(s, Length(IMENU)+1, Length(s)-Length(IMENU))
  else if AnsiPos(NUNNU, s) = 1 then
    Result := 'http://' + Copy(s, Length(NUNNU)+1, Length(s)-Length(NUNNU))
  else
    Result := s;
end;

procedure TMainWnd.TextPopupDownloadClick(Sender: TObject);
  procedure DoOnFileDownlaod(const URL: string);
  var
    WideURL: array of WideChar;
  begin
    SetLength(WideURL, 2084);
    StringToWideChar(URL, @WideURL[0], 2083);
    DoFileDownload(WideURL[0]);
  end;
var
  viewItem: TBaseViewItem;
  S: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := GetViewOf(PopupTextMenu.PopupComponent)
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  S := viewItem.LinkText;
  if Length(S) <= 0 then
    exit;
  S := CutImenu(S);
  if ProtocolCheck(S) then
    DoOnFileDownlaod(S);
end;

//------------------------------------------------------------------------------


procedure TMainWnd.ResJumpTimerTimer(Sender: TObject);
var
  viewItem: TViewItem;
  Str: String;
begin
  if ResJumpTimer.Tag > 0 then
  begin
    viewItem := GetActiveView;
    if (viewItem <> nil) and (viewItem.thread <> nil) and ResJumpTimer.Enabled then
    begin
      if GetKeyState(VK_CONTROL) < 0 then
      begin
        Str := IntToStr((ResJumpTimer.Tag));
        if Show2chInfo(Mouse.CursorPos, '#' + Str, Str, viewItem, Config.hintNestingPopUp and (not FResJumpNormalPopup)) then
        begin
          FStatusText := '';
          if Assigned(viewItem.PossessionView) then
            viewItem.PossessionView.Enabled := True;
        end;
      end
      else
        viewItem.ScrollToAnchor(ResJumpTimer.Tag -1, true, true);
      ResJumpTimer.Tag := 0;
    end;
  end;
  ResJumpTimer.Enabled := false;
  FResJumpNormalPopup := False;
end;

(* 表示レス数指定 *)
procedure TMainWnd.MenuDrawAllClick(Sender: TObject);
var
  viewItem: TViewItem;
  drawline: integer;
begin
  viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  drawline := viewItem.thread.lines - TMenuItem(Sender).Tag + 1;
  if (drawline < 0) or (viewItem.thread.lines < drawline) then
    drawline := 2;
  viewItem.LocalReload(viewItem.GetTopRes, drawline);
end;

{beginner}
procedure TMainWnd.OnAboutToFormShow(var Message: TMessage);
begin
  if (Message.WParam=0) and (Message.LParam=0) then
  begin
    ImageForm.MainWndOnHide;
    if Assigned(WriteForm) then
      WriteForm.MainWndOnHide;
    if Assigned(ImageViewCacheListForm) then
      ImageViewCacheListForm.MainWndOnHide;
  end
  else if (Message.WParam<>0) then
  begin
    ImageForm.MainWndOnShow;
    if Assigned(WriteForm) then
      WriteForm.MainWndOnShow;
    if Assigned(ImageViewCacheListForm) then
      ImageViewCacheListForm.MainWndOnShow;
  end;

  inherited;
end;
{//beginner}

(* タスクトレイに格納 *)
procedure TMainWnd.MenuWndHideInTaskTrayClick(Sender: TObject);
begin
  if Assigned(WriteForm) then
    WriteForm.MainWndOnHide;
  {aiai}
  if Assigned(AAForm) then
    AAForm.MainWndOnHide;
  if Assigned(LovelyWebForm) then
    LovelyWebForm.MainWndOnHide;
  if Assigned(ImageForm) then
    ImageForm.MainWndOnHide;
  if Assigned(ChottoForm) then
    ChottoForm.MainWndOnHide;
  if Assigned(ImageViewCacheListForm) then
    ImageViewCacheListForm.MainWndOnHide;
  {/aiai}
  Hide;
  ShowWindow(Application.Handle, SW_HIDE);
  TrayIcon.Show;
end;

procedure TMainWnd.MenuOptDumpShortcutClick(Sender: TObject);
begin
  SaveKeyConf;
end;

procedure TMainWnd.MenuHelpAboutClick(Sender: TObject);
begin
  OnAbout;
end;

procedure TMainWnd.actBackExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := GetActiveView;
  if (viewItem <> nil) and viewItem.CanGoBack then
  begin
    viewItem.GoBack;
    //actBack.Enabled := viewItem.CanGoBack;
    //actForword.Enabled := viewItem.CanGoForword;
  end;
end;

procedure TMainWnd.actForwordExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := GetActiveView;
  if (viewItem <> nil) and viewItem.CanGoForword then
  begin
    viewItem.GoForword;
    //actBack.Enabled := viewItem.CanGoBack;
    //actForword.Enabled := viewItem.CanGoForword;
  end;
end;

{beginner} //モーダル表示中に無理やりActivateされたとき
procedure TMainWnd.WMActivate(var Msg: TWMActivate);
var
 ActForm: TCustomForm;
begin
 ActForm := nil;
 if Msg.Active = WA_ACTIVE then
   ActForm := Screen.ActiveCustomForm;
 inherited;
 if Assigned(ActForm) and (ActForm <> Self) then
 begin
   try
     if (fsModal in ActForm.FormState) and ActForm.Visible then
       ActForm.BringToFront;
   except
   end;
 end;
end;

procedure TMainWnd.MenuBoardCheckLogFolderClick(Sender: TObject);
begin
  Memo.Lines.Add('ε三三川；’ー’）ﾛｸﾞﾌｫﾙﾀﾞのｶｸﾆﾝ');
  Memo.Lines.Add(' ');
  i2ch.SearchLogDir(Memo.Lines);
  Log('');
  Log('（’ー’；川ｵｼﾏｲ　三三３');
end;

{beginner} //あぼーんのレベル変更
procedure TMainWnd.actAboneLevelExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  if TAction(Sender).Checked then
    Exit;
  TAction(Sender).Checked:=True;
  AboneLevel := TAction(Sender).Tag;
  viewItem := GetActiveView;
  if Assigned(viewItem) and Assigned(viewItem.thread) then
    viewItem.LocalReload(viewItem.GetTopRes);
end;


{beginner} //スレの再描画コマンド
procedure TMainWnd.DrawLinesButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  viewItem: TViewItem;
begin
  if Button = mbRight then begin
    viewItem := GetActiveView;
    if Assigned(viewItem) and Assigned(viewItem.thread) then begin
      viewItem.LocalReload(viewItem.GetTopRes);
//      UpdateTabTexts;
    end;
  end;
end;


{beginner} //マウスオーバーで画像を開くかどうかの切り替え
procedure TMainWnd.MenuOpenURLOnMouseOverClick(Sender: TObject);
begin
  MenuOpenURLOnMouseOver.Checked := Not(MenuOpenURLOnMouseOver.Checked);
end;


{beginner} //クリップボード監視のオンオフ
procedure TMainWnd.MenuWatchClipboardClick(Sender: TObject);
begin
  if MenuWatchClipboard.Checked then begin
    ChangeClipboardChain(Self.Handle, NextClipBoardViewer);
    NextClipBoardViewer := 0;
    MenuWatchClipboard.Checked := False;
  end else begin
    SetLastError(0);
    NextClipBoardViewer := SetClipboardViewer(Self.Handle);
    if (NextClipBoardViewer <> 0) or (GetLastError = 0) then
      MenuWatchClipboard.Checked := True
    else
      Log('ｸﾘｯﾌﾟﾎﾞｰﾄﾞ監視設定失敗');
  end;

end;


//他のクリップボードビューア削除への対応
procedure TMainWnd.ChangeCBChain(var Message: TWMChangeCBChain);
begin
  if  NextClipBoardViewer = Message.Remove then
    NextClipBoardViewer := Message.Next;
  if NextClipBoardViewer <> 0 then
    SendMessage(NextClipBoardViewer, Message.Msg, Message.Remove, Message.Next);
  inherited;
end;

//クリップボードが2chURLなら開く
procedure TMainWnd.DrawClipboard(var Message: TMessage);
var
  S: String;
begin
  if MenuWatchClipboard.Checked and Clipboard.HasFormat(CF_TEXT) then begin //Checkedを確認するのは、登録直後に一度くるメッセージを無視するため
    S := Clipboard.AsText;
    Log('ｸﾘｯﾌﾟﾎﾞｰﾄﾞ監視中');
    if StartWith('http:', S, 1) then begin
      if NavigateIntoView(S, gtOther) then begin
        Log(Format('ｸﾘｯﾌﾟﾎﾞｰﾄﾞのURL %sを 読み込み', [S]));
      end else if ImageForm.GetImage(S) then begin
        Log(Format('ｸﾘｯﾌﾟﾎﾞｰﾄﾞのURL %sを 読み込み', [S]));
      end;
    end;
  end;
  if NextClipBoardViewer <> 0 then
    SendMessage(NextClipBoardViewer, Message.Msg, Message.WParam, Message.LParam);
  inherited;
end;

procedure TMainWnd.FindThreadButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    MenuClearFindThreadResultClick(Sender);
    restrainContext := true;
  end;
end;


{ayaya}
procedure TMainWnd.LoadTraceString();
var
  i,j :Integer;
  inifile :String;
  list: TStringList;
begin
  traceString[0] := '川 ’ー’川';
  traceString[1] := '川 ’ー’川ｻﾃｵｼｺﾞﾄ･･･　　　ε三三三三川；’ー’）鯖ﾏﾃﾞｵﾂｶｲﾔﾖ';
  traceString[2] := '从*･ ｡.･)ﾉｵﾈｰﾁｬﾝｲｯﾃﾗ-　ε三三三三川；’ー’）鯖ﾏﾃﾞｵﾂｶｲﾔﾖ';
  traceString[3] := '从*･ ｡.･)ﾉｵﾈｰﾁｬﾝｵｶｴﾘ　 鯖ｶﾗﾍﾝｼﾞﾔﾖ（’ー’；川つ□　三三三三３';
  traceString[4] := '从*･ ｡.･)人（’ー’*川ｵﾂｶｲｵﾜﾘﾔﾖ　三三三三３';
  traceString[5] := '川 ’∀ ’∀’川';
  traceString[6] := '川*’ー’）ﾍﾟｹﾀｰ!!';
  traceString[7] := '川 ’ー’川愛たんJaneへようこそ';
  traceString[8] := '川*’ー’）＜ﾃﾞﾊﾞｯｸﾞ用ﾅﾝﾔﾖｰ';
  traceString[9] := '川*’∀’）ﾎﾞｰﾄﾞｲﾁﾗﾝｶﾞﾅｲ･･･';
  traceString[10] := '川*’∀’）ﾎﾞｰﾄﾞｲﾁﾗﾝ ﾄﾘﾆｲｸﾖ';
  traceString[11] := '川 ’ー’川ｵﾌﾗｲﾝ･･･';
  traceString[12] := '川*’∀’）ﾀﾌﾞﾝｾｲｺｳ';
  traceString[13] := '川*’∀’）ｱﾄﾃﾞﾓｳｲﾁﾄﾞｺｳｼﾝｼﾃﾐﾙｶﾞｼ';
  traceString[14] := 'ﾂｲﾋﾞｼｯﾊﾟｲ川 - 。- 川';
  traceString[15] := '川*’ー’） □ ﾅﾆﾅﾆ･･･';
  traceString[16] := '川*’∀’）ｲﾃﾝﾂｲﾋ';
  traceString[17] := '川 ’ー’川新着ﾅｼ';
  traceString[18] := '川*’ー’） □ ﾅﾆﾅﾆ･･･';
  traceString[19] := '川＃’ヘ’）ｳﾜｧｧｧﾝ';
  traceString[20] := '川*’ー’）新着 %d件';
  traceString[21] := '川 T－T）  誰もｶｷｺしてないよ・・・';
  traceString[22] := '川；´Д｀）  誰もｶｷｺしてないよ';
  traceString[23] := '川 - 。- 川　誰もｶｷｺしてない･･･';
  traceString[24] := '川*’∀’）　誰も書いてないよ';
  traceString[25] := '川*’ー’）新着 %d件';
  traceString[26] := '川*’ー’）ｻｲｽﾞｶﾞ合ﾜﾅｲ･･･';
  traceString[27] := '川 ’ー’川ﾅﾝｶｴﾗｰﾔﾖ';
  traceString[28] := '川 ’ー’川ｶｺﾛｰｸﾞ!!';
  traceString[29] := '川 ’ー’川ｲﾏﾔｯﾃﾙﾄｺﾛﾔﾖ!!';
  traceString[30] := '川 ’ー’川.｡oO（IDが必要なんやよ～）';
  traceString[31] := '川 ’ー’川ﾁｭｰｼ!!';
  traceString[32] := 'Qﾆ川 ’ー’川';
  traceString[33] := '川*’ー’）ｱﾄ ';
  traceString[34] := '川*’ー’）ｵﾜﾘ';
  traceString[35] := '川*’ー’）ｱﾄ ';
  traceString[36] := '川*’ー’）ｼﾞｶｲﾊ ';
  traceString[37] := '川*’ー’）ｵﾜﾘ';
  traceString[38] := '川*’ー’）ｱﾄ ';
  traceString[39] := '川*’ー’）φ未読変換(%dﾊﾞｲﾄ)';
  traceString[40] := '川*’ー’）φ既読分変換(%dﾊﾞｲﾄ)';
  traceString[41] := 'ボード一覧更新無し';
  traceString[42] := 'スレ一覧更新中';
  traceString[43] := '看板URL取得中';
  traceString[44] := '取得完了';
  traceString[45] := '取得ｼｯﾊﾟｲ';
  traceString[46] := 'index取得中';
  traceString[47] := 'スレッドタイトル検索中';
  traceString[48] := 'ログ削除中';
  traceString[49] := '川 ’ー’川更新ﾁｪｯｸ開始ｽﾙﾝﾔﾖ';
  traceString[50] := '川 ’ー’川更新ﾁｪｯｸ完了ﾔﾖ';
  traceString[51] := '川*’ー’）ｿﾝﾅﾆﾅｶﾞｸﾅｲﾝﾔﾖ';
  for i:=0 to 51 do useTrace[i] := True;

  inifile := Config.BasePath + 'trace.txt';
  if not FileExists(inifile) then
    exit;
  j := 0;
  list := TStringList.Create;
  list.LoadFromFile(inifile);

  if (list.count > 0) and (list.count < 53) then
  begin
    j := list.count-1;
  end
  else begin
    if list.count > 52 then
      j := 51;
  end;
  for i:=0 to j do
    if list.Strings[i] <> '' then
      traceString[i] := list.Strings[i];
  list.Free;
  for i:=0 to 51 do
    useTrace[i] := (Trim(traceString[i]) <> '');
end;

{aiai}
//タブの色
procedure TMainWnd.TabControlDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  tabControl:TTabControl;
  bitmap: TBitmap;
  imageSize:Integer;        //アイコンの大きさによるテキスト描画開始左位置
  topAddSizeActive:Integer; //タブのアクティブによる描画開始左位置のズレ
  topAddSizeStyle:Integer;  //タブのスタイルによる描画開始左位置のズレ
  strText: String;          //タブに書き出す文字列
  viewItem: TViewitem;
  thread: TThreadItem;
  Point: array[0..2] of TPoint;
begin

  viewItem := viewList.Items[TabIndex];
  thread := viewItem.thread;
  tabControl := TTabControl(Control);
  //スタイルによるズレを調整する。
  //アクティブ＋スタイル(標準のタブはアクティブだとちょっとズレるので調整)
  topAddSizeActive := 0;
  if Active then
    case tabControl.Style of
      tsTabs:       topAddSizeActive := 2; //標準のタブ
      tsFlatButtons:topAddSizeActive := 1; //平らなボタンタブ
    end;
  topAddSizeStyle := 0;
  case tabControl.Style of
    tsTabs:       topAddSizeStyle := 2; //標準のタブ
    tsButtons:    topAddSizeStyle := 2; //ボタンタブ
    tsFlatButtons:topAddSizeStyle := 1; //平らなボタンタブ
  end;

  //ビットマップ表示の場合
  imageSize := 0;
  bitmap := nil;  //こうしないとnilにならず、Free時にエラーとなる（エラーメッセージは出ずに処理が進まなくなる）。Windwos Meだと、これで動かなくなる。
  if tabControl.Images <> nil then begin
    bitmap := TBitmap.Create;
  end;
  try
    if tabControl.Images <> nil then begin
      //ビットマップを読み込む
      ListImages.GetBitmap(3,bitmap); //スレタブ
      imageSize := bitmap.Width;
    end;
    //背景色を描画する
    if (thread <> nil) and thread.datbreak then
      tabControl.Canvas.Brush.Color := $000000FF
    else if active and (AutoReload <> nil) and AutoReload.Enabled then
      tabControl.Canvas.Brush.Color := Config.tclAutoReloadBack
    else if (thread <> nil) and WriteWaitTimer.IsThisHost(thread.GetHost) then
      tabControl.Canvas.Brush.Color := Config.tclWriteWaitBack
    else if Active then
      tabControl.Canvas.Brush.Color := Config.tclActiveBack
    else
      tabControl.Canvas.Brush.Color := Config.tclNoActiveBack;
    tabControl.Canvas.FillRect(Rect);

     //テキストを描画する
    if thread = nil then tabControl.Canvas.Font.Color := Config.tclDefaultText
    else begin
      if thread.Downloading and (viewItem.Progress = tpsProgress) then //更新中
        tabControl.Canvas.Font.Color := Config.tclProcessText
      else if (thread.lines > 0) and (thread.itemCount > thread.lines) then  //まだ読み込んでいないレスがある場合
        tabControl.Canvas.Font.Color := Config.tclNew2Text
      else if thread.lines > thread.anchorline then  //新着があった場合
        tabControl.Canvas.Font.Color := Config.tclNewText
      else if (thread.state = tsComplete) or ( (thread.number <= 0)  and not ThreadIsNew(viewItem.thread) ) then //書けない
        tabControl.Canvas.Font.Color := Config.tclDisableWriteText
      else   //デフォルト
        tabControl.Canvas.Font.Color := Config.tclDefaultText;
    end;
    strText := StringReplace(tabControl.Tabs[TabIndex], '&&', '&', [rfReplaceAll]); //タブ文字列に設定されているタイトルは"&"が"&&"になっているので置換する
    tabControl.Canvas.TextRect(Rect
                              ,Rect.Left + imageSize + 5
                              ,Rect.Top + topAddSizeActive + topAddSizeStyle
                              ,strText);

    //ビットマップを描画する
    if tabControl.Images <> nil then begin
      tabControl.Canvas.Draw(Rect.Left + 3
                            ,Rect.Top + topAddSizeActive
                            ,bitmap);
    end;

    if (thread <> nil) and not thread.canclose then
    begin
      case tabControl.Style of
      tsTabs:
        begin
          point[0].X := Rect.Left + 2; //標準のタブ
          point[0].Y := Rect.Top + 2;
        end;
      tsButtons, tsFlatButtons:
        point[0] := Rect.TopLeft;
      end; //Case
      point[1].X := point[0].X + 5;
      point[1].Y := point[0].Y;
      point[2].X := point[0].X;
      point[2].Y := point[0].Y + 5;
      tabControl.Canvas.Brush.Color := clGray;
      tabControl.Canvas.Pen.Color := clGray;
      tabControl.Canvas.Polygon(point);
    end;
  finally
    if bitmap <> nil then begin
      FreeAndNil(bitmap);
    end;
  end;
end;

procedure TMainWnd.ThreCheckNewResButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
   actCheckNewResAllExecute(Sender);
end;

procedure TMainWnd.MenuAAEditClick(Sender: TObject);
begin
  if AAForm <> nil then
  begin
    AAForm.Free;
    AAForm := nil
  end;
  if AAForm = nil then
  begin
    AAForm := TAAForm.Create(self);
    AAForm.Visible := true;
  end;
end;

procedure TMainWnd.MenuClearHistroy(Sender: TObject);
var
  tag: integer;
begin
  tag := TMenuItem(Sender).Tag;
  case tag of
    1: begin
         if Config.grepSearchList.Count < 1 then begin
           ShowMessage('検索履歴はありません');
           exit;
         end;
         if MyMessageDlg('検索履歴を消去します。よろしいですか？') = mrOK then begin
           Config.grepSearchList.Clear;
           if (GrepDlg <> nil) then
             GrepDlg.Edit.Items.Clear;
           Config.grepSearchList.SaveToFile(Config.BasePath + 'search.dat');
           searchTarget := '';
         end;
       end;
    2: begin //名前欄の履歴消去
         if Config.wrtNameList.Count < 1 then begin
           ShowMessage('名前欄の履歴はありません');
           exit;
         end;
         if MyMessageDlg('名前欄の履歴を消去します。よろしいですか？') = mrOK then begin
           Config.wrtNameList.Clear;
           //NameComboBox.Items := Config.wrtNameList;//aiai-pre
           Config.wrtNameList.SaveToFile(Config.BasePath + 'name.dat');
         end;
       end;
    3: begin //メール欄の履歴消去
         if Config.wrtMailList.Count < 1 then begin
           ShowMessage('メール欄の履歴はありません');
           exit;
         end;
         if MyMessageDlg('メール欄の履歴を消去します。よろしいですか？') = mrOK then begin
           Config.wrtMailList.Clear;
           //MailComboBox.Items := Config.wrtMailList;//aiai-pre
           Config.wrtMailList.SaveToFile(Config.BasePath + 'mail.dat');
         end;
       end;
  else exit;
  end;
end;

//datを名前を付けて保存
procedure TMainWnd.ViewPopupSaveDatClick(Sender: TObject);
var
  datpath: String;
  SaveDialog: TSaveDialog;
begin
  datpath := viewList.Items[tabRightClickedIndex].thread.GetFileName + '.dat';
  SaveDialog := TSaveDialog.Create(Self);
  SaveDialog.FileName := viewList.Items[tabRightClickedIndex].thread.datName + '.dat';
  SaveDialog.Filter := 'すべてのファイル|*';
  if SaveDialog.Execute then
  begin
    if FileExists(SaveDialog.FileName) then
    begin
      if datpath = SaveDialog.FileName then
      begin
        ShowMessage('（ﾟДﾟ）この愚か者めが');
        SaveDialog.Free;
        exit;
      end;
      if Application.MessageBox('上書きしますか？', 'Jane', MB_YESNO) = IDNO then
      begin
        SaveDialog.Free;
        exit;
      end;
    end;
    CopyFile(PChar(datpath), PChar(SaveDialog.FileName), False);
  end;
  SaveDialog.Free;
end;

//datをクリップボードにコピー
procedure TMainWnd.ViewPopupCopyDATClick(Sender: TObject);
var
  viewItem: TViewItem;
  fname, s: String;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem <> nil) and (viewItem.thread <> nil) then
  begin
    fname := viewList.Items[tabRightClickedIndex].thread.GetFileName + '.dat';
    if FileExists(fname) then
      s := fname + #0;
  end;
  if s <> '' then
    CopyToClipboard(s, DROPEFFECT_COPY);
end;

//datとidxをクリップボードにコピー
procedure TMainWnd.ViewPopupCopyDIClick(Sender: TObject);
var
  viewItem: TViewItem;
  fname, s: String;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  s := '';
  if (viewItem <> nil) and (viewItem.thread <> nil) then
  begin
    fname := viewList.Items[tabRightClickedIndex].thread.GetFileName + '.dat';
    if FileExists(fname) then
      s := s + fname + #0;
    fname := viewList.Items[tabRightClickedIndex].thread.GetFileName + '.idx';
    if FileExists(fname) then
      s := s + fname + #0;
  end;
  if s <> '' then
    CopyToClipboard(s, DROPEFFECT_COPY);
end;

//スレのタイトルをコピー
procedure TMainWnd.ViewPopupTITLECopyClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  if tabRightClickedIndex < 0 then
    exit;
  viewItem := viewList.Items[tabRightClickedIndex];
  if assigned(viewItem) and assigned(viewItem.thread) then
  begin
    Clipboard.AsText := HTML2String(viewItem.thread.title);
  end;
end;

procedure TMainWnd.StartAutoReSc;
var
  viewItem: TViewItem;
begin
  viewItem := GetActiveView;

  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;

  (* オートリロード *)
  if AutoReload = nil then
    AutoReload := TAutoReload.Create;
  AutoReload.Interval := Config.oprAutoReloadInterval * 1000;
  AutoReload.Enabled  := true;

  (* オートスクロール *)
  if AutoScroll = nil then
    AutoScroll := TAutoScroll.Create;
  AutoScroll.Interval := Config.oprAutoScrollInterval[Config.oprAutoScrollSpeed];
  AutoScroll.ScrollLines := Config.oprAutoScrollLines[Config.oprAutoScrollSpeed];
  AutoScroll.Enabled := true;
  {if WriteMemo.Visible then
    try WriteMemo.SetFocus; except end;}//aiai-pre
end;

procedure TMainWnd.StopAutoReSc;
begin
  if AutoReload <> nil then begin
    AutoReload.Enabled := false;
  end;
  if AutoScroll <> nil then
  begin
    AutoScroll.Enabled := false;
  end;
  actAutoReSc.Checked := false;
end;

procedure TMainWnd.PauseToggleAutoReSc(bool: Boolean);
begin
  if bool then begin
    if (AutoReload <> nil) and (AutoReload.State = relPause) then AutoReload.Enabled := true;
    if (AutoScroll <> nil) and (AutoScroll.State <> scrStopNormal) then AutoScroll.Enabled := true;
  end else begin
    if (AutoReload <> nil) and (AutoReload.State = relProgress) then AutoReload.Pause;
    if (AutoScroll <> nil) and (AutoScroll.State <> scrStopNormal) then AutoScroll.Pause(scrPauseWriteProgress);
  end;
end;

procedure TMainWnd.AutoReloadCount(Count: Integer = 0);
begin
{  if (AutoReload = nil) or not AutoReload.Enabled then exit;

  if Count = 0 then begin
    AutoReScCount := 0;
    if (AutoScroll <> nil) and (AutoScroll.State <> scrStopNormal) then
      AutoScroll.Enabled := true;
    exit;
  end;

  Inc(AutoReScCount, Count);

  if AutoReScCount >= AUTO_RELOAD_COUNT then begin
    Log('从＇v＇从ﾘﾛｰﾄﾞばっかりしないでよ');
    StopAutoReSc;
  end;}
end;

(* オートスクロール間隔の設定 *)
procedure TMainWnd.ViewPopupScrollSpeedClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := true;

  Config.oprAutoScrollSpeed := TMenuItem(Sender).Tag;

  Config.Modified := true;

  if AutoScroll <> nil then
  begin
    AutoScroll.Interval := Config.oprAutoScrollInterval[Config.oprAutoScrollSpeed];
    AutoScroll.ScrollLines := Config.oprAutoScrollLines[Config.oprAutoScrollSpeed];
  end;
end;

(* ちょっと見る *)
procedure TMainWnd.ListPopupChottoViewClick(Sender: TObject);
var
  item: TListItem;
  chottoURL: string;
begin
  item := ListView.Selected;
  if (item = nil) or (ListView.SelCount > 1) then
    exit;

  chottoURL := TThreadItem(item.Data).ToURL(true, false,Config.optChottoView);

  if chottoURL <> '' then
    OpenChottoForm(chottoURL); (* ちょっと見るを開く (aiai) *)
end;

//rika
procedure TMainWnd.TextPopupChottoViewClick(Sender: TObject);
var
  viewItem: TViewItem;
  chottoURL: string;
begin
  if PopupTextMenu.PopupComponent is THogeTextView then
    viewItem := TViewItem(GetViewOf(PopupTextMenu.PopupComponent))
  else
    viewItem := GetActiveView;
  if viewItem = nil then
    exit;
  chottoURL := viewItem.LinkText;

  if GetKeyState(VK_CONTROL) < 0 then
    chottoURL := chottoURL + Config.optChottoView;

  if chottoURL <> '' then
    OpenChottoForm(chottoURL); (* ちょっと見るを開く (aiai) *)
end;


//↓更新チェック
//２ちゃんねるブラウザ「OpenJane」改造総合スレ10
//http://pc5.2ch.net/test/read.cgi/win/1069005879/949-952
procedure TMainWnd.FavCheckServerDownEnd(Sender: TObject);
var
  index: integer;
  board: TBoard;
begin
  index := 0;
  while index < FavBrdList.Count do
  begin
    board := TBoard(FavBrdList.Items[index]);
    if (board.BBSType = bbs2ch) and
            not CheckServerDownInst.CheckDown(board.host) then
    begin
      Log('【' + board.name + '】：'+board.host+'/'+board.bbs+'：Server Down');
      FavBrdList.Delete(index);
    end else
      Inc(index);
  end;
  FreeAndNil(CheckServerDownInst);
  Log('川 ’ー’川 鯖落ﾁﾁｪｯｸｵﾜﾘ');

  if FavBrdList.Count = 0 then begin
    FavBrdList.Free;
    Log('川；’ー’川ﾅﾆﾓｽﾙｺﾄｶﾞﾅｲ');
  end else begin
    //FavBrdOpen;
    if usetrace[49] then Log(traceString[49])
    else Log('川 ’ー’川更新ﾁｪｯｸｽﾙﾝﾔﾖ');
    FavPtrlManager(FavBrdList.Count, patFavorite, nil);
    FavPatrol(patFavorite);
  end;
end;

procedure TMainWnd.MenuFavPatrolClick(Sender: TObject);
//※[457]
  procedure FavPtrlBrdCreate(favs: TFavoriteList);
  var
    index: integer;
    board: TBoard;
    thread: TThreadItem;
  begin
    for index := 0 to favs.count - 1 do
      if (TObject(favs.Items[index]) is TFavorite) then
      begin
        if Length(TFavorite(favs.Items[index]).datName) > 0 then
        begin
          board := i2ch.FindBoard(TFavorite(favs.Items[index]).host, TFavorite(favs.Items[index]).bbs);
          if (board <> nil) and (FavBrdList.IndexOf(board) < 0) then
          begin
            thread := i2ch.FindThread(TFavorite(favs.Items[index]).category, board.name, TFavorite(favs.Items[index]).datName);
            if (thread <> nil) and (thread.number > 0) then
              FavBrdList.Add(board);
          end;
        end;
      end else
      if (TObject(favs.Items[index]) is TFavoriteList) then
        FavPtrlBrdCreate(TFavoriteList(favs.Items[index]));
  end;

begin
  if not Config.netOnline then
  begin
    Log('川＇-＇）ｵﾌﾗｲﾝﾀﾞﾖ');
    exit;
  end;
  if 0 < FavPtrlCount then
  begin
    Log('川＇-＇）ｲﾏﾔｯﾃﾙﾄｺﾛ');
    exit;
  end;
  FavBrdList := TList.Create;
  FavPtrlFavs := favorites;
  FavPtrlBrdCreate(favorites);

  if Config.optFavPatrolCheckServerDown then
  begin
    CheckServerDownInst := TCheckServerDown.Create;
    CheckServerDownInst.OnResponse := FavCheckServerDownEnd;
    Log('川 ’ー’川 鯖落ﾁﾁｪｰｯｸ');
    if CheckServerDownInst.InitInfo then
      exit
    else begin
      FreeAndNil(CheckServerDownInst);
      Log('川 ’ー’川 鯖落ﾁﾁｪｯｸﾃﾞｷﾝｶｯﾀ');
    end;
  end;

  if FavBrdList.Count = 0 then begin
    FavBrdList.Free;
    Log('川；’ー’川ﾅﾆﾓｽﾙｺﾄｶﾞﾅｲ');
  end else begin
    //FavBrdOpen;
    if usetrace[49] then Log(traceString[49])
    else Log('川 ’ー’川更新ﾁｪｯｸｽﾙﾝﾔﾖ');
    FavPtrlManager(FavBrdList.Count, patFavorite, nil);
    FavPatrol(patFavorite);
  end;
end;

procedure TMainWnd.TabPtrlStart;
  procedure TabPtrlBrdCreate;
  var
    index: integer;
    board: TBoard;
    viewItem: TViewItem;
  begin
    for index := 0 to TabControl.Tabs.Count - 1 do
    begin
      viewItem := viewList.Items[index];
      if (viewItem <> nil) and (viewItem.thread <> nil)
          and (viewItem.thread.number > 0) then
      begin
        board := TBoard(viewItem.thread.board);
        if FavBrdList.IndexOf(board) < 0 then
          FavBrdList.Add(board);
      end;
    end;
  end;

begin
  if not Config.netOnline then
  begin
    Log('川＇-＇）ｵﾌﾗｲﾝﾀﾞﾖ');
    exit;
  end;
  if 0 < FavPtrlCount then
  begin
    Log('川＇-＇）ｲﾏﾔｯﾃﾙﾄｺﾛ');
    exit;
  end;

  FavBrdList := TList.Create;
  TabPtrlBrdCreate;
  if FavBrdList.Count = 0 then
  begin
    FavBrdList.Free;
    Log('川；’ー’川ﾅﾆﾓｽﾙｺﾄｶﾞﾅｲ');
  end
  else begin
    if usetrace[49] then Log(traceString[49])
    else Log('川 ’ー’川更新ﾁｪｯｸｽﾙﾝﾔﾖ');
    FavPtrlManager(FavBrdList.Count, patTab, nil);
    FavPatrol(patTab);
  end;
end;

procedure TMainWnd.FavPatrol(PatrolType: TPatrolType);
var
  board: TBoard;
  index: integer;
begin
  index := 0;

  while index < FavBrdList.Count do
  begin
    board := FavBrdList.Items[index];
    //board.AddRef;
    board.StartAsyncRead(IntToStr(index+1) + '/' + IntToStr(FavBrdList.Count),
                         PatrolType);
    //board.Release;
    Inc(index);
  end;

  FavBrdList.Free;

  MainWnd.TabControl.Refresh;
end;

procedure TMainWnd.FavBrdOpen;
var
  FavoriteListBoard: TFavoriteListBoard;
begin
  FavoriteListBoardAdmin.GarbageCollect;
  if FavPtrlFavs = favorites then
    //お気に入り全体はi2chに板として登録済み
    FavoriteListBoard := TFavoriteListBoard(i2ch.Items[0].Items[1]) //  i2ch.FindBoard('Jane', 'fav'));
  else
    //その他のフォルダの板はFavoriteListBoardAdminで管理
    FavoriteListBoard := FavoriteListBoardAdmin.GetBoard(FavPtrlFavs);
  if FavoriteListBoard <> nil then
  begin
    //ListViewNavigate(FavoriteListBoard, gotLOCAL,  //▼新しいタブで開くか
    //                (Config.oprOpenBoardWNewTab xor (GetKeyState(VK_SHIFT) < 0)));
    FavoriteListBoard.AddRef;
    if (FavoriteListBoard = CurrentBoard) then
    begin

      ListView.OnData := nil;

      currentBoard.SafeClear;
      currentBoard.Load;
      currentBoard.ResetListState;
      ListView.OnData := ListViewData;
      UpdateListView;
      if not Config.optFavPatrolOpenBack then
        SetRPane(ptList);
      exit;
    end else

    begin

      FavoriteListBoard.SafeClear;

      FavoriteListBoard.Load;

      FavoriteListBoard.ResetListState;

    end;


    FavoriteListBoard.AddRef;

    if assigned(requestingBoard) then
    begin
      requestingBoard.Release;
      requestingBoard := nil;
    end;

    subjectReadyEvent.ResetEvent;

    OpenBoard(FavoriteListBoard,
              (Config.oprOpenBoardWNewTab xor (GetKeyState(VK_SHIFT) < 0)),
              not Config.optFavPatrolOpenBack);

    if not Config.optFavPatrolOpenBack then
      SetRPane(ptList);
    FavoriteListBoard.Release;
  end;
end;

procedure TMainWnd.FavPtrlManager(Count: Integer;
                   PatrolType: TPatrolType; board: TBoard);
  procedure OpenAll;
  var
    limit: integer;
    board: TBoard;
    thread: TThreadItem;
    index: integer;
  begin
    board :=  TFavoriteListBoard(i2ch.Items[0].Items[1]);
    if board = nil then exit;

    limit := 0;

    for index := 0 to board.Count - 1 do
    begin
      thread := board.Items[index];
      if (thread.lines > 0) and (thread.itemCount > thread.lines) then
      begin
        ShowSpecifiedThread(thread, gotLOCAL, True, false, true);
        Inc(limit);
        if (Config.ojvOpenNewResThreadLimit > 0) and ( limit > Config.ojvOpenNewResThreadLimit) then
          break;
      end;
    end;
    if limit > 0 then  //開いたスレがあるとき
      SetRPane(ptView);
  end;

begin
  if Count >= 0 then
    FavPtrlCount := Count   //更新する板数
  else
  begin
    Dec(FavPtrlCount);

    {if ((PatrolType = patTab) or (PatrolType = patBoardList))
            and (CurrentBoard = board) then}
    if Assigned(CurrentBoard) and (CurrentBoard = board) then
    begin
      UILock := true;
      currentBoard.ResetListState;
      UpdateListView;
      UILock := false;
    end;

    if (FavPtrlCount = 0) then   //更新ﾁｪｯｸ終わり
    begin
      if PatrolType = patFavorite then
      begin
        if usetrace[50] then Log(tracestring[50])
        else Log('川 ’ー’川更新ﾁｪｯｸ完了ﾔﾖ');

        {currentBoard.ResetListState;
        UpdateListView;}
        FavBrdOpen;
        if Config.optFavPatrolMessageBox then
          MessageBox(Handle, '更新チェック完了！',
                     '更新チェック', MB_ICONASTERISK or MB_OK)
        else
          MessageBeep(MB_ICONASTERISK);

        if Config.optFavPatrolOpenNewResThread then
          OpenAll;
      end else if PatrolType = patTab then
      begin
        if usetrace[50] then Log(tracestring[50])
        else Log('川 ’ー’川更新ﾁｪｯｸ完了ﾔﾖ');
      end else
      begin
        Log('川 ’ー’川全板ﾘﾛｰﾄﾞ完了ﾔﾖ');
      end;
    end;
  end;
end;
//↑更新チェック

//板の全タブリロード
procedure TMainWnd.ThreadListRefreshAll;
var
  Boards, index: integer;
  board: TBoard;
begin
  Boards := boardlist.Count;

  if Boards <= 0 then
    exit;

  FavPtrlManager(Boards, patBoardList, nil);
  index := 0;
  while index < Boards do
  begin
    board := boardlist.Items[index];
    if board is TFunctionalBoard then
    begin
      Log('(' + IntToStr(index+1) + '/' + IntToStr(Boards) + ')' + board.name);
      FavPtrlManager(-1, patBoardList, board);
      Inc(index);
      Continue;
    end;
    //board.AddRef;
    board.StartAsyncRead(IntToStr(index+1) + '/' + IntToStr(Boards),
                         patBoardList);
    //board.Release;
    Inc(index);
  end;

end;

(* スレを既読にする *)
procedure TMainWnd.ViewPopupSetAlreadyClick(Sender: TObject);
var
  viewItem: TViewItem;
  thread: TThreadItem;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if viewItem <> nil then begin
    thread := viewItem.thread;
    if thread <> nil then begin
      thread.oldLines := thread.lines;
      viewItem.LocalReload(viewItem.GetTopRes);
    end;
  end;
end;

(* このタブは閉じない *)
procedure TMainWnd.ViewPopupNotCloseClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := viewList.Items[tabRightClickedIndex];
  if (viewItem <> nil) and (viewItem.thread <> nil) then
  begin
    viewItem.thread.canclose := not viewItem.thread.canclose;
    TabControl.Invalidate;
  end;
end;

//↓すべて開く系
(* 更新のあるスレッドをすべて開く *)
procedure TMainWnd.PopupTreeOpenNewResThreadsClick(Sender: TObject);
var
  index: integer;
  limit: integer;
  thread: TThreadItem;
  board: TBoard;
  node: TTreeNode;
begin
//  if Config.oprGestureBrdClick = gotNOP then
//    exit;

  if PopupTreeClose.Visible or (Sender = MenuListOpenNewResThreads) then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board = nil then
    exit;

  limit := 0;

  for index := 0 to board.Count - 1 do
    begin
      thread := board.Items[index];
      if (thread.lines > 0) and (thread.itemCount > thread.lines) then
      begin
        ShowSpecifiedThread(thread, gotLOCAL, True, false, true);
        Inc(limit);
        if (Config.ojvOpenNewResThreadLimit > 0) and ( limit > Config.ojvOpenNewResThreadLimit) then
          break;
      end;
    end;
  SetRPane(ptView);
end;

(* お気に入りで更新のあるスレッドをすべて開く *)
procedure TMainWnd.PopupTreeOpenNewResFavoritesClick(Sender: TObject);
var
  index: integer;
  limit: integer;
  thread: TThreadItem;
  board: TBoard;
  node: TTreeNode;
begin
//  if Config.oprGestureBrdClick = gotNOP then
//    exit;

  if PopupTreeClose.Visible or (Sender = MenuListOpenNewResFavorites) then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board = nil then
    exit;

  limit := 0;

  for index := 0 to board.Count - 1 do
    begin
      thread := board.Items[index];
      if IsFavorite(thread) and (thread.itemCount > thread.lines) then
      begin
        ShowSpecifiedThread(thread, gotLOCAL, True, false, true);
        Inc(limit);
        if (Config.ojvOpenNewResThreadLimit > 0) and ( limit > Config.ojvOpenNewResThreadLimit) then
          break;
      end;
    end;

  SetRPane(ptView);
end;

(* お気に入りをすべて開く *)
procedure TMainWnd.PopupOpenFavoritesClick(Sender: TObject);
var
  index: integer;
  limit: integer;
  thread: TThreadItem;
  board: TBoard;
  node: TTreeNode;
begin
//  if Config.oprGestureBrdClick = gotNOP then
//    exit;

  if PopupTreeClose.Visible or (Sender = MenuListOpenFavorites) then
    board := TBoard(ListTabControl.Tabs.Objects[tabRightClickedIndex])
  else begin
    node := TreeView.Selected;
    if node = nil then
      exit;
    if TObject(node.Data) is TBoard then
      board := TBoard(node.Data)
    else
      board := nil;
  end;

  if board = nil then
    exit;

  limit := 0;

  for index := 0 to board.Count - 1 do
    begin
      thread := board.Items[index];
      if IsFavorite(thread) then
      begin
        ShowSpecifiedThread(thread, gotLOCAL, True, false, true);
        Inc(limit);
        if (Config.ojvOpenNewResThreadLimit > 0) and ( limit > Config.ojvOpenNewResThreadLimit) then
          break;
      end;
    end;

  SetRPane(ptView);
end;
//↑すべて開く系

(* Lovely Web Browswerを呼ぶ *)
procedure TMainWnd.OpenByLovelyBrowser(URI: String = '');
begin
  if (LovelyWebForm <> nil) and not LovelyWebForm.Visible then
  begin
    LovelyWebForm.Visible := true;
  end;
  if LovelyWebForm = nil then
  begin
    LovelyWebForm := TLovelyWebForm.Create(self);
    LovelyWebForm.Visible := true;
  end;
  if URI <> '' then
    LovelyWebForm.WebBrowser.Navigate(URI)
  else begin
    LovelyWebForm.WebBrowser.GoHome;
  end;
  if LovelyWebForm.Visible then
    LovelyWebForm.SetFocus;
end;

procedure TMainWnd.LovelyBrowser1Click(Sender: TObject);
begin
  OpenByLovelyBrowser;
end;

(* スレタイ右クリックで1ポップアップ *)
(*「ひんと」の設定にかかわらず、ポップアップし、多段を許す *)
procedure TMainWnd.ThreadTitleLabelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  viewItem: TBaseViewItem;
begin
  if (Button = mbRight) then
  begin
    viewItem := GetActiveView;
    if (viewItem = nil) or (viewItem.thread = nil) then
      exit;
    viewItem.Lock;
    try
      HintTimer.Enabled := false;
      restrainContext := true;
      if Show2chInfo(Mouse.CursorPos, '#1', '1', viewItem, true) then
        if Assigned(viewItem.PossessionView) then
        begin
          viewItem.PossessionView.Enabled := true;
          viewItem.PossessionView.OwnerCofirmation := true;
        end
      else
        ReleasePopupHint(viewItem, True);
    finally
      viewItem.UnLock;
    end;
  end;
end;

(* すべてのタブのリロード *)
procedure TMainWnd.actCheckNewResAllExecute(Sender: TObject);
var
  i: integer;
begin
  if TabControl.Tabs.Count = 0 then
    exit;

  for i:=0 to TabControl.Tabs.Count-1 do
  begin
    if (viewList.Items[i] = nil)
       or (viewList.Items[i].thread = nil)
       or (viewList.Items[i].thread.state = tsComplete)
       or not ((0 < viewList.Items[i].thread.number)
                  or ThreadIsNew(viewList.Items[i].thread)) then
      Continue;
    viewList.Items[i].thread.anchorLine := viewList.Items[i].thread.lines;
    viewList.Items[i].NewRequest(viewList.Items[i].thread, gotCHECK, -1, false,
                    Config.oprCheckNewWRedraw xor (GetKeyState(VK_SHIFT) < 0));
    UpdateTabTexts;
    SetRPane(ptView);
  end;
end;

(* すべてのタブの更新チェック *)
procedure TMainWnd.actTabPtrlExecute(Sender: TObject);
begin
  TabPtrlStart;
end;

//↓ニュース機能
procedure TMainWnd.MenuOptUseNewsClick(Sender: TObject);
begin
  MenuOptUseNews.Checked := not MenuOptUseNews.Checked;
  Config.tstUseNews := MenuOptUseNews.Checked;
  CreateNewsBar;
  Config.Modified := true;
end;

procedure TMainWnd.MenuOptSetNewsIntervalClick(Sender: TObject);
begin
  if MyNews <> nil then
    MyNews.OpenSettingDlg;
end;

procedure TMainWnd.MenuOptSetNewsSizeClick(Sender: TObject);
//var
//  bs: Integer;
begin
  if MyNews <> nil then
  begin
    {bs := StatusBar2.PartWidth[0] + StatusBar2.PartWidth[1]
      + StatusBar2.PartWidth[2] + Config.tstNewsBarSize;}

    MyNews.OpenSizeSettingDlg;

    {StatusBar2.PartWidth[2] := bs - StatusBar2.PartWidth[0] -
      StatusBar2.PartWidth[1] - Config.tstNewsBarSize;}
    Statusbar.Panels.Items[2].Width := StatusBar.ClientWidth
      - Statusbar.Panels.Items[0].Width
        - Statusbar.Panels.Items[1].Width
          - Config.tstNewsBarSize;
  end;
end;

procedure TMainWnd.CreateNewsBar;
begin
  if Config.tstUseNews then
   begin
    if MyNews = nil then begin
      MyNews := TNews.Create;
      MyNews.OnNews := MyNewsNews;
      //StatusBar2.Parts := 4;
      if StatusBar.Panels.Count <> 4 then
        TStatusPanel.Create(StatusBar.Panels);
    end;
    MyNews.setChangeNewsTimerInterval(Config.tstNewsInterval * 1000);
    MyNews.resetChangeNewsTimer;
  end else
  begin
    if Assigned(MyNews) then
      FreeAndNil(MyNews);
    if StatusBar.Panels.Count = 4 then
      StatusBar.Panels.Items[3].Free;
  end;
end;

procedure TMainWnd.MyNewsNews(Sender: TObject; News: String);
begin
  //StatusBar2.Text[3] := News;
  StatusBar.Panels.Items[3].Text := News;
end;
//↑ニュース機能

procedure TMainWnd.ToolBarUrlEditResize(Sender: TObject);
begin
  UrlEdit.Width := ToolBarUrlEdit.Width;
end;

procedure TMainWnd.MenuBoardListClick(Sender: TObject);
begin
 if (Config.optEnableBoardMenu and (MenuBoardList.IndexOf(MenuBoardSep) <= 0)) or
     (not Config.optEnableBoardMenu) then
    UpdateBoardMenu;
end;

(* ちょっと見るを開く (aiai) *)
//chottoURLは呼び出し側で設定しておく
procedure TMainWnd.OpenChottoForm(chottoURL: String);
begin                                           //なければ作る
  if not Assigned(ChottoForm) then
    ChottoForm := TChottoForm.Create(Self);

  if chottoURL <> ChottoForm.URL then            //要求されたURLと設定されている
    ChottoForm.URL := chottoURL;                 //URLが異なる場合

  ChottoForm.Visible := true;
  ChottoForm.SetFocus;
end;

(* スレッドあぼーん *)
procedure TMainWnd.actThreadAboneExecute(Sender: TObject);
var
  listItem: TListItem;
  thread: TThreadItem;
//  viewItem: TViewItem;
//  index: Integer;
  deletelist: TList;
begin
  if CurrentBoard is TFunctionalBoard then Exit;

  listItem := ListView.Selected;
  thread := nil;

  UILock := True;
  StopAutoReSc;

  deleteList := TList.Create;

  while (listItem <> nil) and (listItem.Data <> thread) do begin
    thread := TThreadItem(listItem.Data);
    deleteList.Add(thread);
    listItem := ListView.GetNextItem(listItem, sdBelow, [isSelected]);
  end;
  CurrentBoard.ThreadAbone(deleteList, TAction(Sender).Tag);
  deleteList.Free;

  ListView.DoubleBuffered := True;

  ThreadAboneFilter;

  ListView.Repaint;
  ListView.DoubleBuffered := False;
  UpdateTabTexts;

  UILock := False;
end;

(* スレッドあぼーん解除 *)
procedure TMainWnd.actThreadAbone2Execute(Sender: TObject);
var
  listItem: TListItem;
  thread: TThreadItem;
  index: Integer;
  threadABoneList: TStringList;
begin
  if (CurrentBoard = nil) or (CurrentBoard is TFunctionalBoard) then Exit;

  listItem := ListView.Selected;
  thread := nil;

  UILock := True;
  StopAutoReSc;

  threadABoneList := TStringList.Create;
  if FileExists(CurrentBoard.LogDir + '\subject.abn') then
    threadABoneList.LoadFromFile(CurrentBoard.LogDir + '\subject.abn')
  else
  begin
    threadABoneList.Free;
    exit;
  end;

  while (listItem <> nil) and (listItem.Data <> thread) do begin
    thread := TThreadItem(listItem.Data);
    if (thread <> nil) and (thread.ThreAboneType and TThreABNFLAG = TThreABNFLAG) then
    begin
      index := threadABoneList.IndexOfName(thread.datName);
      if index >= 0 then
        threadABoneList.Delete(index);
      thread.ThreAboneType := 0;
    end;
    listItem := ListView.GetNextItem(listItem, sdBelow, [isSelected]);
  end;

  if threadABoneList.Count > 0 then
    threadABoneList.SaveToFile(CurrentBoard.LogDir + '\subject.abn')
  else
    SysUtils.DeleteFile(CurrentBoard.LogDir + '\subject.abn');
  threadABoneList.Free;

  ListView.DoubleBuffered := True;

  ThreadAboneFilter;

  ListView.Repaint;
  ListView.DoubleBuffered := False;
  UpdateTabTexts;

  UILock := False;
end;

procedure TMainWnd.MenuImageViewOpenCacheListClick(Sender: TObject);
begin
  if not Assigned(ImageViewCacheListForm) then
    ImageViewCacheListForm := TImageViewCacheListForm.Create(self);
  ImageViewCacheListForm.Visible := true;
end;

procedure TMainWnd.UpdateListViewColumns;
var
  i: integer;
  iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(Config.IniPath);

  for i := 0 to ListView.Columns.Count -1 do
    iniFile.WriteInteger(INI_WIN_SECT,
                         'Column' + IntToStr(ListView.Column[i].Tag),
                         ListView.Column[i].Width);

  while High(Config.stlClmnArray) >= ListView.Columns.Count do
    ListView.Columns.Add;

  ListView.Items.BeginUpdate;
  SetUpColumns;

  for i := 0 to ListView.Columns.Count -1 do
    ListView.Column[i].Width := iniFile.ReadInteger(INI_WIN_SECT,
                                'Column' + IntToStr(ListView.Column[i].Tag),
                                ListView.Column[i].Width);
  ListView.Items.EndUpdate;
  iniFile.Free;
end;

procedure TMainWnd.MenuListRefreshAllClick(Sender: TObject);
begin
  ThreadListRefreshAll;
end;

procedure TMainWnd.PopupTaskTrayCloseClick(Sender: TObject);
begin
  TrayIcon.Hide;
  Close;
end;

procedure TMainWnd.PopupTaskTrayRestoreClick(Sender: TObject);
begin
  MainWndRestore;
end;

procedure TMainWnd.TrayIconMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    MainWndRestore;
  end;
end;

procedure TMainWnd.MainWndRestore;
begin
  //TrayIcon.Hide;
  ShowWindow(Application.Handle,SW_SHOW);
  Show;
  Application.Restore;
  if Assigned(WriteForm) then
    WriteForm.MainWndOnShow;
  {aiai}
  if Assigned(AAForm) then
    AAform.MainWndOnShow;
  if Assigned(LovelyWebForm) then
    LovelyWebForm.MainWndOnShow;
  if Assigned(ImageForm) then
    ImageForm.MainWndOnShow;
  if Assigned(ChottoForm) then
    ChottoForm.MainWndOnShow;
  if Assigned(ImageViewCacheListForm) then
    ImageViewCacheListForm.MainWndOnShow;
  {/aiai}
  SetFocus;
end;



//▼ 板ツリーの表示切替

//TreeViewとFavoriteViewの切り替え
procedure TMainWnd.SetTabSetIndex(index: integer);
begin
  if (index < 0) or (1 < index) then
    exit;

  case index of
  0:
    begin
      TreeView.DoubleBuffered := True;
      TreeView.BringToFront;
      TreeView.Repaint;
      TreeView.DoubleBuffered := False;
      LabelTreeTitle.Caption := '  板一覧';
      TreeView.TabStop := true;
      FavoriteView.TabStop := false;
      try TreeView.SetFocus; except end;
    end;
  1:
    begin
      FavoriteView.DoubleBuffered := True;
      FavoriteView.BringToFront;
      FavoriteView.Repaint;
      FavoriteView.DoubleBuffered := False;
      LabelTreeTitle.Caption := '  お気に入り';
      FavoriteView.TabStop := true;
      TreeView.TabStop := false;
      try FavoriteView.SetFocus; except end;
    end;
  end;

  if TreeTabControl.TabIndex <> index then
    TreeTabControl.TabIndex := index;

end;

//TreePanelの表示切替
procedure TMainWnd.ToggleTreePanel(AVisible: Boolean);
begin
  if TreePanel.Visible = AVisible then
    exit;

  if AVisible then
  begin
    TreePanel.Visible := True;
    actTreeToggleVisible.Checked := True;
    SideBar.Checked := True;
    BoardSplitter.Visible := not TreePanelCanMove;
    BoardSplitter.Left := TreePanel.BoundsRect.Right;
  end else
  begin
    TreePanel.Visible := False;
    BoardSplitter.Visible := False;
    actTreeToggleVisible.Checked := False;
    SideBar.Checked := False;
  end;
end;

//CanMove切り替え
procedure TMainWnd.ToggleTreePanelCanMove(ACanMove: Boolean);
var
  ws: Integer;
begin
  if ACanMove then
  begin
    TreePanelFixedWidth := TreePanel.Width;
    ws := GetWindowLong(TreePanel.Handle, GWL_STYLE);
    ws := ws or WS_THICKFRAME;
    SetWindowLong(TreePanel.Handle, GWL_STYLE, ws);
    ToolButtonTreeTitleCanMove.PictureIndex := 2;
    TreePanel.Align := alNone;
    BoardSplitter.Visible := False;
    TreePanel.BoundsRect := TreePanelHoverRect;
    MenuBoardCanMove.Checked := True;
    MenuBoardRestore.Visible := True;
    TreePanel.BringToFront;
  end else
  begin
    TreePanelHoverRect := TreePanel.BoundsRect;
    ws := GetWindowLong(TreePanel.Handle, GWL_STYLE);
    ws := ws and (not WS_THICKFRAME);
    SetWindowLong(TreePanel.Handle, GWL_STYLE, ws);
    ToolButtonTreeTitleCanMove.PictureIndex := 1;
    TreePanel.Width := TreePanelFixedWidth;
    TreePanel.Align := alLeft;
    BoardSplitter.Left := TreePanel.BoundsRect.Right;
    BoardSplitter.Visible := TreePanel.Visible;
    MenuBoardCanMove.Checked := False;
    MenuBoardRestore.Visible := False;
    if WritePanel.Visible then
      WritePanel.BringToFront;
  end;
  SetWindowPos(TreePanel.Handle, 0, 0, 0, 0, 0, 0
    or SWP_FRAMECHANGED
    or SWP_NOACTIVATE
    or SWP_NOMOVE
    or SWP_NOOWNERZORDER
    or SWP_NOSIZE
    or SWP_NOZORDER);
end;


//各種イベントハンドラ
procedure TMainWnd.TreeTabControlChange(Sender: TObject);
begin
  SetTabSetIndex(TreeTabControl.TabIndex);
end;

procedure TMainWnd.MenuViewTreeToggleVisibleClick(Sender: TObject);
begin
  ToggleTreePanel(not TreePanel.Visible);
  if TreePanel.Visible then
    SetTabSetIndex(TreeTabControl.TabIndex);
end;

procedure TMainWnd.MenuWndBoardClick(Sender: TObject);
begin
  tag := TComponent(Sender).Tag;

  TreeTabControl.TabIndex := tag;
  if not TreePanel.Visible then
    ToggleTreePanel(True);

  SetTabSetIndex(TreeTabControl.TabIndex);
end;

procedure TMainWnd.PanelTitlePanelClick(Sender: TObject);
begin
  //閉じるボタン
  if TJLToolButton(Sender) = ToolButtonTreeTitleClose then
    ToggleTreePanel(False)
  //オートハイド切り替えボタン
  else if TJLToolButton(Sender) = ToolButtonTreeTitleCanMove then
  begin
    TreePanelCanMove := not TreePanelCanMove;
    ToggleTreePanelCanMove(TreePanelCanMove);
  end;
end;

procedure TMainWnd.MenuBoardCanMoveClick(Sender: TObject);
begin
  TreePanelCanMove := not TreePanelCanMove;
  ToggleTreePanelCanMove(TreePanelCanMove);
end;

procedure TMainWnd.TreePanelEnter(Sender: TObject);
begin
  PanelTreeTitle.Color := clActiveCaption;
  if TreePanelCanMove then
    TreePanel.BringToFront;
end;

procedure TMainWnd.TreePanelExit(Sender: TObject);
begin
  PanelTreeTitle.Color := clInActiveCaption;
end;

procedure TMainWnd.LabelTreeTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if TreeTabControl.TabIndex = 0 then
    try TreeView.SetFocus; except end
  else
    try FavoriteView.SetFocus; except end;

  if not TreePanelCanMove then
    exit;

  TreePanelOriginalX := X;
  TreePanelOriginalY := Y;
  TreePanelMouseDowned := True;
end;

procedure TMainWnd.LabelTreeTitleMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  newLeft, newTop: Integer;
begin
  if not TreePanelMouseDowned then
    exit;

  if Panel1.ClientWidth < TreePanel.Width then
    TreePanel.Left := 0
  else
  begin
    newLeft := TreePanel.Left + X - TreePanelOriginalX;
    if newLeft < 0 then
      newLeft := 0
    else if newLeft + TreePanel.Width > Panel1.ClientWidth then
      newLeft := Panel1.ClientWidth - TreePanel.Width;
    TreePanel.Left := newLeft;
  end;

  if Panel1.ClientHeight < TreePanel.Height then
    TreePanel.Top := 0
  else
  begin
    newTop := TreePanel.Top + Y - TreePanelOriginalY;
    if newTop < 0 then
      newTop := 0
    else if newTop + TreePanel.Height > Panel1.ClientHeight then
      newTop := Panel1.ClientHeight - TreePanel.Height;
    TreePanel.Top := newTop;
  end;

  TreePanel.Update;
  Panel1.Update;
end;

procedure TMainWnd.LabelTreeTitleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TreePanelMouseDowned := False;
end;


procedure TMainWnd.ToolButtonTreeTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if TreeTabControl.TabIndex = 0 then
    try TreeView.SetFocus; except end
  else
    try FavoriteView.SetFocus; except end;
end;

procedure TMainWnd.TreePanelResize(Sender: TObject);
begin
  if TreePanelCanMove then
  begin
   if TreePanel.Width < 20 then
     TreePanel.Width := 20;
   if TreePanel.Height < 20 then
     TreePanel.Height := 20;
  end;
end;

//万が一、板ツリーが行方不明になったときのために
procedure TMainWnd.MenuBoardRestoreClick(Sender: TObject);
begin
  TreePanel.BoundsRect := Bounds(10, 10, 150, 300);
end;

//▲ 板ツリーの表示切替


//▼ 書き込みパネルの表示切替

procedure TMainWnd.ToggleWritePanelVisible(AVisible: Boolean);
var
  viewItem: TViewItem;
begin
  if AVisible then
  begin
    ToggleWritePanelTabSheet(0);
    ToolButtonWriteTitleAutoHide.PictureIndex := 1 + Integer(WritePanelCanMove);
    StatusBarWrite.Visible := not Config.wrtDisableStatusBar;
    StatusBarWrite.Top := WritePanel.Height;
  end else
  begin
    viewItem := GetActiveView;
    if viewItem <> nil then
      try
        viewItem.browser.SetFocus;
      except
      end;
  end;

  WritePanel.Visible := AVisible;
  WritePanelSplitter.Visible := AVisible and not WritePanelCanMove;
  WritePanelSplitter.Top := WritePanel.Top - WritePanelSplitter.Height;
  if AVisible and not WritePanelPos then
    SetTracePosition;
end;

procedure TMainWnd.ToggleWritePanelTabSheet(AIndex: Integer);
begin
end;

//CanMove切り替え
procedure TMainWnd.ToggleWritePanelCanMove(ACanMove: Boolean);
var
  ws: Integer;
begin
  ws := GetWindowLong(WritePanel.Handle, GWL_STYLE);
  if WritePanelCanMove then
  begin
    WritePanelFixedHeight := WritePanel.Height;
    WritePanel.Align := alNone;
    WritePanel.Parent := Panel1;
    ToolButtonWriteTitleAutoHide.PictureIndex := 2;
    WritePanelSplitter.Visible := False;
    WritePanel.BoundsRect := WritePanelHoverRect;
    ws := ws or WS_THICKFRAME;
  end else
  begin
    WritePanelHoverRect := WritePanel.BoundsRect;
    WritePanel.Height := WritePanelFixedHeight;
    WritePanel.Align := alBottom;
    ToolButtonWriteTitleAutoHide.PictureIndex := 1;
    WritePanelSplitter.Visible := True;
    WritePanelSplitter.Top := WritePanel.Top - WritePanelSplitter.Height;
    ws := ws and not WS_THICKFRAME;
  end;
  SetWindowLong(WritePanel.Handle, GWL_STYLE, ws);
  SetWindowPos(WritePanel.Handle, 0, 0, 0, 0, 0, 0
    or SWP_FRAMECHANGED
    or SWP_NOACTIVATE
    or SWP_NOMOVE
    or SWP_NOOWNERZORDER
    or SWP_NOSIZE
    or SWP_NOZORDER);
end;

//位置の変更
procedure TMainWnd.ToggleWritePanelPos(APos: Boolean);
begin
  if APos then
  begin
    WritePanel.Parent := WebPanel;
    WritePanelSplitter.Parent := WebPanel;
  end else
  begin
    WritePanel.Parent := ListViewPanel;
    WritePanelSplitter.Parent := ListViewPanel;
  end;
end;

procedure TMainWnd.ToolButtonWriteTitleAutoHideClick(Sender: TObject);
begin
  WritePanelCanMove := not WritePanelCanMove;
  ToggleWritePanelPos(WritePanelPos);
  ToggleWritePanelCanMove(WritePanelCanMove);
  ToggleWritePanelVisible(WritePanel.Visible);
end;

procedure TMainWnd.PopupWritePanelPopup(Sender: TObject);
begin
  MenuWritePanelCanMove.Checked := WritePanelCanMove;
  MenuWritePanelPos.Checked := WritePanelPos;
  MenuWritePanelDisableStatusBar.Checked := Config.wrtDisableStatusBar;
  MenuWritePanelPos.Enabled := not WritePanelCanMove;
  MenuWritePanelDisableTopBar.Checked := not WritePanelTitle.Visible;
end;

procedure TMainWnd.MenuMemoClick(Sender: TObject);
begin
  MenuMemoCanMove.Checked := WritePanelCanMove;
  MenuMemoPos.Checked := WritePanelPos;
  MenuMemoDisableStatusBar.Checked := Config.wrtDisableStatusBar;
  MenuMemoPos.Enabled := not WritePanelCanMove;
  MenuWriteMemoDisableTopBar.Checked := not WritePanelTitle.Visible;
  MenuMemoRestore.Visible := WritePanelCanMove;
end;


procedure TMainWnd.ToolButtonWriteTitleCloseClick(Sender: TObject);
begin
  ToggleWritePanelVisible(False);
end;

procedure TMainWnd.ToolButtonWriteTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  try WritePanel.SetFocus; except end;
  try MemoWriteMain.SetFocus; except end;
end;

procedure TMainWnd.LabelWriteTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Point: TPoint;
begin
  try WritePanel.SetFocus; except end;
  try MemoWriteMain.SetFocus; except end;
  if (not WritePanelCanMove) or (Button <> mbLeft) then
    exit;

  Point := LabelWriteTitle.ScreenToClient(Mouse.CursorPos);
  WritePanelOriginalX := Point.X;
  WritePanelOriginalY := Point.Y;
  WritePanelMouseDowned := True;
end;

procedure TMainWnd.LabelWriteTitleMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  newTop, newLeft: Integer;
begin
  if not WritePanelMouseDowned then
    exit;

  if Panel1.ClientWidth < WritePanel.Width then
    WritePanel.Left := 0
  else
  begin
    newLeft := WritePanel.Left + X - WritePanelOriginalX;
    if newLeft < 0 then
      newLeft := 0
    else if newLeft + WritePanel.Width > Panel1.ClientWidth then
      newLeft := Panel1.ClientWidth - WritePanel.Width;
    WritePanel.Left := newLeft;
  end;

  if Panel1.ClientHeight < WritePanel.Height then
    WritePanel.Top := 0
  else
  begin
    newTop := WritePanel.Top + Y - WritePanelOriginalY;
    if newTop < 0 then
      newTop := 0
    else if newTop + WritePanel.Height > Panel1.ClientHeight then
      newTop := Panel1.ClientHeight - WritePanel.Height;
    WritePanel.Top := newTop;
  end;

  WritePanel.Update;
  Panel1.Update;

end;

procedure TMainWnd.LabelWriteTitleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    WritePanelMouseDowned := False;
end;

procedure TMainWnd.MenuViewClick(Sender: TObject);
begin
  MenuViewWriteMemoToggleVisible.Checked := WritePanel.Visible;
end;


procedure TMainWnd.WritePanelEnter(Sender: TObject);
begin
  if WritePanelCanMove then
    WritePanel.BringToFront;
  WritePanelTitle.Color := clActiveCaption;
  //SetFocusToWriteMemo;
end;

procedure TMainWnd.WritePanelExit(Sender: TObject);
begin
  WritePanelTitle.Color := clInActiveCaption;
end;

procedure TMainWnd.MenuWritePanelPosClick(Sender: TObject);
begin
  if not WritePanel.Visible then
    exit;

  WritePanelPos := not WritePanelPos;
  ToggleWritePanelPos(WritePanelPos);
  ToggleWritePanelVisible(WritePanel.Visible);
end;

procedure TMainWnd.MenuWritePanelDisableStatusBarClick(Sender: TObject);
begin
  Config.wrtDisableStatusBar := not Config.wrtDisableStatusBar;
  Config.Modified := True;
  ToggleWritePanelVisible(WritePanel.Visible);
end;


procedure TMainWnd.MenuWritePanelDisableTopBarClick(Sender: TObject);
begin
  WritePanelTitle.Visible := not WritePanelTitle.Visible;
end;

//万が一メモ欄が行方不明になったときのために
procedure TMainWnd.MenuMemoRestoreClick(Sender: TObject);
begin
  WritePanel.BoundsRect := Bounds(10, 10, 200, 150);
end;



//▲ 書き込みパネルの表示切替



//スレ欄にドラッグ＆ドラップでログ追加
procedure TMainWnd.ListViewDropFiles(Sender: TObject; FileList: TStringList);
var
  board: TBoard;
  i: Integer;
  flist: TStringList;
begin
  board := CurrentBoard;
  if (board = nil) or (board is TFunctionalBoard) then
    exit;

  flist := TStringList.Create;

  for i := 0 to FileList.Count - 1 do
  begin
    if ExtractFileExt(FileList.Strings[i]) = '.dat' then
      flist.Add(FileList.Strings[i]);
  end;

  Application.BringToFront;
  MessageBeep($FFFFFFFF);
  if (flist.Count = 0) or (MessageDlg('【' + HTML2String(board.name) + '】に'
            + #13#10#13#10 + flist.Text + #13#10
            + 'を追加します。よろしいですか？',
              mtConfirmation, mbOKCancel, 0) = mrCancel) then
  begin
    flist.Free;
    exit;
  end;

  i := 0;
  while i < flist.Count do
  begin
    if not CopyFile(PChar(flist.Strings[i]),
        PChar(board.LogDir + '\' + ExtractFileName(flist.Strings[i])), True) then
    begin
      Log('川；’ー’）＜'+flist.Strings[i] + 'のコピーに失敗しちゃった');
      flist.Delete(i);
      Continue;
    end;
    Inc(i);
  end;

  board.MergeCacheFrequency(flist);

  UpdateListView;

  flist.Free;
end;


//▼ ステータスバー
{procedure TMainWnd.StatusBar2Click(Sender: TObject);
begin
  ToggleWritePanelVisible(not WritePanel.Visible);
  if WritePanel.Visible then
    JLTabControlMouseDown(JLTabWrite, mbLeft, [], 0, 0);
end;}

procedure TMainWnd.StatusBarClick(Sender: TObject);
begin
  ToggleWritePanelVisible(not WritePanel.Visible);
  if WritePanel.Visible then
  begin
    PageControlWrite.ActivePage := TabSheetWriteMain;
    try MemoWriteMain.SetFocus; except end;
  end;
end;

{procedure TMainWnd.StatusBar2RClick(Sender: TObject);
var
  Point: TPoint;
begin
  if not GetCursorPos(Point) then exit;
  if InvalidPoint(Point) then exit;

  PopupStatusBar.Popup(Point.X, Point.Y);
end;}

procedure TMainWnd.StatusBarResize(Sender: TObject);
begin
  StatusBar.Panels.Items[2].Width := StatusBar.ClientWidth
    - StatusBar.Panels.Items[0].Width
      - StatusBar.Panels.Items[1].Width
        - Config.tstNewsBarSize;
end;

{procedure TMainWnd.StatusBar2ReSize(Sender: TObject; Width: Integer);
begin
  StatusBar2.PartWidth[2] := Width - StatusBar2.PartWidth[0] -
    StatusBar2.PartWidth[1] - Config.tstNewsBarSize;
end;}

procedure TMainWnd.PopupStatusBarPopup(Sender: TObject);
var
  i: integer;
begin
  if Assigned(MyNews) then
  begin
    MyNews.TempBuffer := MyNews.NewsURI;
    MenuStatusOpenByBrowser.Caption := MyNews.NewsText + 'をブラウザーで開く(&B)';
    MenuStatusOpenByLovelyBrowser.Caption := MyNews.NewsText + 'をLovelyBrowserで開く(&L)';
    MenuStatusCopyURI.Caption := MyNews.NewsText + 'のURLをコピー(&C)';
    MenuStatusOpenByBrowser.Visible := True;
    MenuStatusOpenByLovelyBrowser.Visible := True;
    MenuStatusCopyURI.Visible := True;
    MenuStatusReset.Visible := True;
    i := PopupStatusBar.Items.IndexOf(MenuStatusCmdSep);
    for i := i + 1 to PopupStatusBar.Items.Count - 1 do
      PopupStatusBar.Items[i].Visible := True;
  end else
  begin
    MenuStatusOpenByBrowser.Visible := False;
    MenuStatusOpenByLovelyBrowser.Visible := False;
    MenuStatusCopyURI.Visible := False;
    MenuStatusReset.Visible := False;
    i := PopupStatusBar.Items.IndexOf(MenuStatusCmdSep);
    for i := i + 1 to PopupStatusBar.Items.Count - 1 do
      PopupStatusBar.Items[i].Visible := False;
  end;
end;

procedure TMainWnd.MenuStatusOpenByBrowserClick(Sender: TObject);
begin
  OpenByBrowser(MyNews.TempBuffer);
end;

procedure TMainWnd.MenuStatusOpenByLovelyBrowserClick(Sender: TObject);
begin
  OpenByLovelyBrowser(MyNews.TempBuffer);
end;

procedure TMainWnd.MenuStatusCopyURIClick(Sender: TObject);
begin
 Clipboard.AsText := MyNews.TempBuffer;
end;

procedure TMainWnd.MenuStatusResetClick(Sender: TObject);
begin
  Config.tstUseNews := false;
  CreateNewsBar;
  Config.tstUseNews := true;
  CreateNewsBar;
end;

//▲ ステータスバー


//▼ MDI

procedure TMainWnd.actMaxViewExecute(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := GetActiveView;
  if Assigned(viewItem) then
    if viewList.ViewMaximize(viewItem) then begin
      actMaxView.ImageIndex := 11;
      actMaxView.Hint := '元のサイズに戻す';
    end else begin
      actMaxView.ImageIndex := 12;
      actMaxView.Hint := '最大化';
    end;
end;

procedure TMainWnd.MenuWindowCascadeClick(Sender: TObject);
begin
  viewList.ViewCascade;
  actMaxView.ImageIndex := 12;
  actMaxView.Hint := '最大化';
end;

procedure TMainWnd.MenuWindowTileVerticallyClick(Sender: TObject);
begin
  viewList.ViewTile(False);
  actMaxView.ImageIndex := 12;
  actMaxView.Hint := '最大化';
end;

procedure TMainWnd.MenuWindowTileHorizontallyClick(Sender: TObject);
begin
  viewList.ViewTile(True);
  actMaxView.ImageIndex := 12;
  actMaxView.Hint := '最大化';
end;

procedure TMainWnd.MenuWindowRestoreAllClick(Sender: TObject);
begin
  viewList.ViewAllRestore;
  actMaxView.ImageIndex := 12;
  actMaxView.Hint := '最大化';
end;

procedure TMainWnd.MenuWindowMaximizeAllClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := GetActiveView;
  if Assigned(viewItem) and Assigned(viewItem.browser) then
  begin
    viewList.ViewAllMaximize(viewItem.browser);
    actMaxView.ImageIndex := 11;
    actMaxView.Hint := '元のサイズに戻す';
  end;
end;

procedure TMainWnd.BrowserActive(Sender: TObject);
var
  viewItem: TViewItem;
  Index: Integer;
begin
  if not (Sender is TMDITextView) then
    exit;
  viewItem := viewList.FindViewitem(TComponent(Sender));
  if viewItem <> nil then begin
    Index := viewList.IndexOf(viewItem);
    if Index > -1 then begin
      TabControl.TabIndex := Index;
      UpdateCurrentView(Index);
      ViewItemStateChanged;
      StopAutoReSc;
    end;
  end;
end;

//procedure TMainWnd.BrowserHide(Sender: TObject);
//var
//  index: Integer;
//begin
//  if not (Sender is TMDITextView) then
//    exit;
//
//  index := tabControl.TabIndex;
//  case Config.oprClosetPos of
//
//    tcpLeft: begin
//      if index > 0 then
//        SetCurrentView(index - 1)
//      else
//        SetCurrentView(0);
//    end;
//
//    else // tcpRight;
//      if index < tabControl.Tabs.Count - 1 then
//        SetCurrentView(index + 1)
//      else if index > 0 then
//        SetCurrentView(index - 1)
//      else
//        SetCurrentView(index);  //このbrowserをカレントにする
//
//  end;  //Case
//
//end;

procedure TMainWnd.MenuThreSysMoveClick(Sender: TObject);
var
  viewItem: TViewItem;
  browser: TMDITextView;
begin
  viewItem := GetActiveView;
  if Assigned(viewItem) and Assigned(viewItem.browser) then
  begin
    browser := TMDITextView(viewItem.browser);
    browser.Perform(WM_SYSCOMMAND, SC_MOVE, 0);
  end;
end;

procedure TMainWnd.MenuThreSysResizeClick(Sender: TObject);
var
  viewItem: TViewItem;
  browser: TMDITextView;
begin
  viewItem := GetActiveView;
  if Assigned(viewItem) and Assigned(viewItem.browser) then
  begin
    browser := TMDITextView(viewItem.browser);
    browser.Perform(WM_SYSCOMMAND, SC_SIZE, 0);
  end;
end;

procedure TMainWnd.PopupThreSysPopup(Sender: TObject);
var
  viewItem: TViewItem;
  browser: TMDITextView;
begin
  viewItem := GetActiveView;
  if Assigned(viewItem) and Assigned(viewItem.browser) then
  begin
    browser := TMDITextView(viewItem.browser);
    MenuThreSysMove.Visible := browser.WndState = MTV_NOR;
    MenuThreSysResize.Visible := browser.WndState = MTV_NOR;
  end else
  begin
    MenuThreSysMove.Visible := False;
    MenuThreSysResize.Visible := False;
  end;
end;

//▲ MDI

//▼検索

(* 検索 *)
procedure TMainWnd.MenuFindClick(Sender: TObject);
var
  target: string;
  viewItem: TViewItem;
begin
  if TreeView.Focused or FavoriteView.Focused
    or TreeViewSearchEditBox.Focused then
  begin
    TreeViewSearchToolBar.Visible := true;
    try
      TreeViewSearchEditBox.SetFocus;
    except end;
    exit;
  end else if ListView.Focused
    or (Config.oprToggleRView and (mdRPane = ptList))
      or ListViewSearchEditBox.Focused then
  begin
    ListViewSearchToolBar.Visible := true;
    try
      ListViewSearchEditBox.SetFocus;
    except end;
    exit;
  end else
  begin
    viewItem := GetActiveView;
    if viewItem <> nil then
    begin
      target := viewItem.GetSelection;
      if target <> '' then
        ThreViewSearchEditBox.Text := target;
    end;
    ThreViewSearchToolBar.Visible := true;
    try
      ThreViewSearchEditBox.SetFocus;
    except end;
    exit;
  end;
end;

(* 順方向検索 *)
procedure TMainWnd.FindNextClick(Sender: TObject);
begin
  if TreeView.Focused or FavoriteView.Focused
    or TreeViewSearchEditBox.Focused then
    FindInTree(true)
  else if ListView.Focused
    or (Config.oprToggleRView and (mdRPane = ptList))
      or ListViewSearchEditBox.Focused then
    FindInList(true)
  else
    FindInView(true);
end;

(* 逆方向検索 *)
procedure TMainWnd.FindPrevClick(Sender: TObject);
begin
  if TreeView.Focused or FavoriteView.Focused
    or TreeViewSearchEditBox.Focused then
    FindInTree(false)
  else if ListView.Focused
    or (Config.oprToggleRView and (mdRPane = ptList))
      or ListViewSearchEditBox.Focused then
    FindInList(false)
  else
    FindInView(false);
end;

const
  SEARCH_OPTION_NORMAL = 0;
  SEARCH_OPTION_MIGEMO = 1;
  SEARCH_OPTION_REGEXP = 2;

function InitializeSearchKeywordList(const KeywordText: String; SearchMode: Byte;
  var keywordList: TStringList; var RegExp: TRegExp;
  var RegMode, MigemoMode: Boolean): Boolean;
var
  str: PChar;
  i: integer;
begin
  Result := False;

  if Length(KeywordText) <= 0 then
    exit;

  keywordList := TStringList.Create;

  if Config.schMultiWord then
  begin
    keywordList.Delimiter := #$20;
    keywordList.DelimitedText := ReplaceStr(KeywordText, #$81#$40, #$20);
  end else
    keywordList.Add(KeywordText);

  if keywordList.Count = 0 then
  begin
    keywordList.Free;
    exit;
  end;

  SearchTarget := KeywordText;

  i := Length(KeywordText);
  str := PChar(KeywordText);
  if (SearchMode = SEARCH_OPTION_MIGEMO) and Config.schEnableMigemo
    and MigemoOBJ.CanUse and NumAlpha(str, i) then
  begin
    RegMode := True;
    MigemoMode := True;
    for i := 0 to keywordList.Count - 1 do
    begin
      str := MigemoOBJ.Query(keywordList.Strings[i]);
      keywordList.Delete(i);
      keywordList.Insert(i, str);
      MigemoOBJ.Release(str);
    end;
  end else if (SearchMode = SEARCH_OPTION_REGEXP) then
  begin
    RegMode := True;
    MigemoMode := False;
  end else
  begin
    if Config.schIgnoreFullHalf then
      keywordList.Text := StrUnify(keywordList.Text);
    RegMode := False;
    MigemoMode := False;
  end;

  if RegMode then
  begin
    RegExp := TRegExp.Create(nil);
    RegExp.IgnoreCase := True;
  end else
    RegExp := nil;

  Result := True;
end;

type
  SRESULT = (SEARCH_OK, SEARCH_FAIL, SEARCH_REGERR, SEARCH_NOMATCH);

function SearchFromKeywordList(const KeywordList: TStrings;
  const TargetText: String; RegExp: TRegExp): SRESULT;
var
  i: integer;
begin

  if not Assigned(KeywordList) then
  begin
    Result := SEARCH_FAIL;
    exit;
  end;

  for i := 0 to KeywordList.Count - 1 do
  begin

    if Assigned(RegExp) then
    begin
      try
        RegExp.Pattern := KeywordList.Strings[i];
        if RegExp.Test(TargetText) then
        begin
          Result := SEARCH_OK;
          exit;
        end;
      except
        on E: Exception do begin
          Log('SearchFromTargetList: ' + e.Message);
          Result := SEARCH_REGERR;
          exit;
        end;
      end;
    end else
    begin
//      if 0 < AnsiPos(KeywordList.Strings[i], TargetText) then
      if AnsiContainsText(TargetText, KeywordList.Strings[i]) then
      begin
        Result := SEARCH_OK;
        exit;
      end;
    end;

  end;

  Result := SEARCH_NOMATCH;
end;

//板ツリー内検索
procedure TMainWnd.FindInTree(forwardP: boolean);
var
  i: integer;
  tree: TTreeView;
  node: TTreeNode;
  KeywordList: TStringList;
  RegMode: Boolean;
  MigemoMode: Boolean;
  RegExp: TRegExp;
  target: string;
begin
  TreeViewSearchEditBox.Color := clWindow;

  if not InitializeSearchKeywordList(TreeViewSearchEditBox.Text,
    TreeViewSearchEditBox.Tag, KeywordList, RegExp, RegMode, MigemoMode) then
    exit;

  if TreeTabControl.TabIndex = 1 then
    tree := FavoriteView
  else
    tree := TreeView;

  node := tree.Selected;
  if node = nil then
  begin
    if ForwardP then
      i := 0
    else
      i := tree.Items.Count - 1;
  end else
  begin
    if forwardP then
      i := node.AbsoluteIndex + 1
    else
      i := node.AbsoluteIndex - 1;
  end;

  while (ForwardP and (i < tree.Items.Count)) or (not ForwardP and (i > -1)) do
  begin

    node := tree.Items[i];

    if Config.schIgnoreFullHalf and (not RegMode or MigemoMode) then
    begin
      if MigemoMode then
        target := StrUnify2(node.Text)
      else
        target := StrUnify(node.Text);
    end else
      target := node.Text;

    case SearchFromKeywordList(KeywordList, target, RegExp) of

      SEARCH_OK: begin
        tree.Selected := nil;
        tree.Selected := tree.Items[i];
        if Assigned(RegExp) then
          RegExp.Free;
        KeywordList.Free;
        exit;
      end;

      SEARCH_FAIL: begin
        if Assigned(RegExp) then
          RegExp.Free;
        KeywordList.Free;
        exit;
      end;

      SEARCH_REGERR: begin
        RegExp.Free;
        KeywordList.Free;
        TreeViewSearchEditBox.Color := $D0FFFF;
        exit;
      end;

      SEARCH_NOMATCH:;

    else
      if Assigned(RegExp) then
        RegExp.Free;
      KeywordList.Free;
      exit;
    end;

    if ForwardP then Inc(i) else Dec(i);
  end;

  if Assigned(RegExp) then
    RegExp.Free;
  KeywordList.Free;
  TreeViewSearchEditBox.Color := $CCCCFF;
end;

//スレ欄内検索
procedure TMainWnd.FindInList(forwardP: boolean);
var
  i: integer;
  item: TListItem;
  keywordList: TStringList;
  RegMode: Boolean;
  MigemoMode: Boolean;
  RegExp: TRegExp;
  target: string;
  strDatOut: TStrDatOut;
label
  DONE;
begin
  ListViewSearchEditBox.Color := clWindow;

  if CurrentBoard = nil then
    exit;

  if not InitializeSearchKeywordList(ListViewSearchEditBox.Text,
    ListViewSearchEditBox.Tag, keywordList, RegExp, RegMode, MigemoMode) then
    exit;

  item := ListView.ItemFocused;
  if item = nil then
  begin
    if ForwardP then
      i := 0
    else
      i := ListView.Items.Count - 1;
  end else
  begin
    if ForwardP then
      i := item.Index + 1
    else
      i := item.Index - 1;
  end;

  StrDatOut := TStrDatOut.Create;

  while (ForwardP and (i < ListView.Items.Count)) or (not ForwardP and (i > -1)) do
  begin

    StrDatOut.Clear;
    StrDatOut.WriteHTML(TThreadItem(ListView.List[i]).title);

    if Config.schIgnoreFullHalf and (not RegMode or MigemoMode) then
    begin
      if MigemoMode then
        target := StrUnify2(StrDatOut.Text)
      else
        target := StrUnify(StrDatOut.Text);
    end else
      target := StrDatOut.Text;

    case SearchFromKeywordList(keywordList, target, RegExp) of

      SEARCH_OK: begin
        ListView.Selected := nil;
        ListViewSelectIntoView(ListView.Items[i]);
        if Assigned(RegExp) then
          RegExp.Free;
        keywordList.Free;
        StrDatOut.Free;
        exit;
      end;

      SEARCH_FAIL: begin
        if Assigned(RegExp) then
          RegExp.Free;
        keywordList.Free;
        StrDatOut.Free;
        exit;
      end;

      SEARCH_REGERR: begin
        RegExp.Free;
        keywordList.Free;
        StrDatOut.Free;
        ListViewSearchEditBox.Color := $D0FFFF;
        exit;
      end;

      SEARCH_NOMATCH:;

    else
      if Assigned(RegExp) then
        RegExp.Free;
      keywordList.Free;
      StrDatOut.Free;
      exit;
    end;

    if ForwardP then Inc(i) else Dec(i);
  end;

  if Assigned(RegExp) then
    RegExp.Free;
  keywordList.Free;
  StrDatOut.Free;
  ListViewSearchEditBox.Color := $CCCCFF;
end;

//スレ内検索
procedure TMainWnd.FindInView(forwardP: boolean);
var
  viewItem: TViewItem;
  str: PChar;
  i, j: integer;
  keywordList: TStringList;
  hloption: THighLightOption;
begin
  ThreViewSearchEditBox.Color := clWindow;

  viewItem := GetActiveView;
  if (viewitem = nil) or (viewItem.thread = nil) then
    exit;

  if (Length(ThreViewSearchEditBox.Text) = 0) then
  begin
    viewItem.browser.SearchClear;
    exit;
  end;

  SearchTarget := ThreViewSearchEditBox.Text;

  keywordList := TStringList.Create;

  if Config.schMultiWord then
  begin
    keywordList.Delimiter := #$20;
    keywordList.DelimitedText := ReplaceStr(SearchTarget, #$81#$40, #$20);
  end else
    keywordList.Add(SearchTarget);

  if keywordList.Count = 0 then
  begin
    keywordList.Free;
    exit;
  end;

  hloption := hloNormal;

  j := Length(SearchTarget);
  str := PChar(SearchTarget);
  if (ThreViewSearchEditBox.Tag = 1)
    and Config.schEnableMigemo and MigemoOBJ.CanUse and NumAlpha(str, j) then
  begin
    hloption := hloReg;
    for i := 0 to keywordList.Count - 1 do
    begin
      str := MigemoOBJ.Query(keywordList[i]);
      keywordList.Delete(i);
      keywordList.Insert(i, str);
      MigemoOBJ.Release(str);
    end;
  end else if (ThreViewSearchEditBox.Tag = 2) then
    hloption := hloReg;

  try
    if ForwardP then
    begin
      if not viewItem.browser.SearchForward(keywordList, hloption) then
        ThreViewSearchEditBox.Color := $CCCCFF;
    end else
    begin
      if not viewItem.browser.SearchBackward(keywordList, hloption) then
        ThreViewSearchEditBox.Color := $CCCCFF;
    end;
  except
    on E: Exception do begin
      Log('TMainWnd.FindInView: ' + E.Message);
      ThreViewSearchEditBox.Color := $D0FFFF;
    end;
  end;

  keywordList.Free;
end;

//スレ絞込み
procedure TMainWnd.ListViewSearchNarrowing;
var
  target: string;
  i, j: Integer;
  keywordList: TStringList;
  RegExp: TRegExp;
  RegMode, MigemoMode: Boolean;
  r: boolean;
  strDatOut: TStrDatOut;
begin
  ListViewSearchEditBox.Color := clWindow;

  if currentBoard = nil then
    exit;

  if not InitializeSearchKeywordList(ListViewSearchEditBox.Text,
    ListViewSearchEditBox.Tag, keywordList, RegExp, RegMode, MigemoMode) then
  begin
    ListviewSearchEnd(True);
    exit;
  end;

  strDatOut := TStrDatOut.Create;

  for i := 0 to keywordList.Count - 1 do
  begin

    if Assigned(RegExp) then
      try
        RegExp.Pattern := keywordList.Strings[i];
      except
        on E: Exception do
        begin
          ListviewSearchEnd(True);
          ListViewSearchEditBox.Color := $D0FFFF;
          Log('TMainWnd.ListViewSearchNarrowing: ' + E.Message);
          RegExp.Free;
          keywordList.Free;
          strDatOut.Free;
          exit;
        end;
      end;

    r := false;

    for j := 0 to ListView.Items.Count - 1 do
    begin

      if (i > 0) and (TThreadItem(ListView.List[j]).liststate = 0) then
        Continue;

      StrDatOut.Clear;
      StrDatOut.WriteHTML(TThreadItem(ListView.List[j]).title);

      if Config.schIgnoreFullHalf and (not RegMode or MigemoMode) then
      begin
        if MigemoMode then
          target := StrUnify2(StrDatOut.Text)
        else
          target := StrUnify(StrDatOut.Text);
      end else
        target := StrDatOut.Text;

      if Assigned(RegExp) then
        try
          if RegExp.Test(target) then
            TThreadItem(ListView.List[j]).liststate := 1
          else
            TThreadItem(ListView.List[j]).liststate := 0;
        except
          on E: Exception do
          begin
            ListviewSearchEnd(True);
            ListViewSearchEditBox.Color := $D0FFFF;
            Log('TMainWnd.ListViewSearchNarrowing: ' + E.Message);
            RegExp.Free;
            keywordList.Free;
            strDatOut.Free;
            exit;
          end;
        end
//      else if (AnsiPos(keywordList.Strings[i], target) > 0) then
      else if AnsiContainsText(target, keywordList.Strings[i]) then
        TThreadItem(ListView.List[j]).liststate := 1
      else
        TThreadItem(ListView.List[j]).liststate := 0;

      if TThreadItem(ListView.List[j]).liststate = 1 then
        r := true;
    end;

    if not r then
    begin
      ListViewSearchEditBox.Color := $CCCCFF;
      break;
    end;
  end;

  if Assigned(RegExp) then
    RegExp.Free;
  keywordList.Free;
  strDatOut.Free;
  ListviewSearchEnd(False);
end;

procedure TMainWnd.ListviewSearchEnd(error: Boolean);
var
  i: Integer;
begin
  if error then
  begin
    ListView.DoubleBuffered := True;
    for i := 0 to ListView.Items.Count - 1 do
      TThreadItem(ListView.List[i]).liststate := 0;
    ListView.Sort(@ListCompareFuncSearchState);
    ListView.SetTopItem(ListView.Items[0]);
    currentSortColumn := Config.stlDefSortColumn;
    ListView.Repaint;
    ListView.DoubleBuffered := False;
  end else
  begin
    ListView.DoubleBuffered := True;
    ListView.Sort(@ListCompareFuncSearchState);
    ListView.SetTopItem(ListView.Items[0]);

    currentBoard.threadSearched := (TThreadItem(ListView.Items[0].Data).liststate <> 0);
    if currentBoard.threadSearched then
      currentSortColumn := 100
    else begin
      currentSortColumn := 1;
    end;
    ListView.Repaint;
    ListView.DoubleBuffered := False;
  end;
end;

//レス抽出

procedure TMainWnd.ExtractRes(IncludeRef: Boolean);
var
  viewItem: TViewItem;
  GrepMode: Byte;
  MigemoMode: Boolean;
  str: PChar;
  size: integer;
begin
  viewItem := GetActiveView;
  if (viewItem = nil) or (viewItem.thread = nil) then
    exit;
  if Length(ThreViewSearchEditBox.Text) > 0 then
    SearchTarget := ThreViewSearchEditBox.Text
  else if Length(SearchTarget) = 0 then
    exit;
  MigemoMode := False;
  case ThreViewSearchEditBox.Tag of
    SEARCH_OPTION_NORMAL: GrepMode := Byte(Config.schMultiWord) * GREP_OPTION_OR;
    SEARCH_OPTION_MIGEMO: begin
      GrepMode := Byte(Config.schMultiWord) * GREP_OPTION_OR;
      if Config.schEnableMigemo and MigemoOBJ.CanUse then
      begin
        size := Length(SearchTarget);
        str := PChar(SearchTarget);
        MigemoMode := NumAlpha(str, size);
      end;
    end;
    SEARCH_OPTION_REGEXP: GrepMode := GREP_OPTION_REGEXP;
  else
    GrepMode := GREP_OPTION_NORMAL;
  end;

  NewView(true).ExtractKeyword(SearchTarget, viewItem.thread, GrepMode,
    IncludeRef, MigemoMode);
end;

//▲検索

//Migemo初期化
procedure TMainWnd.InitMigemo;
var
  DicPath: String; //'\つきpath';
begin
  if Length(Config.schMigemoDic) > 0 then
    DicPath := ExtractFilePath(Config.schMigemoDic);
  MigemoOBJ := TMigemo.Create(Config.schMigemoPath,
                              Config.schMigemoDic,
                              DicPath + 'roma2hira.dat',
                              DicPath + 'hira2kata.dat',
                              DicPath + 'han2zen.dat');
end;

procedure TMainWnd.SearchSetSearch(index: integer; EditBox: TComboBox;
  Button: TToolButton);
begin
  EditBox.Tag := index;
  SearchTimer.Enabled := False;
  case index of
  SEARCH_OPTION_NORMAL: begin  //通常検索
    EditBox.OnChange := SearchEditBoxChange;
    Button.ImageIndex := 0;
  end;
  SEARCH_OPTION_MIGEMO: begin  //Migemo
    if Config.schEnableMigemo and MigemoOBJ.CanUse then
      Button.ImageIndex := 1
    else
      Button.ImageIndex := 3;
    EditBox.OnChange := SearchEditBoxChange;
  end;
  SEARCH_OPTION_REGEXP: begin  //正規表現
    EditBox.OnChange := nil;
    Button.ImageIndex := 2;
  end;
  else
  end;
end;

//▼ 共通イベントハンドラ

procedure TMainWnd.SearchTimerTimer(Sender: TObject);
var
  cb: TComboBox;
begin
  SearchTimer.Enabled := False;
  cb := TComboBox(SearchTimer.Tag);
  if cb = ThreViewSearchEditBox then
    FindInView(True)
  else if cb = ListViewSearchEditBox then
    ListViewSearchNarrowing
  else if cb = TreeViewSearchEditBox then
    FindInTree(True);
end;

procedure TMainWnd.SearchEditBoxChange(Sender: TObject);
begin
  SearchTimer.Enabled := False;
  SearchTimer.Tag := Integer(Sender);
  SearchTimer.Enabled := Config.schIncremental
    and (TComponent(Sender).Tag <> SEARCH_OPTION_REGEXP);
end;

procedure TMainWnd.SearchEditBoxKeyPress(Sender: TObject;
  var Key: Char);
var
  cb: TComboBox;
begin
  if Ord(Key) = VK_RETURN then
  begin
    SearchTimer.Enabled := False;
    cb := TComboBox(Sender);
    if cb = ThreViewSearchEditBox then
      FindInView(True)
    else if cb = ListViewSearchEditBox then
      ListViewSearchNarrowing
    else if cb = TreeViewSearchEditBox then
      FindInTree(True);
    Key := #0;
  end;
end;

procedure TMainWnd.PopupSearchPopup(Sender: TObject);
var
  cb: TComboBox;
begin
  if TPopupMenu(Sender).PopupComponent is TComboBox then
    cb := TPopupMenu(Sender).PopupComponent as TComboBox
  else if TPopupMenu(Sender).PopupComponent = TreeViewSearchToolBar then
    cb := TreeViewSearchEditBox
  else if TPopupMenu(Sender).PopupComponent = ListViewSearchToolBar then
    cb := ListViewSearchEditBox
  else if TPopupMenu(Sender).PopupComponent = ThreViewSearchToolBar then
    cb := ThreViewSearchEditBox
  else
    exit;

  MenuSearchCopy.Enabled := Length(cb.SelText) > 0;
  MenuSearchCut.Enabled := MenuSearchCopy.Enabled;
  MenuSearchPaste.Enabled := ClipBoard.HasFormat(CF_TEXT);
  MenuSearchSelectAll.Enabled := Length(cb.Text) > 0;
  MenuSearchClear.Enabled := MenuSearchSelectAll.Enabled;
  MenuSearchMultiWord.Checked := Config.schMultiWord;
  MenuSearchIncremental.Checked := Config.schIncremental;
  MenuSearchIgnoreFullHalf.Checked := Config.schIgnoreFullHalf;

  case cb.Tag of
    SEARCH_OPTION_NORMAL: MenuSearchNormal.Checked := True;
    SEARCH_OPTION_MIGEMO: MenuSearchMigemo.Checked := True;
    SEARCH_OPTION_REGEXP: MenuSearchRegExp.Checked := True;
  end;

  MenuSearchExtract.Visible := cb = ThreViewSearchEditBox;
  MenuSearchExtractTree.Visible := MenuSearchExtract.Visible;

end;

procedure TMainWnd.MenuSearchItemClick(Sender: TObject);
var
  pc: TComponent;
  cb: TComboBox;

begin
  pc := PopupSearch.PopupComponent;
  if pc <> nil then
  begin
    PopupSearch.PopupComponent := nil;
    if  pc is TComboBox then
      cb := pc as TComboBox
    else if pc = TreeViewSearchToolBar then
      cb := TreeViewSearchEditBox
    else if pc = ListViewSearchToolBar then
      cb := ListViewSearchEditBox
    else if pc = ThreViewSearchToolBar then
      cb := ThreViewSearchEditBox
    else
      exit;
  end else
  begin
    if ThreViewSearchEditBox.Focused then
      cb := ThreViewSearchEditBox
    else if ListViewSearchEditBox.Focused then
      cb := ListViewSearchEditBox
    else if TreeViewSearchEditBox.Focused then
      cb := TreeViewSearchEditBox
    else
      exit;
  end;

  case TComponent(Sender).Tag of
    0, 1: if cb = ThreViewSearchEditBox then  //レス抽出
      ExtractRes(TComponent(Sender).Tag = 1);
    2: if cb = ThreViewSearchEditBox then  //前方検索
         FindInView(True)
       else if cb = ListViewSearchEditBox then
         FindInList(True)
       else if cb = TreeViewSearchEditBox then
        FindInTree(True);
    3: if cb = ThreViewSearchEditBox then  //後方検索
         FindInView(False)
       else if cb = ListViewSearchEditBox then
         FindInList(False)
       else if cb = TreeViewSearchEditBox then
         FindInTree(False);
    4: cb.Perform(WM_COPY, 0, 0);          //コピー
    5: cb.Perform(WM_CUT, 0, 0);           //切り取り
    6: cb.Perform(WM_PASTE, 0, 0);         //貼り付け
    7: cb.SelectAll;                       //すべて選択
    8: cb.Text := '';                      //クリア
    9, 10, 11:
      if cb = ThreViewSearchEditBox then
        SearchSetSearch(TComponent(Sender).Tag - 9, cb, ThreViewSearchToolButton)
      else if cb = ListViewSearchEditBox then
        SearchSetSearch(TComponent(Sender).Tag - 9, cb, ListViewSearchToolButton)
      else if cb = TreeViewSearchEditBox then
        SearchSetSearch(TComponent(Sender).Tag - 9, cb, TreeViewSearchToolButton);
    12: Config.schIncremental := not Config.schIncremental;
    13: Config.schMultiWord := not Config.schMultiWord;
    14: Config.schIgnoreFullHalf := not Config.schIgnoreFullHalf;
    15:
      if cb = ThreViewSearchEditBox then
        ThreViewSearchToolBar.Hide
      else if cb = ListViewSearchEditBox then
        ListViewSearchToolBar.Hide
      else if cb = TreeViewSearchEditBox then
        TreeViewSearchToolBar.Hide;
  end;
end;

//▲ 共通イベントハンドラ

//▼ スレ絞込み

procedure TMainWnd.ListViewSearchToolButtonClick(Sender: TObject);
var
  i: integer;
begin
  i := ListViewSearchEditBox.Tag;
  if i = 2 then i := 0 else Inc(i);
  SearchSetSearch(i, ListViewSearchEditBox, ListViewSearchToolButton);
end;

procedure TMainWnd.ListViewSearchToolBarResize(Sender: TObject);
begin
  ListViewSearchEditBox.Width := ListViewSearchToolBar.ClientWidth
    - ListViewSearchCloseButton.Width
      - ListViewSearchToolButton.Width - ListViewSearchSep.Width;
end;

procedure TMainWnd.ListViewSearchCloseButtonClick(Sender: TObject);
begin
  ListViewSearchToolBar.Hide;
end;

//▲ スレ絞込み

//▼ スレ内検索

procedure TMainWnd.ThreViewSearchUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  SearchTimer.Enabled := False;
  FindInView(Button = btPrev);
end;

procedure TMainWnd.ThreViewSearchToolButtonClick(Sender: TObject);
var
  i: integer;
begin
  i := ThreViewSearchEditBox.Tag;
  if i = 2 then i := 0 else Inc(i);
  SearchSetSearch(i, ThreViewSearchEditBox, ThreViewSearchToolButton);
end;

procedure TMainWnd.ThreViewSearchToolBarResize(Sender: TObject);
begin
  ThreViewSearchEditBox.Width := ThreViewSearchToolBar.ClientWidth
    - ThreViewSearchToolButton.Width - ThreViewSearchUpDown.Width
      - ThreViewSearchResFindButton.Width - ThreViewSearchCloseButton.Width
        - ThreViewSearchSep1.Width - ThreViewSearchSep2.Width
          - ThreViewSearchSep3.Width;
end;

procedure TMainWnd.ThreViewSearchCloseButtonClick(Sender: TObject);
begin
  ThreViewSearchToolBar.Hide;
end;

//▲ スレ内検索

//▼ 板ツリー検索

procedure TMainWnd.TreeViewSearchToolBarResize(Sender: TObject);
begin
  TreeViewSearchEditBox.Width := TreeViewSearchToolBar.ClientWidth
    - 38;//TreeViewSearchToolButton.Width;
end;

procedure TMainWnd.TreeViewSearchToolButtonClick(Sender: TObject);
var
  i: integer;
begin
  i := TreeViewSearchEditBox.Tag;
  if i = 2 then i := 0 else Inc(i);
  SearchSetSearch(i, TreeViewSearchEditBox, TreeViewSearchToolButton);
end;

//▲ 板ツリー検索

//▼ UrlEditのメニュー

procedure TMainWnd.PopupUrlEditPopup(Sender: TObject);
begin
  MenuUrlEditUndo.Enabled := UrlEdit.CanUndo;
  MenuUrlEditCut.Enabled := UrlEdit.SelLength > 0;
  MenuUrlEditCopy.Enabled := MenuUrlEditCut.Enabled;
  MenuUrlEditPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
  MenuUrlEditPasteAndGo.Enabled := MenuUrlEditPaste.Enabled;
  MenuUrlEditDelete.Enabled := Length(UrlEdit.Text) > 0;
  MenuUrlEditSelectAll.Enabled := MenuUrlEditDelete.Enabled;
end;

procedure TMainWnd.MenuUrlEditUndoClick(Sender: TObject);
begin
  UrlEdit.Undo;
end;

procedure TMainWnd.MenuUrlEditCutClick(Sender: TObject);
begin
  UrlEdit.CutToClipboard;
end;

procedure TMainWnd.MenuUrlEditCopyClick(Sender: TObject);
begin
  UrlEdit.CopyToClipboard;
end;

procedure TMainWnd.MenuUrlEditPasteClick(Sender: TObject);
begin
  UrlEdit.PasteFromClipboard;
end;

procedure TMainWnd.MenuUrlEditPasteAndGoClick(Sender: TObject);
begin
  UrlEdit.PasteFromClipboard;
  if ImageForm.GetImage(UrlEdit.Text) then begin
    exit;
  end;
  if GetKeyState(VK_CONTROL) < 0 then
    OpenByBrowser(UrlEdit.Text)
  else
    NavigateIntoView(UrlEdit.Text, gtOther, false, Config.oprAddrBgOpen);
end;

procedure TMainWnd.MenuUrlEditDeleteClick(Sender: TObject);
begin
  SendMessage(UrlEdit.Handle, WM_KEYDOWN, VK_DELETE, 0);
end;

procedure TMainWnd.MenuUrlEditSelectAllClick(Sender: TObject);
begin
  UrlEdit.SelectAll;
end;

//▲ UrlEditのメニュー

//▼ WriteWaitTimerのイベントハンドラ
procedure TMainWnd.WriteWaitTimerNotify(Sender: TObject; DomainName: String;
  Remainder: Integer);
begin
  WritePanelControl.WriteWaitNotify(DomainName, Remainder);
  if Assigned(WriteForm) then WriteForm.WriteWaitNotify(DomainName, Remainder);
end;

procedure TMainWnd.WriteWaitTimerEnd(Sender: TObject);
begin
  TabControl.Refresh;
  WritePanelControl.WriteWaitEnd;
  if Assigned(WriteForm) then WriteForm.WriteWaitEnd;
  MainWnd.TabControl.Refresh;
end;

//▲ WriteWaitTimerのイベントハンドラ

//▼ もっと変えたいβ
procedure TMainWnd.PopupTreeCustomSkinClick(Sender: TObject);
var
  uri, section: string;
  str: TStringList;
  i: integer;
  viewItem: TViewItem;
begin
  if (CurrentBoard <> nil) and not (CurrentBoard is TFunctionalBoard)
    and (CurrentBoard.CustomSkinIndex <> TMenuItem(Sender).Tag) then
  begin
    uri := CurrentBoard.URIBase;
    if length(uri) <= 0 then
      exit;
    CurrentBoard.CustomSkinIndex := TMenuItem(Sender).Tag;
    if uri[length(uri)] = '/' then
      SetLength(uri, length(uri) - 1);
    str := TStringList.Create;
    if FileExists(Config.SkinPath + 'BoardToSkin.ini') then
      try
        str.LoadFromFile(Config.SkinPath + 'BoardToSkin.ini');
      except
      end;
    if TMenuItem(Sender).Tag = 0 then
    begin
      i := str.IndexOfName(uri);
      if i > -1 then
        str.Delete(i);
    end else
    begin
      section := TSkinCollection(SkinCollectionList.Items[TMenuItem(Sender).Tag]).Section;
      str.Values[uri] := section;
    end;
    str.SaveToFile(Config.SkinPath + 'BoardToSkin.ini');
    str.Free;
    for i := 0 to viewList.Count - 1 do
    begin
      viewItem := viewList.Items[i];
      if (viewItem <> nil) and (viewItem.thread <> nil)
        and (viewItem.thread.board = CurrentBoard) then
        viewItem.LocalReload(viewItem.GetTopRes);
    end;
  end;
end;
//▲ もっと変えたいβ

procedure TMainWnd.ButtonWriteWriteClick(Sender: TObject);
var
  viewItem: TViewItem;
begin
  viewItem := GetActiveView;
  if (viewItem <> nil) and (viewItem.thread <> nil) then
    WritePanelControl.Post(viewItem.thread);
end;

procedure TMainWnd.ToolButtonWriteClick(Sender: TObject);
begin
  WritePanelControl.ToolButtonHandle(TToolButton(Sender), TToolButton(Sender).Tag);
end;

procedure TMainWnd.PageControlWriteChange(Sender: TObject);
begin
  if PageControlWrite.ActivePage = TabSheetWriteMain then
    try MemoWriteMain.SetFocus; except end
  else if PageControlWrite.ActivePage = TabSheetWritePreview then
    WritePanelControl.MakePreView;
end;

procedure TMainWnd.MemoWriteMainEnter(Sender: TObject);
begin
  WritePanelControl.ChangeMemoIme;
end;

procedure TMainWnd.MemoWriteMainExit(Sender: TObject);
begin
  WritePanelControl.SaveMemoIme;
end;

procedure TMainWnd.ToolButtonWriteAAClick(Sender: TObject);
begin
  WritePanelControl.writeActShowAAListExecute(Sender);
end;

procedure TMainWnd.MemoWriteMainChange(Sender: TObject);
begin
  WritePanelControl.ChangeStatusBar;
end;

procedure TMainWnd.MemoWriteMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (Key = VK_RETURN) then
  begin
    MemoWriteMain.WantReturns := false;
    if ButtonWriteWrite.Enabled then
      ButtonWriteWriteClick(nil)
    else
      MessageBeep($FFFFFFFF);
  end else
  begin
    MemoWriteMain.WantReturns := true;
    if (ssCtrl in Shift) then begin
      if (Key = Ord('A')) then
        MemoWriteMain.SelectAll;
        exit;
      end;
  end;
end;

procedure TMainWnd.MemoWriteMainKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = ' ') and (GetKeyState(VK_CONTROL) < 0) then begin
    Key := #0;
    WritePanelControl.writeActShowAAListExecute(Self);
  end;
end;

procedure TMainWnd.CheckBoxWriteSageClick(Sender: TObject);
begin
  ComboBoxWriteMail.Enabled := not CheckBoxWriteSage.Checked;
  if ComboBoxWriteMail.Enabled then
    ComboBoxWriteMail.Text := ''
  else
    ComboBoxWriteMail.Text := 'sage';
  try MemoWriteMain.SetFocus; except end;
end;

procedure TMainWnd.ListViewRepaint;
begin
  ListView.DoubleBuffered := True;
  ListView.Repaint;
  ListView.DoubleBuffered := False;
end;

initialization
  OleInitialize(nil);
  Application.ShowHint := False;
  HintWindowClass := TXPHintWindow; 
  Application.ShowHint := True;
finalization
  OleUninitialize;

end.













