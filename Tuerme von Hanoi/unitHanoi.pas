unit unitHanoi;

interface

uses
  // Delphi Klassen
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  // OpenGl Klassen
  DGLOpenGL,

  // log4D Klassen
  Log4D, ExtCtrls, StdCtrls;

type
  TfrmHanoi = class(TForm)
    pnlScene: TPanel;
    Button1: TButton;
    procedure initOGL;
    procedure destroyOGL;
    procedure Button1Click(Sender: TObject);

  private { Private-Deklarationen }
    LOG :   TLogLogger; // Logger für Debugausgaben

    // Handle auf Zeichenfläche
    // HDC und HGLRC sind Typen die von Windows zur Verfügung gestellt werden. Ihr findet sie in der Unit "Windows".
    DC                                : HDC;
    // Rendering Context
    // (Diese Unit sollte bei einem neuen Projekt bereits durch Delphi eingebunden worden sein.)
    RC                                : HGLRC;
    obj : PGLUQuadric;

    procedure RenderScheibe(position : TVector3d; radius, height : Double; color : TColor);

  public { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;

    procedure Render();

  end;

var
  frmHanoi: TfrmHanoi;

const
    // Diese Konstanten werden für das OpenGL benutzt
    NEAR_CLIPPING = 1;
    FAR_CLIPPING  = 3000;
    RENDERER_TIMER = 30;

    // Position der drei Stapel
    stapel1 : TVector3d = (-70, -25, 0);
    stapel2 : TVector3d = (  0, -25, 0);
    stapel3 : TVector3d = ( 70, -25, 0);

implementation

{$R *.dfm}

{
 Dieser Konstruktor erzeugt eine neue Instanz dieser Klasse und konfiguriert den Debug Logger.

 ~param AOwner Die Komponente, die den Besitzer dieser Klasse darstellt.
}
constructor TfrmHanoi.Create(AOwner: TComponent);
var fileAppender  : TLogFileAppender;
    patternlayout : TLogPatternLayout;
begin
  inherited Create(AOwner);

  LOG := TLogLogger.GetLogger(TfrmHanoi);
  patternlayout := TLogPatternLayout.Create('%d %p [%c]: %m%n');
  fileAppender := TLogFileAppender.Create('DefaultFileAppender', ExtractFilePath(Application.ExeName) + 'hanoi.log');
  fileAppender.Layout := patternlayout;
  LOG.AddAppender(fileAppender);
  LOG.Level := Log4D.Trace;
  LOG.Info('==================== Türme von Hanoi gestartet ====================');
  LOG.Info('');
  LOG.Info('Autor: Thomas Gattinger');
  LOG.Info('Compiler: Delphi 6 Pro');
  LOG.Info('');

  if(LOG.IsDebugEnabled()) then LOG.Debug('Logger wurde erstellt und konfiguriert');
end;

{
  Diese Methode wird direkt nach dem Aufruf des Konstruktors aufgerufen und initialisiert das OpenGL.
  Allerdings ist zu diesem Zeitpunkt die Klasseninstanz bereits vorhanden, sodass mit ihr gearbeitet werden kann.
}
procedure TfrmHanoi.AfterConstruction;
begin
  inherited AfterConstruction;
  if(LOG.IsTraceEnabled()) then LOG.Trace('AfterConstruction');

  initOGL;
end;

{
  Dieser Destruktor gibt alle in dieser Klasse angeforderten Ressourcen wieder frei einschließlich dieser
  Klasseninstanz.
}
destructor TfrmHanoi.Destroy;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('Destroy');

  LOG.FreeInstance;
  inherited Destroy;
end;

{
  Diese Methode initialisiert und konfiguriert das OpenGL.
}
procedure TfrmHanoi.initOGL;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('initOpenGL');

  // Initialisiere OpenGL
  DC:= GetDC(pnlScene.Handle);  // Hier wird der Gerätekontext (Device Context) von Formular Form1 abgefragt.
  if not InitOpenGL then    // Mit InitOpenGL wird OpenGL initialisiert. Wenn das nicht funktioniert, wird die gesamte Anwendung sofort beendet.
  begin
    Application.Terminate
  end;
  RC:= CreateRenderingContext( DC,    // Hier wird der Renderkontext erzeugt. Den braucht OpenGL zum Zeichnen auf das Formular.
                              [opDoubleBuffered],
                              32,
                              24,
                              0,0,0,
                              0);
  ActivateRenderingContext(DC, RC);  // Abschließend wird der Renderkontext aktiviert. OpenGL ist jetzt prinzipiell startbereit.

  // Konfiguriere OpenGL Einstellungen
  glEnable(GL_LINE_SMOOTH);                          // Use Line smooting
  glEnable(GL_BLEND);                                // Enable Blending
  glEnable(GL_DEPTH_TEST);                           // Enable Depth Testing
  glEnable(GL_LIGHTING);                             // Licht aktivieren
  glEnable(GL_LIGHT0);                               // Lichtquelle 0 aktivieren
  glEnable(GL_COLOR_MATERIAL);                       // Materialien Reflektion aktivieren

  obj := gluNewQuadric;

  gluQuadricDrawStyle(obj, GLU_FILL);
  gluQuadricNormals(obj, GLU_SMOOTH);
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); // Set the type of blending
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);         // Use the Nicest Smooting possible
  glLineWidth(1.5);                                  // Set the line width to 1.5
  glShadeModel(GL_SMOOTH);                           // Do not shade the Model
  glDepthFunc(GL_LEQUAL);                            // Set the Depth Function to Linear Equal
  Render;
end;

{
  Diese Methode deaktiviert alle OpenGL Funktionen und gibt den OpenGL Kontext wieder frei.
}
procedure TfrmHanoi.destroyOGL;
begin
  if(LOG.IsTraceEnabled()) then LOG.Trace('destroyOGL');

  glDisable(GL_LINE_SMOOTH);                          // Diable Line smooting
  glDisable(GL_BLEND);                                // Diable Blending
  glDisable(GL_DEPTH_TEST);                           // Diable Depth Testing
  glDisable(GL_LIGHTING);                             // Diable Light
  glDisable(GL_LIGHT0);                               // Diable Light 0
  glDisable(GL_COLOR_MATERIAL);                       // Materialien Reflektion deaktivieren

  DeactivateRenderingContext;
  DestroyRenderingContext(RC);
  ReleaseDC(Self.Handle, DC);
end;

{
  Diese Methode berechnet aus einem Radius die nötigen Slices, damit ein vernünftiger Kreis entsteht.

  ~param radius Der Radius des Kreises zu dem die Slices berechnet werden
  ~return Liefert die Slices zu einem Radius eines Kreises
}
function getSlices(radius : Double) : Integer;
var slices : Integer;   // Slices für den Kreis
    area   : Real;      // Umfang des Kreises
begin
  area := 2 * pi * radius;
  slices := round(area / 6);
  if(slices < 20) then slices := 20;
  result := slices;
end;

{
  Diese Methode berechnet aus einer Höhe die nötigen Stacks, um Schatteneffekte vernünftig berechnen zu können.

  ~param height Die Höhe des Objekts zu dem die Stacks berechnet werden
  ~return Liefert die Stacks zu einer Höhe eines Objekts
}
function getStacks(height : Double) : Integer;
var stacks : Integer;  // Stacks für das Objekt
begin
  stacks := round(height / 4);
  if(stacks < 2) then stacks := 2;
  result := stacks;
end;

{
  Diese Methode berechnet aus einem Radius die nötigen Loops, um Schatteneffekte vernünftig berechnen zu können.

  ~param radius Der Radius des Kreises zu dem die Loops berechnet werden
  ~return Liefert die Loops zu einem Radius eines Kreises
}
function getLoops(radius : Double) : Integer;
var loops : Integer;  // Loops für den Kreis
begin
  loops := round(radius / 3);
  if(loops < 2) then loops := 2;
  result := loops;
end;

{
  Diese Methode zeichnet die OpenGL Scene.
}
procedure TfrmHanoi.Render;
const
    light_position : Array[0..3] of GlFloat = (25.0, 15.0, -50.0, 0.3);
    light_ambient  : Array[0..3] of GlFloat = (0.4, 0.4, 0.35, 0.3);
    light_diffuse  : Array[0..3] of GlFloat = (0.75, 0.75, 0.7, 0.3);
var pos : TVector3d;
begin
  glClearColor(0, 0, 0, 0.0); // Hintergrundfarbe

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;

  // Hier wird wieder die Perspektive gesetzt. Dieser Aufruf und der bei FormResize müssen von den Parametern
  // identisch sein. Sonst sieht die Ausgabe nach einem Resize ganz einfach anders aus. Wenn sich die Perspektive
  // zwischen den Renderdurchgängen nicht ändert, kann dieser Befehl auch weggelassen werden.
  gluPerspective(45.0, pnlScene.Width/pnlScene.Height, NEAR_CLIPPING, FAR_CLIPPING);

  glMatrixMode(GL_MODELVIEW);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glLoadIdentity;

  // Konfiguriere Lichtquelle
  {
  glPushMatrix();
    glTranslatef(light_position[0], light_position[1], light_position[2]);
    glColor3ub(255, 255, 0);
    gluSphere(obj, 2, 20, 20);
  glPopMatrix();
  }

  glLightfv(GL_LIGHT0, GL_AMBIENT,  @light_ambient[0]);
  glLightfv(GL_LIGHT0, GL_DIFFUSE,  @light_diffuse[0]);
  glLightfv(GL_LIGHT0, GL_POSITION, @light_position[0]);
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);

  // Verschiebe Universum
  glTranslatef(0, 0, -200);

  glColor3ub(255, 0, 0);
//  gluSphere(obj, 15, 30, 30);
  RenderScheibe(stapel1, 25, 3, clRed);
  RenderScheibe(stapel2, 25, 3, clGreen);
  RenderScheibe(stapel3, 25, 3, clBlue);

  SwapBuffers(DC);
  glClear(DC);
end;

{
  Diese Methode zeichnet eine einzelne Scheibe.

  ~param width Der Radius der Scheibe in mm
  ~param height Die Höhe der Scheibe in mm
  ~param color Die Farbe der Scheibe als TColor
}
procedure TfrmHanoi.RenderScheibe(position : TVector3d; radius, height : Double; color : TColor);
begin
  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);
    glRotatef(90, 1, 0, 0);

    gluDisk(obj, 0, radius, getSlices(radius), getLoops(radius));
    gluCylinder(obj, radius, radius, height, getSlices(radius), getStacks(height));
    gluDisk(obj, 0, radius, getSlices(radius), getLoops(radius));
  glPopMatrix();
end;

// funktion bewege (Zahl i, Stab a, Stab b, Stab c) {
//    falls (i > 0) {
//       bewege(i-1, a, c, b);
//       verschiebe oberste Scheibe von a nach c;
//       bewege(i-1, b, a, c);
//    }
// }

procedure TfrmHanoi.Button1Click(Sender: TObject);
begin
  Render;
end;



end.
