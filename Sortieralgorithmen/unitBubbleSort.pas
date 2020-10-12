{
  Diese Klasse implementiert den Bubble-Sort Algorithmus und bietet die
  Möglichkeit diesen zu visualisieren.

  ~compiler Delphi 7.0
  ~author Thomas Gattinger
  ~since 10.11.2010
}
unit unitBubbleSort;

interface

uses

  // Eigene Klassen
  unitAbstractSort;

type

  TBubbleSort = class(TAbstractSort)

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
procedure TBubbleSort.SortArray;
var flipped   : Boolean;        // Gibt an, ob bei einem Durchlauf
                                // Elemente vertauscht wurden
    i         : Integer;        // Zählvariable
begin
  Inc(Self.operationCount);  // Schleifenaufruf
  repeat
    flipped := false;
    Inc(Self.operationCount, 2);  // flipped + until(...)
    for i := 0 to Length(Self.sortedArray) - 2 do
    begin
      Inc(Self.comparisonCount);
      Inc(Self.operationCount);  // Vergleichsoperation
      if(Self.sortedArray[i] > Self.sortedArray[i+1]) then
      begin
        if(not Self.formModel.IsStarted) then exit;
        Inc(Self.operationCount, 2);  // flipped + Methodenaufruf
        flipped := true;
        Swap(i, i+1);
      end;
    end;
  until(not flipped or not Self.formModel.IsStarted);
end;

end.
