unit Sammeln;

interface

uses
  // vordefinierte Klassen
  Windows, SysUtils, Forms, Dialogs, ExtCtrls, ShellAPI, strUtils, ClipBrd,
  // eigene Klassen
  Records, MyIO, Mathematics, Convert;

type
  TSammeln = class(TObject)
  private
    Button      : TButtons;  // Positionen der Links/Buttons
    Speed       : Integer;   // Millisekunden zwischen den einzelnen Klicks
    Zustand     : Integer;   // aktuelle Aufgabe im Timer
    Schiff      : TSchiff;   // aktuelles Schiff
    Fehler      : Integer;   
    Wiederholung: Integer;
    Info        : String;
    Debug       : Boolean;
    stop        : Boolean;
    finish      : Boolean;
    Timer       : TTimer;
    RessTable   : TRessTable;
    RessName    : TRessName;
    IO          : TIO;
    procedure move(richtung: Integer);
    procedure doTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy;
    procedure Sammeln;
    function checkLogin(): Boolean;
    function getInfo : String;
    function getFinishState  : Boolean;
  end;

implementation

const CODES_PATH = 'Kontrollcodes.txt';
      URL = 'http://217.160.164.101/rx/login/';
      MAXWDH = 10;

constructor TSammeln.Create;
begin
  inherited Create;

  finish := false;

  IO := TIO.Create;

  IO.LoadSettings;
  Button := IO.getButtons;
  RessName := IO.getRessName;

  Speed := 3000;
end;

destructor TSammeln.Destroy;
begin
  inherited Destroy;

  IO.Destroy;
end;

function TSammeln.getInfo: String;
begin
  Result := Info;
end;

function TSammeln.getFinishState: Boolean;
begin
  Result := finish;
end;

procedure TSammeln.Sammeln;
begin
  // Timer erstellen und Eigenschaften zuweisen
  Timer := TTimer.Create(nil);
  Timer.OnTimer := doTimer;

  Zustand := 1;
  stop := false;

  Timer.Interval := Speed;
end;

// Prüft, ob der Loginbildschirm angezeigt wird
function TSammeln.checkLogin(): Boolean;
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


// Startbutton, um die Auftragsbearbeitung zu starten/stoppen
procedure TSammeln.move(richtung: Integer);
begin
  with Button do
  begin

  case richtung of
    0: begin // nord
         IO.ClickOn(Navi_Nord.X, Navi_Nord.Y);
         Schiff.neuPos.X := Schiff.neuPos.X;
         Schiff.neuPos.Y := Schiff.neuPos.Y - 1;
         Info := 'Flugrichtung: Nord';
       end;
    1: begin // nord-ost
         IO.ClickOn(Navi_NordOst.X, Navi_NordOst.Y);
         Schiff.neuPos.X := Schiff.neuPos.X + 1;
         Schiff.neuPos.Y := Schiff.neuPos.Y - 1;
         Info := 'Flugrichtung: Nord-Ost';
       end;
    2: begin // ost
         IO.ClickOn(Navi_Ost.X, Navi_Ost.Y);
         Schiff.neuPos.X := Schiff.neuPos.X + 1;
         Schiff.neuPos.Y := Schiff.neuPos.Y;
         Info := 'Flugrichtung: Ost';
       end;
    3: begin // süd-ost
         IO.ClickOn(Navi_SuedOst.X, Navi_SuedOst.Y);
         Schiff.neuPos.X := Schiff.neuPos.X + 1;
         Schiff.neuPos.Y := Schiff.neuPos.Y + 1;
         Info := 'Flugrichtung: Süd-Ost';
       end;
    4: begin // süd
         IO.ClickOn(Navi_Sued.X, Navi_Sued.Y);
         Schiff.neuPos.X := Schiff.neuPos.X;
         Schiff.neuPos.Y := Schiff.neuPos.Y + 1;
         Info := 'Flugrichtung: Süd';
       end;
    5: begin // süd-west
         IO.ClickOn(Navi_SuedWest.X, Navi_SuedWest.Y);
         Schiff.neuPos.X := Schiff.neuPos.X - 1;
         Schiff.neuPos.Y := Schiff.neuPos.Y + 1;
         Info := 'Flugrichtung: Süd-West';
       end;
    6: begin // west
         IO.ClickOn(Navi_West.X, Navi_West.Y);
         Schiff.neuPos.X := Schiff.neuPos.X - 1;
         Schiff.neuPos.Y := Schiff.neuPos.Y;
         Info := 'Flugrichtung: West';
       end;
    7: begin // nord-west
         IO.ClickOn(Navi_NordWest.X, Navi_NordWest.Y);
         Schiff.neuPos.X := Schiff.neuPos.X - 1;
         Schiff.neuPos.Y := Schiff.neuPos.Y - 1;
         Info := 'Flugrichtung: Nord-West';
       end;
  end;

  end;
end;

procedure TSammeln.doTimer(Sender: TObject);
var x, y, i,j : Integer;
    Data : String;
    xPos, yPos : Integer;
    text : String;
    hstring : String;
    code : String;
    Reichweite: Integer;
    Wartezeit: Integer;
    Min, Sek: Integer;
    Stunden,Minuten,Sekunden,HSeks: Word;
    RessAnz: Integer;

    Nrg, Rek, Erz, Org, Syn, Fe, LM, SM, EM, Rad, ES, EG, Iso: TTradeEntry;
begin
  with Button do
  begin
      if Debug = true then Info := 'Fehler: ' + inttostr(Fehler) + ' Wiederholungen: ' + inttostr(Wiederholung) + ' Auftrag: ' + inttostr(Zustand) +
          ' Schiffindex: ' + inttostr(Schiff.Index);

    if checkLogin() then
    begin
      Timer.Interval := 0;
      finish := true;
      ShellExecute(0, 'open', 'RevorixBotCode.exe', nil, nil, SW_NORMAL);
      Application.ProcessMessages;
      Info := 'exit';
    end;

    IO.ClickOn(PopUp.X, PopUp.Y);  // Ressourcen aktualisieren oder Popupblocker wegdrücken

    Data := IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
    if AnsiContainsStr(Data,'Sponsor') then IO.ClickOn(Sponsor.X, Sponsor.Y);

    if (Schiff.Index = Schiff.StopIndex) and
       (Schiff.RessEingeladen = true) and
       (Zustand = 3) then
      begin
        Timer.Interval := 0;
        finish := true;
      end;

      case Zustand of
        1: begin  // Flottenmenü aufrufen
             IO.ClickOn(Flotte.X, Flotte.Y); // Flottenmenü anklicken
             Fehler := 0;
             Zustand := 2;
           end;
        2: begin  // Schiff übernehmen
             IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data,'Flottenname') then
             begin
               Schiff.Anzahl := getSchiffanzahl(Data);

               Schiff.Index := Schiff.Index + 1;
               if Schiff.Index > Schiff.Anzahl then Schiff.Index := 1;

               Schiff.Flottenname := getFlotte(Data,Schiff.Index);
               Schiff.System := getSystem(Data,Schiff.Index);
               if Debug = false then Info := inttostr(Schiff.Index) + '. Flotte: ' + Schiff.Flottenname + ': ' + Schiff.System + ' ';
               if (Schiff.System = 'Nadeschda') or (Schiff.System = 'Sculptor')then
               begin
                 Schiff.Position.X := getXKoord(Data,Schiff.Index);
                 Schiff.Position.Y := getYKoord(Data,Schiff.Index);

                 if Debug = false then Info := Info + inttostr(Schiff.Position.X)+','+inttostr(Schiff.Position.Y);

                 if (Schiff.Anzahl = -1) or (Schiff.Position.X = -1) or (Schiff.Position.Y = -1) or
                    (Schiff.Flottenname = 'error') or (Schiff.System = 'error') then
                 begin
                   Schiff.Index := Schiff.Index - 1;
                   Zustand := 1;
                 end
                 else
                 begin
                   IO.ClickOn(Flotte_uebernehmen.X, Flotte_uebernehmen.Y+(Schiff.Index-1)*22); // übernehmen
                   Zustand := 3;
                 end;
               end
               else
                 Zustand := 1;

               Wiederholung := 0;
             end
             else
             begin
               Wiederholung := Wiederholung + 1;
               if Wiederholung < MAXWDH then Zustand := 2
               else Zustand := 1;
             end
           end;
        3: begin  // Frachtraum auswählen
             IO.getText(NaviClick.X, NaviClick.Y);
             if (AnsiContainsStr(Data,Schiff.Flottenname)) then
             begin
               IO.ClickOn(Navi_Frachtraum.X, Navi_Frachtraum.Y); // Frachtraum-Button
               Zustand := 4;
               Wiederholung := 0;
             end
             else
             begin
               Wiederholung := Wiederholung + 1;
               if Wiederholung < MAXWDH then Zustand := 3
               else Zustand := 1;
             end;
           end;
        4: begin  // Ressourcen prüfen
             IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data,'Schiffsname') then
             begin

               Schiff.Name := getName(Data);
               Schiff.LaderaumAkt := getLaderaumAkt(Data, Schiff.Name);
               Schiff.LaderaumMax := getLaderaumMax(Data, Schiff.Name);
               if Debug = false then Info := Schiff.Flottenname + ' ('+ Schiff.Name + '): ' +
                                       Schiff.System + ' ' + inttostr(Schiff.Position.X) +
                                       ',' + inttostr(Schiff.Position.Y) + ' Laderaum: ' +
                                       inttostr(Schiff.LaderaumAkt) + ' frei';

               RessAnz := getRess(Data);
               if RessAnz <> 0 then
               begin
                 for i := 1 to 14 do
                 begin
                   if (Schiff.Name = 'Yoplanok') or (Schiff.Name = 'Quelwita') or (Schiff.Name = 'Benjoga') or (Schiff.Name='Poliokalis') then
                     IO.ClickOn(Flotte_Plus2.X + 41*(i-1), Flotte_Plus2.Y) // Klickt auf das entsprechende '+++'
                   else
                     IO.ClickOn(Flotte_Plus.X + 41*(i-1), Flotte_Plus.Y); // Klickt auf das entsprechende '+++'
                 end;

                 sleep(100);
                 if (Schiff.Name = 'Yoplanok') or (Schiff.Name = 'Quelwita') or (Schiff.Name = 'Benjoga') or (Schiff.Name='Poliokalis') then
                   IO.ClickOn(Flotte_Zuladen2.X, Flotte_Zuladen2.Y) // Klick auf den Button 'Zuladen'
                 else
                   IO.ClickOn(Flotte_Zuladen.X, Flotte_Zuladen.Y); // Klick auf den Button 'Zuladen'

                 Schiff.RessEingeladen := true;
                 if Schiff.StopIndex = 0 then Schiff.StopIndex := Schiff.Index;
                 sleep(1000);
               end;

               if (Schiff.LaderaumAkt-RessAnz <= 0) then
               begin
                 IO.ClickOn(Navi_Rueckfuehren.X, Navi_Rueckfuehren.Y); // Rückführen Button
                 if Debug = false then Info := Schiff.Name + ' is voll und wird in den Venad geholt.';
                 Zustand := 5;
               end
               else Zustand := 1;

               Wiederholung := 0;
             end
             else
             begin
               Wiederholung := Wiederholung + 1;
               if Wiederholung < MAXWDH then Zustand := 4
               else Zustand := 1;
             end
           end;
        5: begin  // Prüfe Restzeit und rückführen
             IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data,'Rückführung') then
             begin
               if AnsiContainsStr(Data,'bereit') then
               begin
                 IO.ClickOn(Flotte_Rueckfuehren.X, Flotte_Rueckfuehren.Y); // Schiff rückführen Button
                 Zustand := 6;
                 Wiederholung := 0;
               end
               else Zustand := 1;
             end
             else
             begin
               Wiederholung := Wiederholung + 1;
               if Wiederholung < MAXWDH then Zustand := 5
               else Zustand := 1;
             end;
           end;
        6: begin  // zum Dock
             IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data,'zum Dock') then
             begin
               IO.ClickOn(Flotte_zumDock.X, Flotte_zumDock.Y); // zum Dock Link
               Zustand := 7;
               Wiederholung := 0;
             end
             else
             begin
               Wiederholung := Wiederholung + 1;
               if Wiederholung < MAXWDH then Zustand := 6
               else Zustand := 1;
             end
           end;
        7: begin  // Laden / Leeren oben
             IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data,'alle Reaktoren Laden') then
             begin
               IO.ClickOn(Dock_LadenEntladen.X, Dock_LadenEntladen.Y); // alle Frachträume entladen / Reaktoren laden

//               writeLog(Schiff.Name + ': ' + inttostr(Schiff.LaderaumMax)+' Frachteinheiten entladen');
//               writeLog('bisher entladene Gesamtfracht: ' + inttostr(Fracht));
//               writeLog('===================================');
               Zustand := 8;
               Wiederholung := 0;
             end
             else
             begin
               Wiederholung := Wiederholung + 1;
               if Wiederholung < MAXWDH then Zustand := 7
               else Zustand := 1;
             end
           end;
        8: begin  // Portal
             IO.ClickOn(Portal.X, Portal.Y); // Portalmenü Button
             Zustand := 9;
           end;
        9: begin  // Sprung
             IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
             if AnsiContainsStr(Data,'Energiedurchlässigkeit') then
             begin
               IO.ClickOn(Portal_Flottenname.X, Portal_Flottenname.Y); // Flottenname Textfeld
               Application.ProcessMessages;
               sleep(100);

               keybd_event(VK_CONTROL, 0, 0, 0);
               keybd_event(VkKeyScan('a'), 0, 0, 0);
               keybd_event(VkKeyScan('a'), 0, KEYEVENTF_KEYUP, 0);
               keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

               keybd_event(VK_DELETE, 0, 0, 0);
               keybd_event(VK_DELETE, 0, KEYEVENTF_KEYUP, 0);

               IO.EnterText(Schiff.Flottenname);

               if Schiff.System = 'Nadeschda' then
               begin
                 IO.ClickOn(Portal_Sektor.X,Portal_Sektor.Y); // Sektor wählen Button
                 sleep(100);

                 IO.ClickOn(Portal_Feld1.X, Portal_Feld1.Y); // erste Koordinate Feld
                 Application.ProcessMessages;
                 sleep(100);
                 IO.EnterText(inttostr(Schiff.Position.X));
                 Application.ProcessMessages;
                 sleep(100);

                 IO.ClickOn(Portal_Feld2.X, Portal_Feld2.Y); // zweite Koordinate Feld
                 Application.ProcessMessages;
                 sleep(100);
                 IO.EnterText(inttostr(Schiff.Position.Y));
                 sleep(100);

                 Schiff.neuPos.X := Schiff.Position.X;
                 Schiff.neuPos.Y := Schiff.Position.Y;

                 Zustand := 10;
               end;
               if Schiff.System = 'Carmen' then
               begin
                 IO.ClickOn(636,580); // Eintrittsportal
                 sleep(100);
                 IO.ClickOn(636,580); // Eintrittsportal
                 sleep(500);

                 if AnsiContainsStr(Schiff.Name,'Alexis') then Reichweite := 5;
                 if AnsiContainsStr(Schiff.Name,'Luporiotan') then Reichweite := 5;
                 if AnsiContainsStr(Schiff.Name,'Yoplanok') then Reichweite := 7;
                 if AnsiContainsStr(Schiff.Name,'Gikler') then Reichweite := 4;

                 if (Schiff.Position.X >= 24 - Reichweite) and
                    (Schiff.Position.X <= 24 + Reichweite) and
                    (Schiff.Position.Y >= 10 - Reichweite) and
                    (Schiff.Position.Y <= 10 + Reichweite) then
                     begin
                       for i := 1 to 2 do
                       begin
                         keybd_event(VK_DOWN, 0, 0, 0);
                         keybd_event(VK_DOWN, 0, KEYEVENTF_KEYUP, 0);
                         Application.ProcessMessages;
                         sleep(300);
                       end;

                       Schiff.neuPos.X := 24;
                       Schiff.neuPos.Y := 10;
                     end
                 else if (Schiff.Position.X >= 6 - Reichweite) and
                    (Schiff.Position.X <= 6 + Reichweite) and
                    (Schiff.Position.Y >= 11 - Reichweite) and
                    (Schiff.Position.Y <= 11 + Reichweite) then
                     begin
                       for i := 1 to 3 do
                       begin
                         keybd_event(VK_DOWN, 0, 0, 0);
                         keybd_event(VK_DOWN, 0, KEYEVENTF_KEYUP, 0);
                         Application.ProcessMessages;
                         sleep(300);
                       end;

                       Schiff.neuPos.X := 6;
                       Schiff.neuPos.Y := 11;
                     end
                 else if (Schiff.Position.X >= 2 - Reichweite) and
                    (Schiff.Position.X <= 2 + Reichweite) and
                    (Schiff.Position.Y >= 16 - Reichweite) and
                    (Schiff.Position.Y <= 16 + Reichweite) then
                     begin
                       for i := 1 to 4 do
                       begin
                         keybd_event(VK_DOWN, 0, 0, 0);
                         keybd_event(VK_DOWN, 0, KEYEVENTF_KEYUP, 0);
                         Application.ProcessMessages;
                         sleep(300);
                       end;

                       Schiff.neuPos.X := 2;
                       Schiff.neuPos.Y := 16;
                     end
                 else if (Schiff.Position.X >= 24 - Reichweite) and
                    (Schiff.Position.X <= 24 + Reichweite) and
                    (Schiff.Position.Y >= 17 - Reichweite) and
                    (Schiff.Position.Y <= 17 + Reichweite) then
                     begin
                       for i := 1 to 5 do
                       begin
                         keybd_event(VK_DOWN, 0, 0, 0);
                         keybd_event(VK_DOWN, 0, KEYEVENTF_KEYUP, 0);
                         Application.ProcessMessages;
                         sleep(300);
                       end;

                       Schiff.neuPos.X := 24;
                       Schiff.neuPos.Y := 17;
                     end
                 else if (Schiff.Position.X >= 29 - Reichweite) and
                    (Schiff.Position.X <= 29 + Reichweite) and
                    (Schiff.Position.Y >= 17 - Reichweite) and
                    (Schiff.Position.Y <= 17 + Reichweite) then
                     begin
                       for i := 1 to 6 do
                       begin
                         keybd_event(VK_DOWN, 0, 0, 0);
                         keybd_event(VK_DOWN, 0, KEYEVENTF_KEYUP, 0);
                         Application.ProcessMessages;
                         sleep(300);
                       end;

                       Schiff.neuPos.X := 29;
                       Schiff.neuPos.Y := 17;
                     end;

                 Zustand := 10;
               end;
               IO.ClickOn(Portal_Wurmloch.X, Portal_Wurmloch.Y); // Wurmloch Button

//               writeLog('Schiffsname: '+Schiff.Name+' System: '+Schiff.System+' Position: '+inttostr(Schiff.Position.X)+','+inttostr(Schiff.Position.Y)+
//                        ' neuPos: '+inttostr(Schiff.neuPos.X)+','+inttostr(Schiff.neuPos.Y));

               Wiederholung := 0;
             end
             else
             begin
               Wiederholung := Wiederholung + 1;
               if Wiederholung < MAXWDH then Zustand := 9
               else Zustand := 1;
             end;
           end;
        10: begin
              IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
              if AnsiContainsStr(Data,'Sprung erfolgreich durchgeführt.') then
              begin
                IO.ClickOn(Portal_uebernehmen.X, Portal_uebernehmen.Y); // Flotte Übernehmen
                if Schiff.System = 'Carmen' then Zustand := 11;
                if Schiff.System = 'Nadeschda' then Zustand := 3;
              end
              else
              begin
                Wiederholung := Wiederholung + 1;
                if Wiederholung < MAXWDH then Zustand := 10
                else Zustand := 1;
              end;
            end;
        11: begin  // Vom Portal zum Ziel fliegen
              Data := IO.getText(Button.NeueSeiteClick.X, Button.NeueSeiteClick.Y);
              hString := Data;

              if AnsiContainsText(hString,'X:'+inttostr(Schiff.neuPos.X)) and
                 AnsiContainsText(hString,'Y:'+inttostr(Schiff.neuPos.Y)) and
                 AnsiContainsStr(Data,'Delta') then
              begin
                Data := IO.getText(NeueSeiteClick.X, NeueSeiteClick.Y);
                hString := Data;
                if AnsiContainsText(hString,'Carmen') then
                begin
                  for i := 1 to length(hString) do
                  begin
                    if Copy(hString,i,1) = ' ' then hString := Copy(hString,i+1,length(hString));
                  end;

                  for i := 1 to length(hString) do
                  begin
                    if Copy(hstring,i,1) = ' ' then
                    begin
                      try
                        xPos := strtoint(Copy(hString,3,i-3));
                        yPos := strtoint(Trim(Copy(hString,i+3,length(hString)-i-3)));
                      except
                        on E: Exception do
                        begin
//                          writeLog('Folgender Fehler ist aufgetreten: '+E.Message);
                          xPos := -1;
                          yPos := -1;
                        end;
                      end;
                    end;
                  end;
                  Application.ProcessMessages;

                  if (xPos = Schiff.Position.X) and (yPos > Schiff.Position.Y) then move(0); // nord
                  if (xPos < Schiff.Position.X) and (yPos > Schiff.Position.Y) then move(1); // nord-ost
                  if (xPos < Schiff.Position.X) and (yPos = Schiff.Position.Y) then move(2); // ost
                  if (xPos < Schiff.Position.X) and (yPos < Schiff.Position.Y) then move(3); // süd-ost
                  if (xPos = Schiff.Position.X) and (yPos < Schiff.Position.Y) then move(4); // süd
                  if (xPos > Schiff.Position.X) and (yPos < Schiff.Position.Y) then move(5); // süd-west
                  if (xPos > Schiff.Position.X) and (yPos = Schiff.Position.Y) then move(6); // west
                  if (xPos > Schiff.Position.X) and (yPos > Schiff.Position.Y) then move(7); // nord-west

                  if (xPos = Schiff.Position.X) and (yPos = Schiff.Position.Y) then
                  begin
                    Zustand := 3;
                  end;

                  Wiederholung := 0;
                end
                else
                begin
                  Wiederholung := Wiederholung + 1;
                  if Wiederholung < MAXWDH then Zustand := 11
                  else Zustand := 1;
                end;
              end
              else // fehlerhafter Sprung
              begin
                IO.ClickOn(566,625);  // Quantensprung
                Zustand := 12;
              end;
            end;
        12: begin  // Quantensprung
              if AnsiContainsStr(Data,'Sprungziel') then
              begin
                 IO.ClickOn(190,308); // Sektor wählen Button
                 sleep(100);

                 IO.ClickOn(470,308); // erste Koordinate Feld
                 IO.EnterText('17');
                 sleep(100);
                 IO.ClickOn(522,308); // zweite Koordinate Feld
                 IO.EnterText('5');
                 sleep(100);

                 Schiff.System := 'Nadeschda';
                 Schiff.neuPos.X := 17;
                 Schiff.neuPos.Y := 5;

                 IO.ClickOn(576,362); // Wurmloch Button

//                 writeLog('Schiffsname: '+Schiff.Name+' System: '+Schiff.System+' Position: '+inttostr(Schiff.Position.X)+','+inttostr(Schiff.Position.Y)+
//                          ' neuPos: '+inttostr(Schiff.neuPos.X)+','+inttostr(Schiff.neuPos.Y));

                 Wiederholung := 0;

                 Zustand := 1;
              end
              else
              begin
                Wiederholung := Wiederholung + 1;
                if Wiederholung < MAXWDH then Zustand := 12
                else Zustand := 1;
              end;

            end;
      end;

  end;
end;


end.
