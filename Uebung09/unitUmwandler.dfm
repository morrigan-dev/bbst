object frmZahlensysteme: TfrmZahlensysteme
  Left = 394
  Top = 374
  Width = 565
  Height = 155
  Caption = 'Zahlenumwandlungsformular'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblDezimalzahl: TLabel
    Left = 24
    Top = 16
    Width = 56
    Height = 13
    Caption = 'Dezimalzahl'
  end
  object lblBinaerzahl: TLabel
    Left = 24
    Top = 56
    Width = 43
    Height = 13
    Caption = 'Bin'#228'rzahl'
  end
  object lblHexadezimalzahl: TLabel
    Left = 24
    Top = 80
    Width = 79
    Height = 13
    Caption = 'Hexadezimalzahl'
  end
  object edtDezimalzahl: TEdit
    Left = 120
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtBinaerzahl: TEdit
    Left = 120
    Top = 56
    Width = 209
    Height = 21
    TabOrder = 1
  end
  object edtHexadezimalzahl: TEdit
    Left = 120
    Top = 80
    Width = 49
    Height = 21
    TabOrder = 2
  end
  object btnUmwandelnDelphi: TButton
    Left = 344
    Top = 16
    Width = 185
    Height = 25
    Caption = 'umwandeln (&Delphi-Funktionen)'
    TabOrder = 3
    OnClick = btnUmwandelnDelphiClick
  end
  object btnUmwandelnKonventionell: TButton
    Left = 344
    Top = 48
    Width = 185
    Height = 25
    Caption = 'umwandeln (&konventionell)'
    TabOrder = 4
    OnClick = btnUmwandelnKonventionellClick
  end
  object btnProgrammende: TButton
    Left = 344
    Top = 80
    Width = 185
    Height = 25
    Caption = '&Programmende'
    TabOrder = 5
    OnClick = btnProgrammendeClick
  end
end
