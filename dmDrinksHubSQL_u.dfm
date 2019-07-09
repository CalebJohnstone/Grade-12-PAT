object dmDrinksHubSQL: TdmDrinksHubSQL
  OldCreateOrder = False
  Height = 201
  Width = 284
  object conDrinksHubSQL: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=Drink' +
      'sHub.mdb;Mode=ReadWrite;Persist Security Info=False;Jet OLEDB:Sy' +
      'stem database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database P' +
      'assword="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mo' +
      'de=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk T' +
      'ransactions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Creat' +
      'e System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLE' +
      'DB:Don'#39't Copy Locale on Compact=False;Jet OLEDB:Compact Without ' +
      'Replica Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 46
    Top = 26
  end
  object qryDrinksHub: TADOQuery
    Active = True
    Connection = conDrinksHubSQL
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Orders')
    Left = 125
    Top = 24
  end
  object dsrDrinksHubSQL: TDataSource
    DataSet = qryDrinksHub
    Left = 207
    Top = 26
  end
end
