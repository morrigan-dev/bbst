unit unitAutoAmpel;

interface

uses Controls, Graphics, Classes, ExtCtrls;

type
  TAutoAmpel = class(TPanel)
  private
    { Private-Deklarationen }
    backgroundColor: TColor;
    top: Integer;
    left: Integer;
    width: Integer;  // Bildet die Breite der Ampel ab, nicht die des Ampelobjets
    height: Integer; // Bildet die Höhe der Ampel ab, nicht die des Ampelobjets
    orientation: Integer; // 0 - nord, 1 - ost, 2 - süd, 3 - west
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  end;

implementation

constructor TAutoAmpel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  top := 0;
  left := 0;
  width := 25;
  height := 50;
  orientation := 2;
end;

destructor TAutoAmpel.Destroy();
begin
  inherited Destroy;
end;

end.
