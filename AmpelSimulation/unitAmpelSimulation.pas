{ *********************************************************************************************************************
  * K L A S S E : AmpelSimulation
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Copyright ® 2009 by Thomas Gattinger
  * Datei     : unitAmpelSimulation.pas
  * Aufgabe   : Diese Unit beinhaltet die Steuerung für eine Ameplsteuerung einer Kreuzung. Gesteuert werden 4
  *             Autoampeln und 8 Fußgängerampeln. Die Autos können jedoch nur gradeaus fahren. Die Logik für links
  *             bzw. rechts Abbiegen ist nicht enthalten.
  * Compiler  : Delphi 7.0
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
{ P H A S E N - T A B E L L E
Phase	 Dauer	Autoampel (nord)	Autoampel (ost)	Autoampel (süd)	Autoampel (west)
0      2 Sec	aus	              aus	            aus	            aus
1      2 Sec	gelb	            gelb	          gelb	          gelb
2      2 Sec	rot	              rot	            rot	            rot
3      2 Sec	Gelb-rot	        rot	            Gelb-rot	      rot
4     10 Sec	grün	            rot	            grün	          rot
5      2 Sec	gelb	            rot	            gelb	          rot
6      2 Sec	rot	              rot	            rot	            rot
7      2 Sec	rot	              Gelb-rot	      rot	            Gelb-rot
8     10 Sec	rot	              grün	          rot	            grün
9      2 Sec	rot	              gelb	          rot	            gelb

Phase  Dauer  Fußgänger (nord)	Fußgänger (ost)	Fußgänger (süd)	Fußgänger (west)
0      2 Sec  aus	              aus	            aus	            aus
1      2 Sec  gelb	            gelb	          gelb	          gelb
2      2 Sec  rot	              rot	            rot	            rot
3      2 Sec  rot	              grün	          rot	            grün
4     10 Sec  rot	              grün	          rot	            grün
5      2 Sec  rot	              grün	          rot	            grün
6      2 Sec  rot	              rot	            rot	            rot
7      2 Sec  grün	            rot	            grün	          rot
8     10 Sec  grün	            rot	            grün	          rot
9      2 Sec  grün	            rot	            grün	          rot
}
unit unitAmpelSimulation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, unitAmpel, jpeg, StdCtrls;

type
  TfrmAmpelSimulation = class(TForm)
    imgKreuzung: TImage;
    ampCarSouth: TAmpel;
    ampCarNorth: TAmpel;
    ampCarWest: TAmpel;
    ampCarEast: TAmpel;
    ampWalkerEast1: TAmpel;
    ampWalkerEast2: TAmpel;
    ampWalkerWest2: TAmpel;
    ampWalkerWest1: TAmpel;
    ampWalkerNorth2: TAmpel;
    ampWalkerNorth1: TAmpel;
    ampWalkerSouth1: TAmpel;
    ampWalkerSouth2: TAmpel;
    timeAmpel: TTimer;
    btnStart: TButton;
    btnStop: TButton;
    btnExit: TButton;
    chkNightMode: TCheckBox;
    timeTime: TTimer;
    pnlTime: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure timeAmpelTimerTimer(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure timeTimeTimerTimer(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private-Deklarationen }
    phase: Byte;
    procedure ShowTime;
    procedure Reset;
    procedure setAllTrafficLights(trafficLightPhase: TPhase);
    procedure setCarTrafficLightsVertical(trafficLightPhase: TPhase);
    procedure setCarTrafficLightsHorizontal(trafficLightPhase: TPhase);
    procedure setWalkerTrafficLightsNorth(trafficLightPhase: TPhase);
    procedure setWalkerTrafficLightsEast(trafficLightPhase: TPhase);
    procedure setWalkerTrafficLightsSouth(trafficLightPhase: TPhase);
    procedure setWalkerTrafficLightsWest(trafficLightPhase: TPhase);
  public
    { Public-Deklarationen }
  end;

var
  frmAmpelSimulation: TfrmAmpelSimulation;

implementation

const
  second: Integer = 1000;

var
  phaseTime: array [0..9] of Word;
  nightMode: Boolean;
  hours: Byte;
  minutes: Byte;

{$R *.dfm}

{ *********************************************************************************************************************
  * P R O Z E D U R : FormCreate
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur initialisiert die Phasenzeiten und setzt alle Ampeln zurück.
  * Parameter : Sender - Object von dem das Ereignis kommt.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.FormCreate(Sender: TObject);
begin
  phaseTime[0] := 1 * second;
  phaseTime[1] := 1 * second;
  phaseTime[2] := 2 * second;
  phaseTime[3] := 2 * second;
  phaseTime[4] := 10 * second;
  phaseTime[5] := 2 * second;
  phaseTime[6] := 2 * second;
  phaseTime[7] := 2 * second;
  phaseTime[8] := 10 * second;
  phaseTime[9] := 2 * second;

  Reset;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : resetAllTrafficLights
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt alle Ampeln auf die Phase Offline, sodass die aus sind.
  * Parameter : keine
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.setAllTrafficLights(trafficLightPhase: TPhase);
begin
  phase := 0;
  ampCarSouth.Phase := trafficLightPhase;
  ampCarNorth.Phase := trafficLightPhase;
  ampCarWest.Phase := trafficLightPhase;
  ampCarEast.Phase := trafficLightPhase;
  ampWalkerEast1.Phase := trafficLightPhase;
  ampWalkerEast2.Phase := trafficLightPhase;
  ampWalkerWest1.Phase := trafficLightPhase;
  ampWalkerWest2.Phase := trafficLightPhase;
  ampWalkerNorth1.Phase := trafficLightPhase;
  ampWalkerNorth2.Phase := trafficLightPhase;
  ampWalkerSouth1.Phase := trafficLightPhase;
  ampWalkerSouth2.Phase := trafficLightPhase;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : Timer
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur beinhaltet die komplette Logik zum schalten der Ampel. Sie wird alle n Sekunden
  *             automatisch aufgerufen.
  * Parameter : Sender - Object von dem das Ereignis kommt.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.timeAmpelTimerTimer(Sender: TObject);
begin
  timeAmpel.Interval := phaseTime[phase];

  case (phase) of
    0: // alle Ampeln aus (Nachtmodus)
    begin
      setAllTrafficLights(phOffline);
      if(nightMode) then
        phase := 1
      else
        phase := 2;
    end;
    1: // AutoAmpeln blinken gelb (Nachtmodus)
    begin
      setCarTrafficLightsVertical(phYellow);
      setCarTrafficLightsHorizontal(phYellow);
      phase := 0
    end;
    2: // alle Ampeln rot
    begin
      setAllTrafficLights(phRed);
      if(nightMode) then
        phase := 0
      else
        phase := 3;
    end;
    3: // Nord <-> Süd Verkehr starten
    begin
      setCarTrafficLightsVertical(phRedYellow);
      setWalkerTrafficLightsEast(phGreen);
      setWalkerTrafficLightsWest(phGreen);
      if(nightMode) then
        phase := 0
      else
        phase := 4;
    end;
    4: // Nord <-> Süd Verkehr beibehalten
    begin
      setCarTrafficLightsVertical(phGreen);
      if(nightMode) then
        phase := 0
      else
        phase := 5;
    end;
    5: // Nord <-> Süd Verkehr anhalten
    begin
      setCarTrafficLightsVertical(phYellow);
      if(nightMode) then
        phase := 0
      else
        phase := 6;
    end;
    6: // alle Ampeln rot
    begin
      setAllTrafficLights(phRed);
      if(nightMode) then
        phase := 0
      else
        phase := 7;
    end;
    7: // West <-> Ost Verkehr starten
    begin
      setCarTrafficLightsHorizontal(phRedYellow);
      setWalkerTrafficLightsNorth(phGreen);
      setWalkerTrafficLightsSouth(phGreen);
      if(nightMode) then
        phase := 0
      else
        phase := 8;
    end;
    8: // West <-> Ost Verkehr beibehalten
    begin
      setCarTrafficLightsHorizontal(phGreen);
      if(nightMode) then
        phase := 0
      else
        phase := 9;
    end;
    9: // West <-> Ost Verkehr anhalten
    begin
      setCarTrafficLightsHorizontal(phYellow);
      if(nightMode) then
        phase := 0
      else
        phase := 2;
    end;
  end;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : Click
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur startet die Simulation.
  * Parameter : Sender - Gibt das Object an, von dem das Ereignis stammt.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.btnStartClick(Sender: TObject);
begin
  phase := 0;
  timeAmpel.Interval := phaseTime[phase];
  timeTime.Interval := second div 10;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : setCarTrafficLightsVertical
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt die Phase für die nördliche und südliche Autoampel.
  * Parameter : trafficLightPhase - Gibt die Ampelphase an auf die die Ampel gesetzt werden soll.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.setCarTrafficLightsVertical(trafficLightPhase: TPhase);
begin
  ampCarNorth.Phase := trafficLightPhase;
  ampCarSouth.Phase := trafficLightPhase;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : setCarTrafficLightsHorizontal
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt die Phase für die westliche und östliche Autoampel.
  * Parameter : trafficLightPhase - Gibt die Ampelphase an auf die die Ampel gesetzt werden soll.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.setCarTrafficLightsHorizontal(trafficLightPhase: TPhase);
begin
  ampCarWest.Phase := trafficLightPhase;
  ampCarEast.Phase := trafficLightPhase;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : setWalkerTrafficLightsNorth
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt die Phase für die nördlichen Fußgängerampeln.
  * Parameter : trafficLightPhase - Gibt die Ampelphase an auf die die Ampel gesetzt werden soll.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.setWalkerTrafficLightsNorth(trafficLightPhase: TPhase);
begin
  ampWalkerNorth1.Phase := trafficLightPhase;
  ampWalkerNorth2.Phase := trafficLightPhase;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : setWalkerTrafficLightsEast
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt die Phase für die östlichen Fußgängerampeln.
  * Parameter : trafficLightPhase - Gibt die Ampelphase an auf die die Ampel gesetzt werden soll.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.setWalkerTrafficLightsEast(trafficLightPhase: TPhase);
begin
  ampWalkerEast1.Phase := trafficLightPhase;
  ampWalkerEast2.Phase := trafficLightPhase;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : setWalkerTrafficLightsSouth
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt die Phase für die südlichen Fußgängerampeln.
  * Parameter : trafficLightPhase - Gibt die Ampelphase an auf die die Ampel gesetzt werden soll.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.setWalkerTrafficLightsSouth(trafficLightPhase: TPhase);
begin
  ampWalkerSouth1.Phase := trafficLightPhase;
  ampWalkerSouth2.Phase := trafficLightPhase;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : setWalkerTrafficLightsWest
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt die Phase für die westlichen Fußgängerampeln.
  * Parameter : trafficLightPhase - Gibt die Ampelphase an auf die die Ampel gesetzt werden soll.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.setWalkerTrafficLightsWest(trafficLightPhase: TPhase);
begin
  ampWalkerWest1.Phase := trafficLightPhase;
  ampWalkerWest2.Phase := trafficLightPhase;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : Timer
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur aktualisiert die Uhrzeit und setzt in Abhängigkeit der Uhrzeit und dem Haken des
  *             Nachmodus den nightMode.
  * Parameter : Sender - Gibt das Object an, von dem das Ereignis stammt.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.timeTimeTimerTimer(Sender: TObject);
begin
  minutes := minutes + 1;
  if(minutes = 60) then
  begin
    minutes := 0;
    hours := hours + 1;
  end;

  if(hours = 24) then
    hours := 0;

  ShowTime;

  if(chkNightMode.Checked) and (hours >= 0) and (hours < 6) then
  begin
    if(nightMode = False) then
    begin
      nightMode := True;
      timeAmpel.Interval := 1;
    end;
  end
  else
  begin
    if(nightMOde = True) then
    begin
      nightMode := False;
      timeAmpel.Interval := 1;
    end;
  end;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : Click
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur hällt die Simulation an.
  * Parameter : Sender - Gibt das Object an, von dem das Ereignis stammt.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.btnStopClick(Sender: TObject);
begin
  Reset;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : Click
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur beendet das Simulationsprogramm
  * Parameter : Sender - Gibt das Object an, von dem das Ereignis stammt.
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.btnExitClick(Sender: TObject);
begin
  close;
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : ShowTime
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur zeigt die Zeit an
  * Parameter : keine
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.ShowTime;
var minutesFiller: String;
    hoursFiller: String;
begin
  if(Length(IntToStr(minutes)) = 1) then
    minutesFiller := '0'
  else
    minutesFiller := '';

  if(Length(IntToStr(hours)) = 1) then
    hoursFiller := '0'
  else
    hoursFiller := '';

  pnlTime.Caption := 'Zeit: ' + hoursFiller + IntToStr(hours) + ':' + minutesFiller + IntToStr(minutes);
end;

{ *********************************************************************************************************************
  * P R O Z E D U R : Reset
  *--------------------------------------------------------------------------------------------------------------------
  * Version   : 1.0
  * Autor     : Thomas Gattinger
  * Aufgabe   : Diese Prozedur setzt alle Variablen und Ampeln zurück.
  * Parameter : keine
  * Aenderung : 30.11.2009
  *********************************************************************************************************************
}
procedure TfrmAmpelSimulation.Reset;
begin
  timeAmpel.Interval := 0;
  timeTime.Interval := 0;
  phase := 0;
  setAllTrafficLights(phOffline);
  nightMode := False;
  hours :=  8;
  minutes := 0;
  ShowTime;
end;

end.
