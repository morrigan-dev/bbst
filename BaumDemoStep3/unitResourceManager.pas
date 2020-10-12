{
  Diese Klasse dient dazu Texte und Beschriftungstexte jeglicher Art in einer
  externen Datei auszulagern. Da die Resourcen für alle die gleichen sind
  und somit keine Mehrfachinstanzen dieser Klasse benötigt werden ist diese
  nach dem Single-Pattern aufgebaut.

  Singleton in Delphi: http://edn.embarcadero.com/article/22576

  Compiler: Delphi 6.0

  ~author Thomas Gattinger
  ~version 1.0
}
unit unitResourceManager;

interface

uses
  Classes, Dialogs, SysUtils;

type
  TResourceManager = class(TObject)
  private
    resources  : TStringList;                 // Beinhaltet alle GUI-Texte
    separator  : String;                      // Separatorzeichen
    filename   : String;                      // Pfad zur Sprachdatei
    fileLoaded : Boolean;                     // Gibt an, ob die Sprachdatei
                                              // erfolgreich geladen wurde
    constructor Create;

  public
    class function NewInstance : TResourceManager;
    procedure FreeInstance; override;

    procedure LoadLanguageFile(filename : String);
    function GetString(key : String) : String;
    function GetStringWithSeparator(key : String) : String;
    procedure SetSeparator(separator : String);
  end;

const DEFAULT_LABEL = '???';

var Instance  : TResourceManager = nil;        // Einzige Instanz dieser Klasse
    Ref_Count : Integer          = 0;          // Anzahl der Verwedungen dieses
                                               // Singletons
implementation

{
  Diese Methode erzeugt einmal eine Instanz dieser Klasse und liefert diese
  zurück. Wurde bereits einmal eine Instanz erzeugt, so wird beim Aufruf
  direkt diese eine Instanz zurückgeliefert. (Singleton-Pattern)

  ~return Einzige Instanz dieser Klasse.
  ~version 1.0
}
class function TResourceManager.NewInstance: TResourceManager;
begin
  if ( not Assigned( Instance ) ) then
  begin
    Instance := Create;
  end;
  Result := Instance;
  Inc( Ref_Count );
end;

{
  Dieser private Konstruktor erzeugt eine Instanz diser Klasse und
  initialisiert die Klassenvariablen

  ~version 1.0
}
constructor TResourceManager.Create;
begin
  inherited Create;

  Self.resources           := TStringList.Create;
  Self.resources.Delimiter := '=';
  Self.separator           := ':';
  Self.filename            := '';
  Self.fileLoaded          := false;
end;

{
  Diese Methode gitb die Instanz dieser Klasse wieder frei, wenn beim Aufruf
  dieser Methode diese Instanz nicht mehr verwendet wird. Es werden auch
  alle Klassenvariablen wieder freigegeben.

  ~version 1.0
}
procedure TResourceManager.FreeInstance;
begin
  Dec( Ref_Count );
  if ( Ref_Count = 0 ) then
  begin
    Instance := nil;

    // Gebe Klassenvariablen wieder frei
    Self.resources.FreeInstance;
    Self.separator  := '';
    Self.filename   := '';
    Self.fileLoaded := false;

    inherited FreeInstance;
  end;
end;

{
  Diese Methode lädt die angegebene Datei in die TStringList.

  ~param filename Der Dateiname der zu ladenden Datei.
  ~version 1.0
}
procedure TResourceManager.LoadLanguageFile(filename : String);
begin
  try
    Self.resources.LoadFromFile(filename);
    Self.filename := filename;
    Self.fileLoaded := true;
  except
    on EFOpenError do
    begin
      Self.fileLoaded := false;
      MessageDlg('No language file (' + filename + ') found!',
                 mtError, [mbOk], 0);
    end;
  end;
end;

{
  Diese Methode liefert den Wert zu dem übergebenen Key.

  ~param key Der Key des Wertes aus der .properties Datei
  ~return Den Wert zu dem übergebenen Key, falls der Key vorhanden ist.
          Ist der Key nicht vorhanden wird ein Default Zeichen zurückgegeben.
  ~version 1.1
}
function TResourceManager.GetString(key : String) : String;
var value : String;                            // Der Wert zum key
begin
  value := '';

  if(key <> '') then
  begin
    if(not Self.fileLoaded) then               // Falls keine Datei geladen
    begin                                      // wurde, dann verzichte auf eine
      Result := DEFAULT_LABEL;                 // auf eine Fehlermeldung bei
      Exit;                                    // jedem fehlenden key.
    end;

                                               // Falls der key nicht gefunden
                                               // wurde, so zeige dies dem
    value := Self.resources.Values[key];       // Nutzer an und gib eine
    if(value = '') then                        // Defaultbeschriftung zurück.
    begin
      MessageDlg('The key <' + key + '> was not found in the file "'
                 + Self.filename + '"', mtWarning, [mbOk], 0);
      value := DEFAULT_LABEL;
    end
    else
    begin
      value := StringReplace(value, '\n', chr(13)+chr(10), [rfReplaceAll]);
    end;
  end;
  Result := value;
end;

{
  Diese Methode liefert den Wert zu dem übergebenen Key und hängt ans Ende ein
  Separatorzeichen.

  ~param key Der Key des Wertes aus der .properties Datei
  ~return Den Wert und ein Separatprzeichen zu dem übergebenen Key,
          falls der Key vorhanden ist.
          Ist der Key nicht vorhanden wird ein Default Zeichen zurückgegeben.
  ~version 1.0
}
function TResourceManager.GetStringWithSeparator(key : String) : String;
begin
  Result := GetString(key) + Self.separator;
end;

{
  Diese Methode setzt ein Separatorzeichen, welches beim Aufruf der Methode
  GetStringWithSeparator benutzt wird.

  ~param separator Der zu setzende Separator
  ~version 1.0
}
procedure TResourceManager.SetSeparator(separator : String);
begin
  Self.separator := separator;
end;

end.
