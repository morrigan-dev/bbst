{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
{
   Diese Klasse erstellt ein Panel mit sechs Reglern, die einen Wertebereich von 0 bis 100 haben.
   Über diese Regler werden die jeweiligen Servo Variablen der Roboterarm Klasse gesetzt.

   ~author Th. Gattinger
}
unit unitRegler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, unitRoboterarmPanel, unitRoboterarmModel, unitIObserver, unitEinzelteile;

type
  TfrmReglerPanel = class(TForm, IObserver)
    gboxServoEinstellungen: TGroupBox;
    lblServo0: TLabel;
    lblServo0Position: TLabel;
    lblServo12: TLabel;
    lblServo12Position: TLabel;
    lblServo3: TLabel;
    lblServo3Position: TLabel;
    lblServo4: TLabel;
    lblServo4Position: TLabel;
    lblServo5: TLabel;
    lblServo5Position: TLabel;
    lblServo6: TLabel;
    lblServo6Position: TLabel;
    tbarServo0: TTrackBar;
    tbarServo12: TTrackBar;
    tbarServo3: TTrackBar;
    tbarServo4: TTrackBar;
    tbarServo5: TTrackBar;
    tbarServo6: TTrackBar;
    gboxEntwicklungseinstellungen: TGroupBox;
    gboxMinMaxGrad: TGroupBox;
    lblServo0Grad: TLabel;
    lblMinimalerGradwert: TLabel;
    lblMaximalerGradwert: TLabel;
    edtServo0MinGrad: TEdit;
    edtServo0MaxGrad: TEdit;
    lblBis0: TLabel;
    edtServo12MaxGrad: TEdit;
    lblBis12: TLabel;
    edtServo12MinGrad: TEdit;
    lblServo12Grad: TLabel;
    edtServo3MaxGrad: TEdit;
    lblBis3: TLabel;
    edtServo3MinGrad: TEdit;
    lblServo3Grad: TLabel;
    edtServo4MaxGrad: TEdit;
    lblBis4: TLabel;
    edtServo4MinGrad: TEdit;
    lblServo4Grad: TLabel;
    edtServo5MaxGrad: TEdit;
    lblBis5: TLabel;
    edtServo5MinGrad: TEdit;
    lblServo5Grad: TLabel;
    edtServo6MaxGrad: TEdit;
    lblBis6: TLabel;
    edtServo6MinGrad: TEdit;
    lblServo6Grad: TLabel;
    cbStyle: TComboBox;
    btnDemo: TButton;
    tmMoveDelay: TTimer;
    lblAnsicht: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edtWidth: TEdit;
    Label3: TLabel;
    edtHeight: TEdit;
    Label4: TLabel;
    edtDepth: TEdit;
    cbElement: TComboBox;
    cbLogLevel: TComboBox;
    Label1: TLabel;
    RoboterarmPanel1: TRoboterarmPanel;

    // Diese Prozedur wird sofort nach der Erstellung der TForm Instanz aufgerufen
    procedure FormCreate(Sender: TObject);

    // Die folgenden Prozeduren werden bei jeder Änderung des jeweiligen Reglers aufgerufen
    // und übergeben den neuen Wert an den Roboterarm
    procedure tbarServo0Change(Sender: TObject);
    procedure tbarServo12Change(Sender: TObject);
    procedure tbarServo3Change(Sender: TObject);
    procedure tbarServo4Change(Sender: TObject);
    procedure tbarServo5Change(Sender: TObject);
    procedure tbarServo6Change(Sender: TObject);
    procedure edtServo0MinGradChange(Sender: TObject);
    procedure edtServo12MinGradChange(Sender: TObject);
    procedure edtServo3MinGradChange(Sender: TObject);
    procedure edtServo4MinGradChange(Sender: TObject);
    procedure edtServo5MinGradChange(Sender: TObject);
    procedure edtServo6MinGradChange(Sender: TObject);
    procedure edtServo0MaxGradChange(Sender: TObject);
    procedure edtServo12MaxGradChange(Sender: TObject);
    procedure edtServo3MaxGradChange(Sender: TObject);
    procedure edtServo4MaxGradChange(Sender: TObject);
    procedure edtServo5MaxGradChange(Sender: TObject);
    procedure edtServo6MaxGradChange(Sender: TObject);
    procedure tbarServo0Enter(Sender: TObject);
    procedure tbarServo0Exit(Sender: TObject);
    procedure tbarServo12Enter(Sender: TObject);
    procedure tbarServo12Exit(Sender: TObject);
    procedure tbarServo3Enter(Sender: TObject);
    procedure tbarServo3Exit(Sender: TObject);
    procedure tbarServo4Enter(Sender: TObject);
    procedure tbarServo4Exit(Sender: TObject);
    procedure tbarServo5Enter(Sender: TObject);
    procedure tbarServo5Exit(Sender: TObject);
    procedure tbarServo6Enter(Sender: TObject);
    procedure tbarServo6Exit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbStyleChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btnDemoClick(Sender: TObject);
    procedure tmMoveDelayTimer(Sender: TObject);
    procedure cbElementChange(Sender: TObject);
    procedure edtWidthExit(Sender: TObject);
    procedure edtHeightExit(Sender: TObject);
    procedure edtDepthExit(Sender: TObject);
    procedure cbLogLevelChange(Sender: TObject);

  private { Private declarations }
    roboarmModel : TRoboterarmModel;

    function bewegeServo() : Boolean;

  public { Public declarations }
    procedure updateView();

  end;

var
  frmReglerPanel: TfrmReglerPanel;
  phase         : Integer;
  phaseFinished : Boolean;
  ServoNummer   : Integer;
  ServoZielPos  : Integer;

implementation

{$R *.dfm}

function TfrmReglerPanel.bewegeServo() : Boolean;
begin
  result := false;

  case ServoNummer of
    SERVO_0:
    begin
      if(RoboterarmPanel1.Servo0.AktPos = ServoZielPos) then
        result := true;

      if(RoboterarmPanel1.Servo0.AktPos < ServoZielPos) then
        RoboterarmPanel1.Servo0.AktPos := RoboterarmPanel1.Servo0.AktPos + 1;

      if(RoboterarmPanel1.Servo0.AktPos > ServoZielPos) then
        RoboterarmPanel1.Servo0.AktPos := RoboterarmPanel1.Servo0.AktPos - 1;
    end;

    SERVO_12:
    begin
      if(RoboterarmPanel1.Servo12.AktPos = ServoZielPos) then
        result := true;

      if(RoboterarmPanel1.Servo12.AktPos < ServoZielPos) then
        RoboterarmPanel1.Servo12.AktPos := RoboterarmPanel1.Servo12.AktPos + 1;

      if(RoboterarmPanel1.Servo12.AktPos > ServoZielPos) then
        RoboterarmPanel1.Servo12.AktPos := RoboterarmPanel1.Servo12.AktPos - 1;
    end;

    SERVO_3:
    begin
      if(RoboterarmPanel1.Servo3.AktPos = ServoZielPos) then
        result := true;

      if(RoboterarmPanel1.Servo3.AktPos < ServoZielPos) then
        RoboterarmPanel1.Servo3.AktPos := RoboterarmPanel1.Servo3.AktPos + 1;

      if(RoboterarmPanel1.Servo3.AktPos > ServoZielPos) then
        RoboterarmPanel1.Servo3.AktPos := RoboterarmPanel1.Servo3.AktPos - 1;
    end;

    SERVO_4:
    begin
      if(RoboterarmPanel1.Servo4.AktPos = ServoZielPos) then
        result := true;

      if(RoboterarmPanel1.Servo4.AktPos < ServoZielPos) then
        RoboterarmPanel1.Servo4.AktPos := RoboterarmPanel1.Servo4.AktPos + 1;

      if(RoboterarmPanel1.Servo4.AktPos > ServoZielPos) then
        RoboterarmPanel1.Servo4.AktPos := RoboterarmPanel1.Servo4.AktPos - 1;
    end;

    SERVO_5:
    begin
      if(RoboterarmPanel1.Servo5.AktPos = ServoZielPos) then
        result := true;

      if(RoboterarmPanel1.Servo5.AktPos < ServoZielPos) then
        RoboterarmPanel1.Servo5.AktPos := RoboterarmPanel1.Servo5.AktPos + 1;

      if(RoboterarmPanel1.Servo5.AktPos > ServoZielPos) then
        RoboterarmPanel1.Servo5.AktPos := RoboterarmPanel1.Servo5.AktPos - 1;
    end;

    SERVO_6:
    begin
      if(RoboterarmPanel1.Servo6.AktPos = ServoZielPos) then
        result := true;

      if(RoboterarmPanel1.Servo6.AktPos < ServoZielPos) then
        RoboterarmPanel1.Servo6.AktPos := RoboterarmPanel1.Servo6.AktPos + 1;

      if(RoboterarmPanel1.Servo6.AktPos > ServoZielPos) then
        RoboterarmPanel1.Servo6.AktPos := RoboterarmPanel1.Servo6.AktPos - 1;
    end;
  end;
end;

procedure TfrmReglerPanel.tmMoveDelayTimer(Sender: TObject);
const phasen : Array[0..16] of Array[0..1] of Integer =
               ((SERVO_3, 15), (SERVO_6, 0), (SERVO_0, 100), (SERVO_12, 15), (SERVO_4, 7), (SERVO_5, 100),
                (SERVO_6, 40), (SERVO_12, 55), (SERVO_0, 0), (SERVO_12, 15),(SERVO_6, 0),
                // Zurück in die Parkposition
                (SERVO_12, 100), (SERVO_0, 50), (SERVO_4, 10), (SERVO_5, 50), (SERVO_6, 50), (SERVO_3, 100));
begin
  if(phase = 17) then
  begin
    tmMoveDelay.Interval := 30;
    phase := 0;
  end;

  ServoNummer := phasen[phase][0];
  ServoZielPos := phasen[phase][1];
  phaseFinished := false;
  if(bewegeServo() = true) then
    phase := phase + 1;

  if(phase = 17) then
  begin
    tmMoveDelay.Interval := 2000;
  end;
end;

procedure TfrmReglerPanel.updateView();
begin
  if(roboarmModel.GetSkin() = SimpleGrid) then
    cbStyle.ItemIndex := 0
  else if (roboarmModel.GetSkin() = SimpleFull) then
    cbStyle.ItemIndex := 1
  else if (roboarmModel.GetSkin() = DetailedGrid) then
    cbStyle.ItemIndex := 2
  else
    cbStyle.ItemIndex := 3;

  // Aktualisiere Regler
  tbarServo0.Position := trunc(RoboterarmPanel1.Servo0.AktPos);
  tbarServo12.Position := trunc(RoboterarmPanel1.Servo12.AktPos);
  tbarServo3.Position := trunc(RoboterarmPanel1.Servo3.AktPos);
  tbarServo4.Position := trunc(RoboterarmPanel1.Servo4.AktPos);
  tbarServo5.Position := trunc(RoboterarmPanel1.Servo5.AktPos);
  tbarServo6.Position := trunc(RoboterarmPanel1.Servo6.AktPos);

  // Aktualisiere minimale Gradwerte
  edtServo0MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo0.MinGrad);
  edtServo12MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo12.MinGrad);
  edtServo3MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo3.MinGrad);
  edtServo4MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo4.MinGrad);
  edtServo5MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo5.MinGrad);
  edtServo6MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo6.MinGrad);

  // Aktualisiere maximale Gradwerte
  edtServo0MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo0.MaxGrad);
  edtServo12MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo12.MaxGrad);
  edtServo3MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo3.MaxGrad);
  edtServo4MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo4.MaxGrad);
  edtServo5MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo5.MaxGrad);
  edtServo6MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo6.MaxGrad);
end;

procedure TfrmReglerPanel.FormCreate(Sender: TObject);
begin

  roboarmModel := RoboterarmPanel1.GetModel();
  roboarmModel.addObserver(Self);
  roboarmModel.SetVerticalOffset(20);
  RoboterarmPanel1.Servo12.AktPos := 100;
  RoboterarmPanel1.Servo3.AktPos := 100;
  RoboterarmPanel1.Servo4.AktPos := 10;
  updateView();
end;

procedure TfrmReglerPanel.tbarServo0Change(Sender: TObject);
begin
  lblServo0Position.Caption := IntToStr(tbarServo0.Position) + ' %';
  RoboterarmPanel1.Servo0.AktPos := tbarServo0.Position;
end;

procedure TfrmReglerPanel.tbarServo12Change(Sender: TObject);
begin
  lblServo12Position.Caption := IntToStr(tbarServo12.Position) + ' %';
  RoboterarmPanel1.Servo12.AktPos := tbarServo12.Position;
end;

procedure TfrmReglerPanel.tbarServo3Change(Sender: TObject);
begin
  lblServo3Position.Caption := IntToStr(tbarServo3.Position) + ' %';
  RoboterarmPanel1.Servo3.AktPos := tbarServo3.Position;
end;

procedure TfrmReglerPanel.tbarServo4Change(Sender: TObject);
begin
  lblServo4Position.Caption := IntToStr(tbarServo4.Position) + ' %';
  RoboterarmPanel1.Servo4.AktPos := tbarServo4.Position;
end;

procedure TfrmReglerPanel.tbarServo5Change(Sender: TObject);
begin
  lblServo5Position.Caption := IntToStr(tbarServo5.Position) + ' %';
  RoboterarmPanel1.Servo5.AktPos := tbarServo5.Position;
end;

procedure TfrmReglerPanel.tbarServo6Change(Sender: TObject);
begin
  lblServo6Position.Caption := IntToStr(tbarServo6.Position) + ' %';
  RoboterarmPanel1.Servo6.AktPos := tbarServo6.Position;
end;

procedure TfrmReglerPanel.edtServo0MinGradChange(Sender: TObject);
begin
  if(edtServo0MinGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo0.MinGrad := StrToFloat(edtServo0MinGrad.Text);
  end;
end;

procedure TfrmReglerPanel.edtServo12MinGradChange(Sender: TObject);
begin
  if(edtServo12MinGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo12.MinGrad := StrToFloat(edtServo12MinGrad.Text);
  end;
end;

procedure TfrmReglerPanel.edtServo3MinGradChange(Sender: TObject);
begin
  if(edtServo3MinGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo3.MinGrad := (StrToFloat(edtServo3MinGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo4MinGradChange(Sender: TObject);
begin
  if(edtServo4MinGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo4.MinGrad := (StrToFloat(edtServo4MinGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo5MinGradChange(Sender: TObject);
begin
  if(edtServo5MinGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo5.MinGrad := (StrToFloat(edtServo5MinGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo6MinGradChange(Sender: TObject);
begin
  if(edtServo6MinGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo6.MinGrad := (StrToFloat(edtServo6MinGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo0MaxGradChange(Sender: TObject);
begin
  if(edtServo0MaxGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo0.MaxGrad := (StrToFloat(edtServo0MaxGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo12MaxGradChange(Sender: TObject);
begin
  if(edtServo12MaxGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo12.MaxGrad := (StrToFloat(edtServo12MaxGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo3MaxGradChange(Sender: TObject);
begin
  if(edtServo3MaxGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo3.MaxGrad := (StrToFloat(edtServo3MaxGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo4MaxGradChange(Sender: TObject);
begin
  if(edtServo4MaxGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo4.MaxGrad := (StrToFloat(edtServo4MaxGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo5MaxGradChange(Sender: TObject);
begin
  if(edtServo5MaxGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo5.MaxGrad := (StrToFloat(edtServo5MaxGrad.Text));
  end;
end;

procedure TfrmReglerPanel.edtServo6MaxGradChange(Sender: TObject);
begin
  if(edtServo6MaxGrad.Text <> '') then
  begin
    RoboterarmPanel1.Servo6.MaxGrad := (StrToFloat(edtServo6MaxGrad.Text));
  end;
end;

procedure TfrmReglerPanel.tbarServo0Enter(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(SERVO_0);
end;

procedure TfrmReglerPanel.tbarServo0Exit(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(NICHTS);
end;

procedure TfrmReglerPanel.tbarServo12Enter(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(SERVO_12);
end;

procedure TfrmReglerPanel.tbarServo12Exit(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(NICHTS);
end;

procedure TfrmReglerPanel.tbarServo3Enter(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(SERVO_3);
end;

procedure TfrmReglerPanel.tbarServo3Exit(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(NICHTS);
end;

procedure TfrmReglerPanel.tbarServo4Enter(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(SERVO_4);
end;

procedure TfrmReglerPanel.tbarServo4Exit(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(NICHTS);
end;

procedure TfrmReglerPanel.tbarServo5Enter(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(SERVO_5);
end;

procedure TfrmReglerPanel.tbarServo5Exit(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(NICHTS);
end;

procedure TfrmReglerPanel.tbarServo6Enter(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(SERVO_6);
end;

procedure TfrmReglerPanel.tbarServo6Exit(Sender: TObject);
begin
  roboarmModel.SetSelectedServo(NICHTS);
end;

procedure TfrmReglerPanel.FormDestroy(Sender: TObject);
begin
  RoboterarmPanel1.destroyOGL();
end;

procedure TfrmReglerPanel.cbStyleChange(Sender: TObject);
begin
  if(cbStyle.ItemIndex = 0) then
    roboarmModel.ShowSkin(SimpleGrid);

  if(cbStyle.ItemIndex = 1) then
    roboarmModel.ShowSkin(SimpleFull);

  if(cbStyle.ItemIndex = 2) then
    roboarmModel.ShowSkin(DetailedGrid);

  if(cbStyle.ItemIndex = 3) then
    roboarmModel.ShowSkin(DetailedFull);
end;

procedure TfrmReglerPanel.FormPaint(Sender: TObject);
begin
  RoboterarmPanel1.Render();
end;

procedure TfrmReglerPanel.btnDemoClick(Sender: TObject);
begin
  if (tmMoveDelay.Interval = 0) then
  begin
    phase := 0;
    tmMoveDelay.Interval := 30;
    btnDemo.Caption := 'Demo sto&ppen'
  end
  else
  begin
    tmMoveDelay.Interval := 0;
    btnDemo.Caption := 'Demo &starten';
    RoboterarmPanel1.Servo0.AktPos := 50;
    RoboterarmPanel1.Servo12.AktPos := 100;
    RoboterarmPanel1.Servo3.AktPos := 100;
    RoboterarmPanel1.Servo4.AktPos := 10;
    RoboterarmPanel1.Servo5.AktPos := 50;
    RoboterarmPanel1.Servo6.AktPos := 50;
  end;
end;

procedure TfrmReglerPanel.cbElementChange(Sender: TObject);
var width, height, depth : Real;
begin

  case cbElement.ItemIndex of
    0 : // Element 0
    begin
      width := RoboterarmPanel1.Element0.Width;
      height := RoboterarmPanel1.Element0.Height;
      depth := RoboterarmPanel1.Element0.Depth;
    end;
    1 : // Element 1
    begin
      width := RoboterarmPanel1.Element1.Width;
      height := RoboterarmPanel1.Element1.Height;
      depth := RoboterarmPanel1.Element1.Depth;
    end;
    2: // Element 2
    begin
      width := RoboterarmPanel1.Element2.Width;
      height := RoboterarmPanel1.Element2.Height;
      depth := RoboterarmPanel1.Element2.Depth;
    end;
    3 : // Element 3
    begin
      width := RoboterarmPanel1.Element3.Width;
      height := RoboterarmPanel1.Element3.Height;
      depth := RoboterarmPanel1.Element3.Depth;
    end;
    4 : // Element 4
    begin
      width := RoboterarmPanel1.Element4.Width;
      height := RoboterarmPanel1.Element4.Height;
      depth := RoboterarmPanel1.Element4.Depth;
    end;
    5 : // Servo 0
    begin
      width := RoboterarmPanel1.Servo0.Width;
      height := RoboterarmPanel1.Servo0.Height;
      depth := RoboterarmPanel1.Servo0.Depth;
    end;
    6 : // Servo 12
    begin
      width := RoboterarmPanel1.Servo12.Width;
      height := RoboterarmPanel1.Servo12.Height;
      depth := RoboterarmPanel1.Servo12.Depth;
    end;
    7 : // Servo 3
    begin
      width := RoboterarmPanel1.Servo3.Width;
      height := RoboterarmPanel1.Servo3.Height;
      depth := RoboterarmPanel1.Servo3.Depth;
    end;
    8 : // Servo 4
    begin
      width := RoboterarmPanel1.Servo4.Width;
      height := RoboterarmPanel1.Servo4.Height;
      depth := RoboterarmPanel1.Servo4.Depth;
    end;
    9 : // Servo 5
    begin
      width := RoboterarmPanel1.Servo5.Width;
      height := RoboterarmPanel1.Servo5.Height;
      depth := RoboterarmPanel1.Servo5.Depth;
    end;
    10 : // Servo 6
    begin
      width := RoboterarmPanel1.Servo6.Width;
      height := RoboterarmPanel1.Servo6.Height;
      depth := RoboterarmPanel1.Servo6.Depth;
    end;
  end;

  edtWidth.Text := floattostr(width);
  edtHeight.Text := floattostr(height);
  edtDepth.Text := floattostr(depth);
end;

procedure TfrmReglerPanel.edtWidthExit(Sender: TObject);
var width : Real;
begin
  width := strtofloat(edtWidth.Text);

  case cbElement.ItemIndex of
    0 : // Element 0
      RoboterarmPanel1.Element0.Width := width;
    1 : // Element 1
      RoboterarmPanel1.Element1.Width := width;
    2: // Element 2
      RoboterarmPanel1.Element2.Width := width;
    3 : // Element 3
      RoboterarmPanel1.Element3.Width := width;
    4 : // Element 4
      RoboterarmPanel1.Element4.Width := width;
    5 : // Servo 0
      RoboterarmPanel1.Servo0.Width := width;
    6 : // Servo 12
      RoboterarmPanel1.Servo12.Width := width;
    7 : // Servo 3
      RoboterarmPanel1.Servo3.Width := width;
    8 : // Servo 4
      RoboterarmPanel1.Servo4.Width := width;
    9 : // Servo 5
      RoboterarmPanel1.Servo5.Width := width;
    10 : // Servo 6
      RoboterarmPanel1.Servo6.Width := width;
  end;
end;

procedure TfrmReglerPanel.edtHeightExit(Sender: TObject);
var height : Real;
begin
  height := strtofloat(edtHeight.Text);

  case cbElement.ItemIndex of
    0 : // Element 0
      RoboterarmPanel1.Element0.height := height;
    1 : // Element 1
      RoboterarmPanel1.Element1.height := height;
    2: // Element 2
      RoboterarmPanel1.Element2.height := height;
    3 : // Element 3
      RoboterarmPanel1.Element3.height := height;
    4 : // Element 4
      RoboterarmPanel1.Element4.height := height;
    5 : // Servo 0
      RoboterarmPanel1.Servo0.height := height;
    6 : // Servo 12
      RoboterarmPanel1.Servo12.height := height;
    7 : // Servo 3
      RoboterarmPanel1.Servo3.height := height;
    8 : // Servo 4
      RoboterarmPanel1.Servo4.height := height;
    9 : // Servo 5
      RoboterarmPanel1.Servo5.height := height;
    10 : // Servo 6
      RoboterarmPanel1.Servo6.height := height;
  end;
end;

procedure TfrmReglerPanel.edtDepthExit(Sender: TObject);
var depth : Real;
begin
  depth := strtofloat(edtDepth.Text);

  case cbElement.ItemIndex of
    0 : // Element 0
      RoboterarmPanel1.Element0.depth := depth;
    1 : // Element 1
      RoboterarmPanel1.Element1.depth := depth;
    2: // Element 2
      RoboterarmPanel1.Element2.depth := depth;
    3 : // Element 3
      RoboterarmPanel1.Element3.depth := depth;
    4 : // Element 4
      RoboterarmPanel1.Element4.depth := depth;
    5 : // Servo 0
      RoboterarmPanel1.Servo0.depth := depth;
    6 : // Servo 12
      RoboterarmPanel1.Servo12.depth := depth;
    7 : // Servo 3
      RoboterarmPanel1.Servo3.depth := depth;
    8 : // Servo 4
      RoboterarmPanel1.Servo4.depth := depth;
    9 : // Servo 5
      RoboterarmPanel1.Servo5.depth := depth;
    10 : // Servo 6
      RoboterarmPanel1.Servo6.depth := depth;
  end;
end;

procedure TfrmReglerPanel.cbLogLevelChange(Sender: TObject);
begin
//  RoboterarmPanel1.LoggerLevel := cbLogLevel.Text;
end;

end.
