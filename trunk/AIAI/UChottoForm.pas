unit UChottoForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  HogeTextView,
  ULocalCopy,
  U2chTicket,
  UASync,
  StdCtrls,
  StrUtils,
  ExtCtrls,
  UViewItem, ComCtrls;

type
  TChottoForm = class(TForm)
    ButtonOpen: TButton;
    PageControl: TPageControl;
    TabSheet: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonOpenClick(Sender: TObject);
  private
    FURL: String;
    FStatusText: String;
    savedTop: Integer;
    savedLeft: Integer;
    savedHeight: Integer;
    savedWidth: Integer;
    HideOnApplicationMinimize: Boolean;
    TextView: THogeTextView;
    ChottoViewItem: TFlexViewItem;
    procGet: TAsyncReq;
    procedure SetURL(AURL: String);
    procedure OnChotto(sender: TAsyncReq);
  public
    function SavedBoundsRect: TRect;
    procedure MainWndOnShow;
    procedure MainWndOnHide;
  published
    property URL: String read FURL Write SetURL;  //URLをセットしたあとread.cgiにアクセスしに行く
  end;

var
  ChottoForm: TChottoForm;

implementation

{$R *.dfm}

uses
  Main, JConfig, jconvert;

(* 初期化 *)
procedure TChottoForm.FormCreate(Sender: TObject);
begin
  savedTop := 0;
  savedLeft := 0;
  savedHeight := 0;
  savedWidth := 0;
  HideOnApplicationMinimize := false;
  FURL := '';
  FStatusText := '';

  (* スレ表示部分 *)
  TextView := THogeTextView.Create(TabSheet);
  with TextView do
  begin
    Parent := TabSheet;
    Align := alClient;
    Enabled := True;
    Visible := True;
    TabStop := True;
    LeftMargin := 8;
    TopMargin := 4;
    RightMargin := 8;
    ExternalLeading := 1;
    VerticalCaretMargin := 1;
    VScrollLines := 5;
    TextView.HoverTime := Config.hintHoverTime;
    Move(Config.viewTextAttrib, TextAttrib, SizeOf(TextAttrib));
    Color := Main.Config.clViewColor;  //スレビューと同じ色
    (*
    TextAttrib[1].style := [fsBold];
    TextAttrib[2].color := clBlue;
    TextAttrib[2].style := [fsUnderline];
    TextAttrib[3].color := clBlue;
    TextAttrib[3].style := [fsBold, fsUnderline];
    TextAttrib[4].color := clRed;
    TextAttrib[5].color := clGreen;
    *)
    OnMouseMove  := MainWnd.OnBrowserMouseMove;
    OnMouseDown  := MainWnd.OnBrowserMouseDown;
    OnMouseHover := MainWnd.OnBrowserMouseHover;
    PopupMenu := MainWnd.PopupTextMenu;
  end;

  ChottoViewItem := TFlexViewItem.Create;
  ChottoViewItem.PopUpViewList := Main.popupviewList;
  ChottoViewItem.browser := TextView;
  ChottoViewItem.RootControl := PageControl;

  procGet := nil;
end;

(* フォームを破棄 *)
procedure TChottoForm.FormDestroy(Sender: TObject);
begin
  TextView.Free;
  ChottoViewItem.Free;
end;

(* アクティブになった時 *)
procedure TChottoForm.FormActivate(Sender: TObject);
begin
  (* 高さを元に戻す *)
  if (WindowState <> wsMaximized) then begin
    if 0 < savedWidth then
      Width := savedWidth;
    if 0 < savedHeight then
      Height := savedHeight;
  end;
end;

(* アクティブでなくなった時 *)
procedure TChottoForm.FormDeactivate(Sender: TObject);
begin
  if (WindowState <> wsMinimized) then begin
    savedLeft := Left;
    savedTop  := Top;
    savedWidth:= Width;
    savedHeight:= Height;
    Height := 10;
  end;
end;

procedure TChottoForm.FormShow(Sender: TObject);
begin
  (* 保存された位置に移動 *)
  if (Config.ojvchottoViewerTop >= 0)
     and (Config.ojvchottoViewerLeft >= 0)
     and (Config.ojvchottoViewerHeight >= 0)
     and (Config.ojvchottoViewerWidth >= 0) then
    BoundsRect := Bounds(Config.ojvchottoViewerLeft,
                         Config.ojvchottoViewerTop,
                         Config.ojvchottoViewerWidth,
                         Config.ojvchottoViewerHeight);
end;

(* 閉じたようにみせる *)
procedure TChottoForm.FormHide(Sender: TObject);
begin
  if not HideOnApplicationMinimize then
  begin
    SavedBoundsRect;
    if MainWnd.Visible then
      MainWnd.SetFocus;
  end;
end;

//保存用の位置を返す(縮んでいるときは元のサイズを返す)
function TChottoForm.SavedBoundsRect: TRect;
begin
  Result := BoundsRect;
  if WindowState <> wsMaximized then
  begin
    if 0 < savedHeight then
      Result.Bottom := Result.Top + savedHeight;
  end;
  Config.ojvchottoViewerTop := Result.Top;
  Config.ojvchottoViewerLeft := Result.Left;
  Config.ojvchottoViewerHeight := Result.Bottom - Result.Top;
  Config.ojvchottoViewerWidth := Result.Right - Result.Left;
end;

//アプリ復元時に必要なら復元(Main.pasのTMainWnd.OnAboutToShow参照)
procedure TChottoForm.MainWndOnShow;
begin
  if HideOnApplicationMinimize then
    Self.Show;
  HideOnApplicationMinimize:=False;
end;

//アプリ最小化時に自分を隠す(Main.pasのTMainWnd.OnAboutToShow参照)
procedure TChottoForm.MainWndOnHide;
begin
  if Visible then    //aiai
  begin
    HideOnApplicationMinimize := True;
    Hide;
  end;
end;

(* 開くボタンをクリックでこのスレを開く *)
procedure TChottoForm.ButtonOpenClick(Sender: TObject);
begin
  MainWnd.NavigateIntoView(URL, gtOther, false, false);
  Hide;
end;




(* URLをセットしたあと、read.cgiに行く *)
procedure TchottoForm.SetURL(AURL: String);
begin
  FURL := AURL;

  TabSheet.Caption := FURL;
  procGet := AsyncManager.Get(FURL, OnChotto, ticket2ch.OnChottoPreConnect);
end;

(* ちょっと見る完了イベントハンドラ *)
procedure TChottoForm.OnChotto(sender: TAsyncReq);
  procedure WriteHTML(strchotto: string);
  var
    ht2v: TSimpleDat2View;
  begin
    TextView.Clear;
    ht2v := TSimpleDat2View.Create(TextView);
    ht2v.WriteHTML(strchotto);
    ht2v.Flush;
    ht2v.Free;
  end;

  function chottoReplace(const S: string):string;
  begin
    Result := S;
    Result := AnsiReplaceStr(Result,'<title>','<!--');
    Result := AnsiReplaceStr(Result,'</title>','-->');
    Result := AnsiReplaceStr(Result,'<p>','<br><br>');
    Result := AnsiReplaceStr(Result,'<dl>','<br><br>');
    Result := AnsiReplaceStr(Result,'<dt>','</dd><dt>');
    Result := AnsiReplaceStr(Result,'</dl>','</dd></dl>');
    Result := AnsiReplaceStr(Result,'</td>','<br>');
    Result := AnsiReplaceStr(Result,'ime.nu/', '');
  end;

var
  strchotto: String;
begin
  if procGet = sender then
  begin
    case sender.IdHTTP.ResponseCode of
    200: (* OK *)
      begin
        strchotto := sender.Content;
      end;
    304: (* Not Modified *)
      begin
      end;
    else
      begin
      end;
    end;
    strchotto := ConvertJCode(strchotto, SJIS_OUT);
    strchotto := chottoReplace(strchotto);
    WriteHTML(strchotto);
    ChottoViewItem.Base := FURL;
    procGet := nil;
  end;
end;

end.
