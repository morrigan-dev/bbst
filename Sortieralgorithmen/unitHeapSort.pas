{
  Diese Klasse implementiert den Heap-Sort Algorithmus und bietet die
  Möglichkeit diesen zu visualisieren.

  ~compiler Delphi 7.0
  ~author Thomas Gattinger
  ~since 13.12.2010
}
unit unitHeapSort;

interface

uses

  // Eigene Klassen
  unitAbstractSort;

type

  THeapSort = class(TAbstractSort)

  protected
    procedure SortArray; override;

  end;

implementation

// ************************************************************************
// *     PROTECTED: Ab hier sind alle protected-Methoden                  *
// ************************************************************************

{
  Diese Methode startet den Sortiervorgang des unsortierten Arrays.
}
procedure THeapSort.SortArray;
  procedure SiftDown(Current, MaxIndex: Integer);
  var
    Left, Right, Largest: Integer;
  begin
    Inc(Self.operationCount, 6);  // 3 x Zuweisung, 3 x Vergleichsoperation
    Left := Low(Self.sortedArray) + (2 * (Current - Low(Self.sortedArray))) + 1;
    Right := Low(Self.sortedArray) + (2 * (Current - Low(Self.sortedArray))) + 2;
    Largest := Current;
    Inc(Self.comparisonCount, 5);  // 5 x Vergleichsoperation
    if (Left <= MaxIndex) and (Self.sortedArray[Left] > Self.sortedArray[Largest]) then
    begin
      Inc(Self.operationCount);  // Zuweisung
      Largest := Left;
    end;
    if (Right <= MaxIndex) and (Self.sortedArray[Right] > Self.sortedArray[Largest]) then
    begin
      Inc(Self.operationCount);  // Zuweisung
      Largest := Right;
    end;
    if (Largest <> Current) then
    begin
      Inc(Self.operationCount, 2);  // 2 x Methodenaufrufe
      Swap(Current, Largest);
      SiftDown(Largest, MaxIndex);
    end;
  end;

  procedure Heapify();
  var
    Middle: Integer;
    i: Integer;
  begin
    Inc(Self.operationCount, 2);  // Zuweisung, Schleifenaufruf
    Middle := ((Low(Self.sortedArray) + High(Self.sortedArray) + 1) div 2) - 1;
    for i := Middle downto Low(Self.sortedArray) do // Nur die Knoten, die Söhne haben!
    begin
      Inc(Self.operationCount);  // Methodenaufrufe
      SiftDown(i, High(Self.sortedArray));
    end;
  end;

var
  i: Integer;
begin
  Inc(Self.operationCount, 2);  // Methodenaufruf, Schleifenaufruf
  Heapify();
  for i := High(Self.sortedArray) downto Low(Self.sortedArray) + 1 do
  begin
    Inc(Self.operationCount, 2);  // 2 x Methodenaufrufe
    Swap(i, Low(Self.sortedArray));
    SiftDown(Low(Self.sortedArray), i - 1);
  end;
end;

end.
