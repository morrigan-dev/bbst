unit Convert;

interface

uses Dialogs, Windows, SysUtils, Classes, Forms, strUtils, StdCtrls,
     ShellAPI, ClipBrd, Mathematics, Records;

function DTimeToStr(dtime: TDTime): String;
function convertString(text: String): String;
function getSchiffanzahl(text: string): Integer;
function getName(text: string): String;
function getFlotte(text: String; SchiffsIndex: Integer): String;
function getSystem(text: string; SchiffsIndex: Integer): String;
function getLaderaumAkt(text, name: string): Integer;
function getLaderaumMax(text, name: string): Integer;
function getXKoord(text: string; SchiffsIndex: Integer): Integer;
function getYKoord(text: string; SchiffsIndex: Integer): Integer;
function getRess(text: string): Integer;

implementation

function DTimeToStr(dtime: TDTime): String;
begin
  result := inttostr(dtime.Tage) + ' Tage ' + inttostr(dtime.Stunden) + ':' +
            inttostr(dtime.Minuten) + ':' + inttostr(dtime.Sekunden) + ' Stunden';
end;

function convertString(text: String): String;
var i: Integer;
    klammerAuf: Boolean;
    hString: String;
begin
  klammerAuf := false;
  for i := 1 to length(text) do
  begin
    if text[i] = '(' then klammerAuf := true;
    if (klammerAuf = false) and (ord(text[i]) >= ord('0')) and (ord(text[i]) <= ord('9')) then hString := hString + text[i];
    if text[i] = ')' then klammerAuf := false;
  end;
  Result := hString;
end;

function getSchiffanzahl(text: string): Integer;
var start, len : Integer;
    Anzahl: String;
begin
  if AnsiContainsStr(text,'Flotten insgesamt:') then
  begin
    start := Pos(': ',text)+2;
    len := 1;
    Anzahl := Copy(text,start,len);
    if (start <> 0) and isNumber(Anzahl) then result := strtoint(Anzahl)
    else result := 0;
  end
  else
    result := -1;
end;

function getName(text: string): String;
var start, ende: Integer;
begin
  if AnsiContainsStr(text,'Schiffsname') then
  begin
    start := Pos(')',text)+2;
    ende := start;
    while(not isDigit(text[ende])) do
    begin
      ende := ende + 1;
    end;
    result := Copy(text,start,ende-start-4);
  end
  else
    result := 'error';
end;

procedure sucheZeile(var text: string; SchiffsIndex: Integer);
var i, start: Integer;
begin
  for i := 1 to SchiffsIndex do
  begin
    if i = 1 then
      start := Pos('Kontrolle',text)+length('Kontrolle')+1
    else
      start := Pos('übernehmen',text)+length('übernehmen')+1;

    delete(text,1,start);
  end;
end;

function getFlotte(text: String; SchiffsIndex: Integer): String;
var ende: Integer;
begin
  if AnsiContainsStr(text, 'Flottenname') then
  begin
    sucheZeile(text, SchiffsIndex);

    ende := Pos(chr(9),text);
    result := Copy(text,1,ende-1);
  end
  else
    result := 'error';
end;

function getSystem(text: string; SchiffsIndex: Integer): String;
var start, ende: Integer;
    Flotte: String;
begin
  if AnsiContainsStr(text, 'Position') then
  begin
    sucheZeile(text, SchiffsIndex);
    start := Pos(chr(9),text)+1;

    ende := 0;
    while not isDigit(text[ende]) do
    begin
      ende := ende + 1;
    end;

    result := Copy(text,start,ende-start-1);//Copy(text,length(Flotte)+1,ende-2);
  end
  else
    result := 'error';
end;

function getLaderaumAkt(text, name: string): Integer;
var start, ende: Integer;
    LaderaumAkt: String;
begin
  if AnsiContainsStr(text, 'akt.') then
  begin
    start := Pos(name, text)+length(name);
    delete(text, 1, start);
    if start <> 0 then
    begin
      start := 0;
      while(not isDigit(text[start])) do
      begin
        start := start + 1;
      end;

      ende := start;
      while(isDigit(text[ende])) do
      begin
        ende := ende + 1;
      end;

      LaderaumAkt := copy(text,start,ende-start);
    end
    else LaderaumAkt := 'error';

    if isNumber(LaderaumAkt) then
      result := strtoint(LaderaumAkt)
    else
      result := -1;
  end
  else
    result := -1;
end;

function getLaderaumMax(text, name: string): Integer;
var start, ende: Integer;
    LaderaumAkt, LaderaumMax: String;
begin
  if AnsiContainsStr(text, 'max.') then
  begin
    LaderaumAkt := inttostr(getLaderaumAkt(text, name));

    start := Pos(name, text)+length(name);
    delete(text, 1, start);

    start := Pos(LaderaumAkt,text)+length(LaderaumAkt);
    if start <> 0 then
    begin
      while(not isDigit(text[start])) do
      begin
        start := start + 1;
      end;

      ende := start;
      while(isDigit(text[ende])) do
      begin
        ende := ende + 1;
      end;

      LaderaumMax := copy(text,start,ende-start);
    end
    else LaderaumMax := 'error';

    if isNumber(LaderaumMax) then
      result := strtoint(LaderaumMax)
    else
      result := -1;
  end
  else
    result := -1;
end;

function getXKoord(text: string; SchiffsIndex: Integer): Integer;
var i, ende: Integer;
    XKoord: String;
begin
  if AnsiContainsStr(text, 'Position') then
  begin
    sucheZeile(text, SchiffsIndex);
    ende := Pos(chr(9),text)+1;
    delete(text,1,ende);

    i := 1;
    while (not isDigit(text[i])) and (text[i-1]<>' ') do
    begin
      i := i + 1;
    end;
    ende := Pos(',',text);
    XKoord := Copy(text,i,ende-i);
    if isNumber(XKoord) then
      result := strtoint(XKoord)
    else
      result := -1;
  end
  else
    result := -1;
end;

function getYKoord(text: string; SchiffsIndex: Integer): Integer;
var start, ende: Integer;
    YKoord: String;
begin
  if AnsiContainsStr(text, 'Position') then
  begin
    sucheZeile(text, SchiffsIndex);
    ende := Pos(chr(9),text)+1;
    delete(text,1,ende);

    start := Pos(',',text)+1;
    ende := Pos(chr(9),text);
    YKoord := Copy(text,start,ende-start);
    if isNumber(YKoord) then
      result := strtoint(YKoord)
    else
      result := -1;
  end
  else
    result := -1;
end;

function getRess(text: string): Integer;
var Ress: array[0..13] of String;
    i, start, ende: Integer;
    anz: Integer;
begin

  Ress[0] := 'Cr';
  Ress[1] := 'Nrg';
  Ress[2] := 'Rek';
  Ress[3] := 'Erz';
  Ress[4] := 'Org';
  Ress[5] := 'Synth';
  Ress[6] := 'Fe';
  Ress[7] := 'LM';
  Ress[8] := 'SM';
  Ress[9] := 'EM';
  Ress[10] := 'Rad';
  Ress[11] := 'ES';
  Ress[12] := 'EG';
  Ress[13] := 'Iso';

  anz := 0;
  for i := 0 to 13 do
  begin
    start := Pos(Ress[i],text)+length(Ress[i])+2;
    ende := start;
    while isDigit(text[ende]) do
      ende := ende + 1;

    if start <> 0 then
      if isNumber(Copy(text,start,ende-start)) then anz := anz + strtoint(Copy(text,start,ende-start));
  end;

  Result := anz;
end;

end.
