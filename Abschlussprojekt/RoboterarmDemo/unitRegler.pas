{
 **********************************************************************************************************************
 * KLASSE : unitRegler
 *---------------------------------------------------------------------------------------------------------------------
 * Version   : 1.0
 * Autor     : Th.Rittinger, F. Nickol, Th. Gattinger
 * Datei     : unitRegler.pas
 *
 * Aufgabe   : Diese Klasse erstellt ein Panel mit sechs Reglern, die einen Wertebereich von 0 bis 100 haben.
 *             Über diese Regler werden die jeweiligen Servo Variablen der Roboterarm Klasse gesetzt.
 *
 * Compiler  : Delphi 7.0
 * Aenderung : 17.04.2010
 **********************************************************************************************************************
}
unit unitRegler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, unitRoboterarmPanel, Spin; //unitRoboterarm;

type
  TfrmReglerPanel = class(TForm)
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
    chkShowGeoMittelpunkt: TCheckBox;
    chkShowKoordinatensystem: TCheckBox;
    chkShowRotationsmarkierung: TCheckBox;
    chkDeaktiviereTexturen: TCheckBox;
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
    Timer1: TTimer;
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
    procedure chkShowKoordinatensystemClick(Sender: TObject);
    procedure chkShowGeoMittelpunktClick(Sender: TObject);
    procedure chkShowRotationsmarkierungClick(Sender: TObject);
    procedure chkDeaktiviereTexturenClick(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private { Private declarations }

  public { Public declarations }

  end;

var
  frmReglerPanel: TfrmReglerPanel;

implementation

{$R *.dfm}

procedure TfrmReglerPanel.FormCreate(Sender: TObject);
begin

  // Initialisiere Checkboxen
  chkShowKoordinatensystem.Checked   := False;
  chkShowGeoMittelpunkt.Checked      := False;
  chkShowRotationsmarkierung.Checked := False;
  chkDeaktiviereTexturen.Checked     := False;

  RoboterarmPanel1.SetShowKoordinatensystem(False);
  RoboterarmPanel1.SetShowObjektMittelpunkt(False);
  RoboterarmPanel1.SetShowRotationsmarkierung(False);
  RoboterarmPanel1.SetShowTexturen(True);

  // Initialisiere Regler
  tbarServo0.Position := trunc(RoboterarmPanel1.Servo0.AktPos);
  tbarServo12.Position := trunc(RoboterarmPanel1.Servo12.AktPos);
  tbarServo3.Position := trunc(RoboterarmPanel1.Servo3.AktPos);
  tbarServo4.Position := trunc(RoboterarmPanel1.Servo4.AktPos);
  tbarServo5.Position := trunc(RoboterarmPanel1.Servo5.AktPos);
  tbarServo6.Position := trunc(RoboterarmPanel1.Servo6.AktPos);

  // Initialisiere minimale Gradwerte
  edtServo0MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo0.MinGrad);
  edtServo12MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo12.MinGrad);
  edtServo3MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo3.MinGrad);
  edtServo4MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo4.MinGrad);
  edtServo5MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo5.MinGrad);
  edtServo6MinGrad.Text := FloatToStr(RoboterarmPanel1.Servo6.MinGrad);

  // Initialisiere maximale Gradwerte
  edtServo0MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo0.MaxGrad);
  edtServo12MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo12.MaxGrad);
  edtServo3MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo3.MaxGrad);
  edtServo4MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo4.MaxGrad);
  edtServo5MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo5.MaxGrad);
  edtServo6MaxGrad.Text := FloatToStr(RoboterarmPanel1.Servo6.MaxGrad);

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
  RoboterarmPanel1.Servo7.AktPos := tbarServo6.Position;
end;

procedure TfrmReglerPanel.chkShowKoordinatensystemClick(Sender: TObject);
begin
  RoboterarmPanel1.SetShowKoordinatensystem(chkShowKoordinatensystem.Checked);
end;

procedure TfrmReglerPanel.chkShowGeoMittelpunktClick(Sender: TObject);
begin
  RoboterarmPanel1.SetShowObjektMittelpunkt(chkShowGeoMittelpunkt.Checked);
end;

procedure TfrmReglerPanel.chkShowRotationsmarkierungClick(Sender: TObject);
begin
  RoboterarmPanel1.SetShowRotationsmarkierung(chkShowRotationsmarkierung.Checked);
end;

procedure TfrmReglerPanel.chkDeaktiviereTexturenClick(Sender: TObject);
begin
  RoboterarmPanel1.SetShowTexturen(not chkDeaktiviereTexturen.Checked);
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
    RoboterarmPanel1.Servo7.MinGrad := (StrToFloat(edtServo6MinGrad.Text));
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
    RoboterarmPanel1.Servo7.MaxGrad := (StrToFloat(edtServo6MaxGrad.Text));
  end;
end;

procedure TfrmReglerPanel.tbarServo0Enter(Sender: TObject);
begin
  RoboterarmPanel1.Servo0.SetHighlighted(True);
end;

procedure TfrmReglerPanel.tbarServo0Exit(Sender: TObject);
begin
  RoboterarmPanel1.Servo0.SetHighlighted(False);
end;

procedure TfrmReglerPanel.tbarServo12Enter(Sender: TObject);
begin
  RoboterarmPanel1.Servo12.SetHighlighted(True);
end;

procedure TfrmReglerPanel.tbarServo12Exit(Sender: TObject);
begin
  RoboterarmPanel1.Servo12.SetHighlighted(False);
end;

procedure TfrmReglerPanel.tbarServo3Enter(Sender: TObject);
begin
  RoboterarmPanel1.Servo3.SetHighlighted(True);
end;

procedure TfrmReglerPanel.tbarServo3Exit(Sender: TObject);
begin
  RoboterarmPanel1.Servo3.SetHighlighted(False);
end;

procedure TfrmReglerPanel.tbarServo4Enter(Sender: TObject);
begin
  RoboterarmPanel1.Servo4.SetHighlighted(True);
end;

procedure TfrmReglerPanel.tbarServo4Exit(Sender: TObject);
begin
  RoboterarmPanel1.Servo4.SetHighlighted(False);
end;

procedure TfrmReglerPanel.tbarServo5Enter(Sender: TObject);
begin
  RoboterarmPanel1.Servo5.SetHighlighted(True);
end;

procedure TfrmReglerPanel.tbarServo5Exit(Sender: TObject);
begin
  RoboterarmPanel1.Servo5.SetHighlighted(False);
end;

procedure TfrmReglerPanel.tbarServo6Enter(Sender: TObject);
begin
  RoboterarmPanel1.Servo6.SetHighlighted(True);
  RoboterarmPanel1.Servo7.SetHighlighted(True);
end;

procedure TfrmReglerPanel.tbarServo6Exit(Sender: TObject);
begin
  RoboterarmPanel1.Servo6.SetHighlighted(False);
  RoboterarmPanel1.Servo7.SetHighlighted(False);
end;

procedure TfrmReglerPanel.FormDestroy(Sender: TObject);
begin
  RoboterarmPanel1.destroyOGL();
end;

procedure TfrmReglerPanel.FormShow(Sender: TObject);
begin
  // TODO: Das RoboterarmPanel sollte selbst erkennen, wann es resized wird!
  // Bisher muss von Außerhalb dem panel gesagt werden, dass es sich resizen soll.
  RoboterarmPanel1.RoboterarmResize(Self);
end;

procedure TfrmReglerPanel.FormResize(Sender: TObject);
begin
  RoboterarmPanel1.Width := ClientWidth - RoboterarmPanel1.Left - 5;
  RoboterarmPanel1.Height := ClientHeight - RoboterarmPanel1.Top - 5;
end;

procedure TfrmReglerPanel.Timer1Timer(Sender: TObject);
begin
  RoboterarmPanel1.Render();
end;

end.
