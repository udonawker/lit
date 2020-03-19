[Windows で ファイル の チェックサム を確認する](https://aruo.net/arbk/blog/article/verify_file_checksum_on_windows_tipsfaq)<br/>

## CertUtil -hashfile コマンド
CertUtil コマンド は MD2 / MD4 / MD5 / SHA1 / SHA256 / SHA384 / SHA512 ハッシュ値（チェックサム）を計算できます. （デフォルトは SHA1）<br/>
例: EXEファイル の MD5ハッシュ値（MD5チェックサム） を計算する.<br/>
コマンドプロンプトを立ち上げて 以下を入力します.<br/>
<pre>
&gt; CertUtil -hashfile d:\hogehoge.exe MD5
</pre>
結果:<br/>
<pre>
&gt; CertUtil -hashfile d:\hogehoge.exe MD5
MD5 ハッシュ (ファイル d:\hogehoge.exe):
cf 6d 86 4a 0e 88 9d c7 1c 6b e8 42 d8 f9 92 e7
CertUtil: -hashfile コマンドは正常に完了しました。
</pre>
CertUtil -hashfile<br/>
<pre>
使用法:
CertUtil [オプション] -hashfile InFile [HashAlgorithm]
ファイルに暗号化ハッシュを生成し表示します

オプション:
-Unicode -- リダイレクトされた出力を Unicode として書き込む
...

ハッシュ アルゴリズム: MD2 MD4 MD5 SHA1 SHA256 SHA384 SHA512
</pre>

## PowerShell で Get-FileHash コマンドレット
## FCIV ユーティリティ
