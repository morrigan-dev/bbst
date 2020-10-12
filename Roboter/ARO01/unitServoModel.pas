{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitServoModel;

interface

uses
  // Delphi Klassen
  Graphics,

  // Eigene Klassen
  unitElementModel;

type

  {
    Diese Klasse ist das Model für jede Klasse ~[code TServoX], in dem sämtliche zu einem Servo gehörenden Daten
    abgelegt werden. Ferner beinhaltet dieses Model alle Berechnungen, die sich auf einen Servo beziehen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitElementModel.TElementModel Die Oberklasse dieses Model
    ~see unitServo0.TServo0 Benutzt dieses Model
  }
  TServoModel = class(TElementModel)
  private
    { Der aktuelle Gradwert des Servos im Bereich von 0° bis 360° }
    curDegree        : Real;
    { Die aktuelle Position des Servos im Bereich von 0 bis 100 }
    curPosition      : Real;
    { Die Farbe, in der der Servo gezeichnet wird, wenn er aktiv ist }
    highlightColor   : TColor;
    { Gibt an, ob der Servo momentan aktiv ist }
    highlighted      : Boolean;
    { Der maximale Gradwert, die der Servo einnehmen kann im Bereich von 0° bis 360° }
    maxDegree        : Real;
    { Der minimale Gradwert, die der Servo einnehmen kann im Bereich von 0° bis 360° }
    minDegree        : Real;

    { Gibt an, ob bei den Settern nach dem Setzen des Wertes ein update in der GUI gefahren werden soll }
    updateGUI        : Boolean;

    procedure correctDegree(var degree : Real);
    procedure correctPercent(var percent : Real);

    procedure updateCurDegree(var curPosition : Real; var maxDegree : Real; var minDegree : Real);
    procedure updateCurPosition(var curDegree : Real; var maxDegree : Real; var minDegree : Real);

  public
    constructor Create(color : TColor; depth, height, width : Real; curPosition : Real; highlightColor : TColor;
                       highlighted : Boolean; maxDegree, minDegree : Real);
    destructor Destroy(); override;

    function GetCurDegree()      : Real;
    function GetCurPosition()    : Real;
    function GetHighlightColor() : TColor;
    function GetHighlighted()    : Boolean;
    function GetMaxDegree()      : Real;
    function GetMinDegree()      : Real;

    procedure SetCurDegree(curDegree : Real);
    procedure SetCurPosition(curPosition : Real);
    procedure SetHighlightColor(highlightColor : TColor);
    procedure SetHighlighted(highlighted : Boolean);
    procedure SetMaxDegree(maxDegree : Real);
    procedure SetMinDegree(minDegree : Real);
    procedure SetValuesWithDegree(curDegree : Real; highlightColor : TColor; highlighted : Boolean;
                        maxDegree, minDegree : Real);
    procedure SetValuesWithPosition(curPosition : Real; highlightColor : TColor; highlighted : Boolean;
                        maxDegree, minDegree : Real);
    procedure IncPosition();
    procedure DecPosition();
  end;

implementation

uses Classes, Math;

{
  Konstruktor, der dieses Model erzeugt und alle Member mit dem übergebenen Wert initalisiert.

  ~param color Die Farbe dieses Servos.
  ~param depth Die räumliche Tiefenlänge dieses Servos.
  ~param height Die räumliche Höhenlänge dieses Servos.
  ~param width Die räumliche Breitenlänge dieses Servos.

  ~param curPosition Die aktuelle Position.
  ~param highlightColor Die Farbe des aktiven Servos.
  ~param highlighted Das Aktiv Flag des Servos.
  ~param maxDegree Der maximale Gradwert des Servos.
  ~param minDegree Der minimale Gradwert des Servos.
}
constructor TServoModel.Create(color : TColor; depth, height, width : Real; curPosition : Real; highlightColor : TColor;
                               highlighted : Boolean; maxDegree, minDegree : Real);
begin
  inherited Create(color, depth, height, width);

  Self.curPosition    := curPosition;
  Self.highlightColor := highlightColor;
  Self.highlighted    := highlighted;
  Self.maxDegree      := maxDegree;
  Self.minDegree      := minDegree;
  updateCurDegree(curPosition, maxDegree, minDegree);

  updateGUI := true;
end;

{
  Standard Destruktor, der dieses Model wieder freigibt.
}
destructor TServoModel.Destroy();
begin
  inherited Destroy();
end;


// =================================
//   G E T T E R - M E T H O D E N
// =================================

{
  ~result Liefert den aktuelle Gradwert des Servos im Bereich von 0° bis 360° zurück.
}
function TServoModel.GetCurDegree() : Real;
begin
  result := Self.curDegree;
end;

{
  ~result Liefert die aktuelle Position des Servos im Bereich von 0 bis 100 zurück.
}
function TServoModel.GetCurPosition() : Real;
begin
  result := Self.curPosition;
end;

{
  ~result Liefert den Farbwert, wenn der Servos aktiv ist zurück.
}
function TServoModel.GetHighlightColor() : TColor;
begin
  result := Self.highlightColor;
end;

{
  ~result Liefert ~[code true], falls der Servo momentan aktiv ist. Andernsfalls wird ~[code false] zurückgegeben.
}
function TServoModel.GetHighlighted() : Boolean;
begin
  result := Self.highlighted;
end;

{
  ~result Liefert den maximalen Gradwert des Servos im Bereich von 0° bis 360° zurück.
}
function TServoModel.GetMaxDegree() : Real;
begin
  result := Self.maxDegree;
end;

{
  ~result Liefert den minimalen Gradwert des Servos im Bereich von 0° bis 360° zurück.
}
function TServoModel.GetMinDegree() : Real;
begin
  result := Self.minDegree;
end;


// =================================
//   S E T T E R - M E T H O D E N
// =================================

{
  Setzt den aktuellen Gradwert des Servos, falls sich der neue Wert vom Alten unterscheidet.
  Der übergebene Wert muss im Bereich von 0° bis 360° liegen. Ist dies nicht der Fall, so wird der übergebene Wert
  auf diesen Bereich abgebildet.


  ~param curDegree Der aktuelle Gradwert.
}
procedure TServoModel.SetCurDegree(curDegree : Real);
var percent : Real;
begin
  if(Self.curDegree <> curDegree) then
  begin
    correctDegree(curDegree);
    Self.curDegree := curDegree;

    updateCurPosition(curDegree, Self.maxDegree, Self.minDegree);

    if(updateGUI) then
      syncViews();
  end;
end;

{
  Setzt die aktuellen Position des Servos, falls sich der neue Wert vom Alten unterscheidet. Über die Position wird
  auch der aktuelle Gradwert des Servos neu berechnet und gesetzt.

  ~param curPosition Die aktuelle Position.
}
procedure TServoModel.SetCurPosition(curPosition : Real);
var degree : Real;
begin
  if(Self.curPosition <> curPosition) then
  begin
    correctPercent(curPosition);
    Self.curPosition := curPosition;

    updateCurDegree(curPosition, Self.maxDegree, Self.minDegree);

    if(updateGUI) then
      syncViews();
  end;
end;

{
  Setzt die Farbe des Servos, wenn dieser Aktiv ist, falls sich der neue Wert vom Alten unterscheidet.

  ~param highlightColor Die Farbe des aktiven Servos.
}
procedure TServoModel.SetHighlightColor(highlightColor : TColor);
begin
  if(Self.highlightColor <> highlightColor) then
  begin
    Self.highlightColor := highlightColor;

    if(updateGUI) then
      syncViews();
  end;
end;

{
  Setzt das Flag, ob der Servo aktiv ist, falls sich der neue Wert vom Alten unterscheidet. ~[br]
  true: Der Servo ist aktiv und wird in der ~[code highlightColor] Farbe gezeichnet ~[br]
  false: Der Servo ist inaktiv und wird in der ~[code color] Farbe gezeichnet.

  ~param highlighted Das Aktiv Flag des Servos.
}
procedure TServoModel.SetHighlighted(highlighted : Boolean);
begin
  if(Self.highlighted <> highlighted) then
  begin
    Self.highlighted := highlighted;

    if(updateGUI) then
      syncViews();
  end;
end;

{
  Setzt den maximalen Gradwert des Servos, falls sich der neue Wert vom Alten unterscheidet.

  ~param maxDegree Der maximale Gradwert des Servos.
}
procedure TServoModel.SetMaxDegree(maxDegree : Real);
begin
  if(Self.maxDegree <> maxDegree) then
  begin
    correctDegree(maxDegree);
    Self.maxDegree := maxDegree;

    updateCurDegree(Self.curPosition, maxDegree, Self.minDegree);

    if(updateGUI) then
      syncViews();
  end;
end;

{
  Setzt den minimalen Gradwert des Servos, falls sich der neue Wert vom Alten unterscheidet.

  ~param minDegree Der minimale Gradwert des Servos.
}
procedure TServoModel.SetMinDegree(minDegree : Real);
begin
  if(Self.minDegree <> minDegree) then
  begin
    correctDegree(minDegree);
    Self.minDegree := minDegree;

    updateCurDegree(Self.curPosition, Self.maxDegree, minDegree);

    if(updateGUI) then
      syncViews();
  end;
end;

{
  Setzt alle übergebenen Werte, falls diese sich geändert haben.

  ~param curDegree Der aktuelle Gradwert.
  ~param highlightColor Die Farbe des aktiven Servos.
  ~param highlighted Das Aktiv Flag des Servos.
  ~param maxDegree Der maximale Gradwert des Servos.
  ~param minDegree Der minimale Gradwert des Servos.
}
procedure TServoModel.SetValuesWithDegree(curDegree : Real; highlightColor : TColor; highlighted : Boolean;
                                          maxDegree, minDegree : Real);
begin
  updateGUI := false;
  Self.SetCurDegree(curDegree);
  Self.SetHighlightColor(highlightColor);
  Self.SetMaxDegree(maxDegree);
  Self.SetMinDegree(minDegree);
  updateGUI := true;

  syncViews();
end;

{
  Setzt alle übergebenen Werte, falls diese sich geändert haben.

  ~param curPosition Die aktuelle Position.
  ~param highlightColor Die Farbe des aktiven Servos.
  ~param highlighted Das Aktiv Flag des Servos.
  ~param maxDegree Der maximale Gradwert des Servos.
  ~param minDegree Der minimale Gradwert des Servos.
}
procedure TServoModel.SetValuesWithPosition(curPosition : Real; highlightColor : TColor; highlighted : Boolean;
                                            maxDegree, minDegree : Real);
begin
  updateGUI := false;
  Self.SetCurPosition(curPosition);
  Self.SetHighlightColor(highlightColor);
  Self.SetMaxDegree(maxDegree);
  Self.SetMinDegree(minDegree);
  updateGUI := true;

  syncViews();
end;


// ===================================
//   P R I V A T E - M E T H O D E N
// ===================================

{
  Diese Prozedur korrigiert Gradwerte, indem nur ein Bereich von 0 bis 360 zugelassen wird.
  Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.

  ~param degree Der zu korrigierende Gradwert
}
procedure TServoModel.correctDegree(var degree : Real);
begin
  if(degree > 360) then degree := 360;
  if(degree < 0) then degree := 0;
end;

{
  Diese Prozedur korrigiert Prozentwerte, indem nur ein Bereich von 0 bis 100 zugelassen wird.
  Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.

  ~param percent Der zu korrigierende Prozendwert
}
procedure TServoModel.correctPercent(var percent : Real);
begin
  if(percent > 100) then percent := 100;
  if(percent < 0) then percent := 0;
end;

{
  Aktualisiert den aktuellen Gradwert mittels der übergebenen Werte.

  ~param curPosition Die aktuelle Position.
  ~param maxDegree Der maximale Gradwert des Servos.
  ~param minDegree Der minimale Gradwert des Servos.
}
procedure TServoModel.updateCurDegree(var curPosition : Real; var maxDegree : Real; var minDegree : Real);
begin
  Self.curDegree := (maxDegree - minDegree) * curPosition / 100.0 + minDegree;
end;

{
  Aktualisiert den aktuellen Positionswert mittels der übergebenen Werte.

  ~param curDegree Der aktuelle Gradwert.
  ~param maxDegree Der maximale Gradwert des Servos.
  ~param minDegree Der minimale Gradwert des Servos.
}
procedure TServoModel.updateCurPosition(var curDegree : Real; var maxDegree : Real; var minDegree : Real);
begin
  Self.curPosition := (curDegree - minDegree) / (maxDegree - minDegree) * 100;
end;

{
  Inkrementiert den Positionswert.
}
procedure TServoModel.IncPosition();
begin
  SetCurPosition(Self.curPosition + 1);
end;

{
  Dekrementiert den Positionswert.
}
procedure TServoModel.DecPosition();
begin
  SetCurPosition(Self.curPosition - 1);
end;

end.
