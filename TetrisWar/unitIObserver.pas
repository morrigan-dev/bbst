unit unitIObserver;

interface

type
  IObserver = interface(IInterface)
     procedure SetDeletedLineCount(lines: Byte);
     procedure ResetOneBonusColor();
     procedure ResetTwoBonusColor();
     procedure ResetThreeBonusColor();
     procedure ShowNextFigur();
     procedure ShowLines();
     procedure ShowLevel();
     procedure ShowPunkte();
     procedure IncDeads();
     procedure LogMsg(msg: String);
  end;

implementation

end.
