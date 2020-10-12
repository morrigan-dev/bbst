unit unitElement1;

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
    Diese Klasse zeichnet das Element1. Dabei stehen verschiedene Methoden für die jeweiligen Skins zur Verfügung, die
    das Element1 unterschiedlich zeichnen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitAbstractElement.TAbstractElement Die Oberklasse dieses Elements
    ~see unitElementModel.TElementModel Das Model dieses Elements
    ~see unitEinzelteile Sammlung an Methoden zum Rendern der einzelnen Teile
  }
  TElement1 = class(TAbstractElement)

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

const
  { Radius des Elements im einfachen Modus in mm }
  SIMPLE_MODE_RADIUS = 8.5;
  { Höhe des Elements im einfachen Modus in mm  }
  SIMPLE_MODE_HEIGHT = 116.0;

{
  Dieser Konstruktor erzeugt eine Instanz dieser Klasse und setzt den Besitzer
  und das Model des Roboterarms.

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TElement1.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  LOG := TLogLogger.GetLogger(TElement1);
  if(LOG.IsTraceEnabled()) then LOG.Trace('Create');

  Self.elementModel  := TElementModel.Create($006f6f6f, 10.0, 92.0, 10.0);
  Self.elementModel.addObserver(roboarmModel);
end;

{
  Standard Destruktor, der dieses Element und alle erstellten Ressourcen wieder freigibt.
}
destructor TElement1.Destroy;
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
function TElement1.GetModel() : TElementModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.elementModel;
end;

{
  Zeichnet dieses Element in Anhängigkeit des ausgewählten Styles.
}
procedure TElement1.Render();
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
    util.ConfigureGitter(obj, true);
    RenderSimple(obj);
  end;
end;


// ===================================
//   P R I V A T E - M E T H O D E N
// ===================================

{
  Zeichnet den Mantel des Elements.

  ~param obj Das QuadricObject, das zum Zeichnen des Mantels benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement1.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    stacks : Integer;
    width, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  width := elementModel.GetWidth();
  height := elementModel.GetHeight();
  depth := elementModel.GetDepth();

  glTranslatef(0, height, 0);
  glPushMatrix();
      glRotatef(90, 1, 0, 0);
      slices := getSlices(width);
      stacks := getStacks(height);
      gluCylinder(obj, width, width, height, slices, stacks);
  glPopMatrix();
end;

{
  Zeichnet die detailierte Variante des Elements 1. Alle Größen sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement1.RenderExtended(obj : PGLUQuadric);
var P1 : TVector3d;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  glTranslatef(0, ASB10_SIDE_BOARD_HEIGHT, 0);
  glPushMatrix();
    glRotatef(90, 0, 1, 0);

    P1[0] := 0; P1[1] := 0; P1[2] := 0;
    drawASB10(obj, P1, false);
    glRotatef(180, 1, 0, 0);
    P1[0] := 0; P1[1] := 0; P1[2] := 0;
    drawASB10(obj, P1, false);
  glPopMatrix();
  glTranslatef(0, ASB10_SIDE_BOARD_HEIGHT, 0);
end;

end.
