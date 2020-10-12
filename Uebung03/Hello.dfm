object Form1: TForm1
  Left = 578
  Top = 422
  Width = 262
  Height = 232
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblAusgabe: TLabel
    Left = 16
    Top = 104
    Width = 42
    Height = 13
    Caption = 'Ausgabe'
  end
  object edtEingabe: TEdit
    Left = 16
    Top = 16
    Width = 217
    Height = 21
    TabOrder = 0
    Text = 'Peter'
  end
  object btnVerarbeitung: TButton
    Left = 16
    Top = 56
    Width = 113
    Height = 25
    Caption = 'Verarbeitung'
    TabOrder = 1
    OnClick = btnVerarbeitungClick
  end
  object btnEnde: TButton
    Left = 16
    Top = 152
    Width = 113
    Height = 25
    Caption = 'Ende'
    TabOrder = 2
    OnClick = btnEndeClick
  end
end
