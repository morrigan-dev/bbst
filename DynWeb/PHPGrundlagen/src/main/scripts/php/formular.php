<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Teilnehmerliste</title>
<link rel="stylesheet" type="text/css" href="../css/formular-style.css">
</head>
<body>
<div id="root">
<div id="content">
<div id="header">DynWeb Teilnahme</div>
<div id="left-side"><?php

$vorname = isset($_POST['vorname']) ? $_POST['vorname'] : '';
$nachname = isset($_POST['nachname']) ? $_POST['nachname'] : '';
$email = isset($_POST['email']) ? $_POST['email'] : '';
$alter = isset($_POST['alter']) ? $_POST['alter'] : '';
$geschlecht = isset($_POST['geschlecht']) ? $_POST['geschlecht'] : '';
$klasse = isset($_POST['klasse']) ? $_POST['klasse'] : '';
$klassenlehrer = isset($_POST['klassenlehrer']) ? $_POST['klassenlehrer'] : '';

$errMsg = '';
$errMsg .= empty($vorname) ? "- Vorname<br>" : '';
$errMsg .= empty($nachname) ? "- Nachname<br>" : '';
$errMsg .= empty($email) ? "- E-Mail<br>" : '';
$errMsg .= empty($alter) ? "- Alter<br>" : '';
$errMsg .= ($geschlecht == "choose") ? "- Geschlecht<br>" : '';
$errMsg .= empty($klasse) ? "- Klasse<br>" : '';
$errMsg .= empty($klassenlehrer) ? "- Klassenlehrer<br>" : '';

if(!empty($errMsg)) {
	echo "Bitte fülle folgende Fehler aus:<br><span style='color: #ff0000'>" . $errMsg . "</span><br>";
	echo "<a href='javascript:history.back()'>zur&#252;ck zur Anmeldung</a>";
} else {
	$java = isset($_POST['java']) ? $_POST['java'] : '';
	$c = isset($_POST['c']) ? $_POST['c'] : '';
	$php = isset($_POST['php']) ? $_POST['php'] : '';
	$delphi = isset($_POST['delphi']) ? $_POST['delphi'] : '';
	$sql = isset($_POST['sql']) ? $_POST['sql'] : '';
	$html = isset($_POST['html']) ? $_POST['html'] : '';

	$eigeneApp = isset($_POST['eigeneApp']) ? $_POST['eigeneApp'] : '';
	$eigeneHp = isset($_POST['eigeneHp']) ? $_POST['eigeneHp'] : '';
	$erwartung = isset($_POST['erwartung']) ? $_POST['erwartung'] : '';

	echo "Bitte überprüfe zum Abschluss noch einmal deine Daten<br><br>";

	echo "Vorname: <span class='review'>" . $vorname . "</span><br>";
	echo "Nachname: <span class='review'>" . $nachname . "</span><br>";
	echo "E-Mail: <span class='review'>" . $email . "</span><br>";
	echo "Alter: <span class='review'>" . $alter . "</span><br>";
	echo "Geschlecht: <span class='review'>";
	echo ($geschlecht == "male") ? "männlich" : "weiblich";
	echo "<br></span>";
	echo "Klasse: <span class='review'>" . $klasse . "</span><br>";
	echo "Klassenlehrer: <span class='review'>" . $klassenlehrer . "</span><br>";
	echo "<br>";

	$lang = '';
	$lang .= ($java == "on") ? "- Java<br>" : '';
	$lang .= ($c == "on") ? "- C/C++<br>" : '';
	$lang .= ($php == "on") ? "- PHP<br>" : '';
	$lang .= ($delphi == "on") ? "- Delphi<br>" : '';
	$lang .= ($sql == "on") ? "- SQL<br>" : '';
	$lang .= ($html == "on") ? "- HTML<br>" : '';
	if(!empty($lang)) {
		echo "Folgende Programmiersprachen beherrschst du:<br><span class='review'>";
		echo $lang;
		echo "</span><br>";
	}

	echo ($eigeneApp == "true") ? "Du hast bereits eine <span class='review'>eigene Anwendung</span> erstellt.<br>" : '';
	echo ($eigeneHp == "true") ? "Du hast bereits eine <span class='review'>eigene Homepage</span> erstellt.<br>" : '';

	if(!empty($erwartung)) {
		echo "<br>";
		echo "Dies sind deine Erwartungen:<br><span class='review'>" . $erwartung;
		echo "</span>";
	}
	echo "</span><br><br>";
	echo "<a href='javascript:history.back()'>korrigieren</a>";
	
}

?></div>
</div>
</div>
</body>
</html>
