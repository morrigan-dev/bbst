program dprBaumDemo;

uses
  Forms,
  unitBaumDemo in 'unitBaumDemo.pas' {frmBaumDemo},
  unitResourceManager in 'unitResourceManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBaumDemo, frmBaumDemo);
  Application.Run;
end.
