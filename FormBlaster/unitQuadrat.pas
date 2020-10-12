unit unitQuadrat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  // Eigene Units
  unitAbstractGeo, unitIObserver;

type
  TQuadrat = class(TGeo)
  public
    constructor Create(AOwner: TComponent; seitenlaenge: Integer; color: TColor; index: Integer; observer: IObserver);
    procedure Paint(); override;
  end;

implementation

const PADDING = 1;

constructor TQuadrat.Create(AOwner: TComponent; seitenlaenge: Integer; color: TColor; index: Integer; observer: IObserver);
begin
  inherited Create(AOwner, color, index, observer);

  Self.Parent       := TWinControl(AOwner);
  Self.Transparent  := true;
  Self.Width        := seitenlaenge;
  Self.Height       := seitenlaenge;
end;

procedure TQuadrat.Paint();
begin
  Self.Canvas.FillRect(Canvas.ClipRect);
  Self.Canvas.Pen.Color := Self.color;
  Self.Canvas.Rectangle(PADDING, PADDING, Self.Width-PADDING, Self.Height-PADDING);
end;


end.
