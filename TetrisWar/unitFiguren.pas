{*******************************************************************************
 Project       : Tetris War Client
 Filename      : unitFiguren
 Date          : 2011-06-06
 Version       : 0.0.0.1
 Last modified : 2011-06-19
 Author        : Thomas Gattinger
 URL           : -
 Copyright     : Copyright (c) 2011 Thomas Gattinger
*******************************************************************************}
unit unitFiguren;

interface

uses
  // Delphi Libs
  Controls, ExtCtrls, Graphics, Types, Classes, Dialogs, SysUtils,

  // Eigene Libs
  unitTetrisTypes;

type

  {
    Dies ist die Oberklasse aller Figuren und definiert allgemeingültige Methoden,
    die jede Figur besitzt.
  }
  TAbstractFigur = class
    private
      Flipped  : Integer;       // Anzahl der Rotationen nach der Grundstellung (=0)
      Position : TPoint;        // x- und y-Koordinate der Figur
      Gitter   : TGitter;       // Dies ist das Spielfeld, in dem die bereits gefallenen Figuren sind
      GitterRows : Integer;     // Anzahl der Zeilen im Spielfeld
      GitterColumns : Integer;  // Anzahl der Spalten im Spielfeld

    public
      constructor Create(var Gitter: TGitter);
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; virtual; abstract;
      function GetFlipped()    : Integer;
      function GetPosition()   : TPoint;
      function GetPoints()     : TPointArray; virtual; abstract;
      function GetColor()      : TColor; virtual; abstract;
      function MoveLeft()      : Boolean; virtual; abstract;
      function MoveRight()     : Boolean; virtual; abstract;
      function MoveDown()      : Boolean; virtual; abstract;
      function IsFlipAllowed() : Boolean; virtual; abstract;
      function GetIndex()      : Integer; virtual; abstract;
  end;

  {
    Dies ist die Klasse, die eine I Figur repräsentiert.
    Die Figur besitzt zwei Rotationszustände und sieht wie folgt aus:
    1)          2)
    . . . .     . o . .
    o o o o     . o . .
    . . . .     . o . .
    . . . .     . o . .

    Nullpunkt in der Abbildung ist oben links.
    Die Punkte geben das lokale Koordinatensystem an, wobei der Nullpunkt (0,0)
    der Rotationsache entspricht und in der Abbildung somit bei (1,1) liegt.
  }
  TFigurI = class(TAbstractFigur)
    public
      constructor Create(var Gitter: TGitter; X: Integer; Y: Integer);
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; override;
      function GetPoints()     : TPointArray; override;
      function GetColor()      : TColor; override;
      function MoveLeft()      : Boolean; override;
      function MoveRight()     : Boolean; override;
      function MoveDown()      : Boolean; override;
      function IsFlipAllowed() : Boolean; override;
      function GetIndex()      : Integer; override;
  end;

  {
    Dies ist die Klasse, die eine O Figur repräsentiert.
    Die Figur besitzt nur einen Zustand, der wie folgt aussieht:

    1)
    o o
    o o

    Nullpunkt in der Abbildung ist oben links.
    Der Nullpunkt der Figur liegt bei (0,0)
  }
  TFigurO = class(TAbstractFigur)
    public
      constructor Create(var Gitter: TGitter; X: Integer; Y: Integer);
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; override;
      function GetPoints()     : TPointArray; override;
      function GetColor()      : TColor; override;
      function MoveLeft()      : Boolean; override;
      function MoveRight()     : Boolean; override;
      function MoveDown()      : Boolean; override;
      function IsFlipAllowed() : Boolean; override;
      function GetIndex()      : Integer; override;
  end;

  {
    Dies ist die Klasse, die eine S Figur repräsentiert.
    Die Figur besitzt zwei Rotationszustände und sieht wie folgt aus:

    1)        2)
    . . .     . o .
    . o o     . o o
    o o .     . . o

    Nullpunkt in der Abbildung ist oben links.
    Die Punkte geben das lokale Koordinatensystem an, wobei der Nullpunkt (0,0)
    der Rotationsache entspricht und in der Abbildung somit bei (1,1) liegt.
  }
  TFigurS = class(TAbstractFigur)
    public
      constructor Create(var Gitter: TGitter; X: Integer; Y: Integer);
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; override;
      function GetPoints()     : TPointArray; override;
      function GetColor()      : TColor; override;
      function MoveLeft()      : Boolean; override;
      function MoveRight()     : Boolean; override;
      function MoveDown()      : Boolean; override;
      function IsFlipAllowed() : Boolean; override;
      function GetIndex()      : Integer; override;
  end;

  {
    Dies ist die Klasse, die eine Z Figur repräsentiert.
    Die Figur besitzt zwei Rotationszustände und sieht wie folgt aus:

    1)        2)
    . . .     . o .
    o o .     o o .
    . o o     o . .

    Nullpunkt in der Abbildung ist oben links.
    Die Punkte geben das lokale Koordinatensystem an, wobei der Nullpunkt (0,0)
    der Rotationsache entspricht und in der Abbildung somit bei (1,1) liegt.
  }
  TFigurZ = class(TAbstractFigur)
    public
      constructor Create(var Gitter: TGitter; X: Integer; Y: Integer);
      function GetPoints(): TPointArray; override;
      function GetColor(): TColor; override;
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; override;
      function MoveLeft(): Boolean; override;
      function MoveRight(): Boolean; override;
      function MoveDown(): Boolean; override;
      function IsFlipAllowed(): Boolean; override;
      function GetIndex(): Integer; override;
  end;

  {
    Dies ist die Klasse, die eine L Figur repräsentiert.
    Die Figur besitzt vier Rotationszustände und sieht wie folgt aus:
    1)          2)        3)        4)
    . . .     o o .     . . o     . o .
    o o o     . o .     o o o     . o .
    o . .     . o .     . . .     . o o

    Nullpunkt in der Abbildung ist oben links.
    Die Punkte geben das lokale Koordinatensystem an, wobei der Nullpunkt (0,0)
    der Rotationsache entspricht und in der Abbildung somit bei (1,1) liegt.
  }
  TFigurL = class(TAbstractFigur)
    public
      constructor Create(var Gitter: TGitter; X: Integer; Y: Integer);
      function GetPoints(): TPointArray; override;
      function GetColor(): TColor; override;
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; override;
      function MoveLeft(): Boolean; override;
      function MoveRight(): Boolean; override;
      function MoveDown(): Boolean; override;
      function IsFlipAllowed(): Boolean; override;
      function GetIndex(): Integer; override;
  end;

  {
    Dies ist die Klasse, die eine J Figur repräsentiert.
    Die Figur besitzt vier Rotationszustände und sieht wie folgt aus:
    1)          2)        3)        4)
    . . .     . o .     . . .     o o .
    o o o     . o .     o o o     . o .
    . . o     o o .     o . .     . o .

    Nullpunkt in der Abbildung ist oben links.
    Die Punkte geben das lokale Koordinatensystem an, wobei der Nullpunkt (0,0)
    der Rotationsache entspricht und in der Abbildung somit bei (1,1) liegt.
  }
  TFigurJ = class(TAbstractFigur)
    public
      constructor Create(var Gitter: TGitter; X: Integer; Y: Integer);
      function GetPoints(): TPointArray; override;
      function GetColor(): TColor; override;
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; override;
      function MoveLeft(): Boolean; override;
      function MoveRight(): Boolean; override;
      function MoveDown(): Boolean; override;
      function IsFlipAllowed(): Boolean; override;
      function GetIndex(): Integer; override;
  end;

  {
    Dies ist die Klasse, die eine T Figur repräsentiert.
    Die Figur besitzt vier Rotationszustände und sieht wie folgt aus:
    1)          2)        3)        4)
    . . .     . o .     . o .     . o .
    o o o     o o .     o o o     . o o
    . o .     . o .     . . .     . o .

    Nullpunkt in der Abbildung ist oben links.
    Die Punkte geben das lokale Koordinatensystem an, wobei der Nullpunkt (0,0)
    der Rotationsache entspricht und in der Abbildung somit bei (1,1) liegt.
  }
  TFigurT = class(TAbstractFigur)
    public
      constructor Create(var Gitter: TGitter; X: Integer; Y: Integer);
      function GetPoints(): TPointArray; override;
      function GetColor(): TColor; override;
      function Flipp(ImUhrzeigerSinn: Boolean): Boolean; override;
      function MoveLeft(): Boolean; override;
      function MoveRight(): Boolean; override;
      function MoveDown(): Boolean; override;
      function IsFlipAllowed(): Boolean; override;
      function GetIndex(): Integer; override;
  end;

const
  // Farben für die einzelnen Figuren
  COLOR_LEER = $00200d0d;
  COLOR_FIGUR_STAB = $000066ff;
  COLOR_FIGUR_BLOCK = $000000ff;
  COLOR_FIGUR_S = $00ffcc66;
  COLOR_FIGUR_Z = $0000ff00;
  COLOR_FIGUR_L = $00ff0000;
  COLOR_FIGUR_J = $00ff00cc;
  COLOR_FIGUR_T = $0000ffff;
  COLOR_BONUS_LINES = $00878787;

  // Indizies über die einzelnen Figuren identifiziert werden
  INDEX_LEER = 0;
  INDEX_I = 1;
  INDEX_O = 2;
  INDEX_S = 3;
  INDEX_Z = 4;
  INDEX_L = 5;
  INDEX_J = 6;
  INDEX_T = 7;
  INDEX_BONUS = 8;

  PART_WIDTH   = 20;
  PART_BORDER_WIDTH = 2; // TODO
  PART_SPACING      = 2; // TODO

implementation

// **********************************
// *   TAbstractFigur               *
// **********************************

{
  Erzeugt eine neue Instanz einer Figur und setzt das aktuelle Spielfeld.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
}
constructor TAbstractFigur.Create(var Gitter: TGitter);
begin
  inherited Create();

  Self.Gitter := Gitter;
  Self.GitterRows := Length(Gitter);
  Self.GitterColumns := Length(Gitter[0]);
  Self.Flipped := 0;
end;

function TAbstractFigur.GetFlipped(): Integer;
begin
  Result := Self.Flipped;
end;

function TAbstractFigur.GetPosition(): TPoint;
begin
  Result := Self.Position;
end;

// **********************************
// *   TFigurI                      *
// **********************************

{
  Dieser Konstruktor erzeugt eine neue Instanz der I-Figur, setzt das bisherige Spielfeld
  und den Nullpunkt auf dem Spielfeld fest.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
  ~param X Die x-Koordinate des Nullpunkts bezogen auf das Spielfeld
  ~param Y Die y-Koordinate des Nullpunkts bezogen auf das Spielfeld
}
constructor TFigurI.Create(var Gitter: TGitter; X: Integer; Y: Integer);
begin
  inherited Create(Gitter);

  Self.Position.X := X;
  Self.Position.Y := Y;
end;

{
  Diese Funktion erzeugt ein Array, in dem die einzlenen Koordinatenpaare der Figur
  je nach Rotation abgelegt sind.

  ~return Ein Array mit Koordinatenpaaren
}
function TFigurI.GetPoints(): TPointArray;
var P1, P2, P3, P4 : TPoint;
begin
  if(Self.Flipped = 0) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X + 1;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X + 2;
    P4.Y := Self.Position.Y;
  end
  else if(Self.Flipped = 1) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y + 1;
    P4.X := Self.Position.X;
    P4.Y := Self.Position.Y + 2;
  end;
  SetLength(Result, 4);
  Result[0] := P1;
  Result[1] := P2;
  Result[2] := P3;
  Result[3] := P4;
end;

{
  Diese Funktion liefert den Farbwert für diese Figur.

  ~return Einen Farbwert für diese Figur
}
function TFigurI.GetColor(): TColor;
begin
  Result := COLOR_FIGUR_STAB;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach links,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach links
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurI.MoveLeft(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X - 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X - 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach rechts,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach rechts
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurI.MoveRight(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X + 3 > Self.GitterColumns - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 3] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X + 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach unten,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach unten
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurI.MoveDown(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y + 1 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.Y + 3 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 3, Self.Position.X] <> 0) then Exit;
  end;

  Self.Position.Y := Self.Position.Y + 1;
  Result := True;
end;

{
  Diese Methode rotiert die Figur um eine Position weiter.
  Da es nur zwei Rotationszustände gibt kann der Drehsinn unbeachtet bleiben.
}
function TFigurI.Flipp(ImUhrzeigerSinn: Boolean): Boolean;
begin
  Result := False;
  if(IsFlipAllowed()) then
  begin
    Result := True;
    Inc(Self.Flipped);
    if(Self.Flipped > 1) then
      Self.Flipped := 0;
  end;
end;

{
  Diese Methode gibt an, ob das Rotieren auf der aktuellen Position erlaubt ist.
  Das Rotieren ist nur dann erlaubt, wenn keines der in der Abbildung markierten
  Felder belegt ist. Felder, die nicht belegt sein dürfen sind mit einem 'x'
  gekennzeichnet.
    1)          2)
    . x . .     . o . .
    o o o o     x o x x
    . x . .     . o . .
    . x . .     . o . .

  Außerdem darf bei einer Rotation, die Figur nicht aus dem Spielfeld wandern.
}
function TFigurI.IsFlipAllowed(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    // Figur darf nicht aus dem unteren Spielfeldrand wandern
    if (Self.Position.Y + 1 > Self.GitterRows - 1) then Exit;
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;

    // Figur darf nicht rotieren, wenn markierte Felder belegt sind
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    // Figur darf nicht aus den seitlichen Spielfeldrand wandern
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;

    // Figur darf nicht rotieren, wenn markierte Felder belegt sind
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
  end;

  Result := True;
end;

{
  Liefert den Index dieser Figur. Der Index ist ein Zahlenwert, der die Figur auf dem Spielfeld abbildet.
}
function TFigurI.GetIndex(): Integer;
begin
  Result := INDEX_I;
end;


// **********************************
// *   TFigurO                      *
// **********************************

{
  Dieser Konstruktor erzeugt eine neue Instanz der O-Figur, setzt das bisherige Spielfeld
  und den Nullpunkt auf dem Spielfeld fest.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
  ~param X Die x-Koordinate des Nullpunkts bezogen auf das Spielfeld
  ~param Y Die y-Koordinate des Nullpunkts bezogen auf das Spielfeld
}
constructor TFigurO.Create(var Gitter: TGitter; X: Integer; Y: Integer);
begin
  inherited Create(Gitter);

  Self.Position.X := X;
  Self.Position.Y := Y;
end;

{
  Diese Funktion erzeugt ein Array, in dem die einzlenen Koordinatenpaare der Figur
  je nach Rotation abgelegt sind.

  ~return Ein Array mit Koordinatenpaaren
}
function TFigurO.GetPoints(): TPointArray;
var P1, P2, P3, P4 : TPoint;
begin
  P1.X := Self.Position.X;
  P1.Y := Self.Position.Y;
  P2.X := Self.Position.X + 1;
  P2.Y := Self.Position.Y;
  P3.X := Self.Position.X;
  P3.Y := Self.Position.Y + 1;
  P4.X := Self.Position.X + 1;
  P4.Y := Self.Position.Y + 1;
  SetLength(Result, 4);
  Result[0] := P1;
  Result[1] := P2;
  Result[2] := P3;
  Result[3] := P4;
end;

{
  Diese Funktion liefert den Farbwert für diese Figur.

  ~return Einen Farbwert für diese Figur
}
function TFigurO.GetColor(): TColor;
begin
  Result := COLOR_FIGUR_BLOCK;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach links,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach links
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurO.MoveLeft(): Boolean;
begin
  Result := False;
  if(Self.Position.X - 1 < 0) then Exit;
  if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
  if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;

  Self.Position.X := Self.Position.X - 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach rechts,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach rechts
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurO.MoveRight(): Boolean;
begin
  Result := False;
  if(Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
  if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
  if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 2] <> 0) then Exit;

  Self.Position.X := Self.Position.X + 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach unten,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach unten
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurO.MoveDown(): Boolean;
begin
  Result := False;
  // Wenn eine der Zellen der Figur durch den unteren Spielrand oder eine andere Figur blockiert ist,
  // ist eine weitere Bewegung nach unten nicht erlaubt.
  if(Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
  if(Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
  if(Self.Gitter[Self.Position.Y + 2, Self.Position.X + 1] <> 0) then Exit;

  Self.Position.Y := Self.Position.Y + 1;
  Result := True;
end;

{
  Die Drehung dieser Figur hat auf die Darstellung keine Auswirkung.
  Daher braucht hier keine Berechnung durchgeführt werden.
}
function TFigurO.Flipp(ImUhrzeigerSinn: Boolean): Boolean;
begin
  // Diese Figur kann nicht gedreht werden
  Result := False;
end;

{
  Da sich die Darstellung bei einer Drehung nicht ändert,
  wird hier standardmäßg immer 'True' zurückgegeben.
}
function TFigurO.IsFlipAllowed(): Boolean;
begin
  Result := True;
end;

function TFigurO.GetIndex(): Integer;
begin
  Result := INDEX_O;
end;

// **********************************
// *   TFigurS                      *
// **********************************

{
  Dieser Konstruktor erzeugt eine neue Instanz der S-Figur, setzt das bisherige Spielfeld
  und den Nullpunkt auf dem Spielfeld fest.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
  ~param X Die x-Koordinate des Nullpunkts bezogen auf das Spielfeld
  ~param Y Die y-Koordinate des Nullpunkts bezogen auf das Spielfeld
}
constructor TFigurS.Create(var Gitter: TGitter; X: Integer; Y: Integer);
begin
  inherited Create(Gitter);

  Self.Position.X := X;
  Self.Position.Y := Y;
end;

{
  Diese Funktion erzeugt ein Array, in dem die einzlenen Koordinatenpaare der Figur
  je nach Rotation abgelegt sind.

  ~return Ein Array mit Koordinatenpaaren
}
function TFigurS.GetPoints(): TPointArray;
var P1, P2, P3, P4 : TPoint;
begin
  if(Self.Flipped = 0) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X + 1;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y + 1;
    P4.X := Self.Position.X - 1;
    P4.Y := Self.Position.Y + 1;
  end
  else if(Self.Flipped = 1) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y - 1;
    P3.X := Self.Position.X + 1;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y + 1;
  end;
  SetLength(Result, 4);
  Result[0] := P1;
  Result[1] := P2;
  Result[2] := P3;
  Result[3] := P4;
end;

{
  Diese Funktion liefert den Farbwert für diese Figur.

  ~return Einen Farbwert für diese Figur
}
function TFigurS.GetColor(): TColor;
begin
  Result := COLOR_FIGUR_S;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach links,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach links
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurS.MoveLeft(): Boolean;
begin
  Result := False;

  if(Self.Flipped = 0) then
  begin
    if(Self.Position.X - 1 < 0) then Exit;
    if(Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if(Self.Position.X - 2 < 0) then Exit;
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if(Self.Position.X - 1 < 0) then Exit;
    if(Self.Position.Y > 0) then
      if(Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X - 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach rechts,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach rechts
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurS.MoveRight(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if(Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if(Self.Position.Y > 0) then
      if(Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X + 2] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X + 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach unten,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach unten
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurS.MoveDown(): Boolean;
begin
  Result := False;
  // Wenn eine der Zellen der Figur durch den unteren Spielrand oder eine andere Figur blockiert ist,
  // ist eine weitere Bewegung nach unten nicht erlaubt.
  if(Self.Flipped = 0) then
  begin
    if(Self.Position.Y + 2 > Self.GitterRows -1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if(Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.Y := Self.Position.Y + 1;
  Result := True;
end;

{
  Diese Methode rotiert die Figur um eine Position weiter.
  Da es nur zwei Rotationszustände gibt kann der Drehsinn unbeachtet bleiben.
}
function TFigurS.Flipp(ImUhrzeigerSinn: Boolean): Boolean;
begin
  Result := False;
  if(IsFlipAllowed()) then
  begin
    Result := True;
    Inc(Self.Flipped);
    if(Self.Flipped > 1) then
      Self.Flipped := 0;
  end;
end;

{
  Diese Methode gibt an, ob das Rotieren auf der aktuellen Position erlaubt ist.
  Das Rotieren ist nur dann erlaubt, wenn keines der in der Abbildung markierten
  Felder belegt ist. Felder, die nicht belegt sein dürfen sind mit einem 'x'
  gekennzeichnet.
    1)          2)
    . x .     . o .
    . o o     . o o
    o o x     x x o

  Außerdem darf bei einer Rotation, die Figur nicht aus dem Spielfeld wandern.
}
function TFigurS.IsFlipAllowed(): Boolean;
begin
  Result := False;

  if(Self.Flipped = 0) then
  begin
    // Figur darf nicht rotieren, wenn markierte Felder belegt sind
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
    if(Self.Position.Y > 0) then
      if(Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    // Figur darf nicht aus den seitlichen Spielfeldrand wandern
    if(Self.Position.X < 1) then Exit;
    // Figur darf nicht rotieren, wenn markierte Felder belegt sind
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end;

  Result := True;
end;

function TFigurS.GetIndex(): Integer;
begin
  Result := INDEX_S;
end;

// **********************************
// *   TFigurZ                      *
// **********************************

{
  Dieser Konstruktor erzeugt eine neue Instanz der Z-Figur, setzt das bisherige Spielfeld
  und den Nullpunkt auf dem Spielfeld fest.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
  ~param X Die x-Koordinate des Nullpunkts bezogen auf das Spielfeld
  ~param Y Die y-Koordinate des Nullpunkts bezogen auf das Spielfeld
}
constructor TFigurZ.Create(var Gitter: TGitter; X: Integer; Y: Integer);
begin
  inherited Create(Gitter);

  Self.Position.X := X;
  Self.Position.Y := Y;
end;

{
  Diese Funktion erzeugt ein Array, in dem die einzlenen Koordinatenpaare der Figur
  je nach Rotation abgelegt sind.

  ~return Ein Array mit Koordinatenpaaren
}
function TFigurZ.GetPoints(): TPointArray;
var P1, P2, P3, P4 : TPoint;
begin
  if(Self.Flipped = 0) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X - 1;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y + 1;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y + 1;
  end
  else if(Self.Flipped = 1) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y + 1;
    P3.X := Self.Position.X + 1;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y - 1;
  end;
  SetLength(Result, 4);
  Result[0] := P1;
  Result[1] := P2;
  Result[2] := P3;
  Result[3] := P4;
end;

{
  Diese Funktion liefert den Farbwert für diese Figur.

  ~return Einen Farbwert für diese Figur
}
function TFigurZ.GetColor(): TColor;
begin
  Result := COLOR_FIGUR_Z;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach links,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach links
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurZ.MoveLeft(): Boolean;
begin
  Result := False;

  if(Self.Flipped = 0) then
  begin
    if(Self.Position.X - 1 < 0) then Exit;
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if(Self.Position.X - 2 < 0) then Exit;
    if(Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if(Self.Position.X - 1 < 0) then Exit;
    if(Self.Position.Y > 0) then
      if(Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X - 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach rechts,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach rechts
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurZ.MoveRight(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if(Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if(Self.Position.Y > 0) then
      if(Self.Gitter[Self.Position.Y - 1, Self.Position.X + 2] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X + 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach unten,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach unten
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurZ.MoveDown(): Boolean;
begin
  Result := False;
  // Wenn eine der Zellen der Figur durch den unteren Spielrand oder eine andere Figur blockiert ist,
  // ist eine weitere Bewegung nach unten nicht erlaubt.
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows -1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.Y := Self.Position.Y + 1;
  Result := True;
end;

{
  Diese Methode rotiert die Figur um eine Position weiter.
  Da es nur zwei Rotationszustände gibt kann der Drehsinn unbeachtet bleiben.
}
function TFigurZ.Flipp(ImUhrzeigerSinn: Boolean): Boolean;
begin
  Result := False;
  if(IsFlipAllowed()) then
  begin
    Result := True;
    Inc(Self.Flipped);
    if(Self.Flipped > 1) then
      Self.Flipped := 0;
  end;
end;

{
  Diese Methode gibt an, ob das Rotieren auf der aktuellen Position erlaubt ist.
  Das Rotieren ist nur dann erlaubt, wenn keines der in der Abbildung markierten
  Felder belegt ist. Felder, die nicht belegt sein dürfen sind mit einem 'x'
  gekennzeichnet.
    1)          2)
    . . x     . . o
    o o x     x o o
    . o o     . o x

  Außerdem darf bei einer Rotation, die Figur nicht aus dem Spielfeld wandern.
}
function TFigurZ.IsFlipAllowed(): Boolean;
begin
  Result := False;

  if(Self.Flipped = 0) then
  begin
    // Figur darf nicht rotieren, wenn markierte Felder belegt sind
    if(Self.Position.Y > 0) then
      if(Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if(Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    // Figur darf nicht aus den seitlichen Spielfeldrand wandern
  if (Self.Position.X < 1) then Exit;
    // Figur darf nicht rotieren, wenn markierte Felder belegt sind
  if(Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
  if(Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end;

  Result := True;
end;

function TFigurZ.GetIndex(): Integer;
begin
  Result := INDEX_Z;
end;

// **********************************
// *   TFigurL                      *
// **********************************

{
  Dieser Konstruktor erzeugt eine neue Instanz der L-Figur, setzt das bisherige Spielfeld
  und den Nullpunkt auf dem Spielfeld fest.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
  ~param X Die x-Koordinate des Nullpunkts bezogen auf das Spielfeld
  ~param Y Die y-Koordinate des Nullpunkts bezogen auf das Spielfeld
}
constructor TFigurL.Create(var Gitter: TGitter; X: Integer; Y: Integer);
begin
  inherited Create(Gitter);

  Self.Position.X := X;
  Self.Position.Y := Y;
end;

{
  Diese Funktion erzeugt ein Array, in dem die einzlenen Koordinatenpaare der Figur
  je nach Rotation abgelegt sind.

  ~return Ein Array mit Koordinatenpaaren
}
function TFigurL.GetPoints(): TPointArray;
var P1, P2, P3, P4 : TPoint;
begin
  if(Self.Flipped = 0) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X - 1;
    P2.Y := Self.Position.Y + 1;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y;
  end
  else if(Self.Flipped = 1) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y - 1;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X;
    P4.Y := Self.Position.Y + 1;
  end
  else if(Self.Flipped = 2) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X + 1;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y - 1;
  end
  else if(Self.Flipped = 3) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y + 1;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y + 1;
  end;
  SetLength(Result, 4);
  Result[0] := P1;
  Result[1] := P2;
  Result[2] := P3;
  Result[3] := P4;
end;

{
  Diese Funktion liefert den Farbwert für diese Figur.

  ~return Einen Farbwert für diese Figur
}
function TFigurL.GetColor(): TColor;
begin
  Result := COLOR_FIGUR_L;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach links,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach links
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurL.MoveLeft(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X - 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach rechts,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach rechts
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurL.MoveRight(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 2] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X + 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach unten,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach unten
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurL.MoveDown(): Boolean;
begin
  Result := False;
  // Wenn eine der Zellen der Figur durch den unteren Spielrand oder eine andere Figur blockiert ist,
  // ist eine weitere Bewegung nach unten nicht erlaubt.
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.Y + 1 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.Y := Self.Position.Y + 1;
  Result := True;
end;

{
  Diese Methode rotiert die Figur um eine Position weiter.
  Da es vier Rotationszustände gibt muss der Drehsinn beachtet werden.
}
function TFigurL.Flipp(ImUhrzeigerSinn: Boolean): Boolean;
begin
  Result := False;
  if(IsFlipAllowed()) then
  begin
    Result := True;
    if(ImUhrzeigerSinn) then
    begin
      Inc(Self.Flipped);
      if(Self.Flipped > 3) then
        Self.Flipped := 0;
    end
    else
    begin
      Dec(Self.Flipped);
      if(Self.Flipped < 0) then
        Self.Flipped := 3;
    end;
  end;
end;

function TFigurL.IsFlipAllowed(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y > 0) then
    begin
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
    end;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end;

  Result := True;
end;

function TFigurL.GetIndex(): Integer;
begin
  Result := INDEX_L;
end;

// **********************************
// *   TFigurJ                      *
// **********************************

{
  Dieser Konstruktor erzeugt eine neue Instanz der J-Figur, setzt das bisherige Spielfeld
  und den Nullpunkt auf dem Spielfeld fest.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
  ~param X Die x-Koordinate des Nullpunkts bezogen auf das Spielfeld
  ~param Y Die y-Koordinate des Nullpunkts bezogen auf das Spielfeld
}
constructor TFigurJ.Create(var Gitter: TGitter; X: Integer; Y: Integer);
begin
  inherited Create(Gitter);

  Self.Position.X := X;
  Self.Position.Y := Y;
end;

{
  Diese Funktion erzeugt ein Array, in dem die einzlenen Koordinatenpaare der Figur
  je nach Rotation abgelegt sind.

  ~return Ein Array mit Koordinatenpaaren
}
function TFigurJ.GetPoints(): TPointArray;
var P1, P2, P3, P4 : TPoint;
begin
  if(Self.Flipped = 0) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X + 1;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y + 1;
  end
  else if(Self.Flipped = 1) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y + 1;
    P4.X := Self.Position.X - 1;
    P4.Y := Self.Position.Y + 1;
  end
  else if(Self.Flipped = 2) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X - 1;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y;
  end
  else if(Self.Flipped = 3) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X + 1;
    P2.Y := Self.Position.Y - 1;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X;
    P4.Y := Self.Position.Y + 1;
  end;
  SetLength(Result, 4);
  Result[0] := P1;
  Result[1] := P2;
  Result[2] := P3;
  Result[3] := P4;
end;

{
  Diese Funktion liefert den Farbwert für diese Figur.

  ~return Einen Farbwert für diese Figur
}
function TFigurJ.GetColor(): TColor;
begin
  Result := COLOR_FIGUR_J;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach links,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach links
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurJ.MoveLeft(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X - 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach rechts,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach rechts
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurJ.MoveRight(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X + 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach unten,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach unten
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurJ.MoveDown(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.Y + 1 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.Y := Self.Position.Y + 1;
  Result := True;
end;

{
  Diese Methode rotiert die Figur um eine Position weiter.
  Da es vier Rotationszustände gibt muss der Drehsinn beachtet werden.
}
function TFigurJ.Flipp(ImUhrzeigerSinn: Boolean): Boolean;
begin
  Result := False;
  if(IsFlipAllowed()) then
  begin
    Result := True;
    if(ImUhrzeigerSinn) then
    begin
      Inc(Self.Flipped);
      if(Self.Flipped > 3) then
        Self.Flipped := 0;
    end
    else
    begin
      Dec(Self.Flipped);
      if(Self.Flipped < 0) then
        Self.Flipped := 3;
    end;
  end;
end;

function TFigurJ.IsFlipAllowed(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.Y > 0) then
    begin
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    end;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end;

  Result := True;
end;

function TFigurJ.GetIndex(): Integer;
begin
  Result := INDEX_J;
end;

// **********************************
// *   TFigurT                      *
// **********************************

{
  Dieser Konstruktor erzeugt eine neue Instanz der T-Figur, setzt das bisherige Spielfeld
  und den Nullpunkt auf dem Spielfeld fest.

  ~param Gitter Dies ist das Spielfeld mit den bereits gefallenen Figuren
  ~param X Die x-Koordinate des Nullpunkts bezogen auf das Spielfeld
  ~param Y Die y-Koordinate des Nullpunkts bezogen auf das Spielfeld
}
constructor TFigurT.Create(var Gitter: TGitter; X: Integer; Y: Integer);
begin
  inherited Create(Gitter);

  Self.Position.X := X;
  Self.Position.Y := Y;
end;

{
  Diese Funktion erzeugt ein Array, in dem die einzlenen Koordinatenpaare der Figur
  je nach Rotation abgelegt sind.

  ~return Ein Array mit Koordinatenpaaren
}
function TFigurT.GetPoints(): TPointArray;
var P1, P2, P3, P4 : TPoint;
begin
  if(Self.Flipped = 0) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X + 1;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X;
    P4.Y := Self.Position.Y + 1;
  end
  else if(Self.Flipped = 1) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y + 1;
    P4.X := Self.Position.X - 1;
    P4.Y := Self.Position.Y;
  end
  else if(Self.Flipped = 2) then
  begin
    P1.X := Self.Position.X - 1;
    P1.Y := Self.Position.Y;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X + 1;
    P3.Y := Self.Position.Y;
    P4.X := Self.Position.X;
    P4.Y := Self.Position.Y - 1;
  end
  else if(Self.Flipped = 3) then
  begin
    P1.X := Self.Position.X;
    P1.Y := Self.Position.Y - 1;
    P2.X := Self.Position.X;
    P2.Y := Self.Position.Y;
    P3.X := Self.Position.X;
    P3.Y := Self.Position.Y + 1;
    P4.X := Self.Position.X + 1;
    P4.Y := Self.Position.Y;
  end;
  SetLength(Result, 4);
  Result[0] := P1;
  Result[1] := P2;
  Result[2] := P3;
  Result[3] := P4;
end;

{
  Diese Funktion liefert den Farbwert für diese Figur.

  ~return Einen Farbwert für diese Figur
}
function TFigurT.GetColor(): TColor;
begin
  Result := COLOR_FIGUR_T;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach links,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach links
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurT.MoveLeft(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.X - 2 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X - 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach rechts,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach rechts
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurT.MoveRight(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X + 2 > Self.GitterColumns - 1) then Exit;
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X + 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 2] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.X := Self.Position.X + 1;
  Result := True;
end;

{
  Diese Funktion bewegt die Figur auf dem Spielfeld nach unten,
  sofern dies möglich ist. Die Figur kann nur dann verschoben werden,
  wenn sie nicht über den Spielfeldrand wandert, bzw. nicht gegen
  ein belegtes Feld stößt.

  ~return Liefert true, falls der Nullpunkt der Figur nach unten
          verschoben werden konnte. Andernfalls wird false geliefert.
}
function TFigurT.MoveDown(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Position.Y + 1 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X - 1] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.Y + 2 > Self.GitterRows - 1) then Exit;
    if (Self.Gitter[Self.Position.Y + 2, Self.Position.X] <> 0) then Exit;
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X + 1] <> 0) then Exit;
  end;

  Self.Position.Y := Self.Position.Y + 1;
  Result := True;
end;

{
  Diese Methode rotiert die Figur um eine Position weiter.
  Da es vier Rotationszustände gibt muss der Drehsinn beachtet werden.
}
function TFigurT.Flipp(ImUhrzeigerSinn: Boolean): Boolean;
begin
  Result := False;
  if(IsFlipAllowed()) then
  begin
    Result := True;
    if(ImUhrzeigerSinn) then
    begin
      Inc(Self.Flipped);
      if(Self.Flipped > 3) then
        Self.Flipped := 0;
    end
    else
    begin
      Dec(Self.Flipped);
      if(Self.Flipped < 0) then
        Self.Flipped := 3;
    end;
  end;
end;

function TFigurT.IsFlipAllowed(): Boolean;
begin
  Result := False;
  if(Self.Flipped = 0) then
  begin
    if (Self.Position.Y > 0) then
      if (Self.Gitter[Self.Position.Y - 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 1) then
  begin
    if (Self.Position.X + 1 > Self.GitterColumns - 1) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X + 1] <> 0) then Exit;
  end
  else if(Self.Flipped = 2) then
  begin
    if (Self.Gitter[Self.Position.Y + 1, Self.Position.X] <> 0) then Exit;
  end
  else if(Self.Flipped = 3) then
  begin
    if (Self.Position.X - 1 < 0) then Exit;
    if (Self.Gitter[Self.Position.Y, Self.Position.X - 1] <> 0) then Exit;
  end;

  Result := True;
end;

function TFigurT.GetIndex(): Integer;
begin
  Result := INDEX_T;
end;

end.
