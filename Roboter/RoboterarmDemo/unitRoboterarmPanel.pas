{ *********************************************************************************************************************
  * K L A S S E : unitRoboterarmPanel
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Copyright ® 2010 by Thomas Gattinger, Thomas Rittinger, Frédéric Nickol
  * Datei     : unitRoboterarm.pas
  * Aufgabe   : Diese Unit stellt einen kompletten Roboterarm zur Verfügung. Der Arm besteht aus sechs Elementen
  *             die über sieben Servos bewegt werden können.
  *
  * Compiler  : Delphi 7.0
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
unit unitRoboterarmPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DGLOpenGL, ExtCtrls, StdCtrls, unitServo, unitElement, unitIOpenGL, glBMP;

type

  TConfig = record
    showKoordinatensystem  : Boolean;
    showObjektMittelpunk   : Boolean;
    showRotationMarkierung : Boolean;
    showOpenGLInfoPanel    : Boolean;
    showTexturen           : Boolean;
  end;

  TRoboterarmPanel = class(TCustomControl, IOpenGL)
    procedure initOGL();
    procedure destroyOGL();
    procedure RoboterarmResize(Sender: TObject);
    procedure RoboterarmMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RoboterarmMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure RoboterarmMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RoboterarmDblClick(Sender: TObject);
    procedure RoboterarmMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

  private { Private declarations }


    // Handle auf Zeichenfläche
    // HDC und HGLRC sind Typen die von Windows zur Verfügung gestellt werden. Ihr findet sie in der Unit "Windows".
    DC                                : HDC;
    // Rendering Context
    // (Diese Unit sollte bei einem neuen Projekt bereits durch Delphi eingebunden worden sein.)
    RC                                : HGLRC;

    // Interner Variablenblock
    xRotation     : Real;              // Verantwortlich für die horizontale Rotation des gesamten Universums
    yRotation     : Real;              // Verantwortlich für die vertikale Rotation des gesamten Universums
    oldXRotation  : Real;              // Der alte Rotationsstand der horizontalen Rotation des gesamten Universums
    oldYRotation  : Real;              // Der alte Rotationsstand der vertikalen Rotation des gesamten Universums
    xMove         : Real;              // Gibt die horizontale Verschiebung des Universums an
    yMove         : Real;              // Gibt die vertikale Verschiebung des Universums an
    oldXMove      : Real;              // Der alte horizontale Verschiebungswert des Universums
    oldYMove      : Real;              // Der alte vertikale Verschiebungswert des Universums
    zZoom         : Real;              // Gibt die Tiefenverschiebung des Universums an
    mouseRotation : Boolean;           // Gibt an, ob der Roboterarm per Mausbewegung gedreht werden soll
    mouseMove     : Boolean;           // Gibt an, ob der Roboterarm per Mausbewegung verschoben werden soll
    xMousePos     : Integer;           // x Mausposition zum Zeitpunkt als eine Maustaste gedrückt wurde
    yMousePos     : Integer;           // y Mausposition zum Zeitpunkt als eine Maustaste gedrückt wurde
    panelWidth    : Integer;           // Gibt die Breite des Panels an
    panelHeight   : Integer;           // Gibt die Höhe des Panels an

    wasserBewegung : Real;

    config : TConfig;                  // Erstelle Konfigurationsrecord

    // Erstelle Elementrecords
    Felement0 : TElement;
    Felement1 : TElement;
    Felement2 : TElement;
    Felement3 : TElement;
    Felement4 : TElement;
    Felement5 : TElement;

    // Erstelle Servoobjekte
    Fservo0  : TServo;
    Fservo12 : TServo;
    Fservo3  : TServo;
    Fservo4  : TServo;
    Fservo5  : TServo;
    Fservo6  : TServo;
    Fservo7  : TServo;

    Fwidth   : Integer;
    Fheight  : Integer;

    procedure SetupGL();               // Initialisiere OpenGL
    procedure updateViewport();        // Prüft ob sich die Größe des Panels geändert hat und passt den Viewport an

    procedure Koordinatenraum();       // Zeichnet ein Koordinatensystem in den Universumursprung
    procedure ShowObjektMittelpunkt(); // Zeichnet ein Kreuz in den geometrischen Mittelpunkt eines jeden Objekts
    procedure RenderElement0();        // Zeichnet das Element 0
    procedure RenderElement1();        // Zeichnet das Element 1
    procedure RenderElement2();        // Zeichnet das Element 2
    procedure RenderElement3();        // Zeichnet das Element 3
    procedure RenderElement4();        // Zeichnet das Element 4
    procedure RenderServo0();          // Zeichnet den Servo 0
    procedure RenderServo12();         // Zeichnet die Servos 1 und 2
    procedure RenderServo3();          // Zeichnet den Servo 3
    procedure RenderServo4();          // Zeichnet den Servo 4
    procedure RenderServo5();          // Zeichnet den Servo 5
    procedure RenderServo6();          // Zeichnet den Servo 6
    procedure RenderServo7();          // Zeichnet den Servo 7

    procedure correctRenderValues(var slices : Integer; var stacks: Integer; var loops : Integer);
    procedure correctProzent(var prozent : Real);
    procedure correctGrad(var grad : Real);

    procedure SetWidth(width : Integer);
    procedure SetHeight(height : Integer);

  public { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    destructor Destroy; override;

    procedure initElements();          // Initialisiere die sechs Elemente
    procedure initServos();            // Initialisiere die sieben Servos

    procedure Render();                // Organisiert das Rendering der einzelnen Render-Prozeduren


    // Setter für die Konfiguration
    procedure SetShowKoordinatensystem(configValue : Boolean);
    procedure SetShowObjektMittelpunkt(configValue : Boolean);
    procedure SetShowRotationsmarkierung(configValue : Boolean);
    procedure SetShowOpenGLInfoPanel(configValue : Boolean);
    procedure SetShowTexturen(configValue : Boolean);

  published { Published-Deklarationen }

    property Servo0  : TServo read Fservo0  write Fservo0;
    property Servo12 : TServo read Fservo12 write Fservo12;
    property Servo3  : TServo read Fservo3  write Fservo3;
    property Servo4  : TServo read Fservo4  write Fservo4;
    property Servo5  : TServo read Fservo5  write Fservo5;
    property Servo6  : TServo read Fservo6  write Fservo6;
    property Servo7  : TServo read Fservo7  write Fservo7;

    property Element0  : TElement read Felement0  write Felement0;
    property Element1  : TElement read Felement1  write Felement1;
    property Element2  : TElement read Felement2  write Felement2;
    property Element3  : TElement read Felement3  write Felement3;
    property Element4  : TElement read Felement4  write Felement4;
    property Element5  : TElement read Felement5  write Felement5;

    property Width   : Integer read Fwidth   write SetWidth;
    property Height  : Integer read Fheight  write SetHeight;

  end;

procedure Register;

const
    // Diese Konstanten werden für das OpenGL benutzt
    NEAR_CLIPPING = 1;
    FAR_CLIPPING  = 1000;
    RENDERER_TIMER = 30;

var texture : Array of tglBMP;
    obj     : PGLUQuadric;

implementation

{
  Registriert diese Klasse als Komponente in der Palette Schule.

  ~author Thomas Gattinger
  ~version 1.0
}
procedure Register;
begin
  RegisterComponents('Schule', [TRoboterarmPanel]);
end;

{
  Konstruktor, der eine Instanz dieser Klasse erzeugt.

  ~param AOwner Die Komponente auf der die Instanz liegt.

  ~author Thomas Gattinger
  ~version 1.0
}
constructor TRoboterarmPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Parent := TWinControl(AOwner);
end;

{
  Erzeugt die einzelnen Element und Servo Properties für den Objekt Inspektor.

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.AfterConstruction;
begin
  inherited AfterConstruction;

  Fservo0  := TServo.Create(Self);
  Fservo12 := TServo.Create(Self);
  Fservo3  := TServo.Create(Self);
  Fservo4  := TServo.Create(Self);
  Fservo5  := TServo.Create(Self);
  Fservo6  := TServo.Create(Self);
  Fservo7  := TServo.Create(Self);

  Felement0 := TElement.Create(Self);
  Felement1 := TElement.Create(Self);
  Felement2 := TElement.Create(Self);
  Felement3 := TElement.Create(Self);
  Felement4 := TElement.Create(Self);
  Felement5 := TElement.Create(Self);

  initOGL();

  initElements();
  initServos();
end;

{
  Destruktor, der sämtliche von dieser Klasse erzeugten Objekte wieder freigibt.

  ~author Thomas Gattinger
  ~version 1.0
}
destructor TRoboterarmPanel.Destroy;
begin
  Fservo0.Free;
  Fservo12.Free;
  Fservo3.Free;
  Fservo4.Free;
  Fservo5.Free;
  Fservo6.Free;
  Fservo7.Free;

  Felement0.Free;
  Felement1.Free;
  Felement2.Free;
  Felement3.Free;
  Felement4.Free;
  Felement5.Free;

  inherited Destroy;
end;

{
  Diese Prozedur wird unmittelbar nach der Erstellung des Formulars aufgerufen, initialisiert das OpenGL
  und setzt dessen Startwerte. Anschließend werden die Startwerte des Roboterarms gesetzt.

  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.initOGL();
var i : Integer; // Zählvariable
begin
  DC:= GetDC(Self.Handle);    //Hier wird der Gerätekontext (Device Context) von Formular Form1 abgefragt.

  if not InitOpenGL then   //Mit InitOpenGL wird OpenGL initialisiert. Wenn das nicht funktioniert, wird die gesamte Anwendung sofort beendet.
  begin
    Application.Terminate
  end;
  RC:= CreateRenderingContext( DC,    //Hier wird der Renderkontext erzeugt. Den braucht OpenGL zum Zeichnen auf das Formular.
                              [opDoubleBuffered],
                              32,
                              24,
                              0,0,0,
                              0);
  ActivateRenderingContext(DC, RC);  //Abschließend wird der Renderkontext aktiviert. OpenGL ist jetzt prinzipiell startbereit.

  SetLength(texture, 15);
  texture[0] := TGLBMP.Create('element0_boden.jpg');
  texture[1] := TGLBMP.Create('element0_mantel.jpg');
  texture[2] := TGLBMP.Create('servo0_mantel.jpg');
  texture[3] := TGLBMP.Create('servo0_deckel.jpg');
  texture[4] := TGLBMP.Create('servo12_mantel.jpg');
  texture[5] := TGLBMP.Create('element1_mantel.jpg');
  texture[6] := TGLBMP.Create('servo3_mantel.jpg');
  texture[7] := TGLBMP.Create('element2_mantel.jpg');
  texture[8] := TGLBMP.Create('servo4_mantel.jpg');
  texture[9] := TGLBMP.Create('element3_mantel.jpg');
  texture[10] := TGLBMP.Create('element3_servohalterung_mantel.jpg');
  texture[11] := TGLBMP.Create('servo67_mantel.jpg');
  texture[12] := TGLBMP.Create('element4_mantel.jpg');
  texture[13] := TGLBMP.Create('servo5_mantel.jpg');
  texture[14] := TGLBMP.Create('servo5_deckel.jpg');
  for i := 0 to Length(texture)-1 do
  begin
    texture[i].GenTexture();
  end;
  Application.ProcessMessages;

  obj := gluNewQuadric;

  SetupGL;

  xRotation := 0;
  yRotation := 0;
  xMove := 0;
  yMove := 0;
  zZoom := 0;
  mouseRotation := False;
  panelWidth := 0;
  panelHeight := 0;

  wasserBewegung := 0;

  Self.OnResize := RoboterarmResize;
  Self.OnDblClick := Self.RoboterarmDblClick;
  Self.OnMouseDown := Self.RoboterarmMouseDown;
  Self.OnMouseUp := Self.RoboterarmMouseUp;
  Self.OnMouseMove := Self.RoboterarmMouseMove;
  Self.OnMouseWheel := Self.RoboterarmMouseWheel;

  Render();
end;


{
  Diese Prozedur wird immer dann aufgerufe, wenn sich die Größe des Formulars ändert. Sie passt den OpenGL
  Bereich dem verfügbaren Platz auf dem Formular an.

  ~param Sender Das Objekt, von dem der Aufruf stammt.

  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.RoboterarmResize(Sender: TObject);
begin
  updateViewport();
  Render();
end;

{
  Setzt die Breite des Panels und aktualisiert anschließend die Simulation.

  ~param width Die Breite des Panels in Pixel.

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetWidth(width : Integer);
begin
  if(Self.Fwidth <> width) then
  begin
    Self.Fwidth := width;
    ClientWidth := width;
    Render();
  end;
end;

{
  Setzt die Höhe des Panels und aktualisiert anschließend die Simulation.

  ~param height Die Höhe des Panels in Pixel.

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetHeight(height : Integer);
begin
  if(Self.Fheight <> height) then
  begin
    Self.Fheight := height;
    ClientHeight := height;
    Render();
  end;
end;



{
  Diese Prozedur wird aufgerufen kurz bevor das Formular zerstört wird und der Speicher frei gegeben wird.
  Der OpenGL Context wird nun auch wieder freigegeben.

  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.destroyOGL();
var i : Integer;  // Zählvariable
begin

  gluDeleteQuadric(obj);

  for i := 0 to Length(texture)-1 do
  begin
    texture[i].Free;
  end;

  DeactivateRenderingContext;
  DestroyRenderingContext(RC);
  ReleaseDC(Self.Handle, DC);

end;



{
  Diese Prozedur korrigiert das OpenGL.

  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetupGL();
begin
  glClearColor(0.3, 0.4, 0.7, 1.0); // Hintergrundfarbe: Hier ein leichtes Blau
  glEnable(GL_DEPTH_TEST);          // Tiefentest aktivieren
end;



{
  Diese Prozedur initialisiert alle Elemente mit ihren Startwerten.

  ~author Frédéric Nickol
  ~version 1.0
}
procedure TRoboterarmPanel.initElements();
begin
  // Initialisiere Element 0
  Felement0.width       := 9.0;
  Felement0.height      := 5.0;
  Felement0.depth       := 9.0;
  Felement0.color       := $00000000;

  // Initialisiere Element 1
  Felement1.width       := 1.5;
  Felement1.height      := 13.0;
  Felement1.depth       := 5.0;
  Felement1.color       := $00000000;

  // Initialisiere Element 2
  Felement2.width       := 1.5;
  Felement2.height      := 10.0;
  Felement2.depth       := 2.0;
  Felement2.color       := $00000000;

  // Initialisiere Element 3
  Felement3.width       := 6.0;
  Felement3.height      := 3.0;
  Felement3.depth       := 5.0;
  Felement3.color       := $00000000;

  // Initialisiere Element 4
  Felement4.width       := 6.0;
  Felement4.height      := 3.0;
  Felement4.depth       := 0.5;
  Felement4.color       := $00000000;

  Render();

end;


{
  Diese Prozedur initialisiert alle Servos mit ihren Startwerten.

  ~author Frédéric Nickol
  ~version 1.0
}
procedure TRoboterarmPanel.initServos();
begin
  // Initialisiere Servo 0
  Fservo0.Width                := 9.0;
  Fservo0.Height               := 0.3;
  Fservo0.Depth                := 9.0;
  Fservo0.Color                := $0000CC00;
  Fservo0.HighlightColor       := $000000FF;
  Fservo0.MinGrad              := 0.0;
  Fservo0.MaxGrad              := 180.0;
  Fservo0.AktPos               := 50.0;
  Fservo0.SetHighlighted(False);

  // Initialisiere Servo 1+2
  Fservo12.Width                := 1.5;
  Fservo12.Height               := 1.5;
  Fservo12.Depth                := 6.5;
  Fservo12.Color                := $0000CC00;
  Fservo12.HighlightColor       := $000000FF;
  Fservo12.MinGrad              := 30.0;
  Fservo12.MaxGrad              := 140.0;
  Fservo12.AktPos               := 100.0;
  Fservo12.SetHighlighted(False);

  // Initialisiere Servo 3
  Fservo3.Width                := 1.5;
  Fservo3.Height               := 1.5;
  Fservo3.Depth                := 6.5;
  Fservo3.Color                := $0000CC00;
  Fservo3.HighlightColor       := $000000FF;
  Fservo3.MinGrad              := 40.0;
  Fservo3.MaxGrad              := 150.0;
  Fservo3.AktPos               := 100.0;
  Fservo3.SetHighlighted(False);

  // Initialisiere Servo 4
  Fservo4.Width                := 1.5;
  Fservo4.Height               := 1.5;
  Fservo4.Depth                := 6.5;
  Fservo4.Color                := $0000CC00;
  Fservo4.HighlightColor       := $000000FF;
  Fservo4.MinGrad              := 0.0;
  Fservo4.MaxGrad              := 180.0;
  Fservo4.AktPos               := 50.0;
  Fservo4.SetHighlighted(False);

  // Initialisiere Servo 5
  Fservo5.Width                := 3.0;
  Fservo5.Height               := 0.3;
  Fservo5.Depth                := 3.0;
  Fservo5.Color                := $0000CC00;
  Fservo5.HighlightColor       := $000000FF;
  Fservo5.MinGrad              := 0.0;
  Fservo5.MaxGrad              := 180.0;
  Fservo5.AktPos               := 50.0;
  Fservo5.SetHighlighted(False);

  // Initialisiere Servo 6
  Fservo6.Width                 := 6.0;
  Fservo6.Height                := 3.0;
  Fservo6.Depth                 := 0.5;
  Fservo6.Color                 := $0000CC00;
  Fservo6.HighlightColor        := $000000FF;
  Fservo6.MinGrad               := 0.0;
  Fservo6.MaxGrad               := 180.0;
  Fservo6.AktPos                := 0.0;
  Fservo6.SetHighlighted(false);

    // Initialisiere Servo 7
  Fservo7.Width                 := 6.0;
  Fservo7.Height                := 3.0;
  Fservo7.Depth                 := 0.5;
  Fservo7.Color                 := $0000CC00;
  Fservo7.HighlightColor        := $000000FF;
  Fservo7.MinGrad               := 0.0;
  Fservo7.MaxGrad               := 180.0;
  Fservo7.AktPos                := 0.0;
  Fservo7.SetHighlighted(false);

  Render();

end;

{
  Setzt den Zoomfaktor, entsprechend der Bewegung des Mausrads. Wird das Mausrad nach vorne gedreht, so steigt der Zoom-
  faktor und der Roboterarm wird größer. Entsprechend sinkt der Zoomfaktor, wenn das Mausrad zurückgedreht wird.

  ~param Sender Das Objekt, von dem der Aufruf stammt
  ~param Shift Signalisiert, ob die Shift Taste gedrückt wurde
  ~param WheelDelta Die Schritte die eine Mausradbewegung bewirkt
  ~param MousePos Die Cursorposition des Mauszeigers
  ~param Handled

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.RoboterarmMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
                                                MousePos: TPoint; var Handled: Boolean);
begin
   case WheelDelta of
      120: // Mausrad hoch
      begin
        zZoom := zZoom + 1;
        Render();
      end;

      -120: // Maurad runter
      begin
        zZoom := zZoom - 1;
        Render();
      end;
   end;

end;

{
  Aktiviert je nach Maustaste die Bewegung oder die Rotation. Die linke Maustaste aktiviert die Bewegung, die rechte
  Maustaste aktiviert die Rotation.

  ~param Sender Das Objekt, von dem der Aufruf stammt
  ~param Button Die Maustaste, die gedrückt wurde
  ~param Shift Gibt an, ob die Shift Taste gedrückt wurde
  ~param X Die Position des Mauscursors auf der x-Achse
  ~param Y Die Position des Mauscursors auf der y-Achse

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.RoboterarmMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Self.SetFocus;

  if(Button = mbLeft) then
  begin
    if(mouseMove = False) then
    begin
      mouseMove := True;
      xMousePos := Mouse.CursorPos.X;
      yMousePos := Mouse.CursorPos.Y;
    end;  
  end;

  if(Button = mbRight) then
  begin
    if(mouseRotation = False) then
    begin
      mouseRotation := True;
      xMousePos := Mouse.CursorPos.X;
      yMousePos := Mouse.CursorPos.Y;
    end;
  end;
end;

{
  Verschiebt bzw. Rotiert den Roboterarm, jenachdem welche Aktion momentan aktiv ist.

  ~param Sender Das Objekt, von dem der Aufruf stammt
  ~param Shift Gibt an, ob die Shift Taste gedrückt wurde
  ~param X Die Position des Mauscursors auf der x-Achse
  ~param Y Die Position des Mauscursors auf der y-Achse

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.RoboterarmMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var curMouseXPos : Integer;
    curMouseYPos : Integer;

begin
  if(mouseMove) then
  begin
    curMouseXPos := Mouse.CursorPos.X;
    curMouseYPos := Mouse.CursorPos.Y;
    if(Abs(yMousePos - curMouseYPos) > 0) then
      yMove := oldYMove + (yMousePos - curMouseYPos) * 0.05;
    if(Abs(xMousePos - curMouseXPos) > 0) then
      xMove := oldXMove - (xMousePos - curMouseXPos) * 0.05;

    Render();
  end;

  if(mouseRotation) then
  begin
    // Rotiere Objekt um die zurückgelegte Mausstrecke
    curMouseXPos := Mouse.CursorPos.X;
    curMouseYPos := Mouse.CursorPos.Y;
    if(Abs(yMousePos - curMouseYPos) > 0) then
      xRotation := oldXRotation - (yMousePos - curMouseYPos);
    if(Abs(xMousePos - curMouseXPos) > 0) then
      yRotation := oldYRotation - (xMousePos - curMouseXPos);

    Render();
  end;
end;

{
  Setzt die Bewegungs- und Rotationsflags zurück.

  ~param Sender Das Objekt, von dem der Aufruf stammt
  ~param Button Die Maustaste, die gedrückt wurde
  ~param Shift Gibt an, ob die Shift Taste gedrückt wurde
  ~param X Die Position des Mauscursors auf der x-Achse
  ~param Y Die Position des Mauscursors auf der y-Achse

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.RoboterarmMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseRotation := False;
  mouseMove := False;
  oldXRotation := xRotation;
  oldYRotation := yRotation;
  oldXMove := xMove;
  oldYMove := yMove;
end;

{
  Setzt den Roboterarm auf seine ursprüngliche Perspektive zurück.

  ~param Sender Das Objekt, von dem der Aufruf stammt
  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.RoboterarmDblClick(Sender: TObject);
begin
  xRotation := 0;
  yRotation := 0;
  xMove := 0;
  yMove := 0;
  zZoom := 0;
end;

{
  Aktualisiert die Perspekte von OpenGL.

  ~param keine
  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.updateViewport();
begin
  if(ClientWidth <> panelWidth) or (ClientHeight <> panelHeight) then
  begin

    // Mittels glViewport sagt Ihr OpenGL, wie groß die OpenGL-Ausgabe werden soll. Genau diese Größe hatte sich ja
    // durch das Resize verändert.
    glViewport(0, 0, ClientWidth, ClientHeight);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    // Hier wird eingestellt, wie der Betrachter die Welt sehen soll.
    gluPerspective(45.0, ClientWidth/ClientHeight, NEAR_CLIPPING, FAR_CLIPPING);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity;

    panelWidth  := ClientWidth;
    panelHeight := ClientHeight;

  end;
end;

{
  Diese Prozedur organisiert das Zeichnen der einzelnen Elemente und Servos.
  Um die Drehung der einzelnen Servos auf die nachfolgenden Objekte zu übertragen. wird folgende
  Strategie verfolgt:
     1) Schritt: Setze den Mittelpunkt des Universums auf die Stelle an der der Mittelpunkt des zu
                 zeichnenden Objekt ist.
     2) Schritt: Falls das nächste Objekt ein Servo ist, so rotiere nun das Universum entsprechend dem
                 Rotationsverhalten des Servos. Ist das nächste Objekt kein Servo, so gehe direkt zu
                 Schritt 3)
     3) Schritt: Zeiche das nächste Objekt, sodass dessen Mittelpunkt genau auf dem Mittelpunkt des
                 Universums ist.

  Da wir immer erst das Universum verschieben und drehen sieht es so aus, als würden die Servo Drehungen
  die nachfolgenden Elemente mit sich drehen. In Wirklichkeit drehen wir jedoch alle Objekt, die sich
  bisher im Universum befinden! So gesehen zeichnen wir jedes neue Objekt immer nach dem gleichen Muster.
  Jedes Objekt wird in seiner Grundstellung bei 0 Grad gezeichnet. Die Angaben der Dimensionen
  beziehen sich immer auf das Koordinatensystem des Universums

  ~author Thomas Gattinger
  ~version 1.8
}
procedure TRoboterarmPanel.Render();
var
    startX : Real;  // x-Koorinate des aktuellen Universum Mittelpunkts
    startY : Real;  // y-Koorinate des aktuellen Universum Mittelpunkts
    startZ : Real;  // z-Koorinate des aktuellen Universum Mittelpunkts
begin

  // Dieser Aufruf sorgt dafür, dass Farbpuffer und Tiefenpuffer gelöscht werden. Wenn man das nicht macht,
  // sieht man alles mögliche, nur nicht das, was Ihr rendern wollt. Probiert es ruhig mal ohne aus! Man wird dadurch
  // nicht dümmer. Der Farbpuffer wird nicht einfach gelöscht sondern mit der ClearColor überschrieben,
  // die ihr per glClearColor definiert habt. (siehe FormCreate-Methode)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;

  // Hier wird wieder die Perspektive gesetzt. Dieser Aufruf und der bei FormResize müssen von den Parametern
  // identisch sein. Sonst sieht die Ausgabe nach einem Resize ganz einfach anders aus. Wenn sich die Perspektive
  // zwischen den Renderdurchgängen nicht ändert, kann dieser Befehl auch weggelassen werden.
  gluPerspective(45.0, ClientWidth/ClientHeight, NEAR_CLIPPING, FAR_CLIPPING);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  // Dieser Aufruf verschiebt die "Kamera" etwas nach hinten auf der Z-Achse. Schließlich wollen wir das,
  // was wir zeichnen, auch sehen.
  // Alles, was zu nah ist, wird durch die Near-Clipping Plane abgeschnitten.
  glTranslatef(0, 0, -50);

  // Rotiere das ganze Universum
  glTranslatef(xMove, yMove, zZoom);
  glRotatef(xRotation,1,0,0);
  glRotatef(yRotation,0,1,0);

  if(config.showKoordinatensystem) then
  begin
    // Koordinatenraum zeichnen
    Koordinatenraum();
  end;


  // Verschiebe Universum damit Element 0 gezeichnet werden kann
  startX := 0;
  startY := -15;
  startZ := 0;
  glTranslatef(startX, startY, startZ);
  // Standzylinder ohne Deckplatte zeichnen
  RenderElement0;


  // Verschiebe Universum damit Servo 0 gezeichnet werden kann
  startX := 0;
  startY := Felement0.height/2 + Fservo0.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Rotiere um Servo 0
  glRotatef(Fservo0.GetAktGrad(), 0, 1, 0);

  // Standzylinder mit Deckplatte (Servo 0) zeichnen
  RenderServo0();


  // Verschiebe Universum damit Servo 1+2 gezeichnet werden kann
  startX := 0;
  startY := Fservo0.height + servo12.height/2 - 0.2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Rotiere um Servo 1 + 2
  glRotatef(90 - servo12.GetAktGrad(), 0, 0, 1);

  // Servo 1 und 2 zeichnen
  RenderServo12();


  // Verschiebe Universum damit Element 1 gezeichnet werden kann
  startX := 0;
  startY := Felement1.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Anfang Arm Teil 1 (Element 1) zeichnen
  RenderElement1();


  // Verschiebe Universum damit Servo 3 gezeichnet werden kann
  startX := 0;
  startY := Felement1.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Rotiere um Servo 3
  glRotatef(servo3.GetAktGrad(), 0, 0, 1);

  // Servo 3 zeichnen
  RenderServo3();


  // Verschiebe Universum damit Element 2 gezeichnet werden kann
  startX := 0;
  startY := Felement2.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Anfang Arm Teil 2 (Element 2) zeichnen
  RenderElement2();


  // Verschiebe Universum damit Servo 4 gezeichnet werden kann
  startX := 0;
  startY := Felement2.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Rotiere um Servo 4
  glRotatef((servo4.GetAktGrad()-90) * -1, 0, 0, 1);

  // Servo 4 zeichnen
  RenderServo4();


  // Verschiebe Universum damit Element 3 gezeichnet werden kann
  startX := 0;
  startY := Felement3.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Anfang Arm Teil 3 (Element 3) zeichnen
  RenderElement3();


  // Verschiebe Universum damit Servo 5 gezeichnet werden kann
  startX := 0;
  startY := Felement3.height/2 + servo5.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Rotiere um Servo 5
  glRotatef(servo5.GetAktGrad(), 0, 1, 0);

  // Servo 5 zeichnen
  RenderServo5();


  // Verschiebe Universum damit Element 4 gezeichnet werden kann
  startX := 0;
  startY := Felement4.height/2 + servo5.height/2;
  startZ := 0;
  glTranslatef(startX, startY, startZ);

  // Element 4 zeichnen
  RenderElement4();

  // Servo 6 und 7 zeichnen

  startX := 2.4;
  startY := 0;
  startZ := 0;
  glTranslatef(startX, startY, startZ);
  RenderServo6();
  RenderServo7();

  SwapBuffers(DC);
  glclear(DC);

end;



{
  Diese Prozedur korrigiert Prozentwerte, indem nur ein Bereich von 0 bis 100 zugelassen wird.
  Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.

  ~author Thomas Gattinger
  ~version 1.0
}

procedure TRoboterarmPanel.correctProzent(var prozent : Real);
begin
  // Passe zu große Prozentwerte an, sodass ein Bereich von 0 bis max. 100 Prozent gegeben ist
  while(prozent > 100) do
  begin
    prozent := prozent - 100;
  end;
end;


{
  Diese Prozedur korrigiert Gradwerte, indem nur ein Bereich von 0 bis 360 zugelassen wird.
  Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.correctGrad(var grad : Real);
begin
  // Passe zu große Gradzahlen an, sodass ein Bereich von 0 bis max. 360 Grad gegeben ist
  while(grad > 360) do
  begin
    grad := grad - 360;
  end;
end;


{
  Diese Prozedur korrigiert die Werte der Slices, Stacks und Loops.

  ~param slices Anzahl der ...
  ~param stacks Anzahl der Trennlinien in Bezug auf die Höhe eines Objekts
  ~param loops  Anzahl der Zwischenkreise in einem Kreis

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.correctRenderValues(var slices : Integer; var stacks: Integer; var loops : Integer);
begin
  if(slices < 1) then slices := 1;
  if(stacks < 1) then stacks := 1;
  if(loops < 1) then loops := 1;
end;


{
  Diese Prozedur zeichnet ein Koordinatensystem im Universumursprung

  ~author Frédéric Nickol
  ~version 1.0
}
procedure TRoboterarmPanel.Koordinatenraum;
begin
  // X-Achse
  glPushMatrix();
    glColor3ub(255, 0, 0);
    glBegin(GL_LINES);
      glVertex3f(-20, 0, 0);
      glVertex3f( 20, 0, 0);
    glEnd();
  glPopMatrix();

  // Y-Achse
  glPushMatrix();
    glColor3ub(0, 255, 0);
    glBegin(GL_LINES);
      glVertex3f( 0, -20, 0);
      glVertex3f( 0,  20, 0);
    glEnd();
  glPopMatrix();

  // Z-Achse
  glPushMatrix();
    glColor3ub(0, 0, 255);
    glBegin(GL_LINES);
      glVertex3f( 0, 0, -20);
      glVertex3f( 0, 0,  20);
    glEnd();
  glPopMatrix();
end;


{
  Diese Prozedur zeichnet in das aktuelle Objekt ein Kreuz, welches den geometrischen Mittelpunkt anzeigt.

  ~author Frédéric Nickol
  ~version 1.0
}
procedure TRoboterarmPanel.ShowObjektMittelpunkt();
begin
  if(config.showObjektMittelpunk) then
  begin

    // Mittelpunk des Objekts
    glPushMatrix();
      glColor3ub(255, 255, 255);
      glBegin(GL_LINES);
        glVertex3f(-1, 0, 0);
        glVertex3f( 1, 0, 0);
      glEnd();
      glBegin(GL_LINES);
        glVertex3f(0, -1, 0);
        glVertex3f(0,  1, 0);
      glEnd();
      glBegin(GL_LINES);
        glVertex3f(0, 0, -1);
        glVertex3f(0, 0,  1);
      glEnd();
    glPopMatrix();
  end;
end;


{
  Diese Prozedur zeichnet das Element 0, welches ein nach oben offener Zylinder ist.
  Der Mittelpunkt des Elements ist der geometrische Mittelpunkt.

  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.RenderElement0;
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  slices := round(Felement0.width * 4);
  stacks := round(Felement0.height);
  loops  := round(Felement0.width/2);
  correctRenderValues(slices, stacks, loops);

  ShowObjektMittelpunkt();

  glPushMatrix();

    if(config.showTexturen) then
    begin  // Zeiche Element 0 mit Texturen
      glEnable(GL_TEXTURE_2D);

      // Mantel Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(0,-wasserBewegung,0);
      glMatrixMode(GL_MODELVIEW);

      // Mantel
      glTranslatef(0, Felement0.height/2, 0);
      glRotatef(90, 1, 0, 0);
      glColor3ub(255,255,255);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[1].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, Felement0.width/2, Felement0.width/2, Felement0.height, slices, stacks);
      glRotatef(-90, 1, 0, 0);

      // Boden Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(0, 0, 0);
      glMatrixMode(GL_MODELVIEW);

      // Boden
      glTranslatef(0, -Felement0.height, 0);
      glRotatef(90, 1, 0, 0);
      glColor3ub(255,255,255);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[0].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluDisk(obj, 0, Felement0.width/2, slices, loops);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin  // Zeichne Element 0 als Gitterstruktur ohne Texturen
      // Mantel
      glTranslatef(0, Felement0.height/2, 0);
      glRotatef(90, 1, 0, 0);
      glColor3ub(GetRValue(Felement0.Color), GetGValue(Felement0.Color), GetBValue(Felement0.Color));
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluCylinder(obj, Felement0.width/2, Felement0.width/2, Felement0.height, slices, stacks);
      glRotatef(-90, 1, 0, 0);

      // Boden
      glTranslatef(0, -Felement0.height, 0);
      glRotatef(90, 1, 0, 0);
      glColor3ub(GetRValue(Felement0.Color), GetGValue(Felement0.Color), GetBValue(Felement0.Color));
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluDisk(obj, 0, Felement0.width/2, slices, loops);
    end;

  glPopMatrix();


end;


{
  Diese Prozedur zeichnet das Element 1, welches aus zwei Querstreben besteht.

  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.RenderElement1();
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
    width  : Real;
    height : Real;
    depth  : Real;
begin
  ShowObjektMittelpunkt();

  glPushMatrix();

    if(config.showTexturen) then
    begin // Zeiche Element 1 mit Texturen
      glEnable(GL_TEXTURE_2D);

      // Zylinder Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(0,wasserBewegung/2,0);
      glMatrixMode(GL_MODELVIEW);

      glTranslatef(0, -Felement1.height/2, -Felement1.depth/2);
      glRotatef(-90, 1, 0, 0);

      // Zeichne hinteren Zylinder
      width := Felement1.width/2;
      height := Felement1.height;
      depth := Felement1.depth;
      slices := round(width * 8);
      stacks := round(height);
      loops  := round(width);
      correctRenderValues(slices, stacks, loops);

      glColor3ub(255,255,255);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[5].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, width, width, height, slices, stacks);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -Felement1.depth, 0);

      // Zeichne vorderen Zylinder
      gluCylinder(obj, width, width, height, slices, stacks);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin // Zeichne Element 1 als Gitterstruktur ohne Texturen
      glTranslatef(0, -Felement1.height/2, -Felement1.depth/2);
      glRotatef(-90, 1, 0, 0);
      glColor3ub(GetRValue(Felement1.Color), GetGValue(Felement1.Color), GetBValue(Felement1.Color));
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

      // Zeichne hinteren Zylinder
      width := Felement1.width/2;
      height := Felement1.height;
      depth := Felement1.depth;
      slices := round(width * 8);
      stacks := round(height);
      loops  := round(width);
      correctRenderValues(slices, stacks, loops);
      gluCylinder(gluNewQuadric, width, width, height, slices, stacks);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -Felement1.depth, 0);

      // Zeichne vorderen Zylinder
      gluCylinder(gluNewQuadric, width, width, height, slices, stacks);
    end;

  glPopMatrix();

end;


{
  Diese Prozedur zeichnet das Element 2, welches aus zwei Querstreben besteht.

  ~author Thomas Rittinger
  ~version 1.0
}
procedure TRoboterarmPanel.RenderElement2();
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
    width  : Real;
    height : Real;
    depth  : Real;
begin

  ShowObjektMittelpunkt();

  glPushMatrix();

    if(config.showTexturen) then
    begin
      glEnable(GL_TEXTURE_2D);

      // Zylinder Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(0,wasserBewegung/2,0);
      glMatrixMode(GL_MODELVIEW);

      glTranslatef(0, -Felement2.height/2, -Felement2.depth/2);
      glRotatef(-90, 1, 0, 0);

      // Zeichne hinteren Zylinder
      width := Felement2.width/2;
      height := Felement2.height;
      depth := Felement2.depth;
      slices := round(Felement2.width * 6);
      stacks := round(Felement2.height);
      loops  := round(Felement2.width/2);
      correctRenderValues(slices, stacks, loops);

      glColor3ub(255,255,255);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[7].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, width, width, height, slices, stacks);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -Felement2.depth, 0);

      // Zeichne vorderen Zylinder
      gluCylinder(obj, width, width, height, slices, stacks);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin
      glTranslatef(0, -Felement2.height/2, -Felement2.depth/2);
      glRotatef(-90, 1, 0, 0);
      glColor3ub(GetRValue(Felement2.Color), GetGValue(Felement2.Color), GetBValue(Felement2.Color));
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

      // Zeichne hinteren Zylinder
      width := Felement2.width/2;
      height := Felement2.height;
      depth := Felement2.depth;
      slices := round(Felement2.width * 6);
      stacks := round(Felement2.height);
      loops  := round(Felement2.width/2);
      correctRenderValues(slices, stacks, loops);
      gluCylinder(gluNewQuadric, width, width, height, slices, stacks);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -Felement2.depth, 0);

      // Zeichne vorderen Zylinder
      gluCylinder(gluNewQuadric, width, width, height, slices, stacks);
    end;
  glPopMatrix();
end;



{
  Diese Prozedur zeichnet das Element 3, welches aus zwei Querstreben besteht, die einen Quader
  umschließen.

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.RenderElement3();
var subElement1Width : Real;
    subElement1Height : Real;
    subElement1Depth : Real;
    subElement2Width : Real;
    subElement2Height : Real;
    subElement2Depth : Real;
    slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  ShowObjektMittelpunkt();

  subElement1Width  := Felement3.width * 20.0 / 100.0;
  subElement1Height := Felement3.height;
  subElement1Depth  := Felement3.depth;

  subElement2Width  := Felement3.width * 60.0 / 100.0;
  subElement2Height := Felement3.height;
  subElement2Depth  := Felement3.depth;

  glPushMatrix();

    if(config.showTexturen) then
    begin
      glEnable(GL_TEXTURE_2D);

      // Zylinder Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(0,wasserBewegung/2,0);
      glMatrixMode(GL_MODELVIEW);

      glTranslatef(0, -Felement3.height/2, -Felement3.depth/2);
      glRotatef(-90, 1, 0, 0);

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);

      glColor3ub(255,255,255);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[9].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, subElement1Width/2, subElement1Width/2, subElement1Height, slices, stacks);

      // Wechsel zum Würfelmittelpunkt
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, subElement2Height/3);

      // Zeichne Würfel
      glColor3ub(255,255,255);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[10].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, subElement2Width/2, subElement2Width/2, subElement2Height-subElement2Height/3, 4, 1);


      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, -subElement2Height/3);

      // Zeichne vorderen Zylinder
      glColor3ub(255,255,255);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[9].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, subElement1Width/2, subElement1Width/2, subElement1Height, slices, stacks);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin
      glTranslatef(0, -Felement3.height/2, -Felement3.depth/2);
      glRotatef(-90, 1, 0, 0);

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);

      glColor3ub(GetRValue(Felement1.Color), GetGValue(Felement1.Color), GetBValue(Felement1.Color));
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluCylinder(gluNewQuadric, subElement1Width/2, subElement1Width/2, subElement1Height, slices, stacks);

      // Wechsel zum Würfelmittelpunkt
      glColor3ub(GetRValue(Felement2.Color), GetGValue(Felement2.Color), GetBValue(Felement2.Color));
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, subElement2Height/3);

      // Zeichne Würfel
      gluCylinder(gluNewQuadric, subElement2Width/2, subElement2Width/2, subElement2Height-subElement2Height/3, 4, 1);


      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, -subElement2Height/3);

      // Zeichne vorderen Zylinder
      gluCylinder(gluNewQuadric, subElement1Width/2, subElement1Width/2, subElement1Height, slices, stacks);
    end;

  glPopMatrix();

end;

{
  Diese Prozedur zeichnet das Element 4. Je nach Einstellung wird nur das Gitter oder mit Texturen gezeichnet.

  ~author Thomas Gattinger
  ~version 1.2
}
procedure TRoboterarmPanel.RenderElement4();
var subElement1Width : Real;
    subElement1Height : Real;
    subElement1Depth : Real;
    slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  ShowObjektMittelpunkt();

  subElement1Width  := Felement4.width;
  subElement1Height := Felement4.height;
  subElement1Depth  := Felement4.depth;

  glPushMatrix();

    if(config.showTexturen) then
    begin
      glEnable(GL_TEXTURE_2D);

      // Zylinder Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(0,wasserBewegung/2,0);
      glMatrixMode(GL_MODELVIEW);

      glTranslatef(0, -Felement4.height/2, 0);
      glRotatef(90, 1, 0, 0);
      glColor3ub(GetRValue(Felement4.Color), GetGValue(Felement4.Color), GetBValue(Felement4.Color));

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);

      // Zeichne Würfel
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[12].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, subElement1Width/2, subElement1Width/2, subElement1Depth, 4, 1);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin

      glTranslatef(0, -Felement4.height/2, 0);
      glRotatef(90, 1, 0, 0);
      glColor3ub(GetRValue(Felement4.Color), GetGValue(Felement4.Color), GetBValue(Felement4.Color));
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);

      // Zeichne Würfel
      gluCylinder(obj, subElement1Width/2, subElement1Width/2, subElement1Depth, 4, 1);
    end;

  glPopMatrix();
end;

{
  Diese Prozedur zeichnet den Servo 0. Je nach Einstellung wird nur das Gitter oder mit Texturen gezeichnet.

  ~author Thomas Rittinger
  ~version 1.2
}
procedure TRoboterarmPanel.RenderServo0;
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  slices := round(Fservo0.Width * 4);
  stacks := round(Fservo0.Height);
  loops  := round(Fservo0.Width/2);
  correctRenderValues(slices, stacks, loops);

  ShowObjektMittelpunkt();

  if(config.showTexturen) then
  begin // Zeiche Servo 0 mit Texturen
    glEnable(GL_TEXTURE_2D);

    if(Fservo0.isHighlighted()) then
      glColor3ub(GetRValue(Fservo0.HighlightColor), GetGValue(Fservo0.HighlightColor), GetBValue(Fservo0.HighlightColor))
    else
      glColor3ub(255,255,255);

    // Mantel Textur
    glMatrixMode(GL_TEXTURE);
    glLoadIdentity;
    glTranslatef(0,0,0);
    glMatrixMode(GL_MODELVIEW);

    // Mantel
    glPushMatrix();
      glTranslatef(0, Fservo0.height/2, 0);
      glRotatef(90, 1, 0, 0);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[2].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, Fservo0.width/2, Fservo0.width/2, Fservo0.height, slices, stacks);
    glPopMatrix();

    // Deckel Textur
    glMatrixMode(GL_TEXTURE);
    glLoadIdentity;
    glTranslatef(0,0,0);
    glMatrixMode(GL_MODELVIEW);

    // Deckel
    glPushMatrix();
      glTranslatef(0, Fservo0.height/2, 0);
      glRotatef(90, 1, 0, 0);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[3].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluDisk(obj, 0, Fservo0.width/2, slices, loops);
    glPopMatrix();

    glDisable(GL_TEXTURE_2D);
  end
  else
  begin // Zeichne Servo 0 als Gitterstruktur ohne Texturen
    if(Fservo0.isHighlighted()) then
      glColor3ub(GetRValue(Fservo0.HighlightColor), GetGValue(Fservo0.HighlightColor), GetBValue(Fservo0.HighlightColor))
    else
      glColor3ub(GetRValue(Fservo0.Color), GetGValue(Fservo0.Color), GetBValue(Fservo0.Color));

    // Mantel
    glPushMatrix();
      glTranslatef(0, Fservo0.height/2, 0);
      glRotatef(90, 1, 0, 0);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluCylinder(gluNewQuadric, Fservo0.width/2, Fservo0.width/2, Fservo0.height, slices, stacks);
    glPopMatrix();

    // Deckel
    glPushMatrix();
      glTranslatef(0, Fservo0.height/2, 0);
      glRotatef(90, 1, 0, 0);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluDisk(gluNewQuadric, 0, Fservo0.width/2, slices, loops);
    glPopMatrix();

  end;

  if(config.showRotationMarkierung) then
  begin
    // Markierung
    glPushMatrix();
      glColor3ub(255,255,0);
      glTranslatef(0, 0.1, 0);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      glBegin(GL_TRIANGLES);
        glVertex3f(-Fservo0.width/2+2, Fservo0.height/2, -0.3);
        glVertex3f(-Fservo0.width/2, Fservo0.height/2, 0);
        glVertex3f(-Fservo0.width/2+2, Fservo0.height/2, 0.3);
      glEnd();
    glPopMatrix();
  end;

end;

{
  Diese Prozedur zeichnet den Servo 1 und 2. Je nach Einstellung wird nur das Gitter oder mit Texturen gezeichnet.

  ~author Thomas Rittinger
  ~version 1.2
}
procedure TRoboterarmPanel.RenderServo12;
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  slices := round(Fservo12.width * 6);
  stacks := round(Fservo12.depth);
  loops  := round(Fservo12.width);
  correctRenderValues(slices, stacks, loops);

  ShowObjektMittelpunkt();

  glPushMatrix();

    if(config.showTexturen) then
    begin  // Zeichne Servo ´1 & 2 mit Texturen
      glEnable(GL_TEXTURE_2D);

      if(Fservo12.isHighlighted()) then
        glColor3ub(GetRValue(Fservo12.HighlightColor), GetGValue(Fservo12.HighlightColor), GetBValue(Fservo12.HighlightColor))
      else
        glColor3ub(255,255,255);

      // Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(-wasserBewegung, 0, 0);
      glMatrixMode(GL_MODELVIEW);

      // Servo
      glTranslatef(0, 0, -Fservo12.depth/2);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[4].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, Fservo12.width/2, Fservo12.width/2, Fservo12.depth, slices, stacks);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin  // Zeiche Servo 1 & 2 als Gitterstruktur ohne Texturen

      if(Fservo12.isHighlighted()) then
        glColor3ub(GetRValue(Fservo12.HighlightColor), GetGValue(Fservo12.HighlightColor), GetBValue(Fservo12.HighlightColor))
      else
        glColor3ub(GetRValue(Fservo12.Color), GetGValue(Fservo12.Color), GetBValue(Fservo12.Color));

      glTranslatef(0, 0, -Fservo12.depth/2);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluCylinder(gluNewQuadric, Fservo12.width/2, Fservo12.width/2, Fservo12.depth, slices, stacks);
    end;

  glPopMatrix();

  if(config.showRotationMarkierung) then
  begin
    // Markierung
    glPushMatrix();
      glColor3ub(255, 255, 0);
      glTranslatef(0, 0, -Fservo12.depth/2);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      glBegin(GL_TRIANGLES);
        glVertex3f(-0.1, 0, Fservo12.depth);
        glVertex3f(0, Fservo12.height/2, Fservo12.depth);
        glVertex3f(0.1, 0, Fservo12.depth);
      glEnd();
    glPopMatrix();
  end;

end;

{
  Diese Prozedur zeichnet den Servo 3. Je nach Einstellung wird nur das Gitter oder mit Texturen gezeichnet.

  ~author Thomas Rittinger
  ~version 1.2
}
procedure TRoboterarmPanel.RenderServo3();
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  slices := round(servo3.width * 6);
  stacks := round(servo3.depth);
  loops  := round(servo3.width);
  correctRenderValues(slices, stacks, loops);

  ShowObjektMittelpunkt();

  glPushMatrix();

    if(config.showTexturen) then
    begin  // Zeichne Servo 3 mit Texturen
      glEnable(GL_TEXTURE_2D);

      if(Fservo3.isHighlighted()) then
        glColor3ub(GetRValue(Fservo3.HighlightColor), GetGValue(Fservo3.HighlightColor), GetBValue(Fservo3.HighlightColor))
      else
        glColor3ub(255,255,255);

      // Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(-wasserBewegung, 0, 0);
      glMatrixMode(GL_MODELVIEW);

      // Servo
      glTranslatef(0, 0, -servo3.depth/2);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[6].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, servo3.width/2, servo3.width/2, servo3.depth, slices, stacks);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin  // Zeiche Servo 3 als Gitterstruktur ohne Texturen

      if(Fservo3.isHighlighted()) then
        glColor3ub(GetRValue(Fservo3.HighlightColor), GetGValue(Fservo3.HighlightColor), GetBValue(Fservo3.HighlightColor))
      else
        glColor3ub(GetRValue(Fservo3.Color), GetGValue(Fservo3.Color), GetBValue(Fservo3.Color));

      glTranslatef(0, 0, -servo3.depth/2);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluCylinder(obj, servo3.width/2, servo3.width/2, servo3.depth, slices, stacks);
    end;

  glPopMatrix();

  if(config.showRotationMarkierung) then
  begin
    // Markierung
    glPushMatrix();
      glColor3ub(255,255,0);
      glTranslatef(0, 0, -servo3.depth/2);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      glBegin(GL_TRIANGLES);
        glVertex3f(-0.1, 0, servo3.depth);
        glVertex3f(0,  servo3.width/2, servo3.depth);
        glVertex3f(0.1, 0, servo3.depth);
      glEnd();
    glPopMatrix();
  end;

end;

{
  Diese Prozedur zeichnet den Servo 4. Je nach Einstellung wird nur das Gitter oder mit Texturen gezeichnet.

  ~author Thomas Gattinger
  ~version 1.2
}
procedure TRoboterarmPanel.RenderServo4();
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  slices := round(servo4.width * 6);
  stacks := round(servo4.depth);
  loops  := round(servo4.width);
  correctRenderValues(slices, stacks, loops);

  ShowObjektMittelpunkt();

  glPushMatrix();

    if(config.showTexturen) then
    begin  // Zeichne Servo ´1 & 2 mit Texturen
      glEnable(GL_TEXTURE_2D);

      if(servo4.isHighlighted()) then
        glColor3ub(GetRValue(servo4.HighlightColor), GetGValue(servo4.HighlightColor), GetBValue(servo4.HighlightColor))
      else
        glColor3ub(255,255,255);

      // Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(-wasserBewegung, 0, 0);
      glMatrixMode(GL_MODELVIEW);

      // Servo
      glTranslatef(0, 0, -servo4.depth/2);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[8].TextureID);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      gluCylinder(obj, servo4.width/2, servo4.width/2, servo4.depth, slices, stacks);

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin  // Zeiche Servo 1 & 2 als Gitterstruktur ohne Texturen

      if(servo4.isHighlighted()) then
        glColor3ub(GetRValue(servo4.HighlightColor), GetGValue(servo4.HighlightColor), GetBValue(servo4.HighlightColor))
      else
        glColor3ub(GetRValue(servo4.Color), GetGValue(servo4.Color), GetBValue(servo4.Color));

      glTranslatef(0, 0, -servo4.depth/2);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      gluCylinder(gluNewQuadric, servo4.width/2, servo4.width/2, servo4.depth, slices, stacks);
    end;

  glPopMatrix();


  if(config.showRotationMarkierung) then
  begin
    // Markierung
    glPushMatrix();
      glColor3ub(255,255,0);
      glTranslatef(0, 0, -servo4.depth/2);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      glBegin(GL_TRIANGLES);
        glVertex3f(-0.1, 0, servo4.depth);
        glVertex3f(0,  servo4.width/2, servo4.depth);
        glVertex3f(0.1, 0, servo4.depth);
      glEnd();
    glPopMatrix();
  end;

end;

{
  Diese Prozedur zeichnet den Servo 5. Je nach Einstellung wird nur das Gitter oder mit Texturen gezeichnet.

  ~author Thomas Gattinger
  ~version 1.2
}
procedure TRoboterarmPanel.RenderServo5();
var slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  slices := round(servo5.width * 4);
  stacks := round(servo5.height);
  loops  := round(servo5.width/2);
  correctRenderValues(slices, stacks, loops);

  ShowObjektMittelpunkt();

    if(config.showTexturen) then
    begin  // Zeichne Servo ´1 & 2 mit Texturen
      glEnable(GL_TEXTURE_2D);

      if(servo5.isHighlighted()) then
        glColor3ub(GetRValue(servo5.HighlightColor), GetGValue(servo5.HighlightColor), GetBValue(servo5.HighlightColor))
      else
        glColor3ub(255,255,255);

      // Mantel
      glPushMatrix();
        glTranslatef(0, servo5.height/2, 0);
        glRotatef(90, 1, 0, 0);
        gluQuadricTexture(obj,true);
        glBindTexture(GL_TEXTURE_2D,texture[13].TextureID);
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
        gluCylinder(obj, servo5.width/2, servo5.width/2, servo5.height, slices, stacks);
      glPopMatrix();

      // Deckel
      glPushMatrix();
        glTranslatef(0, servo5.height/2, 0);
        glRotatef(90, 1, 0, 0);
        glRotatef(90, 0, 0, 1);
        gluQuadricTexture(obj,true);
        glBindTexture(GL_TEXTURE_2D,texture[14].TextureID);
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
        gluDisk(obj, 0, servo5.width/2, slices, loops);
      glPopMatrix();

      glDisable(GL_TEXTURE_2D);
    end
    else
    begin  // Zeiche Servo 1 & 2 als Gitterstruktur ohne Texturen

      if(servo5.isHighlighted()) then
        glColor3ub(GetRValue(servo5.HighlightColor), GetGValue(servo5.HighlightColor), GetBValue(servo5.HighlightColor))
      else
        glColor3ub(GetRValue(servo5.Color), GetGValue(servo5.Color), GetBValue(servo5.Color));

      // Mantel
      glPushMatrix();
        glTranslatef(0, servo5.height/2, 0);
        glRotatef(90, 1, 0, 0);
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        gluCylinder(gluNewQuadric, servo5.width/2, servo5.width/2, servo5.height, slices, stacks);
      glPopMatrix();

      // Deckel
      glPushMatrix();
        glTranslatef(0, servo5.height/2, 0);
        glRotatef(90, 1, 0, 0);
        glRotatef(90, 0, 0, 1);
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        gluDisk(gluNewQuadric, 0, servo5.width/2, slices, loops);
      glPopMatrix();
    end;

  if(config.showRotationMarkierung) then
  begin
    // Markierung
    glPushMatrix();
      glColor3ub(255,255,0);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      glRotatef(90, 0, 1, 0);
      glBegin(GL_TRIANGLES);
        glVertex3f(-servo5.width/2+1, servo5.height/2+0.1, -0.3);
        glVertex3f(-servo5.width/2, servo5.height/2+0.1, 0);
        glVertex3f(-servo5.width/2+1, servo5.height/2+0.1, 0.3);
      glEnd();
    glPopMatrix();
  end;

end;


{
  Diese Prozedur zeichnet das Servo 6, welches aus 2 Zylindern und einem Würfel besteht.

  ~author Frédéric Nickol
  ~version 1.0
}
procedure TRoboterarmPanel.RenderServo6();
var subElement1Width : Real;
    subElement1Height : Real;
    subElement1Depth : Real;
    subElement2Width : Real;
    subElement2Height : Real;
    subElement2Depth : Real;
    slices : Integer;
    stacks : Integer;
    loops  : Integer;

begin
  ShowObjektMittelpunkt();

  subElement1Width  := Felement3.width * 20.0 / 100.0;
  subElement1Height := Felement3.height;
  subElement1Depth  := Felement3.depth;

  subElement2Width  := Felement3.width * 60.0 / 100.0;
  subElement2Height := Felement3.height;
  subElement2Depth  := Felement3.depth;

  glPushMatrix();

    if(config.showTexturen) then
    begin  // Zeichne Servo 3 mit Texturen
      glEnable(GL_TEXTURE_2D);

      if(Fservo6.isHighlighted()) then
        glColor3ub(GetRValue(Fservo6.HighlightColor), GetGValue(Fservo6.HighlightColor), GetBValue(Fservo6.HighlightColor))
      else
        glColor3ub(255,255,255);

      // Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(-wasserBewegung, 0, 0);
      glMatrixMode(GL_MODELVIEW);

      glTranslatef(-servo6.GetAktGrad/100, -Element4.Height/2, 0);
      glRotatef(-90, 1, 0, 0);
      glRotatef(-90, 0, 0, 1);
  //    glColor3f(element3.clRed, element3.clGreen, element3.clBlue);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[11].TextureID);
      gluCylinder(obj, subElement1Width/2, subElement1Width/2, subElement1Height, slices*2, stacks*2);

      // Wechsel zum Würfelmittelpunkt
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, subElement2Height/3);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, -subElement2Height/3);

      // Zeichne vorderen Zylinder
     // gluCylinder(gluNewQuadric, subElement1.width/2, subElement1.width/2, subElement1.height, slices*2, stacks*2);


      glDisable(GL_TEXTURE_2D);
    end
    else
    begin  // Zeiche Servo 3 als Gitterstruktur ohne Texturen

      if(Fservo6.isHighlighted()) then
        glColor3ub(GetRValue(Fservo6.HighlightColor), GetGValue(Fservo6.HighlightColor), GetBValue(Fservo6.HighlightColor))
      else
        glColor3ub(GetRValue(Fservo6.Color), GetGValue(Fservo6.Color), GetBValue(Fservo6.Color));

      glTranslatef(-servo6.GetAktGrad/100, -Element4.Height/2, 0);
      glRotatef(-90, 1, 0, 0);
      glRotatef(-90, 0, 0, 1);
  //    glColor3f(element3.clRed, element3.clGreen, element3.clBlue);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);
      gluCylinder(gluNewQuadric, subElement1Width/2, subElement1Width/2, subElement1Height, slices*2, stacks*2);

      // Wechsel zum Würfelmittelpunkt
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, subElement2Height/3);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, -subElement2Height/3);

      // Zeichne vorderen Zylinder
     // gluCylinder(gluNewQuadric, subElement1.width/2, subElement1.width/2, subElement1.height, slices*2, stacks*2);
    end;

  glPopMatrix();

end;


{
  Diese Prozedur zeichnet das Servo 7, welches aus 2 Zylindern und einem Würfel besteht.

  ~author Frédéric Nickol
  ~version 1.0
}
procedure TRoboterarmPanel.RenderServo7();
var subElement1Width : Real;
    subElement1Height : Real;
    subElement1Depth : Real;
    subElement2Width : Real;
    subElement2Height : Real;
    subElement2Depth : Real;
    slices : Integer;
    stacks : Integer;
    loops  : Integer;
begin
  ShowObjektMittelpunkt();

  subElement1Width  := Felement3.width * 20.0 / 100.0;
  subElement1Height := Felement3.height;
  subElement1Depth  := Felement3.depth;

  subElement2Width  := Felement3.width * 60.0 / 100.0;
  subElement2Height := Felement3.height;
  subElement2Depth  := Felement3.depth;

  glPushMatrix();

    if(config.showTexturen) then
    begin  // Zeichne Servo 3 mit Texturen
      glEnable(GL_TEXTURE_2D);

      if(Fservo7.isHighlighted()) then
        glColor3ub(GetRValue(Fservo7.HighlightColor), GetGValue(Fservo7.HighlightColor), GetBValue(Fservo7.HighlightColor))
      else
        glColor3ub(255,255,255);

      // Textur
      glMatrixMode(GL_TEXTURE);
      glLoadIdentity;
      glTranslatef(-wasserBewegung, 0, 0);
      glMatrixMode(GL_MODELVIEW);

      glTranslatef(servo7.GetAktGrad/100, -Element4.Height/2,0);
      glRotatef(-90, 1, 0, 0);
      glRotatef(-90, 0, 0, 1);
  //    glColor3f(element3.clRed, element3.clGreen, element3.clBlue);
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);
      //gluCylinder(gluNewQuadric, subElement1.width/2, subElement1.width/2, subElement1.height, slices*2, stacks*2);

      // Wechsel zum Würfelmittelpunkt
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, subElement2Height/3);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, -subElement2Height/3);

      // Zeichne vorderen Zylinder
      gluQuadricTexture(obj,true);
      glBindTexture(GL_TEXTURE_2D,texture[11].TextureID);
      gluCylinder(obj, subElement1Width/2, subElement1Width/2, subElement1Height, slices*2, stacks*2);


      glDisable(GL_TEXTURE_2D);
    end
    else
    begin  // Zeiche Servo 3 als Gitterstruktur ohne Texturen

      if(Fservo7.isHighlighted()) then
        glColor3ub(GetRValue(Fservo7.HighlightColor), GetGValue(Fservo7.HighlightColor), GetBValue(Fservo7.HighlightColor))
      else
        glColor3ub(GetRValue(Fservo7.Color), GetGValue(Fservo7.Color), GetBValue(Fservo7.Color));

      glTranslatef(servo7.GetAktGrad/100, -Element4.Height/2,0);
      glRotatef(-90, 1, 0, 0);
      glRotatef(-90, 0, 0, 1);
  //    glColor3f(element3.clRed, element3.clGreen, element3.clBlue);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

      // Zeichne hinteren Zylinder
      slices := round(subElement1Width*5);
      stacks := round(subElement1Height*1.5);
      correctRenderValues(slices, stacks, loops);
      //gluCylinder(gluNewQuadric, subElement1.width/2, subElement1.width/2, subElement1.height, slices*2, stacks*2);

      // Wechsel zum Würfelmittelpunkt
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, subElement2Height/3);

      // Wechsel zum vorderen Zylinder
      glTranslatef(0, -subElement2Width/2 - subElement1Width/2, -subElement2Height/3);

      // Zeichne vorderen Zylinder
      gluCylinder(gluNewQuadric, subElement1Width/2, subElement1Width/2, subElement1Height, slices*2, stacks*2);
    end;

  glPopMatrix();

end;


{
  Diese Setter-Prozedur setzt das Flag, ob das Universum Koordinatensystem angezeigt werden soll.

  ~param configValue True, falls das Koordinatensystem angezeigt werden soll, sonst false

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetShowKoordinatensystem(configValue : Boolean);
begin
  if(config.showKoordinatensystem <> configValue) then
  begin
    config.showKoordinatensystem := configValue;
    Render();
  end;
end;


{
  Diese Setter-Prozedur setzt das Flag, ob die geometrischen Mittelpunkte der Objekte angezeigt
  werden sollen.

  ~param configValue True, falls die Mittelpunkte angezeigt werden soll, sonst false

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetShowObjektMittelpunkt(configValue : Boolean);
begin
  if(config.showObjektMittelpunk <> configValue) then
  begin
    config.showObjektMittelpunk := configValue;
    Render();
  end;
end;


{
  Diese Setter-Prozedur setzt das Flag, ob die Rotationsmarkierungen bei den Servos angezeigt
  werden sollen.

  ~param configValue True, falls die Rotationsmarkierungen angezeigt werden soll, sonst false

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetShowRotationsmarkierung(configValue : Boolean);
begin
  if(config.showRotationMarkierung <> configValue) then
  begin
    config.showRotationMarkierung := configValue;
    Render();
  end;
end;


{
  Diese Setter-Prozedur setzt das Flag, ob das OpenGL Infopanel angezeigt werden soll.

  ~param configValue True, falls das Infopanel angezeigt werden soll, sonst false

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetShowOpenGLInfoPanel(configValue : Boolean);
begin
  if(config.showOpenGLInfoPanel <> configValue) then
  begin
    config.showOpenGLInfoPanel := configValue;
    Render();
  end;
end;


{
  Diese Setter-Prozedur setzt das Flag, ob die Texturen angezeigt werden sollen.

  ~param configValue True, falls die Texturen angezeigt werden soll, sonst false

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TRoboterarmPanel.SetShowTexturen(configValue : Boolean);
begin
  if(config.showTexturen <> configValue) then
  begin
    config.showTexturen := configValue;
    Render();
  end;
end;

end.
