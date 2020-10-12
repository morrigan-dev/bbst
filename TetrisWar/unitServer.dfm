object frmTetrisWarServer: TfrmTetrisWarServer
  Left = 0
  Top = 0
  Caption = 'TetrisWar Server'
  ClientHeight = 407
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblServerIP: TLabel
    Left = 8
    Top = 40
    Width = 49
    Height = 13
    Caption = 'Server IP:'
  end
  object lblServerPort: TLabel
    Left = 8
    Top = 67
    Width = 59
    Height = 13
    Caption = 'Server Port:'
  end
  object lblSpieler: TLabel
    Left = 8
    Top = 125
    Width = 32
    Height = 13
    Caption = 'Spieler'
  end
  object lblServername: TLabel
    Left = 8
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Servername:'
  end
  object edtServerIP: TEdit
    Left = 73
    Top = 37
    Width = 160
    Height = 21
    TabOrder = 2
  end
  object edtServerPort: TEdit
    Left = 73
    Top = 64
    Width = 160
    Height = 21
    TabOrder = 1
    OnExit = edtServerPortExit
  end
  object lstSpieler: TListBox
    Left = 8
    Top = 144
    Width = 225
    Height = 224
    ItemHeight = 13
    TabOrder = 3
  end
  object btnServerStarten: TButton
    Left = 112
    Top = 91
    Width = 121
    Height = 25
    Caption = 'Server starten'
    TabOrder = 0
    OnClick = btnServerStartenClick
  end
  object edtServerName: TEdit
    Left = 73
    Top = 5
    Width = 160
    Height = 21
    TabOrder = 4
    Text = 'TetrisWar Server'
  end
  object mmoLog: TMemo
    Left = 248
    Top = 5
    Width = 294
    Height = 394
    TabOrder = 5
    Visible = False
  end
  object btLog: TButton
    Left = 112
    Top = 374
    Width = 121
    Height = 25
    Caption = 'Zeige Log >>'
    TabOrder = 6
    OnClick = btLogClick
  end
  object UDPServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    OnUDPRead = UDPServerUDPRead
    Left = 96
    Top = 120
  end
  object AliveTimer: TTimer
    Interval = 0
    OnTimer = AliveTimerTimer
    Left = 40
    Top = 120
  end
end
