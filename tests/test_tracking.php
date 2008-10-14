<?php
require('../classes/class.ups.php');
require('../classes/class.upsTrack.php');

// Obviously, replace the values below with your setup.
$ups_connect = new ups('1234567890123456','username','password');
$ups_connect->setTemplatePath('../xml/');
$ups_connect->setTestingMode(1);

$ups_track = new upsTrack($ups_connect);

print "<h2>UPS Tracking Test</h2>";

$tracking_data = $ups_track->track('1Z12345E1392654435');

print "<pre>";
print_r($tracking_data);
print "</pre>";
?>