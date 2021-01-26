## [テキストファイルの内容をファイル名付きで表示する](https://qiita.com/quenhulu/items/ee2a5aed89a0e702cdda)

小さなテキストファイルがたくさんあって、一度にまとめて眺めたいときに grep はいかがでしょう。<br>
cat だと内容しか表示されませんが grep "" だとファイル名付きで表示されます。<br>
行番号も表示したいときは -n を指定します。<br>
<pre>
grep "" FILE1 FILE2 FILE3...
grep -n "" FILE1 FILE2 FILE3...
</pre>
-H を指定すれば引数のファイルが一つでもファイル名を表示させることができます。<br>
-H をサポートしていない grep では代わりに /dev/null を指定します。<br>
<pre>
grep -H "" FILE1
grep "" /dev/null FILE1
</pre>
