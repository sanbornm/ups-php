VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CDomFunctions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
'set this to 0 to disable debug code in this class
#Const DebugMode = 1


#If DebugMode Then
    'local variable to hold the serialized class ID that was created in Class_Initialize
    Private mlClassDebugID As Long
#End If
Public Enum DomException
    NO_ERROR = 0
    INDEX_SIZE_ERR = 1
    DOMSTRING_SIZE_ERR = 2
    HIERARCHY_REQUEST_ERR = 3
    WRONG_DOCUMENT_ERR = 4
    INVALID_CHARACTER_ERR = 5
    NO_DATA_ALLOWED_ERR = 6
    NO_MODIFICATION_ALLOWED_ERR = 7
    NOT_FOUND_ERR = 8
    NOT_SUPPORTED_ERR = 9
    INUSE_ATTRIBUTE_ERR = 10
    UNKNOWN = 99
End Enum
'local variable(s) to hold property value(s)
Private mvarErrorDescription As String 'local copy
Private mvarErrorNumber As Long 'local copy
Private mvarErrorSource As String 'local copy
Private mvarDomError As DomException 'local copy
Public Sub SetErrorInfo(lngErrNum As Long, strErrErrDesc As String, strErrSource As String, domErr As DomException)
    On Error GoTo SetErrorInfoErr

    mvarErrorNumber = lngErrNum
    mvarErrorDescription = strErrDesc
    mvarErrorSource = strErrSource
    mvarDomError = domErr
        
SetErrorInfoErr:
    Call RaiseError(MyUnhandledError, "CDomFunctions:SetErrorInfo Method")
End Sub

Public Sub ClearErrorInfo()
    On Error GoTo ClearErrorInfoErr

    mvarErrorNumber = 0
    mvarErrorDescription = ""
    mvarErrorSource = ""
    mvarDomError = NO_ERROR

    'your code goes here...
    Exit Sub

ClearErrorInfoErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:ClearErrorInfo Method")
End Sub

Public Property Let DomError(ByVal vData As DomException)
    On Error GoTo DomErrorLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.DomError = 5
    mvarDomError = vData
    Exit Property


DomErrorLetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:DomError Property Let")
End Property


Public Property Get DomError() As DomException
    On Error GoTo DomErrorGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.DomError
    Set X.DomError = mvarDomError
    Exit Property


DomErrorGetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:DomError Property Get")
End Property



Public Property Let ErrorSource(ByVal vData As String)
    On Error GoTo ErrorSourceLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ErrorSource = 5
    mvarErrorSource = vData
    Exit Property


ErrorSourceLetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:ErrorSource Property Let")
End Property


Public Property Get ErrorSource() As String
    On Error GoTo ErrorSourceGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ErrorSource
    ErrorSource = mvarErrorSource
    Exit Property


ErrorSourceGetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:ErrorSource Property Get")
End Property



Public Property Let ErrorNumber(ByVal vData As Long)
    On Error GoTo ErrorNumberLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ErrorNumber = 5
    mvarErrorNumber = vData
    Exit Property


ErrorNumberLetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:ErrorNumber Property Let")
End Property


Public Property Get ErrorNumber() As Long
    On Error GoTo ErrorNumberGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ErrorNumber
    ErrorNumber = mvarErrorNumber
    Exit Property


ErrorNumberGetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:ErrorNumber Property Get")
End Property



Public Property Let ErrorDescription(ByVal vData As String)
    On Error GoTo ErrorDescriptionLetErr


'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.ErrorDescription = 5
    mvarErrorDescription = vData
    Exit Property


ErrorDescriptionLetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:ErrorDescription Property Let")
End Property


Public Property Get ErrorDescription() As String
    On Error GoTo ErrorDescriptionGetErr


'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.ErrorDescription
    ErrorDescription = mvarErrorDescription
    Exit Property


ErrorDescriptionGetErr:


    Call RaiseError(MyUnhandledError, "CDomFunctions:ErrorDescription Property Get")
End Property

Private Sub Class_Initialize()
    #If DebugMode Then
        'get the next available class ID, and print out
        'that the class was created successfully
        mlClassDebugID = GetNextClassDebugID()
        Debug.Print "'" & TypeName(Me) & "' instance " & mlClassDebugID & " created"
    #End If
End Sub


Private Sub Class_Terminate()
    'the class is being destroyed
    #If DebugMode Then
        Debug.Print "'" & TypeName(Me) & "' instance " & CStr(mlClassDebugID) & " is terminating"
    #End If
End Sub


#If DebugMode Then
    Public Property Get ClassDebugID()
        'if we are in debug mode, surface this property that consumers can query
        ClassDebugID = mlClassDebugID
    End Property
#End If

