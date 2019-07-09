unit frmSignIn_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, pngimage, dmDrinks_u;

type
  TfrmSignIn = class(TForm)
    btnHelp: TButton;
    imgTitle: TImage;
    pnlSignIn: TPanel;
    edtCompany: TLabeledEdit;
    edtPassword: TLabeledEdit;
    btnSee: TButton;
    btnSignIn: TButton;
    btnAdminSignIn: TButton;
    btnSignUp: TButton;
    lblNew: TLabel;
    btnForgot: TButton;
    procedure btnSignInClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnAdminSignInClick(Sender: TObject);
    procedure btnSignUpClick(Sender: TObject);
    procedure btnForgotClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnSeeMouseEnter(Sender: TObject);
    procedure btnSeeMouseLeave(Sender: TObject);
  private
    { Private declarations }
    bSee: Boolean;
    sCompany, sPassword, sCorrectPassword, sCustomerID : string;
    iCompanies: integer;
    function ValidCompanyName(pCompany : string) : Boolean;
  public
    { Public declarations }
    function ValidPassword(pPassword : string) : Boolean;
    function GetCustomerID : string;
    function GetCompanyName : string;
    function GetNumCompanies : integer;
    function GetPassword : string;
    procedure SetPassword(pNewPassword : string);
  end;

var
  frmSignIn: TfrmSignIn;

implementation

{$R *.dfm}

uses
  frmSignUp_u, frmCustomer_u, frmAdmin_u, frmHelp_u;

procedure TfrmSignIn.btnAdminSignInClick(Sender: TObject);
var
  sAdmin: string;
begin
  sAdmin := InputBox('Administrator account', 'Enter below', 'Admin@DrinksHub');
  sPassword := InputBox('Password', 'Enter below', 'BeverageKing42');

  // have one set of correct default values to be able to sin into the administrator account

  //data validation
  if sAdmin <> 'Admin@DrinksHub' then
  begin
    ShowMessage('That is not a valid administrator account');
    Exit;
  end;

  if sPassword <> 'BeverageKing42' then
  begin
    ShowMessage('The administrator password you entered is incorrect');
    Exit;
  end;

  frmAdmin.Show;
end;

procedure TfrmSignIn.btnForgotClick(Sender: TObject);
var
  sQuesID, sQuestion, sUserAns, sCorrectAns, sLine, sNewPassword, sNewLine,
    sRecovery: string;
  tFile: TextFile;
  k, iPos, iCount, j : integer;
  bFound: Boolean;
  arrPasswords : array[1..1000] of string;
begin
  {if the user has forgotten their password they can recover their acount and reset their
  password}

  sCompany := edtCompany.Text;

  //data validation
  if not(ValidCompanyName(sCompany)) then
    Exit;

  //find the account and its corresponding correct password in "Passwords.txt"

  if FileExists('Passwords.txt') = false then
  begin
    ShowMessage('The textfile called: "Passwords.txt" could not be found');
    Exit;
  end;

  AssignFile(tFile, 'Passwords.txt');
  Reset(tFile);
  bFound := False;

  while not(EOF(tFile)) and not(bFound) do
  begin
    Readln(tFile, sLine);
    //Example of a line in the texfile: CalebJ#Password1234#1#zebra
    if Copy(sLine,1,Pos('#',sLine)-1) = sCompany then
    begin
      bFound := True;
      for k := 1 to 2 do
      begin
        iPos := Pos('#',sLine);
        Delete(sLine,1,iPos);
      end;
      //2#French
      sQuesID := sLine[1];
      Delete(sLine,1,Pos('#',sLine));
      //French
      sCorrectAns := sLine;
    end;
  end;

  CloseFile(tFile);

  //find the correct account recovery question to ask
  AssignFile(tFile, 'Questions.txt');
  Reset(tFile);
  bFound := False;

  while not(EOF(tFile)) and not(bFound) do
  begin
    Readln(tFile, sLine);
    if sLine[1] = sQuesID then
      bFound := True;
  end;

  CloseFile(tFile);

  iPos := Pos(' ', sLine);
  Delete(sLine, 1, iPos);
  sQuestion := sLine;

  sUserAns := InputBox('Account Recovery Question', sQuestion, 'zebra');

  //data validation
  if sUserAns <> sCorrectAns then
  begin
    ShowMessage('The answer you entered in is incorrect');
    Exit;
  end;

  sNewPassword := InputBox('New password', 'Enter below', 'BeesN33s35');
  // validate the new password
  edtPassword.Text := sNewPassword;

  if ValidPassword(sNewPassword) then
  begin
    frmCustomer.Show;

    //change the password in the textfile called: "Passwords.txt"
    AssignFile(tFile, 'Passwords.txt');
    Reset(tFile);
    iCount := 0;

    while not(EOF(tFile)) and (iCount < 1000) do
    begin
      Readln(tFile, sLine);
      Inc(iCount);
      arrPasswords[iCount] := sLine;
    end;

    CloseFile(tFile);

    bFound := False;
    k := 0;

    while not(bFound) and (k < iCount) do
    begin
      Inc(k);
      //CalebJ#BeesN33s35#1#books
      if Copy(arrPasswords[k],1,Pos('#',arrPasswords[k])-1) = sCompany then
        bFound := True;
    end;

    //CalebJ#Password1234#1#zebra
    sLine := arrPasswords[k];

    for j := 1 to 2 do
    begin
      iPos := Pos('#', sLine);
      Delete(sLine, 1, iPos);
    end;

    sRecovery := sLine;//1#books
    Delete(sLine, 1, Length(sLine));
    sNewLine := sCompany + '#' + sNewPassword + '#' + sRecovery;
    arrPasswords[k] := sNewLine;//CalebJ#Password_New#1#zebra

    {we know the file exists as we have just read data from it into an array
    There is therefore no need to test for this again}

    AssignFile(tFile, 'Passwords.txt');
    Rewrite(tFile);

    for k := 1 to iCount do
      Writeln(tFile, arrPasswords[k]);

    CloseFile(tFile);
    ShowMessage('Your account password has been changed');

    with dmDrinksHub do
    begin
      Customers.Filtered := False;
      Customers.Filter := 'Company = '+Quotedstr(sCompany);
      Customers.Filtered := True;

      sCustomerID := IntToStr(Customers['CustomerID']);
    end;//with dmDrinksHub
  end;//if valid password
end;

procedure TfrmSignIn.btnHelpClick(Sender: TObject);
begin
  frmHelp.Show;
end;

procedure TfrmSignIn.btnSeeMouseEnter(Sender: TObject);
begin
  edtPassword.PasswordChar := #0;
end;

procedure TfrmSignIn.btnSeeMouseLeave(Sender: TObject);
begin
  edtPassword.PasswordChar := '*';
end;

procedure TfrmSignIn.btnSignInClick(Sender: TObject);
var
  tFile: TextFile;
  bFound: Boolean;
  sLine, sCurrentAccount : string;
  iPos, k : integer;
begin
  //user input
  sPassword := edtPassword.Text;
  sCompany := edtCompany.Text;

  //data validation using created functions

  if not(ValidCompanyName(sCompany)) or not(ValidPassword(sPassword)) then
    Exit;

  //find company name and password in the textfile

  if FileExists('Passwords.txt') = false then
  begin
    ShowMessage('The textfile called: "Passwords.txt" could not be found');
    Exit;
  end;

  AssignFile(tFile, 'Passwords.txt');
  Reset(tFile);
  bFound := False;

  while not(EOF(tFile)) and not(bFound) do
  begin
    Readln(tFile, sLine);
    //CalebJ#Password1234#1#zebra
    sCurrentAccount := Copy(sLine,1,Pos('#',sLine)-1);

    if sCurrentAccount = sCompany then
      bFound := True;
  end;

  CloseFile(tFile);

  if bFound then
  begin
    iPos := Pos('#',sLine);
    Delete(sLine,1,iPos);
    //Password1234#1#zebra
    iPos := Pos('#',sLine);
    sCorrectPassword := Copy(sLine,1,iPos-1);//Password1234

    if sPassword <> sCorrectPassword then
    begin
      ShowMessage('The password you entered is incorrect');
      Exit;
    end//incorrect password
    else
    begin
      frmCustomer.Show;
      with dmDrinksHub do
      begin
        Customers.Filtered := False;
        Customers.Filter := 'Company = ' + Quotedstr(sCompany);
        Customers.Filtered := True;
        sCustomerID := IntToStr(Customers['CustomerID']);

        // count the number of companies for later - to use in frmCustomer for arrCompanies upper index (arrCompanies[1..maximum value])
        Customers.Filtered := False;
        iCompanies := Customers.RecordCount;
      end;//with dmDrinksHub
    end;//both company name and password are correct
  end
  else
  begin
    ShowMessage('You do not have an account with us, maybe check your spelling');
    Exit;
  end;//else not have an account
end;

procedure TfrmSignIn.btnSignUpClick(Sender: TObject);
begin
  frmSignUp.Show;
end;

procedure TfrmSignIn.FormActivate(Sender: TObject);
begin
  {set correct default values for marker to do their testing more efficiently and for
  ease of use}

  edtCompany.Text := 'CalebJ';
  edtPassword.Text := 'Password1234';
  edtPassword.PasswordChar := '*';//hides the actual characters of the password entered
  bSee := False;//false - show * and true - show password
end;

function TfrmSignIn.GetCompanyName: string;
begin
  Result := sCompany;
end;

function TfrmSignIn.GetCustomerID : string;
begin
  Result := sCustomerID;
end;

function TfrmSignIn.GetNumCompanies : integer;
begin
  Result := iCompanies;
end;

function TfrmSignIn.GetPassword : string;
begin
  Result := sCorrectPassword;
end;

procedure TfrmSignIn.SetPassword(pNewPassword : string);
begin
  sCorrectPassword := pNewPassword;
end;

function TfrmSignIn.ValidCompanyName(pCompany: string): Boolean;
begin
  Result := False;

  if pCompany = '' then
  begin
    ShowMessage('Please enter in the name of your company');
    Exit;
  end;

  //max length of company name in database is 30

  if Length(pCompany) > 30 then
  begin
    ShowMessage('Your company name can only be a maximum of 30 characters long');
    Exit;
  end;

  Result := True;
end;

function TfrmSignIn.ValidPassword(pPassword : string): Boolean;
begin
  Result := False;

  if pPassword = '' then
  begin
    ShowMessage('Please enter in your password');
    Exit;
  end;

  if Pos(' ', pPassword) > 0 then
  begin
    ShowMessage('You cannot have spaces in your password');
    Exit;
  end;

  //minimum length = 8 and maximum length = 20

  if not(Length(pPassword) In [8 .. 20]) then
  begin
    ShowMessage('Your password has to be from 8 to 20 characters long');
    Exit;
  end;

  Result := True;
end;

end.
