program Project1;

uses
  Forms,
  Datum in 'Datum.pas' {frmblueAngelTool};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'blueAngel Tool';
  Application.CreateForm(TfrmblueAngelTool, frmblueAngelTool);
  Application.Run;
end.
