unit unitIObserver;

interface

uses unitTypes;

type

  IObserver = Interface(IInterface)
    procedure updateView(update : TUpdate);
  end;

implementation

end.
