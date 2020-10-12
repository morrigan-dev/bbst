program HandelsPosten;

uses
  Forms,
  Handel in 'Handel.pas' {frmHandelsposten};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Handelsposten';
  Application.CreateForm(TfrmHandelsposten, frmHandelsposten);
  Application.Run;
end.
