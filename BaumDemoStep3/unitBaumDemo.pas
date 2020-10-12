{
  Dieses Programm ist Teil eines Schulprojekts der Carl-Benz Schule Koblenz.
  Diese Version stellt den Schritt 2 des Projekts dar, in dem der allgemeine
  Aufbau von Bäumen realisiert ist. Zusätzlich ist hier das Löschen und die
  Visualisierung des Baumes implementiert.

  Folgene Funktionalitäten sind in dieser Version realisiert:
    - Anlegen einer neuen Baumwurzel
    - Hinzufügen eines neuen Elements in den bestehenden Baum
    - Löschen des gesamten Baumes
    - In-order Traverierung des Baumes
    - Pre-order Traversierung des Baumes
    - Post-order Traversierung des Baumes
    - Sprachwechsel

    - (neu) Löschen eines einlenzen Elements aus dem Baum
    - (neu) Zeichnen des kompletten Baumes in 2D

  Folgender Styleguide wurde verwendet:
    - Einrücken von Blöcken mittels zwei Leerzeichen
    - Sprechende Variablen- und Methodenbezeichner
    - Klassenvariablen werden mit Self. aufgerufen, damit diese leichter
      zu erkennen sind und von lokalen Variablen unterschieden werden können.
    - Methoden sind nach Sichbarkeit eingeteilt. (public, published, private)
    - Variablen und Methoden sind alphabetisch sortiert.
    - Variablen beginnen mit kleinem Buchstaben und werden camelCase geschrieben
    - Methoden beginnen mit großem Buchstaben und werden CamelCase geschrieben
    - Methodenkommentare folgen der JADD Konvention
    - Einzeilige Kommentare sind zu 2/3 rechts eingerückt
    - Konstanten werden UPPER_CASE geschrieben.
    - Maximale Zeichenbreite pro Zeile ist 80 (bis auf wenige Ausnahmen)
    - Variablen Deklarationsblöcke werden optisch am Doppelpunkt ausgerichtet

  Anmerkungen des Autors:
  =======================

  Sprachwechsel:
  Den Sprachwechsel hab ich eingebaut, weil ich es einfach mal in Delphi
  ausprobieren wollte und ich es zuvor noch nie gemacht habe. Es ist die einzige
  Funktionalität, die mir so von der Umsetzung her in Delphi neu ist.
  Das Prinzip der .properties Dateien ist mir zwar von Java bekannt, aber vor
  diesem Projekt wusste ich noch nicht, wie man dies in Delphi umsetzt.

  Kommentare:
  Die Syntax der Kommentar entspricht der JADD (Just Another DelphiDoc)
  Konvention. Dies ist ein Tool, mit dem Delphi Code und die Kommentare
  automatisch in eine API Dokumentation überführt werden können. Es lehnt sich
  an das JavaDoc aus der Java Welt an.

  SVN:
  Da die Bedingung aufgestellt wurde, dass die insgesamt drei Schritte getrennt
  voneinander abgegeben werden müssen, habe ich in meinem SVN Repository
  drei neue Branches angelegt. Somit kann ich sicherstellen, dass Änderungen in
  früheren Versionen, in die späteren Versionen gemergt werden können, die
  einzelnen Versionen jedoch voneinander getrennt sind.

  ~version x.x
  Dieses Tag steht für die Version der Methode. Die Version spiegelt die
  Einteilung in drei Schritte.
  Version 1.0: Diese Version stammt aus dem ersten Schritt und wurde seit dem
               nicht mehr verändert.
  Version 1.x: Diese Version stammt aus dem ersten Schritt, wurde jedoch für
               die aktuelle Version erweitert/geändert.
  Version 2.0: Diese Version stammt aus dem zweiten Schritt und wurde seit dem
               nicht mehr verändert.
  Version 2.x: Diese version stammt aus dem zweiten Schritt, wurde jedoch für
               die aktuelle Version erweitert/geändert.
  Version 3.0: Diese Version stammt aus dem dritten Schritt und wurde seit dem
               nicht mehr verändert.             

  (neu) Zeichnen in 2D:
  Ich habe für das Zeichnen des Baumes extra eine neue Klasse angelegt, da ich
  diesen Part ein wenig ausführlicher gestalten wollte. Ich hätte auch ganz
  einfach den Baum inorder traversieren können und die Elemente vom Ersten bis
  zum Letzten eine aufsteigende x-Achsen Koordinaten geben können.
  Ich hab mich dafür entschieden den Reingold & Tilford Algorithmus zu
  implementieren, da dieser die ersten fünf Kriterien der Ästhetik von Bäumen
  erfüllt. Weitere Details siehe unitTreeViewer...

  
  Compiler: Delphi 6.0

  ~author Thomas Gattinger
  ~version 1.x / 2.0
}
unit unitBaumDemo;

interface

uses
  // Delphi Klassen
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Math, ExtCtrls, Buttons, ComCtrls, pngimage,

  // Eigene Klassen
  unitElement, unitResourceManager, unitTreeViewer, unitInfoBox;

type

  TfrmBaumDemo = class(TForm)                // Dieser Typ ist für das Formular
    btnBackgroundChoose : TButton;           // zuständig, auf dem sich alle
    btnClear            : TButton;           // GUI Element befinden.
    btnClose            : TButton;
    btnDel              : TButton;
    btnInorder          : TButton;
    btnMemTest          : TButton;
    btnNewElement       : TButton;
    btnNewRoot          : TButton;
    btnNodeColorChoose  : TButton;
    btnPaint            : TButton;
    btnPostorder        : TButton;
    btnPreorder         : TButton;
    cbFontStyle         : TComboBox;
    cbLanguage          : TComboBox;
    chbShowPath         : TCheckBox;
    colorDialog         : TColorDialog;
    edtCount            : TEdit;
    edtDelay            : TEdit;
    edtInput            : TEdit;
    edtLineSize         : TEdit;
    edtNodeRadius       : TEdit;
    gbxInfoBox          : TGroupBox;
    gbxPaintConfig      : TGroupBox;
    gbxTestmode         : TGroupBox;
    lblActionMsg        : TLabel;
    lblBackgroundColor  : TLabel;
    lblCount            : TLabel;
    lblDelay            : TLabel;
    lblFontStyle        : TLabel;
    lblInput            : TLabel;
    lblLineSize         : TLabel;
    lblMillisec         : TLabel;
    lblNodeColor        : TLabel;
    lblNodeRadius       : TLabel;
    lblOutput           : TLabel;
    lblShowPath         : TLabel;
    lblTestModeSpeed    : TLabel;
    lbxOutput           : TListBox;
    randomTester        : TTimer;
    trbTestModeSpeed    : TTrackBar;
    imgSignatur: TImage;
    imgSignaturBlau: TImage;

    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnInorderClick(Sender: TObject);
    procedure btnNewElementClick(Sender: TObject);
    procedure btnNewRootClick(Sender: TObject);
    procedure btnPaintClick(Sender: TObject);
    procedure btnPostorderClick(Sender: TObject);
    procedure btnPreorderClick(Sender: TObject);
    procedure cbLanguageChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure randomTesterTimer(Sender: TObject);
    procedure trbTestModeSpeedChange(Sender: TObject);
    procedure edtLineSizeChange(Sender: TObject);
    procedure cbFontStyleChange(Sender: TObject);
    procedure edtNodeRadiusChange(Sender: TObject);
    procedure edtDelayChange(Sender: TObject);
    procedure btnNodeColorChooseClick(Sender: TObject);
    procedure btnBackgroundChooseClick(Sender: TObject);
    procedure btnMemTestClick(Sender: TObject);
    procedure chbShowPathClick(Sender: TObject);
    procedure edtInputKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure imgSignaturBlauClick(Sender: TObject);
    procedure imgSignaturBlauMouseLeave(Sender: TObject);
    procedure imgSignaturMouseEnter(Sender: TObject);

  private { Private declarations }
    imgTreeViewer       : TTreeViewer;       // Zeichnet einen Binärbaum
    lastActionArguments : Array of TVarRec;  // Letzte Argumentenliste
    lastActionColor     : TColor;            // Letzte Farbe in der Infobox
    lastActionKey       : String;            // Letzter key in der Infobox
    paintingMode        : Boolean;           // Visualisierung (on / off)
    remove              : Boolean;           // Flag für den randomTester
    resourceManager     : TResourceManager;  // Lädt alle Beschriftungen
    root                : TElement;          // Wurzel des aktuellen Baumes
    showPath            : Boolean;           // Zeigt den Weg durch den Baum an
    treeCount           : Integer;           // Anzahl der Elemente im Baum

    procedure CreateNewPointer(var element : TElement; data : Integer);
    procedure CreateNewRoot(data : Integer);
    procedure DeleteElement(var parent : TElement; var element : TElement;
                            data : Integer);
    procedure DeletePointer(var element : TElement);
    procedure DeleteTree(var element : TElement);
    function  FindSmallestElement(element : TElement) : TElement;
    procedure InitLabels();
    procedure InsertNewElement(element : TElement; data : Integer);
    procedure ShowInfoBoxMsg(key : String; color : TColor;
                             arguments : Array of const);
    procedure ShowInOrder(element : TElement);
    procedure ShowPostOrder(element : TElement);
    procedure ShowPreOrder(element : TElement);

  public { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy(); override;

  end;

const
  ENGLISH_LANG = 'baumDemo_en.properties';   // Englische Sprachdatei
  GERMAN_LANG  = 'baumDemo_de.properties';   // Deutsche Sprachdatei

  SMALL_WIDTH = 396;                         // Schmale Breite des Formulars
  HIGH_WIDTH = 1024;                         // Große Breite des Formulars

var
  frmBaumDemo : TfrmBaumDemo;                // Instanz dieser Klasse

implementation

{$R *.dfm}


// ************************************************************************
// *     PUBLIC: Ab hier sind alle public-Methoden                        *
// ************************************************************************

{
  Dieser Konstruktor erzeugt eine Instanz dieser Klassen und setzt das Root
  Element des Baumes auf nil. Außerdem werden die deutschen Beschriftungen
  aus der entsprechenden .properties Datei geladen.

  ~param AOwner Das Objekt, das der Besitzer dieser Instanz ist.
  ~version 1.1
}
constructor TfrmBaumDemo.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Self.root            := nil;
  Self.lastActionKey   := '';
  Self.lastActionColor := clGreen;
  Self.paintingMode    := true;
  Self.showPath        := true;
  Self.remove          := false;
  Self.treeCount       := 0;
  SetLength(Self.lastActionArguments, 0);

  Self.resourceManager := TResourceManager.NewInstance;
  Self.resourceManager.LoadLanguageFile(GERMAN_LANG);
  InitLabels();

  Self.imgTreeViewer        := TTreeViewer.Create(Self);
  Self.imgTreeViewer.Parent := Self;
  Self.DoubleBuffered       := true;

  Self.Position := poScreenCenter;
  Self.imgSignaturBlauClick(Self);
end;

{
  Dieser Destruktor löscht den aktuellen Baum und gibt alle Resourcen sowie
  die Instanz dieser Klasse wieder frei.

  ~version 1.0
}
destructor TfrmBaumDemo.Destroy();
begin
  DeleteTree(Self.root);
  Self.resourceManager.FreeInstance;

  inherited Destroy();
end;


// ************************************************************************
// *     PUBLISHED: Ab hier sind alle published-Methoden                  *
// ************************************************************************

{
  Diese Methode öffnet den Farbdialog und setzt die gewählte Farbe für den
  Hintergrund des TreeViewers.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.btnBackgroundChooseClick(Sender: TObject);
begin
  if(colorDialog.Execute) then
    Self.imgTreeViewer.SetBackgroundColor(colorDialog.Color);
end;

{
  Diese Methode löscht den Inhalt der Ausgabeliste.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnClearClick(Sender: TObject);
begin
  lbxOutput.Clear;
  lblOutput.Caption := Self.resourceManager.GetStringWithSeparator('output');
end;

{
  Diese Methode beendet das Programm.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{
  Diese Methode initiiert das Löschen des in dem Eingabefeld angegebenen
  Elements aus dem Baum.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.btnDelClick(Sender: TObject);
var data   : Integer;
    parent : TElement;
begin
  try
    data := StrToInt(edtInput.Text);

    parent := nil;
    deleteElement(parent, Self.root, data);
  except
    on EConvertError do
    begin
      ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, [Low(Integer), High(Integer)]);
    end;
  end;
  edtInput.SetFocus;
end;

{
  Diese Methode initiert die in-order Traversierung.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnInorderClick(Sender: TObject);
begin
  if(Self.root <> nil) then
  begin
    lbxOutput.Clear;
    lblOutput.Caption := Self.resourceManager.GetStringWithSeparator('outputInorder');
    ShowInOrder(root);
  end
  else
  begin
    ShowInfoBoxMsg('noTreeExist', clMaroon, []);
  end;
end;


{
  Diese Methode startet den Speichertest. Bei diesem Test werden alle
  Möglichkeiten einen Baum zu füllen und wieder zu leeren durchlaufen und
  der benötigte Speicher festgehalten. So kann festgestellt werden, ob
  Speicherlegs vorliegen.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.btnMemTestClick(Sender: TObject);
const COUNT = 20;                              // Anzahl der Elemente (Vielfaches von 2)
var msg         : String;                      // Benutzermeldung
    answer      : Integer;                     // Antwort des Nutzers
    i           : Integer;                     // Zählvariable
    oldShowPath : Boolean;                     // Merkt sich den alten Zustand
    testLog     : String;                      // Ergebnisbericht des Tests
    startTime   : Integer;                     // Startzeit eines Teiltests
    endTime     : Integer;                     // Endzeit eines Teiltests
    usedSpace   : Integer;                     // kompletter benötigter Speicher
    newLine     : String;                      // Zeilenumbruch

    procedure AddLeft;                         // Fügt nur linke Elemente hinzu
    var i : Integer;
    begin
      edtInput.Text := inttostr(COUNT);
      btnNewRootClick(Self);
      for i := COUNT-1 downto 1 do
      begin
        edtInput.Text := inttostr(i);
        btnNewElementClick(Self);
      end;
      Application.ProcessMessages;
    end;

    procedure AddRight;                        // Fügt nur rechte Elemente hinzu
    var i : Integer;
    begin
      edtInput.Text := inttostr(1);
      btnNewRootClick(Self);
      for i := 2 to COUNT do
      begin
        edtInput.Text := inttostr(i);
        btnNewElementClick(Self);
      end;
      Application.ProcessMessages;
    end;

begin
  oldShowPath := Self.showPath;
  chbShowPath.Checked := false;
  testLog := '';
  newLine := chr(13) + chr(10);

  answer := MessageDlg(resourceManager.GetString('startMemTestInfo'),
            mtConfirmation, [mbYes, mbNo], 0);
  if(answer <> mrYes) then
  begin
    chbShowPath.Checked := oldShowPath;
    Exit;
  end;

  Self.imgTreeViewer.SetHighlightDelay(0);
  testLog := testLog + 'Ergebnis des Speichertests' + newLine
                     + '==========================' + newLine + newLine;

  startTime := GetTickCount;

// ************************************************************************
// * (1) Testfall: Es werden nur linke Kinder hinzugefügt                 *
// *     a) lösche immer nur das linkeste Blatt                           *
// *     b) lösche immer nur das vorletzte Element                        *
// *        und zum Schluss die Wurzel                                    *
// *     c) lösche immer nur die Wurzel                                   *
// ************************************************************************

  testLog := testLog + '(1) fülle nur linke Kinder auf:' + newLine;

  testLog := testLog + '--> a) lösche nur Blätter bis der Baum leer ist' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

  AddLeft;                                     // Füge Elemente hinzu

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  for i := 1 to COUNT do                       // Lösche Elemente wieder (a)
  begin
    edtInput.Text := inttostr(i);
    btnDelClick(Self);
  end;
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine;



  testLog := testLog + '--> b) lösche nur Knoten bis der Baum leer ist' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

  AddLeft;                                     // Füge Elemente hinzu

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  for i := 2 to COUNT do                       // Lösche Elemente wieder (b)
  begin
    edtInput.Text := inttostr(i);
    btnDelClick(Self);
  end;
  edtInput.Text := inttostr(1);
  btnDelClick(Self);
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine;



  testLog := testLog + '--> c) lösche immer die Wurzel bis der Baum leer ist' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

  AddLeft;                                     // Füge Elemente hinzu

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  for i := COUNT downto 1 do                   // Lösche Elemente wieder (c)
  begin
    edtInput.Text := inttostr(i);
    btnDelClick(Self);
  end;
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine + newLine;


// ************************************************************************
// * (2) Testfall: Es werden nur rechte Kinder hinzugefügt                *
// *     a) lösche immer nur das rechteste Blatt                          *
// *     b) lösche immer nur das vorletzte Element                        *
// *        und zum Schluss die Wurzel                                    *
// *     c) lösche immer nur die Wurzel                                   *
// ************************************************************************

  testLog := testLog + '(2) fülle nur rechte Kinder auf:' + newLine;

  testLog := testLog + '--> a) lösche nur Blätter bis der Baum leer ist' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

  AddRight;                                    // Füge Elemente hinzu

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  for i := COUNT downto 1 do                   // Lösche Elemente wieder (a)
  begin
    edtInput.Text := inttostr(i);
    btnDelClick(Self);
  end;
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine;



  testLog := testLog + '--> b) lösche nur Knoten bis der Baum leer ist' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

  AddRight;                                    // Füge Elemente hinzu

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  for i := COUNT-1 downto 1 do                 // Lösche Elemente wieder (b)
  begin
    edtInput.Text := inttostr(i);
    btnDelClick(Self);
  end;
  edtInput.Text := inttostr(COUNT);
  btnDelClick(Self);
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine;



  testLog := testLog + '--> c) lösche immer die Wurzel bis der Baum leer ist' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

  AddRight;                                    // Füge Elemente hinzu

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  for i := 1 to COUNT do                      // Lösche Elemente wieder (c)
  begin
    edtInput.Text := inttostr(i);
    btnDelClick(Self);
  end;
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine + newLine;


// ************************************************************************
// * (3) Testfall: Es werden linke und rechte Kinder hinzugefügt          *
// *     a) lösche immer nur die Wurzel                                   *
// ************************************************************************

  testLog := testLog + '(3) fülle linke und rechte Kinder auf:' + newLine;

  testLog := testLog + '--> a) lösche immer die Wurzel bis der Baum leer ist' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

                                              // Füge Elemente hinzu
  edtInput.Text := inttostr(Trunc(COUNT / 2));
  btnNewRootClick(Self);
  for i := Trunc(COUNT / 2) + 1 to COUNT do
  begin
    edtInput.Text := inttostr(i);
    btnNewElementClick(Self);
  end;

  for i := Trunc(COUNT / 2) - 1 downto 1 do
  begin
    edtInput.Text := inttostr(i);
    btnNewElementClick(Self);
  end;
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  edtInput.Text := inttostr(Trunc(COUNT / 2)); // Lösche Elemente wieder (a)
  btnDelClick(Self);
  for i := 1 to Trunc(COUNT / 2) do
  begin
    edtInput.Text := inttostr(Trunc(COUNT / 2)+i);
    btnDelClick(Self);
    edtInput.Text := inttostr(Trunc(COUNT / 2)-i);
    btnDelClick(Self);
  end;
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine + newLine;


// ************************************************************************
// * (4) Testfall: Es werden linke und rechte Kinder hinzugefügt          *
// *     a) lösche kompletten Baum rekursiv (deleteTree)                  *
// ************************************************************************

  testLog := testLog + '(4) fülle linke und rechte Kinder auf:' + newLine;

  testLog := testLog + '--> a) lösche kompletten Baum rekursiv (deleteTree)' + newLine;
  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + 'Speicherverbrauch: vorher ' + IntToStr(usedSpace)
          + ' kByte';

                                              // Füge Elemente hinzu
  edtInput.Text := inttostr(Trunc(COUNT / 2));
  btnNewRootClick(Self);
  for i := Trunc(COUNT / 2) + 1 to COUNT do
  begin
    edtInput.Text := inttostr(i);
    btnNewElementClick(Self);
  end;

  for i := Trunc(COUNT / 2) - 1 downto 1 do
  begin
    edtInput.Text := inttostr(i);
    btnNewElementClick(Self);
  end;
  Application.ProcessMessages;

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | maximum ' + IntToStr(usedSpace)
          + ' kByte';

  DeleteTree(Self.root);                      // Lösche Elemente wieder (a)
  Application.ProcessMessages;
  Self.imgTreeViewer.SetRoot(Self.root);

  usedSpace := Trunc(System.GetHeapStatus.TotalAllocated / 1024);
  testLog := testLog + ' | nacher ' + IntToStr(usedSpace)
          + ' kByte' + newLine + newLine;



  endTime := GetTickCount;
  testLog := testLog
          + 'Benötigte Zeit für diesen Test: '
          + FloatToStr((endTime - startTime) / 1000)
          + ' Sekunden';

  ShowMessage(testLog);

  chbShowPath.Checked := oldShowPath;
end;  
  
{
  Diese Methode speichert, falls möglich, den vom Benutzer angegebenen Inhalt
  für das neue Element und fügt das neue Element in den Baum ein. Tritt ein
  Fehler beim Auslesen des Wertes auf, so wird dies dem Benutzer gemeldet und
  das Element nicht in den Baum eingefügt.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnNewElementClick(Sender: TObject);
var data : Integer;                            // Inhalt des neuen Elements
begin
  if(Self.root <> nil) then
  begin
    try
      data := StrToInt(edtInput.Text);

      InsertNewElement(Self.root, data);
    except
      on EConvertError do
      begin
        ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, [Low(Integer), High(Integer)]);
      end;
    end;
    edtInput.SetFocus;
  end
  else
  begin
    ShowInfoBoxMsg('createRootMsg', clMaroon, []);
    btnNewRoot.SetFocus;
  end;
end;

{
  Diese Methode speichert, falls möglich, den vom Benutzer angegebenen Inhalt
  für den Root und erstellt diesen. Tritt ein Fehler beim Auslesen des Wertes
  auf, so wird dies dem Benutzer gemeldet und kein Root Element erzeugt.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnNewRootClick(Sender: TObject);
var data : Integer;                            // Inhalt der Wurzel (Root)
begin
  try
    data := StrToInt(edtInput.Text);

    CreateNewRoot(data);
  except
    on EConvertError do
    begin
      ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, [Low(Integer), High(Integer)]);
    end;
  end;

  edtInput.SetFocus;
end;

{
  Diese Methode öffnet die Farbauswahl und setzt anschließend die ausgewählte
  Farbe für die Knoten.

  ~param Sender Das Objekt, von dem das Click Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.btnNodeColorChooseClick(Sender: TObject);
begin
  if(colorDialog.Execute) then
    Self.imgTreeViewer.SetNodeColor(colorDialog.Color);
end;

{
  Diese Methode initiert das Zeichnen des Baumes.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.btnPaintClick(Sender: TObject);
var nilRoot : TElement;
begin
  paintingMode := not paintingMode;

  if(paintingMode) then
  begin
    frmBaumDemo.Width := HIGH_WIDTH;
    lbxOutput.Height := 169;
    gbxPaintConfig.Visible := true;
    Self.imgTreeViewer.SetRoot(Self.root);
    Self.btnPaint.Caption := resourceManager.GetString('paintOn');
  end
  else
  begin
    frmBaumDemo.Width := SMALL_WIDTH;
    lbxOutput.Height := 417;
    gbxPaintConfig.Visible := false;
    nilRoot := nil;
    Self.imgTreeViewer.SetRoot(nilRoot);
    Self.btnPaint.Caption := resourceManager.GetString('paintOff');
  end;
end;

{
  Diese Methode initiert die post-order Traversierung.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnPostorderClick(Sender: TObject);
begin
  if(Self.root <> nil) then
  begin
    lbxOutput.Clear;
    lblOutput.Caption := Self.resourceManager.GetStringWithSeparator('outputPostorder');
    ShowPostOrder(Self.root);
  end
  else
  begin
    ShowInfoBoxMsg('noTreeExist', clMaroon, []);
  end;
end;

{
  Diese Methode initiert die pre-order Traversierung.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnPreorderClick(Sender: TObject);
begin
  if(Self.root <> nil) then
  begin
    lbxOutput.Clear;
    lblOutput.Caption := Self.resourceManager.GetStringWithSeparator('outputPreorder');
    ShowPreOrder(Self.root);
  end
  else
  begin
    ShowInfoBoxMsg('noTreeExist', clMaroon, []);
  end;
end;

{
  Diese Methode setzt den Schriftstil des TreeViewers.

  ~param Sender Das Objekt, von dem das Change Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.cbFontStyleChange(Sender: TObject);
begin
  case cbFontStyle.ItemIndex of
    0: begin
         Self.imgTreeViewer.SetFontStyle([]);
       end;
    1: begin
         Self.imgTreeViewer.SetFontStyle([fsBold]);
       end;
    2: begin
         Self.imgTreeViewer.SetFontStyle([fsItalic]);
       end;
    3: begin
         Self.imgTreeViewer.SetFontStyle([fsBold, fsItalic]);
       end;
  end;
end;

{
  Diese Methode läd eine neue Spachdatei und initiiert die Aktualisierung
  der GUI Element.

  ~param Sender Das Objekt, von dem das Change-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.cbLanguageChange(Sender: TObject);
begin
  case cbLanguage.ItemIndex of
    0: begin
         Self.resourceManager.LoadLanguageFile(GERMAN_LANG);
         btnMemTest.Enabled := true;
         InitLabels;
       end;
    1: begin
         Self.resourceManager.LoadLanguageFile(ENGLISH_LANG);
         btnMemTest.Enabled := false;
         InitLabels;
       end;
  end;
end;

{
  Diese Methode setzt die Anzeige des Suchpfades. Ist die CheckBox auf true,
  so wird der Suchpfad angezeigt, ansonsten wird er ausgeblendet.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.chbShowPathClick(Sender: TObject);
begin
  Self.showPath := chbShowPath.Checked;
end;

{
  Diese Methode setzt die Wartezeit, die nach jedem Highlighting eines Knotens
  im TreeViewer gewatet werden soll.

  ~param Sender Das Objekt, von dem das Change Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.edtDelayChange(Sender: TObject);
var delay : Integer;
begin
  try
    delay := StrToInt(edtDelay.Text);
    if(delay < 0) then
      ShowInfoBoxMsg('onlyPositiveValuesMsg', clMaroon, [])
    else
      Self.imgTreeViewer.SetHighlightDelay(delay);
  except
    on EConvertError do
    begin
      ShowInfoBoxMsg('onlyPositiveValuesMsg', clMaroon, []);
    end;
  end;
end;

{
  Diese Methode setzt im TreeViewer die Dicke der Linien. Der Wert wird nur
  dann gesetzt, wenn er gültig ist. Der gültige Wertebereich ist [1, 9].

  ~param Sender Das Objekt, von dem das Change Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.edtLineSizeChange(Sender: TObject);
var lineSize : Integer;
begin
  try
    lineSize := StrToInt(edtLineSize.Text);
    if(lineSize < 1) then
      ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, [1,9])
    else
      Self.imgTreeViewer.SetLineSize(lineSize);
  except
    on EConvertError do
    begin
      ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, [1,9]);
    end;
  end;
end;

{
  Diese Methode setzt den Radius aller Knoten im TreeViewer. Der Wert wird
  nur dann gesetzt, wenn er gültig ist. Der gültige Wertebereich ist [10, 50].
  
  ~version 2.0
}
procedure TfrmBaumDemo.edtNodeRadiusChange(Sender: TObject);
var nodeRadius : Integer;
begin
  try
    nodeRadius := StrToInt(edtNodeRadius.Text);
    if(nodeRadius < 10) or (nodeRadius > 50) then
      ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, [10,50])
    else
      Self.imgTreeViewer.SetNodeRadius(nodeRadius);
  except
    on EConvertError do
    begin
      ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, [10,50]);
    end;
  end;
end;

{
  Diese Methode aktualisiert die Größe der Zeichnfläche, sobald sich die Größe
  des Formulars ändert.

  ~param Sender Das Objekt, von dem das Resize-Ereignis stammt.
  ~version 2.0
}
procedure TfrmBaumDemo.FormResize(Sender: TObject);
begin
  Self.imgTreeViewer.Top := 10;
  Self.imgTreeViewer.Left := 376;
  Self.imgTreeViewer.Height := ClientHeight - Self.imgTreeViewer.Top - 10;
  Self.imgTreeViewer.Width := ClientWidth - Self.imgTreeViewer.Left - 10;

  if(Self.imgTreeViewer.Width < 0) then
    Self.imgTreeViewer.Width := 0;

  if(Self.imgTreeViewer.Height < 0) then
    Self.imgTreeViewer.Height := 0;

  if(Self.imgTreeViewer.Picture.Graphic <> nil) then
  begin
    Self.imgTreeViewer.Picture.Graphic.Width := imgTreeViewer.Width;
    Self.imgTreeViewer.Picture.Graphic.Height := imgTreeViewer.Height;
  end;
  Self.imgTreeViewer.PaintTree;
end;

procedure TfrmBaumDemo.imgSignaturBlauClick(Sender: TObject);
var frmInfoBox : TfrmInfoBox;
begin
  frmInfoBox := TfrmInfoBox.Create(Self);
  frmInfoBox.Position := poScreenCenter;
  frmInfoBox.ShowModal;
end;

procedure TfrmBaumDemo.imgSignaturBlauMouseLeave(Sender: TObject);
begin
  imgSignaturBlau.Visible := False;
end;

procedure TfrmBaumDemo.imgSignaturMouseEnter(Sender: TObject);
begin
  imgSignaturBlau.Visible := True;
end;

{
  Dieser Timer dient als Tester für die einzelnen Baumfunktionalitäten.
  Insbesondere für das Löschen von Elementen aus dem Baum. Es werden zufällige
  Zahlen generiert, die in den Baum eingefügt werden. Hat der Baum eine
  gewisse Größe erreicht, so werden zufällig alle Elemente wieder aus dem
  Baum gelöscht. Danach geht es wieder von vorne los.

  ~param Sender Das Objekt, von dem das Timer Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.randomTesterTimer(Sender: TObject);
var randomNo : Integer;                        // Zufallswert für neue Knoten
    count    : Integer;                        // Max. Anzahl an Elementen im Baum
begin
  try
    Randomize;
    count := StrToInt(edtCount.Text);
    randomNo := Random(count);
    if(root = nil) then                        // Erzeuge neue Wurzel
    begin
      btnClear.Click;
      edtInput.Text := inttostr(randomNo);
      btnNewRoot.Click;
      btnInorder.Click;
      Self.remove := false;
      Exit;
    end;

    if(Self.treeCount >= count) then          // Maximale Knotenzahl erreicht
    begin
      Self.remove := true;
    end;

    if(Self.remove) then                       // Lösche Knoten
    begin
      btnClear.Click;
      edtInput.Text := inttostr(randomNo);
      btnDel.Click;
      btnInorder.Click;
      Exit;
    end;

    if(not Self.remove) then                   // Füge neuen Knoten ein
    begin
      btnClear.Click;
      edtInput.Text := inttostr(randomNo);
      btnNewElement.Click;
      btnInorder.Click;
      Exit;
    end;
  except
    on E : Exception do
    begin
      randomTester.Interval := 0;
      showmessage(E.Message);
    end;
  end;
end;

{
  Diese Methode stellt die Geschwindigkeit des randomTester Timers ein.

  ~param Sender Das Objekt, von dem das Change-Ereignis kommt.
  ~version 2.0
}
procedure TfrmBaumDemo.trbTestModeSpeedChange(Sender: TObject);
begin
  if(trbTestModeSpeed.Position = 10) then
    randomTester.Interval := 0
  else if(trbTestModeSpeed.Position = 0) then
  begin
    randomTester.Interval := 1;
    Self.imgTreeViewer.SetHighlightDelay(0);
  end
  else if(trbTestModeSpeed.Position = 1) then
  begin
    randomTester.Interval := 100;
    Self.imgTreeViewer.SetHighlightDelay(0);
  end
  else
  begin
    randomTester.Interval := (trbTestModeSpeed.Position - 1) * 1000;
    edtDelayChange(trbTestModeSpeed);
  end;
end;

{
  Diese Methode ermöglicht es neue Elemente per ENTER Taste hinzuzufügen,
  ohne das Textfeld verlassen zu müssen und auf den entsprechenden Button
  klicken zu müssen.
  ~param Sender Das Objekt, von dem das KeyUp-Ereignis kommt.
  ~param Key Die Taste, die gedrückt wurde.
  ~param Shift Flag, welches angibt ob die Shift, Strg oder Alt Taste gedrückt
               wurde.
  ~param version 1.0
}
procedure TfrmBaumDemo.edtInputKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if(Key = 13) then
  begin
    if(Self.root = nil) then
      btnNewRootClick(edtInput)
    else
      btnNewElementClick(edtInput);

    edtInput.Clear;
  end;
end;


// ************************************************************************
// *     PRIVATE: Ab hier sind alle private-Methoden                      *
// ************************************************************************

{
  Diese Methode erzeugt ein neues Pointerelement und weist diesem die
  übergebenen Werte zu.

  ~param data Der Datenwert des neuen Pointerelements.
  ~return Ein neues Pointerelement
  ~version 1.1
}
procedure TfrmBaumDemo.createNewPointer(var element : TElement; data : Integer);
begin
  element := nil;
  new(element);
  element^.Data   := data;
  element^.XCoord := 0;
  element^.YCoord := 0;
  element^.LS     := nil;
  element^.RS     := nil;
  Inc(treeCount);
end;

{
  Diese Methode prüft, ob bereits ein root vorhanden ist. Ist dies der Fall,
  so wird der Benutzer gefragt, ob der alte Baum gelöscht und ein neuer Baum
  erzeugt werden soll. Wählt der Benutzer nein aus, so wird der alte Baum
  behalten und die übergebenen Daten verworfen ohne eine neue Wurzel zu
  erstellen.

  ~param data Der Inhalt des neuen Root
  ~version 1.1
}
procedure TfrmBaumDemo.CreateNewRoot(data : Integer);
var msg    : String;                           // Benutzermeldung
    answer : Integer;                          // Antwort des Nutzers

    procedure NewRoot();
    begin
      CreateNewPointer(Self.root, data);
      if(Self.paintingMode) then
      begin
        Self.imgTreeViewer.SetRoot(Self.root);
        Self.imgTreeViewer.HighlightElement(Self.root, clLime);
      end;
      btnClearClick(Self);
      ShowInfoBoxMsg('newRootCreatedMsg', clGreen, [Self.root^.Data]);
    end;
begin
  if(Self.root = nil) then
  begin   // Falls noch kein Root vorhanden ist, so erstelle ein neues Root
    NewRoot();
  end
  else
  begin   // Falls schon ein Root vorhanden ist, so frage den Nutzer, ob
          // der alte Baum gelöscht werden soll.

    answer := MessageDlg(Self.resourceManager.GetString('deleteOldTreeMsg'),
              mtConfirmation, [mbYes, mbNo], 0);
    case answer of
      mrYes : begin
                DeleteTree(Self.root);
                NewRoot();
              end;
      mrNo  : begin
                ShowInfoBoxMsg('noRootCreatedMsg', clGreen, []);
              end;
    end;
  end;
end;

{
  Diese Methode sucht rekursiv nach dem zu löschenden Element und löscht dieses.
  Dabei sind 3 Fälle zu unterscheiden:
  1) Ist das Element ein Blatt,
  so lösche es
  2) Ist das Element ein Knoten mit nur einem Teilbaum,
  so biege den Zeiger des Elternknotens auf den einen Sohn um und lösche
  das Element.
  3) Ist das Element ein Knoten mit zwei Teilbäumen,
  so nimm das kleinste Element aus dem rechten Teilbaum und setze es an die
  Stelle, an der das zu löschende Element sitzt. Lösche anschließend das
  Element, welches gerade kopiert wurde von seiner ursprünglichen Position.

  ~param parent Der Elternknoten vom element
  ~param element Aktuell besuchter Knoten
  ~param data Datenwert des zu löschenden Knotens
  ~version 2.0
}
procedure TfrmBaumDemo.deleteElement(var parent : TElement; var element : TElement;
                                     data : Integer);
var smallestElement : TElement;
    rememberData    : Integer;
    rememberPointer : TElement;
begin
  if(element = nil) then Exit;                 // Von Nichts kommt Nichts ;-)
  rememberPointer := nil;
  rememberData := 0;

  if(Self.showPath) and (Self.paintingMode) then
    Self.imgTreeViewer.HighlightElement(element, clAqua);

  if(element^.Data = data) then                // Zu löschendes Element gefunden
  begin
                                               // 1) Fall: Element ist ein Blatt
    if(element^.LS = nil) and (element^.RS = nil) then
    begin
      ShowInfoBoxMsg('leafDeleted', clGreen, [element^.Data]);
      if(Self.paintingMode) then
        Self.imgTreeViewer.HighlightElement(element, clRed);

      if(parent <> nil) then
      begin
        if(element^.Data < parent^.Data) then  // Setze linken Zeiger des Eltern
        begin                                  // Knotens auf nil, sofern element
          DeletePointer(element);              // Sohn vom linken Teilbaum ist.
          parent^.LS := nil;
        end
        else                                   // Setze rechten Zeiger des Eltern
        begin                                  // Knotens auf nil, sofern element
          DeletePointer(element);              // Sohn vom rechten Teilbaum ist.
          parent^.RS := nil;
        end;
      end
      else
        DeletePointer(element);
        
      if(Self.paintingMode) then
        Self.imgTreeViewer.SetRoot(Self.root);
      Exit;
    end;

                                               // 2) Fall a: Element ist ein
                                               // Knoten mit nur rechtem Teilbaum
    if(element^.LS = nil) and (element^.RS <> nil) then
    begin
      if(Self.paintingMode) then
        Self.imgTreeViewer.HighlightElement(element, clRed);

      if(element = Self.root) then             // Falls das aktuelle Element der
      begin                                    // root ist, so aktualisiere diesen
        ShowInfoBoxMsg('rootDeleted', clGreen, [Self.root^.Data]);
        rememberPointer := Self.root^.RS;
        DeletePointer(Self.root);
        Self.root := rememberPointer;
        rememberPointer := nil;

        if(Self.paintingMode) then
          Self.imgTreeViewer.SetRoot(Self.root);
        Exit;
      end;

      ShowInfoBoxMsg('nodeDeleted', clGreen, [element^.Data]);
      if(parent <> nil) then
      begin
        if(element^.Data < parent^.Data) then  // Setze linken Zeiger des Eltern
        begin                                  // Knotens auf den rechten Teilbaum
          rememberPointer := element^.RS;      // des Elements.
          DeletePointer(element);
          parent^.LS := rememberPointer;
        end;
        if(element^.Data > parent^.Data) then  // Setze rechten Zeiger des Eltern
        begin                                  // Knotens auf den rechten Teilbaum
          rememberPointer := element^.RS;      // des Elements.
          DeletePointer(element);
          parent^.RS := rememberPointer;
        end;
      end;
      if(Self.paintingMode) then
        Self.imgTreeViewer.PaintTree;
      Exit;
    end;

                                               // 2) Fall b: Element ist ein
                                               // Knoten mit nur linkem Teilbaum
    if(element^.LS <> nil) and (element^.RS = nil) then
    begin
      if(Self.paintingMode) then
        Self.imgTreeViewer.HighlightElement(element, clRed);

      if(element = Self.root) then             // Falls das aktuelle Element der
      begin                                    // root ist, so aktualisiere diesen
        ShowInfoBoxMsg('rootDeleted', clGreen, [Self.root^.Data]);
        rememberPointer := Self.root^.LS;
        DeletePointer(Self.root);
        Self.root := rememberPointer;
        rememberPointer := nil;

        if(Self.paintingMode) then
          Self.imgTreeViewer.SetRoot(Self.root);
        Exit;
      end;

      ShowInfoBoxMsg('nodeDeleted', clGreen, [element^.Data]);
      if(parent <> nil) then
      begin
        if(element^.Data < parent^.Data) then  // Setze linken Zeiger des Eltern
        begin                                  // Knotens auf den linken Teilbaum
          rememberPointer := element^.LS;      // des Elements.
          DeletePointer(element);
          parent^.LS := rememberPointer;
          rememberPointer := nil;
        end;
        if(element^.Data > parent^.Data) then  // Setze rechten Zeiger des Eltern
        begin                                  // Knotens auf den linken Teilbaum
          rememberPointer := element^.LS;      // des Elements.
          DeletePointer(element);
          parent^.RS := rememberPointer;
          rememberPointer := nil;
        end;
      end;
      if(Self.paintingMode) then
        Self.imgTreeViewer.PaintTree;
      Exit;
    end;

                                               // 3) Fall: Element ist ein
                                               // Knoten mit zwei Teilbäumen
    if(element^.LS <> nil) and (element^.RS <> nil) then
    begin
      if(Self.paintingMode) then
        Self.imgTreeViewer.HighlightElement(element, clYellow);

      smallestElement := findSmallestElement(element^.RS);
      rememberData := smallestElement^.Data;
      deleteElement(element, element^.RS, smallestElement^.Data);
      ShowInfoBoxMsg('nodeReplaced', clGreen, [element^.Data, rememberData]);
      element^.Data := rememberData;
      smallestElement := nil;
      rememberData := 0;

      if(Self.paintingMode) then
        Self.imgTreeViewer.PaintTree;
    end;
  end
  else                                         // Suche weiter nach dem
  begin                                        // richtigen Element
    if(data < element^.Data) then
    begin
      DeleteElement(element, element^.LS, data);
    end;

    if(data > element^.Data) then
    begin
      DeleteElement(element, element^.RS, data);
    end;
  end;
end;

{
  Diese Methode löscht ein einzelnes übergebenen Zeiger auf ein Element.

  ~param element Der Zeiger auf das zu löschende Element
  ~version 1.1
}
procedure TfrmBaumDemo.DeletePointer(var element : TElement);
begin
  element^.Data   := 0;
  element^.XCoord := 0;
  element^.YCoord := 0;
  element^.LS     := nil;
  element^.RS     := nil;
  Dispose(element);
  element := nil;

  Dec(treeCount);
end;

{
  Diese Methode löscht alle Elemente eines Baumes, ab dem übergebenen Knoten.

  ~param element Zu löschender Knoten mit allen Unterknoten.
  ~version 1.0
}
procedure TfrmBaumDemo.DeleteTree(var element : TElement);
begin
  if(element <> nil) then
  begin
    if(element^.LS <> nil) then
    begin                                      // Lösche linken Teilbaum
      DeleteTree(element^.LS);
    end;

    if(element^.RS <> nil) then
    begin                                      // Lösche rechten Teilbaum
      DeleteTree(element^.RS);
    end;

    if(element^.LS = nil) and (element^.RS = nil) then
    begin                                      // Lösche Blatt
      DeletePointer(element);
    end;
  end;
end;

{
  Diese Methode liefert das kleinste Element eines Baumes.

  ~param element Das aktuell betrachtete Element
  ~param data Wert des aktuellen Elements
  ~return Das Element mit dem kleinsten Wert
  ~version 2.0
}
function TfrmBaumDemo.findSmallestElement(element : TElement) : TElement;
begin
  if(element = nil) then
  begin
    Result := nil;
    Exit;
  end;

  while(element^.LS <> nil) do                 // Das kleinste Element ist das
  begin                                        // Element welches keinen linken
    element := element^.LS;                    // Sohn mehr hat.
  end;
  Result := element;
end;

{
  Diese Methode setzt die Beschriftungen aller GUI Elemente.

  ~version 1.1
}
procedure TfrmBaumDemo.InitLabels();
var lastItemIndex : Integer;
begin
  frmBaumDemo.Caption   := resourceManager.GetString('windowTitle');

  btnClear.Caption            := resourceManager.GetString('clear');
  btnNewRoot.Caption          := resourceManager.GetString('newRoot');
  btnNewElement.Caption       := resourceManager.GetString('newElement');
  btnInorder.Caption          := resourceManager.GetString('inorder');
  btnPreorder.Caption         := resourceManager.GetString('preorder');
  btnPostorder.Caption        := resourceManager.GetString('postorder');
  btnNodeColorChoose.Caption  := resourceManager.GetString('choose');
  btnBackgroundChoose.Caption := resourceManager.GetString('choose');
  btnMemTest.Caption          := resourceManager.GetString('memTest');
  btnClose.Caption            := resourceManager.GetString('close');
  btnPaint.Caption            := resourceManager.GetString('paintOn');
  btnDel.Caption              := resourceManager.GetString('delete');

  lblInput.Caption      := resourceManager.GetStringWithSeparator('input');
  lblOutput.Caption     := resourceManager.GetStringWithSeparator('output');
  lblLineSize.Caption   := resourceManager.GetStringWithSeparator('lineSize');
  lblFontStyle.Caption  := resourceManager.GetStringWithSeparator('fontStyle');
  lblNodeRadius.Caption := resourceManager.GetStringWithSeparator('nodeRadius');
  lblDelay.Caption      := resourceManager.GetStringWithSeparator('delayForTags');
  lblMillisec.Caption   := resourceManager.GetString('msec');
  lblNodeColor.Caption  := resourceManager.GetStringWithSeparator('nodeColor');
  lblBackgroundColor.Caption := resourceManager.GetStringWithSeparator('backgroundColor');
  lblCount.Caption      := resourceManager.GetStringWithSeparator('count');
  lblShowPath.Caption   := resourceManager.GetStringWithSeparator('showPath');
  lblTestModeSpeed.Caption   := resourceManager.GetStringWithSeparator('speed');

  gbxPaintConfig.Caption := resourceManager.GetStringWithSeparator('graphicsSettings');
  gbxTestmode.Caption    := resourceManager.GetStringWithSeparator('testMode');
  gbxInfoBox.Caption     := resourceManager.GetStringWithSeparator('infoBox');

  lastItemIndex := cbLanguage.ItemIndex;
  cbLanguage.Clear;
  cbLanguage.Items.Add(resourceManager.GetString('german'));
  cbLanguage.Items.Add(resourceManager.GetString('english'));
  cbLanguage.ItemIndex := lastItemIndex;

  lastItemIndex := cbFontStyle.ItemIndex;
  cbFontStyle.Clear;
  cbFontStyle.Items.Add(resourceManager.GetString('normal'));
  cbFontStyle.Items.Add(resourceManager.GetString('bold'));
  cbFontStyle.Items.Add(resourceManager.GetString('italic'));
  cbFontStyle.Items.Add(resourceManager.GetString('boldAndItalic'));
  cbFontStyle.ItemIndex := lastItemIndex;

  ShowInfoBoxMsg(Self.lastActionKey, Self.lastActionColor,
                 Self.lastActionArguments);
end;

{
  Diese Methode erzeugt ein neues Element und fügt dieses in den Baum an die
  korrekte Stelle ein. Ist der Wert des Elements kleiner als der des Parent
  Elements, so wird das Element im linken Teilbaum eingebaut. Ist der Wert des
  Elements größer als der des Parent Elements. Es wird kein Element doppelt in
  den Baum eingefügt!

  ~param element Ein Element im Baum
  ~param data Der Wert des neuen Elements
  ~version 1.0
}
procedure TfrmBaumDemo.InsertNewElement(element : TElement; data : Integer);
var newElement : TElement;
    dataValue  : Integer;
begin
  if(element = nil) then Exit;

  if(Self.showPath) and(Self.paintingMode) then
    Self.imgTreeViewer.HighlightElement(element, clAqua);

  if(data < element^.Data) then                // Das Element muss im linken
  begin                                        // Teilbaum eingefügt werden

    if(element^.LS <> nil) then                // Falls das aktuelle Element kein
    begin                                      // Blatt ist gehe zum nächsten
      InsertNewElement(element^.LS, data);
    end
    else                                       // Ansonsten füge ein neues
    begin                                      // Element links ein
      CreateNewPointer(newElement, data);
      element^.LS := newElement;
      if(Self.paintingMode) then
        Self.imgTreeViewer.HighlightElement(newElement, clLime);
      ShowInfoBoxMsg('newElementAddedMsg', clGreen, [newElement^.Data]);
    end;
  end

  else if(data > element^.data) then           // Das Element muss im rechten
  begin                                        // Teilbaum eingefügt werden

    if(element^.RS <> nil) then                // Falls das aktuelle Element kein
    begin                                      // Blatt ist gehe zum nächsten
      InsertNewElement(element^.RS, data);
    end
    else                                       // Ansonsten füge ein neues
    begin                                      // Element rechts ein
      CreateNewPointer(newElement, data);
      element^.RS := newElement;
      if(Self.paintingMode) then
        Self.imgTreeViewer.HighlightElement(newElement, clLime);
      ShowInfoBoxMsg('newElementAddedMsg', clGreen, [newElement^.Data]);
    end;
  end

  else                                         // Das einzufügende Element ist
  begin                                        // ist bereits im Baum enthalten
    ShowInfoBoxMsg('elementAlreadyExistMsg', clMaroon, [data]);
  end;
end;

{
  Diese Methode gibt einen Text in der Infobox aus.

  ~param msg Der .properties Key für den Text, der angezeigt werden soll.
  ~param color Die Schriftfarbe
  ~param arguments Ein Array mit Argumenten, die in den Text eingebaut werden
  ~version 1.0
}
procedure TfrmBaumDemo.ShowInfoBoxMsg(key : String; color : TColor;
                                      arguments : Array of const);
var i : Integer;
begin
  lblActionMsg.Font.Color := color;
  lblActionMsg.Caption := Format(Self.resourceManager.GetString(key), arguments);

  Self.lastActionKey       := key;
  Self.lastActionColor     := color;
  SetLength(Self.lastActionArguments, Length(arguments));
  for i := 0 to Length(arguments) - 1 do
  begin
    Self.lastActionArguments[i] := arguments[i];
  end;
end;

{
  Diese Methode traversiert den Baum nach dem in-order Prinzip und zeigt das
  Ergebnis in dem Ausgabefenster an.

  ~param element Der aktuell betrachtete Knoten (Blatt)
  ~version 1.0
}
procedure TfrmBaumDemo.ShowInOrder(element : TElement);
begin
  if(element = nil) then Exit;

  if(element^.LS <> nil) then
  begin
    ShowInOrder(element^.LS);
  end;

  lbxOutput.Items.Add(IntToStr(element^.Data));

  if(element^.RS <> nil) then
  begin
    ShowInOrder(element^.RS);
  end;
end;

{
  Diese Methode traversiert den Baum nach dem post-order Prinzip und zeigt das
  Ergebnis in dem Ausgabefenster an.

  ~param element Der aktuell betrachtete Knoten (Blatt)
  ~version 1.0
}
procedure TfrmBaumDemo.ShowPostOrder(element : TElement);
begin
  if(element = nil) then Exit;

  if(element^.LS <> nil) then
  begin
    ShowPostOrder(element^.LS);
  end;

  if(element^.RS <> nil) then
  begin
    ShowPostOrder(element^.RS);
  end;

  lbxOutput.Items.Add(IntToStr(element^.Data));
end;

{
  Diese Methode traversiert den Baum nach dem pre-order Prinzip und zeigt das
  Ergebnis in dem Ausgabefenster an.

  ~param element Der aktuell betrachtete Knoten (Blatt)
  ~version 1.0
}
procedure TfrmBaumDemo.ShowPreOrder(element : TElement);
begin
  if(element = nil) then Exit;

  lbxOutput.Items.Add(IntToStr(element^.Data));

  if(element^.LS <> nil) then
  begin
    ShowPreOrder(element^.LS);
  end;

  if(element^.RS <> nil) then
  begin
    ShowPreOrder(element^.RS);
  end;
end;

end.
