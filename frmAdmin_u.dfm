object frmAdmin: TfrmAdmin
  Left = 0
  Top = 0
  Caption = 'Administrator Page'
  ClientHeight = 504
  ClientWidth = 1015
  Color = clOlive
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mnuMain
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object dbgAdmin: TDBGrid
    Left = 9
    Top = 4
    Width = 998
    Height = 195
    DataSource = dmDrinksHubSQL.dsrDrinksHubSQL
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object cmbSort: TComboBox
    Left = 784
    Top = 206
    Width = 145
    Height = 21
    TabOrder = 1
    Text = 'Select a field to sort by'
  end
  object btnSort: TButton
    Left = 934
    Top = 205
    Width = 75
    Height = 25
    Caption = 'Sort'
    TabOrder = 2
    OnClick = btnSortClick
  end
  object chkDesc: TCheckBox
    Left = 787
    Top = 235
    Width = 108
    Height = 17
    Caption = 'Descending Order'
    TabOrder = 3
  end
  object btnConfirmOrder: TButton
    Left = 786
    Top = 304
    Width = 81
    Height = 25
    Caption = 'Confirm Order'
    TabOrder = 4
    OnClick = btnConfirmOrderClick
  end
  object edtConfirm: TLabeledEdit
    Left = 787
    Top = 351
    Width = 121
    Height = 21
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'Order ID'
    TabOrder = 5
  end
  object chtAdmin: TChart
    Left = 6
    Top = 208
    Width = 470
    Height = 288
    Title.Text.Strings = (
      'TChart')
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMaximum = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.Maximum = -0.500000000000000000
    DepthAxis.Minimum = -0.500000000000000000
    DepthTopAxis.Automatic = False
    DepthTopAxis.AutomaticMaximum = False
    DepthTopAxis.AutomaticMinimum = False
    DepthTopAxis.Maximum = -0.500000000000000000
    DepthTopAxis.Minimum = -0.500000000000000000
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    View3DOptions.Elevation = 315
    View3DOptions.Orthogonal = False
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 360
    TabOrder = 6
    object Series1: TPieSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = True
      Gradient.Direction = gdRadial
      OtherSlice.Legend.Visible = False
      PieValues.Name = 'Pie'
      PieValues.Order = loNone
    end
  end
  object cmbSell: TComboBox
    Left = 482
    Top = 207
    Width = 145
    Height = 21
    TabOrder = 7
    Text = 'cmbSell'
  end
  object btnSell: TButton
    Left = 634
    Top = 205
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 8
    OnClick = btnSellClick
  end
  object mnuMain: TMainMenu
    Left = 23
    Top = 48
    object back1: TMenuItem
      Caption = 'Back'
      OnClick = back1Click
    end
    object Customers1: TMenuItem
      Caption = 'Customers'
      OnClick = Customers1Click
      object Group1: TMenuItem
        Caption = 'Number of each email domain'
        OnClick = Group1Click
      end
      object Numberofeachcity1: TMenuItem
        Caption = 'Number of businesses from each city'
        OnClick = Numberofeachcity1Click
      end
    end
    object Orders1: TMenuItem
      Caption = 'Orders'
      OnClick = Orders1Click
      object Salesforeachmonth1: TMenuItem
        Caption = 'Sales by month'
        OnClick = Salesforeachmonth1Click
      end
      object Salesofeachproduct1: TMenuItem
        Caption = 'Sales of each product'
        OnClick = Salesofeachproduct1Click
      end
      object ConfirmDelivery1: TMenuItem
        Caption = 'Confirm Delivery'
        OnClick = ConfirmDelivery1Click
      end
    end
    object Products1: TMenuItem
      Caption = 'Products'
      OnClick = Products1Click
      object UnitQuantities1: TMenuItem
        Caption = 'Unit Prices'
        OnClick = UnitQuantities1Click
      end
      object Putaproductonsale1: TMenuItem
        Caption = 'Make a product available'
        OnClick = Putaproductonsale1Click
      end
      object Stopsellingaproduct2: TMenuItem
        Caption = 'Stop selling a product'
        OnClick = Stopsellingaproduct2Click
      end
      object CreateNewProduct1: TMenuItem
        Caption = 'Create New Product'
        OnClick = CreateNewProduct1Click
      end
      object Deleteaproduct1: TMenuItem
        Caption = 'Delete a product'
        OnClick = Deleteaproduct1Click
      end
    end
    object Sort2: TMenuItem
      Caption = 'Sort'
      OnClick = Sort2Click
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
    object SignOut1: TMenuItem
      Caption = 'Sign Out'
      OnClick = SignOut1Click
    end
    object Quit1: TMenuItem
      Caption = 'Quit'
      OnClick = Quit1Click
    end
  end
end
