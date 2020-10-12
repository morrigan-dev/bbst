{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitIObserverable;

interface

uses unitIObserver;

type

  IObserverable = Interface(IInterface)
    procedure addObserver(observer : IObserver);
    procedure removeObserver(observer : IObserver);
    procedure syncViews();
  end;

implementation

end.
