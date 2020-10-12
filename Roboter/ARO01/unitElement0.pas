{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitElement0;

interface

uses
  // Delphi Klassen
  Controls, Classes, Windows, Dialogs, Graphics, SysUtils,

  // OpenGL Klassen
  DGLOpenGL, glBitmap,

  // log4D Klassen
  Log4D,

  // Eigene Klassen
  unitRoboterarmModel, unitAbstractElement, unitElementModel, unitOpenGlConfigUtil, unitEinzelteile;

type

  {
    Diese Klasse zeichnet das Element0. Dabei stehen verschiedene Methoden für die jeweiligen Skins zur Verfügung, die
    das Element0 unterschiedlich zeichnen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitAbstractElement.TAbstractElement Die Oberklasse dieses Elements
    ~see unitElementModel.TElementModel Das Model dieses Elements
    ~see unitEinzelteile Sammlung an Methoden zum Rendern der einzelnen Teile
  }
  TElement0 = class(TAbstractElement)

  private
    LOG            : TLogLogger;     // Logger für Debugausgaben
    elementModel   : TElementModel;  // Model dieses Elements

    procedure RenderSimple(obj : PGLUQuadric);
    procedure RenderExtended(obj : PGLUQuadric);

  public
    constructor Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
    destructor Destroy; override;

    function GetModel() : TElementModel;

    procedure Render();
  end;

implementation

{
  Dieser Konstruktor erzeugt eine Instanz dieser Klasse und setzt den Besitzer und das Model des Roboterarms.
  Außerdem werden die Orginalmaße des Elements gesetzt. Die Maße beziehen sich auf den detailierten Style. Dabei nimmt
  der Zylinder den größten Teil aus. Dieser Teil ist auch in der Größe variable. Die kleinen Pins zur Befestigung haben
  immer eine Maße von 6mm x 3mm x 5mm

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TElement0.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  LOG := TLogLogger.GetLogger(TElement0);
  if(LOG.IsTraceEnabled()) then LOG.Trace('Create');

  Self.elementModel  := TElementModel.Create($00a08179, 100.0, 47.0, 100.0);
  Self.elementModel.addObserver(roboarmModel);
end;

{
  Standard Destruktor, der dieses Element und alle erstellten Ressourcen wieder freigibt.
}
destructor TElement0.Destroy;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('Destroy');

  Self.elementModel.Free();

  inherited Destroy;
end;


// ===================================
//   P U B L I C - M E T H O D E N
// ===================================

{
  Liefert das Model dieses Elements.
}
function TElement0.GetModel() : TElementModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.elementModel;
end;

{
  Zeichnet dieses Element in Anhängigkeit des ausgewählten Styles.
}
procedure TElement0.Render();
var obj  : PGLUQuadric;        // OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
    util : TOpenGLConfigUtil;  // Util für diverse OpenGl Konfigurationen
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('Render');

  util := TOpenGLConfigUtil.getInstance();
  obj := gluNewQuadric;

  color := elementModel.GetColor();
  glColor3ub(GetRValue(ColorToRGB(color)), GetGValue(ColorToRGB(color)), GetBValue(ColorToRGB(color)));

  if(Self.roboarmModel.GetSkin() = SimpleGrid) then
  begin
    util.ConfigureGitter(obj, true);
    RenderSimple(obj);
  end
  else if(Self.roboarmModel.GetSkin() = SimpleFull) then
  begin
    util.ConfigureSimple(obj, true);
    RenderSimple(obj);
  end
  else if(Self.roboarmModel.GetSkin() = DetailedGrid) then
  begin
    util.ConfigureGitter(obj, true);
    RenderExtended(obj);
  end
  else if(Self.roboarmModel.GetSkin() = DetailedFull) then
  begin
    util.ConfigureSimple(obj, true);
    RenderExtended(obj);
  end
  else
  begin
    LOG.Warn('Render: Der gewählte Style ist nicht verfügbar!');
    util.ConfigureSimple(obj, true);
    RenderSimple(obj);
  end;
end;


// ===================================
//   P R I V A T E - M E T H O D E N
// ===================================

{
  Zeichnet die einzelnen Teile des Elements 0 in einfacher Form. Es wird nur die grobe Form des Element gzeichnet ohne
  Details.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement0.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    loops  : Integer;
    stacks : Integer;
    radius, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  radius := elementModel.GetWidth() / 2;
  height := elementModel.GetHeight();
  depth := elementModel.GetDepth();

  // Deckel
  glPushMatrix();
      glTranslatef(0, height / 2, 0);
      glRotatef(90, 1, 0, 0);
      slices := getSlices(radius);
      loops  := getLoops(radius);
      gluDisk(obj, 0, radius, slices, loops);
  glPopMatrix();

  // Mantel
  glPushMatrix();
      glTranslatef(0, height / 2, 0);
      glRotatef(90, 1, 0, 0);
      slices := getSlices(radius);
      stacks := getStacks(height);
      gluCylinder(obj, radius, radius, height, slices, stacks);
  glPopMatrix();

  // Boden
  glPushMatrix();
      glTranslatef(0, -height / 2, 0);
      glRotatef(90, 1, 0, 0);
      slices := getSlices(radius);
      loops  := getLoops(radius);
      gluDisk(obj, 0, radius, slices, loops);
  glPopMatrix();

  // Setze Mittelpunkt auf die Oberkante dieses Elements
  glTranslatef(0, height / 2, 0);
end;

{
  Zeichnet die detailierte Variante des Elements 0. Alle Größen sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement0.RenderExtended(obj : PGLUQuadric);
var p1 : TVector3d;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  // Zeichne Servo
  glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glRotatef(90, 0, 0, 1);
    p1[0] := 0; p1[1] := 0; p1[2] := -20;
    drawServo(obj, p1, roboarmModel.GetSelectedServo() = SERVO_0);
  glPopMatrix();

  // Zeichne Hauptteil
  p1[0] := 0; p1[1] := 0; p1[2] := 0;
  drawTeil3(obj, p1, false);

  // Setze Mittelpunkt auf die Oberkante dieses Elements
  glTranslatef(0, T3_CYLINDER_HEIGHT / 2, 0);
end;

end.
