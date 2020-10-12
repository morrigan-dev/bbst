object frmBaumDemo: TfrmBaumDemo
  Left = 309
  Top = 176
  Width = 1031
  Height = 678
  Caption = 'Baum Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object lblInput: TLabel
    Left = 8
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Eingabe:'
  end
  object lblOutput: TLabel
    Left = 8
    Top = 56
    Width = 45
    Height = 13
    Caption = 'Ausgabe:'
  end
  object lblAuthor: TLabel
    Left = 241
    Top = 622
    Width = 125
    Height = 11
    Caption = '(c) 2010 Thomas Gattinger'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Courier New'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object edtInput: TEdit
    Left = 8
    Top = 24
    Width = 217
    Height = 21
    TabOrder = 0
    OnKeyUp = edtInputKeyUp
  end
  object lbxOutput: TListBox
    Left = 8
    Top = 72
    Width = 217
    Height = 169
    TabStop = False
    ItemHeight = 13
    TabOrder = 1
  end
  object btnNewRoot: TButton
    Left = 248
    Top = 24
    Width = 113
    Height = 25
    Caption = 'New Root'
    TabOrder = 2
    OnClick = btnNewRootClick
  end
  object btnNewElement: TButton
    Left = 248
    Top = 56
    Width = 113
    Height = 25
    Caption = 'New Element'
    TabOrder = 3
    OnClick = btnNewElementClick
  end
  object btnInorder: TButton
    Left = 248
    Top = 88
    Width = 113
    Height = 25
    Caption = 'Inorder'
    TabOrder = 4
    OnClick = btnInorderClick
  end
  object btnPreorder: TButton
    Left = 248
    Top = 120
    Width = 113
    Height = 25
    Caption = 'Preorder'
    TabOrder = 5
    OnClick = btnPreorderClick
  end
  object btnPostorder: TButton
    Left = 248
    Top = 152
    Width = 113
    Height = 25
    Caption = 'Postorder'
    TabOrder = 6
    OnClick = btnPostorderClick
  end
  object btnClose: TButton
    Left = 8
    Top = 592
    Width = 113
    Height = 25
    Caption = 'Close'
    TabOrder = 8
    OnClick = btnCloseClick
  end
  object btnPaint: TButton
    Left = 128
    Top = 592
    Width = 113
    Height = 25
    Caption = 'Paint'
    TabOrder = 9
    OnClick = btnPaintClick
  end
  object btnDel: TButton
    Left = 248
    Top = 592
    Width = 113
    Height = 25
    Caption = 'Del'
    TabOrder = 10
    OnClick = btnDelClick
  end
  object gbxInfoBox: TGroupBox
    Left = 8
    Top = 496
    Width = 361
    Height = 81
    Caption = 'Infobox:'
    TabOrder = 11
    object lblActionMsg: TLabel
      Left = 8
      Top = 16
      Width = 345
      Height = 57
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
  object cbLanguage: TComboBox
    Left = 248
    Top = 192
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 7
    Text = 'Deutsch'
    OnChange = cbLanguageChange
    Items.Strings = (
      'Deutsch'
      'English')
  end
  object btnClear: TButton
    Left = 184
    Top = 56
    Width = 41
    Height = 17
    Caption = 'Clear'
    TabOrder = 12
    OnClick = btnClearClick
  end
  object gbxTestmode: TGroupBox
    Left = 232
    Top = 360
    Width = 137
    Height = 129
    Caption = 'Testmodus:'
    TabOrder = 13
    object lblTestModeSpeed: TLabel
      Left = 12
      Top = 48
      Width = 78
      Height = 13
      Caption = 'Geschwindigkeit'
    end
    object lblCount: TLabel
      Left = 12
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Anzahl'
    end
    object trbTestModeSpeed: TTrackBar
      Left = 1
      Top = 64
      Width = 128
      Height = 25
      Orientation = trHorizontal
      Frequency = 1
      Position = 10
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = trbTestModeSpeedChange
    end
    object edtCount: TEdit
      Left = 56
      Top = 21
      Width = 65
      Height = 21
      TabOrder = 1
      Text = '50'
    end
    object btnMemTest: TButton
      Left = 6
      Top = 96
      Width = 115
      Height = 25
      Caption = 'Speichertest'
      TabOrder = 2
      OnClick = btnMemTestClick
    end
  end
  object gbxPaintConfig: TGroupBox
    Left = 8
    Top = 248
    Width = 217
    Height = 241
    Caption = 'Grafikeinstellungen:'
    TabOrder = 14
    object lblLineSize: TLabel
      Left = 8
      Top = 24
      Width = 57
      Height = 13
      Caption = 'Liniendicke:'
    end
    object lblFontStyle: TLabel
      Left = 8
      Top = 56
      Width = 50
      Height = 13
      Caption = 'Schrift Stil:'
    end
    object lblNodeColor: TLabel
      Left = 8
      Top = 152
      Width = 85
      Height = 13
      Caption = 'Farbe der Knoten:'
    end
    object lblBackgroundColor: TLabel
      Left = 8
      Top = 184
      Width = 82
      Height = 13
      Caption = 'Hintergrundfarbe:'
    end
    object lblNodeRadius: TLabel
      Left = 8
      Top = 88
      Width = 91
      Height = 13
      Caption = 'Radius der Knoten:'
    end
    object lblDelay: TLabel
      Left = 8
      Top = 120
      Width = 113
      Height = 13
      Caption = 'Delay f'#252'r Markierungen:'
    end
    object lblMillisec: TLabel
      Left = 176
      Top = 120
      Width = 25
      Height = 13
      Caption = 'msek'
    end
    object lblShowPath: TLabel
      Left = 8
      Top = 216
      Width = 55
      Height = 13
      Caption = 'Zeige Pfad:'
    end
    object edtLineSize: TEdit
      Left = 128
      Top = 21
      Width = 17
      Height = 21
      MaxLength = 1
      TabOrder = 0
      Text = '1'
      OnChange = edtLineSizeChange
    end
    object cbFontStyle: TComboBox
      Left = 128
      Top = 53
      Width = 80
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'normal'
      OnChange = cbFontStyleChange
      Items.Strings = (
        'normal'
        'fett'
        'kursiv'
        'fett & kursiv')
    end
    object btnNodeColorChoose: TButton
      Left = 128
      Top = 147
      Width = 75
      Height = 25
      Caption = 'w'#228'hlen...'
      TabOrder = 2
      OnClick = btnNodeColorChooseClick
    end
    object btnBackgroundChoose: TButton
      Left = 128
      Top = 179
      Width = 75
      Height = 25
      Caption = 'w'#228'hlen...'
      TabOrder = 3
      OnClick = btnBackgroundChooseClick
    end
    object edtNodeRadius: TEdit
      Left = 128
      Top = 85
      Width = 25
      Height = 21
      MaxLength = 2
      TabOrder = 4
      Text = '15'
      OnChange = edtNodeRadiusChange
    end
    object edtDelay: TEdit
      Left = 128
      Top = 117
      Width = 41
      Height = 21
      MaxLength = 5
      TabOrder = 5
      Text = '500'
      OnChange = edtDelayChange
    end
    object chbShowPath: TCheckBox
      Left = 128
      Top = 216
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = chbShowPathClick
    end
  end
  object randomTester: TTimer
    Interval = 0
    OnTimer = randomTesterTimer
  end
  object colorDialog: TColorDialog
    Ctl3D = True
    Left = 32
  end
end
