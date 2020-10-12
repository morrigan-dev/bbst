unit unitServo0;

interface

uses
  // Delphi Klassen
  Classes, SysUtils, Dialogs, Windows,

  // OpenGL Klassen
  DGLOpenGL, glBitmap,

  // log4D Klassen
  Log4D,

  // Eigene Klassen
  unitRoboterarmModel, unitAbstractServo, unitServoModel, unitOpenGLConfigUtil, unitEinzelteile;

type

  {
    Diese Klasse zeichnet den Servo0. Dabei stehen verschiedene Methoden f�r die jeweiligen Skins zur Verf�gung, die
    den Servo0 unterschiedlich zeichnen.

    ~author Copyright � Thomas Gattinger (2010)
    ~see unitAbstractServo.TAbstractServo Die Oberklasse dieses Servos
    ~see unitServoModel.TServoModel Das Model dieses Servos
  }
  TServo0 = class(TAbstractServo)

  private
    LOG          : TLogLogger;    // Logger f�r Debugausgaben
    servoModel   : TServoModel;   // Model dieses Servos

    procedure RenderSimple(obj : PGLUQuadric);
    procedure RenderExtended(obj: PGLUQuadric);

  public
    constructor Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
    destructor Destroy; override;

    function GetModel() : TServoModel;

    procedure Render();
  end;

implementation

uses Graphics, unitAbstractElement;

const
  { Breite des Drehtellers in mm }
  CENTER_RADIUS = 50.0;
  { H�he des Drehtellers in mm }
  CENTER_HEIGHT = 5.0;
  { Radius des mittleren Lochs der Scheibe in mm }
  CENTER_HOLE_RADIUS = 4.0;
  { Au�enradius des Rings auf der Scheibe in mm }
  TOP_RING_OUTER_RADIUS = 4.0;
  { Innenradius des Rings auf der Scheibe in mm }
  TOP_RING_INNER_RADIUS = 3.0;
  { H�he des Rings auf der Scheibe in mm }
  TOP_RING_HEIGHT = 1.0;
  { Radius der kleineren L�cher der Scheibe in mm }
  SMALL_HOLE_RADIUS = 1.195;
  { Abstand der kleinen L�cher zum Mittelpunkt }
  SMALL_HOLE_DISTANCE = 8.33;
  { Au�enradius des Rings unter der Scheibe in mm }
  BOTTOM_RING_OUTER_RADIUS = 5.0;
  { Innenradius des Rings unter der Scheibe in mm }
  BOTTOM_RING_INNER_RADIUS = 4.0;
  { H�he des Rings unter der Scheibe in mm }
  BOTTOM_RING_HEIGHT = 3.49;
  { Abstand vom Mittleren Ring zur Oberkante des vorherigen Elements }
  DISTANCE = 0.99;

{
  Konstruktor, der eine Instanz dieser Klasse erzeugt und den Besitzer und das Model des Roboterarms setzt.
  Erzeugt ebenfalls das ~[code TServoModel] Objekt und setzt die Defaultwerte.

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TServo0.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  Self.servoModel := TServoModel.Create($00a08179, 100.0, 5.0, 100.0, 50.0, clRed, false, 180.0, 0.0);
  Self.servoModel.addObserver(roboarmModel);
  LOG := TLogLogger.GetLogger(TServo0);
end;

{
  Standard Destruktor, der diesen Servo und alle erstellten Ressourcen wieder freigibt.
}
destructor TServo0.Destroy;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('Destroy');

  Self.servoModel.Free();

  inherited Destroy;
end;


// ===================================
//   P U B L I C - M E T H O D E N
// ===================================

{
  Liefert das Model dieses Servos.
}
function TServo0.GetModel() : TServoModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.servoModel;
end;

{
  Zeichnet diesen Servo in Anh�ngigkeit des ausgew�hlten Styles.
}
procedure TServo0.Render();
var obj    : PGLUQuadric;
    util   : TOpenGLConfigUtil;
    color  : TColor;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('Render');

  util := TOpenGLConfigUtil.getInstance();

  obj := gluNewQuadric();

  color := servoModel.GetColor();
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
    showMessage('Der gew�nschte Skin ist f�r diesen Servo nicht verf�gbar.');
    util.ConfigureSimple(obj, true);
  end;
  ShowObjektMittelpunkt(servoModel.GetColor());

  util.Free();
end;


// ===================================
//   P R I V A T E - M E T H O D E N
// ===================================

{
  Zeichnet den Deckel des Servos.

  ~param obj Das QuadricObject, das zum Zeichnen des Deckels ben�tigt wird und die Zeicheninformationen enth�llt.
}
procedure TServo0.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    loops  : Integer;
    stacks : Integer;
    width, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  if(roboarmModel.GetSelectedServo = SERVO_0) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2]);

  width := servoModel.GetWidth();
  height := servoModel.GetHeight();
  depth := servoModel.GetDepth();

//  glRotatef(Self.servoModel.GetCurDegree(), 0, 1, 0);
  glRotatef(180-Self.servoModel.GetCurDegree(), 0, 1, 0);
  glTranslatef(0, height / 2, 0);

  // Deckel
  glPushMatrix();
      glTranslatef(0, height / 2, 0);
      glRotatef(90, 1, 0, 0);
      slices := getSlices(width);
      loops := getLoops(width);
      gluDisk(obj, 0, width / 2, slices, loops);
  glPopMatrix();

  // Mantel
  glPushMatrix();
      glTranslatef(0, height / 2, 0);
      glRotatef(90, 1, 0, 0);
      stacks := getStacks(height);
      gluCylinder(obj, width / 2, width / 2, height, slices, stacks);
  glPopMatrix();

    // Boden
  glPushMatrix();
      glTranslatef(0, -height / 2, 0);
      glRotatef(90, 1, 0, 0);
      gluDisk(obj, 0, width / 2, slices, loops);
  glPopMatrix();

  // Setze Mittelpunkt auf die Oberkante dieses Elements
  glRotatef(180, 0, 1, 0);
end;

{
  Zeichnet die detailierte Variante des Servo 0. Alle Gr��en sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements ben�tigt wird und die Zeicheninformationen enth�llt.
}
procedure TServo0.RenderExtended(obj: PGLUQuadric);
var slices : Integer;
    loops  : Integer;
    stacks : Integer;
    util : TOpenGLConfigUtil;
    i : Integer;
    p1 : TVector3d;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  util := TOpenGLConfigUtil.getInstance();

  glRotatef(180-Self.servoModel.GetCurDegree(), 0, 1, 0);
  glTranslatef(0, TOP_RING_HEIGHT + CENTER_HEIGHT + DISTANCE, 0);

  p1[0] := 0; p1[1] := 0; p1[2] := 0;
  drawDrehTeller(obj, p1, roboarmModel.GetSelectedServo() = SERVO_0);

  glPushMatrix();
    glRotatef(-90, 0, 1, 0);
    glTranslatef(-ASB13_BOTTOM_HOLE_LEFT_DIST, -TOP_RING_HEIGHT, -ASB13_BOTTOM_HOLE_BACK_DIST);
    p1[0] := 0; p1[1] := 0; p1[2] := 0;
    drawASB13(obj, p1, false);
  glPopMatrix();

  // Setze Mittelpunkt auf die Oberkante dieses Elements
  glTranslatef(0, ASB13_THICKNESS, 0);
  glRotatef(180, 0, 1, 0);

end;

end.
