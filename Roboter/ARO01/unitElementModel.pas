{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitElementModel;

interface

uses
  // Delphi Klassen
  Graphics,

  // Eigene Klassen
  unitObserverableImpl;

type

  {
    Diese Klasse ist das Model für jede Klasse ~[code TElementX], in dem sämtliche zu einem Element gehörenden Daten
    abgelegt werden. Ferner beinhaltet dieses Model alle Berechnungen, die sich auf ein Element beziehen.

    ~author Copyright © Thomas Gattinger (2010)
    ~see unitElement0.TElement0 Benutzt dieses Model
  }
  TElementModel = class(TObserverableImpl)
  private
    { Farbe, in der das Element gezeichnet wird }
    color           : TColor;
    { Die räumliche Tiefenlänge des Elements in mm }
    depth           : Real;
    { Die räumliche Höhenlänge des Elements in mm }
    height          : Real;
    { Die räumliche Breitenlänge des Elements in mm }
    width           : Real;

  public
    constructor Create(color : TColor; depth, height, width : Real);
    destructor Destroy(); override;

    function GetColor()  : TColor;
    function GetDepth()  : Real;
    function GetHeight() : Real;
    function GetWidth()  : Real;

    procedure SetColor(color : TColor);
    procedure SetDepth(depth : Real);
    procedure SetHeight(height : Real);
    procedure SetWidth(width : Real);
    procedure SetValues(color : TColor; depth, height, width : Real);
  end;

implementation

{
  Konstruktor, der dieses Model erzeugt und alle Member mit dem übergebenen Wert initalisiert.

  ~param color Die Farbe dieses Elements.
  ~param depth Die räumliche Tiefenlänge dieses Elements in mm.
  ~param height Die räumliche Höhenlänge dieses Elements in mm.
  ~param width Die räumliche Breitenlänge dieses Elements in mm.
}
constructor TElementModel.Create(color : TColor; depth, height, width : Real);
begin
  inherited Create();

  Self.color  := color;
  Self.depth  := depth;
  Self.height := height;
  Self.width  := width;
end;

{
  Standard Destruktor, der dieses Model wieder freigibt.
}
destructor TElementModel.Destroy();
begin
  inherited Destroy();
end;


// =================================
//   G E T T E R - M E T H O D E N
// =================================

{
  ~result Liefert die aktuelle Farbe des Elements zurück.
}
function TElementModel.GetColor()  : TColor;
begin
  result := Self.color;
end;

{
  ~result Liefert die aktuelle räumliche Tiefenlänge in mm des Elements zurück.
}
function TElementModel.GetDepth()  : Real;
begin
  result := Self.depth;
end;

{
  ~result Liefert die aktuelle räumliche Höhenlänge in mm des Elements zurück.
}
function TElementModel.GetHeight() : Real;
begin
  result := Self.height;
end;

{
  ~result Liefert die aktuelle räumliche Breitenlänge in mm des Elements zurück.
}
function TElementModel.GetWidth()  : Real;
begin
  result := Self.width;
end;


// =================================
//   S E T T E R - M E T H O D E N
// =================================

{
  Setzt die aktuelle Farbe des Elements, falls sich der neue Wert vom Alten unterscheidet.

  ~param color Die Farbe dieses Elements.
}
procedure TElementModel.SetColor(color : TColor);
begin
  if(Self.color <> color) then
  begin
    Self.color := color;

    syncViews();
  end;
end;

{
  Setzt die aktuelle räumliche Tiefenlänge des Elements in mm, falls sich der neue Wert vom Alten unterscheidet.

  ~param depth Die räumliche Tiefenlänge dieses Elements in mm.
}
procedure TElementModel.SetDepth(depth : Real);
begin
  if(Self.depth <> depth) then
  begin
    Self.depth := depth;

    syncViews();
  end;
end;

{
  Setzt die aktuelle räumliche Höhenlänge des Elements in mm, falls sich der neue Wert vom Alten unterscheidet.

  ~param height Die räumliche Höhenlänge dieses Elements in mm.
}
procedure TElementModel.SetHeight(height : Real);
begin
  if(Self.height <> height) then
  begin
    Self.height := height;

    syncViews();
  end;
end;

{
  Setzt die aktuelle räumliche Breitenlänge des Elements in mm, falls sich der neue Wert vom Alten unterscheidet.

  ~param width Die räumliche Breitenlänge dieses Elements in mm.
}
procedure TElementModel.SetWidth(width : Real);
begin
  if(Self.width <> width) then
  begin
    Self.width := width;

    syncViews();
  end;
end;

{
  Setzt alle übergebenen Werte, falls diese sich geändert haben.

  ~param color Die Farbe dieses Elements.
  ~param depth Die räumliche Tiefenlänge dieses Elements in mm.
  ~param height Die räumliche Höhenlänge dieses Elements in mm.
  ~param width Die räumliche Breitenlänge dieses Elements in mm.
}
procedure TElementModel.SetValues(color : TColor; depth, height, width : Real);
var change : Boolean;
begin
  change := false;

  if(Self.color <> color) then
  begin
    Self.color := color;
    change := true;
  end;

  if(Self.depth <> depth) then
  begin
    Self.depth := depth;
    change := true;
  end;

  if(Self.height <> height) then
  begin
    Self.height := height;
    change := true;
  end;

  if(Self.width <> width) then
  begin
    Self.width := width;
    change := true;
  end;

  if(change) then
    syncViews();
end;

end.
