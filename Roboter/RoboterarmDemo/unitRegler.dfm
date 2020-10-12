object frmReglerPanel: TfrmReglerPanel
  Left = 189
  Top = 122
  Width = 860
  Height = 719
  Caption = 'Regler Panel'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gboxServoEinstellungen: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 321
    Caption = 'Aktuelle Gradeinstellung der Servos:'
    TabOrder = 0
    object lblServo0: TLabel
      Left = 24
      Top = 24
      Width = 49
      Height = 13
      Caption = 'Servo 0:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo0Position: TLabel
      Left = 249
      Top = 24
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo12: TLabel
      Left = 24
      Top = 72
      Width = 71
      Height = 13
      Caption = 'Servo 1 && 2:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo12Position: TLabel
      Left = 249
      Top = 72
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo3: TLabel
      Left = 24
      Top = 120
      Width = 49
      Height = 13
      Caption = 'Servo 3:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo3Position: TLabel
      Left = 249
      Top = 120
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo4: TLabel
      Left = 24
      Top = 168
      Width = 49
      Height = 13
      Caption = 'Servo 4:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo4Position: TLabel
      Left = 249
      Top = 168
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo5: TLabel
      Left = 24
      Top = 216
      Width = 49
      Height = 13
      Caption = 'Servo 5:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo5Position: TLabel
      Left = 249
      Top = 216
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo6: TLabel
      Left = 24
      Top = 264
      Width = 49
      Height = 13
      Caption = 'Servo 6:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblServo6Position: TLabel
      Left = 249
      Top = 264
      Width = 21
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object tbarServo0: TTrackBar
      Left = 16
      Top = 40
      Width = 265
      Height = 33
      Max = 100
      TabOrder = 0
      OnChange = tbarServo0Change
      OnEnter = tbarServo0Enter
      OnExit = tbarServo0Exit
    end
    object tbarServo12: TTrackBar
      Left = 16
      Top = 88
      Width = 265
      Height = 33
      Max = 100
      TabOrder = 1
      OnChange = tbarServo12Change
      OnEnter = tbarServo12Enter
      OnExit = tbarServo12Exit
    end
    object tbarServo3: TTrackBar
      Left = 16
      Top = 136
      Width = 265
      Height = 33
      Max = 100
      TabOrder = 2
      OnChange = tbarServo3Change
      OnEnter = tbarServo3Enter
      OnExit = tbarServo3Exit
    end
    object tbarServo4: TTrackBar
      Left = 16
      Top = 184
      Width = 265
      Height = 33
      Max = 100
      TabOrder = 3
      OnChange = tbarServo4Change
      OnEnter = tbarServo4Enter
      OnExit = tbarServo4Exit
    end
    object tbarServo5: TTrackBar
      Left = 16
      Top = 232
      Width = 265
      Height = 33
      Max = 100
      TabOrder = 4
      OnChange = tbarServo5Change
      OnEnter = tbarServo5Enter
      OnExit = tbarServo5Exit
    end
    object tbarServo6: TTrackBar
      Left = 16
      Top = 280
      Width = 265
      Height = 33
      Max = 100
      TabOrder = 5
      OnChange = tbarServo6Change
      OnEnter = tbarServo6Enter
      OnExit = tbarServo6Exit
    end
  end
  object gboxEntwicklungseinstellungen: TGroupBox
    Left = 8
    Top = 544
    Width = 297
    Height = 129
    Caption = 'Entwicklungseinstellungen:'
    TabOrder = 1
    object chkShowGeoMittelpunkt: TCheckBox
      Left = 16
      Top = 48
      Width = 209
      Height = 17
      Caption = 'Zeige geometrischen Objektmittelpunkt'
      TabOrder = 0
      OnClick = chkShowGeoMittelpunktClick
    end
    object chkShowKoordinatensystem: TCheckBox
      Left = 16
      Top = 24
      Width = 209
      Height = 17
      Caption = 'Zeige Koordinatensystem'
      TabOrder = 1
      OnClick = chkShowKoordinatensystemClick
    end
    object chkShowRotationsmarkierung: TCheckBox
      Left = 16
      Top = 72
      Width = 209
      Height = 17
      Caption = 'Zeige Rotationsmarkierung'
      TabOrder = 2
      OnClick = chkShowRotationsmarkierungClick
    end
    object chkDeaktiviereTexturen: TCheckBox
      Left = 16
      Top = 96
      Width = 209
      Height = 17
      Caption = 'Deaktiviere Texturen'
      TabOrder = 3
      OnClick = chkDeaktiviereTexturenClick
    end
  end
  object gboxMinMaxGrad: TGroupBox
    Left = 8
    Top = 336
    Width = 297
    Height = 201
    Caption = 'Min. und max. Gradwerte der Servos:'
    TabOrder = 2
    object lblServo0Grad: TLabel
      Left = 8
      Top = 48
      Width = 49
      Height = 13
      Caption = 'Servo 0:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMinimalerGradwert: TLabel
      Left = 80
      Top = 24
      Width = 90
      Height = 13
      Caption = 'Minimaler Gradwert'
    end
    object lblMaximalerGradwert: TLabel
      Left = 192
      Top = 24
      Width = 93
      Height = 13
      Caption = 'Maximaler Gradwert'
    end
    object lblBis0: TLabel
      Left = 176
      Top = 48
      Width = 13
      Height = 13
      Caption = 'bis'
    end
    object lblBis12: TLabel
      Left = 176
      Top = 72
      Width = 13
      Height = 13
      Caption = 'bis'
    end
    object lblServo12Grad: TLabel
      Left = 8
      Top = 72
      Width = 71
      Height = 13
      Caption = 'Servo 1 && 2:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBis3: TLabel
      Left = 176
      Top = 96
      Width = 13
      Height = 13
      Caption = 'bis'
    end
    object lblServo3Grad: TLabel
      Left = 8
      Top = 96
      Width = 49
      Height = 13
      Caption = 'Servo 3:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBis4: TLabel
      Left = 176
      Top = 120
      Width = 13
      Height = 13
      Caption = 'bis'
    end
    object lblServo4Grad: TLabel
      Left = 8
      Top = 120
      Width = 49
      Height = 13
      Caption = 'Servo 4:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBis5: TLabel
      Left = 176
      Top = 144
      Width = 13
      Height = 13
      Caption = 'bis'
    end
    object lblServo5Grad: TLabel
      Left = 8
      Top = 144
      Width = 49
      Height = 13
      Caption = 'Servo 5:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBis6: TLabel
      Left = 176
      Top = 168
      Width = 13
      Height = 13
      Caption = 'bis'
    end
    object lblServo6Grad: TLabel
      Left = 8
      Top = 168
      Width = 49
      Height = 13
      Caption = 'Servo 6:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtServo0MinGrad: TEdit
      Left = 88
      Top = 45
      Width = 65
      Height = 21
      TabOrder = 0
      OnChange = edtServo0MinGradChange
    end
    object edtServo0MaxGrad: TEdit
      Left = 208
      Top = 45
      Width = 65
      Height = 21
      TabOrder = 1
      OnChange = edtServo0MaxGradChange
    end
    object edtServo12MaxGrad: TEdit
      Left = 208
      Top = 69
      Width = 65
      Height = 21
      TabOrder = 2
      OnChange = edtServo12MaxGradChange
    end
    object edtServo12MinGrad: TEdit
      Left = 88
      Top = 69
      Width = 65
      Height = 21
      TabOrder = 3
      OnChange = edtServo12MinGradChange
    end
    object edtServo3MaxGrad: TEdit
      Left = 208
      Top = 93
      Width = 65
      Height = 21
      TabOrder = 4
      OnChange = edtServo3MaxGradChange
    end
    object edtServo3MinGrad: TEdit
      Left = 88
      Top = 93
      Width = 65
      Height = 21
      TabOrder = 5
      OnChange = edtServo3MinGradChange
    end
    object edtServo4MaxGrad: TEdit
      Left = 208
      Top = 117
      Width = 65
      Height = 21
      TabOrder = 6
      OnChange = edtServo4MaxGradChange
    end
    object edtServo4MinGrad: TEdit
      Left = 88
      Top = 117
      Width = 65
      Height = 21
      TabOrder = 7
      OnChange = edtServo4MinGradChange
    end
    object edtServo5MaxGrad: TEdit
      Left = 208
      Top = 141
      Width = 65
      Height = 21
      TabOrder = 8
      OnChange = edtServo5MaxGradChange
    end
    object edtServo5MinGrad: TEdit
      Left = 88
      Top = 141
      Width = 65
      Height = 21
      TabOrder = 9
      OnChange = edtServo5MinGradChange
    end
    object edtServo6MaxGrad: TEdit
      Left = 208
      Top = 165
      Width = 65
      Height = 21
      TabOrder = 10
      OnChange = edtServo6MaxGradChange
    end
    object edtServo6MinGrad: TEdit
      Left = 88
      Top = 165
      Width = 65
      Height = 21
      TabOrder = 11
      OnChange = edtServo6MinGradChange
    end
  end
  object RoboterarmPanel1: TRoboterarmPanel
    Left = 320
    Top = 16
    Width = 0
    Height = 0
    Servo0.Color = 52224
    Servo0.Depth = 9.000000000000000000
    Servo0.Height = 0.300000000000000000
    Servo0.Width = 9.000000000000000000
    Servo0.AktPos = 50.000000000000000000
    Servo0.HighlightColor = clRed
    Servo0.MaxGrad = 180.000000000000000000
    Servo12.Color = 52224
    Servo12.Depth = 6.500000000000000000
    Servo12.Height = 1.500000000000000000
    Servo12.Width = 1.500000000000000000
    Servo12.AktPos = 100.000000000000000000
    Servo12.HighlightColor = clRed
    Servo12.MaxGrad = 140.000000000000000000
    Servo12.MinGrad = 30.000000000000000000
    Servo3.Color = 52224
    Servo3.Depth = 6.500000000000000000
    Servo3.Height = 1.500000000000000000
    Servo3.Width = 1.500000000000000000
    Servo3.AktPos = 100.000000000000000000
    Servo3.HighlightColor = clRed
    Servo3.MaxGrad = 150.000000000000000000
    Servo3.MinGrad = 40.000000000000000000
    Servo4.Color = 52224
    Servo4.Depth = 6.500000000000000000
    Servo4.Height = 1.500000000000000000
    Servo4.Width = 1.500000000000000000
    Servo4.AktPos = 50.000000000000000000
    Servo4.HighlightColor = clRed
    Servo4.MaxGrad = 180.000000000000000000
    Servo5.Color = 52224
    Servo5.Depth = 3.000000000000000000
    Servo5.Height = 0.300000000000000000
    Servo5.Width = 3.000000000000000000
    Servo5.AktPos = 50.000000000000000000
    Servo5.HighlightColor = clRed
    Servo5.MaxGrad = 180.000000000000000000
    Servo6.Color = 52224
    Servo6.Depth = 0.500000000000000000
    Servo6.Height = 3.000000000000000000
    Servo6.Width = 6.000000000000000000
    Servo6.HighlightColor = clRed
    Servo6.MaxGrad = 180.000000000000000000
    Servo7.Color = 52224
    Servo7.Depth = 0.500000000000000000
    Servo7.Height = 3.000000000000000000
    Servo7.Width = 6.000000000000000000
    Servo7.HighlightColor = clRed
    Servo7.MaxGrad = 180.000000000000000000
    Element0.Color = clBlack
    Element0.Depth = 9.000000000000000000
    Element0.Height = 5.000000000000000000
    Element0.Width = 9.000000000000000000
    Element1.Color = clBlack
    Element1.Depth = 5.000000000000000000
    Element1.Height = 13.000000000000000000
    Element1.Width = 1.500000000000000000
    Element2.Color = clBlack
    Element2.Depth = 2.000000000000000000
    Element2.Height = 10.000000000000000000
    Element2.Width = 1.500000000000000000
    Element3.Color = clBlack
    Element3.Depth = 5.000000000000000000
    Element3.Height = 3.000000000000000000
    Element3.Width = 6.000000000000000000
    Element4.Color = clBlack
    Element4.Depth = 0.500000000000000000
    Element4.Height = 3.000000000000000000
    Element4.Width = 6.000000000000000000
    Element5.Color = 52224
  end
  object Timer1: TTimer
    Interval = 0
    OnTimer = Timer1Timer
    Left = 312
    Top = 504
  end
end
