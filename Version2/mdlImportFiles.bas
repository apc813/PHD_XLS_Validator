Attribute VB_Name = "mdlImportFiles"
Option Explicit
Sub read_files()
Dim wbk As Excel.Workbook

    'Set wbk = Application.ActiveWorkbook
    
    Set wbk = Application.Workbooks.Open("LandmarkSeq_20250723.xlsx")
    
    LoadLandmarkFile wbk, wbk.Sheets(1).Name
    LoadLandmarkFile wbk, wbk.Sheets(2).Name
    wbk.SaveAs wbk.Sheets("Combined").Names("vbaFileName").RefersToRange.Value
End Sub


Sub LoadLandmarkFile(pwbk As Excel.Workbook, pshtName As String)
Dim adblDimensionsRead() As Double
Dim intFileRow As Integer
Dim strFilePath As String
Dim flgFileOpen As Boolean
Dim strLn As String
Dim astrLn() As String
Dim i As Integer, j As Integer
On Error GoTo errHandle
'Dim retVal as
Dim sht As Excel.Worksheet
Dim rge As Excel.Range
    Set sht = pwbk.Sheets(pshtName)
    strFilePath = UseFileDialogOpen(pshtName)
    If strFilePath = "" Then GoTo exitHandle
    'sht.Names("vbaFileName").Value = strfilePath
    sht.Names("vbaFileName").RefersToRange.Value = getFileNameBase_FromPath(strFilePath)
    Open strFilePath For Input As #1
    flgFileOpen = True
    intFileRow = 0
    Do While Not EOF(1)
        Line Input #1, strLn
        astrLn = Split(strLn, ",")
        intFileRow = intFileRow + 1
        ReDim Preserve adblDimensionsRead(1 To 3, 1 To intFileRow)
        For i = LBound(astrLn) To UBound(astrLn)
            adblDimensionsRead(i + 1, intFileRow) = CDbl(astrLn(i))
        Next i
    Loop
    Close #1
    flgFileOpen = False
    '================================================= Write to table
    With sht.Names("vba_input_data").RefersToRange
        .ClearContents
        For i = LBound(adblDimensionsRead, 1) To UBound(adblDimensionsRead, 1)
            For j = LBound(adblDimensionsRead, 2) To UBound(adblDimensionsRead, 2)
                'Careful here: the dimension sequences are different in the array versus the column
                .Cells(j, i).Value = adblDimensionsRead(i, j)
            Next j
        Next i
    End With
    


exitHandle:
    'LoadFiles = retVal
    Exit Sub
errHandle:
    Select Case Err.Number
        Case Else
            'Debug.Print "Case &h"; Hex(Err.Number); ":", "'"; Left(Err.Description, 75); IIf(Len(Err.Description) > 75, "...", "") ', "VBAProject.Module1.LoadFiles"
            MsgBox Err.Description, vbCritical, Err.Source & " [&h" & Hex(Err.Number) & "] in VBAProject.Module1.LoadFiles"
    End Select
    Resume exitHandle
    Resume
End Sub
