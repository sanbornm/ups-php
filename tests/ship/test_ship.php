<html>
<body>
<?php
// Require the main ups class and upsRate
require('../../classes/class.ups.php');
require('../../classes/class.upsShip.php');

// Get credentials from a form
$accessNumber = $_POST['accessNumber'];
$username = $_POST['username'];
$password = $_POST['password'];

// Approve the label
$approve = $_POST['approve'];
$ShipmentDigest = $_POST['ShipmentDigest'];

// If the form is filled out go get a rate from UPS 
if ($accessNumber != '' && $username != '' && $password != '') {
	$upsConnect = new ups("$accessNumber","$username","$password");
	$upsConnect->setTemplatePath('../../xml/');
	$upsConnect->setTestingMode(1); // Change this to 0 for production

	$upsShip = new upsShip($upsConnect);

	?>

	<?php
	if ($approve == 'approve shipment') {
		echo $upsShip->buildShipmentAcceptXML($ShipmentDigest);
		// echo $upsShip->responseXML;
		$responseArray = $upsShip->responseArray();
		$htmlImage = $responseArray['ShipmentAcceptResponse']['ShipmentResults']['PackageResults']['LabelImage']['GraphicImage']['VALUE'];
		echo '<img src="data:image/gif;base64,'. $htmlImage. '"/>';
	} else {
		echo '<pre>'; print_r($upsShip->buildRequestXML()); echo '</pre>';
		$responseArray = $upsShip->responseArray();
	}
	?>

	<form action="" method="POST">
		<input type="submit" name="approve" value="approve shipment" />
		<input type="hidden" name="accessNumber" value="<?php echo $accessNumber; ?>" />
		<input type="hidden" name="username" value="<?php echo $username; ?>" />
		<input type="hidden" name="password" value="<?php echo $password; ?>" />
		<input type="hidden" name="ShipmentDigest" value="<?php echo $responseArray['ShipmentConfirmResponse']['ShipmentDigest']['VALUE']; ?>" />
	</form>

<?php } ?>

<h2>XML Sent to UPS</h2>
<pre><?php echo htmlspecialchars($upsShip->xmlSent); ?></pre>

<form action="" method="POST">
	Access Key: <input type="text" name="accessNumber" value="<?php echo $accessNumber; ?>" /><br />
	Username: <input type="text" name="username" value="<?php echo $username; ?>" /><br />
	Password: <input type="password" name="password" value="<?php echo $password; ?>" /><br />
	<input type="submit" name="submit" /><br />
</form>


</body>
</html>
