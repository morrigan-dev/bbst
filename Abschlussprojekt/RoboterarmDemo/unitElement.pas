unit unitElement;

interface

uses Classes, Graphics, Dialogs, SysUtils, unitIOpenGL, DGLOpenGL;

type

  {
    Diese Klasse ist lediglich für die Schnittstelle im Object Inspector verantwortlich. Sie stellt verschiedene
    Properties zur Verfügung und reicht deren Inhalte an die Zeichenmethoden weiter bzw. holt sich
    die aktuellen Werte.

    ~author Thomas Gattinger
  }
  TElement = class(TPersistent)

    private

      // Properties
     	Fcolor           : TColor;
      Fdepth           : Real;
      Fheight          : Real;
      Fwidth           : Real;

    protected

      // Interne Eigenschaften
      owner            : IOpenGL;
      texture          : PGLUQuadric;
    
      procedure SetColorProperty(color: TColor);
      procedure SetDepthProperty(depth: Real);
      procedure SetHeightProperty(height: Real);
      procedure SetWidthProperty(width: Real);

    public

      constructor Create(owner: IOpenGL);

      procedure SetTexture(texture : PGLUQuadric);
      function GetTexture() : PGLUQuadric;

    published

      property Color           : TColor read Fcolor           write SetColorProperty;
      property Depth           : Real   read Fdepth           write SetDepthProperty;
      property Height          : Real   read Fheight          write SetHeightProperty;
      property Width           : Real   read Fwidth           write SetWidthProperty;
  end;

implementation

{
  Konstruktor, der eine Instanz dieser Klasse erzeugt und die Klassenvariablen initialisiert.

  ~param owner Eine Klasse, die das IOpenGL Interface implementier, um den Callback Aufruf sicherzustellen.

  ~author Thomas Gattinger
  ~version 1.1
}
constructor TElement.Create(owner: IOpenGL);
begin
  inherited Create;

  Self.owner := owner;
  Self.Fcolor := $0000CC00;
  Self.Fdepth := 0;
  Self.Fheight := 0;
  Self.Fwidth := 0;
end;

{
  Setzt die Textur für das Element

  ~param texture Die Textur

  ~author Thomas Gattinger
  ~version 1.0
}
procedure TElement.SetTexture(texture: PGLUQuadric);
begin
  if(Self.texture <> texture) then
  begin
    Self.texture := texture;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

{
  ~return Liefert die Textur des Elements

  ~author Thomas Gattinger
  ~version 1.0
}
function TElement.GetTexture() : PGLUQuadric;
begin
  result := texture;
end;

procedure TElement.SetColorProperty(color: TColor);
begin
  if(Self.Fcolor <> color) then
  begin
    Self.Fcolor := color;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

procedure TElement.SetDepthProperty(depth: Real);
begin
  if(Self.Fdepth <> depth) then
  begin
    Self.Fdepth := depth;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

procedure TElement.SetHeightProperty(height: Real);
begin
  if(Self.Fheight <> height) then
  begin
    Self.Fheight := height;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

procedure TElement.SetWidthProperty(width: Real);
begin
  if(Self.Fwidth <> width) then
  begin
    Self.Fwidth := width;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

end.
