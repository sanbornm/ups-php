<?php

class upsShip {
	var $buildRequestXML;
	var $xmlSent;
	var $responseXML;
	var $ShipmentDigest;

	function upsShip($upsObj) {
		// Must pass the UPS object to this class for it to work
		$this->ups = $upsObj;
	}

	function buildRequestXML() {
		$xml = $this->ups->access();

		$ShipmentConfirmRequestXML = new xmlBuilder();		
		$ShipmentConfirmRequestXML->push('ShipmentConfirmRequest');
		$ShipmentConfirmRequestXML->push('Request');
		$ShipmentConfirmRequestXML->push('TransactionReference');
			$ShipmentConfirmRequestXML->element('CustomerContext', 'ups-php');
			$ShipmentConfirmRequestXML->element('XpciVersion', '1.0001');
		$ShipmentConfirmRequestXML->pop();
		$ShipmentConfirmRequestXML->element('RequestAction', 'ShipConfirm');
		$ShipmentConfirmRequestXML->element('RequestOption', 'nonvalidate');
		$ShipmentConfirmRequestXML->pop(); // end Request
		$ShipmentConfirmRequestXML->push('Shipment');
		$ShipmentConfirmRequestXML->push('Shipper');
			$ShipmentConfirmRequestXML->element('Name', 'Joes Garage');
			$ShipmentConfirmRequestXML->element('AttentionName', 'Mark Sanborn');
			$ShipmentConfirmRequestXML->element('ShipperNumber', '123456');
			$ShipmentConfirmRequestXML->push('Address');
				$ShipmentConfirmRequestXML->element('AddressLine1', '10000 Preston Rd');
				$ShipmentConfirmRequestXML->element('City', 'Whitehall');
				$ShipmentConfirmRequestXML->element('StateProvinceCode', 'MT');
				$ShipmentConfirmRequestXML->element('PostalCode', '59759');
			$ShipmentConfirmRequestXML->pop(); // end Address
		$ShipmentConfirmRequestXML->pop(); // end Shipper 
		$ShipmentConfirmRequestXML->push('ShipTo');
			$ShipmentConfirmRequestXML->element('CompanyName', 'Pep Boys');
			$ShipmentConfirmRequestXML->element('AttentionName', 'Manny');
			$ShipmentConfirmRequestXML->push('PhoneNumber');
				$ShipmentConfirmRequestXML->push('StructuredPhoneNumber');
					$ShipmentConfirmRequestXML->element('PhoneDialPlanNumber', '410');
					$ShipmentConfirmRequestXML->element('PhoneLineNumber', '5551212');
					$ShipmentConfirmRequestXML->element('PhoneExtension', '1234');
				$ShipmentConfirmRequestXML->pop(); // end StrurcturedPhoneNumber 
			$ShipmentConfirmRequestXML->pop(); // end PhoneNumber 
			$ShipmentConfirmRequestXML->push('Address');
				$ShipmentConfirmRequestXML->element('AddressLine1', '201 York Rd');
				$ShipmentConfirmRequestXML->element('City', 'Timonium');
				$ShipmentConfirmRequestXML->element('StateProvinceCode', 'MD');
				$ShipmentConfirmRequestXML->element('CountryCode', 'US');
				$ShipmentConfirmRequestXML->element('PostalCode', '21093');
				$ShipmentConfirmRequestXML->element('ResidentialAddress', '');
			$ShipmentConfirmRequestXML->pop(); // end Address
		$ShipmentConfirmRequestXML->pop(); // end ShipTo
		$ShipmentConfirmRequestXML->push('Service');
			$ShipmentConfirmRequestXML->element('Code', '03');
			$ShipmentConfirmRequestXML->element('Description', 'UPS Ground');
		$ShipmentConfirmRequestXML->pop(); // end Service 
		$ShipmentConfirmRequestXML->push('PaymentInformation');
			$ShipmentConfirmRequestXML->push('Prepaid');
				$ShipmentConfirmRequestXML->push('BillShipper');
					$ShipmentConfirmRequestXML->push('CreditCard');
						$ShipmentConfirmRequestXML->element('Type', '06');
						$ShipmentConfirmRequestXML->element('Number', '4111111111111111');
						$ShipmentConfirmRequestXML->element('ExpirationDate', '011909');
					$ShipmentConfirmRequestXML->pop(); // end CreditCard
				$ShipmentConfirmRequestXML->pop(); // end BillShipper 
			$ShipmentConfirmRequestXML->pop(); // end Prepaid
		$ShipmentConfirmRequestXML->pop(); // end PaymentInformation
		$ShipmentConfirmRequestXML->push('ShipmentServiceOptions');
			$ShipmentConfirmRequestXML->push('OnCallAir');
				$ShipmentConfirmRequestXML->push('PickupDetails');
					$ShipmentConfirmRequestXML->element('PickupDate', '20090115');
					$ShipmentConfirmRequestXML->element('EarliestTimeReady', '0945');
					$ShipmentConfirmRequestXML->element('LatestTimeReady', '1445');
					$ShipmentConfirmRequestXML->push('ContactInfo');
						$ShipmentConfirmRequestXML->element('Name', 'JaneSmith');
						$ShipmentConfirmRequestXML->element('PhoneNumber', '9725551234');
					$ShipmentConfirmRequestXML->pop(); // end ContactInfo
				$ShipmentConfirmRequestXML->pop(); // end PickupDetails
			$ShipmentConfirmRequestXML->pop(); // end OnCallAir
		$ShipmentConfirmRequestXML->pop(); // end ShipmentServiceOptions
		$ShipmentConfirmRequestXML->push('Package');
			$ShipmentConfirmRequestXML->push('PackagingType');
				$ShipmentConfirmRequestXML->element('Code', '02');
			$ShipmentConfirmRequestXML->pop(); // end PackagingType
			$ShipmentConfirmRequestXML->push('Dimensions');
				$ShipmentConfirmRequestXML->push('UnitOfMeasurement');
					$ShipmentConfirmRequestXML->element('Code', 'IN');
				$ShipmentConfirmRequestXML->pop(); // end UnitOfMeasurement
				$ShipmentConfirmRequestXML->element('Length', '22');
				$ShipmentConfirmRequestXML->element('Width', '20');
				$ShipmentConfirmRequestXML->element('Height', '18');
			$ShipmentConfirmRequestXML->pop(); // end Dimensions
			$ShipmentConfirmRequestXML->push('PackageWeight');
				$ShipmentConfirmRequestXML->element('Weight', '14.1');
			$ShipmentConfirmRequestXML->pop(); // end PackageWeight
			$ShipmentConfirmRequestXML->push('ReferenceNumber');
				$ShipmentConfirmRequestXML->element('Code', '02');
				$ShipmentConfirmRequestXML->element('Value', '1234567');
			$ShipmentConfirmRequestXML->pop(); // end ReferenceNumber
			$ShipmentConfirmRequestXML->push('PackageServiceOptions');
				$ShipmentConfirmRequestXML->push('InsuredValue');
					$ShipmentConfirmRequestXML->element('CurrencyCode', 'USD');
					$ShipmentConfirmRequestXML->element('MonetaryValue', '149.99');
				$ShipmentConfirmRequestXML->pop(); // End Insured Value
				// $ShipmentConfirmRequestXML->push('VerbalConfirmation');
				// 	$ShipmentConfirmRequestXML->element('Name', 'SidneySmith');
				// 	$ShipmentConfirmRequestXML->element('PhoneNumber', '4105551234');
				// $ShipmentConfirmRequestXML->pop(); // end VerbalConfirmation
			$ShipmentConfirmRequestXML->pop(); // end PackageServiceOptions
		$ShipmentConfirmRequestXML->pop(); // end Package
	$ShipmentConfirmRequestXML->pop(); // end Shipment
	$ShipmentConfirmRequestXML->push('LabelSpecification');
		$ShipmentConfirmRequestXML->push('LabelPrintMethod');
			$ShipmentConfirmRequestXML->element('Code', 'GIF');
		$ShipmentConfirmRequestXML->pop(); // end LabelPrintMethod
		$ShipmentConfirmRequestXML->element('HTTPUserAgent', 'Mozilla/4.5');
		$ShipmentConfirmRequestXML->push('LabelImageFormat');
			$ShipmentConfirmRequestXML->element('Code', 'GIF');
		$ShipmentConfirmRequestXML->pop(); // end LabelImageFormat
	$ShipmentConfirmRequestXML->pop(); // end LabelSpecification
$ShipmentConfirmRequestXML->pop(); // ShipmentConfirmRequest

		$xml .= $ShipmentConfirmRequestXML->getXml();
		
		$responseXML = $this->ups->request('ShipConfirm', $xml);

		$this->xmlSent = $xml;
		$this->responseXML = $responseXML;
		return $responseXML;
	}

	function buildShipmentAcceptXML($ShipmentDigest) {

		$xml = new xmlBuilder();		
		$xml->push('ShipmentAcceptRequest');
			$xml->push('Request');
				$xml->push('TransactionReference');
					$xml->element('CustomerContext', 'guidlikesubstance');
					$xml->element('XpciVersion', '1.0001');
				$xml->pop(); // end TransactionReference
			$xml->element('RequestAction', 'ShipAccept');
			$xml->pop(); // end Request
		$xml->element('ShipmentDigest', $ShipmentDigest);
		$xml->pop(); // end ShipmentAcceptRequest

		$ShipmentAcceptXML = $this->ups->access();
		$ShipmentAcceptXML .= $xml->getXml();
		
		$responseXML = $this->ups->request('ShipAccept', $ShipmentAcceptXML);
		$this->responseXML = $responseXML;

		return $ShipmentAcceptXML;
	}

	function responseArray() {
		$xmlParser = new upsxmlParser();
		$responseArray = $xmlParser->xmlParser($this->responseXML);
		$responseArray = $xmlParser->getData();
		return $responseArray;	
	}



}

?>
