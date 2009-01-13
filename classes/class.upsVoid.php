<?php
class upsVoid {
	var $responseXML;
	var $xmlSent;

	function upsVoid($upsObj) {
		// Must pass the UPS object to this class for it to work
		$this->ups = $upsObj;
	}

	function buildRequestXML($ShipmentIdentificationNumber) {
		$xml = new xmlBuilder();
		$xml->push('VoidShipmentRequest');
			$xml->push('Request');
				$xml->element('RequestAction', '1');
			$xml->pop(); // end Request
			$xml->element('ShipmentIdentificationNumber', $ShipmentIdentificationNumber);
		$xml->pop(); // end VoidShipmentRequest

		$VoidRequestXML = $this->ups->access();
		$VoidRequestXML .= $xml->getXml();

		$responseXML = $this->ups->request('Void', $VoidRequestXML);
		$this->responseXML = $responseXML;
		$this->xmlSent = $VoidRequestXML;

		return $VoidRequestXML;
	}

	function voidMultiShipment($ShipmentIdentificationNumber,$TrackingNumber) {
		$xml = new xmlBuilder();
		$xml->push('VoidShipmentRequest');
			$xml->push('Request');
				$xml->element('RequestAction', '1');
			$xml->pop(); // end Request
		$xml->push('ExpandedVoidShipment');
			$xml->element('ShipmentIdentificationNumber', $ShipmentIdentificationNumber);
			foreach ($TrackingNumber as $tracking) {
				$xml->element('TrackingNumber', $tracking);
			}
		$xml->pop(); // end ExpandedVoidShipment
		$xml->pop(); // end VoidShipmentRequest


		$voidMultiShipment = $this->ups->access();
		$voidMultiShipment .= $xml->getXml();

		$responseXML = $this->ups->request('Void', $voidMultiShipment);
		$this->responseXML = $responseXML;
		$this->xmlSent = $voidMultiShipment;

	}
}

?>
