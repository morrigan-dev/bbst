unit Creator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Grids, Menus, Buttons, OleServer, ExcelXP, AxCtrls,
  OleCtrls, VCF1, HTTPApp, DBWeb, Dialogs, ExtCtrls, StrUtils;

type
  TfrmCreator = class(TForm)
    gpbAusgabe: TGroupBox;
    Label4: TLabel;
    edtSpaltenabstand: TEdit;
    btnBBCode: TButton;
    Label5: TLabel;
    memBBCode: TMemo;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    lblAutor: TLabel;
    PopupMenu: TPopupMenu;
    ControlBar1: TControlBar;
    Panel1: TPanel;
    btnBold: TButton;
    btnItalic: TButton;
    btnUnderline: TButton;
    btnLeft: TBitBtn;
    btnCenter: TBitBtn;
    btnRight: TBitBtn;
    cbbColor: TComboBox;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    btnLaden: TBitBtn;
    edtSpalten: TEdit;
    edtZeilen: TEdit;
    btnUpdate: TBitBtn;
    edtSpaltenBreite: TEdit;
    btnSpeichern: TBitBtn;
    pnlTabelle: TPanel;
    btnNeu: TBitBtn;
    cmbRohstoffe: TComboBox;
    Button1: TButton;
    chkBrowser: TCheckBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbColorChange(Sender: TObject);
    procedure cbbColorDropDown(Sender: TObject);
    procedure CellClick(Sender: TObject);
    procedure CellKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CellChange(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure btnBBCodeClick(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
    procedure btnLadenClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnCenterClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure deleteText(Sender: TObject);
    procedure btnNeuClick(Sender: TObject);
    procedure cmbRohstoffeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
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
  Cell : TMemo;
  bold : Boolean;
  italic : Boolean;
  underline : Boolean;
  color : String;
  align_left : boolean;
  align_center : boolean;
  align_right : boolean;
  url : String;
  bild : String;
end;

type TTabelle = record
  Rows : Integer;
  Cols : Integer;
  Cells : array of array of TCells;
  cellWidth : Integer;
  cellHeight : Integer;
  Selected : TObject;
  Saved : Boolean;
  Filename: String;
  Version : Single;
  FuellZeichen: String;
end;

var Tabelle : TTabelle;

procedure setSize();
begin
  frmCreator.pnlTabelle.Width := Tabelle.cellWidth * Tabelle.Cols - Tabelle.Cols+1;
  frmCreator.pnlTabelle.Height := Tabelle.cellHeight * Tabelle.Rows - Tabelle.Rows*2 + 6;
  frmCreator.gpbAusgabe.Top := 72 + Tabelle.cellHeight * Tabelle.Rows - Tabelle.Rows*2 + 6;
  frmCreator.Height := 246 + Tabelle.cellHeight * Tabelle.Rows - Tabelle.Rows*2 + 6;
  frmCreator.lblAutor.Top := 207 + Tabelle.cellHeight * Tabelle.Rows - Tabelle.Rows*2 + 6;
//  frmCreator.chkBrowser.Top := 202 + Tabelle.cellHeight * Tabelle.Rows - Tabelle.Rows*2 + 6;
  if frmCreator.pnlTabelle.Width > 376-20 then
    frmCreator.Width := 50 + frmCreator.pnlTabelle.Width
  else
    frmCreator.Width := 400;

  if frmCreator.Height > Screen.Height then frmCreator.Height := Screen.Height-50;
  frmCreator.Position := poDesktopCenter;
end;

procedure deleteTable();
var i,j : Integer;
begin
  for j := 0 to Tabelle.Rows-1 do
    for i := 0 to Tabelle.Cols-1 do
    begin
      Tabelle.Cells[i,j].Cell.Free;
    end;

  setLength(Tabelle.Cells,0,0);

  Tabelle.Rows := 0;
  Tabelle.Cols := 0;
  setSize();
end;

procedure TfrmCreator.CellClick(Sender: TObject);
begin
  Tabelle.Selected := Sender;
end;

procedure getIJ(var i,j: Integer);
var a : Integer;
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
end;

procedure TfrmCreator.CellChange(Sender: TObject);
begin
  Tabelle.Saved := false;
end;

procedure TfrmCreator.CellKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i,j: Integer;
begin
  if  Shift = [ssCtrl] then
//  showmessage(inttostr(Key));
  begin
    getIJ(i,j);
    case Key of
      37: begin
            if i > 0 then
            begin
              Tabelle.Cells[i-1,j].Cell.setFocus;
              Tabelle.Cells[i-1,j].Cell.SelectAll;
              Tabelle.Selected := Tabelle.Cells[i-1,j].Cell;
            end;
          end;
      38: begin
            if j > 0 then
            begin
              Tabelle.Cells[i,j-1].Cell.SetFocus;
              Tabelle.Cells[i,j-1].Cell.SelectAll;
              Tabelle.Selected := Tabelle.Cells[i,j-1].Cell;
            end;
          end;
      39: begin
            if i < Tabelle.Cols-1 then
            begin
              Tabelle.Cells[i+1,j].Cell.SetFocus;
              Tabelle.Cells[i+1,j].Cell.SelectAll;
              Tabelle.Selected := Tabelle.Cells[i+1,j].Cell;
            end;
          end;
      40: begin
            if j < Tabelle.Rows-1 then
            begin
              Tabelle.Cells[i,j+1].Cell.SetFocus;
              Tabelle.Cells[i,j+1].Cell.SelectAll;
              Tabelle.Selected := Tabelle.Cells[i,j+1].Cell;
            end;
          end;
      66: frmCreator.btnBoldClick(Sender); // Taste b
      73: frmCreator.btnItalicClick(Sender); // Taste i
      85: frmCreator.btnUnderlineClick(Sender); // Taste u
      76: frmCreator.btnLeftClick(Sender); // Taste l
      77: frmCreator.btnCenterClick(Sender); // Taste m
      82: frmCreator.btnRightClick(Sender); // Taste r
      83: frmCreator.btnSpeichernClick(Sender); // Taste s
      79: frmCreator.btnLadenClick(Sender); // Taste o
      13: frmCreator.btnBBCodeClick(Sender); // Enter
    end;
  end;
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
      Tabelle.Cells[i,j].Cell := TMemo.Create(frmCreator.pnlTabelle);
      Tabelle.Cells[i,j].Cell.Parent := frmCreator.pnlTabelle;
      Tabelle.Cells[i,j].Cell.Left := (Tabelle.cellWidth-1) * i;
      Tabelle.Cells[i,j].Cell.Top := (Tabelle.cellHeight-2) * j;
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
      if Tabelle.Cells[i,j].align_left then
        Tabelle.Cells[i,j].Cell.Alignment := taLeftJustify;
      if Tabelle.Cells[i,j].align_center then
        Tabelle.Cells[i,j].Cell.Alignment := taCenter;
      if Tabelle.Cells[i,j].align_right then
        Tabelle.Cells[i,j].Cell.Alignment := taRightJustify;
      Tabelle.Cells[i,j].Cell.Text := caption;
      Tabelle.Cells[i,j].Cell.WantReturns := false;
      Tabelle.Cells[i,j].Cell.WordWrap := false;
      Tabelle.Cells[i,j].Cell.Hint := inttostr(i)+','+inttostr(j);
      Tabelle.Cells[i,j].Cell.Color := $00739EBD;
      Tabelle.Cells[i,j].Cell.OnClick := frmCreator.CellClick;
      Tabelle.Cells[i,j].Cell.OnKeyUp := frmCreator.CellKeyUp;
      Tabelle.Cells[i,j].Cell.OnChange := frmCreator.CellChange;

      Tabelle.Cells[i,j].Cell.OnClick(frmCreator);
      setColor(i,j);

end;

procedure TfrmCreator.FormDestroy(Sender: TObject);
begin
  deleteTable();
end;

procedure TfrmCreator.FormCreate(Sender: TObject);
begin
  Tabelle.Rows := 0;
  Tabelle.Cols := 0;
  Tabelle.cellWidth := 100;
  Tabelle.cellHeight := 18;
  Tabelle.Saved := true;


  edtSpalten.OnClick := deleteText;
  edtZeilen.OnClick := deleteText;
  edtSpaltenBreite.OnClick := deleteText;

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

procedure setStyle(i,j: Integer);
begin
  Tabelle.Cells[i,j].Cell.Font.Style := [];
  if Tabelle.Cells[i,j].bold then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsBold];
  if Tabelle.Cells[i,j].italic then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsItalic];
  if Tabelle.Cells[i,j].underline then
    Tabelle.Cells[i,j].Cell.Font.Style := Tabelle.Cells[i,j].Cell.Font.Style + [fsUnderline];
end;

procedure TfrmCreator.btnBoldClick(Sender: TObject);
var style : TFontStyle;
    a,i,j : Integer;
begin
  Tabelle.Saved := false;

  getIJ(i,j);

  if Tabelle.Cells[i,j].bold = false then
    Tabelle.Cells[i,j].bold := true
  else
    Tabelle.Cells[i,j].bold := false;

  setStyle(i,j);
end;

procedure TfrmCreator.btnItalicClick(Sender: TObject);
var style : TFontStyle;
    a,i,j : Integer;
begin
  Tabelle.Saved := false;

  getIJ(i,j);

  if Tabelle.Cells[i,j].italic = false then
    Tabelle.Cells[i,j].italic := true
  else
    Tabelle.Cells[i,j].italic := false;

  setStyle(i,j);
end;

procedure TfrmCreator.btnUnderlineClick(Sender: TObject);
var style : TFontStyle;
    a,i,j : Integer;
begin
  Tabelle.Saved := false;

  getIJ(i,j);

  if Tabelle.Cells[i,j].underline = false then
    Tabelle.Cells[i,j].underline := true
  else
    Tabelle.Cells[i,j].underline := false;

  setStyle(i,j);
end;

procedure deleteFuellStrings(var BBCode: String);
var ende : Integer;
begin
  BBCode := StringReplace(BBCode,chr(13)+chr(10),'#Zeilenumbruch#',[rfReplaceAll]);

  while (AnsiContainsStr(BBCode,'#Zeilenumbruch#')) do
  begin
    ende := pos('#Zeilenumbruch#',BBCode)-1;
     //showmessage(inttostr(ende));
    while (Copy(BBCode,ende,1)=Tabelle.FuellZeichen) do
    begin
      delete(BBcode,ende,1);
      ende := ende - 1;
    end;
    BBCode := StringReplace(BBCode,'#Zeilenumbruch#',chr(13)+chr(10),[]);
  end;
end;

function getFuellString(len: Integer): String;
var i: Integer;
begin
  Result := '';
  for i := 1 to len do
    Result := Result + Tabelle.FuellZeichen;
end;

function checkBild(i,j: Integer): Boolean;
begin
      if AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Nrg]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Rek]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Erz]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Org]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Syn]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Fes]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Lms]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Sms]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Ems]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Rad]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Eds]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Edg]') or
         AnsiContainsStr(Tabelle.Cells[i,j].Cell.Text,'[Iso]') then Result := true;
end;

procedure TfrmCreator.btnBBCodeClick(Sender: TObject);
var i,j,x,anz : Integer;
    maxLength : Integer;
    fuellString, fuellStringVorne, fuellStringHinten  : String;
    leerString : String;
    BBCode : String;
    StartTag, EndTag : String;
begin
  if chkBrowser.Checked then
    Tabelle.FuellZeichen := chr(168)
  else
    Tabelle.FuellZeichen := chr(160);

  leerString := getFuellString(strtoint(edtSpaltenabstand.Text));

  BBCode := '';
  BBCode := BBCode + '[face=Courier New]' +chr(13)+chr(10);
  for j := 0 to Tabelle.Rows-1 do
  begin
  anz := 0;
    for i := 0 to Tabelle.Cols-1 do
    begin

      maxLength := 0;
      for x := 0 to Tabelle.Rows-1 do
      begin
        if length(Tabelle.Cells[i,x].Cell.Text) > maxLength then
        begin
          if checkBild(i,x) then maxlength := length(Tabelle.Cells[i,x].Cell.Text)-3
          else maxlength := length(Tabelle.Cells[i,x].Cell.Text);
        end;
      end;

      StartTag := '';
      if Tabelle.Cells[i,j].color <> '' then
        StartTag := StartTag + Tabelle.Cells[i,j].color;
      if Tabelle.Cells[i,j].bold then
        StartTag := StartTag + '[b]';
      if Tabelle.Cells[i,j].italic then
        StartTag := StartTag + '[i]';
      if Tabelle.Cells[i,j].underline then
        StartTag := StartTag + '[u]';

      EndTag := '';
      if Tabelle.Cells[i,j].underline then
        EndTag := EndTag + '[/u]';
      if Tabelle.Cells[i,j].italic then
        EndTag := EndTag + '[/i]';
      if Tabelle.Cells[i,j].bold then
        EndTag := EndTag + '[/b]';
      if Tabelle.Cells[i,j].color <> '' then
        EndTag := EndTag + '[/color]';

      fuellString := getFuellString(maxLength-length(Tabelle.Cells[i,j].Cell.Text));
      if checkBild(i,j) then
      begin
        anz := anz + 1;
        fuellString := getFuellString(maxLength-length(Tabelle.Cells[i,j].Cell.Text)+3);
      end;


      if Tabelle.Cells[i,j].align_left then BBCode := BBCode + StartTag + Tabelle.Cells[i,j].Cell.Text + EndTag + fuellString;
      if Tabelle.Cells[i,j].align_right then BBCode := BBCode + fuellString + StartTag + Tabelle.Cells[i,j].Cell.Text + EndTag;

      fuellStringVorne := copy(fuellString,1,length(fuellString) div 2);
      fuellStringHinten := copy(fuellString,length(fuellString) div 2,length(fuellString)-length(fuellString) div 2);
      if Tabelle.Cells[i,j].align_center then BBCode := BBCode + fuellStringVorne + StartTag + Tabelle.Cells[i,j].Cell.Text + EndTag + fuellStringHinten;

      if i < Tabelle.Cols-1 then
      begin
        BBCode := BBCode + leerString;
        if (anz mod 2 = 0) and (anz <>0) then BBCode := BBCode + Tabelle.FuellZeichen;
      end;
    end;
    BBCode := BBCode +chr(13)+chr(10);
  end;
  BBCode := BBCode + '[/face]';

  deleteFuellStrings(BBCode);

  BBCode := StringReplace(BBCode,'[Nrg]','rxenergie',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Rek]','rxmannschaft',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Erz]','rxerz',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Org]','rxorganics',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Syn]','rxsynthetics',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Fes]','rxeisenmetalle',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Lms]','rxleichtmetalle',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Sms]','rxschwermetalle',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Ems]','rxedelmetalle',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Rad]','rxradios',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Eds]','rxedelsteine',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Edg]','rxedelgase',[rfReplaceAll]);
  BBCode := StringReplace(BBCode,'[Iso]','rxisotope',[rfReplaceAll]);

  memBBCode.Text := BBCode;
  memBBCode.SetFocus;
  memBBcode.SelectAll;
end;

procedure saveTable(FileName: String);
var f: TextFile;
    i,j : Integer;
begin
  AssignFile(f, FileName); { Datei in Dialogfeld ausgewählt }
  Rewrite(f);
  Writeln(f, 'Version 2,0');
  Writeln(f, inttostr(Tabelle.Cols));
  Writeln(f, inttostr(Tabelle.Rows));
  for j := 0 to Tabelle.Rows-1 do
  begin
    for i := 0 to Tabelle.Cols-1 do
    begin
      Writeln(f, Tabelle.Cells[i,j].Cell.Text);
      Writeln(f, Tabelle.Cells[i,j].url);
      Writeln(f, Tabelle.Cells[i,j].Bild);
      Writeln(f, Tabelle.Cells[i,j].Bold);
      Writeln(f, Tabelle.Cells[i,j].Italic);
      Writeln(f, Tabelle.Cells[i,j].Underline);
      Writeln(f, Tabelle.Cells[i,j].align_left);
      Writeln(f, Tabelle.Cells[i,j].align_center);
      Writeln(f, Tabelle.Cells[i,j].align_right);
      Writeln(f, Tabelle.Cells[i,j].Color);
    end;
  end;
  CloseFile(f);
end;


procedure TfrmCreator.btnLeftClick(Sender: TObject);
var a,i,j : Integer;
begin
  Tabelle.Saved := false;

  getIJ(i,j);

  Tabelle.Cells[i,j].align_left := true;
  Tabelle.Cells[i,j].align_center := false;
  Tabelle.Cells[i,j].align_right := false;
  Tabelle.Cells[i,j].Cell.Alignment := taLeftJustify;
end;

procedure TfrmCreator.btnCenterClick(Sender: TObject);
var a,i,j : Integer;
begin
  Tabelle.Saved := false;

  getIJ(i,j);

  Tabelle.Cells[i,j].align_left := false;
  Tabelle.Cells[i,j].align_center := true;
  Tabelle.Cells[i,j].align_right := false;
  Tabelle.Cells[i,j].Cell.Alignment := taCenter;
end;

procedure TfrmCreator.btnRightClick(Sender: TObject);
var a,i,j : Integer;
begin
  Tabelle.Saved := false;

  getIJ(i,j);

  Tabelle.Cells[i,j].align_left := false;
  Tabelle.Cells[i,j].align_center := false;
  Tabelle.Cells[i,j].align_right := true;
  Tabelle.Cells[i,j].Cell.Alignment := taRightJustify;
end;

procedure TfrmCreator.btnSpeichernClick(Sender: TObject);
var Msg: WideString;
begin
  SaveDialog.FileName := Tabelle.Filename;
  if SaveDialog.Execute then            { Öffnen-Dialogfeld anzeigen }
  begin
    if fileexists(SaveDialog.FileName) and (SaveDialog.FileName<>Tabelle.Filename) then
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

function saveRequest(): Word;
var Msg : String;
    Answer: Word;
begin
  Result := mrYes;
  if Tabelle.Saved = false then
  begin
    Msg := 'Ihre Tabelle ist noch nicht gespeichert!' +chr(13)+chr(10)+
           'Möchten Sie dies nun tun?';
    Answer := MessageDlg(Msg, mtWarning, [mbYes, mbNo, mbAbort], 0);
    if Answer = mrYes then frmCreator.btnSpeichernClick(frmCreator);
    Result := Answer;
  end;
end;

procedure openTable;
var
  f: TextFile;
  i,j : Integer;
  S: String;
  captionBox: string;
begin
    with frmCreator do
    begin
      deleteTable();
      AssignFile(f, Tabelle.FileName); { Datei in Dialogfeld ausgewählt }
      Reset(f);
      Readln(f, S);
      if length(S) < 7 then
      begin
        Tabelle.Version := 1.0;
        Tabelle.Cols := strtoint(S);
      end
      else
      begin
        Readln(f, Tabelle.Cols);
        Tabelle.Version := strtofloat(copy(S,9,length(S)-8));
      end;
      if Tabelle.Version = 2.0 then
      begin
        Readln(f, Tabelle.Rows);
        frmCreator.deleteText(edtZeilen);
        frmCreator.deleteText(edtSpalten);
        frmCreator.deleteText(edtSpaltenBreite);
        frmCreator.edtZeilen.Text := inttostr(Tabelle.Rows);
        frmCreator.edtSpalten.Text := inttostr(Tabelle.Cols);
        frmCreator.edtSpaltenBreite.Text := '100';

        setSize();
        SetLength(Tabelle.Cells, Tabelle.Cols, Tabelle.Rows);

        frmCreator.pnlTabelle.Visible := false;
        for j := 0 to Tabelle.Rows-1 do
          for i := 0 to Tabelle.Cols-1 do
          begin

            Readln(f, captionBox);

            if Tabelle.Version > 1.0 then
            begin
              Readln(f, Tabelle.Cells[i,j].url);
              Readln(f, Tabelle.Cells[i,j].Bild);
            end;

            Readln(f, S);
            if S='TRUE' then Tabelle.Cells[i,j].Bold := true
            else Tabelle.Cells[i,j].Bold := false;

            Readln(f, S);
            if S='TRUE' then Tabelle.Cells[i,j].Italic := true
            else Tabelle.Cells[i,j].Italic := false;

            Readln(f, S);
            if S='TRUE' then Tabelle.Cells[i,j].Underline := true
            else Tabelle.Cells[i,j].Underline := false;

            if Tabelle.Version > 1.0 then
            begin
              Readln(f,S);
              if S='TRUE' then Tabelle.Cells[i,j].align_left := true
              else Tabelle.Cells[i,j].align_left := false;

              Readln(f,S);
              if S='TRUE' then Tabelle.Cells[i,j].align_center := true
              else Tabelle.Cells[i,j].align_center := false;

              Readln(f,S);
              if S='TRUE' then Tabelle.Cells[i,j].align_right := true
              else Tabelle.Cells[i,j].align_right := false;
            end
            else
            begin
              Tabelle.Cells[i,j].align_left := true;
              Tabelle.Cells[i,j].align_center := false;
              Tabelle.Cells[i,j].align_right := false;
            end;

            Readln(f, S);
            Tabelle.Cells[i,j].Color := S;

            createTable(i,j,captionBox);

          end;
        Tabelle.Saved := True;
        frmCreator.pnlTabelle.Visible := true;
      end
      else
      begin
        showmessage('Die ausgewählte Tabelle wurde mit der Version ' + floattostr(Tabelle.Version) + ' erstellt.'+chr(13)+
                    'Sie besitzen jedoch nur die Version 2.0.');
      end;
      CloseFile(f);
    end;
end;

procedure TfrmCreator.btnLadenClick(Sender: TObject);
begin

  if saveRequest() <> mrAbort then
  begin
    if OpenDialog.Execute then            { Öffnen-Dialogfeld anzeigen }
    begin
      Tabelle.Filename := OpenDialog.FileName;
      openTable;
    end;
  end;
end;

function checkEingabe(text: String): Boolean;
var i: Integer;
begin
  Result := true;
  for i := 1 to length(text) do
  begin
    if (ord(text[i]) < ord('0')) or
       (ord(text[i]) > ord('9')) then
       Result := false;
  end;
end;

procedure TfrmCreator.btnUpdateClick(Sender: TObject);
var i,j : Integer;
    Msg : String;
    Answer : Word;
    oldCols, oldRows, oldLength: Integer;
begin
  if (checkEingabe(edtZeilen.Text)) and
     (checkEingabe(edtSpalten.Text)) and
     (checkEingabe(edtSpaltenBreite.Text)) then
  begin
    Answer := mrYes;
    if (edtSpalten.Text = '') or (edtZeilen.Text = '') or (edtSpaltenBreite.Text = '') or
      (edtSpalten.Text = 'Spalten') or (edtZeilen.Text = 'Zeilen') or (edtSpaltenBreite.Text = 'Zellbreite') then
      showmessage('Sie müssen die Zeilen, die Spalten und die Zellbreite festlegen.')
    else
    begin

      if (Answer = mrNo) or (Answer = mrYes) then
      begin

        oldCols := Tabelle.Cols;
        oldRows := Tabelle.Rows;
        oldLength := Tabelle.cellWidth;

        Tabelle.Cols := StrToInt(edtSpalten.Text);
        Tabelle.Rows := StrToInt(edtZeilen.Text);
        Tabelle.cellWidth := StrToInt(edtSpaltenBreite.Text);
        Tabelle.cellHeight := 20;

        frmCreator.pnlTabelle.Visible := false;
        if (oldRows > Tabelle.Rows) or (oldCols > Tabelle.Cols) then
        begin
          for j := 0 to oldRows-1 do
            for i := 0 to oldCols-1 do
              if (j > Tabelle.Rows-1) or (i > Tabelle.Cols-1) then Tabelle.Cells[i,j].Cell.Free;
        end;

        setLength(Tabelle.Cells,Tabelle.Cols,Tabelle.Rows);

        if oldLength <> Tabelle.cellWidth then
          for j := 0 to Tabelle.Rows-1 do
            for i := 0 to Tabelle.Cols-1 do
              createTable(i,j,Tabelle.Cells[i,j].Cell.Text);

        for j := 0 to Tabelle.Rows-1 do
         for i := 0 to Tabelle.Cols-1 do
           begin
            if (i >= oldCols) or (j >= oldRows) then
            begin
              Tabelle.Cells[i,j].bold := false;
              Tabelle.Cells[i,j].italic := false;
              Tabelle.Cells[i,j].underline := false;
              Tabelle.Cells[i,j].align_left := true;
              Tabelle.Cells[i,j].align_center := false;
              Tabelle.Cells[i,j].align_right := false;
              Tabelle.Cells[i,j].color := '';
              Tabelle.Saved := false;
              createTable(i,j,'');
            end;
          end;
        setSize();
        frmCreator.pnlTabelle.Visible := true;

      end;
    end;
  end
  else
     showmessage('Sie dürfen nur Zahlen eingeben!');
end;

procedure TfrmCreator.FormResize(Sender: TObject);
begin
  ControlBar1.Width := frmCreator.Width-10;
end;

procedure TfrmCreator.deleteText(Sender: TObject);
begin
  TEdit(Sender).Font.Color := clBlack;
  TEdit(Sender).Font.Style := [];
  TEdit(Sender).Text := '';
end;

procedure TfrmCreator.btnNeuClick(Sender: TObject);
var i,j : Integer;
begin
  if saveRequest() <> mrAbort then
  begin
    deleteTable();

    Tabelle.Rows := 5;
    Tabelle.Cols := 5;
    Tabelle.cellWidth := 70;
    Tabelle.cellHeight := 20;

    frmCreator.deleteText(edtZeilen);
    frmCreator.deleteText(edtSpalten);
    frmCreator.deleteText(edtSpaltenBreite);
    edtSpalten.Text := '5';
    edtZeilen.Text := '5';
    edtSpaltenBreite.Text := '70';

    frmCreator.pnlTabelle.Visible := false;
    setLength(Tabelle.Cells,Tabelle.Cols,Tabelle.Rows);

    for j := 0 to Tabelle.Rows-1 do
      for i := 0 to Tabelle.Cols-1 do
      begin
        Tabelle.Cells[i,j].bold := false;
        Tabelle.Cells[i,j].italic := false;
        Tabelle.Cells[i,j].underline := false;
        Tabelle.Cells[i,j].align_left := true;
        Tabelle.Cells[i,j].align_center := false;
        Tabelle.Cells[i,j].align_right := false;
        Tabelle.Cells[i,j].color := '';
        Tabelle.Saved := false;
        createTable(i,j,'');
      end;

    setSize();
    frmCreator.pnlTabelle.Visible := true;
  end;
end;

procedure TfrmCreator.cmbRohstoffeChange(Sender: TObject);
var i,j : Integer;
begin
  getIJ(i,j);

  case cmbRohstoffe.ItemIndex of
    1: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Nrg]';
    2: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Rek]';
    3: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Erz]';
    4: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Org]';
    5: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Syn]';
    6: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Fes]';
    7: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Lms]';
    8: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Sms]';
    9: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Ems]';
    10: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Rad]';
    11: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Eds]';
    12: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Edg]';
    13: Tabelle.Cells[i,j].Cell.Text := Tabelle.Cells[i,j].Cell.Text + '[Iso]';
  end;

end;

procedure TfrmCreator.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if saveRequest() = mrAbort then
  begin
    Action := caNone;
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

function getLevel(name: String) : String;
var start, laenge : Integer;
    text : String;
begin
  text := frmCreator.memBBCode.Text;
  start := Pos(name,text) + length(name);
  delete(text,1,start-1);
  laenge := Pos(')',text)-1;
  if isNumber(Copy(text,0,laenge)) then
    Result := Copy(text,0,laenge)
  else
    Result := '';
end;

procedure TfrmCreator.Button1Click(Sender: TObject);
var i: Integer;
    forschung : Array[0..20] of String;
begin
if AnsiContainsStr(memBBCode.Text,'Gesamtraum') then
begin
  Tabelle.Filename := 'GebäudeForschung.tbl';
  openTable;

  Tabelle.Cells[2,2].Cell.Text := getLevel('Konstruktionsanlage (Lvl ');
  Tabelle.Cells[2,3].Cell.Text := getLevel('Venad-Volumen (Lvl ');
  Tabelle.Cells[2,4].Cell.Text := getLevel('Forschungsanlage (Lvl ');
  Tabelle.Cells[2,5].Cell.Text := getLevel('Entwicklungsanlage (Lvl ');
  Tabelle.Cells[2,6].Cell.Text := getLevel('Werft (Lvl ');
  Tabelle.Cells[2,7].Cell.Text := getLevel('Dock (Lvl ');
  Tabelle.Cells[2,8].Cell.Text := getLevel('Kommandozentrum (Lvl ');
  Tabelle.Cells[2,9].Cell.Text := getLevel('Quartiere (Lvl ');
  Tabelle.Cells[2,10].Cell.Text := getLevel('Trainingsanlage (Lvl ');
  Tabelle.Cells[2,11].Cell.Text := getLevel('Spionageanlage (Lvl ');

  Tabelle.Cells[2,16].Cell.Text := getLevel('Kommunikationsanlage (Lvl ');
  Tabelle.Cells[2,17].Cell.Text := getLevel('Handelszentrum (Lvl ');
  Tabelle.Cells[2,18].Cell.Text := getLevel('Portal (Lvl ');

  Tabelle.Cells[2,23].Cell.Text := getLevel('Energiematrix (Lvl ');
  Tabelle.Cells[2,24].Cell.Text := getLevel('Reaktor (Lvl ');
  Tabelle.Cells[2,25].Cell.Text := getLevel('Energiespeicher (Lvl ');
  Tabelle.Cells[2,26].Cell.Text := getLevel('Silo (Lvl ');
  Tabelle.Cells[2,27].Cell.Text := getLevel('Wohnraum (Lvl ');
  Tabelle.Cells[2,28].Cell.Text := getLevel('Biopod (Lvl ');
  Tabelle.Cells[2,29].Cell.Text := getLevel('Chemiefabrik (Lvl ');
  Tabelle.Cells[2,30].Cell.Text := getLevel('Raffinerie (Lvl ');
  Tabelle.Cells[2,31].Cell.Text := getLevel('Klonanlage (Lvl ');

  Tabelle.Cells[2,36].Cell.Text := getLevel('Quantenlabor (Lvl ');
  Tabelle.Cells[2,37].Cell.Text := getLevel('Elektronenlabor (Lvl ');
  Tabelle.Cells[2,38].Cell.Text := getLevel('Protonenlabor (Lvl ');
  Tabelle.Cells[2,39].Cell.Text := getLevel('Neutronenlabor (Lvl ');
  Tabelle.Cells[2,40].Cell.Text := getLevel('Biolabor (Lvl ');
  Tabelle.Cells[2,41].Cell.Text := getLevel('Materiallabor (Lvl ');
  Tabelle.Cells[2,42].Cell.Text := getLevel('Strahlungslabor (Lvl ');
  Tabelle.Cells[2,43].Cell.Text := getLevel('Computerlabor (Lvl ');
  Tabelle.Cells[2,44].Cell.Text := getLevel('Antimaterielabor (Lvl ');
  Tabelle.Cells[2,45].Cell.Text := getLevel('Teilchenbeschleuniger (Lvl ');

  Forschung[0] := getLevel('Quantenmechanik - Quantenlabor (Level ');
  Forschung[1] := getLevel('Energetik - Quantenlabor Elektronenlabor (Level ');
  Forschung[2] := getLevel('Temperate - Materiallabor (Level ');
  Forschung[3] := getLevel('Ionenverhalten - Elektronenlabor (Level ');
  Forschung[4] := getLevel('Protonenverhalten - Protonenlabor (Level ');
  Forschung[5] := getLevel('Genetik - Biolabor (Level ');
  Forschung[6] := getLevel('Biochemie - Biolabor (Level ');
  Forschung[7] := getLevel('Photovoltaik - Strahlungslabor (Level ');
  Forschung[8] := getLevel('Keramik - Materiallabor (Level ');
  Forschung[9] := getLevel('Verbundstoffe - Materiallabor Strahlungslabor (Level ');
  Forschung[10] := getLevel('Legierungen - Materiallabor (Level ');
  Forschung[11] := getLevel('Strahlungstechnik - Strahlungslabor (Level ');
  Forschung[12] := getLevel('Computertechnik - Computerlabor (Level ');
  Forschung[13] := getLevel('Nanotechnik - Computerlabor (Level ');
  Forschung[14] := getLevel('Leiterbahnen - Elektronenlabor (Level ');
  Forschung[15] := getLevel('Massenanreicherung - Neutronenlabor Teilchenbeschleuniger (Level ');
  Forschung[16] := getLevel('Energieverdichtung - Antimaterielabor (Level ');
  Forschung[17] := getLevel('Antimaterie - Antimaterielabor Teilchenbeschleuniger (Level ');
  Forschung[18] := getLevel('Atombindungen - Protonenlabor (Level ');
  Forschung[19] := getLevel('Molekülstrukturen - Quantenlabor Neutronenlabor (Level ');
  Forschung[20] := getLevel('Kybernetik - Computerlabor Elektronenlabor (Level ');

  if Forschung[0] <> '' then
  begin
    // Quantenlabor
    if (Forschung[0] <> '0') or (Forschung[1] <> '0') then
    begin
      Tabelle.Cells[3,36].Cell.Text := '(';
      if Forschung[0] <> '0' then Tabelle.Cells[3,36].Cell.Text := Tabelle.Cells[3,36].Cell.Text + 'Quantenmechanik ' + Forschung[0];
      if (Forschung[0] <> '0') and (Forschung[1] <> '0') then Tabelle.Cells[3,36].Cell.Text := Tabelle.Cells[3,36].Cell.Text + ', ';
      if Forschung[1] <> '0' then Tabelle.Cells[3,36].Cell.Text := Tabelle.Cells[3,36].Cell.Text + 'Energetik ' + Forschung[1];
      Tabelle.Cells[3,36].Cell.Text := Tabelle.Cells[3,36].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,36].Cell.Text := '';

    // Elektrolabor
    if (Forschung[3] <> '0') or (Forschung[14] <> '0') then
    begin
      Tabelle.Cells[3,37].Cell.Text := '(';
      if Forschung[3] <> '0' then Tabelle.Cells[3,37].Cell.Text := Tabelle.Cells[3,37].Cell.Text + 'Ionenverhalten ' + Forschung[3];
      if (Forschung[3] <> '0') and (Forschung[14] <> '0') then Tabelle.Cells[3,37].Cell.Text := Tabelle.Cells[3,37].Cell.Text + ', ';
      if Forschung[14] <> '0' then Tabelle.Cells[3,37].Cell.Text := Tabelle.Cells[3,37].Cell.Text + 'Leiterbahnen ' + Forschung[14];
      Tabelle.Cells[3,37].Cell.Text := Tabelle.Cells[3,37].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,37].Cell.Text := '';

    // Protonenlabor
    if (Forschung[4] <> '0') or (Forschung[18] <> '0') then
    begin
      Tabelle.Cells[3,38].Cell.Text := '(';
      if Forschung[4] <> '0' then Tabelle.Cells[3,38].Cell.Text := Tabelle.Cells[3,38].Cell.Text + 'Protonforschung ' + Forschung[4];
      if (Forschung[4] <> '0') and (Forschung[18] <> '0') then Tabelle.Cells[3,38].Cell.Text := Tabelle.Cells[3,38].Cell.Text + ', ';
      if Forschung[18] <> '0' then Tabelle.Cells[3,38].Cell.Text := Tabelle.Cells[3,38].Cell.Text + 'Atombindungen ' + Forschung[18];
      Tabelle.Cells[3,38].Cell.Text := Tabelle.Cells[3,38].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,38].Cell.Text := '';

    // Neutronenlabor
    if (Forschung[15] <> '0') or (Forschung[19] <> '0') then
    begin
      Tabelle.Cells[3,39].Cell.Text := '(';
      if Forschung[15] <> '0' then Tabelle.Cells[3,39].Cell.Text := Tabelle.Cells[3,39].Cell.Text + 'Masseanreicherung ' + Forschung[15];
      if (Forschung[15] <> '0') and (Forschung[19] <> '0') then Tabelle.Cells[3,39].Cell.Text := Tabelle.Cells[3,39].Cell.Text + ', ';
      if Forschung[19] <> '0' then Tabelle.Cells[3,39].Cell.Text := Tabelle.Cells[3,39].Cell.Text + 'Molekülstrukturen ' + Forschung[19];
      Tabelle.Cells[3,39].Cell.Text := Tabelle.Cells[3,39].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,39].Cell.Text := '';

    // Biolabor
    if (Forschung[5] <> '0') or (Forschung[6] <> '0') then
    begin
      Tabelle.Cells[3,40].Cell.Text := '(';
      if Forschung[5] <> '0' then Tabelle.Cells[3,40].Cell.Text := Tabelle.Cells[3,40].Cell.Text + 'Genetik ' + Forschung[5];
      if (Forschung[5] <> '0') and (Forschung[6] <> '0') then Tabelle.Cells[3,40].Cell.Text := Tabelle.Cells[3,40].Cell.Text + ', ';
      if Forschung[6] <> '0' then Tabelle.Cells[3,40].Cell.Text := Tabelle.Cells[3,40].Cell.Text + 'Biochemie ' + Forschung[6];
      Tabelle.Cells[3,40].Cell.Text := Tabelle.Cells[3,40].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,40].Cell.Text := '';

    // Materiallabor
    if (Forschung[2] <> '0') or (Forschung[8] <> '0') or (Forschung[10] <> '0') then
    begin
      Tabelle.Cells[3,41].Cell.Text := '(';
      if Forschung[2] <> '0' then Tabelle.Cells[3,41].Cell.Text := Tabelle.Cells[3,41].Cell.Text + 'Temperate ' + Forschung[2];
      if (Forschung[2] <> '0') and (Forschung[8] <> '0') or (Forschung[2] <> '0') and (Forschung[10] <> '0') then Tabelle.Cells[3,41].Cell.Text := Tabelle.Cells[3,41].Cell.Text + ', ';
      if Forschung[8] <> '0' then Tabelle.Cells[3,41].Cell.Text := Tabelle.Cells[3,41].Cell.Text + 'Keramik ' + Forschung[8];
      if (Forschung[8] <> '0') and (Forschung[10] <> '0') then Tabelle.Cells[3,41].Cell.Text := Tabelle.Cells[3,41].Cell.Text + ', ';
      if Forschung[10] <> '0' then Tabelle.Cells[3,41].Cell.Text := Tabelle.Cells[3,41].Cell.Text + 'Legierungen ' + Forschung[10];
      Tabelle.Cells[3,41].Cell.Text := Tabelle.Cells[3,41].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,41].Cell.Text := '';

    // Strahlungslabor
    if (Forschung[11] <> '0') or (Forschung[7] <> '0') or (Forschung[9] <> '0') then
    begin
      Tabelle.Cells[3,42].Cell.Text := '(';
      if Forschung[11] <> '0' then Tabelle.Cells[3,42].Cell.Text := Tabelle.Cells[3,42].Cell.Text + 'Strahlungstechnik ' + Forschung[11];
      if (Forschung[11] <> '0') and (Forschung[7] <> '0') or (Forschung[11] <> '0') and (Forschung[9] <> '0') then Tabelle.Cells[3,42].Cell.Text := Tabelle.Cells[3,42].Cell.Text + ', ';
      if Forschung[7] <> '0' then Tabelle.Cells[3,42].Cell.Text := Tabelle.Cells[3,42].Cell.Text + 'Photovoltaik ' + Forschung[7];
      if (Forschung[7] <> '0') and (Forschung[9] <> '0') then Tabelle.Cells[3,42].Cell.Text := Tabelle.Cells[3,42].Cell.Text + ', ';
      if Forschung[9] <> '0' then Tabelle.Cells[3,42].Cell.Text := Tabelle.Cells[3,42].Cell.Text + 'Verbundstoffe ' + Forschung[9];
      Tabelle.Cells[3,42].Cell.Text := Tabelle.Cells[3,42].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,42].Cell.Text := '';

    // Computerlabor
    if (Forschung[12] <> '0') or (Forschung[13] <> '0') or (Forschung[20] <> '0') then
    begin
      Tabelle.Cells[3,43].Cell.Text := '(';
      if Forschung[12] <> '0' then Tabelle.Cells[3,43].Cell.Text := Tabelle.Cells[3,43].Cell.Text + 'Computertechnik ' + Forschung[12];
      if (Forschung[12] <> '0') and (Forschung[13] <> '0') or (Forschung[12] <> '0') and (Forschung[20] <> '0') then Tabelle.Cells[3,43].Cell.Text := Tabelle.Cells[3,43].Cell.Text + ', ';
      if Forschung[13] <> '0' then Tabelle.Cells[3,43].Cell.Text := Tabelle.Cells[3,43].Cell.Text + 'Nanotechnologie ' + Forschung[13];
      if (Forschung[13] <> '0') and (Forschung[20] <> '0') then Tabelle.Cells[3,43].Cell.Text := Tabelle.Cells[3,43].Cell.Text + ', ';
      if Forschung[20] <> '0' then Tabelle.Cells[3,43].Cell.Text := Tabelle.Cells[3,43].Cell.Text + 'Kybernetik ' + Forschung[20];
      Tabelle.Cells[3,43].Cell.Text := Tabelle.Cells[3,43].Cell.Text + ')';
    end
    else
      Tabelle.Cells[3,43].Cell.Text := '';

    // Antimaterielabor
    if (Forschung[16] <> '0') then
      Tabelle.Cells[3,44].Cell.Text := '(Energieverdichtung ' + Forschung[16] + ')'
    else
      Tabelle.Cells[3,44].Cell.Text := '';

  end
  else
  begin
    for i := 36 to 45 do
      Tabelle.Cells[3,i].Cell.Text := '';
  end;

if AnsiContainsStr(memBBCode.Text,'Taktik') then
begin
  Tabelle.Filename := 'CaptainAgenten.tbl';
  openTable;
end;
end;

end;

end.
