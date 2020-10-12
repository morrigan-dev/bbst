program dprTetrisWar;

uses
  Forms,
  unitTetrisMain in 'unitTetrisMain.pas' {frmTetrisWar},
  unitFiguren in 'unitFiguren.pas',
  unitSpielfeld in 'unitSpielfeld.pas',
  unitTetrisTypes in 'unitTetrisTypes.pas',
  unitIObserver in 'unitIObserver.pas',
  unitGamepad in 'unitGamepad.pas',
  unitKeyboard in 'unitKeyboard.pas' {$R *.res},
  unitColorUtil in 'unitColorUtil.pas',
  unitSoundManager in 'unitSoundManager.pas',
  Joystick in 'Joystick.pas',
  unitInfoBox in 'unitInfoBox.pas' {frmInfoBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTetrisWar, frmTetrisWar);
  Application.CreateForm(TfrmInfoBox, frmInfoBox);
  Application.Run;
end.
