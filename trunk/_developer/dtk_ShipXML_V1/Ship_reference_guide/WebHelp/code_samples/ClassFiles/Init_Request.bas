Attribute VB_Name = "Init"
Public Status As String
Public hInternetSession As Long
Public hHttpOpenRequest As Long
Public hInternetConnect As Long
Public AccessRequest As String
Public filenum As Integer

Public Sub Main()

On Error GoTo ErrorHandle

Dim Tran As New XmlTransmitter
Debug.Print "Started"
Dim Tools As New XMLTools
Dim doc As MSXML2.DOMDocument30
Dim rNode As MSXML2.IXMLDOMElement
Dim doc1 As MSXML2.DOMDocument30
Dim RespFile As String
Dim ReqFile As String
Dim Service As String
'Create XML Document
If (Tools.createXMLDocument("AccessLicenseAgreementRequest")) Then
   Set doc = Tools.docXML
' ******* Build an Access License Agreement Request *****************
   Tools.AddNode doc, "AccessLicenseAgreementRequest", "Request", "EMPTY_NODE", "", ""
   Tools.AddNode doc, "AccessLicenseAgreementRequest", "Request", "", "xml:lang", "en-US"
   Tools.AddNode doc, "AccessLicenseAgreementRequest", "DeveloperLicenseNumber", "TEST5CD8A2612788", "", ""
   Tools.AddNode doc, "AccessLicenseAgreementRequest", "AccessLicenseProfile", "EMPTY_NODE", "", ""
   Tools.AddNode doc, "Request", "TransactionReference", "EMPTY_NODE", "", ""
   Tools.AddNode doc, "Request", "RequestAction", "AccessLicense", "", ""
   Tools.AddNode doc, "Request", "RequestOption", "AllTools", "", ""
   Tools.AddNode doc, "TransactionReference", "CustomerContest", "License Test", "", ""
   Tools.AddNode doc, "TransactionReference", "XpicVersion", "1.0", "", ""
   Tools.AddNode doc, "AccessLicenseProfile", "CountryCode", "US", "", ""
   Tools.AddNode doc, "AccessLicenseProfile", "LanguageCode", "EN", "", ""

' ******* Build an Access License Request *****************
'If (Tools.createXMLDocument("AccessLicenseRequest")) Then
'   Tools.AddNode doc, "AccessLicenseRequest", "Request", "", "xml:lang", "en-US"
'   Tools.AddNode doc, "AccessLicenseRequest", "Request", "EMPTY_NODE", "", ""
'   Tools.AddNode doc, "AccessLicenseRequest", "CompanyName", "ABC Supply", "", ""
'   Tools.AddNode doc, "AccessLicenseRequest", "Address", "EMPTY_NODE", "", ""
'   Tools.AddNode doc, "Address", "AddressLine1", "100 Main St.", "", ""
'   Tools.AddNode doc, "Address", "City", "Atlanta", "", ""
'   Tools.AddNode doc, "Address", "StateProvinceCode", "GA", "", ""
'   Tools.AddNode doc, "Address", "PostalCode", "30076", "", ""
'   Tools.AddNode doc, "Address", "CountryCode", "US", "", ""
'   Tools.AddNode doc, "AccessLicenseRequest", "PrimaryContact", "EMPTY_NODE", "", ""
'   Tools.AddNode doc, "PrimaryContact", "Name", "John Doe", "", ""
'   Tools.AddNode doc, "PrimaryContact", "Title", "Developer", "", ""
'   Tools.AddNode doc, "PrimaryContact", "EMailAddress", "johndoe@ups.com", "", ""
'   Tools.AddNode doc, "PrimaryContact", "PhoneNumber", "1234567890", "", ""
'   Tools.AddNode doc, "Request", "RequestAction", "AccessLicense", "", ""
'   Tools.AddNode doc, "Request", "RequestOption", "AllTools", "", ""
'   Tools.AddNode doc, "AccessLicenseRequest", "CompanyURL", "www.domain.com", "", ""
'   Tools.AddNode doc, "AccessLicenseRequest", "DeveloperLicenseNumber", "TEST5CD8A2612824", "", ""
'   Tools.AddNode doc, "AccessLicenseRequest", "AccessLicenseProfile", "EMPTY_NODE", "", ""
'   Tools.AddNode doc, "AccessLicenseProfile", "CountryCode", "US", "", ""
'   Tools.AddNode doc, "AccessLicenseProfile", "LanguageCode", "EN", "", ""
'   Tools.AdNode doc, "AccessLicenseProfile", "AccessLicenseText", "Whatever", "", ""
    
 'indata = InputBox("Enter the service for XML Request", "Service")
 'Service = indata
 indata = InputBox("Enter the full path and filename of Request to be created", "Request File")
 ReqFile = indata
 Tran.Xmlout = ReqFile
 Set rNode = Tools.rootXML
 Set PiNode = Tools.ProcessNode
 doc.loadXML (PiNode.xml & rNode.xml)
 doc.save (ReqFile)
 End If
'If (Tools.createXMLDocument("TrackRequest")) Then
'  Set doc = Tools.docXML
'   Tools.addThisNode doc, "TrackRequest", "Request", "EMPTY_NODE", "", "en-US"
'   Tools.addThisNode doc, "Request", "RequestAction", "Track", "", ""
'   Tools.addThisNode doc, "Request", "RequestOption", "activity", "", ""
'   Tools.addThisNode doc, "TrackRequest", "Request", "", "xml:lang", "en-US"
'   Tools.addThisNode doc, "TrackRequest", "TrackingNumber", "1Z12345E1512345676", "", "en-US"
   
 
 '   Set rNode = Tools.rootXML
 '   Set PiNode = Tools.ProcessNode
 '   doc.loadXML (PiNode.xml & rNode.xml)
 '   doc.save ("C:\ARequest.xml")
 '  Tran.Xmlout = doc.Load("C:\ARequest.xml")
'End If
 'indata = InputBox("Enter the full path and filename of Response to be created", "Response File")
 'RespFile = indata
 'RespFile = "C:\Response.xml"
 'ReqFile = "D:\KEEP_THIS_STUFF\XMLTOOLS_Documentation\xml\trackrequest1.xml"
 'ReqFile = "C:\TheRequest.xml"
 'Tran.XmlTransmitter Service, ReqFile, RespFile
 'Tran.contactService "", Tools
'MsgBox "Finish, see " & RespFile & " for the XML " & Service & " Response."
MsgBox "Finish, see " & ReqFile & " for the generated XML Request."
Exit Sub
ErrorHandle:
MsgBox "Error running Sample Code"
End Sub


