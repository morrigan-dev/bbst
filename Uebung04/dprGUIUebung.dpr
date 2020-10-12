program dprGUIUebung;

uses
  Forms,
  unitGUI in 'unitGUI.pas' {frmGUI};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGUI, frmGUI);
  Application.Run;
end.
