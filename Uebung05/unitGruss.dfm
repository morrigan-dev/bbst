object frmGruss: TfrmGruss
  Left = 437
  Top = 401
  Width = 423
  Height = 250
  Caption = 'frmGruss'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblEingabeInfo: TLabel
    Left = 16
    Top = 16
    Width = 152
    Height = 13
    Caption = 'Geben Sie bitte Ihren Namen an'
  end
  object lblAusgabe: TLabel
    Left = 16
    Top = 128
    Width = 141
    Height = 13
    Caption = 'Hier erscheint Ihre Begr'#252#223'ung'
  end
  object edtEingabe: TEdit
    Left = 16
    Top = 40
    Width = 265
    Height = 21
    TabOrder = 0
    Text = 'Peter'
  end
  object btnGruss: TButton
    Left = 16
    Top = 80
    Width = 265
    Height = 25
    Caption = 'Begr'#252#223'ung'
    TabOrder = 1
    OnClick = btnGrussClick
  end
  object btnEnde: TButton
    Left = 16
    Top = 168
    Width = 273
    Height = 25
    Caption = 'Ende'
    TabOrder = 2
    OnClick = btnEndeClick
  end
  object ckbWeiblich: TCheckBox
    Left = 312
    Top = 40
    Width = 89
    Height = 17
    Caption = 'weiblich'
    TabOrder = 3
  end
end
