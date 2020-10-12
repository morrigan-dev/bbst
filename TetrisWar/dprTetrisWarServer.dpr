program dprTetrisWarServer;

uses
  Forms,
  unitServer in 'unitServer.pas' {frmTetrisWarServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTetrisWarServer, frmTetrisWarServer);
  Application.Run;
end.
