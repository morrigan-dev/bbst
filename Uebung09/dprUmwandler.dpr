program dprUmwandler;

uses
  Forms,
  unitUmwandler in 'unitUmwandler.pas' {frmZahlensysteme};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmZahlensysteme, frmZahlensysteme);
  Application.Run;
end.
