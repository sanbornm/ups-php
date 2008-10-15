<?php
class upsTrack {
	
	function upsTrack($upsObj){
		// Must pass the UPS object to this class for it to work
		$this->ups = $upsObj;
	}
	
	function track($trackingNumber){
		$xml = $this->ups->access();
		$xml .= $this->ups->sandwich($this->ups->templatePath.'Tracking/TrackRequest.xml', array('{TRACKING_NUMBER}'), array($trackingNumber));
		$responseXML = $this->ups->request('Track', $xml);
		$xmlParser = new XML2Array();
		$fromUPS = $xmlParser->parse($responseXML);
	return $fromUPS;
	}

}
?>
