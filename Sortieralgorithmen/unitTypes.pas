{
  In dieser Klasse sind alle Typen definiert, die f�r die Sortieralgorithmen
  ben�tigt werden.

  ~compiler Delphi 7
  ~author Thomas Gattinger
}
unit unitTypes;

interface

type

  // Dieser Typ wird f�r das zu sortierende Array verwendet
  TDynIntArray = Array of Integer;

  // Diese Enumeration beinhaltet alle w�hlbaren Aufbaufolgen
  TConstructionSequence = (RANDOM, ASC, DESC, START_ERROR, END_ERROR, EQUAL_NUMBERS);

  // Diese Enumeration beinhaltet alle w�hlbaren Sortieralgorithmen
  TAlgorithm = (DIRECT_SWAP, DIRECT_INSERT, BUBBLESORT, QUICKSORT, SHAKERSORT, HEAPSORT);

  // Diese Enumeration beinhaltet alle w�hlbaren Abfolgen
  TSequence = (AUTO_WITHOUT_ANIMATION, AUTO_WITH_ANIMATION, SINGLE_STEP_MODE);

  // Diese Enumeration beinhaltet die unterschiedlichen Bereiche, die
  // in der GUI getrennt voneinander aktualisiert werden k�nnen.
  TUpdate = (VALUE_TABLE, LIST_CONSTRUCTION, SORT_ALGO, ANALYSIS, PRINTSTEP, SAVESTEP);

  const
    DATA_PATH = 'data\';       // Unterpfad /data
    FILES_PATH = 'files\';     // Unterpfad /files
    SINGLE_STEP_DELAY = 500;   // Delay f�r den Einzelschritt Modus bei der Visualisierung

implementation

end.


