unit UCardinalList;

interface

uses
  Classes;

type

  TCardinalList = class(TObject)
  protected
    FList:TList;
    function GetItems(Index: Integer): Cardinal;
    procedure SetItems(Index: Integer; const Value: Cardinal);
    function GetCount: Integer;
    procedure SetCount(const Value: Integer);
    function GetCapacity: Integer;
    procedure SetCapacity(const Value: Integer);
  public
    constructor Create;
    destructor Destroy;override;
    function Add(Item:Cardinal):Integer;
    property Items[Index:Integer]:Cardinal read GetItems write SetItems;default;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function IndexOf(Item: Cardinal): Integer;
    procedure Insert(Index: Integer; Item: Cardinal);
    procedure Move(CurIndex, NewIndex: Integer);
    property Count: Integer read GetCount write SetCount;
    property Capacity: Integer read GetCapacity write SetCapacity;
  end;

implementation

{ TCardinalList }

constructor TCardinalList.Create;
begin
  FList:=TList.Create;
end;
destructor TCardinalList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;
function TCardinalList.Add(Item: Cardinal): Integer;
begin
  Result:=FList.Add(Pointer(Item));
end;
procedure TCardinalList.Clear;
begin
  FList.Clear;
end;
procedure TCardinalList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;
procedure TCardinalList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;
function TCardinalList.GetCount: Integer;
begin
  Result:=FList.Count;
end;
function TCardinalList.GetCapacity: Integer;
begin
  Result:=FList.Capacity;
end;
function TCardinalList.IndexOf(Item: Cardinal): Integer;
begin
  Result:=FList.IndexOf(Pointer(Item));
end;
procedure TCardinalList.Insert(Index: Integer; Item: Cardinal);
begin
  FList.Insert(Index,Pointer(Item));
end;
procedure TCardinalList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;
procedure TCardinalList.SetCount(const Value: Integer);
begin
  FList.Count:=Value;
end;
procedure TCardinalList.SetCapacity(const Value: Integer);
begin
  FList.Capacity:=Value;
end;
function TCardinalList.GetItems(Index: Integer): Cardinal;
begin
  Result:=Cardinal(FList[Index]);
end;
procedure TCardinalList.SetItems(Index: Integer; const Value: Cardinal);
begin
  FList[Index]:=pointer(Value);
end;

end.
