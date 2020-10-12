program Project1;

uses
  Forms,
  Analyse in 'Analyse.pas' {frmAnalyse};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAnalyse, frmAnalyse);
  Application.Run;
end.
