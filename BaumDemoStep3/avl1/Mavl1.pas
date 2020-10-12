unit mAVL1;

{ BUGS:
  beim Löschen: Daten eines Knotens müssen im Speicher verbleiben, sonst
     stürzt das Programm ab! Läßt sich evtl. ja noch abändern!
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, mBaum, mElement, ExtCtrls, mLog1;



type
  TForm1 = class(TForm)
    BtKnotenLoeschen: TButton;
    KnotenEinfuegen: TButton;
    BtNeuerSuchBaum: TButton;
    EdKnoten: TEdit;
    LbKnoten: TLabel;
    BtBaumLoeschen: TButton;
    Button1: TButton;
    procedure BtNeuerSuchBaumClick(Sender: TObject);
    procedure KnotenEinfuegenClick(Sender: TObject);
    procedure BtKnotenLoeschenClick(Sender: TObject);
    procedure BtBaumLoeschenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdKnotenChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    AVLBaum: TAVLBaum;
    procedure Anzeigen (AktKnoten: PTreeNode; Tiefe,X,DX: integer);

  public
    { Public-Deklarationen }
  end;

var Form1: TForm1;


(***************************************************************************)

implementation

{$R *.DFM}

procedure TForm1.Anzeigen (AktKnoten: PTreeNode; Tiefe,X,DX: integer);
var Inhalt: TKnoten;
    XPos,YPos: integer;
begin
  lbKnoten.repaint;
  if AktKnoten <> NIL then begin
    DX := DX div 2;
    XPos := X;
    YPos := Tiefe*20 + 40;
    if Aktknoten^.hright <> nil then begin
      Canvas.MoveTo (XPos,YPos);
      Canvas.LineTo (XPos+DX,YPos+20);
      Anzeigen (AktKnoten^.hRight,Tiefe+1,X+DX,DX);
    end;
    if Aktknoten^.hLeft <> nil then begin
      Canvas.MoveTo (XPos,YPos);
      Canvas.LineTo (XPos-DX,YPos+20);
      Anzeigen (AktKnoten^.hLeft,Tiefe+1,X-DX,DX);
    end;
    Inhalt := TKnoten(AktKnoten^.hKnoten);
    Canvas.Ellipse (XPos-10,YPos-5,XPos+25,YPos+15);
    Canvas.TextOut (XPos,YPos-3,IntToStr(Inhalt.GetElement));
  end
end;

procedure TForm1.BtNeuerSuchBaumClick(Sender: TObject);
const werte: array[1..11] of integer = (5,3,8,2,4,7,10,1,6,9,11);
var NeuKnoten: TKnoten;
    K: integer;
begin
  caption := 'AVL-Bäume';
  form2.listbox1.clear;
  if (AVLBaum <> NIL) then begin
    AVLBaum.Clear;
    AVLBaum.destroy;
  end;
  AVLBaum := TAVLBaum.Create;
  for k := 1 to 5 do begin
     NeuKnoten := TKnoten.Create;
     NeuKnoten.Belegen(werte[k]);
     AVLBaum.Insert(NeuKnoten, form2.listbox1);
  end;
  Canvas.Rectangle (0,0,ClientWidth,ClientHeight);
  Anzeigen (AVLbaum.GetRoot,0,ClientWidth div 2,ClientWidth div 2);
end;

procedure TForm1.KnotenEinfuegenClick(Sender: TObject);
var Neuknoten: TKnoten;
begin
  if AVLBaum = NIL then AVLBaum := TAVLBaum.Create;
  if EdKnoten.Text = '' then EdKnoten.Text := '0';
  Neuknoten := TKnoten.Create;
  Neuknoten.Belegen(StrToInt(EdKnoten.Text));
  if not AVLBaum.Vorhanden(NeuKnoten) then
    AVLbaum.Insert(Neuknoten, form2.listbox1)
  else
    caption := 'Knoten schon vorhanden!';
  Canvas.Rectangle (0,0,ClientWidth,ClientHeight);
  Anzeigen (AVLBaum.GetRoot,0,ClientWidth div 2,ClientWidth div 2);
end;

procedure TForm1.BtKnotenLoeschenClick(Sender: TObject);
var Loeschknoten: TKnoten;
begin
  if AVLBaum = NIL then exit;
  if EdKnoten.Text = '' then EdKnoten.Text := '0';
  Loeschknoten := TKnoten.Create;
  Loeschknoten.Belegen (StrToInt(EdKnoten.Text));
  if AVLBaum.Vorhanden(Loeschknoten) then
    AVLbaum.Delete (Loeschknoten, form2.listbox1)
  else Caption := 'Knoten nicht vorhanden!';
  Canvas.Rectangle (0,0,ClientWidth,ClientHeight);
  Anzeigen (AVLbaum.GetRoot,0,ClientWidth div 2,ClientWidth div 2);
end;

procedure TForm1.BtBaumLoeschenClick(Sender: TObject);
begin
 if AVLbaum = NIL then exit;
 AVLBaum.Clear;
 AVLbaum.Destroy;
 Canvas.Rectangle (0,0,ClientWidth,ClientHeight);
 AVLbaum := NIL;
end;


(***************************  TElement  ***************************************)


procedure TForm1.FormCreate(Sender: TObject);
begin
  AVLBaum := TAVLBaum.Create;
  form2 := TForm2.Create(Form1);
  form2.show;
end;

procedure TForm1.EdKnotenChange(Sender: TObject);
var i: integer;
    s: string;
    iserror: boolean;
begin
  iserror := false;
  s := EdKnoten.Text;
  if length(s) = 0 then EdKnoten.Text := '0';
  for i := 1 to length(s) do
    if not(s[i] in ['0'..'9']) then iserror := true;
  if iserror then
    EdKnoten.Text := IntToStr(EdKnoten.Tag)
  else
    EdKnoten.Tag := StrToInt(EdKnoten.Text);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if AVLBaum <> NIL then
    AVLBaum.Destroy;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  form2.listbox1.clear;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Canvas.Rectangle(0,0,ClientWidth,ClientHeight);
  Anzeigen (AVLbaum.GetRoot,0,ClientWidth div 2,ClientWidth div 2);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FormResize(Sender);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  FormResize(Sender);
end;

end.
