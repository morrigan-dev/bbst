{
    Dieses Werk und alle dazugeh�rigen wurden unter folgender Lizenz ver�ffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausf�hrliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
{ *********************************************************************************************************************
  * K L A S S E : unitRoboterarmModel
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Copyright � 2010 by Thomas Gattinger
  * Datei     : unitRoboterarmModel.pas
  * Aufgabe   : Diese Unit stellt Model im Sinne des Observer-Patterns f�r das RoboterarmPanel dar. In diesem Model
  *             befinden sich somit alle Daten und Berechnungen, die f�r die Simulations ben�tigt werden.
  *
  * Compiler  : Delphi 7.0
  * Aenderung : 06.05.2010
  *********************************************************************************************************************
}
unit unitRoboterarmModel;

interface

uses
  // Delphi Klassen
  Dialogs, SysUtils, Graphics, Classes, TypInfo,

  // Eigene Klassen
  unitObserverableImpl, unitOpenGLConfigUtil, unitIObserver;

const
    NICHTS = -1;
    SERVO_0 = 1;
    SERVO_12 = 2;
    SERVO_3 = 3;
    SERVO_4 = 4;
    SERVO_5 = 5;
    SERVO_6 = 6;

type

  {
    Dies sind die verf�gbaren Skins, die benutzt werden k�nnen

    SimpleGrid - Zeichnet die einfache Ansicht als Gitterstruktur
    SimpleFull - Zeichnet die einfache Ansicht mit ausgef�llten Fl�chen
    DetailedGrid - Zeichnet die detailierte Ansicht als Gitterstruktur
    DetailedFull - Zeichnet die detailierte Ansicht mit ausgef�llten Fl�chen
  }
  TSkin = (SimpleGrid, SimpleFull, DetailedGrid, DetailedFull);

  TRoboterarmModel = class(TObserverableImpl, IObserver)

  private
    {
      #############################################
      #                                           #
      #   Variablen f�r diverse Konfigurationen   #
      #                                           #
      #############################################
    }
    koordinatensystemFlag  : Boolean;  // Gibt an, ob das Koordinatensystem des Universums gezeichnet werden soll
    objektMittelpunktFlag  : Boolean;  // Gibt an, ob die Mittelpunkte der einzelnen elemente gezeichnet werden sollen
    rotationMarkierungFlag : Boolean;  // Gibt an, ob auf den Servos Rotationsmarkierungen angezeigt werden sollen
    skinFlag               : TSkin;    // Gibt an, welcher Skin zum �Zeichnen verwendet werden soll
    backgroundColor        : TColor;   // Gibt die Hintergrundfarbe des Universums an
    light                  : Boolean;  // Gibt an, ob der Roboterarm beleuchtet werden soll
    verticalOffset         : Real;     // Gibt an, wie weit der untere Teil des Arms vom unteren Rand entfernt sein soll

    {
      #############################################
      #                                           #
      #   Variablen f�r die Bewegungsengine       #
      #                                           #
      #############################################
    }
    mouseRotation : Boolean;           // Gibt an, ob der Roboterarm per Mausbewegung gedreht werden soll
    xRotation     : Real;              // Verantwortlich f�r die horizontale Rotation des gesamten Universums
    yRotation     : Real;              // Verantwortlich f�r die vertikale Rotation des gesamten Universums
    oldXRotation  : Real;              // Der alte Rotationsstand der horizontalen Rotation des gesamten Universums
    oldYRotation  : Real;              // Der alte Rotationsstand der vertikalen Rotation des gesamten Universums

    mouseMove     : Boolean;           // Gibt an, ob der Roboterarm per Mausbewegung verschoben werden soll
    xMove         : Real;              // Gibt die horizontale Verschiebung des Universums an
    yMove         : Real;              // Gibt die vertikale Verschiebung des Universums an
    oldXMove      : Real;              // Der alte horizontale Verschiebungswert des Universums
    oldYMove      : Real;              // Der alte vertikale Verschiebungswert des Universums

    zZoom         : Real;              // Gibt die Tiefenverschiebung des Universums an

    xMousePos     : Integer;           // x Mausposition zum Zeitpunkt als eine Maustaste gedr�ckt wurde
    yMousePos     : Integer;           // y Mausposition zum Zeitpunkt als eine Maustaste gedr�ckt wurde

    gripperX      : Double;            // x Koordinate des Greifermittelpunkts
    gripperY      : Double;            // y Koordinate des Greifermittelpunkts
    gripperZ      : Double;            // z Koordinate des Greifermittelpunkts

    {
      #############################################
      #                                           #
      #   Variablen f�r die Elemente und Servos   #
      #                                           #
      #############################################
    }

    selectedServo : Integer;

  public
    constructor Create();
    destructor Destroy(); override;

    procedure updateView();
    procedure correctProzent(var prozent : Real);
    procedure correctGrad(var grad : Real);



    // =================================
    //   S E T T E R - M E T H O D E N
    // =================================

    {
      #############################################
      #                                           #
      #   Methoden f�r diverse Konfigurationen    #
      #                                           #
      #############################################
    }
    procedure ShowKoordinatensystem(flag : Boolean);
    procedure ShowObjektMittelpunkt(flag : Boolean);
    procedure ShowRotationMarkierung(flag : Boolean);
    procedure ShowSkin(skin: TSkin);
    procedure SetBackgroundColor(color: TColor);
    procedure SetLight(flag: Boolean);
    procedure SetVerticalOffset(offset: Real);

    {
      #############################################
      #                                           #
      #   Methoden f�r die Bewegungsengine        #
      #                                           #
      #############################################
    }
    // Methoden f�r die Rotation
    procedure SetMouseRotation(mouseRotation : Boolean);
    procedure SetXYRotation(curMouseXPos, curMouseYPos : Integer);
    procedure ResetXYRotation();
    procedure UpdateOldXYRotation();

    // Methoden f�r die Verschiebung auf der x- und y-Achse
    procedure SetMouseMove(mouseMove : Boolean);
    procedure SetXYMove(curMouseXPos, curMouseYPos : Integer);
    procedure ResetXYMove();
    procedure UpdateOldXYMove();

    // Methoden f�r den Zoom (Verschiebung auf der z-Achse)
    procedure IncZoom(factor : Real);
    procedure DecZoom(factor : Real);
    procedure ResetZoom();

    procedure SetXYMousePos(xMousePos, yMousePos : Integer);
    procedure SetGripperXYZ(x, y, z : Double);

    {
      #############################################
      #                                           #
      #   Methoden f�r die Elemente und Servos    #
      #                                           #
      #############################################
    }
    procedure SetSelectedServo(servo : Integer);


    // =================================
    //   G E T T E R - M E T H O D E N
    // =================================

    {
      #############################################
      #                                           #
      #   Methoden f�r diverse Konfigurationen    #
      #                                           #
      #############################################
    }
    function IsKoordinatensystem()  : Boolean;
    function IsObjektMittelpunkt()  : Boolean;
    function IsRotationMarkierung() : Boolean;
    function GetSkin()              : TSkin;
    function GetSimpleSkinPath()    : String;
    function GetBackgroundColor()   : TColor;
    function IsLight()              : Boolean;
    function GetVerticalOffset()    : Real;

    {
      #############################################
      #                                           #
      #   Methoden f�r die Bewegungsengine        #
      #                                           #
      #############################################
    }
    // Methoden f�r die Rotation
    function IsMouseRotation() : Boolean;
    function GetXRotation()    : Real;
    function GetYRotation()    : Real;

    // Methoden f�r die Verschiebung auf der x- und y-Achse
    function IsMouseMove() : Boolean;
    function GetXMove()    : Real;
    function GetYMove()    : Real;

    // Methoden f�r den Zoom (Verschiebung auf der z-Achse)
    function GetZoom() : Real;

    function GetXMousePos() : Real;
    function GetYMousePos() : Real;
    function GetGripperX() : Double;
    function GetGripperY() : Double;
    function GetGripperZ() : Double;

    {
      #############################################
      #                                           #
      #   Methoden f�r die Elemente und Servos    #
      #                                           #
      #############################################
    }
    function GetSelectedServo() : Integer;

  end;

implementation

const
  DEFAULT_ZOOM = -800;

{ *********************************************************************************************************************
  * C O N S T R U C T O R : Create()
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Dieser Konstruktor erzeugt eine Instanz dieses Models und belegt alle Variablen mit einem Defaultwert.
  * Parameter : keine
  * Aenderung : 06.05.2010
  *********************************************************************************************************************
}
constructor TRoboterarmModel.Create();
begin
  inherited Create();

  Self.koordinatensystemFlag  := False;
  Self.objektMittelpunktFlag  := False;
  Self.rotationMarkierungFlag := False;
  Self.skinFlag               := DetailedFull;
  Self.backgroundColor        := clBtnFace;
  Self.light                  := true;

  Self.mouseRotation := False;
  Self.xRotation     := 0.0;
  Self.yRotation     := 0.0;
  Self.oldXRotation  := 0.0;
  Self.oldYRotation  := 0.0;

  Self.mouseMove     := False;
  Self.xMove         := 0.0;
  Self.yMove         := 0.0;
  Self.oldXMove      := 0.0;
  Self.oldYMove      := 0.0;

  Self.zZoom         := DEFAULT_ZOOM;

  Self.xMousePos     := 0;
  Self.yMousePos     := 0;

  Self.selectedServo := NICHTS;
end;

{ *********************************************************************************************************************
  * D E S T R U C T O R : Destroy()
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Dieser Destruktor gibt die aktuelle Instanz des Models wieder frei.
  * Parameter : keine
  * Aenderung : 06.05.2010
  *********************************************************************************************************************
}
destructor TRoboterarmModel.Destroy();
begin
  inherited Destroy();
end;

procedure TRoboterarmModel.updateView();
begin
  syncViews();
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : correctProzent
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur korrigiert Prozentwerte, indem nur ein Bereich von 0 bis 100 zugelassen wird.
  *             Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.
  * Parameter : prozent - Der zu korrigierende Prozendwert
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TRoboterarmModel.correctProzent(var prozent : Real);
begin
  // Passe zu gro�e Prozentwerte an, sodass ein Bereich von 0 bis max. 100 Prozent gegeben ist
  while(prozent > 100) do
  begin
    prozent := prozent - 100;
  end;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : correctGrad
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur korrigiert Gradwerte, indem nur ein Bereich von 0 bis 360 zugelassen wird.
  *             Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.
  * Parameter : grad - Der zu korrigierende Gradwert
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TRoboterarmModel.correctGrad(var grad : Real);
begin
  // Passe zu gro�e Gradzahlen an, sodass ein Bereich von 0 bis max. 360 Grad gegeben ist
  while(grad > 360) do
  begin
    grad := grad - 360;
  end;
end;



// =================================
//   S E T T E R - M E T H O D E N
// =================================

{
  ####################################################
  #                                                  #
  #   Setter-Methoden f�r diverse Konfigurationen    #
  #                                                  #
  ####################################################
}
procedure TRoboterarmModel.ShowKoordinatensystem(flag : Boolean);
begin
  if(Self.koordinatensystemFlag = flag) then exit;

  if(not hasChanged()) then
  begin
    Self.koordinatensystemFlag := flag;

    syncViews();
  end;
end;

procedure TRoboterarmModel.ShowObjektMittelpunkt(flag : Boolean);
begin
  if(Self.objektMittelpunktFlag = flag) then exit;

  if(not hasChanged()) then
  begin
    Self.objektMittelpunktFlag := flag;

    syncViews();
  end;
end;

procedure TRoboterarmModel.ShowRotationMarkierung(flag : Boolean);
begin
  if(Self.rotationMarkierungFlag = flag) then exit;

  if(not hasChanged()) then
  begin
    Self.rotationMarkierungFlag := flag;

    syncViews();
  end;
end;

procedure TRoboterarmModel.ShowSkin(skin: TSkin);
begin
  if(Self.skinFlag = skin) then exit;

  if(not hasChanged()) then
  begin
    Self.skinFlag := skin;

    syncViews();
  end;
end;

procedure TRoboterarmModel.SetBackgroundColor(color : TColor);
begin
  if(Self.backgroundColor = color) then exit;

  if(not hasChanged()) then
  begin
    Self.backgroundColor := color;

    syncViews();
  end;
end;

procedure TRoboterarmModel.SetLight(flag: Boolean);
var util : TOpenGLConfigUtil;
begin
  if(Self.light = flag) then exit;

  if(not hasChanged()) then
  begin
    Self.light := flag;

    util := TOpenGLConfigUtil.getInstance();
    if(flag = true) then
      util.EnableLight()
    else
      util.DisableLight();

    syncViews();
  end;
end;

procedure TRoboterarmModel.SetVerticalOffset(offset: Real);
begin
  if(Self.verticalOffset = offset) then exit;

  if(not hasChanged()) then
  begin
    Self.verticalOffset := offset;

    syncViews();
  end;
end;

{
  ####################################################
  #                                                  #
  #   Setter-Methoden f�r die Bewegungsengine        #
  #                                                  #
  ####################################################
}
procedure TRoboterarmModel.SetMouseRotation(mouseRotation : Boolean);
begin
  Self.mouseRotation := mouseRotation;
end;

procedure TRoboterarmModel.SetMouseMove(mouseMove : Boolean);
begin
  Self.mouseMove := mouseMove;
end;

procedure TRoboterarmModel.SetXYRotation(curMouseXPos, curMouseYPos : Integer);
begin
  if(not hasChanged()) then
  begin
    Self.xRotation := Self.oldXRotation - (Self.yMousePos - curMouseYPos);
    Self.yRotation := Self.oldYRotation - (Self.xMousePos - curMouseXPos);

    syncViews();
  end;
end;

procedure TRoboterarmModel.UpdateOldXYRotation();
begin
  Self.oldXRotation := Self.xRotation;
  Self.oldYRotation := Self.yRotation;
end;

procedure TRoboterarmModel.ResetXYRotation();
begin
  if(not hasChanged()) then
  begin
    Self.xRotation := 0.0;
    Self.yRotation := 0.0;
    UpdateOldXYRotation();

    syncViews();
  end;
end;

procedure TRoboterarmModel.SetXYMove(curMouseXPos, curMouseYPos : Integer);
begin
  if(not hasChanged()) then
  begin
    Self.xMove := Self.oldXMove - (Self.xMousePos - curMouseXPos) * 0.5;
    Self.yMove := Self.oldYMove + (Self.yMousePos - curMouseYPos) * 0.5;

    syncViews();
  end;
end;

procedure TRoboterarmModel.ResetXYMove();
begin
  if(not hasChanged()) then
  begin
    Self.xMove := 0.0;
    Self.yMove := 0.0;
    UpdateOldXYMove();

    syncViews();
  end;
end;

procedure TRoboterarmModel.UpdateOldXYMove();
begin
  Self.oldXMove := Self.xMove;
  Self.oldYMove := Self.yMove;
end;

procedure TRoboterarmModel.IncZoom(factor : Real);
begin
  if(not hasChanged()) then
  begin
    Self.zZoom := Self.zZoom + factor;

    syncViews();
  end;
end;

procedure TRoboterarmModel.DecZoom(factor : Real);
begin
  if(not hasChanged()) then
  begin
    Self.zZoom := Self.zZoom - factor;

    syncViews();
  end;
end;

procedure TRoboterarmModel.ResetZoom();
begin
  if(not hasChanged()) then
  begin
    Self.zZoom := DEFAULT_ZOOM;

    syncViews();
  end;
end;

procedure TRoboterarmModel.SetXYMousePos(xMousePos, yMousePos : Integer);
begin
  Self.xMousePos := xMousePos;
  Self.yMousePos := yMousePos;
end;

procedure TRoboterarmModel.SetGripperXYZ(x, y, z : Double);
begin
  if(not hasChanged()) then
  begin
    Self.gripperX := x;
    Self.gripperY := y;
    Self.gripperZ := z;

    syncViews();
  end;
end;

{
  ####################################################
  #                                                  #
  #   Setter-Methoden f�r die Elemente und Servos    #
  #                                                  #
  ####################################################
}

procedure TRoboterarmModel.SetSelectedServo(servo : Integer);
begin
  if(not hasChanged()) then
  begin
    Self.selectedServo := servo;

    syncViews();
  end;
end;



// =================================
//   G E T T E R - M E T H O D E N
// =================================

{
  ####################################################
  #                                                  #
  #   Getter-Methoden f�r diverse Konfigurationen    #
  #                                                  #
  ####################################################
}
function TRoboterarmModel.IsKoordinatensystem() : Boolean;
begin
  result := Self.koordinatensystemFlag;
end;

function TRoboterarmModel.IsObjektMittelpunkt() : Boolean;
begin
  result := Self.objektMittelpunktFlag;
end;

function TRoboterarmModel.IsRotationMarkierung() : Boolean;
begin
  result := Self.rotationMarkierungFlag;
end;

function TRoboterarmModel.GetSkin() : TSkin;
begin
  result := Self.skinFlag;
end;

function TRoboterarmModel.GetSimpleSkinPath() : String;
begin
  result := 'images\skin\simple\';
end;

function TRoboterarmModel.GetBackgroundColor() : TColor;
begin
  result := Self.backgroundColor;
end;

function TRoboterarmModel.IsLight() : Boolean;
begin
  result := Self.light;
end;

function TRoboterarmModel.GetVerticalOffset() : Real;
begin
  result := Self.verticalOffset;
end;

{
  ####################################################
  #                                                  #
  #   Getter-Methoden f�r die Bewegungsengine        #
  #                                                  #
  ####################################################
}
function TRoboterarmModel.IsMouseRotation() : Boolean;
begin
  result := Self.mouseRotation;
end;

function TRoboterarmModel.IsMouseMove() : Boolean;
begin
  result := Self.mouseMove;
end;

function TRoboterarmModel.GetXRotation() : Real;
begin
  result := Self.xRotation;
end;

function TRoboterarmModel.GetYRotation() : Real;
begin
  result := Self.yRotation;
end;

function TRoboterarmModel.GetXMousePos() : Real;
begin
  result := Self.xMousePos;
end;

function TRoboterarmModel.GetYMousePos() : Real;
begin
  result := Self.yMousePos;
end;

function TRoboterarmModel.GetXMove() : Real;
begin
  result := Self.xMove;
end;

function TRoboterarmModel.GetYMove() : Real;
begin
  result := Self.yMove;
end;

function TRoboterarmModel.GetZoom() : Real;
begin
  result := Self.zZoom;
end;

function TRoboterarmModel.GetGripperX() : Double;
begin
  result := Self.gripperX;
end;

function TRoboterarmModel.GetGripperY() : Double;
begin
  result := Self.gripperY;
end;

function TRoboterarmModel.GetGripperZ() : Double;
begin
  result := Self.gripperZ;
end;

{
  ####################################################
  #                                                  #
  #   Getter-Methoden f�r die Elemente und Servos    #
  #                                                  #
  ####################################################
}
function TRoboterarmModel.GetSelectedServo() : Integer;
begin
  result := Self.selectedServo;
end;

end.
