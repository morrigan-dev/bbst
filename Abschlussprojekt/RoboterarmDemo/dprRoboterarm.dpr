program dprRoboterarm;

uses
  Forms,
  unitRegler in 'unitRegler.pas' {frmReglerPanel},
  //unitRoboterarm in 'unitRoboterarm.pas' {frmRoboterarm},
  unitRoboterarmPanel in 'unitRoboterarmPanel.pas',
  unitServo in 'unitServo.pas',
  unitIOpenGL in 'unitIOpenGL.pas',
  unitElement in 'unitElement.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Roboterarm Simulation';
  Application.CreateForm(TfrmReglerPanel, frmReglerPanel);
  Application.Run;
end.
