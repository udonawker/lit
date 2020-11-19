### awkのsub()の使い方

[参考：awk入門-使い方まとめ一覧-](https://it-ojisan.tokyo/awk-summary-list/)

書式<br>
<pre>
sub(置換対象文字列, 置換後文字列, 入力文字列)
</pre>

例えば、下記のin.txtがあったとします。<br>
<pre>
 $ cat in.txt 
line11 line12 line13
line21 line22 line23
line31 line32 line33
</pre>

例えば、$0(1行全体)を、下記のようにsub()を使って、"line"を"after"に置換します。<br>
<pre>
 $ cat in.txt | awk '{sub("line", "after", $0);print $0}'
after11 line12 line13
after21 line22 line23
after31 line32 line33
</pre>

### sub()の注意点
sub()の注意点は、置換対象文字列にマッチした最初の文字列しか置換されない点です。<br>
先程の例では、sub()を使った場合、最初の"line"しか"after"に置換されませんでした。<br>
gsub()を使うと、置換対象文字列があった場合は全て置換されます。<br>
<pre>
 $ cat in.txt | awk '{gsub("line", "after", $0);print $0}'
after11 after12 after13
after21 after22 after23
after31 after32 after33
</pre>

### sub()で正規表現を使って置換
sub()で正規表現を使って置換することもできます。<br>
下記のように、最初にマッチした数字を"after"に置換しています。<br>
<pre>
 $ cat in.txt | awk '{sub(/[0-9]/, "after", $0);print $0}'
lineafter1 line12 line13
lineafter1 line22 line23
lineafter1 line32 line33
</pre>

### n回目に出現した文字列を置換
n回目に出現した文字列を置換する場合には、gensub()を使います。<br>
下記の記事を書いていますので、よければ参考にしてください。<br>
[参考：awkのgensub()関数の使い方](https://it-ojisan.tokyo/awk-gensub/)
入力文字列に対して、n番目に出現した置換対象文字列を置換文字列で置換します。<br>
<pre>
r = gensub( 置換対象文字列, 置換文字列, n, 入力文字列 )
</pre>
