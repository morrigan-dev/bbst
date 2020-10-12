object Form2: TForm2
  Left = 325
  Top = 218
  Width = 310
  Height = 363
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 185
    Height = 201
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 200
    Top = 8
    Width = 89
    Height = 25
    Caption = 'isNumber'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 40
    Width = 89
    Height = 25
    Caption = 'getSchiffsAnzahl'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 200
    Top = 72
    Width = 89
    Height = 25
    Caption = 'getSystem'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 200
    Top = 104
    Width = 89
    Height = 25
    Caption = 'getName'
    TabOrder = 4
  end
  object Button5: TButton
    Left = 200
    Top = 136
    Width = 89
    Height = 25
    Caption = 'getFlotte'
    TabOrder = 5
  end
  object Button6: TButton
    Left = 200
    Top = 168
    Width = 89
    Height = 25
    Caption = 'getLaderaumAkt'
    TabOrder = 6
  end
  object Button7: TButton
    Left = 200
    Top = 200
    Width = 89
    Height = 25
    Caption = 'getLaderaumMax'
    TabOrder = 7
  end
  object Button8: TButton
    Left = 200
    Top = 232
    Width = 89
    Height = 25
    Caption = 'getKoord'
    TabOrder = 8
  end
  object Button9: TButton
    Left = 200
    Top = 264
    Width = 89
    Height = 25
    Caption = 'getRess'
    TabOrder = 9
  end
end
