{
  Diese Klasse implementiert den Insertion-Sort Algorithmus und bietet die
  Möglichkeit diesen zu visualisieren.

  ~compiler Delphi 7.0
  ~author Thomas Gattinger
  ~since 13.12.2010
}
unit unitInsertionSort;

interface

uses

  // Eigene Klassen
  unitAbstractSort;

type

  TInsertionSort = class(TAbstractSort)

  protected
    procedure SortArray; override;

  end;

implementation

// ************************************************************************
// *     PROTECTED: Ab hier sind alle protected-Methoden                  *
// ************************************************************************

{
  Diese Methode startet den iterativen Sortiervorgang des unsortierten Arrays.
}
procedure TInsertionSort.SortArray;
var i, j : Integer;                 // Zählvariable
    help : Integer;                 // Hilfsvariable für den Dreieckstausch
begin
  Inc(Self.operationCount);  // Schleifenaufruf
  for i := Low(Self.sortedArray) + 1 to High(Self.sortedArray) do
  begin
    if(not Self.formModel.IsStarted) then exit;

    Inc(Self.comparisonCount);
    Inc(Self.operationCount);  // Vergleichsoperation
    if (Self.sortedArray[i] < Self.sortedArray[i - 1]) then
    begin
      visualBeforeSwap(i, -1);

      help := Self.sortedArray[i];
      j := i;
      Inc(Self.operationCount, 3);  // 2 Zuweisungen, Schleifenaufruf
      while ((j > Low(Self.sortedArray)) and (Self.sortedArray[j - 1] > help)) do
      begin
        if(not Self.formModel.IsStarted) then exit;

        Self.sortedArray[j] := Self.sortedArray[j - 1];
        Dec(j);
        Inc(Self.operationCount, 2);  // Zuweisungen, dec
      end;
      Self.sortedArray[j] := help;
      Inc(Self.swapCount);
      Inc(Self.operationCount);  // Zuweisungen

      visualAfterSwap(i, j);
    end;
  end;
end;

end.
 