program Navigation;

uses
  Forms,
  Main in 'Main.pas' {frmNavigation},
  City in 'City.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Navigation';
  Application.CreateForm(TfrmNavigation, frmNavigation);
  Application.Run;
end.
