unit unitAbstractServo;

interface

uses
  // Delphi Klassen
  Controls, Classes,

  // OpenGL Klassen
  DGLOpenGL, glBMP,

  // Eigene Klassen
  unitAbstractElement, unitRoboterarmModel, unitServoModel;

type

  TAbstractServo = class (TAbstractElement)

  public
    constructor Create(AOwner: TComponent; roboarmModel : TRoboterarmModel);
    destructor Destroy; override;

    procedure Render(); virtual; abstract;
  end;

implementation

{
  Dieser Konstruktor muss von allen abgeleiteten Servo Klassen aufgerufen werden, damit das ~[code Parent] Attribut
  und das ~[code TRoboterarmModel] initialisiert sind.
}
constructor TAbstractServo.Create(AOwner: TComponent; roboarmModel : TRoboterarmModel);
begin
  inherited Create(AOwner, roboarmModel);
end;

destructor TAbstractServo.Destroy;
begin
  inherited Destroy;
end;

end.
