unit automsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    APmessages : array[1..50] of String;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

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

procedure GetScreenShot (var ABitmap : TBitmap);   
var   
  DC : THandle;   
begin   
  if Assigned(ABitmap) then                  // Prüfen ob gültiges Bitmap übergeben wurde   
  begin   
    DC := GetDC(0);                          // Desktop DC holen   
    try
      ABitmap.Width := Screen.Width;           // Bitmapgrösse den...
      ABitmap.Height := Screen.Height;         // Bildschirm anpassen
{      BitBlt(ABitmap.Canvas.Handle,            // Dekstop
             0,0,Screen.Width,Screen.Height,   // in
             DC,                               // das
             0,0,                              // Bitmap
             SrcCopy                           // kopieren
        );}
    finally   
      ReleaseDC(0, DC);                        // DC wieder freigeben   
    end;   
  end;   
end; 

procedure TForm1.Timer1Timer(Sender: TObject);
Var msg : String;
    bild : TBitmap;
begin
  Randomize;
  msg := APmessages[random(16)+1];

  keybd_event(VK_CONTROL, 0, 0, 0);
  EnterText('t');
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

  keybd_event(VK_RETURN, 0, 0, 0 );
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0 );
  EnterText('(Autopilot): ' + msg);
  keybd_event(VK_RETURN, 0, 0, 0 );
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0 );

{  bild := TBitmap.Create;
  try
    GetScreenShot(bild);
    Image1.Picture.Assign(bild);
  finally
    bild.Free;
  end;
}
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  APmessages[1] := 'Ich bin so alleine...';
  APmessages[2] := 'Ahh! will net gekickt werden!';
  APmessages[3] := '*mich auch noch mal meld*';
  APmessages[4] := 'miau';
  APmessages[5] := 'mäh';
  APmessages[6] := 'blue? - Keiner redet mit mir :(';
  APmessages[7] := 'blue? - Was machst du grad?';
  APmessages[8] := 'Ich hab keine Lust mehr hier rumzustehen...';
  APmessages[9] := 'blue? - Wann lerne ich Missionen fliegen?';
  APmessages[10] := 'Darf ich auch mal mit euch Traden gehen?';
  APmessages[11] := 'kurz afk';
  APmessages[12] := 'back';
  APmessages[13] := 'Noch jmd da?';
  APmessages[14] := 'Was gibts Neues?';
  APmessages[15] := 'Hab ich was verpasst?';
  APmessages[16] := 'huhu Nemo :)';
end;

end.
