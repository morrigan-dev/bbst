unit Handel;

interface

uses
  // vordefinierte Klassen
  Windows, SysUtils, Classes, Forms, Dialogs, ExtCtrls,  ShellAPI, strUtils,
  // eigene Klassen
  Records, MyIO, Mathematics, Convert;

type
  THandel = class(TObject)
  private
    Button      : TButtons;    // Positionen der Links/Buttons
    billigRess  : THandelsGut; // momentan günstigsten Ress (Erz - Iso)
    Speed       : Integer;     // Millisekunden zwischen den einzelnen Klicks
    Zustand     : Integer;     // aktuelle Aufgabe im Timer
    Info        : String;      // Infozeile zur Ausgabe der aktuellen Aufgabe
    HandelSeite : Integer;     // Zählvariable für die einzelnen Direkt-Handel Seiten
    Rohdaten    : String;      // Text aus der Zwischenablage
    stop        : Boolean;     // Schalter für den Timer - bei true wird der Timer nicht ausgeführt
    finish      : Boolean;     // Schalter für den Direkthandel - ist true wenn alle Daten gesammelt und ausgewertet wurden
    RessTable   : TRessTable;  // Liste aller Handelsgüter im Direkthandel
    RessName    : TRessName;   // Liste aller Ressourcen in Langform
    Timer       : TTimer;      // Hauptmodul zur Steuerung der Aufgaben
    IO          : TIO;         // E/A Methoden

    function convertRess(ress: String)      : Integer;
    function getBilligstes(element: String) : TTradeEntry;
    function checkLogin()                   : Boolean;
    procedure createTable;
    procedure doTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy;
    function getBilligsteNrg : TTradeEntry;
    function getBilligsteRek : TTradeEntry;
    function getBilligsteErz : TTradeEntry;
    function getBilligsteOrg : TTradeEntry;
    function getBilligsteSyn : TTradeEntry;
    function getBilligsteFe  : TTradeEntry;
    function getBilligsteLM  : TTradeEntry;
    function getBilligsteSM  : TTradeEntry;
    function getBilligsteEM  : TTradeEntry;
    function getBilligsteRad : TTradeEntry;
    function getBilligsteES  : TTradeEntry;
    function getBilligsteEG  : TTradeEntry;
    function getBilligsteIso : TTradeEntry;
    function getCount        : Integer;
    function getInfo         : String;
    function getFinishState  : Boolean;
    procedure updateData;
    procedure setStopState;
    procedure getBilligsteAll(var Nrg, Rek, Erz, Org, Syn, Fe, LM, SM, EM, Rad, ES, EG, Iso: TTradeEntry);
end;

implementation

// ******************************************************
//  **************** public Declaration ****************
//   **************************************************

constructor THandel.Create;
begin
  inherited Create;

  finish := false;

  IO := TIO.Create;

  IO.LoadSettings;
  Button := IO.getButtons;
  RessName := IO.getRessName;

  Speed := 3000;
end;

destructor THandel.Destroy;
begin
  inherited Destroy;
  IO.Destroy;
end;

{ function getBilligXXX
  Diese Funktionen geben jeweils den billigsten Ressourceneintrag zurück.
}
function THandel.getBilligsteNrg: TTradeEntry;
begin
  Result := billigRess.Nrg;
end;

function THandel.getBilligsteRek: TTradeEntry;
begin
  Result := billigRess.Rek;
end;

function THandel.getBilligsteErz: TTradeEntry;
begin
  Result := billigRess.Erz;
end;

function THandel.getBilligsteOrg: TTradeEntry;
begin
  Result := billigRess.Org;
end;

function THandel.getBilligsteSyn: TTradeEntry;
begin
  Result := billigRess.Syn;
end;

function THandel.getBilligsteFe: TTradeEntry;
begin
  Result := billigRess.Fe;
end;

function THandel.getBilligsteLM: TTradeEntry;
begin
  Result := billigRess.LM;
end;

function THandel.getBilligsteSM: TTradeEntry;
begin
  Result := billigRess.SM;
end;

function THandel.getBilligsteEM: TTradeEntry;
begin
  Result := billigRess.SM;
end;

function THandel.getBilligsteRad: TTradeEntry;
begin
  Result := billigRess.Rad;
end;

function THandel.getBilligsteES: TTradeEntry;
begin
  Result := billigRess.ES;
end;

function THandel.getBilligsteEG: TTradeEntry;
begin
  Result := billigRess.EG;
end;

function THandel.getBilligsteIso: TTradeEntry;
begin
  Result := billigRess.Iso;
end;

{ function getCount
  Liefert die Anzahl der Handelseinträge, die eingelesen wurden.
}
function THandel.getCount: Integer;
begin
  Result := length(RessTable)-1;
end;

{ function getInfo
  Liefert eine kleine Info zu der aktuellen Aufgabe,
  die im Timer ausgeführt wird.
}
function THandel.getInfo: String;
begin
  Result := Info;
end;

{ function getFinishState
  Gibt true zurück, sobald alle Daten gesammelt und ausgewertet wurden
  und somit zum Abruf bereit stehen.
  Die Klasse handel ist im Wartezustand
}
function THandel.getFinishState: Boolean;
begin
  Result := finish;
end;

{ procedure: updateData
  Initialisiert die Klassenvariablen und startet den Timer.
}
procedure THandel.updateData;
begin
  Timer := TTimer.Create(nil);
  Timer.OnTimer := doTimer;

  Rohdaten := '';
  setLength(RessTable, 0);
  Zustand := 1;
  stop := false;

  Timer.Interval := Speed;
end;

{ procedure setStopState
  Hällt den Timer an und stellt die Klasse auf den Wartezustand
}
procedure THandel.setStopState;
begin
  stop := true;
  Timer.Interval := 0;
  finish := true;
end;

{ procedure getBilligsteAll
  Prozedure mit call by value Parametern.
  Jeweils die billigsten Handelsgüter werden zurückgegeben.
}
procedure THandel.getBilligsteAll(var Nrg, Rek, Erz, Org, Syn, Fe, LM, SM, EM, Rad, ES, EG, Iso: TTradeEntry);
begin
  Nrg := billigRess.Nrg;
  Rek := billigRess.Rek;
  Erz := billigRess.Erz;
  Org := billigRess.Org;
  Syn := billigRess.Syn;
  Fe  := billigRess.Fe;
  LM  := billigRess.LM;
  SM  := billigRess.SM;
  EM  := billigRess.EM;
  Rad := billigRess.Rad;
  ES  := billigRess.ES;
  EG  := billigRess.EG;
  Iso := billigRess.Iso;
end;


// *******************************************************
//  ***************** private Declaration ***************
//   ***************************************************

{ Wandelt die aus der Zwischenablage kommenden Ressourcenkürzel
  in eine Zahl um, mit der aus der RessName Tabelle die Langform
  ausgelesen werden kann.
}
function THandel.convertRess(ress: String): Integer;
begin
  if ress = 'Cr' then result := 1
  else if ress = 'Nrg' then result := 2
  else if ress = 'Rek' then result := 3
  else if ress = 'Erz' then result := 4
  else if ress = 'Org' then result := 5
  else if ress = 'Synth' then result := 6
  else if ress = 'Fe' then result := 7
  else if ress = 'LM' then result := 8
  else if ress = 'SM' then result := 9
  else if ress = 'EM' then result := 10
  else if ress = 'Rad' then result := 11
  else if ress = 'ES' then result := 12
  else if ress = 'EG' then result := 13
  else if ress = 'Iso' then result := 14
  else result := 0;
end;

function THandel.getBilligstes(element: String): TTradeEntry;
var i: Integer;
begin
  for i := 0 to length(RessTable)-1 do
  begin
    if element = RessTable[i].Ressource then
    begin
      Result.Ressource := RessTable[i].Ressource;
      Result.Menge     := RessTable[i].Menge;
      Result.Preis     := RessTable[i].Preis;
      Result.Venad     := RessTable[i].Venad;
      Result.Clan      := RessTable[i].Clan;
      Result.EndetAm   := RessTable[i].EndetAm;
      Result.EndetIn   := RessTable[i].EndetIn;
      break;
    end;
  end;
end;

// Prüft, ob der Loginbildschirm angezeigt wird
function THandel.checkLogin(): Boolean;
var x,y,i : Integer;
    Data : String;
begin
  Data := IO.getText(Button.NeueSeiteClick.X, Button.NeueSeiteClick.Y);
  if (AnsiContainsStr(Data,'Ungültige Session'))
  or (AnsiContainsStr(Data,'Keine Berechtigung')) then
  begin
    IO.ClickOn(Button.Schliessen.X, Button.Schliessen.Y);
    sleep(1000);

    result := true;
  end
  else result := false;
end;

{ Erstellt aus dem kopierten Text der Zwischenablage
  eine Tabelle mit den einzelnen Handelseinträgen.
}
procedure THandel.createTable;
var Line, Daten: String;
    Umbruch: Integer;
    i, j, tabIndex: Integer;
    weiterAuslesen: Boolean;
    Venad: String;
    formatSettings: TFormatSettings;
begin

  Daten := Rohdaten;
  tabIndex := 0;
  j := 0;

  while Daten <> '' do
  begin
    Umbruch := Pos(chr(13)+chr(10),Daten);
    Line := Copy(Daten, 1, Umbruch+1);
    delete(Daten, 1, Umbruch+1);
    weiterAuslesen := false;
    setLength(RessTable,tabIndex+1);

    // Lese Ressource aus
    if length(Line) > 5 then
    begin
    for i := 1 to 6 do
    begin
      if isDigit(Line[i]) then
      begin
        if convertRess(Copy(Line,1,i-1)) <> 0 then
        begin
          weiterAuslesen := true;
          RessTable[tabIndex].Ressource := RessName[convertRess(Copy(Line,1,i-1))];
          Delete(Line,1,i-1); // Lösche den Ressourcentext
        end;
        break;
      end;
    end;
    end;

    if weiterAuslesen then
    begin
      // Lese Menge aus
      RessTable[tabIndex].Menge := strtoint(Copy(Line,1,Pos('z',Line)-2));
      Delete(Line,1,Pos('z',Line)+2);

      // Lese Preis aus
      RessTable[tabIndex].Preis := StrToFloat(Copy(Line,1,Pos('.',Line)-1)+','+Copy(Line,Pos('.',Line)+1,2));
      Delete(Line,1,Pos('C',Line)+2);

      // Lösche die Beschreibung mit den runden Klammern
      Delete(Line, Pos('(', Line), Pos(chr(9), Line)-Pos('(', Line));
      // Lösche Leerzeichen + Tabschritt
      Delete(Line,1,2);

      // Lese Venad aus
      Venad := Copy(Line,1,Pos(chr(9),Line)-1);
      if Pos('[', Venad) <> 0 then
      begin
        RessTable[tabIndex].Venad := Copy(Venad,1,Pos('[', Venad)-1);
        RessTable[tabIndex].Clan := Copy(Venad,Pos('[', Venad)+1,Pos(']', Venad)-Pos('[', Venad)-1);
      end
      else RessTable[tabIndex].Venad := Venad;
      Delete(Line,1,Pos(chr(9),Line));

      // Lese EndetAm aus
      GetLocaleFormatSettings(1033, formatSettings);
      formatSettings.DateSeparator := '-';
      formatSettings.ShortDateFormat := 'yyyy-mm-dd';
      formatSettings.TimeSeparator := ':';
      formatSettings.ShortTimeFormat := 'hh:mm:ss';
      RessTable[tabIndex].EndetAm := StrToDateTime(Copy(Line,1,Pos(chr(9),Line)-1),formatSettings);
      Delete(Line,1,Pos(chr(9),Line));

      if RessTable[tabIndex].Menge > 0 then tabIndex := tabIndex + 1;
    end;
    j := j + 1;
  end;

  // Sortiere Tabelle
  RessTable := sortiere(RessTable, 'Preis');
  RessTable := sortiere(RessTable, 'Ressource');
end;

{ Arbeitet die einzelnen Aufgaben ab
  1: Ruft die Handel-Seite auf
  2: Ruft den Direkthandel auf
  3: Kopiert die einzelnen Seiten bis keine Folgeseite mehr existiert und
     wertet anschließend die Daten aus.
     Setzt nach Abschluss der Auswertung die Klasse auf den Wartezustand
}
procedure THandel.doTimer(Sender: TObject);
var Data : String;
begin
  if not stop then
  begin
    with Button do
    begin
      // Prüfe auf ungültige Session
      if checkLogin() then
      begin
        Timer.Interval := 0;
        finish := true;
        ShellExecute(0, 'open', 'RevorixBotCode.exe', nil, nil, SW_NORMAL);
        Application.ProcessMessages;
        Info := 'exit';
      end;

      // Ressourcen aktualisieren oder Popupblocker wegdrücken
      IO.ClickOn(PopUp.X, PopUp.Y);

      Data := IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
      if AnsiContainsStr(Data,'Sponsor') then IO.ClickOn(Sponsor.X, Sponsor.Y);

      // ***** Abarbeitung der einzelnen Aufgaben *****
      case Zustand of
        0: begin
             IO.ClickOn(Button.Konstruktionen.X, Button.Konstruktionen.Y);
             sleep(3000);
             IO.ClickOn(Button.Konstruktionen_Quartiere.X, Button.Konstruktionen_Quartiere.Y);
             sleep(3000);
             Zustand := 1;
           end;
        1: begin
             IO.ClickOn(Handel.X, Handel.Y); // Handelsmenü Button
             Zustand := 2;
           end;
        2: begin  // Ressourcen-Direkthandel
             Data := IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data, 'Angebote') then
             begin
               IO.ClickOn(Handel_Direkthandel.X, Handel_Direkthandel.Y); // Direkthandel Button
               HandelSeite := 0;
               Zustand := 3;
             end;
           end;
        3: begin  // Kopiere Einträge
             stop := true;
             Data := Io.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data, 'Beschreibung') then
             begin
               if not AnsiContainsStr(Rohdaten, Data) then Rohdaten := Rohdaten + Data;
               HandelSeite := HandelSeite + 1;
               IO.ClickOn(Handel_Weiter.X, Handel_Weiter.Y); // Direkthandel Button
               if (HandelSeite = 8) or (not AnsiContainsStr(Data, 'weiter')) then
               begin
                 createTable;

                 with billigRess do
                 begin
                   Nrg := getBilligstes('Energie');
                   Rek := getBilligstes('Rekruten');
                   Erz := getBilligstes('Erz');
                   Org := getBilligstes('org. Verbindungen');
                   Syn := getBilligstes('synth. Verbindungen');
                   Fe := getBilligstes('Eisenmetalle');
                   LM := getBilligstes('Leichtmetalle');
                   SM := getBilligstes('Schwermetalle');
                   EM := getBilligstes('Edelmetalle');
                   Rad := getBilligstes('radioaktive Stoffe');
                   ES  := getBilligstes('Edelsteine');
                   EG  := getBilligstes('Edelgase');
                   Iso := getBilligstes('instabile Isotope');
                 end;

                 Timer.Interval := 0;
                 finish := true;
               end;
             end;
             stop := false;
           end;
      end;
    end;
  end;
end;

end.
