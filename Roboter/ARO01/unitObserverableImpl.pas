{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitObserverableImpl;

interface

uses Classes, Dialogs, SysUtils, unitIObserverable, unitIObserver;

type
  TObserverableImpl = class(TInterfacedObject, IObserverable)
    private
      observers : TInterfaceList;      // Liste von Observern
      changed   : Boolean;    // Über dieses Flag wird entschieden ob eine Änderung
                              // bereits an die GUI gereicht wurde.
    public
      constructor Create();
      destructor Destroy(); override;

      function hasChanged() : Boolean;

      procedure addObserver(observer : IObserver);
      procedure removeObserver(observer : IObserver);
      procedure syncViews();
    end;

implementation

constructor TObserverableImpl.Create();
begin
  inherited Create();

  observers := TInterfaceList.Create();
end;

destructor TObserverableImpl.Destroy();
begin
  inherited Destroy();
end;

function TObserverableImpl.hasChanged() : Boolean;
begin
  result := changed;
end;

procedure TObserverableImpl.addObserver(observer : IObserver);
begin
  if(observers.IndexOf(observer) = -1) then
    observers.Add(observer);
end;

procedure TObserverableImpl.removeObserver(observer : IObserver);
begin
  observers.Remove(observer);
end;

procedure TObserverableImpl.syncViews();
var i : Integer;
begin
  changed := True;

  // Benachrichtige alle Observer
  for i := 0 to observers.Count - 1 do
  begin
    IObserver(observers.Items[i]).updateView();
  end;

  changed := False;
end;

end.
