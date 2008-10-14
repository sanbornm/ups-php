package com.ups.xmlsample.tracking;

import org.xml.sax.SAXException;
import org.w3c.dom.Node;
//import com.ibm.xml.parser.LibraryException;
import org.w3c.dom.Element;
import org.w3c.dom.Document;
import com.ups.xmlsample.*;
//xpci data container
import com.ups.xmlsample.xpci.*;

/**
 * Class Name: TrackingAdapter.java
 * Description: class used to convert TrackRequest objects into XML,
 *  and parse XML returned into TrackResponse objects
 */
 
public class TrackingAdapter extends com.ups.xmlsample.Adapter
{
	private String TRACKING_FACILITY = "TrackingAdapter";

/**
 * 
 * 
 * 
 */
public TrackingAdapter()
{
	super();
}
/**
 * Method converts an TrackingRequest object into XML as a StringBuffer, 
 *
 * @return java.lang.StringBuffer
 * @param aServReqContainer com.ups.xml.sample.ServiceRequestContainer
 */
public StringBuffer adaptFromObject(ServiceRequestContainer src) throws Exception
{
	servReqCont = src;
	StringBuffer xmlBuf = new StringBuffer();
	Document doc = createXMLDocument(XML_TrackRequest);
	Element root = doc.getDocumentElement();
	root.setAttribute("xml:lang", "en-US");
	try
	{
		TrackingRequest tr = (TrackingRequest) src;
		// build request
		try
		{
		buildRequest(doc, XML_TrackRequest);
		}catch(Exception e)
		{
			System.out.println("error in buildRequest " + e);
			throw new Exception ("error in buildRequest " + e);
		}
		tr.setRequest(servReqCont.getRequest());

		/***** build tracking info *****/

		// shipment id request
		if (tr.getType().equals(TrackingRequest.SHIPMENT_TRACK))
			addNode(doc, XML_TrackRequest, XML_ShipmentIdentificationNumber, tr.getShipmentIdentificationNumber(), null, null);
		// tracking number request
		if (tr.getType().equals(TrackingRequest.TRACKING_NUMBER_TRACK))
			addNode(doc, XML_TrackRequest, XML_TrackingNumber, tr.getTrackingNumber(), null, null);
		// reference number request
		if (tr.getType().equals(TrackingRequest.REFERENCE_TRACK))
		{
			String referenceNumValue = tr.getReferenceValue();
			if (referenceNumValue != null)
			{
				addNode(doc, XML_TrackRequest, XML_ReferenceNumber, null, null, null);
				addNode(doc, XML_ReferenceNumber, tr.getReferenceCode(), null, null, null);
				addNode(doc, XML_ReferenceNumber, referenceNumValue, null, null, null);
				String shipperNumber = tr.getShipperNumber();
				if (shipperNumber != null)
					addNode(doc, XML_TrackRequest, XML_ShipperNumber, shipperNumber, null, null);
				String destinationPostalCode = tr.getDestinationPostalCode();
				if (destinationPostalCode != null)
					addNode(doc, XML_TrackRequest, XML_DestinationPostalCode, destinationPostalCode, null, null);
				String destinationCountryCode = tr.getDestinationCountryCode();
				if (destinationCountryCode != null)
					addNode(doc, XML_TrackRequest, XML_DestinationCountryCode, destinationCountryCode, null, null);
				String pickupDateRangeBegin = tr.getPickupDateRangeBegin();
				String pickupDateRangeEnd = tr.getPickupDateRangeEnd();
				if ((pickupDateRangeBegin != null) && (pickupDateRangeEnd != null))
				{
					addNode(doc, XML_TrackRequest, XML_PickupDateRange, null, null, null);
					addNode(doc, XML_PickupDateRange, XML_BeginDate, pickupDateRangeBegin, null, null);
					addNode(doc, XML_PickupDateRange, XML_EndDate, pickupDateRangeEnd, null, null);
				}
			}
		}

		// convert Document to StringBuffer
		xmlBuf = docToBuffer(doc);
		
	} catch (Exception e)
	{
		System.out.println("TrackingAdapter error in adaptfromObject --> " + e);
		throw new Exception ("TrackingAdapter error in adaptfromObject --> " + e);
	}
	return xmlBuf;
}
/**
 * Method takes the XML document as a StringBuffer, 
 * parses the XML document, and returns into TrackingResponse.
 *
 * @param java.lang.StringBuffer document
 */
public ServiceResponseContainer adaptFromXml(StringBuffer xmlIn) throws Exception
{
	try
	{
		servRespCont = new com.ups.xmlsample.ServiceResponseContainer();
		TrackingResponse tr = new TrackingResponse();
		Document doc = getDocument(xmlIn.toString());
		org.w3c.dom.Node root = doc.getFirstChild();
		// retrieve the response node XML information and build the response container
		buildResponse(root);
		tr.setResponse(servRespCont.getResponse());

		// walk the doc
		if (servRespCont.getResponse().getResponseStatusCode().equals(RESPONSE_SUCCESS))
		{
			java.util.Vector shipVect = new java.util.Vector();
			org.w3c.dom.Node shipmentNode = null;
			int k =0;
			for (shipmentNode = getChildNode(root, XML_Shipment); shipmentNode != null; shipmentNode = shipmentNode.getNextSibling())
			{
				if (shipmentNode.getNodeName().equalsIgnoreCase(XML_Shipment))
				{
					Shipment ship = new Shipment();
					ship.setDescription(getChildNodeValue(shipmentNode, XML_Description));
					if (getChildNode(shipmentNode, XML_DocumentsOnly) != null)
						ship.setDocuments(true);
					ship.setShipmentID(getChildNodeValue(shipmentNode, XML_ShipmentIdentificationNumber));
					ship.setDeliveryZone(getChildNodeValue(shipmentNode, XML_DeliveryZone));
					ship.setPickupDate(getChildNodeValue(shipmentNode, XML_PickupDate));
					ship.setScheduledDeliveryDate(getChildNodeValue(shipmentNode, XML_ScheduledDeliveryDate));
					ship.setScheduledDeliveryTime(getChildNodeValue(shipmentNode, XML_ScheduledDeliveryTime));
					ship.setAlternateDeliveryDate(getChildNodeValue(shipmentNode, XML_AlternateDeliveryDate));
					ship.setAlternateDeliveryTime(getChildNodeValue(shipmentNode, XML_AlternateDeliveryTime));
					org.w3c.dom.Node invoice = getChildNode(shipmentNode, XML_InvoiceLineTotal);
					if (invoice != null)
					{
						ship.setInvoiceCurrencyCode(getChildNodeValue(invoice, XML_CurrencyCode));
						ship.setInvoiceMonetaryValue(getChildNodeValue(invoice, XML_MonetaryValue));
					}
					org.w3c.dom.Node service = getChildNode(shipmentNode, XML_Service);
					if (service != null)
					{
						ship.setServiceCode(getChildNodeValue(service, XML_Code));
						ship.setServiceDescription(getChildNodeValue(service, XML_Description));
					}
					HandlingCharge handle = new HandlingCharge();
					org.w3c.dom.Node hnode = getChildNode(shipmentNode, XML_HandlingCharge);
					if (hnode != null)
					{
						org.w3c.dom.Node frnode = getChildNode(hnode, XML_FlatRate);
						if (frnode != null)
						{
							handle.setFlatRateCurrencyCode(getChildNodeValue(frnode, XML_CurrencyCode));
							handle.setFlatRateValue(getChildNodeValue(frnode, XML_MonetaryValue));
						}
						handle.setPercentage(getChildNodeValue(hnode, XML_Percentage));
					}
					ship.setHandlingCharge(handle);
					org.w3c.dom.Node shipmentWeight = getChildNode(shipmentNode, XML_ShipmentWeight);
					if (shipmentWeight != null)
					{
						org.w3c.dom.Node uom = getChildNode(shipmentWeight, XML_UnitOfMeasurement);
						if (uom != null)
						{
							ship.setShipmentWeightCode(getChildNodeValue(uom, XML_Code));
							ship.setShipmentWeightDescription(getChildNodeValue(uom, XML_Description));
						}
						ship.setShipmentWeight(getChildNodeValue(shipmentWeight, XML_Weight));
					}
					org.w3c.dom.Node paymentInfo = getChildNode(shipmentNode, XML_PaymentInformation);
					if (paymentInfo != null)
					{
						Node prepaid = getChildNode(paymentInfo, XML_Prepaid);
						if (prepaid != null)
						{
							org.w3c.dom.Node billShipper = getChildNode(prepaid, XML_BillShipper);
							if (billShipper != null)
							{
								PrepaidBillShipper pbs = new PrepaidBillShipper();
								pbs.setAccountNumber(getChildNodeValue(billShipper, XML_AccountNumber));
								org.w3c.dom.Node creditCard = getChildNode(billShipper, XML_CreditCard);
								if (creditCard != null)
								{
									pbs.setCreditCardType(getChildNodeValue(creditCard, XML_Type));
									pbs.setCreditCardNumber(getChildNodeValue(creditCard, XML_Number));
									pbs.setCreditCardExpiration(getChildNodeValue(creditCard, XML_ExpirationDate));
								}
								ship.setPaymentInfo(pbs);
							}
							org.w3c.dom.Node billThird = getChildNode(prepaid, XML_BillThirdPartyShipper);
							if (billThird != null)
							{
								PrepaidBillThirdShipper pbts = new PrepaidBillThirdShipper();
								pbts.setAccountNumber(getChildNodeValue(billThird, XML_AccountNumber));
								org.w3c.dom.Node agent = getChildNode(billThird, XML_ThirdParty);
								CorpAgent third = new CorpAgent();
								if (agent != null)
								{
									third.setAttentionName(getChildNodeValue(agent, XML_AttentionName));
									third.setCompanyName(getChildNodeValue(agent, XML_CompanyName));
									third.setTaxID(getChildNodeValue(agent, XML_TaxIdentificationNumber));
									org.w3c.dom.Node faxDest = getChildNode(agent, XML_FaxDestination);
									if (faxDest != null)
									{
										third.setFaxDestinationFaxNumber(getChildNodeValue(faxDest, XML_FaxNumber));
										third.setFaxDestinationID(getChildNodeValue(faxDest, XML_FaxDestinationIndicator));
									}
									org.w3c.dom.Node phoneNum = getChildNode(agent, XML_PhoneNumber);
									if (phoneNum != null)
									{
										third.setPhoneNumber(buildPhoneVector(phoneNum));
									}
									org.w3c.dom.Node address = getChildNode(agent, XML_Address);
									if (address != null)
									{
										Address add = new Address();
										add.setAddressLine1(getChildNodeValue(address, XML_AddressLine1));
										add.setAddressLine2(getChildNodeValue(address, XML_AddressLine2));
										add.setAddressLine3(getChildNodeValue(address, XML_AddressLine3));
										add.setCity(getChildNodeValue(address, XML_City));
										add.setCountryCode(getChildNodeValue(address, XML_CountryCode));
										add.setPostalCode(getChildNodeValue(address, XML_PostalCode));
										add.setStateProvinceCode(getChildNodeValue(address, XML_StateProvinceCode));
										org.w3c.dom.Node res = getChildNode(address, XML_ResidentialAddressIndicator);
										if (res != null)
										{
											add.setResidentialAddress(true);
										}
										third.setAddress(add);
									}
									pbts.setThirdParty(third);
								}
								ship.setPaymentInfo(pbts);
							}
						}
					}

					// Build a Reference Number Vector
					java.util.Vector refVect = new java.util.Vector();
					org.w3c.dom.Node ref = null;
					for (ref = getChildNode(shipmentNode, XML_ReferenceNumber); ref != null; ref = ref.getNextSibling())
					{
						if (ref.getNodeType() != org.w3c.dom.Node.TEXT_NODE)
						{
							ReferenceNumber refNum = new ReferenceNumber();
							refNum.setCode(getChildNodeValue(ref, XML_Code));
							refNum.setValue(getChildNodeValue(ref, XML_Value));
							refVect.addElement(refNum);
						}
					}
					ship.setReferenceNumbers(refVect);
					// add the shipper
					org.w3c.dom.Node shipAgent = getChildNode(shipmentNode, XML_Shipper);
					if (shipAgent != null)
					{
						Agent shipper = new Agent();
						buildAgent(shipAgent, shipper);
						ship.setShipper(shipper);
					}
					// add the shipto
					org.w3c.dom.Node shiptoAgent = getChildNode(shipmentNode, XML_ShipTo);
					if (shiptoAgent != null)
					{
						Agent shipto = new Agent();
						buildAgent(shiptoAgent, shipto);
						ship.setShipTo(shipto);
					}
					// add the shipfrom
					org.w3c.dom.Node shipfromAgent = getChildNode(shipmentNode, XML_ShipFrom);
					if (shipfromAgent != null)
					{
						Agent shipfrom = new Agent();
						buildAgent(shipfromAgent, shipfrom);
						ship.setShipFrom(shipfrom);
					}
					// add the package
					java.util.Vector packVec = new java.util.Vector();
					org.w3c.dom.Node packages = null;
					int j=0;
					for (packages = getChildNode(shipmentNode, XML_Package); packages != null; packages = packages.getNextSibling())
					{
						if (packages.getNodeName().equalsIgnoreCase(XML_Package))
						{
							Package pack = new Package();
							buildPackage(packages, pack);
							packVec.addElement(pack);
						}
					}
					ship.setPackages(packVec);
				
					// add the shipment service options
					org.w3c.dom.Node shipServ = getChildNode(shipmentNode, XML_ShipmentServiceOptions);
					if (shipServ != null)
					{
						ShipmentServiceOptions sso = new ShipmentServiceOptions();
						Node callTag = getChildNode(shipServ, XML_CallTagARS);
						if (shipServ != null)
						{
							sso.setCallTagARSCode(getChildNodeValue(callTag, XML_Code));
							sso.setCallTagARSNumber(getChildNodeValue(callTag, XML_Number));
							sso.setCallTagARSPickupDate(getChildNodeValue(callTag, XML_PickupDate));
						}
						// build pickup Details
						org.w3c.dom.Node oCall = getChildNode(shipServ, XML_OnCallAir);
						if (oCall != null)
						{
							org.w3c.dom.Node pDetails = getChildNode(oCall, XML_PickupDetails);
							if (pDetails != null)
							{
								PickupDetails pikDetails = new PickupDetails();
								org.w3c.dom.Node contact = getChildNode(pDetails, XML_ContactInfo);
								if (contact != null)
								{
									pikDetails.setContactName(getChildNodeValue(contact, XML_Name));
									org.w3c.dom.Node contPhone = getChildNode(contact, XML_PhoneNumber);
									if (contPhone != null)
									{
										org.w3c.dom.Node structured = getChildNode(contPhone, XML_StructuredPhoneNumber);
										if (structured != null)
										{
											StructuredPhoneNumber strucPhone = new StructuredPhoneNumber();
											strucPhone.setPhoneCountryCode(getChildNodeValue(structured, XML_PhoneCountryCode));
											strucPhone.setPhoneDialPlanNumber(getChildNodeValue(structured, XML_PhoneDialPlanNumber));
											strucPhone.setPhoneExtension(getChildNodeValue(structured, XML_PhoneExtension));
											strucPhone.setPhoneLineNumber(getChildNodeValue(structured, XML_PhoneLineNumber));
											pikDetails.setContactPhone(strucPhone);
										}
									}
								}
								pikDetails.setEarliestTimeReady(getChildNodeValue(pDetails, XML_EarliestTimeReady));
								pikDetails.setFloorID(getChildNodeValue(pDetails, XML_FloorID));
								pikDetails.setLatestTimeReady(getChildNodeValue(pDetails, XML_LatestTimeReady));
								pikDetails.setLocation(getChildNodeValue(pDetails, XML_Location));
								pikDetails.setPickupDate(getChildNodeValue(pDetails, XML_PickupDate));
								pikDetails.setSuiteRoomID(getChildNodeValue(pDetails, XML_SuiteRoomID));
								sso.setOnCallAir(pikDetails);
							}
						}
						// build shipnot
						java.util.Vector snVect = new java.util.Vector();
						org.w3c.dom.Node shipNot = null;
						for (shipNot = getChildNode(shipServ, XML_ShipmentNotification); shipNot != null; shipNot = shipNot.getNextSibling())
						{
							if (shipNot.getNodeName().equalsIgnoreCase(XML_ShipmentNotification))
							{
							ShipmentNotification shNo = new ShipmentNotification();
							shNo.setAttentionName(getChildNodeValue(shipNot, XML_AttentionName));
							shNo.setCompanyName(getChildNodeValue(shipNot, XML_CompanyName));
							shNo.setEmailAddress(getChildNodeValue(shipNot, XML_EmailAddress));
							org.w3c.dom.Node faxDestination = getChildNode(shipNot, XML_FaxDestination);
							if (faxDestination != null)
								{
								shNo.setFaxDestinationIndicator(getChildNodeValue(faxDestination, XML_FaxDestinationIndicator));
								shNo.setFaxDestinationNumber(getChildNodeValue(faxDestination, XML_FaxNumber));
								}
							shNo.setMemo(getChildNodeValue(shipNot, XML_Memo));
							shNo.setNotificationCode(getChildNodeValue(shipNot, XML_NotificationCode));
							// set email message
							EmailMessage emailM = new EmailMessage();
							org.w3c.dom.Node emailMessage = getChildNode(shipNot, XML_EmailMessage);
							if (emailMessage != null)
							{
								org.w3c.dom.Node emailAddress = null;
								int i = 0;
								String[] email = null;
								for (emailAddress = getChildNode(emailMessage, XML_EmailAddress);(i < 3 & emailAddress != null); emailAddress = emailAddress.getNextSibling())
								{
									email[i] = getNodeValue(emailAddress);
									i++;
								}
								emailM.setEmailAddress(email);
							}
							emailM.setMemo(getChildNodeValue(emailMessage, XML_Memo));
							java.util.Vector imVec = new java.util.Vector();
							org.w3c.dom.Node image = null;
							for (image = getChildNode(emailMessage, XML_Image); image != null; image = image.getNextSibling())
							{
								if (image.getNodeName().equalsIgnoreCase(XML_Image))
								{
								Image im = new Image();
								im.setGraphicImage(getChildNodeValue(image, XML_GraphicImage));
								org.w3c.dom.Node imageForm = getChildNode(image, XML_ImageFormat);
								if (imageForm != null)
								{
									im.setImageFormatCode(getChildNodeValue(imageForm, XML_Code));
									im.setImageFormatDesc(getChildNodeValue(imageForm, XML_Description));
								}
								imVec.addElement(im);
								}
							}
							emailM.setImage(imVec);
							shNo.setEmailMessage(emailM);

							// set phone number
							org.w3c.dom.Node snPhone = getChildNode(shipNot, XML_PhoneNumber);
							if (snPhone != null)
							{
								org.w3c.dom.Node structMes = getChildNode(snPhone, XML_StructuredPhoneNumber);
								if (structMes != null)
								{
									StructuredPhoneNumber mesPhone = new StructuredPhoneNumber();
									mesPhone.setPhoneCountryCode(getChildNodeValue(structMes, XML_PhoneCountryCode));
									mesPhone.setPhoneDialPlanNumber(getChildNodeValue(structMes, XML_PhoneDialPlanNumber));
									mesPhone.setPhoneExtension(getChildNodeValue(structMes, XML_PhoneExtension));
									mesPhone.setPhoneLineNumber(getChildNodeValue(structMes, XML_PhoneLineNumber));
									shNo.setPhoneNumber(mesPhone);
								}
							}
							snVect.addElement(shNo);
						  }
						}
						sso.setShipmentNotification(snVect);
						// set boolean satDel
						org.w3c.dom.Node satDel = getChildNode(shipServ, XML_SaturdayDelivery);
						if (satDel != null)
						{
							sso.setSaturdayDelivery(true);
						}
						// set boolean satPick
						org.w3c.dom.Node satPick = getChildNode(shipServ, XML_SaturdayPickup);
						if (satPick != null)
						{
							sso.setSaturdayPickup(true);
						}
						// set ship serv object to shipment object
						ship.setShipmentServiceOptions(sso);
					}
					// add the shipment to the shipment vector
					shipVect.addElement(ship);
				}
			}
			//add the vector to the bean
			tr.setShipments(shipVect);
		}
		return tr;
	} catch (SAXException se)
	{
		System.out.println("SAX Exception occured in parseDocument");
		throw new Exception("SAXException occured building objects: " + se.getMessage());
	} catch (Exception e)
	{
		System.out.println("Exception occured : " + e.getMessage());
		throw new Exception("General Exception Occured " + e.getMessage());
	}
}
/**
 * This method will populate an instance of com.ups.xml.xpci.Package.
 *
 * @param org.w3c.dom.Node, com.ups.xml.xpci.Package
 */
private void buildPackage(org.w3c.dom.Node packNode,Package newPack) throws Exception
{
	// Void
	org.w3c.dom.Node vod = getChildNode(packNode, XML_Void);
	if (vod != null)
		newPack.set_void(true);

	// Activity
	java.util.Vector acVec = new java.util.Vector();
	org.w3c.dom.Node ac = null;
	for (ac = getChildNode(packNode, XML_Activity); ac != null; ac = ac.getNextSibling())
	{
		if ((ac.getNodeName().equals(XML_Activity)))
		{
			Activity act = new Activity();
			org.w3c.dom.Node actLoc = getChildNode(ac, XML_ActivityLocation);
			if (actLoc != null)
			{
				act.setActivityLocationAddress(buildAddress(actLoc));
			}
			act.setActivityLocationCode(getChildNodeValue(actLoc, XML_Code));
			act.setActivityLocationDesc(getChildNodeValue(actLoc, XML_Description));
			act.setActivityLocationSignedFor(getChildNodeValue(actLoc, XML_SignedForByName));
			org.w3c.dom.Node sig = getChildNode(actLoc, XML_SignatureImage);
			if (sig != null)
			{
				Image im = new Image();
				im.setGraphicImage(getChildNodeValue(sig, XML_GraphicImage));
				org.w3c.dom.Node imageForm = getChildNode(sig, XML_ImageFormat);
				if (imageForm != null)
				{
					im.setImageFormatCode(getChildNodeValue(imageForm, XML_Code));
					im.setImageFormatDesc(getChildNodeValue(imageForm, XML_Description));
				}
				act.setSignatureImage(im);
			}
			act.setActivityDate(getChildNodeValue(ac, XML_Date));
			act.setActivityTime(getChildNodeValue(ac, XML_Time));
			org.w3c.dom.Node status = getChildNode(ac, XML_Status);
			if (status != null)
			{
				org.w3c.dom.Node statusCode = getChildNode(status, XML_StatusCode);
				if (statusCode != null)
				{
					act.setStatusCodeCode(getChildNodeValue(statusCode, XML_Code));
					act.setStatusCodeDesc(getChildNodeValue(statusCode, XML_Description));
				}
				org.w3c.dom.Node statusType = getChildNode(status, XML_StatusType);
				if (statusType != null)
				{
					act.setStatusTypeCode(getChildNodeValue(statusType, XML_Code));
					act.setStatusTypeDesc(getChildNodeValue(statusType, XML_Description));
				}
			}
			if (act != null)
				acVec.addElement(act);
		}
	}
	newPack.setActivity(acVec);

	// Additional Handling
	org.w3c.dom.Node ah = getChildNode(packNode, XML_AdditionalHandling);
	if (ah != null)
		newPack.setAdditionalHandling(true);
	// Description
	newPack.setDescription(getChildNodeValue(packNode, XML_Description));
	// Dimensional Weight
	org.w3c.dom.Node dimW = getChildNode(packNode, XML_DimensionalWeight);
	if (dimW != null)
	{
		newPack.setDimensionalWeight(getChildNodeValue(dimW, XML_Weight));
		org.w3c.dom.Node dimWU = getChildNode(dimW, XML_UnitOfMeasurement);
		if (dimWU != null)
		{
			newPack.setDimensionalWeightUOMCode(getChildNodeValue(dimWU, XML_Code));
			newPack.setDimensionalWeightUOMDesc(getChildNodeValue(dimWU, XML_Description));
		}
	}
	// dimensions
	org.w3c.dom.Node dim = getChildNode(packNode, XML_Dimensions);
	if (dim != null)
	{
		org.w3c.dom.Node dimU = getChildNode(dim, XML_UnitOfMeasurement);
		if (dimU != null)
		{
			newPack.setDimensionsUOMCode(getChildNodeValue(dimU, XML_Code));
			newPack.setDimensionsUOMDesc(getChildNodeValue(dimU, XML_Description));
		}
		newPack.setHeight(getChildNodeValue(dim, XML_Height));
		newPack.setLength(getChildNodeValue(dim, XML_Length));
		newPack.setWidth(getChildNodeValue(dim, XML_Width));
	}
	// oversize
	newPack.setOversizePackage(getChildNodeValue(packNode, XML_OversizePackage));
	// package service options
	PackageServiceOptions pso = new PackageServiceOptions();
	org.w3c.dom.Node packSO = getChildNode(packNode, XML_PackageServiceOptions);
	if (packSO != null)
	{
		org.w3c.dom.Node cod = getChildNode(packSO, XML_COD);
		if (cod != null)
		{
			org.w3c.dom.Node amCode = getChildNode(cod, XML_CODAmount);
			if (amCode != null)
			{
				pso.setCODAmountCode(getChildNodeValue(amCode, XML_CurrencyCode));
				pso.setCODAmountValue(getChildNodeValue(amCode, XML_MonetaryValue));
			}
			pso.setCODCode(getChildNodeValue(cod, XML_CODCode));
			pso.setCODControlNumber(getChildNodeValue(cod, XML_ControlNumber));
			pso.setCODFundsCode(getChildNodeValue(cod, XML_CODFundsCode));
		}
		org.w3c.dom.Node dc = getChildNode(packSO, XML_DeliveryConfirmation);
		if (dc != null)
		{
			pso.setDeliveryConfirmationNumber(getChildNodeValue(dc, XML_DCISNumber));
			pso.setDeliveryConfirmationType(getChildNodeValue(dc, XML_DCISType));
		}
		pso.setEarliestDeliveryTime(getChildNodeValue(packSO, XML_EarliestDeliveryTime));
		pso.setHazardousMaterialCode(getChildNodeValue(packSO, XML_HazardousMaterialsCode));
		org.w3c.dom.Node hfp = getChildNode(packSO, XML_HoldForPickup);
		if (hfp != null)
			pso.setHoldForPickup(true);
		org.w3c.dom.Node iv = getChildNode(packSO, XML_InsuredValue);
		if (iv != null)
		{
			pso.setInsuredValue(getChildNodeValue(iv, XML_MonetaryValue));
			pso.setInsuredValueCode(getChildNodeValue(iv, XML_CurrencyCode));
		}
		java.util.Vector snVec = new java.util.Vector();
		org.w3c.dom.Node shipNot = null;
		for (shipNot = getChildNode(packSO, XML_ShipmentNotification); shipNot != null; shipNot = shipNot.getNextSibling())
		{
			ShipmentNotification shNo = new ShipmentNotification();
			shNo.setCompanyName(getChildNodeValue(shipNot, XML_CompanyName));
			shNo.setEmailAddress(getChildNodeValue(shipNot, XML_EmailAddress));
			org.w3c.dom.Node faxDestination = getChildNode(shipNot, XML_FaxDestination);
			if (faxDestination != null)
			{
				shNo.setFaxDestinationIndicator(getChildNodeValue(faxDestination, XML_FaxDestinationIndicator));
				shNo.setFaxDestinationNumber(getChildNodeValue(faxDestination, XML_FaxNumber));
			}
			shNo.setMemo(getChildNodeValue(shipNot, XML_Memo));
			shNo.setNotificationCode(getChildNodeValue(shipNot, XML_NotificationCode));
			// set email message
			EmailMessage emailM = new EmailMessage();
			org.w3c.dom.Node emailMessage = getChildNode(shipNot, XML_EmailMessage);
			if (emailMessage != null)
			{
				org.w3c.dom.Node emailAddress = null;
				String[] email = null;
				int i = 0;
				for (emailAddress = getChildNode(emailMessage, XML_EmailAddress);(i < 3 & emailAddress != null); emailAddress = emailAddress.getNextSibling())
				{
					email[i] = getNodeValue(emailAddress);
					i++;
				}
				emailM.setMemo(getChildNodeValue(emailMessage, XML_Memo));
				java.util.Vector imVec = new java.util.Vector();
				org.w3c.dom.Node image = null;
				for (image = getChildNode(emailMessage, XML_Image); image != null; image = image.getNextSibling())
				{
					Image im = new Image();
					im.setGraphicImage(getChildNodeValue(image, XML_GraphicImage));
					org.w3c.dom.Node imageForm = getChildNode(image, XML_ImageFormat);
					if (imageForm != null)
					{
						im.setImageFormatCode(getChildNodeValue(imageForm, XML_Code));
						im.setImageFormatDesc(getChildNodeValue(imageForm, XML_Description));
					}
					imVec.addElement(im);
				}
				emailM.setImage(imVec);
			}
			shNo.setEmailMessage(emailM);
			// set phone number
			org.w3c.dom.Node snPhone = getChildNode(emailMessage, XML_PhoneNumber);
			if (snPhone != null)
			{
				shNo.setPhoneNumber(buildPhone(snPhone));
			}
			snVec.addElement(shNo);
		}
		pso.setShipmentNotification(snVec);
		org.w3c.dom.Node sr = getChildNode(packSO, XML_SignatureRequired);
		if (sr != null)
			pso.setSignatureRequired(true);
		org.w3c.dom.Node vc = getChildNode(packSO, XML_VerbalConfirmation);
		if (vc != null)
		{
			org.w3c.dom.Node contact = getChildNode(vc, XML_ContactInfo);
			if (contact != null)
			{
				pso.setVerbalContactName(getChildNodeValue(contact, XML_Name));
				org.w3c.dom.Node phoneNum = getChildNode(contact, XML_PhoneNumber);
				if (phoneNum != null)
				{
					pso.setVerbalContactPhone(buildPhone(phoneNum));
				}
			}
		}
	}
	newPack.setPackageServiceOptions(pso);
	// weight
	org.w3c.dom.Node packWeight = getChildNode(packNode, XML_PackageWeight);
	if (packWeight != null)
	{
		newPack.setPackageWeight(getChildNodeValue(packWeight, XML_Weight));
		org.w3c.dom.Node packWU = getChildNode(packWeight, XML_UnitOfMeasurement);
		if (packWU != null)
		{
			newPack.setPackageWeightUOMCode(getChildNodeValue(packWU, XML_Code));
			newPack.setPackageWeightUOMDesc(getChildNodeValue(packWU, XML_Description));
		}
	}
	// package type
	org.w3c.dom.Node type = getChildNode(packNode, XML_PackagingType);
	if (type != null)
	{
		newPack.setPackagingTypeCode(getChildNodeValue(type, XML_Code));
		newPack.setPackagingTypeDesc(getChildNodeValue(type, XML_Description));
	}
	// reference numbers
	java.util.Vector refVec = new java.util.Vector();
	org.w3c.dom.Node ref = null;
	for (ref = getChildNode(packNode, XML_ReferenceNumber); ref != null; ref = ref.getNextSibling())
	{
		if (ref.getNodeType() != org.w3c.dom.Node.TEXT_NODE)
		{
			ReferenceNumber reference = new ReferenceNumber();
			reference.setCode(getChildNodeValue(ref, XML_Code));
			reference.setValue(getChildNodeValue(ref, XML_Description));
			refVec.addElement(reference);
		}
	}
	newPack.setReferenceNumbers(refVec);
	// tracking numbers
	newPack.setTrackingNumber(getChildNodeValue(packNode, XML_TrackingNumber));
}
}
