program GalaxyViewer;

uses
  Forms,
  Main in 'Main.pas' {frmGalaxyViewer};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGalaxyViewer, frmGalaxyViewer);
  Application.Run;
end.
