unit unitKreis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Math,

  // Eigene Units
  unitAbstractGeo, unitIObserver;

type
  TKreis = class(TGeo)
  public
    constructor Create(AOwner: TComponent; durchmesser: Integer; color: TColor; index: Integer; observer: IObserver);
    procedure Paint(); override;
  end;

implementation

const PADDING = 1;

constructor TKreis.Create(AOwner: TComponent; durchmesser: Integer; color: TColor; index: Integer; observer: IObserver);
begin
  inherited Create(AOwner, color, index, observer);

  Self.Parent       := TWinControl(AOwner);
  Self.Transparent  := true;
  Self.Width        := durchmesser;
  Self.Height       := durchmesser;
end;

procedure TKreis.Paint();
begin
  Self.Canvas.FillRect(Canvas.ClipRect);
  Self.Canvas.Pen.Color := Self.color;
  Self.Canvas.Ellipse(PADDING, PADDING, Self.Width-PADDING, Self.Height-PADDING);
end;

end.
