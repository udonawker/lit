## 20260714 [テレワーク中の「離席」を防ぐマウスを自動で動かす PowerShell](https://note.com/mahalo_/n/ndddb882f9089)

```
write-host "CTRL + C で止まります"
Add-Type -AssemblyName System.Windows.Forms
while ($true) {
 $POSITION = [Windows.Forms.Cursor]::Position
 $DX = (Get-Random -Minimum -1 -Maximum 2)
 $DY = (Get-Random -Minimum -1 -Maximum 2)
 for($I=0;$I -lt 30;$I+=1){
  $POSITION.x += $DX
  $POSITION.y += $DY
  [Windows.Forms.Cursor]::Position = $POSITION
  Start-Sleep -Milliseconds 100
 }
 
 Start-Sleep -Seconds 10
}
```
