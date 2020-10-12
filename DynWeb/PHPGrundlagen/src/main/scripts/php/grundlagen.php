<?php

/**
 * Diese PHP Seite zeigt verschiedene Grundlagen dieser Sprache auf.
 * Die einzelnen Funktionalitäten sind in eigene Klassen ausgelagert.
 * - Verkettung
 * - Fallunterscheidungen
 * - Vergleiche und Ausgabe mit var_dump
 * - Einbinden anderer php Klassen
 * - OO PHP
 * - Umgang mit GET und POST Variablen
 * - Prüfung von Variablen mit isset() und empty()
 *
 * @since 13.08.2011
 * @author Thomas Gattinger
 */
include 'classes.php';
include 'kreis.php';

echo "<h1>PHP Grundlagen</h1>";


echo "<h3>Verkettung mit einem Punkt (.)</h3>";

$verkettung = new Verkettung("Hallo", "Welt!");
// Texte werden mit einem Punkt (.) verkettet
$verkettung->printHelloWorld();
// Ebenso können Variablen mit einem Punkt (.) verkettet werden
$verkettung->printVariablenVerkettung();
// Verkettung von Text und Vaiablen ist ebenfalls möglich
$verkettung->printMixedVerkettung();


echo "<h3>Fallunterscheidungen</h3>";

// Gebe eine der Uhrzeit entsprechende Begrüßung aus
$greeting = new Greeting();
$greeting->printGreeting();


echo "<h3>Vergleiche mit var_dump</h3>";

$vergleiche = new Vergleiche("10", 10.0, 10, "09", "10");
// Ausgabe der Variableninformationen
$vergleiche->printValues();


// Ausgabe der verschiedenen Vergleichsmöglichkeiten
$vergleiche->vergleicheValues();
$vergleiche->vergleicheValuesAndTypes();


echo "<h3>Benutzen von eingebundenen php Dateien</h3>";
// Erzeuge eine neue Instanz der Kreis Klasse und gebe die Ergebnisse der Funktionsaufrufe aus
$radius = 100;
$kreis = new Kreis($radius);
echo $kreis->toString() . "<br>";
$kreis->draw();

// Teste GET Variablen
echo "<h3>Test der GET Funktion</h3>";

$name = "";
if(isset($_GET["name"])) {
	$name = $_GET["name"];
}
$age = "";
if(isset($_GET["age"])) {
	$age = $_GET["age"];
}
if(!empty($name)) {
	echo "Hi " . $name;
	if(!empty($age)) {
		echo ", du bist " . $age . " Jahre alt.";
	}
}
if(empty($name) && empty($age)) {
	echo "Bitte gib mindestes eine GET Variable an (name/age).";
}

// Teste POST Variablen
echo "<h3>Test der POST Funktion</h3>";
echo "<iframe src='../html/input.html' width='200px' height='200px' name='inputBox' style='border: 0px;'>"


?>