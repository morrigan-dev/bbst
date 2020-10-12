{
 **********************************************************************************************************************
 * I N T E R F A C E: IObserverable
 *---------------------------------------------------------------------------------------------------------------------
 * Version:   1.0
 * Autor:     tgattinger
 * Datei:     unitIObserverable.pas
 * Aufgabe:   Dieses Interface stellt eine Schnittstelle für alle Formulare dar, die sich bei einem FormModel
 *            als Observer anmelden möchten.
 * Compiler:  Delphi 7.0
 * Aenderung: 05.11.2009
 **********************************************************************************************************************
}
unit unitIObserverable;

interface
  uses
    unitIObserver;

  type
    IObserverable = interface
      procedure addObserver(observer: IObserver);
      procedure removeObserver(observer: IObserver);
      procedure removeAllObservers();
      procedure notifyObservers(observer: IObserver);
    end;

implementation

end.
