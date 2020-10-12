unit unitIObserver;

interface

type
  IObserver = Interface(IInterface)
      procedure SetDeleteIndex(index : Integer; clicked : Boolean);
  end;

implementation

end.
