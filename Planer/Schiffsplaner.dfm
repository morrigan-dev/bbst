object frmPlaner: TfrmPlaner
  Left = 0
  Top = 72
  Width = 1211
  Height = 657
  Caption = 'Schiffsplaner'
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
    Top = 560
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 192
    Top = 56
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 8
    Top = 600
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object maxModuls: TLabeledEdit
    Left = 8
    Top = 16
    Width = 65
    Height = 21
    EditLabel.Width = 60
    EditLabel.Height = 13
    EditLabel.Caption = 'max. Module'
    TabOrder = 1
    Text = '20'
  end
  object techlevel: TLabeledEdit
    Left = 80
    Top = 16
    Width = 49
    Height = 21
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = 'Techlevel:'
    TabOrder = 2
    Text = '11'
  end
  object kommando: TLabeledEdit
    Left = 136
    Top = 16
    Width = 89
    Height = 21
    EditLabel.Width = 89
    EditLabel.Height = 13
    EditLabel.Caption = 'Kommandopunkte:'
    TabOrder = 3
    Text = '60'
  end
  object angriffswert: TLabeledEdit
    Left = 232
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 58
    EditLabel.Height = 13
    EditLabel.Caption = 'Angriffswert:'
    TabOrder = 4
    Text = '0'
  end
  object schilde: TLabeledEdit
    Left = 296
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 38
    EditLabel.Height = 13
    EditLabel.Caption = 'Schilde:'
    TabOrder = 5
    Text = '0'
  end
  object panzer: TLabeledEdit
    Left = 360
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 54
    EditLabel.Height = 13
    EditLabel.Caption = 'Panzerung:'
    TabOrder = 6
    Text = '0'
  end
  object struktur: TLabeledEdit
    Left = 424
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 40
    EditLabel.Height = 13
    EditLabel.Caption = 'Struktur:'
    TabOrder = 7
    Text = '0'
  end
  object wendigkeit: TLabeledEdit
    Left = 488
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 57
    EditLabel.Height = 13
    EditLabel.Caption = 'Wendigkeit:'
    TabOrder = 8
    Text = '0'
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 576
    Width = 953
    Height = 16
    Smooth = True
    TabOrder = 16
  end
  object ListBox1: TListBox
    Left = 192
    Top = 72
    Width = 761
    Height = 481
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Serif'
    Font.Style = []
    ItemHeight = 11
    ParentFont = False
    TabOrder = 17
    OnClick = ListBox1Click
  end
  object ListBox2: TListBox
    Left = 960
    Top = 72
    Width = 233
    Height = 481
    ItemHeight = 13
    TabOrder = 18
  end
  object Button2: TButton
    Left = 88
    Top = 600
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 19
    OnClick = Button2Click
  end
  object Reaktor: TLabeledEdit
    Left = 552
    Top = 16
    Width = 41
    Height = 21
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'Reaktor:'
    TabOrder = 9
    Text = '0'
  end
  object Laderaum: TLabeledEdit
    Left = 600
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = 'Laderaum:'
    TabOrder = 10
    Text = '0'
  end
  object SektorSprung: TLabeledEdit
    Left = 752
    Top = 16
    Width = 65
    Height = 21
    EditLabel.Width = 68
    EditLabel.Height = 13
    EditLabel.Caption = 'SektorSprung:'
    TabOrder = 13
    Text = '0'
  end
  object stop: TCheckBox
    Left = 176
    Top = 600
    Width = 97
    Height = 17
    Caption = 'Stop'
    TabOrder = 20
  end
  object angriffszeit: TLabeledEdit
    Left = 824
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 54
    EditLabel.Height = 13
    EditLabel.Caption = 'Angriffszeit:'
    TabOrder = 14
    Text = '0'
  end
  object Sprungzeit: TLabeledEdit
    Left = 888
    Top = 16
    Width = 57
    Height = 21
    EditLabel.Width = 53
    EditLabel.Height = 13
    EditLabel.Caption = 'Sprungzeit:'
    TabOrder = 15
    Text = '0'
  end
  object Sensor: TLabeledEdit
    Left = 664
    Top = 16
    Width = 33
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = 'Sensor:'
    TabOrder = 11
    Text = '0'
  end
  object Tarnung: TLabeledEdit
    Left = 704
    Top = 16
    Width = 41
    Height = 21
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'Tarnung:'
    TabOrder = 12
    Text = '0'
  end
  object Rumpf: TComboBox
    Left = 712
    Top = 48
    Width = 121
    Height = 21
    ItemHeight = 13
    TabOrder = 21
    OnChange = RumpfChange
    Items.Strings = (
      'Korvette'
      'Fregatte'
      'Frachtschiff'
      'Tanker'
      'Zerst'#246'rer'
      'Versorgungsschiff'
      'Waffenplattform'
      'Kreuzer'
      '')
  end
  object Klasse: TComboBox
    Left = 840
    Top = 48
    Width = 113
    Height = 21
    ItemHeight = 13
    TabOrder = 22
    Text = 'Klasse'
    OnChange = KlasseChange
  end
  object Forschungen: TComboBox
    Left = 8
    Top = 48
    Width = 177
    Height = 21
    ItemHeight = 13
    TabOrder = 23
    Text = 'Forschungen'
    OnChange = ForschungenChange
    Items.Strings = (
      'alle'
      'keine')
  end
  object Button3: TButton
    Left = 1008
    Top = 556
    Width = 147
    Height = 14
    Caption = 'save'
    TabOrder = 24
    OnClick = Button3Click
  end
  object IsoKosten: TLabeledEdit
    Left = 952
    Top = 16
    Width = 33
    Height = 21
    EditLabel.Width = 22
    EditLabel.Height = 13
    EditLabel.Caption = 'Isos:'
    TabOrder = 25
    Text = '0'
  end
end
