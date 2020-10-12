unit Records;

interface

uses Types, Graphics;

type
  TButtons = record
    Schliessen: TPoint;
    NeueSeiteClick: TPoint;
    NaviClick: TPoint;
    AdressLeiste: TPoint;
    PopUp: TPoint;
    News: TPoint;
    Konstruktionen: TPoint;
    Konstruktionen_Quartiere: TPoint;
    Dock: TPoint;
    Dock_LadenEntladen: TPoint;
    Flotte: TPoint;
    Flotte_uebernehmen: TPoint;
    Flotte_Plus: TPoint;
    Flotte_Plus2: TPoint;
    Flotte_Zuladen: TPoint;
    Flotte_Zuladen2: TPoint;
    Flotte_Rueckfuehren: TPoint;
    Flotte_zumDock: TPoint;
    Portal: TPoint;
    Portal_Flottenname: TPoint;
    Portal_Sektor: TPoint;
    Portal_Feld1: TPoint;
    Portal_Feld2: TPoint;
    Portal_Wurmloch: TPoint;
    Portal_uebernehmen: TPoint;
    Navi_Frachtraum: TPoint;
    Navi_Rueckfuehren: TPoint;
    Navi_Nord: TPoint;
    Navi_NordOst: TPoint;
    Navi_Ost: TPoint;
    Navi_SuedOst: TPoint;
    Navi_Sued: TPoint;
    Navi_SuedWest: TPoint;
    Navi_West: TPoint;
    Navi_NordWest: TPoint;
    Aktien: TPoint;
    Depot: TPoint;
    Handel: TPoint;
    Handel_Direkthandel: TPoint;
    Handel_Weiter: TPoint;
    EigeneAngebote: TPoint;
    Sponsor: TPoint;
  end;

  TDTime = record
    Tage     : Integer;
    Stunden  : Integer;
    Minuten  : Integer;
    Sekunden : Integer;
  end;

  TBilderkennung = record
    Image  : TBitmap;
    Path   : String;
    Letter : Char;
    Width  : Integer;
  end;

  type TSchiff = record
    Name : String;
    Position : TPoint;
    neuPos : TPoint;
    System : String;
    Flottenname : String;
    LaderaumAkt : Integer;
    LaderaumMax : Integer;
    Anzahl : Integer;
    Index : Integer;
    StopIndex: Integer;
    RessEingeladen : Boolean;
  end;

  TTabelle = record
    Ressource: String;
    Menge: Integer;
    Preis: Single;
    Venad: String;
    Clan: String;
    EndetAm: TDateTime;
    EndetIn: TDTime;
  end;  

  TTradeEntry = record
    Ressource : String;
    Menge     : Integer;
    Preis     : Single;
    Venad     : String;
    Clan      : String;
    EndetAm   : TDateTime;
    EndetIn   : TDTime;
  end;

  THandelsGut = record
    Nrg : TTradeEntry;
    Rek : TTradeEntry;
    Erz : TTradeEntry;
    Org : TTradeEntry;
    Syn : TTradeEntry;
    Fe  : TTradeEntry;
    LM  : TTradeEntry;
    SM  : TTradeEntry;
    EM  : TTradeEntry;
    Rad : TTradeEntry;
    ES  : TTradeEntry;
    EG  : TTradeEntry;
    Iso : TTradeEntry;
  end;

  TSettings = record
    Ticker_Ress: String;
  end;

  TRessTable = Array of TTradeEntry;
  TRessName = Array[0..14] of String;

  implementation

end.
 