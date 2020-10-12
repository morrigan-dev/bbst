<?php

/**
 * Diese Datei behandelt die Eingaben aus der input.html.
 * 
 * @since 13.08.2011
 * @author Thomas Gattinger
 */

$name = "";
if(isset($_POST["name"])) {
	$name = $_POST["name"];
}
$age = "";
if(isset($_POST["age"])) {
	$age = $_POST["age"];
}
$gender = $_POST["gender"];
if(!empty($name)) {
	echo "Hi " . $name;
	if(!empty($age)) {
		echo ", du bist " . $age . " Jahre alt.";
	}
	echo "<br>Du bist " . $gender . ".";
}
if(empty($name) && empty($age)) {
	echo "Du hast keine Felder ausgefüllt.";
}

?>