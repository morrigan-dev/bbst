unit mLog1;

interface

uses
  (* Delphi 3.0: Windows*) Winprocs, Wintypes (* Delphi 1.0 *), Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm2 = class(TForm)
    ListBox1: TListBox;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.FormResize(Sender: TObject);
begin
  listbox1.width := clientwidth;
  listbox1.height := clientheight;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  form2.FormResize(Sender);
end;

end.
