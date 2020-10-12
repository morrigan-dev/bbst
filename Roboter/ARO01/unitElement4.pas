{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitElement4;

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
    Diese Klasse zeichnet das Element4. Dabei stehen verschiedene Methoden für die jeweiligen Skins zur Verfügung, die
    das Element4 unterschiedlich zeichnen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitAbstractElement.TAbstractElement Die Oberklasse dieses Elements
    ~see unitElementModel.TElementModel Das Model dieses Elements
  }
  TElement4 = class(TAbstractElement)

  private
    LOG            : TLogLogger;        // Logger für Debugausgaben
    elementModel   : TElementModel;     // Model dieses Elements

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
  Dieser Konstruktor erzeugt eine Instanz dieser Klasse und setzt den Besitzer
  und das Model des Roboterarms.

  ~param AOwner Der Besitzer dieser Komponente und gleichzeitig das Eltern Objekt.
  ~param roboarmModel Das Model des Roboterarms.
}
constructor TElement4.Create(AOwner: TComponent; roboarmModel: TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);

  Self.elementModel  := TElementModel.Create(clSkyBlue, 50.0, 3.0, 50.0);
  LOG := TLogLogger.GetLogger(TElement4);
end;

{
  Standard Destruktor, der dieses Element und alle erstellten Ressourcen wieder freigibt.
}
destructor TElement4.Destroy;
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
function TElement4.GetModel() : TElementModel;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('GetModel');

  result := Self.elementModel;
end;

{
  Zeichnet dieses Element in Anhängigkeit des ausgewählten Styles.
}
procedure TElement4.Render();
var obj    : PGLUQuadric;
    util   : TOpenGLConfigUtil;
    color  : TColor;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('Render');

  util := TOpenGLConfigUtil.getInstance();

  ShowObjektMittelpunkt(elementModel.GetColor());
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

  util.Free();
end;


// ===================================
//   P R I V A T E - M E T H O D E N
// ===================================

{
  Zeichnet den Mantel des Elements.

  ~param obj Das QuadricObject, das zum Zeichnen des Mantels benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement4.RenderSimple(obj : PGLUQuadric);
var slices : Integer;
    stacks : Integer;
    width, height, depth : Real;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderSimple(obj)');

  width := elementModel.GetWidth();
  height := elementModel.GetHeight();
  depth := elementModel.GetDepth();

  slices := getSlices(width);
  stacks := getStacks(height);


  glTranslatef(0, 0, -height);

  // Mantel
  glPushMatrix();
      gluDisk(obj, 0, width/2, slices, stacks * 6);
      gluCylinder(obj, width/2, width/2, height, slices, stacks);
      gluDisk(obj, 0, width/2, slices, stacks * 6);
  glPopMatrix();
end;

{
  Zeichnet die detailierte Variante des Servo 6. Alle Größen sind als Konstanten fest vorgegeben.

  ~param obj Das QuadricObject, das zum Zeichnen des Elements benötigt wird und die Zeicheninformationen enthällt.
}
procedure TElement4.RenderExtended(obj: PGLUQuadric);
var P1 : TVector3d;
    x, y, z : GLdouble;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('RenderExtended(obj)');

  glRotatef(90, 1, 0, 0);
  glPushMatrix();
    P1[0] := 0; P1[1] := 0; P1[2] := 0;
    drawTeil1(obj, P1, false);

    glTranslatef(0,0,-1);

    glPushMatrix();
      glRotatef(180, 1, 0, 0);
      glRotatef(180, 0, 0, 1);
      drawGripperWrist(obj, P1, false);
    glPopMatrix();
  glPopMatrix();
end;

end.
