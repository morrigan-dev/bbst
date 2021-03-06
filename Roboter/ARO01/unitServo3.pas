{
    Dieses Werk und alle dazugeh�rigen wurden unter folgender Lizenz ver�ffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausf�hrliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitServo3;

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
    Diese Klasse zeichnet den Servo3. Dabei stehen verschiedene Methoden f�r die jeweiligen Skins zur Verf�gung, die
    den Servo3 unterschiedlich zeichnen.

    ~author Copyright � Thomas Gattinger (2010)
    ~see unitAbstractServo.TAbstractServo Die Oberklasse dieses Servos
    ~see unitServoModel.TServoModel Das Model dieses Servos
  }
  TServo3 = class(TAbstractServo)

  private
    LOG          : TLogLogger;    // Logger f�r Debugausgaben
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

uses Graphics;

const
  { H�he / Breite / Tiefe im Einfachen Modus in mm}
  SIMPLE_MODE_RADIUS_WHD = 17.5;

{
  Konstruktor, der eine Instanz dieser Klasse erzeugt und den Besitzer und das Model des Roboterarms setzt.
  Erzeugt ebenfalls das ~[code TServoModel] Objekt und setzt die Defaultwerte.

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TServo3.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  Self.servoModel := TServoModel.Create($00a08179, 35.0, 35.0, 35.0, 100.0, clRed, false, 150.0, 40.0);
  Self.servoModel.addObserver(roboarmModel);
  LOG := TLogLogger.GetLogger(TServo3);
end;

{
  Standard Destruktor, der diesen Servo und alle erstellten Ressourcen wieder freigibt.
}
destructor TServo3.Destroy;
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
function TServo3.GetModel() : TServoModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.servoModel;
end;

{
  Zeichnet diesen Servo in Anh�ngigkeit des ausgew�hlten Styles.
}
procedure TServo3.Render();
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
  Zeichnet den Servo in einfacher Form.

  ~param obj Das QuadricObject, das zum Zeichnen des Servos ben�tigt wird und die Zeicheninformationen enth�llt.
}
procedure TServo3.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    stacks  : Integer;
    width, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  if(roboarmModel.GetSelectedServo = SERVO_3) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2]);


  width := servoModel.GetWidth();
  height := servoModel.GetHeight();
  depth := servoModel.GetDepth();

  glRotatef(180, 0, 1, 0);

  glPushMatrix();
      slices := getSlices(width);
      stacks := getStacks(width);
      gluSphere(obj, width/2, slices, stacks);
  glPopMatrix();

  // Rotiere um Servo 3
  glRotatef(90 + servoModel.GetCurDegree(), 0, 0, 1);
end;

{
  Zeichnet die detailierte Variante des Servo 3. Alle Gr��en sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements ben�tigt wird und die Zeicheninformationen enth�llt.
}
procedure TServo3.RenderExtended(obj: PGLUQuadric);
var P1 : TVector3d;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  glRotatef(180, 0, 1, 0);
  glTranslatef(0, 0, -ASB10_BOTTOM_BOARD_WIDTH / 2 - ASB09_THICKNESS / 2);
  P1[0] := 0; P1[1] := 0; P1[2] := 0;
  drawServoHornPlastic(obj, P1, roboarmModel.GetSelectedServo() = SERVO_3);

  // Rotiere um Servo 3
  glRotatef(90 + servoModel.GetCurDegree(), 0, 0, 1);
  glTranslatef(0, 0, SHP_CENTER_HEIGHT);

end;

end.
