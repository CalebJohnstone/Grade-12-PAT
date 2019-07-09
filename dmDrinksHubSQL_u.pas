unit dmDrinksHubSQL_u;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TdmDrinksHubSQL = class(TDataModule)
    conDrinksHubSQL: TADOConnection;
    qryDrinksHub: TADOQuery;
    dsrDrinksHubSQL: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDrinksHubSQL: TdmDrinksHubSQL;

implementation

{$R *.dfm}

end.
