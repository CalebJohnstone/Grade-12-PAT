object frmCustomer: TfrmCustomer
  Left = 0
  Top = 0
  Caption = 'DrinksHub.com'
  ClientHeight = 409
  ClientWidth = 841
  Color = clGreen
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
  object Label2: TLabel
    Left = 19
    Top = 222
    Width = 142
    Height = 13
    Caption = 'Buy 10 or more for a discount'
  end
  object pnlOrder: TPanel
    Left = 5
    Top = -2
    Width = 824
    Height = 368
    TabOrder = 0
    object btnAddOrder: TButton
      Left = 11
      Top = 249
      Width = 110
      Height = 38
      Caption = 'Add to orders'
      TabOrder = 0
      OnClick = btnAddOrderClick
    end
    object btnAddCart: TButton
      Left = 13
      Top = 291
      Width = 110
      Height = 38
      Caption = 'Add item to cart'
      TabOrder = 1
      OnClick = btnAddCartClick
    end
    object redProduct: TRichEdit
      Left = 229
      Top = 20
      Width = 342
      Height = 164
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object rgpProducts: TRadioGroup
      Left = 10
      Top = 17
      Width = 211
      Height = 156
      Caption = 'Products for sale'
      TabOrder = 3
      OnClick = rgpProductsClick
    end
    object cmbCity: TComboBox
      Left = 141
      Top = 194
      Width = 148
      Height = 21
      TabOrder = 4
      Text = 'Select a city'
      Items.Strings = (
        'Cape Town'
        'Johannesburg'
        'Durban'
        'Pretoria'
        'Port Elizabeth'
        'Potchefstroom'
        'Bloemfontein'
        'Kimberley'
        'East London')
    end
    object redInfo: TRichEdit
      Left = 574
      Top = 21
      Width = 250
      Height = 165
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
  end
  object dbgCustomer: TDBGrid
    Left = 236
    Top = 201
    Width = 502
    Height = 139
    DataSource = dmDrinksHubSQL.dsrDrinksHubSQL
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object cmbEditInfo: TComboBox
    Left = 597
    Top = 77
    Width = 162
    Height = 21
    TabOrder = 2
    OnSelect = cmbEditInfoSelect
    Items.Strings = (
      'Company'
      'Contact'
      'Phone'
      'Email'
      'Address'
      'City')
  end
  object btnEditInfo: TButton
    Left = 606
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Edit Info'
    TabOrder = 3
    OnClick = btnEditInfoClick
  end
  object edtQuantity: TLabeledEdit
    Left = 18
    Top = 195
    Width = 121
    Height = 21
    EditLabel.Width = 95
    EditLabel.Height = 13
    EditLabel.Caption = 'Quantity of product'
    TabOrder = 4
  end
  object mnuMain: TMainMenu
    Left = 18
    Top = 54
    object Back1: TMenuItem
      Caption = 'Back'
      OnClick = Back1Click
    end
    object AccountInformation1: TMenuItem
      Caption = 'Account Information'
      OnClick = AccountInformation1Click
      object Display1: TMenuItem
        Caption = 'Display'
        OnClick = Display1Click
      end
      object Edit1: TMenuItem
        Caption = 'Edit'
        OnClick = Edit1Click
      end
      object ChangePassword1: TMenuItem
        Caption = 'Change Password'
        OnClick = ChangePassword1Click
      end
    end
    object OrderHistory1: TMenuItem
      Caption = 'Order History'
      OnClick = OrderHistory1Click
    end
    object ShoppingCart1: TMenuItem
      Caption = 'Shopping Cart'
      OnClick = ShoppingCart1Click
      object Purchasefromcart1: TMenuItem
        Caption = 'Purchase from cart'
        OnClick = Purchasefromcart1Click
      end
    end
    object CancelOrder1: TMenuItem
      Caption = 'Cancel Today'#39's Orders'
      OnClick = CancelOrder1Click
    end
    object SignOut1: TMenuItem
      Caption = 'Sign Out'
      OnClick = SignOut1Click
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
    object Exit1: TMenuItem
      Caption = 'Quit'
      OnClick = Exit1Click
    end
  end
end
