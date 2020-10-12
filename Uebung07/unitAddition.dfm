object frmAddition: TfrmAddition
  Left = 548
  Top = 371
  Width = 327
  Height = 115
  Caption = 'Addieren von Zahlen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 16
    Width = 17
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 200
    Top = 16
    Width = 17
    Height = 13
    Alignment = taCenter
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
  end
  object edtZahl1: TEdit
    Left = 16
    Top = 16
    Width = 73
    Height = 21
    TabOrder = 0
  end
  object edtZahl2: TEdit
    Left = 120
    Top = 16
    Width = 73
    Height = 21
    TabOrder = 1
  end
  object edtErgebnis: TEdit
    Left = 224
    Top = 16
    Width = 73
    Height = 21
    Enabled = False
    TabOrder = 2
  end
  object btnRechne: TButton
    Left = 16
    Top = 48
    Width = 281
    Height = 25
    Caption = 'Rechne'
    TabOrder = 3
    OnClick = btnRechneClick
  end
end
