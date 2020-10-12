{
 *******************************************************************************
 * K L A S S E : unitAddition                                                  *
 *-----------------------------------------------------------------------------*
 * Version   : 1.0                                                             *
 * Autor     : Thomas Gattinger                                                *
 * Datei     : unitAddition.pas                                                *
 *                                                                             *
 * Aufgabe   : Diese Klasse zeigt anhand einer einfachen Addition die          *
 *             Verwendung von try ... except                                   *
 *                                                                             *
 * Compiler  : Delphi 7.0                                                      *
 * Aenderung : 2010-01-24                                                      *
 *******************************************************************************
}

unit unitAddition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmAddition = class(TForm)
    edtZahl1: TEdit;
    edtZahl2: TEdit;
    edtErgebnis: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnRechne: TButton;
    procedure btnRechneClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmAddition: TfrmAddition;

implementation

{$R *.dfm}

{
 *******************************************************************************
 * Version   : 1.0                                                             *
 * Autor     : Thomas Gattinger                                                *
 *                                                                             *
 * Aufgabe   : Diese Prozedur liest zwei Zahlen aus zwei Textfeldern aus und   *
 *             addiert diese. Das Ergebnis wird anschließend in einem dritten  *
 *             Textfeld angezeigt. Bei fehlerhaften Benutzereingaben wird eine *
 *             Warnung angezeigt.                                              *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.               *
 *                                                                             *
 * Aenderung : 2010-01-24                                                      *
 *******************************************************************************
}
procedure TfrmAddition.btnRechneClick(Sender: TObject);
var zahl1 : Real;
    zahl2 : Real;
    ergebnis : Real;
    errorMsg : String;
begin
  errorMsg := '';

  // Versuche die erste Zahl aus dem ersten Textfeld zu lesen
  try
    zahl1 := StrToFloat(edtZahl1.Text);
  except
    on EConvertError do
      errorMsg := 'Erstes Eingabefeld: "'+ edtZahl1.Text + '" ist keine gültige Zahl!'+ chr(13);
    on EOverflow do
      errorMsg := 'Erstes Eingabefeld: "'+ Copy(edtZahl1.Text,0,10) + '..." ist zu groß!'+ chr(13);
  end;

  // Versuche die zweite Zahl aus dem zweiten Textfeld zu lesen
  try
    zahl2 := StrToFloat(edtZahl2.Text);
  except
    on EConvertError do
      errorMsg := errorMsg + 'Zweites Eingabefeld: "'+ edtZahl2.Text + '" ist keine gültige Zahl!'+ chr(13);
    on EOverflow do
      errorMsg := errorMsg + 'Zweites Eingabefeld: "'+ Copy(edtZahl2.Text,0,10) + '..." ist zu groß!'+ chr(13);
  end;

  // Falls ein Fehler auftrat, so gebe ihn hier aus
  if(errorMsg <> '') then
  begin
    errorMsg := 'In Ihrer Eingabe befindet sich ein Fehler:' + chr(13) + chr(13) + errorMsg + chr(13) + 'Bitte korrigieren Sie Ihre Eingabe.';
    MessageDlg(errorMsg, mtWarning, [mbOK], 0);
  end
  else  // Andernfalls führe die Addition aus und zeige das Ergebnis an
  begin
    ergebnis := zahl1 + zahl2;
    edtErgebnis.Text := FloatToStr(ergebnis);
  end;
end;

end.
