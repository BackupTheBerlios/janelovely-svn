unit UXPHintWindow;

interface

uses
  Windows, Messages, Classes, Controls, JLUxtheme;

type
  TXPHintWindow = class(THintWindow)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
//    procedure WMNCPaint(var Msg: TMessage); message WM_NCPAINT;
  end;

implementation


 { TXPHintWindow }

procedure TXPHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if IsWindowsXP then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

//procedure TXPHintWindow.WMNCPaint(var Msg: TMessage);
//var
//  R : TRect;
//  DC: HDC;
//begin
//  DC := GetWindowDC(Handle);
//  try
//    R := Rect(0, 0, Width, Height);
//    DrawEdge(DC, R, EDGE_ETCHED, BF_RECT or BF_MONO);
//  finally
//    ReleaseDC(Handle, DC);
//  end;
//end;

end.
