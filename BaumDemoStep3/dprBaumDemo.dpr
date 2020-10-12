program dprBaumDemo;

uses
  Forms,
  unitBaumDemo in 'unitBaumDemo.pas' {frmBaumDemo},
  unitResourceManager in 'unitResourceManager.pas',
  unitTreeViewer in 'unitTreeViewer.pas',
  unitElement in 'unitElement.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBaumDemo, frmBaumDemo);
  Application.Run;
end.
