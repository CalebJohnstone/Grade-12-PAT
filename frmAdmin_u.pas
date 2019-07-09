unit frmAdmin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, Menus, frmSignIn_u, frmHelp_u, dmDrinks_u,
  dmDrinksHubSQL_u, TeEngine, Series, ExtCtrls, TeeProcs, Chart, DateUtils;

type
  TfrmAdmin = class(TForm)
    mnuMain: TMainMenu;
    back1: TMenuItem;
    Customers1: TMenuItem;
    Orders1: TMenuItem;
    Products1: TMenuItem;
    dbgAdmin: TDBGrid;
    cmbSort: TComboBox;
    btnSort: TButton;
    chkDesc: TCheckBox;
    Sort2: TMenuItem;
    SignOut1: TMenuItem;
    Quit1: TMenuItem;
    Group1: TMenuItem;
    Numberofeachcity1: TMenuItem;
    Salesforeachmonth1: TMenuItem;
    Salesofeachproduct1: TMenuItem;
    UnitQuantities1: TMenuItem;
    ConfirmDelivery1: TMenuItem;
    btnConfirmOrder: TButton;
    edtConfirm: TLabeledEdit;
    chtAdmin: TChart;
    Series1: TPieSeries;
    Putaproductonsale1: TMenuItem;
    cmbSell: TComboBox;
    Stopsellingaproduct2: TMenuItem;
    btnSell: TButton;
    Help1: TMenuItem;
    CreateNewProduct1: TMenuItem;
    Deleteaproduct1: TMenuItem;
    procedure back1Click(Sender: TObject);
    procedure SignOut1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure Customers1Click(Sender: TObject);
    procedure Orders1Click(Sender: TObject);
    procedure Products1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure Sort2Click(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Group1Click(Sender: TObject);
    procedure Numberofeachcity1Click(Sender: TObject);
    procedure Salesforeachmonth1Click(Sender: TObject);
    procedure Salesofeachproduct1Click(Sender: TObject);
    procedure UnitQuantities1Click(Sender: TObject);
    procedure ConfirmDelivery1Click(Sender: TObject);
    procedure btnConfirmOrderClick(Sender: TObject);
    procedure Putaproductonsale1Click(Sender: TObject);
    procedure Stopsellingaproduct2Click(Sender: TObject);
    procedure btnSellClick(Sender: TObject);
    procedure CreateNewProduct1Click(Sender: TObject);
    procedure Deleteaproduct1Click(Sender: TObject);
  private
    { Private declarations }
    sCurrentTable : string;
    procedure HideSortObjects;
    procedure ShowSortObjects;
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.dfm}

procedure TfrmAdmin.back1Click(Sender: TObject);
begin
  frmAdmin.Close;
end;

procedure TfrmAdmin.btnConfirmOrderClick(Sender: TObject);
var
  sOrderID, sText : string;
begin
  {an employee at DrinksHub.com will confirm that an order has been delivered on the
  current date}

  with dmDrinksHub do
  begin
    if edtConfirm.Text = '' then
    begin
      ShowMessage('Please enter an OrderID');
      Exit;
    end;

    sOrderID := edtConfirm.Text;

    Orders.Filtered := false;

    //orderID invalid

    if not(Orders.Locate('OrderID', StrToInt(sOrderID), [])) then
    begin
      ShowMessage('The OrderID you entered is invalid');
      Exit;
    end;

    //if Orders['DeliveryDate'] is empty, ('' > any string) is always false

    if Orders['DeliveryDate'] > Orders['OrderDate'] then
    begin
      ShowMessage('That order has already been delivered');
      Exit;
    end;

    with dmDrinksHubSQL do
    begin
      //SQL - UPDATE
      qryDrinksHUb.SQL.Text := 'Update Orders Set DeliveryDate = #'+DateToStr(Date)+'# Where OrderID = '+sOrderID;
      qryDrinksHub.ExecSQL;

      sText := 'Select OrderID, Company, ProdName As [Product Name], Quantity, OrderDate, DeliveryDate from Orders, Customers, Products';
      sText := sText+' Where Orders.ProdID = Products.ProdID and Orders.CustomerID = Customers.CustomerID';
      qryDrinksHub.SQL.Text := sText;
      qryDrinksHub.Open;
      btnConfirmOrder.Hide;
      edtConfirm.Hide;
    end;
    ShowMessage('The order with the OrderID of '+sOrderID+ ' has been confirmed as delivered');
  end;
end;

procedure TfrmAdmin.btnSellClick(Sender: TObject);
var
  sProdName, sNew : string;
  bNew : Boolean;
begin
  //data validation

  if cmbSell.ItemIndex = -1 then
  begin
    ShowMessage('Please select a product');
    Exit;
  end;

  sProdName := cmbSell.Items[cmbSell.ItemIndex];

  with dmDrinksHubSQL do
  begin
    with dmDrinksHub do
    begin
      Products.Filtered := False;
      Products.Filter := 'ProdName = '+quotedstr(sProdName);
      Products.Filtered := True;

      //ADO Tables - INSERT

      Products.Edit;
      bNew := not(Products['Selling']);
      Products['Selling'] := bNew;
      Products.Post;
    end;

    if bNew then
      sNew := 'True'
    else
      sNew := 'False';

    //updating in SQL - reflect change in value on dbgGrid and ADO Tables - change value for when filtering in the product menu options
    qryDrinksHub.SQL.Text := 'Update Products Set Selling = '+sNew+' Where ProdName = '+quotedstr(sProdName);
    qryDrinksHub.ExecSQL;

    qryDrinksHub.SQL.Text := 'Select ProdID, ProdName As [Product Name], UnitCost As [Cost per unit], Discount, UnitQuantity, Selling from Products';
    qryDrinksHub.Open;

    cmbSell.Hide;
    btnSell.Hide;
  end;//with dmDrinksHubSQL
end;

procedure TfrmAdmin.btnSortClick(Sender: TObject);
var
  sField, sDesc, sText : string;
begin
   //sorting the current table by a selected field

  //data validation
  if cmbSort.ItemIndex = -1 then
  begin
    ShowMessage('Please select a field to sort by');
    Exit;
  end;

  sField := cmbSort.Items[cmbSort.ItemIndex];

  //add "DESC" to the Order By SQL statement if chkDesc is selected

  if chkDesc.Checked then
    sDesc := ' DESC'
  else
    sDesc := '';

  with dmDrinksHubSQL do
  begin
    if sCurrentTable = 'Orders' then
    begin
      if (sField = 'Company') or (sField = 'Product Name') then
      begin
        sText := 'Select OrderID, Company, ProdName As [Product Name], Quantity, OrderDate, DeliveryDate from Orders, Customers, Products';
        sText := sText+' Where Orders.ProdID = Products.ProdID and Orders.CustomerID = Customers.CustomerID';
        if sField = 'Product Name' then
          sField := 'ProdName';
        sText := sText+' Order By '+sField;
      end
    end
    else
      sText := 'Select * from '+sCurrentTable+' Order By '+sField;

    qryDrinksHub.SQL.Text := sText+sDesc;
    qryDrinksHub.Open;
  end;
end;

procedure TfrmAdmin.ConfirmDelivery1Click(Sender: TObject);
var
  bHasEmptyDate : Boolean;
begin
  with dmDrinksHub do
  begin
    Orders.Filtered := False;
    Orders.First;
    bHasEmptyDate := False;

    while not(Orders.Eof) and not(bHasEmptyDate) do
    begin
      if Orders['DeliveryDate'] < Orders['OrderDate'] then //('' < any string) is always true
        bHasEmptyDate := True;
      Orders.Next;
    end;

    if not bHasEmptyDate then
    begin
      ShowMessage('There are no pending orders');
      Exit;
    end;//no orders that are not yet delivered
  end;//with dmDrinksHub

  ShowMessage('Enter the order in the text box that you want to confirm');
  chtAdmin.Hide;
  btnConfirmOrder.Show;
  edtConfirm.Show;
  edtConfirm.NumbersOnly := true;//ensure that only numbers can be entered in the edit box
end;

procedure TfrmAdmin.CreateNewProduct1Click(Sender: TObject);
var
  sProductName, sSelling, sInsert, sUnitCost, sDiscount, sUnitQuantity : string;
  rUnitCost, rDiscount : Extended;//Extended dta type - needed for TryStrToFloat
  iUnitQuantity : Integer;
  bSelling : Boolean;
begin
  with dmDrinksHubSQL do
  begin
    //data validation
    
    sProductName := InputBox('Product Name','Enter below','Guava Juice');
    if (sProductName = '') or (sProductName = ' ') then
    begin
      ShowMessage('Please enter a Product Name');
      Exit;
    end;

    sUnitCost := InputBox('Product unit price','Enter below','19,99');

    if TryStrToFloat(sUnitCost, rUnitCost) = False then
    begin
      ShowMessage('Please enter a price (using a comma for the decimal point)');
      Exit;
    end;

    sUnitQuantity := InputBox('Unit Quantity','Enter below','6');

    if TryStrToInt(sUnitQuantity, iUnitQuantity) = False then
    begin
      ShowMessage('Please enter an unit quantity');
      Exit;
    end;

    sDiscount := InputBox('Product discount','Enter below','19,99');

    if TryStrToFloat(sDiscount, rDiscount) = False then
    begin
      ShowMessage('Please enter a product discount');
      Exit;
    end;

    sSelling := InputBox('Put product on sale?','Enter yes/no below','Yes');

    if (sSelling = '') or ((UpperCase(sSelling) <> 'YES') and (UpperCase(sSelling) <> 'NO')) then
    begin
      ShowMessage('Please enter yes/no in the text box');
      Exit;
    end;

    bSelling := True;

    if UpperCase(sSelling) = 'YES' then
      sSelling := 'True'
    else
    begin
      sSelling := 'False';
      //bSelling := False;
    end;

    {Delphi only accpets reals with a comma but SQL sees this as a seperator between 
    query field values, therefore change , to . }
    
    sUnitCost := Copy(sUnitCost,1,Pos(',',sUnitCost)-1)+'.'+copy(sUnitCost,Pos(',',sUnitCost)+1,2);
    sDiscount := Copy(sDiscount,1,Pos(',',sDiscount)-1)+'.'+copy(sDiscount,Pos(',',sDiscount)+1,2);

    //SQL - INSERT
    sInsert := 'Insert Into Products (ProdName, UnitCost, Discount, UnitQuantity, Selling) Values ';
    sInsert := sInsert+'('+quotedstr(sProductName)+', '+sUnitCost+', '+sDiscount+', '+
    sUnitQuantity+', '+sSelling+')';
    qryDrinksHub.SQL.Text := sInsert;
    qryDrinksHub.ExecSQL;

    {also update in ADO Tables because the menu options:
    "Make a product available" and "Stop selling a product"
    use ADO Tables to populate cmbSell and therefore the newly inserted product(s) will
    not be seen by ADO tables. Both methods are used to avoid this from happening as well
    as the dbgGrid outputting the right information, as it uses dmDrinksHubSQL.dsrDrinksHUbSQL
    as its Data Source.}

    {with dmDrinksHub do
    begin
      Products.Insert;
      Products['ProdName'] := sProductName;
      Products['UnitCost'] := rUnitCost;
      Products['Discount'] := rDiscount;
      Products['UnitQuantity'] := iUnitQuantity;
      Products['OnSale'] := bSelling;
      Products.Post;
    end;}

    //show table with newly inserted record
    qryDrinksHub.SQL.Text := 'Select ProdID, ProdName As [Product Name], UnitCost As [Cost per unit], Discount, UnitQuantity, Selling from Products';
    qryDrinksHub.Open;
  end;
end;

procedure TfrmAdmin.Customers1Click(Sender: TObject);
begin
  //show "Customers" table
  HideSortObjects;

  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Select * from Customers';
    qryDrinksHub.Open;
    sCurrentTable := 'Customers';
  end; //with dmDrinksHubSQL
end;

procedure TfrmAdmin.Deleteaproduct1Click(Sender: TObject);
var
  sProdID, sProdName : string;
  iProdID : Integer;
begin
  //Delete a product
  sProdID := InputBox('Product ID','Enter below','34');

  //data validation
  
  if TryStrToInt(sProdID, iProdID) = False then
  begin
    ShowMessage('Please enter a number for the product ID');
    Exit;
  end;

  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Select * from Products Where ProdID = '+sProdID;
    qryDrinksHub.Open;

    //only delete if the product has not been ordered - avoiding delete anomalies
    
    if qryDrinksHub.RecordCount = 0 then
    begin
      ShowMessage('There is no product with a product ID of '+sProdID);
      Exit;
    end;

    qryDrinksHub.SQL.Text := 'Select * from Orders Where ProdID = '+sProdID;
    qryDrinksHub.Open;

    if qryDrinksHub.RecordCount > 0 then
    begin
      ShowMessage('That product cannot be deleted as it has been ordered and this will cause delete anomalies');
      Exit;
    end;

    with dmDrinksHub do
    begin
      //ADO Tables - DELETE
      Products.Filtered := False;
      Products.Filter := 'ProdID = '+sProdID;
      Products.Filtered := True;
      sProdName := Products['ProdName'];

      Products.Delete;
      ShowMessage('The product called: '+sProdName+' was deleted');
    end;

    //show changed table
    qryDrinksHub.SQL.Text := 'Select ProdID, ProdName As [Product Name], UnitCost As [Cost per unit], Discount, UnitQuantity, Selling from Products';
    qryDrinksHub.Open;
  end;
end;

procedure TfrmAdmin.Exit1Click(Sender: TObject);
begin
  frmSignIn.Close;
end;

procedure TfrmAdmin.FormActivate(Sender: TObject);
var
  sText : string;
begin
  {set dbgAdmin to show the orders table by default as this is the table they would
  most likely be interested in}
  
  with dmDrinksHubSQL do
  begin
    sText := 'Select OrderID, Company, ProdName As [Product Name], Quantity, OrderDate, DeliveryDate from Orders, Customers, Products';
    sText := sText+' Where Orders.ProdID = Products.ProdID and Orders.CustomerID = Customers.CustomerID';
    qryDrinksHub.SQL.Text := sText;
    qryDrinksHub.Open;
    sCurrentTable := 'Orders';
  end;

  HideSortObjects;
  btnConfirmOrder.Hide;
  edtConfirm.Hide;
  cmbSell.Hide;
  btnSell.Hide;
  dbgAdmin.Font.Size := 10;//easier to read
end;

procedure TfrmAdmin.Group1Click(Sender: TObject);
begin
  //count how many users use each email domain
  
  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Select Count(*) As [Number], mid(Email,InStr(Email,"@")+1,Len(Email)) As [Email domain name] from Customers Group By mid(Email,InStr(Email,"@")+1,Len(Email))';
    qryDrinksHub.Open;

    chtAdmin.Title.Text.Clear;
    Series1.Clear;
  end;
end;

procedure TfrmAdmin.Help1Click(Sender: TObject);
begin
  frmHelp.Show;
end;

procedure TfrmAdmin.HideSortObjects;
begin
  btnSort.Hide;
  cmbSort.Hide;
  chkDesc.Hide;
end;

procedure TfrmAdmin.Numberofeachcity1Click(Sender: TObject);
var
  bSameCity : Boolean;
  sCity : string;
  iCountCity : Integer;
  rCountCity : real;
begin
  //count the number of user businesses from each city
  
  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Select City, Count (*) As [Number] from Customers Group By City';
    qryDrinksHub.Open;

    //ouput this data in a pie chart
    
    chtAdmin.Show;
    chtAdmin.Title.Text.Clear;
    chtAdmin.Title.Text.Add('Client Locations');
    Series1.Clear;

    with dmDrinksHub do
    begin
      Customers.Filtered := False;
      Customers.Sort := 'City';
      Customers.First;

      while not(Customers.Eof) do
      begin
        sCity := Customers['City'];
        bSameCity := True;
        iCountCity := 0;

        while bSameCity and not(Customers.Eof) do
        begin
          if Customers['City'] <> sCity then
            bSameCity := false
          else
          begin
            Inc(iCountCity);
            Customers.Next;
          end;
        end;

        if iCountCity = 0 then
          iCountCity := 1;
        Series1.Add(iCountCity, sCity);
      end;//while Customers
    end;//with dmDrinksHub
  end;//with dmDrinksHubSQL
end;

procedure TfrmAdmin.Orders1Click(Sender: TObject);
var
  sText : string;
begin
  //output the "Orders" table
  HideSortObjects;

  with dmDrinksHubSQL do
  begin
    sText := 'Select OrderID, Company, ProdName As [Product Name], Quantity, OrderDate, DeliveryDate from Orders, Customers, Products';
    sText := sText+' Where Orders.ProdID = Products.ProdID and Orders.CustomerID = Customers.CustomerID';
    qryDrinksHub.SQL.Text := sText;
    qryDrinksHub.Open;
    sCurrentTable := 'Orders';
  end;
end;

procedure TfrmAdmin.Products1Click(Sender: TObject);
var
  sProd1, sLastProdID : string;
begin
  //ouput the "Products" table
  HideSortObjects;

  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Select ProdID, ProdName As [Product Name], UnitCost As [Cost per unit], Discount, UnitQuantity, Selling from Products';
    qryDrinksHub.Open;
    sCurrentTable := 'Products';
  end;
end;

procedure TfrmAdmin.Putaproductonsale1Click(Sender: TObject);
begin
  //make a product available for purchase by the users
  
  with dmDrinksHub do
  begin
    Products.Filtered := False;
    Products.Filter := 'Selling = False';
    Products.Filtered := True;
    cmbSell.Items.Clear;

    //if there are no products that are not currently being sold
    
    if Products.RecordCount = 0 then
    begin
      ShowMessage('All of the products are available to purchase');
      cmbSell.Hide;
      btnSell.Hide;
      Exit;
    end;

    cmbSell.Show;
    cmbSell.Left := chtAdmin.Left+chtAdmin.Width+20;
    cmbSell.Text := 'Select a product';
    Products.First;

    //populate the cmbSell with the product names
    
    while not(Products.Eof) do
    begin
      cmbSell.Items.Add(Products['ProdName']);
      Products.Next;
    end;
    btnSell.Show;
    btnSell.Left := cmbSell.Left+cmbSell.Width+10;
  end;
end;

procedure TfrmAdmin.Quit1Click(Sender: TObject);
begin
  frmSignIn.Close;
end;

procedure TfrmAdmin.Salesforeachmonth1Click(Sender: TObject);
var
  sText, sMonth, sCurrentMonth, sMonthName : string;
  bSameMonth : Boolean;
  rQuantity : real;
begin
  //count the number of items sold per month
  
  with dmDrinksHubSQL do
  begin
    sText := 'Select Format(OrderDate, "mmmm yyyy") As [Month], Count(*) As [Number of orders]';
    sText := sText+', Sum(Quantity) As [Total items bought], Format(Sum(Quantity*(UnitCost-Discount)), "Currency") As [Total Sales] from Orders, Products ';
    qryDrinksHub.SQL.Text := sText+'Where Orders.ProdID = Products.ProdID Group By Format(OrderDate, "mmmm yyyy")';
    qryDrinksHub.Open;

    //ouput this data in a pie chart
    
    chtAdmin.Show;
    chtAdmin.Title.Text.Clear;
    chtAdmin.Title.Text.Add('Monthly Sales of items');
    Series1.Clear;

    with dmDrinksHub do
    begin
      Orders.Filtered := False;
      Orders.Sort := 'OrderDate';
      Orders.First;

      while not(Orders.Eof) do
      begin
        sMonth := IntToStr(MonthOf(Orders['OrderDate']))+IntToStr(YearOf(Orders['OrderDate']));
        bSameMonth := True;
        rQuantity := 0;

        while bSameMonth and not(Orders.Eof) do
        begin
          sCurrentMonth := IntToStr(MonthOf(Orders['OrderDate']))+IntToStr(YearOf(Orders['OrderDate']));
          if sCurrentMonth <> sMonth then
            bSameMonth := false
          else
          begin
            rQuantity := rQuantity+Orders['Quantity'];
            Orders.Next
          end;
        end;

        if rQuantity = 0 then
        begin
          rQuantity := Orders['Quantity']
        end;//last order in its own month

        if not(Orders.Eof) then
          Orders.Prior;

        //to get the current month must go one month back and then forward to cancel the effect
          
        sMonthName := LongMonthNames[MonthOf(Orders['OrderDate'])]+' '+IntToStr(YearOf(Orders['OrderDate']));;
        Series1.Add(rQuantity, sMonthName);
        if not(Orders.Eof) then
          Orders.Next;
    end;//while Orders
  end;//with dmDrinksHub
  end;
end;

procedure TfrmAdmin.Salesofeachproduct1Click(Sender: TObject);
var
  sProdID, sProdName : string;
  bSameProd : Boolean;
  rTotalQuantity : Real;
begin
  //count the sales of each product in total
  
  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Select ProdName As [Product Name], Sum(Quantity) As [Quanity Bought] from Orders, Products Where Orders.ProdID = Products.ProdID Group By ProdName Order By Sum(Quantity)';
    qryDrinksHub.Open;

    //output this data in a pie chart
    
    chtAdmin.Show;
    chtAdmin.Title.Text.Clear;
    chtAdmin.Title.Text.Add('Product Sales');
    Series1.Clear;

    with dmDrinksHub do
    begin
      Orders.Filtered := False;
      Orders.Sort := 'ProdID';
      Orders.First;

      while not(Orders.Eof) do
      begin
        sProdID := Orders['ProdID'];
        bSameProd := True;
        rTotalQuantity := 0;

        while bSameProd and not(Orders.Eof) do
        begin
          if Orders['ProdID'] <> sProdID then
            bSameProd := false
          else
          begin
            rTotalQuantity := rTotalQuantity+Orders['Quantity'];
            Orders.Next;
          end;
        end;

        if rTotalQuantity = 0 then//last order is the only one of that product
          rTotalQuantity := Orders['Quantity'];

        Products.Filtered := False;
        Products.Filter := 'ProdID = '+sProdID;
        Products.Filtered := True;
        sProdName := Products['ProdName'];
        Series1.Add(rTotalQuantity, sProdName);
      end;//while Orders
    end;//with dmDrinksHUb
  end;//with dmDrinksHubSQL
end;

procedure TfrmAdmin.ShowSortObjects;
begin
  btnSort.Show;
  cmbSort.Show;
  chkDesc.Show;
end;

procedure TfrmAdmin.SignOut1Click(Sender: TObject);
begin
  frmAdmin.Close;
end;

procedure TfrmAdmin.Sort2Click(Sender: TObject);
begin
  //populate cmbSort with the current table's field names
  ShowSortObjects;

  with dmDrinksHubSQL do
  begin
    cmbSort.Items.Clear;

    if sCurrentTable = 'Customers' then
    begin
      cmbSort.Items.Add('Company');
      cmbSort.Items.Add('Contact');
      cmbSort.Items.Add('Phone');
      cmbSort.Items.Add('Email');
      cmbSort.Items.Add('Address');
      cmbSort.Items.Add('City');
    end //Customers table
    else
    begin
      if sCurrentTable = 'Orders' then
      begin
        cmbSort.Items.Add('OrderDate');
        cmbSort.Items.Add('DeliveryDate');
        cmbSort.Items.Add('Company');
        cmbSort.Items.Add('Product Name');
        cmbSort.Items.Add('Quantity');
      end //Orders table
      else
      begin
        cmbSort.Items.Add('ProdName');
        cmbSort.Items.Add('Discount');
        cmbSort.Items.Add('UnitCost');
        cmbSort.Items.Add('UnitQuantity');
      end //Products table
    end;
  end;//with
  cmbSort.ItemIndex := -1;
  cmbSort.Text := 'Select a field to sort by';
end;

procedure TfrmAdmin.UnitQuantities1Click(Sender: TObject);
begin
  //Show the discount information of each product
  
  with dmDrinksHubSQL do
  begin
    qryDrinksHub.SQL.Text := 'Select ProdName As Product, UnitQuantity As [Quantity per unit] , UnitCost As [Cost per unit], Discount, Format(UnitCost-Discount, "Currency") As [Discounted cost per unit] from Products';
    qryDrinksHub.Open;
  end;
end;

procedure TfrmAdmin.Stopsellingaproduct2Click(Sender: TObject);
begin
  //stop selling a product
  
  with dmDrinksHub do
  begin
    Products.Filtered := False;
    Products.Filter := 'Selling = True';
    Products.Filtered := True;
    cmbSell.Items.Clear;

    //if there are currently no products for sale
    //this is possible, but not likely in an actual situation
    
    if Products.RecordCount = 0 then
    begin
      ShowMessage('There are no products being sold currently');
      cmbSell.Hide;
      btnSell.Hide;
      Exit;
    end;

    cmbSell.Show;
    cmbSell.Left := chtAdmin.Left+chtAdmin.Width+20;
    cmbSell.Text := 'Select a product';
    Products.First;

    //populate cmbSell with the Product Names
    
    while not(Products.Eof) do
    begin
      cmbSell.Items.Add(Products['ProdName']);
      Products.Next;
    end;
    btnSell.Show;
    btnSell.Left := cmbSell.Left+cmbSell.Width+10;
  end;
end;

end.
