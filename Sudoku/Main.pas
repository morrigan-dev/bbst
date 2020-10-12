unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, StrUtils;

type
  TfrmSudoku = class(TForm)
    stgFeld: TStringGrid;
    btnBerechnen: TButton;
    btnLaden: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btnBerechnenClick(Sender: TObject);
    procedure btnLadenClick(Sender: TObject);
  private
    { Private-Deklarationen }
    function checkComplete(var errmsg:String): Boolean;
    function checkNumber(a,b,c,state:Integer): Boolean;
    procedure createTable;
    procedure deleteDouble;
  public
    { Public-Deklarationen }
  end;

var
  frmSudoku: TfrmSudoku;

implementation

var gTable : Array[0..8, 0..8] of String;
{$R *.dfm}

procedure TfrmSudoku.FormActivate(Sender: TObject);
var i : Integer;
begin
  stgFeld.DefaultColWidth := 30;
  stgFeld.DefaultRowHeight := 20;

  stgFeld.Width := 9 * stgFeld.DefaultColWidth + 9;
  stgFeld.Height := 9 * stgFeld.DefaultRowHeight + 9;
end;

function TfrmSudoku.checkComplete(var errmsg: String): Boolean;
var i,j,k,x : Integer;
    zeile, spalte, quadrat : Integer;
begin
  result := true;
  errmsg := '';
  { 1. Phase:
    Überprüfe alle Zeilen und Spalten auf Korrektheit.
    Jede Zahl von 1 bis 9 muss in jeder Zeile und jeder Spalte genau
    einmal vorkommen. }
  for i := 1 to 9 do
    begin
    for j := 0 to 0 do
      begin
      zeile := 0;
      spalte := 0;
      for k := 0 to 8 do
        begin
          // Prüfe Zeilen auf Korrektheit
          if stgFeld.Cells[k,j] = IntToStr(i) then zeile := zeile + 1;
          // Prüfe Spalten auf Korrektheit
          if stgFeld.Cells[j,k] = IntToStr(i) then spalte := spalte + 1;
        end;
      end;
      if zeile <> 1 then result := false;
      if spalte <> 1 then result := false;
    end;

  { 2. Phase:
    Überprüfe alle 9 Quadrate.
    Jede Zahl von 1 bis 9 muss in jedem Quadrat genau einmal vorkommen. }
  for x := 0 to 8 do
    begin
      for i := 1 to 9 do
        begin
          quadrat := 0;
          for j := 3*(x mod 3) to 3*(x mod 3) + 2 do
            begin
              for k := 3*(x div 3) to 3*(x div 3) + 2 do
                begin
                  if stgFeld.Cells[j,k] = IntToStr(i) then quadrat := quadrat + 1;
                end;
            end;
          if quadrat <> 1 then result := false;
        end;
    end;

end;

function TfrmSudoku.checkNumber(a,b,c,state:Integer): Boolean;
// a = Zeile, b = Spalte, c = zu überprüfender Wert, state = Prüfart
var i,j,z : Integer;
begin
  result := true;
  case state of
      1: begin  // Prüfe Zeile
           z := 0;
           for i := 0 to 8 do
             begin
               if gTable[i,a] = IntToStr(c) then z := z + 1;
             end;
           if z > 0 then result := false;
         end;
      2: begin  // Prüfe Spalte
           z := 0;
           for i := 0 to 8 do
             begin
               if gTable[b,i] = IntToStr(c) then z := z + 1;
             end;
           if z > 0 then result := false;
         end;
      3: begin  // Prüfe Quadrat
           z := 0;
           for i := 3*(a div 3) to 3*(a div 3) + 2 do
             begin
               for j := 3*(b div 3) to 3*(b div 3) + 2 do
                 begin
                   if gTable[j,i] = IntToStr(c) then z := z + 1;
                 end;
             end;
           if z > 0 then result := false;
         end;
  end;
end;

procedure TfrmSudoku.createTable;
var i,j,k : Integer;
    Numbers : String;
begin
  for i := 0 to 8 do
    begin
      for j := 0 to 8 do
        begin
          if gTable[j,i] = ' ' then
            begin
              Numbers := '';
              for k := 1 to 9 do
                begin
                  if checkNumber(i,j,k,1) and checkNumber(i,j,k,2) and checkNumber(i,j,k,3) then
                    begin
                      Numbers := Numbers + IntToStr(k);
                    end;
                end;
              gTable[j,i] := Numbers;
            end;
        end;
    end;
end;

procedure TfrmSudoku.deleteDouble;
begin

end;

procedure TfrmSudoku.btnBerechnenClick(Sender: TObject);
var msg: String;
    i,j : Integer;
begin
  if checkComplete(msg) then showmessage('Sudokuspiel wurde gelöst.')
  else
    begin
      createTable;
      deleteDouble;

      for i := 0 to 8 do
        begin
          for j := 0 to 8 do
            begin
              stgFeld.Cells[j,i] := gTable[j,i];
            end;
        end;

    end;
end;

procedure TfrmSudoku.btnLadenClick(Sender: TObject);
var f : TextFile;
    s : String;
    i, j : Integer;
begin
  AssignFile(f,'d:\sudoku.txt');
  Reset(f);
  for i := 0 to 8 do
    begin
      Readln(f,s);
      for j := 0 to 8 do
        begin
          stgFeld.Cells[j,i] := MidStr(s,j+1,1);
          gTable[j,i] := MidStr(s,j+1,1);
        end;
    end;
  CloseFile(f);
end;

end.
