unit UTTSearch;
(* スレッドタイトル検索用ユニット *)
(* 検索結果のhtmlを加工して返す *)

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
  findhtml := 'この機能は<a href="http://ttsearch.net/">スレッドタイトル検索</a>を利用させていただいています。<br><br>';

  strfind := TStringList.Create;
  strfind.Text := source;

  for i := 10 to strfind.Count - 1 do
  begin

    if AnsiPos(' の検索結果: ', strfind[i]) > 0 then begin
      startpos := 2;
      endpos := FindPos('件 [サーバ昇順]', strfind[i], 0);
      findhtml := findhtml + Copy(strfind[i], startpos, endpos) + '<br><br>';
    end

    else if AnsiPos('" /><a href="', strfind[i]) > 0 then begin

      (* 板名 *)
      startpos := FindPos('target="_self">', strfind[i], 0) + 15;
      endpos := FindPos('</a>', strfind[i], startpos);
      jpbrdname := Copy(strfind[i], startpos, endpos - startpos);

      (* サーバ名 *)
      startpos := FindPos('value="', strfind[i], startpos) + 7;
      endpos := FindPos(':', strfind[i], startpos);
      host := Copy(strfind[i], startpos, endpos - startpos);

      (* 板名 *)
      startpos := endpos + 1;
      endpos := FindPos(':', strfind[i], startpos);
      brdname := Copy(strfind[i], startpos, endpos - startpos);

      findhtml := findhtml + '<a href="http://' + host + '/' + brdname + '/">' + jpbrdname + '</a>　';

      (* スレッド *)
      startpos := FindPos('" /><a href="http://', strfind[i], startpos) + 4;
      endpos := FindPos('</a></td><td>', strfind[i], startpos) + 4;
      findhtml := findhtml + Copy(strfind[i], startpos, endpos - startpos) + '<br>';

    end;

    if i >= 1000 then begin
      findhtml := findhtml + '<br>量が多すぎるので、中止しました。<br>';
      break;
    end;
  end;

  FreeAndNil(strfind);
  result := findhtml;
end;


end.
