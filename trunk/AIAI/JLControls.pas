unit JLControls;

interface

uses Windows, Messages, Classes;

type
  TJLWinControl = class(TObject)
  private
    FHandle: HWND;
    FParent: HWND;
    FWndProc: Pointer;
    FOriginalProc: Pointer;
    procedure ParentWndProc(var Msg: TMessage);
  protected
    procedure CreateWnd; virtual; abstract;
  public
    constructor Create(AParent: HWND);
    destructor Destroy; override;
    property Handle: HWND read FHandle write FHandle;
    property Parent: HWND read FParent write FParent;
  end;

implementation


 { TJLWinControl }

constructor TJLWinControl.Create(AParent: HWND);
begin
  FParent := AParent;

  CreateWnd;

  FWndProc := MakeObjectInstance(ParentWndProc);
  FOriginalProc := Pointer(GetWindowLong(FParent, GWL_WNDPROC));
  SetWindowLong(FParent, GWL_WNDPROC, Integer(FWndProc));
end;

destructor TJLWinControl.Destroy;
begin
  SetWindowLong(FParent, GWL_WNDPROC, Integer(FOriginalProc));

  //FreeObjectInstance(FWndProc);
  DestroyWindow(FHandle);
  inherited Destroy;
end;

procedure TJLWinControl.ParentWndProc(var Msg: TMessage);
begin
  Msg.Result := CallWindowProc(FOriginalProc, FParent,
                    Msg.Msg, Msg.WParam, Msg.LParam);

  if Msg.Msg = WM_DESTROY then
    Free
  else
    Dispatch(Msg);
end;

end.
