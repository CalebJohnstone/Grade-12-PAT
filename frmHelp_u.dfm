object frmHelp: TfrmHelp
  Left = 0
  Top = 0
  Caption = 'Help'
  ClientHeight = 307
  ClientWidth = 606
  Color = clTeal
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
  object redHelp: TRichEdit
    Left = 77
    Top = 19
    Width = 451
    Height = 241
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Welcome to DrinksHub.com'
      ''
      
        'Select the following options on the home page, depending on what' +
        ' you want to do:'
      ''
      '- Sign In: to sign in as a customer company account'
      '- Sign Up: to sign up for a customer company account'
      
        '- Administrator Sign In: to sign in if you are a DrinksHub execu' +
        'tive or administrator'
      
        '- Forgot password: for users that have forgotten their password ' +
        'to their customer '
      'company account'
      ''
      
        'From there, just follow the header tabs at the top of the screen' +
        ' of each page to guide you.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object mnuMain: TMainMenu
    Left = 15
    Top = 11
    object Back1: TMenuItem
      Caption = 'Back'
      OnClick = Back1Click
    end
  end
end
