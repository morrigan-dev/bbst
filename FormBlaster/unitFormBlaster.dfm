object frmFormBlaster: TfrmFormBlaster
  Left = 192
  Top = 107
  Width = 409
  Height = 600
  Caption = 'FormBlaster'
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
  object lblPunkte: TLabel
    Left = 184
    Top = 541
    Width = 201
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '0 '
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblLevel: TLabel
    Left = 8
    Top = 541
    Width = 177
    Height = 13
    AutoSize = False
    Caption = ' Level 0'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object pnlSpielfeld: TPanel
    Left = 8
    Top = 8
    Width = 377
    Height = 533
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 0
    object memoGameOver: TMemo
      Left = 24
      Top = 176
      Width = 337
      Height = 81
      Alignment = taCenter
      BorderStyle = bsNone
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'GAME OVER!'
        'Max. Punkte: 0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Visible = False
    end
  end
  object Timer1: TTimer
    Interval = 0
    OnTimer = Timer1Timer
    Left = 351
    Top = 16
  end
end
