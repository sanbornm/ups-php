# Update 08/20/2009 #
I have had a lot of people emailing me for support for various modules and integration specific questions.  Because of this, I have made a commercial product called, [RocketShipIt](http://rocketship.it).  It supports all the UPS Online Tools APIs as well as generates the 40+ required files you need to get certified with UPS.  With the purchase of the product you also get support and help with any integration questions you might have.

## What about ups-php? ##
I will still remain active and update this code but integration specific support will be slower.

# About #
This project was started as we have found there is a need for modules written in PHP to communicate with the UPS Shipping API.

Mark has already written code that [calculates UPS shipping rates](http://www.marksanborn.net/php/calculating-ups-shipping-rate-with-php/) using the API.  This was the first implementation.  Now we have a great team of developers that are working hard to bring you a complete framework for all of the UPS services.

The plan for this project is to create reusable code for use with all of the UPS shipping tools through thier XML API.

This project will eventually cover all of these UPS API tools.

  * UPS Tracking Tool
  * UPS Signature Tracking
  * UPS Rates & Service Selection Tool
  * UPS Address Validation Tool
  * UPS File Download for Quantum View
  * UPS Shipping Tool
  * UPS Time in Transit Tool
  * UPS Trade Ability

# Status #
  * Adding ShipTools to the SVN code
  * Current version: 0.2
  * **Lasted Updated: 06-11-2009**

# Usage #
Here are the following usages for the UPS modules.  As of right now there are only two modules created in the release version.

# Requirements #
PHP4 or PHP5 with cURL(libcurl) installed and enabled.

## UPS Rate Selection ##
```
require("upsRate.php");
$myRate = new upsRate('accessnumber','username','password','shippernumber');
echo $myRate->getRate('fromzip','tozip',"service",length,width,height,weight);
```

## UPS Tracking ##
```
require("upsTrack.php");
$myRate = new upsTrack('accessnumber','username','password');
http://ups-php.googlecode.com/svn/trunk/array = $myRate->getTrack('TrackingNumber');
```

# Beta Code #
If you want more functionality or want to see what is coming in the next versions of ups-php, check out our svn at:

http://ups-php.googlecode.com/svn/trunk/

We are working diligently on the next version and want to make it a complete implementation of the UPS API.  This is a very active project so check back often.