unit UPtrStream;
(* Copyright (c) 2002 Twiddle <hetareprog@hotmail.com> *)

interface

uses
  Classes;

type
  TPointerStream = class (TCustomMemoryStream)
  public
    constructor Create(Ptr: Pointer; Size: Longint);
    procedure SetPointer(Ptr: Pointer; Size: Longint);
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

implementation

constructor TPointerStream.Create(Ptr: Pointer; Size: Longint);
begin
  inherited Create;
  SetPointer(Ptr, Size);
end;

procedure TPointerStream.SetPointer(Ptr: Pointer; Size: Longint);
begin
  inherited SetPointer(Ptr, Size);
end;

function TPointerStream.Write(const Buffer; Count: Longint): Longint;
begin
  if Size <= Position + Count then
    result := Size - Position
  else
    result := Count;
  Move(Buffer, (PChar(Memory) + Position)^, result);
  Position := result;
end;

end.
