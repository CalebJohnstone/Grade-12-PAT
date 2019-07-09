object dmDrinksHub: TdmDrinksHub
  OldCreateOrder = False
  Height = 249
  Width = 350
  object conDrinksHub: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=DrinksHub.mdb;Mode=' +
      'ReadWrite;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 19
    Top = 15
  end
  object Customers: TADOTable
    Active = True
    Connection = conDrinksHub
    CursorType = ctStatic
    TableName = 'Customers'
    Left = 199
    Top = 16
  end
  object dsrCustomer: TDataSource
    DataSet = Customers
    Left = 268
    Top = 16
  end
  object Orders: TADOTable
    Active = True
    Connection = conDrinksHub
    CursorType = ctStatic
    TableName = 'Orders'
    Left = 198
    Top = 81
  end
  object dsrOrders: TDataSource
    DataSet = Orders
    Left = 269
    Top = 81
  end
  object Products: TADOTable
    Active = True
    Connection = conDrinksHub
    CursorType = ctStatic
    TableName = 'Products'
    Left = 199
    Top = 144
  end
  object dsrProducts: TDataSource
    DataSet = Products
    Left = 269
    Top = 150
  end
end
