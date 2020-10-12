{
 ******************************************************************************
 * K L A S S E : unitAutoAddition                                             *
 *----------------------------------------------------------------------------*
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 * Datei     : unitAutoAddition.pas                                           *
 *                                                                            *
 * Aufgabe   : Diese Klasse demonstriert, wie eine Addition zweier Zahlen     *
 *             direkt bei Eingabe des Nutzers ausgeführt und Fehler behandelt *
 *             werden können.                                                 *
 *                                                                            *
 * Compiler  : Delphi 7.0                                                     *
 * Aenderung : 2010-01-27                                                     *
 ******************************************************************************
}
unit unitAutoAddition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmAutoAdd = class(TForm)
    edtZahl1: TEdit;
    edtZahl2: TEdit;
    edtErgebnis: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblFehlerHinweis: TLabel;
    procedure edtZahl1Change(Sender: TObject);
    procedure edtZahl2Change(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmAutoAdd: TfrmAutoAdd;

  zahl1 : Real;
  zahl2 : Real;

implementation

{$R *.dfm}

{
 ******************************************************************************
 * Version : 1.0
 * Autor : Thomas Gattinger
 *
 * Aufgabe : Prüft, ob die Eingabe vom Nutzer gültig ist.
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.
 *
 * Aenderung : 2010-01-27
 ******************************************************************************
}
procedure TfrmAutoAdd.edtZahl1Change(Sender: TObject);
begin
  try
    zahl1 := StrToFloat(edtZahl1.Text);
    edtErgebnis.Text := FloatToStr(zahl1 + zahl2);
    lblFehlerHinweis.Caption := '';
  except
    on EConvertError do
    begin
      lblFehlerHinweis.Caption := 'Falsche Eingabe im ersten Eingabefeld!';
      zahl1 := 0;
    end;
  end;
end;

{
 ******************************************************************************
 * Version : 1.0
 * Autor : Thomas Gattinger
 *
 * Aufgabe : Prüft, ob die Eingabe vom Nutzer gültig ist.
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.
 *
 * Aenderung : 2010-01-27
 ******************************************************************************
}
procedure TfrmAutoAdd.edtZahl2Change(Sender: TObject);
begin
  try
    zahl2 := StrToFloat(edtZahl2.Text);
    edtErgebnis.Text := FloatToStr(zahl1 + zahl2);
    lblFehlerHinweis.Caption := '';
  except
    on EConvertError do
    begin
      lblFehlerHinweis.Caption := 'Falsche Eingabe im zweiten Eingabefeld!';
      zahl2 := 0;
    end;
  end;
end;

end.
