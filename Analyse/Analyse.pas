unit Analyse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Math, DateUtils;

type
  TfrmAnalyse = class(TForm)
    cmdAnalyse: TButton;
    lstAnalyse_Dutzend: TListBox;
    Timer: TTimer;
    lstZufallszahlen: TListBox;
    txtZahlenAnzahl: TEdit;
    txtZeilenAnzahlStart: TEdit;
    lstAnalyse_Kolonne: TListBox;
    cmbAuswahl: TComboBox;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    lstAnalyse_KleinGross: TListBox;
    lstAnalyse_GeradeUngerade: TListBox;
    lstAnalyse_Farbe: TListBox;
    lblStatus1: TLabel;
    lblStatus2: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    txtZeilenAnzahlEnde: TEdit;
    lblDauer1: TLabel;
    procedure cmdAnalyseClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbAuswahlChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAnalyse: TfrmAnalyse;

implementation

var gAufgabe : integer;
    gZuordnungsTabelle : array[0..36] of string;
    gSymbol : array[1..5] of string;
    gZufallszahlen : array[1..1000000] of string;
    gZufallszahlenAnzahl : integer;
    gZaehler : integer;
    galtZeit, gneuZeit : Word;
{$R *.dfm}

function Anzeige_3Spalten(Wert : integer) : string;
begin
case Wert of
  1: result := ' --- ';
  2: result := 'x    ';
  3: result := '  x  ';
  4: result := '    x';
end;
end;

function Anzeige_2Spalten(Wert : integer) : string;
begin
case Wert of
  1: result := ' --- ';
  2: result := 'x    ';
  3: result := '    x';
end;
end;

function Zeitmessung : Word;
var x : word;
begin
galtZeit := gneuZeit;
gneuZeit := timoe
result := (gneuZeit-galtZeit)*100;
end;

procedure Tabelle_laden;
begin
// Erläuterung: Dutzend | Kolonne | 1-19/20-36 | Gerade/Ungerade | Farbe(g,r,s)
//              1|2|3|4   1|2|3|4     1|2|3          1|2|3         1|2|3

gZuordnungsTabelle[0] := '11111';
gZuordnungsTabelle[1] := '22232';
gZuordnungsTabelle[2] := '23223';
gZuordnungsTabelle[3] := '24232';
gZuordnungsTabelle[4] := '22223';
gZuordnungsTabelle[5] := '23232';
gZuordnungsTabelle[6] := '24223';
gZuordnungsTabelle[7] := '22232';
gZuordnungsTabelle[8] := '23223';
gZuordnungsTabelle[9] := '24232';
gZuordnungsTabelle[10] := '22223';
gZuordnungsTabelle[11] := '23233';
gZuordnungsTabelle[12] := '24222';
gZuordnungsTabelle[13] := '32233';
gZuordnungsTabelle[14] := '33222';
gZuordnungsTabelle[15] := '34233';
gZuordnungsTabelle[16] := '32222';
gZuordnungsTabelle[17] := '33233';
gZuordnungsTabelle[18] := '34222';
gZuordnungsTabelle[19] := '32232';
gZuordnungsTabelle[20] := '33323';
gZuordnungsTabelle[21] := '34332';
gZuordnungsTabelle[22] := '32323';
gZuordnungsTabelle[23] := '33332';
gZuordnungsTabelle[24] := '34323';
gZuordnungsTabelle[25] := '42332';
gZuordnungsTabelle[26] := '43323';
gZuordnungsTabelle[27] := '44332';
gZuordnungsTabelle[28] := '42323';
gZuordnungsTabelle[29] := '43333';
gZuordnungsTabelle[30] := '44322';
gZuordnungsTabelle[31] := '42333';
gZuordnungsTabelle[32] := '43322';
gZuordnungsTabelle[33] := '44333';
gZuordnungsTabelle[34] := '42322';
gZuordnungsTabelle[35] := '43333';
gZuordnungsTabelle[36] := '44322';
end;

procedure Zufallszahlen_berechnen;
var Eigenschaft : array[1..5] of string;
    Zufallszahl : integer;
    Leerstellen : string;
begin
gZaehler := gZaehler + 1;
Zufallszahl := random(37);
gZufallszahlen[gZaehler] := trim(inttostr(Zufallszahl));

Eigenschaft[1] := Anzeige_3Spalten(strtoint(copy(gZuordnungsTabelle[Zufallszahl],1,1)));
Eigenschaft[2] := Anzeige_3Spalten(strtoint(copy(gZuordnungsTabelle[Zufallszahl],2,1)));
Eigenschaft[3] := Anzeige_2Spalten(strtoint(copy(gZuordnungsTabelle[Zufallszahl],3,1)));
Eigenschaft[4] := Anzeige_2Spalten(strtoint(copy(gZuordnungsTabelle[Zufallszahl],4,1)));
Eigenschaft[5] := Anzeige_2Spalten(strtoint(copy(gZuordnungsTabelle[Zufallszahl],5,1)));

if length(trim(inttostr(Zufallszahl))) = 1 then Leerstellen := '  ';
if length(trim(inttostr(Zufallszahl))) = 2 then Leerstellen := ' ';
frmAnalyse.lstZufallszahlen.Items.Add(Leerstellen+inttostr(Zufallszahl)+' | '+
Eigenschaft[1]+' | '+
Eigenschaft[2]+' |  '+
Eigenschaft[3]+'   |    '+
Eigenschaft[4]+'      |  '+
Eigenschaft[5]);

frmAnalyse.ProgressBar1.Position := gZaehler;
frmAnalyse.lblStatus1.Caption := inttostr(trunc(gZaehler * 100 / gZufallszahlenAnzahl)) + ' %';
if gZaehler / 100 = int(gZaehler/100) then
  frmAnalyse.lblDauer1.Caption := timetostr(Zeitmessung);
end;

procedure Symbole_berechnen;
var i, k, x : integer;
    Stelle : integer;
begin

for x := 1 to 2 do
  begin
  gSymbol[x] := '1' + gSymbol[x];
  gSymbol[x] := trim(inttostr(strtoint(gSymbol[x]) + 1));
  gSymbol[x] := copy(gSymbol[x],2,length(gSymbol[x])-1);
  for i := length(gSymbol[x]) downto 1 do
    begin
    if copy(gSymbol[x],i,1) = '5' then
      begin
      Stelle := 0;
      gSymbol[x] := trim(inttostr(strtoint(copy(gSymbol[x],1,i)) + 6)+ copy(gSymbol[x],i+1,length(gSymbol[x])-i));
      end;
    end;
  end;
if length(gSymbol[3]) < strtoint(frmAnalyse.txtZeilenAnzahlEnde.Text)+1 then
  begin
  for x := 3 to 5 do
    begin
    gSymbol[x] := trim(inttostr(strtoint(gSymbol[x]) + 1));
    for i := length(gSymbol[x]) downto 1 do
      begin
      if copy(gSymbol[x],i,1) = '4' then
        begin
        Stelle := 0;
        gSymbol[x] := trim(inttostr(strtoint(copy(gSymbol[x],1,i)) + 7)+ copy(gSymbol[x],i+1,length(gSymbol[x])-i));
        end;
      end;
    end;
  end;
end;

procedure analysieren;
var Eigenschaft : string;
    i, k, l : integer;
    ZahlenCode : String;
    SymbolZaehler : array[1..5] of integer;
begin
// Anylyse: Dutzend
frmAnalyse.lstAnalyse_Dutzend.Items.Add('==========');
frmAnalyse.lstAnalyse_Dutzend.Items.Add('Muster:');
frmAnalyse.lstAnalyse_Dutzend.Items.Add('Dutzend');
frmAnalyse.lstAnalyse_Dutzend.Items.Add('1 2 3');
for i := 1 to length(gSymbol[1]) do
  begin
  Eigenschaft := Anzeige_3Spalten(strtoint(copy(gSymbol[1],i,1)));
  frmAnalyse.lstAnalyse_Dutzend.Items.Add(Eigenschaft);
  end;
frmAnalyse.lstAnalyse_Dutzend.Items.Add('----------');
frmAnalyse.lstAnalyse_Dutzend.Items.Add('Ergebnis:');

// Anylyse: Kolonne
frmAnalyse.lstAnalyse_Kolonne.Items.Add('==========');
frmAnalyse.lstAnalyse_Kolonne.Items.Add('Muster:');
frmAnalyse.lstAnalyse_Kolonne.Items.Add('Kolonne');
frmAnalyse.lstAnalyse_Kolonne.Items.Add('1 2 3');
for i := 1 to length(gSymbol[2]) do
  begin
  Eigenschaft := Anzeige_3Spalten(strtoint(copy(gSymbol[2],i,1)));
  frmAnalyse.lstAnalyse_Kolonne.Items.Add(Eigenschaft);
  end;
frmAnalyse.lstAnalyse_Kolonne.Items.Add('----------');
frmAnalyse.lstAnalyse_Kolonne.Items.Add('Ergebnis:');

// Anylyse: 1-19/20-36
frmAnalyse.lstAnalyse_KleinGross.Items.Add('==========');
frmAnalyse.lstAnalyse_KleinGross.Items.Add('Muster:');
frmAnalyse.lstAnalyse_KleinGross.Items.Add('1-19/20-36');
frmAnalyse.lstAnalyse_KleinGross.Items.Add('m | p');
for i := 1 to length(gSymbol[3]) do
  begin
  Eigenschaft := Anzeige_2Spalten(strtoint(copy(gSymbol[3],i,1)));
  frmAnalyse.lstAnalyse_KleinGross.Items.Add(Eigenschaft);
  end;
frmAnalyse.lstAnalyse_KleinGross.Items.Add('----------');
frmAnalyse.lstAnalyse_KleinGross.Items.Add('Ergebnis:');

// Anylyse: Gerade/Ungerade
frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add('==========');
frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add('Muster:');
frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add('Gerade/Ungerade');
frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add('p | i');
for i := 1 to length(gSymbol[4]) do
  begin
  Eigenschaft := Anzeige_2Spalten(strtoint(copy(gSymbol[4],i,1)));
  frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add(Eigenschaft);
  end;
frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add('----------');
frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add('Ergebnis:');

// Anylyse: Farbe
frmAnalyse.lstAnalyse_Farbe.Items.Add('==========');
frmAnalyse.lstAnalyse_Farbe.Items.Add('Muster:');
frmAnalyse.lstAnalyse_Farbe.Items.Add('Farbe');
frmAnalyse.lstAnalyse_Farbe.Items.Add('r | s');
for i := 1 to length(gSymbol[5]) do
  begin
  Eigenschaft := Anzeige_2Spalten(strtoint(copy(gSymbol[5],i,1)));
  frmAnalyse.lstAnalyse_Farbe.Items.Add(Eigenschaft);
  end;
frmAnalyse.lstAnalyse_Farbe.Items.Add('----------');
frmAnalyse.lstAnalyse_Farbe.Items.Add('Ergebnis:');

for i := 1 to 5 do
  begin
  SymbolZaehler[i] := 0;
  frmAnalyse.ProgressBar3.Position := 0;
  for k := 1 to gZufallszahlenAnzahl-length(gSymbol[i])+1 do
    begin
    ZahlenCode := '';
    for l := 1 to length(gSymbol[i]) do
      ZahlenCode := ZahlenCode + copy(gZuordnungsTabelle[strtoint(gZufallszahlen[k+l-1])],i,1);
    if ZahlenCode = gSymbol[i] then SymbolZaehler[i] := SymbolZaehler[i] + 1;
    frmAnalyse.ProgressBar3.Position := frmAnalyse.ProgressBar3.Position + 1;
    end;
  end;
frmAnalyse.lstAnalyse_Dutzend.Items.Add('Anzahl: ' + trim(inttostr(SymbolZaehler[1])));
frmAnalyse.lstAnalyse_Kolonne.Items.Add('Anzahl: ' + trim(inttostr(SymbolZaehler[2])));
frmAnalyse.lstAnalyse_KleinGross.Items.Add('Anzahl: ' + trim(inttostr(SymbolZaehler[3])));
frmAnalyse.lstAnalyse_GeradeUngerade.Items.Add('Anzahl: ' + trim(inttostr(SymbolZaehler[4])));
frmAnalyse.lstAnalyse_Farbe.Items.Add('Anzahl: ' + trim(inttostr(SymbolZaehler[5])));

frmAnalyse.ProgressBar2.Position := frmAnalyse.ProgressBar2.Position + 1;
frmAnalyse.lblStatus2.Caption := inttostr(trunc(frmAnalyse.ProgressBar2.Position * 100 / frmAnalyse.ProgressBar2.Max)) + ' %';
end;

//****************************************************************************
// ************************ Hauptprogramm ************************************
// ***************************************************************************

procedure TfrmAnalyse.FormCreate(Sender: TObject);
begin
randomize;
Tabelle_laden;
end;

procedure TfrmAnalyse.cmdAnalyseClick(Sender: TObject);
var i, k : integer;
    Fehler : integer;
begin
Fehler := 0;
if strtoint(frmAnalyse.txtZeilenAnzahlStart.Text) > strtoint(frmAnalyse.txtZeilenAnzahlEnde.Text) then Fehler := 1;
if strtoint(frmAnalyse.txtZahlenAnzahl.Text) > 1000000 then Fehler := 2;

If Fehler = 0 Then
  begin
  if timer.Interval = 0 then
    begin
    frmAnalyse.lstZufallszahlen.Clear;
    frmAnalyse.lstAnalyse_Dutzend.Clear;
    frmAnalyse.lstAnalyse_Kolonne.Clear;
    frmAnalyse.lstAnalyse_KleinGross.Clear;
    frmAnalyse.lstAnalyse_GeradeUngerade.Clear;
    frmAnalyse.lstAnalyse_Farbe.Clear;
    frmAnalyse.lstZufallszahlen.Items.Add('Zahl|Dutzend|Kolonne|1-19/20-36|Gerade/Ungerade|Farbe(r/s)');
    frmAnalyse.txtZahlenAnzahl.Enabled := False;
    frmAnalyse.txtZeilenAnzahlStart.Enabled := False;
    frmAnalyse.txtZeilenAnzahlEnde.Enabled := False;
    for i := 1 to 5 do
      begin
      gSymbol[i] := '0';
      for k := 1 to strtoint(frmAnalyse.txtZeilenAnzahlStart.Text)-1 do
        gSymbol[i] := '1' + gSymbol[i];
      end;
    gZufallszahlenAnzahl := strtoint(frmAnalyse.txtZahlenAnzahl.Text);
    gZaehler := 0;
    frmAnalyse.ProgressBar1.Max := gZufallszahlenAnzahl;
    frmAnalyse.ProgressBar2.Max := 0;
    for i := strtoint(frmAnalyse.txtZeilenAnzahlStart.Text) to strtoint(frmAnalyse.txtZeilenAnzahlEnde.Text) do
      frmAnalyse.ProgressBar2.Max := frmAnalyse.ProgressBar2.Max + trunc(power(4,i));
    frmAnalyse.ProgressBar3.Max := gZufallszahlenAnzahl;
    frmAnalyse.ProgressBar1.Position := 0;
    frmAnalyse.ProgressBar2.Position := 0;
    frmAnalyse.ProgressBar3.Position := 0;
    timer.Interval := 1;
    gAufgabe := 1
    end
  else
    begin
    timer.Interval := 0;
    frmAnalyse.txtZahlenAnzahl.Enabled := True;
    frmAnalyse.txtZeilenAnzahlStart.Enabled := True;
    frmAnalyse.txtZeilenAnzahlEnde.Enabled := True;
    frmAnalyse.cmbAuswahl.ItemIndex := 0;
    frmAnalyse.lstAnalyse_Dutzend.Visible := True;
    end;
  end  
else
  begin
  case Fehler of
    1: showmessage('Der Startwert darf nicht größer als der EndWert sein!');
    2: showmessage('Es können nicht mehr als 1000000 berechnet werden!');
  end;
  end;
end;

procedure TfrmAnalyse.TimerTimer(Sender: TObject);
begin
case gAufgabe of
  1: begin // Zufallzahlen berechnen
     Zufallszahlen_berechnen;
     if gZufallszahlenAnzahl = gZaehler then gAufgabe := 2;
     end;
  2: begin // nächstes Symbol berechnen
     Symbole_berechnen;
     if length(gSymbol[1]) = strtoint(frmAnalyse.txtZeilenAnzahlEnde.Text)+1 then
       frmAnalyse.cmdAnalyse.Click
     else
       gAufgabe := 3;
     end;
  3: begin // Auswertung
     analysieren;
     gAufgabe := 2;
     end;
end;
end;

procedure TfrmAnalyse.cmbAuswahlChange(Sender: TObject);
begin
case frmAnalyse.cmbAuswahl.ItemIndex of
  0: begin
     frmAnalyse.lstAnalyse_Dutzend.Visible := True;
     frmAnalyse.lstAnalyse_Kolonne.Visible := False;
     frmAnalyse.lstAnalyse_KleinGross.Visible := False;
     frmAnalyse.lstAnalyse_GeradeUngerade.Visible := False;
     frmAnalyse.lstAnalyse_Farbe.Visible := False;
     end;
  1: begin
     frmAnalyse.lstAnalyse_Kolonne.Visible := True;
     frmAnalyse.lstAnalyse_Dutzend.Visible := False;
     frmAnalyse.lstAnalyse_KleinGross.Visible := False;
     frmAnalyse.lstAnalyse_GeradeUngerade.Visible := False;
     frmAnalyse.lstAnalyse_Farbe.Visible := False;
     end;
  2: begin
     frmAnalyse.lstAnalyse_KleinGross.Visible := True;
     frmAnalyse.lstAnalyse_Kolonne.Visible := False;
     frmAnalyse.lstAnalyse_Dutzend.Visible := False;
     frmAnalyse.lstAnalyse_GeradeUngerade.Visible := False;
     frmAnalyse.lstAnalyse_Farbe.Visible := False;
     end;
  3: begin
     frmAnalyse.lstAnalyse_GeradeUngerade.Visible := True;
     frmAnalyse.lstAnalyse_KleinGross.Visible := False;
     frmAnalyse.lstAnalyse_Kolonne.Visible := False;
     frmAnalyse.lstAnalyse_Dutzend.Visible := False;
     frmAnalyse.lstAnalyse_Farbe.Visible := False;
     end;
  4: begin
     frmAnalyse.lstAnalyse_Farbe.Visible := True;
     frmAnalyse.lstAnalyse_KleinGross.Visible := False;
     frmAnalyse.lstAnalyse_Kolonne.Visible := False;
     frmAnalyse.lstAnalyse_Dutzend.Visible := False;
     frmAnalyse.lstAnalyse_GeradeUngerade.Visible := False;
     end;
end;
end;

end.
