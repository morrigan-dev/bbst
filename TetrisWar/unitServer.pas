{*******************************************************************************
 Project       : Tetris War Server
 Filename      : unitServer
 Date          : 2011-06-06
 Version       : 0.0.0.1
 Last modified : 2011-06-19
 Author        : Thomas Gattinger
 URL           : -
 Copyright     : Copyright (c) 2011 Thomas Gattinger
*******************************************************************************}
unit unitServer;

interface

uses
  // Delphi Libs
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer,
  IdUDPClient, Winsock, Sockets, IdSocketHandle, StrUtils, ExtCtrls,

  // Eigene Libs
  unitTetrisTypes;

type

  {
    Dies ist die Hauptklasse des Tetris War Servers.
    Hier befindet sich die GUI und die Logik des Servers.
  }
  TfrmTetrisWarServer = class(TForm)
    lblServerIP      : TLabel;
    lblServerPort    : TLabel;
    lblSpieler       : TLabel;
    lblServername    : TLabel;
    edtServerIP      : TEdit;
    edtServerPort    : TEdit;
    edtServerName    : TEdit;
    lstSpieler       : TListBox;
    btLog            : TButton;
    btnServerStarten : TButton;
    UDPServer        : TIdUDPServer;
    AliveTimer       : TTimer;
    mmoLog           : TMemo;

    procedure AliveTimerTimer(Sender: TObject);
    procedure btLogClick(Sender: TObject);
    procedure btnServerStartenClick(Sender: TObject);
    procedure edtServerPortExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UDPServerUDPRead(AThread: TIdUDPListenerThread; AData: TBytes; ABinding: TIdSocketHandle);

  private
    DefaultPort     : Word;              // Der Stanardport des Servers
    Clients         : TClientInfoArray;  // Beinhaltet Informationen zu jedem angemeldeten Spieler
    SpielerCount    : Integer;           // Anzahl der angemeldeten Spieler

    procedure AddNewSpieler(IP: ShortString; Port: Word; Name: ShortString);
    procedure AnalysiereLinien(IP: ShortString; Port: Word; Lines: Byte);
    procedure DeleteClient(index: Integer);
    function GetSpielerIndex(IP: ShortString; Port: Word): Integer;
    procedure LogMsg(msg: String);
    procedure SendInfoPaketToClient(BonusLines: Byte; SpielerIndex: Integer);
    procedure SendSpielerlisteToClients();
    procedure Send(IP: ShortString; Port: Word; Msg: String);

  public

  end;

var
  frmTetrisWarServer: TfrmTetrisWarServer;

implementation

{$R *.dfm}

{************************************************
 *     P U B L I S H E D - M E T H O D E N      *
 ************************************************}

{
  Diese Methode wird automatisch in regelmäßigen Abständen aufgerufen und prüft,
  ob die angemeldeten Spieler noch erreichbar sind. Sind sie nicht mehr erreichbar
  so werden die Spieler gelöscht und somit vom Server entfernt.

  ~param Sender Das Objekt, von dem das Event stammt
}
procedure TfrmTetrisWarServer.AliveTimerTimer(Sender: TObject);
var
  I         : Integer;  // Zählvariable
  Geloescht : Boolean;  // Gibt an, ob ein Spieler gelöscht wurde
begin
  Geloescht := True;
  // Da bei jedem Löschvorgang die Liste der angemeldeten Spieler geändert wird
  // und sich somit die Indizies ändern, muss die Alive-Prüfung nach jedem
  // Löschen neu gestartet werden.
  while(Geloescht) do
  begin
    Geloescht := False;
    for I := 0 to Self.SpielerCount - 1 do
    begin
      Self.Clients[I].AliveCount := Self.Clients[I].AliveCount + 1;
      if(Self.Clients[I].AliveCount > MAX_ALIVE_REQUEST) then
      begin
        DeleteClient(I);
        Geloescht := True;
        Break;
      end;

      // Sende Anfrage, ob der Spieler noch da ist
      if(Self.Clients[I].AliveCount > MAX_ALIVE_REQUEST - 3) then
      begin
        LogMsg('Sende Alive Nachricht an ' + Self.Clients[I].IP + ':' + IntToStr(Self.Clients[I].Port));
        Send(Self.Clients[I].IP, Self.Clients[I].Port, MSG_CLIENT_ANFRAGE);
      end;
    end;
  end;
end;

{
  Diese Methode zeigt den Log Bereich an bzw. blendet ihn wieder aus.
  Außerdem wird die Beschriftung des Log Buttons entsprechend geändert.

  ~param Sender Das Objekt, von dem das Event stammt
}
procedure TfrmTetrisWarServer.btLogClick(Sender: TObject);
begin
  if(mmoLog.Visible = True) then
  begin
    btLog.Caption            := 'Zeige Log >>';
    mmoLog.Visible           := False;
    frmTetrisWarServer.Width := 259;
  end
  else
  begin
    btLog.Caption            := 'Verstecke Log <<';
    mmoLog.Visible           := True;
    frmTetrisWarServer.Width := 566;
  end;
end;

{
  Diese Methode startet bzw. beendet den Tetris War Server.

  ~param Sender Das Objekt, von dem das Event stammt
}
procedure TfrmTetrisWarServer.btnServerStartenClick(Sender: TObject);
begin
  if(UDPServer.Active) then
  begin
    UDPServer.Active := False;
    AliveTimer.Interval := 0;
    btnServerStarten.Caption := 'Server starten';
  end
  else
  begin
    UDPServer.Active := True;
    AliveTimer.Interval := 500;
    btnServerStarten.Caption := 'Server beenden';
  end;
end;

{
  Diese Methode ändert den Standard Port des Tetris War Servers.

  ~param Sender Das Objekt, von dem das Event stammt
}
procedure TfrmTetrisWarServer.edtServerPortExit(Sender: TObject);
begin
  Self.DefaultPort      := StrToInt(edtServerPort.Text);
  UDPServer.DefaultPort := Self.DefaultPort;
end;

{
  Diese Methode befüllt die GUI Felder und initialisiert
  die Variablen und Serverelemente.

  ~param Sender Das Objekt, von dem das Event stammt
}
procedure TfrmTetrisWarServer.FormCreate(Sender: TObject);
var ip : String;
    TCPClient : TTcpClient;
begin
  // Ermittle
  TCPClient := TTcpClient.Create(Self);
  edtServerIP.Text     := TCPClient.LocalHostAddr;
  edtServerIP.ReadOnly := True;
  edtServerIP.Color    := clSilver;
  edtServerIP.TabStop  := False;

  // Setze Standardport
  Self.DefaultPort      := 12346;
  edtServerPort.Text    := IntToStr(Self.DefaultPort);
  UDPServer.DefaultPort := Self.DefaultPort;

  UDPServer.BroadcastEnabled := True;

  Self.SpielerCount := 0;
  SetLength(Self.Clients, 0);
end;

{
  Diese Methode verarbeitet die ankommenden Informationen aus dem Netz
  und deligiert die darauf resultierenden Aufgaben an entsprechende Methoden weiter.

  ~param AThread Dies ist der Indy Listener Thread
  ~param AData Das Byte Array, das über das Netz empfangen wird
  ~param Abinding Enthällt unter anderem die IP und den Port des Senders
}
procedure TfrmTetrisWarServer.UDPServerUDPRead(AThread: TIdUDPListenerThread; AData: TBytes; ABinding: TIdSocketHandle);
var
  ClientMsg  : String;                // Die Nachricht des Spielers
  ClientName : ShortString;           // Der Name des Spielers
  ClientIP   : ShortString;           // Die IP des Spielers
  ClientPort : Word;                  // Der Port des Spielers
  Lines      : Integer;               // Die Linien, die ein Spieler abgebaut hat
  LineHeight : Byte;                  // Die Bauhöhe des Spielers
  Index      : Integer;               // Der Index des Spielers in der Liste der angemeldeten Spieler
  I          : Integer;               // Zählvariable
  InfoPaket  : TInfoPaketForServer;   // Ein InfoPaket vom Client
begin
  ClientMsg := TEncoding.Unicode.GetString(AData);
  ClientIP := ABinding.PeerIP;
  ClientPort := ABinding.PeerPort;

  LogMsg('Nachricht von ' + ClientIP + ':' + IntToStr(ClientPort));

  // Ermittle, ob der Spieler bereits angemeldet ist
  Index := GetSpielerIndex(ClientIP, ClientPort);
  if(Index <> -1) then
    Self.Clients[Index].AliveCount := 0;

  // Spieler sucht nach Servern. Teile dem Spieler mit, dass dieser Server läuft.
  if(ClientMsg = MSG_SERVER_ANFRAGE) then
  begin
    LogMsg(ClientMsg);
    Send(ClientIP, ClientPort, MSG_SERVER_ANTWORT + edtServerName.Text);
    Exit;
  end;

  // Spieler möchte an diesem Server teilnehmen
  if(AnsiContainsText(ClientMsg, MSG_TEILNAHME)) then
  begin
    LogMsg(ClientMsg);
    if(Index = -1) then
    begin
      ClientName := Copy(ClientMsg, Length(MSG_TEILNAHME) + 1, Length(ClientMsg) - Length(MSG_TEILNAHME));
      AddNewSpieler(ClientIP, ClientPort, ClientName);
    end
    else
      Send(ClientIP, ClientPort, MSG_SERVER_ANTWORT + edtServerName.Text);
    Exit;
  end;

  // Spieler meldet sich auf eine Alive-Nachricht
  if(ClientMsg = MSG_CLIENT_ANTWORT) then
  begin
    LogMsg(ClientMsg);
    if(Index = -1) then Exit;
    Self.Clients[index].AliveCount := 0;
    Exit;
  end;

  // Empfange Informationspaket vom Client an den Server
  Move(AData[0], InfoPaket, SizeOf(TInfoPaketForServer));
  if(InfoPaket.Identifier = MSG_INFO_PAKET_FOR_SERVER) then
  begin
    LogMsg('Identifier = ' + InfoPaket.Identifier);
    LogMsg('Lines = '      + IntToStr(InfoPaket.Lines));
    LogMsg('Height = '     + IntToStr(InfoPaket.Height));
    LogMsg('Deads = '      + IntToStr(InfoPaket.Deads));
    LogMsg('Index = '      + IntToStr(index));
    if Index = -1 then Exit;

    Self.Clients[index].Deads := InfoPaket.Deads;
    Self.Clients[index].Height := InfoPaket.Height;
    SendSpielerlisteToClients();

    AnalysiereLinien(ClientIP, ClientPort, InfoPaket.Lines);
    Exit;
  end;
end;

{************************************************
 *     P U B L I C - M E T H O D E N            *
 ************************************************}

 //...

{************************************************
 *     P R O T E C T E D - M E T H O D E N      *
 ************************************************}

 //...

{************************************************
 *     P R I V A T E - M E T H O D E N          *
 ************************************************}

{
  Diese Methode fügt einen neuen Spieler der Liste der angemeldeten Spieler (Clients) hinzu
  und informiert den Spieler über die Teilnahme. Anschließend werden alle angemeldeten Spieler
  über den neuen Spieler informiert.

  ~param IP Die IP des Spielers, der teilnehmen will
  ~param Port Der Port des Spielers, der teilnehmen will
  ~param Name Der Name des Spielers, der teilnehmen will
}
procedure TfrmTetrisWarServer.AddNewSpieler(IP: ShortString; Port: Word; Name: ShortString);
begin
  SetLength(Self.Clients, Self.SpielerCount + 1);
  Self.Clients[Self.SpielerCount].IP              := IP;
  Self.Clients[Self.SpielerCount].Port            := Port;
  Self.Clients[Self.SpielerCount].Name            := Name;
  Self.Clients[Self.SpielerCount].AliveCount      := 0;
  Self.Clients[Self.SpielerCount].OneLineFaktor   := 0;
  Self.Clients[Self.SpielerCount].TwoLineFaktor   := 0;
  Self.Clients[Self.SpielerCount].ThreeLineFaktor := 0;
  Inc(Self.SpielerCount);
  lblSpieler.Caption := 'Spieler (' + IntToStr(Self.SpielerCount) + ')';
  lstSpieler.Items.Add(Name + ' (' + IP + ':' + IntToStr(Port) + ')');
  Send(IP, Port, MSG_TEILNAHME_OK);
  SendSpielerlisteToClients();
end;

{
  Diese Methode ermittelt aus der übergebenen Linenanzahl einen Faktor,
  der an alle anderen Spieler gesendet wird. Es gibt insgesamt drei verschiedene Faktoren
  je nachdem wieviele Linen ein Spieler abgebaut hat.
  - für 2 abgebaute Linien erhalten alle anderen Spieler 1 zusätzliche Linie
  - für 3 abgebaute Linien erhalten alle anderen Spieler 2 zusätzliche Linien
  - für 4 abgebaute Linien erhalten alle anderen Spieler 3 zusätzliche Linien
  Der Faktor pro Spieler ermittelt sich dann durch die zusätzlichen Linen
  multipliziert mit der (angemeldeten Spieleranzahl - 1)

  ~param IP Die IP des Spielers, der Linien abgebaut hat
  ~param Port der Port des Spielers, der Linien abgebaut hat
  ~param Anzahl der Linien, die der Spieler abgebaut hat
}
procedure TfrmTetrisWarServer.AnalysiereLinien(IP: ShortString; Port: Word; Lines: Byte);
var
  lineFaktor : Double;
  I          : Integer;
begin
  if(lines > 1) then
  begin
    if(Self.SpielerCount > 1) then
      lineFaktor := (lines - 1) / (Self.SpielerCount - 1)
    else
      lineFaktor := (lines - 1) / (Self.SpielerCount);

    for I := 0 to Self.SpielerCount - 1 do
    begin
      if not((Self.Clients[I].IP = IP)
        and (Self.Clients[I].Port = Port)) then
      begin
        case lines of
          2:
          begin
            Self.Clients[I].OneLineFaktor := Self.Clients[I].OneLineFaktor + lineFaktor;
            mmoLog.Lines.Add('***OneLineFaktor = ' + FloatToStr(Self.Clients[I].OneLineFaktor));
            if(Self.Clients[I].OneLineFaktor >= 1) then
            begin
              Self.Clients[I].OneLineFaktor := Self.Clients[I].OneLineFaktor - 1;
              mmoLog.Lines.Add('SendInfoPaketToClients: Self.Clients[I].IP = ' + Self.Clients[I].IP
                 + ' Self.Clients[I].Port = ' + IntToStr(Self.Clients[I].Port));
              SendInfoPaketToClient(1, I);
            end;
          end;
          3:
          begin
            Self.Clients[I].TwoLineFaktor := Self.Clients[I].TwoLineFaktor + lineFaktor;
            if(Self.Clients[I].TwoLineFaktor >= 2) then
            begin
              Self.Clients[I].TwoLineFaktor := Self.Clients[I].TwoLineFaktor - 2;
              SendInfoPaketToClient(2, I);
            end;
          end;
          4:
          begin
            Self.Clients[I].ThreeLineFaktor := Self.Clients[I].ThreeLineFaktor + lineFaktor;
            if(Self.Clients[I].ThreeLineFaktor >= 3) then
            begin
              Self.Clients[I].ThreeLineFaktor := Self.Clients[I].ThreeLineFaktor - 3;
              SendInfoPaketToClient(3, I);
            end;
          end;
        end;
        SendInfoPaketToClient(0, I);
      end;
    end;
  end;
end;

{
  Diese Methode entfernt einen Spieler vom Server, wenn der Spieler nicht mehr erreichbar ist.

  ~param Index Der Index des Spielers in der Liste der angemeldeten Spieler (Clients)
}
procedure TfrmTetrisWarServer.DeleteClient(Index: Integer);
var
  I : Integer; // Zählvariable
begin
  // Alle Folgespieler müssen aufrutschen, damit der letzte Index entfernt werden kann
  for I := Index to Self.SpielerCount - 2 do
  begin
    Self.Clients[I].IP  := Self.Clients[I + 1].IP;
    Self.Clients[I].Port := Self.Clients[I + 1].Port;
    Self.Clients[I].Name := Self.Clients[I + 1].Name;
    Self.Clients[I].AliveCount := Self.Clients[I + 1].AliveCount;
    Self.Clients[I].Deads := Self.Clients[I + 1].Deads;
    Self.Clients[I].Height := Self.Clients[I + 1].Height;
    Self.Clients[I].OneLineFaktor := Self.Clients[I + 1].OneLineFaktor;
    Self.Clients[I].TwoLineFaktor := Self.Clients[I + 1].TwoLineFaktor;
    Self.Clients[I].ThreeLineFaktor := Self.Clients[I + 1].ThreeLineFaktor;
  end;
  Dec(Self.SpielerCount);
  SetLength(Self.Clients, Self.SpielerCount);
  lblSpieler.Caption := 'Spieler (' + IntToStr(Self.SpielerCount) + ')';
  lstSpieler.Items.Delete(Index);
end;

{
  Diese Methode ermittelt den Index eines Spielers aus der Liste der angemeldeten Spieler (Clients)
  anhand der IP und des Ports. Wird kein passender Eintrag gefunden so wird -1 zurückgegeben.

  ~param ip Die IP des zu suchenden Spielers
  ~param port Der Port des zu suchenden Spielers
  ~return Den Index an dem der Spieler mit der IP und dem Pot gefunden wurde.
          Falls kein Spieler gefunden wurde wird -1 zurückgegeben
}
function TfrmTetrisWarServer.GetSpielerIndex(IP: ShortString; Port: Word): Integer;
var
  I : Integer;  // Zählvariable
begin
  Result := -1;
  for I := 0 to Self.SpielerCount - 1 do
  begin
    if(Self.Clients[I].IP = IP)
      and(Self.Clients[I].Port = Port) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

{
  Diese Methode schreibt die übergebene Nachricht in die Log Console.

  ~param msg Die zu loggende Nachricht
}
procedure TfrmTetrisWarServer.LogMsg(msg: String);
begin
  mmoLog.Lines.Add(TimeToStr(Time()) + ': ' + msg);
end;

{
  Diese Methode sendet ein InfoPaket zu einem Spieler.

  ~param BonusLines Die Anzahl der zusätzlichen Linien für den Spieler
  ~param SpielerIndex Der Index des Spielers aus der Liste der angemeldeten Spieler
}
procedure TfrmTetrisWarServer.SendInfoPaketToClient(BonusLines: Byte; SpielerIndex: Integer);
var
  I         : Integer;               // Zählvariable
  ByteArray : TBytes;                // Byte-Array, das an den Spieler gesendet wird.
  InfoPaket : TInfoPaketForClients;  // Das InfoPaket für den Spieler
begin
  InfoPaket.Identifier := MSG_INFO_PAKET_FOR_CLIENTS;
  InfoPaket.ErrorMsg := '';
  InfoPaket.OneLineFaktor := Self.Clients[SpielerIndex].OneLineFaktor;
  InfoPaket.TwoLineFaktor := Self.Clients[SpielerIndex].TwoLineFaktor / 2;
  InfoPaket.ThreeLineFaktor := Self.Clients[SpielerIndex].ThreeLineFaktor / 3;
  InfoPaket.BonusLines := BonusLines;
  SetLength(ByteArray, SizeOf(TInfoPaketForClients));
  Move(InfoPaket, ByteArray[0], SizeOf(TInfoPaketForClients));
  UDPServer.SendBuffer(Self.Clients[SpielerIndex].IP, Self.Clients[SpielerIndex].Port, ByteArray);
end;

{
  Diese Methode sendet an alle angemeldeten Spieler eine Spielerliste.
}
procedure TfrmTetrisWarServer.SendSpielerlisteToClients();
var
  I            : Integer;       // Zählvariable
  ByteArray    : TBytes;        // Byte-Array, dass an den Spieler gesendet wird.
  Spielerliste : TSpielerliste; // Enthällt die Spielerliste für jeden Spieler
begin
  SetLength(Spielerliste.Name, 5000);
  SetLength(Spielerliste.Deads, 300);
  SetLength(Spielerliste.Height, 200);

  Spielerliste.Identifier := MSG_SPIELERLISTE;
  Spielerliste.Name       := '';
  Spielerliste.Deads      := '';
  Spielerliste.Height     := '';

  for I := 0 to Self.SpielerCount - 1 do
  begin
    with Spielerliste do
    begin
      Name   := Name   + Self.Clients[I].Name             + ';';
      Deads  := Deads  + IntToStr(Self.Clients[I].Deads)  + ';';
      Height := Height + IntToStr(Self.Clients[I].Height) + ';';
    end;
  end;

  SetLength(ByteArray, SizeOf(TSpielerliste));
  Move(Spielerliste, ByteArray[0], SizeOf(TSpielerliste));
  LogMsg('Spielerliste:');
  LogMsg('Spielerliste.Name = ' + Spielerliste.Name);
  LogMsg('Spielerliste.Deads = ' + Spielerliste.Deads);
  LogMsg('Spielerliste.Height = ' + Spielerliste.Height);
  for I := 0 to Self.SpielerCount - 1 do
  begin
    LogMsg('Sende Spielerliste zu ' + Self.Clients[I].Name);
    UDPServer.SendBuffer(Self.Clients[I].IP, Self.Clients[I].Port, ByteArray);
  end;
end;

{
  Diese Methode sendet eine Nachticht an einen Spieler.

  ~param IP Die IP an die die Nachricht gesendet wird
  ~param Port Der Port an die die Nachricht gesendet wird
  ~param Msg Die Nachricht, die versendet wird
}
procedure TfrmTetrisWarServer.Send(IP: ShortString; Port: Word; Msg: String);
begin
  UDPServer.Send(IP, Port, Msg, TEncoding.Unicode);
end;

end.
