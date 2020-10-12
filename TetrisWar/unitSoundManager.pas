// BASS Homepage: http://www.un4seen.com/
unit unitSoundManager;

interface

uses
  Dialogs, SysUtils, ExtCtrls, Classes,

  Bass;

type
  TStringArray = Array of String;

  TSoundManager = class
    private
      AOwner          : TComponent;
      FlipSound       : HSAMPLE;
      MoveSound       : HSAMPLE;
      DropSound       : HSAMPLE;
      DeleteSound     : HSAMPLE;
      BackgroundMusic : HCHANNEL;

      MusicCount      : Byte;
      MusicPathArray  : TStringArray;

      MusicActivTimer : TTimer;

      procedure MusicActiveTimer(Sender: TObject);

    public
      constructor Create(AOwner: TComponent);
      destructor Destroy();

      procedure PlayBackgroundMusic(vol: Float);
      procedure PlayFlipSound(vol: Float);
      procedure PlayDelteSound(vol: Float);
      procedure PlayDropSound(vol: Float);
      procedure PlayMoveSound(vol: Float);
      procedure StopBackgroundMusic();

  end;

implementation

{************************************************
 *     P U B L I C - M E T H O D E N            *
 ************************************************}

{
  Dieser Konstruktor erzeugt eine neue Instanz dieser Klasse.
  Hier wird die bass.dll initialisiert und alle Spielgeräusche in den Speicher vorgeladen.
}
constructor TSoundManager.Create(AOwner: TComponent);
var
  Path : String;
begin
  // Bass.dll initialisieren
  if not BASS_Init(-1, 44100, 0, 0, nil) then
  begin
    ShowMessage('Can''t initialize sound.');
  end;

  Path := ExtractFilePath(ParamStr(0));
  // Load Wave-File
	FlipSound := BASS_SampleLoad(FALSE, PChar(Path + 'sounds\005.WAV'), 0, 0, 3, BASS_SAMPLE_OVER_POS {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
	DropSound := BASS_SampleLoad(FALSE, PChar(Path + 'sounds\002.WAV'), 0, 0, 3, BASS_SAMPLE_OVER_POS {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
	MoveSound := BASS_SampleLoad(FALSE, PChar(Path + 'sounds\049.WAV'), 0, 0, 3, BASS_SAMPLE_OVER_POS {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
	DeleteSound := BASS_SampleLoad(FALSE, PChar(Path + 'sounds\023.WAV'), 0, 0, 3, BASS_SAMPLE_OVER_POS {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});

  Self.MusicCount := 6;
  SetLength(MusicPathArray, Self.MusicCount);
  MusicPathArray[0] := Path + 'sounds\Basshunter - Tetris [Hard Trance Remix].mp3';
  MusicPathArray[1] := Path + 'sounds\Tetris Techno Remix.mp3';
  MusicPathArray[2] := Path + 'sounds\2pm - Tetris.mp3';
  MusicPathArray[3] := Path + 'sounds\AlexTomar - Tetris (Flute Remix 2009).mp3';
  MusicPathArray[4] := Path + 'sounds\Tetris Theme A on STL Purple Clay Double Ocarina.mp3';
  MusicPathArray[5] := Path + 'sounds\classical version of the tetris theme.mp3';

  Self.MusicActivTimer := TTimer.Create(Self.AOwner);
  Self.MusicActivTimer.OnTimer := MusicActiveTimer;
  Self.MusicActivTimer.Interval := 3000;
end;

{
  Diese Destruktor löscht diese Instanz und gibt den Speicher wieder frei.
  Es werden alle erzeugten Objekte, die Teil dieser Klasse sind wieder freigegeben und die
  bass.dll deinitialisieren.
}
destructor TSoundManager.Destroy;
begin
    // alles Freigeben
  if FlipSound <> 0 then
  begin
    BASS_ChannelStop(FlipSound); // muss man nich anhalten, ich machs
    BASS_StreamFree(FlipSound);
  end;

  if DropSound <> 0 then
  begin
    BASS_ChannelStop(DropSound); // muss man nich anhalten, ich machs
    BASS_StreamFree(DropSound);
  end;

  if MoveSound <> 0 then
  begin
    BASS_ChannelStop(MoveSound); // muss man nich anhalten, ich machs
    BASS_StreamFree(MoveSound);
  end;

  if DeleteSound <> 0 then
  begin
    BASS_ChannelStop(DeleteSound); // muss man nich anhalten, ich machs
    BASS_StreamFree(DeleteSound);
  end;

  // Bass.dll deinitialisieren
  BASS_Free;
end;

procedure TSoundManager.PlayBackgroundMusic(vol: Float);
var
  Music       : HSAMPLE;
  RandomIndex : Byte;
begin
  Randomize;
  RandomIndex := Random(Self.MusicCount);
	Music := BASS_SampleLoad(FALSE, PChar(Self.MusicPathArray[RandomIndex]), 0, 0, 3, BASS_SAMPLE_OVER_POS {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});

  Self.BackgroundMusic := BASS_SampleGetChannel(Music, False);
  BASS_ChannelSetAttribute(Self.BackgroundMusic, BASS_ATTRIB_VOL, 0.1);
  BASS_ChannelPlay(Self.BackgroundMusic, False);
end;

procedure TSoundManager.PlayFlipSound(vol: Float);
var
  ch : HCHANNEL;
begin
  ch := BASS_SampleGetChannel(Self.FlipSound, False);
  BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, vol);
  BASS_ChannelPlay(ch, False);
end;

procedure TSoundManager.PlayDelteSound(vol: Float);
var
  ch : HCHANNEL;
begin
  ch := BASS_SampleGetChannel(Self.DeleteSound, False);
  BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, vol);
  BASS_ChannelPlay(ch, False);
end;

procedure TSoundManager.PlayDropSound(vol: Float);
var
  ch : HCHANNEL;
begin
  ch := BASS_SampleGetChannel(Self.DropSound, False);
  BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, vol);
  BASS_ChannelPlay(ch, False);
end;

procedure TSoundManager.PlayMoveSound(vol: Float);
var
  ch : HCHANNEL;
begin
  ch := BASS_SampleGetChannel(Self.MoveSound, False);
  BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, vol);
  BASS_ChannelPlay(ch, False);
end;

procedure TSoundManager.StopBackgroundMusic();
begin
  if Self.BackgroundMusic <> 0 then
  begin
    BASS_ChannelStop(Self.BackgroundMusic);
    BASS_StreamFree(Self.BackgroundMusic);
  end;
end;

{************************************************
 *     P R I V A T E - M E T H O D E N          *
 ************************************************}

procedure TSoundManager.MusicActiveTimer(Sender: TObject);
begin
  if(BASS_ChannelIsActive(Self.BackgroundMusic) = BASS_ACTIVE_STOPPED) then
  begin
    PlayBackgroundMusic(0.1);
  end;
end;

end.
