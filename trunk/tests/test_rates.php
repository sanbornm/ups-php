<?php
//TODO: This is not a functional test yet as class.upsRate.php is not finished
require('../classes/class.ups.php');
require('../classes/ckass.upsRate.php');

// Replace the values below with your own credentials.
$upsConnect = new ups('accessNumber','username','password');
$upsConnect->setTemplatePath('../xml/');
$upsConnect->setTestingMode(1); // Change this to 0 for production

$upsRate = new upsRate($upsConect);

print '<h2>UPS Rates Test</h2>';

$trackingData = $upsRate->rate();




?>
