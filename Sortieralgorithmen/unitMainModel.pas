unit unitMainModel;

interface

uses
  // Delphi Klassen
  Dialogs, SysUtils, Classes,

  // Eigene Klassen
  unitObserverableImpl, unitTypes;

type
  TMainModel = class(TObserverableImpl)
  private
    algorithm            : TAlgorithm;            // Ausgewähltes Sortierverfahren
    comparisonCount      : Integer;               // Anzahl der Vergleiche
    constructionSequence : TConstructionSequence; // Art des Listenaufbaus
    elementCount         : Integer;               // Anzahl der Elemente in de Liste
    lastSwap1Index       : Integer;               // Erster Index im Array der zu tauschenden Elemente
    lastSwap2Index       : Integer;               // Zweiter Index im Array der zu tauschenden Elemente
    operationCount       : Integer;               // Anzahl der Operationen
    originalArray        : TDynIntArray;          // Original Array dass unverändert bleibt
    printerName          : String;                // Name des ausgewählten Druckers
    printSteps           : Boolean;               // Flag, dass angibt, ob nach jedem Schritt gedruckt wird
    saveSteps            : Boolean;               // Flag, dass angibt, ob nach jedem Schritt gespeichert wird
    sequence             : TSequence;             // Art der Animation
    sleeping             : Boolean;               // Flag, dass angibt, ob gerade ein Sortier-Thread schläft
    speed                : Integer;               // Schritte pro Sekunde, die ein Sortier-Thread laufen soll
    started              : Boolean;               // Flag, dass angibt, ob ein Sortier-Thread gestartet wurde
    swapCount            : Integer;               // Anzahl der Vertauschungen
    time                 : Integer;               // Benötigte Zeit des Sortier-Threads
    unsortedArray        : TDynIntArray;          // Ein Array mit Integer-Werten, die sotiert werden

  public
    constructor Create;
    destructor Destroy; override;

    procedure CreateNewList;
    procedure LoadOriginalArray;
    procedure LoadUnsortedArray(filename : String);
    procedure SaveUnsortedArray(filename : String);

    function GetAlgorithm            : TAlgorithm;
    function GetComparisonCount      : Integer;
    function GetConstructionSequence : TConstructionSequence;
    function GetElementCount         : Integer;
    function GetLastSwap1Index       : Integer;
    function GetLastSwap2Index       : Integer;
    function GetOperationCount       : Integer;
    function GetOriginalArray        : TDynIntArray;
    function GetPrinterName          : String;
    function GetSequence             : TSequence;
    function GetSpeed                : Integer;
    function GetSwapCount            : Integer;
    function GetTime                 : Integer;
    function GetUnsortedArray        : TDynIntArray;
    function IsPrintSteps            : Boolean;
    function IsSaveSteps             : Boolean;
    function IsSleeping              : Boolean;
    function IsStarted               : Boolean;

    procedure SetAlgorithm(algorithm : TAlgorithm);
    procedure SetComparisonCount(comparisonCount : Integer);
    procedure SetConstructionSequence(constructionSequence : TConstructionSequence);
    procedure SetElementCount(elementCount : Integer);
    procedure SetLastSwapsIndex(lastSwap1Index, lastSwap2Index : Integer);
    procedure SetOperationCount(operationCount : Integer);
    procedure SetPrinterName(printerName : String);
    procedure SetPrintSteps(printSteps : Boolean);
    procedure SetSaveSteps(saveSteps : Boolean);
    procedure SetSequence(sequence : TSequence);
    procedure SetSleeping(sleeping : Boolean);
    procedure SetSpeed(speed : Integer);
    procedure SetStarted(started : Boolean);
    procedure SetSwapCount(swapCount : Integer);
    procedure SetTime(time : Integer);
    procedure SetUnsortedArray(unsortedArray : TDynIntArray);

  end;

implementation


// ************************************************************************
// *     PUBLIC: Ab hier sind alle public-Methoden                        *
// ************************************************************************

{
  Dieser Konstruktor erzeugt eine Instanz dieser Klasse und initialisiert alle
  Klassenvariablen.
}
constructor TMainModel.Create;
begin
  inherited Create;

  Randomize;

  Self.algorithm            := DIRECT_SWAP;
  Self.comparisonCount      := 0;
  Self.constructionSequence := RANDOM;
  Self.elementCount         := 20;
  Self.lastSwap1Index       := -1;
  Self.lastSwap2Index       := -1;
  Self.operationCount       := 0;
  Self.printSteps           := false;
  Self.saveSteps            := false;
  Self.sequence             := AUTO_WITH_ANIMATION;
  Self.speed                := 1;
  Self.started              := false;
  Self.swapCount            := 0;
  Self.time                 := 0;
end;

{
  Diese Methode erzeugt eine neue unsortierte Liste anhand der Einstellungen
  der Aufbaufolge.
}
procedure TMainModel.CreateNewList;
var i           : Integer; // Zählvariable
    randomValue : Integer; // Zufallszahl
begin
  SetLength(Self.originalArray, Self.elementCount);
  SetLength(Self.unsortedArray, Self.elementCount);

  case Self.constructionSequence of
    RANDOM: // Erzeuge ein neues unsortiertes Array mit zufälligen Werten
      begin
        for i := 0 to Self.elementCount - 1 do
        begin
          randomValue := System.Random(Self.elementCount) + 1;
          Self.originalArray[i] := randomValue;
          Self.unsortedArray[i] := randomValue;
        end;
      end;
    ASC: // Erzeuge ein neues Array mit aufsteigender Sortierung
      begin
        for i := 0 to Self.elementCount - 1 do
        begin
          Self.originalArray[i] := i + 1;
          Self.unsortedArray[i] := i + 1;
        end;
      end;
    DESC: // Erzeuge ein neues Array mit absteigender Sortierung
      begin
        for i := 0 to Self.elementCount - 1 do
        begin
          Self.originalArray[i] := Self.elementCount - i;
          Self.unsortedArray[i] := Self.elementCount - i;
        end;
      end;
    START_ERROR: // Erzeuge ein neues Array mit aufsteigender Sortierung bei
                 // dem der Anfang nicht sortiert ist.
      begin
        Self.originalArray[0] := Self.elementCount;
        Self.unsortedArray[0] := Self.elementCount;
        for i := 1 to Self.elementCount - 1 do
        begin
          Self.originalArray[i] := i;
          Self.unsortedArray[i] := i;
        end;
      end;
    END_ERROR: // Erzeuge ein neues Array mit absteigender Sortierung bei
               // dem das Ende nicht sortiert ist.
      begin
        for i := 0 to Self.elementCount - 2 do
        begin
          Self.originalArray[i] := i + 2;
          Self.unsortedArray[i] := i + 2;
        end;
        Self.originalArray[Self.elementCount - 1] := 1;
        Self.unsortedArray[Self.elementCount - 1] := 1;
      end;
    EQUAL_NUMBERS: // Erzeuge ein neues Array, bei dem alle Zahlen gleich sind
      begin
        randomValue := System.Random(Self.elementCount) + 1;
        for i := 0 to Self.elementCount - 1 do
        begin
          Self.originalArray[i] := randomValue;
          Self.unsortedArray[i] := randomValue;
        end;
      end;
  end;

  Self.lastSwap1Index := -1;
  Self.lastSwap2Index := -1;

  if(not hasChanged) then
    syncViews(VALUE_TABLE);
end;

{
  Dieser Destruktor gibt die Instanz dieser Klasse wieder frei.
}
destructor TMainModel.Destroy;
begin
  inherited Destroy;
end;

{
  Diese Methode überschreibt alle Werte der unsortierten Liste mit den Werten
  der original Liste und stellt somit die original Liste wieder her.
}
procedure TMainModel.LoadOriginalArray;
var i : Integer;  // Zählvariable
begin
  for i := 0 to Self.elementCount - 1 do
  begin
    Self.unsortedArray[i] := Self.originalArray[i];
  end;

  Self.lastSwap1Index := -1;
  Self.lastSwap2Index := -1;

  if(not hasChanged) then
    syncViews(VALUE_TABLE);
end;

{
  Diese Methode lädt die aktuelle unsortierte Liste aus einer Textdatei.
}
procedure TMainModel.LoadUnsortedArray(filename : String);
var fileStream : TFileStream; // Datei die als Stream eingeladen wird
    i          : Integer;     // Zählvariable
begin
  fileStream := TFileStream.Create(filename, fmOpenRead);
  try
    // Lade Anzahl der Elemente in der Liste
    fileStream.ReadBuffer(Self.elementCount, SizeOf(Integer));
    // Lade Aufbaufolge der Liste
    fileStream.ReadBuffer(Self.constructionSequence, SizeOf(TConstructionSequence));
    // Array-Länge setzen
    SetLength(Self.unsortedArray, Self.elementCount);
    // Record-Daten aus Stream lesen
    for i := 0 to Self.elementCount - 1 do
      fileStream.ReadBuffer(Self.unsortedArray[i], SizeOf(Integer));
  finally
    fileStream.Free;
  end;

  if(not hasChanged) then
  begin
    syncViews(VALUE_TABLE);
    syncViews(LIST_CONSTRUCTION);
  end;
end;

{
  Diese Methode speichert die aktuelle unsortierte Liste in eine Textdatei.

  ~param filename Der Dateiname in die das Array gespeichert wird
}
procedure TMainModel.SaveUnsortedArray(filename : String);
var fileStream : TFileStream; // Filestream zum Speichern des Arrays
    i          : Integer;     // Zählvariable
begin
  fileStream := TFileStream.Create(filename, fmCreate);
  try
    // Schreibe Anzahl der Elemente in der Liste
    fileStream.WriteBuffer(Self.elementCount, SizeOf(Integer));
    // Schreibe Aufbaufolge der Liste
    fileStream.WriteBuffer(Self.constructionSequence, SizeOf(TConstructionSequence));
    // Schreibe die Liste
    for i := 0 to Self.elementCount - 1 do
      fileStream.WriteBuffer(Self.unsortedArray[i], SizeOf(Integer));
  finally
    fileStream.Free;
  end;
end;


// ************************************************************************
// *     GETTER: Ab hier sind alle Getter-Methoden                        *
// ************************************************************************

function TMainModel.GetAlgorithm : TAlgorithm;
begin
  Result := Self.algorithm;
end;

function TMainModel.GetComparisonCount : Integer;
begin
  Result := Self.comparisonCount;
end;

function TMainModel.GetConstructionSequence : TConstructionSequence;
begin
  Result := Self.constructionSequence;
end;

function TMainModel.GetElementCount : Integer;
begin
  Result := Self.elementCount;
end;

function TMainModel.GetLastSwap1Index : Integer;
begin
  Result := Self.lastSwap1Index;
end;

function TMainModel.GetLastSwap2Index : Integer;
begin
  Result := Self.lastSwap2Index;
end;

function TMainModel.GetOperationCount : Integer;
begin
  Result := Self.operationCount;
end;

function TMainModel.GetOriginalArray : TDynIntArray;
begin
  Result := Self.originalArray;
end;

function TMainModel.GetPrinterName : String;
begin
  Result := Self.printerName;
end;

function TMainModel.GetSequence : TSequence;
begin
  Result := Self.sequence;
end;

function TMainModel.GetSpeed : Integer;
begin
  Result := Self.speed;
end;

function TMainModel.GetSwapCount : Integer;
begin
  Result := Self.swapCount;
end;

function TMainModel.GetTime : Integer;
begin
  Result := Self.time;
end;

function TMainModel.GetUnsortedArray : TDynIntArray;
begin
  Result := Self.unsortedArray;
end;

function TMainModel.IsPrintSteps : Boolean;
begin
  Result := Self.printSteps;
end;

function TMainModel.IsSaveSteps : Boolean;
begin
  Result := Self.saveSteps;
end;

function TMainModel.IsSleeping : Boolean;
begin
  Result := Self.sleeping;
end;

function TMainModel.IsStarted : Boolean;
begin
  Result := Self.started;
end;


// ************************************************************************
// *     SETTER: Ab hier sind alle Setter-Methoden                        *
// ************************************************************************

{
  Diese Methode setzt den zu verwendenden Sortieralgorithmus.
}
procedure TMainModel.SetAlgorithm(algorithm : TAlgorithm);
begin
  if(Self.algorithm <> algorithm) and (not hasChanged) then
  begin
    Self.algorithm := algorithm;
    syncViews(SORT_ALGO);

    Self.operationCount  := 0;
    Self.comparisonCount := 0;
    Self.swapCount       := 0;
    Self.time            := 0;
    syncViews(ANALYSIS);
  end;
end;

{
  Diese Methode setzt die Anzahl der benötigten Vergleiche.
}
procedure TMainModel.SetComparisonCount(comparisonCount : Integer);
begin
  if(Self.comparisonCount <> comparisonCount) and (not hasChanged) then
  begin
    Self.comparisonCount := comparisonCount;
    syncViews(ANALYSIS);
  end;
end;

{
  Diese Methode setzt die zu verwendende Aufbaufolge.
}
procedure TMainModel.SetConstructionSequence(constructionSequence : TConstructionSequence);
begin
  if(Self.constructionSequence <> constructionSequence) and (not hasChanged) then
  begin
    Self.constructionSequence := constructionSequence;
    syncViews(LIST_CONSTRUCTION);
  end;
end;

{
  Diese Methode setzt die Anzahl der Elemente in einer automatisch generierten Liste.
}
procedure TMainModel.SetElementCount(elementCount : Integer);
begin
  if(Self.elementCount <> elementCount) and (not hasChanged) then
  begin
    if(elementCount < 1) then
      elementCount := 1;
    Self.elementCount := elementCount;
    syncViews(LIST_CONSTRUCTION);
  end;
end;

{
  Diese Methode setzt die Indizies der Zahlen, die zuletzt vertauscht wurden.
}
procedure TMainModel.SetLastSwapsIndex(lastSwap1Index, lastSwap2Index : Integer);
begin
  if(Self.lastSwap1Index <> lastSwap1Index)
    and (Self.lastSwap2Index <> lastSwap2Index)
    and (not hasChanged) then
  begin
    Self.lastSwap1Index := lastSwap1Index;
    Self.lastSwap2Index := lastSwap2Index;
    syncViews(VALUE_TABLE);
  end;
end;

{
  Diese Methode setzt die Anzahl der benötigten Operationen.
}
procedure TMainModel.SetOperationCount(operationCount : Integer);
begin
  if(Self.operationCount <> operationCount) and (not hasChanged) then
  begin
    Self.operationCount := operationCount;
    syncViews(ANALYSIS);
  end;
end;

{
  Diese Methode setzt den Namen des zu benutzenden Druckers.
}
procedure TMainModel.SetPrinterName(printerName : String);
begin
  Self.printerName := printerName;
end;

{
  Diese Methode setzt, ob die Sortierschritte ausgedruckt werden sollen.
}
procedure TMainModel.SetPrintSteps(printSteps : Boolean);
begin
  if(Self.printSteps <> printSteps) and (not hasChanged) then
  begin
    Self.printSteps := printSteps;
    syncViews(SORT_ALGO);
  end;
end;

{
  Diese Methode setzt, ob die Sortierschritte gespeichert werden sollen.
}
procedure TMainModel.SetSaveSteps(saveSteps : Boolean);
begin
  if(Self.saveSteps <> saveSteps) and (not hasChanged) then
  begin
    Self.saveSteps := saveSteps;
    syncViews(SORT_ALGO);
  end;
end;

{
  Diese Methode setzt die Art der Abfolge, die beim Sortieren verwendet werden soll.
}
procedure TMainModel.SetSequence(sequence : TSequence);
begin
  if(Self.sequence <> sequence) and (not hasChanged) then
  begin
    Self.sequence := sequence;
    syncViews(SORT_ALGO);
  end;
end;

{
  Diese Methode setzt den Pausemodus. Der Aktuell laufende Thread geht schlafen.
}
procedure TMainModel.SetSleeping(sleeping : Boolean);
begin
  // Hier keine Prüfung auf hasChanged, da das Flag direkt gesetzt werden muss, auch wenn die GUI sich noch aktualisiert
  if(Self.sleeping <> sleeping) then
  begin
    Self.sleeping := sleeping;
    syncViews(SORT_ALGO);
  end;
end;

{
  Diese Methode setzt die Geschwindigkeit. Angegeben werden die Schritte pro Sekunde.
}
procedure TMainModel.SetSpeed(speed : Integer);
begin
  if(Self.speed <> speed) and (not hasChanged) then
  begin
    Self.speed := speed;
    syncViews(SORT_ALGO);
  end;
end;

{
  Diese Methode setzt ein Flag, welches angibt, ob ein Sortieralgorithmus aktuell aktiv ist.
}
procedure TMainModel.SetStarted(started : Boolean);
begin
  // Hier keine Prüfung auf hasChanged, da das Flag direkt gesetzt werden muss, auch wenn die GUI sich noch aktualisiert
  if(Self.started <> started) then
  begin
    Self.started := started;
    syncViews(SORT_ALGO);
  end;
end;

{
  Diese Methode setzt die Anzahl der Vertauschungen.
}
procedure TMainModel.SetSwapCount(swapCount : Integer);
begin
  if(Self.swapCount <> swapCount) and (not hasChanged) then
  begin
    Self.swapCount := swapCount;
    syncViews(ANALYSIS);
  end;
end;

{
  Diese Methode setzt die benötigte Zeit.
}
procedure TMainModel.SetTime(time : Integer);
begin
  if(Self.time <> time) and (not hasChanged) then
  begin
    Self.time := time;
    syncViews(ANALYSIS);
  end;
end;

{
  Diese Methode setzt ein unsortierte Array.
}
procedure TMainModel.SetUnsortedArray(unsortedArray : TDynIntArray);
var i    : Integer; // Zählvariable
    size : Integer; // Größe des Arrays

begin
  if(not hasChanged) then
  begin
    size := Length(unsortedArray);
    SetLength(Self.unsortedArray, size);
    for i := 0 to size - 1 do
    begin
      Self.unsortedArray[i] := unsortedArray[i];
    end;
    syncViews(VALUE_TABLE);
  end;
end;

end.
