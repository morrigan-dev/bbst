{
  Diese Klasse stellt ein TImage Objekt zur Verfügung, dass einen übergebenen
  Binärbaum auf sich selbst zeichnet. Zum Zeichnen wird der Reingold & Tilford
  Algorithmus verwendet.

  Der Reingold & Tilford Algorithmus berücksichtigt die ersten fünf ästetischen
  Kriterien beim Zeichnen von Bäumen.

  (A1) Die y-Koordinate eines Knotens entspricht dem Level des Knotens.
  (A2) Die Kanten kreuzen sich nicht und Knoten auf dem selben Level haben einen
       vorgegebenen horizontalen Minimalabstand.
  (A3) Unterbäume, die strukturgleich sind, werden bis auf Verschiebung gleich
       gezeichnet.
  (A4) Die Reihenfolge der Kinder eines Knotens wird in der Zeichnung dargestellt.
  (A5) Der Zeichenalgorithmus arbeitet symmetrisch, das heißt, dass die
       Zeichnung der Spiegelung des Baumes gleich der Spiegelung des
       gezeichneten Baumes ist.

  Quellen:
   - Der Reingold - Tilford Algorithmus von R.P. Herpel (Archenhold Oberschule)
     Link: http://www.g-ymnasium.de/images/Informatik/Tilford/baeume.pdf
     (19.10.2010 - 12:50 Uhr)

   - Zeichnen von Bäumen von Juenger (Uni-Köln)
     Link: http://www.informatik.uni-koeln.de/ls_juenger/teaching/ss_09/gd/graph_2.pdf
     (19.10.2010 - 12:50 Uhr)

   - Zeichnen von Graphen / graph drawing
     von Christian Becker, Eugen Plischke, Vadim Filippov
     Link: http://www.gm.fh-koeln.de/~hk/lehre/ala/ws0607/Referate/D_rot_graph_drawing.pdf
     (19.10.2010 - 12:50 Uhr)


  Compiler: Delphi 6.0

  ~author Thomas Gattinger
  ~version 2.0
}
unit unitTreeViewer;

interface

uses
  // Delphi Klassen
  Classes, ExtCtrls, Dialogs, SysUtils, Math, Graphics,
  
  // Eigene Klassen
  unitElement;

type

  TInsets = record
    left   : Integer;
    top    : Integer;
    right  : Integer;
    bottom : Integer;
  end;  

  TTreeViewer = class(TImage)

  private { Private declarations }
    backgroundColor    : TColor;               // Hintergrundfarbe
    root               : TElement;             // Wurzel des Baumes
    fontStyle          : TFontStyles;          // Style der Schrift
    highlightColor     : TColor;               // Farbe des Highlightings
    highlightDelay     : Integer;              // Wartezeit in Millisekunden
    highlightedElement : TElement;             // Hervorzuhebenes Element
    insets             : TInsets;              // Abstand zum Rand
    lineSize           : Integer;              // Dicke der Linien
    nodeColor          : TColor;               // Hintergrundfarbe eines Knotens
    nodeRadius         : Integer;              // Radius eines Knotens
    treeCount          : Integer;              // Anzahl der Elemente im Baum
    treeHeight         : Integer;              // Höhe des Baumes
    treeWidth          : Integer;              // Breite des Baumes

    procedure CalculateLeftContour(element : TElement; depth : Integer;
                                   var lastContourDepth : Integer;
                                   var leftContour : TList);
    procedure CalculateRightContour(element : TElement; depth : Integer;
                                    var lastContourDepth : Integer;
                                    var rightContour : TList);
    procedure CheckContours(element : TElement);
    procedure FindMaxXCoord(element : TElement; var maxXCoord : Integer);
    procedure FindMinXCoord(element : TElement; var minXCoord : Integer);
    procedure UpdateDrawTree(element : TElement; depth : Integer);
    procedure Paint(element : TElement);
    procedure UpdateXCoord(element : TElement; var offset : Integer);

  public { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy(); override;

    procedure HighlightElement(element : TElement; color : TColor);
    procedure PaintTree();
    procedure SetBackgroundColor(bgColor : TColor);
    procedure SetFontStyle(fontStyle : TFontStyles);
    procedure SetHighlightDelay(highlightDelay : Integer);
    procedure SetInsets(left, top, right, bottom : Integer);
    procedure SetLineSize(lineSize : Integer);
    procedure SetNodeColor(nodeColor : TColor);
    procedure SetNodeRadius(nodeRadius : Integer);
    procedure SetRoot(var root : TElement);

end;

implementation

uses Controls;


// ************************************************************************
// *     PUBLIC: Ab hier sind alle public-Methoden                        *
// ************************************************************************

{
  Dieser Konstruktor erzeugt eine neue Instanz dieser Klasse.

  ~param AOwner Das Objekt, das der Besitzer dieser Instanz ist.
  ~version 2.0
}
constructor TTreeViewer.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Self.root               := nil;
  Self.backgroundColor    := clBtnFace;
  Self.fontStyle          := [];
  Self.highlightColor     := clLime;
  Self.highlightDelay     := 500;
  Self.highlightedElement := nil;
  Self.insets.left        := 5;
  Self.insets.top         := 5;
  Self.insets.right       := 5;
  Self.insets.bottom      := 5;
  Self.lineSize           := 1;
  Self.nodeColor          := clWhite;
  Self.nodeRadius         := 15;
  Self.treeWidth          := 0;
  Self.treeHeight         := 0;
  Self.treeCount          := 0;
  Self.Canvas.Font.Name   := 'Courier New';
end;

{
  Dieser Destruktor gibt die Instanz dieser Klasse wieder frei.
  ~version 2.0
}
destructor TTreeViewer.Destroy;
begin
  inherited Destroy;
end;

{
  Diese Methode hebt den übergebenen Knoten mit der angegebenen Farbe hervor.

  ~param color Die Hintergrundfarbe des Knotens.
  ~param element Der Knoten, der hervorgehoben werden soll.
  ~version 2.0
}
procedure TTreeViewer.HighlightElement(element : TElement; color : TColor);
begin
  Self.highlightColor := color;
  Self.highlightedElement := element;
  PaintTree;
  Sleep(Self.highlightDelay);
  Self.highlightedElement := nil;
  PaintTree;
end;

{
  Diese Methode deligiert das Sammeln der Informationen über den Baum und das
  anschließende Zeichnen.

  ~version 2.0
}
procedure TTreeViewer.PaintTree;
var i                : Integer;                // Zählvariable
    lastContourDepth : Integer;                // Tiefe der zuletzt
                                               // hinzugefügten Kontur
    minXCoord        : Integer;                // kleinster x-Achsen Faktor
begin
                                               // leere die Zeichenfläche
  Self.Canvas.Brush.Color := Self.backgroundColor;
  Self.Canvas.FillRect(Self.Canvas.ClipRect);

  if(Self.root = nil) then Exit;
                                               // Errechne x- und y-Achsen
                                               // Faktoren und zeichne den Baum
  treeWidth  := 0;
  treeHeight := 0;
  treeCount  := 0;

  Self.root^.XCoord := 0;
  Self.root^.YCoord := 0;

  UpdateDrawTree(Self.root, 1);
  CheckContours(Self.root);
  minXCoord := 0;
  FindMinXCoord(Self.root, minXCoord);
  minXCoord := Abs(minXCoord);
  UpdateXCoord(Self.root, minXCoord);

  Self.treeWidth := 0;
  FindMaxXCoord(Self.root, Self.treeWidth);
  Inc(Self.treeWidth);

  Paint(Self.root);
  Repaint;                                     // Muss bei nachfolgendem Sleep
                                               // aufgerufen werden, da sonst
                                               // die GUI nicht aktualisiert.
end;

{
  Diese Methode setzt die Hintergrundfarbe des TreeViewers.

  ~param bgColor Die Hintergrundfarbe des TreeViewers.
  ~version 2.0
}
procedure TTreeViewer.SetBackgroundColor(bgColor : TColor);
begin
  Self.backgroundColor := bgColor;
  PaintTree;
end;

{
  Diese Methode setzt den globalen Schriftstyle.

  ~param fontStyle Der neue Schriftstyle.
  ~version 2.0
}
procedure TTreeViewer.SetFontStyle(fontStyle : TFontStyles);
begin
  Self.fontStyle := fontStyle;
  PaintTree;
end;

{
  Diese Methode setzt die Wartezeit nach dem Highlighting von Knoten.

  ~param highlightDelay Die Wartezeit in Millisekunden.
  ~version 2.0
}
procedure TTreeViewer.SetHighlightDelay(highlightDelay : Integer);
begin
  Self.highlightDelay := highlightDelay;
  PaintTree;
end;

{
  Diese Methode setzt die Äbstände der bemalbaren Fläche zum Rand.

  ~param left Der linke Abstand
  ~param top Der obere Abstand
  ~param right Der rechte Abstand
  ~param bottom Der untere Abstand
  ~version 2.0
}
procedure TTreeViewer.SetInsets(left, top, right, bottom : Integer);
begin
  Self.insets.left   := left;
  Self.insets.top    := top;
  Self.insets.right  := right;
  Self.insets.bottom := bottom;
end;

{
  Diese Methode setzt die Dicke der Linien, die die Knoten umranden und
  verbinden.

  ~param lineSize Dicke der Linien.
  ~version 2.0
}
procedure TTreeViewer.SetLineSize(lineSize : Integer);
begin
  Self.lineSize := lineSize;
  PaintTree;
end;

{
  Diese Methode setzt die globale Hintergrundfarbe für alle Knoten.

  ~param nodeColor Die Hintergrundfarbe aller Knoten.
  ~version 2.0
}
procedure TTreeViewer.SetNodeColor(nodeColor : TColor);
begin
  Self.nodeColor := nodeColor;
  PaintTree;
end;

{
  Diese Methode setzt den globalen Radius aller Knoten.

  ~param nodeRadius Der Radius für alle Knoten.
  ~version 2.0
}
procedure TTreeViewer.SetNodeRadius(nodeRadius : Integer);
begin
  Self.nodeRadius := nodeRadius;
  PaintTree;
end;

{
  Diese Methode setzt die root des Baumes neu.

  ~param root Die neue Root des Baumes
  ~version 2.0
}
procedure TTreeViewer.SetRoot(var root : TElement);
begin
  Self.root := root;
  PaintTree;
end;


// ************************************************************************
// *     PRIVATE: Ab hier sind alle private-Methoden                      *
// ************************************************************************

{
  Diese Methode ermittelt die linke Kontur des visuellen Baumes.
  Der Baum wird pre-order durchlaufen.

  ~param element Der Knoten ab dem die linke Kontur ermittelt werden soll.
  ~param depth Die aktuelle Tiefe
  ~param lastContourDepth Die Tiefe des letzten Konturknotens
  ~version 2.0
}
procedure TTreeViewer.CalculateLeftContour(element : TElement;
                                           depth : Integer;
                                           var lastContourDepth : Integer;
                                           var leftContour : TList);
begin
  if(element <> nil) then
  begin
    if(depth > lastContourDepth) then
    begin
      leftContour.Add(element);
      lastContourDepth := depth;
    end;

    if(element^.LS <> nil) then
    begin
      CalculateLeftContour(element^.LS, depth + 1, lastContourDepth,
                           leftContour);
    end;

    if(element^.RS <> nil) then
    begin
      CalculateLeftContour(element^.RS, depth + 1, lastContourDepth,
                           leftContour);
    end;
  end;
end;

{
  Diese Methode ermittelt die rechte Kontur des visuellen Baumes.
  Der Baum wird pre-order durchlaufen.

  ~param element Der Knoten ab dem die linke Kontur ermittelt werden soll.
  ~param depth Die aktuelle Tiefe
  ~param lastContourDepth Die Tiefe des letzten Konturknotens
  ~version 2.0
}
procedure TTreeViewer.CalculateRightContour(element : TElement;
                                            depth : Integer;
                                            var lastContourDepth : Integer;
                                            var rightContour : TList);
begin
  if(element <> nil) then
  begin
    if(depth > lastContourDepth) then
    begin
      rightContour.Add(element);
      lastContourDepth := depth;
    end;

    if(element^.RS <> nil) then
    begin
      CalculateRightContour(element^.RS, depth + 1, lastContourDepth,
                            rightContour);
    end;

    if(element^.LS <> nil) then
    begin
      CalculateRightContour(element^.LS, depth + 1, lastContourDepth,
                            rightContour);
    end;
  end;
end;

{
  Diese Methode überprüft die aktuell linke und die rechte Kontur und
  aktualisiert falls nötig die Distanz des linken und rechten Teilbaumes
  voneinander. Der Baum wird post-order durchlaufen.

  Formel:
    (Wert(links) - Wert(rechts) + 2) / 2 = Distanz
    Wenn distanz größer 0 ist, so verschiebe den linken Teilbaum um
    -Distanz und den rechten Teilbaum um +Distanz

  ~param element Die Wurzel des Baumes, dessen Konturen geprüft werden sollen.
  ~version 2.0
}
procedure TTreeViewer.CheckContours(element : TElement);
var lastContourDepth : Integer;                // Tiefe der zuletzt
                                               // hinzugefügten Kontur
    diff, maxDiff    : Integer;                // Distanz der Konturelemente
    minContourSize   : Integer;                // Anzahl der kleinsten Kontur
    i                : Integer;                // Zählvariable
    leftContour      : TList;                  // Linke Kontur eines Baumes
    rightContour     : TList;                  // Rechte Kontur eines Baumes
begin
  if(element = nil) then Exit;

  if(element^.LS <> nil) then
  begin
    CheckContours(element^.LS);
  end;

  if(element^.RS <> nil) then
  begin
    CheckContours(element^.RS);
  end;

  leftContour := TList.Create;                 // Ermittle linke Kontur des
  lastContourDepth := -1;                      // des rechten Teilbaumes
  CalculateLeftContour(element^.RS, 0, lastContourDepth, leftContour);

  rightContour := TList.Create;                // Ermittle rechte Kontur des
  lastContourDepth := -1;                      // linken Teilbaumes
  CalculateRightContour(element^.LS, 0, lastContourDepth, rightContour);

  if(leftContour.Count < rightContour.Count) then
    minContourSize := leftContour.Count
  else
    minContourSize := rightContour.Count;

  SetRoundMode(rmUp);
  maxDiff := 0;                                // Durchlaufe die Konturen und
  for i := 0 to minContourSize - 1 do          // ermittle die größte Differenz
  begin
    diff := Round((TElement(rightContour.Items[i])^.XCoord
          - TElement(leftContour.Items[i])^.XCoord + 2) / 2);
    if(diff > maxDiff) then
      maxDiff := diff;
  end;

  leftContour.Destroy;
  rightContour.Destroy;

  UpdateXCoord(element^.RS, maxDiff);
  maxDiff := -maxDiff;
  UpdateXCoord(element^.LS, maxDiff);
end;

{
  Diese Methode sucht das Element mit dem größten x-Achsen Faktor ab einem
  angegeben Knoten. Der Baum wird post-order durchlaufen.

  ~param element Wurzel des Baumes, der durchsucht werden soll.
  ~param maxXCoord Der größte x-Achsen Wert.
  ~version 2.0
}
procedure TTreeViewer.FindMaxXCoord(element : TElement;
                                    var maxXCoord : Integer);
begin
  if(element = nil) then Exit;

  if(element^.LS <> nil) then
  begin
    FindMaxXCoord(element^.LS, maxXCoord);
  end;

  if(element^.RS <> nil) then
  begin
    FindMaxXCoord(element^.RS, maxXCoord);
  end;

  if(element^.XCoord > maxXCoord) then
    maxXCoord := element^.XCoord;
end;

{
  Diese Methode sucht das Element mit dem kleinsten x-Achsen Faktor ab einem
  angegeben Knoten. Der Baum wird post-order durchlaufen.

  ~param element Wurzel des Baumes, der durchsucht werden soll.
  ~param maxXCoord Der kleinste x-Achsen Wert.
  ~version 2.0
}
procedure TTreeViewer.FindMinXCoord(element : TElement;
                                    var minXCoord : Integer);
begin
  if(element = nil) then Exit;

  if(element^.LS <> nil) then
  begin
    FindMinXCoord(element^.LS, minXCoord);
  end;

  if(element^.RS <> nil) then
  begin
    FindMinXCoord(element^.RS, minXCoord);
  end;

  if(element^.XCoord < minXCoord) then
    minXCoord := element^.XCoord;
end;

{
  Diese Methode erzeugt eine Kopie des übergebenen Baumes und berechnet
  zusätzlich noch die x und y Koordinaten für die einzelnen Knoten, die direkt
  in der Kopie abgelegt werden.

  Hier wird auch direkt die Höhe des Baumes ermittelt.

  ~param element Aktueller Knoten für den die Koordinaten ermittelt werden.
  ~param element Knoten des ursprünglichen Baumes (nicht visualisiert)
  ~param depth Die aktuelle Tiefe des Knotens
  ~version 2.0
}
procedure TTreeViewer.UpdateDrawTree(element : TElement; depth : Integer);
begin
  if(Self.treeHeight < depth) then
    Self.treeHeight := depth;

  if(element^.LS <> nil) then
  begin
    element^.LS^.XCoord := element^.XCoord - 1;
    element^.LS^.YCoord := depth;
    UpdateDrawTree(element^.LS, depth + 1);
  end;

  if(element^.RS <> nil) then
  begin
    element^.RS^.XCoord := element^.XCoord + 1;
    element^.RS^.YCoord := depth;
    UpdateDrawTree(element^.RS, depth + 1);
  end;
end;

{
  Diese Methode zeichnet einzelne Knoten und die Verbindungslinie zum nächsten
  Knoten, falls einer vorhanden ist. Außerdem werden die Datenwerte eines
  jeden Knotens zentriert auf jeden Knoten geschrieben.
  Der Baum wird post-order durchlaufen und gezeichnet.

  ~param element Der zu zeichnende Knoten
  ~version 2.0
}
procedure TTreeViewer.Paint(element : TElement);
var x1, x2, y1, y2           : Integer;
    width                    : Double;         // Breite der bemalbaren Fläche
    height                   : Double;         // Höhe der bemalbaren
    textWidth                : Integer;        // Breite des Textes
    textHeight               : Integer;        // Höhe des Textes
    textX, textY             : Integer;        // Obere linke Ecke des Textes
    nodeCenterX, nodeCenterY : Integer;        // Mitelpunkt eines Knotens
    nextNodeCenterX,
    nextNodeCenterY          : Integer;        // Mitelpunkt eines Folgeknotens
begin
  if(element = nil) then Exit;

  if(element^.LS <> nil) then
  begin
    Paint(element^.LS);
  end;

  if(element^.RS <> nil) then
  begin
    Paint(element^.RS);
  end;

  width  := ClientWidth  - 2 * (Self.nodeRadius + Self.lineSize)
            - Self.insets.left - Self.insets.right;
  height := ClientHeight - 2 * (Self.nodeRadius + Self.lineSize)
            - Self.insets.top - Self.insets.bottom;

                                               // Ermittle Koordinaten für den
                                               // Knoten und zeichne diesen
  nodeCenterX := Self.nodeRadius + Self.lineSize + Self.insets.left;
  if(Self.treeWidth > 1) then
    nodeCenterX := Trunc(element^.XCoord * width  / (Self.treeWidth-1)  + Self.nodeRadius + Self.lineSize + Self.insets.left);

  nodeCenterY := Self.nodeRadius + Self.lineSize + Self.insets.top;
  if(Self.treeHeight > 1) then
    nodeCenterY := Trunc(element^.YCoord * height / (Self.treeHeight-1) + Self.nodeRadius + Self.lineSize + Self.insets.top);

  x1 := nodeCenterX - Self.nodeRadius;
  y1 := nodeCenterY - Self.nodeRadius;
  x2 := nodeCenterX  + Self.nodeRadius;
  y2 := nodeCenterY + Self.nodeRadius;

  if(Self.highlightedElement <> nil) and
    (element^.Data = Self.highlightedElement^.Data) then
    Self.Canvas.Brush.Color := Self.highlightColor
  else
    Self.Canvas.Brush.Color := Self.nodeColor;

  Self.Canvas.Pen.Color := clBlack;
  Self.Canvas.Pen.Width := Self.lineSize;
  Self.Canvas.Ellipse(x1, y1, x2, y2);

                                               // Zeichne die Verbindungslinien
                                               // zum nächsten Knoten
  SetRoundMode(rmNearest);
  if(element^.LS <> nil) then
  begin
    nextNodeCenterX := Self.nodeRadius + Self.lineSize + Self.insets.left;
    if(Self.treeWidth > 1) then
      nextNodeCenterX := Round(element^.LS^.XCoord * width  / (Self.treeWidth-1)
                       + Self.nodeRadius + Self.lineSize + Self.insets.left);

    nextNodeCenterY := Self.nodeRadius + Self.lineSize + Self.insets.top;
    if(Self.treeHeight > 1) then
      nextNodeCenterY := Round(element^.LS^.YCoord * height  / (Self.treeHeight-1)
                       + Self.lineSize + Self.insets.top);

    Self.Canvas.MoveTo(nodeCenterX, y2);
    Self.Canvas.LineTo(nextNodeCenterX, nextNodeCenterY);
  end;

  if(element^.RS <> nil) then
  begin
    nextNodeCenterX := Self.nodeRadius + Self.lineSize + Self.insets.left;
    if(Self.treeWidth > 1) then
      nextNodeCenterX := Round(element^.RS^.XCoord * width  / (Self.treeWidth-1)
                       + Self.nodeRadius + Self.lineSize + Self.insets.left);

    nextNodeCenterY := Self.nodeRadius + Self.lineSize + Self.insets.top;
    if(Self.treeHeight > 1) then
      nextNodeCenterY := Round(element^.RS^.YCoord * height  / (Self.treeHeight-1)
                       + Self.lineSize + Self.insets.top);

    Self.Canvas.MoveTo(nodeCenterX, y2);
    Self.Canvas.LineTo(nextNodeCenterX, nextNodeCenterY);
  end;

                                               // Ermittle Beschriftungsbreite
                                               // und -höhe und zeichne den
                                               // Datenwert des Knotens
  Self.Canvas.Font.Height := Self.nodeRadius;
  Self.Canvas.Font.Style := Self.fontStyle;
  textWidth := Self.Canvas.TextWidth(IntTostr(element^.Data));
  textHeight := Self.Canvas.TextHeight(IntTostr(element^.Data));
  textX := Trunc(x1 + Self.nodeRadius - textWidth / 2);
  textY := Trunc(y1 + Self.nodeRadius - textHeight / 2);
  Self.Canvas.TextOut(textX, textY, IntTostr(element^.Data));
  if(textWidth > 2 * Self.nodeRadius - 4) then
  begin
    Self.Canvas.MoveTo(Trunc(nodeCenterX), Trunc(nodeCenterY));
    x1 := textX - 1;
    y1 := textY;
    x2 := textX + textWidth + 2;
    y2 := textY + textHeight + 1;
    Self.Canvas.Brush.Style := bsClear;
    Self.Canvas.Rectangle(Trunc(x1), Trunc(y1), Trunc(x2), Trunc(y2));
  end;

  Self.Canvas.Pen.Width := 1;
  Self.Canvas.Brush.Style := bsClear;
  Self.Canvas.Pen.Color := clSilver;
  Self.Canvas.Rectangle(0,0,Self.Width, Self.Height);
end;

{
  Diese Methode aktualisiert den x-Achsen Faktor eines Knotens. Der Baum wird
  post-order durchlaufen. Um eine Verschiebung nach links zu erreichen muss
  ein negatives offset angegeben werden.

  ~param element Die Wurzel des Baumes ab dem alle x-Achsen Faktoren
                     aktualisiert werden sollen.
  ~param offset Der Wert, um den der x-Achsen Faktor geändert werden muss.
  ~version 2.0
}
procedure TTreeViewer.UpdateXCoord(element : TElement;
                                   var offset : Integer);
begin
  if(element = nil) then Exit;

  if(element^.LS <> nil) then
  begin
    UpdateXCoord(element^.LS, offset);
  end;

  if(element^.RS <> nil) then
  begin
    UpdateXCoord(element^.RS, offset);
  end;

  element^.XCoord := element^.XCoord + offset;
end;

end.
