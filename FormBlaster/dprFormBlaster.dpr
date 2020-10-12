program dprFormBlaster;

uses
  Forms,
  unitFormBlaster in 'unitFormBlaster.pas' {frmFormBlaster},
  unitAbstractGeo in 'unitAbstractGeo.pas',
  unitKreis in 'unitKreis.pas',
  unitDreieck in 'unitDreieck.pas',
  unitQuadrat in 'unitQuadrat.pas',
  unitIObserver in 'unitIObserver.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFormBlaster, frmFormBlaster);
  Application.Run;
end.
