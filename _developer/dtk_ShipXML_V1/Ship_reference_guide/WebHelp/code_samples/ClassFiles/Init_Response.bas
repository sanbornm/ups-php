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
Dim doc1 As MSXML2.DOMDocument30
Dim RespFile As String
Dim ReqFile As String
Dim Service As String
'Create XML Document
Set doc = Tools.docXML
  indata = InputBox("Enter the service for XML Request", "Service")
 Service = indata
 indata = InputBox("Enter the full path and filename of Request to be created", "Request File")
 ReqFile = indata
 Tran.Xmlout = ReqFile

 indata = InputBox("Enter the full path and filename of Response to be created", "Response File")
 RespFile = indata

 Tran.XmlTransmitter Service, ReqFile, RespFile
 Tran.contactService "", Tools
'MsgBox "Finish, see " & ReqFile & " for the generated XML Request."
MsgBox "Finish, see " & RespFile & " for the XML " & Service & " Response."
Exit Sub
ErrorHandle:
MsgBox "Error running Sample Code"
End Sub
