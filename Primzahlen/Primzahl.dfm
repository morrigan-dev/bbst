object frmPrimzahlen: TfrmPrimzahlen
  Left = 271
  Top = 163
  Width = 337
  Height = 296
  Caption = 'Primzahlen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo1: TLabel
    Left = 8
    Top = 16
    Width = 313
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Berechnung von Primzahlen'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object lblPrimAnzahl: TLabel
    Left = 8
    Top = 61
    Width = 247
    Height = 13
    Caption = 'Anzahl der bereits berechneten Primzahlen:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cmdBerechne: TButton
    Left = 48
    Top = 232
    Width = 137
    Height = 25
    Caption = 'Berechnung &starten'
    TabOrder = 0
    OnClick = cmdBerechneClick
  end
  object lstPrimzahlen: TListBox
    Left = 8
    Top = 80
    Width = 313
    Height = 137
    ItemHeight = 13
    TabOrder = 1
  end
  object cmdUnterbrechung: TButton
    Left = 200
    Top = 232
    Width = 81
    Height = 25
    Caption = '&Pause'
    Enabled = False
    TabOrder = 2
    OnClick = cmdUnterbrechungClick
  end
  object Timer1: TTimer
    Interval = 0
    OnTimer = Timer1Timer
  end
end
