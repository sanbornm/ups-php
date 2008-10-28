<html>
<body>
<?php
// Require the main ups class and upsRate
require('../classes/class.ups.php');
require('../classes/class.upsRate.php');

// Get credentials from a form
$accessNumber = $_POST['accessNumber'];
$username = $_POST['username'];
$password = $_POST['password'];

// If the form is filled out go get a rate from UPS 
if ($accessNumber != '' && $username != '' && $password != '') {
	// Replace the values below with your own credentials.
	$upsConnect = new ups("$accessNumber","$username","$password");
	$upsConnect->setTemplatePath('../xml/');
	$upsConnect->setTestingMode(1); // Change this to 0 for production
	
	
	
	$upsRate = new upsRate($upsConnect);
	
	echo '<h2>UPS Rates Response XML in an Array</h2>';
	
	# Shop for different services
	#$upsRate->request(array('Shop' => true));
	# Return a specific service rate
	$upsRate->request(array());

	$upsRate->shipper(array('name' => 'mark',
							 'phone' => '5556568976', 
							 'shipperNumber' => '486732', 
							 'address1' => '14 main st', 
							 'address2' => '', 
							 'address3' => '', 
							 'city' => 'Beverly Hills', 
							 'state' => 'CA', 
							 'postalCode' => '90210', 
							 'country' => 'US'));

	$upsRate->shipTo(array('companyName' => 'mark', 
							'attentionName' => 'mark', 
							'phone' => '5554823976', 
							'address1' => '12 Hollywood Blvd', 
							'address2' => '', 
							'address3' => '', 
							'city' => 'Beverly Hills', 
							'state' => 'CA', 
							'postalCode' => '90210', 
							'countryCode' => 'US'));

	$upsRate->package(array('description' => 'my description', 'code' => '02'));

	$upsRate->shipment(array('description' => 'my description','serviceType' => '03'));

	$rateFromUPS = $upsRate->rate();
	echo '<pre>'; print_r($rateFromUPS); echo '</pre>';


	echo '<h2>XML Sent to UPS</h2>';
	echo '<pre><![CDATA['; echo $upsRate->xmlSent; echo ']]></pre>';

} else {
	echo 'One or more parts of the form are not filled out.  You must provide your UPS credentials in order to get an accurate rate.';
}
?>
<form action="" method="POST">
	Access Key: <input type="text" name="accessNumber" value="<?php echo $accessNumber; ?>" /><br />
	Username: <input type="text" name="username" value="<?php echo $username; ?>" /><br />
	Password: <input type="password" name="password" value="<?php echo $password; ?>" /><br />
	<input type="submit" name="submit" /><br />
</form>
</body>
</html>
