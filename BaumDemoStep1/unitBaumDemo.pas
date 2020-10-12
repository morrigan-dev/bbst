{
  Dieses Programm ist Teil eines Schulprojekts der Carl-Benz Schule Koblenz.
  Diese Version stellt den Schritt 1 des Projekts dar, in dem der allgemeine
  Aufbau von Bäumen realisiert ist.

  Folgene Funktionalitäten sind in dieser Version realisiert:
    - Anlegen einer neuen Baumwurzel
    - Hinzufügen eines neuen Elements in den bestehenden Baum
    - Löschen des gesamten Baumes
    - In-order Traverierung des Baumes
    - Pre-order Traversierung des Baumes
    - Post-order Traversierung des Baumes
    - Sprachwechsel

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

  Compiler: Delphi 6.0

  ~author Thomas Gattinger
  ~version 1.0
}
unit unitBaumDemo;

interface

uses
  // Delphi Klassen
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,

  // Eigene Klassen
  unitResourceManager;

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
    Data : Integer;                          // Datenwert des Elements
    LS   : TElement;                         // Zeiger auf den linken Sohn
    RS   : TElement;                         // Zeiger auf den rechten Sohn

    // Diese Zeile einkommentieren, um den Speicherverbrauch zu testen.
    // VORSICHT: Der Speicher wird sehr schnell voll... ;-)
    //
    memTest : Array[0..100] of Array[0..100] of Array[0..100] of String;
  end;

  TfrmBaumDemo = class(TForm)                // Dieser Typ ist für das Formular
    btnClear         : TButton;              // zuständig, auf dem sich alle
    btnClose         : TButton;              // GUI Element befinden.
    btnDel           : TButton;
    btnInorder       : TButton;
    btnNewElement    : TButton;
    btnNewRoot       : TButton;
    btnPaint         : TButton;
    btnPostorder     : TButton;
    btnPreorder      : TButton;
    cbLanguage       : TComboBox;
    edtInput         : TEdit;
    gbxInfoBox       : TGroupBox;
    lblActionMsg     : TLabel;
    lblInput         : TLabel;
    lblOutput        : TLabel;
    lbxOutput        : TListBox;
    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnInorderClick(Sender: TObject);
    procedure btnNewElementClick(Sender: TObject);
    procedure btnNewRootClick(Sender: TObject);
    procedure btnPostorderClick(Sender: TObject);
    procedure btnPreorderClick(Sender: TObject);
    procedure cbLanguageChange(Sender: TObject);
    procedure edtInputKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private { Private declarations }
    lastActionArguments : Array of TVarRec;  // Letzte Argumentenliste
    lastActionColor     : TColor;            // Letzte Farbe in der Infobox
    lastActionKey       : String;            // Letzter key in der Infobox
    resourceManager     : TResourceManager;  // Lädt alle Beschriftungen

    procedure CreateNewRoot(data : Integer);
    function  CreateNewPointer(data : Integer) : TElement;
    procedure DeletePointer(var element : TElement);
    procedure DeleteTree(var element : TElement);
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

var
  frmBaumDemo : TfrmBaumDemo;                // Instanz dieser Klasse
  root        : TElement;                    // Wurzel des aktuellen Baumes

implementation

{$R *.dfm}


// ************************************************************************
// *     PUBLIC: Ab hier sind alle public-Methoden                        *
// ************************************************************************

{
  Dieser Konstruktor erzeugt eine Instanz dieser Klassen und setzt das Root
  Element des Baumes auf nil. Außerdem werden die deutschen Beschriftungen
  aus der entsprechenden .properties Datei geladen.

  ~param AOwner Das Objekt, das der Besitzer diese Formulars ist.
  ~version 1.0
}
constructor TfrmBaumDemo.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  root := nil;
  Self.lastActionKey := '';
  Self.lastActionColor := clGreen;
  SetLength(Self.lastActionArguments, 0);

  Self.resourceManager := TResourceManager.NewInstance;
  Self.resourceManager.LoadLanguageFile(GERMAN_LANG);
  InitLabels();
end;

{
  Dieser Destruktor löscht den aktuellen Baum und gibt alle Resourcen sowie
  die Instanz dieser Klasse wieder frei.

  ~version 1.0
}
destructor TfrmBaumDemo.Destroy();
begin
  DeleteTree(root);
  Self.resourceManager.FreeInstance;

  inherited Destroy();
end;


// ************************************************************************
// *     PUBLISHED: Ab hier sind alle published-Methoden                  *
// ************************************************************************

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
  Diese Methode initiert die in-order Traversierung.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnInorderClick(Sender: TObject);
begin
  if(root <> nil) then
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
  if(root <> nil) then
  begin
    try
      data := StrToInt(edtInput.Text);

      InsertNewElement(root, data);
    except
      on EConvertError do
      begin
        ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, []);
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
      ShowInfoBoxMsg('onlyNumberValuesMsg', clMaroon, []);
    end;
  end;

  edtInput.SetFocus;
end;

{
  Diese Methode initiert die post-order Traversierung.

  ~param Sender Das Objekt, von dem das Click-Ereignis kommt.
  ~version 1.0
}
procedure TfrmBaumDemo.btnPostorderClick(Sender: TObject);
begin
  if(root <> nil) then
  begin
    lbxOutput.Clear;
    lblOutput.Caption := Self.resourceManager.GetStringWithSeparator('outputPostorder');
    ShowPostOrder(root);
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
  if(root <> nil) then
  begin
    lbxOutput.Clear;
    lblOutput.Caption := Self.resourceManager.GetStringWithSeparator('outputPreorder');
    ShowPreOrder(root);
  end
  else
  begin
    ShowInfoBoxMsg('noTreeExist', clMaroon, []);
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
         InitLabels;
       end;
    1: begin
         Self.resourceManager.LoadLanguageFile(ENGLISH_LANG);
         InitLabels;
       end;
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
    if(root = nil) then
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
  ~version 1.0
}
function TfrmBaumDemo.CreateNewPointer(data : Integer) : TElement;
begin
  Result := nil;
  new(Result);
  Result^.Data := data;
  Result^.LS   := nil;
  Result^.RS   := nil;
end;

{
  Diese Methode prüft, ob bereits ein root vorhanden ist. Ist dies der Fall,
  so wird der Benutzer gefragt, ob der alte Baum gelöscht und ein neuer Baum
  erzeugt werden soll. Wählt der Benutzer nein aus, so wird der alte Baum
  behalten und die übergebenen Daten verworfen ohne eine neue Wurzel zu
  erstellen.

  ~param data Der Inhalt des neuen Root
  ~version 1.0
}
procedure TfrmBaumDemo.CreateNewRoot(data : Integer);
var msg    : String;                           // Benutzermeldung
    answer : Integer;                          // Antwort des Nutzers
begin
  if(root = nil) then
  begin   // Falls noch kein Root vorhanden ist, so erstelle ein neues Root
    root := CreateNewPointer(data);
    btnClearClick(Self);
    ShowInfoBoxMsg('newRootCreatedMsg', clGreen, [root^.Data]);
  end
  else
  begin   // Falls schon ein Root vorhanden ist, so frage den Nutzer, ob
          // der alte Baum gelöscht werden soll.

    answer := MessageDlg(Self.resourceManager.GetString('deleteOldTreeMsg'),
              mtConfirmation, [mbYes, mbNo], 0);
    case answer of
      mrYes : begin
                DeleteTree(root);
                root := CreateNewPointer(data);
                btnClearClick(Self);
                ShowInfoBoxMsg('newRootCreatedMsg', clGreen, [root^.Data]);
              end;
      mrNo  : begin
                ShowInfoBoxMsg('noRootCreatedMsg', clGreen, []);
              end;
    end;
  end;
end;

{
  Diese Methode löscht ein einzelnes übergebenen Zeiger auf ein Element.

  ~param element Der Zeiger auf das zu löschende Element
  ~version 1.0
}
procedure TfrmBaumDemo.DeletePointer(var element : TElement);
begin
  element^.Data   := 0;
  element^.LS     := nil;
  element^.RS     := nil;
  Dispose(element);
  element := nil;
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
  Diese Methode setzt die Beschriftungen aller GUI Elemente.

  ~version 1.0
}
procedure TfrmBaumDemo.InitLabels();
begin
  frmBaumDemo.Caption   := resourceManager.GetString('windowTitle');
  btnClear.Caption      := resourceManager.GetString('clear');
  lblInput.Caption      := resourceManager.GetStringWithSeparator('input');
  lblOutput.Caption     := resourceManager.GetStringWithSeparator('output');
  btnNewRoot.Caption    := resourceManager.GetString('newRoot');
  btnNewElement.Caption := resourceManager.GetString('newElement');
  btnInorder.Caption    := resourceManager.GetString('inorder');
  btnPreorder.Caption   := resourceManager.GetString('preorder');
  btnPostorder.Caption  := resourceManager.GetString('postorder');
  gbxInfoBox.Caption    := resourceManager.GetStringWithSeparator('infoBox');
  btnClose.Caption      := resourceManager.GetString('close');
  btnPaint.Caption      := resourceManager.GetString('paint');
  btnDel.Caption        := resourceManager.GetString('delete');
  ShowInfoBoxMsg(Self.lastActionKey, Self.lastActionColor, Self.lastActionArguments);
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
  if(data < element^.Data) then                // Das Element muss im linken
  begin                                        // Teilbaum eingefügt werden

    if(element^.LS <> nil) then                // Falls das aktuelle Element kein
    begin                                      // Blatt ist gehe zum nächsten
      InsertNewElement(element^.LS, data);
    end
    else                                       // Ansonsten füge ein neues
    begin                                      // Element links ein
      newElement := CreateNewPointer(data);
      element^.LS := newElement;
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
      newElement := CreateNewPointer(data);
      element^.RS := newElement;
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
