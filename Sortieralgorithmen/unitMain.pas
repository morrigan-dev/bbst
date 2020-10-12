{
  Dieses Programm ist Teil eines Schulprojekts der Carl-Benz Schule Koblenz.
  Diese Klasse erstellt die GUI der Anwendung und reagiert auf Benutzeraktionen.

  Folgende Funktionalitäten sind in dieser Version realisiert:
    - Erstellung einer Liste von n Zahlen die
      -> zufällig
      -> aufsteigend
      -> absteigend
      -> aufsteigend mit Anfangsfehler
      -> aufsteigend mit Endfehler
      -> gleiche Zahlen
      vorsortiert sein können.
    - Eine Liste von Zahlen aus einer Textdatei laden
    - Eine Liste von Zahlen in eine Textdatei speichern
    - Folgende Sortierverfahren stehen zur Verfügung:
      -> direktes Austauschen (Selection-Sort)
      -> direktes Einfügen (Insertion-Sort)
      -> Bubble-Sort
      -> Quick-Sort
      -> Shaker-Sort
      -> Heap-Sort
    - Ablauf des Sortierens (auto mit Animation, auto ohne Animation, Einzelschritt)
    - Sortierschritte können gedruckt oder gespeichert werden
    - Die Sortiergeschwindigkeit kann engestellt werden
    - Ausgabe einer Auswertung (Anzahl Operationen, Vertauschungen, Vergleiche, benötigte Zeit)


  Anmerkungen des Autors:
  =======================

  Sortieralgorithmen:
  Die Grundgerüste aller Algorithmen stammen von Stefan Baur (http://www.stefan-baur.de/cs.algo.sort.html)
  Die Verfahren wurden jedoch von mir an die benötigten Zwecke dieses Tools angepasst bzw. erweitert.
  Das Wissen über den Aufbau von Threads in Delphi stammt aus dem wikibook:
  http://de.wikibooks.org/wiki/Programmierkurs:_Delphi:_Pascal:_Threads

  Sprachdatei:
  Bei den Bezeichnungen setze ich auf eine Sprachdatei, die über ein TStringList Objekt
  eingeladen wird. Jeder Eintrag der Sprachdatei besteht aus einem Key und einem Wert
  getrennt mit einem '='. In der Anwendung kann über den Key der entsprechende Wert
  abgerufen werden.

  Kommentare:
  Die Syntax der Kommentar entspricht der JADD (Just Another DelphiDoc)
  Konvention. Dies ist ein Tool, mit dem Delphi Code und die Kommentare
  automatisch in eine API Dokumentation überführt werden können. Es lehnt sich
  an das JavaDoc aus der Java Welt an.

  Observer-Pattern:
  Da dieses Programm sehr viele Daten vom Nutzer über die GUI entgegen nimmt und die GUI nach
  der Sortierung aktualisiert werden muss, wird hier das Observer-Pattern verwendet.
  Dieses Pattern ermöglicht ein saubere Trennung von GUI und Logik und ermöglicht die Datenübergabe
  an andere Klassen mittels eines gekapselten Objekts.

  ~compiler Delphi 6.0
  ~author Thomas Gattinger
  ~since 10.11.2010
}
unit unitMain;

interface

uses
  // Delphi Klassen
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Printers, pngimage,

  // Eigene Klassen
  unitTypes, unitResourceManager, unitIObserver, unitMainModel,
  unitBubbleSort, unitQuickSort, unitSelectionSort,
  unitInsertionSort, unitShakerSort, unitHeapSort, unitInfoBox;

type
  TfrmSortAlgo = class(TForm, IObserver)
    btnCreateList          : TButton;
    btnEnd                 : TButton;
    btnLoadOriginList      : TButton;
    btnOpenList            : TButton;
    btnSaveList            : TButton;
    btnStart               : TButton;
    btnStop                : TButton;

    chbPrintSteps          : TCheckBox;
    chbSaveSteps           : TCheckBox;

    edtComparisonCount     : TEdit;
    edtOperationCount      : TEdit;
    edtSwapCount           : TEdit;
    edtTime                : TEdit;

    gbxAlgo                : TGroupBox;
    gbxAnalysis            : TGroupBox;
    gbxConstructSequence   : TGroupBox;
    gbxListConstruction    : TGroupBox;
    gbxSequence            : TGroupBox;
    gbxSortAlgo            : TGroupBox;
    gbxValueTable          : TGroupBox;

    lblComparisonCount     : TLabel;
    lblElementCount        : TLabel;
    lblOperationCount      : TLabel;
    lblSwapCount           : TLabel;
    lblSpeed               : TLabel;
    lblTime                : TLabel;

    lbxValueTable          : TListBox;

    pnlConfig              : TPanel;
    pnlElementCount        : TPanel;

    rbAsc                  : TRadioButton;
    rbAuto                 : TRadioButton;
    rbAutoAnimation        : TRadioButton;
    rbBubbleSort           : TRadioButton;
    rbDesc                 : TRadioButton;
    rbEndError             : TRadioButton;
    rbEqualNumbers         : TRadioButton;
    rbHeapSort             : TRadioButton;
    rbInsertion            : TRadioButton;
    rbQuickSort            : TRadioButton;
    rbRandom               : TRadioButton;
    rbShakerSort           : TRadioButton;
    rbStartError           : TRadioButton;
    rbSingleSteps          : TRadioButton;
    rbSwap                 : TRadioButton;

    sedElementCount        : TSpinEdit;
    sedSpeed               : TSpinEdit;

    PrintDialog            : TPrintDialog;
    OpenDialog             : TOpenDialog;
    SaveDialog             : TSaveDialog;
    imgSignatur: TImage;
    imgSignaturBlau: TImage;

    procedure btnEndClick(Sender: TObject);
    procedure chbPrintStepsClick(Sender: TObject);
    procedure chbSaveStepsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbxValueTableDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure rbAscClick(Sender: TObject);
    procedure rbAutoAnimationClick(Sender: TObject);
    procedure rbAutoClick(Sender: TObject);
    procedure rbBubbleSortClick(Sender: TObject);
    procedure rbDescClick(Sender: TObject);
    procedure rbEndErrorClick(Sender: TObject);
    procedure rbEqualNumbersClick(Sender: TObject);
    procedure rbHeapSortClick(Sender: TObject);
    procedure rbInsertionClick(Sender: TObject);
    procedure rbQuickSortClick(Sender: TObject);
    procedure rbRandomClick(Sender: TObject);
    procedure rbShakerSortClick(Sender: TObject);
    procedure rbSingleStepsClick(Sender: TObject);
    procedure rbStartErrorClick(Sender: TObject);
    procedure rbSwapClick(Sender: TObject);
    procedure sedElementCountExit(Sender: TObject);
    procedure sedSpeedExit(Sender: TObject);
    procedure btnCreateListClick(Sender: TObject);
    procedure btnLoadOriginListClick(Sender: TObject);
    procedure btnSaveListClick(Sender: TObject);
    procedure btnOpenListClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure imgSignaturMouseEnter(Sender: TObject);
    procedure imgSignaturBlauMouseLeave(Sender: TObject);
    procedure imgSignaturBlauClick(Sender: TObject);

  private
    { Private declarations }
    formModel        : TMainModel;
    resourceManager  : TResourceManager;

    selectionSort    : TSelectionSort;
    insertionSort    : TInsertionSort;
    bubbleSort       : TBubbleSort;
    quickSort        : TQuickSort;
    shakerSort       : TShakerSort;
    heapSort         : THeapSort;

    procedure initLabels;
    procedure resetAllThreads;

  public
    { Public declarations }
    procedure updateView(update : TUpdate);

  end;

var
  frmSortAlgo: TfrmSortAlgo;

implementation

{$R *.dfm}

// ************************************************************************
// *     PUBLIC: Ab hier sind alle public-Methoden                        *
// ************************************************************************

{
  Diese Methode synchronisiert die GUI Elemente mittels der Daten aus dem Model.

  ~param update Updateflag, dass angibt welcher Bereich in der GUI aktualisiert
         werden soll.
}
procedure TfrmSortAlgo.updateView(update : TUpdate);
var integerList : TDynIntArray; // Array mit Integerwerten die sortiert werden
    i           : Integer;      // Zählvariable
    PrintText   : TextFile;     // Ausgabedatei für den Drucker
begin
  // Aktualisiere Tabelle
  if(update = VALUE_TABLE) then
  begin
    //showmessage('update');
    integerList := Self.formModel.GetUnsortedArray;
    lbxValueTable.Clear;
    for i := 0 to Length(integerList) - 1 do
    begin
      lbxValueTable.Items.Add(IntToStr(integerList[i]));
    end;
    // Scrolle bis zum ersten Highlighting
    if(Self.formModel.GetLastSwap1Index <> -1) then
      SendMessage(lbxValueTable.Handle, LB_SETTOPINDEX, Self.formModel.GetLastSwap1Index, 0);
  end;

  // Aktualisiere Bereich Listenaufbau
  if(update = LIST_CONSTRUCTION) then
  begin
    sedElementCount.Value := Self.formModel.GetElementCount;

    case Self.formModel.GetConstructionSequence of
      RANDOM:        rbRandom.Checked       := true;
      ASC:           rbAsc.Checked          := true;
      DESC:          rbDesc.Checked         := true;
      START_ERROR:   rbStartError.Checked   := true;
      END_ERROR:     rbEndError.Checked     := true;
      EQUAL_NUMBERS: rbEqualNumbers.Checked := true;
    end;
  end;

  // Aktualisiere Bereich Sortierverfahren
  if(update = SORT_ALGO) then
  begin
    case Self.formModel.GetAlgorithm of
      unitTypes.DIRECT_SWAP:   rbSwap.Checked       := true;
      unitTypes.DIRECT_INSERT: rbInsertion.Checked  := true;
      unitTypes.BUBBLESORT:    rbBubbleSort.Checked := true;
      unitTypes.QUICKSORT:     rbQuickSort.Checked  := true;
      unitTypes.SHAKERSORT:    rbShakerSort.Checked := true;
      unitTypes.HEAPSORT:      rbHeapSort.Checked   := true;
    end;

    case Self.formModel.GetSequence of
      AUTO_WITHOUT_ANIMATION:
        begin
          rbAuto.Checked   := true;
          lblSpeed.Visible := false;
          sedSpeed.Visible := false;
        end;
      AUTO_WITH_ANIMATION:
        begin
          rbAutoAnimation.Checked := true;
          lblSpeed.Visible        := true;
          sedSpeed.Visible        := true;
        end;
      SINGLE_STEP_MODE:
        begin
          rbSingleSteps.Checked := true;
          lblSpeed.Visible      := false;
          sedSpeed.Visible      := false;
        end;
    end;

    btnStop.Enabled := Self.formModel.IsStarted;
    if(Self.formModel.IsSleeping) then
      btnStart.Caption := resourceManager.GetString('weiter');
    if(not Self.formModel.IsStarted) then
      btnStart.Caption := resourceManager.GetString('start');

    rbSwap.Enabled          := not Self.formModel.IsStarted;
    rbInsertion.Enabled     := not Self.formModel.IsStarted;
    rbBubbleSort.Enabled    := not Self.formModel.IsStarted;
    rbQuickSort.Enabled     := not Self.formModel.IsStarted;
    rbShakerSort.Enabled    := not Self.formModel.IsStarted;
    rbHeapSort.Enabled      := not Self.formModel.IsStarted;

    rbAutoAnimation.Enabled := not Self.formModel.IsStarted;
    rbAuto.Enabled          := not Self.formModel.IsStarted;
    rbSingleSteps.Enabled   := not Self.formModel.IsStarted;

    if(Self.formModel.GetSequence = SINGLE_STEP_MODE) then
    begin
      chbPrintSteps.Checked := Self.formModel.IsPrintSteps;
      chbPrintSteps.Enabled := true;
      chbSaveSteps.Checked  := Self.formModel.IsSaveSteps;
      chbSaveSteps.Enabled  := true;
    end
    else
    begin
      chbPrintSteps.Checked := false;
      chbPrintSteps.Enabled := false;
      chbSaveSteps.Checked  := false;
      chbSaveSteps.Enabled  := false;
    end;

    sedSpeed.Value          := Self.formModel.GetSpeed;
  end;

  // Aktualisiere Bereich Analyse
  if(update = ANALYSIS) then
  begin
    edtComparisonCount.Text := IntToStr(Self.formModel.GetComparisonCount);
    edtOperationCount.Text  := IntToStr(Self.formModel.GetOperationCount);
    edtSwapCount.Text       := IntToStr(Self.formModel.GetSwapCount);
    edtTime.Text            := Format('%1.3f', [Self.formModel.GetTime / 1000]);
  end;

  // Drucke aktuelle Tabelle
  if(update = PRINTSTEP) then
  begin
    if PrintDialog.Execute then
    begin
      AssignPrn(PrintText);
      Rewrite(PrintText);
      Printer.Canvas.Font := lbxValueTable.Font;
      integerList := Self.formModel.GetUnsortedArray;

      for i := 0 to Length(integerList) - 1 do
        Writeln(PrintText, integerList[i]);
      CloseFile(PrintText);
    end;
  end;

  // Speichere aktuelle Tabelle
  if(update = SAVESTEP) then
  begin
    if(SaveDialog.Execute) then
    begin
      lbxValueTable.Items.SaveToFile(SaveDialog.FileName);
    end;
  end;
end;


// ************************************************************************
// *     PUBLISHED: Ab hier sind alle published-Methoden                  *
// ************************************************************************

{
  Diese Methode weist das Model an, eine neue unsortierte Liste zu erzeugen.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.btnCreateListClick(Sender: TObject);
begin
  Self.formModel.CreateNewList;
  resetAllThreads();
end;

{
  Diese Methode beendet das Programm.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.btnEndClick(Sender: TObject);
begin
  resetAllThreads;
  Close;
end;

{
  Diese Methode weist das FormModel an die original Liste wieder zu laden.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.btnLoadOriginListClick(Sender: TObject);
begin
  Self.formModel.LoadOriginalArray;
  resetAllThreads();
end;

{
  Diese Methode weist das FormModel an die aktuelle Liste durch eine aus einer
  Datei geladenen zu ersetzen.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.btnOpenListClick(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName) + FILES_PATH;
  OpenDialog.Filter := '.dat';
  if OpenDialog.Execute then
  begin
    Self.formModel.LoadUnsortedArray(OpenDialog.FileName);
    resetAllThreads();
  end;
end;

{
  Diese Methode weist das Model an, die aktuelle Liste zu speichern.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.btnSaveListClick(Sender: TObject);
var filename          : String;  // Dateiname in der die Zahlen gespeichert werden
    constructionLabel : String;  // Teil des Dateinamens. Gibt die Art des Listenaufbaus an.
begin
  case Self.formModel.GetConstructionSequence of
    RANDOM:        constructionLabel := rbRandom.Caption;
    ASC:           constructionLabel := rbAsc.Caption;
    DESC:          constructionLabel := rbDesc.Caption;
    START_ERROR:   constructionLabel := rbStartError.Caption;
    END_ERROR:     constructionLabel := rbEndError.Caption;
    EQUAL_NUMBERS: constructionLabel := rbEqualNumbers.Caption;
  end;

  filename := IntToStr(Self.formModel.GetElementCount) + '_'
            + constructionLabel + '.dat';

  SaveDialog.InitialDir := ExtractFilePath(Application.ExeName) + FILES_PATH;
  SaveDialog.FileName := filename;
  SaveDialog.Filter := '.dat';
  if SaveDialog.Execute then
  begin
    Self.formModel.SaveUnsortedArray(SaveDialog.FileName);
  end;
end;

{
  Diese Methode startet je nachdem welcher Algorithmus ausgewählt ist die
  Sortier-Methode der jeweiligen Sortierklasse auf.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.btnStartClick(Sender: TObject);
begin
  if(Self.formModel.IsStarted = false) and( Self.formModel.IsSleeping = false) then
    resetAllThreads;

  case Self.formModel.GetAlgorithm of
    unitTypes.DIRECT_SWAP: // Starte Seletion-Sort Thread
      begin
        if(Self.selectionSort = nil) then
        begin
          Self.selectionSort := TSelectionSort.Create(Self, Self.formModel);
          Self.selectionSort.SetUnsortedArray(Self.formModel.GetUnsortedArray);
        end;
        if(Self.selectionSort.Suspended) then
          Self.selectionSort.Resume;
      end;
    unitTypes.DIRECT_INSERT:  // Starte Insertion-Sort Thread
      begin
        if(Self.insertionSort = nil) then
        begin
          Self.insertionSort := TInsertionSort.Create(Self, Self.formModel);
          Self.insertionSort.SetUnsortedArray(Self.formModel.GetUnsortedArray);
        end;
        if(Self.insertionSort.Suspended) then
          Self.insertionSort.Resume;
      end;
    unitTypes.BUBBLESORT:  // Starte Bubble-Sort Thread
      begin
        if(Self.bubbleSort = nil) then
        begin
          Self.bubbleSort := TBubbleSort.Create(Self, Self.formModel);
          Self.bubbleSort.SetUnsortedArray(Self.formModel.GetUnsortedArray);
        end;
        if(Self.bubbleSort.Suspended) then
          Self.bubbleSort.Resume;
      end;
    unitTypes.QUICKSORT:  // Starte Quick-Sort Thread
      begin
        if(Self.quickSort = nil) then
        begin
          quickSort := TQuickSort.Create(Self, Self.formModel);
          quickSort.SetUnsortedArray(Self.formModel.GetUnsortedArray);
        end;
        if(Self.quickSort.Suspended) then
          Self.quickSort.Resume;
      end;
    unitTypes.SHAKERSORT:  // Starte Shaker-Sort Thread
      begin
        if(Self.shakerSort = nil) then
        begin
          shakerSort := TShakerSort.Create(Self, Self.formModel);
          shakerSort.SetUnsortedArray(Self.formModel.GetUnsortedArray);
        end;
        if(Self.shakerSort.Suspended) then
          Self.shakerSort.Resume;
      end;
    unitTypes.HEAPSORT:  // Starte Heap-Sort Thread
      begin
        if(Self.heapSort = nil) then
        begin
          heapSort := THeapSort.Create(Self, Self.formModel);
          heapSort.SetUnsortedArray(Self.formModel.GetUnsortedArray);
        end;
        if(Self.heapSort.Suspended) then
          Self.heapSort.Resume;
      end;
  end;
end;

{
  Diese Methode beendet den aktuellen Sortiervorgang, indem der aktuell
  laufende Thread beendet wird.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.btnStopClick(Sender: TObject);
begin
  Self.formModel.setStarted(false);
  Self.formModel.SetSleeping(false);
  resetAllThreads;
end;

{
  Diese Methode setzt die Option zum Drucken der Einzelschritte.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.chbPrintStepsClick(Sender: TObject);
begin
  Self.formModel.SetPrintSteps(chbPrintSteps.Checked);
end;

{
  Diese Methode setzt die Option zum Speichern der Einzelschritte.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.chbSaveStepsClick(Sender: TObject);
begin
  Self.formModel.SetSaveSteps(chbSaveSteps.Checked);
end;

{
  Diese Methode wird aufgerufen sobald das Formular erstellt wird und
  initialisiert alle Komponenten, die zur Laufzeit benötigt werden.

  ~param Sender Das Objekt, von dem das Create-Ereignis stammt.
}
procedure TfrmSortAlgo.FormCreate(Sender: TObject);
begin
  // Erstelle benötigte Verzeichnisstrultur
  if(not DirectoryExists(ExtractFilePath(Application.ExeName) + FILES_PATH)) then
    MkDir(ExtractFilePath(Application.ExeName) + FILES_PATH);

  // Lade Beschriftungen
  Self.resourceManager := TResourceManager.NewInstance;
  Self.resourceManager.LoadLanguageFile(DATA_PATH + 'sortierAlgorithmen_de.properties');

  initLabels;
  lbxValueTable.Style := lbOwnerDrawVariable;

  // Erstelle FormModel für dieses Formular
  formModel := TMainModel.Create;
  formModel.addObserver(Self);

  Self.selectionSort := nil;
  Self.insertionSort := nil;
  Self.bubbleSort    := nil;
  Self.quickSort     := nil;
  Self.shakerSort    := nil;
  Self.heapSort      := nil;

  Self.Position := poScreenCenter;
  Self.imgSignaturBlauClick(Self);

  updateView(VALUE_TABLE);
  updateView(LIST_CONSTRUCTION);
  updateView(SORT_ALGO);
  updateView(ANALYSIS);
end;

procedure TfrmSortAlgo.imgSignaturBlauClick(Sender: TObject);
var frmInfoBox : TfrmInfoBox;
begin
  frmInfoBox := TfrmInfoBox.Create(Self);
  frmInfoBox.Position := poScreenCenter;
  frmInfoBox.ShowModal;
end;

procedure TfrmSortAlgo.imgSignaturBlauMouseLeave(Sender: TObject);
begin
  imgSignaturBlau.Visible := False;
end;

procedure TfrmSortAlgo.imgSignaturMouseEnter(Sender: TObject);
begin
  imgSignaturBlau.Visible := True;
end;

{
  Diese Methode zeichnet eine Zeile in der Wertetabelle.
  Die jeweils zuletzt vertauschen Elemente werden Farblich hervorgehoben.
}
procedure TfrmSortAlgo.lbxValueTableDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var listbox : TListbox;
begin
  if Control is TListbox then begin
    listbox := Control as TListbox;
    if (Index = Self.formModel.GetLastSwap1Index) and (Self.formModel.GetSequence <> AUTO_WITHOUT_ANIMATION) then
      listbox.Canvas.Brush.Color := clLime
    else if (Index = Self.formModel.GetLastSwap2Index) and (Self.formModel.GetSequence <> AUTO_WITHOUT_ANIMATION) then
      listbox.Canvas.Brush.Color := clYellow
    else
      listbox.Canvas.Brush.Color := clWhite;

    listbox.Canvas.FillRect(Rect);
    listbox.Canvas.TextOut(Rect.Left, Rect.Top, listbox.Items[Index]);
  end;
end;

{
  Diese Methode setzt die Aufbaufolge auf ASC.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbAscClick(Sender: TObject);
begin
  Self.formModel.SetConstructionSequence(ASC);
end;

{
  Diese Methode setzt die Abgolge auf Auto mit Animation.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbAutoAnimationClick(Sender: TObject);
begin
  Self.formModel.SetSequence(AUTO_WITH_ANIMATION);
end;

{
  Diese Methode setzt die Abfolge auf Auto ohne Animation.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbAutoClick(Sender: TObject);
begin
  Self.formModel.SetSequence(AUTO_WITHOUT_ANIMATION);
end;

{
  Diese Methode setzt den Sortieralgorithmus auf Bubble-Sort.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbBubbleSortClick(Sender: TObject);
begin
  Self.formModel.SetAlgorithm(unitTypes.BUBBLESORT);
end;

{
  Diese Methode setzt die Aufbaufolge auf DESC.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbDescClick(Sender: TObject);
begin
  Self.formModel.SetConstructionSequence(DESC);
end;

{
  Diese Methode setzt die Aufbaufolge auf END_ERROR.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbEndErrorClick(Sender: TObject);
begin
  Self.formModel.SetConstructionSequence(END_ERROR);
end;

{
  Diese Methode setzt die Aufbaufolge auf EQAUL_NUMBERS.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbEqualNumbersClick(Sender: TObject);
begin
  Self.formModel.SetConstructionSequence(EQUAL_NUMBERS);
end;

{
  Diese Methode setzt den Sortieralgorithmus Heap-Sort.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbHeapSortClick(Sender: TObject);
begin
  Self.formModel.SetAlgorithm(unitTypes.HEAPSORT);
end;

{
  Diese Methode setzt den Sortieralgorithmus auf direktes Einfügen.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbInsertionClick(Sender: TObject);
begin
  Self.formModel.SetAlgorithm(DIRECT_INSERT);
end;

{
  Diese Methode setzt die Aufbaufolge auf RANDOM.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbRandomClick(Sender: TObject);
begin
  Self.formModel.SetConstructionSequence(RANDOM);
end;

{
  Diese Methode setzt den Sortieralgorithmus Shaker-Sort.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbShakerSortClick(Sender: TObject);
begin
  Self.formModel.SetAlgorithm(unitTypes.SHAKERSORT);
end;

{
  Diese Methode setzt die Abfolge auf Einzelschritte.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbSingleStepsClick(Sender: TObject);
begin
  Self.formModel.SetSequence(SINGLE_STEP_MODE);
end;

{
  Diese Methode setzt den Sortieralgorithmus auf Quick-Sort
  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.

  }
procedure TfrmSortAlgo.rbQuickSortClick(Sender: TObject);
begin
  Self.formModel.SetAlgorithm(unitTypes.QUICKSORT);
end;

{
  Diese Methode setzt die Aufbaufolge auf START_ERROR.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbStartErrorClick(Sender: TObject);
begin
  Self.formModel.SetConstructionSequence(START_ERROR);
end;

{
  Diese Methode setzt den Sortieralgorithmus auf direktes Austauschen.

  ~param Sender Das Objekt, von dem das Click-Ereignis stammt.
}
procedure TfrmSortAlgo.rbSwapClick(Sender: TObject);
begin
  Self.formModel.SetAlgorithm(DIRECT_SWAP);
end;

{
  Diese Methode setzt die Anzahl der Elemente, die in einer Liste generiert werden
  ins Model.

  ~param Sender Das Objekt, von dem das Exit-Ereignis stammt.
}
procedure TfrmSortAlgo.sedElementCountExit(Sender: TObject);
begin
  try
    Self.formModel.SetElementCount(sedElementCount.Value);
  except
    // Ignoriere, dass das Feld leer ist oder ein ungültiger Wert enthalten ist.
    Self.formModel.SetElementCount(1);
  end;
end;

{
  Diese Methode setzt die Anzahl der Schritte, die in einer Sekunde
  ausgeführt werden sollen.

  ~param Sender Das Objekt, von dem das Exit-Ereignis stammt.
}
procedure TfrmSortAlgo.sedSpeedExit(Sender: TObject);
begin
  Self.formModel.SetSpeed(sedSpeed.Value);
end;


// ************************************************************************
// *     PRIVATE: Ab hier sind alle private-Methoden                      *
// ************************************************************************

{
  Diese Methode setzt alle Bezeichnungen auf die GUI Elemente.
}
procedure TfrmSortAlgo.initLabels;
begin
  btnCreateList.Caption        := resourceManager.GetString('createList');
  btnEnd.Caption               := resourceManager.GetString('end');
  btnLoadOriginList.Caption    := resourceManager.GetString('loadOriginList');
  btnOpenList.Caption          := resourceManager.GetString('openList');
  btnSaveList.Caption          := resourceManager.GetString('saveList');
  btnStart.Caption             := resourceManager.GetString('start');
  btnStop.Caption              := resourceManager.GetString('stop');

  chbPrintSteps.Caption        := resourceManager.GetString('printSteps');
  chbSaveSteps.Caption         := resourceManager.GetString('saveSteps');

  frmSortAlgo.Caption          := resourceManager.GetString('sortalgorithm');

  gbxAlgo.Caption              := resourceManager.GetStringWithSpace('algorithm');
  gbxAnalysis.Caption          := resourceManager.GetStringWithSpace('analysis');
  gbxConstructSequence.Caption := resourceManager.GetStringWithSpace('constructionSequence');
  gbxListConstruction.Caption  := resourceManager.GetStringWithSpace('listConstruction');
  gbxSequence.Caption          := resourceManager.GetStringWithSpace('sequence');
  gbxSortAlgo.Caption          := resourceManager.GetStringWithSpace('sortalgorithm');
  gbxValueTable.Caption        := resourceManager.GetStringWithSpace('valueTable');

  lblComparisonCount.Caption   := resourceManager.GetString('comparisonCount');
  lblElementCount.Caption      := resourceManager.GetString('elementCount');
  lblOperationCount.Caption    := resourceManager.GetString('operationCount');
  lblSwapCount.Caption         := resourceManager.GetString('swapCount');
  lblSpeed.Caption             := resourceManager.GetString('speedInfo');
  lblTime.Caption              := resourceManager.GetString('time');

  rbAsc.Caption                := resourceManager.GetString('asc');
  rbAuto.Caption               := resourceManager.GetString('autoWithoutAnimation');
  rbAutoAnimation.Caption      := resourceManager.GetString('autoWithAnimation');
  rbBubbleSort.Caption         := resourceManager.GetString('bubbleSort');
  rbDesc.Caption               := resourceManager.GetString('desc');
  rbEndError.Caption           := resourceManager.GetString('endError');
  rbEqualNumbers.Caption       := resourceManager.GetString('equalNumbers');
  rbHeapSort.Caption           := resourceManager.GetString('heapSort');
  rbInsertion.Caption          := resourceManager.GetString('directInsert');
  rbQuickSort.Caption          := resourceManager.GetString('quickSort');
  rbRandom.Caption             := resourceManager.GetString('randomNumbers');
  rbShakerSort.Caption         := resourceManager.GetString('shakerSort');
  rbStartError.Caption         := resourceManager.GetString('startError');
  rbSingleSteps.Caption        := resourceManager.GetString('singleStep');
  rbSwap.Caption               := resourceManager.GetString('directSwap');
end;

{
  Diese Methode terminiert alle Threads und setzt die Analyse zurück.
}
procedure TfrmSortAlgo.resetAllThreads;
begin
  Self.formModel.SetOperationCount(0);
  Self.formModel.SetComparisonCount(0);
  Self.formModel.SetSwapCount(0);
  Self.formModel.SetTime(0);

  Self.formModel.SetStarted(false);
  Self.formModel.SetSleeping(false);
  Self.formModel.SetLastSwapsIndex(-1, -1);

  if(Self.selectionSort <> nil) then
  begin
    Self.selectionSort := nil;
  end;

  if(Self.insertionSort <> nil) then
  begin
    Self.insertionSort := nil;
  end;

  if(Self.bubbleSort <> nil) then
  begin
    Self.bubbleSort := nil;
  end;

  if(Self.quickSort <> nil) then
  begin
    Self.quickSort := nil;
  end;

  if(Self.shakerSort <> nil) then
  begin
    Self.shakerSort := nil;
  end;

  if(Self.heapSort <> nil) then
  begin
    Self.heapSort := nil;
  end;
end;

end.
