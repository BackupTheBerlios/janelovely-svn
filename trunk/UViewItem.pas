unit UViewItem;
(* スレの中身を表示するWebBrowserとTThreadItemの関連付け *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)
(* version 1.114, 2004/08/14 14:22:14 *)

interface

uses
   SysUtils,
   Classes,
   Controls,
   ExtCtrls,
   AppEvnts,
   Messages,
   HogeTextView,
   UTVSub,
   UPopupTextView,
   UCardinalList,  //beginner
   StrUtils,
   Forms,
   IdGlobal, Types, Windows, VBScript_RegExp_55_TLB,
   U2chThread, U2chBoard, U2chCat, U2chCatList, UAsync, JConfig, UDat2HTML,
   USynchro, StrSub, StdCtrls, ApiBmp, PNGImage, GifImage, Graphics, IniFiles;

{const
  TESTVER = 'test71+75';
  SYRUPTESTVER = 'Syrup_test35';}

const
  {aiai}
  GREP_OPTION_NORMAL = 0;
  GREP_OPTION_REGEXP = 1;
  GREP_OPTION_AND    = 2;
  GREP_OPTION_OR     = 3;
  {/aiai}

type
  ECancelViewException = class (Exception);

  TDat2View = class(TConvDatOut)
  protected
    FBrowser: THogeTextView;
    re_entrant: integer;
    canceled: boolean;
    FAttribute: THogeAttribute;
    FBold: THogeAttribute;
    FStream: THogeMemoryStream;
    flushCount: integer;
    FOffsetLeft: integer;
    FOffsetBQ: Integer; //beginner
    FBiteSpaces: boolean;
    FUser: integer;
    FHref: string;
    EnableFontTag: boolean;
    EnableBodyTag: boolean;
    FDDOffsetLeft: Integer;
    FIgnoreBR: Boolean;
    FColorName: THogeColorHandleNameRecord;
    function GetRange(var ANK: string): Boolean; override;
    function ProcTag: boolean; override;
    function ProcEntity: boolean; override;
    function ProcBlank: boolean; override;
    function ProcDayOfWeek: Boolean; override;  //aiai
    function ProcID: Boolean; override;  //aiai
    procedure BeginAnchor; virtual;
    procedure EndAnchor; virtual;
    procedure AppendResNumList(num: Integer); overload; virtual;
    procedure AppendResNumList(num, num2: Integer); overload; virtual;
  public
    DD_OFFSET_LEFT: Integer;  //beginner
    LI_OFFSET_LEFT: Integer;  //beginner
    constructor Create(browser: THogeTextView);
    destructor Destroy; override;
    procedure WriteText(str: PChar; size: integer); override;
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); override;
    procedure WriteChar(c: Char); override;
    procedure WriteID(str: PChar; size: integer); virtual;  //aiai
    procedure WriteUNICODE(str: PChar; size: integer);
    procedure WriteBR;
    procedure WriteHR(color: Integer; custom: Boolean);  //aiai
    procedure WritePicture(pass: String; overlap: Boolean);  //aiai
    procedure WriteWallPaper(const pass: string);  //aiai
    procedure SetBold(boldP: boolean);
    procedure Flush; override;
    procedure Cancel;
    procedure SetIgnoreBR(ABool: Boolean); override;
    property DDOffsetLeft: Integer read FDDOffsetLeft write FDDOffsetLeft;
  end;

  TDat2PopupView = class(TDat2View)
  protected
    procedure AppendResNumList(num: Integer); override;
    procedure AppendResNumList(num, num2: Integer); override;
  public
    function ProcBlank: boolean; override;
    procedure WriteChar(c: Char); override;
    procedure WriteID(str: PChar; size: integer); override;  //aiai
  end;

  TDat2ViewForExtraction = class(TDat2View)
  protected
    procedure AppendResNumList(num: Integer); override;
    procedure AppendResNumList(num, num2: Integer); override;
  public
    Base:string;
    BBSType: TBBSType;
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); override;
    procedure Flush; override;
    procedure WriteID(str: PChar; size: integer); override;  //aiai
  end;

  TSimpleDat2View = class(TDat2View)
  protected
    function ProcTag: boolean; override;
    procedure ProcHTML; override;
    procedure BeginAnchor; override;
    procedure EndAnchor; override;
    procedure AppendResNumList(num: Integer); override;
    procedure AppendResNumList(num, num2: Integer); override;
  public
    procedure Flush; override;
    procedure WriteID(str: PChar; size: integer); override;  //aiai
  end;

  {aiai}
  //とりあえずプレビュー用
  TDat2PreViewView = class(TDat2View)
  protected
    procedure AppendResNumList(num: Integer); override;
    procedure AppendResNumList(num, num2: Integer); override;
  public
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); override;
    procedure WriteID(str: PChar; size: integer); override;
  end;

  //ヒント、検索用
  TStrDatOutForHint = class(TStrDatOut)
  protected
    function ProcDayOfWeek: Boolean; override;
  end;
  {/aiai}


  {beginner}
  TIndexTree = class(TConvDatOut)
  protected
    FtmpDat: TThreadData;
    Pos: Integer;
    FThread: TThreadItem;
    function ProcTag: boolean; override;
  public

    ShowRoot: Boolean;
    AllowDup: Boolean;
    HeadLineLength: Integer;
    LevelLimit: Integer;
    TraceBackLimit: Integer;

    Trunk: TList;
    Mask: TBits;

    constructor Create;
    destructor Destroy; override;
    procedure WriteText(str: PChar; size: integer); override;
    procedure WriteAnchor(const Name: string;
                          const HRef: string;
                          str: PChar; size: integer); override;
    procedure Build(thread: TThreadItem; Start: Integer);
    function TreeDatOut(Dest: TDatOut;
                        Index: Integer = -1;
                        AboneArray: TAboneArray = nil;
                        NeedConvert: Boolean = False): Integer;
    function OutLine(Dest: TDatOut;
                     Index: Integer = -1;
                     AboneArray: TAboneArray = nil;
                     NeedConvert: Boolean = False): Integer;
  end;

  TStrDatOutForHeadline = class(TStrDatOut)
  protected
    function ProcEntity: boolean; override;
  end;

  {/beginner}


  (*-------------------------------------------------------*)
  TViewList = class;
  TProgState = (tpsNone, tpsProgress, tpsReady, tpsWorking, tpsDone);

  BoolArray = array of boolean;

  (* TWebBrowserとTTreadItemの関連付け *)

  TPopupViewItem = class;
  TPopupViewList = class;

  (* 共通のスーパークラス *)
  TBaseViewItem = class(TObject)
  protected
    FThread: TThreadItem;
    FPossessionView: TPopupViewItem;
    FLockCount: Integer;
    FPopupViewList: TPopupViewList;
    FLinkText: String; //aiai
    function GetBaseItem: TBaseViewItem; virtual; abstract;
    function GetBaseThread: TThreadItem; virtual;
    function GetRootControl: TWinControl; virtual; abstract;
    function GetDerivativeBrowser: TControl; virtual; abstract;
    function GetDerivativeStream: TDatOut; virtual; abstract;
    function GetStreamCanceled: Boolean; virtual; abstract;
    function _ExtractKeyWord(thread: TThreadItem; dest: TDatOut;
      targetList: TStrings; Max: Integer; GrepMode: Byte;{koreawatcher} RegExp: TRegExp = nil;
      IncludeRef: Boolean = False; NeedTitle: Boolean = False{/koreawatcher}): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Cancel; virtual; abstract;
    function GetSelection: String; virtual; abstract;
    //function GetFocusedLink: String; {virtual;}
    function GetLinkUnderCursor: String; //aiai
    procedure SelectAll; virtual;
    procedure Lock; virtual;
    procedure UnLock; virtual;
    function Locked: Boolean;
    procedure ReleasePossessionView;
    function IsMouseInPane: Boolean; virtual;
    function BrowserQueryClose: Boolean; virtual;
    function ValidateURI(source: String; var full: String): Boolean; virtual;
    property BaseItem: TBaseViewItem read GetBaseItem;
    property BaseThread: TThreadItem read GetBaseThread;
    property thread: TThreadItem read FThread;
    property PossessionView:TPopupViewItem read FPossessionView;
    property RootControl: TWinControl read GetRootControl;
    property PopUpViewList: TPopupViewList read FPopupViewList;
    property LinkText: String read FLinkText; //aiai
  end;

  (* Doe,非DoeそれぞれでTHogeTextView,TWebBrowserを管理するための基礎クラス *)

  TPlainViewItem = class(TBaseViewItem)
  protected
    FRootControl: TWinControl;
    FBrowser: THogeTextView;
    FStream: TDat2View;
    procedure SetBrowser(value: THogeTextView);
    function GetBaseItem: TBaseViewItem; override;
    function GetRootControl: TWinControl; override;
    function GetDerivativeBrowser: TControl; override;
    function GetDerivativeStream: TDatOut; override;
    function GetStreamCanceled: Boolean; override;
  public
    property browser: THogeTextView read FBrowser write SetBrowser;
    property stream: TDat2View read FStream;
    function GetSelection: String; override;
    procedure Cancel; override;
    property RootControl: TWinControl read GetRootControl write FRootControl;
    property PopUpViewList: TPopupViewList read FPopupViewList write FPopupViewList;
  end;

  (* プレビュー等で使うための汎用viewItem *)

  // TViewItemがbrowserやthreadの管理機能や状態管理の仕組みを
  // 備えるのに対し、このクラスでは自前で解放などの処理をする
  TFlexViewItem = class(TPlainViewItem)
  protected
    FBase: String;
  public
    function ValidateURI(source: String; var full: String): Boolean; override;
    property thread read FThread write FThread;
    property Base: String read FBase write FBase;
  end;

  (* スレビュー用 *)
  TViewItem = class(TPlainViewItem)
  protected
    FProgress: TProgState;
    FNaviStat: TProgState;
    FPreStat:  TProgState;
    FAsyncStat: TProgState;
    viewList: TViewList;

    re_entrant: integer;
    freeByCancel: boolean;
    canceled: boolean;

    currentCheckNew: boolean;
    nextThread: TThreadItem;
    nextCheckOpr: TGestureOprType;
    pumpCount: integer;
    currentStartLine : integer;
    FNavigateToViewPos: Boolean;
    drawStartLine: integer;
    newdrawStartLine: integer;

    backStack: array of integer;
    forwordStack: array of integer;

    FWantTraceLogDone: Boolean;

    procedure FreeStream;
    function  SetViewPos: boolean;
    procedure OnCancel;
    procedure OnAsyncNotifyProc(thread: TThreadItem);
    procedure OnAsyncDoneProc(thread: TThreadItem);
    procedure PumpChunk;
    procedure ClearBrowser;
    procedure SaveViewPos;
    procedure WriteSkin(str: PChar; size: integer; thread: TThreadItem = nil);
    function GetBaseThread: TThreadItem; override;
  public
    HintText: string; //beginner
    procedure FreeThread(savePos: boolean = True);
    constructor Create(parent: TViewList);
    destructor Destroy; override;
    procedure DoWorking;
    procedure NewRequest(thread: TThreadItem; oprType: TGestureOprType;
                         position: integer = -1; force: Boolean = False;
                         redraw: Boolean = False;
                         {aiai}TabText: Boolean = True{/aiai});
    procedure AutoFree;
    function Drain: boolean;
    procedure OnNavigateDone;
    procedure ZoomBrowser(zoom: integer);
    function ScrollToNewRes: boolean;
    function ScrollToAnchor(num: integer; isTop: boolean; redraw: boolean): boolean;
    procedure GoBack;
    function CanGoBack: boolean;
    procedure GoForword;
    function CanGoForword: boolean;
    function MessageLoop: boolean;
    procedure ExtractKeyword(const target:string; ExThread:TThreadItem;
      GrepMode: Byte; IncludeRef: Boolean; MigemoMode: Boolean = False);
    procedure Grep(const target: string; targetBoardList: TList; GrepMode: Byte;
               threadtitleonly: boolean = false; writepopup: boolean = false;
               ShowDirect: boolean = false; IncludeRef: Boolean = False;  //beginner
               const popupmaxseq: Integer = 5; const popupeachthremax: Integer = 10);
    procedure ThreadTree(ExThread: TThreadItem; Index:Integer; OutLine: Boolean);
    procedure Reload;
    procedure LocalReload(line: integer; drawline: integer = -1); //※[457]
    procedure About;
    function GetTopRes: integer;
    property Progress: TProgState read FProgress;
    procedure Viewidx(idxhtml: string;title: string); //rika
  end;
  (*-------------------------------------------------------*)
  TPictureViewList = class;
  (* TWebBrowser一覧 *)
    TViewList = class(TList)
  private
    synchro: THogeMutex;
    garbageList: TList;    (* どこかでHTMLドキュメントが残ってるぽいので逃げを打つ *)
    function GetItems(index: integer): TViewItem;
    procedure SetItems(index: integer; viewItem: TViewItem);
  public
    wallPaperList: TPictureViewList;
    PictViewList: TPictureViewList;
    constructor Create;
    destructor Destroy; override;
    procedure Delete(index: integer);
    procedure Clear; override;
    function NewView(browser: THogeTextView; index: integer = -1): TViewItem;
    function FindViewItem(thread: TThreadItem): TViewItem; overload;
    function FindViewitem(browser: TComponent): TViewItem; overload;
    function FindViewItemIndex(thread: TThreadItem): Integer; overload;  //aiai  viewListのindexを返す
    function FindViewItemIndex(browser: TComponent): Integer; overload;  //aiai  viewListのindexを返す
    function FindFirstViewItem: Integer; //aiai viewListにあるViewのうちで最も高いZオーダーをもつViewのインデックスを返す
    function GetGarbage(insertIndex: integer = -1): TViewItem;
    procedure DoWorkingAll;
    procedure MasterNotifyProc(thread: TThreadItem);
    procedure MasterDoneProc(thread: TThreadItem);
    procedure UpdateFocus(index: integer); overload;
    procedure UpdateFocus(viewItem: TViewItem); overload;
    procedure Debug;
    {aiai}
    function ViewMaximize(viewItem: TViewItem): Boolean;
    procedure ViewAllRestore;
    procedure ViewAllMaximize(TopWnd: THogeTextView);
    procedure ViewCascade;
    procedure ViewTile(Horize: Boolean);
    {/aiai}
    property Items[index: integer]: TViewItem read GetItems write SetItems;
  end;

  (*-------------------------------------------------------*)

  (* 多重ポップアップ用のTViewItem *)

  //Lock,Unlockについて
  //ポップアップの処理はprocessmessageにより一つのインスタンスに複数の呼び出しが
  //同時に起こる可能性があり、さらにカーソルの移動で自動的に解放される仕組みなので、
  //イベントハンドラ実行中に別のイベントハンドラがインスタンスを解放するのを
  //防ぐためにロック処理が必要。
  //ロックを掛けると、TPopupViewList.ConfirmでEnabled:=FalseやReleaseされず、
  //さらに明示的にReleaseを呼んでも画面から消えるだけですぐに開放されず、
  //Unlockでロックカウントが0になったときに解放されます。ロックが必要になるのは、
  //メッセージ処理または明示的なReleaseが入る可能性がある場所で、OpenJaneでは
  //TDat2HTMLによるスレ出力(processmessage)、モーダルダイアログ表示、メニュー表示。
  //必要か分からないときは、どうせLockとUnlockの実行コストは安いので
  //TPopupViewを扱う処理の最初と最後で常にLock,Unlockしても可。
  //また、このためTPopupViewItemの解放はReleaseで行い、
  //直接Free、Destroyはしないようにしてください。
  //ちなみにTBaseViewItem派生クラスのうち、TPopupViewItem以外のLock,Unlockは
  //今のところダミーで何の処理もしません。

  TPopupViewItem = class(TBaseViewItem)
  protected
    FOwnerView: TBaseViewItem;
    FBrowser: TPopupTextView;
    FStream: TDat2View;
    FHadPointed: Boolean;
    FReleased: Boolean;
    FOwnerCofirmation: Boolean;
    FIdStr: String;
    FOnEnabled: TNotifyEvent;
    procedure PopUp(Point: TPoint);
    procedure SetThread(const AThread: TThreadItem);
    function GetBaseItem: TBaseViewItem; override;
    function GetBaseThread: TThreadItem; override;
    function GetRootControl: TWinControl; override;
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    function GetDerivativeBrowser: TControl; override;
    function GetDerivativeStream: TDatOut; override;
    function GetStreamCanceled: Boolean; override;
    procedure SetResNumIDList; //aiai レス番とIDリストをセット
  public
    constructor Create(ABrowser: TPopupTextView; AOwnerView: TBaseViewItem); reintroduce;
    destructor Destroy; override;
    procedure Cancel; override;
    procedure UnLock; override;
    procedure Release;
    function BrowserQueryClose: Boolean; override;
    function GetSelection: String; override;
    procedure Show2chInfo(AIdStr: String; ATarget: String; ABoard: TBoard;
      AThread: TThreadItem; ARangearray: TRangeArray; Point: TPoint);
    procedure ShowTextInfo(AIdStr: String; Text: String; AThread: TThreadItem;
      HTML: Boolean; Point: TPoint);
    function ExtractKeyword(AIdStr: String; AThread: TThreadItem;
      Target: String; Max: Integer;Point: TPoint): Integer;
    function ExtractID(AIdStr: String; AThread: TThreadItem; Target: String;
      Max: Integer; Point: TPoint): Integer; //aiai
    function ThreadTree(AIdStr: String; AThread: TThreadItem;
      Index: Integer; OutLine: Boolean; Point: TPoint): Boolean;
    property OwnerView:TBaseViewItem read FOwnerView;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property HadPointed: Boolean read FHadPointed write FHadPointed;
    property IdStr: String read FIdStr;
    property OwnerCofirmation: Boolean read FOwnerCofirmation write FOwnerCofirmation;
    property OnEnabled: TNotifyEvent read FOnEnabled write FOnEnabled;
  end;

  (*-------------------------------------------------------*)
  (* ポップアップ一覧 *)
  TPopupViewList = class(TObject)
  private
    FList: TList;
    FOnChange: TNotifyEvent;
  protected
    FAppEvent: TApplicationEvents;
    FTimer: TTimer;
    FPrevPoint: TPoint;
    function GetItems(index: integer): TPopupViewItem;
    function GetCount: Integer;
    function Add(Item: TPopupViewItem): Integer;
    function Extract(Item: TPopupViewItem): TPopupViewItem;
    procedure FTimerTimer(Sender: TObject);
    procedure FAppEventMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure Change;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear(Force: Boolean);
    procedure Confirm(Point: TPoint);   (* マウス位置によるヒントの非多段化、消去の管理 *)
    property Items[Index: Integer]: TPopupViewItem read GetItems;
    property Count: Integer read GetCount;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  {aiai}
  TPictureViewList = class(TStringList)
  public
    destructor Destroy; override;
  end;

  TSkinCollection = class(TObject)
  public
    Section: String;
    HeaderHTML: String;
    RecHTML: String;
    NewRecHTML: String;
    BookMarkHTML: String;
    NewMarkHTML: String;
    PopupRecHTML: String;
  end;

  TSkinCollectionList = class(TList)
  private
    function GetItems(index: integer): TSkinCollection;
  public
    property Items[index: integer]: TSkinCollection read GetItems;
  end;
  {/aiai}

  TDat2HTMLType = (dhtRes, dhtNewRes, dhtPopupRes, dhtSearchRes);

procedure Make2chInfo(dest: TDatOut; URI: string; basethread: TThreadItem;
  board: TBoard; thread: TThreadItem; RangeArray: TRangeArray);
function MakeIDInfo(dest: TDatOut; const URI: String;
  const thread: TThreadItem; Max: integer): Integer;
function PickUpRes(thread: TThreadItem; startLine, endLine: integer): string;
function SetUpDat2HTML(const body: string; d2htype: TDat2HTMLType): TDat2HTML;


(*=======================================================*)
implementation
(*=======================================================*)

uses
  Dialogs,
  Main,
  jconvert,      //aiai
  UMDITextView;  //aiai

type
  CharEntity = record
    Cd: Word;
    Ent: String;
  end;

const
  CharEntryList: Array[0..246] of CharEntity = (
  (Cd: 8194; Ent: 'ensp'),    (Cd: 8195; Ent: 'emsp'),    (Cd: 8201; Ent: 'thinsp'),
  (Cd: 9674; Ent: 'loz'),    (Cd: 9824; Ent: 'spades'),  (Cd: 9827; Ent: 'clubs'),  (Cd: 9829; Ent: 'hearts'), (Cd: 9830; Ent: 'diams'),
  (Cd: 161; Ent: 'iexcl'),   (Cd: 162; Ent: 'cent'),     (Cd: 163; Ent: 'pound'),
  (Cd: 164; Ent: 'curren'),  (Cd: 165; Ent: 'yen'),      (Cd: 166; Ent: 'brvbar'),  (Cd: 167; Ent: 'sect'),
  (Cd: 168; Ent: 'uml'),     (Cd: 169; Ent: 'copy'),     (Cd: 170; Ent: 'ordf'),    (Cd: 171; Ent: 'laquo'),
  (Cd: 172; Ent: 'not'),     (Cd: 173; Ent: 'shy'),      (Cd: 174; Ent: 'reg'),     (Cd: 175; Ent: 'macr'),
  (Cd: 176; Ent: 'deg'),     (Cd: 177; Ent: 'plusmn'),   (Cd: 178; Ent: 'sup2'),    (Cd: 179; Ent: 'sup3'),
  (Cd: 180; Ent: 'acute'),   (Cd: 181; Ent: 'micro'),    (Cd: 182; Ent: 'para'),    (Cd: 183; Ent: 'middot'),
  (Cd: 184; Ent: 'cedil'),   (Cd: 185; Ent: 'sup1'),     (Cd: 186; Ent: 'ordm'),    (Cd: 187; Ent: 'raquo'),
  (Cd: 188; Ent: 'frac14'),  (Cd: 189; Ent: 'frac12'),   (Cd: 190; Ent: 'frac34'),  (Cd: 191; Ent: 'iquest'),
  (Cd: 192; Ent: 'Agrave'),  (Cd: 193; Ent: 'Aacute'),   (Cd: 194; Ent: 'Acirc'),   (Cd: 195; Ent: 'Atilde'),
  (Cd: 196; Ent: 'Auml'),    (Cd: 197; Ent: 'Aring'),    (Cd: 198; Ent: 'AElig'),   (Cd: 199; Ent: 'Ccedil'),
  (Cd: 200; Ent: 'Egrave'),  (Cd: 201; Ent: 'Eacute'),   (Cd: 202; Ent: 'Ecirc'),   (Cd: 203; Ent: 'Euml'),
  (Cd: 204; Ent: 'Igrave'),  (Cd: 205; Ent: 'Iacute'),   (Cd: 206; Ent: 'Icirc'),   (Cd: 207; Ent: 'Iuml'),
  (Cd: 208; Ent: 'ETH'),     (Cd: 209; Ent: 'Ntilde'),   (Cd: 210; Ent: 'Ograve'),  (Cd: 211; Ent: 'Oacute'),
  (Cd: 212; Ent: 'Ocirc'),   (Cd: 213; Ent: 'Otilde'),   (Cd: 214; Ent: 'Ouml'),    (Cd: 215; Ent: 'times'),
  (Cd: 216; Ent: 'Oslash'),  (Cd: 217; Ent: 'Ugrave'),   (Cd: 218; Ent: 'Uacute'),  (Cd: 219; Ent: 'Ucirc'),
  (Cd: 220; Ent: 'Uuml'),    (Cd: 221; Ent: 'Yacute'),   (Cd: 222; Ent: 'THORN'),   (Cd: 223; Ent: 'szlig'),
  (Cd: 224; Ent: 'agrave'),  (Cd: 225; Ent: 'aacute'),   (Cd: 226; Ent: 'acirc'),   (Cd: 227; Ent: 'atilde'),
  (Cd: 228; Ent: 'auml'),    (Cd: 229; Ent: 'aring'),    (Cd: 230; Ent: 'aelig'),   (Cd: 231; Ent: 'ccedil'),
  (Cd: 232; Ent: 'egrave'),  (Cd: 233; Ent: 'eacute'),   (Cd: 234; Ent: 'ecirc'),   (Cd: 235; Ent: 'euml'),
  (Cd: 236; Ent: 'igrave'),  (Cd: 237; Ent: 'iacute'),   (Cd: 238; Ent: 'icirc'),   (Cd: 239; Ent: 'iuml'),
  (Cd: 240; Ent: 'eth'),     (Cd: 241; Ent: 'ntilde'),   (Cd: 242; Ent: 'ograve'),  (Cd: 243; Ent: 'oacute'),
  (Cd: 244; Ent: 'ocirc'),   (Cd: 245; Ent: 'otilde'),   (Cd: 246; Ent: 'ouml'),    (Cd: 247; Ent: 'divide'),
  (Cd: 248; Ent: 'oslash'),  (Cd: 249; Ent: 'ugrave'),   (Cd: 250; Ent: 'uacute'),  (Cd: 251; Ent: 'ucirc'),
  (Cd: 252; Ent: 'uuml'),    (Cd: 253; Ent: 'yacute'),   (Cd: 254; Ent: 'thorn'),   (Cd: 255; Ent: 'yuml'),
  (Cd: 338; Ent: 'OElig'),   (Cd: 339; Ent: 'oelig'),    (Cd: 352; Ent: 'Scaron'),  (Cd: 353; Ent: 'scaron'),
  (Cd: 376; Ent: 'Yuml'),    (Cd: 710; Ent: 'circ'),     (Cd: 732; Ent: 'tilde'),   (Cd: 402; Ent: 'fnof'),
  (Cd: 913; Ent: 'Alpha'),   (Cd: 914; Ent: 'Beta'),     (Cd: 915; Ent: 'Gamma'),   (Cd: 916; Ent: 'Delta'),
  (Cd: 917; Ent: 'Epsilon'), (Cd: 918; Ent: 'Zeta'),     (Cd: 919; Ent: 'Eta'),     (Cd: 920; Ent: 'Theta'),
  (Cd: 921; Ent: 'Iota'),    (Cd: 922; Ent: 'Kappa'),    (Cd: 923; Ent: 'Lambda'),  (Cd: 924; Ent: 'Mu'),
  (Cd: 925; Ent: 'Nu'),      (Cd: 926; Ent: 'Xi'),       (Cd: 927; Ent: 'Omicron'), (Cd: 928; Ent: 'Pi'),
  (Cd: 929; Ent: 'Rho'),     (Cd: 931; Ent: 'Sigma'),    (Cd: 932; Ent: 'Tau'),     (Cd: 933; Ent: 'Upsilon'),
  (Cd: 934; Ent: 'Phi'),     (Cd: 935; Ent: 'Chi'),      (Cd: 936; Ent: 'Psi'),     (Cd: 937; Ent: 'Omega'),
  (Cd: 945; Ent: 'alpha'),   (Cd: 946; Ent: 'beta'),     (Cd: 947; Ent: 'gamma'),   (Cd: 948; Ent: 'delta'),
  (Cd: 949; Ent: 'epsilon'), (Cd: 950; Ent: 'zeta'),     (Cd: 951; Ent: 'eta'),     (Cd: 952; Ent: 'theta'),
  (Cd: 953; Ent: 'iota'),    (Cd: 954; Ent: 'kappa'),    (Cd: 955; Ent: 'lambda'),  (Cd: 956; Ent: 'mu'),
  (Cd: 957; Ent: 'nu'),      (Cd: 958; Ent: 'xi'),       (Cd: 959; Ent: 'omicron'), (Cd: 960; Ent: 'pi'),
  (Cd: 961; Ent: 'rho'),     (Cd: 962; Ent: 'sigmaf'),   (Cd: 963; Ent: 'sigma'),   (Cd: 964; Ent: 'tau'),
  (Cd: 965; Ent: 'upsilon'), (Cd: 966; Ent: 'phi'),      (Cd: 967; Ent: 'chi'),     (Cd: 968; Ent: 'psi'),
  (Cd: 969; Ent: 'omega'),   (Cd: 977; Ent: 'thetasym'), (Cd: 978; Ent: 'upsih'),   (Cd: 982; Ent: 'piv'),
  (Cd: 8204; Ent: 'zwnj'),   (Cd: 8205; Ent: 'zwj'),     (Cd: 8206; Ent: 'lrm'),    (Cd: 8207; Ent: 'rlm'),
  (Cd: 8211; Ent: 'ndash'),  (Cd: 8212; Ent: 'mdash'),  (Cd: 8216; Ent: 'lsquo'),   (Cd: 8217; Ent: 'rsquo'),
  (Cd: 8218; Ent: 'sbquo'),  (Cd: 8220; Ent: 'ldquo'),  (Cd: 8221; Ent: 'rdquo'),   (Cd: 8222; Ent: 'bdquo'),
  (Cd: 8224; Ent: 'dagger'), (Cd: 8225; Ent: 'Dagger'), (Cd: 8226; Ent: 'bull'),    (Cd: 8230; Ent: 'hellip'),
  (Cd: 8240; Ent: 'permil'), (Cd: 8242; Ent: 'prime'),  (Cd: 8243; Ent: 'Prime'),   (Cd: 8249; Ent: 'lsaquo'),
  (Cd: 8250; Ent: 'rsaquo'), (Cd: 8254; Ent: 'oline'),  (Cd: 8260; Ent: 'frasl'),   (Cd: 8364; Ent: 'euro'),
  (Cd: 8465; Ent: 'image'),  (Cd: 8472; Ent: 'ewierp'), (Cd: 8476; Ent: 'real'),    (Cd: 8482; Ent: 'trade'),
  (Cd: 8501; Ent: 'alefsym'),(Cd: 8592; Ent: 'larr'),   (Cd: 8593; Ent: 'uarr'),    (Cd: 8594; Ent: 'rarr'),
  (Cd: 8595; Ent: 'darr'),   (Cd: 8596; Ent: 'harr'),   (Cd: 8629; Ent: 'crarr'),   (Cd: 8656; Ent: 'lArr'),
  (Cd: 8657; Ent: 'uArr'),   (Cd: 8658; Ent: 'rArr'),   (Cd: 8659; Ent: 'dArr'),    (Cd: 8660; Ent: 'hArr'),
  (Cd: 8704; Ent: 'forall'), (Cd: 8706; Ent: 'part'),   (Cd: 8707; Ent: 'exist'),   (Cd: 8709; Ent: 'empty'),
  (Cd: 8711; Ent: 'nabla'),  (Cd: 8712; Ent: 'isin'),   (Cd: 8713; Ent: 'notin'),   (Cd: 8715; Ent: 'ni'),
  (Cd: 8719; Ent: 'prod'),   (Cd: 8721; Ent: 'sum'),    (Cd: 8722; Ent: 'minus'),   (Cd: 8727; Ent: 'lowast'),
  (Cd: 8730; Ent: 'radic'),  (Cd: 8733; Ent: 'prop'),   (Cd: 8734; Ent: 'infin'),   (Cd: 8736; Ent: 'ang'),
  (Cd: 8743; Ent: 'and'),    (Cd: 8744; Ent: 'or'),     (Cd: 8745; Ent: 'cap'),     (Cd: 8746; Ent: 'cup'),
  (Cd: 8747; Ent: 'int'),    (Cd: 8756; Ent: 'there4'), (Cd: 8764; Ent: 'sim'),     (Cd: 8773; Ent: 'cong'),
  (Cd: 8776; Ent: 'asymp'),  (Cd: 8800; Ent: 'ne'),     (Cd: 8801; Ent: 'equiv'),   (Cd: 8804; Ent: 'le'),
  (Cd: 8805; Ent: 'ge'),     (Cd: 8834; Ent: 'sub'),    (Cd: 8835; Ent: 'sup'),     (Cd: 8836; Ent: 'nsub'),
  (Cd: 8838; Ent: 'sube'),   (Cd: 8839; Ent: 'supe'),   (Cd: 8853; Ent: 'oplus'),   (Cd: 8855; Ent: 'otimes'),
  (Cd: 8869; Ent: 'perp'),   (Cd: 8901; Ent: 'sdot'),   (Cd: 8968; Ent: 'lceil'),   (Cd: 8969; Ent: 'rceil'),
  (Cd: 8970; Ent: 'lfloor'), (Cd: 8971; Ent: 'rfloor'), (Cd: 9001; Ent: 'lang'),    (Cd: 9002; Ent: 'rang')
  );

{beginner}
const
  DEF_TREE_HTML    = '<dt><NUMBER/> 名前：<SA i=2><b><NAME/></b></b><SA i=0>[<MAIL/>] 投稿日：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10;
{/beginner}

(* =========================================================== *)
function ZoomToPoint(zoom: integer): Integer;
begin
  try
    result := Config.viewZoomPointArray[zoom];
  except
    result := -9;
  end;
  {case zoom of
  0: result := -9;
  1: result := -10;
  2: result := -12;
  3: result := -14;//521 -16
  4: result := -15;//521 -24
  end;}
end;

function ZoomToExternalLeading(zoom: integer): Integer;
begin
  result := 1;
  case zoom of
  0: result := 1;
  1: result := 2;
  2: result := 2;
  3: result := 3;
  4: result := 4;
  end;
end;

function FindAnchorName(item: THogeTVItem; var startPos, size: integer): boolean;
var
  i: integer;
begin
  if startPos <= 0 then
    i := 1
  else begin
    i := startPos + size;
    size := 0;
  end;
  startPos := 0;
  result := True;
  for i := i to length(item.FAttrib) do
  begin
    if (Ord(item.FAttrib[i]) and (htvVMASK or htvATTMASK))
       = (htvHIDDEN or ATTRIB_ANCHOR_NAME) then
    begin
      if startPos <= 0 then
        startPos := i
    end
    else if 0 < startPos then
    begin
      size := i - startPos;
      exit;
    end;
  end;
  if startpos > 0 then
    size := length(item.FAttrib) - startpos + 1
  else
    result := false;
end;

(* =========================================================== *)

constructor TDat2View.Create(browser: THogeTextView);
begin
  inherited Create;
  FBrowser := browser;
  canceled := false;
  re_entrant := 0;
  FAttribute := 0;
  FBold := 0;
  FStream := THogeMemoryStream.Create;
  FStream.Size := 4096;
  flushCount := 0;
  FOffsetLeft := 0;
  {beginner}
  DD_OFFSET_LEFT := UTVSub.DD_OFFSET_LEFT;
  LI_OFFSET_LEFT := UTVSub.LI_OFFSET_LEFT;
  FOffsetBQ :=0;
  {/beginner}
  FBiteSpaces := False;
  FUser := 0;
  EnableFontTag := false;
  FDDOffsetLeft := DD_OFFSET_LEFT;
  zeromemory(@FColorName, sizeof(THogeColorHandleNameRecord));
end;

destructor TDat2View.Destroy;
begin
  FStream.Free;
  inherited;
end;

procedure TDat2View.BeginAnchor;
var
  name, value: string;
begin
  FHref := '';
  while GetAttribPair(name, value) do
  begin
    if name = 'href' then
    begin
      FHref := value;
      break;
    end;
  end;
  if AnsiStartsStr('mailto:', FHref) or AnsiStartsStr('/test/p.php?', FHref) then
  begin
    Flush;
    FUser := htvUSER or ATTRIB_LINK;
  end else if AnsiStartsStr('javascript:', FHref) then
  begin
    Flush;
    FUser := htvUSER or ATTRIB_LINK;
  end;
end;

procedure TDat2View.EndAnchor;
  function GetBeID(const Source: String): String;
  var
    startpos, endpos, ssize: integer;
    p: PChar;
    c: Char;
  begin
    result := '';
    p := PChar(Source);
    ssize := Length(Source);
    startpos := Pos('i=', Source);
    if startpos = 0 then
      exit;
    Inc(startpos);
    endpos := startpos;
    while endpos < ssize do
    begin
      c := (p + endpos)^;
      if c in [#$30..#$39] then
        Inc(endpos)
      else
        break;
    end;
    if (endpos = startpos) or (endpos = ssize) then
      exit;
    SetString(Result, p + startpos, endpos - startpos);
  end;


begin
  if AnsiStartsStr('mailto:', FHref) then
  begin
    Flush;
    FBrowser.Append(FHref, ATTRIB_ANCHOR_HREF or htvHIDDEN);
    FUser := 0;
  end else if AnsiStartsStr('/test/p.php?', FHref) then
  begin
    Flush;
    //もうない形式なのでbe.2ch.net固定でいいと思う
    FBrowser.Append('http://be.2ch.net' + FHref, ATTRIB_ANCHOR_HREF or htvHIDDEN);
    FUser := 0;
  end else if AnsiStartsStr('javascript:', FHref) then
  begin
    Flush;
    FBrowser.Append('BE:' + GetBeID(FHref), ATTRIB_ANCHOR_HREF or htvHIDDEN);
    FUser := 0;
  end;
end;

function TDat2View.GetRange(var ANK: string): Boolean;
var
  s2: string;
  num, num2, origindex: Integer;
  flag: Boolean;
begin
  if not Config.ojvColordNumber then
  begin
    Result := Inherited GetRange(ANK);
    exit;
  end;

  origindex := index;
  ANK := '';
  s2 := '';
  flag := false;
  num := 0;
  while index < size do
  begin
    case (str + index)^ of
    '0'..'9':
      begin
        if flag then
          s2 := s2 + (str + index)^;
        ANK := ANK + (str + index)^;
      end;
    '-':
      begin
        if index <= origindex then
          break;
        num := StrToIntDef(ANK, 0);
        flag := true;
        ANK := ANK + (str + index)^;
      end;
    #$81:
      begin
        if (index + 1 < size) and
           (((str + index+1)^ = #$7c) or
            ((str + index+1)^ = #$5d))  then
        begin (* － *)
          if index <= origindex then
            break;
          num := StrToIntDef(ANK, 0);
          flag := true;
          ANK := ANK + '-';
          inc(index);
        end
        else
          break;
      end;
    #$82:
      begin
        if (index + 1 < size) and ((str + index+1)^ in [#$4f..#$58]) then
        begin   (* 全角数字 *)
          inc(index);
          ANK := ANK + Chr(Ord((str + index)^) - $1f);
          if flag then
            s2 := s2 + Chr(Ord((str + index)^) - $1f);
        end
        else
          break;
      end;
    else break;
    end;
    Inc(index);
  end;
  result := index > origindex;
  if length(s2) > 0 then
  begin
    num2 := StrToIntDef(s2, 0);
    AppendResNumList(num, num2);
  end else if result then
  begin
    num := StrToIntDef(ANK, 0);
    AppendResNumList(num);
  end;
end;

function TDat2View.ProcTag: boolean;

  procedure EndFont;
  begin
    if FColorName.startp > 0 then
    begin
      Flush;
      Fbrowser.SetColorName(FColorName);
      zeromemory(@FColorName, sizeof(THogeColorHandleNameRecord));
    end;
  end;

  procedure SetFont;
  var
    name, value: string;
    color, len: Integer;
    failure: Boolean;

    procedure ReturnValue(i: Integer);
    begin
      if failure then exit;
      case value[i] of
      '0'..'9': color := color * 16 + Ord(value[i]) - Ord('0');
      'A'..'F': color := color * 16 + Ord(value[i]) - Ord('A') + 10;
      'a'..'f': color := color * 16 + Ord(value[i]) - Ord('a') + 10;
      else
        begin
          failure := True;
          exit;
        end;
      end;  //Case
    end;

  begin
//    if not EnableFontTag then
//      exit;
    while GetAttribPair(name, value) do
    begin
      if EnableFontTag and (name = 'face') and (0 < length(value)) then
      begin
        FBrowser.SetFont(value, ZoomToPoint(Config.viewZoomSize));
        break;
      end else if (name = 'color') and (0 < length(value)) then
      begin
        len := Length(value);
        color := 0;
        failure := False;
        if (name = 'color') then
        begin
          if len = 6 then
          begin
            ReturnValue(5);  //Blue
            ReturnValue(6);  //Blue
            ReturnValue(3);  //Green
            ReturnValue(4);  //Green
            ReturnValue(1);  //Red
            ReturnValue(2);  //Red
          end else if (len = 7) and (value[1] = '#') then
          begin
            ReturnValue(6);  //Blue
            ReturnValue(7);  //Blue
            ReturnValue(4);  //Green
            ReturnValue(5);  //Green
            ReturnValue(2);  //Red
            ReturnValue(3);  //Red
          end;
          Flush;
          FColorName.color := color;
          FColorName.startp := FBrowser.Strings[FBrowser.Strings.Count - 1].GetLength + 1;
        end;
      end;
    end;
  end;

  procedure SetBody;
  var
    name, value: string;
  begin
    if not EnableBodyTag then
      exit;
    while GetAttribPair(name, value) do
    begin
      if (name = 'background') and (length(value) > 0) then
      begin
        WriteWallPaper(value);
      end else if (name = 'valign') and (length(value) > 0) then
      begin
        if value = 'top' then
          FBrowser.WallpaperVAlign := walVTop
        else if value = 'center' then
          FBrowser.WallpaperVAlign := walVCenter
        else if value = 'bottom' then
          FBrowser.WallpaperVAlign := walVBottom
        else
          FBrowser.WallpaperVAlign := walVTop;
      end else if (name = 'halign') and (length(value) > 0) then
      begin
        if value = 'left' then
          FBrowser.WallpaperHAlign := walHLeft
        else if value = 'center' then
          FBrowser.WallpaperHAlign := walHCenter
        else if value = 'right' then
          FBrowser.WallpaperHAlign := walHRight
        else
          FBrowser.WallpaperHAlign := walHLeft;
      end else if (name = 'leftmargin') and (length(value) > 0) then
      begin
        FBrowser.LeftMargin := StrToIntDef(value, 8);
      end else if (name = 'rightmargin') and (length(value) > 0) then
      begin
        FBrowser.RightMargin := StrToIntDef(value, 8);
      end;
      //end else if name = 'maxwidth' then
      //begin
      //  BrowserMaxWidth := StrToIntDef(value, 0);
      //end;
    end;
  end;

  function GetAttribValue(name: PChar; var value: Integer; len: Integer): Boolean;
  var
    i: integer;
  label GOTVALUE;
  begin
    while (index < size -1) and ((str + index)^ <> '>') do
    begin
      SkipSpaces;
      if (index < size -1) then
      begin
        if not IsThisTag(name, str + index, len) then
        begin
          Result := False;
          exit;
        end;
        Inc(index, len);
        SkipSpaces;
        if (index < size -1) and ((str + index)^ = '=') then
        begin
          Inc(index);
          SkipSpaces;
          value := 0;
          if (index < size -1) and ((str + index)^ = '"') then
          begin
            for i := index + 1 to size -1 do
            begin
              case (str + i)^ of
              '>': begin index := i; goto GOTVALUE; end;
              '"': begin index := i + 1; goto GOTVALUE; end;
              else value := value * 10 + Ord((str + i)^) - Ord('0');
              end;
            end;
            index := size -1;
          end
          else begin
            for i := index to size -1 do
            begin
              case (str + i)^ of
              '>', '/', ' ': begin index := i; goto GOTVALUE; end;
              else value := value * 10 + Ord((str + i)^) - Ord('0');
              end;
            end;
            index := size -1;
          end;
          GOTVALUE:
            result := True;
            exit;
        end;
      end;
    end;
    result := False;
  end;

  procedure SetAttrib;
  var
    value: Integer;
    att: THogeAttribute;
  begin
    if GetAttribValue('i', value, 1) then
    begin
      if (0 <= value) then
      begin
        att := (value * 2) mod 32;
        if att <> FAttribute then
        begin
          Flush;
          FAttribute := att;
        end;
      end;
    end;
  end;

  //aiai
  procedure SetBorder;
  var
    name, value: String;
    color, len: Integer;
    failure: Boolean;

    procedure ReturnValue(i: Integer);
    begin
      if failure then exit;
      case value[i] of
      '0'..'9': color := color * 16 + Ord(value[i]) - Ord('0');
      'A'..'F': color := color * 16 + Ord(value[i]) - Ord('A') + 10;
      'a'..'f': color := color * 16 + Ord(value[i]) - Ord('a') + 10;
      else
        begin
          failure := True;
          exit;
        end;
      end;  //Case
    end;

  begin
    GetAttribPair(name, value);
    len := Length(value);
    color := 0;
    failure := False;
    if (name = 'color') then
    begin
      if len = 6 then
      begin
        ReturnValue(5);  //Blue
        ReturnValue(6);  //Blue
        ReturnValue(3);  //Green
        ReturnValue(4);  //Green
        ReturnValue(1);  //Red
        ReturnValue(2);  //Red
      end else if (len = 7) and (value[1] = '#') then
      begin
        ReturnValue(6);  //Blue
        ReturnValue(7);  //Blue
        ReturnValue(4);  //Green
        ReturnValue(5);  //Green
        ReturnValue(2);  //Red
        ReturnValue(3);  //Red
      end;
      WriteHR(color, not failure);
    end else
      WriteHR(0, False);
  end;

  //aiai
  procedure SetPicture;
  var
    name, value, pass: String;
    overlap: Boolean;
  begin
    overlap := False;
    while GetAttribPair(name, value) do
    begin
      if (name = 'src') and (0 < length(value)) then
      begin
        pass := value;
      end else if (name = 'align') and (0 < length(value)) then
      begin
        if value = 'overlap' then
          overlap := True;
      end;
    end;
    if pass <> '' then
      WritePicture(pass, overlap);
  end;


begin
  {aiai}
  result := False;
  if (str + index)^ = '<' then
  begin
    Inc(index);
    if index >= size then exit;
    if (str + index)^ = '/' then begin
      Inc(index);
      if index >= size then exit;
      if IsThisTag('b', str + index, 1) then begin
        Inc(index);
        SetBold(False);
      end else if IsThisTag('dd', str + index, 2) then begin
        Inc(index, 2);
        FOffsetLeft := FOffsetBQ;
      end else if IsThisTag('dl', str + index, 2) then begin
        Inc(index, 2);
        FOffsetLeft := FOffsetBQ;
      end else if IsThisTag('p', str + index, 1) then begin
        Inc(index);
        WriteBR;
      end else if IsThisTag('li', str + index, 2) then begin
        Inc(index, 2);
        WriteBR;
      end else if IsThisTag('blockquote', str + index, 10) then begin
        Inc(index);
        Dec(FOffsetBQ, FDDOffsetLeft);
        if FOffsetBQ<0 then
          FOffsetBQ := 0;
        Dec(FOffsetLeft, FDDOffsetLeft);
        if FOffsetLeft<0 then
          FOffsetBQ := 0;
      end else if IsThisTag('a', str + index, 1) then begin
        Inc(index);
        EndAnchor;
      end else if IsThisTag('font', str + index, 4) then begin
        Inc(index, 4);
        EndFont;
      end;
    end else begin
      if IsThisTag('br', str + index, 2) then begin
        Inc(index, 2);
        WriteBR;
      end else if IsThisTag('SA', str + index, 2) then begin
        Inc(index, 2);
        SetAttrib;
      end else if IsThisTag('b', str + index, 1) then begin
        Inc(index);
        SetBold(True);
      end else if IsThisTag('dt', str + index, 2) then begin
        Inc(index, 2);
        FOffsetLeft := FOffsetBQ;
      end else if IsThisTag('dd', str + index, 2) then begin
        Inc(index, 2);
        WriteBR;
        FOffsetLeft := FOffsetBQ + FDDOffsetLeft;
      end else if IsThisTag('ul', str + index, 2) then begin
        Inc(index, 2);
        WriteBR;
      end else if IsThisTag('blockquote', str + index, 10) then begin
        Inc(index, 10);
        Inc(FOffsetBQ, FDDOffsetLeft);
        Inc(FOffsetLeft, FDDOffsetLeft);
      end else if IsThisTag('hr', str + index, 2) then begin
        Inc(index, 2);
        SetBorder;
      end else if IsThisTag('img', str + index, 3) then begin
        Inc(index, 3);
        SetPicture;
      end else if IsThisTag('font', str + index, 4) then begin
        Inc(index, 4);
        SetFont;
      end else if IsThisTag('a', str + index, 1) then begin
        Inc(index);
        BeginAnchor;
      end else if IsThisTag('body', str + index, 4) then begin
        Inc(index, 4);
        SetBody;
      end;
    end;
    EndOfTag;
    Result := True;
  end;
  {/aiai}
end;

(* (str + index)^ = '&' *)
function TDat2View.ProcEntity: boolean;
var
  i, len, val: integer;

  procedure OutCode;
  begin

    Inc(i, len);
    if  130 < val then
    begin
      if val <> 3642 then
        WriteUNICODE(PChar(@val), 2);
    end
    else if Chr(val) in LeadBytes then
    begin
      FStream.WriteBuffer((str + index)^, i - index)
    end
    else if 32 <= val then
      FStream.WriteBuffer(PChar(@val)^, 1);
    index := i;
    if (str + index)^ = ';' then
      Inc(index);
  end;

  {beginner} //実体参照→ユニコード
  function GetEntityCode(s: String; var Code: Word): Boolean;
  var
    i: Integer;
  begin
    Code := 0;
    Result := False;
    for i := Low(CharEntryList) to High(CharEntryList) do
      if s = CharEntryList[i].Ent then
      begin
        Code := CharEntryList[i].Cd;
        Result := True;
        Break;
      end;
  end;

  procedure OutAscii(Ch: Char);
  begin
    WriteChar(Ch);
    index := i + 1;
    if (index < size) and ((str + index)^ = ';') then
      Inc(index);
  end;
var
  s: string;
  Code: Word;
begin
  result := true;
  i := index + 1;
  if (str + i)^ = '#' then
  begin
    val := 0;
    Inc(i);
    if (str + i)^ in ['X','x'] then
    begin
      Inc(i);
      if GetHex(str + i, size - i, val, len) then
      begin
        OutCode;
        exit;
      end;
    end
    else begin
      if GetDecimal(str + i, size - i, val, len) then
      begin
        OutCode;
        exit;
      end;
    end;
  end
  else begin
    while i < size do
    begin
      case (str + i)^ of
      'A'..'Z','a'..'z','0'..'9':
        begin
          s := s + (str + i)^;
          if s = 'amp' then  (* 古いログに ; 等で終らないのがある *)
          begin
            OutAscii('&');
            exit;
          end else
          if s = 'gt' then
          begin
            OutAscii('>');
            exit;
          end else
          if s = 'lt' then
          begin
            OutAscii('<');
            exit;
          end else
          if s = 'quot' then
          begin
            OutAscii('"');
            exit;
          end else
          if s = 'nbsp' then
          begin
            WriteUNICODE(PChar(#160#0), 2);
            index := i + 1;
            if (index < size) and ((str + index)^ = ';') then
              Inc(index);
            exit;
          end;
        end;
      else
        begin
          Result := False;
          if (str + i)^ = ';' then
          begin
            Inc(i);
            if GetEntityCode(s, Code) then
            begin
              WriteUNICODE(PChar(@Code), 2);
              index := i;
              Result := True;
            end;
          end;
          Exit;
        end;
      end;
      Inc(i);
    end;
  end;
  result := false;
end;

function TDat2View.ProcBlank: boolean;
var
  i: integer;
begin
  result := true;
  i := index + 1;
  while ((str + i)^ = ' ') and (i < size) do
    Inc(i);
  index := i;
  WriteChar(' ')
end;

//aiai
(* dateのサイズチェックは呼び出し側ですること *)
(* 年は4桁,1月と2月は前の年の13月と14月とする *)
function CalcDayOfWeek(date: PChar; num:integer): string; (* 曜日だけ返す *)
var
  intyear, intmon, intday, thedayofweek: Integer;
begin
  case num of
    2: begin //年が2桁の場合
      intyear := (Ord(date^) - 48) * 10 + Ord((date+1)^) - 48;
      intmon  := (Ord((date+3)^) - 48) * 10 + Ord((date+4)^) - 48;
      intday  := (Ord((date+6)^) - 48) * 10 + Ord((date+7)^) - 48;

      if intyear < 100 then // 90～99年は1990～1999年に、それ以外は2000年以降にする
        if (intyear >= 90) and (intyear <= 99) then
          Inc(intyear, 1900)
        else
          Inc(intyear, 2000);

    end;

    4: begin //年が4桁の場合
      intyear := (Ord(date^) - 48) * 1000 + (Ord((date+1)^) - 48) * 100 + (Ord((date+2)^) - 48) * 10 + Ord((date+3)^) - 48;
      intmon  := (Ord((date+5)^) - 48) * 10 + Ord((date+6)^) - 48;
      intday  := (Ord((date+8)^) - 48) * 10 + Ord((date+9)^) - 48;

    end;

  else
    begin
      result := '';
      exit;
    end;
  end;

  if (intmon = 1) or (intmon = 2) then //1・2月は前年の13・14月
  begin
    Dec(intyear);
    Inc(intmon, 12);
  end;

  thedayofweek := ( intday + (8 + 13 * intmon) div 5 + intyear
                 + intyear div 4 - intyear div 100 + intyear div 400 ) mod 7;
  (* thedayofweek: 0=Sun 1=Mon 2=Tue 3=Wed 4=Thu 5=Fri 6=Sat *)

  result := Main.Config.optDayOfWeekListForThreView.Strings[thedayofweek];
end;

//aiai
function TDat2View.ProcDayOfWeek: Boolean;
var
  i: integer;
begin
  Result := False;
  if not Main.Config.ojvShowDayOfWeek then
    exit;

  (* 曜日付きがどうか調べる *)
  for i := 0 to size do
    case (str + i)^ of
      #$8C: if (i < size - 1) and ((str + i + 1)^ = #$8E) then exit;  //月
      #$89: if (i < size - 1) and ((str + i + 1)^ = #$CE) then exit;  //火
      #$90: if (i < size - 1) and ((str + i + 1)^ = #$85) then exit;  //水
      #$96: if (i < size - 1) and ((str + i + 1)^ = #$D8) then exit;  //木
      #$8B: if (i < size - 1) and ((str + i + 1)^ = #$E0) then exit;  //金
      #$93: if (i < size - 1) then
              if (str + i + 1)^ = #$79 then exit //土
              else if (str + i + 1)^ = #$FA then exit; //日
    end;  //Case

  (* 年が2桁の場合 *)
  if (size > 8)  and ((str + 2)^ = '/') and ((str + 8)^ = ' ') then
  begin
    WriteText(str, 8);
    WriteText(CalcDayOfWeek(str, 2) + ' ');
    Inc(index, 9);
  (* 年が4桁の場合 *)
  end else if (size > 10) and ((str + 4)^ = '/') and ((str + 10)^ = ' ') then
  begin
    WriteText(str, 10);
    WriteText(CalcdayOfWeek(str, 4) + ' ');
    Inc(index, 11);
  end;
  Result := True;
end;

//aiai
function TDat2View.ProcID: Boolean;
var
  index2: Integer;
begin
  Result := False;
  if not Config.ojvIDPopUp then
    exit;
  index2 := index;
  if ((index2 + 3) < size) and ((str + index2 + 1)^ = 'D')
    and ((str + index2 + 2)^ = ':') and ((str + index2 + 3)^ <> '?')then
  begin
    Inc(index2, 3);

    (* IDの末尾を探す *)
    while index2 < size do
    begin
      if ((str + index2)^ in [' ']) then
        break;
      Inc(index2);
    end;

    WriteID(str + index + 3, index2 - index - 3);

    index := index2;
    Result := True;
  end;
end;

procedure TDat2View.AppendResNumList(num: Integer);
begin
  if (num > 0) and (num < line) then
    FBrowser.SetResNum(num);
end;

procedure TDat2View.AppendResNumList(num, num2: Integer);
var
  i: integer;
begin
  if num >= num2 then exit;
  if (num <= 0) or (num2 <= 0) then exit;
  if (num >= line) or (num2 >= line) then exit;
  if (num2 - num > 20) then exit;

  for i := num to num2 do
    FBrowser.SetResNum(i);
end;

procedure TDat2View.WriteText(str: PChar; size: integer);
begin
  FStream.WriteBuffer(str^, size);
  FBiteSpaces := False;
end;

procedure TDat2View.WriteAnchor(const Name: string;
                                const Href: string;
                                str: PChar; size: integer);
var
  user: integer;
begin
  Flush;
  if 0 < length(Href) then
    user := htvUSER
  else
    user := 0;

  FBrowser.nAppend(str, size, FBold or ATTRIB_LINK or user);
  FBrowser.Append(Name, ATTRIB_ANCHOR_NAME or htvHIDDEN);
  FBrowser.Append(Href, ATTRIB_ANCHOR_HREF or htvHIDDEN);

  FBiteSpaces := False;
end;

procedure TDat2View.WriteBR;
  procedure TrimRight;
  var
    i: integer;
    p: PChar;
  begin
    p := FStream.Memory;
    for i := FStream.Position -1 downto 0 do
    begin
      if (p+i)^ <> ' ' then
      begin
        FStream.Position := i + 1;
        exit;
      end;
    end;
    FStream.Position := 0;
  end;

begin
  if FIgnoreBR then
    exit;
  TrimRight;
  Flush;
  FBrowser.Append(#10);
  FBiteSpaces := True;
end;

//aiai
procedure TDat2View.WriteHR(color: Integer; custom: Boolean);
begin
  Flush;
  FBrowser.AppendHR(color, custom, FOffsetLeft);

  FBiteSpaces := True;
end;

//aiai
procedure TDat2View.WritePicture(pass: String; overlap: Boolean);
var
  Image, ImageConv: TGraphic;
  Ext: String;
  index: Integer;
begin
  Flush;
  Image := nil;
  if not Assigned(ViewList.PictViewList) then
    viewList.PictViewList := TPictureViewList.Create;
  index := ViewList.PictViewList.IndexOf(pass);
  if index <> -1 then
  begin
    Image := TGraphic(ViewList.PictViewList.Objects[index]);
  end else
  begin
    Ext := ExtractFileExt(Config.SkinPath + pass);
    if FileExists(Config.SkinPath + pass) then
    begin
      if SameText(Ext, '.jpg') or SameText(Ext, '.jpeg') then begin

        Image := TBitmap.Create;
        ImageConv := TApiBitmap.Create;
        try
          try
            ImageConv.LoadFromFile(Config.SkinPath + pass);
            Image.Assign(ImageConv);
          finally
            ImageConv.Free;
          end;  //try
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        ViewList.PictViewList.AddObject(pass, Image);

      end else if SameText(Ext, '.png') then begin

        Image := TPNGObject.Create;
        try
          Image.LoadFromFile(Config.SkinPath + pass);
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        ViewList.PictViewList.AddObject(pass, Image);

      end else if SameText(Ext, '.gif') then begin

        Image := TGifImage.Create;
        TGifImage(Image).Animate := False;
        try
          Image.LoadFromFile(Config.SkinPath + pass);
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        ViewList.PictViewList.AddObject(pass, Image);

      end else if SameText(Ext, '.bmp') then begin

        Image := TBitmap.Create;
        try
          Image.LoadFromFile(Config.SkinPath + pass);
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        ViewList.PictViewList.AddObject(pass, Image);
      end else
        exit;
    end else
      exit;
  end;

  FBiteSpaces := FBrowser.AppendPicture(Image, overlap, FOffsetLeft);
end;

procedure TDat2View.WriteWallPaper(const pass: string);
var
  Image, ImageConv: TGraphic;
  Ext: String;
  index: Integer;
begin
  if not Assigned(viewList.wallPaperList) then
    viewList.wallPaperList := TPictureViewList.Create;
  Image := nil;
  index := viewList.wallPaperList.IndexOf(pass);
  if index <> -1 then
    Image := TGraphic(viewList.wallPaperList.Objects[index])
  else
  begin
    Ext := ExtractFileExt(Config.SkinPath + pass);
    if FileExists(Config.SkinPath + pass) then
    begin
      if SameText(Ext, '.jpg') or SameText(Ext, '.jpeg') then begin

        Image := TBitmap.Create;
        ImageConv := TApiBitmap.Create;
        try
          try
            ImageConv.LoadFromFile(Config.SkinPath + pass);
            Image.Assign(ImageConv);
          finally
            ImageConv.Free;
          end;  //try
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        viewList.wallPaperList.AddObject(pass, Image);

      end else if SameText(Ext, '.png') then begin

        Image := TPNGObject.Create;
        try
          Image.LoadFromFile(Config.SkinPath + pass);
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        viewList.wallPaperList.AddObject(pass, Image);

      end else if SameText(Ext, '.gif') then begin

        Image := TGifImage.Create;
        TGifImage(Image).Animate := False;
        try
          Image.LoadFromFile(Config.SkinPath + pass);
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        viewList.wallPaperList.AddObject(pass, Image);

      end else if SameText(Ext, '.bmp') then begin

        Image := TBitmap.Create;
        try
          Image.LoadFromFile(Config.SkinPath + pass);
        except
          on E: Exception do begin
            Main.Log('Load ' + pass+ ':' + E.Message);
            FreeAndNil(Image);
          end;
        end;  //try
        viewList.wallPaperList.AddObject(pass, Image);
      end else
        exit;
    end else
      exit;
  end;

  FBrowser.Wallpaper := Image;
end;

procedure TDat2View.SetBold(boldP: boolean);
begin
  Flush;
  if boldP then
    FBold := 1
  else
    FBold := 0;
end;

procedure TDat2View.WriteChar(c: Char);
begin
  if FBiteSpaces and (c = ' ') then
    exit;
  FBiteSpaces := False;
  if ' ' <= c then
    FStream.WriteChar(c);
end;

//aiai
//strはID:を含まない
procedure TDat2View.WriteID(str: PChar; size: integer);
var
  idstring: string;
begin
  SetString(idstring, str, size);
  WriteAnchor('', 'ID:' + idstring, 'ID:', 3);
  WriteText(str, size);

  if Config.ojvIDLinkColor then
  begin
    while FBrowser.IDList.Count > line - 1 do
      FBrowser.IDList.Delete(line - 1);
    while FBrowser.IDList.Count < line - 1 do
      FBrowser.IDList.Append('');
    FBrowser.IDList.Append(idstring);
  end;
end;

procedure TDat2View.WriteUNICODE(str: PChar; size: integer);
begin
  Flush;
  FBiteSpaces := False; //beginner
  FBrowser.nAppend(str, size, FBold or FAttribute or htvUNICODE);
end;

procedure TDat2View.Flush;
begin
  FBrowser.Strings[FBrowser.Strings.Count -1].OffsetLeft := FOffsetLeft;
  if FStream.Position <= 0 then
    exit;
  if FUser <> 0 then
    FBrowser.nAppend(FStream.Memory, FStream.Position, FBold or FUser)
  else
    FBrowser.nAppend(FStream.Memory, FStream.Position, FBold or FAttribute);
  FStream.Position := 0;
  Inc(flushCount);
  if (flushCount mod 256) = 0 then
  begin
    Inc(re_entrant);
    Application.ProcessMessages;
    Dec(re_entrant);
  end;
end;

procedure TDat2View.Cancel;
begin
  canceled := true;
end;

procedure TDat2View.SetIgnoreBR(ABool: Boolean);
begin
  FIgnoreBR := ABool;
end;

(*=======================================================*)

procedure TDat2PopupView.AppendResNumList(num: Integer);
begin
end;

procedure TDat2PopupView.AppendResNumList(num, num2: Integer);
begin
end;

function TDat2PopupView.ProcBlank: boolean;
begin
  Result := False;
end;

procedure TDat2PopupView.WriteChar(c: Char);
begin
  if ' ' <= c then
    FStream.WriteChar(c);
end;

procedure TDat2PopupView.WriteID(str: PChar; size: integer);
var
  idstring: string;
begin
  SetString(idstring, str, size);
  WriteAnchor('', 'ID:' + idstring, 'ID:', 3);
  WriteText(str, size);
end;

(*=======================================================*)

procedure TDat2ViewForExtraction.AppendResNumList(num: Integer);
begin
end;

procedure TDat2ViewForExtraction.AppendResNumList(num, num2: Integer);
begin
end;

procedure TDat2ViewForExtraction.WriteAnchor(const Name: string;
                      const HRef: string;
                      str: PChar; size: integer);
var
  ModifHref:string;
  Hyphen: Integer;
begin
  ModifHref := HRef;
  if (HRef<>'') then begin
    if HRef[1] = '#' then
      case BBSType of
        bbsJBBS, bbsMachi: begin
          Hyphen := Pos('-', HRef);
          if Hyphen > 0 then
            ModifHref := Base + '&START=' + copy(HRef, 2, Hyphen - 2) + '&END=' + copy(HRef, Hyphen + 1, High(Integer))
          else
            ModifHref := Base + '&START=' + copy(HRef, 2, High(Integer)) + '&END=' + copy(HRef, 2, High(Integer));
        end;
      else
        ModifHref := Base + copy(HRef, 2, High(Integer));
      end
    else if StrLIComp('menu:', pchar(HRef), 5) = 0 then
      case BBSType of
        bbsJBBS, bbsMachi:
          ModifHref := Base + '&START=' + copy(HRef, 6, High(Integer)) + '&END=' + copy(HRef, 6, High(Integer));
      else
        ModifHref := Base + copy(HRef, 6, High(Integer));
      end;
  end;
  inherited WriteAnchor(Name,ModifHref,str,size);
end;

procedure TDat2ViewForExtraction.Flush;
begin
  FBrowser.Invalidate;
  inherited;
end;

procedure TDat2ViewForExtraction.WriteID(str: PChar; size: integer);
var
  idstring: string;
begin
  SetString(idstring, str, size);
  WriteAnchor('', 'ID:' + idstring, 'ID:', 3);
  WriteText(str, size);
end;

(*=======================================================*)

procedure TSimpleDat2View.AppendResNumList(num: Integer);
begin
end;

procedure TSimpleDat2View.AppendResNumList(num, num2: Integer);
begin
end;

procedure TSimpleDat2View.BeginAnchor;
var
  name, value: string;
begin
  Flush;
  FHref := '';
  while GetAttribPair(name, value) do
  begin
    if name = 'href' then
    begin
      FHref := value;
      break;
    end;
  end;
  FUser := htvUSER or ATTRIB_LINK;
end;

procedure TSimpleDat2View.EndAnchor;
begin
  Flush;
  FBrowser.Append(FHref, ATTRIB_ANCHOR_HREF or htvHIDDEN);
  FUser := 0;
end;

function TSimpleDat2View.ProcTag: boolean;
  procedure ProcLineFeed;
  begin
    if not FBiteSpaces then
      WriteBR;
    EndOfTag;
    result := True;
  end;
var
  tag: string;
  tmpIndex: Integer;
begin
  if (str + index)^ = '<' then
  begin
    tmpIndex  := Index;
    Inc(index);
    tag := GetTagName;
    if tag = 'blockquote' then
    begin
      ProcLineFeed;
      FOffsetLeft := DDOffsetLeft;
    end else
    if tag = '/blockquote' then
    begin
      FOffsetLeft := 0;
      ProcLineFeed;
    end else
    if (tag = 'dt') or (tag = 'dd') or (tag = 'li') or (tag = 'p') then
      ProcLineFeed
    {aiai}
    else if (tag = 'img') then begin
      EndOfTag;
      result := true;
    end
    {/aiai}
    else
    begin
      index := tmpIndex;
      result := inherited ProcTag;
    end;
  end
  else
    result := false;
end;

procedure TSimpleDat2View.ProcHTML;
begin
  while (index < size) do
  begin
    if not ((((str + index)^ = '<') and ProcTag) or
           (((str + index)^ = '&') and ProcEntity) or
           (((str + index)^ = ' ') and ProcBlank)) then
    begin
      case (str + index)^ of
      #0..#$1F:;
      else
        WriteChar((str + index)^);
      end;
      Inc(index);
    end;
  end;
end;

procedure TSimpleDat2View.Flush;
begin
  FBrowser.Invalidate;
  inherited;
end;

procedure TSimpleDat2View.WriteID(str: PChar; size: integer);
begin
  WriteAnchor('', '', 'ID:', 3);
  WriteText(str, size);
end;

(*=======================================================*)

{aiai}//とりあえずプレビュー用Dat2View

{ TDat2PreViewView }

//レス番着色しない
procedure TDat2PreViewView.AppendResNumList(num: Integer);
begin
end;

procedure TDat2PreViewView.AppendResNumList(num, num2: Integer);
begin
end;

//レス番クリックメニューを出さなくする
procedure TDat2PreViewView.WriteAnchor(const Name: string;
                                       const HRef: string;
                                       str: PChar; size: integer);
var
  user: integer;
begin
  Flush;
  if (0 < length(Href)) and (1 <> Pos('menu:', HRef)) then
    user := htvUSER
  else
    user := 0;

  FBrowser.nAppend(str, size, FBold or ATTRIB_LINK or user);
  FBrowser.Append(Name, ATTRIB_ANCHOR_NAME or htvHIDDEN);
  FBrowser.Append(Href, ATTRIB_ANCHOR_HREF or htvHIDDEN);

  FBiteSpaces := False;
end;

procedure TDat2PreViewView.WriteID(str: PChar; size: integer);
begin
  WriteAnchor('', '', 'ID:', 3);
  WriteText(str, size);
end;


 { TStrDatOutForHint }

// TDatOut.ProcDayOfWeekと同じ
function TStrDatOutForHint.ProcDayOfWeek: Boolean;
var
  i: integer;
begin
  Result := False;
  if not Main.Config.ojvShowDayOfWeek then
    exit;

  (* 曜日付きがどうか調べる *)
  for i := 0 to size do
    case (str + i)^ of
      #$8C: if (i < size - 1) and ((str + i + 1)^ = #$8E) then exit;  //月
      #$89: if (i < size - 1) and ((str + i + 1)^ = #$CE) then exit;  //火
      #$90: if (i < size - 1) and ((str + i + 1)^ = #$85) then exit;  //水
      #$96: if (i < size - 1) and ((str + i + 1)^ = #$D8) then exit;  //木
      #$8B: if (i < size - 1) and ((str + i + 1)^ = #$E0) then exit;  //金
      #$93: if (i < size - 1) then
              if (str + i + 1)^ = #$79 then exit //土
              else if (str + i + 1)^ = #$FA then exit; //日
    end;  //Case

  (* 年が2桁の場合 *)
  if (size > 8)  and ((str + 2)^ = '/') and ((str + 8)^ = ' ') then
  begin
    WriteText(str, 8);
    WriteText(CalcDayOfWeek(str, 2) + ' ');
    Inc(index, 9);
  (* 年が4桁の場合 *)
  end else if (size > 10) and ((str + 4)^ = '/') and ((str + 10)^ = ' ') then
  begin
    WriteText(str, 10);
    WriteText(CalcdayOfWeek(str, 4) + ' ');
    Inc(index, 11);
  end;
  Result := True;
end;

{/aiai}

(*=======================================================*)

{beginner} //ツリー表示関係

{ TIndexTree }

constructor TIndexTree.Create;
begin
  inherited Create;
  ShowRoot := True;
  AllowDup := False;
  HeadLineLength := 80;
  LevelLimit := High(Integer);
  TraceBackLimit := High(Integer) div 2;
  FtmpDat := nil;
end;


procedure TIndexTree.Build(thread: TThreadItem; Start: Integer);
var
  D2HTML: TDat2HTML;
begin

  if (thread = nil) or (thread.dat = nil) then
    exit;

  if Assigned(FThread) then
    FThread.Release;
  FThread := thread;
  FThread.AddRef;

  Trunk.Free;
  Trunk := TList.Create;
  Trunk.Count := thread.Lines + 1;  //TListは0から、TThreadItemは1から始まる

  if Start<=FThread.lines then
    Pos := Start
  else
    Pos := 1;

  FtmpDat.Free;
  FtmpDat := thread.DupData;
  D2HTML := SetUpDat2HTML((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).RecHTML, dhtRes);
  D2HTML.URL := FThread.ToURL;
  D2HTML.Title := FThread.title;
  D2HTML.ToDatOut(Self, FtmpDat ,Pos, thread.lines - Pos + 1, FThread.ABoneArray, FThread.NeedConvert);
  D2HTML.Free;
end;


destructor TIndexTree.Destroy;
var
  i: Integer;
begin
  FtmpDat.Free;
  FThread.Release;
  if Assigned(Trunk) then
    for i := 0 to Trunk.Count - 1 do
      TCardinalList(Trunk[i]).Free;
  Trunk.Free;
  inherited;
end;

function TIndexTree.ProcTag: Boolean;
var
  tag: string;
  i: integer;
begin
  if (str + index)^ = '<' then
  begin
    i := index;
    Inc(index);
    tag := GetTagName;
    EndOfTag;
    if (tag <> 'a') and (tag <> '/a') then
      WriteText(str + i, index - i);
    result := True;
  end
  else
    result := false;
end;


procedure TIndexTree.WriteText(str: PChar; size: integer);
begin
  ; //Abstructエラー回避のため。
end;


//D2HTMLのアンカーとリンク出力を受け取ってレス間の関連づけをする
procedure TIndexTree.WriteAnchor(const Name: string;
                 const HRef: string; str: PChar; size: integer);
var
  LinkTo: Integer;
  LinkToBegin, LinkToEnd: Integer;
  Hyphen: PChar;
begin
  if Name <> '' then
    Pos := StrToIntDef(Name, Pos);

  if (HRef <>'') and (HRef[1] = '#') then begin
    Hyphen := AnsiStrScan(PChar(HRef) + 1, '-');
    if Hyphen = nil then begin
      LinkToBegin := StrToIntDef(PChar(HRef)+1, -1);
      LinkToEnd := LinkToBegin;
    end else begin
      LinkToBegin := StrToIntDef(Copy(HRef, 2, Hyphen - @HRef[2]), -1);
      LinkToEnd   := StrToIntDef(Hyphen + 1, LinkToBegin);
    end;

    For LinkTo := LinkToBegin to LinkToEnd do
      if (LinkTo > 0) and (LinkTo < Pos) and (LinkTo + TraceBackLimit >= Pos) then begin
        if Trunk[LinkTo] = nil then
          Trunk[LinkTo] := TCardinalList.Create;
        if (TCardinalList(Trunk[LinkTo]).Count = 0) or
           (Int64(TCardinalList(Trunk[LinkTo])[TCardinalList(Trunk[LinkTo]).Count - 1]) < Int64(Pos)) then
          TCardinalList(Trunk[LinkTo]).Add(Pos);
      end;
  end;
end;

//ツリーをレス形式で出力
function TIndexTree.TreeDatOut(Dest: TDatOut;
                               Index: Integer = -1;
                               AboneArray: TAboneArray = nil;
                               NeedConvert: Boolean = False): Integer;
var
  D2HTMLForTree: TDat2HTML;

  procedure Nesting(Index: Integer; Level: Integer);
  var
    i: Integer;
    NotIndented: Boolean;
    Branch: TCardinalList;
  begin

    if (Level > 0) or ShowRoot then
      Inc(Result, D2HTMLForTree.ToDatOut(Dest, FtmpDat, Index, 1, AboneArray, NeedConvert));

    if Assigned(Mask) then
      Mask[Index] := True;

    Branch := TCardinalList(Trunk[Index]);

    if Assigned(Branch) and (Level < LevelLimit) then begin
      NotIndented := True;

      for i := 0 to Branch.Count - 1 do begin
        if (Mask = nil) or not Mask[Branch[i]] or AllowDup then begin
          if NotIndented then begin
            Dest.WriteHTML('<blockquote>'#13#10);
            NotIndented := False;
          end;
          Dest.WriteHTML('<SA i=2/>▼ <SA i=0/>');
          Nesting(Branch[i], Level + 1);
        end;
      end;

      if not NotIndented then
        Dest.WriteHTML('</blockquote>'#13#10);

    end;
  end;

var
  i: Integer;
begin

  D2HTMLForTree := TDat2HTML.Create(DEF_TREE_HTML, Config.SkinPath);
  D2HTMLForTree.NGItems := Main.NGItems;
  D2HTMLForTree.AboneLevel := Main.AboneLevel;
  D2HTMLForTree.TransparencyAbone := Config.viewTransparencyAbone;

  Result := 0;
  if Index = -1 then begin
    for i := 1 to Trunk.Count - 1 do
      if (Mask = nil) or not Mask[i] then
        Nesting(i, 0);
  end else begin
    if (Mask = nil) or not Mask[Index] then
      Nesting(Index, 0);
  end;

  D2HTMLForTree.Free;

end;


//アウトライン＋ポップアップ形式で出力
function TIndexTree.OutLine(Dest: TDatOut;
                            Index: Integer = -1;
                            AboneArray: TAboneArray = nil;
                            NeedConvert: Boolean = False): Integer;
var
  IndexList: TCardinalList;
  LevelList: TCardinalList;
  LevelMax: Integer;

  procedure Nesting(Index: Integer; Level: Integer);
  var
    i: Integer;
    Branch: TCardinalList;
  begin

    if Assigned(Mask) and Mask[Index] and (not(AllowDup) or (Level = 0)) then Exit;

    IndexList.Add(Index);
    LevelList.Add(Level);
    if Level > LevelMax then
      LevelMax := Level;

    if Assigned(Mask) then
      Mask[Index] := True;

    if Level < LevelLimit then begin
      Branch := TCardinalList(Trunk[Index]);
      if Assigned(Branch) then begin
        for i := 0 to Branch.Count - 1 do
          Nesting(Branch[i], Level + 1);
      end;
    end;

  end;

  function CutAnsi(s: String; Len: Integer): String;
  begin
    if Len = 0 then begin
      Result := '';
      Exit;
    end;

    if Length(s) <= Len then begin
      Result := s;
      Exit;
    end;

    if (StrByteType(PChar(s), Len - 1) = mbLeadByte) and (Length(s) > Len + 1) then
      Inc(Len);
    Result := copy(s, 1, Len)+'...';
  end;

var
  i, j, l: Integer;
  s : String;
  LvState: array of Boolean;
  Indent: TStringList;
  StrDatOut: TStrDatOut;
begin
  IndexList := TCardinalList.Create;
  LevelList := TCardinalList.Create;
  LevelMax := 0;

  if Index = -1 then begin
    IndexList.Capacity := Trunk.Count;
    LevelList.Capacity := Trunk.Count;
    for i := 1 to Trunk.Count - 1 do
      Nesting(i, 0);
  end else begin
    Nesting(Index, 0);
  end;

  SetLength(LvState, LevelMax + 1);
  for i := 0 to High(LvState) do
    LvState[i] := False;

  Indent := TStringList.Create;
  Indent.Capacity := Trunk.Count;

  for i := IndexList.Count - 1 downto 0 do begin
    if LevelList[i] > 0 then begin

      SetLength(s, LevelList[i] * 2);
      for j := 1 to LevelList[i] - 1 do
        if LvState[j] then
           StrLCopy(PChar(s) + j * 2 - 2, '│',2)
        else
           StrLCopy(PChar(s) + j * 2 - 2, '　',2);

      If LvState[LevelList[i]] then
        StrLCopy(PChar(s) + LevelList[i] * 2 - 2, '├',2)
      else
        StrLCopy(PChar(s) + LevelList[i] * 2 - 2, '└',2);

      Indent.Add(s);

    end else begin
      Indent.Add('');
    end;
    for j := LevelList[i] + 1 to High(LvState) do
      LvState[j] := False;
    LvState[LevelList[i]] := True;
  end;

  for i :=0 to IndexList.Count - 1 do begin
    if (i > 0) and (LevelList[i] = 0) then
      Dest.WriteHTML('<br>');
    s := IntToStr(IndexList[i]);
    Dest.WriteHTML(Indent[IndexList.Count - i - 1] + '<b>');
    Dest.WriteAnchor('', '#' + s, PChar(s), Length(s));
    Dest.WriteHTML('</b>');
    StrDatOut :=TStrDatOut.Create;

    StrDatOut.WriteHTML( FtmpDat.FetchMessage(IndexList[i]));

    l := HeadLineLength - Length(Indent[IndexList.Count - i - 1]);
    if l<0 then
      l := 0;
    {aiai}
    //Dest.WriteText('　　　　' +
    //               CutAnsi(StringReplace(StrDatOut.Text, #13#10, '', [rfReplaceAll, rfIgnoreCase]), l));
    s := CutAnsi(StringReplace(StrDatOut.Text, #13#10, '', [rfReplaceAll, rfIgnoreCase]), l);
    if NeedConvert then
      s := euc2sjis(s);
    Dest.WriteText('　　　　' + s);
    {/aiai}
    StrDatOut.Free;
    Dest.WriteHTML('<br>');
  end;

  Result := IndexList.Count;


  Indent.Free;
  LevelList.Free;
  IndexList.Free;

end;


{ TStrDatOutForHeadline } //TStrDatOutと同じだけど、文字参照を処理しない

function TStrDatOutForHeadline.ProcEntity: boolean;
begin
  Result := False;
end;


{/beginner}

(*=======================================================*)

{ TBaseViewItem }

constructor TBaseViewItem.Create;
begin
  inherited;
  FLockCount := 0;
  FThread := nil;
  FPossessionView := nil;
end;

destructor TBaseViewItem.Destroy;
begin
  ReleasePossessionView;
  inherited;
end;

procedure TBaseViewItem.ReleasePossessionView;
begin
  if Assigned(FPossessionView) then
    FPossessionView.Release;
end;

function TBaseViewItem.GetBaseThread: TThreadItem;
begin
  Result := nil;
end;

{function TBaseViewItem.GetFocusedLink: String;
var
  browser: THogeTextView;
  Point: TPoint;
  item: THogeTVItem;
begin
  //本来はabstractにしてPlainあたりの派生クラスで定義すべきだけど、
  //HogeTextViewが2箇所で使われるので、Baseで定義して手抜き
  try
    browser := GetDerivativeBrowser as THogeTextView;
    if browser = nil then
      Abort;
    point := browser.Caret;
    item := browser.Strings[point.Y];
    Result := item.GetEmbed(point.X + 1);
  except
    Result := '';
  end;
end;}

//aiai CaretでなくCursorの下のリンクを取得し、結果をFLinkTextに入れる
function TBaseViewItem.GetLinkUnderCursor: String;
var
  browser: THogeTextView;
  Point: TPoint;
  item: THogeTVItem;
begin
  FLinkText := '';
  Result := '';
  try
    browser := GetDerivativeBrowser as THogeTextView;
    if browser = nil then
      Abort;
    GetCursorPos(Point);
    if InvalidPoint(Point) then exit;
    Point := browser.ScreenToClient(Point);
    if InvalidPoint(Point) then exit;
    Point := browser.ClientToPhysicalCharPos(Point.X, Point.Y);
    if InvalidPoint(Point) then exit;
    item := browser.Strings[point.Y];
    FLinkText := item.GetEmbed(point.X + 1);
    Result := FLinkText;
  except
    Result := '';
  end;
end;

procedure TBaseViewItem.SelectAll;
var
  Browser: THogeTextView;
begin
  try
    browser := GetDerivativeBrowser as THogeTextView;
  except
    Browser := nil;
  end;

  if Assigned(Browser) then
    with Browser do
    begin
      BeginningOfBuffer;
      SetMarkCommand;
      EndOfBuffer;
      Selecting := True;
    end;
end;

function TBaseViewItem.IsMouseInPane: Boolean;
var
  Browser: TControl;
begin
  Browser := GetDerivativeBrowser;
  Result := Assigned(Browser) and MouseInPane(Browser);
end;

procedure TBaseViewItem.Lock;
begin
  Inc(FLockCount);
end;

procedure TBaseViewItem.UnLock;
begin
  if Locked then
    Dec(FLockCount);
end;

function TBaseViewItem.Locked: Boolean;
begin
  Result := (FLockCount > 0);
end;

function TBaseViewItem.ValidateURI(source: String; var full: String): Boolean;
begin
  full := source;
  Result := True;
end;

function TBaseViewItem.BrowserQueryClose: Boolean;
begin
  Result := False;
end;

function TBaseViewItem._ExtractKeyWord(thread: TThreadItem; dest: TDatOut;
  targetList: TStrings; Max: Integer; GrepMode: Byte;{koreawatcher} RegExp: TRegExp = nil;
  IncludeRef: Boolean = False; NeedTitle: Boolean = False{/koreawatcher}): Integer;
  procedure ShowTitle(thread: TThreadItem);
  var
    board: TBoard;
    category: TCategory;
  begin
    board := TBoard(thread.board);
    category := TCategory(board.category);
    dest.WriteHTML('</dl><br><br><b>=================================================<br>'#13#10
                     + category.name + ' [' + board.name + '] ');
    dest.WriteAnchor('', Thread.ToURL(false, false), PChar(thread.title), Length(thread.title));
    dest.WriteHTML('<br>=================================================</b><br><br><dl>'#13#10);
  end;
var
  i, j: Integer;
  s: String;
  dup: TThreadData;
  Mask: TBits;
  Tree: TIndexTree;
  SEARCHD2HTML: TDat2HTML;
  D2HTML: TDat2HTML;
  hr: Boolean;
begin
  dup := thread.DupData;
  Mask := nil;
  Tree := nil;
  SEARCHD2HTML := SetUpDat2HTML(TSkinCollection(SkinCollectionList.Items[TBoard(thread.board).CustomSkinIndex]).PopupRecHTML, dhtSearchRes);
  D2HTML := SetUpDat2HTML(TSkinCollection(SkinCollectionList.Items[TBoard(thread.board).CustomSkinIndex]).RecHTML, dhtRes);
  D2HTML.URL := thread.ToURL; 
  D2HTML.Title := thread.title;
  try
    if IncludeRef then
    begin
      Mask := TBits.Create;
      mask.Size := thread.lines + 1;

      Tree := TIndexTree.Create;
      Tree.AllowDup := Config.ojvAllowTreeDup;
      Tree.HeadLineLength := Config.ojvLenofOutLineRes;
      Tree.Mask := Mask;
      Tree.Build(thread, 1);
    end;
    Result := 0;
    for i := 1 to thread.lines do
    begin
      s := SEARCHD2HTML.ToString(dup, i, 1, thread.NeedConvert);
      hr := GrepMode = GREP_OPTION_AND;
      if Assigned(RegExp) then
      begin
        s := AnsiReplaceStr(s, #10' ', #10);
        s := AnsiReplaceStr(s, ' '#13, #13);
        for j := 0 to targetList.Count - 1 do
        begin
          try
            RegExp.Pattern := targetList.Strings[j];
            if GrepMode = GREP_OPTION_AND then
              hr := hr and RegExp.Test(s)
            else if RegExp.Test(s) then
            begin
              hr := true;
              break;
            end;
          except
            on E: Exception do begin
              Log('TBaseViewItem._ExtractKeyWord: ' + e.Message);
              exit;
            end;
          end;
        end;
        if hr then
        begin
          if NeedTitle then
          begin
            ShowTitle(thread);
            NeedTitle := False;
          end;
          if IncludeRef then
          begin
            inc(Result, Tree.TreeDatOut(dest, i, thread.ABoneArray, thread.NeedConvert));
          end
          else
          begin
            D2HTML.ToDatOut(dest, dup, i, 1, thread.ABoneArray, thread.NeedConvert);
            inc(Result);
          end;
        end;
      end
      else
      begin
        for j := 0 to targetList.Count - 1 do
        begin
          if GrepMode = GREP_OPTION_AND then
            hr := hr and AnsiContainsText(s, targetList.Strings[j])
          else if AnsiContainsText(s, targetList.Strings[j]) then
          begin
            hr := true;
            break;
          end;
        end;
        if hr then
        begin
          if NeedTitle then
          begin
            ShowTitle(thread);
            NeedTitle := False;
          end;
          if IncludeRef then
          begin
            inc(Result, Tree.TreeDatOut(dest, i, thread.ABoneArray, thread.NeedConvert));
          end
          else
          begin
            D2HTML.ToDatOut(dest, dup, i, 1, thread.ABoneArray, thread.NeedConvert);
            inc(Result);
           end;
        end;
      end;
      if (Max > 0) and (Result >= Max) then
        Break;
      if GetStreamCanceled then
        Break;
    end;
  finally
    Mask.Free;
    Tree.Free;
    dup.Free;
    SEARCHD2HTML.Free;
    D2HTML.Free;
  end;
end;

(*=======================================================*)

{ TPlainViewItem }



function TPlainViewItem.GetSelection: String;
begin
  if Assigned(browser) then
    Result := browser.Selection
  else
    Result := '';
end;

procedure TPlainViewItem.SetBrowser(value: THogeTextView);
begin
  if Assigned(FBrowser) then
    FBrowser.Tag := 0;
  FBrowser := value;
  if Assigned(FBrowser) then
    FBrowser.Tag := Integer(Self);
end;

function TPlainViewItem.GetBaseItem: TBaseViewItem;
begin
  Result := Self;
end;

function TPlainViewItem.GetRootControl: TWinControl;
begin
  Result := FRootControl;
end;

function TPlainViewItem.GetDerivativeBrowser: TControl;
begin
  Result := FBrowser;
end;

function TPlainViewItem.GetDerivativeStream: TDatOut;
begin
  Result := FStream;
end;

procedure TPlainViewItem.Cancel;
begin
  if Assigned(FStream) then
    FStream.Cancel;
end;

function TPlainViewItem.GetStreamCanceled;
begin
  Result := Assigned(FStream) and FStream.canceled;
end;


(*=======================================================*)

{ TFlexViewItem }


function TFlexViewItem.ValidateURI(source: String; var full: String): Boolean;
begin
  if (Base <> '') and (source <> 'ページが表示されました') and (source <> '') then
  begin
    Result := True;
    if AnsiCompareStr('about:blank', source) = 0 then
      full := source
    else if StartWith('about:', source, 1) then
      full := CombineURI(Base, Copy(source, 7, High(Integer)))
    else
      full := CombineURI(Base, source);
  end else
    Result := inherited ValidateURI(source, full);
end;

(*=======================================================*)
(*  *)
constructor TViewItem.Create(parent: TViewList);
begin
  inherited Create;
  FBrowser := nil;
  FStream  := nil;
  FThread  := nil;
  FProgress:= tpsNone;
  FNaviStat:= tpsNone;
  FPreStat := tpsNone;
  FAsyncStat:= tpsNone;
  nextThread := nil;
  viewList := parent;
  pumpCount:= 0;

  re_entrant := 0;
  freeByCancel := false;
  canceled := false;
  currentCheckNew := False;
  newDrawStartline := -1;
end;

(*  *)
destructor TViewItem.Destroy;
begin
  FreeStream;
  FreeThread;
  if assigned(nextThread) then
    nextThread.Release;
  if browser <> nil then
  begin
    browser.Free;
  end;
  inherited;
end;

(*  *)
procedure TViewItem.FreeStream;
begin
  if assigned(FSTream) then
    FStream.Free;
  FStream := nil;
end;

(*  *)
procedure TViewItem.FreeThread(savePos: boolean = True);
begin
  if assigned(FThread) then
  begin
    if savePos and assigned(browser) then
      SaveViewPos;
    FThread.Release;
  end;
  FThread := nil;
end;

(* このルーチンは怪しい *)
function TViewItem.GetTopRes: integer; // 521 SaveViewPosから独立
var
  i, line: Integer;
  startPos, size: integer;
  item: THogeTVItem;
begin
  for line := FBrowser.TopLine to FBrowser.Strings.Count -1 do
  begin
    item := FBrowser.Strings[line];
    startPos := 0;
    while FindAnchorName(item, startPos, size) do
    begin
      result := 0;
      for i := startPos to startPos + size -1 do
      begin
        case item.FText[i] of
        '0'..'9': result := result * 10 + Ord(item.FText[i]) - Ord('0');
        else
          begin
            result := -1;
            break;
          end;
        end;
      end;
      if 0 < result then
      begin
        Dec(result);
        exit;
      end;
    end;
  end;
  result := thread.lines - 1;
  if result < 0 then
    result := 0;
end;

(*  *)
procedure TViewItem.SaveViewPos;
begin
  if Assigned(thread) and Assigned(browser) then
  begin
    thread.SetViewPos(GetTopRes);
    thread.SaveIndexData;
  end;
end;


function TViewItem.GetBaseThread: TThreadItem;
begin
  Result := FThread;
end;

(* キャンセル時の処理 *)
procedure TViewItem.OnCancel;
var
  thread: TThreadItem;
begin
  thread := nextThread;
  nextThread := nil;
  if thread <> nil then
  begin
    thread.Release;
    FProgress := tpsNone;
    NewRequest(thread, nextCheckOpr);
  end;
end;

(*  *)
procedure TViewItem.AutoFree;
begin
  freeByCancel := true;
  Drain;
end;

function TViewItem.Drain: boolean;
  function ReleaseObjs: boolean;
  begin
    if freeByCancel then
    begin
      Self.Free;
      result := true;
    end
    else begin
      FreeThread;
      if assigned(browser) then
      begin
        browser.Visible := FALSE;
        ClearBrowser;
      end;
      FProgress := tpsNone;
      FNaviStat := tpsNone;
      FPreStat  := tpsNone;
      FAsyncStat:= tpsNone;
      result := false;
    end;
  end;
begin
  result := false;
  Cancel;
  canceled := true;
  if (FProgress = tpsNONE) and (re_entrant <= 0) then
  begin
    result := ReleaseObjs;
    exit;
  end;
  if nextThread <> nil then
  begin
    nextThread.Release;
    nextThread := nil;
  end;
  if assigned(browser) then
    browser.Visible := FALSE;
  if (FPreStat <> tpsWorking) and
     (re_entrant <= 0) then
  begin
    result := ReleaseObjs;
  end;
end;


(* スレ表示要求処理 *)
procedure TViewItem.NewRequest(thread: TThreadItem; oprType: TGestureOprType;
                               position: integer = -1; force: Boolean = False;
                               redraw: Boolean = False;
                         {aiai}TabText: Boolean = True{/aiai});  //Tabのテキストを描きなおす
  function CheckP(thread: TThreadItem; oprType: TGestureOprType): boolean;
  begin
    result := false;
    if Config.netOnline then
    begin
      case oprType of
      gotCHECK: result := true;
      gotGRACEFUL:
        begin
          thread.AddRef;
          if ((thread.lines <= 0) or (thread.lines < thread.itemCount) or
              (thread.lines <= position)) then
            result := true;
          thread.Release;
        end;
      end;
    end;
  end;

  procedure DeleteNewRes;
  var
    s: string;
    line, len: integer;
    startPos, size: integer;
    item: THogeTVItem;
  begin
    if currentStartLine > FThread.lines then
      exit;
    if currentStartLine <= 1 then
    begin
      ClearBrowser;
      exit;
    end;

    s := IntToStr(currentStartLine);
    len := length(s);
    for line := 0 to FBrowser.Strings.Count -1 do
    begin
      item := FBrowser.Strings[line];
      startPos := 0;
      while  FindAnchorName(item, startPos, size) do
      begin
        if (size = len) and StartWithP(s, @item.FText[startPos], size) then
        begin
          if FBrowser.TopLine > line then
            FBrowser.SetTop(line);
          while FBrowser.Strings.Count > line +1 do
          begin
            FBrowser.Strings.Items[line].Free;
            FBrowser.Strings.Delete(line);
          end;
          exit;
        end;
      end;
    end;
    currentStartLine := 1;
    ClearBrowser;
  end;

  function CalcDrawStartline: integer;
  begin
    result := thread.lines - DrawLinesArray[Config.oprDrawLines] + 1;
    if result >= thread.lines then
      result := 2;
  end;

var
  checkNew: boolean;
  title: String; //aiai
label DoReq;
begin
  if assigned(daemon.FatalException) then
    ResetDaemon;

  if thread = nil then
    exit;

  if FThread = thread then
  begin
    if (0 < drawStartLine) or (drawStartLine < FThread.lines) then
      newDrawStartline := drawStartLine
    else
      newDrawStartline := CalcDrawStartline;
    if (-1 < position) and (position < FThread.lines) and (position < newDrawStartline - 1) then
      newDrawStartline := position + 1;
    if newDrawStartline <> drawStartLine then
    begin
      FThread.CancelAsyncRead;
      FreeThread(false);
      drawStartLine := newDrawStartline;
    end;
  end else
  begin
    if newDrawStartline <= 0 then
    begin
      DrawStartline := CalcDrawStartline;
      if (-1 < position) and (position < thread.lines) and (position < DrawStartline - 1) then
        DrawStartline := position + 1;
    end else
      drawStartLine := newDrawStartline;
  end;
  newDrawStartline := -1;

  FNavigateToViewPos := (0 <= position);
  if FNavigateToViewPos then
    thread.viewPos := position;
  if (FProgress = tpsProgress) then
  begin
    if thread = FThread then
    begin
      checkNew := CheckP(thread, oprType);
      if checkNew and (not currentCheckNew) then
        goto DoReq;
      exit;
    end;
    if 0 < FStream.re_entrant then
    begin
      if assigned(nextThread) then
        nextThread.Release;
      nextThread := thread;
      nextCheckOpr := oprType;
      thread.AddRef;
      FStream.Cancel;
      exit;
    end;
    nextThread := nil;
  end;
  FProgress:= tpsProgress;
  FNaviStat:= tpsNone;
  FPreStat := tpsNone;
  FAsyncStat:= tpsNone;
  pumpCount := 0;

  FreeStream;

  {aiai}
  if TabText then begin
    title := Copy(AnsiReplaceText(HTML2String(thread.title), '&', '&&'), 1, 4095);
    MainWnd.TabControl.Tabs.Strings[viewList.IndexOf(self)] := title;
    SetWindowText(FBrowser.Handle, PChar(title));
  end;
  {/aiai}

  checkNew := CheckP(thread, oprType);

  if (thread = FThread) and (thread.dat <> nil) then
  begin
    if (checkNew {aiai}or (oprType = gotLocal){/aiai})
            and redraw and (FThread.lines > FThread.oldLines) then
    begin
      currentStartLine := FThread.oldLines +1;
      if FNavigateToViewPos then
      begin
        FThread.oldLines := FThread.lines;
        FThread.anchorLine := FThread.lines;
      end else
        SaveViewPos;
      DeleteNewRes;

      if currentStartLine = 1 then
      begin
        FNaviStat := tpsDone;
        FPreStat := tpsProgress;
      end
      else begin
        FNaviStat := tpsDone;
        FPreStat := tpsReady;
      end;
      SetLength(backStack, 0);
      SetLength(forwordStack, 0);
    end
    else begin
      FNaviStat := tpsDone;
      if FNavigateToViewPos then
        FPreStat := tpsReady
      else
        FPreStat := tpsDone;
    end;
    FStream := TDat2View.Create(FBrowser);
  end
  else begin
    currentStartLine := 1;

    if FThread <> thread then
      MainWnd.ThreadClosing(FThread);

    FreeThread;
    FThread := thread;
    thread.AddRef;
    thread.anchorLine := thread.oldLines;

    FPreStat := tpsProgress;
    FStream := TDat2View.Create(FBrowser);

    (* 画面クリア *)
    //FNaviStat := tpsDone;
    FNaviStat := tpsProgress;
    //OnNavigateDone;
    daemon.Post(OnNavigateDone);
    ClearBrowser;
    SetLength(backStack, 0);
    SetLength(forwordStack, 0);
  end;

 DoReq:
  currentCheckNew := True;
  FWantTraceLogDone := checkNew;

  if checkNew then
  begin
    (* 非同期受信開始：キャンセルとの絡みで終了通知は親分宛て *)
    FAsyncStat := tpsProgress;
    if Config.optOldOnCheckNew then thread.oldLines := thread.lines; //aiai
    case thread.StartAsyncRead(viewList.MasterDoneProc,
                               viewList.MasterNotifyProc, force) of
    trrSuccess, trrErrorProgress: ;
    trrErrorTemporary:
      begin
        DlgTooManyConn;
        OnAsyncDoneProc(thread);
      end;
    else //trrErrorPermanent:
      OnAsyncDoneProc(thread);
    end;
  end
  else begin
    FAsyncStat := tpsReady;
  end;

  DoWorking;

end;

(* WebBrowserのnavigate終了時処理 *)
procedure TViewItem.OnNavigateDone;
begin
  if FProgress = tpsProgress then
  begin
    if FNaviStat = tpsProgress then
      FNaviStat := tpsDone;
    //if browser.Visible then
    //  viewList.UpdateFocus(self);
  end;
  (* 再入しているとイヤなので別口で廻す *)
  daemon.Post(viewList.DoWorkingAll);
  MainWnd.TabControl.Refresh;  //aiai
end;


(* 非同期受信完了イベントハンドラ *)
procedure TViewItem.OnAsyncDoneProc(thread: TThreadItem);
begin
  if (FProgress = tpsProgress) and (thread = FThread) then
  begin
    if FAsyncStat = tpsWorking then
    begin
      FAsyncStat := tpsReady;
      (* あちらでディスパッチャを呼びだす *)
    end
    else begin
      FAsyncStat := tpsReady;
      DoWorking;
    end;
    MainWnd.TabControl.Refresh;  //aiai
  end;
end;

(* 受信途中経過 *)
procedure TViewItem.OnAsyncNotifyProc(thread: TThreadItem);
begin
  if thread <> FThread then
    exit;
  if (FProgress = tpsProgress) and
     (FPreStat = tpsDone) and (FAsyncStat = tpsProgress) then
  begin
    (* 新着分を表示する *)
    FAsyncStat := tpsWorking;
    Inc(re_entrant);
    try
      PumpChunk;
    except
    end;
    Dec(re_entrant);
    if canceled then // and (FNaviStat in [tpsNone, tpsDone]) and (re_entrant <= 0) then
    begin
      Drain;
      exit;
    end;
    if (length(thread.title) <= 0) and
      Assigned(thread.dat) and (0 < thread.dat.Size) then
    begin
      thread.title := thread.GetSubject;
      MainWnd.UpdateTabTexts;
    end;

    (* 再入されて完了通知が来ているかも知れないので状態をチェックする *)
    if FAsyncStat = tpsWorking then
      FAsyncStat := tpsProgress
    else
      DoWorking;
  end
  else
    DoWorking;
end;

(* 新着を表示する *)
procedure TViewItem.PumpChunk;
var
  lines: integer;
  NEWD2HTML: TDat2HTML;
  NewMarkHTML: PChar;
  BookMarkHTML: PChar;
begin
  if (FThread = nil) or (FThread.dat = nil) then
    exit;
  if (currentStartLine <= FThread.dat.Lines) then
  begin
    if (FStream = nil) or (FStream.canceled) then
      exit;
   {Log(Format('φ（･∀･）未読変換(%dﾊﾞｲﾄ)', [FThread.dat.Size - FThread.dat.Position+1]));}
    {ayaya}
    if useTrace[39] then
      Log(Format(traceString[39], [FThread.dat.Size - FThread.dat.Position+1]));
    {//ayaya}
    NEWD2HTML := SetUpDat2HTML((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).NewRecHTML, dhtNewRes);
    NEWD2HTML.URL := thread.ToURL;
    NEWD2HTML.Title := thread.title;
    try
    try
      if currentStartLine = FThread.anchorLine +1 then
      begin
        NewMarkHTML := PChar((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).NewMarkHTML);
        WriteSkin(NewMarkHTML, Length(NewMarkHTML));
      end;
      //NEWD2HTML.AboneArray := FThread.AboneArray; //※[457]
      //NEWD2HTML.thread :=  FThread;
      if (0 < FThread.readPos) and (currentStartLine <= FThread.readPos) then
      begin
        lines := NEWD2HTML.ToDatOut(FStream, FThread.dat, currentStartLine, FThread.readPos - currentStartLine + 1, FThread.AboneArray, FThread.NeedConvert);
        Inc(currentStartLine, lines);
        if currentStartLine - 1 = FThread.readPos then
        begin
          BookMarkHTML := PChar((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).BookMarkHTML);
          WriteSkin(BookMarkHTML, length(BookMarkHTML)); // ここまで読んだ
          lines := NEWD2HTML.ToDatOut(FStream, FThread.dat, FThread.readPos + 1, High(integer), FThread.AboneArray, FThread.NeedConvert);
        end;
        if 0 < lines then
          Inc(currentStartLine, lines);
      end
      else begin
        lines := NEWD2HTML.ToDatOut(FStream, FThread.dat, currentStartLine, High(integer), FThread.AboneArray, FThread.NeedConvert);
        if 0 < lines then
          Inc(currentStartLine, lines);
      end;
      FThread.ChkConsistency;
      FBrowser.Invalidate;
      FStream.Flush;
      if not FNavigateToViewPos and Config.oprScrollToNewRes and (pumpCount = 0) then
        ScrollToNewRes;
    except
      on e: EStreamError do
      begin
        Log(Format('stream exception: may be canceled: %s', [e.Message]));
      end;
    end;
    finally
      NEWD2HTML.Free;
    end;
    Inc(pumpCount);
  end;
end;


(* スレ表示：状態毎の処理 *)
procedure TViewItem.DoWorking;
  procedure StartWriting;
  var
    HeaderHTML: PChar;
  begin
    FPreStat := tpsWorking;
    ZoomBrowser(Config.viewZoomSize);

    FBrowser.Wallpaper := nil;

    FStream.EnableFontTag := true;
    FStream.EnableBodyTag := true;
    if (FThread.board <> nil) and
       (0 < length(TBoard(FThread.board).customHeader)) then
    begin
      with TBoard(FThread.board) do
        WriteSkin(@customHeader[1], length(customHeader));
    end
    else
    begin
      if FThread.board <> nil then
        With TBoard(FThread.board) do
          HeaderHTML := PChar((SkinCollectionList.Items[CustomSkinIndex]).HeaderHTML)
      else
        HeaderHTML := PChar((SkinCollectionList.Items[0]).HeaderHTML);
      WriteSkin(HeaderHTML, length(HeaderHTML));
    end;
    FStream.EnableFontTag := false;
    FStream.EnableBodyTag := false;
    FPreStat := tpsReady;
    FStream.Flush;
  end;

  procedure PumpPreContents;
  var
    {$IFDEF BENCH}
    index: integer;
    {$ENDIF}
    D2HTML: TDat2HTML;
    BookMarkHTML: PChar;
  begin
    FPreStat := tpsWorking;
    if (currentStartLine <= FThread.oldLines) and
       assigned(FThread.dat) and (0 < FThread.dat.Size) then
    begin
      {$IFDEF BENCH}
      Bench2(0);
      {$ENDIF}

      {Log(Format('φ（･∀･）既読分変換(%dﾊﾞｲﾄ)', [FThread.dat.Size]));}
      {ayaya}
      if useTrace[40] then
        Log(Format(traceString[40], [FThread.dat.Size]));
      {//ayaya}
      D2HTML := SetUpDat2HTML((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).RecHTML, dhtRes);
      D2HTML.URL := FThread.ToURL;
      D2HTML.Title := FThread.title;
      if currentStartLine = 1 then
      begin
        D2HTML.ToDatOut(FStream, FThread.dat, 1, 1, FThread.AboneArray, FThread.NeedConvert);
        if FThread.readPos = 1 then
          FStream.WriteHTML(PChar((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).BookMarkHTML),length((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).BookMarkHTML));
        Inc(currentStartLine);
      end;
      if currentStartLine < drawStartLine then // 表示レス数指定
        currentStartLine := drawStartLine;

      if (0 < FThread.readPos) and (currentStartLine <= FThread.readPos) and (FThread.readPos <= Fthread.oldLines) then
      begin
        D2HTML.ToDatOut(FStream, FThread.dat,
                        currentStartLine, FThread.readPos - currentStartLine + 1, FThread.AboneArray, FThread.NeedConvert);
        BookMarkHTML := PChar((SkinCollectionList.Items[TBoard(FThread.board).CustomSkinIndex]).BookMarkHTML);
        WriteSkin(BookMarkHTML,length(BookMarkHTML)); // ここまで読んだ
        D2HTML.ToDatOut(FStream, FThread.dat,
                        FThread.readPos + 1, FThread.oldLines - FThread.readPos, FThread.AboneArray, FThread.NeedConvert);
      end else
        D2HTML.ToDatOut(FStream, FThread.dat,
                        currentStartLine, FThread.oldLines - currentStartLine + 1, FThread.AboneArray{※[457]}, FThread.NeedConvert); (* 再入する *)
      D2HTML.Free;
      FThread.ChkConsistency;
      currentStartLine := FThread.oldLines + 1;
      FStream.Flush;
      FWantTraceLogDone := True;
      {$IFDEF BENCH}
      index := Bench2(1);
      if index >= 100 then
        Log('（；＾▽＾）ﾉ ' +  FormatFloat('#,##0',index) + 'ﾐﾘ秒')
      else
        Log('（　＾▽＾）ﾉ ' + FormatFloat('#,##0',index) + 'ﾐﾘ秒');
      {$ENDIF}
    end;
    if Config.oprScrollToPreviousRes or FNavigateToViewPos then
      SetViewPos;

    if FThread = nil then
    begin
      FPreStat := tpsDone;
    end
    else begin
      //if FThread.oldLines < currentStartLine then
        FPreStat := tpsDone
      //else
      //  FPreStat := tpsReady;
    end;
  end;


  procedure AsyncResult;
  begin
    if FAsyncStat <> tpsReady then
      exit;
    FAsyncStat := tpsWorking;
    Inc(re_entrant);
    PumpChunk;
    Dec(re_entrant);
    FAsyncStat := tpsDone;
    LogDone(FWantTraceLogDone);
    UpdateThreadInfo(FThread);
  end;

  procedure Complete;
  begin
    if not FNavigateToViewPos and Config.oprScrollToNewRes and (pumpCount = 0) then
      ScrollToNewRes;

    if FNavigateToViewPos and
       Assigned(FThread) and (FThread.oldLines <= FThread.viewPos) then
      SetViewPos;

    FBrowser.Invalidate;
    FProgress := tpsNone;
    FNaviStat:= tpsNone;
    FPreStat := tpsNone;
    FAsyncStat:= tpsNone;
    FreeStream;
    currentCheckNew := False;
    if freeByCancel then
      FreeThread
    else
      MainWnd.UpdateTabTexts;
  end;

  procedure sub;
  begin
    if FProgress <> tpsProgress then
      exit;
    if FNaviStat <> tpsDone then
      exit;
    if freeByCancel and (FAsyncStat = tpsNone) then
    begin
      FProgress := tpsNONE;
      exit;
    end;
    if FPreStat = tpsProgress then
      StartWriting;
    if FPreStat = tpsReady then
      PumpPreContents;
    if FPreStat = tpsDone then
    begin
      if FAsyncStat = tpsReady then
        AsyncResult;
      if FAsyncStat = tpsDone then
      begin
        Complete;
        if assigned(nextThread) then
          OnCancel;
      end
    end;
  end;

begin
  Inc(re_entrant);
  try
    sub;
  except
    on stream: ECancelViewException do
    begin
      Log('canceled');
      FPreStat := tpsDone;
      if not canceled then
        OnCancel;
    end;
  end;
  Dec(re_entrant);
  if canceled then
    Drain;
end;

(* スレ内容表示位置の設定 *)
function TViewItem.SetViewPos: boolean;
begin
  //result := false;
  //if not Config.oprScrollToPreviousRes then
  //  exit;
  result := ScrollToAnchor(FThread.viewPos, true, false);
end;

(* 文字の大きさ変更 *)
procedure TViewItem.ZoomBrowser(zoom: integer);
begin
  FBrowser.ExternalLeading := ZoomToExternalLeading(Config.viewZoomSize);
  FBrowser.SetFont(FBrowser.Font.Name, ZoomToPoint(Config.viewZoomSize));
end;

(* 新着へスクロール *)
function TViewItem.ScrollToNewRes: boolean;
begin
  result := false;
  if FThread = nil then
    exit;
  result := ScrollToAnchor(FThread.anchorLine, Config.oprScrollTop, false);
  if not result then
  begin
    FBrowser.EndOfBuffer;
    SetLength(forwordStack, 0);
    SetLength(backStack, length(backStack) +1);
    backStack[length(backStack) -1] := FBrowser.LogicalTopLine;
  end;
end;

(* アンカーへのスクロール *)
function TViewItem.ScrollToAnchor(num: integer; isTop: boolean; redraw: boolean): boolean;
var
  s: string;
  line, len: integer;
  startPos, size: integer;
  item: THogeTVItem;
  point: TPoint;
  PrevAnchorLine: Integer;
  thread: TThreadItem;

label FoundLine;
begin
  //※[457]
//  if Config.viewTransparencyAbone then
  num := FThread.ABoneArray.GetNearNotAboneResNumber(num+1) - 1;

  if (num + 1 < drawStartLine) and (num <> 0) and redraw then
  begin
    thread := FThread;
    FThread.CancelAsyncRead;
    FreeThread(false);
    NewRequest(thread, gotLOCAL, num, false, false);
    result := true;
    exit;
  end;

  if FThread.lines < num + 1 then
    num := -1;

  s := IntToStr(num+1);
  len := length(s);
  FBrowser.Selecting := False;
  PrevAnchorLine := -1;
  for line := 0 to FBrowser.Strings.Count -1 do
  begin
    item := FBrowser.Strings[line];
    startPos := 0;
    while FindAnchorName(item, startPos, size) do
    begin
      if (size = len) and StartWithP(s, @item.FText[startPos], size) then begin
        PrevAnchorLine:=line;
        goto FoundLine;
      end else
      if (size > len) or
          ((size = len) and (CompareStr(s, Copy(item.FText,startPos,size))<= 0)) then
        goto FoundLine;
      PrevAnchorLine := line;
    end;
  end;
  FoundLine:
  if PrevAnchorLine >= 0 then
  begin
    SetLength(forwordStack, 0);
    SetLength(backStack, length(backStack) +1);
    backStack[length(backStack) -1] := FBrowser.LogicalTopLine;
    point.X := 0;
    point.Y := PrevAnchorLine;
    FBrowser.DownLine;  //aiai キャレットを１行下げる
    FBrowser.SetTop(FBrowser.PhysicalToLogical(point).Y);
    FBrowser.SetPhysicalCaret(0, PrevAnchorLine + FBrowser.VerticalCaretMargin);
    result := True;
  end else
    result := false;
end;

procedure TViewItem.GoBack;
begin
  if length(backStack) > 0 then
  begin
    SetLength(forwordStack, length(forwordStack) +1);
    forwordStack[length(forwordStack) -1] := FBrowser.LogicalTopLine;
    FBrowser.Selecting := false;
    FBrowser.SetTop(backStack[length(backStack) -1]);
    SetLength(backStack, length(backStack) -1);
  end;
end;

function TViewItem.CanGoBack: boolean;
begin
  result := length(backStack) > 0;
end;

procedure TViewItem.GoForword;
begin
  if length(forwordStack) > 0 then
  begin
    SetLength(backStack, length(backStack) +1);
    backStack[length(backStack) -1] := FBrowser.LogicalTopLine;
    FBrowser.Selecting := false;
    FBrowser.SetTop(forwordStack[length(forwordStack) -1]);
    SetLength(forwordStack, length(forwordStack) -1);
  end;
end;

function TViewItem.CanGoForword: boolean;
begin
  result := length(forwordStack) > 0;
end;


function TViewItem.MessageLoop: boolean;
begin
  Application.ProcessMessages;
  if canceled then
  begin
    Drain;
    result := true;
  end
  else
    result := false;
end;

{beginner} //スレッドのキーワード抽出
procedure TViewItem.ExtractKeyword(const target:string; ExThread:TThreadItem;
  GrepMode: Byte; IncludeRef: Boolean; MigemoMode: Boolean = False);
var
  i, count: Integer;
  ExtStream :TDat2ViewForExtraction;
  RegExp: TRegExp;
  baseViewItem: TViewItem;
  baseBrowser: THogeTextView;
  HeaderHTML: PChar;
  targetList: TStringList;
  str: PChar;
  starttime: Cardinal;
begin
  if ExThread = nil then
    exit;

  {aiai}
  starttime := GetTickCount;

  targetList := TStringList.Create;
  if Config.schMultiWord then
  begin
    targetList.Delimiter := #$20;
    targetList.DelimitedText := ReplaceStr(target, #$81#$40, #$20);
  end else
    targetList.Add(target);
  if targetList.Count = 0 then
  begin
    targetList.Free;
    exit;
  end;
  {/aiai}

  MainWnd.TabControl.Tabs.Strings[viewList.IndexOf(self)] := '抽出';
  SetWindowText(FBrowser.Handle, '抽出');  //aiai
  ExThread.AddRef;
  ExThread.CancelAsyncRead;

  ClearBrowser;
  ZoomBrowser(Config.viewZoomSize);

  {aiai}
  if Config.ojvIDLinkColor then
  begin
   baseViewItem := viewList.FindViewItem(ExThread);
    if baseViewItem <> nil then
    begin
      baseBrowser := baseViewItem.browser;
      FBrowser.IDLinkColor := True;
      FBrowser.IDLinkColorNone := baseBrowser.IDLinkColorNone;
      FBrowser.IDLinkColorMany := baseBrowser.IDLinkColorMany;
      FBrowser.IDList.Assign(baseBrowser.IDList);
    end;
  end;
  {/aiai}

  ExtStream := TDat2ViewForExtraction.Create(FBrowser);
  FStream := ExtStream;

  ExtStream.Base:= ExThread.ToURL;
  ExtStream.BBSType := TBoard(ExThread.board).GetBBSType;

  if AnsiPos(#13,ExtStream.Base)>0 then
    ExtStream.Base := copy(ExtStream.Base, 1, AnsiPos(#13, ExtStream.Base) - 1);

  ExtStream.EnableFontTag := true;
  ExtStream.EnableBodyTag := true;
  FBrowser.Wallpaper := nil;
  if (ExThread.board <> nil) and
     (0 < length(TBoard(ExThread.board).customHeader)) then
  begin
    with TBoard(ExThread.board) do
      WriteSkin(@customHeader[1], length(customHeader), ExThread);
    end
  else
  begin
    if (ExThread.board <> nil) then
      With TBoard(ExThread.board) do
        HeaderHTML := PChar((SkinCollectionList.Items[CustomSkinIndex]).HeaderHTML)
    else
      HeaderHTML := PChar((SkinCollectionList.Items[0]).HeaderHTML);
    WriteSkin(HeaderHTML, length(HeaderHTML), ExThread);
  end;
  ExtStream.EnableFontTag := false;
  ExtStream.EnableBodyTag := true;

  ExtStream.WriteHTML('【レス抽出】<br>対象スレ： ');
  ExtStream.WriteAnchor('',ExtStream.Base,pchar(ExThread.title), length(ExThread.title));
  ExtStream.WriteHTML('<br>キーワード： ' + target + '<br><br><br>');
  ExtStream.Flush;

  {aiai}
  MigemoMode := MigemoMode and MigemoOBJ.CanUse;
  if MigemoMode then
  begin
    for i := 0 to targetList.Count - 1 do
    begin
      str := MigemoOBJ.Query(targetList[i]);
      targetList.Delete(i);
      targetList.Insert(i, str);
      MigemoOBJ.Release(str);
    end;
  end;
  {/aiai}

  if (GrepMode = GREP_OPTION_REGEXP) or MigemoMode then begin
    RegExp := TRegExp.Create(nil);
    RegExp.IgnoreCase := True;
  end else
    RegExp := nil;


  if (GrepMode <> GREP_OPTION_REGEXP) or Assigned(RegExp) then
    Count := _ExtractKeyWord(ExThread, ExtStream, targetList, 0, GrepMode,
      RegExp, IncludeRef, False)
  else
    Count := 0;

  ExtStream.WriteHTML('<br><br><br>抽出レス数：' + IntToStr(count));
  ExtStream.Flush;

  HintText:='【キーワード抽出】'#13#10'対象スレ：'+ExThread.title
           +#13#10'キーワード：'+StringReplace(target,'&','&&',[rfReplaceAll])
           +#13#10'抽出レス数：'+inttostr(count);

  ExThread.Release;

  ExtStream.flush;
  ExtStream.Free;
  RegExp.Free;
  FStream := nil;
  FBrowser.SetTop(0);
  FBrowser.SetPhysicalCaret(0,0);

  {aiai}
  if (GrepMode = GREP_OPTION_REGEXP) or MigemoMode then
    FBrowser.SearchForward(targetList, hloReg, False)
  else
    FBrowser.SearchForward(targetList, hloNormal, False);

  targetList.Free;

  Log('レス抽出完了: ' + FloatToStr((GetTickCount - starttime) / 1000) + '秒');

  {/aiai}

  FProgress := tpsNone;
end;

procedure TViewItem.ThreadTree(ExThread: TThreadItem; Index:Integer; OutLine: Boolean);
var
  count: Integer;
  Mask: TBits;
  Tree: TIndexTree;
  ExtStream :TDat2ViewForExtraction;
  HeaderHTML: PChar;
begin
  if ExThread = nil then
    exit;

  if OutLine then
  begin
    MainWnd.TabControl.Tabs.Strings[viewList.IndexOf(self)] := 'アウトライン';
    SetWindowText(FBrowser.Handle, 'アウトライン');  //aiai
  end else
  begin
    MainWnd.TabControl.Tabs.Strings[viewList.IndexOf(self)] := 'ツリー';
    SetWindowText(FBrowser.Handle, 'ツリー');  //aiai
  end;
  ExThread.AddRef;

  ClearBrowser;

  ZoomBrowser(Config.viewZoomSize);


  ExtStream := TDat2ViewForExtraction.Create(FBrowser);

  ExtStream.Base:= ExThread.ToURL;

  if AnsiPos(#13,ExtStream.Base)>0 then
    ExtStream.Base:=copy(ExtStream.Base, 1, AnsiPos(#13, ExtStream.Base) - 1);

  ExtStream.EnableFontTag := true;
  ExtStream.EnableBodyTag := true;
  FBrowser.Wallpaper := nil;
  if (ExThread.board <> nil) and
     (0 < length(TBoard(ExThread.board).customHeader)) then
  begin
    with TBoard(ExThread.board) do
      ExtStream.WriteHTML(@customHeader[1], length(customHeader));
    end
  else
  begin
    if ExThread.board <> nil then
      HeaderHTML := PChar((SkinCollectionList.Items[TBoard(ExThread.board).CustomSkinIndex]).HeaderHTML)
    else
      HeaderHTML := PChar((SkinCollectionList.Items[0]).HeaderHTML);
    ExtStream.WriteHTML(HeaderHTML, length(HeaderHTML));
  end;
  ExtStream.EnableFontTag := false;
  ExtStream.EnableBodyTag := false;

  ExtStream.Flush;

  Mask := TBits.Create;
  mask.Size := ExThread.lines + 1;

  Tree := TIndexTree.Create;
  Tree.AllowDup := Config.ojvAllowTreeDup;
  Tree.HeadLineLength := Config.ojvLenofOutLineRes;

  Tree.Mask := Mask;
  Tree.Build(ExThread, 1);

  if OutLine then
    count := Tree.OutLine(ExtStream, Index, ExThread.ABoneArray, ExThread.NeedConvert)
  else
    count := Tree.TreeDatOut(ExtStream, Index, ExThread.ABoneArray, ExThread.NeedConvert);

  Mask.Free;
  Tree.Free;

  ExtStream.WriteHTML('<br><br><br>表示レス数：'+inttostr(count));
  ExtStream.Flush;

  HintText:='【ツリー表示】'#13#10'対象スレ：'+ExThread.title;

  ExThread.Release;

  ExtStream.flush;
  ExtStream.Free;

  FBrowser.SetTop(0);
  FBrowser.SetPhysicalCaret(0,0);

  FProgress := tpsNone;

end;

(* ログ検索 *)
procedure TViewItem.Grep(const target: string; targetBoardList: TList; GrepMode: Byte;
               threadtitleonly: boolean = false; writepopup: boolean = false;
               ShowDirect: boolean = false; IncludeRef: Boolean = False;  //beginner
               const popupmaxseq: Integer = 5; const popupeachthremax: Integer = 10);
var
  thread: TThreadItem;
  tvc: TSimpleDat2View;
  SEARCHD2HTML: TDat2HTML;
  POPUPD2HTML: TDat2HTML;
  RegExp: TRegExp;
  ExtStream :TDat2ViewForExtraction;
  TickCount: Cardinal;
  totalCount: integer;
  targetList: TStringList;

  procedure ShowEntry(const additional: string = ''; first: boolean = false);
  var
    brd: string;
    board: TBoard;
    category: TCategory;
  begin
    board := TBoard(thread.board);
    category := TCategory(board.category);
    if first then
      brd := '<a href="' + board.GetURIBase + '/">' + board.name + '</a>'
    else
      brd := board.name;
    {beginner}
    if ShowDirect then
      tvc.WriteHTML('</dl><br><br><b>=================================================<br>'#13#10);
    tvc.WriteHTML(
                 '<li>' + category.name + ' ['+ brd + ']' + additional
               + '  '
               + '<a href="' + thread.ToURL(false, false) + '">'
               + thread.title + '</a></li>'
              );
    if ShowDirect then
      tvc.WriteHTML('=================================================</b><br><br>'#13#10'<dl>');
    {/beginner}
  end;

  //※[457]
  procedure ShowPopUpEntry(const numberstr: string);
  begin
    tvc.WriteHTML(
               '<a href="' + thread.ToURL(false, false, numberstr) + '">'
               + numberstr + '</a> '
              );
  end;

  procedure Ending;
  var
    index: integer;
  begin
    SEARCHD2HTML.Free;
    POPUPD2HTML.Free;
    if not canceled then  //canceled = trueのときも問題ないと思うけどけど。。。
      tvc.WriteHTML(
            '</ul><br><p>【' + IntToStr(totalCount) + ' 件見つかりました】(検索時間:' + IntToStr((GetTickCount - TickCount) div 1000) + '秒)</p>');
    tvc.Free;
    {beginner}
    ExtStream.Free;
    RegExp.Free;
    {/beginner}

    if Assigned(targetList) then
    begin
      if not Canceled then
      begin
        if GrepMode = GREP_OPTION_REGEXP then
          FBrowser.SearchForward(targetList, hloReg, false)
        else
          FBrowser.SearchForward(targetList, hloNormal, false);
      end;
      targetList.Free;
    end;
    index := viewList.IndexOf(self);
    if 0 <= index then begin
      MainWnd.TabControl.Tabs.Strings[index] := '検索結果';
      SetWindowText(FBrowser.Handle, '検索結果');  //aiai
    end;
    FProgress := tpsNone;
    Log('検索終了');
    MainWnd.WriteStatus('検索終了');
  end;

var
  index: integer;
  i, j, k, l: integer;
  board: TBoard;
  category: TCategory;
  tgt: string;
  hasTarget: boolean;
  countInBoard: integer;
  //※[457]
  s: string;
  popupstartline: Integer;
  popupcountthread: Integer;
  popupbreak: Boolean;
  tmpDat: TThreadData;
  {beginner}
  EntryFlag: Boolean;
  {/beginner}
  HeaderHTML: PChar;
  rc: Boolean;

begin
  TickCount := GetTickCount;
  hasTarget := (0 < length(target));
  rc := False;
  if hasTarget then
  begin
    {beginner} // VBScript_RegExpに変更 by aiai
    RegExp := nil;
    if GrepMode = GREP_OPTION_REGEXP then begin
      RegExp := TRegExp.Create(nil);
      RegExp.IgnoreCase := True;
      try
        RegExp.Pattern := target;
      except
        FreeAndNil(RegExp);
      end;
    end;
    {/beginner}
    tgt := target;
    tgt := StringReplace(tgt, '&', '&amp;', [rfReplaceAll]);
    tgt := StringReplace(tgt, '<', '&lt;', [rfReplaceAll]);
    tgt := StringReplace(tgt, '>', '&gt;', [rfReplaceAll]);

    {aiai}
    targetList := TStringList.Create;
    if GrepMode in [GREP_OPTION_AND, GREP_OPTION_OR] then
    begin
      targetList.Delimiter := #$20;
      targetList.DelimitedText := ReplaceStr(tgt, #$81#$40, #$20);
    end else if GrepMode = GREP_OPTION_REGEXP then
      targetList.Add(target)
    else
      targetList.Add(tgt);
    {/aiai}
  end;
  index := viewList.IndexOf(self);
  MainWnd.TabControl.Tabs.Strings[index] := 'ログ検索中';
  SetWindowText(FBrowser.Handle, 'ログ検索中');  //aiai
  totalCount := 0;

  ClearBrowser; //beginner

  ZoomBrowser(Config.viewZoomSize);

  tvc := TSimpleDat2View.Create(FBrowser);
  {beginner}
  if ShowDirect then begin
    HeaderHTML := PChar((SkinCollectionList.Items[0]).HeaderHTML);
    ExtStream := TDat2ViewForExtraction.Create(FBrowser);
    ExtStream.EnableFontTag := True;
    ExtStream.WriteHTML(HeaderHTML, length(HeaderHTML));
    ExtStream.EnableFontTag := False;
  end else begin
    ExtStream := nil;
  end;
  if hasTarget then begin
    tvc.WriteHTML('<html><body><p>【'+ tgt +'】の検索</p><ul>'#10);
    if (GrepMode = GREP_OPTION_REGEXP) and (RegExp = nil) then
      tvc.WriteHTML('キーワードは有効な正規表現ではありません');
  end else
  {/beginner}
    tvc.WriteHTML('<html><body><p>【取得済みログ一覧】</p><ul>'#10);

  SEARCHD2HTML := SetUpDat2HTML((SkinCollectionList.Items[0]).PopupRecHTML, dhtSearchRes);
  POPUPD2HTML := SetUpDat2HTML((SkinCollectionList.Items[0]).PopupRecHTML, dhtPopupRes);

  for i := 0 to targetBoardList.Count -1 do
  begin
    board := TBoard(targetBoardList.Items[i]);
    board.AddRef;
    category := TCategory(board.category);
    log('  ' + board.name);
    MainWnd.WriteStatus(board.name);
    if MessageLoop then
    begin
      board.Release;
      break;
    end;
    {aiai}
    if hasTarget and (GrepMode <> GREP_OPTION_REGEXP) then
    begin
      rc := (GrepMode = GREP_OPTION_AND) and (targetList.Count > 0);
      for j := 0 to targetList.Count - 1 do
      begin
        if GrepMode = GREP_OPTION_AND then
          rc := rc and (0 < FindPosIC(targetList.Strings[j], board.name, 1))
        else if (0 < FindPosIC(targetList.Strings[j], board.name, 1)) then
        begin
          rc := true;
          break;
        end;
      end;
    end else
      try
        rc := hasTarget and (Assigned(RegExp) and RegExp.Test(board.name));
      except
        On E: Exception do
        begin
          Windows.MessageBox(MainWnd.Handle, PChar(E.Message), '正規表現のエラーらしい', MB_ICONERROR or MB_OK);
          board.Release;
          break;
       end;
      end;
    {/aiai}
    if hasTarget and rc then //beginner
    begin
      if ShowDirect then
        tvc.WriteHTML('<b>');
      tvc.WriteHTML(
        '<li>' + category.name + ' ['
        + '<a href="http://' + board.host + '/' + board.bbs + '/"> '
        + board.name + '</a>]</li>'
      );
      if Assigned(RegExp) then
        tvc.WriteHTML('</b>');
      Inc(totalCount);
    end;
    countInBoard := 0;
    for k := 0 to board.Count -1 do
    begin
      if MessageLoop then
        break; //beginner
      thread := board.Items[k];
      if hasTarget then
      begin
        {aiai}
        if (GrepMode <> GREP_OPTION_REGEXP) then
        begin
          rc := (GrepMode = GREP_OPTION_AND) and (targetList.Count > 0);
          for j := 0 to targetList.Count - 1 do
          begin
            if GrepMode = GREP_OPTION_AND then
              rc := rc and (0 < FindPosIC(targetList.Strings[j], thread.title, 1))
            else if (0 < FindPosIC(targetList.Strings[j], thread.title, 1)) then
            begin
              rc := true;
              break;
            end;
          end;
        end else
          try
            rc := (Assigned(RegExp) and RegExp.Test(thread.title));
          except
            On E: Exception do
            begin
              Windows.MessageBox(MainWnd.Handle, PChar(E.Message), '正規表現のエラーらしい', MB_ICONERROR or MB_OK);
              board.Release;
              Ending;
              exit;
            end;
          end;
        {/aiai}
        if rc then //beginner
        begin
          if thread.lines <= 0 then
            ShowEntry('(未取得)')
          else
          begin
            ShowEntry('');
          end;
          Inc(totalCount);
        end
        else if not threadtitleonly then
        begin
          if thread.lines <= 0 then
            continue;
          thread.AddRef;
          if thread.dat <> nil then
          begin
            {beginner}
            if ShowDirect then begin
              ExtStream.Base := thread.ToURL;
              if AnsiPos(#13,ExtStream.Base)>0 then
                ExtStream.Base := copy(ExtStream.Base, 1, AnsiPos(#13, ExtStream.Base) - 1);
              ExtStream.BBSType := TBoard(thread.board).GetBBSType;
              if _ExtractKeyword(thread, ExtStream, targetList, 0, GrepMode, RegExp, IncludeRef, True) > 0 then
                inc(totalCount);
            {/beginner}
            end else
            begin
              {aiai}
              rc := Assigned(RegExp);
              if not rc then
                for j := 0 to targetList.Count - 1 do
                begin
                  rc := thread.dat.Contains(targetList[j], board.NeedConvert);
                  if rc then break;
                end;
              {/aiai}
              if rc then
              begin
                EntryFlag := True; //beginner

                if writepopup then
                begin
                  popupstartline := 0;
                  popupcountthread := 0;
                  popupbreak := false;
                  tmpDat := thread.DupData;
                  for l:=1 to thread.lines do
                  begin
                    {beginner}
                    if Assigned(RegExp) then begin
                      s := AnsiReplaceStr(AnsiReplaceStr(POPUPD2HTML.ToString(tmpDat, l, 1, board.NeedConvert), ' '#13, #13), #10' ', #10);
                    end else begin
                      s := SEARCHD2HTML.ToString(tmpDat, l, 1, board.NeedConvert);
                    end;
                    {aiai}
                    if (GrepMode <> GREP_OPTION_REGEXP) then
                    begin
                      rc := (GrepMode = GREP_OPTION_AND) and (targetList.Count > 0);
                      for j := 0 to targetList.Count - 1 do
                      begin
                        if GrepMode = GREP_OPTION_AND then
                          rc := rc and AnsiContainsText(s, targetList.Strings[j])
                        else if AnsiContainsText(s, targetList.Strings[j]) then
                        begin
                          rc := true;
                          break;
                        end;
                      end;
                    {/aiai}
                    end else
                      try
                        rc := ((RegExp = nil) and AnsiContainsText(s, target)) or (Assigned(RegExp) and RegExp.Test(s));
                      except
                        On E: Exception do
                        begin
                          Windows.MessageBox(MainWnd.Handle, PChar(E.Message), '正規表現のエラーらしい', MB_ICONERROR or MB_OK);
                          board.Release;
                          thread.Release;
                          Ending;
                          exit;
                        end;
                      end;
                    if rc then
                    {/beginner}
                    begin
                      {beginner}
                      if EntryFlag then begin
                        ShowEntry;
                        Inc(totalCount);
                        EntryFlag := False;
                      end;
                      {/beginner}
                      if popupstartline = 0 then
                        popupstartline := l
                      else if l - popupstartline >= popupmaxseq then //あんまり長いと読めない
                      begin
                        ShowPopUpEntry(IntToStr(popupstartline) + '-' + IntToStr(l-1));
                        Inc(popupcountthread);
                        popupstartline := l;
                      end;
                    end
                    else begin
                      if popupstartline <> 0 then
                      begin
                        if(popupstartline <> l-1) then
                          ShowPopUpEntry(IntToStr(popupstartline) + '-' + IntToStr(l-1))
                        else
                          ShowPopUpEntry(IntToStr(popupstartline));
                        popupstartline := 0;
                        Inc(popupcountthread);
                      end;
                    end;
                    if popupcountthread >= popupeachthremax then
                    begin
                      tvc.WriteHTML('(以下略)');
                      popupbreak := true;
                      break;
                    end;
                  end;
                  tmpDat.Free;

                  if (popupstartline <> 0) and (not popupbreak) then
                  begin
                    if(popupstartline <> thread.lines) then
                      ShowPopUpEntry(IntToStr(popupstartline) + '-' + IntToStr(thread.lines))
                    else
                      ShowPopUpEntry(IntToStr(popupstartline));
                  end;

                  if popupcountthread > 0 then
                  begin
                    tvc.WriteHTML('<BR>');
                  end;
                end;
              end;

            end;
          end;
          thread.Release;
        end;
      end
      else begin
        if 0 < thread.lines then
        begin
          ShowEntry('', countInBoard = 0);
          Inc(countInBoard);
          Inc(totalCount);
          if writepopup then
          begin
            ShowPopUpEntry('1-' + IntToStr(Min(popupmaxseq, thread.lines)));
            tvc.WriteHTML('<BR>');
          end;
        end;
      end;
    end;
    board.Release;
  end;

  Ending;
end;

procedure TViewItem.Reload;
var
  thread: TThreadItem;
begin
  if FThread = nil then
    exit;
  FThread.CancelAsyncRead;
  FThread.MoveLog;
  FThread.Release;
  thread := FThread;
  FThread := nil;
  NewRequest(thread, gotCHECK, -1, true);
end;

//※[457] スレの再描画（AboneLocalReload改め）- 521　
procedure TViewItem.LocalReload(line: Integer; drawline: integer = -1);
var
  thread: TThreadItem;
begin
  //
  // DoWorking中の場合はスキップ by aiai
  //
  if (FThread = nil) or (re_entrant > 0) then
    exit;

  if drawline > 0 then
  begin
    if drawline <= 1 then
      newdrawStartLine := 2
    else
      newdrawStartLine := drawline;
  end;
  FThread.CancelAsyncRead;
  thread := FThread;
  FreeThread(false);
  //NewRequest(thread, gotLOCAL, line, false, false);
  NewRequest(thread, gotLOCAL, line, false, false, false);  //aiai
end;

procedure TViewItem.About;
var
  stv: TSimpleDat2View;
  i: Integer;
begin
  i := viewList.IndexOf(self);
  MainWnd.TabControl.Tabs.Strings[i] := 'ABOUT';
  SetWindowText(FBrowser.Handle, 'ABOUT');  //aiai
  ClearBrowser;
  ZoomBrowser(Config.viewZoomSize);

  stv := TSimpleDat2View.Create(FBrowser);
  with stv do
  begin
    WriteHTML('<html><head></head><body>');
    WriteHTML('<h1><a href="' + Main.DISTRIBUTORS_SITE + '">' + Main.JANE2CH + '</a></h1>'#10);
              {+ '(<a href="http://www.geocities.co.jp/SiliconValley-Cupertino/2486/">' + TESTVER + '</a>)'
              + '(<a href="http://tokyo.cool.ne.jp/ymf754/">' + SYRUPTESTVER + '</a>)</h1>'#10);}
    WriteHTML('<hr>');
    WriteHTML('<p>Powered by <a href="http://www.monazilla.org/">Monazilla Project</a>.</p>'#10);
    WriteHTML('<br><hr><ul>');
    for i := 0 to length(Main.Copyrights) -1 do
    begin
      WriteHTML('<li>' + AnsiReplaceText(Main.Copyrights[i], '(c)', '&copy;') + '</li>'#10);
    end;
    WriteHTML('</ul>');
    WriteHTML('</body></html>');
  end;
  stv.Free;
end;

//rika
procedure TViewItem.Viewidx(idxhtml: string;title: string);
var
  stv: TSimpleDat2View;
  i: Integer;
begin
  i := viewList.IndexOf(self);
  MainWnd.TabControl.Tabs.Strings[i] := title;
  SetWindowText(FBrowser.Handle, PChar(title));
  ClearBrowser;
  ZoomBrowser(Config.viewZoomSize);

  stv := TSimpleDat2View.Create(FBrowser);
  with stv do
  begin
    WriteHTML(idxhtml);
  end;
  stv.Free;
end;

procedure TViewItem.ClearBrowser;
begin
  FBrowser.Clear;
end;

procedure TViewItem.WriteSkin(str: PChar; size: integer; thread: TThreadItem = nil);
var
  i: integer;
begin
  if thread = nil then
    thread := FThread;
  if thread = nil then
  begin
    FStream.WriteHTML(str, size);
    exit;
  end;

  i := 0;
  while i < size do
  begin
    if str[i] = '<' then
    begin
      if StartWithP('<THREADURL/>', str+i, size-i) then
      begin
        FStream.WriteHTML(str, i);
        FStream.WriteHTML(thread.ToURL);
        str := str +i +12;
        Dec(size, i+12);
        i := 0;
      end
      else if StartWithP('<THREADNAME/>', str+i, size-i) then
      begin
        FStream.WriteHTML(str, i);
        FStream.WriteHTML(thread.title);
        str := str +i +13;
        Dec(size, i+13);
        i := 0;
      end
      else if StartWithP('<GETRESCOUNT/>', str+i, size-i) then
      begin
        FStream.WriteHTML(str, i);
        FStream.WriteHTML(IntToStr(thread.oldLines));
        str := str +i +14;
        Dec(size, i+14);
        i := 0;
      end
      else if StartWithP('<SKINPATH/>', str+i, size-i) then
      begin
        FStream.WriteHTML(str, i);
        FStream.WriteHTML(Config.SkinPath);
        str := str +i +11;
        Dec(size, i+11);
        i := 0;
      end else
        Inc(i);
    end else
      Inc(i);
  end;
  FStream.WriteHTML(str, i);
end;

(*=======================================================*)
(* 構築 *)
constructor TViewList.Create;
begin
  inherited;
  synchro := THogeMutex.Create;
  garbageList := TList.Create;
  wallPaperList := nil;
  PictViewList := nil;
end;

(* 消滅 *)
destructor TViewList.Destroy;
var
  i: integer;
begin
  Clear;
  if Assigned(wallPaperList) then
    wallPaperList.Free;
  if Assigned(PictViewList) then
    PictViewList.Free;
  for i := 0 to garbageList.Count -1 do
    TViewItem(garbageList.Items[i]).Free;
  garbageList.Free;
  synchro.Free;
  inherited;
end;

(* 只のキャスト *)
function TViewList.GetItems(index:integer): TViewItem;
begin
  result := inherited Items[index];
end;

(* 同上 *)
procedure TViewList.SetItems(index: integer; viewItem: TViewItem);
begin
  inherited Items[index] := viewItem;
end;

(* 項目削除 *)
procedure TViewList.Delete(index: integer);
begin
  //LEAK PREVENTION TViewItem(Items[index]).AutoFree;
  garbageList.Add(Items[index]);
  TViewItem(Items[index]).Drain;
  inherited Delete(index);
end;

(* 全削除 *)
procedure TViewList.Clear;
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    if Items[i] <> nil then
      TViewItem(Items[i]).AutoFree;
  end;
  {
  for i := 0 to garbageList.Count -1 do
  begin
    if garbageList.Items[i] <> nil then
      TViewItem(garbageList.Items[i]).AutoFree;
  end;
  }
  inherited;
end;

function TViewList.GetGarbage(insertIndex: integer = -1): TViewItem;
var
  i: integer;
begin
  result := nil;
  for i := 0 to garbageList.Count -1 do
  begin
    if TViewItem(garbageList.Items[i]).Progress = tpsNone then
    begin
      result := garbageList[i];
      if insertIndex < 0 then
        inherited Add(result)
      else
        inherited Insert(insertIndex, result);
      garbageList.Delete(i);
      TMDITextView(result.browser).WndState := MTV_MAX;  //aiai
      result.browser.Visible := true;
      result.browser.BringToFront;
      result.FreeThread;
      result.canceled := false;
      exit;
    end;
  end;
end;



(* 新規ビュー生成 *)
function TViewList.NewView(browser: THogeTextView; index: integer = -1): TViewItem;
var
  viewItem: TViewItem;
begin
  viewItem := TViewItem.Create(self);
  viewItem.browser := browser;

  synchro.Wait;
  if index < 0 then
    Add(viewItem)
  else
    Insert(index, viewItem);
  synchro.Release;

  result := viewItem;
end;

(* スレで探す *)
function TViewList.FindViewItem(thread: TThreadItem): TViewItem;
var
  i: integer;
  viewItem: TViewItem;
begin
  for i := 0 to Count -1 do
  begin
    viewItem := Items[i];
    if viewItem.thread = thread then
    begin
      result := viewitem;
      exit;
    end;
  end;
  result := nil;
end;

(* ブラウザで探す *)
function TViewList.FindViewitem(browser: TComponent): TViewItem;
var
  i: integer;
  viewItem: TViewItem;
begin
  for i := 0 to Count -1 do
  begin
    viewItem := Items[i];
    if viewItem.browser = browser then
    begin
      result := viewitem;
      exit;
    end;
  end;
  result := nil;
end;

//aiai indexを返す
function TViewList.FindViewItemIndex(thread: TThreadItem): Integer;
var
  i: integer;
  viewItem: TViewItem;
begin
  for i := 0 to Count -1 do
  begin
    viewItem := Items[i];
    if viewItem.thread = thread then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

//aiai indexを返す
function TViewList.FindViewitemIndex(browser: TComponent): Integer;
var
  i: integer;
  viewItem: TViewItem;
begin
  for i := 0 to Count -1 do
  begin
    viewItem := Items[i];
    if viewItem.browser = browser then
    begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

//aiai
//viewListにあるViewのうちで最も高いZオーダーをもつViewのインデックスを返す
function TViewList.FindFirstViewItem: Integer;
var
  hWindow: HWND;
  wCnt: TWinControl;
  wc: Integer;
  i: Integer;
begin
  Result := -1;
  wc := Count;
  if wc = 0 then
    exit;

  hWindow := Items[0].browser.Handle;
  hWindow := GetWindow(hWindow, GW_HWNDFIRST);
  while hWindow <> 0 do
  begin
    wCnt := FindControl(hWindow);
    if (wCnt <> nil) and (wCnt is THogeTextView) then
    begin
      for i := 0 to wc - 1 do
      begin
        if wCnt = Items[i].browser then
        begin
          Result := i;
          exit;
        end;
      end;
    end;
    hWindow := GetWindow(hWindow, GW_HWNDNEXT);
  end;
end;


(* カッコ悪いけど全部廻す *)
procedure TViewList.DoWorkingAll;
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    Items[i].DoWorking;
  end;
end;

(* データ受信時処理：キャンセルがあるのでこちらで受ける *)
procedure TViewList.MasterNotifyProc(thread: TThreadItem);
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    if Items[i].thread = thread then
    begin
      Items[i].OnAsyncNotifyProc(thread);
      exit;
    end;
  end;
  for i := 0 to garbageList.Count -1 do
  begin
    if TViewItem(garbageList.Items[i]).thread = thread then
    begin
      TViewItem(garbageList.Items[i]).OnAsyncNotifyProc(thread);
      exit;
    end;
  end;
end;

(* データ受信完了時処理：キャンセルがあるのでこちらで受ける *)
procedure TViewList.MasterDoneProc(thread: TThreadItem);
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    if Items[i].thread = thread then
    begin
      Items[i].OnAsyncDoneProc(thread);
      exit;
    end;
  end;
  for i := 0 to garbageList.Count -1 do
  begin
    if TViewItem(garbageList.Items[i]).thread = thread then
    begin
      TViewItem(garbageList.Items[i]).OnAsyncDoneProc(thread);
      exit;
    end;
  end;
end;

procedure TViewList.UpdateFocus(index: integer);
begin
  UpdateFocus(Items[index]);
end;

procedure TViewList.UpdateFocus(viewItem: TViewItem);
var
  wnd: HWND;
  i: integer;
begin
  if viewItem.browser = nil then
    exit;
  wnd := GetFocus;
  for i := 0 to Count -1 do
  begin
    with Items[i] do
    begin
      if (browser <> nil) and
         ((browser.Handle = wnd) or
          (IsChild(browser.Handle, wnd))) then
      begin
        viewItem.browser.SetFocus;
        exit;
      end;
    end;
  end;
end;

procedure TViewList.Debug;
begin
  Log(Format('browser: %d, garbage: %d', [Count, garbageList.Count]));
end;



{aiai}
function TViewList.ViewMaximize(viewItem: TViewItem): Boolean;
var
  browser: TMDITextView;
  state: TMTVState;
  //pcx, pcy: Integer;
begin
  Result := True;
  if Assigned(viewItem.browser) then begin
    browser := TMDITextView(viewItem.browser);
    state := browser.WndState;
    if state = MTV_MAX then begin
      browser.Hide;
      browser.WndState := MTV_NOR;
      //pcx := MainWnd.MDIClientPanel.Width div 20;
      //pcy := MainWnd.MDIClientPanel.Height div 20;
      //browser.BoundsRect := Bounds(pcx, pcy, pcx * 18, pcy * 18);
      browser.Show;
      browser.SetFocus;
      Result := False;
    end else if state = MTV_NOR then begin
      browser.WndState := MTV_MAX;
    end;
  end;
end;
procedure TViewList.ViewAllRestore;
var
  browser: TMDITextView;
  i: Integer;
begin
  for i := 0 to Count  - 1 do begin
    browser := TMDITextView(Items[i].browser);
    browser.WndState := MTV_NOR;
    browser.Visible := True;
  end;
end;

procedure TViewList.ViewAllMaximize(TopWnd: THogeTextView);
var
  browser: TMDITextView;
  i: Integer;
begin
  for i := 0 to Count  - 1 do begin
    browser := TMDITextView(Items[i].browser);
    browser.WndState := MTV_MAX;
    if browser = TopWnd then
      browser.Visible := true
    else
      browser.Visible := false;
  end;
end;

procedure TViewList.ViewCascade;
var
  cx, cy, x, y, wcnt, i: Integer;
  browser, activeview: TMDITextView;
begin
  wcnt := Count;
  if wcnt <= 0 then
    exit;

  activeview := TMDITextView(MainWnd.GetActiveView.browser);

  cx := MainWnd.MDIClientPanel.ClientWidth * 5 div 7;
  cy := MainWnd.MDIClientPanel.ClientHeight * 5 div 7;
  if wcnt = 1 then begin
    x := 0;
    y := 0;
  end else begin
    x := (MainWnd.MDIClientPanel.ClientWidth - cx) div (wcnt - 1);
    y := (MainWnd.MDIClientPanel.ClientHeight - cy) div (wcnt - 1);
  end;

  for i := 0 to wcnt - 1 do begin
    browser := TMDITextView(Items[i].browser);
    With browser do begin
      WndState := MTV_NOR;
      Width := cx;
      Height := cy;
      Left := x * i;
      Top := y * i;
      Visible := True;
      BringToFront;
    end;
  end;

  activeview.BringToFront;
end;

procedure TViewList.ViewTile(Horize: Boolean);
var
  cx: Integer;              { WindowのWidth }
  cy: Integer;              { WindowのHeight }
  wcnt: Integer;            { Windowの数 }
  lcnt: Integer;            { 列の数 }
  rcnt: Integer;            { 行の数 }
  line: Integer;            { 列のインデックス }
  row: Integer;             { 行のインデックス }
  oneplus: Integer;         { 一列多くなる行のインデックスの最小値 or 一行多くなる列のインデックスの最小値 }
  i: Integer;
  browser: TMDITextView;
begin
  wcnt := viewList.Count;
  if wcnt <= 0 then
    exit;

  if Horize then begin
    lcnt := Trunc(sqrt(wcnt));            { 0行目の列数 }
    i := wcnt - lcnt * lcnt;
    rcnt := lcnt + i div lcnt;            { 列の数 }
    oneplus := rcnt - i mod lcnt;         { 一列多くなる最初の行のインデックス }
  end else begin
    rcnt := Trunc(sqrt(wcnt));            { 0列目の行数 }
    i := wcnt - rcnt * rcnt;
    lcnt := rcnt + i div rcnt;            { 行の数 }
    oneplus := lcnt - i mod rcnt;         { 一行多くなる最初の列のインデックス }
  end;

  cx := MainWnd.MDIClientPanel.ClientWidth div lcnt;
  cy := MainWnd.MDIClientPanel.ClientHeight div rcnt;

  line := 0;
  row := 0;

  for i := 0 to wcnt - 1 do begin
    browser := TMDITextView(Items[i].browser);
    With browser do begin
      WndState := MTV_NOR;

      Visible := True;
      BoundsRect := Bounds(cx * line, cy * row, cx, cy);

      if Horize then begin
        Inc(line);         { 次の列へ }
        if line = lcnt then begin
          Inc(row);        { 次の行へ }
          line := 0;
          if (row = oneplus) then begin
            Inc(lcnt);
            cx := MainWnd.MDIClientPanel.ClientWidth div lcnt;
          end;
        end;
      end else begin
        Inc(row);          { 次の行へ }
        if row = rcnt then begin
          Inc(line);       { 次の列へ }
          row := 0;
          if (line = oneplus) then begin
            Inc(rcnt);
            cy := MainWnd.MDIClientPanel.ClientHeight div rcnt;
          end;
        end;
      end;

    end;
  end;
end;
{/aiai}


(*=======================================================*)

{ TPopupViewItem }

constructor TPopupViewItem.Create(ABrowser: TPopupTextView; AOwnerView: TBaseViewItem);
begin
  inherited Create;
  FBrowser := ABrowser;
  FBrowser.Tag := LongInt(Self);
  FOwnerView := AOwnerView;
  if Assigned(FOwnerView) then
  begin
    if Assigned(FOwnerView.FPossessionView) then
      FOwnerView.FPossessionView.Release;
    FOwnerView.FPossessionView := Self;
    FPopupViewList := FOwnerView.PopUpViewList;
    if Assigned(FPopupViewList) then
      FPopupViewList.Add(Self);
  end else
    FPopupViewList := nil;
end;


destructor TPopupViewItem.Destroy;
begin
  SetThread(nil);
  if Assigned(FOwnerView) then
    FOwnerView.FPossessionView := nil;
  if Assigned(FPopupViewList) then
    FPopupViewList.Extract(Self);
  FBrowser.Free;
  inherited;
end;


procedure TPopupViewItem.Release;
begin
  if FReleased then
    Exit;
  if Locked then
  begin
    FReleased := True;
    Cancel;
    ReleasePossessionView;
    if Assigned(FOwnerView) then
      FOwnerView.FPossessionView := nil;
    if Assigned(FPopupViewList) then
      FPopupViewList.Extract(Self);
    FBrowser.Tag := 0;
    FBrowser.Hide;
  end else
    Free;
end;

procedure TPopupViewItem.UnLock;
begin
  if Locked then
  begin
    inherited Unlock;
    if FReleased and (not Locked) then
      Free;
  end;
end;


function TPopupViewItem.GetBaseItem: TBaseViewItem;
begin
  if Assigned(FOwnerView) then
    Result := FOwnerView.GetBaseItem
  else
    Result := nil;
end;

function TPopupViewItem.GetBaseThread: TThreadItem;
begin
  if Assigned(FOwnerView) then
    Result := FOwnerView.BaseThread
  else
    Result := nil;
end;


function TPopupViewItem.GetRootControl: TWinControl;
begin
  if Assigned(FOwnerView) then
    Result := FOwnerView.GetRootControl
  else
    Result := nil;
end;


procedure TPopupViewItem.SetThread(const AThread: TThreadItem);
begin
  if Assigned(FThread) then
    FThread.Release;
  FThread := AThread;
  if Assigned(FThread) then
    FThread.AddRef;
end;

procedure TPopupViewItem.Cancel;
begin
  if Assigned(FStream) then
    FStream.Cancel;
end;

function TPopupViewItem.GetSelection: String;
begin
  if Assigned(FBrowser) then
    Result := FBrowser.Selection
  else
    Result := '';
end;

function TPopupViewItem.GetDerivativeBrowser: TControl;
begin
  Result := FBrowser;
end;

function TPopupViewItem.GetDerivativeStream: TDatOut;
begin
  Result := FStream;
end;

function TPopupViewItem.BrowserQueryClose: Boolean;
begin
  Release;
  Result := True;
end;

function TPopupViewItem.GetStreamCanceled;
begin
  Result := Assigned(FStream) and FStream.canceled;
end;

procedure TPopupViewItem.PopUp(Point: TPoint);
var
  Rect: TRect;
  Monitor: TMonitor;
  MonitorRect: TRect;
  X, Y, yoffset1, yoffset2: Integer;  //aiai
begin
  Monitor := Screen.MonitorFromPoint(Point);
  if Assigned(Monitor) then
    MonitorRect := Monitor.WorkareaRect
  else
    MonitorRect := Screen.WorkAreaRect;

  {aiai}
  if Config.optPopupSizeContrainX > 0 then
    X := Config.optPopupSizeContrainX
  else
    X := MonitorRect.Right - MonitorRect.Left;
  if Config.optPopupSizeContrainY > 0 then
    Y := Config.optPopupSizeContrainY
  else
    Y := MonitorRect.Bottom - MonitorRect.Top;
  Rect := FBrowser.CalcAdjstableSize(Y, X);
  AdjustToTextViewLine(Point, Rect, yoffset1, yoffset2);
  {/aiai}
  Dec(Point.X, 32);
  if Point.X < MonitorRect.Left then
    Point.X := MonitorRect.Left
  else if Rect.Right + Point.X > MonitorRect.Right then
    Point.X := MonitorRect.Right - Rect.Right;
  {aiai}
  if Point.Y - (Rect.Bottom - Rect.Top) - yoffset1 < MonitorRect.Top then
  begin
    if Point.Y + (Rect.Bottom - Rect.Top) + yoffset2 < MonitorRect.Bottom then
      Inc(Point.Y, yoffset2)
    else
      Point.Y := MonitorRect.Top - Rect.Top;
  end else
    Dec(Point.Y, Rect.Bottom - Rect.Top + yoffset1);
  {/aiai}
  OffsetRect(Rect, Point.X, Point.Y);
  FBrowser.PopUp(Rect);
end;

function TPopupViewItem.GetEnabled: Boolean;
begin
  Result := Assigned(FBrowser) and FBrowser.Enabled;
end;

procedure TPopupViewItem.SetEnabled(const Value: Boolean);
begin
  if Assigned(FBrowser) then
    FBrowser.Enabled := Value;
  if Value then
  begin
    if Assigned(FOnEnabled) then
      FOnEnabled(Self);
  end;
  if not Value then
    ReleasePossessionView;
end;

procedure TPopupViewItem.Show2chInfo(AIdStr: String; ATarget: String; ABoard: TBoard;
  AThread: TThreadItem; ARangearray: TRangeArray; Point: TPoint);
begin
  try
    Lock;
    FIdStr := AIdStr;
    SetThread(Athread);

    SetResNumIDList; //aiai レス番とIDのリストをコピー

    FStream := TDat2PopupView.Create(FBrowser);
    try
      FStream.DDOffsetLeft := DD_OFFSET_LEFT div 4;
      Make2chInfo(FStream, ATarget, BaseThread, ABoard, FThread, ARangearray);
      if not FStream.canceled and FBrowser.Trim then
        PopUp(Point)
      else
        Release;
    finally
      FreeAndNil(FStream);
    end;
  finally
    UnLock;
  end;
end;

procedure TPopupViewItem.ShowTextInfo(AIdStr: String; Text: String;
  AThread: TThreadItem; HTML: Boolean; Point: TPoint);
begin
  try
    Lock;
    FIdStr := AIdStr;
    SetThread(Athread);
    FStream := TDat2PopupView.Create(FBrowser);
    try
      if HTML then
        FStream.WriteHTML(text)
      else
        FStream.WriteText(text);
      FStream.Flush;
      if not FStream.canceled and FBrowser.Trim then
        PopUp(Point)
      else
        Release;
    finally
      FreeAndNil(FStream);
    end;
  finally
    UnLock;
  end;
end;

{aiai}
function TPopupViewItem.ExtractID(AIdStr: String; AThread: TThreadItem;
  Target: String; Max: Integer;Point: TPoint): Integer;
begin
  try
    Lock;
    FIdStr := AIdStr;
    SetThread(AThread);
    FStream := TDat2PopupView.Create(FBrowser);
    Result := 0;

    SetResNumIDList; //aiai レス番とIDのリストをコピー

    try
      FStream.DDOffsetLeft := DD_OFFSET_LEFT div 4;
      //Result := _ExtractID(FThread, FStream, Target, Max, false);
      Result := MakeIDInfo(FStream, Target, FThread, Max);
      if not FStream.canceled and FBrowser.Trim then
        PopUp(Point)
      else
      begin
        Result := 0;
        Release;
      end;
    finally
      FreeAndNil(FStream);
    end;
  finally
    UnLock;
  end;
end;
{/aiai}

function TPopupViewItem.ExtractKeyword(AIdStr: String; AThread: TThreadItem;
  Target: String; Max: Integer;Point: TPoint): Integer;
var
  targetList: TStringList;
begin
  try
    Lock;
    FIdStr := AIdStr;
    SetThread(AThread);
    FStream := TDat2PopupView.Create(FBrowser);
    Result := 0;

    {aiai}
    SetResNumIDList; //レス番とIDのリストをコピー

    targetList := TStringList.Create;
    targetList.Add(target);
    {/aiai}

    try
      FStream.DDOffsetLeft := DD_OFFSET_LEFT div 4;
      Result := _ExtractKeyWord(FThread, FStream, targetList, Max, GREP_OPTION_NORMAL);
      if not FStream.canceled and FBrowser.Trim then
        PopUp(Point)
      else
      begin
        Result := 0;
        Release;
      end;
    finally
      FreeAndNil(FStream);
    end;
    {aiai}
    FBrowser.SearchForward(targetList, hloNormal, False);
    targetList.Free;
    {/aiai}
  finally
    UnLock;
  end;
end;

function TPopupViewItem.ThreadTree(AIdStr: String; AThread: TThreadItem;
  Index: Integer; OutLine: Boolean; Point: TPoint): Boolean;
var
  IndexTree: TIndexTree;
  Mask: TBits;
  Count: Integer;
begin
  if (Index < 1) or (Index > AThread.lines) then
  begin
    Result := False;
    Exit;
  end;

  try
    Lock;
    FIdStr := AIdStr;
    SetThread(AThread);

    IndexTree := TIndexTree.Create;
    IndexTree.AllowDup := Config.ojvAllowTreeDup;
    IndexTree.HeadLineLength := Config.ojvLenofOutLineRes;
    IndexTree.Build(AThread, Index);
    Mask := TBits.Create;
    Mask.Size := AThread.lines + 1;
    IndexTree.Mask := Mask;

    FStream := TDat2PopupView.Create(FBrowser);
    Result := False;
    try
      FStream.DD_OFFSET_LEFT := 8;
      FStream.DDOffsetLeft := DD_OFFSET_LEFT div 4;
      if OutLine then
      begin
        Count := IndexTree.OutLine(FStream, Index, nil, AThread.NeedConvert);
      end
      else
      begin
        IndexTree.ShowRoot := False;
        IndexTree.LevelLimit := 1;
        Count := IndexTree.TreeDatOut(FStream, Index, nil, AThread.NeedConvert);
      end;

      Result := Count > 0;

      if (Count > 1) or ((Count > 0) and not(OutLine)) then
      begin
        if not FStream.canceled and FBrowser.Trim then
          PopUp(Point)
        else
        begin
          Result := False;
          Release;
        end;
      end
    finally
      FreeAndNil(FStream);
      FreeAndNil(IndexTree);
      FreeAndNil(Mask);
    end;
  finally
    UnLock;
  end;
end;

{aiai} //aiai レス番とIDのリストをコピー
procedure TPopupViewItem.SetResNumIDList;
var
  baseViewItem: TViewItem;
  baseBrowser: THogeTextView;
begin
  if Config.ojvIDLinkColor or Config.ojvColordNumber then
  begin
    baseViewItem := viewList.FindViewItem(FThread);
    if baseViewItem <> nil then
    begin
      baseBrowser := baseViewItem.browser;
      if Config.ojvIDLinkColor then
      begin
        FBrowser.ColordNumber := True;
        FBrowser.LinkedNumColor := Config.ojvLinkedNumColor;
        FBrowser.ResNumArray := baseBrowser.ResNumArray;
      end;
      if Config.ojvColordNumber then
      begin
        FBrowser.IDLinkColor := True;
        FBrowser.IDLinkColorNone := Config.ojvIDLinkColorNone;
        FBrowser.IDLinkColorMany := Config.ojvIDLinkColorMany;
        FBrowser.IDLinkThreshold := Config.ojvIDLinkThreshold;
        FBrowser.IDList.Assign(baseBrowser.IDList);
      end;
    end;
  end;
end;
{/aiai}

(*=======================================================*)

{ TPopupViewList }

//ポップアップをリスト化して保持し、主にカーソル移動による
//ポップアップの非アクティブ化、解放を管理する

constructor TPopupViewList.Create;
begin
  inherited;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 100;
  FTimer.OnTimer := FTimerTimer;
  FList := TList.Create;
  FAppEvent := TApplicationEvents.Create(nil);
  FAppEvent.OnMessage := nil;
  Change;
end;

destructor TPopupViewList.Destroy;
begin
  FAppEvent.Free;
  Clear(True);
  FList.Free;
  FTimer.Free;
  inherited;
end;

procedure TPopupViewList.Clear(Force: Boolean);
begin
  if (FList.Count > 0) and ((not Items[0].Enabled) or Force) then
  begin
    while Count > 0 do
      Items[Count - 1].Release;
    FList.Clear;
    FTimer.Enabled := False;
    FAppEvent.OnMessage := nil;
  end;
end;

function TPopupViewList.GetItems(index: integer): TPopupViewItem;
begin
  Result := TPopupViewItem(FList.Items[index]);
end;

function TPopupViewList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPopupViewList.Add(Item: TPopupViewItem): Integer;
begin
  //PopupViewListは、Popupの系列を一つしか保持できない。
  //異なる系列のItemがaddされたときは、元々あった系列を消去
  if (Count > 0) and (Item.BaseItem <> Items[0].BaseItem) then
    Clear(True);
  Result := FList.Add(Item);
  if Result = 0 then
  begin
    FPrevPoint := Mouse.CursorPos;
    FTimer.Enabled := True;
    FAppEvent.OnMessage := FAppEventMessage;
    FAppEvent.Activate;
  end;
  Change;
end;

function TPopupViewList.Extract(Item: TPopupViewItem): TPopupViewItem;
begin
  Result := TPopupViewItem(FList.Extract(Item));
  if FList.Count = 0 then
  begin
    FTimer.Enabled := False;
    FAppEvent.OnMessage := nil;
  end;
end;

procedure TPopupViewList.Confirm(Point: TPoint);
var
  i: Integer;
  Top: Integer;
  Browser: TPopUpTextView;
  ClientPoint: TPoint;
  ClientPrev: TPoint;
  NotInRootControl: Boolean;
  ControlAtCursor: TWinControl;
  RootControl: TWinControl;
  function OwnerConfirm(item: TPopupViewItem): Boolean;
  begin
    item.OwnerCofirmation := item.OwnerCofirmation and
      Assigned(item.OwnerView) and
      (item.OwnerView.GetDerivativeBrowser = ControlAtCursor);
    result := item.OwnerCofirmation;
  end;
begin
  if (Count = 0) or ((FPrevPoint.X = Point.X) and (FPrevPoint.Y = Point.Y)) then
    Exit;

  Top := -1;
  for i := Count - 1 downto 0 do
  begin
    if items[i].Enabled then
    begin
      Top := i;
      Break;
    end;
  end;

  ControlAtCursor := FindVCLWindow(Point);

  //PositionをBrowserが含むかどうかの判定は、なぜか２ずれ。
  if Top >= 0 then
  begin
    OwnerConfirm(Items[Top]);
    Browser := Items[Top].FBrowser;
    ClientPoint := Browser.ScreenToClient(Point);
    ClientPrev  := Browser.ScreenToClient(FPrevPoint);
    if (not Items[Top].Locked) and (Browser <> GetCaptureControl) then
    begin
      if ((((ClientPoint.X < -2) or (ClientPoint.X >= Browser.Width - 2)) and
           (Abs(ClientPoint.X) > Abs(ClientPrev.X))
          ) or
          (((ClientPoint.Y < -2) or (ClientPoint.Y >= Browser.Height - 2)) and
           (Abs(ClientPoint.Y) > Abs(ClientPrev.Y))
          )
         ) then
      begin
        if not Items[Top].OwnerCofirmation then
          for i := Top downto 0 do
          begin
            Browser := Items[i].FBrowser;
            ClientPoint := Browser.ScreenToClient(Point);
            if (ClientPoint.X < -2) or (ClientPoint.X >= Browser.Width - 2) or
              (ClientPoint.Y < -2) or (ClientPoint.Y >= Browser.Height - 2) then
            begin
              Items[i].Enabled := False;
            end else
              Break;
          end;
      end else if (ClientPoint.X < -2) or (ClientPoint.X >= Browser.Width - 2) or
        (ClientPoint.Y < -2) or (ClientPoint.Y >= Browser.Height - 2) then
      begin
        if Assigned(Items[i].PossessionView) then
          Items[i].PossessionView.Release;
      end;
    end;
  end;

  RootControl := Items[0].RootControl;
  if (not Items[0].Enabled) and Assigned(RootControl) then
  begin
    NotInRootControl := True;
    while Assigned(ControlAtCursor) do
    begin
      if ControlAtCursor = RootControl then
      begin
        NotInRootControl := False;
        Break;
      end;
      ControlAtCursor := ControlAtCursor.Parent;
    end;
    if NotInRootControl then
      Clear(True);
  end;

  FPrevPoint := Point;

end;

procedure TPopupViewList.FTimerTimer(Sender: TObject);
begin
  Confirm(Mouse.CursorPos);
end;

procedure TPopupViewList.FAppEventMessage(var Msg: tagMSG; var Handled: Boolean);
begin
  case Msg.message of
    WM_MOUSEMOVE, WM_NCMOUSEMOVE: Confirm(Mouse.CursorPos);
  end;
end;

procedure TPopupViewList.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

(*=======================================================*)

destructor TPictureViewList.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Assigned(TGraphic(Objects[i])) then
      TGraphic(Objects[i]).Free;
  end;

  inherited Destroy;
end;

function TSkinCollectionList.GetItems(index: integer): TSkinCollection;
begin
  result := inherited Items[index];
end;

(*=======================================================*)

(* destに指定されたレスを出力する *) //thread.addrefは呼び出し側責任
procedure Make2chInfo(dest: TDatOut; URI: string; basethread: TThreadItem;
                      board: TBoard; thread: TThreadItem; RangeArray: TRangeArray);

  procedure MakeThreadInfo(dest: TDatOut);
  var
    dat: TThreadData;
    ThreadURL: String;
    i: Integer;
    POPUPD2HTML: TDat2HTML;
  begin
    if (thread <> basethread) or (rangearray[0].st = -1) then
    begin
      ThreadURL := thread.ToURL;
      dest.WriteAnchor('', ThreadURL, PChar(ThreadURL), Length(ThreadURL));
      dest.WriteText(#13#10 +
           TCategory(TBoard(thread.board).category).name + ' ['
         + TBoard(thread.board).name + ']　“'
         + HTML2String(thread.title) + '”' + #13#10#13#10);
    end;
    if Config.hintForOtherThread or (thread = BaseThread) then
    begin
      dat := thread.DupData;
      POPUPD2HTML := SetUpDat2HTML((SkinCollectionList.Items[TBoard(thread.board).CustomSkinIndex]).PopupRecHTML, dhtPopupRes);
      POPUPD2HTML.URL := thread.ToURL;
      POPUPD2HTML.Title := thread.title;
      try
      if RangeArray[0].st >= 0 then
        for i := 0 to Length(RangeArray) - 1 do
          POPUPD2HTML.PickUpRes(dest, dat, thread.ABoneArray, thread.NeedConvert, RangeArray[i].st, RangeArray[i].ed);
      finally
        dat.Free;
        POPUPD2HTML.Free;
      end;
    end;
  end;
  
begin
  if board <> nil then
  begin
    if thread <> nil then
      MakeThreadInfo(dest)
    else
    begin
      //板情報だけ表示
      dest.WriteAnchor('', URI, PChar(URI), Length(URI));
      dest.WriteText(#13#10 + TCategory(board.category).name + ' [' + board.name + ']');
    end;
  end else
    MakeThreadInfo(dest);
  dest.Flush;
end;

function MakeIDInfo(dest: TDatOut; const URI: String;
        const thread: TThreadItem; Max: integer): Integer;
  procedure ShowTitle(ID: String; Count: Integer);
  begin
    dest.WriteHTML('抽出 ID:' + ID + ' (' + IntToStr(Count) + '回)<br><br>');
  end;

  function GetThreadMaxNum: integer;
  begin
    case TBoard(thread.board).GetBBSType of
    bbs2ch:   result := 1000;
    bbsMachi: result := 300;
    else      result := 100000;
    end;
  end;

var
  i, size: Integer;
  list: array of integer;
  dup: TThreadData;
  p: PChar;
  POPUPD2HTML: TDat2HTML;
begin
  Result := 0;
  if (Length(URI) <= 0) or (thread = nil) or (thread.dat = nil) then
    exit;
  {$IFDEF DEVELBENCH}{$IFDEF BENCH}
  Bench(0);
  {$ENDIF}{$ENDIF}
  dup := thread.DupData;
  SetLength(list, GetThreadMaxNum);
  POPUPD2HTML := SetUpDat2HTML((SkinCollectionList.Items[TBoard(thread.board).CustomSkinIndex]).PopupRecHTML, dhtPopupRes);
  POPUPD2HTML.URL := thread.ToURL;
  POPUPD2HTML.Title := thread.title;
  try
    Result := 0;
    for i := 1 to thread.lines do
    begin
      if dup.FetchIDP(i, p, size) and (StrLComp(p, PChar(URI), size) = 0) then
      begin
        list[result] := i;
        Inc(result);
      end;
    end;
    ShowTitle(URI, result);
    if result < Max then Max := result;
    for i := result - Max to result - 1 do
    begin
      POPUPD2HTML.ToDatOut(dest, dup, list[i], 1, thread.ABoneArray, thread.NeedConvert);
    end;
  finally
    dup.Free;
    POPUPD2HTML.Free;
    SetLength(list, 0);
    {$IFDEF DEVELBENCH}{$IFDEF BENCH}
    Bench(1);
    {$ENDIF}{$ENDIF}
  end;
end;

(* ポップアップ用範囲指定レス抽出 *)
function PickUpRes(thread: TThreadItem; startLine, endLine: integer): string;
var
  dest: TStrDatOut;
  dup: TThreadData;
  POPUPD2HTML: TDat2HTML;
begin
  if thread = nil then
    exit;
  dest := TStrDatOut.Create;
  dup := thread.DupData;
  POPUPD2HTML := SetUpDat2HTML((SkinCollectionList.Items[TBoard(thread.board).CustomSkinIndex]).PopupRecHTML, dhtPopupRes);
  try
    POPUPD2HTML.PickUpRes(dest, dup, thread.abonearray, thread.NeedConvert, startLine, endLine);
    Result := dest.Text;
  finally
    dup.Free;
    dest.Free;
    POPUPD2HTML.Free;
  end;
end;

function SetUpDat2HTML(const body: string; d2htype: TDat2HTMLType): TDat2HTML;
var
  d2html: TDat2HTML;
begin
  d2html := TDat2HTML.Create(body, Config.SkinPath);
  if d2htype <> dhtSearchRes then
  begin
    d2html.NGItems := Main.NGItems;
    d2html.ExNGList := Main.ExNGList;
    if d2htype = dhtPopupRes then
    begin
      d2html.AboneLevel := 127;
      d2html.VisibleAbone := True;
    end else
    begin
      d2html.AboneLevel := Main.AboneLevel;
      d2html.TransparencyAbone := Config.viewTransparencyAbone;
      d2html.PermanentNG := Config.viewPermanentNG;
      d2html.PermanentMarking := Config.viewPermanentMarking;
      d2html.LinkABone := Config.viewLinkAbone;
    end;
  end;
  result := d2html;
end;

end.

