unit frmCustomer_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, frmSignIn_u, frmHelp_u, dmDrinks_u,
  Grids, DBGrids, dmDrinksHubSQL_u;

type
  TfrmCustomer = class(TForm)
    mnuMain: TMainMenu;
    Back1: TMenuItem;
    AccountInformation1: TMenuItem;
    OrderHistory1: TMenuItem;
    ShoppingCart1: TMenuItem;
    SignOut1: TMenuItem;
    Help1: TMenuItem;
    Exit1: TMenuItem;
    Display1: TMenuItem;
    Edit1: TMenuItem;
    pnlOrder: TPanel;
    btnAddOrder: TButton;
    btnAddCart: TButton;
    redProduct: TRichEdit;
    rgpProducts: TRadioGroup;
    dbgCustomer: TDBGrid;
    cmbEditInfo: TComboBox;
    btnEditInfo: TButton;
    edtQuantity: TLabeledEdit;
    CancelOrder1: TMenuItem;
    ChangePassword1: TMenuItem;
    Label2: TLabel;
    cmbCity: TComboBox;
    redInfo: TRichEdit;
    Purchasefromcart1: TMenuItem;
    procedure Back1Click(Sender: TObject);
    procedure SignOut1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Display1Click(Sender: TObject);
    procedure OrderHistory1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure btnEditInfoClick(Sender: TObject);
    procedure btnAddOrderClick(Sender: TObject);
    procedure rgpProductsClick(Sender: TObject);
    procedure btnAddCartClick(Sender: TObject);
    procedure ChangePassword1Click(Sender: TObject);
    procedure ShoppingCart1Click(Sender: TObject);
    procedure cmbEditInfoSelect(Sender: TObject);
    procedure Purchasefromcart1Click(Sender: TObject);
    procedure AccountInformation1Click(Sender: TObject);
    procedure CancelOrder1Click(Sender: TObject);
  private
    { Private declarations }
    iProducts, iShop : Integer;
    arrCompanies, arrCart : array[1..1000] of string;
    sProdID, sQuantity, sProdName : string;
    procedure DisplayAccountInfo;
    function ValidOrder(pProducts : integer; pQuantity : string) : Boolean;
  public
    { Public declarations }
  end;

var
  frmCustomer: TfrmCustomer;

implementation

{$R *.dfm}

procedure TfrmCustomer.AccountInformation1Click(Sender: TObject);
begin
  redInfo.Show;
  dbgCustomer.Hide;
end;

procedure TfrmCustomer.Back1Click(Sender: TObject);
begin
  frmCustomer.Close;
end;

procedure TfrmCustomer.btnAddCartClick(Sender: TObject);
var
  tFile : TextFile;
  sLine : string;
begin
  sQuantity := edtQuantity.Text;
  //data validation

  if ValidOrder(rgpProducts.ItemIndex, sQuantity) = False then
    Exit;

  //add the order to the textfile called: "ShoppingCart.txt"
  AssignFile(tFile, 'ShoppingCart.txt');

  if FileExists('ShoppingCart.txt') = false then
    Rewrite(tFile)
  else
    Append(tFile);

  //format of the data stored in the textfile: <CustomerID>#<ProdID>#<sQuantity>
  Writeln(tFile, frmSignIn.GetCustomerID+'#'+sProdID+'#'+sQuantity);
  CloseFile(tFile);
end;

procedure TfrmCustomer.btnAddOrderClick(Sender: TObject);
var
  sInsert, sText : string;
begin
  sQuantity := edtQuantity.Text;
  //data validation

  if ValidOrder(rgpProducts.ItemIndex,sQuantity) = false then
    Exit;

  with dmDrinksHubSQL do
  begin
    //SQL - INSERT
    sInsert := 'Insert Into Orders (CustomerID, ProdID, Quantity, OrderDate) Values ';
    sInsert := sInsert+' ('+frmSignIn.GetCustomerID+', '+sProdID+', '+sQuantity+', ';
    sInsert := sInsert+'#'+DateToStr(Date)+'#)';
    qryDrinksHub.SQL.Text := sInsert;
    qryDrinksHub.ExecSQL;

    dbgCustomer.Show;
    dbgCustomer.Top := edtQuantity.Top;

    //Ouput the products bought today by the user
    qryDrinksHub.SQL.Text := 'Select ProdName As [Today''s Ordered Products], Quantity from Orders, Products Where (CustomerID = '+frmSignIn.GetCustomerID+' and OrderDate = #'+DateToSTr(Date)+'#) and (Products.ProdID = Orders.ProdID)';
    qryDrinksHub.Open;
    edtQuantity.Text := '5';
  end;
end;

procedure TfrmCustomer.btnEditInfoClick(Sender: TObject);
var
  sField, sNewValue, sLine, sCompany, sName : string;
  tFile : textfile;
  iCount, iPos, k : integer;
  bFound, bDigits : boolean;
begin
  //user selects the data field that the want to change the value of

  //data validation
  if cmbEditInfo.ItemIndex = -1 then
  begin
    ShowMessage('Please select a property to change');
    Exit;
  end;

  sCompany := frmSignIn.GetCompanyName;

  with dmDrinksHub do
  begin
    sField := cmbEditInfo.Items[cmbEditInfo.ItemIndex];

    //city names are selected from cmbCity as there are a limited number of options

    if sField <> 'City' then
    begin
      sNewValue := InputBox('New value of '+sField,'Ente0r below','Buzzer');

      if sNewValue = '' then
      begin
        ShowMessage('Please enter a new value for your '+sField);
        Exit;
      end;
    end
    else
    begin
      if cmbCity.ItemIndex = -1 then
      begin
        ShowMessage('Please select a new city');
        Exit;
      end;

      sNewValue := cmbCity.Items[cmbCity.ItemIndex];
    end;

    if sField = 'Phone' then
    begin
      //check whether the user entered digits only

      k := 0;
      bDigits := True;

      while (bDigits) and (k < Length(sNewValue)) do
      begin
        Inc(k);
        if not(sNewValue[k] in ['0'..'9']) then
          bDigits := false;
      end;

      if not bDigits then
      begin
        ShowMessage('Please only enter the digits 0 to 9 for the phone number');
        Exit;
      end;

      //Example phone number: 0117895524
      Insert('-',sNewValue, 4);
      //011-7895524
      Insert('-',sNewValue, 8);
      //Resulting string: 011-789-5524
    end;//phone number formatting to make it easier to read when looking at the "Customers" table

    Customers.Filtered := False;
    Customers.Filter := 'CustomerID = '+quotedstr(frmSignIn.GetCustomerID);
    Customers.Filtered := True;
    Customers.First;

    //ADO Tables - UPDATE

    Customers.Edit;
    Customers[sField] := sNewValue;
    Customers.Post;

    ShowMessage('Your account information has been changed');
  end;//with dmDrinksHubSQL

  btnEditInfo.Hide;
  cmbEditInfo.Hide;
  redInfo.Show;
  redInfo.Lines.Clear;
  DisplayAccountInfo;

  //now update the company name in the textfile: "Passwords.txt"

  if sField <> 'Company' then
    Exit;

  //store textfile lines in an array

  if FileExists('Passwords.txt') = false then
  begin
    ShowMessage('The textfile called "Passwords.txt" could not be found');
    Exit;
  end;

  AssignFile(tFile, 'Passwords.txt');
  Reset(tFile);
  iCount := 0;

  while not(EOF(tFile)) and (iCount < frmSignIn.GetNumCompanies) do
  begin
    readln(tFile,sLine);
    Inc(iCount);
    //CalebJ#Password1234#1#zebra
    arrCompanies[iCount] := sLine;
  end;//while not file end

  CloseFile(tFile);

  //change company name in array

  bFound := false;
  iCount := 0;

  while not(bFound) and (iCount < frmSignIn.GetNumCompanies) do
  begin
    Inc(iCount);
    //Buzzer Franchise#H@n3y4Me#2#French
    sLine := arrCompanies[iCount];
    sName := Copy(sLine,1,Pos('#',sLine)-1);

    if sName = sCompany then
    begin
      bFound := true;
      iPos := pos('#', sLine);
      Delete(sLine,1,iPos-1);
      arrCompanies[iCount] := sNewValue+sLine;
    end;
  end;//while not bFound

  //write the new company name, other data of the user and the rest of the original
  //content in the textfile to the textfile

  AssignFile(tFile, 'Passwords.txt');
  Rewrite(tFile);

  for k := 1 to frmSignIn.GetNumCompanies do
    writeln(tFile, arrCompanies[k]);

  CloseFile(tFile);
end;

procedure TfrmCustomer.CancelOrder1Click(Sender: TObject);
begin
  //Cancel all of the orders the user made today

  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Delete * from Orders Where CustomerID = '+frmSignIn.GetCustomerID+' and OrderDate = #'+DateToStr(Date)+'#';
    qryDrinksHub.ExecSQL;
  end;
end;

procedure TfrmCustomer.ChangePassword1Click(Sender: TObject);
var
  sCurrentPassword, sOldPassword, sNewPassword, sLine, sNewLine : string;
  tFile : TextFile;
  k, iPos : Integer;
  bFound : Boolean;
begin
  //allow the iser to change thieir account password

  sCurrentPassword := frmSignIn.GetPassword;
  sOldPassword := InputBox('Current Password','Enter below','Password1234');

  //data validation

  if frmSignIn.ValidPassword(sOldPassword) then
    if sCurrentPassword <> sOldPassword then
    begin
      ShowMessage('The password you entered is incorrect');
      Exit;
    end;

  sNewPassword := InputBox('New Password','Enter below','Password_New');

  if frmSignIn.ValidPassword(sNewPassword) then
  begin
    //store the contents of "Passwords.txt" in an array

    if FileExists('Passwords.txt') = false then
    begin
      ShowMessage('The textfile called : "Passwords.txt" could not be found');
      Exit;
    end;

    AssignFile(tFile, 'Passwords.txt');
    Reset(tFile);
    k := 0;

    while not(Eof(tFile)) and (k < frmSignIn.GetNumCompanies) do
    begin
      readln(tFile, sLine);
      //CalebJ#Password1234#1#zebra
      Inc(k);
      arrCompanies[k] := sLine;
    end;

    CloseFile(tFile);

    //find the company

    bFound := false;
    k := 0;

    while not(bFound) and (k < frmSignIn.GetNumCompanies) do
    begin
      Inc(k);
      if Copy(arrCompanies[k],1,Pos('#',arrCompanies[k])-1) = frmSignIn.GetCompanyName then
        bFound := True;
    end;

    //change the password

    //CalebJ#Password1234#1#zebra
    sLine := arrCompanies[k];
    iPos := Pos('#',sLine);
    sNewLine := Copy(sLine,1,iPos);
    Delete(sLine,1,iPos);
    //Password1234#1#zebra
    iPos := Pos('#',sLine);
    Delete(sLine,1,iPos-1);
    //#1#zebra
    sNewLine := sNewLine+sNewPassword+sLine;//CalebJ#Password_New#1#zebra
    arrCompanies[k] := sNewLine;

    //override the contents of the textfile with the new paassword using the array as
    //new input

    AssignFile(tFile, 'Passwords.txt');
    Rewrite(tFile);

    for k := 1 to frmSignIn.GetNumCompanies do
    begin
      Writeln(tFile, arrCompanies[k]);
    end;

    CloseFile(tFile);
    ShowMessage('Your account password has been changed');
  end;//if valid password
end;

procedure TfrmCustomer.cmbEditInfoSelect(Sender: TObject);
begin
  //show cmbCity when the "City" field is selected
  if cmbEditInfo.ItemIndex = 5 then
    cmbCity.Show;
end;

procedure TfrmCustomer.Display1Click(Sender: TObject);
begin
  redInfo.Show;
  DisplayAccountInfo;
end;

procedure TfrmCustomer.DisplayAccountInfo;
var
  iMost, iLeast, k , iProduct, iQuantity, iPending : Integer;
  sMost, sLeast : string;
  arrBoughtCounters : array[1..20] of Integer; //counts how many of each product the user has purchased
begin
  //ouput the user's information in a rich edit

  with dmDrinksHub do
  begin
    Customers.Filtered := False;
    Customers.Filter := 'CustomerID = '+frmSignIn.GetCustomerID;
    Customers.Filtered := True;

    //the user has signed in and will therefore there will be one record in the table

    //ouput details from "Customers" table
    redInfo.Lines.Clear;
    redInfo.Lines.Add('Account Information'+#13);
    redInfo.Lines.Add('Company name: '+Customers['Company']);
    redInfo.Lines.Add('Contact Person: '+Customers['Contact']);
    redInfo.Lines.Add('Phone number: '+Customers['Phone']);
    redInfo.Lines.Add('Email address: '+Customers['Email']);
    redInfo.Lines.Add('Delivery address: '+Customers['Address']);
    redInfo.Lines.Add('City: '+Customers['City']);

    //ouput a summary of the account's orders
    Orders.Filtered := False;
    Orders.Filter := 'CustomerID = '+frmSignIn.GetCustomerID;
    Orders.Filtered := True;
    Orders.First;

    iProducts := rgpProducts.Items.Count;

    for k := 1 to iProducts do
      arrBoughtCounters[k] := 0;

    iPending := 0;

    while not(Orders.Eof) do
    begin
      iProduct := StrToInt(IntToStr(Orders['ProdID']));
      iQuantity := StrToInt(IntToStr(Orders['Quantity']));
      Inc(arrBoughtCounters[iProduct], iQuantity);

      if Orders['DeliveryDate'] < Orders['OrderDate'] then //if the date is empty
        Inc(iPending);

      Orders.Next;
    end;

    //count which product(s) the user has bought the most and the least

    k := 0;
    iMost := 1;
    iLeast := 1;
    sMost := '';
    sLeast := '';

    while k < iProducts do
    begin
      Inc(k);
      if arrBoughtCounters[k] > arrBoughtCounters[iMost] then
      begin
        iMost := k;
        sMost := rgpProducts.Items[k-1];
      end
      else
      begin
        if arrBoughtCounters[k] = arrBoughtCounters[iMost] then
          sMost := sMost+' and '+rgpProducts.Items[k-1]
        else
        if arrBoughtCounters[k] < arrBoughtCounters[iLeast] then
        begin
          iLeast := k;
          sLeast := rgpProducts.Items[k-1];
        end
        else
          sLeast := sLeast+' and '+rgpProducts.Items[k-1];
      end;
    end;//while

    if arrBoughtCounters[iMost] > 0 then
      redInfo.Lines.Add('Most bought: '+sMost+' - '+IntToStr(arrBoughtCounters[iMost])+' item(s)')
    else
      redInfo.Lines.Add('No products bought');

    if arrBoughtCounters[iLeast] > 0 then
      redInfo.Lines.Add('Least bought: '+sLeast+' - '+IntToStr(arrBoughtCounters[iLeast])+' item(s)');

    redInfo.Lines.Add('Last order: '+DateToStr(Orders['OrderDate']));

    if iPending > 0 then
      redInfo.Lines.Add('Pending orders: '+IntToStr(iPending));
  end;//with dmDrinksHub
end;

procedure TfrmCustomer.Edit1Click(Sender: TObject);
begin
  redInfo.Hide;
  cmbEditInfo.Show;
  cmbEditInfo.ItemIndex := -1;
  cmbEditInfo.Text := 'Select a property to change';
  btnEditInfo.Show;
end;

procedure TfrmCustomer.Exit1Click(Sender: TObject);
begin
  frmSignIn.Close;
end;

procedure TfrmCustomer.FormActivate(Sender: TObject);
var
  k : Integer;
begin
  pnlOrder.Show;
  dbgCustomer.Hide;
  rgpProducts.Items.Clear;
  cmbEditInfo.Hide;
  btnEditInfo.Hide;
  cmbCity.Hide;

  //populate the radio group with product names from the database table : "Products"

  with dmDrinksHub do
  begin
    Products.Filtered := False;
    Products.Filter := 'Selling = True';
    Products.Filtered := True;
    Products.First;

    while not(Products.Eof) do
    begin
      rgpProducts.Items.Add(Products['ProdName']);
      Products.Next;
    end;
  end;

  redInfo.Lines.Clear;
  redProduct.Lines.Clear;
  redInfo.Hide;
  edtQuantity.NumbersOnly := True;//only integer numbers can be entered (part of data validation)
  edtQuantity.Text := '5';
end;

procedure TfrmCustomer.Help1Click(Sender: TObject);
begin
  frmHelp.Show;
end;

procedure TfrmCustomer.OrderHistory1Click(Sender: TObject);
var
  sCompanyID, sOrderDate, sDeliveryDate, sProdID, sProdName, sLine : string;
  iQuantity, k : Integer;
  rItemCost : Real;
begin
  //display the user's order history

  pnlOrder.Hide;
  edtQuantity.Hide;
  Label2.Hide;
  dbgCustomer.Width := 600;
  dbgCustomer.Height := 200;
  dbgCustomer.Top := 20;
  dbgCustomer.Left := 50;
  dbgCustomer.Show;

  with dmDrinksHub do
  begin
    Orders.Filtered := false;
    Orders.First;
    Customers.Filtered := False;
    Customers.Filter := 'Company = '+quotedstr(frmSignIn.edtCompany.Text);
    Customers.Filtered := True;
    sCompanyID := Customers['CustomerID'];

    Orders.Filtered := False;
    Orders.Filter := 'CustomerID = '+sCompanyID;
    Orders.Filtered := True;

    if Orders.RecordCount = 0 then
    begin
      ShowMessage('You have made no orders yet');
      Exit;
    end;

    with dmDrinksHubSQL do
    begin
      qryDrinksHub.SQL.Text := 'Select ProdName, Quantity, OrderDate, DeliveryDate from Orders, Products Where (CustomerID = '+frmSignIn.GetCustomerID+') and (Orders.ProdID = Products.ProdID) Order By OrderDate';
      qryDrinksHub.Open;
    end;
  end;//with dmDrinksHub
end;

procedure TfrmCustomer.Purchasefromcart1Click(Sender: TObject);
var
  iCart, k, j : Integer;
  sCart, sLine, sProduct, sText, sBuyer, sBuyProdID, sKeepLine : string;
  bFound : Boolean;
  tFile : TextFile;
begin
  sCart := InputBox('Cart order number','Enter below','1');

  //data validation
  if TryStrToInt(sCart, iCart) then
  begin
    if not(iCart in [1..iShop]) then
    begin
      ShowMessage('Please enter a number between 1 and '+IntToStr(iShop));
      Exit;
    end;

    sLine := arrCart[iCart];
    //<sProdName>#<Quantity>
    sProduct := Copy(sLine,1,Pos('#',sLine)-1);
    Delete(sLine,1,Pos('#',sLine));

    //<Quantity>
    with dmDrinksHubSQL do
    begin
      with dmDrinksHub do
      begin
        Products.Filtered := False;
        Products.Filter := 'ProdName = '+quotedstr(sProduct);
        Products.Filtered := True;
        sProdID := IntToStr(Products['ProdID']);
      end;

      //SQL - INSERT

      sText := 'Insert Into Orders (CustomerID, ProdID, Quantity, OrderDate) Values ';
      sText := sText+' ('+frmSignIn.GetCustomerID+', '+sProdID+', '+sLine+', '+
      '#'+DateToStr(Date)+'#)';
      qryDrinksHub.SQL.Text := sText;
      qryDrinksHub.ExecSQL;

      dbgCustomer.Show;
      qryDrinksHub.SQL.Text := 'Select ProdName As [Today''s Ordered Products], Quantity from Orders, Products Where (CustomerID = '+frmSignIn.GetCustomerID+' and OrderDate = #'+DateToSTr(Date)+'#) and (Products.ProdID = Orders.ProdID)';
      qryDrinksHub.Open;

      //now "delete" from the textfile by excluding it when rewriting to the textfile

      redProduct.Lines.Clear;
      for k := 1 to 1000 do
        arrCart[k] := '';

      AssignFile(tFile, 'ShoppingCart.txt');
      Reset(tFile);
      k := 0;
      bFound := false;

      while not(Eof(tFile)) and (k < 1000) do
      begin
        Inc(k);
        Readln(tFile, sLine);
        //8#5#5
        sBuyer := Copy(sLine,1,Pos('#',sLine)-1);

        if (sBuyer = frmSignIn.GetCustomerID) and not(bFound) then
        begin
          sKeepLine := sLine;
          Delete(sLine,1,Pos('#',sLine));
          //5#5
          sBuyProdID := Copy(sLine,1,pos('#',sLine)-1);

          if sBuyProdID = sProdID then
            bFound := True
          else
            arrCart[k] := sKeepLine;
        end
        else
          arrCart[k] := sLine;
      end;

      CloseFile(tFile);

      //override the contents of the texfile

      AssignFile(tFile, 'ShoppingCart.txt');
      Rewrite(tFile);

      for j := 1 to k do
        if arrCart[j] <> '' then
          Writeln(tFile, arrCart[j]);

      CloseFile(tFile);
    end;
  end//can StrToInt(sCart)
  else
  begin
    ShowMessage('Please enter a number');
    Exit;
  end;
end;

procedure TfrmCustomer.rgpProductsClick(Sender: TObject);
var
  sProdName : string;
begin
  //ouput the selected product's details in a rich edit

  with dmDrinksHub do
  begin
    sProdName := rgpProducts.Items[rgpProducts.ItemIndex];
    Products.Filtered := false;
    Products.Filter := 'ProdName = '+quotedstr(sProdName);
    Products.Filtered := True;
    sProdID := Products['ProdID'];

    redProduct.Lines.Clear;
    redProduct.Lines.Add('Product Information'+#10);
    redProduct.Lines.Add('Product name: '+sProdName);
    redProduct.Lines.Add('Cost per unit: '+FloatToStrF(Products['UnitCost'],ffCurrency,10,2));
    redProduct.Lines.Add('Discount when purchasing 10 or more: '+FloatToStrF(Products['Discount'],ffCurrency,10,2));
    redProduct.Lines.Add('Quantity per unit: '+IntToStr(Products['UnitQuantity']));
  end;
end;

procedure TfrmCustomer.ShoppingCart1Click(Sender: TObject);
var
  tFile : textfile;
  sLine, sProdName, sProdID : string;
  k : integer;
  rUnitPrice, rTotal, rDiscount : real;
begin
  //ouput the user's draft orders that are in their shopping cart

  if FileExists('ShoppingCart.txt') = false then
  begin
    ShowMessage('The textfile called : "ShoppingCart.txt" could not be found');
    Exit;
  end;

  AssignFile(tFile, 'ShoppingCart.txt');
  Reset(tFile);
  iShop := 0;

  redProduct.Show;
  redProduct.Lines.Clear;
  redProduct.Paragraph.TabCount := 4;

  for k := 0 to 3 do
    redProduct.Paragraph.Tab[k] := (k+1)*50;

  redProduct.Lines.Add('Cart Order'+#9+'Product'+#9+'Unit Price'+#9+'Quantiy'+#9+'Total'+#10);

  while not(EOF(tFile)) and (iShop < 1000) do
  begin
    readln(tFile, sLine);
    //format: <CustomerID>#<ProdID>#<sQuantity>
    //2#2#5
    if pos(frmSignIn.GetCustomerID, sLine) = 1 then
    begin
      Inc(iShop);

      with dmDrinksHub do
      begin
        Delete(sLine,1,pos('#',sLine));
        //2#5
        sProdID := copy(sLine,1,pos('#',sLine)-1);
        Delete(sLine,1,pos('#',sLine));
        //5
        Products.Filtered := false;
        Products.Filter := 'ProdID = '+sProdID;
        Products.Filtered := true;

        sProdName := Products['ProdName'];
        rUnitPrice := Products['UnitCost'];

        if StrToInt(sLine) >= 10 then //discount for ten or more items bought
          rDiscount := Products['Discount']
        else
          rDiscount := 0;
        
        if StrToInt(sLine) >= 10 then
          rTotal := StrToInt(sLine)*(rUnitPrice-rDiscount)
        else
          rTotal := StrToInt(sLine)*rUnitPrice;
      end;

      arrCart[iShop] := sProdName+'#'+sLine;
      redProduct.Lines.Add(IntToStr(iShop)+#9+sProdName+#9+FloatToStrF(rUnitPrice,ffCurrency,10,2)+#9+sLine+#9+FloatToStrF(rTotal,ffCurrency,10,2));
    end;
  end;//while not EOF(tFile)

  CloseFile(tFile);
  Purchasefromcart1.Visible := True;

  if iShop = 0 then //no draft orders found for the current user in the textfile
  begin
    redProduct.Lines.Clear;
    redProduct.Lines.Add('You have no items in your cart');
    Purchasefromcart1.Visible := False;
  end;

  dbgCustomer.Hide;
end;

procedure TfrmCustomer.SignOut1Click(Sender: TObject);
begin
  frmCustomer.Close;
end;

function TfrmCustomer.ValidOrder(pProducts: integer; pQuantity: string): Boolean;
begin
  //data validation
  Result := false;

  if pProducts = -1 then
  begin
    ShowMessage('Please select a product to order');
    Exit;
  end;

  if pQuantity = '' then
  begin
    with dmDrinksHub do
    begin
      Products.Filtered := False;
      Products.Filter := 'ProdID = '+sProdID;
      Products.Filtered := True;
      sProdName := Products['ProdName'];
    end;

    ShowMessage('Please enter the quantity you want of the product: '+sProdName);
    Exit;
  end;

  Result := True;
end;

end.
