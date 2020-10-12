{
 ******************************************************************************
 * K L A S S E : unitGUI                                                      *
 *----------------------------------------------------------------------------*
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 * Datei     : unitGUI.pas                                                    *
 *                                                                            *
 * Aufgabe   : Diese Klasse zeigt verschiedene Beispiele die GUI zu verändern.*
 *                                                                            *
 * Compiler  : Delphi 7.0                                                     *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
unit unitGUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmGUI = class(TForm)
    edtEingabe: TEdit;
    btnAendereTitel: TButton;
    lblInfo: TLabel;
    gpbVisible: TGroupBox;
    btnVersteckeEingabe: TButton;
    btnZeigeEingabe: TButton;
    gpbEnable: TGroupBox;
    btnVerbieteEingabe: TButton;
    btnErlaubeEingabe: TButton;
    gpbFarbe: TGroupBox;
    btnFaerbeRot: TButton;
    btnFaerbeWeiss: TButton;
    gpbWidth: TGroupBox;
    btnBreiter: TButton;
    btnSchmaeler: TButton;
    gpbHeight: TGroupBox;
    btnGroesser: TButton;
    btnKleiner: TButton;
    gpbFontColor: TGroupBox;
    btnSchriftGruen: TButton;
    btnSchriftSchwarz: TButton;
    procedure btnAendereTitelClick(Sender: TObject);
    procedure btnVersteckeEingabeClick(Sender: TObject);
    procedure btnZeigeEingabeClick(Sender: TObject);
    procedure btnVerbieteEingabeClick(Sender: TObject);
    procedure btnErlaubeEingabeClick(Sender: TObject);
    procedure btnFaerbeRotClick(Sender: TObject);
    procedure btnFaerbeWeissClick(Sender: TObject);
    procedure btnBreiterClick(Sender: TObject);
    procedure btnSchmaelerClick(Sender: TObject);
    procedure btnGroesserClick(Sender: TObject);
    procedure btnKleinerClick(Sender: TObject);
    procedure btnSchriftGruenClick(Sender: TObject);
    procedure btnSchriftSchwarzClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmGUI: TfrmGUI;

implementation

{$R *.dfm}

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur setzt den Titel des Formulars mit dem Inhalt des*
 *             Textfeldes.                                                    *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnAendereTitelClick(Sender: TObject);
begin
  frmGUI.Text := edtEingabe.Text;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur versteckt das Eingabefeld.                      *
 * Parameter : Sender - Das Objekt, von dem das Ereignis kommt.               *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnVersteckeEingabeClick(Sender: TObject);
begin
  edtEingabe.Visible := False;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur zeigt das Eingabefeld wieder an.                *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnZeigeEingabeClick(Sender: TObject);
begin
  edtEingabe.Visible := True;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur verbietet die Eingabe im Eingabetextfeld.       *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnVerbieteEingabeClick(Sender: TObject);
begin
  edtEingabe.Enabled := False;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur erlaubt die Eingabe im Eingabefeld wieder.      *
 * Paramater : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnErlaubeEingabeClick(Sender: TObject);
begin
  edtEingabe.Enabled := True;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur färbt den Hintergund des Eingabefeldes rot ein. *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnFaerbeRotClick(Sender: TObject);
begin
  edtEingabe.Color := clRed;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur färbt den Hintergund des Eingabefeldes weiß ein.*
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnFaerbeWeissClick(Sender: TObject);
begin
  edtEingabe.Color := clWhite;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur setzt eine große Breite für das Eingabefeld.    *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnBreiterClick(Sender: TObject);
begin
  edtEingabe.Width := 329;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur setzt eine schmale Breite für das Eingabefeld.  *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnSchmaelerClick(Sender: TObject);
begin
  edtEingabe.Width := 50;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur setzt eine große Höhe für das Eingabefeld.      *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnGroesserClick(Sender: TObject);
begin
  edtEingabe.Height := 50;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur setzt eine kleine Höhe für das Eingabefeld.     *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnKleinerClick(Sender: TObject);
begin
  edtEingabe.Height := 21;
end;

{
 ******************************************************************************
 * Version   : 1.0                                                            *
 * Autor     : Thomas Gattinger                                               *
 *                                                                            *
 * Aufgabe   : Diese Prozedur setzt die Schriftfarbe im Eingabefeld auf grün. *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.              *
 *                                                                            *
 * Aenderung : 2010-01-24                                                     *
 ******************************************************************************
}
procedure TfrmGUI.btnSchriftGruenClick(Sender: TObject);
begin
  edtEingabe.Font.Color := clGreen;
end;

{
 *********************************************************************************
 * Version   : 1.0                                                               *
 * Autor     : Thomas Gattinger                                                  *
 *                                                                               *
 * Aufgabe   : Diese Prozedur setzt die Schriftfarbe im Eingabefeld auf schwarz. *
 * Parameter : Sender - Das Objekt, von dem das Ereignis stammt.                 *
 *                                                                               *
 * Aenderung : 2010-01-24                                                        *
 *********************************************************************************
}
procedure TfrmGUI.btnSchriftSchwarzClick(Sender: TObject);
begin
  edtEingabe.Font.Color := clBlack;
end;

end.
