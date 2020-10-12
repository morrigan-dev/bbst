object Form1: TForm1
  Left = 666
  Top = 241
  Width = 296
  Height = 147
  Caption = 'Login'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 0
    Width = 149
    Height = 33
    Caption = 'Auto-Login'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Image1: TImage
    Left = 96
    Top = 96
    Width = 80
    Height = 12
    Picture.Data = {
      07544269746D61703E020000424D3E0200000000000036000000280000000D00
      00000D000000010018000000000008020000120B0000120B0000000000000000
      000000000000000000000000FF0000FF0000000000000000FF0000FF0000FF00
      00FF0000FF0000FF000000000000000000000000FF0000FF0000FF0000FF0000
      FF0000FF0000FF0000FF0000FF0000FF000000000000000000000000FF0000FF
      0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000000000000000
      00000000FF0000FF0000000000000000000000000000000000000000FF0000FF
      000000000000000000000000FF0000FF00000000000000000000000000000000
      00000000FF0000FF000000000000000000000000FF0000FF0000000000000000
      000000000000000000000000FF0000FF000000000000000000000000FF0000FF
      0000000000000000000000000000000000000000FF0000FF0000000000000000
      00000000FF0000FF0000000000000000000000000000000000000000FF0000FF
      000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
      00FF0000FF0000FF000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
      000000FF0000FF0000FF0000FF0000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000}
    Visible = False
  end
  object btnStartStop: TButton
    Left = 120
    Top = 56
    Width = 49
    Height = 25
    Caption = '&starten'
    TabOrder = 0
    Visible = False
    OnClick = btnStartStopClick
  end
  object ListBox1: TListBox
    Left = 176
    Top = 0
    Width = 105
    Height = 81
    ItemHeight = 13
    TabOrder = 1
    Visible = False
  end
  object Memo1: TMemo
    Left = 0
    Top = 32
    Width = 113
    Height = 49
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
    Visible = False
  end
  object Edit1: TEdit
    Left = 112
    Top = 32
    Width = 65
    Height = 21
    TabOrder = 3
    Text = '7,9'
    Visible = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 64
    Top = 80
  end
  object OpenDialog: TOpenDialog
    Left = 32
    Top = 80
  end
  object SaveDialog: TSaveDialog
    Top = 80
  end
end
