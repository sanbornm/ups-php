VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "XMLTools"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Private NumberofWritableNodes As Integer
Private MaxNodes As Integer
Dim NodeNames() As String
Private mvstrSaveHere As String
Private mvHTTPSecure As Boolean
Private mvtxtUrl As String
Private mvTargetUrl As String
Private hInternetSession As Long
Private hInternetConnect As Long
Private hHttpOpenRequest As Long
Dim TotalBytesRead As Long
Private mvdocXML As MSXML2.DOMDocument30
Private mvroot As MSXML2.IXMLDOMElement
Private mvResponseFile As String
Private mvProcessNode As MSXML2.IXMLDOMProcessingInstruction
Public XML_AccessRequest As String '= "AccessRequest";
Public XML_AccessLicenseNumber As String '= "AccessLicenseNumber";
Public XML_UserId As String  '= "UserId";
Public XML_Password As String '= "Password"


Public Event StatusChange(sValue As String)
Public Event MousePntChange(lStyle As Long)
Public Event GotResponse(sResponse As String)
Private mvMakeAcceptResponseFiles As Boolean
Dim oDomError As CDomFunctions


Public Sub GetResponse()
Dim bDoLoop             As Boolean
Dim sReadBuffer         As String * 2048
Dim lNumberOfBytesRead  As Long
Dim sBuffer             As String
On Error Resume Next
Debug.Print "I'm in"
'btGet.Enabled = False
'Screen.MousePointer = vbHourglass
RaiseEvent MousePntChange(vbHourglass)
'ProgressBar1.Min = 0
'If CBool(Val(lblContentLength)) Then ProgressBar1.Max = Val(lblContentLength)
'ProgressBar1.Value = ProgressBar1.Min
RaiseEvent StatusChange("InternetReadFile")
bDoLoop = True
While bDoLoop
    sReadBuffer = vbNullString
    bDoLoop = InternetReadFile(hHttpOpenRequest, sReadBuffer, Len(sReadBuffer), TotalBytesRead)
    sBuffer = sBuffer & Left$(sReadBuffer, TotalBytesRead)
        If Not CBool(TotalBytesRead) Then bDoLoop = False
    'If CBool(Val(lblContentLength)) Then ProgressBar1.Value = ProgressBar1.Value + lNumberOfBytesRead
    Debug.Print sReadBuffer
Wend
Dim RDoc As New MSXML2.DOMDocument
Dim Bresult As Boolean
Rresult = RDoc.loadXML(sBuffer)
RDoc.save (mvResponseFile)

RaiseEvent StatusChange("Ready")
RaiseEvent MousePntChange(1)
RaiseEvent GotResponse(sBuffer)

'If mvMakeAcceptResponseFiles = True Then
'    DecodeGIF sBuffer, filenum
'    DecodeHTML sBuffer, filenum
'    filenum = filenum + 1
'End If

'Screen.MousePointer = vbDefault
'txthtml.TextRTF = sReadBuffer

'ProgressBar1.Value = 0
End Sub

Public Sub btSend(sBuffer As String, strUrl As String, username As String, password As String)
Dim ErrResp As Boolean
Dim holdstring As String
Dim iRetVal     As Integer

Dim lBufferLen  As Long
Dim vDllVersion As tWinInetDLLVersion
Dim sStatus     As String
Dim sOptionBuffer   As String
Dim lOptionBufferLen As Long
Dim lblMajor As String
Dim lblMinor As String

'Dim lBufferLength As Long
Debug.Print "I'm in"
RaiseEvent MousePntChange(vbHourglass)

hInternetSession = 0
hHttpOpenRequest = 0
hInternetConnect = 0

hInternetSession = InternetOpen(scUserAgent, INTERNET_OPEN_TYPE_PRECONFIG, "proxy.ups.com:8080", vbNullString, 0)
                                            
If CBool(hInternetSession) Then
    Status = "Ready"
Else
    Status = "InternetOpen failed."
End If

If Len(Trim(strUrl)) <> 0 Then mvtxtUrl = strUrl

'Screen.MousePointer = vbHourglass
'btsend.Enabled = True
lBufferLen = Len(sBuffer)
If CBool(hInternetSession) Then
    RaiseEvent StatusChange("InternetQueryOption")
    InternetQueryOption hInternetSession, INTERNET_OPTION_VERSION, vDllVersion, Len(vDllVersion)
    lblMajor = vDllVersion.lMajorVersion
    lblMinor = vDllVersion.lMinorVersion
    RaiseEvent StatusChange("InternetConnect")
    If mvHTTPSecure = False Then
'        hInternetConnect = InternetConnect(hInternetSession, CheckUrl, INTERNET_DEFAULT_HTTP_PORT, _
'                            "antigua", "antigua", INTERNET_SERVICE_HTTP, 0, 0)
        hInternetConnect = InternetConnect(hInternetSession, CheckUrl, INTERNET_DEFAULT_HTTP_PORT, _
                            vbNullString, vbNullString, INTERNET_SERVICE_HTTP, 0, 0)
    Else
'        hInternetConnect = InternetConnect(hInternetSession, CheckUrl, INTERNET_DEFAULT_HTTPS_PORT, _
'                            "antigua", "antigua", INTERNET_SERVICE_HTTP, 0, 0)
        hInternetConnect = InternetConnect(hInternetSession, CheckUrl, INTERNET_DEFAULT_HTTPS_PORT, _
                            username, password, INTERNET_SERVICE_HTTP, 0, 0)
    End If
    If hInternetConnect > 0 Then
       
        
        RaiseEvent StatusChange("HttpOpenRequest")
'        If optGet.Value = True Then
'            sOptionBuffer = vbNullString
'            lOptionBufferLen = 0
'            If optSSL.Value = False Then
'                hHttpOpenRequest = HttpOpenRequest(hInternetConnect, "GET", GetUrlObject, "HTTP/1.0", vbNullString, 0, _
'                INTERNET_FLAG_RELOAD Or INTERNET_FLAG_KEEP_CONNECTION, 0)
'            Else
'                hHttpOpenRequest = HttpOpenRequest(hInternetConnect, "GET", GetUrlObject, "HTTP/1.0", vbNullString, 0, _
'                INTERNET_FLAG_RELOAD Or INTERNET_FLAG_KEEP_CONNECTION Or INTERNET_FLAG_SECURE Or INTERNET_FLAG_IGNORE_CERT_CN_INVALID Or INTERNET_FLAG_IGNORE_CERT_DATE_INVALID, 0)
'            End If
'        Else
            sOptionBuffer = sBuffer
            Debug.Print sOptionBuffer
            lOptionBufferLen = Len(sOptionBuffer)
            If mvHTTPSecure = False Then
                hHttpOpenRequest = HttpOpenRequest(hInternetConnect, "POST", GetUrlObject, "HTTP/1.0", vbNullString, 0, _
                INTERNET_FLAG_RELOAD Or INTERNET_FLAG_MULTIPART, 0)
               
            Else
                hHttpOpenRequest = HttpOpenRequest(hInternetConnect, "POST", GetUrlObject, "HTTP/1.0", vbNullString, 0, _
                INTERNET_FLAG_RELOAD Or INTERNET_FLAG_MULTIPART Or INTERNET_FLAG_SECURE Or INTERNET_FLAG_IGNORE_CERT_CN_INVALID Or INTERNET_FLAG_IGNORE_CERT_DATE_INVALID, 0)
           End If
        'End If

        If CBool(hHttpOpenRequest) Then
        RaiseEvent StatusChange("HttpSendRequest")
            
            Debug.Print sOptionBuffer
            Dim sHeader As String
            
            'sHeader = "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd." & vbCrLf
            'iRetVal = HttpAddRequestHeaders(hHttpOpenRequest, sHeader, Len(sHeader), HTTP_ADDREQ_FLAG_REPLACE Or HTTP_ADDREQ_FLAG_ADD)
            'Debug.Print iRetVal & " " & Len(sHeader)
                        
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
           
           'sHeader = "Content-Type: text/html" & vbCrLf ' "Accept = image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd." & vbCrLf
            'iRetVal = HttpAddRequestHeaders(hHttpOpenRequest, sHeader, Len(sHeader), HTTP_ADDREQ_FLAG_REPLACE Or HTTP_ADDREQ_FLAG_ADD)
            'Debug.Print iRetVal & " " & Len(sHeader)
            
            'sHeader = "Content-Length: " & lOptionBufferLen & vbCrLf & "Content-Type: application/x-www-form-urlencoded" & vbCrLf & vbCrLf & vbCrLf
            
            Debug.Print iRetVal & " " & sHeader;
'Actually only INTERNET_OPTION_RECEIVE_TIMEOUT works. More info see the following KB:
'BUG: InternetSetOption Does Not Set Timeout Values            [axsdk]
'ID: Q176420    CREATED: 06-NOV-1997   MODIFIED: 06-NOV-1997
           Dim dwTimeOut As Long
            dwTimeOut = 60000
            iRetVal = InternetSetOption(hHttpOpenRequest, INTERNET_OPTION_CONNECT_TIMEOUT, _
        dwTimeOut, 4)
            Debug.Print iRetVal & " " & Err.LastDllError & " " & "INTERNET_OPTION_CONNECT_TIMEOUT"
            iRetVal = InternetSetOption(hHttpOpenRequest, INTERNET_OPTION_RECEIVE_TIMEOUT, _
        dwTimeOut, 4)
            Debug.Print iRetVal & " " & "INTERNET_OPTION_RECEIVE_TIMEOUT"
            iRetVal = InternetSetOption(hHttpOpenRequest, INTERNET_OPTION_SEND_TIMEOUT, _
        dwTimeOut, 4)
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
                 iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_PROXY_USERNAME, _
        username, Len(username) + 1)
                Debug.Print "in by proxy usr " & iRetVal
                 iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_PROXY_PASSWORD, _
        password, Len(password) + 1)
                Debug.Print "in by proxy psw " & iRetVal
            GoTo Resend
              Case HTTP_STATUS_DENIED
                iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_USERNAME, _
        username, Len(username) + 1)
                iRetVal = InternetSetOptionStr(hHttpOpenRequest, INTERNET_OPTION_PASSWORD, _
        password, Len(password) + 1)
            GoTo Resend
           End Select
           
            If iRetVal Then
            RaiseEvent StatusChange("HttpQueryInfo")
                sStatus = "Ready"
            Else
                ' HttpSendRequest failed
                 sStatus = "HttpSendRequest call failed; Error code: " & Err.LastDllError & "."
                ErrResp = modWinInet.InternetGetLastResponseInfo(Err.LastDllError, holdstring, 1024)
                Debug.Print holdstring & " S"
                Debug.Print Err.Description
            End If
        Else
            ' HttpOpenRequest failed
           sStatus = "HttpOpenRequest call failed; Error code: " & Err.LastDllError & "."
        End If
    Else
        ' InternetConnect failed
        sStatus = "InternetConnect call failed; Error code: " & Err.LastDllError & "."
    End If
Else
    ' hInternetSession handle not allocated
    sStatus = "InternetOpen call failed: Error code: " & Err.LastDllError & "."
End If
RaiseEvent StatusChange(sStatus)
RaiseEvent MousePntChange(1)
GetResponse
End Sub


Public Function GetXML(strFilePath As String, Optional Service As String, Optional strAppend As String = "") As String

Dim i As Integer
Dim objXMl As DOMDocument30
Dim objXMLList As IXMLDOMNodeList
Dim ElementList As IXMLDOMNodeList


ReDim NodeNames(0)

Set objXMl = New DOMDocument30
Set objXMLList = objXMl.getElementsByTagName("*")

If (UCase$(Service) = "LICENSE") Or (UCase$(Service) = "REGISTER") Then
    objXMl.Load (strFilePath)
Else
    objXMl.Load ("D:\sdk\AccessRequest.xml")
    AccessRequest = objXMl.xml
    Dim Request As String
    objXMl.Load (strFilePath)
    Request = objXMl.xml
End If
Debug.Print objXMl.xml
Debug.Print objXMl.getElementsByTagName("*").length

NumberofWritableNodes = 0
MaxNodes = objXMl.getElementsByTagName("*").length

Debug.Print MaxNodes
Debug.Print objXMLList.length

For i = 0 To MaxNodes - 1
Set ElementList = objXMLList.Item(i).childNodes
If ElementList.length = 1 Then
'ReDim Preserve NodeNames(UBound(NodeNames, 1) + 1)
'NodeNames(NumberofWritableNodes) = objXMLList.Item(i).nodeName
NumberofWritableNodes = NumberofWritableNodes + 1
'Debug.Print NodeNames(NumberofWritableNodes - 1)
End If
Debug.Print objXMLList.Item(i).nodeName
Debug.Print ElementList.length
Next i
'Debug.Print NodeNames(2)
Debug.Print NumberofWritableNodes

If (UCase$(Service) = "LICENSE") Then
    GetXML = objXMl.xml
Else
    GetXML = AccessRequest & vbCrLf & objXMl.xml
End If
End Function
Public Function FillXML(xnodes() As String, strXML As String) As String
Dim i As Integer
Dim str As String
Dim objHoldXML As IXMLDOMNodeList
Dim objXMl As DOMDocument30
Dim objXMLList As IXMLDOMNodeList

Set objXMl = New DOMDocument30

objXMl.loadXML strXML

Debug.Print "***********************************************"
Debug.Print NodeNames(0)

Set objXMLList = objXMl.getElementsByTagName("*")

t = 0
MaxNodes = objXMl.getElementsByTagName("*").length

Debug.Print "Max " & MaxNodes
Debug.Print "length of List " & objXMLList.length

For i = 0 To MaxNodes - 1
Set ElementList = objXMLList.Item(i).childNodes
If ElementList.length = 1 Then
    objXMl.getElementsByTagName("*").Item(i).Text = xnodes(t)
    Debug.Print "Text " & objXMl.getElementsByTagName("*").Item(i).Text
    t = t + 1
End If
Debug.Print "Name " & objXMLList.Item(i).nodeName
Debug.Print "Child Node Lenght " & ElementList.length
Next i
'Debug.Print NodeNames(2)
Debug.Print "wirteable nodes" & t

'SaveXML objXML.xml, mvstrSaveHere
'Debug.Print DisplayXML(objXMl.xml)
'FillXML = DisplayXML(objXML.xml)

End Function
Private Function GetUrlObject() As String
If InStr(txtUrl, "/") <> 0 Then
GetUrlObject = Right(txtUrl, Len(txtUrl) - InStr(txtUrl, "/") + 1)
Else
GetUrlObject = ""
End If
Debug.Print GetUrlObject
End Function
Private Function CheckUrl() As String
'If Len(txtUrl) = 0 Then txtUrl = mvTargetUrl ' "oltcertification.ams1907.com/ups.app/xml/Track"
Dim posSlash As Long
posSlash = InStr(mvtxtUrl, "/")
If InStr(mvtxtUrl, "/") <> 0 Then
CheckUrl = Left(mvtxtUrl, InStr(mvtxtUrl, "/") - 1)
Else
CheckUrl = mvtxtUrl
End If
Debug.Print mvtxtUrl
End Function
Private Function GetQueryInfo(ByVal hHttpRequest As Long, ByVal lblContentType As Object, ByVal iInfoLevel As Long) As Boolean
Dim sBuffer         As String * 1024
Dim lBufferLength   As Long
lBufferLength = Len(sBuffer)
GetQueryInfo = CBool(HttpQueryInfo(hHttpRequest, iInfoLevel, ByVal sBuffer, lBufferLength, 0))
lblContentType = sBuffer
Debug.Print sBuffer & " pp"
End Function

Private Sub optSSL_Click()
If optSSL.Value = True Then
 optSSL.Value = False
Else
    optSSL.Value = True
End If
End Sub

Public Property Get ISession() As Long
ISession = hInternetSession
End Property

Public Property Let ISession(ByVal vNewValue As Long)
hInternetSession = vNewValue
End Property

Public Property Get IConnect() As Long
IConnect = hInternetConnect
End Property

Public Property Let IConnect(ByVal vNewValue As Long)
hInternetConnect = vNewValue
End Property

Public Property Get IRequest() As Long
IRequest = hHttpOpenRequest
End Property

Public Property Let IRequest(ByVal vNewValue As Long)
hHttpOpenRequest = vNewValue
End Property
Public Sub Cleanup()
On Error Resume Next
InternetCloseHandle (hHttpOpenRequest)
InternetCloseHandle (hInternetConnect)
InternetCloseHandle (hInternetSession)
End Sub

Public Property Get HTTPSecure() As Boolean
HTTPSecure = mvHTTPSecure
End Property

Public Property Let HTTPSecure(ByVal vNewValue As Boolean)
mvHTTPSecure = vNewValue
End Property

Public Property Get txtUrl() As String
txtUrl = mvtxtUrl
End Property

Public Property Let txtUrl(ByVal vNewValue As String)
mvtxtUrl = vNewValue
End Property

Public Function LoadBoxes(strX As String, Node() As String)
Dim i As Integer
Dim str As String
Dim objHoldXML As IXMLDOMNodeList
Dim objXMl As DOMDocument30
Dim objXMLList As IXMLDOMNodeList


Set objXMl = New DOMDocument30

objXMl.Load (strX)

ReDim Node(0)
Debug.Print objXMl.xml
Debug.Print "***********************************************"
Debug.Print Node(0)

Set objXMLList = objXMl.getElementsByTagName("*")

t = 0
MaxNodes = objXMl.getElementsByTagName("*").length


Debug.Print "length of List " & objXMLList.length

For i = 0 To MaxNodes - 1
Set ElementList = objXMLList.Item(i).childNodes
If ElementList.length = 1 Then
    ReDim Preserve Node(UBound(Node) + 1)
    t = t + 1
    Node(t - 1) = objXMl.getElementsByTagName("*").Item(i).nodeName
    Debug.Print "Text " & objXMl.getElementsByTagName("*").Item(i).Text
    Debug.Print Node(t - 1)
    Debug.Print objXMl.getElementsByTagName("*").Item(i).nodeName
End If
Debug.Print "Name " & objXMLList.Item(i).nodeName
Debug.Print "Child Node Lenght " & ElementList.length
Next i
'Debug.Print NodeNames(2)
Debug.Print "wirteable nodes" & t
LoadBoxes = t

End Function
Public Sub DecodeGIF(strXML As String, index As Integer)
    Dim xnode As IXMLDOMNode
    Dim xdoc As DOMDocument30
    Dim ynode As IXMLDOMNode
    Set xdoc = New DOMDocument
    
    xdoc.loadXML strXML
    
    Set xnode = xdoc.selectSingleNode("ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/GraphicImage")
    
    Dim xmlDoc As New MSXML2.DOMDocument30
    Dim xmlDocTest As New MSXML2.DOMDocument30
    Dim childnode As IXMLDOMText
    Set xmlDoc.documentElement = xmlDoc.createElement("Label")
    Set childnode = xmlDoc.createNode(NODE_TEXT, "", "")
    xmlDoc.documentElement.appendChild childnode
    xmlDoc.documentElement.dataType = "bin.base64"
    childnode.nodeTypedValue = xnode.Text
    xmlDocTest.async = False
    xmlDocTest.Load xmlDoc
    Debug.Print xmlDoc.xml
    Set ynode = xmlDocTest.selectSingleNode("Label")

    Set xnode = xdoc.selectSingleNode("ShipmentAcceptResponse/ShipmentResults/PackageResults/TrackingNumber")
    
    Dim btArr() As Byte
    btArr = ynode.nodeTypedValue
    
    strFile = "d:\ShippingTests\Label" & xnode.Text & "_" & index & ".gif"
    Open strFile For Binary As #1
    Put #1, 1, btArr
    Close #1

End Sub

Public Sub DecodeHTML(strXML As String, index As Integer)
    Dim xnode As IXMLDOMNode
    Dim xdoc As DOMDocument30
    Dim ynode As IXMLDOMNode
    Set xdoc = New DOMDocument
    
    xdoc.loadXML strXML
    
    Set xnode = xdoc.selectSingleNode("ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/HTMLImage")
    
    Dim xmlDoc As New MSXML2.DOMDocument30
    Dim xmlDocTest As New MSXML2.DOMDocument30
    Dim childnode As IXMLDOMText
    Set xmlDoc.documentElement = xmlDoc.createElement("HTML")
    Set childnode = xmlDoc.createNode(NODE_TEXT, "", "")
    xmlDoc.documentElement.appendChild childnode
    xmlDoc.documentElement.dataType = "bin.base64"
    childnode.nodeTypedValue = xnode.Text
    xmlDocTest.async = False
    xmlDocTest.Load xmlDoc
    Debug.Print xmlDoc.xml
    Set ynode = xmlDocTest.selectSingleNode("HTML")

    Set xnode = xdoc.selectSingleNode("ShipmentAcceptResponse/ShipmentResults/PackageResults/TrackingNumber")
    
    Dim btArr() As Byte
    btArr = ynode.nodeTypedValue
    Debug.Print btArr
    strFile = "d:\ShippingTests\" & xnode.Text & "_" & index & ".html"
    Open strFile For Binary As #2
    Put #2, 1, btArr
    Close #2

End Sub

Public Property Get xmlDoc() As MSXML2.DOMDocument30
Set xmlDoc = mvdocXML
End Property

Public Function createXMLDocument(rootname As String) As Boolean
    On Error GoTo ErrHand
    Dim docXML As New MSXML2.DOMDocument30
    Set mvdocXML = New MSXML2.DOMDocument30
    Dim parentNode As IXMLDOMNode
    Dim root  As IXMLDOMElement
    docXML.async = False
    'Set elementnode = mvDocXML.createElement(rootname)
    Set root = docXML.createElement(rootname)
    docXML.loadXML root.xml
    Set parentNode = root
    Dim Prop As MSXML2.IXMLDOMProcessingInstruction
    Set Prop = docXML.createProcessingInstruction("xml", "version = '1.0'")
    docXML.loadXML (Prop.xml & root.xml)
    Set mvProcessNode = Prop
    Set mvroot = root
    Set mvdocXML = docXML
    createXMLDocument = True
    Exit Function
ErrHand: 'Catch
Debug.Print "Error creating Document (" & rootname & ")"
createXMLDocument = False
End Function
Public Function addElement(oDom As MSXML2.DOMDocument30, _
        oPNode As MSXML2.IXMLDOMNode, sElementName As String, _
        sElementContent As String) As Boolean
    On Error GoTo ErrHand
    Dim oNode As MSXML2.IXMLDOMNode
    Dim elNode As MSXML2.IXMLDOMText
    Dim Result As Boolean
    'Dim DomError As CDomFunctions
    'Set DomError = New CDomFunctions
    Call oDomError.ClearErrorInfo

    Select Case oPNode.nodeType
    Case NODE_DOCUMENT_FRAGRAMENT, NODE_DOCUMENT_FRAGRAMENT, NODE_ENTITY_REFERENCE, _
                NODE_ELEMENT:
            Set elNode = oDom.createTextNode(sElementName)
            Set oNode = oPNode.appendChild(elNode)
            If (Len(sElementContent)) Then
              oNode.Text = sElementContent
            End If
            Bresult = True
    Case Else
            Bresult = False
            Call oDomError.SetErrorInfo(-1, "Invalid parent node type.", _
                 "CDomFuntions.AddTestNode", HIERARCHY_REQUEST_ERR)
End Select
Exit Function
ErrHand:
If Err.Number <> 0 Then
Bresult = False
Call oDomError.SetErrorInfo(Err.Number, Err.Description, _
        "CDomFunctions." & Err.Source, UNKNOWN)
End If
addElement = Bresult
End Function
Public Function AddComment(oDom As MSXML2.DOMDocument30, _
        oPNode As MSXML2.IXMLDOMNode, _
        sContent As String) As Boolean
    On Error GoTo ErrHand
    Dim elNode As MSXML2.IXMLDOMComment
    Dim Result As Boolean
    
    Call oDomError.ClearErrorInfo

    Select Case oPNode.nodeType
    Case NODE_DOCUMENT_FRAGRAMENT, NODE_DOCUMENT_FRAGRAMENT, NODE_ENTITY_REFERENCE, _
                NODE_ELEMENT:
            Set elNode = oDom.createComment(sContent)
            Set oNode = oPNode.appendChild(elNode)
            Bresult = True
    Case Else
            Bresult = False
            Call oDomError.SetErrorInfo(-1, "Invalid parent node type.", _
                 "CDomFuntions.AddComment", HIERARCHY_REQUEST_ERR)
End Select
Exit Function
ErrHand:
If Err.Number <> 0 Then
Bresult = False
Call oDomError.SetErrorInfo(Err.Number, Err.Description, _
        "CDomFunctions." & Err.Source, UNKNOWN)
End If
AddComent = Bresult
End Function



Public Function AddTextNode(oDom As MSXML2.DOMDocument30, _
oPNode As MSXML2.IXMLDOMNode, _
sValue As String) As Boolean
On Error GoTo ErrHand
Dim oNode As MSXML2.IXMLDOMNode
Dim elNode As MSXML2.IXMLDOMText
Dim domErr As DomException
Call oDomError.ClearErrorInfo

Select Case oPNode.nodeType
Case NODE_ATTRIBUTE, NODE_DOCUMENT_FRAGRAMENT, NODE_ENTITY_REFERENCE, _
                NODE_ELEMENT:
            Set elNode = oDom.createTextNode(sValue)
            Set oNode = oPNode.appendChild(elNode)
            AddTextNode = True
Case Else
            AddTextNode = False
            Call oDomError.SetErrorInfo(-1, "Invalid parent node type.", _
                 "CDomFuntions.AddTestNode", HIERARCHY_REQUEST_ERR)
End Select
Exit Function
ErrHand:
If Err.Number <> 0 Then
AddTextNode = False
Call oDomError.SetErrorInfo(Err.Number, Err.Description, _
        "CDomFunctions." & Err.Source, UNKNOWN)
End If

End Function


Public Function AddAttribute(oDom As MSXML2.DOMDocument30, _
oElement As MSXML2.IXMLDOMElement, _
sName As String, _
sValue As String, _
Optional bReplace As Boolean = False) As Boolean


On Error GoTo ErrHand
Dim oArrt As MSXML2.IXMLDOMAttribute

Call oDomError.ClearErrorInfo

If (Not oElement.Attributes.getNamedItem(sName) Is Nothing) Then
    If bReplace = False Then
       AddAttribe = False
       Exit Function
    End If
End If
Set oAttr = oDom.createAttribute(sName)

oElement.setAttribute sName, sValue
AddAttribute = True
Exit Function

ErrHand:
If Err.Number <> 0 Then
    Call oDomError.SetErrorInfo(Err.Number, Err.Description, _
        "CDomFunctions." & Err.Source, UNKNOWN)
AddAttribute = False
End If
End Function


Public Function AddANode(oDom As MSXML2.DOMDocument30, _
    nNodeType As MSXML2.DOMNodeType, _
    sParentNodeName As String, _
    sNodeName As String, _
    sNodeContent As String) As Boolean


Dim oAtrr As MSXML2.IXMLDOMAttribute
Dim oNode As MSXML2.IXMLDOMNode
Bresult = True
Set oNode = oDom.nodeFromID(sParentNodeName)
'If (IsNodeIndexOK(oDom, nIndex)) Then
'    Set oNode = oDom.selectNodes("//").Item(nIndex)

'Set oAttr = oDom.createAttribute(sNodeName)


Select Case nNodeType

    Case NODE_ELEMENT
        If Not addElement(oDom, oNode, sNodeName, sNodeContent) Then
            Bresult = False
        End If
    Case NODE_ATTRIBUTE
        If Not AddAttribute(oDom, oNode, sNodeName, sNodeContent) Then
            Bresult = False
        End If
    Case NODE_TEXT
        If Not AddTextNode(oDom, oNode, sNodeContent) Then
            Bresult = False
        End If
    Case NODE_COMMENT
        If Not AddComment(oDom, oNode, sNodeContent) Then
            Bresult = False
        End If
    Case Else
        Call oDomError.SetErrorInfo(-1, "Unknown parent node type", _
            "CDomFunctions.AddNode", NOT_SUPPORTED_ERR)
    End Select
 '   Else
 '   bResult = False
 '   Call CDomFunctions.SetErrorInfo(-1, "Unknown parent node type", _
            "CDomFunctions.AddNode", NOT_SUPPORTED_ERR)
    
'End If
AddANode = Bresult

End Function

Public Function IsNodeIndexOK(oDom As MSXML2.DOMDocument30, nIndex As Integer) As Boolean
If nIndex < 0 Then
    IsNodeIndexOK = False
ElseIf nIndexOK > (oDom.selectNodes("//").length - 1) Then
    IsNodeIndexOK = False
Else
    IsNodeIndexOK = True
End If
End Function



'Function Sample_adaptFromObject(acc As Access_) As String
'Dim xmlBuf As String
'Dim doc As MSXML2.DOMDocument30
'Dim root As MSXML2.IXMLDOMElement
'Dim elementnode As MSXML2.IXMLDOMElement
'Dim childnode As MSXML2.IXMLDOMNode
'Dim attrNode As MSXML2.IXMLDOMAttribute
'doc = createXMLDocument(XML_AccessRequest)
'Set attrNode = doc.createAttribute("xml_lang")
'root = doc.documentElement
'root.setAttribute Xml_Lang, "US en"
'Dim Bresult As Boolean
'Bresult = AddANode(doc, NODE_ELEMENT, XML_AccessRequest, XML_AccessLicenseNumber, acc.LicenseNumber())

'Bresult = AddANode(doc, NODE_ELEMENT, XML_AccessRequest, XML_UserId, acc.userID)

'Bresult = AddANode(doc, NODE_ELEMENT, XML_AccessRequest, XML_Password, acc.password)
'xmlBuf = doc.Text
'Sample_adaptFromObject = xmlBuf
'End Function
'Function adaptFromObject(xmlIn As String) As String
'Dim xmlBuf As String
'Dim doc As MSXML2.DOMDocument30
'Dim root As MSXML2.IXMLDOMElement
'Dim elementnode As MSXML2.IXMLDOMElement
'Dim childnode As MSXML2.IXMLDOMNode
'doc = doc.loadXML(xmlIn)
'root = doc.documentElement
'root = doc.firstChild
'childnode = Nothing
'childnode = childnode.firstChild
'While (childnode Is Not Null)
'    If (childnode.nodeName = XML_Shipment) Then
'        Dim Ship As Shipment
'        Set Ship = New Shipment
'        Ship.Description = childnode.nodeValue(shipmentNode, XML_Desciption)
'        Ship.shipmentID = childnode.nodeValue(shipmentNode, XML_DeliveryZone)
'        Ship.pickupDate = childnode.nodeValue(shipmentNode, XML_PickupDate)
        
'    Else
'        Debug.Print "Failed to create a parser in getDocument"
'    End If
'    childnode = childnode.nextSibling
'Wend
'xmlBuf = doc.Text
'adaptFromObject = xmlBuf
'End Function
Public Property Get R_File() As String
R_File = mvResponseFile
End Property

Public Sub SetR_File(ByVal vNewValue As String)
mvResponseFile = vNewValue
End Sub

Public Property Get MakeAcceptResponseFiles() As Boolean
MakeAcceptResponseFiles = mvMakeAcceptResponseFiles
End Property

Public Property Let MakeAcceptResponseFiles(ByVal vNewValue As Boolean)
mvMakeAcceptResponseFiles = vNewValue
End Property

Public Property Get docXML() As MSXML2.DOMDocument30
Set docXML = mvdocXML
End Property

Public Property Let docXML(NewDoc)
    Set mvdocXML = NewDoc
End Property
Public Property Get rootXML() As MSXML2.IXMLDOMNode
Set rootXML = mvroot
End Property

Public Property Let rootXML(Newroot)
    Set mvroot = Newroot
End Property
Public Property Get ProcessNode() As MSXML2.IXMLDOMProcessingInstruction
Set ProcessNode = mvProcessNode
End Property

Public Property Let ProcessNode(NewPiNode)
    Set mvProcessNode = NewPiNode
End Property

Private Sub Class_Initialize()
XML_AccessRequest = "AccessRequest"
XML_AccessLicenseNumber = "AccessLicenseNumber"
XML_UserId = userID
XML_Password = password

Set oDomError = New CDomFunctions
End Sub


'adds a new element tag with text node date, e.g. <City>Timonium</City>
'if 'str' is null, the element is added as an "empty" element
'e.g. <City/>
Public Sub AddNode(doc As MSXML2.DOMDocument30, _
        strParentTag As String, newTagName As String, _
        textString As String, attrName As String, _
        attrValue As String)
    On Error GoTo ErrHand
    Dim Item As MSXML2.IXMLDOMElement
    Dim root As MSXML2.IXMLDOMElement
    Dim oAttr As MSXML2.IXMLDOMAttribute
    Dim parentTag As MSXML2.IXMLDOMNode
    Dim Node As MSXML2.IXMLDOMNode
    Dim pNode As MSXML2.IXMLDOMNode
    Dim child As MSXML2.IXMLDOMNode
    Dim ThisNode As MSXML2.IXMLDOMText
    Bresult = True
    ' we are getting a nodelist because it allows us to specify the parent element
    ' by its string name; that way, we don't have to pass Elements around
    Dim N1 As MSXML2.IXMLDOMNodeList
   Set parentTag = mvroot
   Set N1 = mvroot.getElementsByTagName(strParentTag)
   If N1.length > 0 Then
       Set Parent = N1.Item(N1.length - 1)
    Else
        Set Parent = parentTag
    End If
        If Not (StrComp(textString, "") = 0) Then
            'we support #RM, which means, 'do not add this node'
            'If (InStr("#RM", textString) And InStr("#rm", textString)) Then
                Set Node = doc.createNode(NODE_ELEMENT, newTagName, "")
                If Not (StrComp(textString, "EMPTY_NODE") = 0) Then
                    Node.nodeTypedValue = textString
                End If
                Parent.appendChild Node
                'MsgBox Parent.xml
                Bresult = True
            '}
         Else
                If Not (((StrComp(attrName, "") = 0) Or (StrComp(attrValue, "") = 0))) Then
                Set oAttr = doc.createAttribute(attrName)
                Parent.setAttribute attrName, attrValue
                'Parent.appendChild Item
                Bresult = True
                Else
                Bresult = False
                End If
        End If
        'addThisNode = Bresult
        Exit Sub
ErrHand:
        Bresult = False
 'addThisNode = Bresult
End Sub

