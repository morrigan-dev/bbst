{
 ***************************************************************************************
 * K L A S S E : unitAmpel                                                             *
 *-------------------------------------------------------------------------------------*
 * Version   : 1.0                                                                     *
 * Autor     : Thomas Gattinger                                                        *
 * Datei     : unitAmpel.pas                                                           *
 *                                                                                     *
 * Aufgabe   : Diese Klasse simuliert eine einfache Ampelsteuerung                     *
 *             Phasen: 0 - rot       (5 Sekunden)                                      *
 *                     1 - rot-gelb  (1 Sekunden)                                      *
 *                     2 - grün      (3 Sekunden)                                      *
 *                     3 - gelb      (1 Sekunden)                                      *
 *                                                                                     *
 * Compiler  : Delphi 7.0                                                              *
 * Aenderung : 2010-01-24                                                              *
 ***************************************************************************************
}
unit unitAmel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    pnlAmpel: TPanel;
    shpRed: TShape;
    shpYellow: TShape;
    shpGreen: TShape;
    btnStart: TButton;
    btnStopp: TButton;
    btnProgrammende: TButton;
    tmrSteuerung: TTimer;
    procedure btnStartClick(Sender: TObject);
    procedure btnStoppClick(Sender: TObject);
    procedure btnProgrammendeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrSteuerungTimer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  phase: Byte;

implementation

{$R *.dfm}

{
 ***************************************************************************************
 * Version   : 1.0                                                                     *
 * Autor     : Thomas Gattinger                                                        *
 *                                                                                     *
 * Aufgabe   : Startet die Ampelsimulation.                                            *
 * Parameter : Sender - das Objekt, von dem das Ereigniss stammt.                      *
 *                                                                                     *
 * Aenderung : 2010-01-24                                                              *
 ***************************************************************************************
}
procedure TForm1.btnStartClick(Sender: TObject);
begin
  tmrSteuerung.Interval := 1;
  phase := 0;
end;

{
 ***************************************************************************************
 * Version   : 1.0                                                                     *
 * Autor     : Thomas Gattinger                                                        *
 *                                                                                     *
 * Aufgabe   : Stoppt die Ampelsimulation                                              *
 * Parameter : Sender - das Objekt, von dem das Ereigniss stammt.                      *
 *                                                                                     *
 * Aenderung : 2010-01-24                                                              *
 ***************************************************************************************
}
procedure TForm1.btnStoppClick(Sender: TObject);
begin
  tmrSteuerung.Interval := 0;
  shpRed.Brush.Color := clBlack;
  shpYellow.Brush.Color := clBlack;
  shpGreen.Brush.Color := clBlack;
end;

{
 ***************************************************************************************
 * Version   : 1.0                                                                     *
 * Autor     : Thomas Gattinger                                                        *
 *                                                                                     *
 * Aufgabe   : Beendet das Programm.                                                   *
 * Parameter : Sender - das Objekt, von dem das Ereigniss stammt.                      *
 *                                                                                     *
 * Aenderung : 2010-01-24                                                              *
 ***************************************************************************************
}
procedure TForm1.btnProgrammendeClick(Sender: TObject);
begin
  Close;
end;

{
 ***************************************************************************************
 * Version   : 1.0                                                                     *
 * Autor     : Thomas Gattinger                                                        *
 *                                                                                     *
 * Aufgabe   : Initialisiert die Ampel beim Programmstart.                             *
 * Parameter : Sender - das Objekt, von dem das Ereigniss stammt.                      *
 *                                                                                     *
 * Aenderung : 2010-01-24                                                              *
 ***************************************************************************************
}
procedure TForm1.FormCreate(Sender: TObject);
begin
  shpRed.Brush.Color := clBlack;
  shpYellow.Brush.Color := clBlack;
  shpGreen.Brush.Color := clBlack;
end;

{
 ***************************************************************************************
 * Version   : 1.0                                                                     *
 * Autor     : Thomas Gattinger                                                        *
 *                                                                                     *
 * Aufgabe   : Steuert die Ampel und zeigt die verschiedenen Ampelphasen an.           *
 * Parameter : Sender - das Objekt, von dem das Ereigniss stammt.                      *
 *                                                                                     *
 * Aenderung : 2010-01-24                                                              *
 ***************************************************************************************
}
procedure TForm1.tmrSteuerungTimer(Sender: TObject);
var sekunde : Integer;
begin
  sekunde := 1000;

  case phase of
      0: begin // rot
           tmrSteuerung.Interval := 5 * sekunde;
           shpRed.Brush.Color := clRed;
           shpYellow.Brush.Color := clBlack;
           shpGreen.Brush.Color := clBlack;
           phase := 1;
         end;
      1: begin // rot-gelb
           tmrSteuerung.Interval := 1 * sekunde;
           shpRed.Brush.Color := clRed;
           shpYellow.Brush.Color := clYellow;
           shpGreen.Brush.Color := clBlack;
           phase := 2;
         end;
      2: begin // grün
           tmrSteuerung.Interval := 3 * sekunde;
           shpRed.Brush.Color := clBlack;
           shpYellow.Brush.Color := clBlack;
           shpGreen.Brush.Color := clGreen;
           phase := 3;
         end;
      3: begin // gelb
           tmrSteuerung.Interval := 1 * sekunde;
           shpRed.Brush.Color := clBlack;
           shpYellow.Brush.Color := clYellow;
           shpGreen.Brush.Color := clBlack;
           phase := 0;
         end;
  end;
end;

end.
