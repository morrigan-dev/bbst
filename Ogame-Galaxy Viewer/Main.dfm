object frmGalaxyViewer: TfrmGalaxyViewer
  Left = 406
  Top = 279
  Width = 571
  Height = 439
  Caption = 'Ogame-Galaxy Viewer'
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 32
    Width = 18
    Height = 13
    Caption = 'Pos'
  end
  object Label3: TLabel
    Left = 144
    Top = 32
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label4: TLabel
    Left = 216
    Top = 32
    Width = 27
    Height = 13
    Caption = 'Mond'
  end
  object Label5: TLabel
    Left = 272
    Top = 32
    Width = 32
    Height = 13
    Caption = 'Spieler'
  end
  object Label6: TLabel
    Left = 352
    Top = 32
    Width = 30
    Height = 13
    Caption = 'Allianz'
  end
  object Label7: TLabel
    Left = 48
    Top = 56
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Label2: TLabel
    Left = 424
    Top = 32
    Width = 77
    Height = 13
    Caption = 'Spionagebericht'
  end
  object DBNavigator1: TDBNavigator
    Left = 168
    Top = 336
    Width = 200
    Height = 18
    DataSource = DataSource1
    TabOrder = 0
  end
  object DBEdit1: TDBEdit
    Left = 120
    Top = 56
    Width = 89
    Height = 21
    BorderStyle = bsNone
    Color = clNavy
    DataField = 'Planetenname'
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 48
    Top = 144
    Width = 393
    Height = 97
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 2
  end
  object DBEdit2: TDBEdit
    Left = 216
    Top = 56
    Width = 25
    Height = 21
    BorderStyle = bsNone
    Color = clNavy
    DataField = 'Mond'
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object DBEdit3: TDBEdit
    Left = 248
    Top = 56
    Width = 89
    Height = 21
    BorderStyle = bsNone
    Color = clNavy
    DataField = 'Spielename'
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object DBEdit4: TDBEdit
    Left = 344
    Top = 56
    Width = 49
    Height = 21
    BorderStyle = bsNone
    Color = clNavy
    DataField = 'Allianz'
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object DBMemo1: TDBMemo
    Left = 424
    Top = 56
    Width = 129
    Height = 65
    DataField = 'Spionagebericht'
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object Button1: TButton
    Left = 80
    Top = 256
    Width = 97
    Height = 25
    Caption = 'Button1'
    TabOrder = 7
    OnClick = Button1Click
  end
  object DataSource1: TDataSource
    DataSet = tblGalaxy
    Left = 24
    Top = 328
  end
  object tblGalaxy: TTable
    TableName = 'galaxy.db'
    Left = 56
    Top = 328
  end
end
