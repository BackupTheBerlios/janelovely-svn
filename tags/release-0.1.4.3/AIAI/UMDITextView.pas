unit UMDITextView;
(* Multi Document Style Window *)
(* ◆aiai/zdSWk *)

interface

uses
  Windows, Messages, Classes, Controls, ExtCtrls, HogeTextView;



type
  //ウィンドウの状態
  {// MTV_MIN・・・最小化}
  // MTV_NOR・・・いわゆるウィンドウ、タイトルバーやシステムメニュー、最大化・最小化ボタンを持つ
  // MTV_MAX・・・親ウィンドウのクライント領域いっぱいに配置される
  TMTVState = ({MTV_MIN,} MTV_NOR, MTV_MAX);


  TMDITextView = class(THogeTextView)  // MDI子ウィンドウになるTHogeTextview
  private
    FNorRect: TRect;
    FMTVState: TMTVState;
    FCloseWindow: TNotifyEvent;
    FMaximizeWindow: TNotifyEvent;
    FDbClickTBar: TNotifyEvent;
    FActive: TNotifyEvent;
    //FHide: TNotifyEvent;
    procedure DoCloseWindow;
    procedure DoMaximizeWindow;
    procedure DoDbClickTBar;
    procedure DoActive;
    //procedure DoHide;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure SetWndState(AState: TMTVState);
    //function GetWndState: TMTVState;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property WndState: TMTVState read FMTVState write SetWndState;
    property NorRect: TRect read FNorRect write FNorRect;
    property OnCloseWindow: TNotifyEvent read FCloseWindow write FCloseWindow;
    property OnMaximizeWindow: TNotifyEvent read FMaximizeWindow write FMaximizeWindow;
    property OnDbClickTBar: TNotifyEvent read FDbClickTBar write FDbClickTBar;
    property OnActive: TNotifyEvent read FActive write FActive;
    //property OnHide: TNotifyEvent read FHide write FHide;
  end;





implementation

const
  WS_MDIDEFAULTWINDOW = (WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or
    WS_THICKFRAME {or WS_MINIMIZEBOX} or WS_MAXIMIZEBOX);





 { TMDITextView }

constructor TMDITextView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FNorRect := Bounds(10, 10, 300, 300);
  FMTVState := MTV_MAX;
end;

destructor TMDITextView.Destroy;
begin
  inherited Destroy;
end;

procedure TMDITextView.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_SYSCOMMAND then begin
    Case Message.WParam of

      SC_CLOSE: begin
        DoCloseWindow;
        exit;
      end;

      SC_MAXIMIZE: begin
        DoMaximizeWindow;
        exit;
      end;

      SC_MAXIMIZE + 2: begin
        DoDbClickTBar;
        exit;
      end;

      //SC_MINIMIZE: begin
      //  Hide;
      //  DoHide;
      //  exit;
      //end;

      //SC_RESTORE, SC_RESTORE + 2: begin
      //  WndState := MTV_NOR;
      //  exit;
      //end;

    end; //Case
  end;
  inherited WndProc(Message);
end;

procedure TMDITextView.CMEnter(var Message: TCMEnter);
begin
  inherited;
  Perform(WM_NCACTIVATE, 1, 0);
  DoActive;
  BringToFront;
end;

procedure TMDITextView.CMExit(var Message: TCMExit);
begin
  inherited;
  Perform(WM_NCACTIVATE, 0, 0);
end;


procedure TMDITextView.SetWndState(AState: TMTVState);
var
  WS: Longint;
begin
  if FMTVState = AState then
    exit;

  //Show;

  {if AState = MTV_MIN then begin
    FMTVState := AState;
    WS := GetWindowLong(Handle, GWL_STYLE);
    WS := WS or WS_MINIMIZE;
    SetWindowLong(Handle, GWL_STYLE, WS);
    SetWindowPos(Handle, 0, 0, 0, 0, 0, 0
                     or SWP_FRAMECHANGED
                     or SWP_NOACTIVATE
                     or SWP_NOMOVE
                     or SWP_NOOWNERZORDER
                     or SWP_NOSIZE
                     or SWP_NOZORDER);

  end else} if AState = MTV_NOR then begin

    FMTVState := AState;
    WS := GetWindowLong(Handle, GWL_STYLE);
    WS := WS or WS_MDIDEFAULTWINDOW;
    SetWindowLong(Handle, GWL_STYLE, WS);
    Align := alNone;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, 0
      or SWP_FRAMECHANGED
      or SWP_NOACTIVATE
      or SWP_NOMOVE
      or SWP_NOOWNERZORDER
      or SWP_NOSIZE
      or SWP_NOZORDER);
    BoundsRect := FNorRect;

  end else if AState = MTV_MAX then begin

    FMTVState := AState;
    FNorRect := BoundsRect;
    WS := GetWindowLong(Handle, GWL_STYLE);
    WS := WS and not WS_MDIDEFAULTWINDOW;
    SetWindowLong(Handle, GWL_STYLE, WS);
    Align := alClient;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, 0
                     or SWP_FRAMECHANGED
                     or SWP_NOACTIVATE
                     or SWP_NOMOVE
                     or SWP_NOOWNERZORDER
                     or SWP_NOSIZE
                     or SWP_NOZORDER);

  end;
end;




procedure TMDITextView.DoCloseWindow;
begin
  if Assigned(FCloseWindow) then
    FCloseWindow(Self);
end;

procedure TMDITextView.DoMaximizeWindow;
begin
  if Assigned(FMaximizeWindow) then
    FMaximizeWindow(Self);
end;

procedure TMDITextView.DoDbClickTBar;
begin
  if Assigned(FDbClickTBar) then
    FDbClickTBar(Self);
end;

procedure TMDITextView.DoActive;
begin
  if Assigned(FActive) then
    FActive(self);
end;

//procedure TMDITextView.DoHide;
//begin
//  if Assigned(FHide) then
//    FHide(self);
//end;

end.
