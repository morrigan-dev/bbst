object frmGUI: TfrmGUI
  Left = 375
  Top = 297
  Width = 625
  Height = 416
  Caption = 'GUI Ueung'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo: TLabel
    Left = 24
    Top = 88
    Width = 569
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Alle Buttons ver'#228'ndern die Eigenschaft des Edit-Feldes'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object edtEingabe: TEdit
    Left = 24
    Top = 24
    Width = 329
    Height = 21
    TabOrder = 0
  end
  object btnAendereTitel: TButton
    Left = 384
    Top = 24
    Width = 209
    Height = 25
    Caption = 'Titel '#228'ndern'
    TabOrder = 1
    OnClick = btnAendereTitelClick
  end
  object gpbVisible: TGroupBox
    Left = 24
    Top = 136
    Width = 185
    Height = 105
    Caption = 'Visible'
    TabOrder = 2
    object btnVersteckeEingabe: TButton
      Left = 24
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Verstecke Eingabe'
      TabOrder = 0
      OnClick = btnVersteckeEingabeClick
    end
    object btnZeigeEingabe: TButton
      Left = 24
      Top = 56
      Width = 137
      Height = 25
      Caption = 'Zeige Eingabe'
      TabOrder = 1
      OnClick = btnZeigeEingabeClick
    end
  end
  object gpbEnable: TGroupBox
    Left = 216
    Top = 136
    Width = 185
    Height = 105
    Caption = 'Enable'
    TabOrder = 3
    object btnVerbieteEingabe: TButton
      Left = 24
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Verbiete Eingabe'
      TabOrder = 0
      OnClick = btnVerbieteEingabeClick
    end
    object btnErlaubeEingabe: TButton
      Left = 24
      Top = 56
      Width = 137
      Height = 25
      Caption = 'Erlaube Eingabe'
      TabOrder = 1
      OnClick = btnErlaubeEingabeClick
    end
  end
  object gpbFarbe: TGroupBox
    Left = 408
    Top = 136
    Width = 185
    Height = 105
    Caption = 'Farbe'
    TabOrder = 4
    object btnFaerbeRot: TButton
      Left = 24
      Top = 24
      Width = 137
      Height = 25
      Caption = 'F'#228'rbe rot'
      TabOrder = 0
      OnClick = btnFaerbeRotClick
    end
    object btnFaerbeWeiss: TButton
      Left = 24
      Top = 56
      Width = 137
      Height = 25
      Caption = 'F'#228'rbe wei'#223
      TabOrder = 1
      OnClick = btnFaerbeWeissClick
    end
  end
  object gpbWidth: TGroupBox
    Left = 24
    Top = 256
    Width = 185
    Height = 105
    Caption = 'Width'
    TabOrder = 5
    object btnBreiter: TButton
      Left = 24
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Breiter'
      TabOrder = 0
      OnClick = btnBreiterClick
    end
    object btnSchmaeler: TButton
      Left = 24
      Top = 56
      Width = 137
      Height = 25
      Caption = 'Schm'#228'ler'
      TabOrder = 1
      OnClick = btnSchmaelerClick
    end
  end
  object gpbHeight: TGroupBox
    Left = 216
    Top = 256
    Width = 185
    Height = 105
    Caption = 'Height'
    TabOrder = 6
    object btnGroesser: TButton
      Left = 24
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Gr'#246#223'er'
      TabOrder = 0
      OnClick = btnGroesserClick
    end
    object btnKleiner: TButton
      Left = 24
      Top = 56
      Width = 137
      Height = 25
      Caption = 'Kleiner'
      TabOrder = 1
      OnClick = btnKleinerClick
    end
  end
  object gpbFontColor: TGroupBox
    Left = 408
    Top = 256
    Width = 185
    Height = 105
    Caption = 'Font.Color'
    TabOrder = 7
    object btnSchriftGruen: TButton
      Left = 24
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Schrift gr'#252'n'
      TabOrder = 0
      OnClick = btnSchriftGruenClick
    end
    object btnSchriftSchwarz: TButton
      Left = 24
      Top = 56
      Width = 137
      Height = 25
      Caption = 'Schrift schwarz'
      TabOrder = 1
      OnClick = btnSchriftSchwarzClick
    end
  end
end
