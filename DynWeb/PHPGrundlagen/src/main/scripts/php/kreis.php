<?php

/**
 * Dieser Codeblock zeichnet den Kreis.
 * Über die GET Variable 'r' kann der Radius des Kreises mit angegeben werden.
 */
if(isset($_GET["r"]) && !empty($_GET["r"])) {
	$radius = $_GET["r"];
	$durchmesser = 2 * $radius;

	// create a blank image
	$image = imagecreatetruecolor($durchmesser + 1, $durchmesser + 1);

	// fill the background color
	$bg = imagecolorallocate($image, 255, 255, 255);

	// choose a color for the ellipse
	$col_ellipse = imagecolorallocate($image, 0, 0, 255);

	// draw the ellipse
	imagefill($image, 0, 0, $bg);
	imageellipse($image, $radius, $radius, $durchmesser, $durchmesser, $col_ellipse);

	// output the picture
	header("Content-type: image/png");
	imagepng($image);
	imagedestroy($image);
}

/**
 * Diese Klasse stellt verschiedene Funktionen eines Kreises zur Verfügung.
 *
 * @since 13.08.2011
 * @author Thomas Gattinger
 * @version 1.0
 */
class Kreis {
	private $radius;

	/**
	 * Dieser Konstruktor erzeugt eine neue Instanz eines Kreises und setzt den Radius des Kreises.
	 *
	 * @param $radius Der Radius dieses Kreises.
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function Kreis($radius) {
		$this->radius = $radius;
	}

	/**
	 * Diese Methode liefert den Umfang dieses Kreises.
	 *
	 * @return den Umfang dieses Kreises.
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function getUmfang() {
		return pi() * $this->getDurchmesser();
	}

	/**
	 * Diese Methode liefert die Fläche dieses Kreises.
	 *
	 * @return die Fläche dieses Kreises.
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function getFlaeche() {
		return pi() * $this->radius * $this->radius;
	}

	/**
	 * Diese Methode liefert Informationen über diesen Kreis.
	 *
	 * @return Informationen über diesen Kreis.
	 * @since 13.08.2011
	 * @author Thomas Gattinger
	 */
	public function toString() {
		return "Kreis Eigenschaften:<br>Radius: " . $this->radius . " px<br>Umfang: " . $this->getUmfang()
		. " px<br>Fl&#228;che: " . $this->getFlaeche() . " px<sup>2</sup>";
	}

	/**
	 * Diese Methode liefert den Durchmesser dieses Kreises.
	 *
	 * @return den Durchmesser in Pixel.
	 * @since 14.08.2011
	 * @author Thomas Gattinger
	 */
	public function getDurchmesser() {
		return 2 * $this->radius;
	}

	/**
	 * Diese Methode zeichnet diesen Kreis.
	 *
	 * @since 14.08.2011
	 * @author Thomas Gattinger
	 */
	public function draw() {
		echo "<img src=kreis.php?r=" . $this->radius . ">";
	}
}

?>
