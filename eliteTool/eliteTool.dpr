program eliteTool;

uses
  Forms,
  Tool in 'Tool.pas' {frmEliteTool};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmEliteTool, frmEliteTool);
  Application.Run;
end.
