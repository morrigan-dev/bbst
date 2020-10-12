{
 *****************************************************************************
 * K L A S S E : unitUmwandler
 *---------------------------------------------------------------------------*
 * Version   : 1.0                                                           *
 * Autor     : Thomas Gattinger                                              *
 * Datei     : unitUmwandler.pas                                             *
 *                                                                           *
 * Aufgabe   : Diese Klasse kann eine Dezimalzahl in eine Binärzahl und eine *
 *             Hexadezimalzahl auf zwei unterschiedliche Weisen berechnen.   *
 *                                                                           *
 * Compiler  : Delphi 7.0                                                    *
 * Aenderung : 2010-01-27                                                    *
 *****************************************************************************
}
unit unitUmwandler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmZahlensysteme = class(TForm)
    lblDezimalzahl: TLabel;
    lblBinaerzahl: TLabel;
    lblHexadezimalzahl: TLabel;
    edtDezimalzahl: TEdit;
    edtBinaerzahl: TEdit;
    edtHexadezimalzahl: TEdit;
    btnUmwandelnDelphi: TButton;
    btnUmwandelnKonventionell: TButton;
    btnProgrammende: TButton;
    procedure btnUmwandelnDelphiClick(Sender: TObject);
    procedure btnUmwandelnKonventionellClick(Sender: TObject);
    procedure btnProgrammendeClick(Sender: TObject);
  private
    { Private-Deklarationen }
    function DecToBase(dec: Integer; base: Integer; digits: Integer): String;
  public
    { Public-Deklarationen }
  end;

var
  frmZahlensysteme: TfrmZahlensysteme;

implementation

{$R *.dfm}

{
 *****************************************************************************
 * Version   : 1.0                                                           *
 * Auto      : Thomas Gattinger                                              *
 *                                                                           *
 * Aufgabe   : Diese Funktion wandelt eine beliebiege ganzzahlige            *
 *             Dezimalzahl in ein anderes Zahlensystem b um.                 *
 * Parameter : value - Die umzuwandelnde Dezimalzahl                         *
 *             base - Basis des neuen Zahlensystems                          *
 *             digits - Anzahl der Stellen. Fehlende Stellen werden mit 0    *
 *                      vor der Zahl gefüllt                                 *
 *                                                                           *
 * Aenderung : 2010-01-27                                                    *
 *****************************************************************************
}
function TfrmZahlensysteme.DecToBase(dec: Integer; base: Integer; digits: Integer): String;
const zahlensystemZeichen = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var zaehler : Integer;
begin
  result := '';
  // Wandle Dezimalzahl in anderes Zahlensystem um
  while dec > 0 do
  begin
    result := zahlensystemZeichen[(dec mod base)+1] + result;
    dec := dec div base;
  end;

  // Fülle fehlende Stellen mit '0' auf
  if(Length(result) < digits) then
    for zaehler := 0 to digits-Length(result)-1 do
      result := '0' + result;
end;

{
 *****************************************************************************
 * Version   : 1.0                                                           *
 * Auto      : Thomas Gattinger                                              *
 *                                                                           *
 * Aufgabe   : Diese Prozedur wird beim Drücken des Buttons                  *
 *             'umwandlen (Delphi-Funktion)' aufgerufen.                     *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.             *
 *                                                                           *
 * Aenderung : 2010-01-27                                                    *
 *****************************************************************************
}
procedure TfrmZahlensysteme.btnUmwandelnDelphiClick(Sender: TObject);
var dezimalZahl : Integer;
begin
  try
    dezimalZahl := StrToInt(edtDezimalzahl.Text);
    edtBinaerzahl.Text := DecToBase(dezimalZahl,2,32);
    edtHexadezimalzahl.Text := IntToHex(dezimalZahl,4);
  except
    on EConvertError do
      MessageDlg('"' + edtDezimalzahl.Text + '" ist keine Decimalzahl!', mtWarning, [mbOK], 0);
  end;
end;

{
 *****************************************************************************
 * Version   : 1.0                                                           *
 * Auto      : Thomas Gattinger                                              *
 *                                                                           *
 * Aufgabe   : Diese Prozedur wird beim Drücken des Buttons                  *
 *             'umwandlen (konventionell)' aufgerufen.                       *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.             *
 *                                                                           *
 * Aenderung : 2010-01-27                                                    *
 *****************************************************************************
}
procedure TfrmZahlensysteme.btnUmwandelnKonventionellClick(Sender: TObject);
var dezimalZahl : Integer;
begin
  try
    dezimalZahl := StrToInt(edtDezimalzahl.Text);
    edtBinaerzahl.Text := DecToBase(dezimalZahl,2,32);
    edtHexadezimalzahl.Text := DecToBase(dezimalZahl,16,4);
  except
    on EConvertError do
      MessageDlg('"' + edtDezimalzahl.Text + '" ist keine Decimalzahl!', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmZahlensysteme.btnProgrammendeClick(Sender: TObject);
begin
  Close;
end;

end.
