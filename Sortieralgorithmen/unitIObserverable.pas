unit unitIObserverable;

interface

uses unitIObserver, unitTypes;

type

  IObserverable = Interface(IInterface)
    procedure addObserver(observer : IObserver);
    procedure removeObserver(observer : IObserver);
    procedure syncViews(update : TUpdate);
  end;

implementation

end.
