{
  Diese Klasse implementiert den Shaker-Sort Algorithmus und bietet die
  Möglichkeit diesen zu visualisieren.

  ~compiler Delphi 6.0
  ~author Thomas Gattinger
  ~since 11.12.2010
}
unit unitShakerSort;

interface

uses
  // Eigene Klassen
  unitAbstractSort;

type

  TShakerSort = class(TAbstractSort)

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
procedure TShakerSort.SortArray;
var half      : Integer;                        // Hilfsvariable
    size      : Integer;
    i, j      : Integer;                        // Zählvariable

begin
  size := (High(Self.sortedArray) - Low(Self.sortedArray)) + 1;
  half := size div 2;

  for i := 1 to half do
  begin
    if(not Self.formModel.IsStarted) then exit;

    for j := Low(Self.sortedArray) to High(Self.sortedArray) - i do
    begin
      if(not Self.formModel.IsStarted) then exit;

      if Self.sortedArray[j] > Self.sortedArray[j + 1] then
      begin
        Swap(j, j + 1);
      end;
    end;
    for j := High(Self.sortedArray) downto Low(Self.sortedArray) + i do
    begin
      if(not Self.formModel.IsStarted) then exit;

      if Self.sortedArray[j - 1] > Self.sortedArray[j] then
      begin
        Swap(j - 1, j);
      end;
    end;
  end;
end;

end.
