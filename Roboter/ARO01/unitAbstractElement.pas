{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitAbstractElement;

interface

uses
  // Delphi Klassen
  Controls, Classes, Windows, Graphics, Dialogs, SysUtils,

  // OpenGL Klassen
  DGLOpenGL, glBMP,

  // log4D Klassen
  Log4D,

  // Eigene Klassen
  unitRoboterarmModel, unitElementModel;

const
  { Korrekturabstand zur nächsten Fläche, um Grafikfehler zu vermeiden }
  CORRECTION_DISTANCE = 0.05;

type
  TAbstractElement = class (TCustomControl)

  private { Private declarations }
    LOG            : TLogLogger;

  protected {Protected declaraions }
    roboarmModel   : TRoboterarmModel;

    procedure drawQuad(diagonal1, diagonal2 : TVector3d); overload;
    procedure drawQuad(diagonalAussen1, diagonalAussen2, diagonalInnen1, diagonalInnen2 : TVector3d); overload;
    procedure drawQuader(width, height, depth : Real; obj: PGLUQuadric);
    procedure correctRenderValue(var value : Integer);
    procedure ShowObjektMittelpunkt(color : TColor);
    function getSlices(radius : Real) : Integer;
    function getStacks(height : Real) : Integer;
    function getLoops(radius : Real) : Integer;
    function getNormalenVector(p1, p2, p3 : TVector3d) : TVector3d;
    function getLaengeVector(vector : TVector3d) : Real;
  public { Public declarations }
    constructor Create(AOwner: TComponent; roboarmModel : TRoboterarmModel);
    destructor Destroy; override;
  end;

implementation

{
  Dieser Konstruktor ist für die ~[code TAbstractServo] Klasse, um für alle Servo Klassen das ~[code Parent] Attribut
  und das ~[code TRoboterarmModel] initialisiert sind.
}
constructor TAbstractElement.Create(AOwner: TComponent; roboarmModel : TRoboterarmModel);
begin
  inherited Create(AOwner);

  Self.Parent := TWinControl(AOwner);
  Self.roboarmModel := roboarmModel;
  LOG := TLogLogger.GetLogger(TAbstractElement);
end;

destructor TAbstractElement.Destroy;
begin
  inherited Destroy;
end;

procedure TAbstractElement.drawQuad(diagonal1, diagonal2 : TVector3d);
begin
  // Vorderseite
  glBegin(GL_QUADS);
    glNormal3d(0, 0, 1);
    glVertex3f(diagonal1[0], diagonal1[1], diagonal1[2]);
    glVertex3f(diagonal2[0], diagonal1[1], diagonal1[2]);
    glVertex3f(diagonal2[0], diagonal2[1], diagonal1[2]);
    glVertex3f(diagonal1[0], diagonal2[1], diagonal1[2]);
  glEnd;

  // linke Seite
  glBegin(GL_QUADS);
    glNormal3d(1, 0, 0);
    glVertex3f(diagonal1[0], diagonal1[1], diagonal1[2]);
    glVertex3f(diagonal1[0], diagonal2[1], diagonal1[2]);
    glVertex3f(diagonal1[0], diagonal2[1], diagonal2[2]);
    glVertex3f(diagonal1[0], diagonal1[1], diagonal2[2]);
  glEnd;

  // Rückseite
  glBegin(GL_QUADS);
    glNormal3d(0, 0, 1);
    glVertex3f(diagonal1[0], diagonal1[1], diagonal2[2]);
    glVertex3f(diagonal2[0], diagonal1[1], diagonal2[2]);
    glVertex3f(diagonal2[0], diagonal2[1], diagonal2[2]);
    glVertex3f(diagonal1[0], diagonal2[1], diagonal2[2]);
  glEnd;

  // rechte Seite
  glBegin(GL_QUADS);
    glNormal3d(-1, 0, 0);
    glVertex3f(diagonal2[0], diagonal1[1], diagonal1[2]);
    glVertex3f(diagonal2[0], diagonal1[1], diagonal2[2]);
    glVertex3f(diagonal2[0], diagonal2[1], diagonal2[2]);
    glVertex3f(diagonal2[0], diagonal2[1], diagonal1[2]);
  glEnd;

  // Oberseite
  glBegin(GL_QUADS);
    glNormal3d(0, -1, 0);
    glVertex3f(diagonal1[0], diagonal2[1], diagonal1[2]);
    glVertex3f(diagonal2[0], diagonal2[1], diagonal1[2]);
    glVertex3f(diagonal2[0], diagonal2[1], diagonal2[2]);
    glVertex3f(diagonal1[0], diagonal2[1], diagonal2[2]);
  glEnd;

  // Unterseite
  glBegin(GL_QUADS);
    glNormal3d(0, -1, 0);
    glVertex3f(diagonal1[0], diagonal1[1], diagonal1[2]);
    glVertex3f(diagonal2[0], diagonal1[1], diagonal1[2]);
    glVertex3f(diagonal2[0], diagonal1[1], diagonal2[2]);
    glVertex3f(diagonal1[0], diagonal1[1], diagonal2[2]);
  glEnd;
end;

procedure TAbstractElement.drawQuad(diagonalAussen1, diagonalAussen2, diagonalInnen1, diagonalInnen2 : TVector3d);
var diagonalP1, diagonalP2,
    diagonalQ1, diagonalQ2,
    diagonalR1, diagonalR2,
    diagonalS1, diagonalS2 : TVector3d;
begin
  diagonalP1 := diagonalAussen1;
  diagonalP2[0] := diagonalInnen1[0];
  diagonalP2[1] := diagonalAussen2[1];
  diagonalP2[2] := diagonalAussen2[2];
  drawQuad(diagonalP1, diagonalP2);

  diagonalQ1[0] := diagonalInnen1[0];
  diagonalQ1[1] := diagonalAussen1[1];
  diagonalQ1[2] := diagonalAussen1[2];
  diagonalQ2[0] := diagonalInnen2[0];
  diagonalQ2[1] := diagonalInnen1[1];
  diagonalQ2[2] := diagonalAussen2[2];
  drawQuad(diagonalQ1, diagonalQ2);

  diagonalR1[0] := diagonalInnen2[0];
  diagonalR1[1] := diagonalAussen1[1];
  diagonalR1[2] := diagonalAussen1[2];
  diagonalR2 := diagonalAussen2;
  drawQuad(diagonalR1, diagonalR2);

  diagonalS1[0] := diagonalInnen1[0];
  diagonalS1[1] := diagonalInnen2[1];
  diagonalS1[2] := diagonalInnen1[2];
  diagonalS2[0] := diagonalInnen2[0];
  diagonalS2[1] := diagonalAussen2[1];
  diagonalS2[2] := diagonalAussen2[2];
  drawQuad(diagonalS1, diagonalS2);

end;

procedure TAbstractElement.drawQuader(width, height, depth : Real; obj: PGLUQuadric);
var p1, p2, p3, nVec : TVector3d;
begin
//      LOG.Debug('nVec1 = ' + floattostr(nVec[0]) + ' nVec2 = ' + floattostr(nVec[1]) + ' nVec3 = ' + floattostr(nVec[2]));
//      glNormal3d(0, 0, 1);


      // Oberseite
//      glColor3ub(255,0,0);
      glBegin(GL_QUADS);
        glVertex3f(-width / 2, height,  depth / 2);
        glVertex3f( width / 2, height,  depth / 2);
        glVertex3f( width / 2, height, -depth / 2);
        glVertex3f(-width / 2, height, -depth / 2);
      glEnd;

      // Unterseite
      glColor3ub(255,0,0);
      glBegin(GL_QUADS);
        p1[0] := -width / 2; p1[1] := 0; p1[2] :=  depth / 2;
        p2[0] :=  width / 2; p2[1] := 0; p2[2] :=  depth / 2;
        p3[0] :=  width / 2; p3[1] := 0; p3[2] := -depth / 2;
        nVec := getNormalenVector(p1, p2, p3);
        glNormal3d(nVec[0], nVec[1], nVec[2]);
        glVertex3f(-width / 2, 0,  depth / 2);
        glVertex3f( width / 2, 0,  depth / 2);
        glVertex3f( width / 2, 0, -depth / 2);
        glVertex3f(-width / 2, 0, -depth / 2);
      glEnd;

      // Vorderseite
      glColor3ub(255,255,255);
      glBegin(GL_QUADS);
        glVertex3f(-width / 2, height, -depth / 2);
        glVertex3f( width / 2, height, -depth / 2);
        glVertex3f( width / 2,      0, -depth / 2);
        glVertex3f(-width / 2,      0, -depth / 2);
      glEnd;

      // Rückseite
//      glColor3ub(255,255,255);
      glBegin(GL_QUADS);
        glVertex3f(-width / 2, height, depth / 2);
        glVertex3f( width / 2, height, depth / 2);
        glVertex3f( width / 2,      0, depth / 2);
        glVertex3f(-width / 2,      0, depth / 2);
      glEnd;

      // rechte Seite
//      glColor3ub(255,0,0);
      glBegin(GL_QUADS);
        glVertex3f(width / 2, height, -depth / 2);
        glVertex3f(width / 2, height,  depth / 2);
        glVertex3f(width / 2,      0,  depth / 2);
        glVertex3f(width / 2,      0, -depth / 2);
      glEnd;

      // linke Seite
//      glColor3ub(255,255,255);
      glBegin(GL_QUADS);
        glVertex3f(-width / 2, height, -depth / 2);
        glVertex3f(-width / 2, height,  depth / 2);
        glVertex3f(-width / 2,      0,  depth / 2);
        glVertex3f(-width / 2,      0, -depth / 2);
      glEnd;

end;

procedure TAbstractElement.correctRenderValue(var value : Integer);
begin
  if(value < 1) then value := 1;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : ShowObjektMittelpunkt
  *--------------------------------------------------------------------------------------------------------------------
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur zeichnet in das aktuelle Objekt ein Kreuz, welches den geometrischen Mittelpunkt anzeigt.
  * Parameter : keine
  *********************************************************************************************************************
}
procedure TAbstractElement.ShowObjektMittelpunkt(color : TColor);
begin
  if(roboarmModel.IsObjektMittelpunkt()) then
  begin
    // Mittelpunk des Objekts
    glPushMatrix();
      glColor3ub(255, 0, 0);
      glBegin(GL_LINES);
        glVertex3f(-1.5, 0, 0);
        glVertex3f( 1.5, 0, 0);
      glEnd();
      glColor3ub(0, 255, 0);
      glBegin(GL_LINES);
        glVertex3f(0, -1.5, 0);
        glVertex3f(0,  1.5, 0);
      glEnd();
      glColor3ub(0, 0, 255);
      glBegin(GL_LINES);
        glVertex3f(0, 0, -1.5);
        glVertex3f(0, 0,  1.5);
      glEnd();
    glPopMatrix();

    // Stelle ursprüngliche Farbe wieder her
    glColor3ub(GetRValue(ColorToRGB(color)), GetGValue(ColorToRGB(color)), GetBValue(ColorToRGB(color)));
  end;
end;

function TAbstractElement.getSlices(radius : Real) : Integer;
var slices : Integer;
    area   : Real;
begin
  area := 2 * pi * radius;
  slices := round(area / 6);
  if(slices < 20) then slices := 20;
  result := slices;
end;

function TAbstractElement.getStacks(height : Real) : Integer;
var stacks : Integer;
begin
  stacks := round(height / 4);
  if(stacks < 2) then stacks := 2;
  result := stacks;
end;

function TAbstractElement.getLoops(radius : Real) : Integer;
var loops : Integer;
begin
  loops := round(radius / 3);
  if(loops < 2) then loops := 2;
  result := loops;
end;

function TAbstractElement.getNormalenVector(p1, p2, p3 : TVector3d) : TVector3d;
var nVec, u, v : TVector3d;
    nVecLaenge : Real;
begin
  u[0] := p2[0] - p1[0];
  u[1] := p2[1] - p1[1];
  u[2] := p2[2] - p1[2];

  v[0] := p3[0] - p1[0];
  v[1] := p3[1] - p1[1];
  v[2] := p3[2] - p1[2];

  nVec[0] := u[1] * v[2] - u[2] * v[1];
  nVec[1] := u[2] * v[0] - u[0] * v[2];
  nVec[2] := u[0] * v[1] - u[1] * v[0];

  nVecLaenge := getLaengeVector(nVec);
  result[0] := nVec[0] / nVecLaenge;
  result[1] := nVec[1] / nVecLaenge;
  result[2] := nVec[2] / nVecLaenge;
end;

function TAbstractElement.getLaengeVector(vector : TVector3d) : Real;
begin
  result := sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
end;

end.
