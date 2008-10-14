Attribute VB_Name = "modSampleCode"

Public Sub Main()

On Error GoTo ErrorHandle
Dim doc As New MSXML2.DOMDocument30
Dim rNode As MSXML2.IXMLDOMElement
Dim doc1 As MSXML2.DOMDocument30
Dim RespFile As String
Dim ReqFile As String
Dim Service As String

'Create the XML document
Set doc = New MSXML2.DOMDocument30
If (createXMLDocument("AccessLicenseAgreementRequest", doc)) Then
   

' ******* Build an Access License Agreement Request *****************

'Adding Nodes to the XML document that was previously created "doc"
    AddNode doc, "AccessLicenseAgreementRequest", "", "", "xml:lang", "en-US"
    AddNode doc, "AccessLicenseAgreementRequest", "Request", "EMPTY_NODE", "", ""
    AddNode doc, "AccessLicenseAgreementRequest", "AccessLicenseNumber", "8B505CD8A2612824", "", ""
    AddNode doc, "AccessLicenseAgreementRequest", "AccessLicenseProfile", "EMPTY_NODE", "", ""
    AddNode doc, "Request", "TransactionReference", "EMPTY_NODE", "", ""
    AddNode doc, "Request", "RequestAction", "AccessLicense", "", ""
    AddNode doc, "Request", "RequestOption", "AllTools", "", ""
    AddNode doc, "TransactionReference", "CustomerContext", "License Test", "", ""
    AddNode doc, "TransactionReference", "XpicVersion", "1.0", "", ""
    AddNode doc, "AccessLicenseProfile", "CountryCode", "US", "", ""
    AddNode doc, "AccessLicenseProfile", "LanguageCode", "EN", "", ""

indata = InputBox("Enter the full path and filename of Request to be created." & vbCrLf & vbCrLf & _
    "If the path is not valid no file will be created", "Request File")
If Len(Trim(indata)) <> 0 Then
    ReqFile = indata
    doc.save (ReqFile)
    MsgBox "Finish, see " & ReqFile & " for the generated XML Request."
Else
    MsgBox "No demo for you"
End If
End If

Exit Sub
ErrorHandle:
MsgBox "Error running Sample Code"
End Sub
 

Public Function createXMLDocument(rootname As String, xml As MSXML2.DOMDocument30) As Boolean

 On Error GoTo ErrHand
    
    Dim docXML As New MSXML2.DOMDocument30
    Dim parentNode As IXMLDOMNode
    Dim root  As IXMLDOMElement
    Dim Prop As MSXML2.IXMLDOMProcessingInstruction
    
    docXML.async = False
    Set root = docXML.createElement(rootname)
    docXML.loadXML root.xml
    Set parentNode = root
    
    Set Prop = docXML.createProcessingInstruction("xml", "version = '1.0'")
    docXML.loadXML (Prop.xml & root.xml)
    
    Set xml = docXML
    createXMLDocument = True
    Exit Function
    
ErrHand:
Debug.Print "Error creating Document (" & rootname & ")"
createXMLDocument = False
Debug.Print Err.Description
End Function

Public Function AddNode(doc As MSXML2.DOMDocument30, strParentTag As String, newTagName As String, _
        textString As String, attrName As String, AttrValue As String)

    On Error GoTo ErrHand
    Dim Item As MSXML2.IXMLDOMElement
    Dim root As MSXML2.IXMLDOMElement
    Dim oAttr As MSXML2.IXMLDOMAttribute
    Dim parentTag As MSXML2.IXMLDOMNode
    Dim Node As MSXML2.IXMLDOMNode
    Dim pNode As MSXML2.IXMLDOMNode
    Dim child As MSXML2.IXMLDOMNode
    Dim ThisNode As MSXML2.IXMLDOMText
    AddNode = True
    ' we are getting a nodelist because it allows us to specify the parent element
    ' by its string name; that way, we don't have to pass Elements around
    Dim N1 As MSXML2.IXMLDOMNodeList
   Set parentTag = doc
   Set N1 = doc.getElementsByTagName(strParentTag)
   If N1.length > 0 Then
       Set Parent = N1.Item(N1.length - 1)
    Else
        Set Parent = parentTag
    End If
        If Not (StrComp(textString, "") = 0) Then
            
                Set Node = doc.createNode(NODE_ELEMENT, newTagName, "")
                If Not (StrComp(textString, "EMPTY_NODE") = 0) Then
                    Node.nodeTypedValue = textString
                End If
                Parent.appendChild Node
               
                AddNode = True
       
         Else
                If Not (((StrComp(attrName, "") = 0) Or (StrComp(AttrValue, "") = 0))) Then
                Set oAttr = doc.createAttribute(attrName)
                Parent.setAttribute attrName, AttrValue
               
                AddNode = True
                Else
                AddNode = False
                End If
        End If
        Exit Function
ErrHand:
        AddNode = False
Debug.Print "Error Addong Node (" & ErrObject & ")"
Debug.Print Err.Description
End Function


Public Function FillXML(xnodes() As String, strXML As String) As String
'This method requires that the array size be greater than or equal to the amount
'of "writable" nodes in the XML document. Also, the order of the values in the
'array should sync up with the order of their respective "writable" nodes in the 'XML document.
On Error GoTo ErrFill

Dim I As Integer
Dim str As String
Dim objXMl As DOMDocument30
Dim objXMLList As IXMLDOMNodeList

Set objXMl = New DOMDocument30
objXMl.loadXML strXML

Set objXMLList = objXMl.getElementsByTagName("*")
t = 0
MaxNodes = objXMl.getElementsByTagName("*").length

For I = 0 To MaxNodes - 1
'Here we make a list of child nodes for every element in the list.
Set ElementList = objXMLList.Item(I).childNodes
'If there is only one child in the list then we write the value in the array to that node.
If ElementList.length = 1 Then
objXMl.getElementsByTagName("*").Item(I).Text = xnodes(t)
t = t + 1
End If
Next I
FillXML = True
strXML = objXMl.xml
Exit Function

ErrFill:
FillXML = False
End Function

Public Function PostXML(sBuffer As String, strUrl As String, Optional sResponse As String) As String

Dim iRetVal     As Integer

Dim lBufferLen  As Long
Dim vDllVersion As tWinInetDLLVersion
Dim sStatus     As String
Dim sOptionBuffer   As String
Dim lOptionBufferLen As Long
Dim lblMajor As String
Dim lblMinor As String
Dim dwTimeOut As Long
Dim bDoLoop             As Boolean
Dim sReadBuffer         As String * 2048
Dim lNumberOfBytesRead  As Long
Dim sResponseBuffer             As String
'***************************************************
Const username As String = "demo22"
Const password As String = "demo22"
'Normally you would take the strUrl parameter and parse it but for example purposes we are using constants.
Const URL As String = "ups.com"
Const URLObject As String = "/ups.app/xml/Track" ' This portion of the URL will not always have 'Track' in it. The last word will change base on the tool you are using.
'***************************************************

'Set the Time out value for the INTERNET_OPTION_CONNECT_TIMEOUT, INTERNET_OPTION_RECEIVE_TIMEOUT,INTERNET_OPTION_SEND_TIMEOUT
dwTimeOut = 60000

If Len(Trim(strUrl)) <> 0 Then mvtxtUrl = strUrl

lBufferLen = Len(sBuffer)

hInternetSession = 0
hHttpOpenRequest = 0
hInternetConnect = 0

' Open session
hInternetSession = InternetOpen(scUserAgent, INTERNET_OPEN_TYPE_PRECONFIG, "proxy.ups.com:8080", vbNullString, 0)

If CBool(hInternetSession) Then
    'Set DLL Major/Minor version variables
    InternetQueryOption hInternetSession, INTERNET_OPTION_VERSION, vDllVersion, Len(vDllVersion)
    lblMajor = vDllVersion.lMajorVersion
    lblMinor = vDllVersion.lMinorVersion
    
   'Open Connection
    hInternetConnect = InternetConnect(hInternetSession, URL, INTERNET_DEFAULT_HTTPS_PORT, _
    vbNullString, vbNullString, INTERNET_SERVICE_HTTP, 0, 0)
    
    If hInternetConnect > 0 Then
            sOptionBuffer = sBuffer
          
            lOptionBufferLen = Len(sOptionBuffer)
          
            hHttpOpenRequest = HttpOpenRequest(hInternetConnect, "POST", URLObject, "HTTP/1.0", vbNullString, 0, _
            INTERNET_FLAG_RELOAD Or INTERNET_FLAG_MULTIPART Or INTERNET_FLAG_SECURE Or INTERNET_FLAG_IGNORE_CERT_CN_INVALID Or INTERNET_FLAG_IGNORE_CERT_DATE_INVALID, 0)
   
        If CBool(hHttpOpenRequest) Then
                        
            sHeader = "Content-Length: " & lOptionBufferLen & vbCrLf
            iRetVal = HttpAddRequestHeaders(hHttpOpenRequest, sHeader, Len(sHeader), HTTP_ADDREQ_FLAG_REPLACE Or HTTP_ADDREQ_FLAG_ADD)
            Debug.Print iRetVal & " " & sHeader;
            
            sHeader = "Accept-Language: en" & vbCrLf
            iRetVal = HttpAddRequestHeaders(hHttpOpenRequest, sHeader, Len(sHeader), HTTP_ADDREQ_FLAG_REPLACE Or HTTP_ADDREQ_FLAG_ADD)
            Debug.Print iRetVal & " " & sHeader
                        
            sHeader = "Connection: Keep-Alive" & vbCrLf
            iRetVal = HttpAddRequestHeaders(hHttpOpenRequest, sHeader, Len(sHeader), HTTP_ADDREQ_FLAG_REPLACE Or HTTP_ADDREQ_FLAG_ADD)
            Debug.Print iRetVal & " " & sHeader;
 
            sHeader = "Content-Type: application/x-www-form-urlencoded" & vbCrLf
            iRetVal = HttpAddRequestHeaders(hHttpOpenRequest, sHeader, Len(sHeader), HTTP_ADDREQ_FLAG_REPLACE Or HTTP_ADDREQ_FLAG_ADD)
            Debug.Print iRetVal & " " & sHeader;
        
           iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_PROXY_USERNAME, username, Len(username) + 1)
                Debug.Print "in by proxy usr " & iRetVal
            
            iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_PROXY_PASSWORD, password, Len(password) + 1)
                Debug.Print "in by proxy psw " & iRetVal
           
            iRetVal = InternetSetOption(hHttpOpenRequest, INTERNET_OPTION_CONNECT_TIMEOUT, dwTimeOut, 4)
            Debug.Print iRetVal & " " & Err.LastDllError & " " & "INTERNET_OPTION_CONNECT_TIMEOUT"
            
            iRetVal = InternetSetOption(hHttpOpenRequest, INTERNET_OPTION_RECEIVE_TIMEOUT, dwTimeOut, 4)
            Debug.Print iRetVal & " " & "INTERNET_OPTION_RECEIVE_TIMEOUT"
            
            iRetVal = InternetSetOption(hHttpOpenRequest, INTERNET_OPTION_SEND_TIMEOUT, dwTimeOut, 4)
            Debug.Print iRetVal & " " & "INTERNET_OPTION_SEND_TIMEOUT"
             
            
Resend:
       
            iRetVal = HttpSendRequest(hHttpOpenRequest, vbNullString, 0, sOptionBuffer, lOptionBufferLen)
                
            Dim dwStatus As Long, dwStatusSize As Long
            dwStatusSize = Len(dwStatus)
            HttpQueryInfo hHttpOpenRequest, HTTP_QUERY_FLAG_NUMBER Or HTTP_QUERY_STATUS_CODE, dwStatus, dwStatusSize, 0
            Select Case dwStatus
                Case HTTP_STATUS_PROXY_AUTH_REQ
                'make sure change it to your user name and password.
                'Note Poxy authentication only works for IE40 wininet. For IE3.0x, you need to
                'manually add Proxy-Authentication header.
                'GoTo Resend
              Case HTTP_STATUS_DENIED
                iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_USERNAME, _
        username, Len(username) + 1)
                iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_PASSWORD, _
        password, Len(password) + 1)
            GoTo Resend
           End Select
           
       Else
            ' HttpOpenRequest failed
           sResponse = "HttpOpenRequest call failed; Error code: " & Err.LastDllError & "."
           PostXML = False
        End If
    Else
        ' InternetConnect failed
       sResponse = "InternetConnect call failed; Error code: " & Err.LastDllError & "."
        PostXML = False
    End If
Else
    ' hInternetSession handle not allocated
    sResponse = "InternetOpen call failed: Error code: " & Err.LastDllError & "."
    PostXML = False
End If

'This code will capture the response from the server and passes it back out through the sResponse variable
On Error GoTo ErrHand

bDoLoop = True

While bDoLoop
    sReadBuffer = vbNullString
    bDoLoop = InternetReadFile(hHttpOpenRequest, sReadBuffer, Len(sReadBuffer), TotalBytesRead)
    sResponseBuffer = sResponseBuffer & Left$(sReadBuffer, TotalBytesRead)
    If Not CBool(TotalBytesRead) Then bDoLoop = False
    Debug.Print sReadBuffer
Wend
sResponse = sResponseBuffer
PostXML = True
Exit Function

ErrHand:
sResponse = "There was a problem processing the XML response."
PostXML = False
 
End Function

Public Sub DecodeLabels(strXML As String)
On Error Resume Next
    
    Dim xnodelist As IXMLDOMNodeList
    Dim TrackNum As String
    Dim xnode As IXMLDOMNode
    Dim xdoc As DOMDocument30
    Dim ynode As IXMLDOMNode
    Dim objNode As IXMLDOMNode
    Dim xElement As IXMLDOMElement
    Dim I As Long
    Dim xmlDoc As New MSXML2.DOMDocument30
    Dim xmlDocTest As New MSXML2.DOMDocument30
    Dim childNode As IXMLDOMText
    Dim btArr() As Byte
    
    Debug.Print "Decode Label"
    Set xdoc = New DOMDocument30
    xdoc.loadXML strXML
    
    'Set xnode = xdoc.selectSingleNode("ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/GraphicImage")
    Set xnodelist = xdoc.getElementsByTagName("*")
    
    Set xnode = xnodelist.nextNode
    
  For Each xnode In xnodelist
    Select Case xnode.nodeName
    
        Case "GraphicImage"
                    
                    Set xmlDoc.documentElement = xmlDoc.createElement("Label")
                    Set childNode = xmlDoc.createNode(NODE_TEXT, "", "")
                    xmlDoc.documentElement.appendChild childNode
                    xmlDoc.documentElement.dataType = "bin.base64"
                    childNode.nodeTypedValue = xnode.Text
                    xmlDocTest.async = False
                    xmlDocTest.Load xmlDoc
                    Debug.Print xmlDoc.xml
                    Set ynode = xmlDocTest.selectSingleNode("Label")
                    
                    btArr = ynode.nodeTypedValue
                    Debug.Print btArr
                    strFile = "d:\ShippingTests\Label" & TrackNum & ".gif"
                    Open strFile For Binary As #1
                    Put #1, 1, btArr
                    Close #1
        Case "HTMLImage"
                
                Set xmlDoc.documentElement = xmlDoc.createElement("HTML")
                Set childNode = xmlDoc.createNode(NODE_TEXT, "", "")
                xmlDoc.documentElement.appendChild childNode
                xmlDoc.documentElement.dataType = "bin.base64"
                childNode.nodeTypedValue = xnode.Text
                xmlDocTest.async = False
                xmlDocTest.Load xmlDoc
                Debug.Print xmlDoc.xml
                Set ynode = xmlDocTest.selectSingleNode("HTML")
                
                btArr = ynode.nodeTypedValue
                Debug.Print btArr
                strFile = "d:\ShippingTests\" & TrackNum & ".html"
                Open strFile For Binary As #2
                Put #2, 1, btArr
            Close #2
        Case "TrackingNumber"
                    TrackNum = xnode.Text
    End Select
  Next
End Sub

