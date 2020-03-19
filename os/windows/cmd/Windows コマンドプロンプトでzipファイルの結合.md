[Windows コマンドプロンプトでzipファイルの結合](https://qiita.com/ichigobambi/items/55574fc9341552cc7a1a)<br/>

`copy /b` コマンドで結合<br/>
<br/>
bunkatsu.zip.001<br/>
bunkatsu.zip.002<br/>
bunkatsu.zip.003<br/>
とを結合する場合<br/>
<pre>
copy /b bunkatsu.zip.001+bunkatsu.zip.002+bunkatsu.zip.003 ketsugou.zip
</pre>
