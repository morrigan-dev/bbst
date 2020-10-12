<?php

/**
 * Diese Klasse ermöglicht die Verbindung zur MySQL Datenbank. Es kann immer nur eine Verbindung zu einer Datenbank
 * hergestellt werden. Außerdem werden hier alle benötigten Abfragen zusammengebaut, um auf Tabellen und Spalten,
 * zugreifen zu können. Ebenso kann in dieser Klasse die Sortierung nach einzelnen Spalten angegeben werden.
 *
 * @since 14.09.2011
 * @author Thomas Gattinger
 */
class DBConnection {

	/** Ein Host Adresse auf der die MySQL Datenbank liegt */
	private $host;

	/** Ein Benutzername, mit dem Zugriff auf die MySQL Datenbank möglich ist */
	private $username;

	/** Ein zu dem Benutzername gültiges Passwot fü den Zugriff auf die MySQL Datenbank */
	private $passwort;

	/** Eine Datenbank zu der verbunden werden soll */
	private $database;

	/** Link auf die aktuell geöffnete Datenbankverbindung */
	private $dbLink;

	/** Gibt an, ob eine Verbindung zu einer MySQL Datenbank besteht */
	private $connected;

	/**
	 * Dieser Konstruktor erzeugt eine neue Instanz dieser Klasse und setzt die übergebenen Wert.
	 *
	 * @param $host Eine Host Adresse auf der die MySQL Datenbank liegt.
	 * @param $username Ein Benutzername, mit dem Zugriff auf die MySQL Datenbank möglich ist.
	 * @param $passwort Ein zu dem Benutzername gültiges Passwot fü den Zugriff auf die MySQL Datenbank.
	 * @param $database Eine Datenbank zu der verbunden werden soll.
	 */
	public function __construct($host, $username, $passwort, $database) {
		$this->host = $host;
		$this->username = $username;
		$this->passwort = $passwort;
		$this->database = $database;
		$this->dbLink = null;
		$this->connected = false;
		$this->connect();
	}

	/**
	 * Dieser Destruktor beendet eine noch offene Datenbankverbindung und gibt alle angeforderten Resourcen wieder frei.
	 */
	public function __destruct() {
		$this->disconnect();
		unset($this->host);
		unset($this->username);
		unset($this->passwort);
		unset($this->database);
		unset($this->dbLink);
		unset($this->connected);
	}

	/**
	 * Diese Methode versucht eine Verbindung zu einer MySQL Datenbank herzustellen. Es werden die Verbindungsdaten,
	 * die im Konstruktor angegeben wurden verwendet. Bestand bereits eine Verbindung zu einer Datenbank, so wird diese
	 * Verbindung beendet und eine neue Verbindung aufgebaut.
	 *
	 * @return liefert true, falls eine Verbindung zum Host und zur Datenbank hergestellt werden konnte. Ansonsten wird
	 *         false zurückgegeben.
	 */
	public function connect() {
		if($this->connected) {
			$this->disconnect();
		}
		if($this->dbLink = mysql_connect ($this->host, $this->username, $this->passwort)) {
			if(mysql_select_db($this->database)) {
				$this->connected = true;
			}
		}
		return $this->connected;
	}

	/**
	 * Diese Methode beendet eine bestehende Datenbankverbindung.
	 *
	 * @return liefert true, falls eine bestehende Datenbankverbindung nun erfolgreich geschlossen wurde oder gar keine
	 *         Verbdinung offen war. Konnte eine bestehende Verbindung nicht geschlossen werden, so wird false
	 *         zurückgegeben.
	 */
	public function disconnect() {
		if(isset($this->dbLink)) {
			return mysql_close($this->dbLink);
		}
		return true;
	}

	/**
	 * Diese Methode fügt einen neuen Datensatz in die angebene Tabelle ein. Dabei können beliebig viele Spalten
	 * und deren Werte mittels eines assiziativen Arrays übergeben werden.
	 *
	 * @param $table Die Tabelle, in die ein neuer Datensazu eingefügt werden soll.
	 * @param $columnsAndValue Ein assoziatives Array bei dem die keys die Spaltennamen und die values die Werte
	 *                         des Datensatzes sind.
	 */
	public function insert($table, $columnsAndValue) {
		if($this->connected) {
			$size = count($columnsAndValue);
			$index = 0;
			$columns = "";
			$values = "";
			foreach ($columnsAndValue as $column => $value) {
				$columns .= $column;
				$values .= "'" . $value . "'";
				$index++;
				if($index < $size) {
					$columns .= ",";
					$values .= ",";
				}
			}
			$query = "INSERT INTO " . $table . " (" . $columns . ") VALUES (" . $values . ");";
			echo $query . "<br>";
			return mysql_query($query, $this->dbLink);
		}
		return false;
	}

	/**
	 * Diese Methode gibt an, ob eine Verbindung zu einer Datenbank besteht.
	 *
	 * @return liefert true, falls eine Verbindung zum Host und der Datenbank erfolgreich war und somit Zugriff auf die
	 *         Daten besteht. Besteht keine Verbindung zum Host oder zur Datenbank so wird false zurückgegeben.
	 */
	public function isConnected() {
		return $this->connected;
	}

	/**
	 * Diese Methode liefert den aktuellen Datenbank-Link, sofern eine Verbindung zum Host und einer Datenbank besteht.
	 *
	 * @return liefert den aktuellen Datenbank-Link oder null, falls keine Verbinsung besteht.
	 */
	public function getDBLink() {
		if($this->connected) {
			return $this->dbLink;
		}
		return null;
	}

	/**
	 * Diese Methode fragt per Datensätze aus der angegebenen Tabelle ab. Über das $columnArray array können die Spalten
	 * angegeben werden, die bei der Abfrage berücksichtigt werden sollen.
	 *
	 * @param $table Die Tabelle aus der Datensätze abgefragt werden sollen.
	 * @param $columnArray Die Spalten, die bei der Abfrage herauskommen sollen.
	 */
	public function select($table, $columnArray) {
		if($this->connected) {
			$size = count($columnArray);
			$columns = $columnArray[0];
			for ($i = 1; $i < $size; $i++) {
				$columns .= "," . $columnArray[$i];
			}
			$query = "SELECT " . $columns . " FROM " . $table . ";";
			return mysql_query($query, $this->dbLink);
		}
	}
}

/**
 * Diese Klasse beinhaltet alle benötigten Abfragen für das BigVideo Projekt.
 *
 * @author Thomas Gattinger
 * @since 17.09.2011
 */
class BigVideoQueries {

	/** Objekt, dass eine Datenbankverbindung verwaltet */
	private $dbconnection;

	/**
	 * Dieser Konstruktor erzeugt eine neue Instanz dieser Klasse und setzt das übergebene Datenbankverwaltungsobjekt.
	 *
	 * @param Objekt, dass eine Datenbankverbindung verwaltet.
	 */
	function __construct($dbconnection) {
		$this->dbconnection = $dbconnection;
	}

	/**
	 * Dieser Destruktor gibt alle Resourcen dieser Klasse wieder frei.
	 */
	function __destruct() {
		unset($this->dbconnection);
	}

	/**
	 * Diese Methode formatiert die übergebene Query und stellt die Schlüsselwörter farblich dar.
	 *
	 * @param $query Die zu formatierende Query.
	 */
	function formatQuery($query) {
		$left_space = 20;
		$query = str_replace("FROM", "<br /><span style='margin-left:" . $left_space . "px'>FROM</span>", $query);
		$query = str_replace("WHERE", "<br /><span style='margin-left:" . $left_space . "px'>WHERE</span>", $query);
		$query = str_replace("LIMIT", "<br /><span style='margin-left:" . $left_space . "px'>LIMIT</span>", $query);
		$query = str_replace("ORDER", "<br /><span style='margin-left:" . $left_space . "px'>ORDER</span>", $query);
		$query = str_replace("LEFT", "<br /><span style='margin-left:" . $left_space . "px'>LEFT</span>", $query);

		$query = str_replace("SELECT", "<span style='color: #7f0055'><b>SELECT</b></span>", $query);
		$query = str_replace("FROM", "<span style='color: #7f0055'><b>FROM</b></span>", $query);
		$query = str_replace("WHERE", "<span style='color: #7f0055'><b>WHERE</b></span>", $query);
		$query = str_replace("LIMIT", "<span style='color: #7f0055'><b>LIMIT</b></span>", $query);
		$query = str_replace("ORDER", "<span style='color: #7f0055'><b>ORDER</b></span>", $query);
		$query = str_replace("BY", "<span style='color: #7f0055'><b>BY</b></span>", $query);
		$query = str_replace("LEFT", "<span style='color: #7f0055'><b>LEFT</b></span>", $query);
		$query = str_replace("JOIN", "<span style='color: #7f0055'><b>JOIN</b></span>", $query);
		$query = str_replace("MAX", "<span style='color: #7f0055'><b>MAX</b></span>", $query);
		$query = str_replace("LIKE", "<span style='color: #7f0055'><b>LIKE</b></span>", $query);
		$query = str_replace("RIGHT", "<span style='color: #7f0055'><b>RIGHT</b></span>", $query);
		$query = str_replace("GROUP", "<span style='color: #7f0055'><b>GROUP</b></span>", $query);
		$query = str_replace("COUNT", "<span style='color: #7f0055'><b>COUNT</b></span>", $query);
		$query = str_replace("ON", "<span style='color: #7f0055'><b>ON</b></span>", $query);
		$query = str_replace("DESC", "<span style='color: #7f0055'><b>DESC</b></span>", $query);
		$query = str_replace("ASC", "<span style='color: #7f0055'><b>ASC</b></span>", $query);
		$query = str_replace("OR", "<span style='color: #7f0055'><b>OR</b></span>", $query);
		$query = str_replace("AND", "<span style='color: #7f0055'><b>AND</b></span>", $query);

		$query = "<div class='query'>" . $query . "</div>";

		return $query;
	}

	/**
	 * Diese Methode liefert die Query, um alle Schauspieler aus der Datenbank zu laden.
	 *
	 * @return eine Query für alle Schauspieler.
	 */
	public function getAlleSchauspielerQuery() {
		return "SELECT id, schauspieler FROM schauspieler;";
	}

	/**
	 * Diese Methode liefert alle Daten von Schauspielern.
	 *
	 * @return alle Datensätze der Tabelle 'schauspieler' bzw. false falls ein Fehler auftritt.
	 */
	function selectAlleSchauspieler() {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getAlleSchauspielerQuery();
		return mysql_query($query, $dbLink);
	}

	/**
	 * Diese Methode liefert die Query, um die ersten 30 Schauspieler aus der Datenbank zu laden.
	 *
	 * @return eine Query für die ersten 30 Schauspieler.
	 */
	public function getTop30SchauspielerQuery() {
		return "SELECT id, schauspieler FROM schauspieler LIMIT 30;";
	}

	/**
	 * Diese Methode liefert die ersten 30 Daten von Schauspielern.
	 *
	 * @return die ersten 30 Datensätze der Tabelle 'schauspieler' bzw. false falls ein Fehler auftritt.
	 */
	function selectTop30Schauspieler() {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getTop30SchauspielerQuery();
		return mysql_query($query, $dbLink);
	}

	/**
	 * Diese Methode liefert die Query, um die letzten 30 Schauspieler aus der Datenbank zu laden.
	 *
	 * @return eine Query für die letzten 30 Schauspieler.
	 */
	public function getLAST30SchauspielerQuery() {
		return "SELECT id, schauspieler FROM schauspieler WHERE id >= (SELECT MAX(id)-30 FROM schauspieler);";
	}

	/**
	 * Diese Methode liefert die letzten 30 Daten von Schauspielern.
	 *
	 * @return die letzten 30 Datensätze der Tabelle 'schauspieler' bzw. false falls ein Fehler auftritt.
	 */
	function selectLast30Schauspieler() {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getLast30SchauspielerQuery();
		return mysql_query($query, $dbLink);
	}

	/**
	 * Diese Methode liefert die Query, um alle Schauspieler mit einem 'A' im Namensanfang aus der Datenbank zu laden.
	 *
	 * @return eine Query für alle Schauspieler, die mit einem 'A' beginnen.
	 */
	public function getASchauspielerQuery() {
		return "SELECT id, schauspieler FROM schauspieler WHERE schauspieler LIKE 'A%';";
	}

	/**
	 * Diese Methode liefert alle Schauspieler mit einem 'A' im Namensanfang aus der Datenbank zu laden.
	 *
	 * @return alle Schauspieler mit einem 'A' im Namensanfang aus der Datenbank zu laden. bzw. false falls ein Fehler auftritt.
	 */
	function selectASchauspieler() {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getASchauspielerQuery();
		return mysql_query($query, $dbLink);
	}

	/**
	 * Diese Methode liefert die Query, um alle Filme, die in den USA gedreht wurden aus der Datenbank zu laden.
	 *
	 * @param $order Gibt an, ob die Ausgabe nach Erstellungszeitpunkt sortiert werden soll.
	 * @return eine Query mit Filmen.
	 */
	public function getFilmeAusUSAQuery($order) {
		if($order) {
			return "SELECT title, prodort FROM filme WHERE prodort LIKE '%USA%' ORDER BY RIGHT(prodort,4) ASC;";
		} else {
			return "SELECT title, prodort FROM filme WHERE prodort LIKE '%USA%';";
		}
	}

	/**
	 * Diese Methode liefert alle Filme, die in den USA gedreht wurden aus der Datenbank zu laden.
	 *
	 * @param $order Gibt an, ob die Ausgabe nach Erstellungszeitpunkt sortiert werden soll.
	 * @return eine Liste mit Filmen bzw. false falls ein Fehler auftritt.
	 */
	function selectFilmeAusUSA($order) {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getFilmeAusUSAQuery($order);
		return mysql_query($query, $dbLink);
	}

	/**
	 * Diese Methode liefert die Query, um alle Filme, die in den USA 1984 gedreht wurden aus der Datenbank zu laden.
	 *
	 * @return eine Query mit Filmen.
	 */
	public function getFilmeAusUSA1984Query() {
		return "SELECT title, prodort FROM filme WHERE prodort LIKE '%USA%' AND RIGHT(prodort,4) = '1984';";
	}

	/**
	 * Diese Methode liefert alle Filme, die in den USA 1984 gedreht wurden aus der Datenbank zu laden.
	 *
	 * @return eine Liste mit Filmen bzw. false falls ein Fehler auftritt.
	 */
	function selectFilmeAusUSA1984() {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getFilmeAusUSA1984Query();
		return mysql_query($query, $dbLink);
	}

	/**
	 * Diese Methode liefert die Query, um alle Schauspieler, die beim Film Blade Runner - The Director´s Cut
	 * mitgespielthaben aus der Datenbank zu laden.
	 *
	 * @return eine Query mit Schauspielern.
	 */
	public function getBladeRunnerSchauspielerQuery() {
		$query = "SELECT title, schauspieler FROM schauspieler" .
				 " LEFT JOIN filmschauspieler ON filmschauspieler.schauspielerid = schauspieler.id" .
				 " LEFT JOIN filme ON filmschauspieler.filmid = filme.id" .
				 " WHERE filme.title LIKE 'Blade Runner - The Director_s Cut';";
		return $query;
	}

	/**
	 * Diese Methode liefert alle Schauspieler, die beim Film Blade Runner - The Director´s Cut
	 * mitgespielthaben aus der Datenbank zu laden.
	 *
	 * @return eine Liste mit Schauspielern.
	 */
	function selectBladeRunnerSchauspieler() {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getBladeRunnerSchauspielerQuery();
		return mysql_query($query, $dbLink);
	}

	/**
	 * Diese Methode liefert die Query, um den Regisseur mit den meisten Filmen aus der Datenbank zu laden.
	 *
	 * @return eine Query mit einer Liste mit Regisseur.
	 */
	public function getRegisseurMaxFilmeQuery() {
		$query = "SELECT regisseur.regisseur, COUNT(*)" .
				 " FROM regisseur, filmregisseur" .
				 " WHERE regisseur.id = filmregisseur.regisseurid" .
				 " GROUP BY regisseur.id" .
				 " ORDER BY 2 DESC" .
				 " LIMIT 5;";
		return $query;
	}

	/**
	 * Diese Methode liefert den Regisseur mit den meisten Filmen aus der Datenbank zu laden.
	 *
	 * @return eine Liste mit Regisseur.
	 */
	function selectRegisseurMaxFilme() {
		$dbLink = $this->dbconnection->getDBLink();
		$query = $this->getRegisseurMaxFilmeQuery();
		return mysql_query($query, $dbLink);
	}
}
?>