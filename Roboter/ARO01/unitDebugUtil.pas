{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitDebugUtil;

interface

uses Classes, Types, SysUtils, Contnrs, Variants,

  // OpenGL Klassen
  DGLOpenGL, glBitmap,

  // log4D Klassen
  Log4D;


function debugTObjectVariables(names : TStringList; values : TObjectList) : String;
//function debugVariantVariables(names : TStringList; values : TList) : String;
function ShiftStateToString(s: TShiftState): string;

implementation

{
  Diese Funktion liefert zu allen bekannten Typen den Ihalt des Objektes.

  ~param obj Das Objekt, dessen Inhalt als String zurückgegeben werden soll
}
function toString(obj : TGLVectord3) : String;
var vector3d : TGLVectord3;
    LOG      : TLogLogger;
begin
  LOG := TLogLogger.GetLogger('toString');

  vector3d := obj;
    result := floattostr(vector3d[0]) + '|'
            + floattostr(vector3d[1]) + '|'
            + floattostr(vector3d[2]);

end;

function debugTObjectVariables(names : TStringList; values : TObjectList) : String;
var i      : Integer;
    logMsg : String;
begin
  logMsg := '';
  for i := 0 to names.Count - 1 do
  begin
//    logMsg := logMsg + chr(13) + chr(10) + inttostr(i) + ')' + names + ' = ' + values[i];
  end;

  result := logMsg;
end;

{function debugVariantVariables(names : TStringList; values : TList) : String;
var basicType  : Integer;
    logMsg     : String;
    x : TObject;
    i : Integer;
begin
  logMsg := '';
  x := TObject(values.Items[0]);
  for i := 0 to names.Count - 1 do
  begin
    basicType := VarType(varVar) and VarTypeMask;
    // Set a string to match the type
    case basicType of
      varEmpty     : logMsg := logMsg + '<Empty>';
      varNull      : logMsg := logMsg + '<Null>';
      varSmallInt  : logMsg := logMsg + '<SmallInt>';
      varInteger   : logMsg := logMsg + '<Integer> ' + inttostr(values.);
      varSingle    : logMsg := logMsg + '<Single>';
      varDouble    : logMsg := logMsg + '<Double>';
      varCurrency  : logMsg := logMsg + '<Curreny>';
      varDate      : logMsg := logMsg + '<Date>';
      varOleStr    : logMsg := logMsg + '<OleStr>';
      varDispatch  : logMsg := logMsg + '<Dispatch>';
      varError     : logMsg := logMsg + '<Error>';
      varBoolean   : logMsg := logMsg + '<Boolean>';
      varVariant   : logMsg := logMsg + '<Variant>';
      varUnknown   : logMsg := logMsg + '<Unknown>';
      varByte      : logMsg := logMsg + '<Byte>';
      varWord      : logMsg := logMsg + '<Word>';
      varLongWord  : logMsg := logMsg + '<LongWord>';
      varInt64     : logMsg := logMsg + '<Int64>';
      varStrArg    : logMsg := logMsg + '<StrArg>';
      varString    : logMsg := logMsg + '<String>';
      varAny       : logMsg := logMsg + '<Any>';
      varTypeMask  : logMsg := logMsg + '<TypeMask>';
    end;
  end;
end;
}

function ShiftStateToString(s: TShiftState): string;
const
  Shifts: array[0..2] of TShiftState = ([ssAlt], [ssShift], [ssCtrl]);
  strings: array[0..2] of string = ('ssAlt', 'ssShift', 'ssCtrl');
  formatStrings: array[boolean] of string = ('', '%s + ');
var
  i: byte;
begin
  result := '';
  for i := 0 to 2 do
    result := result + format(formatStrings[(Shifts[i] * s) <> []], [strings[i]]);
  delete(result, length(result) - 2, 2);
  result := '[' + result + ']';
end;

function PointToStr(point : TPoint) : String;
begin
  result := IntToStr(point.X) + '|' + IntToStr(point.Y);
end;


end.
