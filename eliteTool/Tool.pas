unit Tool;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TfrmEliteTool = class(TForm)
    pnlMain: TPanel;
    shpMainHeader: TShape;
    shpMainInfo01: TShape;
    lblMainHeader: TLabel;
    shpMainHeader2: TShape;
    shpMainInfo02: TShape;
    lblMainInfo02: TLabel;
    lblMainHeader2: TLabel;
    lblFlottenAnzahl: TLabel;
    pnlFlottenAnzahl: TPanel;
    Shape1: TShape;
    Label2: TLabel;
    txtFlottenAnzahl: TEdit;
    Shape3: TShape;
    Panel1: TPanel;
    lblFlottenErinnerung: TLabel;
    lblBeenden: TLabel;
    Shape2: TShape;
    Shape4: TShape;
    Image1: TImage;
    Shape5: TShape;
    Label1: TLabel;
    Shape6: TShape;
    Image2: TImage;
    Image3: TImage;
    procedure pnlMainResize(Sender: TObject);
    procedure txtFlottenAnzahlChange(Sender: TObject);
    procedure lblFlottenErinnerungClick(Sender: TObject);
    procedure lblFlottenErinnerungMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblFlottenErinnerungMouseLeave(Sender: TObject);
    procedure lblBeendenClick(Sender: TObject);
    procedure lblBeendenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblBeendenMouseLeave(Sender: TObject);
  private
    shpMainInfo : array[1..20,1..2] of TShape;
    txtMainInfo : array[1..20,1..2] of TEdit;
  public
    { Public-Deklarationen }
  end;

var
  frmEliteTool: TfrmEliteTool;
  shpMainInfo21: TShape;

implementation

{$R *.dfm}

procedure TfrmEliteTool.pnlMainResize(Sender: TObject);
var x: Integer;
begin
  // Passt die Größe der Objekte der Flotten Erinnerung an
  shpMainHeader.Width := pnlMain.Width;

  shpMainInfo02.Width := pnlMain.Width - 67;

  lblMainInfo02.Width := pnlMain.Width - 67;

  shpMainHeader2.Width := pnlMain.Width;

  for x := 1 to StrToInt(lblFlottenAnzahl.Caption) do begin
    shpMainInfo[x,1].Top := 57 + 32 * (x-1);
    shpMainInfo[x,2].Top := 57 + 32 * (x-1);
    shpMainInfo[x,2].Width := pnlMain.Width - 67;
    txtMainInfo[x,1].Top := 65 + 32 * (x-1);
    txtMainInfo[x,2].Top := 65 + 32 * (x-1);
    txtMainInfo[x,2].Width := pnlMain.Width - 79;
  end;

end;


procedure TfrmEliteTool.txtFlottenAnzahlChange(Sender: TObject);
var x: Integer;
var altAnzahl, Anzahl: Integer;
var answer: LongInt;
begin
  if (txtFlottenAnzahl.Text <> '') and (StrToInt(txtFlottenAnzahl.Text) <= 20) then begin
    altAnzahl := StrToInt(lblFlottenAnzahl.Caption);
    Anzahl := StrToInt(txtFlottenAnzahl.Text);

    if altAnzahl < Anzahl then begin
      lblFlottenAnzahl.Caption := txtFlottenAnzahl.Text;
      for x := altAnzahl+1 to Anzahl do begin
        shpMainInfo[x,1] := TShape.Create(pnlMain);
        shpMainInfo[x,1].Parent := pnlMain;
        with shpMainInfo[x,1] do begin
          Left := 0;
          Width := 65;
          Height := 30;
          Pen.Color := $00996633;
          Brush.Color := $00664534;
        end;
        shpMainInfo[x,2] := TShape.Create(pnlMain);
        shpMainInfo[x,2].Parent := pnlMain;
        with shpMainInfo[x,2] do begin
          Left := 67;
          Height := 30;
          Pen.Color := $00996633;
          Brush.Color := $00664534;
        end;

        txtMainInfo[x,1] := TEdit.Create(pnlMain);
        txtMainInfo[x,1].Parent := pnlMain;
        with txtMainInfo[x,1] do begin
          Left := 10;
          Width := 45;
          Height := 13;
          Color := $00664534;
          BorderStyle := bsNone;
          Font.Color := clWhite;
          Font.Style := [fsBold];
          Text := '0:00:00';
          ReadOnly := True;
        end;
        txtMainInfo[x,2] := TEdit.Create(pnlMain);
        txtMainInfo[x,2].Parent := pnlMain;
        with txtMainInfo[x,2] do begin
          Left := 78;
          Height := 13;
          Color := $00664534;
          BorderStyle := bsNone;
          Font.Color := clLime;
          Font.Style := [fsBold];
          Text := 'Flotte ist am Ziel angekommen.';
        end;
      end;
      pnlMain.Height := 90 + Anzahl * 32;
      pnlFlottenAnzahl.Top := 56 + Anzahl * 32;
    end;

    if altAnzahl > Anzahl then begin
      if (altAnzahl-Anzahl) = 1 then
        answer := Application.MessageBox('Soll der letzte Eintrag wirklich gelöscht werden?','Eintrag löschen',mb_YESNO + mb_DefButton2 + mb_IconQuestion)
      else
        answer := Application.MessageBox('Sollen die letzten Einträge wirklich gelöscht werden?','Einträge löschen',mb_YESNO + mb_DefButton2 + mb_IconQuestion);

      if answer = IDYes then begin
        lblFlottenAnzahl.Caption := txtFlottenAnzahl.Text;
        pnlMain.Width := 300;
        pnlMain.Height := 90 + Anzahl * 32;
        pnlFlottenAnzahl.Top := 56 + Anzahl * 32;
        for x := Anzahl+1 to altAnzahl do begin
          shpMainInfo[x,1].Destroy;
          shpMainInfo[x,2].Destroy;
          txtMainInfo[x,1].Destroy;
          txtMainInfo[x,2].Destroy;
        end;
      end
      else
        txtFlottenAnzahl.Text := lblFlottenAnzahl.Caption;
    end;

  end;
end;

procedure txtMainInfoDblClick;
begin

end;

procedure TfrmEliteTool.lblFlottenErinnerungClick(Sender: TObject);
begin
  // Feste Positionswerte der Objekte der Flotten Erinnerung werden festgelegt
  shpMainHeader.Left := 0;
  shpMainHeader.Top := 0;
  shpMainHeader.Height := 17;

  shpMainInfo01.Left := 0;
  shpMainInfo01.Top := 19;
  shpMainInfo01.Width := 65;
  shpMainInfo01.Height := 17;

  shpMainInfo02.Left := 67;
  shpMainInfo02.Top := 19;
  shpMainInfo02.Height := 17;
  lblMainInfo02.Left := 67;
  lblMainInfo02.Top := 21;
  lblMainInfo02.Height := 17;

  shpMainHeader2.Left := 0;
  shpMainHeader2.Top := 38;
  shpMainHeader2.Height := 17;

  pnlMain.Width := 500;
  pnlMain.Visible := True;
end;

procedure TfrmEliteTool.lblFlottenErinnerungMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblFlottenErinnerung.Color := $0093644A;
end;

procedure TfrmEliteTool.lblFlottenErinnerungMouseLeave(Sender: TObject);
begin
  lblFlottenErinnerung.Color := $00664534;
end;

procedure TfrmEliteTool.lblBeendenClick(Sender: TObject);
begin
  close();
end;

procedure TfrmEliteTool.lblBeendenMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblBeenden.Color := $0093644A;
end;

procedure TfrmEliteTool.lblBeendenMouseLeave(Sender: TObject);
begin
  lblBeenden.Color := $00664534;
end;

end.
