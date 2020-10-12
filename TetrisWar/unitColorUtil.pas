unit unitColorUtil;

interface

uses Graphics;

function RGB2TColor(const R, G, B: Byte): TColor;
procedure TColor2RGB(const Color: TColor; var R, G, B: Byte);
function BrightenUpColor(const Color: TColor; factor: Byte): TColor;

implementation

function RGB2TColor(const R, G, B: Byte): TColor;
begin
  // convert hexa-decimal values to RGB
  Result := R + G shl 8 + B shl 16;
end;


procedure TColor2RGB(const Color: TColor; var R, G, B: Byte);
begin
  // convert hexa-decimal values to RGB
  R := Color and $FF;
  G := (Color shr 8) and $FF;
  B := (Color shr 16) and $FF;
end;

function BrightenUpColor(const Color: TColor; factor: Byte): TColor;
Var
 R, G, B : Byte;
begin
  TColor2RGB(Color, R, G, B);
//  R := R + factor;
//  G := G + factor;
//  B := B + factor;
  if(R > 255) then R := 255;
  if(G > 255) then G := 255;
  if(B > 255) then B := 255;
  Result := RGB2TColor(R, G, B);
end;

end.
