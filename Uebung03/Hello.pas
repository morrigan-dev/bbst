{
 **********************************************************************************
 * KLASSE : Hello                                                                 *
 *--------------------------------------------------------------------------------*
 * Version   : 1.0                                                                *
 * Autor     : Thomas Gattinger                                                   *
 * Datei     : Hello.pas                                                          *
 *                                                                                *
 * Aufgabe   : Diese Klasse zeigt ein Formular an, das EVA Prinzip verdeutlichen  *
 *             soll. hierf�r steht ein Eingabetextfeld, ein Verarbeitungsbutton   *
 *             und ein Ausgabelabel zur Verf�gung.                                *
 *                                                                                *
 * Compiler  : Delphi 7.0                                                         *
 * Aenderung : 2010-01-24                                                         *
 **********************************************************************************
}
unit Hello;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    edtEingabe: TEdit;
    btnVerarbeitung: TButton;
    lblAusgabe: TLabel;
    btnEnde: TButton;
    procedure btnVerarbeitungClick(Sender: TObject);
    procedure btnEndeClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{
 ************************************************************************************
 * Version   : 1.0                                                                  *
 * Autor     : Thomas Gatinger                                                      *
 *                                                                                  *
 * Aufgabe   : Diese Prozedur wird beim Dr�cken des 'Verarbeite' Buttons ausgef�hrt *
 *             und schreibt einen Begr��ungstext in das Ausgabelabel zusammen mit   *
 *             dem Text, den der Benutzer in das eingabetextfeld gegeben hat.       *
 * Parameter : Sender - Das Objekt, von dem das Signal stammt.                      *
 *                                                                                  *
 * Aenderung : 2008-01-24                                                           *
 ************************************************************************************
}
procedure TForm1.btnVerarbeitungClick(Sender: TObject);
const nachricht = 'Hallo, sch�n dass Du da bist ';
begin
  lblAusgabe.Caption := nachricht + edtEingabe.Text;
end;

{
 ************************************************************************************
 * Version : 1.0                                                                    *
 * Autor   : Thomas Gattinger                                                       *
 *                                                                                  *
 * Aufgabe : Diese Prozedur beendet das Programm.                                   *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.                    *
 *                                                                                  *
 * Aenderung : 2008-01-24                                                           *
 ************************************************************************************
}
procedure TForm1.btnEndeClick(Sender: TObject);
begin
  Close;
end;

end.
