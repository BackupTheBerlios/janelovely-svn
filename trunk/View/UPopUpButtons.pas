unit UPopUpButtons;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
  StdCtrls, ImgList, ExtCtrls;

type

  TTransparentForm = class(TForm)
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMouseOn:Boolean;
    procedure SetMouseOn(Value:Boolean);
  protected
    WindowRgn:HRGN;
    procedure SetRgn;
    procedure RemoveRgn;
    procedure WndProc(var Message: TMessage); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ShowInactive;
    property MouseOn:Boolean read FMouseOn write SetMouseOn;
  end;


  TPopUpButtons = class(TComponent)
  private
    FButtonWidth: Integer;
    FButtonHeight: Integer;
    FColumn: Integer;
    FOnClick: TNotifyEvent;
    FIndex: Integer;
    FOnCancel: TNotifyEvent;
    FShowTerm:Integer;
    FResetTimeIfMouseOver:Boolean;
    procedure SetButtonWidth(const Value: Integer);
    procedure SetButtonHeight(const Value: Integer);
    procedure SetColumn(const Value: Integer);
    procedure SetOnClick(const Value: TNotifyEvent);
    procedure SetIndex(const Value: Integer);
    procedure SetOnCancel(const Value: TNotifyEvent);
    procedure SetShowTerm(Value:Integer);
    procedure SetResetTimeIfMouseOver(Value:Boolean);
    function GetParent:TWinControl;
    procedure SetParent(Value:TWinControl);
  protected
    Timer:TTimer;
    TimerCount:Integer;
    Form:TTransparentForm;
    MasterWindowProc:TWndMethod;
    ButtonList:TList;
    procedure AlignButton;
    procedure SubWindowProc(var Message: TMessage);
    procedure ButtonClick(Sender:TObject);
    procedure TimerOnTime(Sender:TObject);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure MakeButton(Captions: array of string);overload;
    procedure MakeButton(ImageList:TImageList);overload;
    procedure PopUp(Pos:TPoint;IgnorePos:Boolean=False);
    procedure Hide;
    property ButtonWidth:Integer read FButtonWidth write SetButtonWidth;
    property ButtonHeight:Integer read FButtonHeight write SetButtonHeight;
    property Column:Integer read FColumn write SetColumn;
    property ResetTimeIfMouseOver:Boolean read FResetTimeIfMouseOver write SetResetTimeIfMouseOver;
    property Index:Integer read FIndex write SetIndex;
    property OnClick:TNotifyEvent read FOnClick write SetOnClick;
    property OnCancel:TNotifyEvent read FOnCancel write SetOnCancel;
    property Parent:TWinControl read GetParent write SetParent;
    property ShowTerm:Integer read FShowTerm write SetShowTerm;
  end;


implementation

uses main;

{$R *.DFM}

const TimerInterval=100;

//Childではなく、PopUpとして作成する(親Windowの枠外に出せる)
procedure TTransparentForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style:=Params.Style or WS_POPUP;
  Params.Style:=Params.Style and not(WS_CHILD);
end;

//アクティブ化しないで表示する
procedure TTransparentForm.ShowInactive;
begin
  if ControlCount=0 then Exit;
  SetWindowPos(Handle,HWND_TOP,0,0,0,0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
  Visible:=True;
end;


//表示する時にリージョンを適用
procedure TTransparentForm.FormShow(Sender: TObject);
begin
  SetRgn;
end;


//隠す時にリージョンを適用
procedure TTransparentForm.FormHide(Sender: TObject);
begin
  RemoveRgn;
end;




//子コントロール部分だけを表示するリージョンを適用
procedure TTransparentForm.SetRgn;
var
  i:Integer;
  BaseRgn,ControlRgn,CombinedRgn:HRGN;
begin
  if WindowRgn<>0 then RemoveRgn;

  BaseRgn:=CreateRectRgn(Controls[0].Left,Controls[0].Top,Controls[0].Left+Controls[0].Width,Controls[0].Top+Controls[0].Height);
  for i:=1 to ControlCount-1 do begin
    ControlRgn:=CreateRectRgn(Controls[i].Left,Controls[i].Top,Controls[i].Left+Controls[i].Width,Controls[i].Top+Controls[i].Height);
    CombinedRgn := CreateRectRgn(0, 0, 10, 10);
    CombineRgn(CombinedRgn,BaseRgn,ControlRgn,RGN_OR);
    DeleteObject(BaseRgn);
    DeleteObject(ControlRgn);
    BaseRgn:=CombinedRgn;
  end;
  WindowRgn:=BaseRgn;
  SetWindowRgn(Handle,WindowRgn,False);
end;


//リージョンの破棄
procedure TTransparentForm.RemoveRgn;
begin
  SetWindowRgn(Handle,0,False);
  DeleteObject(WindowRgn);
  WindowRgn:=0;
end;

//自分のボタンがクリックされた場合は、すぐに閉じられないよう状態を保持
procedure TTransparentForm.WndProc(var Message: TMessage);
begin
 if Message.Msg=WM_MOUSEACTIVATE then
   MouseOn:=True;
 inherited WndProc(Message);
end;

procedure TTransparentForm.SetMouseOn(Value:Boolean);
begin
  FMouseOn:=Value;
end;


{ TPopUpButtons }


constructor TPopUpButtons.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  MasterWindowProc:=nil;
  FButtonWidth:=24;
  FButtonHeight:=24;
  FColumn:=4;
  FResetTimeIfMouseOver:=True;
  ButtonList:=TList.Create;
  Form:=TTransparentForm.Create(Owner);
  Timer:=TTimer.Create(Self);
  Timer.Interval:=TimerInterval;
  Timer.Enabled:=False;
  Timer.OnTimer:=TimerOnTime;
end;


destructor TPopUpButtons.Destroy;
begin
  ButtonList.Free;

  inherited Destroy;
end;


//プロパティ関連

//ボタン高さの設定
procedure TPopUpButtons.SetButtonHeight(const Value: Integer);
var
  i:Integer;
begin
  FButtonHeight := Value;
  for i:=0 to ButtonList.Count-1 do
    TSpeedButton(ButtonList[i]).Height:=FButtonHeight;
  AlignButton;
end;
//ボタン幅の設定
procedure TPopUpButtons.SetButtonWidth(const Value: Integer);
var
  i:Integer;
begin
  FButtonWidth := Value;
  for i:=0 to ButtonList.Count-1 do
    TSpeedButton(ButtonList[i]).Height:=FButtonHeight;
  AlignButton;
end;
//ボタンの列数設定
procedure TPopUpButtons.SetColumn(const Value: Integer);
begin
  FColumn := Value;
  AlignButton;
end;
//押されたボタンの番号(代入可)
procedure TPopUpButtons.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;
//クリックイベント
procedure TPopUpButtons.SetOnClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
end;
//キャンセルイベント
procedure TPopUpButtons.SetOnCancel(const Value: TNotifyEvent);
begin
  FOnCancel := Value;
end;
//表示時間
procedure TPopUpButtons.SetShowTerm(Value:Integer);
begin
  FShowTerm:=Value;
end;
procedure TPopUpButtons.SetResetTimeIfMouseOver(Value:Boolean);
begin
  FResetTimeIfMouseOver:=Value;
end;

//親
function TPopUpButtons.GetParent:TWinControl;
begin
  Result:=Form.Parent;
end;
procedure TPopUpButtons.SetParent(Value:TWinControl);
begin
  Form.Parent:=Value;
end;

//ポップアップ
procedure TPopUpButtons.PopUp(Pos:TPoint;IgnorePos:Boolean=False);
var
  Top,Left:Integer;
begin

  if not assigned(MasterWindowProc) then
    if Assigned(Parent) then begin
      MasterWindowProc:=Parent.WindowProc;
      Parent.WindowProc:=SubWindowProc;
    end else begin
      MasterWindowProc:=nil;
    end;

  if ShowTerm>0 then begin
    Timer.Enabled:=True;
    TimerCount:=0;
  end;

  if not IgnorePos then begin
    Top:=Pos.Y+25;
    if Top+Form.Height>Screen.Height then Top:=Pos.Y-Form.Height-15;

    Left:=Pos.X;
    if Left<0 then Left:=0;
    if Left+Form.Width>Screen.Width then Left:=Pos.X-Form.Width;

    Form.Top:=Top;
    Form.Left:=Left;
  end;

  Form.SetRgn;
  Form.ShowInactive;
end;


//隠す（＋親のメッセージ処理を元に戻す）
procedure TPopUpButtons.Hide;
begin
  Timer.Enabled:=False;
  Form.Hide;
  if Assigned(MasterWindowProc) then
    Parent.WindowProc:=MasterWindowProc;
  MasterWindowProc:=nil;
end;


//親ウィンドウのメッセージ処理ルーチンのサブクラス
//クリック、キーなどのメッセージでボタンを隠す
procedure TPopUpButtons.SubWindowProc(var Message: TMessage);
begin
  MasterWindowProc(Message);
//  if (Message.Msg<>WM_SETCURSOR) and (Message.Msg<>WM_MOUSEMOVE) and (Message.Msg<>WM_NCHITTEST) and (Message.Msg<>$b03f) then log(inttohex(Message.Msg,8));//チェック用
  if ((Message.Msg>=WM_MOUSEFIRST) and (Message.Msg<=WM_MOUSELAST) and (Message.Msg<>WM_MOUSEMOVE)) or
     (Message.Msg=WM_NCLBUTTONDOWN) or ((Message.Msg=WM_MOUSEACTIVATE) and not(Form.MouseOn)) or
     (Message.Msg=WM_ACTIVATEAPP) or (Message.Msg=$B006) or (Message.Msg=$B001) then begin
    Hide;
    if Assigned(FOnCancel) then FOnCancel(Self);
  end;
  Form.MouseOn:=False;
end;


//ボタンクリックで、ボタンの番号を取得して隠す
procedure TPopUpButtons.ButtonClick(Sender: TObject);
begin
  FIndex:=ButtonList.IndexOf(Sender);
  Hide;
  if assigned(FOnClick) then FOnClick(Self);
end;



//ボタンの作成(キャプションリストによる)
procedure TPopUpButtons.MakeButton(Captions: array of string);
var
  i:integer;
  Button:TSpeedButton;
begin

  for i:=0 to ButtonList.Count-1 do
    TSpeedButton(ButtonList[0]).Free;

  ButtonList.Clear;

  for i:=Low(Captions) to High(Captions) do begin
    Button:=TSpeedButton.Create(Form);
    Button.OnClick:=ButtonClick;
    Button.Caption:=Captions[i];
    Button.Width:=ButtonWidth;
    Button.Height:=ButtonHeight;
    Button.Parent:=Form;
    ButtonList.Add(Button);
  end;
  AlignButton;
end;

//ボタンの作成(イメージリストによる)

procedure TPopUpButtons.MakeButton(ImageList: TImageList);
var
  Dummy:array of string;
  Bmp:TBitmap;
  i:Integer;
begin
  SetLength(Dummy,ImageList.Count);
  MakeButton(Dummy);
  for i:=0 to ImageList.Count-1 do begin
      Bmp:=TBitmap.Create;
      ImageList.GetBitmap(i,Bmp);
      TSpeedButton(ButtonList[i]).Glyph:=Bmp;
      Bmp.Free;
    end;
end;


//ボタンの配列
procedure TPopUpButtons.AlignButton;
var
  i:Integer;
begin
  for i:=0 to ButtonList.Count-1 do
    with TSpeedButton(ButtonList[i]) do begin
      Top:=(i div Column)*ButtonHeight;
      Left:=(i mod Column)*ButtonWidth;
    end;
  Form.SetRgn;
end;

//時間が来たら隠す
procedure TPopUpButtons.TimerOnTime(Sender:TObject);
begin

  if ResetTimeIfMouseOver and (ChildWindowFromPoint(Form.Handle,Form.ScreenToClient(Mouse.CursorPos))<>0) then begin
    TimerCount:=0;
  end else begin
    Inc(TimerCount,TimerInterval);
    if  TimerCount>ShowTerm then begin
      Hide;
      if Assigned(FOnCancel) then FOnCancel(Self);
    end;
  end;
end;

end.
