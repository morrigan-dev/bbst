unit SimpleUDP;

{*******************************************************************************
 Project       : SimpleUDP
 Filename      : SimpleUDP
 Date          : 2004-07-30
 Version       : 1.0.0.1
 Last modified : 2004-11-24
 Author        : Andreas Kreul a.k.a Udontknow
 URL           : www.xnebula.net
 Copyright     : Copyright (c) 2004 Andreas Kreul
*******************************************************************************}


{*******************************************************************************
 Copyright (c) 2004, Andreas Kreul ["copyright holder(s)"]
 All rights reserved.
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
 3. The name(s) of the copyright holder(s) may not be used to endorse or
    promote products derived from this software without specific prior written
    permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************}


{*******************************************************************************
 The two classes TSimpleUDPClient and TSimpleUDPServer simplify the use of the
 Indy-components TidUDPClient and TidUDPServer, synchronising all events and
 implementing extra "OnInput" events.
 *** Changes in Version 1.0.0.1 ***
 - declared TidSocketHandle in this unit so there is no longer the need to add
   the unit idsockethandle to the uses-statement.
   Udontknow, 2004-11-24
*******************************************************************************}


interface

uses SysUtils, Classes, IdUDPClient, idUDPServer, IdUDPBase, idSocketHandle;

type TCommand=Integer;

//bidirectional commands
const coData:TCommand=0;

//Server2Client commands
const coDisconnect:TCommand=-1;


type
  TidSocketHandle=idSocketHandle.TidSocketHandle;

  //forward declarations
  TSimpleUDPClient=class;

  TProcessCommandEvent=procedure(Command:Integer; Stream:TStream) of object;
  THandleInputEvent=procedure(Sender:TObject;Stream:TStream) of object;
  TServerHandleInputEvent=procedure(Sender: TObject; AData: TStream; ABinding: TIdSocketHandle) of object;

  TClientThread=class(TThread)
  private
    function GetOnProcessCommand: TProcessCommandEvent;
    procedure SetOnProcessCommand(const Value: TProcessCommandEvent);
    function GetClient: TidUDPClient;
    procedure SetClient(const Value: TidUDPClient);
  protected
    FCommand:Integer;
    FStream:TMemoryStream;
    FClient:TidUDPClient;
    FOnProcessCommand:TProcessCommandEvent;
    procedure HandleProcessCommand; virtual;
  public
    procedure Execute; override;
  published
    property OnProcessCommand:TProcessCommandEvent read GetOnProcessCommand Write SetOnProcessCommand;
    property Client:TidUDPClient read GetClient write SetClient;
end;

  TSimpleUDPClient=class(TComponent)
  private
    FClient:TidUDPClient;
    FThread:TClientThread;
    FOnInput:THandleInputEvent;
    function GetOnInput: THandleInputEvent;
    procedure SetOnInput(const Value: THandleInputEvent);
    function GetActive: Boolean;
    function GetBufferSize: Integer;
    function GetHost: String;
    function GetPort: Integer;
    procedure SetActive(const Value: Boolean);
    procedure SetBufferSize(const Value: Integer);
    procedure SetHost(const Value: String);
    procedure SetPort(const Value: Integer);
  protected
    procedure ProcessCommand(Command:Integer; Stream:TStream); virtual;
    procedure SendCommand(Command:Integer; Stream:TStream); virtual;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure SendStream(AStream:TStream);

  published
    property OnInput:THandleInputEvent read GetOnInput write SetOnInput;
    property BufferSize:Integer read GetBufferSize write SetBufferSize;
    property Host:String read GetHost write SetHost;
    property Port:Integer read GetPort write SetPort;
    property Active:Boolean read GetActive write SetActive;
  end;

  TSimpleUDPServer=class(TComponent)
  private
    FOnInput:TServerHandleInputEvent;
    function GetActive: Boolean;
    function GetBufferSize: Integer;
    function GetOnInput: TServerHandleInputEvent;
    function GetPort: Integer;
    procedure SetActive(const Value: Boolean);
    procedure SetBufferSize(const Value: Integer);
    procedure SetOnInput(const Value: TServerHandleInputEvent);
    procedure SetPort(const Value: Integer);
    procedure UDPRead(Sender: TObject; AData: TStream; ABinding: TIdSocketHandle);
  protected
    FServer:TidUDPServer;
    procedure ProcessCommand(Binding:TIdSocketHandle; Command:Integer; Stream:TStream); virtual;
    procedure SendCommand(PeerIP:String;PeerPort:Integer;Command:Integer; Stream:TStream); virtual;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property OnInput:TServerHandleInputEvent read GetOnInput write SetOnInput;
    property BufferSize:Integer read GetBufferSize write SetBufferSize;
    property Port:Integer read GetPort write SetPort;
    property Active:Boolean read GetActive write SetActive;

  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Simple Network',[TSimpleUDPClient,TSimpleUDPServer]);
end;

{ TClientThread }

{ TSimpleUDPClient }

constructor TSimpleUDPClient.Create(AOwner: TComponent);
begin
  inherited;
  FClient:=TidUDPClient.Create(Self);
  FThread:=TClientThread.Create(True);
  FThread.FClient:=FClient;
  FThread.FOnProcessCommand:=ProcessCommand;
  FThread.Resume;
end;

destructor TSimpleUDPClient.Destroy;
begin
  FThread.Free;
  inherited;
end;

procedure TClientThread.Execute;
var BytesRead, BytesToRead:Integer;
var Ptr:Pointer;
begin
  Ptr:=NIL;
  Getmem(Ptr,FClient.BufferSize);
  try
    While not Terminated do
    begin
      if (not FClient.Active) then
      begin
        sleep(40);
        Continue;
      end;

      try
        BytesRead:=FClient.ReceiveBuffer(Ptr^,FClient.BufferSize,20);

        if BytesRead>0 then
        begin
          FCommand:=Integer(Ptr^);
          BytesToRead:=Integer(Pointer(Integer(Ptr)+4)^);
          if BytestoRead>FClient.BufferSize-4 then
            raise Exception.Create('data size exceeds packet size!');

          FStream:=TMemoryStream.Create;
          try
            FStream.Size:=BytesToRead;
            Move(Pointer(Integer(Ptr)+8)^,FStream.Memory^,BytesToRead);
            FStream.Position:=0;
            Synchronize(HandleProcessCommand);
          finally
            FStream.Free;
          end;
        end;

      except
      end;
    end;
  finally
    FreeMem(Ptr);
  end;
end;

function TClientThread.GetClient: TidUDPClient;
begin
  Result:=FClient;
end;

function TClientThread.GetOnProcessCommand: TProcessCommandEvent;
begin
  Result:=FOnProcessCommand;
end;

procedure TClientThread.HandleProcessCommand;
begin
  if Assigned(FOnProcessCommand) then
    FOnProcessCommand(FCommand,FStream);
end;

procedure TClientThread.SetClient(const Value: TidUDPClient);
begin
  FClient:=Value;
end;

procedure TClientThread.SetOnProcessCommand(
  const Value: TProcessCommandEvent);
begin
  FOnProcessCommand:=Value;
end;

function TSimpleUDPClient.GetActive: Boolean;
begin
  Result:=FClient.Active;
end;

function TSimpleUDPClient.GetBufferSize: Integer;
begin
  Result:=FClient.BufferSize;
end;

function TSimpleUDPClient.GetHost: String;
begin
  Result:=FClient.Host;
end;

function TSimpleUDPClient.GetOnInput: THandleInputEvent;
begin
  Result:=FOnInput;
end;

function TSimpleUDPClient.GetPort: Integer;
begin
  Result:=FClient.Port;
end;

procedure TSimpleUDPClient.ProcessCommand(Command: Integer;
  Stream: TStream);
begin
  if (Command=coData) and (Assigned(FOnInput)) then
    FOnInput(Self,Stream);
end;

procedure TSimpleUDPClient.SendCommand(Command: Integer; Stream: TStream);
var BufferPtr:Pointer;
begin
  if Stream.Size>BufferSize-8 then
    raise Exception.Create('Data size exceeds buffer size!');
  Stream.Position:=0;
  Getmem(BufferPtr,Stream.Size+8);
  try
    //first 4 byte indicating command type
    Integer(BufferPtr^):=Command;
    //following 4 byte telling size of following data-block
    Integer(Pointer(Integer(BufferPtr)+4)^):=Stream.Size;
    //Data from stream to temporary buffer
    Stream.ReadBuffer(Pointer(Integer(BufferPtr)+8)^,Stream.Size);
    //data from buffer to udp
    FClient.SendBuffer(BufferPtr^,Stream.Size+8);
  finally
    FreeMem(BufferPtr);
  end;
end;

procedure TSimpleUDPClient.SendStream(AStream: TStream);
begin
  SendCommand(CoData,AStream);
end;

procedure TSimpleUDPClient.SetActive(const Value: Boolean);
begin
  FClient.Active:=Value;
end;

procedure TSimpleUDPClient.SetBufferSize(const Value: Integer);
begin
  FClient.BufferSize:=Value;
end;

procedure TSimpleUDPClient.SetHost(const Value: String);
begin
  FClient.Host:=Value;
end;

procedure TSimpleUDPClient.SetOnInput(const Value: THandleInputEvent);
begin
  FOnInput:=Value;
end;

procedure TSimpleUDPClient.SetPort(const Value: Integer);
begin
  FClient.Port:=Value;
end;

{ TSimpleUDPServer }

constructor TSimpleUDPServer.Create(AOwner: TComponent);
begin
  inherited;
  FServer:=TidUdpServer.Create(Self);
  FServer.OnUDPRead:=UDPRead;
end;

destructor TSimpleUDPServer.Destroy;
begin
  FServer.Free;
  inherited;
end;

function TSimpleUDPServer.GetActive: Boolean;
begin
  Result:=FServer.Active;
end;

function TSimpleUDPServer.GetBufferSize: Integer;
begin
  Result:=FServer.BufferSize;
end;

function TSimpleUDPServer.GetOnInput: TServerHandleInputEvent;
begin
  Result:=FOnInput;
end;

function TSimpleUDPServer.GetPort: Integer;
begin
  Result:=FServer.DefaultPort;
end;

procedure TSimpleUDPServer.ProcessCommand(Binding: TIdSocketHandle;
  Command: Integer; Stream: TStream);
begin
  if (Command=coData) and (Assigned(FOnInput)) then
    FOnInput(Self,Stream,Binding);
end;

procedure TSimpleUDPServer.SendCommand(PeerIP: String; PeerPort,
  Command: Integer; Stream: TStream);
var BufferPtr:Pointer;
begin
  if Stream.Size>BufferSize-8 then
    raise Exception.Create('Data size exceeds buffer size!');
  Stream.Position:=0;
  Getmem(BufferPtr,Stream.Size+8);
  try
    //first 4 byte indicating command type
    Integer(BufferPtr^):=Command;
    //following 4 byte telling size of following data-block
    Integer(Pointer(Integer(BufferPtr)+4)^):=Stream.Size;
    //Data from stream to temporary buffer
    Stream.ReadBuffer(Pointer(Integer(BufferPtr)+8)^,Stream.Size);
    //data from buffer to udp
    FServer.SendBuffer(PeerIP,PeerPort,BufferPtr^,Stream.Size+8);
  finally
    FreeMem(BufferPtr);
  end;
end;

procedure TSimpleUDPServer.SetActive(const Value: Boolean);
begin
  FServer.Active:=Value;
end;

procedure TSimpleUDPServer.SetBufferSize(const Value: Integer);
begin
  FServer.Buffersize:=Value;
end;

procedure TSimpleUDPServer.SetOnInput(
  const Value: TServerHandleInputEvent);
begin
  FOnInput:=Value;
end;

procedure TSimpleUDPServer.SetPort(const Value: Integer);
begin
  FServer.DefaultPort:=Value;
end;

procedure TSimpleUDPServer.UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var BytesToRead:Integer;
var Command:integer;
var Stream:TMemoryStream;
begin
  AData.ReadBuffer(Command,SizeOf(Command));
  AData.ReadBuffer(BytesToRead,SizeOf(BytesToRead));

  if BytesToRead<>AData.Size-8 then
    raise Exception.Create('data size does not represent packet size!');

  Stream:=TMemoryStream.Create;
  try
    Stream.CopyFrom(AData,BytesToRead);
    Stream.Position:=0;
    ProcessCommand(ABinding,Command,Stream);
  finally
    Stream.Free;
  end;
end;

end.
