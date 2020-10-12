object frmAnalyse: TfrmAnalyse
  Left = 2
  Top = 0
  Width = 638
  Height = 452
  Caption = 'Systemanalyse'
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
  object lblStatus1: TLabel
    Left = 392
    Top = 353
    Width = 46
    Height = 16
    AutoSize = False
    Caption = '0 %'
  end
  object lblStatus2: TLabel
    Left = 712
    Top = 353
    Width = 41
    Height = 16
    AutoSize = False
    Caption = '0 %'
  end
  object Label1: TLabel
    Left = 40
    Top = 402
    Width = 144
    Height = 13
    Caption = 'Anzahl der Zufallszahlen:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 40
    Top = 426
    Width = 142
    Height = 13
    Caption = 'Anzahl der Symbolzeilen:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 192
    Top = 426
    Width = 22
    Height = 13
    Caption = 'von'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 248
    Top = 426
    Width = 17
    Height = 13
    Caption = 'bis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDauer1: TLabel
    Left = 16
    Top = 368
    Width = 3
    Height = 13
  end
  object cmdAnalyse: TButton
    Left = 576
    Top = 416
    Width = 97
    Height = 25
    Caption = 'Analyse &starten'
    TabOrder = 0
    OnClick = cmdAnalyseClick
  end
  object lstAnalyse_Dutzend: TListBox
    Left = 448
    Top = 32
    Width = 305
    Height = 313
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object lstZufallszahlen: TListBox
    Left = 8
    Top = 8
    Width = 433
    Height = 337
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ItemHeight = 14
    Items.Strings = (
      'Zahl|Dutzend|Kolonne|1-19/20-36|Gerade/Ungerade|Farbe(r/s)')
    ParentFont = False
    TabOrder = 2
  end
  object txtZahlenAnzahl: TEdit
    Left = 192
    Top = 400
    Width = 113
    Height = 21
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 3
    Text = '10000'
  end
  object txtZeilenAnzahlStart: TEdit
    Left = 216
    Top = 424
    Width = 25
    Height = 21
    TabOrder = 4
    Text = '1'
  end
  object lstAnalyse_Kolonne: TListBox
    Left = 448
    Top = 32
    Width = 305
    Height = 313
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    TabOrder = 5
    Visible = False
  end
  object cmbAuswahl: TComboBox
    Left = 448
    Top = 8
    Width = 305
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = cmbAuswahlChange
    Items.Strings = (
      'Dutzend'
      'Kolonne'
      '1-19/20-36'
      'Gerade/Ungerade'
      'Farbe')
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 352
    Width = 369
    Height = 16
    BorderWidth = 1
    Smooth = True
    TabOrder = 7
  end
  object ProgressBar2: TProgressBar
    Left = 456
    Top = 352
    Width = 249
    Height = 16
    BorderWidth = 1
    Smooth = True
    TabOrder = 8
  end
  object ProgressBar3: TProgressBar
    Left = 456
    Top = 368
    Width = 249
    Height = 16
    BorderWidth = 1
    Smooth = True
    TabOrder = 9
  end
  object lstAnalyse_KleinGross: TListBox
    Left = 448
    Top = 32
    Width = 305
    Height = 313
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    TabOrder = 10
    Visible = False
  end
  object lstAnalyse_GeradeUngerade: TListBox
    Left = 448
    Top = 32
    Width = 305
    Height = 313
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    TabOrder = 11
    Visible = False
  end
  object lstAnalyse_Farbe: TListBox
    Left = 448
    Top = 32
    Width = 305
    Height = 313
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    TabOrder = 12
    Visible = False
  end
  object txtZeilenAnzahlEnde: TEdit
    Left = 272
    Top = 424
    Width = 25
    Height = 21
    TabOrder = 13
    Text = '5'
  end
  object Timer: TTimer
    Interval = 0
    OnTimer = TimerTimer
    Left = 688
    Top = 416
  end
end
