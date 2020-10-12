unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Convert, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{    function isDigit(c: Char): Boolean;
    function isNumber(Anzahl: String): Boolean;
    function getSchiffanzahl(text: string): Integer;
    function getSystem(text: string; SchiffsIndex: Integer): String;
    function getName(text: string): String;
    function getFlotte(text: String; SchiffsIndex: Integer): String;
    function getLaderaumAkt(text, name: string): Integer;
    function getLaderaumMax(text, name: string): Integer;
    function getXKoord(text: string; SchiffsIndex: Integer): Integer;
    function getYKoord(text: string; SchiffsIndex: Integer): Integer;
    function getRess(text: string): Boolean;
}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (MyConvert.isNumber(Memo1.Text)) then showmessage('true')
  else showmessage('false');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  showmessage(inttostr(MyConvert.getSchiffanzahl(Memo1.Text)));
end;

procedure TForm1.Button3Click(Sender: TObject);
var i : Integer;
begin
  for i := 1 to MyConvert.getSchiffanzahl(Memo1.text) do
    showmessage(MyConvert.getSystem(Memo1.Text,i));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  showmessage(MyConvert.getName(Memo1.Text));
end;

procedure TForm1.Button5Click(Sender: TObject);
var i: Integer;
begin
  for i := 1 to MyConvert.getSchiffanzahl(Memo1.text) do
    showmessage(MyConvert.getFlotte(Memo1.Text,i));
end;

procedure TForm1.Button6Click(Sender: TObject);
var name: string;
begin
  name := MyConvert.getName(Memo1.Text);
  showmessage(inttostr(MyConvert.getLaderaumAkt(Memo1.Text,name)));
  showmessage(inttostr(MyConvert.getLaderaumMax(Memo1.Text,name)));
end;

procedure TForm1.Button7Click(Sender: TObject);
var i: Integer;
begin
  for i := 1 to MyConvert.getSchiffanzahl(Memo1.text) do
    showmessage(inttostr(MyConvert.getXKoord(Memo1.Text,i)) + '|' + inttostr(MyConvert.getYKoord(Memo1.Text,i)));
end;

procedure TForm1.Button8Click(Sender: TObject);
var x : Integer;
begin
  x := MyConvert.getRess(Memo1.Text);
  showmessage(inttostr(x));
end;

end.
