object frmNiobAP: TfrmNiobAP
  Left = 256
  Top = 280
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'NIOB~AutoPilot'
  ClientHeight = 250
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object gpbSpielerEinladen: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 233
    Caption = 'Spieler einladen:'
    TabOrder = 0
    Visible = False
    object Label1: TLabel
      Left = 208
      Top = 32
      Width = 161
      Height = 17
      AutoSize = False
      Caption = 'Spielername:'
    end
    object Label2: TLabel
      Left = 208
      Top = 88
      Width = 44
      Height = 13
      Caption = 'ShortCut:'
    end
    object lstSpieler: TListBox
      Left = 16
      Top = 24
      Width = 177
      Height = 177
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstSpielerClick
    end
    object edtSpielername: TEdit
      Left = 208
      Top = 48
      Width = 161
      Height = 21
      TabOrder = 1
    end
    object edtShortcut: TEdit
      Left = 208
      Top = 104
      Width = 161
      Height = 21
      TabOrder = 2
    end
    object btnNew: TButton
      Left = 16
      Top = 208
      Width = 177
      Height = 17
      Caption = '&Neuen Eintrag'
      TabOrder = 3
      OnClick = btnNewClick
    end
    object btnEdit: TButton
      Left = 240
      Top = 144
      Width = 97
      Height = 25
      Caption = '&Bearbeiten'
      TabOrder = 4
      OnClick = btnEditClick
    end
    object btnOK: TButton
      Left = 240
      Top = 176
      Width = 97
      Height = 25
      Caption = '&OK'
      TabOrder = 5
      OnClick = btnOKClick
    end
  end
  object gpbAutoChat: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 233
    Caption = 'AutoChat Einstellungen:'
    TabOrder = 1
    Visible = False
    object Label3: TLabel
      Left = 16
      Top = 26
      Width = 59
      Height = 13
      Hint = 'Wartezeit zwischen den einzelnen Nachrichten.'
      Caption = 'Wartedauer:'
    end
    object Label4: TLabel
      Left = 120
      Top = 26
      Width = 38
      Height = 13
      Caption = 'Minuten'
    end
    object edtWartedauer: TEdit
      Left = 88
      Top = 24
      Width = 25
      Height = 21
      Hint = 'Wartezeit zwischen den einzelnen Nachrichten.'
      MaxLength = 2
      TabOrder = 0
      Text = '7'
    end
    object btnOK2: TButton
      Left = 272
      Top = 200
      Width = 97
      Height = 25
      Caption = '&OK'
      TabOrder = 1
      OnClick = btnOK2Click
    end
    object ckbAutoChat: TCheckBox
      Left = 16
      Top = 56
      Width = 121
      Height = 17
      Caption = 'AutoChatt aktivieren'
      TabOrder = 2
    end
  end
  object MainMenu: TMainMenu
    object mmuAP: TMenuItem
      Caption = '&AutoPilot'
      object smuStarten: TMenuItem
        Caption = '&starten'
        ShortCut = 49235
        OnClick = smuStartenClick
      end
      object smuStoppen: TMenuItem
        Caption = 'sto&ppen'
        Enabled = False
        ShortCut = 49232
        OnClick = smuStoppenClick
      end
      object smuBeenden: TMenuItem
        Caption = '&beenden'
        ShortCut = 49218
        OnClick = smuBeendenClick
      end
    end
    object mmuEinstellungen: TMenuItem
      Caption = '&Einstellungen'
      object smuAutoChat: TMenuItem
        Caption = 'Auto&Chat'
        OnClick = smuAutoChatClick
      end
      object smuSpielerEinladen: TMenuItem
        Caption = '&Spieler ein&laden'
        OnClick = smuSpielerEinladenClick
      end
    end
    object mmuHilfe: TMenuItem
      Caption = '&Hilfe'
      object smuInfo: TMenuItem
        Caption = 'I&nfo'
      end
      object smuLine1: TMenuItem
        Caption = '-'
      end
      object smuHilfe: TMenuItem
        Caption = '&Hilfe'
        ShortCut = 112
      end
    end
  end
  object Timer: TTimer
    Interval = 0
    OnTimer = TimerTimer
    Left = 32
  end
end
