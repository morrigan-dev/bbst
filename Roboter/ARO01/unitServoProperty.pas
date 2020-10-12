{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitServoProperty;

interface

uses
  // Delphi Klassen
  Classes, Graphics, Dialogs, SysUtils,

  // Eigene Klassen
  unitServoModel;

type

  {
    Diese Klasse ist lediglich für die Schnittstelle im Object Inspector verantwortlich. Sie stellt verschiedene
    Properties zur Verfügung und reicht deren Inhalte an das entsprechende ~[code TServoModel] weiter bzw. holt sich
    die aktuellen Werte aus dem Model.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitServoModel.TServoModel Das Model, an das die Daten geschickt werden
    ~see unitElementProperty.TElementProperty Die entsprechende Property Klasse für Elemente
  }
  TServoProperty = class(TPersistent)

    private
      { Das Model des Servos }
      servoModel : TServoModel;

      // Getter, die auch ein Element besitzt
      function GetColorProperty()  : TColor;
      function GetDepthProperty()  : Real;
      function GetHeightProperty() : Real;
      function GetWidthProperty()  : Real;

      // Setter, die auch ein Element besitzt
      procedure SetColorProperty(color: TColor);
      procedure SetDepthProperty(depth: Real);
      procedure SetHeightProperty(height: Real);
      procedure SetWidthProperty(width: Real);


      // Getter, die speziell für einen Servo hinzukommen
      function GetAktPosProperty() : Real;
      function GetHighlightColorProperty() : TColor;
      function GetMaxGradProperty() : Real;
      function GetMinGradProperty() : Real;

      // Setter, die speziell für einen Servo hinzukommen
      procedure SetAktPosProperty(prozent: Real);
      procedure SetHighlightColorProperty(color: TColor);
      procedure SetMaxGradProperty(grad: Real);
      procedure SetMinGradProperty(grad: Real);

    public
      constructor Create(servoModel: TServoModel);

    published
      // Properties, die auch ein Element besitzt
      property Color           : TColor read GetColorProperty           write SetColorProperty;
      property Depth           : Real   read GetDepthProperty           write SetDepthProperty;
      property Height          : Real   read GetHeightProperty          write SetHeightProperty;
      property Width           : Real   read GetWidthProperty           write SetWidthProperty;

      // Properties, die speziell nur ein Servo besitzt
      property AktPos          : Real   read GetAktPosProperty          write SetAktPosProperty;
      property HighlightColor  : TColor read GetHighlightColorProperty  write SetHighlightColorProperty;
      property MaxGrad         : Real   read GetMaxGradProperty         write SetMaxGradProperty;
      property MinGrad         : Real   read GetMinGradProperty         write SetMinGradProperty;

  end;

implementation

{
  Konstruktor, der das Model des Servos setzt, damit die Werte aus dem Object Inspector an den korrekten Servo
  gesendet werden.

  ~param servoModel Das Model des Servos zu dem die Properties Einträge gehören.
}
constructor TServoProperty.Create(servoModel: TServoModel);
begin
  inherited Create();

  Self.servoModel := servoModel;
end;


// =================================================
//   P R I V A T E   G E T T E R - M E T H O D E N
// =================================================

{
  Zeigt im Object Inspector den aktuellen Farbwert des Servos an.

  ~result Den aktuellen Farbwert des Servos.
}
function TServoProperty.GetColorProperty() : TColor;
begin
  result := Self.servoModel.GetColor();
end;

{
  Zeigt im Object Inspector den aktuellen räumliche Tiefenwert des Servos an.

  ~result Den aktuellen räumlichen Tiefenwert des Servos als.
}
function TServoProperty.GetDepthProperty() : Real;
begin
  result := Self.servoModel.GetDepth();
end;

{
  Zeigt im Object Inspector den aktuellen räumliche Höhenwert des Servos an.

  ~result Den aktuellen räumlichen Höhenwert des Servos.
}
function TServoProperty.GetHeightProperty() : Real;
begin
  result := Self.servoModel.GetHeight();
end;

{
  Zeigt im Object Inspector den aktuellen räumliche Breitenwert des Servos an.

  ~result Den aktuellen räumlichen Breitenwert des Servos.
}
function TServoProperty.GetWidthProperty() : Real;
begin
  result := Self.servoModel.GetWidth();
end;

{
  Zeigt im Object Inspector die aktuelle Position in Prozent des Servos an.

  ~result Die aktuelle Position des Servos im Bereich von 0 bis 100.
}
function TServoProperty.GetAktPosProperty() : Real;
begin
  result := Self.servoModel.GetCurPosition();
end;

{
  Zeigt im Object Inspector die aktuelle Highlight Farbe des Servos an.

  ~result Die aktuelle Highlight Farbe des Servos.
}
function TServoProperty.GetHighlightColorProperty() : TColor;
begin
  result := Self.servoModel.GetHighlightColor();
end;

{
  Zeigt im Object Inspector den maximalen Gradwert des Servos an.

  ~result Den maximalen Gradwert des Servos im Bereich von 0° bis 360°.
}
function TServoProperty.GetMaxGradProperty() : Real;
begin
  result := Self.servoModel.GetMaxDegree();
end;

{
  Zeigt im Object Inspector den minimalen Gradwert des Servos an.

  ~result Den minimalen Gradwert des Servos im Bereich von 0° bis 360°.
}
function TServoProperty.GetMinGradProperty() : Real;
begin
  result := Self.servoModel.GetMinDegree();
end;


// =================================================
//   P R I V A T E   S E T T E R - M E T H O D E N
// =================================================

{
  Reicht den Farbwert aus dem Object Inspector an das Model des Servos weiter.

  ~param color Die zu setzende Farbe.
}
procedure TServoProperty.SetColorProperty(color: TColor);
begin
  Self.servoModel.SetColor(color);
end;

{
  Reicht den räumlichen Tiefenwert aus dem Object Inspector an das Model des Servos weiter.

  ~param depth Die zu setzende räumliche Tiefenlänge.
}
procedure TServoProperty.SetDepthProperty(depth: Real);
begin
  Self.servoModel.SetDepth(depth);
end;

{
  Reicht den räumlichen Höhenwert aus dem Object Inspector an das Model des Servos weiter.

  ~param height Die zu setzende räumliche Höhenlänge.
}
procedure TServoProperty.SetHeightProperty(height: Real);
begin
  Self.servoModel.SetHeight(height);
end;

{
  Reicht den räumlichen Breitenwert aus dem Object Inspector an das Model des Servos weiter.

  ~param width Die zu setzende räumliche Breitenlänge.
}
procedure TServoProperty.SetWidthProperty(width: Real);
begin
  Self.servoModel.SetWidth(width);
end;

{
  Reicht den neuen Gradwert aus dem Object Inspector an das Model des Servos weiter.

  ~param prozent Der neue Gradwert des Servos.
}
procedure TServoProperty.SetAktPosProperty(prozent: Real);
begin
  Self.servoModel.SetCurPosition(prozent);
end;

{
  Reicht den Highlight Farbwert aus dem Object Inspector an das Model des Servos weiter.

  ~param color Der Highlight Farbwert des Servos.
}
procedure TServoProperty.SetHighlightColorProperty(color: TColor);
begin
  Self.servoModel.SetHighlightColor(color);
end;

{
  Reicht den neuen maximalen Gradwert aus dem Object Inspector an das Model des Servos weiter.

  ~param grad Der neue maximale Gradwert des Servos.
}
procedure TServoProperty.SetMaxGradProperty(grad: Real);
begin
  Self.servoModel.SetMaxDegree(grad);
end;

{
  Reicht den neuen minimale Gradwert aus dem Object Inspector an das Model des Servos weiter.

  ~param grad Der neue minimale Gradwert des Servos.
}
procedure TServoProperty.SetMinGradProperty(grad: Real);
begin
  Self.servoModel.SetMinDegree(grad);
end;

end.
