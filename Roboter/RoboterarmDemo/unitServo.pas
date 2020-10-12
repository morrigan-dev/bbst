unit uniTServo;

interface

uses Classes, Graphics, Dialogs, SysUtils, unitIOpenGL, unitElement;

type

  TServo = class(TElement)

    private

      // Properties
      FaktPos          : Real;
    	FhighlightColor  : TColor;
      FmaxGrad         : Real;
      FminGrad         : Real;

      // Interne Eigenschaften
      highlighted      : Boolean;
      aktGrad          : Real;

      procedure correctProzent(var prozent : Real);
      procedure correctGrad(var grad : Real);

      procedure SetAktPosProperty(prozent: Real);
      procedure SetHighlightColorProperty(color: TColor);
      procedure SetMaxGradProperty(grad: Real);
      procedure SetMinGradProperty(grad: Real);

    public

      constructor Create(owner: IOpenGL);

      procedure SetHighlighted(highlighted: Boolean);
      function isHighlighted(): Boolean;
      function GetAktGrad(): Real;

    published
      property AktPos          : Real   read FaktPos          write SetAktPosProperty;
      property HighlightColor  : TColor read FhighlightColor  write SetHighlightColorProperty;
      property MaxGrad         : Real   read FmaxGrad         write SetMaxGradProperty;
      property MinGrad         : Real   read FminGrad         write SetMinGradProperty;

  end;

implementation

// ***** Public *****

constructor TServo.Create(owner: IOpenGL);
begin
  inherited Create(owner);

  Self.FaktPos := 0;
  Self.FhighlightColor := $000000FF;
//  Self.FmaxGrad := 180;
  Self.FminGrad := 0;
  Self.highlighted := false;
end;

procedure TServo.SetHighlighted(highlighted: Boolean);
begin
  Self.highlighted := highlighted;
  if(Self.owner <> nil) then
    Self.owner.Render();
end;

function TServo.isHighlighted(): Boolean;
begin
  result := Self.highlighted;
end;

function TServo.GetAktGrad: Real;
begin
  result := Self.aktGrad;
end;


// ***** Private *****

{ *********************************************************************************************************************
  * P R O C E D U R E : correctProzent
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur korrigiert Prozentwerte, indem nur ein Bereich von 0 bis 100 zugelassen wird.
  *             Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.
  * Parameter : prozent - Der zu korrigierende Prozendwert
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TServo.correctProzent(var prozent : Real);
begin
  // Passe zu große Prozentwerte an, sodass ein Bereich von 0 bis max. 100 Prozent gegeben ist
  while(prozent > 100) do
  begin
    prozent := prozent - 100;
  end;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : correctGrad
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur korrigiert Gradwerte, indem nur ein Bereich von 0 bis 360 zugelassen wird.
  *             Ein Vielfaches dieses Bereiches wird auf diesen Bereich reduziert.
  * Parameter : grad - Der zu korrigierende Gradwert
  * Aenderung : 18.04.2010
  *********************************************************************************************************************
}
procedure TServo.correctGrad(var grad : Real);
begin
  // Passe zu große Gradzahlen an, sodass ein Bereich von 0 bis max. 360 Grad gegeben ist
  while(grad > 360) do
  begin
    grad := grad - 360;
  end;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : SetAktGradProperty
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Setter-Prozedur setzt die Gradzahl des Servo 0.
  *             Unter oder überschreitet der übergebene Gradwert den zulässig Wert, so wird dieser automatisch
  *             korrigiert.
  * Parameter : prozent - Ein Wert zwischen 0 und 100, der den prozentualen Anteil vom maximalen Gradwert angibt.
  * Aenderung : 23.04.2010
  *********************************************************************************************************************
}
procedure TServo.SetAktPosProperty(prozent: Real);
var grad : Real;
begin
  correctProzent(prozent);
  FaktPos := prozent;
  grad := (Self.FmaxGrad-Self.FminGrad) * prozent / 100.0 + Self.FminGrad;

  if(grad < Self.FminGrad) then
  begin
    Self.aktGrad := Self.FminGrad;
    exit;
  end;

  if(grad > Self.FmaxGrad) then
  begin
    Self.aktGrad := Self.FmaxGrad;
    exit;
  end;

  if(Self.aktGrad <> grad) then
  begin
    Self.aktGrad := grad;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

procedure TServo.SetHighlightColorProperty(color: TColor);
begin
  if(Self.FhighlightColor <> color) then
  begin
    Self.FhighlightColor := color;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

procedure TServo.SetMaxGradProperty(grad: Real);
begin
  correctGrad(grad);

  if(Self.FmaxGrad <> grad) then
  begin
    Self.FmaxGrad := grad;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

procedure TServo.SetMinGradProperty(grad: Real);
begin
  correctGrad(grad);

  if(Self.FminGrad <> grad) then
  begin
    Self.FminGrad := grad;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

end.
