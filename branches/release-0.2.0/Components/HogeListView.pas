unit HogeListView;
(* version 0.0.1  *)
(* Copyright (c) 2001,2002 Twiddle <hetareprog@hotmail.com>  *)

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls;

type
  TDropFilesEvent = procedure (Sender: TObject; FileList: TStringList)
       of Object;  //aiai Drag and Drop

  THogeListView = class(TListView)
  private
    { Private éŒ¾ }
  protected
    { Protected éŒ¾ }
    FObjList: TList;
    FHogeOnData: TLVOwnerDataEvent;
    FDropFiles: TDropFilesEvent;  //aiai Drag and Drop
    procedure SetList(AList: TList);
    procedure SetHogeOnData(Handler: TLVOwnerDataEvent);
    procedure HogeOnData(Sender: TObject; Item: TListItem);
    procedure CreateParams(var Params: TCreateParams); override;  //aiai Drag and Drop
    procedure WmDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;  //aiai Drag and Drop
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Sort(Compare: TListSortCompare);
    procedure SelectIntoView(Item: TListItem);
    procedure SetTopItem(Item: TListItem);
    property List: TList read FObjList write SetList;
  published
    { Published éŒ¾ }
    property OnData: TLVOwnerDataEvent read FHogeOnData write SetHogeOnData;
    property OnDropFiles: TDropFilesEvent read FDropFiles write FDropFiles;
  end;

procedure Register;

implementation


uses ShellAPI;  //aiai Drag and Drop

type
  TD56TSubItemsCorrector = class (TStringList)
  public
    Dummy: Pointer;
    ToClear: TList;
  end;

procedure Register;
begin
  RegisterComponents('Samples', [THogeListView]);
end;

constructor THogeListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjList := TList.Create;
  OwnerData := False;
end;

destructor THogeListView.Destroy;
begin
  if FObjList <> nil then
    FObjList.Free;
  inherited;
end;

procedure THogeListView.SetList(AList: TList);
begin
  Items.Count := 0;
  if (AList <> nil) and (0 < AList.Count) then
  begin
    FObjList.Assign(AList);
    OwnerData := True;
    TabStop := True;
    Items.Count := FObjList.Count;
  end
  else begin
    OwnerData := False;
    FObjList.Clear;
  end;
end;

procedure THogeListView.Sort(Compare: TListSortCompare);
begin
  FObjList.Sort(Compare);
  Repaint;
end;

procedure THogeListView.SelectIntoView(Item: TListItem);
var
  itemHeight: integer;
  Y: integer;
begin
  Y := Item.Position.Y;
  Selected := item;
  item.Focused := true;
  if Items.Count <= 1 then
    exit;
  itemHeight := (Items[Items.Count -1].Position.Y - Items[0].Position.Y) div Items.Count;
  Scroll(0, Y - TopItem.Position.Y - itemHeight * VisibleRowCount div 2);
end;

procedure THogeListView.SetTopItem(Item: TListItem);
var
  Y: integer;
begin
  Y := Item.Position.Y;
  if Items.Count <= 1 then
    exit;
  Scroll(0, Y - TopItem.Position.Y);
end;

procedure THogeListView.SetHogeOnData(Handler: TLVOwnerDataEvent);
begin
  FHogeOnData := Handler;
  if Assigned(FHogeOnData) then
    inherited OnData := HogeOnData
  else
    inherited OnData := nil;
end;


procedure THogeListView.HogeOnData(Sender: TObject; Item: TListItem);
begin
  TD56TSubItemsCorrector(Item.SubItems).ToClear.Clear;
  if Assigned(FHogeOnData) then
    FHogeOnData(Sender, Item);
end;





//aiai Drag and Drop
procedure THogeListView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_ACCEPTFILES;
end;

//aiai Drag and Drop
procedure THogeListView.WmDropFiles(var Msg: TWMDropFiles);
var
  fcount, i: Integer;
  flist: TStringList;
  fname: array[0..255] of Char;
begin
  inherited;

  if Assigned(FDropFiles) then
  begin
    flist := TStringList.Create;

    fcount := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
    for i := 0 to fcount - 1 do
    begin
      DragQueryFile(Msg.Drop, i, fname, SizeOf(fname) - 1);
      flist.Add(fname);
    end;

    FDropFiles(Self, flist);

    flist.Free;
  end;

  DragFinish(Msg.Drop);
end;

end.
