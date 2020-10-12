{ *******************************************************************************
  Project       : Tetris War Client
  Filename      : unitTetrisMain
  Date          : 2011-06-06
  Version       : 0.0.0.1
  Last modified : 2011-06-19
  Author        : Thomas Gattinger
  URL           : -
  Copyright     : Copyright (c) 2011 Thomas Gattinger
  ******************************************************************************* }
unit unitTetrisMain;

interface

uses
  // Delphi Libs
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IDSocketHandle, StdCtrls, Sockets, IdUDPServer,
  IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, StrUtils, Winsock, IdException, pngimage,

  // Eigene Libs
  unitSpielfeld, unitIObserver, unitTetrisTypes, unitGamepad, unitKeyboard, unitInfoBox;

type

  {
    Dies ist die Hauotklasse des Tetris War Spiels.
    Hier befinden sich alle GUI Elemente und die Eventverarbeitung.
    }
  TfrmTetrisWar = class(TForm, IObserver)
    // Lobby mit all ihren Elementen
    pnlLobby: TPanel;
    btnServerSuchen: TButton;
    btnTeilnehmen: TButton;
    edtLocalIP: TEdit;
    edtLocalPort: TEdit;
    edtSpielername: TEdit;
    edtServerPort: TEdit;
    lblLobby: TLabel;
    lblLocalIP: TLabel;
    lblLocalPort: TLabel;
    lblServerIP: TLabel;
    lblSpielername: TLabel;
    lblServerListe: TLabel;
    lstServerListe: TListBox;
    rbTastatur: TRadioButton;
    rbGamepad: TRadioButton;

    // Spielfläche mit all ihren Elementen
    imgHintergund: TImage;
    imgRanken: TImage;
    imgNextFigur: TImage;
    mmo1Mal: TMemo;
    mmo2Mal: TMemo;
    mmo3Mal: TMemo;
    mmoPunkte: TMemo;
    mmoLevel: TMemo;
    mmoLinien: TMemo;
    lblGameOver: TLabel;
    lblRestart: TLabel;
    lstSpielerliste: TListBox;
    UDPServer: TIdUDPServer;
    RotationTimer: TTimer;
    MoveSideTimer: TTimer;
    MoveDownTimer: TTimer;
    mmoLog: TMemo;
    RestartTimer: TTimer;
    edtServerIP: TEdit;
    lblServerPort: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnServerSuchenClick(Sender: TObject);
    procedure btnTeilnehmenClick(Sender: TObject);
    procedure UDPServerUDPRead(AThread: TIdUDPListenerThread; AData: TBytes;
      ABinding: TIdSocketHandle);
    procedure edtServerPortExit(Sender: TObject);
    procedure RotationTimerTimer(Sender: TObject);
    procedure MoveSideTimerTimer(Sender: TObject);
    procedure MoveDownTimerTimer(Sender: TObject);
    procedure rbTastaturClick(Sender: TObject);
    procedure rbGamepadClick(Sender: TObject);
    procedure RestartTimerTimer(Sender: TObject);
    procedure LogMsg(msg: String);
    procedure lstSpielerlisteMouseLeave(Sender: TObject);
    procedure edtLocalPortExit(Sender: TObject);
    procedure edtServerIPExit(Sender: TObject);
    procedure lstServerListeClick(Sender: TObject);

  private { Private-Deklarationen }
    Spielfeld: TSpielfeld;
    ServerCount: Integer;
    ServerIPs: TStringArray;
    ServerPorts: TIntegerArray;
    ServerIP: ShortString;
    ServerPort: Word;
    DefaultClientPort: Word;
    DefaultServerPort: Word;
    OneLineFaktor: Double;
    TwoLineFaktor: Double;
    ThreeLineFaktor: Double;
    Gamepad: TGamepad;
    Keyboard: TKeyboard;
    aktiveDevice: Integer;
    Deads: Word;
    Counter: Byte;
    LastPOVControl: TPOVControl;

    procedure UpdateBonusView();
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
    procedure SendInfoPaketForServer(lines: Byte);

  public { Public-Deklarationen }
    constructor Create(AOwner : TComponent); override;
    procedure StartGame();
    procedure SetDeletedLineCount(lines: Byte);
    procedure ResetOneBonusColor();
    procedure ResetTwoBonusColor();
    procedure ResetThreeBonusColor();
    procedure ShowNextFigur();
    procedure ShowLines();
    procedure ShowLevel();
    procedure ShowPunkte();
    procedure IncDeads();

    procedure GamepadButtonPushed(Sender: TObject; Joystick: Word;
      Buttons: Word);

  end;

var
  frmTetrisWar: TfrmTetrisWar;

implementation

{$R *.dfm}

const
  DEVICE_GAMEPAD = 0;
  DEVICE_KEYBOARD = 1;

constructor TfrmTetrisWar.Create(AOwner : TComponent);
  var frmInfoBox : TfrmInfoBox;
begin
  inherited Create(AOwner);

  Self.Position := poScreenCenter;
  frmInfoBox := TfrmInfoBox.Create(Self);
  frmInfoBox.Position := poScreenCenter;
  frmInfoBox.ShowModal;
end;

procedure TfrmTetrisWar.GamepadButtonPushed(Sender: TObject; Joystick: Word;
  Buttons: Word);
begin
  showmessage('ok');
end;

procedure TfrmTetrisWar.LogMsg(msg: String);
begin
  mmoLog.lines.Add(TimeToStr(Time()) + ': ' + msg);
end;

procedure TfrmTetrisWar.lstServerListeClick(Sender: TObject);
var
  selectedServerIndex: Integer;
begin
  selectedServerIndex := lstServerListe.ItemIndex;
  Self.ServerIP := Self.ServerIPs[selectedServerIndex];
  Self.ServerPort := Self.ServerPorts[selectedServerIndex];

  edtServerIP.Text := Self.ServerIP;
  edtServerPort.Text := IntToStr(Self.ServerPort);
end;

procedure TfrmTetrisWar.lstSpielerlisteMouseLeave(Sender: TObject);
begin
  lstSpielerliste.Selected[0] := False;
  frmTetrisWar.Show;
end;

procedure TfrmTetrisWar.IncDeads();
begin
  mmoLog.lines.Add('IncDeads');
  Inc(Self.Deads);
  Self.Spielfeld.Stop();
  lblGameOver.Visible := True;
  lblGameOver.BringToFront;
  lblRestart.BringToFront;
  Self.Counter := 5;
  RestartTimer.Interval := 1000;
  RestartTimer.Enabled := True;
end;

procedure TfrmTetrisWar.Split(Delimiter: Char; Str: string;
  ListOfStrings: TStrings);
begin
  ListOfStrings.Clear;
  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.DelimitedText := Str;
end;

procedure TfrmTetrisWar.ShowPunkte();
begin

end;

procedure TfrmTetrisWar.ShowLevel();
begin
  mmoLevel.lines[1] := IntToStr(Self.Spielfeld.GetLevel());
end;

procedure TfrmTetrisWar.ShowLines();
begin
  mmoLinien.lines[1] := IntToStr(Self.Spielfeld.GetLinien());
end;

procedure TfrmTetrisWar.ShowNextFigur();
var
  NextFigur: TBitmap;
  Rect: TRect;
begin
  NextFigur := Self.Spielfeld.GetNextFigurImage();
  imgNextFigur.Canvas.Draw(0, 0, NextFigur);
  SendInfoPaketForServer(0);
end;

procedure TfrmTetrisWar.SendInfoPaketForServer(lines: Byte);
var
  InfoPaket: TInfoPaketForServer;
  ByteArray: TBytes;
begin
  InfoPaket.Identifier := MSG_INFO_PAKET_FOR_SERVER;
  InfoPaket.lines := lines;
  InfoPaket.Height := Self.Spielfeld.GetLineHeight();
  InfoPaket.Deads := Self.Deads;

  mmoLog.lines.Add('InfoPaket.Height = ' + IntToStr(InfoPaket.Height));

  SetLength(ByteArray, SizeOf(TInfoPaketForServer));
  Move(InfoPaket, ByteArray[0], SizeOf(TInfoPaketForServer));

  UDPServer.SendBuffer(Self.ServerIP, Self.ServerPort, ByteArray);
end;

procedure TfrmTetrisWar.SetDeletedLineCount(lines: Byte);
begin
  SendInfoPaketForServer(lines);
end;

procedure TfrmTetrisWar.ResetOneBonusColor();
begin
  // mmo1Mal.Color := clBlack;
  // mmo1Mal.Font.Color := clYellow;
  UpdateBonusView();
end;

procedure TfrmTetrisWar.ResetTwoBonusColor();
begin
  // mmo2Mal.Color := clBlack;
  // mmo2Mal.Font.Color := clYellow;
  UpdateBonusView();
end;

procedure TfrmTetrisWar.RestartTimerTimer(Sender: TObject);
begin
  lblRestart.Caption := 'Restart in ' + IntToStr(Self.Counter) + ' Sekunden';
  lblRestart.Visible := True;
  if (Self.Counter = 0) then
  begin
    mmoLog.lines.Add('restart');
    RestartTimer.Interval := 0;
    lblGameOver.Visible := False;
    lblRestart.Visible := False;
    Self.Spielfeld.Start();
    SendInfoPaketForServer(0);
  end;
  Dec(Self.Counter);
end;

procedure TfrmTetrisWar.ResetThreeBonusColor();
begin
  // mmo3Mal.Color := clBlack;
  // mmo3Mal.Font.Color := clYellow;
  UpdateBonusView();
end;

procedure TfrmTetrisWar.UpdateBonusView();
var
  bonus: Integer;
begin
  bonus := Self.Spielfeld.GetOneBonusRows();
  if (bonus > 0) then
  begin
    mmo1Mal.Font.Size := 8;
    mmo1Mal.Color := $000000FF;
    mmo1Mal.Font.Color := clBlack;
    mmo1Mal.lines[1] := FloatToStrF(Self.OneLineFaktor * 100, ffGeneral, 3, 1)
      + '% (' + IntToStr(bonus) + 'x)';
  end
  else
  begin
    mmo1Mal.Font.Size := 11;
    mmo1Mal.Color := clBlack;
    mmo1Mal.Font.Color := clYellow;
    mmo1Mal.lines[1] := FloatToStrF(Self.OneLineFaktor * 100, ffGeneral, 3, 1)
      + '%';
  end;

  bonus := Self.Spielfeld.GetTwoBonusRows();
  if (bonus > 0) then
  begin
    mmo2Mal.Font.Size := 8;
    mmo2Mal.Color := $000000FF;
    mmo2Mal.Font.Color := clBlack;
    mmo2Mal.lines[1] := FloatToStrF(Self.TwoLineFaktor * 100, ffGeneral, 3, 1)
      + '% (' + IntToStr(bonus) + 'x)';
  end
  else
  begin
    mmo2Mal.Font.Size := 11;
    mmo2Mal.Color := clBlack;
    mmo2Mal.Font.Color := clYellow;
    mmo2Mal.lines[1] := FloatToStrF(Self.TwoLineFaktor * 100, ffGeneral, 3, 1)
      + '%';
  end;

  bonus := Self.Spielfeld.GetThreeBonusRows();
  if (bonus > 0) then
  begin
    mmo3Mal.Font.Size := 8;
    mmo3Mal.Color := $000000FF;
    mmo3Mal.Font.Color := clBlack;
    mmo3Mal.lines[1] := FloatToStrF(Self.ThreeLineFaktor * 100, ffGeneral, 3,
      1) + '% (' + IntToStr(bonus) + 'x)';
  end
  else
  begin
    mmo3Mal.Font.Size := 11;
    mmo3Mal.Color := clBlack;
    mmo3Mal.Font.Color := clYellow;
    mmo3Mal.lines[1] := FloatToStrF(Self.ThreeLineFaktor * 100, ffGeneral, 3,
      1) + '%';
  end;

end;

procedure TfrmTetrisWar.btnServerSuchenClick(Sender: TObject);
var
  localIP: ShortString;
  localPort: Word;
  ServerIP: ShortString;
  ServerPort: Word;
begin
  lstServerListe.Clear;
  UDPServer.DefaultPort := Self.DefaultClientPort;
  if (not UDPServer.Active) then
    UDPServer.Active := True;

  if (edtServerIP.Text <> '') then
  begin
    Self.ServerIP := edtServerIP.Text;
    Self.ServerPort := StrToInt(edtServerPort.Text);
    UDPServer.Send(Self.ServerIP, Self.ServerPort, MSG_SERVER_ANFRAGE,
      TEncoding.Unicode);
    mmoLog.lines.Add('Server-Suchanfrage gesendet (Port: ' + IntToStr
        (Self.DefaultServerPort) + ')');
  end;

  UDPServer.Broadcast(MSG_SERVER_ANFRAGE, Self.DefaultServerPort,
    '255.255.255.255', TEncoding.Unicode);
  mmoLog.lines.Add('Server-Suchanfrage gesendet (Port: ' + IntToStr
      (Self.DefaultServerPort) + ')');
end;

procedure TfrmTetrisWar.btnTeilnehmenClick(Sender: TObject);
begin
  UDPServer.Send(Self.ServerIP, Self.ServerPort,
    MSG_TEILNAHME + edtSpielername.Text, TEncoding.Unicode);
end;

procedure TfrmTetrisWar.edtLocalPortExit(Sender: TObject);
begin
  Self.DefaultClientPort := StrToInt(edtLocalPort.Text);
end;

procedure TfrmTetrisWar.edtServerIPExit(Sender: TObject);
begin
  Self.ServerIP := edtServerIP.Text;
end;

procedure TfrmTetrisWar.edtServerPortExit(Sender: TObject);
begin
  Self.DefaultServerPort := StrToInt(edtServerPort.Text);
end;

procedure TfrmTetrisWar.FormCreate(Sender: TObject);
var
  TCPClient: TTcpClient;
begin
  TCPClient := TTcpClient.Create(Self);

  Self.DefaultServerPort := 12346;
  Self.DefaultClientPort := 12355;
  Self.ServerPort := Self.DefaultServerPort;

  edtLocalIP.Text := TCPClient.LocalHostAddr;
  edtLocalIP.ReadOnly := True;
  edtLocalIP.Color := clSilver;
  edtLocalPort.Text := IntToStr(Self.DefaultClientPort);
  edtLocalPort.NumbersOnly := True;
  edtServerPort.Text := IntToStr(Self.DefaultServerPort);
  edtServerPort.NumbersOnly := True;
  edtServerIP.Text := '';
  edtSpielername.Text := 'Spieler';

  Self.ServerCount := 0;
  SetLength(Self.ServerIPs, 0);
  SetLength(Self.ServerPorts, 0);

  OneLineFaktor := 0;
  TwoLineFaktor := 0;
  ThreeLineFaktor := 0;

  Self.aktiveDevice := DEVICE_GAMEPAD;
  rbTastatur.Checked := True;

  Self.Gamepad := TGamepad.Create();
  Self.Keyboard := TKeyboard.Create();

  mmo1Mal.Visible := False;
  mmo2Mal.Visible := False;
  mmo3Mal.Visible := False;
  mmoPunkte.Visible := False;
  mmoLevel.Visible := False;
  mmoLinien.Visible := False;

  btnServerSuchen.Click;
end;

procedure TfrmTetrisWar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // showmessage(inttostr(ord(key)));
  if (ord(Key) = 76) then
    if mmoLog.Visible then
      mmoLog.Visible := False
    else
      mmoLog.Visible := True;

  if (Self.aktiveDevice <> DEVICE_KEYBOARD) then
    Exit;

  { case ord(key) of
    37: // Left-Arrow
    Self.Spielfeld.MoveLeft();
    38: // Up-Arrow
    Self.Spielfeld.FlipObject();
    39: // Right-Arrow
    Self.Spielfeld.MoveRight();
    40: // Down-Arrow
    Self.Spielfeld.FastDown();
    13:
    begin
    if pnlLobby.Visible then
    pnlLobby.Visible := false
    else
    pnlLobby.Visible := true;
    end;
    end;
  }
end;

procedure TfrmTetrisWar.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {
    case ord(key) of
    40: // Down-Arrow
    Self.Spielfeld.StopFastDown();
    end;
  }
end;

procedure TfrmTetrisWar.MoveDownTimerTimer(Sender: TObject);
var
  down: Boolean;
  left: Boolean;
  right: Boolean;
begin
  if (Self.aktiveDevice = DEVICE_GAMEPAD) then
  begin
    Self.Gamepad.Update();
    down := Self.Gamepad.POV.down;
    left := Self.Gamepad.POV.left;
    right := Self.Gamepad.POV.right;
  end;

  if (Self.aktiveDevice = DEVICE_KEYBOARD) then
  begin
    Self.Keyboard.Update();
    down := Self.Keyboard.GetArrowControl.down;
    left := Self.Keyboard.GetArrowControl.left;
    right := Self.Keyboard.GetArrowControl.right;
  end;

  if (not down) then
  begin
    Self.Spielfeld.ResetFastDownAllowed();
    if (Self.Spielfeld.isFastDown()) then
      Self.Spielfeld.StopFastDown();
  end;

  if (not left) and (not right) and (down) then
    Self.Spielfeld.FastDown();
end;

procedure TfrmTetrisWar.MoveSideTimerTimer(Sender: TObject);
var
  down: Boolean;
  left: Boolean;
  right: Boolean;
begin
  if (Self.aktiveDevice = DEVICE_GAMEPAD) then
  begin
    LastPOVControl.up := Self.Gamepad.POV.up;
    LastPOVControl.down := Self.Gamepad.POV.down;
    LastPOVControl.left := Self.Gamepad.POV.left;
    LastPOVControl.right := Self.Gamepad.POV.right;
    Self.Gamepad.Update();
    down := Self.Gamepad.POV.down;
    left := Self.Gamepad.POV.left;
    right := Self.Gamepad.POV.right;
  end;

  if (Self.aktiveDevice = DEVICE_KEYBOARD) then
  begin
    Self.Keyboard.Update();
    down := Self.Keyboard.GetArrowControl.down;
    left := Self.Keyboard.GetArrowControl.left;
    right := Self.Keyboard.GetArrowControl.right;
  end;

  if (left) then
  begin
    Self.Spielfeld.MoveLeft();
    Self.Spielfeld.ResetFastDownAllowed();
  end;
  if (right) then
  begin
    Self.Spielfeld.MoveRight();
    Self.Spielfeld.ResetFastDownAllowed();
  end;
end;

procedure TfrmTetrisWar.rbGamepadClick(Sender: TObject);
begin
  Self.aktiveDevice := DEVICE_GAMEPAD;
end;

procedure TfrmTetrisWar.rbTastaturClick(Sender: TObject);
begin
  Self.aktiveDevice := DEVICE_KEYBOARD;
end;

procedure TfrmTetrisWar.RotationTimerTimer(Sender: TObject);
var
  I: Integer;
begin
  if (Self.aktiveDevice = DEVICE_GAMEPAD) then
  begin
    Self.Gamepad.Update();

    if (not Self.Gamepad.Buttons[1]) and (Self.Spielfeld.isFlipped()) then
      Self.Spielfeld.StopFlipped();

    if (Self.Gamepad.Buttons[1]) and (not Self.Spielfeld.isFlipped()) then
      Self.Spielfeld.FlipObject();
  end;

  if (Self.aktiveDevice = DEVICE_KEYBOARD) then
  begin
    Self.Keyboard.Update();

    if (not Self.Keyboard.GetArrowControl.up) and (Self.Spielfeld.isFlipped())
      then
      Self.Spielfeld.StopFlipped();

    if (Self.Keyboard.GetArrowControl.up) and (not Self.Spielfeld.isFlipped())
      then
      Self.Spielfeld.FlipObject();
  end;

  // for I := 0 to 31 do
  // begin
  // mmoLog.Lines.Add(inttostr(I) + ' Button: '  + booltostr(Self.Gamepad.Buttons[I]));
  // end;

end;

procedure TfrmTetrisWar.StartGame();
begin
  KeyPreview := True;
  pnlLobby.Visible := False;
  mmo1Mal.Visible := True;
  mmo2Mal.Visible := True;
  mmo3Mal.Visible := True;
  mmoPunkte.Visible := True;
  mmoLevel.Visible := True;
  mmoLinien.Visible := True;
  LastPOVControl.up := False;
  LastPOVControl.down := False;
  LastPOVControl.left := False;
  LastPOVControl.right := False;
  lstSpielerliste.Visible := True;
  Self.Spielfeld := TSpielfeld.Create(Self, Self, 20, 10);
  Self.Spielfeld.left := 45;
  Self.Spielfeld.Top := 55;
  imgRanken.BringToFront;
  RotationTimer.Interval := 50;
  MoveSideTimer.Interval := 120;
  MoveDownTimer.Interval := 70;
  Self.Spielfeld.Start();
end;

procedure TfrmTetrisWar.UDPServerUDPRead(AThread: TIdUDPListenerThread;
  AData: TBytes; ABinding: TIdSocketHandle);
var
  ClientMsg: String;
  ServerName: String;
  LinienFaktor: String;
  SplitFaktor: TStringList;
  Index: Integer;
  BonusRows: Integer;
  InfoPaket: TInfoPaketForClients;
  Spielerliste: TSpielerliste;
  SpielerNamen: TStringList;
  SpielerDead: TStringList;
  SpielerHeight: TStringList;
  I: Integer;
  Name: String;
  Deads: String;
  Height: String;
  J: Integer;
begin
  ClientMsg := TEncoding.Unicode.GetString(AData);

  mmoLog.lines.Add('Nachricht von ' + ABinding.PeerIP + ':' + IntToStr
      (ABinding.Port) + ' = ' + ClientMsg);
  mmoLog.lines.Add('BufferSize = ' + IntToStr(UDPServer.BufferSize));

  if (AnsiContainsText(ClientMsg, MSG_SERVER_ANTWORT)) then
  begin
    SetLength(Self.ServerIPs, Self.ServerCount + 1);
    SetLength(Self.ServerPorts, Self.ServerCount + 1);
    Self.ServerIPs[Self.ServerCount] := ABinding.PeerIP;
    Self.ServerPorts[Self.ServerCount] := ABinding.PeerPort;
    Inc(Self.ServerCount);
    ServerName := Copy(ClientMsg, Length(MSG_SERVER_ANTWORT) + 1,
      Length(ClientMsg));
    lstServerListe.Items.Add(ServerName + ' (' + ABinding.PeerIP + ')');
    if (lstServerListe.GetCount > 0) then
    begin
      lstServerListe.Selected[0] := True;
      lstServerListeClick(lstServerListe);
      btnTeilnehmen.SetFocus();
    end;
    Exit;
  end;

  if (ClientMsg = MSG_TEILNAHME_OK) then
  begin
    StartGame();
    Exit;
  end;

  if (ClientMsg = MSG_CLIENT_ANFRAGE) then
  begin
    UDPServer.Send(Self.ServerIP, Self.ServerPort, MSG_CLIENT_ANTWORT,
      TEncoding.Unicode);
    Exit;
  end;

  Move(AData[0], InfoPaket, SizeOf(TInfoPaketForClients));
  mmoLog.lines.Add('infoPaket.Identifier = ' + InfoPaket.Identifier);
  if (InfoPaket.Identifier = MSG_INFO_PAKET_FOR_CLIENTS) then
  begin
    mmoLog.lines.Add('infoPaket.ErrorMsg = ' + InfoPaket.ErrorMsg);
    mmoLog.lines.Add('infoPaket.OneLineFaktor = ' + FloatToStr
        (InfoPaket.OneLineFaktor));
    mmoLog.lines.Add('infoPaket.TwoLineFaktor = ' + FloatToStr
        (InfoPaket.TwoLineFaktor));
    mmoLog.lines.Add('infoPaket.ThreeLineFaktor = ' + FloatToStr
        (InfoPaket.ThreeLineFaktor));
    mmoLog.lines.Add('infoPaket.BonusLines = ' + IntToStr(InfoPaket.BonusLines)
      );

    Self.OneLineFaktor := InfoPaket.OneLineFaktor;
    Self.TwoLineFaktor := InfoPaket.TwoLineFaktor;
    Self.ThreeLineFaktor := InfoPaket.ThreeLineFaktor;

    case InfoPaket.BonusLines of
      1:
        begin
          mmoLog.lines.Add('***AddOneBonusRows***');
          Self.Spielfeld.AddOneBonusRows();
          // mmo1Mal.Color := $000000ff;
          // mmo1Mal.Font.Color := clBlack;
        end;
      2:
        begin
          Self.Spielfeld.AddTwoBonusRows();
          // mmo2Mal.Color := $000000ff;
          // mmo2Mal.Font.Color := clBlack;
        end;
      3:
        begin
          Self.Spielfeld.AddThreeBonusRows();
          // mmo3Mal.Color := $000000ff;
          // mmo3Mal.Font.Color := clBlack;
        end;
    end;

    UpdateBonusView();
    Exit;
  end;

  Move(AData[0], Spielerliste, SizeOf(TSpielerliste));
  mmoLog.lines.Add('SizeOf(TSpielerliste) = ' + IntToStr(SizeOf(TSpielerliste))
    );
  mmoLog.lines.Add('Spielerliste.Identifier = ' + Spielerliste.Identifier);
  if (Spielerliste.Identifier = MSG_SPIELERLISTE) then
  begin
    mmoLog.lines.Add('Spielerliste.Name = ' + Spielerliste.Name);
    mmoLog.lines.Add('Spielerliste.Deads = ' + Spielerliste.Deads);
    mmoLog.lines.Add('Spielerliste.Height = ' + Spielerliste.Height);

    SpielerNamen := TStringList.Create;
    SpielerDead := TStringList.Create;
    SpielerHeight := TStringList.Create;
    Split(';', Spielerliste.Name, SpielerNamen);
    Split(';', Spielerliste.Deads, SpielerDead);
    Split(';', Spielerliste.Height, SpielerHeight);

    mmoLog.lines.Add('SpielerNamen.Count = ' + IntToStr(SpielerNamen.Count));

    lstSpielerliste.Clear;
    lstSpielerliste.Items.Add('Spielername   Gestorben   Höhe');
    for I := 0 to SpielerNamen.Count - 2 do
    begin
      Name := SpielerNamen.Strings[I];
      for J := 0 to 10 - Length(Name) - 1 do
        Name := Name + ' ';

      Deads := SpielerDead.Strings[I];
      for J := 0 to 3 - Length(Deads) - 1 do
        Deads := Deads + ' ';
      lstSpielerliste.Items.Add
        (Name + '       ' + Deads + '       ' + SpielerHeight.Strings[I]);
    end;
  end;

end;

end.
