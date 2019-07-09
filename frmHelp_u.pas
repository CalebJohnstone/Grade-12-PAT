unit frmHelp_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls;

type
  TfrmHelp = class(TForm)
    mnuMain: TMainMenu;
    Back1: TMenuItem;
    redHelp: TRichEdit;
    procedure Back1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.dfm}

procedure TfrmHelp.Back1Click(Sender: TObject);
begin
  frmHelp.Close;
end;

procedure TfrmHelp.FormActivate(Sender: TObject);
begin
  redHelp.ReadOnly := True;
end;

end.
