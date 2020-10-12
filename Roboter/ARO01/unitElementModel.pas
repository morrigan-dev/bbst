{
    Dieses Werk und alle dazugeh�rigen wurden unter folgender Lizenz ver�ffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausf�hrliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
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
    Diese Klasse ist das Model f�r jede Klasse ~[code TElementX], in dem s�mtliche zu einem Element geh�renden Daten
    abgelegt werden. Ferner beinhaltet dieses Model alle Berechnungen, die sich auf ein Element beziehen.

    ~author Copyright � Thomas Gattinger (2010)
    ~see unitElement0.TElement0 Benutzt dieses Model
  }
  TElementModel = class(TObserverableImpl)
  private
    { Farbe, in der das Element gezeichnet wird }
    color           : TColor;
    { Die r�umliche Tiefenl�nge des Elements in mm }
    depth           : Real;
    { Die r�umliche H�henl�nge des Elements in mm }
    height          : Real;
    { Die r�umliche Breitenl�nge des Elements in mm }
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
  Konstruktor, der dieses Model erzeugt und alle Member mit dem �bergebenen Wert initalisiert.

  ~param color Die Farbe dieses Elements.
  ~param depth Die r�umliche Tiefenl�nge dieses Elements in mm.
  ~param height Die r�umliche H�henl�nge dieses Elements in mm.
  ~param width Die r�umliche Breitenl�nge dieses Elements in mm.
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
  ~result Liefert die aktuelle Farbe des Elements zur�ck.
}
function TElementModel.GetColor()  : TColor;
begin
  result := Self.color;
end;

{
  ~result Liefert die aktuelle r�umliche Tiefenl�nge in mm des Elements zur�ck.
}
function TElementModel.GetDepth()  : Real;
begin
  result := Self.depth;
end;

{
  ~result Liefert die aktuelle r�umliche H�henl�nge in mm des Elements zur�ck.
}
function TElementModel.GetHeight() : Real;
begin
  result := Self.height;
end;

{
  ~result Liefert die aktuelle r�umliche Breitenl�nge in mm des Elements zur�ck.
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
  Setzt die aktuelle r�umliche Tiefenl�nge des Elements in mm, falls sich der neue Wert vom Alten unterscheidet.

  ~param depth Die r�umliche Tiefenl�nge dieses Elements in mm.
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
  Setzt die aktuelle r�umliche H�henl�nge des Elements in mm, falls sich der neue Wert vom Alten unterscheidet.

  ~param height Die r�umliche H�henl�nge dieses Elements in mm.
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
  Setzt die aktuelle r�umliche Breitenl�nge des Elements in mm, falls sich der neue Wert vom Alten unterscheidet.

  ~param width Die r�umliche Breitenl�nge dieses Elements in mm.
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
  Setzt alle �bergebenen Werte, falls diese sich ge�ndert haben.

  ~param color Die Farbe dieses Elements.
  ~param depth Die r�umliche Tiefenl�nge dieses Elements in mm.
  ~param height Die r�umliche H�henl�nge dieses Elements in mm.
  ~param width Die r�umliche Breitenl�nge dieses Elements in mm.
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
