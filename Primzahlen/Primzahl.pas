unit Primzahl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmPrimzahlen = class(TForm)
    cmdBerechne: TButton;
    lblInfo1: TLabel;
    lstPrimzahlen: TListBox;
    lblPrimAnzahl: TLabel;
    Timer1: TTimer;
    cmdUnterbrechung: TButton;
    procedure cmdBerechneClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure cmdUnterbrechungClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrimzahlen: TfrmPrimzahlen;

implementation

{$R *.dfm}
var gaktZahl : integer;
    gPrimAnzahl : integer;

procedure TfrmPrimzahlen.cmdBerechneClick(Sender: TObject);
begin
if (timer1.Interval = 0) and (cmdUnterbrechung.Enabled = False) Then
  begin
    lstPrimzahlen.Clear;
    gPrimAnzahl := 1;
    lblPrimAnzahl.Caption := 'Anzahl der bereits berechneten Primzahlen:' + inttostr(gPrimAnzahl);
    lstPrimzahlen.Items.Add('1');
    gaktZahl := 1;
    cmdBerechne.Caption := 'Berechnung &beenden';
    cmdUnterbrechung.Caption := '&Pause';
    cmdUnterbrechung.Enabled := True;
    timer1.Interval := 1;
  end
else
  begin
    cmdBerechne.Caption := 'Berechnung &starten';
    cmdUnterbrechung.Caption := '&Pause';
    cmdUnterbrechung.Enabled := False;
    timer1.Interval := 0;
  end;
end;

procedure TfrmPrimzahlen.Timer1Timer(Sender: TObject);
var i, z ,x: integer;
    PrimZahl : Integer;
begin
gaktZahl := gaktZahl + 1;
z := 0;
If gPrimAnzahl > 0 then
  begin
    for i := 1 to gPrimAnzahl div 2 + 1 do
      begin
        PrimZahl := strtoint(lstPrimzahlen.Items[i-1]);
        if gaktZahl/PrimZahl = int(gaktZahl/PrimZahl) then z := z + 1;
      end;
  end;
if z = 1 then
  begin
    gPrimAnzahl := gPrimAnzahl + 1;
    lblPrimAnzahl.Caption := 'Anzahl der bereits berechneten Primzahlen:' + inttostr(gPrimAnzahl);
    lstPrimzahlen.Items.Add(inttostr(gaktZahl));
    lstPrimzahlen.ItemIndex := gPrimAnzahl - 1;
  end;
end;

procedure TfrmPrimzahlen.cmdUnterbrechungClick(Sender: TObject);
begin
if cmdUnterbrechung.Caption = '&Pause' then
  begin
    timer1.Interval := 0;
    cmdUnterbrechung.Caption := '&Weiter';
  end
else
  begin
    timer1.Interval := 1;
    cmdUnterbrechung.Caption := '&Pause';
  end;
end;

end.
