<?php

/**
 * Diese Klasse stellt verschiedene Verkettungsbeispiele von Variablen und Texten zur Verfügung.
 *
 * @since 13.08.2011
 * @author Thomas Gattinge
 * @version 1.0
 */
class Verkettung {
	const SPACE = " ";  // Einfaches Leerzeichen, mit dem die beiden Meldungen getrennt werden

	private $msg1;      // Erste beliebige Meldung
	private $msg2;      // Zweite beliebige Meldung

	/**
	 * Dieser Konstruktor erzeugt eine neue Instanz der Klasse Verkettung
	 * und setzt die beiden übergebenen Meldungen.
	 *
	 * @param unknown_type $msg1 Eine beliebige erste Meldung
	 * @param unknown_type $msg2 Eine beliebige zweite Meldung
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function Verkettung($msg1, $msg2) {
		$this->msg1 = $msg1;
		$this->msg2 = $msg2;
	}

	/**
	 * Diese Methode gibt einen vorgegebenen Text zurück, der mit Punkten (.) verbunden wurden.
	 *
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function printHelloWorld() {
		echo "Dies sind verkettete Texte:<br>";
		echo "<b>Hallo" . " " . "Welt!</b>";
		echo "<br><br>";
	}

	/**
	 * Diese Methode benutzt die in <code>msg1</code> und <code>msg2</code> enthaltenden Meldungen
	 * und baut diese zu einer Meldung zusammen, die dann ausgegeben wird.
	 *
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function printVariablenVerkettung() {
		echo "Dies sind verkettete Variablen:<br>";
		echo $this->msg1 . Verkettung::SPACE . $this->msg2;
		echo "<br><br>";
	}

	/**
	 * Diese Methode baut die Inhalte der beiden Variablen <code>msg1</code> und <code>msg2</code> zusammen
	 * mit einem fest vorgegebenen Text zusammen zu einer Meldung und gibt diese aus.
	 *
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function printMixedVerkettung() {
		echo "Dies sind verkettete Variablen und Texte:<br>";
		echo "<b>" . $this->msg1 . " " . $this->msg2 . "</b>";
		echo "<br><br>";
	}
}


/**
 * Diese Klasse erzeugt eine Begrüßungsnachricht auf Basis der aktuellen Uhrzeit.
 * Eine Tageszeit ist wie folgt kodiert:<br>
 * <ul>
 * <li>-1: unbekannte Tageszeit</li>
 * <li>0: morgends</li>
 * <li>1: mittags</li>
 * <li>2: abends</li>
 * <li>3: nachts</li>
 * </ul>
 *
 * @since 13.08.2011
 * @author Thomas Gattinger
 * @version 1.0
 */
class Greeting {

	private $time;       // Die aktuelle Uhrzeit
	private $timeOfDay;  // Die aktuelle Tageszeit

	/**
	 * Dieser Konstruktor erzeugt eine neue Instanz der Klasse Greting und setzt die Tageszeit auf 'ungekannt'.
	 *
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function Greeting() {
		$this->timeOfDay = -1;
	}

	/**
	 * Diese Methode gibt einen der aktuellen Uhrzeit angemessenen Begrüßungstext aus.
	 *
	 * @since 14.08.2011
	 * @author Thomas Gattinger
	 */
	public function printGreeting() {
		$hour = $this->getCurrentHour();
		echo "Uhrzeit: " . date('H:i:s', $this->time) . "<br>";

		// Berechne Tageszeit (-1 = unbekannte Tageszeit, 0 = morgends, 1 = mittags, 2 = abends, 3 = nachts)
		if($hour >= 6 && $hour < 12) {
			$this->timeOfDay = 0;
		} else if($hour >= 12 && $hour < 18) {
			$this->timeOfDay = 1;
		} else if ($hour >= 18 && $hour < 22) {
			$this->timeOfDay = 2;
		} else if ($hour >= 22 && $hour < 6) {
			$this->timeOfDay = 3;
		}

		// Begrüße den Nutzer mit der korrekten Tageszeit
		switch ($this->timeOfDay) {
			case 0:
				echo "<b>Guten Morgen!</b>";
				break;
			case 1:
				echo "<b>Guten Tag!</b>";
				break;
			case 2:
				echo "<b>Guten Abend!</b>";
				break;
			case 3:
				echo "<b>Gute Nacht!</b>";
				break;

			default:
				if($hour > 24) {
					echo "<b>Hoppla, ein Zeitreisender!</b><br>Ein Tag, der mehr als 24 Stunden auf der Erde hat, wird es erst in ein paar Millionen Jahren geben, wenn der Mond die Erde in ihrer Rotation weiter abgebremst hat :-)";
				} else {
					echo "<b>Hoppla, diese Tageszeit kenne ich gar nicht!</b>";
				}
				break;
		}
	}

	/**
	 * Diese Methode liefert die Stunden der aktuellen Uhrzeit.
	 *
	 * @since 14.08.2011
	 * @author Thomas Gattinger
	 */
	private function getCurrentHour() {
		// Ermittle aktuelle Uhrzeit
		$this->time = time();
		return date('H', $this->time);
	}
}


/**
 * Diese Klasse stellt verschiedene Beispiele zur Verfügung,
 * die die verschiedenen Vergleichsmöglichkeiten in PHP aufzeigen.
 *
 * @since 13.08.2011
 * @author Thomas Gattinger
 * @version 1.0
 */
class Vergleiche {
	private $value1;  // Ein belibiger Wert und Variablentyp, der mit den anderen Verglichen wird
	private $value2;  // Ein belibiger Wert und Variablentyp, der mit den anderen Verglichen wird
	private $value3;  // Ein belibiger Wert und Variablentyp, der mit den anderen Verglichen wird
	private $value4;  // Ein belibiger Wert und Variablentyp, der mit den anderen Verglichen wird
	private $value5;  // Ein belibiger Wert und Variablentyp, der mit den anderen Verglichen wird

	/**
	 * Dieser Konstruktor erzeugt eine neue Instanz der Klasse <code>Vergleiche</code>
	 * und setzt fünf beliebige Werte mir beliebigem Variablentyp.
	 *
	 * @param unknown_type $value1 Ein beliebiger Wert.
	 * @param unknown_type $value2 Ein beliebiger Wert.
	 * @param unknown_type $value3 Ein beliebiger Wert.
	 * @param unknown_type $value4 Ein beliebiger Wert.
	 * @param unknown_type $value5 Ein beliebiger Wert.
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function Vergleiche($value1, $value2, $value3, $value4, $value5) {
		$this->value1 = $value1;
		$this->value2 = $value2;
		$this->value3 = $value3;
		$this->value4 = $value4;
		$this->value5 = $value5;
	}

	/**
	 * Diese Methode gibt alle Variablen und deren Typ mittels <code>var_dump</code> aus.
	 *
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function printValues() {
		echo "<b>\$value1:" . $this->value1 . "</b><br>";
		echo var_dump($this->value1) . "<br><br>";
		echo "<b>\$value2:" . $this->value2 . "</b><br>";
		echo var_dump($this->value2) . "<br><br>";
		echo "<b>\$value3:" . $this->value3 . "</b><br>";
		echo var_dump($this->value3) . "<br><br>";
		echo "<b>\$value4:" . $this->value4 . "</b><br>";
		echo var_dump($this->value4) . "<br><br>";
		echo "<b>\$value5:" . $this->value5 . "</b><br>";
		echo var_dump($this->value5) . "<br><br>";
	}

	/**
	 * Diese Methode vergleicht mittels des <code>==</code> Operators und gibt das Ergebnis über
	 * <code>var_dump</code> aus.
	 *
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function vergleicheValues() {
		echo "<b>Vergleiche mit ==</b><br>";
		echo var_dump($this->value1 == $this->value2) . " <- \$value1 == \$value2 <br>";
		echo var_dump($this->value2 == $this->value3) . " <- \$value2 == \$value3 <br>";
		echo var_dump($this->value3 == $this->value4) . " <- \$value3 == \$value4 <br>";
		echo var_dump($this->value4 == $this->value5) . " <- \$value4 == \$value5 <br>";
		echo var_dump($this->value5 == $this->value1) . " <- \$value5 == \$value1 <br><br>";
	}

	/**
	 * Diese Methode vergleicht mittels des <code>===</code> Operators und gibt das Ergebnis über
	 * <code>var_dump</code> aus.
	 *
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function vergleicheValuesAndTypes() {
		echo "<b>Vergleiche mit ===</b><br>";
		echo var_dump($this->value1 === $this->value2) . " <- \$value1 === \$value2 <br>";
		echo var_dump($this->value2 === $this->value3) . " <- \$value2 === \$value3 <br>";
		echo var_dump($this->value3 === $this->value4) . " <- \$value3 === \$value4 <br>";
		echo var_dump($this->value4 === $this->value5) . " <- \$value4 === \$value5 <br>";
		echo var_dump($this->value5 === $this->value1) . " <- \$value5 === \$value1 <br>";
	}
}

/**
 * Diese Klasse stellt verschiedene Beispiele im Umgang mit Arrays zu Verfügung.
 *
 * @since 15.08.2011
 * @author Thomas Gattinger
 * @version 1.0
 */
class Arrays {
	private $eindimensional;
	private $zweidimensional;
	private $assoziativEindimensional;
	private $assoziativZweidimensional;

	/**
	 * Diese Methode erzeugt ein eindimansionales Array und füllt es mit Zufallszahlen
	 * im Bereich von 0 bis einschließlich 36.
	 *
	 * @param unknown_type $length Die Anzahl der Zahlen, die generiert werden sollen.
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function createEindimensionalesArray($length) {
		$this->eindimensional = array();

		for ($i = 0; $i < $length; $i++) {
			$this->eindimensional[$i] = mt_rand(0, 36);
		}
	}

	/**
	 * Diese Methode erzeugt ein zweidimensionales Array und füllt es mit Daten eines Wochenplans.
	 *
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function createZweidimensionalesArray() {
		$this->zweidimensional = array();

		$this->zweidimensional[0][0] = "Uhrzeit";
		$this->zweidimensional[0][1] = "Montag";
		$this->zweidimensional[0][2] = "Dienstag";
		$this->zweidimensional[0][3] = "Mittwoch";
		$this->zweidimensional[0][4] = "Donnerstag";
		$this->zweidimensional[0][5] = "Freitag";

		$this->zweidimensional[1][0] = "07:55";
		$this->zweidimensional[2][0] = "08:40";
		$this->zweidimensional[3][0] = "09:40";
		$this->zweidimensional[4][0] = "10:25";
		$this->zweidimensional[5][0] = "11:25";
		$this->zweidimensional[6][0] = "12:10";

		$this->zweidimensional[1][1] = "Deutsch";
		$this->zweidimensional[2][1] = "Englisch";
		$this->zweidimensional[3][1] = "Sport";
		$this->zweidimensional[4][1] = "Sport";
		$this->zweidimensional[5][1] = "Religion";
		$this->zweidimensional[6][1] = "Sozialkunde";

		$this->zweidimensional[1][2] = "Franze";
		$this->zweidimensional[2][2] = "Musik";
		$this->zweidimensional[3][2] = "Geschichte";
		$this->zweidimensional[4][2] = "Mathe";
		$this->zweidimensional[5][2] = "Physik";
		$this->zweidimensional[6][2] = "Chemie";

		$this->zweidimensional[1][3] = "Bilogie";
		$this->zweidimensional[2][3] = "Geschichte";
		$this->zweidimensional[3][3] = "Mathe";
		$this->zweidimensional[4][3] = "Englisch";
		$this->zweidimensional[5][3] = "Erdkunde";
		$this->zweidimensional[6][3] = "Deutsch";

		$this->zweidimensional[1][4] = "Religion";
		$this->zweidimensional[2][4] = "Physik";
		$this->zweidimensional[3][4] = "Franze";
		$this->zweidimensional[4][4] = "Franze";
		$this->zweidimensional[5][4] = "Erdkunde";
		$this->zweidimensional[6][4] = "Deutsch";

		$this->zweidimensional[1][5] = "Mathe";
		$this->zweidimensional[2][5] = "Mathe";
		$this->zweidimensional[3][5] = "Englisch";
		$this->zweidimensional[4][5] = "Chemie";
		$this->zweidimensional[5][5] = "Musik";
		$this->zweidimensional[6][5] = "Biologie";
	}

	/**
	 * Diese Methode erstellt ein assiziatives eindimensionales Array und füllt es mit Wörtern.
	 *
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function createAssoziativ1DimArray() {
		$this->assoziativEindimensional = array();

		$this->assoziativEindimensional['one'] = "eins";
		$this->assoziativEindimensional['two'] = "zwei";
		$this->assoziativEindimensional['three'] = "drei";
		$this->assoziativEindimensional['four'] = "vier";
		$this->assoziativEindimensional['five'] = "fünf";
		$this->assoziativEindimensional['six'] = "sechs";
		$this->assoziativEindimensional['seven'] = "sieben";
		$this->assoziativEindimensional['eight'] = "acht";
		$this->assoziativEindimensional['nine'] = "neun";
	}


	/**
	 * Diese Methode erzeugt ein assoziatives zweidimensionales Array und füllt es mit Daten eines Wochenplans.
	 *
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function createAssoziativ2DimArray() {
		$this->assoziativZweidimensional = array();

		$this->assoziativZweidimensional['07:55']['Montag'] = "Deutsch";
		$this->assoziativZweidimensional['08:40']['Montag'] = "Englisch";
		$this->assoziativZweidimensional['09:40']['Montag'] = "Sport";
		$this->assoziativZweidimensional['10:25']['Montag'] = "Sport";
		$this->assoziativZweidimensional['11:25']['Montag'] = "Religion";
		$this->assoziativZweidimensional['12:10']['Montag'] = "Sozialkunde";

		$this->assoziativZweidimensional['07:55']['Dienstag'] = "Franze";
		$this->assoziativZweidimensional['08:40']['Dienstag'] = "Musik";
		$this->assoziativZweidimensional['09:40']['Dienstag'] = "Geschichte";
		$this->assoziativZweidimensional['10:25']['Dienstag'] = "Mathe";
		$this->assoziativZweidimensional['11:25']['Dienstag'] = "Physik";
		$this->assoziativZweidimensional['12:10']['Dienstag'] = "Chemie";

		$this->assoziativZweidimensional['07:55']['Mittwoch'] = "Bilogie";
		$this->assoziativZweidimensional['08:40']['Mittwoch'] = "Geschichte";
		$this->assoziativZweidimensional['09:40']['Mittwoch'] = "Mathe";
		$this->assoziativZweidimensional['10:25']['Mittwoch'] = "Englisch";
		$this->assoziativZweidimensional['11:25']['Mittwoch'] = "Erdkunde";
		$this->assoziativZweidimensional['12:10']['Mittwoch'] = "Deutsch";

		$this->assoziativZweidimensional['07:55']['Donnerstag'] = "Religion";
		$this->assoziativZweidimensional['08:40']['Donnerstag'] = "Physik";
		$this->assoziativZweidimensional['09:40']['Donnerstag'] = "Franze";
		$this->assoziativZweidimensional['10:25']['Donnerstag'] = "Franze";
		$this->assoziativZweidimensional['11:25']['Donnerstag'] = "Erdkunde";
		$this->assoziativZweidimensional['12:10']['Donnerstag'] = "Deutsch";

		$this->assoziativZweidimensional['07:55']['Freitag'] = "Mathe";
		$this->assoziativZweidimensional['08:40']['Freitag'] = "Mathe";
		$this->assoziativZweidimensional['09:40']['Freitag'] = "Englisch";
		$this->assoziativZweidimensional['10:25']['Freitag'] = "Chemie";
		$this->assoziativZweidimensional['11:25']['Freitag'] = "Musik";
		$this->assoziativZweidimensional['12:10']['Freitag'] = "Biologie";
	}

	/**
	 * Diese Methode gibt alle Elemente, die in dem eindimensionalen Array sind aus.
	 *
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function printEindimensionalesArray() {
		echo "Inhalt des eindimensionalen Arrays:<br>";
		foreach ($this->eindimensional as $value) {
			echo $value . "<br>";;
		}
	}

	/**
	 * Diese Methode gibt alle Elemente des zweidimensionalen Arrays aus.
	 *
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function printZweidimensionalesArray() {
		echo "Inhalt des zweidimensionalen Arrays:<br>";
		echo "<span style='font-family: Courier New'>";
		foreach ($this->zweidimensional as $array) {
			foreach ($array as $value) {
				$strlen = strlen($value);
				$space = '';
				for ($i = 0; $i < 14-$strlen; $i++) {
					$space .= ".";
				}
				echo $value . $space;
			}
			echo "<br>";
		}
		echo "</span>";
	}

	/**
	 * Diese Methode gibt rekursiv alle Elemente aus dem assoziativen eindimensionalen Array aus.
	 *
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function printAssoziatives1DimArray() {
		echo "Inhalt des assoziativen eindimensionalen Arrays:<br>";
		print("<pre>");
		print_r($this->assoziativEindimensional);
		print("</pre>");
	}

	/**
	 * Diese Methode gibt rekursiv alle Elemente aus dem assoziativen zweidimensionalen Array aus.
	 *
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function printAssoziatives2DimArray() {
		echo "Inhalt des assoziativen zweidimensionalen Arrays:<br>";
		print("<pre>");
		print_r($this->assoziativZweidimensional);
		print("</pre>");
	}

	/**
	 * Diese Methode liefert einen Eintrag aus dem assoziativen zweidimensionalen Array.
	 *
	 * @param unknown_type $zeit Erster assoziativer Index
	 * @param unknown_type $wochentag Zweiter assoziativer Index
	 * @since 15.08.2011
	 * @author Thomas Gattinger
	 */
	public function getAssoziativ2DimArray($zeit, $wochentag) {
		return $this->assoziativZweidimensional[$zeit][$wochentag];
	}
}

?>