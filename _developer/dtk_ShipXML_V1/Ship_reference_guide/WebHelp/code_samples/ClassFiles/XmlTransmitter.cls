VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "XmlTransmitter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"XmlTransmitter"
' The XmlTransmitter will transmit as HTTP/HTTPS post with the String Buffer provided
' as the data of the post message.  The XmlTranmitter must be constructed with
' a URL or IP address and a protocol to use for transmitting the message.
'
Public proxySet As Boolean
Public pass As String
Public proxyHost_Prop As String
Public proxyport_Prop As String
Private m_hostname As String
Private m_protocol As String
Private m_prefix As String
Private m_proxyHost As String
Private m_proxyport As String
Private m_keyLocation As String
Private m_XmlIn As String
Private m_XmlOut As String
Private m_username As String
Private m_password As String
Private m_service As String
Private m_encodedPass As String
Private m_logger As String
Private CLASS__ As String
Private METHOD_ContactService As String
Private METHOD_readURLConnection As String
Private Status As String
Private AccessRequest As String
Private filenum As Integer
Private HttpURLConnection As Long
Private Connection As Long
Private strRequest As String
Private m_requestFile As String
Private m_responseFile As String
'local variable(s) to hold property value(s)
Public mvarhInternetConnection As Long 'local copy
Public mvarhInternetSession As Long 'local copy
Public mvarhHttpOpenRequest As Long 'local copy

Private Declare Function apiGetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" _
(ByVal AppName As String, _
ByVal KeyName As String, _
ByVal keydefault As String, _
ByVal ReturnString As String, _
ByVal NumBytes As Long, _
ByVal FileName As String) As Long
Public Function GetProfileStuff(AppName As String, KeyName As String, IniLoc As String) As String
Dim ok As Long
Dim ibuf As Long
Dim DefValue As String
Dim Results As String
On Error GoTo GetProfileStuff_Error

'Initialize Variables
ibuf = 255
DefValue = "*** PROBLEM ***" + AppName + " : " + KeyName 'Set error
Results = Space(255)
'Call API to read INI file

ok = apiGetPrivateProfileString(AppName, KeyName, DefValue, Results, ibuf, IniLoc)
 Results = Trim$(Results)
 MsgBox Results
Do While Asc(Right$(Results, 1)) = 0
    Results = Left(Results, Len(Results) - 1)
Loop
GetProfileStuff = Results
Exit Function
GetProfileStuff_Error:
GetProfileStuffError = "** Err: " + str$(Err) + "==>" + Error$

End Function

Public Property Let hHttpOpenRequest(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.hHttpOpenRequest = 5
    mvarhHttpOpenRequest = vData
End Property


Public Property Get hHttpOpenRequest() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.hHttpOpenRequest
    hHttpOpenRequest = mvarhHttpOpenRequest
End Property



Public Property Let hInternetSession(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.hInternetSession = 5
    mvarhInternetSession = vData
End Property


Public Property Get hInternetSession() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.hInternetSession
    hInternetSession = mvarhInternetSession
End Property



Public Property Let hInternetConnection(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.hInternetConnection = 5
    mvarhInternetConnection = vData
End Property


Public Property Get hInternetConnection() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.hInternetConnection
    hInternetConnection = mvarhInternetConnection
End Property

Public Sub XmlTransmitter(Service As String, RequestFile As String, ResponseFile As String)
m_requestFile = RequestFile
 m_responseFile = ResponseFile
 Dim ResultString As String
Dim Config As New MSXML2.DOMDocument
Dim ConfigXMLList As IXMLDOMNodeList

Config.Load ("config.xml")
Set ConfigXMLList = Config.getElementsByTagName("*")
Dim hostname As String
Dim proxy As String
Dim port As String
Dim username As String
Dim password As String
Dim protocol As String

m_hostname = Config.getElementsByTagName("hostname").Item(0).Text
proxy = Config.getElementsByTagName("proxy").Item(0).Text
port = Config.getElementsByTagName("port").Item(0).Text
username = Config.getElementsByTagName("username").Item(0).Text
password = Config.getElementsByTagName("password").Item(0).Text
m_protocol = Config.getElementsByTagName("protocol").Item(0).Text
m_service = Service


Dim compare As Integer
compare = vbTextCompare

If Not IsNull(proxy) And Not IsNull(port) Then
    Dim position As Integer
    Dim dwTimeOut As Long
        
        m_proxyHost = proxy
        m_proxyport = port
        m_username = username
        m_password = password
    If UCase$(m_protocol) = "HTTPS" Then
        'proxy_Prop = "https.proxyHost"
        'port_Prop = "https.proxyport"
        proxySet = True

    Else
        'proxy_Prop = "http.proxyHost"
        'port_Prop = "http.proxyport"
        proxySet = True
        pass = username & ":" & password
        
        Set Encoded = New Base64
        m_encodedPass = "Basic" & Encoded.EncodeStr64(pass)
    End If
End If
End Sub

Sub GetRequestData(newrequestFile As String)
   Set clsXML = New XMLTools
   strRequest = clsXML.GetXML(newrequestFile, Service)
   'rtfRequest.ToolTipText = strRequest
   'Teracking
    Debug.Print strRequest
    Xmlout = strRequest
End Sub
Property Let Service(newservice As String)
    m_service = newservice
End Property
Property Get Service() As String
    Service = m_service
End Property

Property Let RequestFile(newFile As String)
    m_requestFile = newFile
End Property
Property Get RequestFile() As String
    RequestFile = m_requestFile
End Property

Property Let ResponseFile(newFile As String)
    m_responseFile = newFile
End Property
Property Get ResponseFile() As String
    ResponseFile = m_responseFile
End Property

Property Get Xmlout() As String
    Xmlout = m_XmlOut
End Property

Property Let Xmlout(newXml As String)
    m_XmlOut = newXml
End Property
Sub contactService(prefix As String, XmlRequest As XMLTools)
Dim url As String
Debug.Print CLASS__ & METHOD_ContactService & "************************Started" & Service & " "
' + new Date.toString()
position = InStr("https", m_protocol)
'If (position >= 0)Then
'use IBM's SSLight to deal with SSL
 'setHttpsContext(keyLocation, "sslight")
'End If
 'RequestFile = "D:\KEEP_THIS_STUFF\XMLTOOLS_Documentation\xml"
 'requestFile = "C:\"
 GetRequestData (RequestFile)
url = m_hostname & "/" & m_service
'url = m_protocol & "://" & m_hostname & "/" & prefix & "/" & service
'Set XmlRequest = New XmlTools
XmlRequest.SetR_File (ResponseFile)
XmlRequest.btSend m_XmlOut, url, m_username, m_password

Debug.Print CLASS__ & METHOD_ContactService & "Transmission sent to" & url

' + new Date.toString()

End Sub
Sub Main()

 'Debug.Print "Started"
 'Tran.XmlTransmitter "hostname", "protocol", "keyring", "proxy", "port", "username", "password"
 'Tran.contactService "Tracking ,  UPS"
End Sub

