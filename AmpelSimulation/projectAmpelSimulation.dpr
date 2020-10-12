program projectAmpelSimulation;

uses
  Forms,
  unitAmpelSimulation in 'unitAmpelSimulation.pas' {frmAmpelSimulation},
  unitAutoAmpel in 'unitAutoAmpel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAmpelSimulation, frmAmpelSimulation);
  Application.Run;
end.
