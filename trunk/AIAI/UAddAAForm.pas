unit UAddAAForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, HogeTextView, UViewItem, UDat2HTML,
  U2chThread, StrUtils, UCrypt, IniFiles, StrSub, JLWritePanel;

type
  TAddAAForm = class(TForm)
    PageControl: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheetPreview: TTabSheet;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Panel: TPanel;
    MemoTitle: TMemo;
    MemoEdit: TMemo;
    PanelTitle: TPanel;
    LabelKind: TLabel;
    LabelLines: TLabel;
    Labelcaution: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure MemoEditChange(Sender: TObject);
    procedure MemoTitleChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Preview: THogeTextView;
    function GetText: String;
    procedure SetText(AText: String);
    procedure ShowPreview;
    function Res2Dat: string;
    function saveToAAList: Boolean;
  public
  published
    property Text: String read GetText write SetText;
  end;

implementation

uses
  Main, JConfig;

{$R *.dfm}

procedure TAddAAForm.FormCreate(Sender: TObject);
  procedure LoadWindowPos;
  var
    ini: TMemIniFile;
  begin
    ini := TMemIniFile.Create(Config.IniPath);
    self.Top    := ini.ReadInteger(INI_AA_SECt, 'AddAAFormTop',    self.Top);
    self.Left   := ini.ReadInteger(INI_AA_SECT, 'AddAAFormLeft',   self.Left);
    self.Height := ini.ReadInteger(INI_AA_SECT, 'AddAAFormHeight', self.Height);
    self.Width  := ini.ReadInteger(INI_AA_SECT, 'AddAAFormWidth',  self.Width);
    ini.Free;
  end;
begin
  PageControl.ActivePage := TabSheetMain;
  LoadWindowPos;
  Preview := THogeTextView.Create(TabSheetPreview);
  with Preview do
  begin
    Parent := TabSheetPreview;
    Align := alClient;
    LeftMargin := 8;
    TopMargin := 4;
    RightMargin := 8;
    ExternalLeading := 1;
    VerticalCaretMargin := Config.viewVerticalCaretMargin;
    WheelPageScroll := Config.viewPageScroll;
    VScrollLines := Config.viewScrollLines;
    EnableAutoScroll := Config.viewEnableAutoScroll;
    Frames := Config.viewScrollSmoothness;
    FrameRate := Config.viewScrollFrameRate;
    Font.Name := 'ＭＳ Ｐゴシック';
    Color := RGB($ef, $ef, $ef);
    TextAttrib[1].style := [fsBold];
    TextAttrib[2].color := clBlue;
    TextAttrib[2].style := [fsUnderline];
    TextAttrib[3].color := clBlue;
    TextAttrib[3].style := [fsBold, fsUnderline];
    TextAttrib[4].color := clGreen;
    TextAttrib[5].color := clGreen;
    TextAttrib[5].style := [fsBold];
    OnMouseMove :=  MainWnd.OnBrowserMouseMove;
    OnMouseDown :=  MainWnd.OnBrowserMouseDown;
    OnMouseHover := MainWnd.OnBrowserMouseHover;
  end;
end;

function TAddAAForm.GetText: String;
begin
  Result := MemoEdit.Text;
end;

procedure TAddAAForm.SetText(AText: String);
begin
  MemoEdit.Text := AText;
end;

procedure TAddAAForm.ShowPreview;
const
  HeaderSkin = '<html><body><font face="ＭＳ Ｐゴシック"><dl>';
var
  TempStream: TDat2PreViewView;
  PreviewD2HTML: TDat2HTML;
  ResSkin: String;
  dat: TThreadData;

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

begin
  Preview.Clear;
  TempStream := TDat2PreViewView.Create(Preview);
  ResSkin := '<dt><SA i=1><b><PLAINNUMBER/></b><SA i=0> ：<SA i=2><b><NAME/></b></b><SA i=0>[<MAIL/>] ：<DATE/></dt><dd><MESSAGE/><br><br></dd>'#10;
  PreviewD2HTML := TDat2HTML.Create(ResSkin);
  dat := TThreadData.Create;
  try
    Preview.ExternalLeading := ZoomToExternalLeading(Config.viewZoomSize);
    Preview.SetFont(Preview.Font.Name, -12);
    dat.Add(Res2Dat);
    TempStream.WriteHTML(HeaderSkin);
    TempStream.Flush;
    PreviewD2HTML.ToDatOut(TempStream, dat, 1, 1);
    TempStream.Flush;
  finally
    dat.Free;
    PreviewD2HTML.Free;
    TempStream.Free;
  end;
end;

function TAddAAForm.Res2Dat: string;
  function HtmlPost(const S: string):string;
  begin
    Result := S;
    Result := AnsiReplaceStr(Result, '<', '&lt;');
    Result := AnsiReplaceStr(Result, '>', '&gt;');
    Result := AnsiReplaceStr(Result, #13#10, '<br>');
    Result := AnsiReplaceStr(Result, #13, '<br>');
    Result := AnsiReplaceStr(Result, #10, '<br>');
  end;
  function MessageConv(const S: string):string;
  begin
    Result := HtmlPost(S);
    Result := AnsiReplaceStr(Result, '"', '&quot;');
  end;
var
  aName, aMail, aDate, aMessage: string;
  p1, p2: PChar;
  tmp: String;
begin
  aName := '<b>名無しさん</b>';
  aMail := '';
  aDate := FormatDateTime('yy/mm/dd hh:nn', Now);
  aDate := aDate + ' ID:xxxxxxxxxx';
  aMessage := MemoEdit.Text;

  aMessage := MessageConv(aMessage);

  Result := aName + '<>'
          + aMail + '<>'
          + aDate + '<>'
          + aMessage + '<>' + #10;

  //Unicode置換板の処理  とりあえず全部の置換しとく
  //if SameText(SettingTxt.Lines.Values['BBS_UNICODE'], 'change') then
  //begin
    p1 := PChar(Result);
    SetLength(tmp, Length(Result));
    p2 := PChar(tmp);
    while True do
    begin
      if (p1^ = '&') and ((p1 + 1)^ ='#') then
      begin
        p2^ := #$81;
        inc(p2);
        p2^ := #$48;
        inc(p2);
        inc(p1, 2);
        while p1^ in ['0'..'9'] do
          inc(p1);
        if p1^ = ';' then
          inc(p1);
      end else
      begin
        if p1^ in LeadBytes then
        begin
          p2^ := p1^;
          inc(p1);
          inc(p2);
          p2^ := p1^;
          inc(p1);
          inc(p2);
        end else
        begin
          p2^ := p1^;
          if p1^ = #10 then
            Break;
          inc(p1);
          inc(p2);
        end;
      end;
    end;
    Result := copy(tmp, 1, p2 - PChar(tmp) + 1);
  //end;
end;

procedure TAddAAForm.PageControlChange(Sender: TObject);
var
  ActiveTab: TTabSheet;
begin
  ActiveTab := PageControl.Pages[PageControl.ActivePageIndex];

  if ActiveTab = TabSheetPreview then
    ShowPreview;
end;

procedure TAddAAForm.MemoEditChange(Sender: TObject);
var
  Lines: Integer;
begin
  Lines := MemoEdit.Lines.Count;

  LabelLines.Caption := IntToSTr(Lines) + '行';

  if Lines > 1 then
  begin
    LabelKind.Caption := '複数行AAのタイトル';
    MemoTitle.Enabled := true;
    MemoTitle.Brush.Color := clWindow;
    if not (length(MemoTitle.Text) > 0) then
    begin
      ButtonOK.Enabled := false;
      Labelcaution.Caption := '複数行AAのタイトルを入力して下さい';
      Labelcaution.Color := clYellow;
      Labelcaution.Visible := true;
    end else
    begin
      ButtonOK.Enabled := true;
      Labelcaution.Visible := false;
    end;
  end else if Lines = 1 then
  begin
    LabelKind.Caption := '一行AA';
    MemoTitle.Enabled := false;
    MemoTitle.Brush.Color := clBtnFace;
    ButtonOK.Enabled := true;
    Labelcaution.Visible := false;
  end else
  begin
    LabelKind.Caption := '';
    MemoTitle.Enabled := false;
    MemoTitle.Brush.Color := clBtnFace;
    ButtonOK.Enabled := false;
    Labelcaution.Caption := 'AAの内容がありません';
    Labelcaution.Color := clYellow;
    Labelcaution.Visible := true;
  end;
end;

procedure TAddAAForm.FormDestroy(Sender: TObject);
begin
  if Preview <> nil then
    Preview.Free;
end;

procedure TAddAAForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);

  procedure SaveWindowPos;
  var
    ini: TMemIniFile;
  begin
    ini := TMemIniFile.Create(Config.IniPath);
    ini.WriteInteger(INI_AA_SECT, 'AddAAFormTop',    self.Top);
    ini.WriteInteger(INI_AA_SECT, 'AddAAFormLeft',   self.Left);
    ini.WriteInteger(INI_AA_SECT, 'AddAAFormHeight', self.Height);
    ini.WriteInteger(INI_AA_SECT, 'AddAAFormWidth',  self.Width);

    ini.UpdateFile;
    ini.Free;
  end;

var
  close: Boolean;
begin
  close := true;
  if modalResult = mrOK then
  begin
    close := saveToAAList;
  end;

  if close then
    SaveWindowPos;

  CanClose := close;
end;

function TAddAAForm.saveToAAList: Boolean;
var
  index: Integer;

  procedure CreateAAList;
  var
    index: Integer;
  begin
    Config.aaAAList.Clear;
    Config.aaAAList.Add('[aalist]');
    if MemoEdit.Lines.Count > 1 then  //複数行AA
    begin
      Config.aaAAList.Add('*' + MemoTitle.Text);
      Config.aaAAList.Add('[' + MemoTitle.Text + ']');
      for index := 0 to MemoEdit.Lines.Count - 1 do
        Config.aaAAList.Append(MemoEdit.Lines.Strings[index]);
    end else //1行AA
    begin
      Config.aaAAList.Add(MemoEdit.Lines.Strings[0]);
    end;
    UpdateAAComboBox;
    Config.aaAAList.SaveToFile(Config.BasePath + 'AAlist.txt');
  end;

begin

  if not (length(MemoEdit.Text) > 0) then
  begin
//    Beep;
    Application.MessageBox('内容がありません', '確認', MB_OK);
    Result := false;
    exit;
  end;

  if (MemoEdit.Lines.Count = 1) and
     ((1 = AnsiPos('*', MemoEdit.Text)) or (1 = AnsiPos('[', MemoEdit.Text))) then
  begin
    Application.MessageBox('AAの一文字目を*や[にしないで下さい', '確認', MB_OK);
    Result := false;
    exit;
  end;

  if not FileExists(Config.BasePath + 'AAlist.txt') then
  begin
    Beep;
    if mrOK = MessageDlg('AAlist.txtがありません' + #13#10 + '新規に作りますか？', mtConfirmation, mbOKCancel, 0) then
    begin
      CreateAAList;
      Result := true;
    end else
      Result := false;
    exit;
  end;

  Config.aaAAList.Clear;
  Config.aaAAList.LoadFromFile(Config.BasePath + 'AAlist.txt');

  if LeftStr(Config.aaAAList.Strings[0], 8) <> '[aalist]' then
  begin
    Application.MessageBox('AAlist.txtの1行目に[aalist]がないので登録やめ', '確認', MB_OK);
    Result := false;
    exit;
  end;

  if MemoEdit.Lines.Count > 1 then     //複数行AA
  begin
    for index := 1 to Config.aaAAList.Count - 1 do
      if (1 = AnsiPos('[', Config.aaAAList.Strings[index])) then
        break;

    Config.aaAAList.Insert(index, '*' + MemoTitle.Text);
    Config.aaAAList.Append('[' + MemoTitle.Text + ']');

    for index := 0 to MemoEdit.Lines.Count - 1 do
      Config.aaAAList.Append(MemoEdit.Lines.Strings[index]);
  end else                             //1行AA
  begin
    for index := 1 to Config.aaAAList.Count - 1 do
      if (1 = AnsiPos('*', Config.aaAAList.Strings[index])) then
        break
      else if (1 = AnsiPos('[', Config.aaAAList.Strings[index])) then
        break;

    Config.aaAAList.Insert(index, MemoEdit.Lines.Strings[0]);
  end;

  UpdateAAComboBox;
  Config.aaAAList.SaveToFile(Config.BasePath + 'AAlist.txt');

  Result := true;
end;

procedure TAddAAForm.MemoTitleChange(Sender: TObject);
begin
  if (Length(MemoTitle.Text) > 0) then
  begin
    ButtonOK.Enabled := true;
    Labelcaution.Visible := false;
  end else
  begin
    ButtonOK.Enabled := false;
    Labelcaution.Caption := '複数行AAのタイトルを入力して下さい';
    Labelcaution.Color := clYellow;
    Labelcaution.Visible := true;
  end;
end;

procedure TAddAAForm.FormShow(Sender: TObject);
begin
  if MemoTitle.Enabled and MemoTitle.Visible then
    MemoTitle.SetFocus
  else if ButtonOK.Enabled and ButtonOK.Visible then
    ButtonOK.SetFocus;
end;

end.
