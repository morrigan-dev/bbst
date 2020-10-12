unit MyIO;

interface

uses Windows, SysUtils, Classes, Forms, StdCtrls, ShellAPI, ClipBrd,
     Records;

type
  TIO = class(TObject)

  private
    RessName: TRessName;
    Button: TButtons;
    function getKoord(s1, s2: string): TPoint;
  public
    constructor Create;
    destructor Destroy;
    procedure ClickOn(x, y: Integer);
    function getText(x, y: Integer): String;
    procedure EnterText(AText: String);
    procedure safeLog(listBox: TListBox);
    procedure writeLog(s: string);
    procedure LoadSettings;
    function getRessName: TRessName;
    function getButtons: TButtons;
  end;

implementation

// ***************** private ****************************

function TIO.getKoord(s1, s2: string): TPoint;
var Position: Integer;
    X, Y: Integer;
begin
  Position := Pos('=',s1)+1;
  X := strtoint(Copy(s1,Position,length(s1)-Position+1));

  Position := Pos('=',s2)+1;
  Y := strtoint(Copy(s2,Position,length(s2)-Position+1));

  Result := Point(X,Y);
end;


// ***************** public *****************************

constructor TIO.Create;
begin
  inherited Create;
end;

destructor TIO.Destroy;
begin
  inherited Destroy;
end;

// Klickt an die übergebene Position
procedure TIO.ClickOn(x, y: Integer);
begin
  SetCursorPos(x,y);
  mouse_event(MOUSEEVENTF_LEFTDOWN, x, y, 0, 0);
  mouse_event(MOUSEEVENTF_LEFTUP, x, y, 0, 0);

  Application.ProcessMessages;
  sleep(20);
end;

// Kopiert den Text auf dem Bildschirm in das Memofeld
function TIO.getText(x, y: Integer): String;
begin
  ClickOn(x,y);
  Application.ProcessMessages;
  sleep(100);

  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(VkKeyScan('a'), 0, 0, 0);
  keybd_event(VkKeyScan('a'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

  Application.ProcessMessages;
  sleep(100);

  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(VkKeyScan('c'), 0, 0, 0);
  keybd_event(VkKeyScan('c'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
  try
    result := Clipboard.AsText;
    if Clipboard.HasFormat(CF_TEXT) then Clipboard.Clear;
  except
    on E: Exception do
    begin
      result := E.Message+ '; Text konnte nicht kopiert werden';
    end;
  end;
end;

// Sendet an das akuelle Fenster einen Text
procedure TIO.EnterText(AText: String);
var lCount     : Integer;
    lScanCode  : Smallint;
    lWithAlt,
    lWithCtrl,
    lWithShift : Boolean;
begin
  for lCount := 1 To Length(AText) Do
  begin
    lScanCode := VkKeyScan(AText[lCount]);
    //Ermitteln ob Shift gedrückt wurde
    lWithShift := lScanCode and (1 shl 8)  <> 0;
    //Ermitteln ob Strg gedrückt wurde
    lWithCtrl  := lScanCode and (1 shl 9)  <> 0;
    //Ermitteln ob Alt gedrückt wurde
    lWithAlt   := lScanCode and (1 shl 10) <> 0;

    if lWithShift then
      keybd_event(VK_SHIFT, 0, 0, 0);
    if lWithCtrl then
      keybd_event(VK_CONTROL, 0, 0, 0);
    if lWithAlt then
      keybd_event(VK_MENU, 0, 0, 0);

    keybd_event(lScanCode, 0, 0, 0);
    keybd_event(lScanCode, 0, KEYEVENTF_KEYUP, 0);

    if lWithAlt then 
      keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);
    if lWithCtrl then
      keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
    if lWithShift then
      keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
  end; 
end;

procedure TIO.safeLog(listBox: TListBox);
var f : TextFile;
    i : integer;
begin
    if not fileexists('log.txt') then
    begin
      AssignFile(f, 'log.txt');
      Rewrite(f);
      CloseFile(f);
    end;

    AssignFile(f, 'log.txt');
    Append(f);
    for i := 0 to listBox.Count-1 do
      Writeln(f, listBox.Items[i]);
    { Hier Code einfügen, der ein Flush vor dem Schließen der Datei erfordert }
    Flush(f);  { Sicherstellen, dass der Text in die Datei geschrieben wird }
    CloseFile(f);
end;

procedure TIO.writeLog(s: string);
var f : TextFile;
    i : integer;
begin
    if not fileexists('log.txt') then
    begin
      AssignFile(f, 'log.txt');
      Rewrite(f);
      CloseFile(f);
    end;

    AssignFile(f, 'log.txt');
    Append(f);
    Writeln(f, s);
    { Hier Code einfügen, der ein Flush vor dem Schließen der Datei erfordert }
    Flush(f);  { Sicherstellen, dass der Text in die Datei geschrieben wird }
    CloseFile(f);
end;

procedure TIO.LoadSettings;
var f : TextFile;
    s1, s2: string;
    i : integer;
begin
    AssignFile(f, 'config.txt');
    Reset(f);
    Readln(f, s1);  // Head
    for i := 0 to 14 do
      Readln(f, RessName[i]);

    Readln(f, s1);  // Leerzeile
    Readln(f, s1);  // Head

    with Button do
    begin
      Readln(f, s1); Readln(f, s2); Schliessen := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); NeueSeiteClick := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); NaviClick := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); AdressLeiste := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); PopUp := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); News := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Konstruktionen := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Konstruktionen_Quartiere := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Dock := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Dock_LadenEntladen := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Flotte := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Flotte_uebernehmen := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Flotte_Plus := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Flotte_Plus2 := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Flotte_Zuladen := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Flotte_Zuladen2 := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Flotte_Rueckfuehren := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Flotte_zumDock := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Portal := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Portal_Flottenname := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Portal_Sektor := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Portal_Feld1 := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Portal_Feld2 := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Portal_Wurmloch := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Portal_uebernehmen := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Navi_Frachtraum := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_Rueckfuehren := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_Nord := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_NordOst := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_Ost := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_SuedOst := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_Sued := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_SuedWest := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_West := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Navi_NordWest := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Aktien := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Depot := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Handel := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Handel_Direkthandel := getKoord(s1,s2);
      Readln(f, s1); Readln(f, s2); Handel_Weiter := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); EigeneAngebote := getKoord(s1,s2);

      Readln(f, s1); Readln(f, s2); Sponsor := getKoord(s1,s2);

    end;

    CloseFile(f);
end;

function TIO.getRessName: TRessName;
begin
  Result := RessName;
end;

function TIO.getButtons: TButtons;
begin
  Result := Button;
end;

end.
