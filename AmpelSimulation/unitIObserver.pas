{
 **********************************************************************************************************************
 * I N T E R F A C E: IObserver
 *---------------------------------------------------------------------------------------------------------------------
 * Version:   1.0
 * Autor:     tgattinger
 * Datei:     unitIObserver.pas
 * Aufgabe:   Dieses Interface stellt eine Schnittstelle für das FormModel zu
 *            allen registrierten Formularen zur Verfügung, um so das Observer-Pattern zu realisieren.
 * Compiler:  Delphi 7.0
 * Aenderung: 05.11.2009
 **********************************************************************************************************************
}
unit unitIObserver;

interface

type
  IObserver = interface
    procedure update;
  end;

implementation

end.
 