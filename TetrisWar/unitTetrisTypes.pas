unit unitTetrisTypes;

interface

uses Types;

type

  TClientInfo = record
    Name       : ShortString; // Name des Spielers
    IP         : ShortString; // IP des Spielers
    Port       : Word;        // Port des Spielers
    AliveCount : Byte;        // Zähler, der die Erreichbarkeit des Spielers angibt
    Deads      : Word;        // Anzahl wie oft der Spieler gestorben ist
    Height     : Byte;        // Gibt das höchste belegte Feld des Spielers an
    OneLineFaktor   : Single; // Faktor für eine zusätzliche Linie (0 bis 1) Zum Client wird ein Prozentwert gesendet
    TwoLineFaktor   : Single; // Faktor für zwei zusätzliche Linien (0 bis 2) Zum Client wird ein Prozentwert gesendet
    ThreeLineFaktor : Single; // Faktor für drei zusätzliche Linien (0 bis 3) Zum Client wird ein Prozentwert gesendet
  end;

  TInfoPaketForClients = record
    Identifier : ShortString; // Wird benötigt, um beim Client zu erkennen,
                              // dass es sich um ein TInfoPaketForClients handelt.
    ErrorMsg   : ShortString; // Kann eine Fehlermeldung für den Client beinhalten
    OneLineFaktor   : Single; // Faktor für eine zusätzliche Linie (0 bis 1)
    TwoLineFaktor   : Single; // Faktor für zwei zusätzliche Linien (0 bis 1)
    ThreeLineFaktor : Single; // Faktor für drei zusätzliche Linien (0 bis 1)
    BonusLines      : Byte;   // Anzahl der zusätzlichen Linien, die der Spieler bekommt
  end;

  TInfoPaketForServer = record
    Identifier : ShortString; // Wird benötigt, um beim Server zu erkennen,
                              // dass es sich um ein TInfoPaketForServer handelt.
    Lines      : Byte;        // Anzahl der entfernten Linien
    Height     : Byte;        // Höhe des höchsten Steins
    Deads      : Word;        // Anzahl wie oft der Spieler gestorben ist
  end;

  // Beinhaltet informationen zu jedem Spieler.
  // Jede Spielerinformation ist mit einem Semikolon getrennt.
  // Beispiel mit 4 Spielern:
  // Name = 'Peter;Klaus;Lena;Martin;'
  // Deads = '1;2;0;4;'
  TSpielerliste = record
    Identifier : ShortString;  // Wird benötigt, um beim Client zu erkennen,
                               // dass es sich um ein TInfoPaket handelt.
    Name       : String[250];  // Name der Spieler (Max Zeichen pro Spieler = 10, Max Spieleranzahl = 25)
    Deads      : String[125];  // Anzahl wie oft der Spieler gestorben ist (5 * 25)
    Height     : String[25];   // Gibt das höchste belegte Feld des Spielers an (2 * 25)
  end;

  TClientInfoArray = Array of TClientInfo;
  TPointArray  = Array of TPoint;
  TGitter = Array of Array of Integer;
  TStringArray = Array of String;
  TIntegerArray = Array of Integer;
  TDoubleArray = Array of Double;

const
  // Nachrichten vom Client an den Server
  MSG_SERVER_ANFRAGE        = 'Server?';
  MSG_TEILNAHME             = 'Teilnahme:';
  MSG_LINIEN                = 'Linien:';
  MSG_CLIENT_ANTWORT        = 'Here';
  MSG_INFO_PAKET_FOR_SERVER = 'InfoPaketForServer';

  // Nachrichten vom Server an den Client
  MSG_SERVER_ANTWORT         = 'Server:';
  MSG_TEILNAHME_OK           = 'Teilnahme ok';
  MSG_CLIENT_ANFRAGE         = 'Client?';
  MSG_INFO_PAKET_FOR_CLIENTS = 'InfoPaketForClients';
  MSG_SPIELERLISTE           = 'Spielerliste';
  MSG_BEREITS_ONLINE         = 'SpielerBereitsOnline';

  MAX_ALIVE_REQUEST          = 5;

implementation

end.
