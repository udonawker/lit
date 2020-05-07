[Linux上で特殊文字を含む名前のファイルの削除方法](http://y-sumida.hatenablog.com/entry/2017/10/17/213915)<br>

コマンドの操作ミスやスクリプト出力の文字化けなどで特殊文字を含む名前でファイルができてしまい、単にrmコマンドでは削除できない時の削除方法。<br>

## 実験用のファイル
<pre>
temp $ ls
"ccc.txt    -bbb.txt    aaa.txt
temp $
</pre>

## 実験
とりあえず用意したファイルを普通に消そうとするとどうなるか見てみます。<br>

## 先頭がダブルクォートのファイル名
<pre>
temp $ rm "ccc.txt
&gt;
temp $
</pre>

次の入力を待たれてしまいます。<br>

## 先頭がハイフンのファイル名
<pre>
temp $ rm -bbb.txt
rm: illegal option -- b
usage: rm [-f | -i] [-dPRrvW] file ...
       unlink file
temp $ 
</pre>

rmコマンドのオプションと解釈されてしまいます。<br>

## 解決方法
いろいろなやり方があるのですが、汎用的な方法を。<br>

## 手順1 ls -iでinode番号を確認
<pre>
temp $ ls -i
2991451 "ccc.txt    2991471 -bbb.txt    2991475 aaa.txt
temp $
</pre>
ファイル名の前に表示されているのがinode番号です。<br>

## 手順2 確認したinode番号を指定して削除
<pre>
temp $ rm `find . -inum 2991451`
temp $ ls
-bbb.txt    aaa.txt
temp $ rm `find . -inum 2991471`
temp $ ls
aaa.txt
temp $
</pre>
削除できました。<br>
実際にやる場合は、事前の削除対象の確認を忘れずに。<br>

## 
