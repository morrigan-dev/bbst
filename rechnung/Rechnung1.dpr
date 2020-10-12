program Project1;

uses
  Forms,
  Rechnung1 in 'Rechnung1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
