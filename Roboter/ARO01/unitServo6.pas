{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitServo6;

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
    Diese Klasse zeichnet den Servo6. Dabei stehen verschiedene Methoden für die jeweiligen Skins zur Verfügung, die
    den Servo6 unterschiedlich zeichnen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitAbstractServo.TAbstractServo Die Oberklasse dieses Servos
    ~see unitServoModel.TServoModel Das Model dieses Servos
  }
  TServo6 = class(TAbstractServo)

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

{
  Konstruktor, der eine Instanz dieser Klasse erzeugt und den Besitzer und das Model des Roboterarms setzt.
  Erzeugt ebenfalls das ~[code TServoModel] Objekt und setzt die Defaultwerte.

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TServo6.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  Self.servoModel := TServoModel.Create($00a08179, 7.0, 30.0, 7.0, 50.0, clRed, false, 180.0, 0.0);
  Self.servoModel.addObserver(roboarmModel);
  LOG := TLogLogger.GetLogger(TServo6);
end;

{
  Standard Destruktor, der diesen Servo und alle erstellten Ressourcen wieder freigibt.
}
destructor TServo6.Destroy;
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
function TServo6.GetModel() : TServoModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.servoModel;
end;

{
  Zeichnet diesen Servo in Anhängigkeit des ausgewählten Styles.
}
procedure TServo6.Render();
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
procedure TServo6.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
    width, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  if(roboarmModel.GetSelectedServo = SERVO_6) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2]);

  width := servoModel.GetWidth();
  height := servoModel.GetHeight();
  depth := servoModel.GetDepth();

  slices := getSlices(width / 2);
  stacks := getStacks(height);
  loops := getLoops(width / 2);

  glPushMatrix();
    glTranslatef(0, 0, -height);

    glPushMatrix();
      glTranslatef((120-servoModel.GetCurPosition()) / 100 * ( -25 + width ), 0, 0);
      gluDisk(obj, 0, Self.servoModel.GetWidth()/2, slices, loops);
      gluCylinder(obj, width/2, width/2, height, slices, stacks);
    glPopMatrix();

    glRotatef(180, 0, 0, 1);

    glTranslatef((120-servoModel.GetCurPosition()) / 100 * (-25 + width), 0, 0);
    gluDisk(obj, 0, Self.servoModel.GetWidth()/2, slices, loops);
    gluCylinder(obj, width/2, width/2, height, slices, stacks);

  glPopMatrix();
end;

{
  Zeichnet die detailierte Variante des Servo 6. Alle Größen sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements benötigt wird und die Zeicheninformationen enthällt.
}
procedure TServo6.RenderExtended(obj: PGLUQuadric);
var P1 : TVector3d;
    x, y, z : GLdouble;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  glPushMatrix();
    glPushMatrix();
      glRotatef(-90, 1, 0, 0);
      glRotatef(180, 0, 0, 1);
      P1[0] := 0; P1[1] := 16.5; P1[2] := -3.4;
      drawServo(obj, P1, roboarmModel.GetSelectedServo() = SERVO_6);
    glPopMatrix();


    glPushMatrix();
//      glcolor3f(1,0,0);
//      glTranslatef(0, 0, GW_TOTAL_DEPTH - F_BACK_QUAD1_DEPTH + F_TOTAL_DEPTH -F_PAD_QUAD_DEPTH / 2);
//      roboarmModel.SetGripperXYZ();
//      gluSphere(obj, 1, 10, 10);
//      glcolor3f(1,1,1);
    glPopMatrix();

    glPushMatrix();
      glTranslatef((100-servoModel.GetCurPosition()) / 100 * (-GW_TOTAL_WIDTH / 2 + F_TOTAL_WIDTH), 0, 0);
      P1[0] := -F_TOTAL_WIDTH; P1[1] := GW_FRONT_QUADER_HEIGHT / 2 + GW_FRONT_PIN_HEIGHT + F_BACK_QUAD1_HEIGHT + 0.7;
      P1[2] := GW_TOTAL_DEPTH - F_BACK_QUAD1_DEPTH;
      drawFingerLeft(obj, P1, roboarmModel.GetSelectedServo = SERVO_6);
    glPopMatrix();

    glRotatef(180, 0, 0, 1);

    glTranslatef((100-servoModel.GetCurPosition()) / 100 * (-GW_TOTAL_WIDTH / 2 + F_TOTAL_WIDTH), 0, 0);
    P1[0] := -F_TOTAL_WIDTH; P1[1] := GW_FRONT_QUADER_HEIGHT / 2 + GW_FRONT_PIN_HEIGHT + F_BACK_QUAD1_HEIGHT - 0.55;
    P1[2] := GW_TOTAL_DEPTH - F_BACK_QUAD1_DEPTH;
    drawFingerLeft(obj, P1, roboarmModel.GetSelectedServo = SERVO_6);

  glPopMatrix();
end;

end.
