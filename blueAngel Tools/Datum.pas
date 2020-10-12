unit Datum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfrmblueAngelTool = class(TForm)
    imgSearch_Up: TImage;
    imgSearch_Down: TImage;
    imgSearch: TImage;
    imgBackground: TImage;
    lblInfo: TLabel;
    procedure imgSearchMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure imgBackgroundMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure imgSearchClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmblueAngelTool: TfrmblueAngelTool;

implementation

{$R *.dfm}

{---------------------- Begin-User-Procedures --------------------------}

Procedure Search;
Begin

End;

{----------------------  End-User-Procedures ---------------------------}

procedure TfrmblueAngelTool.imgSearchMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
Self.imgSearch.Picture := Self.imgSearch_Down.Picture;
end;

procedure TfrmblueAngelTool.FormShow(Sender: TObject);
begin
imgBackground.Left := 0;
imgBackground.Top := 0;
imgBackground.Width := Self.Width;
imgBackground.Height := Self.Height;
end;

procedure TfrmblueAngelTool.imgBackgroundMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
imgSearch.Picture := imgSearch_Up.Picture;
end;

procedure TfrmblueAngelTool.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case key of
    ord(27) : Self.Close;
    ord(83) : Search;
end;
end;

procedure TfrmblueAngelTool.imgSearchClick(Sender: TObject);
begin
Search;
end;

end.
