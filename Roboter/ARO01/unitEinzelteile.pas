{
    Dieses Werk und alle dazugehörigen wurden unter folgender Lizenz veröffentlicht:
	
	Creative Commons
    Namensnennung - Keine kommerzielle Nutzung - Weitergabe unter gleichen Bedingungen 3.0 Deutschland
	
	Der ausführliche und rechtsverbindliche Lizenzvertrag liegt im root-Verzeichnis
	und ist unter dem Namen "licence.htm" zu finden.
}
unit unitEinzelteile;

interface

uses
  // Delphi klassen
  Graphics, SysUtils, Classes, Contnrs,

  // OpenGL Klassen
  DGLOpenGL, glBMP,

  // log4D Klassen
  Log4D,

  // Eigene Klassen
  unitOpenGLConfigUtil, unitDebugUtil;

const
  SHOW_START_POINT = false;
  HIGHLIGHT_COLOR : Array[0..2] of Integer = (1, 0, 0);

  CORRECTION_DISTANCE = 0.05;    // Korrekturabstand zur nächsten Fläche, um Grafikfehler zu vermeiden

  ASB09_DEPTH = 24.61;                           // Tiefe des Elements in mm
  ASB09_THICKNESS = 1.52;                        // Dicke des Elements in mm
  ASB09_HOLE_STACKS = 5;                         // Stacks für alle Löcher
  ASB09_CENTER_HOLE_RADIUS = 4.0;                // Radius des mittleren Lochs der unteren Platte in mm
  ASB09_CENTER_HOLE_SLICES = 30;                 // Slices für das mittlere Loch
  ASB09_CENTER_HOLE_LOOPS = 15;                  // Loops für das mittlere Loch
  ASB09_SMALL_HOLE_RADIUS = 1.195;               // Radius der kleinen Löcher der unteren Platte in mm
  ASB09_SMALL_HOLE_SLICES = 15;                  // Slices für die Schraubenlöcher
  ASB09_SMALL_HOLE_LOOPS = 5;                    // Loops für die Schraubenlöcher
  ASB09_SMALL_HOLE_DISTANCE = 8.33;              // Abstand der kleinen Löcher von der Mittelsenkrechten in mm
  ASB09_BOTTOM_BOARD_WIDTH = 49.2;               // Breite der unteren Platte in mm
  ASB09_SIDE_BOARD_HEIGHT = 31.78;               // Höhe der Seitenwand in mm
  ASB09_SIDE_BOARD_TOP_RADIUS = ASB09_DEPTH / 2; // Radius des oberen Teils der Seitenwand in mm
  ASB09_SIDE_BOARD_TOP_SLICES = 30;              // Slices für die Halbzylinder der Seitenteile
  ASB09_SIDE_BOARD_TOP_STACKS = 5;               // Stacks für die Halbzylinder der Seitenteile
  ASB09_SIDE_BOARD_TOP_LOOPS = 15;               // Loops für die Halbzylinder der Seitenteile

  ASB10_DEPTH = 24.61;                           // Tiefe des Elements in mm
  ASB10_THICKNESS = 1.52;                        // Dicke des Elements in mm
  ASB10_HOLE_STACKS = 5;                         // Stacks für alle Löcher
  ASB10_CENTER_HOLE_RADIUS = 4.0;                // Radius des mittleren Lochs der unteren Platte in mm
  ASB10_CENTER_HOLE_SLICES = 30;                 // Slices für das mittlere Loch
  ASB10_CENTER_HOLE_LOOPS = 15;                  // Loops für das mittlere Loch
  ASB10_SMALL_HOLE_RADIUS = 1.195;               // Radius der kleinen Löcher der unteren Platte in mm
  ASB10_SMALL_HOLE_SLICES = 15;                  // Slices für die Schraubenlöcher
  ASB10_SMALL_HOLE_LOOPS = 5;                    // Loops für die Schraubenlöcher
  ASB10_SMALL_HOLE_DISTANCE = 8.33;              // Abstand der kleinen Löcher von der Mittelsenkrechten in mm
  ASB10_BOTTOM_BOARD_WIDTH = 49.2;               // Breite der unteren Platte in mm
  ASB10_SIDE_BOARD_HEIGHT = 44.27;               // Höhe der Seitenwand in mm
  ASB10_SIDE_BOARD_TOP_RADIUS = ASB10_DEPTH / 2; // Radius des oberen Teils der Seitenwand in mm
  ASB10_SIDE_BOARD_TOP_SLICES = 30;              // Slices für die Halbzylinder der Seitenteile
  ASB10_SIDE_BOARD_TOP_STACKS = 5;               // Stacks für die Halbzylinder der Seitenteile
  ASB10_SIDE_BOARD_TOP_LOOPS = 15;               // Loops für die Halbzylinder der Seitenteile

  ASB13_THICKNESS = 1.59;                   // Dicke der Platten
  ASB13_BOTTOM_SIDE1_WIDTH = 48.72;         // Breite der hinteren und vorderen Platten, die in die Vertikale übergehen
  ASB13_BOTTOM_SIDE2_WIDTH = 44.42;         // Breite des kleinen Quaders zwichen dem hinteren und dem mittleren Quader
  ASB13_BOOTOM_SIDE2_DEPTH = 2.43;          // Tiefe des kleinen Quaders zwichen dem hinteren und dem mittleren Quader
  ASB13_SIDE1_DEPTH = 7.95;                 // Tiefe der hinteren und vorderen Platten und der vertikalen Platten
  ASB13_SIDE1_HEIGHT = 21.98;               // Höhe der vertikalen Platten
  ASB13_MIDDLE_WIDTH = 60.33;               // Breite der mittleren Platte
  ASB13_MIDDLE_DEPTH = 34.90;               // Tiefe der mittleren Platte
  ASB13_BOTTOM_CENTER_HOLE_RADIUS = 4;      // Radius des unteren mittleren Lochs
  ASB13_BOTTOM_SMALL_HOLE_RADIUS = 1.195;   // Radius der unteren kleinen Löcher
  ASB13_BOTTOM_SMALL_HOLE_DISTANCE = 8.33;  // Abstand der kleinen Löcher zum mittleren Loch
  ASB13_BOTTOM_HOLE_LEFT_DIST = 12.29;      // Abstand des unteren Lochs zum linken Rand
  ASB13_BOTTOM_HOLE_BACK_DIST = 17.25;      // Abstand des unteren Lochs zum hinteren Rand
  ASB13_SIDE_HOLE_RADIUS = 2.185;           // Radius der seitlichen Löcher
  ASB13_SIDE_BOTTOM_HOLE_DIST = 7.10;       // Abstand des unteren Lochs der vertikalen Platten zum unteren Rand
  ASB13_SIDE_TOP_HOLE_DIST = 9.80;          // Abstand des unteren Lochs der vertikalen Platten zum unteren Loch
  ASB13_MIDDLE_SIDE_DISTANCE = 6.06;        // Abstand in der Breite von der mittleren zur seitlichen Platte
  ASB13_SIDE1_SIDE2_DISTANCE = 2.41;        // Abstand in der Breite seitlichen zur schmallen Trennplatte
  ASB13_MIDDLE_SIDE2_DISTANCE = 7.95;       // Abstand in der Breite von der mittleren zur schmallen Trennplatte

  ASB14_THICKNESS = 1.52;                // Dicke des Teils
  ASB14_LEFT_INNER_RADIUS = 4;           // Innenradius der linken Befestigungsscheibe
  ASB14_LEFT_OUTER_RADIUS = 12.31;       // Außenradius der linken Befestigungsscheibe
  ASB14_LEFT_SMALL_HOLE_RADIUS = 1.195;  // Radius der linken Schraubenlöcher
  ASB14_LEFT_SMALL_HOLE_DIST = 8.33;     // Abstand der Schraubenlöcher zum mittleren Loch
  ASB14_LEFT_QUADER_WIDTH = 22.14;       // Breite des linken Quaders
  ASB14_LEFT_QUADER_HEIGHT = 24.61;      // Höhe des linken Quaders
  ASB14_LEFT_MIDDLE1_DISTANCE = 4.37;    // Abstand der linken Seite zur Mittleren in Bezug auf die Höhe
  ASB14_MIDDLE1_QUADER_WIDTH = 3.18;     // Breite des linken Teils des mittleren Quaders auf dem die Rundung sitzt
  ASB14_MIDDLE1_QUADER_HEIGHT = 51.44;   // Höhe des linken Teils des mittleren Quaders auf dem die Rundung sitzt
  ASB14_MIDDLE2_QUADER_WIDTH = 3.96;     // Breite des rechten Teils des mittleren Quaders
  ASB14_MIDDLE2_QUADER_HEIGHT = 57.79;   // Höhe des rechten Teils des mittleren Quaders
  ASB14_TD_QUAD1_WIDTH = 9.12;           // Breite des ersten Quaders der Servohalterung
  ASB14_TD_QUAD1_HEIGHT = 9.53;          // Höhe des ersten Quaders der Servohalterung
  ASB14_TD_QUAD2_WIDTH = 3.63;           // Breite des zweiten Quaders der Servohalterung
  ASB14_TD_QUAD2_HEIGHT = 3.58;          // Höhe des zweiten Quaders der Servohalterung
  ASB14_TD_QUAD3_WIDTH = 5.95;           // Breite des dritten Quaders der Servohalterung
  ASB14_TD_QUAD3_HEIGHT = 3.58;          // Höhe des dritten Quaders der Servohalterung
  ASB14_TD_QUAD4_WIDTH = 5.95;           // Breite des vierten Quaders der Servohalterung
  ASB14_TD_QUAD4_HEIGHT = 5.94;          // Höhe des vierten Quaders der Servohalterung
  ASB14_TD_QUAD5_WIDTH = 3.58;           // Breite des fünften Quaders der Servohalterung
  ASB14_TD_QUAD5_HEIGHT = 5.94;          // Höhe des fünften Quaders der Servohalterung

  BBH01_HEIGHT = 3.18;            // Höhe der Scheibe in mm
  BBH01_CENTER_IN_RADIUS = 1.59;  // Innenradius der inneren abgesenkten Scheibe in mm
  BBH01_CENTER_HEIGHT = 1.98;     // Höhe der inneren abgesenkten Scheibe in mm
  BBH01_CENTER_STACKS = 4;        // Stacks für die abgesenkte Scheibe
  BBH01_CENTER_LOOPS = 5;         // Loops für die abgesenkte Scheibe
  BBH01_MAIN_IN_RADIUS = 3.57;    // Innenradius der Hautscheibe in mm
  BBH01_MAIN_OUT_RADIUS = 11.915; // Außenradius der Hauptscheibe in mm
  BBH01_MAIN_SLICES = 30;         // Slices für die Hauptscheibe
  BBH01_MAIN_STACKS = 5;          // Stacks für die Hauptscheibe
  BBH01_MAIN_LOOPS = 15;          // Loops für die Hauptscheibe
  BBH01_HOLES_RADIUS = 1.195;     // Radius der Schraubenlöcher in mm
  BBH01_HOLES_DISTANCE = 8.33;    // Abstand der Schraubenlöcher Mittelpunkte zum Hauptschreibenmittelpunkt in mm
  BBH01_HOLES_SLICES = 15;        // Slices für die Schraubenlöcher
  BBH01_HOLES_LOOPS = 5;          // Loops für die Schraubenlöcher

  DT_CENTER_RADIUS = 50.0;           // Breite des Drehtellers in mm
  DT_CENTER_HEIGHT = 5.0;            // Höhe des Drehtellers in mm
  DT_CENTER_HOLE_RADIUS = 4.0;       // Radius des mittleren Lochs der Scheibe in mm
  DT_TOP_RING_OUTER_RADIUS = 4.0;    // Außenradius des Rings auf der Scheibe in mm
  DT_TOP_RING_INNER_RADIUS = 3.0;    // Innenradius des Rings auf der Scheibe in mm
  DT_TOP_RING_HEIGHT = 1.0;          // Höhe des Rings auf der Scheibe in mm
  DT_SMALL_HOLE_RADIUS = 1.195;      // Radius der kleineren Löcher der Scheibe in mm
  DT_SMALL_HOLE_DISTANCE = 8.33;     // Abstand der kleinen Löcher zum Mittelpunkt
  DT_BOTTOM_RING_OUTER_RADIUS = 5.0; // Außenradius des Rings unter der Scheibe in mm
  DT_BOTTOM_RING_INNER_RADIUS = 4.0; // Innenradius des Rings unter der Scheibe in mm
  DT_BOTTOM_RING_HEIGHT = 3.49;      // Höhe des Rings unter der Scheibe in mm
  DT_DISTANCE = 0.99;                // Abstand vom Mittleren Ring zur Oberkante des vorherigen Elements

  F_TOTAL_WIDTH = 14.61;
  F_TOTAL_DEPTH = 30.66;
  F_BACK_PIN_HEIGHT = 1.02;                // Höhe der Führungsschiene in mm
  F_BACK_PIN_WIDTH = 11.43;                // Breite der Führungsschiene in mm
  F_BACK_PIN_DEPTH = 0.91;                 // Tiefe der Fühungsschiene in mm
  F_BACK_PIN_DISTANCE = 12.95;             // Abstand der Führungsschienen von einander in mm
  F_BACK_QUAD1_HEIGHT = 2.03;              // Höhe des Quaders an dem die Führungsschienen sind
  F_BACK_QUAD1_WIDTH = 11.43;              // Breite des Quaders an dem die Führungsschienen sind
  F_BACK_QUAD1_DEPTH = 2.08;               // Tiefe des Quaders an dem die Führungsschienen sind
  F_BACK_QUAD1_DISTANCE = 14.99;           // Abstand der Quader 1 voneinander
  F_BACK_QUAD2_HEIGHT = 2.54;              // Höhe des Quaders an dem die Rückwand ist
  F_BACK_QUAD2_WIDTH = 11.43;              // Breite des Quaders an dem die Rückwand ist
  F_BACK_QUAD2_DEPTH = 6.06;               // Tiefe des Quaders an dem die Rückwand ist
  F_BACK_QUAD3_HEIGHT = 13.97;             // Höhe des hinterer Quaders der die Rückwand bildet
  F_BACK_QUAD3_WIDTH = 11.43;              // Breite des hinterer oberer Quaders der die Rückwand bildet
  F_BACK_QUAD3_DEPTH = 2.03;               // Tiefe des hinterer oberer Quaders der die Rückwand bildet
  F_FRONT_QUAD1_HEIGHT = 2.54;             // Höhe des Quaders der hinter dem schrägen Gefälle liegt
  F_FRONT_QUAD1_WIDTH = 2.82;              // Breite des Quaders der hinter dem schrägen Gefälle liegt
  F_FRONT_QUAD1_DEPTH = 22.52;             // Tiefe des Quaders der hinter dem schrägen Gefälle liegt
  F_FRONT_QUAD2_HEIGHT = 13.97;            // Höhe des vorderen Quaders
  F_FRONT_QUAD2_WIDTH = 2.82;              // Breite des vorderen Quaders
  F_FRONT_QUAD2_DEPTH = 2.54;              // Tiefe des vorderen Quaders
  F_SIDE_QUAD_HEIGHT = 13.97;              // Höhe der Seitenwand des Teils
  F_SIDE_QUAD_WIDTH = 2.03;                // Breite der Seitenwand des Teils
  F_SIDE_QUAD_DEPTH = 24;                  // Tiefe der Seitenwand des Teils
  F_SIDE_QUAD_HOLE1_DISTANCE = 6.015;
  F_SIDE_QUAD_HOLE2_DISTANCE = 12;
  F_SIDE_QUAD_HOLE_IN_RADIUS = 2.145;      // Innenradius der Zylinder in der Seitenwand
  F_SIDE_QUAD_HOLE_OUT_RADIUS = 3.905;     // Außenradius der Zylinder in der Seitenwand
  F_SIDE_QUAD_HOLE_HEIGHT = 6.99;          // Höhe der Zylinder in der Seitenwand
  F_SIDE_QUAD_HOLE_TOP_OUT_RADIUS = 2.96;  // Außenradius des Rings auf dem Zylinder in der Seitenwand
  F_SIDE_QUAD_HOLE_TOP_HEIGHT = 0.79;      // Höhe des Rings auf dem Zylinder in der Seitenwand
  F_PAD_QUAD_WIDTH = 3.18;                 // Breite des Pads am Greifer
  F_PAD_QUAD_HEIGHT = 19.05;               // Höhe des Pads am Greifer
  F_PAD_QUAD_DEPTH = 25.4;                 // Tiefe des Pads am Greifer

  GW_TOTAL_DEPTH = 28.35;                 // Komplette Tiefe des Teils
  GW_TOTAL_WIDTH = 64.36;                 // Komplette Breite des Teils
  GW_TOTAL_HEIGHT = 26.38;                // Komplette Höhe des Teils
  GW_BACK_ZYLINDER_SLICES = 30;           // Slices des hinteren Zylinders mit den Zacken
  GW_BACK_ZYLINDER_STACKS = 5;            // Stacks des hinteren Zylinders mit den Zacken
  GW_BACK_ZYLINDER_LOOPS = 15;            // Loops des hinteren Zylinders mit den Zacken
  GW_BACK_ZYLINDER_OUT_RADIUS = 5.08;     // Außenradius des hinteren Zylinders mit den Zacken
  GW_BACK_ZYLINDER_IN_RADIUS1 = 2.84;     // Innenradius des hinteren Zylinders mit den Zacken (außen)
  GW_BACK_ZYLINDER_IN_RADIUS2 = 2.45;     // Innenradius des hinteren Zylinders mit den Zacken (innen)
  GW_BACK_ZYLINDER_IN_RADIUS3 = 1.59;     // Innenradius des inneren Zylinders des hinteren Zylinders
  GW_BACK_ZYLINDER_JAG_COUNT = 24;        // Anzahl der Zacken des hinteren Zylinders
  GW_BACK_ZYLINDER_DEPTH1 = 4.45;         // Tiefe des hinteren Zylinders
  GW_BACK_ZYLINDER_DEPTH2 = 1.88;         // Tiefe des inneren Zylinders des hinteren Zylinders
  GW_BACK_ATTACH_DEPTH = 1.52;            // Tiefe der hinteren Halterungsschiene
  GW_BACK_ATTACH_WIDTH = 6.35;            // Breite/Radius der hinteren Halterungsschiene
  GW_BACK_ATTACH_CENTER_HEIGHT = 20.02;   // Höhe des mittleren Teil der hinteren HAlterungsschiene
  GW_BACK_ATTACH_HOLE_RADIUS = 1.5;       // Radius des Schraubenlochs der hinteren Halterungsschine
  GW_BACK_QUADER_DEPTH = 2.13;            // Tiefe des hinteren Quaders
  GW_BACK_QUADER_WIDTH = 64.36;           // Breite des hinteren Quaders
  GW_BACK_QUADER_HEIGHT = 13.31;          // Höhe des hinteren Quaders
  GW_BACK_QUADER_HOLE_RADIUS = 3.175;     // Radius des inneren Lochs des hinteren Quaders
  GW_BACK_QUADER_HOLE_TOP_DISTANCE = 6.4; // Abstand des Lochs von der Oberkante
  GW_BACK_QUADER_HOLE_BOTTOM_DISTANCE = 6.4; // Abstand des Lochs von der Unterkante
  GW_BOTTOM_QUADER_DEPTH = 19.69;         // Tiefe des unteren Quaders
  GW_BOTTOM_QUADER_WIDTH = 64.36;         // Breite des unteren Quaders
  GW_BOTTOM_QUADER_HEIGHT = 2.84;         // Höhe des unteren Quaders
  GW_BOTTOM_QUADER_HOLE_RADIUS = 3.175;   // Radius des inneren Lochs des unteren Quaders
  GW_BOTTOM_QUADER_CAP_HEIGHT = 0.3;      // Höhe des Aufsatzes auf dem unteren Quader
  GW_BOTTOM_QUADER_CAP_OUT_RADIUS = 8.28; // Außenradius des Aufsatzes auf dem unteren Quader
  GW_BOTTOM_QUADER_CAP_IN_RADIUS = 6.5;   // Innenradius des Aufsatzes auf dem unteren Quader
  GW_BOTTOM_QUADER_CAP_PIN_LENTH = 2.48;  // Länge der Pins des Aufsatzes auf dem unteren Quader
  GW_BOTTOM_QUADER_CAP_PIN_RADIUS = 1.27; // Radius der Pins des Aufsatzes auf dem unteren Quader
  GW_FRONT_QUADER_DEPTH = 2.08;           // Tiefe des vorderen Quaders
  GW_FRONT_QUADER_WIDTH = 64.36;          // Breite des vorderen Quaders
  GW_FRONT_QUADER_HEIGHT = 12.8;          // Höhe des vorderen Quaders
  GW_FRONT_QUADER_HOLE_RADIUS = 3.175;    // Radius des inneren Lochs des vorderen Quaders
  GW_FRONT_PIN_DEPTH = 1.02;              // Tiefe der vorderen Pins
  GW_FRONT_PIN_WIDTH = 64.36;             // Breite der vorderen Pins
  GW_FRONT_PIN_HEIGHT = 1.02;             // Höhe der vorderen Pins

  SC_TOP1_INNER_RADIUS = 2.92;          // Innenradius des obersten Rings
  SC_TOP1_OUTER_RADIUS = 4.955;         // Außenradius des obersten Rings
  SC_TOP1_HEIGHT = 1.27;                // Höhe des obersten Rings
  SC_TOP1_TOP2_DISTANCE = 0.38;         // Abstand des obersten zu dem zweiten Ring
  SC_TOP2_INNER_RADIUS = 3.685;         // Innenradius des zweiten Rings
  SC_TOP2_OUTER_RADIUS = 6.35;          // Außenradius des zweiten Rings
  SC_TOP2_HEIGHT = 1.91;                // Höhe des zweiten Rings
  SC_TOP_FRONT_INNER_RADIUS = 6;        // Innenradius des vorderen Teilzylinders
  SC_TOP_FRONT_OUTER_RADIUS = 9.46;     // Außenradius des vorderen Teilzylinders
  SC_TOP_FRONT_HEIGHT = 2.54;           // Höhe des vorderen Teilzylinders
  SC_TOP_FRONT_SWEEPANGLE = 250;        // Grad des zu zeichnenden Ausschnitts des vorderen Teilzylinders
  SC_TOP_QUADER_WIDTH = 24.78;          // Breite des oberen Quaders
  SC_TOP_QUADER_DEPTH = 2.54;           // Tiefe des oberen Quaders
  SC_TOP_QUADER_HEIGHT = 18.16;         // Höhe des oberen Quaders
  SC_MAIN_QUADER_WIDTH = 38.74;         // Breite des Hauptquaders
  SC_MAIN_QUADER_HEIGHT = 19.69;        // Höhe des Hauptquaders
  SC_MAIN_QUADER_DEPTH = 30.49;         // Tiefe des Hauptquaders
  SC_SIDE_QUADER_WIDTH = 7.24;          // Breite des seitlichen Quaders mit den Schraubenlöchern
  SC_SIDE_QUADER_HEIGHT = 18.92;        // Höhe des seitlichen Quaders mit den Schraubenlöchern
  SC_SIDE_QUADER_DEPTH = 2.41;          // Tiefe des seitlichen Quaders mit den Schraubenlöchern
  SC_SIDE_QUADER_DEPTH_DIST = 24.14;    // Abstand des seitlichen Quaders zur Hinterkante des Hauptquaders
  SC_SIDE_QUADER_BOTTOM_DIST = 0.385;   // Abstand des seitlichen Quaders zur Unterkante des Hauptquaders
  SC_SIDE_HOLE_RADIUS = 2.22;           // Radius der Schraubenlöcher
  SC_SIDE_HOLE_DISTANCE = 4.38;         // Abstand des Schraubenlochs zum oberen/unteren Rand
  SC_SIDE_HOLE_LEFT_DISTANCE = 2.53;    // Abstand des Schraubenlochs zum linken Rand
  SC_BOTTOM_QUADER_WIDTH = 37.97;       // Breite der Rückwand
  SC_BOTTOM_QUADER_HEIGHT = 18.92;      // Höhe der Rückwand
  SC_BOTTOM_QUADER_DEPTH = 0.38;        // Tiefe der Rückwand

  SHP_TOP_RING_OUTER_RADIUS = 3.75;         // Außenradius des Rings auf der Scheibe in mm
  SHP_TOP_RING_INNER_RADIUS = 3.0;          // Innenradius des Rings auf der Scheibe in mm
  SHP_TOP_RING_SLICES = 30;                 // Slices für den oberen Ring
  SHP_TOP_RING_STACKS = 2;                  // Stacks für den oberen Ring
  SHP_TOP_RING_LOOPS = 2;                   // Loops für den oberen Ring
  SHP_TOP_RING_HEIGHT = 1.0;                // Höhe des Rings auf der Scheibe in mm
  SHP_CENTER_RING_OUTER_RADIUS = 12.0;      // Außenradius des großen Rings in mm
  SHP_CENTER_RING_INNER_RADIUS = 3.75;      // Innenradius des großen Ring in mm
  SHP_CENTER_RING_SLICES = 30;              // Slices für die mittlere große Scheibe
  SHP_CENTER_RING_STACKS = 5;               // Stacks für die mittlere große Scheibe
  SHP_CENTER_RING_LOOPS = 15;               // Loops für die mittlere große Scheibe
  SHP_CENTER_HEIGHT = 2.0;                  // Höhe des großen Rings in mm
  SHP_CENTER_SMALL_RING_OUTER_RADIUS = 3.0; // Außenradius des inneren Rings in mm
  SHP_CENTER_SMALL_RING_INNER_RADIUS = 1.4; // Innenradius des inneren Rings in mm
  SHP_CENTER_SMALL_HEIGHT = 1.0;            // Höhe des inneren Rings in mm
  SHP_CENTER_SMALL_SLICES = 30;             // Slices für innere mitlere Scheibe
  SHP_CENTER_SMALL_STACKS = 2;              // Stacks für innere mitlere Scheibe
  SHP_CENTER_SMALL_LOOPS = 5;               // Loops für innere mitlere Scheibe
  SHP_BOTTOM_RING_OUTER_RADIUS = 4.45;      // Außenradius des Rings unter der Scheibe in mm
  SHP_BOTTOM_RING_INNER_RADIUS = 3.0;       // Innenradius des Rings unter der Scheibe in mm
  SHP_BOTTOM_RING_HEIGHT = 2.5;             // Höhe des Rings unter der Scheibe in mm
  SHP_BOTTOM_SMALL_SLICES = 30;             // Slices für innere mitlere Scheibe
  SHP_BOTTOM_SMALL_STACKS = 2;              // Stacks für innere mitlere Scheibe
  SHP_BOTTOM_SMALL_LOOPS = 5;               // Loops für innere mitlere Scheibe
  SHP_SMALL_HOLE_DISTANCE = 8.33;           // Abstand der Befestigungslöcher zur Mittelsenkrechten in mm
  SHP_SMALL_HOLE_RADIUS = 0.75;             // Radius der Befestigungslöcher in mm
  SHP_SMALL_HOLE_SLICES = 15;               // Slices für die Schraubenlöcher
  SHP_SMALL_HOLE_LOOPS = 5;                 // Loops für die Schraubenlöcher
  {
    Winkel für den Abstand der drei Befestigungslöcher voneinander
    Cosinussatz:	c^2 = a^2 + b^2 - 2ab * cos(gamma)
    <=>		        gamma = arccos((c^2 - a^2 - b^2) / (-2ab))
  }
  SHP_SMALL_HOLE_ANGLE = 14.968;

  T1_THICKNESS = 2;               // Tiefe des Teils in mm
  T1_TOTAL_HEIGHT = 25.96;        // Die Gesamthöhe des Teils in mm
  T1_TOTAL_WIDTH = 63.96;         // Die Gesamtbreite des Teils in mm
  T1_HEIGHT = 21.96;              // Höhe des Teils ohne die abgerundeten Kanten in mm
  T1_STACKS = 5;                  // Stacks für das komplette Teil
  T1_WIDTH = 59.96;               // Breite des Teils ohne die abgerundeten Kanten in mm
  T1_CORNER_RADIUS = 2;           // Radius der Kanten in mm
  T1_CORNER_SLICES = 30;          // Slices für die Kanten
  T1_CORNER_LOOPS = 15;           // Loops für die Kanten
  T1_CORNER_HOLE_RADIUS = 1.5;    // Radius der Befestigungslöcher an den Kanten in mm
  T1_CORNER_HOLE_DISTANCE = 2.97; // Abstand der Befestigungslöcher zu den Seiten in mm
  T1_CORNER_HOLE_SLICES = 30;     // Slices der Befestigungslöcher an den Kanten
  T1_CORNER_HOLE_LOOPS = 15;      // Loops der Befestigungslöcher an den Kanten
  T1_CENTER_HOLE_RADIUS = 4.0;    // Radius des mittleren Lochs der unteren Platte in mm
  T1_CENTER_HOLE_SLICES = 30;     // Slices für das mittlere Loch
  T1_CENTER_HOLE_LOOPS = 15;      // Loops für das mittlere Loch
  T1_SMALL_HOLE_RADIUS = 1.195;   // Radius der kleinen Löcher der unteren Platte in mm
  T1_SMALL_HOLE_SLICES = 15;      // Slices für die Schraubenlöcher
  T1_SMALL_HOLE_LOOPS = 5;        // Loops für die Schraubenlöcher
  T1_SMALL_HOLE_DISTANCE = 8.33;  // Abstand der kleinen Löcher von der Mittelsenkrechten in mm

  T3_CYLINDER_RADIUS = 50.0;      // Breite des Zylinders in mm
  T3_CYLINDER_HEIGHT = 47.0;      // Höhe des Zylinders in mm
  T3_PIN_WIDTH = 6.0;             // Breite der Befestigungspins in mm
  T3_PIN_HEIGHT = 3.0;            // Höhe der Befestigungspins in mm
  T3_PIN_DEPTH = 5.0;             // Tiefe der Befestigungspins in mm
  T3_PIN_HOLE_RAD = 1.25;         // Radius des Lochs der Befestigungspins in mm
  T3_CAP_THICKNESS = 2.0;         // Dicke des Deckels in mm
  T3_CAP_HOLE_RADIUS = 11.5;      // Radius des Lochs des Deckels in mm
  T3_OUTERCOVER_THICKNESS = 2.0;  // Dicke des Mantels in mm


// Ab hier sind Hilfsmethoden definiert
function getSlices(radius : Real) : Integer;
function getStacks(height : Real) : Integer;
function getLoops(radius : Real) : Integer;
function getVectorLength(vector : TVector3d) : Real;
function getNormalizedVector(vector : TVector3d) : TVector3d;
procedure drawCylinder(quadObject: PGLUquadric; innerRadius, outerRadius, height: TGLdouble; slices, stacks, loops: TGLint;
                       sweepAngle: TGLdouble);
procedure drawHoleMask(quadObject: PGLUQuadric; holeRadius, height: TGLdouble; slices, loops : GLint);
procedure drawHoles(quadObject: PGLUQuadric; centerHoleRadius, smallHoleRadius, smallHoleDistance, thickness: TGLdouble;
                    slices, stacks, smallSlices, smallStacks: GLint);
procedure drawHolesMask(quadObject: PGLUQuadric; centerHoleRadius, smallHoleRadius, smallHoleDistance, thickness: TGLdouble;
                    slices, loops, smallSlices, smallLoops: GLint);
procedure drawPrisma(p1, p2, p3 : TVector3d; height : GLdouble);
procedure drawQuad(P1, P2 : TVector3d);

// Ab hier sind die einzelnen Teile definiert
procedure drawASB09(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawASB10(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawASB13(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawASB14(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawBBH01(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawDrehTeller(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawFingerLeft(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawGripperWrist(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawServo(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawServoHornPlastic(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawTeil1(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
procedure drawTeil3(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);

implementation

// ******************************************************
// *                                                    *
// * Hilfsfunktionen zur Erstellung der einzelnen Teile *
// *                                                    *
// ******************************************************

{
  Diese Methode berechnet aus einem Radius die nötigen Slices, damit ein vernünftiger Kreis entsteht.

  ~param radius Der Radius des Kreises zu dem die Slices berechnet werden
  ~return Liefert die Slices zu einem Radius eines Kreises
}
function getSlices(radius : Real) : Integer;
var slices : Integer;   // Slices für den Kreis
    area   : Real;      // Umfang des Kreises
begin
  area := 2 * pi * radius;
  slices := round(area / 6);
  if(slices < 20) then slices := 20;
  result := slices;
end;

{
  Diese Methode berechnet aus einer Höhe die nötigen Stacks, um Schatteneffekte vernünftig berechnen zu können.

  ~param height Die Höhe des Objekts zu dem die Stacks berechnet werden
  ~return Liefert die Stacks zu einer Höhe eines Objekts
}
function getStacks(height : Real) : Integer;
var stacks : Integer;  // Stacks für das Objekt
begin
  stacks := round(height / 4);
  if(stacks < 2) then stacks := 2;
  result := stacks;
end;

{
  Diese Methode berechnet aus einem Radius die nötigen Loops, um Schatteneffekte vernünftig berechnen zu können.

  ~param radius Der Radius des Kreises zu dem die Loops berechnet werden
  ~return Liefert die Loops zu einem Radius eines Kreises
}
function getLoops(radius : Real) : Integer;
var loops : Integer;  // Loops für den Kreis
begin
  loops := round(radius / 3);
  if(loops < 2) then loops := 2;
  result := loops;
end;

{
  Diese Methode berechnet die Länge eines Vektors.

  ~param vector Der Vektor dessen Länge bestimmt werden soll
  ~return Die Länge des übergebenen Vektors
}
function getVectorLength(vector : TVector3d) : Real;
begin
  result := sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
end;

{
  Diese Methode normalisiert einen Vector.

  ~param vector Der zu normalisierende Vector
  ~return Einen entsprechenden normalisierten Vector
}
function getNormalizedVector(vector : TVector3d) : TVector3d;
var nVecLaenge : GLdouble;
begin
  nVecLaenge := getVectorLength(vector);
  result[0] := vector[0] / nVecLaenge;
  result[1] := vector[1] / nVecLaenge;
  result[2] := vector[2] / nVecLaenge;
end;

{
  Diese Methode berechnet aus drei Vektoren den Normalenvektor, der Fläche, die sich aus diesen Vektoren ergibt. Die
  Vektoren müssen gegen den Uhrzeigersinn angegeben werden.

  ~param p1, p2, p3 Die Vektoren der Fläche
  ~return Einen normierten Normalenvektor
}
function getNormalenVector(p1, p2, p3 : TVector3d) : TVector3d;
var nVec, u, v : TVector3d;
begin
  u[0] := p2[0] - p1[0];
  u[1] := p2[1] - p1[1];
  u[2] := p2[2] - p1[2];

  v[0] := p3[0] - p1[0];
  v[1] := p3[1] - p1[1];
  v[2] := p3[2] - p1[2];

  nVec[0] := u[1] * v[2] - u[2] * v[1];
  nVec[1] := u[2] * v[0] - u[0] * v[2];
  nVec[2] := u[0] * v[1] - u[1] * v[0];

  result := getNormalizedVector(nVec);
end;

{
  Diese Methode zeichnet einen Zylinder bzw. einen Ausschnitt eines Zylinders, bei dem der Startwinkel und der Endwinkel
  angegeben werden kann.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param innerRadius Der Innenradius des Zylinders
  ~param outerRadius Der Außenradius des Zylinders
  ~param height Die Höhe des Zylinders
  ~param sweepAngle Winkel des zu zeichnenden Zylinderausschnitts
}
procedure drawCylinder(quadObject: PGLUquadric; innerRadius, outerRadius, height: TGLdouble; slices, stacks, loops: TGLint;
                       sweepAngle: TGLdouble);
var i, j : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    M,                        // Mittelpunkt des Zylinders
    innerP1, innerP2,         // Jeweiliger Start- und Endpunkt auf dem Innenmantel
    outerP1, outerP5,         // Jeweiliger Start- und Endpunkt auf dem Außenmantel
    stepP,                    // Hilfsvariable für die Zwischenpunkte auf dem Innen- und Außenmantel
    helpP,                    // Hilfsvektor zur Berechnung des Normalenvektors
    nVec : TVector3d;         // Normalenvektor
    angleStep,                // Winkelschritte für den Mantel
    loopStep,                 // Schritte für die Innenflächen aus dem Zylinder. Sie entsprechen den loops der Ober und
                              // Unterseiten, die jedoch nicht gezeichnet werden
    stackStep : GLdouble;     // Schritte für die stacks des ganzen Zylinders

    function getNextP(P: TVector3d; angle: GLdouble) : TVector3d;
    begin
      result[0] := P[0] * cos(angle) + P[1] * sin(angle);
      result[1] := P[0] * sin(angle) + P[1] * cos(angle);
      result[2] := P[2];
    end;
begin
  LOG := TLogLogger.GetLogger('drawCyinder');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.debug('innerRadius = ' + floattostr(innerRadius)
            + ' outerRadius = ' + floattostr(outerRadius)
            + ' height = ' + floattostr(height)
            + ' sweepAngle = ' + floattostr(sweepAngle));
  end;

  // Wandle Gradwerte in Bogenmaß um
  sweepAngle := 2 * pi * sweepAngle / 360;
  angleStep := sweepAngle / slices;
  innerP1[0] := 0; innerP1[1] := innerRadius; innerP1[2] := 0;
  outerP5 := getNextP(innerP1, sweepAngle);
  outerP1[0] := 0; outerP1[1] := outerRadius; outerP1[2] := 0;
  innerP2 := getNextP(outerP1, sweepAngle);
  M[0] := 0; M[1] := 0; M[2] := 0;
  loopStep := (outerRadius - innerRadius) / loops;
  stackStep := height / stacks;

  // Zeichne inneren Mantel
  for j := 1 to stacks do
  begin
    helpP[0] := innerP1[0]; helpP[1] := innerP1[1] - 1; helpP[2] := innerP1[2];
    glBegin(GL_QUAD_STRIP);
      glVertex3f(innerP1[0], innerP1[1], 0);
      glVertex3f(innerP1[0], innerP1[1], stackStep * j);
      for i := 0 to slices do
      begin
        stepP := getNextP(innerP1, i * angleStep);
        nVec := getNormalizedVector(getNextP(helpP, (i) * angleStep));
        glNormal3f(nVec[0], nVec[1], nVec[2]);
        glVertex3f(stepP[0], stepP[1], 0);
        glVertex3f(stepP[0], stepP[1], stackStep * j);
      end;
    glEnd;
  end;

  // Zeichne äußeren Mantel
  for j := 1 to stacks do
  begin
    helpP[0] := outerP1[0]; helpP[1] := outerP1[1] + 1; helpP[2] := outerP1[2];
    glBegin(GL_QUAD_STRIP);
      glVertex3f(outerP1[0], outerP1[1], 0);
      glVertex3f(outerP1[0], outerP1[1], stackStep * j);
      for i := 0 to slices do
      begin
        stepP := getNextP(outerP1, i * angleStep);
        nVec := getNormalizedVector(getNextP(helpP, (i) * angleStep));
        glNormal3f(nVec[0], nVec[1], nVec[2]);
        glVertex3f(stepP[0], stepP[1], 0);
        glVertex3f(stepP[0], stepP[1], stackStep * j);
      end;
    glEnd;
  end;

  // Zeichne Fläche vom inneren Mantel bis zum äußeren Mantel (0 Grad)
  for j := 1 to stacks do
  begin
    glNormal3f(1, 0, 0);
    glBegin(GL_QUAD_STRIP);
      for i := 0 to loops do
      begin
        stepP[0] := M[0];
        stepP[1] := M[1] + i * loopStep + innerRadius;
        stepP[2] := M[2];
        glVertex3f(stepP[0], stepP[1], 0);
        glVertex3f(stepP[0], stepP[1], stackStep * j);
      end;
    glEnd;
  end;

  // Zeichne Fläche vom inneren Mantel bis zum äußeren Mantel ('sweepAngle' Grad)
  for j := 1 to stacks do
  begin
    glNormal3f(0, -1, 0);
    glBegin(GL_QUAD_STRIP);
      for i := 0 to loops do
      begin
        stepP[0] := outerP5[0] + i * (innerP2[0] - outerP5[0]) / loops;
        stepP[1] := outerP5[1] + i * (innerP2[1] - outerP5[1]) / loops;
        stepP[2] := outerP5[2];
        glVertex3f(stepP[0], stepP[1], 0);
        glVertex3f(stepP[0], stepP[1], stackStep * j);
      end;
    glEnd;
  end;
end;

{
  Diese Methode zeichnet ein einzelnes Loch in einen Körper. Eine entsprechende Lochmaske wird vorbereitet und muss nach
  Aufruf dieser Methode aktiviert werden und anschließend deaktiviert werden!

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param holeRadius Radius des Lochs
  ~param height Höhe des Lochs
}
procedure drawHoleMask(quadObject: PGLUQuadric; holeRadius, height: TGLdouble; slices, loops : GLint);
var i    : Integer;           // Zählvariable
    LOG  : TLogLogger;        // Logger für Debugausgaben

begin
  LOG := TLogLogger.GetLogger('drawHoleMask');

  if(LOG.IsTraceEnabled()) then
  begin
    LOG.Debug('holeRadius = ' + floattostr(holeRadius)
            + ' height = ' + floattostr(height)
            + ' slices = ' + inttostr(slices)
            + ' loops = ' + inttostr(loops));
  end;

  gluDisk(quadObject, 0, holeRadius, slices, loops);
  glPushMatrix();
    glTranslatef(0, 0, height);
    gluDisk(quadObject, 0, holeRadius, slices, loops);
  glPopMatrix();
end;


{
  Diese Methode zeichnet fünf Löcher in ein Element, ein großes in der Mitte und vier kleine Schraubenlöcher jeweils
  90° versetzt um das mittlere Loch herum. Diese Löcher
  kommen in den Teilen asb-09 und asb-10 vor.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param centerHoleRadius Der Radius des inneren großen Lochs
  ~param smallHoleRadius Der Radius der kleinen Schraubenlöcher
  ~param smallHoleDistance Abstand der Schraubenlöcher zum mittleren Loch
  ~param thickness Höhe der Löcher
}
procedure drawHoles(quadObject: PGLUQuadric; centerHoleRadius, smallHoleRadius, smallHoleDistance, thickness: TGLdouble;
                    slices, stacks, smallSlices, smallStacks: GLint);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben

begin
  LOG := TLogLogger.GetLogger('bbh-01');

  if(LOG.IsTraceEnabled()) then
  begin
    LOG.Debug('centerHoleRadius = ' + floattostr(centerHoleRadius)
            + ' smallHoleRadius = ' + floattostr(smallHoleRadius)
            + ' smallHoleDistance = ' + floattostr(smallHoleDistance)
            + ' thickness = ' + floattostr(thickness)
            + ' slices = ' + inttostr(slices)
            + ' stacks = ' + inttostr(stacks)
            + ' smallSlices = ' + inttostr(smallSlices)
            + ' smallStacks = ' + inttostr(smallStacks));
  end;

  util := TOpenGLConfigUtil.getInstance();

  // Mittleres Loch
  gluCylinder(quadObject, centerHoleRadius, centerHoleRadius, thickness, slices, stacks);

  glPushMatrix();
  // kleine Löcher
    for i := 0 to 3 do
    begin
      glRotatef(90 * i, 0, 0, 1);
      glPushMatrix();
          glTranslatef(0, smallHoleDistance, 0);
          gluCylinder(quadObject, smallHoleRadius, smallHoleRadius, thickness, smallSlices, smallStacks);
      glPopMatrix();
    end;
  glPopMatrix();
end;

{
  Diese Methode zeichnet die Masken von fünf Löcher in ein Element, ein großes in der Mitte und vier kleine Schraubenlöcher jeweils
  90° versetzt um das mittlere Loch herum. Diese Löcher
  kommen in den Teilen asb-09 und asb-10 vor.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param centerHoleRadius Der Radius des inneren großen Lochs
  ~param smallHoleRadius Der Radius der kleinen Schraubenlöcher
  ~param smallHoleDistance Abstand der Schraubenlöcher zum mittleren Loch
  ~param thickness Höhe der Löcher
}
procedure drawHolesMask(quadObject: PGLUQuadric; centerHoleRadius, smallHoleRadius, smallHoleDistance, thickness: TGLdouble;
                    slices, loops, smallSlices, smallLoops: GLint);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben

begin
  LOG := TLogLogger.GetLogger('drawHolesMasks');

  if(LOG.IsTraceEnabled()) then
  begin
    LOG.Debug('centerHoleRadius = ' + floattostr(centerHoleRadius)
            + ' smallHoleRadius = ' + floattostr(smallHoleRadius)
            + ' smallHoleDistance = ' + floattostr(smallHoleDistance)
            + ' thickness = ' + floattostr(thickness)
            + ' slices = ' + inttostr(slices)
            + ' loops = ' + inttostr(loops)
            + ' smallSlices = ' + inttostr(smallSlices)
            + ' smallLoops = ' + inttostr(smallLoops));
  end;

  util := TOpenGLConfigUtil.getInstance();

  // Erstelle Maske für die Löcher
  gluDisk(quadObject, 0, centerHoleRadius, slices, loops);
  glPushMatrix();
    glTranslatef(0, 0, thickness);
    gluDisk(quadObject, 0, centerHoleRadius, slices, loops);
  glPopMatrix();

  // kleine Löcher
  glPushMatrix();
    for i := 0 to 3 do
    begin
      glRotatef(90 * i, 0, 0, 1);
        glPushMatrix();
          glTranslatef(0, smallHoleDistance, 0);
          gluDisk(quadObject, 0, smallHoleRadius, smallSlices, smallLoops);
          glPushMatrix();
            glTranslatef(0, 0, thickness);
            gluDisk(quadObject, 0, smallHoleRadius, smallSlices, smallLoops);
          glPopMatrix();
        glPopMatrix();
    end;
  glPopMatrix();
end;

{
  Diese Methode zeichnet einen Quader, der durch die Raumdiagonale angegeben wird. Dabei zeigt der Diagonalenvektor
  von P1 nach P2.

  ~param P1 Linker, unterer, vorderer Punkt des Quaders
  ~param P2 Rechter, oberer, hinterer Punkt des Quaders
}
procedure drawQuad(P1, P2 : TVector3d);
var     LOG  : TLogLogger;        // Logger für Debugausgaben
begin
  LOG := TLogLogger.GetLogger('drawQuad');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('p1 = ' + floattostr(P1[0]) + '|' + floattostr(P1[1]) + '|' + floattostr(P1[2])
            + ' p2 = ' + floattostr(P2[0]) + '|' + floattostr(P2[1]) + '|' + floattostr(P2[2]));
  end;

  // Vorderseite
  glBegin(GL_QUADS);
    glNormal3d(0, 0, 1);
    glVertex3f(P1[0], P1[1], P1[2]);
    glVertex3f(P2[0], P1[1], P1[2]);
    glVertex3f(P2[0], P2[1], P1[2]);
    glVertex3f(P1[0], P2[1], P1[2]);
  glEnd;

  // linke Seite
  glBegin(GL_QUADS);
    glNormal3d(1, 0, 0);
    glVertex3f(P1[0], P1[1], P1[2]);
    glVertex3f(P1[0], P2[1], P1[2]);
    glVertex3f(P1[0], P2[1], P2[2]);
    glVertex3f(P1[0], P1[1], P2[2]);
  glEnd;

  // Rückseite
  glBegin(GL_QUADS);
    glNormal3d(0, 0, 1);
    glVertex3f(P1[0], P1[1], P2[2]);
    glVertex3f(P2[0], P1[1], P2[2]);
    glVertex3f(P2[0], P2[1], P2[2]);
    glVertex3f(P1[0], P2[1], P2[2]);
  glEnd;

  // rechte Seite
  glBegin(GL_QUADS);
    glNormal3d(-1, 0, 0);
    glVertex3f(P2[0], P1[1], P1[2]);
    glVertex3f(P2[0], P1[1], P2[2]);
    glVertex3f(P2[0], P2[1], P2[2]);
    glVertex3f(P2[0], P2[1], P1[2]);
  glEnd;

  // Oberseite
  glBegin(GL_QUADS);
    glNormal3d(0, -1, 0);
    glVertex3f(P1[0], P2[1], P1[2]);
    glVertex3f(P2[0], P2[1], P1[2]);
    glVertex3f(P2[0], P2[1], P2[2]);
    glVertex3f(P1[0], P2[1], P2[2]);
  glEnd;

  // Unterseite
  glBegin(GL_QUADS);
    glNormal3d(0, -1, 0);
    glVertex3f(P1[0], P1[1], P1[2]);
    glVertex3f(P2[0], P1[1], P1[2]);
    glVertex3f(P2[0], P1[1], P2[2]);
    glVertex3f(P1[0], P1[1], P2[2]);
  glEnd;
end;

{
  Diese Methode zeichnet ein Prisma mit der Höhe 'height' und drei Punkten, die die Oberseite angeben. Die drei Punkte
  müssen gegen den Uhrzeigersinn angegeben werden.

  ~param p1, p2, p3 Die Eckpunkte des Dreiecks, das die Oberseite darstellt
  ~param height Die Höhe des Prismas.
}
procedure drawPrisma(p1, p2, p3 : TVector3d; height : GLdouble);
var hP1, hP2, hP3,                     // Hilfspunkte
    nVec                : TVector3d;   // Normalenvektor
    LOG                 : TLogLogger;  // Logger für Debugausgaben
begin
  LOG := TLogLogger.GetLogger('drawPrisma');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('p1 = ' + floattostr(P1[0]) + '|' + floattostr(P1[1]) + '|' + floattostr(P1[2])
            + ' p2 = ' + floattostr(P2[0]) + '|' + floattostr(P2[1]) + '|' + floattostr(P2[2])
            + ' p3 = ' + floattostr(P3[0]) + '|' + floattostr(P3[1]) + '|' + floattostr(P3[2])
            + ' height = ' + floattostr(height));
  end;

  glBegin(GL_TRIANGLES);
    glNormal3f(0, 1, 0);
    glVertex3f(p1[0], p1[1], p1[2]);
    glVertex3f(p2[0], p2[1], p2[2]);
    glVertex3f(p3[0], p3[1], p3[2]);
  glEnd();
  glBegin(GL_QUADS);
    hP1[0] := p1[0]; hP1[1] := p1[1] - height; hP1[2] := p1[2];
    hP2[0] := p2[0]; hP2[1] := p2[1] - height; hP2[2] := p2[2];
    nVec := getNormalenVector(p1, hP1, hP2);
    glNormal3f(nVec[0], nVec[1], nVec[2]);
    glVertex3f(p1[0],  p1[1],  p1[2]);
    glVertex3f(hP1[0], hP1[1], hP1[2]);
    glVertex3f(hP2[0], hP2[1], hP2[2]);
    glVertex3f(p2[0],  p2[1],  p2[2]);
  glEnd;
  glBegin(GL_QUADS);
    hP1[0] := p2[0]; hP1[1] := p2[1] - height; hP1[2] := p2[2];
    hP2[0] := p3[0]; hP2[1] := p3[1] - height; hP2[2] := p3[2];
    nVec := getNormalenVector(p1, hP1, hP2);
    glNormal3f(nVec[0], nVec[1], nVec[2]);
    glVertex3f(p2[0],  p2[1],  p2[2]);
    glVertex3f(hP1[0], hP1[1], hP1[2]);
    glVertex3f(hP2[0], hP2[1], hP2[2]);
    glVertex3f(p3[0],  p3[1],  p3[2]);
  glEnd;
  glBegin(GL_QUADS);
    hP1[0] := p3[0]; hP1[1] := p3[1] - height; hP1[2] := p3[2];
    hP2[0] := p1[0]; hP2[1] := p1[1] - height; hP2[2] := p1[2];
    nVec := getNormalenVector(p1, hP1, hP2);
    glNormal3f(nVec[0], nVec[1], nVec[2]);
    glVertex3f(p3[0],  p3[1],  p3[2]);
    glVertex3f(hP1[0], hP1[1], hP1[2]);
    glVertex3f(hP2[0], hP2[1], hP2[2]);
    glVertex3f(p1[0],  p1[1],  p1[2]);
  glEnd;
  glBegin(GL_TRIANGLES);
  glNormal3f(0, 1, 0);
    glVertex3f(p1[0], p1[1] - height, p1[2]);
    glVertex3f(p2[0], p2[1] - height, p2[2]);
    glVertex3f(p3[0], p3[1] - height, p3[2]);
  glEnd();
end;


// ************************************************
// *                                              *
// * Ab hier werden die einzelnen Teile definiert *
// *                                              *
// ************************************************

{
  Dies ist das Teil mit der Bezeichnung asb-09, welche das Element 3 bildet.
  Der Startpunkt befindet sich auf der Unterseite im Mittelpunkt der Fläche.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawASB09(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    P1, P2 : TVector3d;       // Hilfsvektoren

    procedure drawSide();
    begin
      // Zeichne linke Platte (Löcher)
      glPushMatrix();
        glRotatef(90, 0, 0, 1);
        glPushMatrix();
          glTranslatef(ASB09_SIDE_BOARD_HEIGHT, 0, 0);
          glPushMatrix();
            glTranslatef(0, ASB09_THICKNESS, 0);
            glRotatef(90, 1, 0, 0);
            drawHoles(quadObject, ASB09_CENTER_HOLE_RADIUS, ASB09_SMALL_HOLE_RADIUS, ASB09_SMALL_HOLE_DISTANCE,
                      ASB09_THICKNESS,
                      ASB09_CENTER_HOLE_SLICES, ASB09_HOLE_STACKS,
                      ASB09_SMALL_HOLE_SLICES, ASB09_HOLE_STACKS);
            util.PrepairMask();
            drawHolesMask(quadObject, ASB09_CENTER_HOLE_RADIUS, ASB09_SMALL_HOLE_RADIUS, ASB09_SMALL_HOLE_DISTANCE,
                      ASB09_THICKNESS,
                      ASB09_CENTER_HOLE_SLICES, ASB09_CENTER_HOLE_LOOPS,
                      ASB09_SMALL_HOLE_SLICES, ASB09_SMALL_HOLE_LOOPS);
          glPopMatrix();
        glPopMatrix();

        // Zeichne linke Platte
        util.AktivateMask();
        P1[0] := ASB09_THICKNESS;         P1[1] := 0;               P1[2] := -ASB09_DEPTH / 2;
        P2[0] := ASB09_SIDE_BOARD_HEIGHT; P2[1] := ASB09_THICKNESS; P2[2] := ASB09_DEPTH / 2;
        drawQuad(P1, P2);

        glPushMatrix();
          glTranslatef(ASB09_SIDE_BOARD_HEIGHT, 0, 0);
          glRotatef(-90, 1, 0, 0);
          gluPartialDisk(quadObject, 0, ASB09_SIDE_BOARD_TOP_RADIUS,
                         ASB09_SIDE_BOARD_TOP_SLICES, ASB09_SIDE_BOARD_TOP_LOOPS, 0, 180);
          gluCylinder(quadObject, ASB09_SIDE_BOARD_TOP_RADIUS, ASB09_SIDE_BOARD_TOP_RADIUS, ASB09_THICKNESS,
                      ASB09_SIDE_BOARD_TOP_SLICES, ASB09_SIDE_BOARD_TOP_STACKS);
          glTranslatef(0, 0, ASB09_THICKNESS);
          gluPartialDisk(quadObject, 0, ASB09_SIDE_BOARD_TOP_RADIUS,
                         ASB09_SIDE_BOARD_TOP_SLICES, ASB09_SIDE_BOARD_TOP_LOOPS, 0, 180);
        glPopMatrix();
        util.DisableMask();
      glPopMatrix();
    end;

begin
  LOG := TLogLogger.GetLogger('asb-10');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(77, 77, 77);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Untere Platte (Löcher)
    glPushMatrix();
      glTranslatef(0, ASB09_THICKNESS, 0);
      glRotatef(90, 1, 0, 0);
        drawHoles(quadObject, ASB09_CENTER_HOLE_RADIUS, ASB09_SMALL_HOLE_RADIUS, ASB09_SMALL_HOLE_DISTANCE,
                  ASB09_THICKNESS,
                  ASB09_CENTER_HOLE_SLICES, ASB09_HOLE_STACKS,
                  ASB09_SMALL_HOLE_SLICES, ASB09_HOLE_STACKS);
        util.PrepairMask();
        drawHolesMask(quadObject, ASB09_CENTER_HOLE_RADIUS, ASB09_SMALL_HOLE_RADIUS, ASB09_SMALL_HOLE_DISTANCE,
                  ASB09_THICKNESS,
                  ASB09_CENTER_HOLE_SLICES, ASB09_CENTER_HOLE_LOOPS,
                  ASB09_SMALL_HOLE_SLICES, ASB09_SMALL_HOLE_LOOPS);
    glPopMatrix();

    // Untere Platte
    util.AktivateMask();
    P1[0] := -ASB09_BOTTOM_BOARD_WIDTH / 2; P1[1] := 0;               P1[2] := -ASB09_DEPTH / 2;
    P2[0] := ASB09_BOTTOM_BOARD_WIDTH / 2;  P2[1] := ASB09_THICKNESS; P2[2] := ASB09_DEPTH / 2;
    drawQuad(P1, P2);
    util.DisableMask();

    // Zeichne linke Abrundung
    glPushMatrix();
      glTranslatef(-ASB09_BOTTOM_BOARD_WIDTH / 2, ASB09_THICKNESS, -ASB09_DEPTH / 2);
      glRotatef(180, 0, 0, 1);
      drawCylinder(quadObject, 0, ASB09_THICKNESS, ASB09_DEPTH,
                   getSlices(ASB09_THICKNESS), getStacks(ASB09_DEPTH), getLoops(ASB09_THICKNESS), 90);
      gluPartialDisk(quadObject, 0, ASB09_THICKNESS,
                   getSlices(ASB09_THICKNESS), getLoops(ASB09_THICKNESS), 0, 90);
      glTranslatef(0, 0, ASB09_DEPTH);
      gluPartialDisk(quadObject, 0, ASB09_THICKNESS,
                   getSlices(ASB09_THICKNESS), getLoops(ASB09_THICKNESS), 0, 90);
    glPopMatrix();

    // Zeichne rechte Abrundung
    glPushMatrix();
      glTranslatef(ASB09_BOTTOM_BOARD_WIDTH / 2, ASB09_THICKNESS, -ASB09_DEPTH / 2);
      glRotatef(-90, 0, 0, 1);
      drawCylinder(quadObject, 0, ASB09_THICKNESS, ASB09_DEPTH,
                   getSlices(ASB09_THICKNESS), getStacks(ASB09_DEPTH), getLoops(ASB09_THICKNESS), 90);
      gluPartialDisk(quadObject, 0, ASB09_THICKNESS,
                   getSlices(ASB09_THICKNESS), getLoops(ASB09_THICKNESS), 0, 90);
      glTranslatef(0, 0, ASB09_DEPTH);
      gluPartialDisk(quadObject, 0, ASB09_THICKNESS,
                   getSlices(ASB09_THICKNESS), getLoops(ASB09_THICKNESS), 0, 90);
    glPopMatrix();

    glTranslatef(-ASB09_BOTTOM_BOARD_WIDTH / 2, 0, 0);
    drawSide();

    glTranslatef(ASB09_BOTTOM_BOARD_WIDTH + ASB09_THICKNESS, 0, 0);
    drawSide();
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung asb-10, welche das Element 1 bildet.
  Der Startpunkt befindet sich auf der Unterseite im Mittelpunkt der Fläche.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawASB10(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    P1, P2 : TVector3d;       // Hilfsvektoren

    procedure drawSide();
    begin
      // Zeichne linke Platte (Löcher)
      glPushMatrix();
        glRotatef(90, 0, 0, 1);
        glPushMatrix();
          glTranslatef(ASB10_SIDE_BOARD_HEIGHT, 0, 0);
          glPushMatrix();
            glTranslatef(0, ASB10_THICKNESS, 0);
            glRotatef(90, 1, 0, 0);
            drawHoles(quadObject, ASB10_CENTER_HOLE_RADIUS, ASB10_SMALL_HOLE_RADIUS, ASB10_SMALL_HOLE_DISTANCE,
                      ASB10_THICKNESS,
                      ASB10_CENTER_HOLE_SLICES, ASB10_HOLE_STACKS,
                      ASB10_SMALL_HOLE_SLICES, ASB10_HOLE_STACKS);
            util.PrepairMask();
            drawHolesMask(quadObject, ASB10_CENTER_HOLE_RADIUS, ASB10_SMALL_HOLE_RADIUS, ASB10_SMALL_HOLE_DISTANCE,
                      ASB10_THICKNESS,
                      ASB10_CENTER_HOLE_SLICES, ASB10_CENTER_HOLE_LOOPS,
                      ASB10_SMALL_HOLE_SLICES, ASB10_SMALL_HOLE_LOOPS);
          glPopMatrix();
        glPopMatrix();

        // Zeichne linke Platte
        util.AktivateMask();
        P1[0] := ASB10_THICKNESS;         P1[1] := 0;               P1[2] := -ASB10_DEPTH / 2;
        P2[0] := ASB10_SIDE_BOARD_HEIGHT; P2[1] := ASB10_THICKNESS; P2[2] := ASB10_DEPTH / 2;
        drawQuad(P1, P2);

        glPushMatrix();
          glTranslatef(ASB10_SIDE_BOARD_HEIGHT, 0, 0);
          glRotatef(-90, 1, 0, 0);
          gluPartialDisk(quadObject, 0, ASB10_SIDE_BOARD_TOP_RADIUS,
                         ASB10_SIDE_BOARD_TOP_SLICES, ASB10_SIDE_BOARD_TOP_LOOPS, 0, 180);
          drawCylinder(quadObject, 0, ASB10_SIDE_BOARD_TOP_RADIUS, ASB10_THICKNESS,
                       ASB10_SIDE_BOARD_TOP_SLICES, ASB10_SIDE_BOARD_TOP_STACKS, ASB10_SIDE_BOARD_TOP_LOOPS, 180);
          glTranslatef(0, 0, ASB10_THICKNESS);
          gluPartialDisk(quadObject, 0, ASB10_SIDE_BOARD_TOP_RADIUS,
                         ASB10_SIDE_BOARD_TOP_SLICES, ASB10_SIDE_BOARD_TOP_LOOPS, 0, 180);
        glPopMatrix();
        util.DisableMask();
      glPopMatrix();
    end;

begin
  LOG := TLogLogger.GetLogger('asb-10');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(77, 77, 77);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Untere Platte (Löcher)
    glPushMatrix();
      glTranslatef(0, ASB10_THICKNESS, 0);
      glRotatef(90, 1, 0, 0);
        drawHoles(quadObject, ASB10_CENTER_HOLE_RADIUS, ASB10_SMALL_HOLE_RADIUS, ASB10_SMALL_HOLE_DISTANCE,
                  ASB10_THICKNESS,
                  ASB10_CENTER_HOLE_SLICES, ASB10_HOLE_STACKS,
                  ASB10_SMALL_HOLE_SLICES, ASB10_HOLE_STACKS);
        util.PrepairMask();
        drawHolesMask(quadObject, ASB10_CENTER_HOLE_RADIUS, ASB10_SMALL_HOLE_RADIUS, ASB10_SMALL_HOLE_DISTANCE,
                  ASB10_THICKNESS,
                  ASB10_CENTER_HOLE_SLICES, ASB10_CENTER_HOLE_LOOPS,
                  ASB10_SMALL_HOLE_SLICES, ASB10_SMALL_HOLE_LOOPS);
    glPopMatrix();

    // Untere Platte
    util.AktivateMask();
    P1[0] := -ASB10_BOTTOM_BOARD_WIDTH / 2; P1[1] := 0;               P1[2] := -ASB10_DEPTH / 2;
    P2[0] := ASB10_BOTTOM_BOARD_WIDTH / 2;  P2[1] := ASB10_THICKNESS; P2[2] := ASB10_DEPTH / 2;
    drawQuad(P1, P2);
    util.DisableMask();

    // Zeichne linke Abrundung
    glPushMatrix();
      glTranslatef(-ASB10_BOTTOM_BOARD_WIDTH / 2, ASB10_THICKNESS, -ASB10_DEPTH / 2);
      glRotatef(180, 0, 0, 1);
      drawCylinder(quadObject, 0, ASB10_THICKNESS, ASB10_DEPTH,
                   getSlices(ASB10_THICKNESS), getStacks(ASB10_DEPTH), getLoops(ASB10_THICKNESS), 90);
      gluPartialDisk(quadObject, 0, ASB10_THICKNESS,
                   getSlices(ASB10_THICKNESS), getLoops(ASB10_THICKNESS), 0, 90);
      glTranslatef(0, 0, ASB10_DEPTH);
      gluPartialDisk(quadObject, 0, ASB10_THICKNESS,
                   getSlices(ASB10_THICKNESS), getLoops(ASB10_THICKNESS), 0, 90);
    glPopMatrix();

    // Zeichne rechte Abrundung
    glPushMatrix();
      glTranslatef(ASB10_BOTTOM_BOARD_WIDTH / 2, ASB10_THICKNESS, -ASB10_DEPTH / 2);
      glRotatef(-90, 0, 0, 1);
      drawCylinder(quadObject, 0, ASB10_THICKNESS, ASB10_DEPTH,
                   getSlices(ASB10_THICKNESS), getStacks(ASB10_DEPTH), getLoops(ASB10_THICKNESS), 90);
      gluPartialDisk(quadObject, 0, ASB10_THICKNESS,
                   getSlices(ASB10_THICKNESS), getLoops(ASB10_THICKNESS), 0, 90);
      glTranslatef(0, 0, ASB10_DEPTH);
      gluPartialDisk(quadObject, 0, ASB10_THICKNESS,
                   getSlices(ASB10_THICKNESS), getLoops(ASB10_THICKNESS), 0, 90);
    glPopMatrix();

    glTranslatef(-ASB10_BOTTOM_BOARD_WIDTH / 2 , 0, 0);
    drawSide();

    glTranslatef(ASB10_BOTTOM_BOARD_WIDTH + ASB10_THICKNESS, 0, 0);
    drawSide();
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung asb-13, welches sich auf der sich drehenden Platte auf dem Element 0 befindet
  und als Halterung für die Servos 1 und 2 dient.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawASB13(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    d1, d2 : TVector3d;

    procedure drawVerticalElement();
    begin
    // Zeichne vertikale Platte
    glPushMatrix();
      glRotatef(180, 0, 0, 1);
      gluPartialDisk(quadObject, 0, ASB13_THICKNESS, 10, 5, 0, 90);
      drawCylinder(quadObject, 0, ASB13_THICKNESS, ASB13_SIDE1_DEPTH, 10, 10, 5, 90);
      glTranslatef(0, 0, ASB13_SIDE1_DEPTH);
      gluPartialDisk(quadObject, 0, ASB13_THICKNESS, 10, 5, 0, 90);
      glRotatef(-180, 0, 0, 1);

      // Löcher
      glPushMatrix();
        glRotatef(-90, 0, 1, 0);
        glTranslatef(-ASB13_SIDE1_DEPTH / 2, ASB13_SIDE_BOTTOM_HOLE_DIST, 0);
        gluCylinder(quadObject, ASB13_SIDE_HOLE_RADIUS, ASB13_SIDE_HOLE_RADIUS, ASB13_THICKNESS, 30, 5);
        glTranslatef(0, ASB13_SIDE_TOP_HOLE_DIST, 0);
        gluCylinder(quadObject, ASB13_SIDE_HOLE_RADIUS, ASB13_SIDE_HOLE_RADIUS, ASB13_THICKNESS, 30, 5);
      glPopMatrix();

      // Masken vorbereiten
      util.PrepairMask();
      glPushMatrix();
        glRotatef(-90, 0, 1, 0);
        glTranslatef(-ASB13_SIDE1_DEPTH / 2, ASB13_SIDE_BOTTOM_HOLE_DIST, 0);
        drawHoleMask(quadObject, ASB13_SIDE_HOLE_RADIUS, ASB13_THICKNESS, 30, 15);
        glTranslatef(0, ASB13_SIDE_TOP_HOLE_DIST, 0);
        drawHoleMask(quadObject, ASB13_SIDE_HOLE_RADIUS, ASB13_THICKNESS, 30, 15);
      glPopMatrix();

      // vertikale Platte
      util.AktivateMask();
      glTranslatef(-ASB13_THICKNESS, 0, 0);
      d1[0] := 0; d1[1] := 0; d1[2] := -ASB13_SIDE1_DEPTH;
      d2[0] := ASB13_THICKNESS; d2[1] := ASB13_SIDE1_HEIGHT; d2[2] := 0;
      drawQuad(d1, d2);
      util.DisableMask();
    glPopMatrix();
    end;
begin
  LOG := TLogLogger.GetLogger('asb-13');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(77, 77, 77);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // hintere vertikale Platten
    glTranslatef(ASB13_MIDDLE_SIDE_DISTANCE, 0, ASB13_SIDE1_DEPTH);
    glPushMatrix();
      glTranslatef(0, ASB13_THICKNESS, -ASB13_SIDE1_DEPTH);
      drawVerticalElement();

      glRotatef(180, 0, 1, 0);
      glTranslatef(-ASB13_BOTTOM_SIDE1_WIDTH, 0, -ASB13_SIDE1_DEPTH);
      drawVerticalElement();
    glPopMatrix();

    // Untere Löcher
    glPushMatrix();
      glRotatef(90, 1, 0, 0);
      glTranslatef(ASB13_BOTTOM_HOLE_LEFT_DIST - ASB13_MIDDLE_SIDE_DISTANCE, ASB13_BOTTOM_HOLE_BACK_DIST - ASB13_SIDE1_DEPTH, -ASB13_THICKNESS);
      drawHoles(quadObject, ASB13_BOTTOM_CENTER_HOLE_RADIUS, ASB13_BOTTOM_SMALL_HOLE_RADIUS,
                ASB13_BOTTOM_SMALL_HOLE_DISTANCE, ASB13_THICKNESS, 30, 5, 20, 5);
    glPopMatrix();

    // Untere Maske der Löcher
    util.PrepairMask();
    glPushMatrix();
      glRotatef(90, 1, 0, 0);
      glTranslatef(ASB13_BOTTOM_HOLE_LEFT_DIST - ASB13_MIDDLE_SIDE_DISTANCE, ASB13_BOTTOM_HOLE_BACK_DIST - ASB13_SIDE1_DEPTH, -ASB13_THICKNESS);
      drawHolesMask(quadObject, ASB13_BOTTOM_CENTER_HOLE_RADIUS, ASB13_BOTTOM_SMALL_HOLE_RADIUS, ASB13_BOTTOM_SMALL_HOLE_DISTANCE, ASB13_THICKNESS, 30, 15, 20, 5);
    glPopMatrix();

    util.AktivateMask();
    // Zeichne hintere untere Platte
    d1[0] := 0; d1[1] := 0; d1[2] := -ASB13_SIDE1_DEPTH;
    d2[0] := ASB13_BOTTOM_SIDE1_WIDTH; d2[1] := ASB13_THICKNESS; d2[2] := 0;
    drawQuad(d1, d2);

    // Zeichne hintere untere schmale Trennplatte
    glTranslatef(ASB13_SIDE1_SIDE2_DISTANCE, 0, ASB13_BOOTOM_SIDE2_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := -ASB13_BOOTOM_SIDE2_DEPTH;
    d2[0] := ASB13_BOTTOM_SIDE2_WIDTH; d2[1] := ASB13_THICKNESS; d2[2] := 0;
    drawQuad(d1, d2);

    // Zeichne mittelere Platte
    glTranslatef(-ASB13_MIDDLE_SIDE2_DISTANCE, 0, ASB13_MIDDLE_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := -ASB13_MIDDLE_DEPTH;
    d2[0] := ASB13_MIDDLE_WIDTH; d2[1] := ASB13_THICKNESS; d2[2] := 0;
    drawQuad(d1, d2);
    util.DisableMask();

    // Zeichne vordere untere schmale Trennplatte
    glTranslatef(ASB13_MIDDLE_SIDE2_DISTANCE, 0, ASB13_BOOTOM_SIDE2_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := -ASB13_BOOTOM_SIDE2_DEPTH;
    d2[0] := ASB13_BOTTOM_SIDE2_WIDTH; d2[1] := ASB13_THICKNESS; d2[2] := 0;
    drawQuad(d1, d2);

    // Zeichne vordere untere Platte
    glTranslatef(-ASB13_SIDE1_SIDE2_DISTANCE, 0, ASB13_SIDE1_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := -ASB13_SIDE1_DEPTH;
    d2[0] := ASB13_BOTTOM_SIDE1_WIDTH; d2[1] := ASB13_THICKNESS; d2[2] := 0;
    drawQuad(d1, d2);

    // hintere vertikale Platten
    glPushMatrix();
      glTranslatef(0, ASB13_THICKNESS, -ASB13_SIDE1_DEPTH);
      drawVerticalElement();

      glRotatef(180, 0, 1, 0);
      glTranslatef(-ASB13_BOTTOM_SIDE1_WIDTH, 0, -ASB13_SIDE1_DEPTH);
      drawVerticalElement();
    glPopMatrix();
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung asb-14, welches den seitlichen Servo 5 hällt.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawASB14(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    p1, p2 : TVector3d;

    procedure drawSide();
    begin
      glPushMatrix();
        // Zeichne Quad 1
        glTranslatef(-ASB14_TD_QUAD1_WIDTH, 0, 0);
        p1[0] := 0; p1[1] := 0; p1[2] := 0;
        p2[0] := ASB14_TD_QUAD1_WIDTH; p2[1] := ASB14_TD_QUAD1_HEIGHT; p2[2] := ASB14_THICKNESS;
        drawQuad(p1, p2);

        // Zeichne Quad 2
        glTranslatef(-ASB14_TD_QUAD2_WIDTH, 0, 0);
        p1[0] := 0; p1[1] := 0; p1[2] := 0;
        p2[0] := ASB14_TD_QUAD2_WIDTH; p2[1] := ASB14_TD_QUAD2_HEIGHT; p2[2] := ASB14_THICKNESS;
        drawQuad(p1, p2);

        // Zeichne Quad 3
        glTranslatef(-ASB14_TD_QUAD3_WIDTH, 0, 0);
        p1[0] := 0; p1[1] := 0; p1[2] := 0;
        p2[0] := ASB14_TD_QUAD3_WIDTH; p2[1] := ASB14_TD_QUAD3_HEIGHT; p2[2] := ASB14_THICKNESS;
        drawQuad(p1, p2);

        // Zeichne Quad 4
        glTranslatef(0, ASB14_TD_QUAD3_HEIGHT, 0);
        p1[0] := 0; p1[1] := 0; p1[2] := 0;
        p2[0] := ASB14_TD_QUAD4_WIDTH; p2[1] := ASB14_TD_QUAD4_HEIGHT; p2[2] := ASB14_THICKNESS;
        drawQuad(p1, p2);

        // Zeichne Rundung
        glPushMatrix();
          glRotatef(180, 0, 0, 1);
          drawCylinder(quadObject, 0, ASB14_TD_QUAD3_HEIGHT, ASB14_THICKNESS,
                       getSlices(ASB14_TD_QUAD3_HEIGHT), getStacks(ASB14_THICKNESS),
                       getLoops(ASB14_TD_QUAD3_HEIGHT), 90);
          gluPartialDisk(quadObject, 0, ASB14_TD_QUAD3_HEIGHT,
                         getSlices(ASB14_TD_QUAD3_HEIGHT), getLoops(ASB14_TD_QUAD3_HEIGHT), 0, 90);
          glTranslatef(0, 0, ASB14_THICKNESS);
          gluPartialDisk(quadObject, 0, ASB14_TD_QUAD3_HEIGHT,
                         getSlices(ASB14_TD_QUAD3_HEIGHT), getLoops(ASB14_TD_QUAD3_HEIGHT), 0, 90);
        glPopMatrix();

        // Zeichne Quad 5
        glTranslatef(-ASB14_TD_QUAD5_WIDTH, 0, 0);
        p1[0] := 0; p1[1] := 0; p1[2] := 0;
        p2[0] := ASB14_TD_QUAD5_WIDTH; p2[1] := ASB14_TD_QUAD5_HEIGHT; p2[2] := ASB14_THICKNESS;
        drawQuad(p1, p2);
      glPopMatrix();
    end;
begin
  LOG := TLogLogger.GetLogger('bbh-01');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(77, 77, 77);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Zeichne seitliche abgerundete Platte mit Löchern
    glPushMatrix();
      drawHoles(quadObject, ASB14_LEFT_INNER_RADIUS, ASB14_LEFT_SMALL_HOLE_RADIUS, ASB14_LEFT_SMALL_HOLE_DIST,
                ASB14_THICKNESS, getSlices(ASB14_LEFT_INNER_RADIUS), getStacks(ASB14_THICKNESS),
                getSlices(ASB14_LEFT_SMALL_HOLE_RADIUS), getStacks(ASB14_THICKNESS));
    glPopMatrix();
    util.PrepairMask;
    glPushMatrix();
      drawHolesMask(quadObject, ASB14_LEFT_INNER_RADIUS, ASB14_LEFT_SMALL_HOLE_RADIUS, ASB14_LEFT_SMALL_HOLE_DIST,
                    ASB14_THICKNESS, getSlices(ASB14_LEFT_INNER_RADIUS), getLoops(ASB14_LEFT_INNER_RADIUS),
                    getSlices(ASB14_LEFT_SMALL_HOLE_RADIUS), getLoops(ASB14_LEFT_SMALL_HOLE_RADIUS));
    glPopMatrix();
    util.AktivateMask();
    drawCylinder(quadObject, ASB14_LEFT_INNER_RADIUS, ASB14_LEFT_OUTER_RADIUS, ASB14_THICKNESS,
                 getSlices(ASB14_LEFT_OUTER_RADIUS), getStacks(ASB14_THICKNESS), getLoops(ASB14_LEFT_OUTER_RADIUS), 180);
    gluPartialDisk(quadObject, ASB14_LEFT_INNER_RADIUS, ASB14_LEFT_OUTER_RADIUS, getSlices(ASB14_LEFT_OUTER_RADIUS),
                   getLoops(ASB14_LEFT_OUTER_RADIUS), 0, 180);
    glPushMatrix();
      glTranslatef(0, 0, ASB14_THICKNESS);
      gluPartialDisk(quadObject, ASB14_LEFT_INNER_RADIUS, ASB14_LEFT_OUTER_RADIUS, getSlices(ASB14_LEFT_OUTER_RADIUS),
                     getLoops(ASB14_LEFT_OUTER_RADIUS), 0, 180);
    glPopMatrix();

    // Zeiche seitlichen Quader
    glTranslatef(-ASB14_LEFT_QUADER_WIDTH, -ASB14_LEFT_OUTER_RADIUS, 0);
    p1[0] := 0; p1[1] := 0; p1[2] := 0;
    p2[0] := ASB14_LEFT_QUADER_WIDTH; p2[1] := ASB14_LEFT_QUADER_HEIGHT; p2[2] := ASB14_THICKNESS;
    drawQuad(p1, p2);
    util.DisableMask();

    // Zeichne mittleren Quader 1
    glTranslatef(-ASB14_MIDDLE1_QUADER_WIDTH, -ASB14_LEFT_MIDDLE1_DISTANCE, 0);
    p1[0] := 0; p1[1] := 0; p1[2] := 0;
    p2[0] := ASB14_MIDDLE1_QUADER_WIDTH; p2[1] := ASB14_MIDDLE1_QUADER_HEIGHT; p2[2] := ASB14_THICKNESS;
    drawQuad(p1, p2);

    // Zeichne untere Abrundung
    glPushMatrix();
      glRotatef(-90, 0, 0, 1);
      drawCylinder(quadObject, 0, ASB14_MIDDLE1_QUADER_WIDTH, ASB14_THICKNESS,
                   getSlices(ASB14_MIDDLE1_QUADER_WIDTH), getStacks(ASB14_THICKNESS),
                   getLoops(ASB14_MIDDLE1_QUADER_WIDTH), 90);
      gluPartialDisk(quadObject, 0, ASB14_MIDDLE1_QUADER_WIDTH,
                   getSlices(ASB14_MIDDLE1_QUADER_WIDTH), getLoops(ASB14_MIDDLE1_QUADER_WIDTH), 0, 90);
      glTranslatef(0, 0, ASB14_THICKNESS);
      gluPartialDisk(quadObject, 0, ASB14_MIDDLE1_QUADER_WIDTH,
                   getSlices(ASB14_MIDDLE1_QUADER_WIDTH), getLoops(ASB14_MIDDLE1_QUADER_WIDTH), 0, 90);
    glPopMatrix();

    // Zeichne obere Abrundung
    glPushMatrix();
      glTranslatef(0, ASB14_MIDDLE1_QUADER_HEIGHT, 0);
      drawCylinder(quadObject, 0, ASB14_MIDDLE1_QUADER_WIDTH, ASB14_THICKNESS,
                   getSlices(ASB14_MIDDLE1_QUADER_WIDTH), getStacks(ASB14_THICKNESS),
                   getLoops(ASB14_MIDDLE1_QUADER_WIDTH), 90);
      gluPartialDisk(quadObject, 0, ASB14_MIDDLE1_QUADER_WIDTH,
                   getSlices(ASB14_MIDDLE1_QUADER_WIDTH), getLoops(ASB14_MIDDLE1_QUADER_WIDTH), 0, 90);
      glTranslatef(0, 0, ASB14_THICKNESS);
      gluPartialDisk(quadObject, 0, ASB14_MIDDLE1_QUADER_WIDTH,
                   getSlices(ASB14_MIDDLE1_QUADER_WIDTH), getLoops(ASB14_MIDDLE1_QUADER_WIDTH), 0, 90);
    glPopMatrix();

    // Zeichne mittleren Quader 2
    glTranslatef(-ASB14_MIDDLE2_QUADER_WIDTH, -ASB14_MIDDLE1_QUADER_WIDTH, 0);
    p1[0] := 0; p1[1] := 0; p1[2] := 0;
    p2[0] := ASB14_MIDDLE2_QUADER_WIDTH; p2[1] := ASB14_MIDDLE2_QUADER_HEIGHT; p2[2] := ASB14_THICKNESS;
    drawQuad(p1, p2);

    drawSide();
    glRotatef(180, 1, 0, 0);
    glTranslatef(0, -ASB14_MIDDLE2_QUADER_HEIGHT, -ASB14_THICKNESS);
    drawSide();
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung bbh-01, welches sich zwischen Element 3 und Servo 5 befindet.
  Der Startpunkt befindet sich auf der Oberseite im Mittelpunkt der Scheibe.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawBBH01(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben

begin
  LOG := TLogLogger.GetLogger('bbh-01');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(77, 77, 77);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Zeichen Hauptzylinder
    gluCylinder(quadObject, BBH01_MAIN_IN_RADIUS, BBH01_MAIN_IN_RADIUS, BBH01_HEIGHT,
                BBH01_MAIN_SLICES, BBH01_MAIN_STACKS);
    gluCylinder(quadObject, BBH01_MAIN_OUT_RADIUS, BBH01_MAIN_OUT_RADIUS, BBH01_HEIGHT,
                BBH01_MAIN_SLICES, BBH01_MAIN_STACKS);

    // Zeichen inneren Zylinder
    gluCylinder(quadObject, BBH01_CENTER_IN_RADIUS, BBH01_CENTER_IN_RADIUS, BBH01_CENTER_HEIGHT,
                BBH01_MAIN_SLICES, BBH01_CENTER_STACKS);

    // Zeichne Schraubenlöcher
    for i := 0 to 4 do
    begin
      glPushMatrix();
        glRotatef(90 * i, 0, 0, 1);
        glTranslatef(0, BBH01_HOLES_DISTANCE, 0);
        gluCylinder(quadObject, BBH01_HOLES_RADIUS, BBH01_HOLES_RADIUS, BBH01_HEIGHT,
                    BBH01_HOLES_SLICES, BBH01_MAIN_STACKS);
      glPopMatrix();
    end;

    // Bereite Maske für die Schraubenlöcher vor
    util.PrepairMask();
    util.ConfigureSimple(quadObject, false);
    for i := 0 to 4 do
    begin
      glPushMatrix();
        glRotatef(90 * i, 0, 0, 1);
        glTranslatef(0, BBH01_HOLES_DISTANCE, 0);
        gluDisk(quadObject, 0, BBH01_HOLES_RADIUS, BBH01_HOLES_SLICES, BBH01_HOLES_LOOPS);
        glPushMatrix();
          glTranslatef(0, 0, BBH01_HEIGHT);
          gluDisk(quadObject, 0, BBH01_HOLES_RADIUS, BBH01_HOLES_SLICES, BBH01_HOLES_LOOPS);
        glPopMatrix();
      glPopMatrix();
    end;
    util.resetOriginalConfig(quadObject);

    // Zeiche Ober-, Mittel- und Unterseite
    util.AktivateMask();
    gluDisk(quadObject, BBH01_CENTER_IN_RADIUS, BBH01_MAIN_OUT_RADIUS, BBH01_MAIN_SLICES, BBH01_MAIN_LOOPS);
    glTranslatef(0, 0, BBH01_CENTER_HEIGHT);
    gluDisk(quadObject, BBH01_CENTER_IN_RADIUS, BBH01_MAIN_IN_RADIUS, BBH01_MAIN_SLICES, BBH01_CENTER_LOOPS);
    glTranslatef(0, 0, BBH01_HEIGHT - BBH01_CENTER_HEIGHT);
    gluDisk(quadObject, BBH01_MAIN_IN_RADIUS, BBH01_MAIN_OUT_RADIUS, BBH01_MAIN_SLICES, BBH01_MAIN_LOOPS);
    util.DisableMask();
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung drehteller, welches auf dem Element 0 liegt und über den Servo 0 gedreht werden
  kann.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawDrehTeller(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    slices : GLint;
    loops  : GLint;
    stacks : GLint;

begin
  LOG := TLogLogger.GetLogger('drawDrehTeller');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(121, 129, 160);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    glRotatef(90, 1, 0, 0);

    // Oberer Ring
    slices := getSlices(DT_TOP_RING_OUTER_RADIUS);
    loops := getLoops(DT_TOP_RING_OUTER_RADIUS - DT_TOP_RING_INNER_RADIUS);
    stacks := getStacks(DT_TOP_RING_HEIGHT);
    gluDisk(quadObject, DT_TOP_RING_INNER_RADIUS, DT_TOP_RING_OUTER_RADIUS, slices, loops);
    gluCylinder(quadObject, DT_TOP_RING_OUTER_RADIUS, DT_TOP_RING_OUTER_RADIUS, DT_TOP_RING_HEIGHT, slices, stacks);
    gluCylinder(quadObject, DT_TOP_RING_INNER_RADIUS, DT_TOP_RING_INNER_RADIUS, DT_TOP_RING_HEIGHT, slices, stacks);

    glTranslatef(0, 0, DT_TOP_RING_HEIGHT);
    gluDisk(quadObject, DT_TOP_RING_INNER_RADIUS, DT_TOP_RING_OUTER_RADIUS, slices, loops);

    // Löcher
    glPushMatrix();
      drawHoles(quadObject, DT_CENTER_HOLE_RADIUS, DT_SMALL_HOLE_RADIUS, DT_SMALL_HOLE_DISTANCE, DT_CENTER_HEIGHT, slices, 5, 20, 5);
    glPopMatrix();
    util.PrepairMask();
    glPushMatrix();
      drawHolesMask(quadObject, DT_CENTER_HOLE_RADIUS, DT_SMALL_HOLE_RADIUS, DT_SMALL_HOLE_DISTANCE, DT_CENTER_HEIGHT, slices, 5, 20, 5);
    glPopMatrix();

    util.AktivateMask();
    slices := getSlices(DT_CENTER_RADIUS);
    loops := getLoops(DT_CENTER_RADIUS - DT_CENTER_HOLE_RADIUS);
    gluDisk(quadObject, DT_CENTER_HOLE_RADIUS, DT_CENTER_RADIUS, slices, loops);

    gluCylinder(quadObject, DT_CENTER_RADIUS, DT_CENTER_RADIUS, DT_CENTER_HEIGHT, slices, stacks);
    slices := getSlices(DT_CENTER_HOLE_RADIUS);
    gluCylinder(quadObject, DT_CENTER_HOLE_RADIUS, DT_CENTER_HOLE_RADIUS, DT_CENTER_HEIGHT, slices, stacks);

    glTranslatef(0, 0, DT_CENTER_HEIGHT);
    slices := getSlices(DT_CENTER_RADIUS);
    loops := getLoops(DT_CENTER_RADIUS);
    gluDisk(quadObject, DT_CENTER_HOLE_RADIUS, DT_CENTER_RADIUS, slices, loops);
    util.DisableMask();

    // Unterer Ring
    glPushMatrix();
      slices := getSlices(DT_BOTTOM_RING_OUTER_RADIUS);
      stacks := getStacks(DT_BOTTOM_RING_HEIGHT);
      gluCylinder(quadObject, DT_BOTTOM_RING_OUTER_RADIUS, DT_BOTTOM_RING_OUTER_RADIUS, DT_BOTTOM_RING_HEIGHT, slices, stacks);
      slices := getSlices(DT_BOTTOM_RING_INNER_RADIUS);
      gluCylinder(quadObject, DT_BOTTOM_RING_INNER_RADIUS, DT_BOTTOM_RING_INNER_RADIUS, DT_BOTTOM_RING_HEIGHT, slices, stacks);
    glPopMatrix();

    glTranslatef(0, 0, DT_BOTTOM_RING_HEIGHT);
    glPushMatrix();
      slices := getSlices(DT_BOTTOM_RING_OUTER_RADIUS);
      loops := getLoops(DT_BOTTOM_RING_OUTER_RADIUS - DT_BOTTOM_RING_INNER_RADIUS);
      gluDisk(quadObject, DT_BOTTOM_RING_INNER_RADIUS, DT_BOTTOM_RING_OUTER_RADIUS, slices, loops);
    glPopMatrix();

  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung finger (left bzw. right).

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawFingerLeft(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    d1, d2 : TVector3d;
    p1, p2, p3 : TVector3d;

    procedure drawCylinder();
    begin
      glPushMatrix();
        glRotatef(90, 0, 1, 0);
        gluCylinder(quadObject, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_HOLE_HEIGHT, 30, 10);
        gluCylinder(quadObject, F_SIDE_QUAD_HOLE_OUT_RADIUS, F_SIDE_QUAD_HOLE_OUT_RADIUS, F_SIDE_QUAD_HOLE_HEIGHT, 30, 10);
        gluDisk(quadObject, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_HOLE_OUT_RADIUS, 30, 15);
        glPushMatrix();
          glTranslatef(0, 0, -F_SIDE_QUAD_HOLE_TOP_HEIGHT);
          gluCylinder(quadObject, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_HOLE_TOP_HEIGHT, 30, 10);
          gluCylinder(quadObject, F_SIDE_QUAD_HOLE_TOP_OUT_RADIUS, F_SIDE_QUAD_HOLE_TOP_OUT_RADIUS, F_SIDE_QUAD_HOLE_TOP_HEIGHT, 30, 10);
          gluDisk(quadObject, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_HOLE_TOP_OUT_RADIUS, 30, 15);
        glPopMatrix();
      glPopMatrix();
    end;
begin
  LOG := TLogLogger.GetLogger('drawFinger');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(121, 129, 160);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    glPushMatrix();
      // Zeichne oberen Quader 1
      glTranslatef(0, -F_BACK_QUAD1_HEIGHT, 0);
      d1[0] := 0; d1[1] := 0; d1[2] := 0;
      d2[0] := F_BACK_QUAD1_WIDTH; d2[1] := F_BACK_QUAD1_HEIGHT; d2[2] := F_BACK_QUAD1_DEPTH;
      drawQuad(d1, d2);
      glPushMatrix();
        // Zeichne unteren Quader 1
        glTranslatef(0, -F_BACK_QUAD1_DISTANCE - F_BACK_QUAD1_HEIGHT, 0);
        d1[0] := 0; d1[1] := 0; d1[2] := 0;
        d2[0] := F_BACK_QUAD1_WIDTH; d2[1] := F_BACK_QUAD1_HEIGHT; d2[2] := F_BACK_QUAD1_DEPTH;
        drawQuad(d1, d2);
      glPopMatrix();

      // Zeichne obere Führungsschiene
      glTranslatef(0, -F_BACK_PIN_HEIGHT, 0);
      d1[0] := 0; d1[1] := 0; d1[2] := 0;
      d2[0] := F_BACK_PIN_WIDTH; d2[1] := F_BACK_PIN_HEIGHT; d2[2] := F_BACK_PIN_DEPTH;
      drawQuad(d1, d2);
      glPushMatrix();
        // Zeichne untere Führungsschiene
        glTranslatef(0, -F_BACK_PIN_DISTANCE - F_BACK_PIN_HEIGHT, 0);
        d1[0] := 0; d1[1] := 0; d1[2] := 0;
        d2[0] := F_BACK_PIN_WIDTH; d2[1] := F_BACK_PIN_HEIGHT; d2[2] := F_BACK_PIN_DEPTH;
        drawQuad(d1, d2);
      glPopMatrix();
    glPopMatrix();

    // Zeichne oberen Quader 2
    glTranslatef(0, -F_BACK_QUAD2_HEIGHT, F_BACK_QUAD1_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := 0;
    d2[0] := F_BACK_QUAD2_WIDTH; d2[1] := F_BACK_QUAD2_HEIGHT; d2[2] := F_BACK_QUAD2_DEPTH;
    drawQuad(d1, d2);
    glPushMatrix();
      // Zeichne unteren Quader 2
      glTranslatef(0, -F_BACK_QUAD3_HEIGHT - F_BACK_QUAD2_HEIGHT, 0);
      d1[0] := 0; d1[1] := 0; d1[2] := 0;
      d2[0] := F_BACK_QUAD2_WIDTH; d2[1] := F_BACK_QUAD2_HEIGHT; d2[2] := F_BACK_QUAD2_DEPTH;
      drawQuad(d1, d2);
    glPopMatrix();

    // Zeichne Prisma
    glPushMatrix();
      glTranslatef(0, F_BACK_QUAD2_HEIGHT, F_BACK_QUAD2_DEPTH);
      p1[0] := 0; p1[1] := 0; p1[2] := 0;
      p2[0] := F_BACK_QUAD2_WIDTH - F_FRONT_QUAD1_WIDTH; p2[1] := 0; p2[2] := F_FRONT_QUAD1_DEPTH;
      p3[0] := F_BACK_QUAD2_WIDTH - F_FRONT_QUAD1_WIDTH; p3[1] := 0; p3[2] := 0;
      drawPrisma(p1, p2, p3, F_BACK_QUAD2_HEIGHT);
      glTranslatef(0, -F_BACK_QUAD3_HEIGHT - F_BACK_QUAD2_HEIGHT, 0);
      drawPrisma(p1, p2, p3, F_BACK_QUAD2_HEIGHT);
    glPopMatrix();

    glPushMatrix();
      // Zeichne Rückwand
      glTranslatef(0, -F_BACK_QUAD3_HEIGHT, 0);
      d1[0] := 0; d1[1] := 0; d1[2] := 0;
      d2[0] := F_BACK_QUAD3_WIDTH; d2[1] := F_BACK_QUAD3_HEIGHT; d2[2] := F_BACK_QUAD3_DEPTH;
      drawQuad(d1, d2);

      // Zeichne Seitenwand
      glPushMatrix();
        glTranslatef(F_BACK_QUAD3_WIDTH - F_SIDE_QUAD_HOLE_HEIGHT, F_SIDE_QUAD_HEIGHT / 2,
                     F_BACK_QUAD3_DEPTH + F_SIDE_QUAD_HOLE1_DISTANCE);
        drawCylinder();
        glTranslatef(0, 0, F_SIDE_QUAD_HOLE2_DISTANCE);
        drawCylinder();
      glPopMatrix();
      glPushMatrix();
        util.PrepairMask();
        glTranslatef(F_BACK_QUAD3_WIDTH - F_SIDE_QUAD_WIDTH, F_SIDE_QUAD_HEIGHT / 2,
                     F_BACK_QUAD3_DEPTH + F_SIDE_QUAD_HOLE1_DISTANCE);
        glRotatef(90, 0, 1, 0);
        drawHoleMask(quadObject, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_WIDTH, 30, 15);
        glTranslatef(-F_SIDE_QUAD_HOLE2_DISTANCE, 0, 0);
        drawHoleMask(quadObject, F_SIDE_QUAD_HOLE_IN_RADIUS, F_SIDE_QUAD_WIDTH, 30, 15);
      glPopMatrix();
      util.AktivateMask();
      glTranslatef(F_BACK_QUAD3_WIDTH - F_SIDE_QUAD_WIDTH, 0, F_BACK_QUAD3_DEPTH);
      d1[0] := 0; d1[1] := 0; d1[2] := 0;
      d2[0] := F_SIDE_QUAD_WIDTH; d2[1] := F_SIDE_QUAD_HEIGHT; d2[2] := F_SIDE_QUAD_DEPTH;
      drawQuad(d1, d2);
      util.DisableMask();
    glPopMatrix();

    glTranslatef(F_BACK_QUAD2_WIDTH - F_FRONT_QUAD1_WIDTH, 0, F_BACK_QUAD2_DEPTH);

    // Zeichne oberen Seitenquader
    d1[0] := 0; d1[1] := 0; d1[2] := 0;
    d2[0] := F_FRONT_QUAD1_WIDTH; d2[1] := F_FRONT_QUAD1_HEIGHT; d2[2] := F_FRONT_QUAD1_DEPTH;
    drawQuad(d1, d2);
    glTranslatef(0, -F_BACK_QUAD3_HEIGHT, 0);
    glPushMatrix();
      // Zeichne unteren Seitenquader
      glTranslatef(0, -F_FRONT_QUAD1_HEIGHT, 0);
      d1[0] := 0; d1[1] := 0; d1[2] := 0;
      d2[0] := F_FRONT_QUAD1_WIDTH; d2[1] := F_FRONT_QUAD1_HEIGHT; d2[2] := F_FRONT_QUAD1_DEPTH;
      drawQuad(d1, d2);
    glPopMatrix();

    glTranslatef(0, 0, F_FRONT_QUAD1_DEPTH - F_FRONT_QUAD2_DEPTH);

    // Zeichne vorderen Quader
    d1[0] := 0; d1[1] := 0; d1[2] := 0;
    d2[0] := F_FRONT_QUAD2_WIDTH; d2[1] := F_FRONT_QUAD2_HEIGHT; d2[2] := F_FRONT_QUAD2_DEPTH;
    drawQuad(d1, d2);

    // Zeichne Pad
    glTranslatef(F_FRONT_QUAD1_WIDTH, -F_FRONT_QUAD1_HEIGHT, F_FRONT_QUAD2_DEPTH - F_PAD_QUAD_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := 0;
    d2[0] := F_PAD_QUAD_WIDTH; d2[1] := F_PAD_QUAD_HEIGHT; d2[2] := F_PAD_QUAD_DEPTH;
    drawQuad(d1, d2);
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung gripper wrist, welches die beiden Greiffinger hällt.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawGripperWrist(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    d1, d2 : TVector3d;

    procedure drawAttach();
    begin
      glPushMatrix();
        // Zeichne Löcher der Halterungsschine
        glPushMatrix();
          glTranslatef(0, -GW_BACK_ATTACH_CENTER_HEIGHT / 2, 0);
          glTranslatef(GW_BACK_ATTACH_WIDTH / 2, 0, 0);
          gluCylinder(quadObject, GW_BACK_ATTACH_HOLE_RADIUS, GW_BACK_ATTACH_HOLE_RADIUS, GW_BACK_ATTACH_DEPTH,
                      GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
          glPushMatrix();
            glTranslatef(0, GW_BACK_ATTACH_CENTER_HEIGHT, 0);
            gluCylinder(quadObject, GW_BACK_ATTACH_HOLE_RADIUS, GW_BACK_ATTACH_HOLE_RADIUS, GW_BACK_ATTACH_DEPTH,
                        GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
          glPopMatrix();
          util.PrepairMask();
          drawHoleMask(quadObject, GW_BACK_ATTACH_HOLE_RADIUS, GW_BACK_ATTACH_DEPTH, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);
          glTranslatef(0, GW_BACK_ATTACH_CENTER_HEIGHT, 0);
          drawHoleMask(quadObject, GW_BACK_ATTACH_HOLE_RADIUS, GW_BACK_ATTACH_DEPTH, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);
        glPopMatrix();

        // Zeichne Halterungsschiene
        util.AktivateMask();
        glTranslatef(0, -GW_BACK_ATTACH_CENTER_HEIGHT / 2, 0);
        d1[0] := 0; d1[1] := 0; d1[2] := 0;
        d2[0] := GW_BACK_ATTACH_WIDTH; d2[1] := GW_BACK_ATTACH_CENTER_HEIGHT; d2[2] := GW_BACK_ATTACH_DEPTH;
        drawQuad(d1, d2);
        glTranslatef(GW_BACK_ATTACH_WIDTH / 2, 0, 0);
        glRotatef(-90, 0, 0, 1);
        gluPartialDisk(quadObject, 0, GW_BACK_ATTACH_WIDTH / 2, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS, 0, 180);
        drawCylinder(quadObject, 0, GW_BACK_ATTACH_WIDTH / 2, GW_BACK_ATTACH_DEPTH,
                     GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS, GW_BACK_ZYLINDER_LOOPS, 180);
        glTranslatef(0, 0, GW_BACK_ATTACH_DEPTH);
        gluPartialDisk(quadObject, 0, GW_BACK_ATTACH_WIDTH / 2, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS, 0, 180);
        glRotatef(90, 0, 0, 1);
        glTranslatef(0, GW_BACK_ATTACH_CENTER_HEIGHT, -GW_BACK_ATTACH_DEPTH);
        glRotatef(90, 0, 0, 1);
        gluPartialDisk(quadObject, 0, GW_BACK_ATTACH_WIDTH / 2, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS, 0, 180);
        drawCylinder(quadObject, 0, GW_BACK_ATTACH_WIDTH / 2, GW_BACK_ATTACH_DEPTH,
                     GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS, GW_BACK_ZYLINDER_LOOPS, 180);
        glTranslatef(0, 0, GW_BACK_ATTACH_DEPTH);
        gluPartialDisk(quadObject, 0, GW_BACK_ATTACH_WIDTH / 2, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS, 0, 180);
        util.DisableMask();
      glPopMatrix();
    end;
begin
  LOG := TLogLogger.GetLogger('GripperWrist');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(121, 129, 160);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Zeichne hinteren Zylinder
    gluDisk(quadObject, GW_BACK_ZYLINDER_IN_RADIUS1, GW_BACK_ZYLINDER_OUT_RADIUS,
            GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);
    glTranslatef(0, 0, -GW_BACK_ZYLINDER_DEPTH1);
    gluCylinder(quadObject, GW_BACK_ZYLINDER_OUT_RADIUS, GW_BACK_ZYLINDER_OUT_RADIUS,
            GW_BACK_ZYLINDER_DEPTH1, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
    glTranslatef(0, 0, GW_BACK_ZYLINDER_DEPTH2);
    gluCylinder(quadObject, GW_BACK_ZYLINDER_IN_RADIUS1, GW_BACK_ZYLINDER_IN_RADIUS1,
            GW_BACK_ZYLINDER_DEPTH1 - GW_BACK_ZYLINDER_DEPTH2, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
    gluDisk(quadObject, GW_BACK_ZYLINDER_IN_RADIUS3, GW_BACK_ZYLINDER_IN_RADIUS1,
            GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);
    glTranslatef(0, 0, -GW_BACK_ZYLINDER_DEPTH2);
    gluCylinder(quadObject, GW_BACK_ZYLINDER_IN_RADIUS3, GW_BACK_ZYLINDER_IN_RADIUS3,
            GW_BACK_ZYLINDER_DEPTH2, GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
    gluDisk(quadObject, GW_BACK_ZYLINDER_IN_RADIUS3, GW_BACK_ZYLINDER_OUT_RADIUS,
            GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);

    // Zeichne Befestigungsschienen
    glPushMatrix();
      glTranslatef(-GW_BACK_QUADER_WIDTH / 2, 0, 0);
      drawAttach();
      glTranslatef(GW_BACK_QUADER_WIDTH - GW_BACK_ATTACH_WIDTH, 0, 0);
      drawAttach();
    glPopMatrix();

    // Zeichne hinteren Quader
    glPushMatrix();
      glTranslatef(0, 0, -GW_BACK_QUADER_DEPTH);
      gluCylinder(quadObject, GW_BACK_QUADER_HOLE_RADIUS, GW_BACK_QUADER_HOLE_RADIUS, GW_BACK_QUADER_DEPTH,
                  GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
      util.PrepairMask();
      drawHoleMask(quadObject, GW_BACK_QUADER_HOLE_RADIUS, GW_BACK_QUADER_DEPTH,
                  GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);
    glPopMatrix();
    util.AktivateMask();
    glTranslatef(-GW_BACK_QUADER_WIDTH / 2, -GW_BACK_QUADER_HOLE_BOTTOM_DISTANCE, -GW_BACK_QUADER_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := 0;
    d2[0] := GW_BACK_QUADER_WIDTH; d2[1] := GW_BACK_QUADER_HEIGHT; d2[2] := GW_BACK_QUADER_DEPTH;
    drawQuad(d1, d2);
    util.DisableMask();

    // Zeichne unteren Quader
    glPushMatrix();
      glTranslatef(GW_BOTTOM_QUADER_WIDTH / 2, GW_BOTTOM_QUADER_HEIGHT, -GW_BOTTOM_QUADER_DEPTH / 2);
      glRotatef(90, 1, 0, 0);
      gluCylinder(quadObject, GW_BOTTOM_QUADER_HOLE_RADIUS, GW_BOTTOM_QUADER_HOLE_RADIUS, GW_BOTTOM_QUADER_HEIGHT,
                  GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
      util.PrepairMask();
      drawHoleMask(quadObject, GW_BOTTOM_QUADER_HOLE_RADIUS, GW_BOTTOM_QUADER_HEIGHT,
                  GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);
    glPopMatrix();
    util.AktivateMask();
    d1[0] := 0; d1[1] := 0; d1[2] := -GW_BOTTOM_QUADER_DEPTH;
    d2[0] := GW_BOTTOM_QUADER_WIDTH; d2[1] := GW_BOTTOM_QUADER_HEIGHT; d2[2] := 0;
    drawQuad(d1, d2);
    util.DisableMask();

    // Zeichne vorderen Quader
    glPushMatrix();
    glTranslatef(GW_FRONT_QUADER_WIDTH / 2, GW_FRONT_QUADER_HEIGHT / 2, -GW_BOTTOM_QUADER_DEPTH - GW_FRONT_QUADER_DEPTH);
      gluCylinder(quadObject, GW_FRONT_QUADER_HOLE_RADIUS, GW_FRONT_QUADER_HOLE_RADIUS, GW_FRONT_QUADER_DEPTH,
                  GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_STACKS);
      util.PrepairMask();
      drawHoleMask(quadObject, GW_FRONT_QUADER_HOLE_RADIUS, GW_FRONT_QUADER_DEPTH,
                  GW_BACK_ZYLINDER_SLICES, GW_BACK_ZYLINDER_LOOPS);
    glPopMatrix();
    util.AktivateMask();
    glTranslatef(0, GW_BACK_QUADER_HEIGHT - GW_FRONT_QUADER_HEIGHT, -GW_BOTTOM_QUADER_DEPTH - GW_FRONT_QUADER_DEPTH);
    d1[0] := 0; d1[1] := 0; d1[2] := 0;
    d2[0] := GW_FRONT_QUADER_WIDTH; d2[1] := GW_FRONT_QUADER_HEIGHT; d2[2] := GW_FRONT_QUADER_DEPTH;
    drawQuad(d1, d2);
    util.DisableMask();

    // Zeichne untere Führungsschiene
    d1[0] := 0; d1[1] := -GW_FRONT_PIN_HEIGHT; d1[2] := 0;
    d2[0] := GW_FRONT_PIN_WIDTH; d2[1] := 0; d2[2] := GW_FRONT_PIN_DEPTH;
    drawQuad(d1, d2);

    glTranslatef(0, GW_FRONT_QUADER_HEIGHT, 0);

    // Zeichne obere Führungsschiene
    d1[0] := 0; d1[1] := 0; d1[2] := 0;
    d2[0] := GW_FRONT_PIN_WIDTH; d2[1] := GW_FRONT_PIN_HEIGHT; d2[2] := GW_FRONT_PIN_DEPTH;
    drawQuad(d1, d2);
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung servo cover, welches den oberen Teil der Servos bildet.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawServo(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i      : Integer;           // Zählvariable
    util   : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG    : TLogLogger;        // Logger für Debugausgaben
    p1, p2 : TVector3d;

    procedure drawSide();
    begin
      // Zeichne Seitenplatte
      glTranslatef(SC_SIDE_QUADER_WIDTH, SC_SIDE_QUADER_BOTTOM_DIST, 0);
      glPushMatrix();
        glPushMatrix();
          glTranslatef(-SC_SIDE_HOLE_LEFT_DISTANCE, SC_SIDE_HOLE_DISTANCE, -SC_SIDE_QUADER_DEPTH);
          gluCylinder(quadObject, SC_SIDE_HOLE_RADIUS, SC_SIDE_HOLE_RADIUS, SC_SIDE_QUADER_DEPTH,
                      getSlices(SC_SIDE_HOLE_RADIUS), getStacks(SC_SIDE_QUADER_DEPTH));
        glPopMatrix();
        glTranslatef(0, SC_SIDE_QUADER_HEIGHT, 0);
        glTranslatef(-SC_SIDE_HOLE_LEFT_DISTANCE, -SC_SIDE_HOLE_DISTANCE, -SC_SIDE_QUADER_DEPTH);
        gluCylinder(quadObject, SC_SIDE_HOLE_RADIUS, SC_SIDE_HOLE_RADIUS, SC_SIDE_QUADER_DEPTH,
                    getSlices(SC_SIDE_HOLE_RADIUS), getStacks(SC_SIDE_QUADER_DEPTH));
      glPopMatrix();
      util.PrepairMask();
      glPushMatrix();
        glPushMatrix();
          glTranslatef(-SC_SIDE_HOLE_LEFT_DISTANCE, SC_SIDE_HOLE_DISTANCE, -SC_SIDE_QUADER_DEPTH);
          drawHoleMask(quadObject, SC_SIDE_HOLE_RADIUS, SC_SIDE_QUADER_DEPTH,
                       getSlices(SC_SIDE_HOLE_RADIUS), getLoops(SC_SIDE_HOLE_RADIUS));
        glPopMatrix();
        glTranslatef(0, SC_SIDE_QUADER_HEIGHT, 0);
        glTranslatef(-SC_SIDE_HOLE_LEFT_DISTANCE, -SC_SIDE_HOLE_DISTANCE, -SC_SIDE_QUADER_DEPTH);
        drawHoleMask(quadObject, SC_SIDE_HOLE_RADIUS, SC_SIDE_QUADER_DEPTH,
                     getSlices(SC_SIDE_HOLE_RADIUS), getLoops(SC_SIDE_HOLE_RADIUS));
      glPopMatrix();
      util.AktivateMask();
      p1[0] := -SC_SIDE_QUADER_WIDTH; p1[1] := 0; p1[2] := -SC_SIDE_QUADER_DEPTH;
      p2[0] := 0; p2[1] := SC_SIDE_QUADER_HEIGHT; p2[2] := 0;
      drawQuad(p1, p2);
      util.DisableMask();
    end;

begin
  LOG := TLogLogger.GetLogger('drawServoCover');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(25, 25, 25);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Zeichne obersten Ring
    gluCylinder(quadObject, SC_TOP1_INNER_RADIUS, SC_TOP1_INNER_RADIUS, SC_TOP1_HEIGHT,
                getSlices(SC_TOP1_INNER_RADIUS), getStacks(SC_TOP1_HEIGHT));
    gluCylinder(quadObject, SC_TOP1_OUTER_RADIUS, SC_TOP1_OUTER_RADIUS, SC_TOP1_HEIGHT,
                getSlices(SC_TOP1_INNER_RADIUS), getStacks(SC_TOP1_HEIGHT));
    gluDisk(quadObject, SC_TOP1_INNER_RADIUS, SC_TOP1_OUTER_RADIUS,
            getSlices(SC_TOP1_OUTER_RADIUS), getLoops(SC_TOP1_OUTER_RADIUS - SC_TOP1_INNER_RADIUS));

    // Zeichne zweiten Ring
    glTranslatef(0, 0, SC_TOP1_TOP2_DISTANCE);
    gluCylinder(quadObject, SC_TOP2_INNER_RADIUS, SC_TOP2_INNER_RADIUS, SC_TOP2_HEIGHT,
                getSlices(SC_TOP2_INNER_RADIUS), getStacks(SC_TOP2_HEIGHT));
    gluCylinder(quadObject, SC_TOP2_OUTER_RADIUS, SC_TOP2_OUTER_RADIUS, SC_TOP2_HEIGHT,
                getSlices(SC_TOP2_INNER_RADIUS), getStacks(SC_TOP2_HEIGHT));
    gluDisk(quadObject, SC_TOP2_INNER_RADIUS, SC_TOP2_OUTER_RADIUS,
            getSlices(SC_TOP2_OUTER_RADIUS), getLoops(SC_TOP2_OUTER_RADIUS - SC_TOP2_INNER_RADIUS));

    // Zeichne Teilzylinder
    glTranslatef(0, 0, SC_TOP2_HEIGHT);
    glPushMatrix();
      glRotatef((SC_TOP_FRONT_SWEEPANGLE - 180) / 2, 0, 0, 1);
      drawCylinder(quadObject, SC_TOP_FRONT_INNER_RADIUS, SC_TOP_FRONT_OUTER_RADIUS, SC_TOP_FRONT_HEIGHT,
                   getSlices(SC_TOP_FRONT_OUTER_RADIUS), getStacks(SC_TOP_FRONT_HEIGHT),
                   getLoops(SC_TOP_FRONT_OUTER_RADIUS), SC_TOP_FRONT_SWEEPANGLE);
      gluPartialDisk(quadObject, SC_TOP_FRONT_INNER_RADIUS, SC_TOP_FRONT_OUTER_RADIUS,
                   getSlices(SC_TOP_FRONT_OUTER_RADIUS), getLoops(SC_TOP_FRONT_OUTER_RADIUS), 0, SC_TOP_FRONT_SWEEPANGLE);
    glPopMatrix();

    // oberen Quader
    glPushMatrix();
      glRotatef(180, 0, 0, 1);
      drawCylinder(quadObject, SC_TOP_FRONT_INNER_RADIUS, SC_TOP_FRONT_INNER_RADIUS, SC_TOP_QUADER_DEPTH,
                  getSlices(SC_TOP_FRONT_INNER_RADIUS), getStacks(SC_TOP_QUADER_DEPTH),
                  getLoops(SC_TOP_FRONT_INNER_RADIUS), 180);
    glPopMatrix();
    util.PrepairMask();
    glPushMatrix();
      glRotatef(180, 0, 0, 1);
      drawHoleMask(quadObject, SC_TOP_FRONT_INNER_RADIUS, SC_TOP_QUADER_DEPTH,
                   getSlices(SC_TOP_FRONT_INNER_RADIUS), getLoops(SC_TOP_FRONT_INNER_RADIUS));
    glPopMatrix();
    util.AktivateMask();
    glTranslatef(0, 0, SC_TOP_QUADER_DEPTH);
    glPushMatrix();
      glTranslatef(0, -SC_TOP_QUADER_HEIGHT / 2, 0);
      p1[0] := -SC_TOP_QUADER_WIDTH; p1[1] := 0; p1[2] := -SC_TOP_QUADER_DEPTH;
      p2[0] := 0; p2[1] := SC_TOP_QUADER_HEIGHT; p2[2] := 0;
      drawQuad(p1, p2);
    glPopMatrix();
    util.DisableMask();

    glPushMatrix();
      gluCylinder(quadObject, SC_TOP_FRONT_INNER_RADIUS, SC_TOP_FRONT_INNER_RADIUS, SC_MAIN_QUADER_DEPTH,
                  getSlices(SC_TOP_FRONT_INNER_RADIUS), getStacks(SC_MAIN_QUADER_DEPTH));
    glPopMatrix();
    util.PrepairMask();
    glPushMatrix();
      drawHoleMask(quadObject, SC_TOP_FRONT_INNER_RADIUS, SC_MAIN_QUADER_DEPTH,
                   getSlices(SC_TOP_FRONT_INNER_RADIUS), getLoops(SC_TOP_FRONT_INNER_RADIUS));
    glPopMatrix();
    util.AktivateMask();
    glTranslatef(SC_TOP_FRONT_OUTER_RADIUS, -SC_MAIN_QUADER_HEIGHT / 2, SC_MAIN_QUADER_DEPTH);
    p1[0] := -SC_MAIN_QUADER_WIDTH; p1[1] := 0; p1[2] := -SC_MAIN_QUADER_DEPTH;
    p2[0] := 0; p2[1] := SC_MAIN_QUADER_HEIGHT; p2[2] := 0;
    drawQuad(p1, p2);
    util.DisableMask();

    // Zeichne Seitenplatten für die Befestigungsschrauben

    glPushMatrix();
      glTranslatef(0, 0, -SC_SIDE_QUADER_DEPTH_DIST);
      drawSide();
      glRotatef(180, 0, 0, 1);
      glTranslatef(SC_MAIN_QUADER_WIDTH + SC_SIDE_QUADER_WIDTH, -SC_SIDE_QUADER_HEIGHT - SC_SIDE_QUADER_BOTTOM_DIST,
                   0);
      drawSide();
    glPopMatrix();

    glTranslatef(-(SC_MAIN_QUADER_WIDTH - SC_BOTTOM_QUADER_WIDTH) / 2,
                  (SC_MAIN_QUADER_HEIGHT - SC_BOTTOM_QUADER_HEIGHT) / 2, SC_BOTTOM_QUADER_DEPTH);
    p1[0] := -SC_BOTTOM_QUADER_WIDTH; p1[1] := 0; p1[2] := -SC_BOTTOM_QUADER_DEPTH;
    p2[0] := 0; p2[1] := SC_BOTTOM_QUADER_HEIGHT; p2[2] := 0;
    drawQuad(p1, p2);

  glPopMatrix()
end;

{
  Dies ist das Teil mit der Bezeichnung ServoHornPlastic, welches sich zwischen den Elementen und den Servos befindet.
  Der Startpunkt befindet sich auf der Oberseite im Mittelpunkt der Scheibe.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawServoHornPlastic(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var i    : Integer;           // Zählvariable
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben

    procedure drawHoleMask();
    begin
      glPushMatrix();
        glTranslatef(0, SHP_SMALL_HOLE_DISTANCE, 0);
        gluDisk(quadObject, 0, SHP_SMALL_HOLE_RADIUS, SHP_SMALL_HOLE_SLICES, SHP_SMALL_HOLE_LOOPS);
        glPushMatrix();
          glTranslatef(0, 0, SHP_CENTER_HEIGHT);
          gluDisk(quadObject, 0, SHP_SMALL_HOLE_RADIUS, SHP_SMALL_HOLE_SLICES, SHP_SMALL_HOLE_LOOPS);
        glPopMatrix();
      glPopMatrix();
    end;
begin
  LOG := TLogLogger.GetLogger('ServoHornPlastic');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(144, 144, 144);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Oberer Ring
    gluCylinder(quadObject, SHP_TOP_RING_OUTER_RADIUS, SHP_TOP_RING_OUTER_RADIUS, SHP_TOP_RING_HEIGHT,
                SHP_TOP_RING_SLICES, SHP_TOP_RING_STACKS);
    gluCylinder(quadObject, SHP_TOP_RING_INNER_RADIUS, SHP_TOP_RING_INNER_RADIUS, SHP_TOP_RING_HEIGHT,
                SHP_TOP_RING_SLICES, SHP_TOP_RING_STACKS);
    gluDisk(quadObject, SHP_TOP_RING_INNER_RADIUS, SHP_TOP_RING_OUTER_RADIUS, SHP_TOP_RING_SLICES, SHP_TOP_RING_LOOPS);

    glTranslatef(0, 0, SHP_TOP_RING_HEIGHT / 2);

    // Mittlerer Ring
    gluCylinder(quadObject, SHP_CENTER_RING_OUTER_RADIUS, SHP_CENTER_RING_OUTER_RADIUS, SHP_CENTER_HEIGHT,
                SHP_CENTER_RING_SLICES, SHP_CENTER_RING_STACKS);
    gluCylinder(quadObject, SHP_CENTER_RING_INNER_RADIUS, SHP_CENTER_RING_INNER_RADIUS, SHP_CENTER_HEIGHT,
                SHP_CENTER_RING_SLICES, SHP_CENTER_RING_STACKS);

    // Schraubenlöcher
    glPushMatrix();
      for i := 0 to 3 do
      begin
        glRotatef(90 * i, 0, 0, 1);
        glPushMatrix();
          glRotatef(-SHP_SMALL_HOLE_ANGLE, 0, 0, 1);
          glPushMatrix();
            glPushMatrix();
              glTranslatef(0, SHP_SMALL_HOLE_DISTANCE, 0);
              gluCylinder(quadObject, SHP_SMALL_HOLE_RADIUS, SHP_SMALL_HOLE_RADIUS, SHP_CENTER_HEIGHT,
                          SHP_SMALL_HOLE_SLICES, SHP_CENTER_RING_STACKS);
            glPopMatrix();

            glRotatef(SHP_SMALL_HOLE_ANGLE, 0, 0, 1);
            glPushMatrix();
              glTranslatef(0, SHP_SMALL_HOLE_DISTANCE, 0);
              gluCylinder(quadObject, SHP_SMALL_HOLE_RADIUS, SHP_SMALL_HOLE_RADIUS, SHP_CENTER_HEIGHT,
                          SHP_SMALL_HOLE_SLICES, SHP_CENTER_RING_STACKS);
            glPopMatrix();

            glRotatef(SHP_SMALL_HOLE_ANGLE, 0, 0, 1);
            glPushMatrix();
              glTranslatef(0, SHP_SMALL_HOLE_DISTANCE, 0);
              gluCylinder(quadObject, SHP_SMALL_HOLE_RADIUS, SHP_SMALL_HOLE_RADIUS, SHP_CENTER_HEIGHT,
                          SHP_SMALL_HOLE_SLICES, SHP_CENTER_RING_STACKS);
            glPopMatrix();
          glPopMatrix();
        glPopMatrix();
      end;
    glPopMatrix();

    // Erstelle Maske für die Schraubenlöcher und zeichne Ober- und Unterseite der mittleren großen Scheibe
    glPushMatrix();
      util.PrepairMask();
      util.ConfigureSimple(quadObject, false);
      for i := 0 to 3 do
      begin
        glRotatef(90 * i , 0, 0, 1);
        glPushMatrix();
          glRotatef(-SHP_SMALL_HOLE_ANGLE, 0, 0, 1);
          glPushMatrix();
            drawHoleMask();
            glRotatef(SHP_SMALL_HOLE_ANGLE, 0, 0, 1);
            drawHoleMask();
            glRotatef(SHP_SMALL_HOLE_ANGLE, 0, 0, 1);
            drawHoleMask();
          glPopMatrix();
        glPopMatrix();
      end;
      util.resetOriginalConfig(quadObject);

      util.AktivateMask();
      gluDisk(quadObject, SHP_CENTER_RING_INNER_RADIUS, SHP_CENTER_RING_OUTER_RADIUS,
              SHP_CENTER_RING_SLICES, SHP_CENTER_RING_LOOPS);
      glPushMatrix();
        glTranslatef(0, 0, SHP_CENTER_HEIGHT);
        gluDisk(quadObject, SHP_CENTER_RING_INNER_RADIUS, SHP_CENTER_RING_OUTER_RADIUS,
                SHP_CENTER_RING_SLICES, SHP_CENTER_RING_LOOPS);
      glPopMatrix();
      util.DisableMask();
    glPopMatrix();

    glTranslatef(0, 0, SHP_TOP_RING_HEIGHT / 2);

    // Zeichne inneren kleinen Ring
    glPushMatrix();
      gluCylinder(quadObject, SHP_CENTER_SMALL_RING_INNER_RADIUS, SHP_CENTER_SMALL_RING_INNER_RADIUS,
                  SHP_CENTER_SMALL_HEIGHT, SHP_CENTER_SMALL_SLICES, SHP_CENTER_SMALL_STACKS);
      gluDisk(quadObject, SHP_CENTER_SMALL_RING_INNER_RADIUS, SHP_CENTER_SMALL_RING_OUTER_RADIUS,
              SHP_CENTER_SMALL_SLICES, SHP_CENTER_SMALL_LOOPS);
      glTranslatef(0, 0, SHP_CENTER_SMALL_HEIGHT);
      gluDisk(quadObject, SHP_CENTER_SMALL_RING_INNER_RADIUS, SHP_CENTER_SMALL_RING_OUTER_RADIUS,
              SHP_CENTER_SMALL_SLICES, SHP_CENTER_SMALL_LOOPS);
    glPopMatrix();

    glTranslatef(0, 0, SHP_CENTER_HEIGHT - SHP_CENTER_SMALL_HEIGHT);

    // Unterer Ring
    glPushMatrix();
      gluCylinder(quadObject, SHP_BOTTOM_RING_OUTER_RADIUS, SHP_BOTTOM_RING_OUTER_RADIUS, SHP_BOTTOM_RING_HEIGHT,
                  SHP_BOTTOM_SMALL_SLICES, SHP_BOTTOM_SMALL_STACKS);
      gluCylinder(quadObject, SHP_BOTTOM_RING_INNER_RADIUS, SHP_BOTTOM_RING_INNER_RADIUS, SHP_BOTTOM_RING_HEIGHT,
                  SHP_BOTTOM_SMALL_SLICES, SHP_BOTTOM_SMALL_STACKS);
      glTranslatef(0, 0, SHP_BOTTOM_RING_HEIGHT);
      gluDisk(quadObject, SHP_BOTTOM_RING_INNER_RADIUS, SHP_BOTTOM_RING_OUTER_RADIUS,
              SHP_BOTTOM_SMALL_SLICES, SHP_BOTTOM_SMALL_LOOPS);
    glPopMatrix();
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung Teil 1. Es befindet sich vor dem Servo 5 und hällt den Greifer.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawTeil1(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var d1, d2 : TVector3d;
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben

begin
  LOG := TLogLogger.GetLogger('drawTeil1');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(121, 129, 160);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);
    glTranslatef(-T1_WIDTH / 2 - T1_CORNER_RADIUS, T1_HEIGHT / 2 + T1_CORNER_RADIUS, 0);

    // Oberes linkes Befestigungsloch
    glPushMatrix();
      glTranslatef(T1_CORNER_HOLE_DISTANCE, -T1_CORNER_HOLE_DISTANCE, 0);
      gluCylinder(quadObject, T1_CORNER_HOLE_RADIUS, T1_CORNER_HOLE_RADIUS, T1_THICKNESS,
                  T1_CENTER_HOLE_SLICES, T1_STACKS);
    glPopMatrix();
    // Unteres linkes Befestigungsloch
    glPushMatrix();
      glTranslatef(T1_CORNER_HOLE_DISTANCE, -T1_TOTAL_HEIGHT + T1_CORNER_HOLE_DISTANCE, 0);
      gluCylinder(quadObject, T1_CORNER_HOLE_RADIUS, T1_CORNER_HOLE_RADIUS, T1_THICKNESS,
                  T1_CENTER_HOLE_SLICES, T1_STACKS);
    glPopMatrix();
    // Oberes rechtes Befestigungsloch
    glPushMatrix();
      glTranslatef(T1_TOTAL_WIDTH - T1_CORNER_HOLE_DISTANCE, -T1_CORNER_HOLE_DISTANCE, 0);
      gluCylinder(quadObject, T1_CORNER_HOLE_RADIUS, T1_CORNER_HOLE_RADIUS, T1_THICKNESS,
                  T1_CENTER_HOLE_SLICES, T1_STACKS);
    glPopMatrix();
    // Unteres rechtes Befestigungsloch
    glPushMatrix();
      glTranslatef(T1_TOTAL_WIDTH - T1_CORNER_HOLE_DISTANCE, -T1_TOTAL_HEIGHT + T1_CORNER_HOLE_DISTANCE, 0);
      gluCylinder(quadObject, T1_CORNER_HOLE_RADIUS, T1_CORNER_HOLE_RADIUS, T1_THICKNESS,
                  T1_CENTER_HOLE_SLICES, T1_STACKS);
    glPopMatrix();
    // Mittlere Löcher
    glPushMatrix();
      glTranslatef(T1_TOTAL_WIDTH / 2, -T1_TOTAL_HEIGHT / 2, 0);
      drawHoles(quadObject, T1_CENTER_HOLE_RADIUS, T1_SMALL_HOLE_RADIUS, T1_SMALL_HOLE_DISTANCE,
                T1_THICKNESS,
                T1_CENTER_HOLE_SLICES, T1_STACKS,
                T1_SMALL_HOLE_SLICES, T1_STACKS);
    glPopMatrix();


    util.PrepairMask();
    // Oberes linkes Befestigungsloch (Maske)
    glPushMatrix();
      glTranslatef(T1_CORNER_HOLE_DISTANCE, -T1_CORNER_HOLE_DISTANCE, 0);
      drawHoleMask(quadObject, T1_CORNER_HOLE_RADIUS, T1_THICKNESS, T1_CORNER_HOLE_SLICES, T1_CORNER_HOLE_LOOPS);
    glPopMatrix();
    // Unteres linkes Befestigungsloch (Maske)
    glPushMatrix();
      glTranslatef(T1_CORNER_HOLE_DISTANCE, -T1_TOTAL_HEIGHT + T1_CORNER_HOLE_DISTANCE, 0);
      drawHoleMask(quadObject, T1_CORNER_HOLE_RADIUS, T1_THICKNESS, T1_CORNER_HOLE_SLICES, T1_CORNER_HOLE_LOOPS);
    glPopMatrix();
    // Oberes rechtes Befestigungsloch (Maske)
    glPushMatrix();
      glTranslatef(T1_TOTAL_WIDTH - T1_CORNER_HOLE_DISTANCE, -T1_CORNER_HOLE_DISTANCE, 0);
      drawHoleMask(quadObject, T1_CORNER_HOLE_RADIUS, T1_THICKNESS, T1_CORNER_HOLE_SLICES, T1_CORNER_HOLE_LOOPS);
    glPopMatrix();
    // Unteres rechtes Befestigungsloch (Maske)
    glPushMatrix();
      glTranslatef(T1_TOTAL_WIDTH - T1_CORNER_HOLE_DISTANCE, -T1_TOTAL_HEIGHT + T1_CORNER_HOLE_DISTANCE, 0);
      drawHoleMask(quadObject, T1_CORNER_HOLE_RADIUS, T1_THICKNESS, T1_CORNER_HOLE_SLICES, T1_CORNER_HOLE_LOOPS);
    glPopMatrix();
    // Mittlere Löcher
    glPushMatrix();
      glTranslatef(T1_TOTAL_WIDTH / 2, -T1_TOTAL_HEIGHT / 2, 0);
      drawHolesMask(quadObject, T1_CENTER_HOLE_RADIUS, T1_SMALL_HOLE_RADIUS, T1_SMALL_HOLE_DISTANCE,
                T1_THICKNESS,
                T1_CENTER_HOLE_SLICES, T1_CENTER_HOLE_LOOPS,
                T1_SMALL_HOLE_SLICES, T1_SMALL_HOLE_LOOPS);
    glPopMatrix();


    glTranslatef(T1_CORNER_RADIUS, -T1_CORNER_RADIUS, 0);
    util.AktivateMask();
    glPushMatrix();

      // Obere linke Kante
      glPushMatrix();
        glRotatef(90, 0, 0, 1);
        drawCylinder(quadObject, 0, T1_CORNER_RADIUS, T1_THICKNESS, T1_CORNER_SLICES, T1_STACKS, T1_CORNER_LOOPS, 90);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
        glTranslatef(0, 0, T1_THICKNESS);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
      glPopMatrix();

      // Mittlerer linker Quader
      d1[0] := -T1_CORNER_RADIUS; d1[1] := -T1_HEIGHT; d1[2] := 0;
      d2[0] := 0;                 d2[1] := 0;          d2[2] := T1_THICKNESS;
      drawQuad(d1, d2);

      glTranslatef(0, -T1_HEIGHT, 0);

      // Untere linke Kante
      glPushMatrix();
        glRotatef(180, 0, 0, 1);
        drawCylinder(quadObject, 0, T1_CORNER_RADIUS, T1_THICKNESS, T1_CORNER_SLICES, T1_STACKS, T1_CORNER_LOOPS, 90);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
        glTranslatef(0, 0, T1_THICKNESS);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
      glPopMatrix();
    glPopMatrix();

    glPushMatrix();
      // Oberer mittlerer Quader
      d1[0] := 0;        d1[1] := 0;                d1[2] := 0;
      d2[0] := T1_WIDTH; d2[1] := T1_CORNER_RADIUS; d2[2] := T1_THICKNESS;
      drawQuad(d1, d2);

      // Mittlerer Quader
      d1[0] := 0;        d1[1] := -T1_HEIGHT; d1[2] := 0;
      d2[0] := T1_WIDTH; d2[1] := 0;          d2[2] := T1_THICKNESS;
      drawQuad(d1, d2);

      glTranslatef(0, -T1_HEIGHT, 0);

      // Unterer mittlerer Quader
      d1[0] := 0;        d1[1] := -T1_CORNER_RADIUS; d1[2] := 0;
      d2[0] := T1_WIDTH; d2[1] := 0;                 d2[2] := T1_THICKNESS;
      drawQuad(d1, d2);
    glPopMatrix();

    glTranslatef(T1_WIDTH, 0, 0);

    glPushMatrix();
      // Obere rechte Kante
      glPushMatrix();
        drawCylinder(quadObject, 0, T1_CORNER_RADIUS, T1_THICKNESS, T1_CORNER_SLICES, T1_STACKS, T1_CORNER_LOOPS, 90);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
        glTranslatef(0, 0, T1_THICKNESS);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
      glPopMatrix();

      // Mittlerer rechte Quader
      d1[0] := 0;                d1[1] := -T1_HEIGHT; d1[2] := 0;
      d2[0] := T1_CORNER_RADIUS; d2[1] := 0;          d2[2] := T1_THICKNESS;
      drawQuad(d1, d2);

      glTranslatef(0, -T1_HEIGHT, 0);

      // Untere rechte Kante
      glPushMatrix();
        glRotatef(270, 0, 0, 1);
        drawCylinder(quadObject, 0, T1_CORNER_RADIUS, T1_THICKNESS, T1_CORNER_SLICES, T1_STACKS, T1_CORNER_LOOPS, 90);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
        glTranslatef(0, 0, T1_THICKNESS);
        gluPartialDisk(quadObject, 0, T1_CORNER_RADIUS, T1_CORNER_SLICES, T1_CORNER_LOOPS, 0, 90);
      glPopMatrix();
    glPopMatrix();
    util.DisableMask();
  glPopMatrix();
end;

{
  Dies ist das Teil mit der Bezeichnung Teil 3. Es befindet sich unter dem Drehteller. An diesem Teil ist der Servo 0
  befestigt.

  ~param quadObject OpenGl Quadric Object, welches für die vordefinierten OpenGl Funktionen benötigt wird
  ~param position Das Koordinatentripple (x,y,z) an dem das Teil im Raum gezeichnet werden soll
  ~param highlighted Gibt an, ob das Teil in der hervorgehobenen Farbe gezeichnet werden soll.
                     True, falls das Teil in der hervorgehobenen Farbe gerendert werden soll.
                     False, falls das Teil in seiner Eigenfarbe gerendert werden soll.
}
procedure drawTeil3(quadObject: PGLUquadric; position: TVector3d; highlighted : Boolean);
var d1, d2 : TVector3d;
    util : TOpenGLConfigUtil; // Util für diverse OpenGl Konfigurationen
    LOG  : TLogLogger;        // Logger für Debugausgaben
    slices : Integer;
    loops  : Integer;
    stacks : Integer;

    {
      Zeichnet einen Befestungspin, der am unteren Ende des Zylinders befestigt ist.

      ~param obj Das QuadricObject, das zum Zeichnen des Pins benötigt wird und die Zeicheninformationen enthällt
      ~param outerCoverRadius Der Außenradius des Zylinders
      ~param degree Die Gradzahl um die der Pin um den Zylinder gedreht wird
    }
    procedure RenderPin(obj : PGLUQuadric; outerCoverRadius, degree : Real);
    var slices : Integer;
      loops  : Integer;
      stacks : Integer;
      util   : TOpenGLConfigUtil;
    begin
      if(LOG.IsTraceEnabled()) then LOG.Trace('RenderPin(obj, '+floatToStr(degree)+')');

      util := TOpenGLConfigUtil.getInstance();

      // Befestigungspin
      glPushMatrix();
        glRotatef(degree, 0, 1, 0);
        glTranslatef(0, -T3_CYLINDER_HEIGHT / 2, outerCoverRadius);

        slices := getSlices(T3_PIN_HOLE_RAD);
        loops  := getLoops(T3_PIN_HOLE_RAD);
        stacks := getStacks(T3_PIN_HEIGHT);
        // Loch
        glPushMatrix();
          glTranslatef(0, T3_PIN_HEIGHT - CORRECTION_DISTANCE, T3_PIN_DEPTH / 2);
          glRotatef(90, 1, 0, 0);
          gluCylinder(obj, T3_PIN_HOLE_RAD, T3_PIN_HOLE_RAD, T3_PIN_HEIGHT - 2 * CORRECTION_DISTANCE, slices, stacks);
        glPopMatrix();

        // Loch Maske, die aus der Ober- und Unterseite das Loch ausschneidet
        util.ConfigureSimple(obj, false);
        util.PrepairMask();
        glPushMatrix();
          glTranslatef(0, T3_PIN_HEIGHT, T3_PIN_DEPTH / 2);
          glRotatef(90, 1, 0, 0);
          gluDisk(obj, 0, T3_PIN_HOLE_RAD, slices, loops);
        glPopMatrix();
        glPushMatrix();
          glTranslatef(0, 0, T3_PIN_DEPTH / 2);
          glRotatef(90, 1, 0, 0);
          gluDisk(obj, 0, T3_PIN_HOLE_RAD, slices, loops);
        glPopMatrix();
        util.resetOriginalConfig(obj);

        // Ober- und Unterseite
        util.AktivateMask();
        glBegin(GL_QUADS);
          glVertex3f(-T3_PIN_WIDTH / 2, T3_PIN_HEIGHT, -T3_OUTERCOVER_THICKNESS / 2);
          glVertex3f(-T3_PIN_WIDTH / 2, T3_PIN_HEIGHT, T3_PIN_DEPTH);
          glVertex3f( T3_PIN_WIDTH / 2, T3_PIN_HEIGHT, T3_PIN_DEPTH);
          glVertex3f( T3_PIN_WIDTH / 2, T3_PIN_HEIGHT, -T3_OUTERCOVER_THICKNESS / 2);
        glEnd;
        glBegin(GL_QUADS);
          glVertex3f(-T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, -T3_OUTERCOVER_THICKNESS / 2);
          glVertex3f( T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, -T3_OUTERCOVER_THICKNESS / 2);
          glVertex3f( T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, T3_PIN_DEPTH);
          glVertex3f(-T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, T3_PIN_DEPTH);
        glEnd;
        util.DisableMask();

        // Linke Seiten
        glBegin(GL_QUADS);
          glVertex3f(-T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, -T3_OUTERCOVER_THICKNESS / 2);
          glVertex3f(-T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, T3_PIN_DEPTH);
          glVertex3f(-T3_PIN_WIDTH / 2, T3_PIN_HEIGHT,       T3_PIN_DEPTH);
          glVertex3f(-T3_PIN_WIDTH / 2, T3_PIN_HEIGHT,       -T3_OUTERCOVER_THICKNESS / 2);
        glEnd;

        // Vordere Seiten
        glBegin(GL_QUADS);
          glVertex3f(-T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, T3_PIN_DEPTH);
          glVertex3f( T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, T3_PIN_DEPTH);
          glVertex3f( T3_PIN_WIDTH / 2, T3_PIN_HEIGHT,       T3_PIN_DEPTH);
          glVertex3f(-T3_PIN_WIDTH / 2, T3_PIN_HEIGHT,       T3_PIN_DEPTH);
        glEnd;

        // Rechte Seiten
        glBegin(GL_QUADS);
          glVertex3f(T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, -T3_OUTERCOVER_THICKNESS / 2);
          glVertex3f(T3_PIN_WIDTH / 2, T3_PIN_HEIGHT,       -T3_OUTERCOVER_THICKNESS / 2);
          glVertex3f(T3_PIN_WIDTH / 2, T3_PIN_HEIGHT,       T3_PIN_DEPTH);
          glVertex3f(T3_PIN_WIDTH / 2, CORRECTION_DISTANCE, T3_PIN_DEPTH);
        glEnd;
      glPopMatrix();
    end;
begin
  LOG := TLogLogger.GetLogger('drawTeil3');

  if(LOG.IsDebugEnabled()) then
  begin
    LOG.Debug('position = ' + floattostr(position[0]) + '|' + floattostr(position[1]) + '|' + floattostr(position[2]));
  end;
  if(SHOW_START_POINT) then gluSphere(quadObject, 1, 10, 10);

  util := TOpenGLConfigUtil.getInstance();
  if(highlighted) then
    glColor3f(HIGHLIGHT_COLOR[0], HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2])
  else
    glColor3ub(121, 129, 160);

  glPushMatrix();
    glTranslatef(position[0], position[1], position[2]);

    // Deckel
    glPushMatrix();
      slices := getSlices(T3_CYLINDER_RADIUS);
      loops  := getLoops(T3_CYLINDER_RADIUS);
      stacks := getStacks(T3_CAP_THICKNESS);
      glTranslatef(0, T3_CYLINDER_HEIGHT / 2 , 0);
      glPushMatrix();
          glRotatef(-90, 1, 0, 0);
          gluDisk(quadObject, T3_CAP_HOLE_RADIUS, T3_CYLINDER_RADIUS, slices, loops);
      glPopMatrix();
      glPushMatrix();
          glRotatef(90, 1, 0, 0);
          gluCylinder(quadObject, T3_CAP_HOLE_RADIUS, T3_CAP_HOLE_RADIUS, T3_CAP_THICKNESS, slices, stacks);
      glPopMatrix();

      glTranslatef(0, -T3_CAP_THICKNESS , 0);
      glPushMatrix();
          glRotatef(90, 1, 0, 0);
          gluDisk(quadObject, T3_CAP_HOLE_RADIUS, T3_CYLINDER_RADIUS - T3_OUTERCOVER_THICKNESS, slices, loops);
      glPopMatrix();
    glPopMatrix();

    // Mantel
    glPushMatrix();
      slices := getSlices(T3_CYLINDER_RADIUS);
      stacks := getStacks(T3_CYLINDER_HEIGHT);
      glTranslatef(0, T3_CYLINDER_HEIGHT / 2, 0);
      glPushMatrix();
          glRotatef(90, 1, 0, 0);
          gluCylinder(quadObject, T3_CYLINDER_RADIUS, T3_CYLINDER_RADIUS, T3_CYLINDER_HEIGHT, slices, stacks);
      glPopMatrix();
      glPushMatrix();
          glTranslatef(0, -T3_CAP_THICKNESS, 0);
          glRotatef(90, 1, 0, 0);
          gluCylinder(quadObject, T3_CYLINDER_RADIUS - T3_OUTERCOVER_THICKNESS, T3_CYLINDER_RADIUS - T3_OUTERCOVER_THICKNESS,
              T3_CYLINDER_HEIGHT - T3_CAP_THICKNESS, slices, stacks);
      glPopMatrix();

      loops  := getLoops(T3_OUTERCOVER_THICKNESS);
      glTranslatef(0, -T3_CYLINDER_HEIGHT, 0);
      glPushMatrix();
          glRotatef(90, 1, 0, 0);
          gluDisk(quadObject, T3_CYLINDER_RADIUS - T3_OUTERCOVER_THICKNESS, T3_CYLINDER_RADIUS, slices, loops);
      glPopMatrix();
    glPopMatrix();

    // Pins
    RenderPin(quadObject, T3_CYLINDER_RADIUS, 0.0);
    RenderPin(quadObject, T3_CYLINDER_RADIUS, 90.0);
    RenderPin(quadObject, T3_CYLINDER_RADIUS, 180.0);
    RenderPin(quadObject, T3_CYLINDER_RADIUS, 270.0);
  glPopMatrix();
end;

end.
