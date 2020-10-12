program TabellenCreator;

uses
  Forms,
  Creator in 'Creator.pas' {frmCreator};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Tabellen Creator';
  Application.CreateForm(TfrmCreator, frmCreator);
  Application.Run;
end.
