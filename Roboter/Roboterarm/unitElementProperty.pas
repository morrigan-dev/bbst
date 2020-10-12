unit unitElementProperty;

interface

uses
  // Delphi Klassen
  Classes, Graphics, Dialogs, SysUtils,

  // OpenGL Klassen
  DGLOpenGL,

  // Eigene Klassen
  unitRoboterarmModel, unitElementModel;

type

  {
    Diese Klasse ist lediglich für die Schnittstelle im Object Inspector verantwortlich. Sie stellt verschiedene
    Properties zur Verfügung und reicht deren Inhalte an das entsprechende ~[code TElementModel] weiter bzw. holt sich
    die aktuellen Werte aus dem Model.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitServoModel.TServoModel Das Model, an das die Daten geschickt werden
    ~see unitElementProperty.TElementProperty Die entsprechende Property Klasse für Elemente
  }
  TElementProperty = class(TPersistent)

    private
      elementModel : TElementModel;

      function GetColorProperty()  : TColor;
      function GetDepthProperty()  : Real;
      function GetHeightProperty() : Real;
      function GetWidthProperty()  : Real;

      procedure SetColorProperty(color: TColor);
      procedure SetDepthProperty(depth: Real);
      procedure SetHeightProperty(height: Real);
      procedure SetWidthProperty(width: Real);

    public
      constructor Create(elementModel : TElementModel);
      destructor Destroy(); override;

    published
      property Color           : TColor read GetColorProperty           write SetColorProperty;
      property Depth           : Real   read GetDepthProperty           write SetDepthProperty;
      property Height          : Real   read GetHeightProperty          write SetHeightProperty;
      property Width           : Real   read GetWidthProperty           write SetWidthProperty;

  end;

implementation

// ***** Public *****

constructor TElementProperty.Create(elementModel : TElementModel);
begin
  inherited Create;

  Self.elementModel := elementModel;
end;

destructor TElementProperty.Destroy();
begin
  inherited Destroy();
end;

// ***** Private *****

function TElementProperty.GetColorProperty() : TColor;
begin
  result := Self.elementModel.GetColor();
end;

function TElementProperty.GetDepthProperty() : Real;
begin
  result := Self.elementModel.GetDepth();
end;

function TElementProperty.GetHeightProperty() : Real;
begin
  result := Self.elementModel.GetHeight();
end;

function TElementProperty.GetWidthProperty() : Real;
begin
  result := Self.elementModel.GetWidth();
end;

procedure TElementProperty.SetColorProperty(color: TColor);
begin
  Self.elementModel.SetColor(color);
end;

procedure TElementProperty.SetDepthProperty(depth: Real);
begin
  Self.elementModel.SetDepth(depth);
end;

procedure TElementProperty.SetHeightProperty(height: Real);
begin
  Self.elementModel.SetHeight(height);
end;

procedure TElementProperty.SetWidthProperty(width: Real);
begin
  Self.elementModel.SetWidth(width);
end;

end.
