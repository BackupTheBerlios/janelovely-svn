unit UTTSearch;
(* �X���b�h�^�C�g�������p���j�b�g *)
(* �������ʂ�html�����H���ĕԂ� *)

interface

function TTSearchOnFind(source: String): String;

implementation

uses Classes, SysUtils, StrSub;

function TTSearchOnFind(source: String): String;
var
  findhtml, host, brdname, jpbrdname: String;
  strfind: TStringList;
  i, startpos, endpos: integer;
begin
  findhtml := '���̋@�\��<a href="http://ttsearch.net/">�X���b�h�^�C�g������</a>�𗘗p�����Ă��������Ă��܂��B<br><br>';

  strfind := TStringList.Create;
  strfind.Text := source;

  for i := 10 to strfind.Count - 1 do
  begin

    if AnsiPos(' �̌�������: ', strfind[i]) > 0 then begin
      startpos := 2;
      endpos := FindPos('�� [�T�[�o����]', strfind[i], 0);
      findhtml := findhtml + Copy(strfind[i], startpos, endpos) + '<br><br>';
    end

    else if AnsiPos('" /><a href="', strfind[i]) > 0 then begin

      (* �� *)
      startpos := FindPos('target="_self">', strfind[i], 0) + 15;
      endpos := FindPos('</a>', strfind[i], startpos);
      jpbrdname := Copy(strfind[i], startpos, endpos - startpos);

      (* �T�[�o�� *)
      startpos := FindPos('value="', strfind[i], startpos) + 7;
      endpos := FindPos(':', strfind[i], startpos);
      host := Copy(strfind[i], startpos, endpos - startpos);

      (* �� *)
      startpos := endpos + 1;
      endpos := FindPos(':', strfind[i], startpos);
      brdname := Copy(strfind[i], startpos, endpos - startpos);

      findhtml := findhtml + '<a href="http://' + host + '/' + brdname + '/">' + jpbrdname + '</a>�@';

      (* �X���b�h *)
      startpos := FindPos('" /><a href="http://', strfind[i], startpos) + 4;
      endpos := FindPos('</a></td><td>', strfind[i], startpos) + 4;
      findhtml := findhtml + Copy(strfind[i], startpos, endpos - startpos) + '<br>';

    end;

    if i >= 1000 then begin
      findhtml := findhtml + '<br>�ʂ���������̂ŁA���~���܂����B<br>';
      break;
    end;
  end;

  FreeAndNil(strfind);
  result := findhtml;
end;


end.
