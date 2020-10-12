unit Mathematics;

interface

uses Records, Dialogs, MyIO, SysUtils;

function isDigit(c: Char): Boolean;
function isNumber(Anzahl: String): Boolean;
function sortiere(list: TRessTable; by:String): TRessTable;

implementation

var RessTable   : TRessTable;
    HelpTable   : TRessTable;

procedure merge(low, mid, high: Integer; by: String);
var i, j, k: Integer;
begin
    i := 0;
    j := low;
    // linke Hälfte von RessTable in Hilfsarray hilf kopieren
    while (j <= mid) do
    begin
      HelpTable[i].Ressource := RessTable[j].Ressource;
      HelpTable[i].Menge := RessTable[j].Menge;
      HelpTable[i].Preis := RessTable[j].Preis;
      HelpTable[i].Venad := RessTable[j].Venad;
      HelpTable[i].Clan := RessTable[j].Clan;
      HelpTable[i].EndetAm := RessTable[j].EndetAm;
      HelpTable[i].EndetIn := RessTable[j].EndetIn;
      i := i + 1;
      j := j + 1;
    end;

    i := 0;
    k := low;
    // jeweils das nächstgrößte Element zurückkopieren
    while ((k<j) and (j<=high)) do
    begin
      if ((by = 'Ressource') and (HelpTable[i].Ressource <= RessTable[j].Ressource)) or
         ((by = 'Menge') and (HelpTable[i].Menge <= RessTable[j].Menge)) or
         ((by = 'Preis') and (HelpTable[i].Preis <= RessTable[j].Preis)) or
         ((by = 'Venad') and (HelpTable[i].Venad <= RessTable[j].Venad)) or
         ((by = 'Clan') and (HelpTable[i].Clan <= RessTable[j].Clan)) then
//      if HelpTable[i].Menge <= RessTable[j].Menge then
      begin
        RessTable[k].Ressource := HelpTable[i].Ressource;
        RessTable[k].Menge := HelpTable[i].Menge;
        RessTable[k].Preis := HelpTable[i].Preis;
        RessTable[k].Venad := HelpTable[i].Venad;
        RessTable[k].Clan := HelpTable[i].Clan;
        RessTable[k].EndetAm := HelpTable[i].EndetAm;
        RessTable[k].EndetIn := HelpTable[i].EndetIn;
        k := k + 1;
        i := i + 1;
      end
      else
      begin
        RessTable[k].Ressource := RessTable[j].Ressource;
        RessTable[k].Menge := RessTable[j].Menge;
        RessTable[k].Preis := RessTable[j].Preis;
        RessTable[k].Venad := RessTable[j].Venad;
        RessTable[k].Clan := RessTable[j].Clan;
        RessTable[k].EndetAm := RessTable[j].EndetAm;
        RessTable[k].EndetIn := RessTable[j].EndetIn;
        k := k + 1;
        j := j + 1;
      end;
    end;

    // Rest von b falls vorhanden zurückkopieren
    while (k<j) do
    begin
      RessTable[k].Ressource := HelpTable[i].Ressource;
      RessTable[k].Menge := HelpTable[i].Menge;
      RessTable[k].Preis := HelpTable[i].Preis;
      RessTable[k].Venad := HelpTable[i].Venad;
      RessTable[k].Clan := HelpTable[i].Clan;
      RessTable[k].EndetAm := HelpTable[i].EndetAm;
      RessTable[k].EndetIn := HelpTable[i].EndetIn;
      k := k + 1;
      i := i + 1;
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

function isDigit(c: Char): Boolean;
begin
  if (ord(c) >= 48) and (ord(c) <= 57) then result := true
  else result := false;
end;

function isNumber(Anzahl: String): Boolean;
var i, laenge: Integer;
begin
  laenge := length(Anzahl);
  if laenge = 0 then
    result := false
  else
    result := true;

  for i := 1 to laenge do
    if not isDigit(Anzahl[i]) then
    begin
      result := false;
      break;
    end;
end;

function sortiere(list: TRessTable; by:String): TRessTable;
begin
  setLength(RessTable,length(list));
  setLength(HelpTable,length(list));
  RessTable := list;

  sortList(0, length(RessTable)-2,by);

  Result := RessTable;
end;

end.
