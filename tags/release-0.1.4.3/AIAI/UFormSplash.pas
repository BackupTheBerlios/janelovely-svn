unit UFormSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormSplash = class(TForm)
    Image: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  FormSplash: TFormSplash;

implementation

{$R *.dfm}

procedure TFormSplash.FormCreate(Sender: TObject);
begin
  //if FileExists('splash.bmp') then begin
    Image.Picture.LoadFromFile('splash.bmp');
  //end;
  self.Width := Monitor.Width div 2;
  self.Height := Monitor.Height div 2;
  //TitleLabel.Top := self.Top + 10;
  //TitleLabel.Left := (self.ClientWidth - TitleLabel.Width) div 2;
  //VersionLabel.Top := self.ClientHeight - VersionLabel.Height - 10;
  //VersionLabel.Left := self.ClientWidth - VersionLabel.Width - 10;
end;

end.
