Unit U2chCat;
(* ２ちゃんねる　カテゴリ(分類内のボード一覧を内包) *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com> *)

interface

uses
  Classes,
  U2chBoard, FileSub;

type

  (*-------------------------------------------------------*)
  (* 分類 *)
  TCategory = class(TList)
  private
    function GetItems(index: integer): TBoard;
    procedure SetItems(index: integer; board: TBoard);
  public
    categoryList: TObject;
    name: string;
    expanded: boolean;
    custom: boolean;
    constructor Create(categoryList: TObject);
    destructor Destroy; override;
    procedure Clear; override;
    procedure SafeClear;
    property Items[index: integer]: TBoard read GetItems write SetItems;
    function GetLogDir: string;
  end;



(*=======================================================*)
implementation
(*=======================================================*)

uses
  U2chCatList;

(*=======================================================*)
(*  *)
constructor TCategory.Create(categoryList: TObject);
begin
  inherited Create;
  self.categoryList := categoryList;
  expanded := False;
  custom := False;
end;

(*  *)
destructor TCategory.Destroy ;
begin
  Clear;
  inherited;
end;


(*  *)
function TCategory.GetLogDir: string;
begin
  result := TCategoryList(categoryList).GetLogDir + '\' + Convert2FName(name);
end;

(*  *)
function TCategory.GetItems(index:integer): TBoard;
begin
  result := inherited Items[index];
end;

(*  *)
procedure TCategory.SetItems(index: integer; board: TBoard);
begin
  inherited Items[index] := board;
end;

(*  *)
procedure TCategory.Clear;
var
  i: integer;
begin
  for i := 0 to Count -1 do
  begin
    if Items[i] <> nil then
      Items[i].Free;
  end;
  inherited;
end;

(*  *)
procedure TCategory.SafeClear;
var
  i: integer;
begin
  if custom then
    exit;
  for i := 0 to Count -1 do
  begin
    if Items[i] <> nil then
    begin
      if not Items[i].Refered then
      begin
        Items[i].Free;
        Items[i] := nil;
      end;
    end;
  end;
  Pack;
end;

end.
