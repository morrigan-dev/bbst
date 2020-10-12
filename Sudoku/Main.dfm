object frmSudoku: TfrmSudoku
  Left = 278
  Top = 260
  Width = 474
  Height = 277
  Caption = 'Sudoku Analyse'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object stgFeld: TStringGrid
    Left = 8
    Top = 8
    Width = 281
    Height = 233
    BorderStyle = bsNone
    ColCount = 9
    Ctl3D = False
    FixedCols = 0
    RowCount = 9
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 0
  end
  object btnBerechnen: TButton
    Left = 312
    Top = 16
    Width = 129
    Height = 25
    Caption = '&Berechnen'
    TabOrder = 1
    OnClick = btnBerechnenClick
  end
  object btnLaden: TButton
    Left = 304
    Top = 192
    Width = 137
    Height = 25
    Caption = 'Laden'
    TabOrder = 2
    OnClick = btnLadenClick
  end
end
