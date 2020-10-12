{
  Quelle:
  - http://www.delphi-treff.de/tutorials/systemnahe-programmierung/mouse-und-tastatur-hooks/unser-erster-hook-die-tastatur/                                      *

  Siehe auch:
  - http://de.wikibooks.org/wiki/Programmierkurs:_Delphi:_DLL-Programmierung
}

library dprKeyboardHook;

uses
  Windows,
  Messages;

var
  HookHandle: Cardinal = 0;
  WindowHandle: Cardinal = 0;

function KeyboardHookProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM):
LRESULT; stdcall;
begin
//es ist ebenfalls möglich die Bearbeitung an eine Bedingung zu knüpfen
//it's possible to call CallNextHookEx conditional only.
  Result := CallNextHookEx(HookHandle, nCode, wParam, lParam);
  case nCode < 0 of
    TRUE: exit; //wenn code kleiner 0 wird nix gemacht
                //if code smaller 0 nothing has to be done
    FALSE:
      begin
//Hier kann jetzt alles bearbeitet werden
//Here one can work with the parameters
      end;
  end;
end;

function InstallHook(Hwnd: Cardinal): Boolean; stdcall;
begin
  Result := False;
  if HookHandle = 0 then begin
//Erstmal Hook installieren
//First install the hook
    HookHandle := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc,
    HInstance, 0);
//Uebergebenes Fensterhandle sichern
//Save the given window handle
    WindowHandle := Hwnd;
    Result := TRUE;
  end;
end;

function UninstallHook: Boolean; stdcall;
begin
//Hook aus der Hookchain entfernen
//Uninstall hook from hook chain
  Result := UnhookWindowsHookEx(HookHandle);
  HookHandle := 0;
end;

exports
//Installations- und Deinstallationsroutine exportieren
//Export the installation and deinstallation routine
  InstallHook,
  UninstallHook;
end.
