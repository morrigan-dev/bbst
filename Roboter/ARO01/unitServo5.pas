{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitServo5;

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
    Diese Klasse zeichnet den Servo5. Dabei stehen verschiedene Methoden für die jeweiligen Skins zur Verfügung, die
    den Servo5 unterschiedlich zeichnen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitAbstractServo.TAbstractServo Die Oberklasse dieses Servos
    ~see unitServoModel.TServoModel Das Model dieses Servos
  }
  TServo5 = class(TAbstractServo)

  private
    LOG          : TLogLogger;    // Logger für Debugausgaben
    servoModel   : TServoModel;   // Model dieses Servos

    procedure RenderSimple(obj  : PGLUQuadric);
    procedure RenderExtended(obj : PGLUQuadric);

  public
    constructor Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
    destructor Destroy; override;

    function GetModel() : TServoModel;

    procedure Render();
  end;

implementation

uses Graphics, unitAbstractElement;

const
  BBH01_DISTANCE = 1;  // Abstand der bbh-01 Platten

{
  Konstruktor, der eine Instanz dieser Klasse erzeugt und den Besitzer und das Model des Roboterarms setzt.
  Erzeugt ebenfalls das ~[code TServoModel] Objekt und setzt die Defaultwerte.

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TServo5.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  Self.servoModel := TServoModel.Create($006f6f6f, 70.0, 35.0, 35.0, 50.0, clRed, false, 180.0, 0.0);
  Self.servoModel.addObserver(roboarmModel);
  LOG := TLogLogger.GetLogger(TServo5);
end;

{
  Standard Destruktor, der diesen Servo und alle erstellten Ressourcen wieder freigibt.
}
destructor TServo5.Destroy;
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
function TServo5.GetModel() : TServoModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.servoModel;
end;

{
  Zeichnet diesen Servo in Anhängigkeit des ausgewählten Styles.
}
procedure TServo5.Render();
var obj    : PGLUQuadric;
    util   : TOpenGLConfigUtil;
    color  : TColor;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('Render');

  util := TOpenGLConfigUtil.getInstance();

  ShowObjektMittelpunkt(servoModel.GetColor());
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
    showMessage('Der gewünschte Skin ist für diesen Servo nicht verfügbar.');
    util.ConfigureSimple(obj, true);
  end;
end;


// ===================================
//   P R I V A T E - M E T H O D E N
// ===================================

{
  Zeichnet den Servo in einfacher Form.

  ~param obj Das QuadricObject, das zum Zeichnen des Servos benötigt wird und die Zeicheninformationen enthällt.
}
procedure TServo5.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    stacks : Integer;
    width, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  if(roboarmModel.GetSelectedServo = SERVO_5) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2]);

  width := servoModel.GetWidth();
  height := servoModel.GetHeight();
  depth := servoModel.GetDepth();

  // Rotiere um Servo 5
  glRotatef(90, 0, 1, 0);
  glRotatef(180-servoModel.GetCurDegree(), 0, 0, 1);

  glPushMatrix();
      slices := getSlices(width);
      stacks := getStacks(width);
      gluSphere(obj, width/2, slices, stacks);

      glTranslatef(0, 0, -height/2);
      slices := getSlices(width);
      stacks := getStacks(height);
      gluCylinder(obj, width/2, width/2, height/2, slices, stacks);
      gluDisk(obj, 0, width/2, slices, stacks);
  glPopMatrix();

  glTranslatef(0, 0, -height/2);
end;

{
  Zeichnet die detailierte Variante des Servo 5. Alle Größen sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements benötigt wird und die Zeicheninformationen enthällt.
}
procedure TServo5.RenderExtended(obj: PGLUQuadric);
var P1 : TVector3d;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  glPushMatrix();
    glRotatef(180, 0, 0, 1);
    glRotatef(90, 1, 0, 0);
    P1[0] := 0.8; P1[1] := -29.04 - 10.34; P1[2] := -9.14;
    drawServo(obj, p1, roboarmModel.GetSelectedServo() = SERVO_5);
  glPopMatrix();

  glTranslatef(0,-ASB14_THICKNESS,0);
  glPushMatrix();
    glRotatef(-90, 1, 0, 0);
    glRotatef(-90, 0, 0, 1);
    P1[0] := 0; P1[1] := 0; P1[2] := 0;
    drawASB14(obj, p1, false);
  glPopMatrix();

  glTranslatef(0,-BBH01_HEIGHT,0);
  glPushMatrix();
    glRotatef(-90, 1, 0, 0);
    P1[0] := 0; P1[1] := 0; P1[2] := 0;
    drawBBH01(obj, P1, roboarmModel.GetSelectedServo() = SERVO_5);
  glPopMatrix();

  glTranslatef(0,-BBH01_DISTANCE,0);

  // Rotiere um Servo 5
  glRotatef(180-servoModel.GetCurDegree(), 0, 1, 0);

  glPushMatrix();
    glRotatef(90, 1, 0, 0);
    P1[0] := 0; P1[1] := 0; P1[2] := 0;
    drawBBH01(obj, P1, roboarmModel.GetSelectedServo() = SERVO_5);
  glPopMatrix();

  glTranslatef(0,-BBH01_HEIGHT,0);
end;

end.
