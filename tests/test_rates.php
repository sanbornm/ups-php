<?php
//TODO: This is not a functional test yet as class.upsRate.php is not finished
require('../classes/class.ups.php');
require('../classes/class.upsRate.php');

$accessNumber = $_POST['accessNumber'];
$username = $_POST['username'];
$password = $_POST['password'];

if (isset($accessNumber)) {
	// Replace the values below with your own credentials.
	$upsConnect = new ups("$accessNumber","$username","$password");
	$upsConnect->setTemplatePath('../xml/');
	$upsConnect->setTestingMode(1); // Change this to 0 for production
	
	$upsRate = new upsRate($upsConnect);
	
	print '<h2>UPS Rates Test</h2>';
	
	$rateData = $upsRate->rate();
	echo '<pre>'; print_r($rateData); echo '</pre>';
	
}
?>
<form action="" method="POST">
	Access Key: <input type="text" name="accessNumber" value="<?php echo $accessNumber; ?>" /><br />
	Username: <input type="text" name="username" value="<?php echo $username; ?>" /><br />
	Password: <input type="password" name="password" value="<?php echo $password; ?>" /><br />
	<input type="submit" name="submit" /><br />
</form>
