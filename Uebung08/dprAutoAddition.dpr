program dprAutoAddition;

uses
  Forms,
  unitAutoAddition in 'unitAutoAddition.pas' {frmAutoAdd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAutoAdd, frmAutoAdd);
  Application.Run;
end.
