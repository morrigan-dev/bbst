unit unitAbstractSort;

interface

uses
  // Delphi Klassen
  ExtCtrls, Windows, Dialogs, SysUtils, Classes, Printers, Graphics,

  // Eigene Klassen
  unitTypes, unitMainModel;

type

  TAbstractSort = class(TThread)

  private
    lastException : Exception;

    procedure InitSort;
    procedure ShowErrorMessage;
    procedure UpdateGUI();

  protected
    formModel       : TMainModel;                 // FormModel des Hauptprogramms
    operationCount  : Integer;                    // Anzahl der Operationen (nur Sortieralgoithmus)
                                                  // Eine Operation entspricht einer Codezeile
    unsortedArray   : TDynIntArray;               // Das zu sortierende Array
    sortedArray     : TDynIntArray;               // Das sortierte Array
    swapCount       : Integer;                    // Anzahl der Vertauschungen (nur Sortieralgoithmus)
    comparisonCount : Integer;                    // Anzahl der Vergleiche (nur Sortieralgoithmus)

    procedure Execute; override;
    procedure SortArray; virtual; abstract;
    procedure Swap(i, j : Integer);
    procedure visualAfterSwap(i, j : Integer);
    procedure visualBeforeSwap(i, j : Integer);

  public
    constructor Create(AOwner : TComponent; formModel : TMainModel);

    function GetSortedArray : TDynIntArray;
    procedure SetUnsortedArray(unsortedArray : TDynIntArray);

  end;

implementation

// ************************************************************************
// *     PUBLIC: Ab hier sind alle public-Methoden                        *
// ************************************************************************

{
  Dieser Konstruktor erzeugt ein neues Sortier-Objekt, dass in einem eigenen
  Thread läuft. Der Thread startet erst, wenn Resume aufgerufen wird und
  terminiert sobald die Execute Methode abgelaufen ist.

  ~param AOwner Der Besitzer dieses Threads
  ~param formModel Das FormModel des Hauptformulars
}
constructor TAbstractSort.Create(AOwner : TComponent; formModel : TMainModel);
begin
  inherited Create(true);
  Self.FreeOnTerminate := true;

  Self.formModel := formModel;
end;

{
  Diese Methode liefert das sortierte Array zurück.

  ~return Ein sortiertes Array
}
function TAbstractSort.GetSortedArray : TDynIntArray;
begin
  result := Self.sortedArray;
end;

{
  Diese Methode setzt ein unsortiertes Array. Das Array wird als Referenz
  übergeben, damit sich Änderungen direkt auf den Viewer auswirken.

  ~param UnsortedArray Ein unsortiertes Array
}
procedure TAbstractSort.SetUnsortedArray(unsortedArray : TDynIntArray);
begin
  Self.unsortedArray := unsortedArray;
end;


// ************************************************************************
// *     PROTECTED: Ab hier sind alle protected-Methoden                  *
// ************************************************************************

{
  Diese Methode wird beim Starten dieses Threads aufgerufen.
}
procedure TAbstractSort.Execute;
begin
  initSort;
end;

{
  Diese Methode vertauscht im sortierten Array die Elemente an den Positionen i und j.
  Je nach Einstellung wird diese Vertauschung unterschiedlich visualisiert.

  ~param i Der erste Index des Array, der vertauscht werden soll
  ~param j Der zweite Index des Array, der vertauscht werden soll
}
procedure TAbstractSort.Swap(i, j : Integer);
var help      : Integer;                        // Hilfsvariable für den Dreieckstausch
begin
  visualBeforeSwap(i, j);

  // Tausche die Werte im Array
  help                  := Self.sortedArray[i];
  Self.sortedArray[i]   := Self.sortedArray[j];
  Self.sortedArray[j]   := help;
  Inc(Self.swapCount);
  Inc(Self.operationCount, 3); // Dreieckstausch

  visualAfterSwap(i, j);
end;

{
  Diese Methode visualisiert die zu tauschenden Elemente.

  ~param i Der erste Index des Array, der vertauscht werden soll
  ~param j Der zweite Index des Array, der vertauscht werden soll
}
procedure TAbstractSort.visualAfterSwap(i, j : Integer);
begin
  // Zeige Visualisierung an falls nötig
  case Self.formModel.GetSequence of
    AUTO_WITH_ANIMATION: // Zeige bei jedem Schritt das aktuelle Array an
      begin
        UpdateGUI;
        Self.formModel.SetLastSwapsIndex(j, i);
        Sleep(Trunc(1000 / formModel.GetSpeed / 2));
      end;
    SINGLE_STEP_MODE: // Breche nach jeder Vertauschung ab
      begin
        UpdateGUI;
        Self.formModel.SetLastSwapsIndex(j, i);
        if(Self.formModel.IsPrintSteps) then
          Self.formModel.syncViews(PRINTSTEP);
        if(Self.formModel.IsSaveSteps) then
          Self.formModel.syncViews(SAVESTEP);
        Self.formModel.SetSleeping(true);
        Self.Suspend;
        Self.formModel.SetSleeping(false);
      end;
  end;
end;

{
  Diese Methode visualisiert die getauschten Elemente.

  ~param i Der erste Index des Array, der vertauscht werden soll
  ~param j Der zweite Index des Array, der vertauscht werden soll
}
procedure TAbstractSort.visualBeforeSwap(i, j : Integer);
begin
  // Zeige Visualisierung an falls nötig
  case Self.formModel.GetSequence of
    AUTO_WITH_ANIMATION: // Zeige bei jedem Schritt das aktuelle Array an
      begin
        Self.formModel.SetLastSwapsIndex(i, j);
        Sleep(Trunc(1000 / formModel.GetSpeed / 2));
      end;
    SINGLE_STEP_MODE: // Breche nach jeder Vertauschung ab
      begin
        Self.formModel.SetLastSwapsIndex(i, j);
        Sleep(SINGLE_STEP_DELAY);
      end;
  end;
end;


// ************************************************************************
// *     PRIVATE: Ab hier sind alle private-Methoden                      *
// ************************************************************************

{
  Diese Methode wird vor dem eigentlichen Sortieren aufgerufen.
}
procedure TAbstractSort.InitSort;
var startTime : Integer;                        // Startzeit des Sortiervorgangs
    endTime   : Integer;                        // Endzeit des Sortiervorgangs
    i         : Integer;                        // Zählvariable
begin
  try
    try
      Self.formModel.setStarted(true);
      Self.swapCount       := Self.formModel.GetSwapCount;
      Self.comparisonCount := Self.formModel.GetComparisonCount;
      Self.operationCount  := Self.formModel.GetOperationCount;

      // Kopiere unsortiertes Array, damit das neue Array sortiert werden kann
      SetLength(Self.sortedArray, Length(Self.unsortedArray));
      for i := 0 to Length(Self.sortedArray) - 1 do
      begin
        Self.sortedArray[i] := Self.unsortedArray[i];
      end;

      startTime := GetTickCount;
      SortArray;
      endTime := GetTickCount;

      Self.formModel.SetOperationCount(Self.operationCount);
      Self.formModel.SetSwapCount(Self.swapCount);
      Self.formModel.SetComparisonCount(Self.comparisonCount);
      Self.formModel.SetUnsortedArray(Self.sortedArray);
      Self.formModel.SetTime(endTime - startTime);
    except
     on e: Exception do
       begin
         Self.lastException := e;
         Synchronize(ShowErrorMessage);
       end;
     end;
  finally
    begin
      Self.formModel.setStarted(false);
      if(Self.formModel.GetSequence <> SINGLE_STEP_MODE) then
        Self.formModel.SetLastSwapsIndex(-1, -1);
    end;
  end;
end;

{
  Diese Methode zeigt den letzten Fehler an. Die Methode muss synchronisiert aufgerufen werden.
}
procedure TAbstractSort.ShowErrorMessage;
begin
  if(Self.lastException <> nil) then
    showMessage(Self.lastException.ClassName + ': ' + Self.lastException.Message);
end;

{
  Diese Methode aktualisiert das FormModel, damit die GUI nach jedem Schritt auf dem aktuellen Stand ist.
}
procedure TAbstractSort.UpdateGUI;
begin
  Self.formModel.SetUnsortedArray(Self.sortedArray);
  Self.formModel.SetOperationCount(Self.operationCount);
  Self.formModel.SetSwapCount(Self.swapCount);
  Self.formModel.SetComparisonCount(Self.comparisonCount);
end;

end.
