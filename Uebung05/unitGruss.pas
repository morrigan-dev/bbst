{
 *********************************************************************************************
 * K L A S S E : unitGruss                                                                   *
 *-------------------------------------------------------------------------------------------*
 * Version   : 1.0                                                                           *
 * Autor     : Thomas Gattinger                                                              *
 * Datei     : unitGruss.pas                                                                 *
 *                                                                                           *
 * Aufgabe   : Diese Klasse gibt einen Begrüßungstext aus. Dabei muss eine Fallunterscheidung*
 *             getroffen werden, ob der Benutzer männlich oder weiblich ist                  *
 *                                                                                           *
 * Compiler  : Delphi 7.0                                                                    *
 * Aenderung : 2010-01-24                                                                    *
 *********************************************************************************************
}
unit unitGruss;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmGruss = class(TForm)
    lblEingabeInfo: TLabel;
    edtEingabe: TEdit;
    btnGruss: TButton;
    lblAusgabe: TLabel;
    btnEnde: TButton;
    ckbWeiblich: TCheckBox;
    procedure btnGrussClick(Sender: TObject);
    procedure btnEndeClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmGruss: TfrmGruss;

implementation

{$R *.dfm}

{
 *********************************************************************************************
 * Version   : 1.0                                                                           *
 * Autor     : Thomas Gattinger                                                              *
 *                                                                                           *
 * Aufgabe   : Diese Prozedur erstellt zwei Ausgabezeilen vorbei der auszugebene Text von der*
 *             Auswahl des Benutzer abhängt.                                                 *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.                             *
 *                                                                                           *
 * Aenderung : 2010-01-24                                                                    *
 *********************************************************************************************
}
procedure TfrmGruss.btnGrussClick(Sender: TObject);
var zeile1 : String;
    zeile2 : String;
begin
  zeile1 := 'Hallo ' + edtEingabe.Text;
  if(ckbWeiblich.Checked) then
    zeile2 := 'Du bist weiblich.'
  else
    zeile2 := 'Du bist nicht weiblich.';

  lblAusgabe.Caption := zeile1 + chr(13) + zeile2;     
end;

{
 *********************************************************************************************
 * Version   : 1.0                                                                           *
 * Autor     : Thomas Gattinger                                                              *
 *                                                                                           *
 * Aufgabe   : DieseProzedur beendet das Programm                                            *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.                             *
 *                                                                                           *
 * Aenderung : 2010-01-24                                                                    *
 *********************************************************************************************
}
procedure TfrmGruss.btnEndeClick(Sender: TObject);
begin
  Close;
end;

end.
