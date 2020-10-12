//----------------------------------------------------------------------------
//
// Author      : Jan Horn
// Email       : jhorn@global.co.za
// Website     : http://www.sulaco.co.za
//               http://home.global.co.za/~jhorn
// Version     : 1.02
// Date        : 1 May 2001
// Changes     : 2 October - Added support for 32bit TGA files
//               28 July   - Faster BGR to RGB swapping routine
//
// Description : A unit that used with OpenGL projects to load BMP, JPG and TGA
//               files from the disk or a resource file.
// Usage       : LoadTexture(Filename, TextureName, LoadFromResource);
//
//               eg : LoadTexture('logo.jpg', LogoTex, TRUE);
//                    will load a JPG texture from the resource included
//                    with the EXE. File has to be loaded into the Resource
//                    using this format  "logo JPEG logo.jpg"
//
//----------------------------------------------------------------------------
unit Textures;

interface

uses
  Windows, OpenGL, Graphics, Classes, JPEG, SysUtils;

procedure LoadBMPTextureFromStream(Stream : TStream; var Texture:GLuint);
function LoadTexture(Filename: String; var Texture: GLuint; LoadFromRes : Boolean): Boolean;

implementation


function gluBuild2DMipmaps(Target: GLenum; Components, Width, Height: GLint; Format, atype: GLenum; Data: Pointer): GLint; stdcall; external glu32;
procedure glGenTextures(n: GLsizei; var textures: GLuint); stdcall; external opengl32;
procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;


{------------------------------------------------------------------}
{  Swap bitmap format from BGR to RGB                              }
{------------------------------------------------------------------}
procedure SwapRGB3(data : Pointer; Size : Integer);
asm
  mov ebx, eax
  mov ecx, size

@@loop :
  mov al,[ebx+0]
  mov ah,[ebx+2]
  mov [ebx+2],al
  mov [ebx+0],ah
  add ebx,3
  dec ecx
  jnz @@loop
end;

procedure SwapRGB4(data : Pointer; Size : Integer);
asm
  mov ebx, eax
  mov ecx, size
  mov edx, [ebx]
@@loop :
  cmp edx,[ebx]
  jnz @@NotTrans
  mov al, 0
  jmp @@SetAlpha
@@NotTrans:
  mov al,255
@@SetAlpha:
  mov [ebx+3],al

  mov al,[ebx+0]
  mov ah,[ebx+2]
  mov [ebx+2],al
  mov [ebx+0],ah
  add ebx,4
  dec ecx
  jnz @@loop
end;


{------------------------------------------------------------------}
{  Create the Texture                                              }
{------------------------------------------------------------------}
function CreateTexture(Width, Height, Format : Word; pData : Pointer) : Integer;
var
  Texture : GLuint;
begin
  glGenTextures(1, Texture);
  glBindTexture(GL_TEXTURE_2D, Texture);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);  {Texture blends with object background}
//  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);  {Texture does NOT blend with object background}

  { Select a filtering type. BiLinear filtering produces very good results with little performance impact
    GL_NEAREST               - Basic texture (grainy looking texture)
    GL_LINEAR                - BiLinear filtering
    GL_LINEAR_MIPMAP_NEAREST - Basic mipmapped texture
    GL_LINEAR_MIPMAP_LINEAR  - BiLinear Mipmapped texture
  }

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); { only first two can be used }
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); { all of the above can be used }

  if Format = GL_RGBA then
    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, pData)
  else
    gluBuild2DMipmaps(GL_TEXTURE_2D, 3, Width, Height, GL_RGB, GL_UNSIGNED_BYTE, pData);
//  glTexImage2D(GL_TEXTURE_2D, 0, 3, Width, Height, 0, GL_RGB, GL_UNSIGNED_BYTE, pData);  // Use when not wanting mipmaps to be built by openGL

  result :=Texture;
end;


{------------------------------------------------------------------}
{  Load BMP textures                                               }
{------------------------------------------------------------------}
procedure LoadBMPTextureFromStream(Stream : TStream; var Texture:GLuint);
var
  FileHeader: BITMAPFILEHEADER;
  InfoHeader: BITMAPINFOHEADER;
  Palette: array of RGBQUAD;
  BitmapLength: LongWord;
  PaletteLength: LongWord;
  Width, Height : Integer;
  pData : Pointer;
  p,j,ExpandBMP,Rmask,Gmask,Bmask : Integer;
  Format : Word;
begin
   Stream.ReadBuffer(FileHeader, SizeOf(FileHeader));  // FileHeader
   Stream.ReadBuffer(InfoHeader, SizeOf(InfoHeader));  // InfoHeader
   PaletteLength := InfoHeader.biClrUsed;
   case InfoHeader.biBitCount of
   1,4:
   begin
    ExpandBMP := InfoHeader.biBitCount;
    InfoHeader.biBitCount := 8;
   end;
   else
    ExpandBMP := 0;
   end;
   case InfoHeader.biCompression of
   0: // BI_RGB
      begin
        case InfoHeader.biBitCount of
        15,16: begin Rmask := $7c00; GMask := $03e0; BMask := $001f; end;
        // assuming big endian
        24: begin Rmask := $ff; GMask := $ff00; Bmask := $ff0000; end;
        32: begin Rmask := $ff0000; Gmask := $ff00; Bmask := $ff; end;
        end;
      end;
   1, // BI_RLE8
   2: // BI_RLE4
      raise EInvalidGraphic.create('Compressed Bitmaps not handled');
   3: // BI_BitFields
      begin
        case InfoHeader.biBitCount of
        15,16,32: begin
                    Stream.ReadBuffer(Rmask,sizeof(Rmask));
                    Stream.ReadBuffer(Gmask,sizeof(Gmask));
                    Stream.ReadBuffer(Bmask,sizeof(Bmask));
                  end;
        end;
      end;
   end;
   if (InfoHeader.biBitCount=24) then
    Format := GL_RGB
   else
    Format := GL_RGBA;

   SetLength(Palette, PaletteLength);
   Stream.ReadBuffer(Palette, PaletteLength);          // Palette
   Width := InfoHeader.biWidth;
   Height := InfoHeader.biHeight;

   BitmapLength := InfoHeader.biSizeImage;
   if BitmapLength = 0 then
     BitmapLength := Width * Height * InfoHeader.biBitCount Div 8;
   GetMem(pData, BitmapLength);
   try
     Stream.ReadBuffer(pData^, BitmapLength);            // Bitmap Data
  // Bitmaps are stored BGR and not RGB, so swap the R and B bytes.
    if (Rmask<>$ff0000) then
        SwapRGB3(pData, Width*Height);
    if (InfoHeader.biBitCount=32) then
    begin
      SwapRGB4(pData,Width*Height);
    end;
    Texture :=CreateTexture(Width, Height, format, pData);
  finally
    FreeMem(pData);
  end;
end;


function LoadBMPTexture(Filename: String; var Texture : GLuint; LoadFromResource : Boolean) : Boolean;
var
  FileHeader: BITMAPFILEHEADER;
  InfoHeader: BITMAPINFOHEADER;
  Palette: array of RGBQUAD;
  BitmapFile: THandle;
  BitmapLength: LongWord;
  PaletteLength: LongWord;
  ReadBytes: LongWord;
  Width, Height : Integer;
  pData : Pointer;

  // used for loading from resource
  ResStream : TResourceStream;
  FStream : TFileStream;
begin
  result :=FALSE;

  if LoadFromResource then // Load from resource
  begin
      ResStream := TResourceStream.Create(hInstance,
                        PChar(copy(Filename, 1, Pos('.', Filename)-1)), 'BMP');
    try
      try
        LoadBMPTextureFromStream(ResStream,Texture);
      except on
        EResNotFound do
        begin
          MessageBox(0, PChar('File not found in resource - ' + Filename), PChar('BMP Texture'), MB_OK);
          Exit;
        end
        else
        begin
          MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('BMP Unit'), MB_OK);
          Exit;
        end
      end
   finally
      ResStream.Free;
    end;
  end
  else
  begin   // Load image from file
    FStream := TFileStream.Create(Filename,fmOpenRead);
    try
      LoadBMPTextureFromStream(FStream,Texture);
    finally
      FStream.Free;
    end;
  end;
  result :=TRUE;
end;


{------------------------------------------------------------------}
{  Load JPEG textures                                              }
{------------------------------------------------------------------}
function LoadJPGTexture(Filename: String; var Texture: GLuint; LoadFromResource : Boolean): Boolean;
var
  JPG : TJPEGImage;
  BMP : TBitmap;
  MStream : TMemoryStream;
  ResStream : TResourceStream;      // used for loading from resource
begin
  result :=FALSE;
  JPG:=TJPEGImage.Create;
  if LoadFromResource then // Load from resource
  begin
    try
      ResStream := TResourceStream.Create(hInstance, PChar(copy(Filename, 1, Pos('.', Filename)-1)), 'JPEG');
      JPG.LoadFromStream(ResStream);
      ResStream.Free;
    except on
      EResNotFound do
      begin
        MessageBox(0, PChar('File not found in resource - ' + Filename), PChar('JPG Texture'), MB_OK);
        Exit;
      end
      else
      begin
        MessageBox(0, PChar('Couldn''t load JPG Resource - "'+ Filename +'"'), PChar('BMP Unit'), MB_OK);
        Exit;
      end;
    end;
  end
  else
  begin
    try
      JPG.LoadFromFile(Filename);
    except
      MessageBox(0, PChar('Couldn''t load JPG - "'+ Filename +'"'), PChar('BMP Unit'), MB_OK);
      Exit;
    end;
  end;

  // Create Bitmap
  BMP:=TBitmap.Create;
  try
  BMP.pixelformat:=pf32bit;
  BMP.width:=JPG.width;
  BMP.height:=JPG.height;
  BMP.canvas.draw(0,0,JPG);        // Copy the JPEG onto the Bitmap
    try
      MStream := TMemoryStream.Create;
      BMP.TransparentMode := tmAuto;
      BMP.PixelFormat :=  pf24bit;  // just because this format works!
      BMP.Dormant;                  // make it so!
      BMP.SaveToStream(MStream);
      MStream.Seek(0,soFromBeginning);
      LoadBMPTextureFromStream(MStream, Texture);
    finally
      MStream.free;
    end;
  finally
    BMP.Free;
  end;
  result :=TRUE;
end;


{------------------------------------------------------------------}
{  Loads 24 and 32bpp (alpha channel) TGA textures                 }
{------------------------------------------------------------------}
function LoadTGATexture(Filename: String; var Texture: GLuint; LoadFromResource : Boolean): Boolean;
var
  TGAHeader : packed record   // Header type for TGA images
    FileType     : Byte;
    ColorMapType : Byte;
    ImageType    : Byte;
    ColorMapSpec : Array[0..4] of Byte;
    OrigX  : Array [0..1] of Byte;
    OrigY  : Array [0..1] of Byte;
    Width  : Array [0..1] of Byte;
    Height : Array [0..1] of Byte;
    BPP    : Byte;
    ImageInfo : Byte;
  end;
  TGAFile   : File;
  bytesRead : Integer;
  image     : Pointer;    {or PRGBTRIPLE}
  Width, Height : Integer;
  ColorDepth    : Integer;
  ImageSize     : Integer;
  I : Integer;
  Front: ^Byte;
  Back: ^Byte;
  Temp: Byte;
  NumBytes : Integer;
  ResStream : TResourceStream;      // used for loading from resource
begin
  result :=FALSE;
  GetMem(Image, 0);
  if LoadFromResource then // Load from resource
  begin
    try
      ResStream := TResourceStream.Create(hInstance, PChar(copy(Filename, 1, Pos('.', Filename)-1)), 'TGA');
      ResStream.ReadBuffer(TGAHeader, SizeOf(TGAHeader));  // FileHeader
      result :=TRUE;
    except on
      EResNotFound do
      begin
        MessageBox(0, PChar('File not found in resource - ' + Filename), PChar('TGA Texture'), MB_OK);
        Exit;
      end
      else
      begin
        MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('BMP Unit'), MB_OK);
        Exit;
      end;
    end;
  end
  else
  begin
    if FileExists(Filename) then
    begin
      AssignFile(TGAFile, Filename);
      Reset(TGAFile, 1);

      // Read in the bitmap file header
      BlockRead(TGAFile, TGAHeader, SizeOf(TGAHeader));
      result :=TRUE;
    end
    else
    begin
      MessageBox(0, PChar('File not found  - ' + Filename), PChar('TGA Texture'), MB_OK);
      Exit;
    end;
  end;

  if Result = TRUE then
  begin
    Result :=FALSE;

    // Only support uncompressed images
    if (TGAHeader.ImageType <> 2) then  { TGA_RGB }
    begin
      Result := False;
      CloseFile(tgaFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Compressed TGA files not supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    // Don't support colormapped files
    if TGAHeader.ColorMapType <> 0 then
    begin
      Result := False;
      CloseFile(TGAFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Colormapped TGA files not supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    // Get the width, height, and color depth
    Width  := TGAHeader.Width[0]  + TGAHeader.Width[1]  * 256;
    Height := TGAHeader.Height[0] + TGAHeader.Height[1] * 256;
    ColorDepth := TGAHeader.BPP;
    ImageSize  := Width*Height*(ColorDepth div 8);

    if ColorDepth < 24 then
    begin
      Result := False;
      CloseFile(TGAFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Only 24 bit TGA files supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    GetMem(Image, ImageSize);

    if LoadFromResource then // Load from resource
    begin
      try
        ResStream.ReadBuffer(Image^, ImageSize);
        ResStream.Free;
      except
        MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('BMP Unit'), MB_OK);
        Exit;
      end;
    end
    else         // Read in the image from file
    begin
      BlockRead(TGAFile, image^, ImageSize, bytesRead);
      if bytesRead <> ImageSize then
      begin
        Result := False;
        CloseFile(TGAFile);
        MessageBox(0, PChar('Couldn''t read file "'+ Filename +'".'), PChar('TGA File Error'), MB_OK);
        Exit;
      end;
    end;
  end;

  // TGAs are stored BGR and not RGB, so swap the R and B bytes.
  // 32 bit TGA files have alpha channel and gets loaded differently
  if TGAHeader.BPP = 24 then
    NumBytes := 3
  else
    NumBytes := 4;

  for I :=0 to Width * Height - 1 do
  begin
   Front := Pointer(Integer(Image) + I*NumBytes);
   Back := Pointer(Integer(Image) + I*NumBytes + 2);
   Temp := Front^;
   Front^ := Back^;
   Back^ := Temp;
  end;
  if TGAHeader.BPP = 24 then
    Texture :=CreateTexture(Width, Height, GL_RGB, Image)
  else
    Texture :=CreateTexture(Width, Height, GL_RGBA, Image);
  Result :=TRUE;
  FreeMem(Image);
end;


{------------------------------------------------------------------}
{  Determines file type and sends to correct function              }
{------------------------------------------------------------------}
function LoadTexture(Filename: String; var Texture : GLuint; LoadFromRes : Boolean) : Boolean;
begin
  if copy(Uppercase(filename), length(filename)-3, 4) = '.BMP' then
    LoadBMPTexture(Filename, Texture, LoadFromRes);
  if copy(Uppercase(filename), length(filename)-3, 4) = '.JPG' then
    LoadJPGTexture(Filename, Texture, LoadFromRes);
  if copy(Uppercase(filename), length(filename)-3, 4) = '.TGA' then
    LoadTGATexture(Filename, Texture, LoadFromRes);
end;


end.
