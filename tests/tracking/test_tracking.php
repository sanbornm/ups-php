<html>
<body>
<?php
require('../../classes/class.ups.php');
require('../../classes/class.upsTrack.php');

// Get credentials from a form
$accessNumber = $_POST['accessNumber'];
$username = $_POST['username'];
$password = $_POST['password'];
$trackingNumber = $_POST['tracking'];

// Obviously, replace the values below with your setup.
if ($accessNumber != '' && $username != '' && $password != '') {
	$ups_connect = new ups($accessNumber,$username,$password);
	$ups_connect->setTemplatePath('../../xml/');
	$ups_connect->setTestingMode(1); //Change this to 0 for production

	$upsTrack = new upsTrack($ups_connect);

	$tracking_data = $upsTrack->track($trackingNumber);
?>
<h2>UPS Tracking Test</h2>
<pre><?php print_r($tracking_data); ?></pre>

<h2>XML Sent to UPS</h2>
<pre><?php echo htmlspecialchars($upsTrack->xmlSent); ?></pre>
<?php } else { ?>
One or more parts of the form are not filled out.  You must provide your UPS credentials in order to get an accurate rate.
<?php } ?>


<form action="" method="POST">
	<fieldset style="width:250px;">
	<legend><strong>Credentials</strong></legend>
	Access Key: <input type="text" name="accessNumber" value="<?php echo $accessNumber; ?>" /><br />
	Username: <input type="text" name="username" value="<?php echo $username; ?>" /><br />
	Password: <input type="password" name="password" value="<?php echo $password; ?>" /><br />
	</fieldset>
	<fieldset style="width:250px;">
	<legend><strong>Tracking Info</strong></legend>
	Tracking Number: <input type="text" name="tracking" value="<?php echo $trackingNumber; ?>" /><br/>
	</fieldset>
	<input type="submit" name="submit" /><br />
</form>


</body>
</html>
