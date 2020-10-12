object frmBaumDemo: TfrmBaumDemo
  Left = 519
  Top = 282
  Width = 394
  Height = 431
  Caption = 'Baum Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
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
    Height = 273
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
    Top = 360
    Width = 113
    Height = 25
    Caption = 'Close'
    TabOrder = 8
    OnClick = btnCloseClick
  end
  object btnPaint: TButton
    Left = 128
    Top = 360
    Width = 113
    Height = 25
    Caption = 'Paint'
    Enabled = False
    TabOrder = 9
  end
  object btnDel: TButton
    Left = 248
    Top = 360
    Width = 113
    Height = 25
    Caption = 'Del'
    Enabled = False
    TabOrder = 10
  end
  object gbxInfoBox: TGroupBox
    Left = 232
    Top = 216
    Width = 137
    Height = 129
    Caption = 'Infobox:'
    TabOrder = 11
    object lblActionMsg: TLabel
      Left = 8
      Top = 16
      Width = 121
      Height = 105
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
    Top = 184
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    Sorted = True
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
end
