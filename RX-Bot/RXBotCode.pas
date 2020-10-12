unit RXBotCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    btnStartStop: TButton;
    Timer1: TTimer;
    ListBox1: TListBox;
    Memo1: TMemo;
    Edit1: TEdit;
    Image1: TImage;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure btnStartStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type TBilderkennung = record
  Image  : TBitmap;
  Path   : String;
  Letter : Char;
  Width  : Integer;
end;

type TButtons = record
  AdressLeiste: TPoint;
  VenadFeld: TPoint;
  Login: TPoint;
  Code: TPoint;
end;


const CODES_PATH = 'Kontrollcodes.txt';
      URL = 'C:\Program Files (x86)\Mozilla Firefox\firefox.exe';

var gRun : boolean;
    gAuftrag : Integer;
    gBild : array[1..61] of TBilderkennung;
    gVerschiebung : TPoint;
    gLoginFailed : Integer;
    gCodeImage : TImage;
    gButton: TButtons;

// Klickt an die übergebene Position
procedure ClickOn(x: Integer; y: Integer);
begin
  SetCursorPos(x,y);
  mouse_event(MOUSEEVENTF_LEFTDOWN, x, y, 0, 0);
  mouse_event(MOUSEEVENTF_LEFTUP, x, y, 0, 0);
end;

// Kopiert den Text auf dem Bildschirm in das Memofeld
procedure getText(startX: Integer; startY: Integer; endX: Integer);
var x,y : Integer;
begin
{  SetCursorPos(startX,startY);
  mouse_event(MOUSEEVENTF_LEFTDOWN, startX, startY, 0, 0);
  SetCursorPos(endX,startY);
  mouse_event(MOUSEEVENTF_LEFTUP, endX, startY, 0, 0);
}
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(VkKeyScan('a'), 0, 0, 0);
  keybd_event(VkKeyScan('a'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
  sleep(1000);

  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(VkKeyScan('c'), 0, 0, 0);
  keybd_event(VkKeyScan('c'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

  Form1.Memo1.Clear;
  ClickOn(Form1.Left + Form1.Memo1.Left + Trunc(Form1.Memo1.Width/2),Form1.Top + Form1.Memo1.Top + 30);
  sleep(100);

  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(VkKeyScan('v'), 0, 0, 0);
  keybd_event(VkKeyScan('v'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

  Application.ProcessMessages;
end;

// Gibt den Farbcode des Pixels auf dem Bildschirm zurück
function DesktopColor(x,y: integer): TColor;
var c:TCanvas;
begin
  c:=TCanvas.create;
  c.handle:=GetWindowDC(GetDesktopWindow);
  result:=getpixel(c.handle,x,y);
  c.Free;
end;

// Ermittelt die Positionen für Links und Buttons
procedure checkPosition();
var i,j : integer;
begin
// neuer Laptop - Breitbild: 675-474
// Fixpunkt: 546 - 456, schwarz : FF: 516, 407
for j := 450 to 500 do
  for i := 660 to 690 do
  begin
    if (DesktopColor(i,j) = $00000000) and (DesktopColor(i+1,j+1) = $000000BE) and
       (DesktopColor(i+1,j) = $00000000) then
       begin
         gVerschiebung.X := i - gButton.Code.X;
         gVerschiebung.Y := j - gButton.Code.Y;
  //showmessage(inttostr(gVerschiebung.X)+'-'+inttostr(gVerschiebung.Y));
         gAuftrag:=12;
         break;
       end;
  end;
end;

procedure safeLog();
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
    for i := 0 to Form1.ListBox1.Count-1 do
      Writeln(f, Form1.ListBox1.Items[i]);
    { Hier Code einfügen, der ein Flush vor dem Schließen der Datei erfordert }
    Flush(f);  { Sicherstellen, dass der Text in die Datei geschrieben wird }
    CloseFile(f);
end;

// Erstellt ein kleines Log
procedure writeLog(msg: String);
var
  Present: TDateTime;
 begin
  Form1.ListBox1.Items.Add(datetimetostr(Now)+' - '+msg);
  Form1.ListBox1.ItemIndex := Form1.ListBox1.Count-1;
end;

procedure readCodeImage();
var i,j : Integer;
begin
  for j := 0 to 12 do
  begin
    for i := 0 to 80 do
    begin
      gCodeImage.Canvas.Pixels[i,j] := DesktopColor(gButton.Code.X+gVerschiebung.X + i, gButton.Code.Y+gVerschiebung.Y + j);
      Form1.Image1.Canvas.Pixels[i,j] := gCodeImage.Canvas.Pixels[i,j];
    end;
  end;
end;

// Ermittelt den Kontrollcode beim Login
function getCode() : String;
var i,j,k,m : Integer;
    check,treffer : Boolean;
    Code : String;
    width : Integer;
begin
  gCodeImage := TImage.Create(Form1);
  readCodeImage();

  Code := '';
  width := 0;
  for m := 1 to 4 do
  begin
    treffer := true;
    for k := 1 to 61 do
    begin
      check := true;
      for j := 0 to 12 do
      begin
        for i := 0 to 12 do
        begin

          if gBild[k].image.Canvas.Pixels[i,j] <> $00000000 then
          begin
            if (gBild[k].Image.Canvas.Pixels[i,j] <> gCodeImage.Canvas.Pixels[i + width,j]) then
            begin
              check := false;
              break;
            end;
          end;

        end; // end i
        if check = false then break;
      end; // end j
      if check then
      begin
        Code := Code + gBild[k].letter;
//        showmessage(Code);
        width := width + gBild[k].width;
        if gBild[k].letter = 'f' then width := width - 1;
        break;
      end;
    end; // end k
    if check = false then break;
  end; // end m
  if length(Code) = 4 then
    result := Code
  else
    result := 'unbekannt';

  gCodeImage.Free;
end;

// Läd die Informationen (Buchstabe, Breite, Pfad), der einzelnen Zeichen
procedure load();
var f   : TextFile;
    i,j : Integer;
begin
  AssignFile(f, CODES_PATH);
  Reset(f);
  i := 1;
  while not Eof(f) do
  begin
    readln(f, gBild[i].letter);
    readln(f, gBild[i].width);
    readln(f, gBild[i].path);
    gBild[i].image := TBitmap.Create();
    gBild[i].image.LoadFromFile(gBild[i].Path);
    i := i+1;
  end;
  CloseFile(f);
end;

// Sendet an das akuelle Fenster einen Text
procedure EnterText(AText: String);
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

function isMember(letter, wort: String) : Boolean;
var i : Integer;
    Member : Boolean;
begin
  Member := false;
  for i := 1 to (length(wort)-length(letter))+1 do
  begin
//    showmessage(copy(wort,i,length(letter)));
    if copy(wort,i,length(letter)) = letter then Member := true;
  end;
  result := Member;
end;


// Startbutton, um die Auftragsbearbeitung zu starten/stoppen
procedure TForm1.btnStartStopClick(Sender: TObject);
begin
  if btnStartStop.Caption = '&starten' then
    begin
      gAuftrag := 11;

      gRun := true;
      Timer1.Interval := 5000;
      btnStartStop.Caption := 'sto&ppen';
    end
  else
    begin
      gRun := false;
      Timer1.Interval := 0;
      btnStartStop.Caption := '&starten';
    end;
end;

// Abarbeitung der einzelnen Aufgaben
procedure TForm1.Timer1Timer(Sender: TObject);
var x, y, i,j : Integer;
    xPos, yPos : String;
    text : String;
    myColor : TColor;
    hstring : String;
    code : String;
begin
  if gRun then                       
    begin
      gRun := false;

      ClickOn(477+gVerschiebung.X,63+gVerschiebung.Y);

      getText(6+gVerschiebung.X,130+gVerschiebung.Y,103+gVerschiebung.X); // Prüfe auf fehlerhaftem Login
      if isMember('Login',Memo1.Lines[0]) then gAuftrag := 13;

      case gAuftrag of
        0: begin
             myColor := DesktopColor(Mouse.CursorPos.x, Mouse.CursorPos.y);
             ListBox1.Items.Add(IntToStr(Mouse.CursorPos.X)+' - '+IntToStr(Mouse.CursorPos.Y)+' - '+inttostr(myColor));
             Form1.Color := myColor;
             ListBox1.ItemIndex := ListBox1.Count-1;
             gRun := true;
           end;
        12: begin // Login
              gRun := false;
              Timer1.Interval := 0;

              ClickOn(gButton.VenadFeld.X,gButton.VenadFeld.Y); // Venad Feld
              keybd_event(VK_F5, 0, 0, 0);
              keybd_event(VK_F5, 0, KEYEVENTF_KEYUP, 0);
              sleep(1000);
              ClickOn(gButton.VenadFeld.X,gButton.VenadFeld.Y); // Venad Feld

              try
                  for i := -3 to 3 do
                  begin
//                    showmessage('Teste ' + inttostr(i));
                    gVerschiebung.Y := i;
                    code := getCode();
//                    Memo1.Text := code;
//                    if (code = '') then Memo1.Text := 'leer';
//                    Application.ProcessMessages;
//                    sleep(2000);
//                    Memo1.Clear;
                    if length(code) = 4 then break;
                  end;
                //showmessage(code);
              except
                if gLoginFailed = 5 then
                begin
                  writeLog('Programm wird neugestartet');
                  safeLog();
                  ShellExecute(0, 'open', 'RevorixBotCode.exe', nil, nil, SW_NORMAL);
                  Application.ProcessMessages;
                  Application.Terminate;
                end;
                writeLog('Fehler beim Login ('+ inttostr(gLoginFailed)+')');
                gLoginFailed := gLoginFailed + 1;
              end;

              if (code = 'unbekannt') or (code = '') then
              begin
                writeLog('unbekannter Code');
                safeLog();
                gAuftrag := 12;
                if gVerschiebung.Y = 0 then gVerschiebung.Y := -1
                else Timer1.Interval := 1000 * 60 * 5;
              end
              else
              begin
                gLoginFailed := 0;
                writeLog('Code = '+code);
                ClickOn(gButton.VenadFeld.X,gButton.VenadFeld.Y); // Venad Feld
                EnterText('Delta-Quadrant');
                keybd_event(VK_TAB, 0, 0, 0);
                keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0);
                EnterText('blueAngel');
                keybd_event(VK_TAB, 0, 0, 0);
                keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0);

                EnterText('Voyager74656');
                keybd_event(VK_TAB, 0, 0, 0);
                keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0);
                EnterText(code);

                EnterText(chr(13));

                sleep(10000);

                safeLog();
                //ShellExecute(0, 'open', 'RevorixBot.exe', nil, nil, SW_NORMAL);
                Application.ProcessMessages;
                Application.Terminate;
              end;
              gRun := true;
            end;
        13: begin // Login failed
              writeLog('Login failed');
              ClickOn(gButton.VenadFeld.X,gButton.VenadFeld.Y); // Loginfenster aktivieren

              keybd_event(VK_BACK, 0, 0, 0);
              keybd_event(VK_BACK, 0, KEYEVENTF_KEYUP, 0);
              sleep(2000);

              keybd_event(VK_F5, 0, 0, 0);
              keybd_event(VK_F5, 0, KEYEVENTF_KEYUP, 0);

              Timer1.Interval := 5000;
              gAuftrag := 12;
              gRun := true;
            end;
      end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i :integer;
begin
  //ShellExecute(0, 'open', URL, '-new-window http://217.160.164.101/rx/login/', nil, SW_NORMAL);

  gRun := false;
  gLoginFailed := 0;

  gVerschiebung.X := 0;
  gVerschiebung.Y := 0;

  gButton.AdressLeiste.X := 321;
  gButton.AdressLeiste.Y := 65;
  gButton.VenadFeld.X := 660;
  gButton.VenadFeld.Y := 386;
  gButton.Login.X := 717;
  gButton.Login.X := 481;
  gButton.Code.X := 644;
  gButton.Code.Y := 436;

  load();

      gAuftrag := 12;

      gRun := true;
      Timer1.Interval := 5000;
      btnStartStop.Caption := 'sto&ppen';


end;

end.
