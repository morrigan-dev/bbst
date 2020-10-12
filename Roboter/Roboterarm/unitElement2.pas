unit unitElement2;

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
    Diese Klasse zeichnet das Element2. Dabei stehen verschiedene Methoden für die jeweiligen Skins zur Verfügung, die
    das Element2 unterschiedlich zeichnen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitAbstractElement.TAbstractElement Die Oberklasse dieses Elements
    ~see unitElementModel.TElementModel Das Model dieses Elements
  }
  TElement2 = class(TAbstractElement)

  private
    LOG            : TLogLogger;       // Logger für Debugausgaben
    elementModel   : TElementModel;    // Model dieses Elements

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
  SIMPLE_MODE_RADIUS = 7.5;
  { Höhe des Elements im einfachen Modus in mm  }
  SIMPLE_MODE_HEIGHT = 180.0;

  { Gibt die maximale Höhe des Elements in mm an }
  MAX_HEIGHT = 41;
  { Gibt die Höhe im Mittelstück des Elements in mm an }
  MIDDLE_HEIGHT = 21;
  { Gitb die Breite des hinteren Stücks in mm an }
  BACK_WIDTH = 80;
  { Gibt die Breite des mittleren Stücks in mm an }
  MIDDLE_WIDTH = 70;
  { Gibt den Abstand des mittleren Stücks zum Rand in mm an }
  MIDDLE_V_DISTANCE = 10;
  { Gibt die Breite des vrderen Stücks in mm an }
  FRONT_WIDTH = 59.02;
  { Gibt den Radius des vorderen Halbkreises in mm an }
  FRONT_RADIUS = 20.5;
  { Dicke des Elements in mm }
  THICKNESS = 5;

  { Höhe der rechteckigen Löcher in mm }
  REC_HOLE_HEIGHT = 19.69;
  { Breite der rechteckigen Löcher in mm }
  REC_HOLE_WIDTH = 38.74;
  { Horizontaler Abstand des ersten Lochs zum linken Rand in mm }
  REC1_H_DISTANCE = 18;
  { Horizontaler Abstand des zweiten Lochs zum linken Rand in mm }
  REC2_H_DISTANCE = 20;
  { Vertikaler Abstand beider Löcher zum unteren Rand in mm }
  REC_V_DISTANCE = 10.56;

  { Radius der kleinen Löcher in mm }
  SMALL_HOLE_RADIUS = 1.5;


{
  Dieser Konstruktor erzeugt eine Instanz dieser Klasse und setzt den Besitzer
  und das Model des Roboterarms.

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TElement2.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  Self.elementModel  := TElementModel.Create($00a08179, 10.0, 152.0, 10.0);
  LOG := TLogLogger.GetLogger(TElement2);
end;

{
  Standard Destruktor, der dieses Element und alle erstellten Ressourcen wieder freigibt.
}
destructor TElement2.Destroy;
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
function TElement2.GetModel() : TElementModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.elementModel;
end;

{
  Zeichnet dieses Element in Anhängigkeit des ausgewählten Styles.
}
procedure TElement2.Render();
var obj    : PGLUQuadric;
    util   : TOpenGLConfigUtil;
    color  : TColor;
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
    util.ConfigureGitter(obj, true);
    RenderSimple(obj);
  end;
  ShowObjektMittelpunkt(elementModel.GetColor());

  util.Free();
end;


// ===================================
//   P R I V A T E - M E T H O D E N
// ===================================

{
  Zeichnet den Mantel des Elements.

  ~param obj Das QuadricObject, das zum Zeichnen des Mantels benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement2.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    stacks : Integer;
    width, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  width := elementModel.GetWidth();
  height := elementModel.GetHeight();
  depth := elementModel.GetDepth();

  glPushMatrix();
      glRotatef(90, 0, 1, 0);
      slices := getSlices(width);
      stacks := getStacks(height);
      gluCylinder(obj, width, width, height, slices, stacks);
  glPopMatrix();

  glTranslatef(height, 0, 0);
end;

{
  Zeichnet die detailierte Variante des Elements 2. Alle Größen sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement2.RenderExtended(obj : PGLUQuadric);
var slices : Integer;
    loops  : Integer;
    stacks : Integer;
    util   : TOpenGLConfigUtil;
    quadDiagonalAussen1,
    quadDiagonalAussen2,
    quadDiagonalInnen1,
    quadDiagonalInnen2,
    diagonalP1,
    diagonalP2, p1 : TVector3d;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  glTranslatef(0, 0, 5);
  glPushMatrix();
    p1[0] := 0.2; p1[1] := 0; p1[2] := 0;
    drawServo(obj, p1, roboarmModel.GetSelectedServo() = SERVO_3);
    p1[0] := 152.3; p1[1] := 0; p1[2] := 0;
    drawServo(obj, p1, roboarmModel.GetSelectedServo() = SERVO_4);
  glPopMatrix();

  glTranslatef(-47, -MAX_HEIGHT / 2, 11.2);
  glColor3ub(121, 129, 160);
  glPushMatrix();
      quadDiagonalAussen1[0] := 0;
      quadDiagonalAussen1[1] := 0;
      quadDiagonalAussen1[2] := 0;
      quadDiagonalAussen2[0] := BACK_WIDTH;
      quadDiagonalAussen2[1] := MAX_HEIGHT;
      quadDiagonalAussen2[2] := THICKNESS;

      quadDiagonalInnen1[0] := REC1_H_DISTANCE;
      quadDiagonalInnen1[1] := REC_V_DISTANCE;
      quadDiagonalInnen1[2] := 0;
      quadDiagonalInnen2[0] := REC1_H_DISTANCE + REC_HOLE_WIDTH;
      quadDiagonalInnen2[1] := REC_V_DISTANCE + REC_HOLE_HEIGHT;
      quadDiagonalInnen2[2] := THICKNESS;

      drawQuad(quadDiagonalAussen1, quadDiagonalAussen2, quadDiagonalInnen1, quadDiagonalInnen2);

      glTranslatef(BACK_WIDTH, MIDDLE_V_DISTANCE, 0);

      diagonalP1[0] := 0;
      diagonalP1[1] := 0;
      diagonalP1[2] := 0;
      diagonalP2[0] := MIDDLE_WIDTH;
      diagonalP2[1] := MIDDLE_HEIGHT;
      diagonalP2[2] := THICKNESS;
      drawQuad(diagonalP1, diagonalP2);

      glTranslatef(MIDDLE_WIDTH, -MIDDLE_V_DISTANCE, 0);

      quadDiagonalAussen1[0] := 0;
      quadDiagonalAussen1[1] := 0;
      quadDiagonalAussen1[2] := 0;
      quadDiagonalAussen2[0] := FRONT_WIDTH;
      quadDiagonalAussen2[1] := MAX_HEIGHT;
      quadDiagonalAussen2[2] := THICKNESS;

      quadDiagonalInnen1[0] := REC2_H_DISTANCE;
      quadDiagonalInnen1[1] := REC_V_DISTANCE;
      quadDiagonalInnen1[2] := 0;
      quadDiagonalInnen2[0] := REC2_H_DISTANCE + REC_HOLE_WIDTH;
      quadDiagonalInnen2[1] := REC_V_DISTANCE + REC_HOLE_HEIGHT;
      quadDiagonalInnen2[2] := THICKNESS;

      drawQuad(quadDiagonalAussen1, quadDiagonalAussen2, quadDiagonalInnen1, quadDiagonalInnen2);

      glTranslatef(FRONT_WIDTH, MAX_HEIGHT/2, 0);
      slices := getSlices(FRONT_RADIUS);
      loops := getLoops(FRONT_RADIUS);
      gluPartialDisk(obj, 0, FRONT_RADIUS, slices, loops, 0, 180);
      stacks := getStacks(THICKNESS);
      drawCylinder(obj, 0, FRONT_RADIUS, THICKNESS, slices, stacks, loops, 180);
      glTranslatef(0, 0, THICKNESS);
      gluPartialDisk(obj, 0, FRONT_RADIUS, slices, loops, 0, 180);
  glPopMatrix();

  glTranslatef(BACK_WIDTH + MIDDLE_WIDTH + REC2_H_DISTANCE + 30, REC_HOLE_HEIGHT, 0);
end;

end.
