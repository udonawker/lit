[正規表現に合致するファイル名をfindする方法](https://www.greptips.com/posts/301/)<br>

<pre>
## 「パスを含むファイル名全体が正規表現にマッチするものを検索する」ので、正規表現がパスに完全一致しなければならない
$ find . -regextype posix-egrep -regex "\./[1-9]{4}$"
./1234
</pre>

## findと正規表現の問題点
\-regexオプションが「パスを含むファイル名全体が正規表現にマッチするものを検索する。」とあるが、grepで使うような正規表現を書いても検索できない。<br>
これは正規表現の種類がデフォルトでemacsになっているのが原因。<br>
たとえばYYYY-MM-DDが含まれるファイル名を探したい。また反対にYYYY-MM-DDが含まれないファイル名を探したい。<br>

## 解決方法その１
`regextype`を設定する。<br>
findの`regextype`に指定できるのは`emacs`以外に`posix-awk`, `posix-basic`, `posix-egrep`, `posix-extended`。<br>
grepと同じにするには`regextype`を`posix-basic`にすればよい。<br>
<br>
※解決方法その１の注意点としては、grepと同じ種類の正規表現を使うといっても、部分一致で検索してくれるgrepとは異なり、findのregexは一番初めに書いた通り「パスを含むファイル名全体が正規表現にマッチするものを検索する」ので、正規表現がパスに完全一致しなければならないという点がある。<br>
そのため正規表現の始まりと終わりにそれぞれ `".*"` を入れている。<br>
<pre>
$ find . -type f -regextype posix-basic -regex ".*[0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}.*"
./2015-06-15.log
</pre>

正規表現を否定条件として使うには記号(!)をregexオプションにつける。<br>
<pre>
$ find . -type f -regextype posix-basic ! -regex ".*[0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}.*"
</pre>

grepと同じでは`{}`等をエスケープしなければならず不便なので、egrep、grep -Eと同じ正規表現を使うために`regextype`を`posix-egrep`にしてもいい。<br>
<pre>
$ find . -type f -regextype posix-egrep -regex ".*[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}.*"
</pre>

## 解決方法その２
grepと組み合わせる。<br>
grep はファイルが指定されていない場合や、ファイル名の代わりに1個のマイナス記号(-)が指定されている場合は標準入力を検索するため、findの結果をパイプで渡してあげればいい。<br>
<pre>
$ find . -type f | grep -e "[0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}" -
</pre>

正規表現を否定条件として使うにはgrepのvオプションをつける。<br>
<pre>
$ find . -type f | grep -ve "[0-9]\{4\}-[0-9]\{1,2\}-[0-9]\{1,2\}" -
</pre>

こちらも解決方法その１で`posix-egrep`を使用したのと同様にegrep、grep -Eを使用すればエスケープいらず。<br>
<pre>
$ find . -type f | grep -E "[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" -
</pre>
ちなみにファイル名の検索ではなくファイルの中身を検索する場合は、xargsをパイプの直後に入れると、findの結果をgrepのFILE引数に当てはめてくれる。<br>



