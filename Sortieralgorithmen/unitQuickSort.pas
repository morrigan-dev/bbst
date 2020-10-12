{
  Diese Klasse implementiert den Quick-Sort Algorithmus und bietet die
  Möglichkeit diesen zu visualisieren.

  ~compiler Delphi 7.0
  ~author Thomas Gattinger
  ~since 10.11.2010
}
unit unitQuickSort;

interface

uses

  // Eigene Klassen
  unitAbstractSort;

type

  TQuickSort = class(TAbstractSort)

  protected
    procedure SortArray; override;

  private
    procedure SortQuickSort(LoIndex, HiIndex: Integer);

  end;

implementation


// ************************************************************************
// *     PROTECTED: Ab hier sind alle protected-Methoden                  *
// ************************************************************************

procedure TQuickSort.SortArray;
begin
  Inc(Self.operationCount); // Methodenaufruf
  SortQuickSort(Low(Self.unsortedArray), High(Self.unsortedArray));
end;


// ************************************************************************
// *     PRIVATE: Ab hier sind alle private-Methoden                      *
// ************************************************************************

{
  Diese Methode startet den rekursiven Sortiervorgang des unsortierten Arrays.
}
procedure TQuickSort.SortQuickSort(LoIndex, HiIndex: Integer);
var Lo, Hi    : Integer;
    Pivot     : Integer;
begin
  if(not Self.formModel.IsStarted) then exit;

  // Wähle stets das mittlere Element als Pivotelement.
  Pivot := Self.sortedArray[(LoIndex + HiIndex) div 2];

  // Stelle die Ordnung bzgl. des Pivotelements her.
  Lo := LoIndex;
  Hi := HiIndex;

  Inc(Self.operationCount, 4);  // pivot, lo, hi, Schleifenaufruf

  repeat
    Inc(Self.comparisonCount, 4);  // 2 while Vergleiche, if-then, until Vergleich
    while Self.sortedArray[Lo] < Pivot do
    begin
      Inc(Lo);
      Inc(Self.operationCount);  // inc
    end;
    while Self.sortedArray[Hi] > Pivot do
    begin
      Dec(Hi);
      Inc(Self.operationCount);  // dec
    end;
    if Lo <= Hi then
    begin
      if(not Self.formModel.IsStarted) then exit;

      Swap(Lo, Hi);
      Inc(Lo);
      Dec(Hi);
      Inc(Self.operationCount, 3);  // swap, inc, dec
    end;
  until Lo > Hi;

  // Gegebenenfalls linke Teilliste sortieren.
  if LoIndex < Hi then SortQuickSort(LoIndex, Hi);

  // Gegebenenfalls rechte Teilliste sortieren.
  if Lo < HiIndex then SortQuickSort(Lo, HiIndex);

  Inc(Self.operationCount, 2);  // 2 Vergleiche mit evtl. Rekursivaufruf
end;

end.
 