unit ClipBrdSub;
(* クリップボード関連 *)
(* ◆aiai/zdSWk *)

(*
  CopyToClipboard: クリップボードにファイル名をセットしてエクスプローラで
                   貼り付けを可能にする


    flist: クリップボードにセットするファイル名。末尾に#0をセットし、複数の
           ファイル名をセットする場合はファイル名を#0で区切る

           例)'C:\PATH\TO\FILENAME' + #0 + 'C:\ANOTHER\PATH\TO\FILENAME' + #0


    Flag:  ファイルをコピー・切り取りのいずれを可能にするか
           コピー:       DROPEFFECT_COPY   = 1
           切り取り:     DROPEFFECT_MOVE   = 2
*)

interface

uses
  Windows, ClipBrd, ShlObj;

const
  DROPEFFECT_COPY   = 1;
  DROPEFFECT_MOVE   = 2;

  DROPEFFECT_MASK   = 3;

function CopyToClipboard(flist: String;
    Flag: DWORD = DROPEFFECT_COPY): Boolean;

implementation

(* ========================================================================= *)

var
  CF_DROPEFFECT: UINT;

function CopyToClipboard(flist: String;
    Flag: DWORD = DROPEFFECT_COPY): Boolean;
var
  hDrop, hEffect: HGLOBAL;
  pDrop: Pointer;
  pEffect: ^DWORD;
  df: TDROPFILES;
  len: Integer;
  effect: DWORD;
begin
  result := False;

  //パラメータをチェック
  len := Length(flist);
  if not len > 0 then
    exit;
  effect := Flag and DROPEFFECT_MASK;
  if effect = 0 then
    exit;

  //DROPFILESレコードに値をセットする
  df.pFiles := SizeOf(TDROPFILES);
  df.pt.X := 0;
  df.pt.Y := 0;
  df.fNC := false;
  df.fWide := false;
  

  //CF_HDROP ファイル名
  hDrop := GlobalAlloc(GHND, SizeOf(TDROPFILES) + len + 1);
  if hDrop = 0 then
    exit;

  pDrop := GlobalLock(hDrop);
   if pDrop = nil then
   begin
     GlobalFree(hDrop);
     exit;
   end;
   Move(df, pDrop^, SizeOf(TDropFiles));
   Inc(PByte(pDrop), SizeOf(TDROPFILES));
   Move(PChar(flist)^, pDrop^, len + 1);
  GlobalUnlock(hDrop);


  //CF_DROPEFFECT コピーor切り取り
  CF_DROPEFFECT :=
      RegisterClipboardFormat(PChar(CFSTR_PREFERREDDROPEFFECT));

  hEffect := GlobalAlloc(GHND, SizeOf(DWORD));
  if hEffect = 0 then
  begin
    GlobalFree(hDrop);
    exit;
  end;

  pEffect := GlobalLock(hEffect);
   if pEffect = nil then
   begin
     GlobalFree(hDrop);
     GlobalFree(hEffect);
     exit;
   end;
   pEffect^ := effect;
  GlobalUnlock(hEffect);


  //クリップボードにセット
  Clipboard.Open;
  Clipboard.Clear;
  Clipboard.SetAsHandle(CF_HDROP, hDrop);
  Clipboard.SetAsHandle(CF_DROPEFFECT, hEffect);
  Clipboard.Close;

  result := True;
end;

end.
