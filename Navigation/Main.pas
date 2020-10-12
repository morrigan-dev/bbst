unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, Menus;

type
  TfrmNavigation = class(TForm)
    MainMenu1: TMainMenu;
    mmuDatei: TMenuItem;
    smuExit: TMenuItem;
    mmuCity: TMenuItem;
    smuCalc: TMenuItem;
    smuManual: TMenuItem;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    smuSave: TMenuItem;
    smuLoad: TMenuItem;
    N2: TMenuItem;
    smuSmallCity: TMenuItem;
    smuMiddleCity: TMenuItem;
    smuLargeCity: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    popA: TMenuItem;
    popB: TMenuItem;
    popC: TMenuItem;
    popD: TMenuItem;
    popE: TMenuItem;
    popF: TMenuItem;
    popG: TMenuItem;
    popH: TMenuItem;
    popI: TMenuItem;
    popJ: TMenuItem;
    popK: TMenuItem;
    popL: TMenuItem;
    popM: TMenuItem;
    popN: TMenuItem;
    popO: TMenuItem;
    mmuNavigation: TMenuItem;
    smuStart: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure smuSmallCityClick(Sender: TObject);
    procedure smuMiddleCityClick(Sender: TObject);
    procedure smuLargeCityClick(Sender: TObject);
    procedure smuCalcClick(Sender: TObject);
    procedure smuExitClick(Sender: TObject);
    procedure smuSaveClick(Sender: TObject);
    procedure smuLoadClick(Sender: TObject);
    procedure btnCreateFieldsClick(Sender: TObject);
    procedure popClick(Sender: TObject);
    procedure smuManualClick(Sender: TObject);
    procedure smuStartClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen }
    pnlPanel : TPanel;
    lblInfo, lblSize, lblWidth, lblHeight : TLabel;
    cmbStreetSize : TComboBox;
    edtWidth, edtHeight : TEdit;
    btnCreateFields : TButton;
  public
    { Public-Deklarationen }
  end;

var
  frmNavigation: TfrmNavigation;

implementation

{$R *.dfm}

type
  MyOrientation = (East, South, West, North);

  MyPoint = record
    x : ShortInt;
    y : ShortInt;
  end;

  MyCross = record
    position : MyPoint;
    orientation : MyOrientation;
  end;

  MyNavigation = record
    start : MyPoint;
    goal : MyPoint;
    aktPosition : MyPoint;
    lastCrossings : array of MyCross;
    Crossings : Integer;
    aktWay : String;
    listOfWays : array of String;
  end;

  MyCity = record
    width  : ShortInt;
    height : ShortInt;
    size   : ShortInt;
    fields : array of array of String;
    images : array of array of TImage;
    sender : TObject;
  end;

  MyConstants = record
    WaysToGo : array[0..3] of String;
    PathLarge : String;
    PathMiddle : String;
    PathSmall : String;
    possibleElementsRight : array[0..1] of String;
    possibleElementsDown : array[0..1] of String;
  end;


var city : MyCity;
    navi : MyNavigation;
    constants : MyConstants;

// Programmeinstieg: Startbelegungen und Konstanten werden gesetzt
procedure TfrmNavigation.FormCreate(Sender: TObject);
begin
  popA.OnClick := popClick;
  popB.OnClick := popClick;
  popC.OnClick := popClick;
  popD.OnClick := popClick;
  popE.OnClick := popClick;
  popF.OnClick := popClick;
  popG.OnClick := popClick;
  popH.OnClick := popClick;
  popI.OnClick := popClick;
  popJ.OnClick := popClick;
  popK.OnClick := popClick;
  popL.OnClick := popClick;
  popM.OnClick := popClick;
  popN.OnClick := popClick;
  popO.OnClick := popClick;

  constants.WaysToGo[0] := 'acegijk'; // East
  constants.WaysToGo[1] := 'abfhijk'; // South
  constants.WaysToGo[2] := 'bdeghik'; // West
  constants.WaysToGo[3] := 'cdfghjk'; // North

  constants.PathLarge := 'Straßen groß\';
  constants.PathMiddle := 'Straßen mittel\';
  constants.PathSmall := 'Straßen klein\';

  constants.possibleElementsRight[0] := 'bdeghiko';
  constants.possibleElementsRight[1] := 'acfjlmn';

  constants.possibleElementsDown[0] := 'cdfghjkn';
  constants.possibleElementsDown[1] := 'abeilmo';

  city.width := 0;
  city.height := 0;

  smuMiddleCity.Checked := true;
  city.size := 2;
end;


//  **********************************************
//           Wegsuche vom Start zum Ziel
//  **********************************************

procedure initialNavigation();
begin
  navi.start.x := 0;
  navi.start.y := 0;
  navi.goal.x := city.width-1;
  navi.goal.y := city.height-1;
  navi.aktPosition := navi.start;
  navi.Crossings := 0;
end;

function drive(orientation : MyOrientation) : Boolean;
var i : Integer;
begin
  result := false;
  if (navi.aktPosition.x <> city.width-1) then
    for i := 1 to length(constants.WaysToGo[ord(orientation)]) do
      if (city.fields[navi.aktPosition.x,navi.aktPosition.y] = Copy(constants.WaysToGo[ord(orientation)],i,1)) then
        result := true;
end;

procedure calculateWays();
var bestWayFound : Boolean;
    x,y : Integer;
begin
  bestWayFound := false;

  while not bestWayFound do
  begin
    if drive(East) then
    begin
      SetLength(navi.lastCrossings, navi.Crossings+1);
      navi.lastCrossings[navi.Crossings].position := navi.aktPosition;
      navi.lastCrossings[navi.Crossings].orientation := East;
      navi.aktPosition.x := navi.aktPosition.x + 1;
    end
    else
    begin
      if drive(South) then
      begin
        SetLength(navi.lastCrossings, navi.Crossings+1);
        navi.lastCrossings[navi.Crossings].position := navi.aktPosition;
        navi.lastCrossings[navi.Crossings].orientation := South;
        navi.aktPosition.y := navi.aktPosition.y + 1;
      end
      else
      begin
        if drive(West) then
        begin
          SetLength(navi.lastCrossings, navi.Crossings+1);
          navi.lastCrossings[navi.Crossings].position := navi.aktPosition;
          navi.lastCrossings[navi.Crossings].orientation := West;
          navi.aktPosition.x := navi.aktPosition.x - 1;
        end
        else
        begin
          if drive(North) then
          begin
            SetLength(navi.lastCrossings, navi.Crossings+1);
            navi.lastCrossings[navi.Crossings].position := navi.aktPosition;
            navi.lastCrossings[navi.Crossings].orientation := North;
            navi.aktPosition.y := navi.aktPosition.y - 1;
          end;
        end;
      end;
    end;
    showmessage(inttostr(navi.aktPosition.x) +'-'+inttostr(navi.aktPosition.y));
  end;
end;


//  **********************************************
//              Erstellung der Stadt
//  **********************************************

// Startebelegungen wereden gesetzt
procedure initialCity();
var i,j : Integer;
begin
  { Straßenformen:
    Kurve von unten nach rechts: a
    Kurve von unten nach links:  b
    Kurve von oben nach rechts:  c
    Kurve von oben nach links:   d
    Gerade Strecke waagerecht:   e
    Gerade Strecke senkrecht:    f
    T-Kreuzung nach oben:        g
    T-Kreuzung nach links:       h
    T-Kreuzung nach unten:       i
    T-Kreuzung nach rechts:      j
    Kreuzung:                    k
    Haus:                        l
    Häuserreihe:                 m
    Kreisel nach oben:           n
  }

  case city.size of
    1: begin // kleine Stadt
         city.width := 10;
         city.height := 7;
       end;
    2: begin // mittlere Stadt
         city.width := 19;
         city.height := 13;
       end;
    3: begin // große Stadt
         city.width := 37;
         city.height := 25;
       end;
  end;


  SetLength(city.fields, city.width, city.height);
  SetLength(city.images, city.width, city.height);

  // Erstelle für jedes Feld alle Möglichkeiten die Straßen anzuordnen.
  // Eckpunkte
  city.fields[0,0] := 'a';
  city.fields[0,city.height-1] := 'c';
  city.fields[city.width-1,0] := 'b';
  city.fields[city.width-1,city.height-1] := 'dno';

  // Umrandung oben/unten
  city.fields[1,0] := 'bei';
  city.fields[1,city.height-1] := 'deg';
  for i := 2 to city.width-3 do
  begin
    city.fields[i,0] := 'abei';
    city.fields[i,city.height-1] := 'cdeg';
  end;
  city.fields[city.width-2,0] := 'aei';
  city.fields[city.width-2,city.height-1] := 'ceg';

  // Umrandung links/rechts
  city.fields[0,1] := 'cfj';
  city.fields[0,city.height-2] := 'afj';
  for j := 2 to city.height-3 do
  begin
    city.fields[0,j] := 'acfj';
    city.fields[city.width-1,j] := 'bdfh';
  end;
  city.fields[city.width-1,1] := 'dfh';
  city.fields[city.width-1,city.height-2] := 'bfh';

  // Innen
  for i := 1 to city.height-2 do
  begin
    for j := 1 to city.width-2 do
    begin
      city.fields[j,i] := 'abcdefghijklm';
    end;
  end;
end;

// Löscht alle Bilder
procedure destroyCity();
var i,j : Integer;
begin

  for i := 0 to city.height-1 do
  begin
    for j := 0 to city.width-1 do
    begin
      city.images[j,i].Free;
    end;
  end;

end;

// Erstellt die Stadtbilder und zeigt sie an
procedure printCity();
var cityString : String;
    i,j : Integer;
    jpegImage : TJpegImage;
begin
  cityString := '';
  for i := 0 to city.height-1 do
  begin
    for j := 0 to city.width-1 do
    begin
      city.images[j,i] := TImage.Create(frmNavigation);
      city.images[j,i].OnMouseUp := frmNavigation.FormMouseUp;
      with city.images[j,i] do
      begin
        Parent := frmNavigation;
        case city.size of
          1: begin // kleine Stadt
               if (length(city.fields[j,i])=1) then
               begin
                 if FileExists(constants.PathLarge+city.fields[j,i]+'.jpg') then
                 begin
                   jpegImage := TJpegImage.Create;
                   jpegImage.LoadFromFile(constants.PathLarge+city.fields[j,i]+'.jpg');
                   Picture.Assign(jpegImage);
                 end
                 else
                   showmessage('Das Bild '+ '"'+constants.PathLarge+city.fields[j,i]+'.jpg"' +
                               ' konnte nicht gefunden werden.');
               end;
               Left := j*100;
               Top := i*100;
             end;
          2: begin // mittlere Stadt
               if (length(city.fields[j,i])=1) then
               begin
                 if FileExists(constants.PathMiddle+city.fields[j,i]+'.jpg') then
                 begin
                   jpegImage := TJpegImage.Create;
                   jpegImage.LoadFromFile(constants.PathMiddle+city.fields[j,i]+'.jpg');
                   Picture.Assign(jpegImage);
                 end
                 else
                   showmessage('Das Bild '+ '"'+constants.PathMiddle+city.fields[j,i]+'.jpg"' +
                               ' konnte nicht gefunden werden.');
               end;
               Left := j*50;
               Top := i*50;
             end;
          3: begin // große Stadt
               if (length(city.fields[j,i])=1) then
               begin
                 if FileExists(constants.PathSmall+city.fields[j,i]+'.jpg') then
                 begin
                   jpegImage := TJpegImage.Create;
                   jpegImage.LoadFromFile(constants.PathSmall+city.fields[j,i]+'.jpg');
                   Picture.Assign(jpegImage);
                 end
                 else
                   showmessage('Das Bild '+ '"'+constants.PathSmall+city.fields[j,i]+'.jpg"' +
                               ' konnte nicht gefunden werden.');
               end;
               Left := j*25;
               Top := i*25;
             end;
        end;
        Show;
      end;
    end;
  end;
end;

// Manulle Bearbeitung der Bilder durch Popupmenü
procedure TfrmNavigation.popClick(Sender: TObject);
var jpegImage : TJpegImage;
    imageFile : String;
    j,i : Integer;
begin
  if Sender is TMenuItem then
  begin
    imageFile := '';
    case city.size of
      1: begin
           imageFile := constants.PathLarge;
           j := TImage(city.sender).Left div 100;
           i := TImage(city.sender).Top div 100;
         end;
      2: begin
           imageFile := constants.PathMiddle;
           j := TImage(city.sender).Left div 50;
           i := TImage(city.sender).Top div 50;
         end;
      3: begin
           imageFile := constants.PathSmall;
           j := TImage(city.sender).Left div 25;
           i := TImage(city.sender).Top div 25;
         end;
    end;

    case TMenuItem(Sender).Tag of
      0: begin
           city.fields[j,i] := 'a';
           imageFile := imageFile + 'a.jpg';
         end;
      1: begin
           city.fields[j,i] := 'b';
           imageFile := imageFile + 'b.jpg';
         end;
      2: begin
           city.fields[j,i] := 'c';
           imageFile := imageFile + 'c.jpg';
         end;
      3: begin
           city.fields[j,i] := 'd';
           imageFile := imageFile + 'd.jpg';
         end;
      4: begin
           city.fields[j,i] := 'e';
           imageFile := imageFile + 'e.jpg';
         end;
      5: begin
           city.fields[j,i] := 'f';
           imageFile := imageFile + 'f.jpg';
         end;
      6: begin
           city.fields[j,i] := 'g';
           imageFile := imageFile + 'g.jpg';
         end;
      7: begin
           city.fields[j,i] := 'h';
           imageFile := imageFile + 'h.jpg';
         end;
      8: begin
           city.fields[j,i] := 'i';
           imageFile := imageFile + 'i.jpg';
         end;
      9: begin
           city.fields[j,i] := 'j';
           imageFile := imageFile + 'j.jpg';
         end;
      10: begin
           city.fields[j,i] := 'k';
           imageFile := imageFile + 'k.jpg';
         end;
      11: begin
           city.fields[j,i] := 'l';
           imageFile := imageFile + 'l.jpg';
         end;
      12: begin
           city.fields[j,i] := 'm';
           imageFile := imageFile + 'm.jpg';
         end;
      13: begin
           city.fields[j,i] := 'n';
           imageFile := imageFile + 'n.jpg';
         end;
      14: begin
           city.fields[j,i] := 'o';
           imageFile := imageFile + 'o.jpg';
         end;
    end;

    jpegImage := TJpegImage.Create;
    jpegImage.LoadFromFile(imageFile);
    TImage(city.sender).Picture.Assign(jpegImage);
  end;
end;

// Öffnet das Popupmenu bei einem Rechtsklick
procedure TfrmNavigation.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var pos : TPoint;
begin
  if (Sender is TImage) and (Button = mbRight) then
  begin
    GetCursorPos(pos);
    popupMenu.Popup(pos.X, pos.Y);
    city.sender := Sender;
  end;
end;

// Bildet die Schnittmenge zweier Listen
procedure calculateIntersection(possElems : String; j,i : Integer; field : String);
var x,y : Integer;
    helpStr : String;
begin

  // rechtes Feld
  if (field = 'right') then
  begin
    helpStr := '';
    for x := 1 to length(city.fields[j+1,i]) do
    begin
      for y := 1 to length(possElems) do
      begin
        if (Copy(city.fields[j+1,i],x,1) = Copy(possElems,y,1)) then
          helpStr := helpStr + Copy(city.fields[j+1,i],x,1);
      end;
    end;

    if (helpStr='') then
    begin
      helpStr := 'lm';
    end;
    city.fields[j+1,i] := helpStr;
  end;

  // unteres Feld
  if (field = 'bottom') then
  begin
    helpStr := '';
    for x := 1 to length(city.fields[j,i+1]) do
    begin
      for y := 1 to length(possElems) do
      begin
        if (Copy(city.fields[j,i+1],x,1) = Copy(possElems,y,1)) then
          helpStr := helpStr + Copy(city.fields[j,i+1],x,1);
      end;
    end;

    if (helpStr='') then
    begin
      helpStr := 'lm';
    end;
    city.fields[j,i+1] := helpStr;
  end;
end;

// Berechnet die Möglichen Straßen aus dem rechten Feld neu
procedure calculateRightField(j,i : Integer);
begin
  if (j<>city.width-1) then
  begin
    if (city.fields[j,i] = 'a') or (city.fields[j,i] = 'c') or
       (city.fields[j,i] = 'e') or (city.fields[j,i] = 'g') or
       (city.fields[j,i] = 'i') or (city.fields[j,i] = 'j') or
       (city.fields[j,i] = 'k') then
    begin
      calculateIntersection(constants.possibleElementsRight[0],j,i,'right');
    end;

    if (city.fields[j,i] = 'b') or (city.fields[j,i] = 'd') or
       (city.fields[j,i] = 'f') or (city.fields[j,i] = 'h') or
       (city.fields[j,i] = 'l') or (city.fields[j,i] = 'm') or
       (city.fields[j,i] = 'n') or (city.fields[j,i] = 'o') then
    begin
      calculateIntersection(constants.possibleElementsRight[1],j,i,'right');
    end;
  end;
end;

// Berechnet die Möglichen Straßen aus dem unteren Feld neu
procedure calculateBottomField(j,i : Integer);
begin
  if (i<>city.height-1) then
  begin
    if (city.fields[j,i] = 'a') or (city.fields[j,i] = 'b') or
       (city.fields[j,i] = 'f') or (city.fields[j,i] = 'h') or
       (city.fields[j,i] = 'i') or (city.fields[j,i] = 'j') or
       (city.fields[j,i] = 'k') then
    begin
      calculateIntersection(constants.possibleElementsDown[0],j,i,'bottom');
    end;

    if (city.fields[j,i] = 'c') or (city.fields[j,i] = 'd') or
       (city.fields[j,i] = 'e') or (city.fields[j,i] = 'g') or
       (city.fields[j,i] = 'l') or (city.fields[j,i] = 'm') or
       (city.fields[j,i] = 'n') or (city.fields[j,i] = 'o') then
    begin
      calculateIntersection(constants.possibleElementsDown[1],j,i,'bottom');
    end;
  end;
end;

//  **********************************************
//                      Menüs
//  **********************************************

// Setzt die Stadtgröße auf 'klein', 'mittel' bzw 'groß'
procedure TfrmNavigation.smuSmallCityClick(Sender: TObject);
begin
  smuSmallCity.Checked := true;
  smuMiddleCity.Checked := false;
  smuLargeCity.Checked := false;
  city.size := 1;
end;
procedure TfrmNavigation.smuMiddleCityClick(Sender: TObject);
begin
  smuSmallCity.Checked := false;
  smuMiddleCity.Checked := true;
  smuLargeCity.Checked := false;
  city.size := 2;
end;
procedure TfrmNavigation.smuLargeCityClick(Sender: TObject);
begin
  smuSmallCity.Checked := false;
  smuMiddleCity.Checked := false;
  smuLargeCity.Checked := true;
  city.size := 3;
end;

// Erzeugt eine Stadt per Zufall
procedure TfrmNavigation.smuCalcClick(Sender: TObject);
var i,j : Integer;
begin
  destroyCity();
  initialCity();

  randomize;
  for i := 0 to city.height-1 do
  begin
    for j := 0 to city.width-1 do
    begin
      city.fields[j,i] := Copy(city.fields[j,i],random(length(city.fields[j,i]))+1,1);
      calculateRightField(j,i);
      calculateBottomField(j,i);
    end;
  end;

  printCity();
end;

// Erzeugt die leeren Stadt-Felder des Editors
procedure TfrmNavigation.btnCreateFieldsClick(Sender: TObject);
var i,j : Integer;
begin
  destroyCity();

  city.size := cmbStreetSize.ItemIndex+1;

  if (edtWidth.Text = '') or (edtHeight.Text = '') then
  begin
    showmessage('Sie müssen noch die Größe der Stadt festlegen.');
    edtWidth.SetFocus();
    exit;
  end;

  if (StrToInt(edtWidth.Text)<5) then
  begin
    showmessage('Die Stadt muss mind. 5x5 Felder groß sein');
    edtWidth.SetFocus();
    exit;
  end
  else
  begin
    city.width := StrToInt(edtWidth.Text);
    city.height := StrToInt(edtHeight.Text);
  end;

  pnlPanel.Visible := false;

  SetLength(city.fields,city.width,city.height);
  SetLength(city.images,city.width,city.height);

  for i := 0 to city.height-1 do
  begin
    for j := 0 to city.width-1 do
    begin
      city.fields[j,i] := '0';
    end;
  end;

  printCity();
end;

// Startet den Stadt-Editor
procedure TfrmNavigation.smuManualClick(Sender: TObject);
begin
  pnlPanel := TPanel.Create(frmNavigation);
  pnlPanel.Parent := frmNavigation;
  pnlPanel.Left := 50;
  pnlPanel.Top := 50;
  pnlPanel.Width := 650;
  pnlPanel.Height := 250;

  lblInfo := TLabel.Create(pnlPanel);
  lblInfo.Parent := pnlPanel;
  lblInfo.Left := 10;
  lblInfo.Top := 10;
  lblInfo.Caption := 'Stadteditor' + #13#10 + #13#10 +
                  'Mit diesem Editor können Sie ihre eigene Stadt erstellen' + #13#10 +
                  'Sie müssen nur in die unteren Eingabefelder die Breite und die Höhe der ' +
                  'Stadt eintragen und auf den Button "erstelle Felder" klicken.' + #13#10 +
                  'Anschließend können Sie auf jedes Feld mit der rechten Maustaste klicken '+
                  'und das gewünschte Element auswählen.' + #13#10 +
                  'Viel Spaß!';

  lblSize := TLabel.Create(pnlPanel);
  lblSize.Parent := pnlPanel;
  lblSize.Left := 10;
  lblSize.Top := 104;
  lblSize.Caption := 'Bitte die Größe der Bilder auswählen:';

  cmbStreetSize := TComboBox.Create(pnlPanel);
  cmbStreetSize.Parent := pnlPanel;
  cmbStreetSize.Left := 190;
  cmbStreetSize.Top := 100;
  cmbStreetSize.Items.Add('große Bilder');
  cmbStreetSize.Items.Add('mittlere Bilder');
  cmbStreetSize.Items.Add('kleine Bilder');
  cmbStreetSize.ItemIndex := 1;

  lblWidth := TLabel.Create(pnlPanel);
  lblWidth.Parent := pnlPanel;
  lblWidth.Left := 10;
  lblWidth.Top := 134;
  lblWidth.Caption := 'Breite:';

  edtWidth := TEdit.Create(pnlPanel);
  edtWidth.Parent := pnlPanel;
  edtWidth.Left := 45;
  edtWidth.Top := 130;
  edtWidth.Width := 30;
  edtWidth.SetFocus();

  lblHeight := TLabel.Create(pnlPanel);
  lblHeight.Parent := pnlPanel;
  lblHeight.Left := 90;
  lblHeight.Top := 134;
  lblHeight.Caption := 'Höhe:';

  edtHeight := TEdit.Create(pnlPanel);
  edtHeight.Parent := pnlPanel;
  edtHeight.Left := 125;
  edtHeight.Top := 130;
  edtHeight.Width := 30;

  btnCreateFields := TButton.Create(pnlPanel);
  btnCreateFields.Parent := pnlPanel;
  btnCreateFields.Left := 10;
  btnCreateFields.Top := 160;
  btnCreateFields.Caption := '&erstelle Felder';
  btnCreateFields.OnClick := btnCreateFieldsClick;

end;

// Setzt die Startwerte für die Routensuche und startet diese
procedure TfrmNavigation.smuStartClick(Sender: TObject);
begin
  initialNavigation();
  calculateWays();
end;

// Löscht alle Bilder und beendet das Programm
procedure TfrmNavigation.smuExitClick(Sender: TObject);
begin
  destroyCity();
  close;
end;


//  **********************************************
//         Speichern & Laden der Stadt
//  **********************************************

procedure TfrmNavigation.smuSaveClick(Sender: TObject);
var f : TextFile;
    mkDir, setDir : Boolean;
    i,j : Integer;
begin
  mkDir := CreateDir('cities');

  SaveDialog.InitialDir := 'cities\';
  SaveDialog.Filter := 'Stadt Dateien (*.cty)|*.CTY';
  SaveDialog.Title := 'Stadt speichern...';
  if SaveDialog.Execute then
  begin
    if (Copy(SaveDialog.FileName,length(SaveDialog.FileName)-3,4)<>'.cty') then
      AssignFile(f,SaveDialog.FileName + '.cty')
    else
      AssignFile(f,SaveDialog.FileName);
    Rewrite(f);
    writeln(f, city.width);
    writeln(f, city.height);
    writeln(f, city.size);
    for i := 0 to city.height-1 do
    begin
      for j := 0 to city.width -1 do
      begin
        write(f, city.fields[j,i]);
      end;
      writeln(f,'');
    end;
    CloseFile(f);
  end;
  setDir := SetCurrentDir('..\');
end;

procedure TfrmNavigation.smuLoadClick(Sender: TObject);
var f : TextFile;
    line : String;
    mkDir, setDir : Boolean;
    i,j : Integer;
begin
  destroyCity();
  OpenDialog.InitialDir := 'cities\';
  OpenDialog.Filter := 'Stadt Dateien (*.cty)|*.CTY';
  OpenDialog.Title := 'Stadt laden...';
  if OpenDialog.Execute then
  begin
    AssignFile(f,OpenDialog.FileName);
    Reset(f);
    i := 0;
    readln(f, city.width);
    readln(f, city.height);
    readln(f, city.size);
    SetLength(city.fields, city.width, city.height);
    SetLength(city.images, city.width, city.height);
    while not Eof(f) do
    begin
      readln(f,line);
      for j := 0 to length(line)-1 do
      begin
        city.fields[j,i] := Copy(line,j+1,1);
      end;
      i := i+1;
    end;
    CloseFile(f);
  end;
  setDir := SetCurrentDir('..\');
  printCity();
end;

end.
