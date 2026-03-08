Dim fso, wsh, folder, exe, py, pythonw, cmd

Set fso = CreateObject("Scripting.FileSystemObject")
Set wsh = CreateObject("WScript.Shell")

folder = fso.GetParentFolderName(WScript.ScriptFullName)
exe    = folder & "\RedAlertMonitor.exe"
py     = folder & "\red_alert.py"

' --- 1. Prefer the compiled EXE ---
If fso.FileExists(exe) Then
    wsh.Run """" & exe & """", 0, False
    WScript.Quit
End If

' --- 2. Find pythonw.exe (no-console Python interpreter) ---
pythonw = ""

On Error Resume Next
Dim oExec, pyLine, pyDir
Set oExec = wsh.Exec("cmd /c where python 2>nul")
pyLine = Trim(oExec.StdOut.ReadLine())
If pyLine <> "" Then
    pyDir   = fso.GetParentFolderName(pyLine)
    pythonw = pyDir & "\pythonw.exe"
    If Not fso.FileExists(pythonw) Then pythonw = ""
End If
On Error GoTo 0

If pythonw = "" Then
    On Error Resume Next
    Set oExec = wsh.Exec("cmd /c where py 2>nul")
    pyLine = Trim(oExec.StdOut.ReadLine())
    On Error GoTo 0
    If pyLine <> "" Then pythonw = pyLine
End If

' --- 3. Run the .py (window style 0 = hidden) ---
If fso.FileExists(py) Then
    If pythonw <> "" Then
        cmd = """" & pythonw & """ """ & py & """"
    Else
        cmd = "python """ & py & """"
    End If
    wsh.Run cmd, 0, False
Else
    MsgBox "RedAlertMonitor.exe not found." & vbCrLf & "Run build_exe.bat to create it.", 16, "Red Alert Monitor"
End If
