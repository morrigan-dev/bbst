{
 **********************************************************************************************************************
 * K L A S S E: ObserverableImpl
 *---------------------------------------------------------------------------------------------------------------------
 * Version:   1.0
 * Autor:     tgattinger
 * Datei:     unitObserverableImpl.pas
 * Aufgabe:   Diese Klasse implementiert das IObserverable Interface für alle FormModelle.
 *            Jedes FormModel muss von dieser Klasse abgeleitet sein.
 * Compiler:  Delphi 7.0
 * Aenderung: 05.11.2009
 **********************************************************************************************************************
}
unit unitObserverableImpl;

interface
uses
  classes,
  unitIObserver;        // Observer Interface als Schnittstelle für die Modelle

type
  TObserveravleImpl = class(TObject)
  protected
    observerList : TList;
    procedure notifyAll;
  public
    constructor create;
    destructor destroy;
    procedure addObserver(observer: IObserver);
    procedure removeObserver(observer: IObserver);
  end;

implementation

constructor TObserveravleImpl.create;
begin
  inherited create;
  observerList := TList.Create;
end;

destructor TObserveravleImpl.destroy;
begin
  observerList.Free;
  inherited free;
end;

procedure TObserveravleImpl.addObserver(observer: IObserver);
begin
  if observerList.IndexOf(pointer(observer)) = -1
  then observerList.Add(pointer(observer));
end;

procedure TObserveravleImpl.removeObserver(observer: IObserver);
begin
  observerList.Remove(pointer(observer));
end;

procedure TObserveravleImpl.notifyAll;
var
  i        : integer;
  observer : IObserver;
begin
  for i := 0 to observerList.Count-1 do
  begin
    observer := IObserver(observerList[i]); // bewirkt typecast
    observer.update;
  end;
end;

end.
