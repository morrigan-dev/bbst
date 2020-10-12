program dprAddition;

uses
  Forms,
  unitAddition in 'unitAddition.pas' {frmAddition};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAddition, frmAddition);
  Application.Run;
end.
