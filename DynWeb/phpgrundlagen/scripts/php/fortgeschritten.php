<?php

include 'classes.php';

$array = new Arrays();
$array->createEindimensionalesArray(10);
$array->printEindimensionalesArray();
echo "<br>";

$array->createZweidimensionalesArray();
$array->printZweidimensionalesArray();
echo "<br>";

echo "<b>Ein assoziatives eindimensionales Array kann Werte &#252;ber ein Schl&#252;ssel liefern.</b><br>";
echo "Dies kann z.B. n&#252;tzlich bei Beschriftungen in verschiedenen Sprachen n&#252;tzlich sein.";
echo "<br><br>";
$array->createAssoziativ1DimArray();
$array->printAssoziatives1DimArray();
echo "<br>";

$array->createAssoziativ2DimArray();
$array->printAssoziatives2DimArray();
echo "<br>";
echo "<b>Mit assoziativen zweidimensionalen Arrays k&#246;nnen Werte angesprochen werden, die von zwei Parametern abh&#228;ngen.<br>"; 
echo "Dies kann z.B. ein Stundenplan sein, von dem man wissen m&#246;chte welches Fach man an einem Tag zu einer Uhrzeit hat.</b>";
echo "<br>";
echo "Welches Fach habe ich am Dienstag um 10:25 Uhr?<br>";
echo "Antwort: " . $array->getAssoziativ2DimArray("10:25", "Dienstag");

?>