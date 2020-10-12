program RevorixBot;

uses
  Forms,
  RXBot in 'RXBot.pas' {Form1},
  MyIO in 'MyIO.pas',
  Convert in 'Convert.pas',
  ColorButton in 'ColorButton.pas',
  Handel in 'Handel.pas',
  Records in 'Records.pas',
  Mathematics in 'Mathematics.pas',
  Sammeln in 'Sammeln.pas',
  Aktien in 'Aktien.pas',
  Assistent in 'Assistent.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
//  Application.CreateForm(TfmGraphics, fmGraphics);
  Application.Run;
end.
