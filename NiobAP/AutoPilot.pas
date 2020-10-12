unit AutoPilot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls;

type
  TfrmNiobAP = class(TForm)
    MainMenu: TMainMenu;
    mmuAP: TMenuItem;
    smuStarten: TMenuItem;
    smuStoppen: TMenuItem;
    smuBeenden: TMenuItem;
    mmuHilfe: TMenuItem;
    smuInfo: TMenuItem;
    smuLine1: TMenuItem;
    smuHilfe: TMenuItem;
    mmuEinstellungen: TMenuItem;
    smuAutoChat: TMenuItem;
    smuSpielerEinladen: TMenuItem;
    gpbSpielerEinladen: TGroupBox;
    lstSpieler: TListBox;
    Label1: TLabel;
    edtSpielername: TEdit;
    Label2: TLabel;
    edtShortcut: TEdit;
    btnNew: TButton;
    btnEdit: TButton;
    gpbAutoChat: TGroupBox;
    Label3: TLabel;
    edtWartedauer: TEdit;
    Label4: TLabel;
    btnOK: TButton;
    btnOK2: TButton;
    Timer: TTimer;
    ckbAutoChat: TCheckBox;
    procedure smuBeendenClick(Sender: TObject);
    procedure smuStartenClick(Sender: TObject);
    procedure smuStoppenClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure smuSpielerEinladenClick(Sender: TObject);
    procedure lstSpielerClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure smuAutoChatClick(Sender: TObject);
    procedure btnOK2Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure GetInput;
    procedure Run;
    procedure EnterText(AText: String);
  public
    { Public-Deklarationen }
  end;

type TSCut = record
  Name : String;
  Key  : TShortCut;
end;

type TShortCutControl = record
  Strg  : Boolean;
  Alt   : Boolean;
  Shift : Boolean;
  Letter: Boolean;
end;

var
  frmNiobAP: TfrmNiobAP;

  gAbbruch    : Boolean;
  gShortCut   : array[0..20] of TSCut;
  gSCControl  : TShortCutControl;
  gAPMessages : array[1..20] of String;

implementation

{$R *.dfm}

procedure TfrmNiobAP.GetInput;
var i : Integer;
begin
  if  (GetAsyncKeystate($11) < 0)
  and (GetAsyncKeystate($12) < 0) then
    begin
      // Startet den AP
      if (GetAsyncKeystate($53) < 0) then frmNiobAP.smuStarten.Click;
      // Stoppt den AP
      if (GetAsyncKeystate($50) < 0) then frmNiobAP.smuStoppen.Click;
      // Beendet den AP
      if (GetAsyncKeystate($42) < 0) then frmNiobAP.smuBeenden.Click;

      for i := 0 to lstSpieler.Items.Count-1 do
        begin
//          showmessage(floattostr(gShortCut[i].Key));
          if GetAsyncKeystate(gShortCut[i].Key) < 0 then
            begin
              keybd_event(VK_CONTROL, 0, 0, 0);
              EnterText('t');
              keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

              keybd_event(VK_RETURN, 0, 0, 0 );
              keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0 );
              EnterText('/i ' + gShortCut[i].Name);
              keybd_event(VK_RETURN, 0, 0, 0 );
              keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0 );
            end;
        end;

    end;
end;

procedure TfrmNiobAP.Run;
begin
  gAbbruch := false;
  // Autopilot aktiviert
  while not gAbbruch do
    begin
      // ggf. auf Ereignisse reagieren (z.B. Tastatur/Maus)
      Application.ProcessMessages;
      // Tasten abfragen
      GetInput;
    end;
end;

procedure TfrmNiobAP.smuBeendenClick(Sender: TObject);
begin
  // Programm beenden
  gAbbruch := true;
  close;
end;

procedure TfrmNiobAP.smuStartenClick(Sender: TObject);
begin
  smuStarten.Enabled := false;
  smuStoppen.Enabled := true;
  // Starte Autopilot
  
end;

procedure TfrmNiobAP.smuStoppenClick(Sender: TObject);
begin
  // Stoppe Autopilot
  smuStarten.Enabled := true;
  smuStoppen.Enabled := false;
end;

procedure TfrmNiobAP.FormActivate(Sender: TObject);
begin
  gSCControl.Strg   := false;
  gSCControl.Alt    := false;
  gSCControl.Shift  := false;
  gSCControl.Letter := false;

  gAPmessages[1] := 'Ich bin so alleine...';
  gAPmessages[2] := 'Ahh! will net gekickt werden!';
  gAPmessages[3] := '*mich auch noch mal meld*';
  gAPmessages[4] := 'miau';
  gAPmessages[5] := 'mäh';
  gAPmessages[6] := 'blue? - Keiner redet mit mir :(';
  gAPmessages[7] := 'blue? - Was machst du grad?';
  gAPmessages[8] := 'Ich hab keine Lust mehr hier rumzustehen...';
  gAPmessages[9] := 'blue? - Wann lerne ich Missionen fliegen?';
  gAPmessages[10] := 'Darf ich auch mal mit euch Traden gehen?';
  gAPmessages[11] := 'kurz afk';
  gAPmessages[12] := 'back';
  gAPmessages[13] := 'Noch jmd da?';
  gAPmessages[14] := 'Was gibts Neues?';
  gAPmessages[15] := 'Hab ich was verpasst?';
  gAPmessages[16] := 'Will mich hier net mal jmd ablösen?';

  Run;
end;

procedure TfrmNiobAP.btnNewClick(Sender: TObject);
begin
  gShortCut[lstSpieler.Items.Count].Name := 'Spielername';
  gShortCut[lstSpieler.Items.Count].Key := TextToShortCut('Strg+A');
  lstSpieler.Items.Add('Spielername     ' + ShortCutToText (gShortCut[lstSpieler.Items.Count].Key));
  lstSpieler.ItemIndex := lstSpieler.Items.Count-1;
  lstSpielerClick(Sender);
end;

procedure TfrmNiobAP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gAbbruch := true;
end;

procedure TfrmNiobAP.btnOKClick(Sender: TObject);
begin
  gpbSpielerEinladen.Visible := false;
  Run;
end;

procedure TfrmNiobAP.smuSpielerEinladenClick(Sender: TObject);
begin
  gAbbruch := true;
  gpbAutoChat.Visible := false;
  gpbSpielerEinladen.Visible := true;
end;

procedure TfrmNiobAP.lstSpielerClick(Sender: TObject);
begin
  edtSpielername.Text := gShortCut[lstSpieler.ItemIndex].Name;
  edtShortCut.Text := ShortCutToText(gShortCut[lstSpieler.ItemIndex].Key);
end;

procedure TfrmNiobAP.btnEditClick(Sender: TObject);
begin
  gShortCut[lstSpieler.Items.Count].Name := edtSpielername.Text;
  gShortCut[lstSpieler.Items.Count].Key := TextToShortCut(edtShortcut.Text);
  lstSpieler.Items[lstSpieler.ItemIndex] := ('Spielername     ' + ShortCutToText (gShortCut[lstSpieler.Items.Count].Key));
//  lstSpieler.ItemIndex := lstSpieler.Items.Count-1;
//  lstSpielerClick(Sender);
end;

procedure TfrmNiobAP.smuAutoChatClick(Sender: TObject);
begin
  gAbbruch := true;
  gpbSpielerEinladen.Visible := false;
  gpbAutoChat.Visible := true;
end;

procedure TfrmNiobAP.btnOK2Click(Sender: TObject);
begin
  if ckbAutoChat.Checked then
    Timer.Interval := StrToInt(edtWartedauer.Text) * 60000
  else
    Timer.Interval := 0;

  gpbAutoChat.Visible := false;
  Run;
end;

procedure TfrmNIOBAP.EnterText(AText: String);
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

procedure TfrmNiobAP.TimerTimer(Sender: TObject);
Var msg : String;
begin
  Randomize;
  msg := gAPmessages[random(16)+1];

//  keybd_event(VK_CONTROL, 0, 0, 0);
//  EnterText('t');
//  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

  keybd_event(VK_RETURN, 0, 0, 0 );
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0 );
//  EnterText('(Autopilot): ' + msg);
  EnterText(' ');
  keybd_event(VK_RETURN, 0, 0, 0 );
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0 );
end;

end.
