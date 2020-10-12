unit unitElement;

interface

type
  {
    Anmerkung: Da die Bezeichner Element und TElement fest vorgegeben waren,
    habe ich diese auch so belassen.
    Korrekt wäre allerdings statt Element den Bezeichner TElement zu nennen,
    da ein neuer Typ definiert wird und statt TElement den Bezeichner
    PElement, da ein Pointer auf einen Typ definiert wird.
  }

  TElement = ^Element;
                                             // Dieser Typ stellt einen Knoten,
                                             // bzw. ein Blatt des Baumes dar
  Element = record
    Data   : Integer;                        // Datenwert des Elements
    XCoord : Integer;                        // Faktor für die x-Achse
    YCoord : Integer;                        // Faktor für die y-Achse
    LS     : TElement;                       // Zeiger auf den linken Sohn
    RS     : TElement;                       // Zeiger auf den rechten Sohn

    // Diese Zeile einkommentieren, um den Speicherverbrauch zu testen.
    // VORSICHT: Der Speicher wird sehr schnell voll... ;-)
    //
    memTest : Array[0..100] of Array[0..100] of Array[0..100] of String;
  end;

implementation

end.
