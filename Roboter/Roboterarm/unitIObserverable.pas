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
