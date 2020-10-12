{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
program dprRoboterarm;

uses
  Forms,
  unitRegler in 'unitRegler.pas' {frmReglerPanel},
  unitRoboterarmPanel in 'unitRoboterarmPanel.pas',
  unitServoProperty in 'unitServoProperty.pas',
  unitIOpenGL in 'unitIOpenGL.pas',
  unitElementProperty in 'unitElementProperty.pas',
  unitRoboterarmModel in 'unitRoboterarmModel.pas',
  unitIObserver in 'unitIObserver.pas',
  unitIObserverable in 'unitIObserverable.pas',
  unitObserverableImpl in 'unitObserverableImpl.pas',
  unitElement0 in 'unitElement0.pas',
  unitAbstractElement in 'unitAbstractElement.pas',
  unitServo0 in 'unitServo0.pas',
  unitElementModel in 'unitElementModel.pas',
  unitServoModel in 'unitServoModel.pas',
  unitAbstractServo in 'unitAbstractServo.pas',
  unitOpenGLConfigUtil in 'unitOpenGLConfigUtil.pas',
  unitServo12 in 'unitServo12.pas',
  unitElement1 in 'unitElement1.pas',
  unitServo3 in 'unitServo3.pas',
  unitElement2 in 'unitElement2.pas',
  unitServo4 in 'unitServo4.pas',
  unitElement3 in 'unitElement3.pas',
  unitServo5 in 'unitServo5.pas',
  unitElement4 in 'unitElement4.pas',
  unitServo6 in 'unitServo6.pas',
  Log4D in 'log4d\Log4D.pas',
  unitDebugUtil in 'unitDebugUtil.pas';

{$R *.res}

begin
  Application.Initialize;
//  TConfiguratorUnit.doBasicConfiguration;  
  Application.CreateForm(TfrmReglerPanel, frmReglerPanel);
  Application.Run;
end.
