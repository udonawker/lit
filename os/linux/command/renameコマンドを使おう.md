[Linuxでrenameコマンドを使おう](https://qiita.com/yahihi/items/dd8b3cc7c7041c3f03b9)<br>

<pre>
rename s/foo/bar/ ./hara/horo/hire/hare/foo.txt
</pre>

-v オプションで出力結果を表示<br>
<pre>
$ rename -v s/foo/bar/ foo.txt 
foo.txt renamed as bar.txt
</pre>

サンプル<br>
.bakという拡張子を全部とる<br>
<pre>
rename 's/\.bak$//' *.bak
</pre>

大文字を小文字に変える<br>
<pre>
rename 'y/A-Z/a-z/' *
</pre>
