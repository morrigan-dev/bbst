unit unitAbstractGeo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  // Eigene Units
  unitIObserver;

type
  TGeo = class(TImage)
  private
    index    : Integer;
    observer : IObserver;
  protected
    color     : TColor;
    procedure Clicked(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; color: TColor; index: Integer; observer: IObserver);
    destructor Destroy; override;
    procedure Paint(); virtual; abstract;
    procedure IncTop(incFaktor: Integer);
  end;

implementation

constructor TGeo.Create(AOwner: TComponent; color: TColor; index: Integer; observer: IObserver);
begin
  inherited Create(AOwner);

  Self.index     := index;
  Self.observer  := observer;
  Self.color     := color;
  Self.OnClick   := Clicked;
  Self.Cursor    := crCross;
end;

destructor TGeo.Destroy();
begin
  inherited Destroy();
end;

procedure TGeo.IncTop(incFaktor: Integer);
begin
  Self.Top := Self.Top + incFaktor;
  if(Self.Top > Self.Parent.Height) then
    Self.observer.SetDeleteIndex(Self.index, false)
  else
    Paint();
end;

procedure TGeo.Clicked(Sender: TObject);
begin
  Self.observer.SetDeleteIndex(Self.index, true);
end;

end.
