{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
{ *********************************************************************************************************************
  * K L A S S E : unitElement
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Copyright © 2010 by Thomas Gattinger
  * Datei     : unitElement.pas
  * Aufgabe   : Diese Klasse dient als Datenbehälter für alle Elemente aus denen der Roboterarm besteht. Sie wird im
  *             Objekt-Inspektor als aufklappbare Property angezeigt.
  *
  * Compiler  : Delphi 7.0
  * Aenderung : 07.05.2010
  *********************************************************************************************************************
}
unit unitElement;

interface

uses
  // Delphi Klassen
  Classes, Graphics, Dialogs, SysUtils,

  // OpenGL Klassen
  DGLOpenGL,
  
  // Eigene Klassen
  unitIOpenGL;

type

  TElement = class(TPersistent)

    private

      // Properties
     	Fcolor           : TColor;  // Farbe in der das Gitter des Elements gezeichnet wird
      Fdepth           : Real;    // Tiefe des Elements
      Fheight          : Real;    // Höhe des Elements
      Fwidth           : Real;    // Breite des Elements

    protected

      // Interne Eigenschaften
      owner            : IOpenGL;
      texture          : PGLUQuadric;
    
      procedure SetColorProperty(color: TColor);
      procedure SetDepthProperty(depth: Real);
      procedure SetHeightProperty(height: Real);
      procedure SetWidthProperty(width: Real);

    public

      constructor Create(owner: IOpenGL);
      destructor Destroy(); override;

      procedure SetTexture(texture : PGLUQuadric);
      function GetTexture() : PGLUQuadric;

    published

      property Color           : TColor read Fcolor           write SetColorProperty;
      property Depth           : Real   read Fdepth           write SetDepthProperty;
      property Height          : Real   read Fheight          write SetHeightProperty;
      property Width           : Real   read Fwidth           write SetWidthProperty;
      
  end;

implementation

// P U B L I C - M E T H O D E N
// =============================

constructor TElement.Create(owner: IOpenGL);
begin
  inherited Create;

  Self.owner := owner;
  Self.Fcolor := $0000CC00;
  Self.Fdepth := 0;
  Self.Fheight := 0;
  Self.Fwidth := 0;
end;

destructor TElement.Destroy();
begin
  inherited Destroy();
end;

procedure TElement.SetTexture(texture: PGLUQuadric);
begin
  if(Self.texture <> texture) then
  begin
    Self.texture := texture;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

function TElement.GetTExture() : PGLUQuadric;
begin
  result := texture;
end;


// P O T E C T E D - M E T H O D E N
// =================================


{ *********************************************************************************************************************
  * P R O C E D U R E : SetColorProperty
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Setter-Prozedur setzt die Farbe des Elements.
  * Parameter : color - Ein Farbwert vom Typ TColor.
  * Aenderung : 23.04.2010
  *********************************************************************************************************************
}
procedure TElement.SetColorProperty(color: TColor);
begin
  if(Self.Fcolor <> color) then
  begin
    Self.Fcolor := color;

//    syncViews();
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : SetDepthProperty
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Setter-Prozedur setzt die Tiefe des Elements.
  * Parameter : depth - Ein Kommawert, der die Tiefe angibt.
  * Aenderung : 23.04.2010
  *********************************************************************************************************************
}
procedure TElement.SetDepthProperty(depth: Real);
begin
  if(Self.Fdepth <> depth) then
  begin
    Self.Fdepth := depth;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : SetHeightProperty
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Setter-Prozedur setzt die Höhe des Elements.
  * Parameter : height - Ein Kommawert, der die Höhe angibt.
  * Aenderung : 23.04.2010
  *********************************************************************************************************************
}
procedure TElement.SetHeightProperty(height: Real);
begin
  if(Self.Fheight <> height) then
  begin
    Self.Fheight := height;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

{ *********************************************************************************************************************
  * P R O C E D U R E : SetWidthProperty
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Setter-Prozedur setzt die Breite des Elements.
  * Parameter : width - Ein Kommawert, der die Breite angibt.
  * Aenderung : 23.04.2010
  *********************************************************************************************************************
}
procedure TElement.SetWidthProperty(width: Real);
begin
  if(Self.Fwidth <> width) then
  begin
    Self.Fwidth := width;
    if(Self.owner <> nil) then
      Self.owner.Render();
  end;
end;

end.
