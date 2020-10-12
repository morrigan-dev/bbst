program Sudoku;

uses
  Forms,
  Main in 'Main.pas' {frmSudoku};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSudoku, frmSudoku);
  Application.Run;
end.
