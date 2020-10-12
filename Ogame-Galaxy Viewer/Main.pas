unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, ExtCtrls, DBCtrls, DBTables,
  StdCtrls, Mask;

type
  TfrmGalaxyViewer = class(TForm)
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;
    tblGalaxy: TTable;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label2: TLabel;
    DBMemo1: TDBMemo;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmGalaxyViewer: TfrmGalaxyViewer;

implementation

{$R *.dfm}

procedure TfrmGalaxyViewer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tblGalaxy.Close;
end;

procedure TfrmGalaxyViewer.FormActivate(Sender: TObject);
begin
  tblGalaxy.Open;
end;

procedure TfrmGalaxyViewer.Button1Click(Sender: TObject);
var Galaxy, Sonnensystem, Position : Integer;
    Planetenname, Spielername, Allyname : String;
    Line : String;
begin
  Line := memo1.Lines[0];
  for i := 0 to length Line do
    begin

    end;
  showmessage(Line);
end;

end.
