program Planer;

uses
  Forms,
  Schiffsplaner in 'Schiffsplaner.pas' {frmPlaner};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPlaner, frmPlaner);
  Application.Run;
end.
