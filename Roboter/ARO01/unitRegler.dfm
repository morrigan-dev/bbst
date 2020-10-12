object frmReglerPanel: TfrmReglerPanel
  Left = 232
  Top = 192
  Width = 1059
  Height = 693
  Caption = 'ARO01 Simulation - Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
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
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsAuto
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
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      TickMarks = tmBottomRight
      TickStyle = tsAuto
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
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 2
      TickMarks = tmBottomRight
      TickStyle = tsAuto
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
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 3
      TickMarks = tmBottomRight
      TickStyle = tsAuto
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
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 4
      TickMarks = tmBottomRight
      TickStyle = tsAuto
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
      Orientation = trHorizontal
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 5
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = tbarServo6Change
      OnEnter = tbarServo6Enter
      OnExit = tbarServo6Exit
    end
  end
  object gboxEntwicklungseinstellungen: TGroupBox
    Left = 456
    Top = 8
    Width = 241
    Height = 129
    Caption = 'Demo:'
    TabOrder = 1
    object lblAnsicht: TLabel
      Left = 16
      Top = 26
      Width = 38
      Height = 13
      Caption = 'Ansicht:'
    end
    object Label1: TLabel
      Left = 16
      Top = 50
      Width = 50
      Height = 13
      Caption = 'Log Level:'
    end
    object cbStyle: TComboBox
      Left = 72
      Top = 24
      Width = 137
      Height = 21
      ItemHeight = 13
      ItemIndex = 3
      TabOrder = 0
      Text = 'Detailed - Full'
      OnChange = cbStyleChange
      Items.Strings = (
        'Simple - Grid'
        'Simple - Full'
        'Detailed - Grid'
        'Detailed - Full')
    end
    object btnDemo: TButton
      Left = 16
      Top = 88
      Width = 89
      Height = 25
      Caption = 'Demo &starten'
      TabOrder = 1
      OnClick = btnDemoClick
    end
    object cbLogLevel: TComboBox
      Left = 72
      Top = 48
      Width = 137
      Height = 21
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 2
      Text = 'Info'
      OnChange = cbLogLevelChange
      Items.Strings = (
        'Trace'
        'Debug'
        'Info'
        'Warn'
        'Error'
        'Fatal')
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
  object GroupBox1: TGroupBox
    Left = 312
    Top = 8
    Width = 137
    Height = 129
    Caption = 'Gr'#246#223'en:'
    TabOrder = 3
    object Label2: TLabel
      Left = 16
      Top = 51
      Width = 30
      Height = 13
      Caption = 'Breite:'
    end
    object Label3: TLabel
      Left = 16
      Top = 75
      Width = 29
      Height = 13
      Caption = 'H'#246'he:'
    end
    object Label4: TLabel
      Left = 16
      Top = 99
      Width = 24
      Height = 13
      Caption = 'Tiefe'
    end
    object edtWidth: TEdit
      Left = 56
      Top = 48
      Width = 65
      Height = 21
      TabOrder = 0
      OnExit = edtWidthExit
    end
    object edtHeight: TEdit
      Left = 56
      Top = 72
      Width = 65
      Height = 21
      TabOrder = 1
      OnExit = edtHeightExit
    end
    object edtDepth: TEdit
      Left = 56
      Top = 96
      Width = 65
      Height = 21
      TabOrder = 2
      OnExit = edtDepthExit
    end
    object cbElement: TComboBox
      Left = 8
      Top = 24
      Width = 113
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ItemIndex = 0
      ParentFont = False
      TabOrder = 3
      Text = 'Element 0'
      OnChange = cbElementChange
      Items.Strings = (
        'Element 0'
        'Element 1'
        'Element 2'
        'Element 3'
        'Element 4'
        'Servo 0'
        'Servo 1&2'
        'Servo 3'
        'Servo 4'
        'Servo 5'
        'Servo 6')
    end
  end
  object RoboterarmPanel1: TRoboterarmPanel
    Left = 312
    Top = 144
    Width = 721
    Height = 505
    Skin = DetailedFull
    BackgroundColor = clBtnFace
    Servo0.Color = 10518905
    Servo0.Depth = 100
    Servo0.Height = 5
    Servo0.Width = 100
    Servo0.AktPos = 50
    Servo0.HighlightColor = clRed
    Servo0.MaxGrad = 180
    Servo12.Color = 10518905
    Servo12.Depth = 35
    Servo12.Height = 35
    Servo12.Width = 35
    Servo12.AktPos = 100
    Servo12.HighlightColor = clRed
    Servo12.MaxGrad = 140
    Servo12.MinGrad = 30
    Servo3.Color = 10518905
    Servo3.Depth = 35
    Servo3.Height = 35
    Servo3.Width = 35
    Servo3.AktPos = 100
    Servo3.HighlightColor = clRed
    Servo3.MaxGrad = 150
    Servo3.MinGrad = 40
    Servo4.Color = 10518905
    Servo4.Depth = 35
    Servo4.Height = 35
    Servo4.Width = 35
    Servo4.AktPos = 10
    Servo4.HighlightColor = clRed
    Servo4.MaxGrad = 180
    Servo5.Color = 7303023
    Servo5.Depth = 70
    Servo5.Height = 35
    Servo5.Width = 35
    Servo5.AktPos = 50
    Servo5.HighlightColor = clRed
    Servo5.MaxGrad = 180
    Servo6.Color = 10518905
    Servo6.Depth = 7
    Servo6.Height = 30
    Servo6.Width = 7
    Servo6.AktPos = 50
    Servo6.HighlightColor = clRed
    Servo6.MaxGrad = 180
    Element0.Color = 10518905
    Element0.Depth = 100
    Element0.Height = 47
    Element0.Width = 100
    Element1.Color = 7303023
    Element1.Depth = 10
    Element1.Height = 92
    Element1.Width = 10
    Element2.Color = 10518905
    Element2.Depth = 10
    Element2.Height = 152
    Element2.Width = 10
    Element3.Color = 7303023
    Element3.Depth = 10
    Element3.Height = 33
    Element3.Width = 10
    Element4.Color = clSkyBlue
    Element4.Depth = 50
    Element4.Height = 3
    Element4.Width = 50
    Element5.Color = 10518905
    Element5.Depth = 100
    Element5.Height = 47
    Element5.Width = 100
  end
  object tmMoveDelay: TTimer
    Interval = 0
    OnTimer = tmMoveDelayTimer
    Left = 8
    Top = 544
  end
end
