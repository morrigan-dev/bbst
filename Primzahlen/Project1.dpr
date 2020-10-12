program Project1;

uses
  Forms,
  Primzahl in 'Primzahl.pas' {frmPrimzahlen};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Primzahl';
  Application.CreateForm(TfrmPrimzahlen, frmPrimzahlen);
  Application.Run;
end.
