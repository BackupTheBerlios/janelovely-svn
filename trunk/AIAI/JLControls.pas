unit JLControls;

interface

uses Windows, Messages, Classes;



type


  TCreateWinParams = packed record
    dwExStyle: DWORD;
    lpClassName: PChar;
    lpWindowName: PChar;
    dwStyle: DWORD;
    X: Integer;
    Y: Integer;
    nWidth: Integer;
    nHeight: Integer;
    hWndParent: HWND;
    hMenu: HMENU;
    hInstance: HINST;
    lpParam: Pointer;
  end;


  TJLWinControl = class(TObject)
  private

    FHandle: HWND;
    FParent: HWND;
    FWndProc: Pointer;
    FOriginalProc: Pointer;
    procedure ParentWndProc(var Msg: TMessage);

  protected

    procedure CreateHandle; virtual; abstract;
    procedure CreateWnd; virtual; abstract;
    procedure CreateParams(var Params: TCreateWinParams); virtual; abstract;
    procedure CreateWindowHandle(const Params: TCreateWinParams); virtual; abstract;

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

  CreateHandle;

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
  if Msg.Msg = WM_DESTROY then
    Free
  else
    Dispatch(Msg);

  Msg.Result := CallWindowProc(FOriginalProc, FParent,
                    Msg.Msg, Msg.WParam, Msg.LParam);
end;















end.
