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
    property URL: String read FURL Write SetURL;  //URL���Z�b�g��������read.cgi�ɃA�N�Z�X���ɍs��
  end;

var
  ChottoForm: TChottoForm;

implementation

{$R *.dfm}

uses
  Main, JConfig, jconvert;

(* ������ *)
procedure TChottoForm.FormCreate(Sender: TObject);
begin
  savedTop := 0;
  savedLeft := 0;
  savedHeight := 0;
  savedWidth := 0;
  HideOnApplicationMinimize := false;
  FURL := '';
  FStatusText := '';

  (* �X���\������ *)
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
    Color := Main.Config.clViewColor;  //�X���r���[�Ɠ����F
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

(* �t�H�[����j�� *)
procedure TChottoForm.FormDestroy(Sender: TObject);
begin
  TextView.Free;
  ChottoViewItem.Free;
end;

(* �A�N�e�B�u�ɂȂ����� *)
procedure TChottoForm.FormActivate(Sender: TObject);
begin
  (* ���������ɖ߂� *)
  if (WindowState <> wsMaximized) then begin
    if 0 < savedWidth then
      Width := savedWidth;
    if 0 < savedHeight then
      Height := savedHeight;
  end;
end;

(* �A�N�e�B�u�łȂ��Ȃ����� *)
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
  (* �ۑ����ꂽ�ʒu�Ɉړ� *)
  if (Config.ojvchottoViewerTop >= 0)
     and (Config.ojvchottoViewerLeft >= 0)
     and (Config.ojvchottoViewerHeight >= 0)
     and (Config.ojvchottoViewerWidth >= 0) then
    BoundsRect := Bounds(Config.ojvchottoViewerLeft,
                         Config.ojvchottoViewerTop,
                         Config.ojvchottoViewerWidth,
                         Config.ojvchottoViewerHeight);
end;

(* �����悤�ɂ݂��� *)
procedure TChottoForm.FormHide(Sender: TObject);
begin
  if not HideOnApplicationMinimize then
  begin
    SavedBoundsRect;
    if MainWnd.Visible then
      MainWnd.SetFocus;
  end;
end;

//�ۑ��p�̈ʒu��Ԃ�(�k��ł���Ƃ��͌��̃T�C�Y��Ԃ�)
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

//�A�v���������ɕK�v�Ȃ畜��(Main.pas��TMainWnd.OnAboutToShow�Q��)
procedure TChottoForm.MainWndOnShow;
begin
  if HideOnApplicationMinimize then
    Self.Show;
  HideOnApplicationMinimize:=False;
end;

//�A�v���ŏ������Ɏ������B��(Main.pas��TMainWnd.OnAboutToShow�Q��)
procedure TChottoForm.MainWndOnHide;
begin
  if Visible then    //aiai
  begin
    HideOnApplicationMinimize := True;
    Hide;
  end;
end;

(* �J���{�^�����N���b�N�ł��̃X�����J�� *)
procedure TChottoForm.ButtonOpenClick(Sender: TObject);
begin
  MainWnd.NavigateIntoView(URL, gtOther, false, false);
  Hide;
end;




(* URL���Z�b�g�������ƁAread.cgi�ɍs�� *)
procedure TchottoForm.SetURL(AURL: String);
begin
  FURL := AURL;

  TabSheet.Caption := FURL;
  procGet := AsyncManager.Get(FURL, OnChotto, ticket2ch.OnChottoPreConnect);
end;

(* ������ƌ��銮���C�x���g�n���h�� *)
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
