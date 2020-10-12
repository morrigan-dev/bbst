program dprFallunterscheidung;

uses
  Forms,
  unitGruss in 'unitGruss.pas' {frmGruss};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGruss, frmGruss);
  Application.Run;
end.
