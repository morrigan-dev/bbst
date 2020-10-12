{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
{ *********************************************************************************************************************
  * K L A S S E : unitRoboterarmPanel
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Copyright © 2010 by Thomas Gattinger, Thomas Rittinger, Frédérik Nickol
  * Datei     : unitRoboterarm.pas
  * Aufgabe   : Diese Unit stellt einen kompletten Roboterarm zur Verfügung. Der Arm besteht aus sechs Elementen
  *             die über sieben Servos bewegt werden können.
  *
  * Compiler  : Delphi 7.0
  * Aenderung : 18.04.2010
  *
  * Kommentar Styleguide : http://java.sun.com/j2se/javadoc/writingdoccomments/#styleguide
  * Kommentar Syntax     : http://delphidoc.sourceforge.net/comments.html
  *********************************************************************************************************************
}
unit unitRoboterarmPanel;

interface

uses
  // Delphi Klassen
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, TypInfo,

  // OpenGL Klassen
  DGLOpenGL, glBMP,

  // log4D Klassen
  Log4D,

  // Eigene Klassen
  unitElementProperty, unitServoProperty, unitIOpenGL, unitIObserver, unitRoboterarmModel, unitOpenGLConfigUtil,
  unitEinzelteile,
  unitDebugUtil,
  unitElement0,
  unitElement1,
  unitElement2,
  unitElement3,
  unitElement4,
  unitServo0,
  unitServo12,
  unitServo3,
  unitServo4,
  unitServo5,
  unitServo6;

type

  TRoboterarmPanel = class(TCustomControl, IOpenGL, IObserver)
    procedure initOGL();
    procedure destroyOGL();
    procedure RoboterarmResize(Sender: TObject);
    procedure RoboterarmMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RoboterarmMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure RoboterarmMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RoboterarmDblClick(Sender: TObject);
    procedure RoboterarmMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure RoboterarmKeyPress(Sender: TObject; var Key: Char);

  private { Private declarations }
    LOG :   TLogLogger;
    rootLogger    : TLogLogger;
    fileAppender  : TLogFileAppender;
    patternlayout : TLogPatternLayout;

    // Handle auf Zeichenfläche
    // HDC und HGLRC sind Typen die von Windows zur Verfügung gestellt werden. Ihr findet sie in der Unit "Windows".
    DC                                : HDC;
    // Rendering Context
    // (Diese Unit sollte bei einem neuen Projekt bereits durch Delphi eingebunden worden sein.)
    RC                                : HGLRC;

    roboarmModel  : TRoboterarmModel;  // Model des kompletten Roboterarms
    selectionMode : Integer;           // Gibt an, welcher Rendermodus momentan aktiv ist
                                       // 0 - Die Szene wird normal gerendert
                                       // 1 - Der Selection Modus ist aktiv und das angeklickte Element wird berechnet

    // Interner Variablenblock
    panelWidth    : Integer;           // Gibt die Breite des Panels an
    panelHeight   : Integer;           // Gibt die Höhe des Panels an

    ele0 : TElement0;
    ele1 : TElement1;
    ele2 : TElement2;
    ele3 : TElement3;
    ele4 : TElement4;
    serv0 : TServo0;
    serv12 : TServo12;
    serv3 : TServo3;
    serv4 : TServo4;
    serv5 : TServo5;
    serv6 : TServo6;

    // Erstelle Elementrecords
    Felement0 : TElementProperty;
    Felement1 : TElementProperty;
    Felement2 : TElementProperty;
    Felement3 : TElementProperty;
    Felement4 : TElementProperty;
    Felement5 : TElementProperty;

    // Erstelle Servoobjekte
    Fservo0  : TServoProperty;
    Fservo12 : TServoProperty;
    Fservo3  : TServoProperty;
    Fservo4  : TServoProperty;
    Fservo5  : TServoProperty;
    Fservo6  : TServoProperty;

    Fwidth   : Integer;
    Fheight  : Integer;

    procedure initRootLogger();
    procedure SetupGL();               // Initialisiere OpenGL
    procedure updateViewport();        // Prüft ob sich die Größe des Panels geändert hat und passt den Viewport an
    function Selection(xs, ys : Integer) : Integer;

    procedure Koordinatenraum();       // Zeichnet ein Koordinatensystem in den Universumursprung

    procedure SetWidth(width : Integer);
    procedure SetHeight(height : Integer);

    function GetBackgroundColor() : TColor;
    function GetSkin() : TSkin;
//    function GetLogLevel() : String;

    procedure SetBackgroundColor(color : TColor);
    procedure SetSkin(skin : TSkin);
//    procedure SetLogLevel(logLevel : String);

  public { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure CreateParams(var Params: TCreateParams); override;

    procedure Render();                // Organisiert das Rendering der einzelnen Render-Prozeduren

    procedure updateView();                // update-Procedure des Observer-Patterns

    function GetModel() : TRoboterarmModel;

  published { Published-Deklarationen }

    property Skin : TSkin read GetSkin write SetSkin;
    property BackgroundColor : TColor read GetBackgroundColor write SetBackgroundColor;

    property Servo0  : TServoProperty read Fservo0  write Fservo0;
    property Servo12 : TServoProperty read Fservo12 write Fservo12;
    property Servo3  : TServoProperty read Fservo3  write Fservo3;
    property Servo4  : TServoProperty read Fservo4  write Fservo4;
    property Servo5  : TServoProperty read Fservo5  write Fservo5;
    property Servo6  : TServoProperty read Fservo6  write Fservo6;

    property Element0  : TElementProperty read Felement0  write Felement0;
    property Element1  : TElementProperty read Felement1  write Felement1;
    property Element2  : TElementProperty read Felement2  write Felement2;
    property Element3  : TElementProperty read Felement3  write Felement3;
    property Element4  : TElementProperty read Felement4  write Felement4;
    property Element5  : TElementProperty read Felement5  write Felement5;

    property Width       : Integer read Fwidth   write SetWidth;
    property Height      : Integer read Fheight  write SetHeight;
//    property LoggerLevel : String read GetLogLevel write SetLogLevel;

  end;

procedure Register;

const
    // Diese Konstanten werden für das OpenGL benutzt
    NEAR_CLIPPING = 1;
    FAR_CLIPPING  = 3000;
    RENDERER_TIMER = 30;

implementation

uses unitElementModel;

procedure Register;
begin
  RegisterComponents('Schule', [TRoboterarmPanel]);
end;

constructor TRoboterarmPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Parent := TWinControl(AOwner);

  //initRootLogger();

  //LOG := TLogLogger.GetLogger(TRoboterarmPanel);
end;

procedure TRoboterarmPanel.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
// Transparentes Objekt
// Params.ExStyle := Params.ExStyle+WS_EX_Transparent;
// ControlStyle := ControlStyle-[csOpaque]+[csAcceptsControls];
end;

procedure TRoboterarmPanel.AfterConstruction;
begin
  inherited AfterConstruction;
  //if(LOG.IsTraceEnabled()) then LOG.Trace('AfterConstruction');

  roboarmModel := TRoboterarmModel.Create();
  roboarmModel.addObserver(Self);

  Skin := roboarmModel.GetSkin();

  ele0 := TElement0.Create(Self, roboarmModel);
  ele1 := TElement1.Create(Self, roboarmModel);
  ele2 := TElement2.Create(Self, roboarmModel);
  ele3 := TElement3.Create(Self, roboarmModel);
  ele4 := TElement4.Create(Self, roboarmModel);
  serv0 := TServo0.Create(Self, roboarmModel);
  serv12 := TServo12.Create(Self, roboarmModel);
  serv3 := TServo3.Create(Self, roboarmModel);
  serv4 := TServo4.Create(Self, roboarmModel);
  serv5 := TServo5.Create(Self, roboarmModel);
  serv6 := TServo6.Create(Self, roboarmModel);

  Fservo0  := TServoProperty.Create(serv0.getModel());
  Fservo12 := TServoProperty.Create(serv12.getModel());
  Fservo3  := TServoProperty.Create(serv3.getModel());
  Fservo4  := TServoProperty.Create(serv4.getModel());
  Fservo5  := TServoProperty.Create(serv5.getModel());
  Fservo6  := TServoProperty.Create(serv6.getModel());

  Felement0 := TElementProperty.Create(ele0.GetModel());
  Felement1 := TElementProperty.Create(ele1.GetModel());
  Felement2 := TElementProperty.Create(ele2.GetModel());
  Felement3 := TElementProperty.Create(ele3.GetModel());
  Felement4 := TElementProperty.Create(ele4.GetModel());
  Felement5 := TElementProperty.Create(ele0.GetModel());

  ClientWidth := 200;
  ClientHeight := 200;

  Fwidth := 200;
  Fheight := 200;
  selectionMode := 0;  // RENDER

  initOGL();
end;

destructor TRoboterarmPanel.Destroy;
var rootLogger    : TLogLogger;
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('Destroy');

  ele0.Free;
  ele1.Free;
  ele2.Free;
  ele3.Free;
  ele4.Free;
  serv0.Free;
  serv12.Free;
  serv3.Free;
  serv4.Free;
  serv5.Free;
  serv6.Free;

  Fservo0.Free;
  Fservo12.Free;
  Fservo3.Free;
  Fservo4.Free;
  Fservo5.Free;
  Fservo6.Free;

  Felement0.Free;
  Felement1.Free;
  Felement2.Free;
  Felement3.Free;
  Felement4.Free;
  Felement5.Free;

{
  rootLogger := TLogLogger.GetRootLogger();
  rootLogger.Info('====================== Simulation beendet =====================');
  rootLogger.Info('');

  showmessage('free 1');

  Self.rootLogger.GetAppender('DefaultFileAppender').Close;
  Self.rootLogger.GetAppender('DefaultFileAppender').RemoveAllFilters;
  Self.rootLogger.FreeInstance;

  showmessage('free 2');
}
  inherited Destroy;
end;


procedure TRoboterarmPanel.initRootLogger();
begin
showmessage('1');
  Self.patternlayout := TLogPatternLayout.Create('%d %p [%c]: %m%n');

showmessage('2');
  Self.fileAppender := TLogFileAppender.Create('DefaultFileAppender', ExtractFilePath(Application.ExeName)
                  + 'roboarm.log');
  Self.fileAppender.Layout := patternlayout;
showmessage('3');

  Self.rootLogger := TLogLogger.GetRootLogger();
showmessage('4');
  Self.rootLogger.RemoveAllAppenders;
  Self.rootLogger.AddAppender(fileAppender);
showmessage('5');
  Self.rootLogger.Level := Log4D.Info;
showmessage('6');

  Self.rootLogger.Info('=============== Roboterarm-Simulation gestartet ===============');
  Self.rootLogger.Info('');
  Self.rootLogger.Info('Autor: Thomas Gattinger');
  Self.rootLogger.Info('Compiler: Delphi 6 Pro');
showmessage('7');

end;



{ *********************************************************************************************************************
  * P R O C E D U R E : FormCreate
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Rittinger
  * Aufgabe   : Diese Prozedur wird unmittelbar nach der Erstellung des Formulars aufgerufen, initialisiert das OpenGL
  *             und setzt dessen Startwerte. Anschließend werden die Startwerte des Roboterarms gesetzt.
  * Parameter : Sender - Das Objekt, von dem der Aufruf stammt.
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TRoboterarmPanel.initOGL();
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('initOGL');

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

  SetupGL;

  Self.OnResize := RoboterarmResize;
  Self.OnDblClick := Self.RoboterarmDblClick;
  Self.OnMouseDown := Self.RoboterarmMouseDown;
  Self.OnMouseUp := Self.RoboterarmMouseUp;
  Self.OnMouseMove := Self.RoboterarmMouseMove;
  Self.OnMouseWheel := Self.RoboterarmMouseWheel;
  Self.OnKeyPress := Self.RoboterarmKeyPress;

  Render();
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : FormResize
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Rittinger
  * Aufgabe   : Diese Prozedur wird immer dann aufgerufe, wenn sich die Größe des Formulars ändert. Sie passt den OpenGL
  *             Bereich dem verfügbaren Platz auf dem Formular an.
  * Parameter : Sender - Das Objekt, von dem der Aufruf stammt.
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TRoboterarmPanel.RoboterarmResize(Sender: TObject);
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('RoboterarmResize(' + Sender.ClassName + ')');

  updateViewport();
  Render();
end;

procedure TRoboterarmPanel.SetWidth(width : Integer);
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('SetWidth(' + IntToStr(width) + ')');

  if(Self.Fwidth <> width) then
  begin
    Self.Fwidth := width;
    ClientWidth := width;
    updateViewport();
    Render();
  end;
end;

procedure TRoboterarmPanel.SetHeight(height : Integer);
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('SetHeight(' + IntToStr(height) + ')');

  if(Self.Fheight <> height) then
  begin
    Self.Fheight := height;
    ClientHeight := height;
    updateViewport();
    Render();
  end;
end;


{ *********************************************************************************************************************
  * P R O C E D U R E : FormDestroy
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Rittinger
  * Aufgabe   : Diese Prozedur wird aufgerufen kurz bevor das Formular zerstört wird und der Speicher frei gegeben wird.
  *             Der OpenGL Context wird nun auch wieder freigegeben.
  * Parameter : Sender - Das Objekt, von dem der Aufruf stammt.
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}

procedure TRoboterarmPanel.destroyOGL();
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('destroyOGL');

  glDisable(GL_BLEND);               // Enable Blending
  glDisable(GL_DEPTH_TEST);          // Tiefentest deaktivieren

  DeactivateRenderingContext;
  DestroyRenderingContext(RC);
  ReleaseDC(Self.Handle, DC);
end;


{ *********************************************************************************************************************
  * P R O C E D U R E : SetupGL
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Rittinger
  * Aufgabe   : Diese Prozedur konfigiert das OpenGL
  * Parameter : keine
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TRoboterarmPanel.SetupGL();
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('SetupGL');

  glEnable(GL_DEPTH_TEST);          // Tiefentest aktivieren
end;

procedure TRoboterarmPanel.RoboterarmMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
                                                MousePos: TPoint; var Handled: Boolean);
begin
  //if(LOG.IsTraceEnabled()) then LOG.Trace('RoboterarmMouseWheel(' + Sender.ClassName + ', ' + ShiftStateToString(Shift) + ')');

  case WheelDelta of
      120: // Mausrad hoch
      begin
        case roboarmModel.GetSelectedServo() of
          NICHTS: roboarmModel.IncZoom(10.0);
          SERVO_0: Self.serv0.GetModel().IncPosition();
          SERVO_12: Self.serv12.GetModel().IncPosition();
          SERVO_3: Self.serv3.GetModel().IncPosition();
          SERVO_4: Self.serv4.GetModel().IncPosition();
          SERVO_5: Self.serv5.GetModel().IncPosition();
          SERVO_6: Self.serv6.GetModel().IncPosition();
        end;
      end;

      -120: // Maurad runter
      begin
        case roboarmModel.GetSelectedServo() of
          NICHTS: roboarmModel.DecZoom(10.0);
          SERVO_0: Self.serv0.GetModel().DecPosition();
          SERVO_12: Self.serv12.GetModel().DecPosition();
          SERVO_3: Self.serv3.GetModel().DecPosition();
          SERVO_4: Self.serv4.GetModel().DecPosition();
          SERVO_5: Self.serv5.GetModel().DecPosition();
          SERVO_6: Self.serv6.GetModel().DecPosition();
        end;
      end;
  end;

  roboarmModel.syncViews();
end;

procedure TRoboterarmPanel.RoboterarmMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(Button = mbLeft) then
  begin
    Self.SetFocus;
    roboarmModel.SetSelectedServo(NICHTS);
  end;

{
  if(Button = mbLeft) then
  begin
  roboarmModel.SetSelectedServo(NICHTS);
    case Selection(X, Y) of
      NICHTS:
      begin
        roboarmModel.SetSelectedServo(NICHTS);
      end;
      SERVO_0:
      begin
        roboarmModel.SetSelectedServo(SERVO_0);
      end;
      SERVO_12:
      begin
        roboarmModel.SetSelectedServo(SERVO_12);
      end;
      SERVO_3:
      begin
        roboarmModel.SetSelectedServo(SERVO_3);
      end;
      SERVO_4:
      begin
        roboarmModel.SetSelectedServo(SERVO_4);
      end;
      SERVO_5:
      begin
        roboarmModel.SetSelectedServo(SERVO_5);
      end;
      SERVO_6:
      begin
        roboarmModel.SetSelectedServo(SERVO_6);
      end;
    end;
  end;
}

  if(Button = mbMiddle) then
  begin
    if(not roboarmModel.IsMouseMove()) then
    begin
      roboarmModel.SetMouseMove(True);
      roboarmModel.SetXYMousePos(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
  end;

  if(Button = mbRight) then
  begin
    if(not roboarmModel.IsMouseRotation()) then
    begin
      roboarmModel.SetMouseRotation(True);
      roboarmModel.SetXYMousePos(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
  end;
end;

procedure TRoboterarmPanel.RoboterarmMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var curMouseXPos : Integer;
    curMouseYPos : Integer;

begin
  if(roboarmModel.IsMouseMove()) then
  begin
    curMouseXPos := Mouse.CursorPos.X;
    curMouseYPos := Mouse.CursorPos.Y;
    if(Abs(roboarmModel.GetYMousePos() - curMouseYPos) > 0)
      or (Abs(roboarmModel.GetXMousePos() - curMouseXPos) > 0) then
    begin
      roboarmModel.SetXYMove(curMouseXPos, curMouseYPos);
    end;

    Render();
  end;

  if(roboarmModel.IsMouseRotation()) then
  begin
    // Rotiere Objekt um die zurückgelegte Mausstrecke
    curMouseXPos := Mouse.CursorPos.X;
    curMouseYPos := Mouse.CursorPos.Y;
    if(Abs(roboarmModel.GetYMousePos() - curMouseYPos) > 0) or (Abs(roboarmModel.GetXMousePos() - curMouseXPos) > 0) then
    begin
      roboarmModel.SetXYRotation(curMouseXPos, curMouseYPos);
    end;
  end;
end;

procedure TRoboterarmPanel.RoboterarmMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(Button <> mbLeft) then
  begin
    roboarmModel.SetMouseRotation(False);
    roboarmModel.SetMouseMove(False);
    roboarmModel.UpdateOldXYRotation();
    roboarmModel.UpdateOldXYMove();
  end;  
end;

procedure TRoboterarmPanel.RoboterarmDblClick(Sender: TObject);
begin
  roboarmModel.ResetXYRotation();
  roboarmModel.ResetXYMove();
  roboarmModel.ResetZoom();
end;

procedure TRoboterarmPanel.RoboterarmKeyPress(Sender: TObject; var Key: Char);
begin
  roboarmModel.SetSelectedServo(NICHTS);
  case Key of
    '0': roboarmModel.SetSelectedServo(SERVO_0);
    '1', '2': roboarmModel.SetSelectedServo(SERVO_12);
    '3': roboarmModel.SetSelectedServo(SERVO_3);
    '4': roboarmModel.SetSelectedServo(SERVO_4);
    '5': roboarmModel.SetSelectedServo(SERVO_5);
    '6': roboarmModel.SetSelectedServo(SERVO_6);
  end;
end;

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

    Fwidth  := ClientWidth;
    Fheight := ClientHeight;

  end;
end;

procedure TRoboterarmPanel.updateView();
begin
  Render();
end;

function TRoboterarmPanel.GetModel() : TRoboterarmModel;
begin
  result := Self.roboarmModel;
end;

{
  #####################################################################################################################

  Ab hier werden die einzelnen Roboterarm Elemente gerendert.
  ===========================================================

  Erläuterungen zu den einzelnen OpenGL Objektformen:

  gluCylinder: http://wiki.delphigl.com/index.php/gluCylinder

  #####################################################################################################################
}

{ *********************************************************************************************************************
  * P R O C E D U R E : Render
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur organisiert das Zeichnen der einzelnen Elemente und Servos.
  *             Um die Drehung der einzelnen Servos auf die nachfolgenden Objekte zu übertragen. wird folgende
  *             Strategie verfolg:
  *             1) Schritt: Setze den Mittelpunkt des Universums auf die Stelle an der der Mittelpunkt des zu
  *                         zeichnenden Objekt ist.
  *             2) Schritt: Falls das nächste Objekt ein Servo ist, so rotiere nun das Universum entsprechend dem
  *                         Rotationsverhalten des Servos. Ist das nächste Objekt kein Servo, so gehe direkt zu
  *                         Schritt 3)
  *             3) Schritt: Zeiche das nächste Objekt, sodass dessen Mittelpunkt genau auf dem Mittelpunkt des
  *                         Universums ist.
  *
  *             Da wir immer erst das Universum verschieben und drehen sieht es so aus, als würden die Servo Drehungen
  *             die nachfolgenden Elemente mit sich drehen. In Wirklichkeit drehen wir jedoch alle Objekt, die sich
  *             bisher im Universum befinden! So gesehen zeichnen wir jedes neue Objekt immer nach dem gleichen Muster.
  *             Jedes Objekt wird in seiner Grundstellung bei 0 Grad gezeichnet. Die Angaben der Dimensionen
  *             beziehen sich immer auf das Koordinatensystem des Universums
  *
  * Parameter : keine
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TRoboterarmPanel.Render();
var
    startX : Real;  // x-Koorinate des aktuellen Universum Mittelpunkts
    startY : Real;  // y-Koorinate des aktuellen Universum Mittelpunkts
    startZ : Real;  // z-Koorinate des aktuellen Universum Mittelpunkts
    bgColor : LongInt;
    util : TOpenGLConfigUtil;

    P1 : TVector3d;
const
    light_position : Array[0..3] of GlFloat = (25.0, 0.0, -10.0, 0.3);
    light_ambient  : Array[0..3] of GlFloat = (0.4, 0.4, 0.35, 0.3);
    light_diffuse  : Array[0..3] of GlFloat = (0.75, 0.75, 0.7, 0.3);
//    light_ambient  : Array[0..3] of GlFloat = (1.0, 1.0, 1.0, 0.5);
//    light_diffuse  : Array[0..3] of GlFloat = (1.0, 1.0, 1.0, 0.5);

begin
  util := TOpenGLConfigUtil.getInstance();

  if(roboarmModel.IsLight()) and (not util.IsLightEnabled()) then
    util.EnableLight()
  else
    util.DisableLight();

  bgColor := ColorToRGB(Self.roboarmModel.GetBackgroundColor());
//  glClearColor(0,0,0, 0.0); // Hintergrundfarbe
  glClearColor(GetRValue(bgColor)/255, GetGValue(bgColor)/255, GetBValue(bgColor)/255, 0.0); // Hintergrundfarbe
//  glColor4d(1,0,0,1.0);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;

  // Hier wird wieder die Perspektive gesetzt. Dieser Aufruf und der bei FormResize müssen von den Parametern
  // identisch sein. Sonst sieht die Ausgabe nach einem Resize ganz einfach anders aus. Wenn sich die Perspektive
  // zwischen den Renderdurchgängen nicht ändert, kann dieser Befehl auch weggelassen werden.
  gluPerspective(45.0, ClientWidth/ClientHeight, NEAR_CLIPPING, FAR_CLIPPING);

  glMatrixMode(GL_MODELVIEW);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glLoadIdentity;

  if(roboarmModel.IsLight()) then
  begin
    glPushMatrix();
      glTranslatef(light_position[0], light_position[1], light_position[2]);
      glColor3ub(255, 255, 0);
      gluSphere(gluNewQuadric, 2, 20, 20);
    glPopMatrix();

    glLightfv(GL_LIGHT0, GL_AMBIENT,  @light_ambient[0]);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  @light_diffuse[0]);
    glLightfv(GL_LIGHT0, GL_POSITION, @light_position[0]);

    glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
  end;

  // Rotiere das ganze Universum
  glTranslatef(roboarmModel.GetXMove(), roboarmModel.GetYMove(), roboarmModel.GetZoom());
  glRotatef(roboarmModel.GetXRotation(),1,0,0);
  glRotatef(roboarmModel.GetYRotation(),0,1,0);

  glInitNames();
  glPushName(0);

  glPushMatrix();
    // Verschiebe Universum damit Element 0 gezeichnet werden kann
    startX := 0;
    startY := -210;
    startZ := 0;
    glTranslatef(startX, startY + roboarmModel.GetVerticalOffset(), startZ);

    if(roboarmModel.IsKoordinatensystem()) then Koordinatenraum();

    Self.ele0.Render();
    Self.serv0.Render();
    Self.serv12.Render();
    Self.ele1.Render();
    Self.serv3.Render();
    Self.ele2.Render();
    Self.serv4.Render();
    Self.ele3.Render();
    Self.serv5.Render();
    Self.ele4.Render();
    Self.serv6.Render();

  glPopMatrix();

  SwapBuffers(DC);
  glclear(DC);

end;

function TRoboterarmPanel.Selection(xs, ys : Integer) : Integer;
var
  Puffer       : array[0..256] of GLUInt;
  Viewport     : TGLVectori4;
  Treffer,i    : Integer;
  Z_Wert       : GLUInt;
  Getroffen    : GLUInt;
begin
  glGetIntegerv(GL_VIEWPORT, @viewport);      //Die Sicht speichern
  glSelectBuffer(256, @Puffer);               //Den Puffer zuordnen
 
  glMatrixMode(GL_PROJECTION);                //In den Projektionsmodus
  glRenderMode(GL_SELECT);                    //In den Selectionsmodus schalten

  glPushMatrix;                               //Um unsere Matrix zu sichern
    glLoadIdentity;                             //Und dieselbige wieder zurückzusetzen

    gluPickMatrix(xs, viewport[3]-ys, 1.0, 1.0, viewport);
    gluPerspective(45.0, ClientWidth/ClientHeight, NEAR_CLIPPING, FAR_CLIPPING);

    render;                                     //Die Szene zeichnen
    glMatrixMode(GL_PROJECTION);                //Wieder in den Projektionsmodus
  glPopMatrix;                                //und unsere alte Matrix wiederherzustellen

  treffer := glRenderMode(GL_RENDER);         //Anzahl der Treffer auslesen

  Getroffen := High(GLUInt);                  //Höchsten möglichen Wert annehmen
  Z_Wert := High(GLUInt);                     //Höchsten Z - Wert
  for i := 0 to Treffer-1 do
    if Puffer[(i*4)+1] < Z_Wert then
    begin
      getroffen       := Puffer[(i*4)+3];
      Z_Wert := Puffer[(i*4)+1];
    end;
 
  if getroffen=High(GLUInt) 
    then Result := NICHTS
    else Result := getroffen;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : Koordinatenraum
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Frederic Nickol
  * Aufgabe   : Diese Prozedur zeichnet ein Koordinatensystem im Universumursprung
  * Parameter : keine
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TRoboterarmPanel.Koordinatenraum;
begin
  // X-Achse
  glPushMatrix();
    glColor3ub(255, 0, 0);
    glBegin(GL_LINES);
      glVertex3f(-100, 0, 0);
      glVertex3f( 100, 0, 0);
    glEnd();
  glPopMatrix();

  // Y-Achse
  glPushMatrix();
    glColor3ub(0, 255, 0);
    glBegin(GL_LINES);
      glVertex3f( 0, -100, 0);
      glVertex3f( 0,  100, 0);
    glEnd();
  glPopMatrix();

  // Z-Achse
  glPushMatrix();
    glColor3ub(0, 0, 255);
    glBegin(GL_LINES);
      glVertex3f( 0, 0, -100);
      glVertex3f( 0, 0,  100);
    glEnd();
  glPopMatrix();
end;

function TRoboterarmPanel.GetBackgroundColor() : TColor;
begin
  result := Self.roboarmModel.GetBackgroundColor();
end;

function TRoboterarmPanel.GetSkin() : TSkin;
begin
  result := Self.roboarmModel.GetSkin()
end;
{
function TRoboterarmPanel.GetLogLevel() : String;
var rootLogger : TLogLogger;
begin
  rootLogger := TLogLogger.GetRootLogger();
  if(rootLogger.Level = Log4D.Trace) then
    result := 'Trace'
  else if (rootLogger.Level = Log4D.Debug) then
    result := 'Debug'
  else if (rootLogger.Level = Log4D.Info) then
    result := 'Info'
  else if (rootLogger.Level = Log4D.Warn) then
    result := 'Warn'
  else if (rootLogger.Level = Log4D.Error) then
    result := 'Error'
  else if (rootLogger.Level = Log4D.Fatal) then
    result := 'Fatal';
end;
}
procedure TRoboterarmPanel.SetBackgroundColor(color : TColor);
begin
  Self.roboarmModel.SetBackgroundColor(color);
end;

procedure TRoboterarmPanel.SetSkin(skin : TSkin);
begin
  Self.roboarmModel.ShowSkin(skin);
end;

{
procedure TRoboterarmPanel.SetLogLevel(logLevel : String);
var rootLogger : TLogLogger;
begin
  rootLogger := TLogLogger.GetRootLogger();
  if(LowerCase(logLevel) = 'trace') then
    rootLogger.Level := Log4D.Trace
  else if(LowerCase(logLevel) = 'debug') then
    rootLogger.Level := Log4D.Debug
  else if(LowerCase(logLevel) = 'info') then
    rootLogger.Level := Log4D.Info
  else if(LowerCase(logLevel) = 'warn') then
    rootLogger.Level := Log4D.Warn
  else if(LowerCase(logLevel) = 'error') then
    rootLogger.Level := Log4D.Error
  else if(LowerCase(logLevel) = 'fatal') then
    rootLogger.Level := Log4D.Fatal;
end;
}

end.
