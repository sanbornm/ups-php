<html>
<body>
<?php
// Require the main ups class and upsRate
require('../../classes/class.ups.php');
require('../../classes/class.upsVoid.php');

// Get credentials from a form
$accessNumber = $_POST['accessNumber'];
$username = $_POST['username'];
$password = $_POST['password'];
$ShipmentIdentificationNumber = $_POST['ShipmentIdentificationNumber'];

// If the form is filled out go get a rate from UPS 
if ($accessNumber != '' && $username != '' && $password != '') {
	//Initiate the main UPS class
	$upsConnect = new ups("$accessNumber","$username","$password");
	$upsConnect->setTemplatePath('../../xml/');
	$upsConnect->setTestingMode(1); // Change this to 0 for production
	$upsVoid = new upsVoid($upsConnect);

	$upsVoid->buildRequestXML($ShipmentIdentificationNumber);

	echo $upsVoid->responseXML;	
}
?>

<h2>XML Sent to UPS</h2>
<pre><?php echo htmlspecialchars($upsVoid->xmlSent); ?></pre>

<form action="" method="POST">
	Access Key: <input type="text" name="accessNumber" value="<?php echo $accessNumber; ?>" /><br />
	Username: <input type="text" name="username" value="<?php echo $username; ?>" /><br />
	Password: <input type="password" name="password" value="<?php echo $password; ?>" /><br />
	Shipment Identification Number: <input type="text" name="ShipmentIdentificationNumber" value="<?php echo $ShipmentIdentificationNumber; ?>" /><br />
	<input type="submit" name="submit" /><br />
</form>
</body>
</html>
