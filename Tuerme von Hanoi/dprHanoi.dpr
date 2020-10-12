program dprHanoi;

uses
  Forms,
  unitHanoi in 'unitHanoi.pas' {frmHanoi};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmHanoi, frmHanoi);
  Application.Run;
end.
