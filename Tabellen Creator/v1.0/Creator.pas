unit Creator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Grids, Menus, Buttons, OleServer, ExcelXP, AxCtrls,
  OleCtrls, VCF1, HTTPApp, DBWeb, Dialogs;

type
  TfrmCreator = class(TForm)
    btnErstellen: TButton;
    Label1: TLabel;
    edtSpalten: TEdit;
    edtZeilen: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtSpaltenBreite: TEdit;
    gpbAusgabe: TGroupBox;
    Label4: TLabel;
    edtSpaltenabstand: TEdit;
    btnBBCode: TButton;
    Label5: TLabel;
    btnBold: TButton;
    btnItalic: TButton;
    btnUnderline: TButton;
    cbbColor: TComboBox;
    memBBCode: TMemo;
    btnSpeichern: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    btnLaden: TButton;
    Label6: TLabel;
    procedure btnErstellenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbColorChange(Sender: TObject);
    procedure cbbColorDropDown(Sender: TObject);
    procedure CellClick(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure btnBBCodeClick(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
    procedure btnLadenClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmCreator: TfrmCreator;

implementation

{$R *.dfm}

type TCells = record
  Cell : TEdit;
  bold : Boolean;
  italic : Boolean;
  underline : Boolean;
  color : String;
end;

type TTabelle = record
  Rows : Integer;
  Cols : Integer;
  Cells : array of array of TCells;
  cellWidth : Integer;
  cellHeight : Integer;
  Selected : TObject;
  Saved : Boolean;
end;

var Tabelle : TTabelle;

procedure deleteTable();
var i,j : Integer;
begin
  for j := 0 to Tabelle.Rows-1 do
    for i := 0 to Tabelle.Cols-1 do
    begin
      Tabelle.Cells[i,j].Cell.Free;
    end;

  setLength(Tabelle.Cells,0,0);

  frmCreator.gpbAusgabe.Top := 80 + Tabelle.cellHeight * Tabelle.Rows;
  frmCreator.Height := 211 + Tabelle.cellHeight * Tabelle.Rows;
end;

procedure TfrmCreator.CellClick(Sender: TObject);
begin
  Tabelle.Selected := Sender;
end;

procedure setSize();
begin
  frmCreator.gpbAusgabe.Top := 112 + Tabelle.cellHeight * Tabelle.Rows;
  frmCreator.Height := 275 + Tabelle.cellHeight * Tabelle.Rows;
  if Tabelle.cellWidth * Tabelle.Cols > frmCreator.Width then
    frmCreator.Width := 18 + Tabelle.cellWidth * Tabelle.Cols
  else
    frmCreator.Width := 344;
end;

procedure setColor(i,j: Integer);
begin
  if Tabelle.Cells[i,j].color = '' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00000000;
  if Tabelle.Cells[i,j].color = '[color=darkred]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $0000008C;
  if Tabelle.Cells[i,j].color = '[color=red]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $000000FF;
  if Tabelle.Cells[i,j].color = '[color=orange]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $0000A6FF;
  if Tabelle.Cells[i,j].color = '[color=brown]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $002928A5;
  if Tabelle.Cells[i,j].color = '[color=yellow]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $0000FFFF;
  if Tabelle.Cells[i,j].color = '[color=green]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00008200;
  if Tabelle.Cells[i,j].color = '[color=olive]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00008284;
  if Tabelle.Cells[i,j].color = '[color=cyan]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00FFFF00;
  if Tabelle.Cells[i,j].color = '[color=blue]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00FF0000;
  if Tabelle.Cells[i,j].color = '[color=darkblue]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $008C0000;
  if Tabelle.Cells[i,j].color = '[color=indigo]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $0084004A;
  if Tabelle.Cells[i,j].color = '[color=violet]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00EF82EF;
  if Tabelle.Cells[i,j].color = '[color=white]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00FFFFFF;
  if Tabelle.Cells[i,j].color = '[color=black]' then
    Tabelle.Cells[i,j].Cell.Font.Color := $00000000;
end;

procedure createTable(i,j: Integer; caption: String);
begin
      Tabelle.Cells[i,j].Cell := TEdit.Create(frmCreator);
      Tabelle.Cells[i,j].Cell.Parent := frmCreator;
      Tabelle.Cells[i,j].Cell.Left := 8 + (Tabelle.cellWidth-1) * i;
      Tabelle.Cells[i,j].Cell.Top := 104 + (Tabelle.cellHeight-2) * j;
      Tabelle.Cells[i,j].Cell.Width := Tabelle.cellWidth;
      Tabelle.Cells[i,j].Cell.Height := Tabelle.cellHeight;
      Tabelle.Cells[i,j].Cell.Ctl3D := False;
      Tabelle.Cells[i,j].Cell.Font.Style := [];
      if Tabelle.Cells[i,j].bold then
        Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsBold];
      if Tabelle.Cells[i,j].Italic then
        Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsItalic];
      if Tabelle.Cells[i,j].Underline then
        Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsUnderline];
      Tabelle.Cells[i,j].Cell.Text := caption;
      Tabelle.Cells[i,j].Cell.Hint := inttostr(i)+','+inttostr(j);
      Tabelle.Cells[i,j].Cell.Color := $00739EBD;
      Tabelle.Cells[i,j].Cell.OnClick := frmCreator.CellClick;

      Tabelle.Cells[i,j].Cell.OnClick(frmCreator);
      setColor(i,j);

end;

procedure TfrmCreator.btnErstellenClick(Sender: TObject);
var i,j : Integer;
    Msg : String;
    Answer : Word;
begin
  Answer := mrYes;
  if Tabelle.Saved = false then
  begin
    Msg := 'Ihre Tabelle ist noch nicht gespeichert!' +chr(13)+chr(10)+
           'Möchten Sie dies nun tun?';
    Answer := MessageDlg(Msg, mtWarning, [mbYes, mbNo, mbAbort], 0);
    if Answer = mrYes then frmCreator.btnSpeichernClick(Sender);
  end;

  if (Answer = mrNo) or (Answer = mrYes) then
  begin
    deleteTable();

    Tabelle.Cols := StrToInt(edtSpalten.Text);
    Tabelle.Rows := StrToInt(edtZeilen.Text);
    Tabelle.cellWidth := StrToInt(edtSpaltenBreite.Text);
    Tabelle.cellHeight := 20;

    setSize();

    setLength(Tabelle.Cells,Tabelle.Cols,Tabelle.Rows);

    for j := 0 to Tabelle.Rows-1 do
      for i := 0 to Tabelle.Cols-1 do
      begin
        Tabelle.Cells[i,j].bold := false;
        Tabelle.Cells[i,j].italic := false;
        Tabelle.Cells[i,j].underline := false;
        Tabelle.Cells[i,j].color := '';
        Tabelle.Saved := false;
        createTable(i,j,'');
      end;

  end;
end;

procedure TfrmCreator.FormDestroy(Sender: TObject);
begin
  deleteTable();
end;

procedure TfrmCreator.FormCreate(Sender: TObject);
begin
  Tabelle.Rows := 0;
  Tabelle.Cols := 0;
  Tabelle.cellWidth := 70;
  Tabelle.cellHeight := 20;
  Tabelle.Saved := true;
end;

procedure TfrmCreator.cbbColorChange(Sender: TObject);
var a,i,j : Integer;
begin
  Tabelle.Saved := false;

  for a := 1 to length(TEdit(Tabelle.Selected).Hint) do
  begin
    if Copy(TEdit(Tabelle.Selected).Hint,a,1) = ',' then
      begin
        i := strtoint(Copy(TEdit(Tabelle.Selected).Hint,1,a-1));
        j := strtoint(Copy(TEdit(Tabelle.Selected).Hint,a+1,length(TEdit(Tabelle.Selected).Hint)));
      end;
  end;

  case cbbColor.ItemIndex of
    0: Tabelle.Cells[i,j].color := '';
    1: Tabelle.Cells[i,j].color := '[color=darkred]';
    2: Tabelle.Cells[i,j].color := '[color=red]';
    3: Tabelle.Cells[i,j].color := '[color=orange]';
    4: Tabelle.Cells[i,j].color := '[color=brown]';
    5: Tabelle.Cells[i,j].color := '[color=yellow]';
    6: Tabelle.Cells[i,j].color := '[color=green]';
    7: Tabelle.Cells[i,j].color := '[color=olive]';
    8: Tabelle.Cells[i,j].color := '[color=cyan]';
    9: Tabelle.Cells[i,j].color := '[color=blue]';
    10: Tabelle.Cells[i,j].color := '[color=darkblue]';
    11: Tabelle.Cells[i,j].color := '[color=indigo]';
    12: Tabelle.Cells[i,j].color := '[color=violet]';
    13: Tabelle.Cells[i,j].color := '[color=white]';
    14: Tabelle.Cells[i,j].color := '[color=black]';
  end;
  if Tabelle.Selected <> nil then setColor(i,j);
  cbbColor.ItemIndex := 0;
end;


procedure TfrmCreator.cbbColorDropDown(Sender: TObject);
begin
  cbbColor.Font.Color := $00000000;
end;

procedure TfrmCreator.btnBoldClick(Sender: TObject);
var style : TFontStyle;
    a,i,j : Integer;
begin
  Tabelle.Saved := false;

  for a := 1 to length(TEdit(Tabelle.Selected).Hint) do
  begin
    if Copy(TEdit(Tabelle.Selected).Hint,a,1) = ',' then
      begin
        i := strtoint(Copy(TEdit(Tabelle.Selected).Hint,1,a-1));
        j := strtoint(Copy(TEdit(Tabelle.Selected).Hint,a+1,length(TEdit(Tabelle.Selected).Hint)));
      end;
  end;

  if Tabelle.Cells[i,j].bold = false then
    Tabelle.Cells[i,j].bold := true
  else
    Tabelle.Cells[i,j].bold := false;

  Tabelle.Cells[i,j].Cell.Font.Style := [];
  if Tabelle.Cells[i,j].bold then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsBold];
  if Tabelle.Cells[i,j].italic then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsItalic];
  if Tabelle.Cells[i,j].underline then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsUnderline];
end;

procedure TfrmCreator.btnItalicClick(Sender: TObject);
var style : TFontStyle;
    a,i,j : Integer;
begin
  Tabelle.Saved := false;

  for a := 1 to length(TEdit(Tabelle.Selected).Hint) do
  begin
    if Copy(TEdit(Tabelle.Selected).Hint,a,1) = ',' then
      begin
        i := strtoint(Copy(TEdit(Tabelle.Selected).Hint,1,a-1));
        j := strtoint(Copy(TEdit(Tabelle.Selected).Hint,a+1,length(TEdit(Tabelle.Selected).Hint)));
      end;
  end;

  if Tabelle.Cells[i,j].italic = false then
    Tabelle.Cells[i,j].italic := true
  else
    Tabelle.Cells[i,j].italic := false;

  Tabelle.Cells[i,j].Cell.Font.Style := [];
  if Tabelle.Cells[i,j].bold then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsBold];
  if Tabelle.Cells[i,j].italic then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsItalic];
  if Tabelle.Cells[i,j].underline then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsUnderline];
end;

procedure TfrmCreator.btnUnderlineClick(Sender: TObject);
var style : TFontStyle;
    a,i,j : Integer;
begin
  Tabelle.Saved := false;

  for a := 1 to length(TEdit(Tabelle.Selected).Hint) do
  begin
    if Copy(TEdit(Tabelle.Selected).Hint,a,1) = ',' then
      begin
        i := strtoint(Copy(TEdit(Tabelle.Selected).Hint,1,a-1));
        j := strtoint(Copy(TEdit(Tabelle.Selected).Hint,a+1,length(TEdit(Tabelle.Selected).Hint)));
      end;
  end;

  if Tabelle.Cells[i,j].underline = false then
    Tabelle.Cells[i,j].underline := true
  else
    Tabelle.Cells[i,j].underline := false;

  Tabelle.Cells[i,j].Cell.Font.Style := [];
  if Tabelle.Cells[i,j].bold then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsBold];
  if Tabelle.Cells[i,j].italic then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsItalic];
  if Tabelle.Cells[i,j].underline then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsUnderline];
end;

function getFuellString(len: Integer): String;
var i: Integer;
begin
  Result := '';
  for i := 1 to len do
    Result := Result + chr(160);
end;

procedure TfrmCreator.btnBBCodeClick(Sender: TObject);
var i,j,x : Integer;
    maxLength : Integer;
    fuellString : String;
    leerString : String;
    BBCode : String;
begin
  leerString := getFuellString(strtoint(edtSpaltenabstand.Text));

  BBCode := '';
  BBCode := BBCode + '[face=Courier New]' +chr(13)+chr(10);
  for j := 0 to Tabelle.Rows-1 do
  begin
    for i := 0 to Tabelle.Cols-1 do
    begin

      maxLength := 0;
      for x := 0 to Tabelle.Rows-1 do
      begin
        if length(Tabelle.Cells[i,x].Cell.Text) > maxLength then maxlength := length(Tabelle.Cells[i,x].Cell.Text);
      end;

      if Tabelle.Cells[i,j].color <> '' then
        BBCode := BBCode + Tabelle.Cells[i,j].color;

      if Tabelle.Cells[i,j].bold then
        BBCode := BBCode + '[b]';
      if Tabelle.Cells[i,j].italic then
        BBCode := BBCode + '[i]';
      if Tabelle.Cells[i,j].underline then
        BBCode := BBCode + '[u]';

      fuellString := getFuellString(maxLength-length(Tabelle.Cells[i,j].Cell.Text));
      BBCode := BBCode + Tabelle.Cells[i,j].Cell.Text + fuellString;

      if Tabelle.Cells[i,j].underline then
        BBCode := BBCode + '[/u]';
      if Tabelle.Cells[i,j].italic then
        BBCode := BBCode + '[/i]';
      if Tabelle.Cells[i,j].bold then
        BBCode := BBCode + '[/b]';

      if Tabelle.Cells[i,j].color <> '' then
        BBCode := BBCode + '[/color]';

      if i < Tabelle.Cols-1 then BBCode := BBCode + leerString;

    end;
    BBCode := BBCode +chr(13)+chr(10);
  end;

  BBCode := BBCode + '[/face]';

  memBBCode.Text := BBCode;
end;

procedure saveTable(FileName: String);
var f: TextFile;
    i,j : Integer;
begin
  AssignFile(f, FileName); { Datei in Dialogfeld ausgewählt }
  Rewrite(f);
  Writeln(f, inttostr(Tabelle.Cols));
  Writeln(f, inttostr(Tabelle.Rows));
  for j := 0 to Tabelle.Rows-1 do
  begin
    for i := 0 to Tabelle.Cols-1 do
    begin
      Writeln(f, Tabelle.Cells[i,j].Cell.Text);
      Writeln(f, Tabelle.Cells[i,j].Bold);
      Writeln(f, Tabelle.Cells[i,j].Italic);
      Writeln(f, Tabelle.Cells[i,j].Underline);
      Writeln(f, Tabelle.Cells[i,j].Color);
    end;
  end;
  CloseFile(f);
end;

procedure TfrmCreator.btnSpeichernClick(Sender: TObject);
var Msg: WideString;
begin
  if SaveDialog.Execute then            { Öffnen-Dialogfeld anzeigen }
  begin
    if fileexists(SaveDialog.FileName) then
    begin

      Msg := SaveDialog.FileName + ' besteht bereits.'+chr(13)+chr(10)+'Möchten Sie sie ersetzen?';
      if MessageDlg(Msg, mtWarning, [mbYes, mbNo], 0) = mrYes then
        begin
          saveTable(SaveDialog.FileName);
        end;
    end
    else saveTable(SaveDialog.FileName);
  end;
  Tabelle.Saved := true;
end;

procedure TfrmCreator.btnLadenClick(Sender: TObject);
var
  f: TextFile;
  i,j : Integer;
  S: String;
  caption: string;
  Msg : String;
  Answer : Word;
begin
  Answer := mrYes;
  if Tabelle.Saved = false then
  begin
    Msg := 'Ihre Tabelle ist noch nicht gespeichert!' +chr(13)+chr(10)+
           'Möchten Sie dies nun tun?';
    Answer := MessageDlg(Msg, mtWarning, [mbYes, mbNo, mbAbort], 0);
    if Answer = mrYes then frmCreator.btnSpeichernClick(Sender);
  end;

  if (Answer = mrNo) or (Answer = mrYes) then
  begin
    if OpenDialog.Execute then            { Öffnen-Dialogfeld anzeigen }
    begin
      deleteTable();
      AssignFile(f, OpenDialog.FileName); { Datei in Dialogfeld ausgewählt }
      Reset(f);
      Readln(f, Tabelle.Cols);
      Readln(f, Tabelle.Rows);

      setSize();
      SetLength(Tabelle.Cells, Tabelle.Cols, Tabelle.Rows);

      for j := 0 to Tabelle.Rows-1 do
        for i := 0 to Tabelle.Cols-1 do
        begin

          Readln(f, caption);

          Readln(f, S);
          if S='TRUE' then Tabelle.Cells[i,j].Bold := true
          else Tabelle.Cells[i,j].Bold := false;

          Readln(f, S);
          if S='TRUE' then Tabelle.Cells[i,j].Italic := true
          else Tabelle.Cells[i,j].Italic := false;

          Readln(f, S);
          if S='TRUE' then Tabelle.Cells[i,j].Underline := true
          else Tabelle.Cells[i,j].Underline := false;

          Readln(f, S);
          Tabelle.Cells[i,j].Color := S;

          createTable(i,j,caption);

        end;
      CloseFile(f);
      Tabelle.Saved := True;
    end;
  end;
end;

end.
