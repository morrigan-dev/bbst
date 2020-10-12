unit unitKeyboard;

interface

uses Windows;

type
  TArrowControl = record
    up, down, left, right : Boolean;
  end;

  TKeyboard = class

    private
      LastArrowControl : TArrowControl;
      CurrentArrowControl : TArrowControl;

    public
      constructor Create();
      destructor Destroy();

      procedure Update();
      function GetArrowControl : TArrowControl;

  end;


implementation

{ TKeyboard }

constructor TKeyboard.Create();
begin
  inherited Create();

end;

destructor TKeyboard.Destroy();
begin

  inherited Destroy();
end;

procedure TKeyboard.Update();
begin
  Self.CurrentArrowControl.up := GetAsyncKeyState(VK_UP) <> 0;
  Self.CurrentArrowControl.down := GetAsyncKeyState(VK_DOWN) <> 0;
  Self.CurrentArrowControl.left := GetAsyncKeyState(VK_LEFT) <> 0;
  Self.CurrentArrowControl.right := GetAsyncKeyState(VK_RIGHT) <> 0;
//  Self.CurrentArrowControl.up := GetAsyncKeyState(ord('W')) <> 0;
//  Self.CurrentArrowControl.down := GetAsyncKeyState(ord('S')) <> 0;
//  Self.CurrentArrowControl.left := GetAsyncKeyState(ord('A')) <> 0;
//  Self.CurrentArrowControl.right := GetAsyncKeyState(ord('D')) <> 0;
end;

function TKeyboard.GetArrowControl : TArrowControl;
begin
  Result := Self.CurrentArrowControl;
end;

end.
