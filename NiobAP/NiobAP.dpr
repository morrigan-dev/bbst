program NiobAP;

uses
  Forms,
  AutoPilot in 'AutoPilot.pas' {frmNiobAP};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Niob Auto Pilot';
  Application.CreateForm(TfrmNiobAP, frmNiobAP);
  Application.Run;
end.
