Attribute VB_Name = "mdlFileUtilities"
Option Explicit
'Application.VBE.ActiveVBProject.References.AddFromFile "C:\Windows\System32\scrrun.dll" 'Scripting  1.0
'Application.VBE.ActiveVBProject.References.AddFromFile "C:\Program Files\Common Files\Microsoft Shared\VBA\VBA7.1\VBE7.DLL" 'VBA  4.2
'Application.VBE.ActiveVBProject.References.AddFromFile "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" 'Excel  1.9
'Application.VBE.ActiveVBProject.References.AddFromFile "C:\Windows\System32\stdole2.tlb" 'stdole  2.0
'Application.VBE.ActiveVBProject.References.AddFromFile "C:\Program Files\Common Files\Microsoft Shared\OFFICE16\MSO.DLL" 'Office  2.8
'Application.VBE.ActiveVBProject.References.AddFromFile "C:\WINDOWS\system32\FM20.DLL" 'MSForms  2.0
'Application.VBE.ActiveVBProject.References.AddFromFile "C:\Windows\System32\scrrun.dll" 'Scripting  1.0


Function UseFileDialogOpen(Optional pstrButton As String = "Open") As String
On Error GoTo errHandle
Dim retVal As String
Dim lngCount As Long
Dim dlg As Office.FileDialog
    ' Open the file dialog
    Set dlg = Application.FileDialog(msoFileDialogFilePicker)
    dlg.ButtonName = pstrButton
    If pstrButton <> "Open" Then
        dlg.Title = "Select '" & pstrButton & "' file."
    End If
    ' ------------------------------ Doesn't seem to work - Microsoft bug.
    dlg.InitialView = msoFileDialogViewDetails
    dlg.AllowMultiSelect = False
    If dlg.Show() Then
        ' Display paths of each file selected
        For lngCount = 1 To dlg.SelectedItems.Count
            Debug.Print dlg.SelectedItems(lngCount)
        Next lngCount
        retVal = dlg.SelectedItems(1)
    Else
        retVal = ""
    End If



exitHandle:
    UseFileDialogOpen = retVal
    Exit Function
errHandle:
    Select Case Err.Number
        Case Else
            'Debug.Print "Case &h"; Hex(Err.Number); ":", "'"; Left(Err.Description, 75); IIf(Len(Err.Description) > 75, "...", "") ', "VBAProject.mdlFileUtils.UseFileDialogOpen"
            MsgBox Err.Description, vbCritical, Err.Source & " [&h" & Hex(Err.Number) & "] in VBAProject.mdlFileUtils.UseFileDialogOpen"
    End Select
    retVal = ""
    Resume exitHandle
    Resume
End Function

'Sub apcDebugListVBrefs()
'Dim kRefs As Integer
'Dim k As Integer
'kRefs = Application.VBE.ActiveVBProject.References.Count
'For k = 1 To kRefs
'    Debug.Print "Application.Vbe.ActiveVBProject.References.AddFromFile """; Application.VBE.ActiveVBProject.References(k).FullPath; """ '"; Application.VBE.ActiveVBProject.References(k).Name; "  "; RTrim(Application.VBE.ActiveVBProject.References(k).Major); "."; LTrim(Application.VBE.ActiveVBProject.References(k).Minor)
'Next k
'End Sub

Function getFilePath_Archive(pstrPath As String) As String
On Error GoTo errHandle
Dim retVal As String
Dim fso As Scripting.FileSystemObject
    Set fso = New Scripting.FileSystemObject
    retVal = fso.GetParentFolderName(pstrPath)
    retVal = fso.BuildPath(retVal, fso.GetBaseName(pstrPath))
    If fso.FileExists(pstrPath) Then
        retVal = retVal & "_" & Format(fso.GetFile(pstrPath).DateCreated, "yyyymmdd_hhnnss")
    Else
        retVal = retVal & "_" & Format(Now(), "yyyymmdd_hhnnss")
    End If
    If fso.GetExtensionName(pstrPath) <> "" Then retVal = retVal & "." & fso.GetExtensionName(pstrPath)

exitHandle:
    getFilePath_Archive = retVal
    Exit Function
errHandle:
    Select Case Err.Number
        Case Else
            'Debug.Print "Case &h"; Hex(Err.Number); ":", "'"; Left(Err.Description, 75); IIf(Len(Err.Description) > 75, "...", "") ', "VBAProject.mdlFileUtils.getFilePath_Archive"
            MsgBox Err.Description, vbCritical, Err.Source & " [&h" & Hex(Err.Number) & "] in VBAProject.mdlFileUtils.getFilePath_Archive"
    End Select
    retVal = False
    Resume exitHandle
    Resume
End Function
Function getFileNameBase_FromPath(pstrPath As String) As String
On Error GoTo errHandle
Dim retVal As String
'Dim strTmp As String
    retVal = StrReverse(pstrPath)
    retVal = Left(retVal, InStr(retVal, "\") - 1)
    retVal = Mid(retVal, InStr(retVal, ".") + 1)
    retVal = StrReverse(retVal)


exitHandle:
    getFileNameBase_FromPath = retVal
    Exit Function
errHandle:
    Select Case Err.Number
        Case Else
            'Debug.Print "Case &h"; Hex(Err.Number); ":", "'"; Left(Err.Description, 75); IIf(Len(Err.Description) > 75, "...", "") ', "VBAProject.mdlImportFile.getFileNameBase_FromPath"
            MsgBox Err.Description, vbCritical, Err.Source & " [&h" & Hex(Err.Number) & "] in VBAProject.mdlImportFile.getFileNameBase_FromPath"
    End Select
    retVal = pstrPath
    Resume exitHandle
    Resume
End Function
Sub Test_fso(strWriteToFile As String)
Dim strFileName As String
Dim fso As Scripting.FileSystemObject
Dim fleOut As Scripting.TextStream
strFileName = "C:\Users\acrisp\Documents\Toad SQLs\VBA_Insert\InsertSQL_VBA_Item_" + Format(Now(), "yyyymmdd_hhnnss") + ".SQL"
Set fso = New Scripting.FileSystemObject
Set fleOut = fso.CreateTextFile(strFileName)

fleOut.WriteLine strWriteToFile '------------ Writes Line to file

'exitHandle:
'---------------------------------------------------------------------------------------------------- Cleanup
If Not fleOut Is Nothing Then
    fleOut.Close
    Set fleOut = Nothing
    Set fso = Nothing
End If

End Sub



