unit ClipBrdSub;
(* �N���b�v�{�[�h�֘A *)
(* ��aiai/zdSWk *)

(*
  CopyToClipboard: �N���b�v�{�[�h�Ƀt�@�C�������Z�b�g���ăG�N�X�v���[����
                   �\��t�����\�ɂ���


    flist: �N���b�v�{�[�h�ɃZ�b�g����t�@�C�����B������#0���Z�b�g���A������
           �t�@�C�������Z�b�g����ꍇ�̓t�@�C������#0�ŋ�؂�

           ��)'C:\PATH\TO\FILENAME' + #0 + 'C:\ANOTHER\PATH\TO\FILENAME' + #0


    Flag:  �t�@�C�����R�s�[�E�؂���̂�������\�ɂ��邩
           �R�s�[:       DROPEFFECT_COPY   = 1
           �؂���:     DROPEFFECT_MOVE   = 2
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

  //�p�����[�^���`�F�b�N
  len := Length(flist);
  if not len > 0 then
    exit;
  effect := Flag and DROPEFFECT_MASK;
  if effect = 0 then
    exit;

  //DROPFILES���R�[�h�ɒl���Z�b�g����
  df.pFiles := SizeOf(TDROPFILES);
  df.pt.X := 0;
  df.pt.Y := 0;
  df.fNC := false;
  df.fWide := false;
  

  //CF_HDROP �t�@�C����
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


  //CF_DROPEFFECT �R�s�[or�؂���
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


  //�N���b�v�{�[�h�ɃZ�b�g
  Clipboard.Open;
  Clipboard.Clear;
  Clipboard.SetAsHandle(CF_HDROP, hDrop);
  Clipboard.SetAsHandle(CF_DROPEFFECT, hEffect);
  Clipboard.Close;

  result := True;
end;

end.
