unit unitDreieck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  // Eigene Units
  unitAbstractGeo, unitIObserver;

type
  TDreieck = class(TGeo)
  public
    constructor Create(AOwner: TComponent; seitenlaenge: Integer; color: TColor; index: Integer; observer: IObserver);
    procedure Paint(); override;
  end;

implementation

const WURZEL_3_HALBE = 0.866025403;
      PADDING = 1;

constructor TDreieck.Create(AOwner: TComponent; seitenlaenge: Integer; color: TColor; index: Integer; observer: IObserver);
begin
  inherited Create(AOwner, color, index, observer);

  Self.Parent       := TWinControl(AOwner);
  Self.Transparent  := true;
  Self.Width        := seitenlaenge;
  Self.Height       := Trunc(WURZEL_3_HALBE * seitenlaenge);
end;

procedure TDreieck.Paint();
var A, B, C : TPoint;
begin
  Self.Canvas.FillRect(Canvas.ClipRect);
  Self.Canvas.Pen.Color := Self.color;

  A.X := Trunc(Self.Width / 2);
  A.Y := Self.Height - PADDING;

  B.X := 0 + PADDING;
  B.Y := 0 + PADDING;

  C.X := Self.Width - PADDING;
  C.Y := 0 + PADDING;    

  // Zeichne Seite a
  Self.Canvas.MoveTo(B.X, B.Y);
  Self.Canvas.LineTo(C.X, C.Y);
  // Zeichne Seite b
  Self.Canvas.LineTo(A.X, A.Y);
  // Zeichne Seite c
  Self.Canvas.LineTo(B.X, B.Y);
end;

end.
