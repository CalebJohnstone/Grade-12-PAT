object frmSignUp: TfrmSignUp
  Left = 0
  Top = 0
  Caption = 'Sign Up'
  ClientHeight = 395
  ClientWidth = 773
  Color = clMoneyGreen
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
  object lbl1: TLabel
    Left = 36
    Top = 342
    Width = 125
    Height = 13
    Caption = 'Already have an account?'
  end
  object pnl1: TPanel
    Left = 8
    Top = 16
    Width = 296
    Height = 267
    TabOrder = 0
    object lblMatch: TLabel
      Left = 158
      Top = 105
      Width = 39
      Height = 13
      Caption = 'lblMatch'
    end
    object edtCompany: TLabeledEdit
      Left = 27
      Top = 26
      Width = 121
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = 'Company name'
      TabOrder = 0
    end
    object edtPassword: TLabeledEdit
      Left = 31
      Top = 63
      Width = 121
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'Password'
      TabOrder = 1
      OnChange = edtPasswordChange
    end
    object edtConfirm: TLabeledEdit
      Left = 30
      Top = 100
      Width = 121
      Height = 21
      EditLabel.Width = 111
      EditLabel.Height = 13
      EditLabel.Caption = 'Confirm your password'
      TabOrder = 2
      OnChange = edtConfirmChange
    end
    object edtContact: TLabeledEdit
      Left = 31
      Top = 137
      Width = 121
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = 'Contact person'
      TabOrder = 3
    end
    object edtEmail: TLabeledEdit
      Left = 30
      Top = 172
      Width = 121
      Height = 21
      EditLabel.Width = 65
      EditLabel.Height = 13
      EditLabel.Caption = 'Email address'
      TabOrder = 4
    end
    object edtPhone: TLabeledEdit
      Left = 30
      Top = 212
      Width = 121
      Height = 21
      EditLabel.Width = 69
      EditLabel.Height = 13
      EditLabel.Caption = 'Phone number'
      TabOrder = 5
    end
    object btnSee: TButton
      Left = 163
      Top = 62
      Width = 80
      Height = 25
      Caption = 'See Passwords'
      TabOrder = 6
      OnClick = btnSeeClick
    end
  end
  object pnl2: TPanel
    Left = 533
    Top = 15
    Width = 212
    Height = 270
    TabOrder = 1
    object rgpQuestion: TRadioGroup
      Left = 15
      Top = 9
      Width = 185
      Height = 105
      Caption = 'Question number'
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5')
      TabOrder = 0
    end
    object edtAddress: TLabeledEdit
      Left = 20
      Top = 143
      Width = 121
      Height = 21
      EditLabel.Width = 81
      EditLabel.Height = 13
      EditLabel.Caption = 'Delivery Address'
      TabOrder = 1
    end
    object cmbCity: TComboBox
      Left = 21
      Top = 173
      Width = 148
      Height = 21
      TabOrder = 2
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
  end
  object redQuestions: TRichEdit
    Left = 308
    Top = 16
    Width = 223
    Height = 267
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object btnCreate: TButton
    Left = 31
    Top = 306
    Width = 105
    Height = 25
    Caption = 'Create Account'
    TabOrder = 3
    OnClick = btnCreateClick
  end
  object btnSignIn: TButton
    Left = 33
    Top = 365
    Width = 75
    Height = 25
    Caption = 'Sign In'
    TabOrder = 4
    OnClick = btnSignInClick
  end
  object mnuMain: TMainMenu
    Left = 13
    Top = 19
    object Back1: TMenuItem
      Caption = 'Back'
      OnClick = Back1Click
    end
    object Restart1: TMenuItem
      Caption = 'Restart'
      OnClick = Restart1Click
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
    object Quit1: TMenuItem
      Caption = 'Quit'
      OnClick = Quit1Click
    end
  end
end
