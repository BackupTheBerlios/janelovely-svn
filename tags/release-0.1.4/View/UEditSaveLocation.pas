unit UEditSaveLocation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ShellApi, FileCtrl;

type
  TSavePointDialog = class(TForm)
    ebCaption: TEdit;
    ebLocation: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnSelectLocation: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    Procedure WMDropFiles(Var Msg: TWMDropFiles);Message WM_DropFiles;
    procedure btnSelectLocationClick(Sender: TObject);
    procedure ebChange(Sender: TObject);

  private
    function GetSPCaption: String;
    function GetSPLocation: String;
    { Private 宣言 }
  public
    property SPCaption:String read GetSPCaption;
    property SPLocation:String read GetSPLocation;
    function ShowDialog(ASPCaption, ASPLocation:string):Boolean;
    { Public 宣言 }
  end;

implementation

{$R *.DFM}

procedure TSavePointDialog.FormCreate(Sender: TObject);
begin
   DragAcceptFiles(Handle,True);
end;

function TSavePointDialog.GetSPCaption: String;
begin
  Result:=ebCaption.Text;
end;

function TSavePointDialog.GetSPLocation: String;
begin
  Result:=ebLocation.Text;
end;

function TSavePointDialog.ShowDialog(ASPCaption, ASPLocation: string): Boolean;
begin
  ebCaption.Text:=ASPCaption;
  ebLocation.Text:=ASPLocation;
  btnOK.Enabled:=False;
  if Self.ShowModal=mrOK then
    Result:=True
  else
    Result:=False;
end;

procedure TSavePointDialog.WMDropFiles(var Msg: TWMDropFiles);
var
  FileName: Array[0..255] of Char;
begin
  DragQueryFile(Msg.Drop, 0, FileName, SizeOf(FileName));
  ebLocation.Text:=FileName;
  ebChange(nil);
end;

procedure TSavePointDialog.btnSelectLocationClick(Sender: TObject);
var
  SP:String;
begin
  if SelectDirectory('固定保存フォルダの選択','',SP) then begin
    ebLocation.Text:=SP;
    ebChange(nil);
  end;
end;

procedure TSavePointDialog.ebChange(Sender: TObject);
begin
  if (ebCaption.Text<>'') and (ebLocation.Text<>'') and DirectoryExists(ebLocation.Text) then
    btnOK.Enabled:=True
  else
    btnOK.Enabled:=False;
end;

end.
