引用 [Windows 10 環境変数の一覧と既定値](https://www.tipsfound.com/windows10/11010) <br/>

## 環境変数の既定値

### 環境変数には使用時の値と保存されている生の値があります。それらは少し異なります。

* **使用時の値** : 保存されている値が展開されたものです。保存されていなくても OS などが自動的に設定したものがあります。
* **保存されている生の値** : 値に別の環境変数を入力できます。使用するときにそれが展開されます。

環境変数名をエクスプローラーなどで使用するには`%環境変数名%`のように % で囲みます。そのためここでは % 付きで名前を記載しています。

## 使用時の値

`ユーザー名`などカタカナで記載されている部分は、ログインしているユーザーの名前などに置き換えられます。<br/>

|変数名|値|
|---|---|
|%ALLUSERSPROFILE%|C:\ProgramData|
|%APPDATA%|C:\Users\ユーザー名\AppData\Roaming|
|%COMMONPROGRAMFILES%|C:\Program Files\Common Files|
|%COMMONPROGRAMFILES(x86)%|C:\Program Files (x86)\Common Files|
|%CommonProgramW6432%|C:\Program Files\Common Files|
|%COMPUTERNAME%|コンピューター名|
|%ComSpec%|C:\Windows\System32\cmd.exe|
|%HOMEDRIVE%|C:\|
|%HOMEPATH%|\Users\ユーザー名|
|%LOCALAPPDATA%|C:\Users\ユーザー名\AppData\Local|
|%LOGONSERVER%|\\ログインサーバー名|
|%Path%|C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem|
|%PATHEXT%|.com;.exe;.bat;.cmd;.vbs;.vbe;.js;.jse;.wsf;.wsh;.msc|
|%PROGRAMDATA%|C:\ProgramData|
|%PROGRAMFILES%|C:\Program Files|
|%PROGRAMFILES(X86)%|C:\Program Files (x86)|
|%ProgramW6432%|C:\Program Files|
|%PROMPT%|$P$G|
|%PSModulePath%|C:\Windows\system32\WindowsPowerShell\v1.0\Modules\|
|%PUBLIC%|C:\Users\Public|
|%SystemDrive%|C:|
|%SystemRoot%|C:\Windows|
|%TEMP%|C:\Users\ユーザー名\AppData\Local\Temp|
|%TMP%|C:\Users\ユーザー名\AppData\Local\Temp|
|%USERDOMAIN%|ドメイン名|
|%USERNAME%|ユーザー名|
|%USERPROFILE%|C:\Users\ユーザー名|
|%windir%|C:\Windows|

## 保存されている生の値

レジストリに保存されている生の値です。場所の「ユーザー」とは、そのユーザーでのみ使用可能なものです。<br/>
「システム」とは、すべてのユーザーで使用可能なものです。<br/>

|変数名|値|場所|
|---|---|---|
|%ComSpec%|%SystemRoot%\system32\cmd.exe|システム|
|%Path%|%USERPROFILE%\AppData\Local\Microsoft\WindowsApps|ユーザー|
||%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem|システム|
|%PATHEXT%|.com;.exe;.bat;.cmd;.vbs;.vbe;.js;.jse;.wsf;.wsh;.msc|システム|
|%PSModulePath%|%SystemRoot%\system32\WindowsPowerShell\v1.0\Modules|システム|
|%TEMP%|%USERPROFILE%\AppData\Local\Temp|ユーザー|
|%SystemRoot%\TEMP|システム|
|%TMP%|%USERPROFILE%\AppData\Local\Temp|ユーザー|
|%SystemRoot%\TEMP|システム|
|%USERNAME%|SYSTEM|システム|
|%windir%|%SystemRoot%|システム|

値には別の環境変数を入力できます。<br/>
また、保存されていない環境変数名 (%USERPROFILE% など) も入力できます。<br/>
このような環境変数を「プロセス」と言います。<br/>
<br/>
環境変数の優先順位は「プロセス」、「ユーザー」、「システム」の順になっています。<br/>
同じ名前の環境変数があるときは、優先度の高いものが使用されます。<br/>
<br/>
%Path% は特殊で`システム;ユーザー`のようにシステムの後ろにユーザーの値を追加して使用されます。<br/>
使用できる環境変数の多くは「プロセス」になっています。<br/>
