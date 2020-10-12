unit Handel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, StrUtils;

type
  TDTime = record
    Tage: Integer;
    Stunden: Integer;
    Minuten: Integer;
    Sekunden: Integer;
  end;

  TTabelle = record
    Ressource: String;
    Menge: Integer;
    Preis: Single;
    Venad: String;
    Clan: String;
    EndetAm: TDateTime;
    EndetIn: TDTime;
  end;

  TfrmHandelsposten = class(TForm)
    mmoDaten: TMemo;
    btnCreateTable: TButton;
    Panel1: TPanel;
    stgTabelle: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateTableClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckboxClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);

  private
    { Private declarations }
    RessTabelle: array[0..200] of TTabelle;
    hilf: array[0..100] of TTabelle;
    RessName: array[0..14] of String;
    TabCount: Integer;
    AnzeigeCode: String;
  public
    { Public declarations }
  end;

var
  frmHandelsposten: TfrmHandelsposten;

implementation

{$R *.dfm}

function DTimeToStr(dtime: TDTime): String;
begin
  result := inttostr(dtime.Tage) + ' Tage ' + inttostr(dtime.Stunden) + ':' +
            inttostr(dtime.Minuten) + ':' + inttostr(dtime.Sekunden) + ' Stunden';
end;

procedure showTabelle(elements: String);
var i, count: Integer;
    altRess: String;
begin
  i := 0;
  count := 0;
  altRess := frmHandelsposten.RessTabelle[0].Ressource;
  while (i < frmHandelsposten.TabCount) do
  begin
    with frmHandelsposten do
    begin
      if AnsiContainsStr(elements, RessTabelle[i].Ressource) then
      begin
        stgTabelle.RowCount := count+1;
//        if altRess <> RessTabelle[i].Ressource then count := count + 1;
        stgTabelle.Cells[0,count] := RessTabelle[i].Ressource;
        stgTabelle.Cells[1,count] := inttostr(RessTabelle[i].Menge);
        stgTabelle.Cells[2,count] := FormatFloat('0.00',RessTabelle[i].Preis);
        stgTabelle.Cells[3,count] := RessTabelle[i].Venad;
        stgTabelle.Cells[4,count] := RessTabelle[i].Clan;
        stgTabelle.Cells[5,count] := DateTimeToStr(RessTabelle[i].EndetAm);
        stgTabelle.Cells[6,count] := DTimeToStr(RessTabelle[i].EndetIn);
        altRess := RessTabelle[i].Ressource;
        count := count + 1;
      end;
      i := i + 1;
    end;
  end;
end;

function convertRess(ress: String): Integer;
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

function isDigit(c: Char): Boolean;
begin
  if (ord(c) >= 48) and (ord(c) <= 57) then result := true
  else result := false;
end;

procedure merge(low, mid, high: Integer; by: String);
var i, j, k: Integer;
begin
  with frmHandelsposten do
  begin
    i := 0;
    j := low;
    // linke Hälfte von RessTabelle in Hilfsarray hilf kopieren
    while (j <= mid) do
    begin
      hilf[i].Ressource := RessTabelle[j].Ressource;
      hilf[i].Menge := RessTabelle[j].Menge;
      hilf[i].Preis := RessTabelle[j].Preis;
      hilf[i].Venad := RessTabelle[j].Venad;
      hilf[i].Clan := RessTabelle[j].Clan;
      hilf[i].EndetAm := RessTabelle[j].EndetAm;
      hilf[i].EndetIn := RessTabelle[j].EndetIn;
      i := i + 1;
      j := j + 1;
    end;

    i := 0;
    k := low;
    // jeweils das nächstgrößte Element zurückkopieren
    while ((k<j) and (j<=high)) do
    begin
      if ((by = 'Ressource') and (hilf[i].Ressource <= RessTabelle[j].Ressource)) or
         ((by = 'Menge') and (hilf[i].Menge <= RessTabelle[j].Menge)) or
         ((by = 'Preis') and (hilf[i].Preis <= RessTabelle[j].Preis)) or
         ((by = 'Venad') and (hilf[i].Venad <= RessTabelle[j].Venad)) or
         ((by = 'Clan') and (hilf[i].Clan <= RessTabelle[j].Clan)) then
//      if hilf[i].Menge <= RessTabelle[j].Menge then
      begin
        RessTabelle[k].Ressource := hilf[i].Ressource;
        RessTabelle[k].Menge := hilf[i].Menge;
        RessTabelle[k].Preis := hilf[i].Preis;
        RessTabelle[k].Venad := hilf[i].Venad;
        RessTabelle[k].Clan := hilf[i].Clan;
        RessTabelle[k].EndetAm := hilf[i].EndetAm;
        RessTabelle[k].EndetIn := hilf[i].EndetIn;
        k := k + 1;
        i := i + 1;
      end
      else
      begin
        RessTabelle[k].Ressource := RessTabelle[j].Ressource;
        RessTabelle[k].Menge := RessTabelle[j].Menge;
        RessTabelle[k].Preis := RessTabelle[j].Preis;
        RessTabelle[k].Venad := RessTabelle[j].Venad;
        RessTabelle[k].Clan := RessTabelle[j].Clan;
        RessTabelle[k].EndetAm := RessTabelle[j].EndetAm;
        RessTabelle[k].EndetIn := RessTabelle[j].EndetIn;
        k := k + 1;
        j := j + 1;
      end;
    end;

    // Rest von b falls vorhanden zurückkopieren
    while (k<j) do
    begin
      RessTabelle[k].Ressource := hilf[i].Ressource;
      RessTabelle[k].Menge := hilf[i].Menge;
      RessTabelle[k].Preis := hilf[i].Preis;
      RessTabelle[k].Venad := hilf[i].Venad;
      RessTabelle[k].Clan := hilf[i].Clan;
      RessTabelle[k].EndetAm := hilf[i].EndetAm;
      RessTabelle[k].EndetIn := hilf[i].EndetIn;
      k := k + 1;
      i := i + 1;
    end;
  end;

end;

procedure sortList(low, high: Integer; by: String);
var mid: Integer;
begin
  if (low < high) then
  begin
    mid := (low+high) div 2;
    sortList(low, mid, by);
    sortList(mid+1, high, by);
    merge(low, mid, high, by);
  end;
end;

procedure TfrmHandelsposten.btnCreateTableClick(Sender: TObject);
var Line: String;
    i, j, tabIndex: Integer;
    Position: Integer;
    weiterAuslesen: Boolean;
    Venad: String;
    formatSettings: TFormatSettings;
begin
  tabIndex := 0;
  for j := 0 to frmHandelsposten.mmoDaten.Lines.Count-1 do
  begin
    Line := mmoDaten.Lines[j];
    weiterAuslesen := false;

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
          RessTabelle[tabIndex].Ressource := frmHandelsposten.RessName[convertRess(Copy(Line,1,i-1))];
          Delete(Line,1,i-1); // Lösche den Ressourcentext
        end;
        break;
      end;
    end;
    end;

    if weiterAuslesen then
    begin
      // Lese Menge aus
      RessTabelle[tabIndex].Menge := strtoint(Copy(Line,1,Pos('z',Line)-2));
      Delete(Line,1,Pos('z',Line)+2);

      // Lese Preis aus
      RessTabelle[tabIndex].Preis := StrToFloat(Copy(Line,1,Pos('.',Line)-1)+','+Copy(Line,Pos('.',Line)+1,2));
      Delete(Line,1,Pos('C',Line)+2);

      // Lösche die Beschreibung mit den runden Klammern
      Delete(Line, Pos('(', Line), Pos(chr(9), Line)-Pos('(', Line));
      // Lösche Leerzeichen + Tabschritt
      Delete(Line,1,2);

      // Lese Venad aus
      Venad := Copy(Line,1,Pos(chr(9),Line)-1);
      if Pos('[', Venad) <> 0 then
      begin
        RessTabelle[tabIndex].Venad := Copy(Venad,1,Pos('[', Venad)-1);
        RessTabelle[tabIndex].Clan := Copy(Venad,Pos('[', Venad)+1,Pos(']', Venad)-Pos('[', Venad)-1);
      end
      else RessTabelle[tabIndex].Venad := Venad;
      Delete(Line,1,Pos(chr(9),Line));

      // Lese EndetAm aus
      GetLocaleFormatSettings(1033, formatSettings);
      formatSettings.DateSeparator := '-';
      formatSettings.ShortDateFormat := 'yyyy-mm-dd';
      formatSettings.TimeSeparator := ':';
      formatSettings.ShortTimeFormat := 'hh:mm:ss';
      RessTabelle[tabIndex].EndetAm := StrToDateTime(Copy(Line,1,Pos(chr(9),Line)-1),formatSettings);
      Delete(Line,1,Pos(chr(9),Line));


      tabIndex := tabIndex + 1;
    end;

  end;

  frmHandelsposten.TabCount := tabIndex;
  sortList(0, frmHandelsposten.TabCount-1,'Preis');
  sortList(0, frmHandelsposten.TabCount-1,'Ressource');
  showTabelle('EnergieRekrutenErzorg. Verbindungensynth. VerbindungenEisenmetalleLeichtmetalleSchwermetalleEdelmetalleradioaktive StoffeEdelsteineEdelgaseinstabile Isotope');
end;

procedure TfrmHandelsposten.Button1Click(Sender: TObject);
begin
  sortList(0, frmHandelsposten.TabCount-1,'Ressource');
  showTabelle(AnzeigeCode);
end;

procedure TfrmHandelsposten.Button2Click(Sender: TObject);
begin
  sortList(0, frmHandelsposten.TabCount-1,'Menge');
  showTabelle(AnzeigeCode);
end;

procedure TfrmHandelsposten.Button3Click(Sender: TObject);
begin
  sortList(0, frmHandelsposten.TabCount-1,'Preis');
  showTabelle(AnzeigeCode);
end;

procedure TfrmHandelsposten.CheckboxClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then AnzeigeCode := AnzeigeCode + TCheckBox(Sender).Caption
  else Delete(AnzeigeCode, Pos(TCheckBox(Sender).Caption, AnzeigeCode), length(TCheckBox(Sender).Caption));
  showTabelle(AnzeigeCode);
end;

procedure TfrmHandelsposten.FormCreate(Sender: TObject);
begin
  CheckBox1.OnClick := CheckboxClick;
  CheckBox2.OnClick := CheckboxClick;
  CheckBox3.OnClick := CheckboxClick;
  CheckBox4.OnClick := CheckboxClick;
  CheckBox5.OnClick := CheckboxClick;
  CheckBox6.OnClick := CheckboxClick;
  CheckBox7.OnClick := CheckboxClick;
  CheckBox8.OnClick := CheckboxClick;
  CheckBox9.OnClick := CheckboxClick;
  CheckBox10.OnClick := CheckboxClick;
  CheckBox11.OnClick := CheckboxClick;
  CheckBox12.OnClick := CheckboxClick;
  CheckBox13.OnClick := CheckboxClick;

  AnzeigeCode := 'EnergieRekrutenErzorg. Verbindungensynth. VerbindungenEisenmetalleLeichtmetalleSchwermetalleEdelmetalleradioaktive StoffeEdelsteineEdelgaseinstabile Isotope';

  with stgTabelle do
  begin
    RowCount := 1;
    ColCount := 6;
    FixedRows := 0;
    FixedCols := 0;
  end;

  with frmHandelsposten do
  begin
    RessName[0] := 'Unbekannt';
    RessName[1] := 'Credits';
    RessName[2] := 'Energie';
    RessName[3] := 'Rekruten';
    RessName[4] := 'Erz';
    RessName[5] := 'org. Verbindungen';
    RessName[6] := 'synth. Verbindungen';
    RessName[7] := 'Eisenmetalle';
    RessName[8] := 'Leichtmetalle';
    RessName[9] := 'Schwermetalle';
    RessName[10] := 'Edelmetalle';
    RessName[11] := 'radioaktive Stoffe';
    RessName[12] := 'Edelsteine';
    RessName[13] := 'Edelgase';
    RessName[14] := 'instabile Isotope';
  end;
end;


procedure TfrmHandelsposten.Button4Click(Sender: TObject);
begin
  sortList(0, frmHandelsposten.TabCount-1,'Venad');
  showTabelle(AnzeigeCode);
end;

end.
