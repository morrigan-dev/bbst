object frmHandelsposten: TfrmHandelsposten
  Left = 115
  Top = 107
  Width = 768
  Height = 523
  Caption = 'Handelsposten'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 80
    Height = 13
    Caption = 'Copy && Paste:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object mmoDaten: TMemo
    Left = 8
    Top = 24
    Width = 609
    Height = 121
    TabOrder = 0
    WordWrap = False
  end
  object btnCreateTable: TButton
    Left = 8
    Top = 152
    Width = 113
    Height = 25
    Caption = 'Tabelle erstellen'
    TabOrder = 1
    OnClick = btnCreateTableClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 184
    Width = 721
    Height = 233
    BevelOuter = bvNone
    TabOrder = 2
    object stgTabelle: TStringGrid
      Left = 1
      Top = 16
      Width = 712
      Height = 209
      BorderStyle = bsNone
      ColCount = 7
      Ctl3D = False
      DefaultColWidth = 100
      DefaultRowHeight = 17
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      ParentCtl3D = False
      TabOrder = 0
    end
    object Button1: TButton
      Left = 1
      Top = 0
      Width = 102
      Height = 17
      Caption = 'Ressource'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 102
      Top = 0
      Width = 102
      Height = 17
      Caption = 'Menge'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 203
      Top = 0
      Width = 102
      Height = 17
      Caption = 'St'#252'ckpreis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 304
      Top = 0
      Width = 102
      Height = 17
      Caption = 'Venad'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = Button4Click
    end
    object Button7: TButton
      Left = 405
      Top = 0
      Width = 102
      Height = 17
      Caption = 'Clan'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 506
      Top = 0
      Width = 102
      Height = 17
      Caption = 'Endet am:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object Button6: TButton
      Left = 607
      Top = 0
      Width = 101
      Height = 17
      Caption = 'Endet in:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 424
    Width = 70
    Height = 17
    Caption = 'Energie'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 440
    Width = 70
    Height = 17
    Caption = 'Rekruten'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 456
    Width = 70
    Height = 17
    Caption = 'Erz'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBox4: TCheckBox
    Left = 88
    Top = 440
    Width = 120
    Height = 17
    Caption = 'synth. Verbindungen'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object CheckBox5: TCheckBox
    Left = 88
    Top = 424
    Width = 120
    Height = 17
    Caption = 'org. Verbindungen'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object CheckBox6: TCheckBox
    Left = 88
    Top = 456
    Width = 120
    Height = 17
    Caption = 'Eisenmetalle'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object CheckBox7: TCheckBox
    Left = 216
    Top = 424
    Width = 120
    Height = 17
    Caption = 'Leichtmetalle'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object CheckBox8: TCheckBox
    Left = 216
    Top = 440
    Width = 120
    Height = 17
    Caption = 'Schwermetalle'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object CheckBox9: TCheckBox
    Left = 216
    Top = 456
    Width = 120
    Height = 17
    Caption = 'Edelmetalle'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object CheckBox10: TCheckBox
    Left = 344
    Top = 424
    Width = 120
    Height = 17
    Caption = 'radioaktive Stoffe'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object CheckBox11: TCheckBox
    Left = 344
    Top = 440
    Width = 120
    Height = 17
    Caption = 'Edelsteine'
    Checked = True
    State = cbChecked
    TabOrder = 13
  end
  object CheckBox12: TCheckBox
    Left = 344
    Top = 456
    Width = 120
    Height = 17
    Caption = 'Edelgase'
    Checked = True
    State = cbChecked
    TabOrder = 14
  end
  object CheckBox13: TCheckBox
    Left = 472
    Top = 424
    Width = 120
    Height = 17
    Caption = 'instabile Isotope'
    Checked = True
    State = cbChecked
    TabOrder = 15
  end
end
