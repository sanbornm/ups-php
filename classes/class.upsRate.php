<?php

class upsRate {
	
	function upsRate($upsObj) {
		// Must pass the UPS object to this class for it to work
		$this->ups = $upsObj;
	}
	
	function rate() {
		$xml = $this->ups->access();
		$content = $this->ups->sandwich($this->ups->templatePath.'Rates/RatingServiceSelection_Request.xml', array(), array());
		$content .=$this->ups->sandwich($this->ups->templatePath.'Rates/RatingServiceSelection_PickupType.xml', array('{PICKUP_TYPE}','{DESCRIPTION}'), array($pickupType,'blah'));
		$xml .= $this->ups->sandwich($this->ups->templatePath.'Rates/RatingServiceSelection_Main.xml', array('{CONTENT}'), array($content));
		echo "<pre>$xml</pre>";
		$responseXML = $this->ups->request('Rate', $xml);
		$xmlParser = new XML2Array();
		$fromUPS = $xmlParser->parse($responseXML);
		return $fromUPS;
	}
}
?>
