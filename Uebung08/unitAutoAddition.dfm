object frmAutoAdd: TfrmAutoAdd
  Left = 528
  Top = 342
  Width = 450
  Height = 93
  Caption = 'automatisches Rechnen'
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
    Left = 136
    Top = 8
    Width = 17
    Height = 13
    Alignment = taCenter
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 288
    Top = 8
    Width = 17
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblFehlerHinweis: TLabel
    Left = 8
    Top = 40
    Width = 425
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object edtZahl1: TEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    OnChange = edtZahl1Change
  end
  object edtZahl2: TEdit
    Left = 160
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
    OnChange = edtZahl2Change
  end
  object edtErgebnis: TEdit
    Left = 312
    Top = 8
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
end
