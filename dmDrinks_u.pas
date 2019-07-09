unit dmDrinks_u;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TdmDrinksHub = class(TDataModule)
    conDrinksHub: TADOConnection;
    Customers: TADOTable;
    dsrCustomer: TDataSource;
    Orders: TADOTable;
    dsrOrders: TDataSource;
    Products: TADOTable;
    dsrProducts: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDrinksHub: TdmDrinksHub;

implementation

{$R *.dfm}

end.
