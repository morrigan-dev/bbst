{
  Diese Klasse implementiert den Selection-Sort Algorithmus und bietet die
  Möglichkeit diesen zu visualisieren.

  ~compiler Delphi 6.0
  ~author Thomas Gattinger
  ~since 11.12.2010
}
unit unitSelectionSort;

interface

uses

  // Eigene Klassen
  unitAbstractSort;

type

  TSelectionSort = class(TAbstractSort)

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
procedure TSelectionSort.SortArray;
var i, j : Integer;                        // Zählvariable
begin
  (* Nach dem ersten Durchgang ist Low(sortedArray) der Index des kleinsten Elements.
     An die i-te Position wird nach und nach das kleinste Element (Minimum)
     des unsortierten Rests geswappt. *)

  Inc(Self.operationCount);  // Schleifenaufruf
  for i := Low(Self.sortedArray) to High(Self.sortedArray) - 1 do
  begin
    Inc(Self.operationCount);  // Schleifenaufruf
    for j := i + 1 to High(Self.sortedArray) do            // der unsortierte Rest
    begin
      if(not Self.formModel.IsStarted) then exit;

      Inc(Self.comparisonCount);
      Inc(Self.operationCount);  // Vergleichsoperation
      if Self.sortedArray[i] > Self.sortedArray[j] then
      begin
        Swap(i, j);

        Inc(Self.operationCount);  // Methodenaufruf
      end;
    end;
  end;
end;

end.
