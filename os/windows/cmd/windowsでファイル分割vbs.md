[Windowsの標準機能だけでファイルを分割する方法](https://blog.goo.ne.jp/n-best/e/a564cbd4cb1e904b45d701227ed555a7)<br/>

### 以下をsplit.vbsとして保存し、分割したいファイルをDropする

<pre>
Option Explicit
Dim args, arg
Dim BYTES
Dim sourceStream
Dim outputStream

'分割サイズ(byte) ## ここを変更する
BYTES = 1024000

Set args = WScript.Arguments

If args.Count <> 1 Then
WScript.Echo "Drag and drop only one file."
WScript.Quit
End If

Dim InputFilename
Dim OutputFilename
Dim objFS, ret, objFile

InputFilename = args(0)

Set args = nothing

Set objFS = CreateObject("Scripting.FileSystemObject")
ret = objFS.FileExists(InputFilename)
If ret Then
Set objFile = objFS.GetFile(InputFilename)
If objFile.Size < BYTES Then
WScript.Echo "File size is too small. It requires more than " & FormatNumber(BYTES, 0) & " byte." & vbCrLf & InputFilename & vbCrLf & "(" & FormatNumber(objFile.Size, 0) & " byte)"
WScript.Quit
End If
WScript.Echo "A target file is " & InputFilename & vbCrLf & "(" & FormatNumber(objFile.Size, 0) & " byte)"
Set objFile = nothing
Else
WScript.Echo "No file."
WScript.Quit
End If

Set objFS = nothing

Set sourceStream = CreateObject("ADODB.Stream")
sourceStream.Type = 1
sourceStream.Open
sourceStream.LoadFromFile InputFilename
sourceStream.Position = 0

Set outputStream = CreateObject("ADODB.Stream")
outputStream.Type = 1
outputStream.Open
outputStream.Position = 0

Dim no

no = 0

Do While sourceStream.EOS = False
OutputFilename = InputFilename & "." & no
outputStream.Write sourceStream.Read( BYTES )
outputStream.SaveToFile OutputFilename, 2
outputStream.Close
outputStream.Open
no = no + 1
Loop

WScript.Echo InputFilename & " -> Success : " & no

sourceStream.Close
outputStream.Close

Set sourceStream = nothing
Set outputStream = nothing
</pre>
