unit RXBot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellAPI, strUtils, ClipBrd, MyIO, Convert,
  jpeg, Grids, Buttons, Handel, Records, Sammeln;

type
  TForm1 = class(TForm)
    Image2: TImage;
    lblInfo: TLabel;
    lblStartStop: TLabel;
    lblBeenden: TLabel;
    lblHandel: TLabel;
    lblCreateTable: TLabel;
    Label2: TLabel;
    lblStatus: TLabel;
    lblRess: TLabel;
    lblEinstellungen: TLabel;
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
    Panel2: TPanel;
    stgTabelle: TStringGrid;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button7: TButton;
    Button5: TButton;
    Button6: TButton;
    mmoDaten: TMemo;
    Timer1: TTimer;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Shape1: TShape;
    lblTabelleInfo: TLabel;
    Timer2: TTimer;
    Button1: TButton;
    CheckBox14: TCheckBox;
    Memo1: TMemo;
    Timer3: TTimer;
    ListBox1: TListBox;
    lblPlaner: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure lblStartStopClick(Sender: TObject);
    procedure lblBeendenClick(Sender: TObject);
    procedure CheckboxClick(Sender: TObject);
    procedure lblHandelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure CheckBox14Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    RessTabelle: array[0..200] of TTabelle;
    hilf: array[0..100] of TTabelle;
    RessName: TRessName;
    TabCount: Integer;
    AnzeigeCode: String;
    Trade: THandel;
    Sammeln: TSammeln;
    IO: TIO;
    stop: Boolean;
    Settings: TSettings;
    Zustand : Integer;
    Speed : Integer;
    Verschiebung : TPoint;
    Schiff : TSchiff;
    Wiederholung : Integer;
    Button: TButtons;
    HandelZaehler: Integer;
    Wartezeit: Integer;
    Fehler: Integer;
    Debug: boolean;
    LauftextZaehler: Integer;
    InfoText: String;
    MaxLength: Integer;
    Space: String;
    procedure Initial;
    procedure SetDesign;
    procedure writeLog(msg: String);
    procedure showTabelle(elements: String);
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


const CODES_PATH = 'Kontrollcodes.txt';
      URL = 'http://217.160.164.101/rx/login/';
      MAXWDH = 10;

// Erstellt ein kleines Log
procedure TForm1.writeLog(msg: String);
var
  Present: TDateTime;
begin
  Form1.ListBox1.Items.Add(datetimetostr(Now)+' - '+msg);
  Form1.ListBox1.ItemIndex := Form1.ListBox1.Count-1;
  Form1.lblInfo.Caption := 'Ein Fehler ist aufgetreten: siehe log';
  Fehler := Fehler + 1;
  if Fehler = MAXWDH then Zustand := 1;
end;

procedure TForm1.showTabelle(elements: String);
var i, count: Integer;
    altRess: String;
begin
  i := 0;
  count := 0;
  altRess := Form1.RessTabelle[0].Ressource;
  while (i < Form1.TabCount) do
  begin
    with Form1 do
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
//        stgTabelle.Cells[5,count] := DateTimeToStr(RessTabelle[i].EndetAm);
//        stgTabelle.Cells[6,count] := DTimeToStr(RessTabelle[i].EndetIn);
        altRess := RessTabelle[i].Ressource;
        count := count + 1;
      end;
      i := i + 1;
    end;
  end;
  Form1.lblTabelleInfo.Caption := inttostr(Form1.stgTabelle.RowCount)+' Einträge'
end;

// Abarbeitung der einzelnen Aufgaben
procedure TForm1.Timer1Timer(Sender: TObject);
var myColor : TColor;
    Stunden,Minuten,Sekunden,HSeks: Word;
    Nrg, Rek, Erz, Org, Syn, Fe, LM, SM, EM, Rad, ES, EG, Iso: TTradeEntry;
begin
  with Button do
  begin
      case Zustand of
        0: begin
             ListBox1.Items.Add(IntToStr(Mouse.CursorPos.X)+' - '+IntToStr(Mouse.CursorPos.Y)+' - '+inttostr(myColor));
             Form1.Color := myColor;
             ListBox1.ItemIndex := ListBox1.Count-1;
           end;
         1: begin  // Ressourcen sammeln
              lblStatus.Caption := 'Ressourcen sammeln';
              Sammeln := TSammeln.Create;
              Sammeln.Sammeln;
              Zustand := 2;
            end;
         2: begin
              if Sammeln.getInfo = 'exit' then close();
              if Sammeln.getFinishState then
              begin
                Sammeln.Destroy;
                IO.ClickOn(News.X,News.Y);
                timer1.Interval := 0;
                DecodeTime(GetTime,Stunden,Minuten,Sekunden,HSeks);
                if Stunden < 10 then
                  Wartezeit := 3500*60 + random(60000) + 5000*60*random(3)
                else
                  Wartezeit := 3500*60 + random(60000);
                timer2.Interval := 1000;
                lblInfo.Caption := 'Revorix-Bot';
                HandelZaehler := HandelZaehler + 1;
                if HandelZaehler < 3 then
                  Zustand := 1
                else
                begin
                  HandelZaehler := 0;
                  Zustand := 13;
                end;
              end;
            end;
        13: begin  // Handel
              lblStatus.Caption := 'prüfe Handelsgüter';
              Trade := THandel.Create;
              Trade.updateData;
              Zustand := 14;
            end;
        14: begin  // Direkt-Handel
//              if not Trade.getFinishState then gInfoText := 'Handelstool: keine Rückmeldung!';
              if Trade.getInfo = 'exit' then close();
              if Trade.getFinishState then
              begin
                Trade.getBilligsteAll(Nrg, Rek, Erz, Org, Syn, Fe, LM, SM, EM, Rad, ES, EG, Iso);
                Settings.Ticker_Ress := 'Erz,LM,SM,Rad,ES,EG,Iso';
                InfoText := Space + 'Direkthandel-News: ('+inttostr(Trade.getCount)+' Einträge) ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Nrg') then InfoText := InfoText + 'Nrg: '+inttostr(Nrg.Menge)+ ' für '+FormatFloat('0.00',Nrg.Preis)+' ('+Nrg.Venad+')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Rek') then InfoText := InfoText + 'Rek: '+inttostr(Rek.Menge)+ ' für '+FormatFloat('0.00',Rek.Preis)+' ('+Rek.Venad+')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Erz') then InfoText := InfoText + 'Erz: '+inttostr(Erz.Menge)+ ' für '+FormatFloat('0.00',Erz.Preis)+' ('+Erz.Venad+')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Org') then InfoText := InfoText + 'Org: '+inttostr(Org.Menge)+ ' für '+FormatFloat('0.00',Org.Preis)+' ('+Org.Venad+')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Syn') then InfoText := InfoText + 'Syn: '+inttostr(Syn.Menge)+ ' für '+FormatFloat('0.00',Syn.Preis)+' ('+Syn.Venad+')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Fe')  then InfoText := InfoText + 'Fe: ' +inttostr(Fe.Menge) + ' für '+FormatFloat('0.00',Fe.Preis) +' ('+Fe.Venad +')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'LM')  then InfoText := InfoText + 'LM: ' +inttostr(LM.Menge) + ' für '+FormatFloat('0.00',LM.Preis) +' ('+LM.Venad +')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'SM')  then InfoText := InfoText + 'SM: ' +inttostr(SM.Menge) + ' für '+FormatFloat('0.00',SM.Preis) +' ('+SM.Venad +')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'EM')  then InfoText := InfoText + 'EM: ' +inttostr(EM.Menge) + ' für '+FormatFloat('0.00',EM.Preis) +' ('+EM.Venad +')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Rad') then InfoText := InfoText + 'Rad: '+inttostr(Rad.Menge)+ ' für '+FormatFloat('0.00',Rad.Preis)+' ('+Rad.Venad+')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'ES')  then InfoText := InfoText + 'ES: ' +inttostr(ES.Menge) + ' für '+FormatFloat('0.00',ES.Preis) +' ('+ES.Venad +')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'EG')  then InfoText := InfoText + 'EG: ' +inttostr(EG.Menge) + ' für '+FormatFloat('0.00',EG.Preis) +' ('+EG.Venad +')  |  ';
                if AnsiContainsStr(Settings.Ticker_Ress,'Iso') then InfoText := InfoText + 'Iso: '+inttostr(Iso.Menge)+ ' für '+FormatFloat('0.00',Iso.Preis)+' ('+Iso.Venad+')  |  ';
                Trade.Destroy;
                Zustand := 1;
              end;
            end;
      end;
  end;
end;

procedure TForm1.Initial;
var i: Integer;
begin
  Randomize;

  MaxLength := 115;
  Verschiebung.X := 0;
  Verschiebung.Y := 0;

  for i := 1 to MaxLength do
    Space := Space + ' ';

  InfoText := Space + 'Momentan keine News verfügbar';
end;

procedure TForm1.setDesign;
begin
  Button1.Left := 1;
  Button1.Top := 0;
  Button1.Width := 102;
  Button1.Height := 17;
  Button1.Caption := 'Ressourcen';
  Button1.Parent := Panel2;

  form1.Left := 156;
  form1.Top := 109;
  Form1.Height := 71;
  Form1.Width := 848;

  form1.Image2.Picture.LoadFromFile('background.bmp');
  Form1.Image2.Left := 0;
  Form1.Image2.Top := 0;
  Form1.Image2.Width := Form1.Width;
  Form1.Image2.Height := Form1.Height;

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
end;

procedure TForm1.FormCreate(Sender: TObject);
var i :integer;
    Space: String;
begin
  IO := TIO.Create;

  Initial;
  IO.LoadSettings;
  Button := IO.getButtons;
  SetDesign;


  lblStartStopClick(Sender);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var Min, Sek: Integer;
    SekNull: String;
begin
  if Wartezeit <= 0 then
  begin
    timer2.Interval := 0;
    Schiff.RessEingeladen := false;
    Schiff.Index := 0;
    Schiff.StopIndex := 0;
    Zustand := 1;
    timer1.Interval := Speed;
  end
  else
  begin
    Wartezeit := Wartezeit - 1000;
    Min := trunc(Wartezeit/1000/60);
    Sek := trunc((Wartezeit - Min*60*1000)/1000);
    if Sek < 10 then SekNull := '0'
    else SekNull := '';
    lblStatus.Caption := 'Wartezeit: '+ inttostr(Min) + ':' + SekNull +inttostr(Sek) + ' Min';
    Application.ProcessMessages;
  end;
end;

procedure TForm1.lblStartStopClick(Sender: TObject);
begin
  if lblStartStop.Caption = 'starten' then
    begin

      if lblHandel.Caption = 'Handelstool aus' then lblHandelClick(Sender);
      lblHandel.Enabled := false;
      Zustand := 13;
      Debug := false;
      Wiederholung := 0;
      Speed := 3000;
      HandelZaehler := 0;
      Fehler := 0;
      stop := false;
      Schiff.Index := 0;
      Schiff.StopIndex := 0;
      Schiff.RessEingeladen := false;
      LauftextZaehler := 1;
      Timer1.Interval := Speed;
      lblStartStop.Caption := 'stoppen';

    end
  else
    begin
      Timer1.Interval := 0;
      Timer2.Interval := 0;
      lblHandel.Enabled := true;
      lblStartStop.Caption := 'starten';
    end;
end;

procedure TForm1.lblBeendenClick(Sender: TObject);
begin
  IO.safeLog(Form1.ListBox1);
  close();
end;

procedure TForm1.CheckboxClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then AnzeigeCode := AnzeigeCode + TCheckBox(Sender).Hint
  else Delete(AnzeigeCode, Pos(TCheckBox(Sender).Hint, AnzeigeCode), length(TCheckBox(Sender).Hint));
  showTabelle(AnzeigeCode);
end;

procedure TForm1.lblHandelClick(Sender: TObject);
var i, width: Integer;
begin
  if lblHandel.Caption = 'Handelstool an' then
  begin
    lblHandel.Caption := 'Handelstool aus';
    Form1.lblInfo.Visible := false;
    Form1.lblRess.Visible := false;
    Form1.lblStatus.Visible := false;
    Form1.Height := 175;
    Form1.Image2.Height := 175;
    Form1.Image2.Picture.LoadFromFile('background2.bmp');

    stgTabelle.ColWidths[0] := Button1.Width-1;
    stgTabelle.ColWidths[1] := Button2.Width-2;
    stgTabelle.ColWidths[2] := Button3.Width-2;
    stgTabelle.ColWidths[3] := Button4.Width-2;
    stgTabelle.ColWidths[4] := Button7.Width-2;
//    stgTabelle.ColWidths[5] := Button5.Width-2;
//    stgTabelle.ColWidths[6] := Button6.Width-2;
  width := 0;
  for i := 0 to 4 do
    width := width + stgTabelle.ColWidths[i];

  stgTabelle.ScrollBars := ssNone;
  stgTabelle.Left := 1;
  stgTabelle.Width := width + 6;
  Panel2.Left := 25;
  Panel2.Width := width+5;
  shape1.Left := Panel2.Left-1;
  shape1.Top := panel2.Top-1;
  shape1.Width := panel2.width+2;
  shape1.Height := panel2.Height+2;
  shape1.Pen.Color := rgb(65,66,88);



    Panel2.Visible := true;
    Shape1.Visible := true;

    lblTabelleInfo.Visible := true;
//    mmoDaten.Visible := true;


  AnzeigeCode := 'EnergieRekrutenErzorg. Verbindungensynth. VerbindungenEisenmetalleLeichtmetalleSchwermetalleEdelmetalleradioaktive StoffeEdelsteineEdelgaseinstabile Isotope';

  with stgTabelle do
  begin
    RowCount := 1;
    ColCount := 5;
    FixedRows := 0;
    FixedCols := 0;
  end;

  end
  else
  begin

    Panel2.Visible := false;
    mmoDaten.Visible := false;
    lblTabelleInfo.Visible := false;
    Shape1.Visible := false;

    lblHandel.Caption := 'Handelstool an';
    Form1.lblInfo.Visible := true;
    Form1.lblRess.Visible := true;
    Form1.lblStatus.Visible := true;
    Form1.Height := 71;
    Form1.Image2.Height := 71;
    Form1.Image2.Picture.LoadFromFile('background.bmp');
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  sortList(0, Form1.TabCount-1,'Ressource');
//  showTabelle(AnzeigeCode);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
//  sortList(0, Form1.TabCount-1,'Menge');
//  showTabelle(AnzeigeCode);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
//  sortList(0, Form1.TabCount-1,'Preis');
//  showTabelle(AnzeigeCode);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
//  sortList(0, Form1.TabCount-1,'Venad');
//  showTabelle(AnzeigeCode);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
//  sortList(0, Form1.TabCount-1,'Clan');
//  showTabelle(AnzeigeCode);
end;

procedure TForm1.Label2Click(Sender: TObject);
var i: Integer;
begin
  Zustand := 13;
  Timer1.Interval := Speed;
end;

procedure TForm1.CheckBox14Click(Sender: TObject);
begin
  if CheckBox14.Checked then
  begin
    CheckBox1.Checked := true;
    CheckBox2.Checked := true;
    CheckBox3.Checked := true;
    CheckBox4.Checked := true;
    CheckBox5.Checked := true;
    CheckBox6.Checked := true;
    CheckBox7.Checked := true;
    CheckBox8.Checked := true;
    CheckBox9.Checked := true;
    CheckBox10.Checked := true;
    CheckBox11.Checked := true;
    CheckBox12.Checked := true;
    CheckBox13.Checked := true;
  end
  else
  begin
    CheckBox1.Checked := false;
    CheckBox2.Checked := false;
    CheckBox3.Checked := false;
    CheckBox4.Checked := false;
    CheckBox5.Checked := false;
    CheckBox6.Checked := false;
    CheckBox7.Checked := false;
    CheckBox8.Checked := false;
    CheckBox9.Checked := false;
    CheckBox10.Checked := false;
    CheckBox11.Checked := false;
    CheckBox12.Checked := false;
    CheckBox13.Checked := false;
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var Lauftext, Space: String;
    i : Integer;
begin

  if LauftextZaehler <= length(InfoText)  then
  begin
    lauftext := copy(InfoText,LauftextZaehler,MaxLength);
  end
  else
  begin
    LauftextZaehler := 0;
  end;
  lblRess.Caption := Lauftext;

  LauftextZaehler := LauftextZaehler + 1;
end;

end.
