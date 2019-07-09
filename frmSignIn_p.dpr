program frmSignIn_p;

uses
  Forms,
  frmSignIn_u in 'frmSignIn_u.pas' {frmSignIn},
  frmSignUp_u in 'frmSignUp_u.pas' {frmSignUp},
  frmCustomer_u in 'frmCustomer_u.pas' {frmCustomer},
  frmAdmin_u in 'frmAdmin_u.pas' {frmAdmin},
  frmHelp_u in 'frmHelp_u.pas' {frmHelp},
  dmDrinks_u in 'dmDrinks_u.pas' {dmDrinksHub: TDataModule},
  dmDrinksHubSQL_u in 'dmDrinksHubSQL_u.pas' {dmDrinksHubSQL: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSignIn, frmSignIn);
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TfrmCustomer, frmCustomer);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TdmDrinksHub, dmDrinksHub);
  Application.CreateForm(TdmDrinksHubSQL, dmDrinksHubSQL);
  Application.Run;
end.
