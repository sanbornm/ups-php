<?php
class upsTrack {
	var $xmlSent;
	
	function upsTrack($upsObj){
		// Must pass the UPS object to this class for it to work
		$this->ups = $upsObj;
	}
	
	function track($trackingNumber){
		$xml = $this->ups->access();
		$xml .= $this->ups->sandwich($this->ups->templatePath.'Tracking/TrackRequest.xml', array('{TRACKING_NUMBER}'), array($trackingNumber));

		// Put the xml that is sent do UPS into a variable so we can call it later for debugging.
		$this->xmlSent = $xml;

		$responseXML = $this->ups->request('Track', $xml);
		$xmlParser = new XML2Array();
		$fromUPS = $xmlParser->parse($responseXML);
	return $fromUPS;
	}

}
?>
