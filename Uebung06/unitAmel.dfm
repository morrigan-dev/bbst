object Form1: TForm1
  Left = 633
  Top = 405
  Width = 156
  Height = 363
  Caption = 'Form1'
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
  object pnlAmpel: TPanel
    Left = 32
    Top = 8
    Width = 81
    Height = 225
    TabOrder = 0
    object shpRed: TShape
      Left = 8
      Top = 8
      Width = 65
      Height = 65
      Shape = stCircle
    end
    object shpYellow: TShape
      Left = 8
      Top = 80
      Width = 65
      Height = 65
      Shape = stCircle
    end
    object shpGreen: TShape
      Left = 8
      Top = 152
      Width = 65
      Height = 65
      Shape = stCircle
    end
  end
  object btnStart: TButton
    Left = 8
    Top = 240
    Width = 129
    Height = 25
    Caption = '&Start'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object btnStopp: TButton
    Left = 8
    Top = 272
    Width = 129
    Height = 25
    Caption = 'S&topp'
    TabOrder = 2
    OnClick = btnStoppClick
  end
  object btnProgrammende: TButton
    Left = 8
    Top = 304
    Width = 129
    Height = 25
    Caption = '&Programmende'
    TabOrder = 3
    OnClick = btnProgrammendeClick
  end
  object tmrSteuerung: TTimer
    Interval = 0
    OnTimer = tmrSteuerungTimer
    Left = 112
    Top = 8
  end
end
