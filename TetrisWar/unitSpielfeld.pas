unit unitSpielfeld;

interface

uses
  ExtCtrls, Classes, Controls, Graphics, Types, Dialogs, SysUtils, GraphUtil,

  unitTetrisTypes, unitFiguren, unitIObserver, unitColorUtil, unitSoundManager;

type
  TSpielfeld = class(TImage)
    private
      Rows         : Integer;
      Columns      : Integer;
      Gitter       : TGitter;
      CurrentFigur : TAbstractFigur;
      Timer        : TTimer;
      Speed        : Integer;
      Main         : IObserver;
      FastDownFlag : Boolean;
      FastDownAllowed : Boolean;
      FlippedFlag  : Boolean;
      OneBonusRows : Integer;
      TwoBonusRows : Integer;
      ThreeBonusRows : Integer;
      NextFigurIndex : Integer;
      Lines          : Integer;
      Punkte         : Integer;
      Level          : Integer;
      Stopped        : Boolean;
      SoundManager   : TSoundManager;

      procedure Paint();
      function GetPart(Color: TColor; ShowBorder: Boolean): TBitmap;
      procedure MoveObject(Sender: TObject);
      function CheckFullLines(): Boolean;
      procedure DeleteLines(ToDelete: TIntegerArray);
      function GetFigur(index: Integer): TAbstractFigur;
      procedure CheckLoose();
      procedure Reset();
    protected

    public
      constructor Create(Main: IObserver; AOwner: TComponent; Rows: Integer; Columns: Integer);
      destructor Destroy();
      procedure NewObject();
      procedure FlipObject();
      procedure Start();
      procedure Stop();
      procedure MoveLeft();
      procedure MoveRight();
      procedure FastDown();
      procedure StopFastDown();
      procedure StopFlipped();
      procedure AddRows(rows: Integer);
      procedure AddOneBonusRows();
      procedure AddTwoBonusRows();
      procedure AddThreeBonusRows();
      procedure ResetFastDownAllowed();
      function isFastDown(): Boolean;
      function isFlipped(): Boolean;
      function GetOneBonusRows(): Integer;
      function GetTwoBonusRows(): Integer;
      function GetThreeBonusRows(): Integer;
      function GetNextFigurImage(): TBitmap;
      function GetLinien(): Integer;
      function GetLevel(): Integer;
      function GetPunkte(): Integer;
      function GetLineHeight(): Byte;

  end;

implementation

const
  CELL_WIDTH   = 20;
  CELL_SPACING = 3;

constructor TSpielfeld.Create(Main: IObserver; AOwner: TComponent; Rows: Integer; Columns: Integer);
begin
  inherited Create(AOwner);

  Randomize;
  Self.Main         := Main;
  Self.Parent       := TWinControl(AOwner);
  Self.Rows         := Rows;
  Self.Columns      := Columns;
  Self.Width        := Columns * CELL_WIDTH + Columns * CELL_SPACING + CELL_SPACING;
  Self.Height       := Rows * CELL_WIDTH + Rows * CELL_SPACING + CELL_SPACING;
  with Self.Canvas do
  begin
    Brush.Color := clBlack;
    FillRect(ClipRect);
  end;
  Self.SoundManager := TSoundManager.Create(AOwner);
  SetLength(Self.Gitter, Self.Rows, Self.Columns);
  Timer := TTimer.Create(Self);
  Timer.OnTimer := MoveObject;
end;

destructor TSpielfeld.Destroy();
begin
  Self.SoundManager.Destroy();
end;

procedure TSpielfeld.ResetFastDownAllowed();
begin
  Self.FastDownAllowed := True;
end;

function TSpielfeld.GetLineHeight(): Byte;
var
  Row: Byte;
  Col: Byte;
  EmptyLine: Boolean;
begin
  for Row := 0 to Self.Rows - 1 do
  begin
    EmptyLine := True;
    for Col := 0 to Self.Columns - 1 do
    begin
      if (Self.Gitter[Row, Col] <> INDEX_LEER) then
      begin
        EmptyLine := False;
        break;
      end;
    end;
    if(not EmptyLine) then
    begin
      Result := Self.Rows - Row;
      Exit;
    end;
  end;
end;

procedure TSpielfeld.Reset();
var
  I: Integer;
  J: Integer;
begin
  Self.Transparent  := False;
  Self.FastDownFlag := False;
  Self.FastDownAllowed := True;
  Self.CurrentFigur := nil;
  Self.OneBonusRows := 0;
  Self.TwoBonusRows := 0;
  Self.ThreeBonusRows := 0;
  Self.Lines        := 0;
  Self.Level        := 0;
  Self.Punkte       := 0;
  Self.Stopped      := False;
  for I := 0 to Self.Rows - 1 do
    for J := 0 to Self.Columns - 1 do
      Self.Gitter[I,J] := 0;
end;

procedure TSpielfeld.CheckLoose();
var
  FigurPoints : TPointArray;
  I: Integer;
begin
  if(Self.Stopped) then Exit;

  FigurPoints := Self.CurrentFigur.GetPoints();
  for I := 0 to Length(FigurPoints) - 1 do
  begin
    if(Self.Gitter[FigurPoints[I].Y, FigurPoints[I].X] <> INDEX_LEER) then
    begin
      Self.Main.IncDeads();
      Exit;
    end;
  end;

end;

function TSpielfeld.GetPunkte(): Integer;
begin
  Result := Self.Punkte;
end;

function TSpielfeld.GetLevel(): Integer;
begin
  Result := Self.Level;
end;

function TSpielfeld.GetLinien(): Integer;
begin
  Result := Self.Lines;
end;

function TSpielfeld.GetNextFigurImage(): TBitmap;
var
  NextFigurImage: TBitmap;
  K           : Integer;
  Cell        : TBitmap;
  FigurPoints : TPointArray;
  NextFigur   : TAbstractFigur;
begin
  NextFigur := GetFigur(Self.NextFigurIndex);
  Cell := GetPart(NextFigur.GetColor(), True);
  FigurPoints := NextFigur.GetPoints();
  NextFigurImage := TBitmap.Create();
  NextFigurImage.SetSize(105, 105);
  NextFigurImage.Canvas.Brush.Color := clBlack;
  NextFigurImage.Canvas.Brush.Color := clBlack;
  NextFigurImage.Canvas.FillRect(NextFigurImage.Canvas.ClipRect);

  for K := 0 to Length(FigurPoints) - 1 do
  begin
    NextFigurImage.Canvas.Draw(CELL_WIDTH * (FigurPoints[K].X-3) + CELL_SPACING * (FigurPoints[K].X-3) + CELL_SPACING,
      CELL_WIDTH * (FigurPoints[K].Y+1) + CELL_SPACING * (FigurPoints[K].Y+1) + CELL_SPACING, Cell);
  end;
  Cell.Free();
  NextFigur.Free;

  Result := NextFigurImage;
end;

function TSpielfeld.GetOneBonusRows(): Integer;
begin
  Result := Self.OneBonusRows;
end;

function TSpielfeld.GetTwoBonusRows(): Integer;
begin
  Result := Self.TwoBonusRows;
end;

function TSpielfeld.GetThreeBonusRows(): Integer;
begin
  Result := Self.ThreeBonusRows;
end;

procedure TSpielfeld.AddOneBonusRows();
begin
  Inc(Self.OneBonusRows);
end;

procedure TSpielfeld.AddTwoBonusRows();
begin
  Inc(Self.TwoBonusRows);
end;

procedure TSpielfeld.AddThreeBonusRows();
begin
  Inc(Self.ThreeBonusRows);
end;

procedure TSpielfeld.AddRows(rows: Integer);
var
  randomIndex : Integer;
  I, J : Integer;
begin
  for I := 0 to Self.Rows - 1 - rows do
    for J := 0 to Self.Columns - 1 do
      Self.Gitter[I,J] := Self.Gitter[I + rows,J];

  randomIndex := Random(10);
  for I := Self.Rows - rows to Self.Rows - 1 do
    for J := 0 to Self.Columns - 1 do
      if(J <> randomIndex) then
        Self.Gitter[I,J] := 8
      else
        Self.Gitter[I,J] := 0;
end;

procedure TSpielfeld.FastDown();
begin
  if(Self.Stopped) then Exit;
  if(not Self.FastDownAllowed) then Exit;

  main.LogMsg('FastDown');
  Self.FastDownFlag := True;
  Self.Timer.Interval := 50;
end;

procedure TSpielfeld.StopFastDown();
begin
  Self.FastDownFlag := False;
  Self.Timer.Interval := Speed;
end;

procedure TSpielfeld.StopFlipped();
begin
  Self.FlippedFlag := False;
end;

function TSpielfeld.isFastDown(): Boolean;
begin
  Result := Self.FastDownFlag;
end;

function TSpielfeld.isFlipped(): Boolean;
begin
  Result := Self.FlippedFlag;
end;

procedure TSpielfeld.DeleteLines(ToDelete: TIntegerArray);
var
  I: Integer;
  Row: Integer;
  Column: Integer;
begin
  if(Length(ToDelete) > 0) then
  begin
    Self.SoundManager.PlayDelteSound(0.2);
    Self.Main.SetDeletedLineCount(Length(ToDelete));
    for I := 0 to Length(ToDelete) - 1 do
    begin
      for Row := ToDelete[I] downto 1 do
        for Column := 0 to Self.Columns - 1 do
          Self.Gitter[Row, Column] := Self.Gitter[Row - 1, Column];
    end;
  end;
end;

procedure TSpielfeld.Paint();
var
  Row         : Integer;
  Column      : Integer;
  K           : Integer;
  Cell        : TBitmap;
  FigurPoints : TPointArray;
begin
  for Row := 0 to Self.Rows - 1 do
  begin
    for Column := 0 to Self.Columns - 1 do
    begin
      case Self.Gitter[Row, Column] of
        INDEX_LEER: // Leeres Feld
          Cell := GetPart(COLOR_LEER, False);
        INDEX_I: // Figurteil: I
          Cell := GetPart(COLOR_FIGUR_STAB, True);
        INDEX_O: // Figurteil: O
          Cell := GetPart(COLOR_FIGUR_BLOCK, True);
        INDEX_S: // Figurteil: S
          Cell := GetPart(COLOR_FIGUR_S, True);
        INDEX_Z: // Figurteil: Z
          Cell := GetPart(COLOR_FIGUR_Z, True);
        INDEX_L: // Figurteil: L
          Cell := GetPart(COLOR_FIGUR_L, True);
        INDEX_J: // Figurteil: L
          Cell := GetPart(COLOR_FIGUR_J, True);
        INDEX_T: // Figurteil: T
          Cell := GetPart(COLOR_FIGUR_T, True);
        INDEX_BONUS: // Bonusblock
          Cell := GetPart(COLOR_BONUS_LINES, True);
      end;
      Self.Canvas.Draw(CELL_WIDTH * Column + CELL_SPACING * Column + CELL_SPACING,
          CELL_WIDTH * Row + CELL_SPACING * Row + CELL_SPACING, Cell);
      Cell.Free();
    end;
  end;

  Cell := GetPart(Self.CurrentFigur.GetColor(), True);
  FigurPoints := Self.CurrentFigur.GetPoints();
  for K := 0 to Length(FigurPoints) - 1 do
  begin
    Self.Canvas.Draw(CELL_WIDTH * FigurPoints[K].X + CELL_SPACING * FigurPoints[K].X + CELL_SPACING,
      CELL_WIDTH * FigurPoints[K].Y + CELL_SPACING * FigurPoints[K].Y + CELL_SPACING, Cell);
  end;
  Cell.Free();
end;

function TSpielfeld.GetPart(Color: TColor; ShowBorder: Boolean): TBitmap;
var
  Core   : TRect;
  I: Integer;
begin
  Core.Top    := 0;
  Core.Left   := 0;
  Core.Bottom := PART_WIDTH;
  Core.Right  := PART_WIDTH;

  Result := TBitmap.Create();
  Result.Width := PART_WIDTH;
  Result.Height := PART_WIDTH;
  with Result.Canvas do
  begin
    Brush.Color := Color;
    FillRect(Core);
    if(ShowBorder) then
    begin
      // Äußerer heller Rahmen
      Pen.Color := ColorAdjustLuma(colortorgb(Color), 60, false);
      MoveTo(0, 0);
      LineTo(PART_WIDTH, 0);
      Pen.Color := ColorAdjustLuma(colortorgb(Color), 50, false);
      MoveTo(PART_WIDTH - 1, 1);
      LineTo(PART_WIDTH - 1, PART_WIDTH - 1);

      // Innerer heller Rahmen
      Pen.Color := ColorAdjustLuma(colortorgb(Color), 40, false);
      MoveTo(1, 1);
      LineTo(PART_WIDTH - 1, 1);
      Pen.Color := ColorAdjustLuma(colortorgb(Color), 30, false);
      MoveTo(PART_WIDTH - 2, 2);
      LineTo(PART_WIDTH - 2, PART_WIDTH - 2);

      // Äußerer dunkler Rahmen
      Pen.Color := ColorAdjustLuma(colortorgb(Color), -50, false);
      MoveTo(0, 1);
      LineTo(0, PART_WIDTH - 1);
      Pen.Color := ColorAdjustLuma(colortorgb(Color), -60, false);
      LineTo(PART_WIDTH, PART_WIDTH - 1);

      // Innerer dunkler Rahmen
      Pen.Color := ColorAdjustLuma(colortorgb(Color), -30, false);
      MoveTo(1, 2);
      LineTo(1, PART_WIDTH - 2);
      Pen.Color := ColorAdjustLuma(colortorgb(Color), -40, false);
      LineTo(PART_WIDTH - 1, PART_WIDTH - 2);


      Pen.Color := ColorAdjustLuma(colortorgb(Color), 10, false);
      MoveTo(2, 3);
      LineTo(2, PART_WIDTH - 2);
      MoveTo(2, PART_WIDTH - 3);
      LineTo(PART_WIDTH - 3, PART_WIDTH - 3);

      Pen.Color := ColorAdjustLuma(colortorgb(Color), -10, false);
      MoveTo(2, 2);
      LineTo(PART_WIDTH - 2, 2);
      MoveTo(PART_WIDTH - 3, 2);
      LineTo(PART_WIDTH - 3, PART_WIDTH - 2);


      // Helle Reflektion
      Pixels[3, PART_WIDTH - 4] := ColorAdjustLuma(colortorgb(Color), 80, false);
      for I := 0 to 11 do
      begin
        Pen.Color := ColorAdjustLuma(colortorgb(Color), 77 - I * 7, false);
        MoveTo(3, PART_WIDTH - 4 - I);
        LineTo(4 + I, PART_WIDTH - 3);
      end;


    end;
  end;
end;

procedure TSpielfeld.NewObject();
var
  I: Integer;
begin
  if(Self.Stopped) then Exit;
  Self.FastDownAllowed := False;
  StopFastDown();

  if(Self.OneBonusRows > 0) then
  begin
    for I := 0 to Self.OneBonusRows - 1 do
      AddRows(1);
    Self.OneBonusRows := 0;
    Self.Main.ResetOneBonusColor();
  end;

  if(Self.TwoBonusRows > 0) then
  begin
    for I := 0 to Self.TwoBonusRows - 1 do
      AddRows(2);
    Self.TwoBonusRows := 0;
    Self.Main.ResetTwoBonusColor();
  end;

  if(Self.ThreeBonusRows > 0) then
  begin
    for I := 0 to Self.ThreeBonusRows - 1 do
      AddRows(3);
    Self.ThreeBonusRows := 0;
    Self.Main.ResetThreeBonusColor();
  end;

  if(Self.CurrentFigur <> nil) then
    Self.CurrentFigur.Free;

  Self.CurrentFigur := GetFigur(NextFigurIndex);
  NextFigurIndex := Random(7) + 1;
  Self.Main.ShowNextFigur();

  Paint();
end;

function TSpielfeld.GetFigur(index: Integer): TAbstractFigur;
begin
  case index of
    INDEX_I: // Figurteil: I
      Result := TFigurI.Create(Self.Gitter, 4, 0);
    INDEX_O: // Figurteil: O
      Result := TFigurO.Create(Self.Gitter, 4, 0);
    INDEX_S: // Figurteil: S
      Result := TFigurS.Create(Self.Gitter, 4, 0);
    INDEX_Z: // Figurteil: Z
      Result := TFigurZ.Create(Self.Gitter, 4, 0);
    INDEX_L: // Figurteil: L
      Result := TFigurL.Create(Self.Gitter, 4, 0);
    INDEX_J: // Figurteil: J
      Result := TFigurJ.Create(Self.Gitter, 4, 0);
    INDEX_T: // Figurteil: T
      Result := TFigurT.Create(Self.Gitter, 4, 0);
  end;
end;

procedure TSpielfeld.FlipObject();
begin
  if(Self.Stopped) then Exit;
  Self.FlippedFlag := True;
  if(Self.CurrentFigur.Flipp(True)) then
  begin
    Self.SoundManager.PlayFlipSound(0.3);
    Paint();
  end;
end;

function TSpielfeld.CheckFullLines(): Boolean;
var
  Row, Column     : Integer;
  Count    : Integer;
  ToDelete : TIntegerArray;
begin
  Result := False;
  SetLength(ToDelete, 0);
  for Row := 0 to Self.Rows - 1 do
  begin
    Count := 0;
    for Column := 0 to Self.Columns - 1 do
    begin
      if(Self.Gitter[Row, Column] <> 0) then
        Count := Count + 1;
    end;
    if(Count = Self.Columns) then
    begin
      SetLength(ToDelete, Length(ToDelete) + 1);
      ToDelete[Length(ToDelete) - 1] := Row;
      Result := True;
    end;
  end;
  // ShowDeleteLines()
  DeleteLines(ToDelete);
  Self.Lines := Self.Lines + Length(ToDelete);
  Self.Level := Trunc(Self.Lines / 10);
  if(Self.Level < 10) then
    Self.Speed := 1000 - 50 * Self.Level
  else
    Self.Speed := 400;
  Self.Main.ShowLines();
  Self.Main.ShowLevel();
  for Row := 0 to Length(ToDelete) - 1 do
    for Column := 0 to Self.Columns - 1 do
      Self.Gitter[Row, Column] := 0;

end;

procedure TSpielfeld.MoveObject(Sender: TObject);
var
  Moved : Boolean;
  FigurPoints : TPointArray;
  I: Integer;
begin
  if(Self.Stopped) then Exit;

  Moved := Self.CurrentFigur.MoveDown();
  if(not Moved) then
  begin
    FigurPoints := Self.CurrentFigur.GetPoints();
    for I := 0 to Length(FigurPoints) - 1 do
    begin
      if(FigurPoints[I].Y > -1) then
        Self.Gitter[FigurPoints[I].Y, FigurPoints[I].X] := Self.CurrentFigur.GetIndex();
    end;
    if(CheckFullLines()) then
    begin
      Self.SoundManager.PlayDropSound(0.2);
      Paint();
      NewObject();
      Exit;
    end;
    Self.SoundManager.PlayDropSound(0.2);
    NewObject();
  end;
  Paint();
  CheckLoose();
end;

procedure TSpielfeld.Start();
begin
  Self.SoundManager.PlayBackgroundMusic(0.1);

  Reset();
  NextFigurIndex := Random(7) + 1;
  NewObject();
  Speed := 1000;
  Timer.Interval := Speed;
  Self.Stopped := False;
end;

procedure TSpielfeld.Stop();
begin
  Speed := 0;
  Timer.Interval := Speed;
  Self.Stopped := True;

  Self.SoundManager.StopBackgroundMusic();
end;

procedure TSpielfeld.MoveLeft();
begin
  if(Self.Stopped) then Exit;
  Self.FastDownAllowed := False;
  StopFastDown();
  if(Self.CurrentFigur.MoveLeft()) then
  begin
    Self.SoundManager.PlayMoveSound(0.2);
    Paint();
  end;
end;

procedure TSpielfeld.MoveRight();
begin
  if(Self.Stopped) then Exit;
  Self.FastDownAllowed := False;
  StopFastDown();
  if(Self.CurrentFigur.MoveRight()) then
  begin
    Self.SoundManager.PlayMoveSound(0.2);
    Paint();
  end;
end;

end.
