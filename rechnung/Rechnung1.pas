unit Rechnung1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    EditRechnungsbetrag: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RechnungErstellen: TButton;
    EditMehrwertsteuersatz: TEdit;
    EditRabattsatz: TEdit;
    EditSkontosatz: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label16: TLabel;
    RechnungsbetragohneMWST: TLabel;
    MWST: TLabel;
    RechnungsbetragmitMWST: TLabel;
    Rabatt: TLabel;
    RechnungsbetragnachRabatt: TLabel;
    Skonto: TLabel;
    Endrechnungsbetrag: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    procedure RechnungErstellenClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.RechnungErstellenClick(Sender: TObject);
var vRechnungsbetrag, vMehrwertsteuersatz, vRabattsatz, vSkontosatz,
    vMWST, vRechnungsbetragmitMWST, vRabatt, vRechnungsbetragnachRabatt,
    vSkonto, vEndrechnungsbetrag : Double;
begin

  //Umwandlung Text in Zahl
  vRechnungsbetrag    := StrToFloat( EditRechnungsbetrag.text );
  vMehrwertsteuersatz := StrToFloat( EditMehrwertsteuersatz.text );
  vRabattsatz         := StrToFloat( EditRabattsatz.Text );
  vSkontosatz         := StrToFloat( EditSkontosatz.text );

  //Rechnung
  vMWST                      := vRechnungsbetrag / 100 * vMehrwertsteuersatz;
  vRechnungsbetragmitMWST    := vRechnungsbetrag + vMWST;
  vRabatt                    := vRechnungsbetragmitMWST / 100 * vRabattsatz;
  vRechnungsbetragnachRabatt := vRechnungsbetragmitMWST - vRabatt;
  vSkonto                    := vRechnungsbetragnachRabatt / 100 * vSkontosatz;

  //Umwandlung Zahl in Text
  MWST.Caption                      := FloatToStr(vMWST);
  RechnungsbetragmitMWST.Caption    := FloatToStr(vRechnungsbetragmitMWST);
  Rabatt.Caption                    := FloatToStr(vRabatt);
  RechnungsbetragnachRabatt.Caption := FloatToStr(vRechnungsbetragnachRabatt);
  Skonto.Caption                    := FloatToStr(vSkonto);
  Endrechnungsbetrag.Caption        := FloatToStr(vEndrechnungsbetrag);
end;

end.
