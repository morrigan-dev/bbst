<?php

include_once 'config.php';
include_once 'classes.php';

// Erzeuge benötigte Objekte
$dbconnect = new DBConnection(MYSQL_HOST, MYSQL_BENUTZER, MYSQL_KENNWORT, MYSQL_DATENBANK);
$bigvideo_queries = new BigVideoQueries($dbconnect);

// Frage GET Variablen ab
$show_alle_schauspieler_result = isset($_GET['alleSchauspieler']);
$show_top30_schauspieler_result = isset($_GET['top30Schauspieler']);
$show_last30_schauspieler_result = isset($_GET['last30Schauspieler']);
$show_a_schauspieler_result = isset($_GET['aSchauspieler']);
$show_usa_filme_result = isset($_GET['usaFilme']);
$show_usa_filme_sort_result = isset($_GET['usaFilmeSort']);
$show_usa1984_filme_result = isset($_GET['usa1984Filme']);
$show_bladerunner_schauspieler_result = isset($_GET['bladerunnerSchauspieler']);
$show_regisseur_maxfilme_result = isset($_GET['regisseurMaxFilme']);

// Daten aus Datenbank abfragen
// 1. Frage
$start_time = microtime();
$schauspieler_alle_db_result = $bigvideo_queries->selectAlleSchauspieler();
$end_time = microtime();
$schauspieler_alle_time = $end_time - $start_time;

// 2. Frage
$start_time = microtime();
$schauspieler_top30_db_result = $bigvideo_queries->selectTop30Schauspieler();
$end_time = microtime();
$schauspieler_top30_time = $end_time - $start_time;

// 3. Frage
$start_time = microtime();
$schauspieler_last30_db_result = $bigvideo_queries->selectLast30Schauspieler();
$end_time = microtime();
$schauspieler_last30_time = $end_time - $start_time;

// 4. Frage
$start_time = microtime();
$schauspieler_a_db_result = $bigvideo_queries->selectASchauspieler();
$end_time = microtime();
$schauspieler_a_time = $end_time - $start_time;

// 5. Frage
$start_time = microtime();
$filme_usa_db_result = $bigvideo_queries->selectFilmeAusUSA(false);
$end_time = microtime();
$filme_usa_time = $end_time - $start_time;

// 6. Frage
$start_time = microtime();
$filme_usa_sort_db_result = $bigvideo_queries->selectFilmeAusUSA(true);
$end_time = microtime();
$filme_usa_sort_time = $end_time - $start_time;

// 7. Frage
$start_time = microtime();
$filme_usa1984_db_result = $bigvideo_queries->selectFilmeAusUSA1984();
$end_time = microtime();
$filme_usa1984_time = $end_time - $start_time;

// 8. Frage
$start_time = microtime();
$filme_bladerunner_schauspieler_db_result = $bigvideo_queries->selectBladeRunnerSchauspieler();
$end_time = microtime();
$filme_bladerunner_schauspieler_time = $end_time - $start_time;

// 9. Frage
$start_time = microtime();
$regisseur_maxfilme_db_result = $bigvideo_queries->selectRegisseurMaxFilme();
$end_time = microtime();
$regisseur_maxfilme_time = $end_time - $start_time;

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript">
<!--
/* http://www.alistapart.com/articles/zebratables/ */
function removeClassName (elem, className) {
	elem.className = elem.className.replace(className, "").trim();
}

function addCSSClass (elem, className) {
	removeClassName (elem, className);
	elem.className = (elem.className + " " + className).trim();
}

String.prototype.trim = function() {
	return this.replace( /^\s+|\s+$/, "" );
}

function stripedTable() {
	if (document.getElementById && document.getElementsByTagName) {  
		var allTables = document.getElementsByTagName('table');
		if (!allTables) { return; }

		for (var i = 0; i < allTables.length; i++) {
			if (allTables[i].className.match(/[\w\s ]*scrollTable[\w\s ]*/)) {
				var trs = allTables[i].getElementsByTagName("tr");
				for (var j = 0; j < trs.length; j++) {
					removeClassName(trs[j], 'alternateRow');
					addCSSClass(trs[j], 'normalRow');
				}
				for (var k = 0; k < trs.length; k += 2) {
					removeClassName(trs[k], 'normalRow');
					addCSSClass(trs[k], 'alternateRow');
				}
			}
		}
	}
}

window.onload = function() { stripedTable(); }
-->
</script>

<title>BigVideo Abfragen</title>
<link rel="stylesheet" type="text/css" href="../css/standard-style.css">

</head>
<body>



<?php 
  	echo "<span class='headercontainer'><img src='../../resources/graphics/warning_icon.jpg' width='54px' height='50px'></span>";
  	echo "<span class='header'> Die Tabellen werden auf dem IE nicht korrekt dargestellt! Nutzen Sie den Firefox, um Anzeigefehler zu vermeiden.</span><br /><br />";

	$question_icon = "<img src='../../resources/graphics/icon_questionmark.gif' alt='question' width='35px' height='35px'>";

	// 1. Frage
  	echo "<a name='quest1'><span class='headercontainer'>" . $question_icon . "</span></a>";
  	echo "<span class='header'> 1. Es sollen alle Daten von allen Schauspielern ausgegeben werden.</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getAlleSchauspielerQuery()) . "<br /><br />";
  	
  	if($show_alle_schauspieler_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Es sind " . mysql_num_rows($schauspieler_alle_db_result) . " Schauspieler vorhanden.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>id</th>";
		echo "<th>schauspieler</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($schauspieler_alle_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[0] . "</td><td>" . $data[1] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $schauspieler_alle_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?alleSchauspieler#quest1' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";
	
  	// 2. Frage
  	echo "<a name='quest2'><span class='headercontainer'>" . $question_icon . "</span></a>";
  	echo "<span class='header'> 2. Es sollen alle Daten von den ersten 30 Schauspielern ausgegeben werden.</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getTop30SchauspielerQuery()) . "<br /><br />";
  	
  	if($show_top30_schauspieler_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Die ersten 30 Schauspieler wurden geladen.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>id</th>";
		echo "<th>schauspieler</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($schauspieler_top30_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[0] . "</td><td>" . $data[1] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $schauspieler_top30_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?top30Schauspieler#quest2' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";
  	
	// 3. Frage
  	echo "<a name='quest3'><span class='headercontainer'>" . $question_icon . "</span></a>";
	echo "<span class='header'> 3. Es sollen alle Daten von den letzten 30 Schauspielern ausgegeben werden.</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getLast30SchauspielerQuery()) . "<br /><br />";
  	
  	if($show_last30_schauspieler_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Die letzten 30 Schauspieler wurden geladen.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>id</th>";
		echo "<th>schauspieler</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($schauspieler_last30_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[0] . "</td><td>" . $data[1] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $schauspieler_last30_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?last30Schauspieler#quest3' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";
	
	// 4. Frage
  	echo "<a name='quest4'><span class='headercontainer'>" . $question_icon . "</span></a>";
	echo "<span class='header'> 4. Es sollen alle Schauspieler ausgegeben werden, die mit 'A' als Namen beginnen.</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getASchauspielerQuery()) . "<br /><br />";
  	
  	if($show_a_schauspieler_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Es sind " . mysql_num_rows($schauspieler_a_db_result) . " Schauspieler, mit dem Anfangsbuchstaben 'A' vorhanden.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>id</th>";
		echo "<th>schauspieler</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($schauspieler_a_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[0] . "</td><td>" . $data[1] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $schauspieler_a_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?aSchauspieler#quest4' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";	
	
	// 5. Frage
  	echo "<a name='quest5'><span class='headercontainer'>" . $question_icon . "</span></a>";
	echo "<span class='header'> 5. Es sollen alle Titel aller Filme ausgegeben werden, die in den USA gedreht wurden.</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getFilmeAusUSAQuery(false)) . "<br /><br />";
  	
  	if($show_usa_filme_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Es sind " . mysql_num_rows($filme_usa_db_result) . " Filme, die in den USA produziert wurden.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>Ort</th>";
		echo "<th>Titel</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($filme_usa_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[1] . "</td><td>" . $data[0] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $filme_usa_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?usaFilme#quest5' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";	
	
	// 6. Frage
  	echo "<a name='quest6'><span class='headercontainer'>" . $question_icon . "</span></a>";
	echo "<span class='header'> 6. Es sollen alle Titel aller Filme ausgegeben werden, die in den USA gedreht wurden, sortiert nach Erstellungsdatum. (Fehler bei mehreren L&auml;ndern).</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo "Die Fehler wurden auf dieser Datenbank behoben, sodass das Jahr immer an den letzten 4 Stellen ablesbar ist.<br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getFilmeAusUSAQuery(true)) . "<br /><br />";
  	
  	if($show_usa_filme_sort_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Es sind " . mysql_num_rows($filme_usa_sort_db_result) . " Filme, die in den USA produziert wurden.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>Ort</th>";
		echo "<th>Titel</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($filme_usa_sort_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[1] . "</td><td>" . $data[0] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $filme_usa_sort_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?usaFilmeSort#quest6' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";	
	
	// 7. Frage
  	echo "<a name='quest7'><span class='headercontainer'>" . $question_icon . "</span></a>";
	echo "<span class='header'> 7. Es sollen alle Filme ausgegeben werden, die in den USA im Jahr 1984 gedreht wurden.</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo "Die Fehler wurden auf dieser Datenbank behoben, sodass das Jahr immer an den letzten 4 Stellen ablesbar ist.<br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getFilmeAusUSA1984Query()) . "<br /><br />";
  	
  	if($show_usa1984_filme_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Es sind " . mysql_num_rows($filme_usa1984_db_result) . " Filme, die in den USA produziert wurden.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>Ort</th>";
		echo "<th>Titel</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($filme_usa1984_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[1] . "</td><td>" . $data[0] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $filme_usa1984_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?usa1984Filme#quest7' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";	
	
	// 8. Frage
  	echo "<a name='quest8'><span class='headercontainer'>" . $question_icon . "</span></a>";
	echo "<span class='header'> 8. Es sollen alle Schauspieler ausgegeben werden, die beim Film Blade Runner - The Director&#180;s Cut mitspielen.</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getBladeRunnerSchauspielerQuery()) . "<br /><br />";
  	
  	if($show_bladerunner_schauspieler_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Es haben " . mysql_num_rows($filme_bladerunner_schauspieler_db_result) . " Schauspieler mitgespielt.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>Titel</th>";
		echo "<th>Schauspieler</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($filme_bladerunner_schauspieler_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[0] . "</td><td>" . $data[1] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $filme_bladerunner_schauspieler_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?bladerunnerSchauspieler#quest8' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";	
	
	
	// 9. Frage
  	echo "<a name='quest9'><span class='headercontainer'>" . $question_icon . "</span></a>";
  	echo "<span class='header'> 9. Welcher Regisseur hat die meisten Filme gedreht?</span><br /><br />";
  	echo "<span class='header'>Abfrage</span><br />";
  	echo $bigvideo_queries->formatQuery($bigvideo_queries->getRegisseurMaxFilmeQuery()) . "<br /><br />";
  	
  	if($show_regisseur_maxfilme_result) {
	  	echo "<span class='header'>Ergebnis</span><br />";
	  	echo "Dies sind die ersten 5 Regisseure mit den meisen Filmen.";
	  	echo "<div id='tableContainer' class='tableContainer'>";
		echo "<table border='1px' cellpadding='0' cellspacing='0' width='100%' height='30px' class='scrollTable'>";
		echo "<thead class='fixedHeader'>";
		echo "<tr>";
		echo "<th>Regisseur</th>";
		echo "<th>Anzahl der Filme</th>";
		echo "</tr>";
		echo "</thead>";
		echo "<tbody class='scrollContent'>";
		while ($data = mysql_fetch_array($regisseur_maxfilme_db_result)) {
			echo "<tr>";
			echo "<td>" . $data[0] . "</td><td>" . $data[1] . "</td>";
			echo "</tr>";
		}
		echo "</tbody>";
		echo "</table>";
		echo "</div>";
		echo "Die Abfrage hat " . $regisseur_maxfilme_time . " Sekunden gedauert.";
  	} else {
  		echo "<form action='bigvideo.php?regisseurMaxFilme#quest9' method='post'>";
  		echo "<input type='submit' value='zeige Ergebnis'>";
  		echo "</form>";
  	}
	echo "<br /><br />";	
	
	$bigvideo_queries->__destruct();
	$dbconnect->__destruct();

?>

</body>
</html>