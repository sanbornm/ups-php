VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Base64"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "VB_Name = ""basRadix64"""
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'Attribute VB_Name = "basRadix64"
Option Explicit
Option Base 0

' basRadix64: Radix 64 en/decoding functions
' Version 1. Published 28 December 2000
'************************COPYRIGHT NOTICE*************************
' Copyright (C) 2000 DI Management Services Pty Ltd,
' Sydney Australia <www.di-mgt.com.au>. All rights reserved.
' This code was originally written in Visual Basic by David Ireland.
' You are free to use this code in your applications without liability
' or compensation, but the courtesy of both notification of use and
' inclusion of due credit are requested. You must keep this copyright
' notice intact.
' It is PROHIBITED to distribute or reproduce this code for profit
' or otherwise, on any web site, ftp server or BBS, or by any
' other means, including CD-ROM or other physical media, without the
' EXPRESS WRITTEN PERMISSION of the author.
' Use at your own risk.
' David Ireland and DI Management Services Pty Limited
' offer no warranty of its fitness for any purpose whatsoever,
' and accept no liability whatsoever for any loss or damage
' incurred by its use.
' If you use it, or found it useful, or can suggest an improvement
' please let us know at <code@di-mgt.com.au>.

' Credit where credit is due:
' Some parts of this VB code are based on original C code
' by Carl M. Ellison. See "cod64.c" published 1995.
'*****************************************************************


Private aDecTab(255) As Integer
Private Const sEncTab As String = _
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

Public Function EncodeStr64(sInput As String) As String
' Return radix64 encoding of string of binary values
' Does not insert CRLFs. Just returns one long string,
' so it's up to the user to add line breaks or other formatting.
    Dim sOutput As String, sLast As String
    Dim b(2) As Byte
    Dim j As Integer
    Dim i As Long, nLen As Long, nQuants As Long
    
    nLen = Len(sInput)
    nQuants = nLen \ 3
    sOutput = ""
    ' Now start reading in 3 bytes at a time
    For i = 0 To nQuants - 1
        For j = 0 To 2
           b(j) = Asc(Mid(sInput, (i * 3) + j + 1, 1))
        Next
        sOutput = sOutput & EncodeQuantum(b)
    Next
    
    ' Cope with odd bytes
    Select Case nLen Mod 3
    Case 0
        sLast = ""
    Case 1
        b(0) = Asc(Mid(sInput, nLen, 1))
        b(1) = 0
        b(2) = 0
        sLast = EncodeQuantum(b)
        ' Replace last 2 with =
        sLast = Left(sLast, 2) & "=="
    Case 2
        b(0) = Asc(Mid(sInput, nLen - 1, 1))
        b(1) = Asc(Mid(sInput, nLen, 1))
        b(2) = 0
        sLast = EncodeQuantum(b)
        ' Replace last with =
        sLast = Left(sLast, 3) & "="
    End Select
    
    EncodeStr64 = sOutput & sLast
End Function

Public Function DecodeStr64(sEncoded As String) As String
' Return string of decoded binary values given radix64 string
' Ignores any chars not in the 64-char subset
    Dim sDecoded As String
    Dim d(3) As Byte
    Dim c As Byte
    Dim di As Integer
    Dim i As Long
    
    sDecoded = ""
    di = 0
    Call MakeDecTab
    ' Read in each char in trun
    For i = 1 To Len(sEncoded)
        c = CByte(Asc(Mid(sEncoded, i, 1)))
        c = aDecTab(c)
        If c >= 0 Then
            d(di) = c
            di = di + 1
            If di = 4 Then
                sDecoded = sDecoded & DecodeQuantum(d)
                If d(3) = 64 Then
                    sDecoded = Left(sDecoded, Len(sDecoded) - 1)
                End If
                If d(2) = 64 Then
                    sDecoded = Left(sDecoded, Len(sDecoded) - 1)
                End If
                di = 0
            End If
        End If
    Next i
    
    DecodeStr64 = sDecoded
End Function

Private Function EncodeQuantum(b() As Byte) As String
    Dim sOutput As String
    Dim c As Integer
    
    sOutput = ""
    c = SHR(b(0), 2) And &H3F
    sOutput = sOutput & Mid(sEncTab, c + 1, 1)
    c = SHL(b(0) And &H3, 4) Or (SHR(b(1), 4) And &HF)
    sOutput = sOutput & Mid(sEncTab, c + 1, 1)
    c = SHL(b(1) And &HF, 2) Or (SHR(b(2), 6) And &H3)
    sOutput = sOutput & Mid(sEncTab, c + 1, 1)
    c = b(2) And &H3F
    sOutput = sOutput & Mid(sEncTab, c + 1, 1)
    
    EncodeQuantum = sOutput
    
End Function

Private Function DecodeQuantum(d() As Byte) As String
    Dim sOutput As String
    Dim c As Long
    
    sOutput = ""
    c = SHL(d(0), 2) Or (SHR(d(1), 4) And &H3)
    sOutput = sOutput & Chr$(c)
    c = SHL(d(1) And &HF, 4) Or (SHR(d(2), 2) And &HF)
    sOutput = sOutput & Chr$(c)
    c = SHL(d(2) And &H3, 6) Or d(3)
    sOutput = sOutput & Chr$(c)
    
    DecodeQuantum = sOutput
    
End Function

Private Function MakeDecTab()
' Set up Radix 64 decoding table
    Dim t As Integer
    Dim c As Integer

    For c = 0 To 255
        aDecTab(c) = -1
    Next
  
    t = 0
    For c = Asc("A") To Asc("Z")
        aDecTab(c) = t
        t = t + 1
    Next
  
    For c = Asc("a") To Asc("z")
        aDecTab(c) = t
        t = t + 1
    Next
    
    For c = Asc("0") To Asc("9")
        aDecTab(c) = t
        t = t + 1
    Next
    
    c = Asc("+")
    aDecTab(c) = t
    t = t + 1
    
    c = Asc("/")
    aDecTab(c) = t
    t = t + 1
    
    c = Asc("=")    ' flag for the byte-deleting char
    aDecTab(c) = t  ' should be 64

End Function

Private Function SHL(bytX As Byte, nShift As Integer)
' Shifts left by nShift bits, i.e. bytX << nShift in C
    Dim i As Integer, byt As Byte
    byt = bytX
    For i = 1 To nShift
        byt = SHL_1(byt)
    Next
    SHL = byt
End Function

Private Function SHR(bytX As Byte, nShift As Integer)
' Shifts right by nShift bits, i.e. bytX >> nShift in C
    Dim i As Integer, byt As Byte
    byt = bytX
    For i = 1 To nShift
        byt = SHR_1(byt)
    Next
    SHR = byt
End Function

Private Function SHR_1(bytX As Byte)
    Dim byt As Byte
    'Debug.Print ShowBinary(bytX)
    byt = bytX
    SHR_1 = byt \ 2
End Function

Private Function SHL_1(bytX As Byte)
    Dim byt As Byte
    'Debug.Print ShowBinary(bytX)
    byt = bytX And &H7F
    SHL_1 = byt * 2
End Function




