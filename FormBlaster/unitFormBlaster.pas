unit unitFormBlaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,

  // Eigene Units
  unitAbstractGeo, unitKreis, unitDreieck, unitQuadrat, unitIObserver;

type
  TfrmFormBlaster = class(TForm, IObserver)
    pnlSpielfeld: TPanel;
    Timer1: TTimer;
    lblPunkte: TLabel;
    lblLevel: TLabel;
    memoGameOver: TMemo;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private { Private declarations }
    geos          : Array of TGeo;
    speed         : Integer;
    punkte        : Integer;
    maxPunkte     : Integer;
    level         : Integer;
    deleteIndex   : Integer;
    deleteByClick : Boolean;
    function CreateGeo(index: Integer) : TGeo;
  public { Public declarations }
    procedure SetDeleteIndex(index : Integer; clicked : Boolean);
    procedure DeleteGeo();
  end;

var
  frmFormBlaster: TfrmFormBlaster;

implementation

{$R *.dfm}

const
  MIN_GEO_WIDTH  = 10;
  MAX_GEO_WIDTH  = 50;
  GEO_COUNT      = 10;
  DEFAULT_PUNKTE = 10;
  NEXT_LEVEL     = 1000;
  DEFAULT_SPEED  = 100;

function TfrmFormBlaster.CreateGeo(index: Integer) : TGeo;
var randomIndex : Integer;
    geoWidth    : Integer;
    geoLeft     : Integer;
begin
  randomIndex := Random(3);
  geoWidth    := Random(MAX_GEO_WIDTH - MIN_GEO_WIDTH) + MIN_GEO_WIDTH;
  geoLeft     := Random(Trunc(pnlSpielfeld.Width - geoWidth));
  case randomIndex of
    0: // Dreieck
      begin
        Result := TDreieck.Create(pnlSpielfeld, geoWidth, clRed, index, Self);
      end;
    1: // Quadrat
      begin
        Result := TQuadrat.Create(pnlSpielfeld, geoWidth, clSkyBlue, index, Self);
      end;
    2: // Kreis
      begin
        Result := TKreis.Create(pnlSpielfeld, geoWidth, clYellow, index, Self);
      end;
  end;
  Result.Left := geoLeft;
  Result.Top  := 0;
  Result.Paint();
end;

procedure TfrmFormBlaster.FormCreate(Sender: TObject);
var i : Integer;
begin
  pnlSpielfeld.DoubleBuffered := true;
  Randomize();
  Self.speed  := DEFAULT_SPEED;
  Self.punkte := 0;
  Self.level  := 0;
  Self.deleteIndex := -1;
  Self.deleteByClick := false;
  SetLength(Self.geos, GEO_COUNT);
  for i := 0 to GEO_COUNT - 1 do
  begin
    Self.geos[i] := CreateGeo(i);
  end;
  Timer1.Interval  := Self.speed;
end;

procedure TfrmFormBlaster.Timer1Timer(Sender: TObject);
var i         : Integer;
    incFaktor : Integer;
begin
  if(Self.deleteIndex <> -1) then
  begin
    DeleteGeo();
    Self.deleteIndex := -1;
  end;

  for i := 0 to GEO_COUNT - 1 do
  begin
     incFaktor := Trunc(Self.level / 2);
     Self.geos[i].IncTop(2 + incFaktor);
  end;
end;

procedure TfrmFormBlaster.SetDeleteIndex(index : Integer; clicked : Boolean);
begin
  Self.deleteIndex := index;
  Self.deleteByClick := clicked;
end;

procedure TfrmFormBlaster.DeleteGeo();
var bonusPunkte : Integer;
begin
  bonusPunkte := MAX_GEO_WIDTH - Self.geos[Self.deleteIndex].Width;
  if(Self.deleteByClick) then
    Self.punkte := Self.punkte + DEFAULT_PUNKTE + bonusPunkte
  else
    Self.punkte := Self.punkte - 10 * (DEFAULT_PUNKTE + bonusPunkte);

  if(Self.punkte > Self.maxPunkte) then
    Self.maxPunkte := Self.punkte;
  if(Self.punkte < 0) then
  begin
    Timer1.Interval := 0;
    memoGameOver.Lines[1] := 'Max. Punkte: ' + IntToStr(Self.maxPunkte);
    memoGameOver.Visible := true;
  end;

  Self.level := Self.maxPunkte div NEXT_LEVEL;
  lblLevel.Caption := ' Level ' + IntToStr(Self.level);
  Self.speed := DEFAULT_SPEED - 10 * Self.level;
  if(Self.speed < 0) then
    Self.speed := 1;
  lblPunkte.Caption := IntToStr(Self.punkte) + ' ';

  Self.geos[Self.deleteIndex].Destroy();
  Self.geos[Self.deleteIndex] := CreateGeo(Self.deleteIndex);
end;

end.
