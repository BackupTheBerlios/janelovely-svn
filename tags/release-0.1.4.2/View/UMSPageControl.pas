unit UMSPageControl;

interface

uses
  Classes,Windows,Controls,ComCtrls;

const
  intFarFORWARD =integer($6fffffff);
  intFarBACKWARD=integer($90000000);
  intUNDEFINED  =integer($ffffffff);

type

  //直前の移動方向を示すタイプ
  TPageControlDierction=(pdUNDEFINED, pdFORWARD, pdBACKWARD);

  //前後キーなどで左右の端を越えようとしたときのイベント
  TPageControlOnEdgeEvent = procedure(Sender:TObject ;GoForward:Boolean) of object;

  //TTabSheet.Highlightedを使って複数選択を可能にするページコントロール
  //TTabSheet.Tagをいろいろ勝手に書き換えるので注意(事前にゼロを代入)
  //マウスホイール、方向キーでタブ移動
  TMSPageControl = class(TPageControl)
  protected
    FOnEdge: TPageControlOnEdgeEvent;
    FDirection:TPageControlDierction;
    PushShiftAt:Integer;
    procedure Change;override;
    function CanChange:Boolean;override;
    procedure Highlighten(Index:Integer;Value:Boolean);virtual;
    procedure FixHighlight(Index:Integer);virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;override;
    function GetBeginSelectionWithDirection:TPageControlDierction;
    procedure SetBeginSelectionWithDirection(Value:TPageControlDierction);
    function GetSelectionDirectTo:TPageControlDierction;
  public
    constructor Create(AOwner:TComponent);override;
    function HighlightCount:Integer;
    procedure GoForward;
    procedure GoBackward;
    procedure FillHighlight(Value:Boolean;FromOwnOriginTo:TPageControlDierction);
    procedure TerminateSelectionState;virtual;
    procedure DragDrop(Source: TObject; X, Y: Integer);override;
    property Direction:TPageControlDierction read FDirection;
    property BeginSelectionWithDirection:TPageControlDierction
             read GetBeginSelectionWithDirection write SetBeginSelectionWithDirection;
    property SelectionDirectTo:TPageControlDierction read GetSelectionDirectTo;
    property OnEdge:TPageControlOnEdgeEvent read FOnEdge write FOnEdge;
  end;

implementation


uses
  SysUtils,uimageviewer;


function Between(const Value,Limit1,Limit2:Integer):Boolean;
var
  L1,L2:Integer;
begin
  if Limit1<Limit2 then begin
    L1:=Limit1;
    L2:=Limit2;
  end else begin
    L1:=Limit2;
    L2:=Limit1;
  end;
  if (L1<=Value) and (Value<=L2) then Result:=True else Result:=False;
end;



{ TMSPageControl }

constructor TMSPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PushShiftAt:=intUNDEFINED;
end;


//アクティブタブ変更前に、
//シフトが押されていれば原点として登録
function TMSPageControl.CanChange: Boolean;
var
  i:Integer;
begin
  if GetKeyState(VK_SHIFT)<0 then begin
    if PushShiftAt=intUNDEFINED then
      PushShiftAt:=ActivePageIndex;
  end else begin
    PushShiftAt:=intUNDEFINED;
    for i:=0 to PageCount-1 do
      FixHighlight(i);
  end;
  Result:=inherited CanChange;
end;


//アクティブタブ変更後、シフトが押されていれば範囲選択処理
procedure TMSPageControl.Change;
var
  i:Integer;
begin
  inherited Change;
  if PushShiftAt<>intUNDEFINED then begin
    for i:=0 to PageCount-1 do
      Highlighten(i, Between(i,ActivePageIndex,PushShiftAt) or (Pages[i].Tag<>0));
  end else begin
    TerminateSelectionState;
  end;
end;


//マウス押下への応答
//ssTabsは、クリックするとCanChange→Change→MouseDownの順でイベント
//それ以外は、クリックでMouseDownイベントだけが起こる
procedure TMSPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  TabIndex:Integer;
begin
  TabIndex:=IndexOfTabAt(X, Y);
  if TabIndex>=0 then begin
    if (Style <> tsTabs) and (TabIndex <> ActivePageIndex) then begin
      //tsTabs以外でアクティブタブ以外がクリックされた場合、
      //自分でActivePageを動かさないといけない
      if CanChange then begin
        ActivePageIndex:=TabIndex;
        Change;
      end;
    end;
    if GetKeyState(VK_CONTROL)<0 then
       Highlighten(ActivePageIndex,not(ActivePage.Highlighted));
    if ssDouble in Shift then begin
      EndDrag(False);
    end else if Button=mbLeft then begin
      BeginDrag(False);
    end;
  end;
  inherited MouseDown(Button,Shift,X,Y);
end;


//ページのドラッグ移動中
procedure TMSPageControl.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
  if Source=Self then Accept:=True;
end;


//ページのドラッグ移動終了
procedure TMSPageControl.DragDrop(Source: TObject; X, Y: Integer);
var
  NewIndex:Integer;
begin
  if Source=Self then begin
    NewIndex:=IndexOfTabAt(ScreenToClient(Mouse.CursorPos).x,ScreenToClient(Mouse.CursorPos).y);
    if (NewIndex>=0) and (NewIndex<>ActivePage.PageIndex) then
      ActivePage.PageIndex:=NewIndex;
  end;
  ActivePage.Highlighted:=ActivePage.Highlighted;//見かけ上ハイライトが消える現象の対策
  inherited;
end;


//前後への移動を統括するプロシージャ×２
procedure TMSPageControl.GoForward;
begin
  FDirection:=pdFORWARD;
  if ActivePageIndex<PageCount-1 then begin
    if CanChange then begin
      ActivePageIndex:=ActivePageIndex+1;
      Change;
    end;
  end else begin
    if Assigned(FOnEdge) then FOnEdge(Self,True);
  end;
  FDirection:=pdUNDEFINED;
end;
//
procedure TMSPageControl.GoBackWard;
begin
  FDirection:=pdBACKWARD;
  if ActivePageIndex>0 then begin
    if CanChange then begin
      ActivePageIndex:=ActivePageIndex-1;
      Change;
    end;
  end else begin
    if Assigned(FOnEdge) then FOnEdge(Self,False);
  end;
  FDirection:=pdUNDEFINED;
end;


//キー打鍵への応答
procedure TMSPageControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_HOME,VK_UP :begin
      if PageCount>0 then
        if CanChange then begin
          ActivePageIndex:=0;
          Change;
        end;
      Key:=0;
    end;
    VK_END,VK_DOWN :begin
        if CanChange then begin
          ActivePageIndex:=PageCount-1;
          Change;
        end;
      Key:=0;
    end;
    VK_SPACE : begin
      if ssCtrl in Shift then GoBackWard else GoForward;
      Key:=0;
    end;
    VK_LEFT  : begin
      GoBackWard;
      Key:=0;
    end;
    VK_RIGHT : begin
      GoForward;
      Key:=0;
    end;
  else
    inherited KeyDown(Key, Shift);
  end;
end;


//ホイールへの応答１
function TMSPageControl.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  if PtInRect(Rect(0,0,Width,Height),ScreenToClient(MousePos)) then
    GoForward;
  inherited DoMouseWheelDown(Shift,MousePos);
  Result:=True;
end;


//ホイールへの応答２
function TMSPageControl.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  if PtInRect(Rect(0,0,Width,Height),ScreenToClient(MousePos)) then
    GoBackward;
  inherited DoMouseWheelUp(Shift,MousePos);
  Result:=True;
end;


//ハイライトの数を調査
function TMSPageControl.HighlightCount: Integer;
var
  i:Integer;
begin
  Result:=0;
  for i:=0 to PageCount-1 do if Pages[i].Highlighted then Inc(Result);
end;


//全てのハイライト非確定タブをハイライト／消去
procedure TMSPageControl.FillHighlight(Value:Boolean;FromOwnOriginTo:TPageControlDierction);
var
  Limit1,Limit2:Integer;
  i:Integer;
begin

  if (PushShiftAt=intUNDEFINED) and (FromOwnOriginTo<>pdUNDEFINED) then
    raise Exception.Create('範囲選択のエラー：起点が未定義');

  Limit1:=0;
  Limit2:=PageCount-1;

  if Value then begin //Value=FalseならFromOwnOriginTo=pdUNDEFINED以外ありえないけど念のためif文
    case FromOwnOriginTo of
      pdFORWARD:begin
        Limit1:=PushShiftAt;
        Limit2:=PageCount-1;
      end;
      pdBACKWARD:Begin
        Limit1:=0;
        Limit2:=PushShiftAt;
      end;
    end
  end;

  for i:=0 to PageCount-1 do
    Highlighten(i,(Value and Between(i,Limit1,Limit2)) or Boolean(Pages[i].Tag));

end;


//それまでの範囲選択を確定させて後始末
procedure TMSPageControl.TerminateSelectionState;
var
  i:Integer;
begin
  for i:=0 to PageCount-1 do
    FixHighlight(i);
  PushShiftAt:=intUNDEFINED;
end;


//指定されたページのハイライトを変更する
procedure TMSPageControl.Highlighten(Index:Integer; Value:Boolean);
begin
  Pages[Index].Highlighted:=Value;
end;


//指定されたページのハイライトを確定する
procedure TMSPageControl.FixHighlight(Index:Integer);
begin
  Pages[Index].Tag:=Integer(Pages[Index].Highlighted);
end;


//外部から範囲選択を開始(値がUNDEFINEDの時だけ新たな値に変更される)
procedure TMSPageControl.SetBeginSelectionWithDirection(Value:TPageControlDierction);
var
  i:Integer;
begin
  case Value of
    pdFORWARD : if PushShiftAt=intUNDEFINED then PushShiftAt:=intFarBACKWARD;
    pdBACKWARD: if PushShiftAt=intUNDEFINED then PushShiftAt:=intFarFORWARD;
    pdUNDEFINED:Exit;
  end;
  for i:=0 to PageCount-1 do
    Highlighten(i, Between(i,ActivePageIndex,PushShiftAt) or (Pages[i].Tag<>0));
end;


//選択開始時の状態を返す
function TMSPageControl.GetBeginSelectionWithDirection:TPageControlDierction;
begin
  if PushShiftAt=intFarBackward then
    Result:=pdFORWARD
  else if PushShiftAt=intFarBackward then
    Result:=pdBACKWARD
  else
    Result:=pdUNDEFINED;
end;


//選択が起点からどちらに向かっているかを示す関数
function TMSPageControl.GetSelectionDirectTo:TPageControlDierction;
begin
  Result:=pdUNDEFINED;

  if (ActivePageIndex<0) or (PushShiftAt=intUNDEFINED) then Exit;

  if ActivePageIndex>PushShiftAt then
    Result:=pdFORWARD
  else if ActivePageIndex<PushShiftAt then
    Result:=pdBACKWARD;

end;

end.
 