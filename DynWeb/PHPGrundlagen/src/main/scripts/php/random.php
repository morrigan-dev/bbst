<?php

class Random {
	public function wuefeln(&$angreifer, &$verteidiger) {
		while( $angreifer > 0 && $verteidiger > 0 ) {
			$awuerfel = $vwuerfel = array(0,0,0);

			for ( $i = 0; $i < $angreifer && $i < 3; $i++ ) {
				$awuerfel[ $i ] = mt_rand( 1, 6 );
			}

			for ( $i = 0; $i < $verteidiger && $i < 2; $i++ ) {
				$vwuerfel[ $i ] = mt_rand( 1, 6 );
			}

			// compare highest dice rolls against eachother
			rsort($awuerfel, SORT_NUMERIC);
			rsort($vwuerfel, SORT_NUMERIC);

			// only the two highest dice rolls need to be compared
			for ( $i = 0; $i < 2; $i++ ) {
				if ( $vwuerfel[$i] == 0 || $awuerfel[$i] == 0 )
				break; // there are no more dice rolls

				if ( $vwuerfel[$i] >= $awuerfel[$i] )
				$angreifer--; // defender wins
				else
				$verteidiger--; // attacker wins
			}
		}
	}
}

$random = new Random();
$awin = 0;
$vwin = 0;
for ($i = 0; $i < 1; $i++) {
	$angreifer = 1;
	$verteidiger = 1;
	$random->wuefeln($angreifer, $verteidiger);
	if($angreifer > 0) {
		$awin++;
	} else {
		$vwin++;
	}
}
echo "awin = " . $awin . "<br>";
echo "vwin = " . $vwin . "<br>";

$anzahl = array(0,0,0,0,0,0);
for ($i = 0; $i < 1000000; $i++) {
	$anzahl[mt_rand( 1, 6 )-1]++;
}
for ($j = 0; $j < 6; $j++) {
	echo ($j+1) . " -> " . $anzahl[$j] . "<br>";
}
?>