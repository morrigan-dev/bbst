program Pavl1;

uses
  Forms,
  mAVL1 in 'MAVL1.PAS' {Form1},
  mLog1 in 'MLOG1.PAS' {Form2};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
