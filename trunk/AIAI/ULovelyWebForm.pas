unit ULovelyWebForm;
(* 簡易ウェブブラウザー *)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw_TLB, ComCtrls, ToolWin, ImgList, StdCtrls,
  JLXPComCtrls;

const
  LOVELY_WEB_BROWSER = '川 ’ー’川 Lovely Web Browser';



type
  TLovelyWebForm = class(TForm)
    NavigateToolBar: TJLXPToolBar;
    GoBackButton: TToolButton;
    GoForwardButton: TToolButton;
    StopButton: TToolButton;
    GoHomeButton: TToolButton;
    RefreshButton: TToolButton;
    NavigateEdit: TEdit;
    NavigateButtonImageList: TImageList;
    WebBrowser: TWebBrowser;
    StatusBar: TJLXPStatusBar;
    procedure NavigateButtonClick(Sender: TObject);
    procedure NavigateEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure WebBrowserCommandStateChange(Sender: TObject;
      Command: Integer; Enable: WordBool);
    procedure WebBrowserNavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowserTitleChange(Sender: TObject;
      const Text: WideString);
    procedure WebBrowserStatusTextChange(Sender: TObject;
      const Text: WideString);
    procedure NavigateEditEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure WebBrowserWindowClosing(Sender: TObject;
      IsChildWindow: WordBool; var Cancel: WordBool);
    //procedure FormResize(Sender: TObject);
  private
    { Private 宣言 }
    HideOnApplicationMinimize: Boolean;
    savedHeight: Integer;
    savedWidth:  Integer;
    savedTop:    Integer;
    savedLeft:   Integer;
    //StatusBar: TJLStatusBar;
  public
    { Public 宣言 }
    procedure MainWndOnShow;
    procedure MainWndOnHide;
    function SavedBoundsRect: TRect;
  end;

implementation

uses
  Main;

{$R *.dfm}

procedure TLovelyWebForm.FormCreate(Sender: TObject);
begin
  self.Caption := LOVELY_WEB_BROWSER;
  savedTop    := 0;
  savedLeft   := 0;
  savedHeight := 0;
  savedWidth  := 0;
  HideOnApplicationMinimize := false;

  //StatusBar := TJLStatusBar.Create(Handle);
end;

procedure TLovelyWebForm.FormActivate(Sender: TObject);
begin
  if (WindowState <> wsMaximized) then begin
    if 0 < savedWidth then
      Width := savedWidth;
    if 0 < savedHeight then
      Height := savedHeight;
  end;

  SetImeMode(Handle, userImeMode);
end;

procedure TLovelyWebForm.FormDeactivate(Sender: TObject);
begin
  if (WindowState <> wsMinimized) then begin
    savedLeft := Left;
    savedTop  := Top;
    savedWidth:= Width;
    savedHeight:= Height;
    //Height := 50;
    Height := 0;
  end;
  SaveImeMode(Handle);
end;

(* 戻る、進む、中止、再読込、ホーム *)
procedure TLovelyWebForm.NavigateButtonClick(Sender: TObject);
var
  tag: integer;
begin
  tag := TToolButton(Sender).Tag;
  case tag of
    1: WebBrowser.GoBack;
    2: WebBrowser.GoForward;
    3: if WebBrowser.Busy then WebBrowser.Stop;
    4: if WebBrowser.Document <> nil then WebBrowser.Refresh;
    5: WebBrowser.GoHome;
  else exit;
  end;
end;

(* 指定したURLへ *)
procedure TLovelyWebForm.NavigateEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  url: string;
begin
  if Key = VK_RETURN then
  begin
    url := NavigateEdit.Text;
    if url = '' then begin
      url := 'about:blank';
      NavigateEdit.Text := url;
    end;
    WebBrowser.Navigate(url);
  end;
end;

(* 戻る、進むボタンを押せるか否か *)
procedure TLovelyWebForm.WebBrowserCommandStateChange(Sender: TObject;
  Command: Integer; Enable: WordBool);
begin
  case Command of
    CSC_NAVIGATEFORWARD: GoForwardButton.Enabled := Enable;
    CSC_NAVIGATEBACK:    GoBackButton.Enabled    := Enable;
    else
  end;
end;

(* URLを表示 *)
procedure TLovelyWebForm.WebBrowserNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  NavigateEdit.Text := WebBrowser.LocationURL;
end;

(* タイトル表示 *)
procedure TLovelyWebForm.WebBrowserTitleChange(Sender: TObject;
  const Text: WideString);
begin
  self.Caption := LOVELY_WEB_BROWSER + ' - '+ Text;
end;

(* ステータス表示 *)
procedure TLovelyWebForm.WebBrowserStatusTextChange(Sender: TObject;
  const Text: WideString);
begin
  //StatusBar.Text[0] := Text;
  StatusBar.SimpleText := Text;
end;

(* URLを全選択 *)
procedure TLovelyWebForm.NavigateEditEnter(Sender: TObject);
begin
  if NavigateEdit.Text <> '' then
    PostMessage(NavigateEdit.Handle, EM_SETSEL, 0, -1);
end;

procedure TLovelyWebForm.MainWndOnShow;
begin
  if HideOnApplicationMinimize then begin
    HideOnApplicationMinimize := false;
    Show;
  end;
end;

procedure TLovelyWebForm.MainWndOnHide;
begin
  if Visible then begin
    HideOnApplicationMinimize := true;
    Hide;
  end;
end;

procedure TLovelyWebForm.FormHide(Sender: TObject);
begin
  WebBrowser.Navigate('about:blank');
  if not HideOnApplicationMinimize then
  begin
    SavedBoundsRect;
    if MainWnd.Visible then
      MainWnd.SetFocus;
  end;
end;

//保存用の位置を返す(縮んでいるときは元のサイズを返す)
function TLovelyWebForm.SavedBoundsRect: TRect;
begin
  Result := BoundsRect;
  if WindowState <> wsMaximized then
  begin
    if 0 < savedHeight then
      Result.Bottom := Result.Top + savedHeight;
  end;
  Config.lovelyWebFormTop := Result.Top;
  Config.lovelyWebFormLeft := Result.Left;
  Config.lovelyWebFormHeight := Result.Bottom - Result.Top;
  Config.lovelyWebFormWidth := Result.Right - Result.Left;
end;

procedure TLovelyWebForm.FormShow(Sender: TObject);
begin
  (* 保存された位置に移動 *)
  {if (Config.lovelyWebFormTop >= 0)
     and (Config.lovelyWebFormLeft >= 0)
     and (Config.lovelyWebFormWidth >= 0)
     and (Config.lovelyWebFormHeight >= 0) then}
    BoundsRect := Bounds(Config.lovelyWebFormLeft,
                         Config.lovelyWebFormTop,
                         Config.lovelyWebFormWidth,
                         Config.lovelyWebFormHeight);

end;

procedure TLovelyWebForm.WebBrowserWindowClosing(Sender: TObject;
  IsChildWindow: WordBool; var Cancel: WordBool);
begin
  Cancel := True;
  Close;
end;

{procedure TLovelyWebForm.FormResize(Sender: TObject);
begin
  WebBrowser.Width := ClientWidth;
  WebBrowser.Height := ClientHeight - NavigateToolBar.Height - StatusBar.Height;
  WebBrowser.Top := NavigateToolBar.BoundsRect.Bottom;
end;}

end.
