{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitOpenGLConfigUtil;

interface

uses
  // Delphi Klassen
  Windows, Graphics,
  
  // OpenGL Klassen
  DGLOpenGL;

type

  {
    Diese Klasse stellt verschiedene Methoden zur Konfiguration des OopenGL Kontextes.

    ~author Copyright © Thomas Gattinger (2010)
  }
  TOpenGLConfigUtil = class(TObject)

  private
    lightEnabled : Boolean;
    configMode   : Integer;  // 0 - Gitter, 1 - Ausgefüllt

    constructor Create();
  public
    destructor Destroy(); override;
    class function getInstance() : TOpenGLConfigUtil;

    procedure ConfigureGitter(var obj : PGLUQuadric; setConfigMode : Boolean);
    procedure ConfigureSimple(var obj : PGLUQuadric; setConfigMode : Boolean);
    procedure resetOriginalConfig(var obj : PGLUQuadric);
    procedure EnableLight();
    procedure DisableLight();
    function  IsLightEnabled() : Boolean;
    procedure PrepairMask();
    procedure AktivateMask();
    procedure DisableMask();
  end;

var openGLConfigUtil : TOpenGLConfigUtil;

implementation

{
  Liefert die einzige Instanz dieser Klasse. (Singleton - Pattern)
}
class function TOpenGLConfigUtil.getInstance() : TOpenGLConfigUtil;
begin
  if(openGLConfigUtil = nil) then
    openGLConfigUtil := TOpenGLConfigUtil.Create();

  result := openGLConfigUtil;
end;

{
  Privater Konstruktor, der eine Instanz dieser Klasse erzeugt.
}
constructor TOpenGLConfigUtil.Create();
begin
  inherited Create();

  configMode := 0;
end;

{
  Standard Destruktor, der diese Instanz und alle Ressourcen wieder freigibt.
}
destructor TOpenGLConfigUtil.Destroy();
begin
  if(openGLConfigUtil = Self) then
    openGLConfigUtil := nil;

  inherited Destroy();
end;


// ===================================
//   P U B L I C - M E T H O D E N
// ===================================

{
  Konfiguriert das QuadricObject sodass die einzelnen Teile als Gitter-Konstrukt dargestellt werden.
}
procedure TOpenGLConfigUtil.ConfigureGitter(var obj : PGLUQuadric; setConfigMode : Boolean);
begin
  gluQuadricDrawStyle(obj, GLU_LINE);
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

  if(setConfigMode) then configMode := 0;
end;

{
  Konfiguriert das QuadricObject sodass die einzelnen Teile gefüllt und mit geglätetem Schatteneffekt bei aktiviertem
  Licht gezeichnet werden.
}
procedure TOpenGLConfigUtil.ConfigureSimple(var obj : PGLUQuadric; setConfigMode : Boolean);
begin
  gluQuadricDrawStyle(obj, GLU_FILL);
  gluQuadricNormals(obj, GLU_SMOOTH);
//  glShadeModel(GL_SMOOTH);
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

  glEnable(GL_LINE_SMOOTH);               // Use Line smooting
  glEnable(GL_BLEND);                     // Enable Blending
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); // Set the type of blending
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST); // Use the Nicest Smooting possible
  glLineWidth(1.5);                       // Set the line width to 1.5

  glShadeModel(GL_SMOOTH);                  // Do not shade the Model
  glDepthFunc(GL_LEQUAL);                 // Set the Depth Function to Linear Equal
  glEnable(GL_DEPTH_TEST);                // Enable Depth Testing

//  glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);// Only draw outlines of polygons
  if(setConfigMode) then configMode := 1;
end;

procedure TOpenGLConfigUtil.resetOriginalConfig(var obj : PGLUQuadric);
begin
  if(configMode = 0) then ConfigureGitter(obj, false);
  if(configMode = 1) then ConfigureSimple(obj, false);
end;

{
  Konfiguriert OpenGL für Lichteffekte.
}
procedure TOpenGLConfigUtil.EnableLight();
begin
  glEnable(GL_LIGHTING);            // Licht aktivieren
  glEnable(GL_LIGHT0);              // Lichtquelle 0 aktivieren
  glEnable(GL_COLOR_MATERIAL);
  Self.lightEnabled := true;
end;

{
  Deaktiviert sämtliche Lichteffekte.
}
procedure TOpenGLConfigUtil.DisableLight();
begin
  glDisable(GL_LIGHTING);            // Licht deaktivieren
  glDisable(GL_LIGHT0);              // Lichtquelle 0 deaktivieren
  glDisable(GL_COLOR_MATERIAL);
  Self.lightEnabled := false;
end;

{
  Gibt an, ob der Lichtmodus momenatn aktiviert oder deaktiviert ist.

  ~result true, falls der Lichtmodus aktiv ist. false, falls der Lichtmodus deaktiviert ist.
}
function TOpenGLConfigUtil.IsLightEnabled() : Boolean;
begin
  result := Self.lightEnabled;
end;

{}
procedure TOpenGLConfigUtil.PrepairMask();
begin
      glEnable(GL_STENCIL_TEST);
      glClear(GL_STENCIL_BUFFER_BIT);
      glStencilFunc(GL_ALWAYS, 1, 1);
      glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE);
      glColorMask(false, false, false, false);
      glDepthMask(FALSE);
end;

{}
procedure TOpenGLConfigUtil.AktivateMask();
begin
      glDepthMask(true);
      glColorMask(true, true, true, true);
      glStencilFunc(GL_EQUAL, 0, 1);
      glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
end;

procedure TOpenGLConfigUtil.DisableMask();
begin
        glDisable(GL_STENCIL_TEST);
end;

end.
