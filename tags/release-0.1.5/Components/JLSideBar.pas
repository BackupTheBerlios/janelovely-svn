unit JLSideBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics;

type
  TJLSideBar = class(TCustomControl)
  private
    procedure CmMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CmMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    savedColor: TColor;

    FChecked: Boolean;
    FFocusColor: TColor;
    FTriangleColor: TColor;
    procedure SetChecked(AChecked: Boolean);
    procedure PaintTriangle(DC: HDC);
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintWindow(DC: HDC); override;
  published
    property Checked: Boolean read FChecked write SetChecked default false;
    property FocusColor: TColor read FFocusColor write FFocusColor
                                                              default clYellow;
    property TriangleColor: TColor read FTriangleColor write FTriangleColor
                                                                default clGray;

    property Align;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property Caption;
    property Color;
    property OnClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JaneLovely', [TJLSideBar]);
end;

{ TJLSideBar }

constructor TJLSideBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption] - [csDoubleClicks];

  savedColor := self.Color;
  FChecked := false;
  FFocusColor := clYellow;
  FTriangleColor := clGray;
end;

procedure TJLSideBar.PaintWindow(DC: HDC);
begin
  inherited PaintWindow(DC);

  PaintTriangle(DC);
end;

procedure TJLSideBar.PaintTriangle(DC: HDC);
var
  P: array[0..2] of TPoint;
  Center: Integer;
begin
  Center := ClientHeight div 2;

  if FChecked then
  begin
    P[0] := Point(0, Center);
    P[1] := Point(3, Center - 3);
    P[2] := Point(3, Center + 3);
  end else
  begin
    P[0] := Point(3, Center);
    P[1] := Point(0, Center - 3);
    P[2] := Point(0, Center + 3);
  end;

  Canvas.Pen.Color := FTriangleColor;
  Canvas.Brush.Color := FTriangleColor;
  Canvas.Polygon(P);
end;

procedure TJLSideBar.SetChecked(AChecked: Boolean);
begin
  FChecked := AChecked;
  Invalidate;
end;

procedure TJLSideBar.CmMouseEnter(var Message: TMessage);
begin
  savedColor := Self.Color;
  Self.Color := FFocusColor;
end;

procedure TJLSideBar.CmMouseLeave(var Message: TMessage);
begin
  Self.Color := savedColor;
end;

end.
