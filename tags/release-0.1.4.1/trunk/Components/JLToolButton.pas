unit JLToolButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, Graphics;

type
  TJLToolButton = class(TToolButton)
  protected
    FPictureIndex: Integer;
    FPictureColor: TColor;
    //FMouseDowned: Boolean;
    //FSavedMouseDowned: Boolean;
    //FMouseEntered: Boolean;
    procedure WmPaint(var Message: TMessage); message WM_PAINT;
    //procedure MouseDown(Button: TMouseButton;
    //  Shift: TShiftState; X, Y: Integer); override;
    //procedure MouseUp(Button: TMouseButton;
    //  Shift: TShiftState; X, Y: Integer); override;
    //procedure WmMouseEnter(var Message: TWmMouse); message CM_MOUSEENTER;
    //procedure WmMouseLeave(var Message: TWmMouse); message CM_MOUSELEAVE;
    procedure SetPictureIndex(APictureIndex: Integer);
    procedure SetPictureColor(APictureColor: TColor);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property PictureIndex: Integer
        read FPictureIndex write SetPictureIndex default 0;
    property PictureColor: TColor
        read FPictureColor write SetPictureColor default clCaptionText;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JaneLovely', [TJLToolButton]);
end;

constructor TJLToolButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPictureIndex := 0;
  FPictureColor := clCaptionText;
//  FMouseDowned := False;
//  FMouseEntered := False;
end;

//procedure TJLToolButton.MouseDown(Button: TMouseButton;
//  Shift: TShiftState; X, Y: Integer);
//begin
//  FMouseDowned := True;
//
//  inherited;
//end;
//
//procedure TJLToolButton.MouseUp(Button: TMouseButton;
//  Shift: TShiftState; X, Y: Integer);
//begin
//  FMouseDowned := False;
//
//  inherited;
//end;
//
//procedure TJLToolButton.WmMouseEnter(var Message: TWmMouse);
//begin
//  inherited;
//end;
//
//procedure TJLToolButton.WmMouseLeave(var Message: TWmMouse);
//begin
//  inherited;
//end;

procedure TJLToolButton.SetPictureIndex(APictureIndex: Integer);
begin
  FPictureIndex := APictureIndex;
  Invalidate;
end;

procedure TJLToolButton.SetPictureColor(APictureColor: TColor);
begin
  FPictureColor := APictureColor;
  Invalidate;
end;

procedure TJLToolButton.WmPaint;
var
  Point: array[0..2] of TPoint;
  offset: Integer;
begin
  inherited;

  //if FMouseDowned then
  //  offset := 1
  //else
  //  offset := 0;
  offset := 0;

  With Canvas do
  begin
    Pen.Color := FPictureColor;
    Brush.Color := FPictureColor;

    Case FPictureIndex of
    0:begin
        Point[0].X := 4 + offset;
        Point[1].X := 12 + offset;
        Point[2].X := 8 + offset;
        Point[0].Y := 6 + offset;
        Point[1].Y := 6 + offset;
        Point[2].Y := 10 + offset;
        Polygon(Point);
      end;
    1:begin
        MoveTo(5 + offset, 10 + offset);
        LineTo(12 + offset, 10 + offset);
        MoveTo(6 + offset, 4 + offset);
        LineTo(11 + offset, 4 + offset);
        MoveTo(6 + offset, 4 + offset);
        LineTo(6 + offset, 10 + offset);
        MoveTo(10 + offset, 4 + offset);
        LineTo(10 + offset, 10 + offset);
        MoveTo(9 + offset, 4 + offset);
        LineTo(9 + offset, 10 + offset);
        MoveTo(8 + offset, 10 + offset);
        LineTo(8 + offset, 14 + offset);
      end;
    2:begin
        MoveTo(6 + offset, 4 + offset);
        LineTo(6 + offset, 11 + offset);
        MoveTo(2 + offset, 7 + offset);
        LineTo(6 + offset, 7 + offset);
        MoveTo(7 + offset, 5 + offset);
        LineTo(12 + offset, 5 + offset);
        MoveTo(7 + offset, 8 + offset);
        LineTo(12 + offset, 8 + offset);
        MoveTo(7 + offset, 9 + offset);
        LineTo(12 + offset, 9 + offset);
        MoveTo(12 + offset, 5 + offset);
        LineTo(12 + offset, 10 + offset);
      end;
    3:begin
        Pen.Width := 1;
        MoveTo(4 + offset, 4 + offset);
        LineTo(13 + offset, 13 + offset);
        MoveTo(5 + offset, 4 + offset);
        LineTo(14 + offset, 13 + offset);
        MoveTo(4 + offset, 12 + offset);
        LineTo(13 + offset, 3 + offset);
        MoveTo(5 + offset, 12 + offset);
        LineTo(14 + offset, 3 + offset);
      end;
    end; //Case
  end; //With
end;

end.
