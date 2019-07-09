unit frmSignUp_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, ComCtrls, frmSignIn_u, dmDrinks_u, Math;

type
  TfrmSignUp = class(TForm)
    mnuMain: TMainMenu;
    Back1: TMenuItem;
    Restart1: TMenuItem;
    Help1: TMenuItem;
    Quit1: TMenuItem;
    pnl1: TPanel;
    pnl2: TPanel;
    redQuestions: TRichEdit;
    rgpQuestion: TRadioGroup;
    edtAddress: TLabeledEdit;
    cmbCity: TComboBox;
    edtCompany: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtConfirm: TLabeledEdit;
    edtContact: TLabeledEdit;
    edtEmail: TLabeledEdit;
    edtPhone: TLabeledEdit;
    btnSee: TButton;
    btnCreate: TButton;
    lbl1: TLabel;
    btnSignIn: TButton;
    lblMatch: TLabel;
    procedure Back1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure Restart1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSeeClick(Sender: TObject);
    procedure btnSignInClick(Sender: TObject);
    procedure edtConfirmChange(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  private
    { Private declarations }
    bSee : Boolean;
    procedure Restart;
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;

implementation

{$R *.dfm}
uses
  frmCustomer_u, frmHelp_u;
procedure TfrmSignUp.Back1Click(Sender: TObject);
begin
  frmSignUp.Close;
end;

procedure TfrmSignUp.btnCreateClick(Sender: TObject);
var
  sCompany, sPassword, sConfirm, sContact, sEmail, sPhone, sAddress, sCity, sLine, sAns : string;
  iQuesID, iCustomerID : Integer;
  tFile : TextFile;
begin
  //user input - data validation
  if edtCompany.Text = '' then
  begin
    ShowMessage('Please enter your company name');
    Exit;
  end;

  if edtPassword.Text = '' then
  begin
    ShowMessage('Please enter your password');
    Exit;
  end;

  if edtConfirm.Text = '' then
  begin
    ShowMessage('Please enter your password again to confirm');
    Exit;
  end;

  if edtContact.Text = '' then
  begin
    ShowMessage('Please enter the name of your contact person');
    Exit;
  end;

  if edtEmail.Text = '' then
  begin
    ShowMessage('Please enter the email address that we can contact you with');
    Exit;
  end;

  if edtPhone.Text = '' then
  begin
    ShowMessage('Please enter the phone number we can contact you with');
    Exit;
  end;

  if rgpQuestion.ItemIndex = -1 then
  begin
    ShowMessage('Please select a question number');
    Exit;
  end;

  if edtAddress.Text = '' then
  begin
    ShowMessage('Please enter your delivery address');
    Exit;
  end;

  if cmbCity.ItemIndex = -1 then
  begin
    ShowMessage('Please select a city');
    Exit;
  end;

  if not(Length(edtPassword.Text) In [8..20]) then
  begin
    ShowMessage('Your password has to be from 8 to 20 characters long');
    Exit;
  end;

  if edtPassword.Text <> edtConfirm.Text then
  begin
    ShowMessage('Your passwords entered need to match t confirm there are no typing errors');
    Exit;
  end;

  if Length(edtPhone.Text) <> 10 then
  begin
    ShowMessage('Your phone number needs to be 10 characters long');
    Exit;
  end;

  if Length(edtCompany.Text) > 30 then
  begin
    ShowMessage('Your company name can only be a maximum of 30 characters');
    Exit;
  end;

  if Length(edtAddress.Text) > 30 then
  begin
    ShowMessage('Your address can only be a maximum of 30 characters');
    Exit;
  end;

  if Length(edtContact.Text) > 30 then
  begin
    ShowMessage('The name of your contact person can only be a mximum of 30 characters');
    Exit;
  end;

  if Length(edtEmail.Text) > 30 then
  begin
    ShowMessage('Your email can only be a mazimum of 30 characters long');
    Exit;
  end;

  if Pos('#',edtPassword.Text) > 0 then
  begin
    ShowMessage('Your password may not contain a hash (#)');
    Exit;
  end;

  if pos('#', edtCompany.Text) > 0 then
  begin
    ShowMessage('Your company name may not contain a hash (#)');
    Exit;
  end;

  if Pos('@',edtEmail.Text) = 0 then
  begin
    ShowMessage('Your email needs to have a "@" in it');
    Exit;
  end;

  //give variables values
  sCompany := edtCompany.Text;
  sPassword := edtPassword.Text;
  sConfirm := edtConfirm.Text;
  sContact := edtContact.Text;
  sEmail := edtEmail.Text;
  sPhone := Copy(edtPhone.Text,1,3)+'-'+copy(edtPhone.Text,4,3)+'-'+copy(edtPhone.Text,7,4);
  iQuesID := rgpQuestion.ItemIndex+1;
  sAddress := edtAddress.Text;
  sCity := cmbCity.Items[cmbCity.ItemIndex];

  with dmDrinksHub do
  begin
    Customers.Filtered := False;
    Customers.Filter := 'Company = '+Quotedstr(sCompany);
    Customers.Filtered := True;

    //all Company names are unique to avoid errors later on in the logic of the program

    if Customers.RecordCount > 0 then
    begin
      ShowMessage('An account with that username already exists');
      Exit;
    end;
  end;//with dmDrinksHub

  sAns := '';
  while sAns = '' do
    sAns := InputBox('Answer to account recovery question','Enter below','cat');

  //ADO Tables - INSERT
  with dmDrinksHub do
  begin
    Customers.Insert;
    Customers['Company'] := sCompany;
    Customers['Contact'] := sContact;
    Customers['Phone'] := sPhone;
    Customers['Email'] := sEmail;
    Customers['Address'] := sAddress;
    Customers['City'] := sCity;
    Customers.Post;
  end;

  //add account detials to "Passwords.txt"
  AssignFile(tFile,'Passwords.txt');

  if FileExists('Passwords.txt') = false then
    Rewrite(tFile)
  else
    Append(tFile);

  sLine := sCompany+'#'+sPassword+'#'+IntToStr(iQuesID)+'#'+sAns;
  Writeln(tFile, sLine);
  CloseFile(tFile);
  frmSignUp.Close;
end;

procedure TfrmSignUp.btnSeeClick(Sender: TObject);
begin
  bSee := not(bSee);

  if bSee then
  begin
    edtPassword.PasswordChar := #0;//shows actual characters being typed
    edtConfirm.PasswordChar := #0;
  end
  else
  begin
    edtPassword.PasswordChar := '*';
    edtConfirm.PasswordChar := '*';
  end;
end;

procedure TfrmSignUp.btnSignInClick(Sender: TObject);
begin
  frmSignUp.Close;
end;

procedure TfrmSignUp.edtConfirmChange(Sender: TObject);
begin
  //tell the user whether their passwords match as they may be hidden

  if edtPassword.Text = edtConfirm.Text then
  begin
    lblMatch.Caption := 'Passwords match';
    lblMatch.Font.Color := clGreen;
  end
  else
  begin
    lblMatch.Caption := 'Passwords don''t match';
    lblMatch.Font.Color := clRed;
  end;
end;

procedure TfrmSignUp.edtPasswordChange(Sender: TObject);
begin
  if edtPassword.Text = edtConfirm.Text then
  begin
    lblMatch.Caption := 'Passwords match';
    lblMatch.Font.Color := clGreen;
  end
  else
  begin
    lblMatch.Caption := 'Passwords don''t match';
    lblMatch.Font.Color := clRed;
  end;
end;

procedure TfrmSignUp.FormActivate(Sender: TObject);
begin
  Restart;
end;

procedure TfrmSignUp.Help1Click(Sender: TObject);
begin
  frmHelp.Show;
end;

procedure TfrmSignUp.Quit1Click(Sender: TObject);
begin
  frmSignIn.Close;
end;

procedure TfrmSignUp.Restart;
var
  tFile : TextFile;
  sLine : string;
begin
  //setting default values to create a new account
  redQuestions.ReadOnly := True;
  edtPhone.NumbersOnly := True;
  edtPhone.MaxLength := 10;
  redQuestions.Lines.Clear;
  redQuestions.Lines.Add('Account Recovery Questions'+#13+'(if you forget your password)'+#13);
  lblMatch.Caption := 'Passwords match';
  lblMatch.Font.Color := clGreen;
  rgpQuestion.ItemIndex := 0;
  edtAddress.Text := '5 Cross Way';
  cmbCity.ItemIndex := 0;
  edtCompany.Text := 'Company'+Chr(RandomRange(1,101));//can create multiple accounts for testing
  edtPassword.Text := 'MyPassword';
  edtConfirm.Text := 'MyPassword';
  edtContact.Text := 'John Smith';
  edtEmail.Text := 'jsmith@yahoo.com';
  edtPhone.Text := '0112345678';

  //output account recovery questions in a rich edit

  AssignFile(tFile, 'Questions.txt');
  Reset(tFile);

  while not(Eof(tFile)) do
  begin
    Readln(tFile,sLine);
    redQuestions.Lines.Add(sLine);
  end;

  CloseFile(tFile);

  edtPassword.PasswordChar := '*';
  edtConfirm.PasswordChar := '*';
  bSee := False;
end;

procedure TfrmSignUp.Restart1Click(Sender: TObject);
begin
  Restart;
end;

end.
