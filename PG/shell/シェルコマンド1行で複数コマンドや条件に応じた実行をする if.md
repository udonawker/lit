[シェルコマンド1行で複数コマンドや条件に応じた実行をする](https://qiita.com/wwwaltz/items/9ee247ee8fe3ab63fd27)<br/>

## コマンド1 || コマンド2

コマンド1が異常終了ならコマンド2を実行<br/>

<pre>
$ ls hello.txt || echo "Hello!" > hello.txt
</pre>
hello.txtが存在しなければ、文字列"Hello!"をhello.txtに出力して生成.<br/>

## コマンド1 && コマンド2

コマンド1が正常終了ならコマンド2を実行<br/>

<pre>
$ ls hello.txt && rm -f hello.txt
</pre>

hello.txtが存在したら、hello.txtを削除.<br/>

## "[ 条件式 ]"の利用

以下のように、シェルスクリプトのif文で用いる "[ 条件式 ]" を利用した書き方も可能です.<br/>

<pre>
$ [ -f hello.txt ] || echo "Hello!" > hello.txt
$ [ -f hello.txt ] && rm -f hello.txt
</pre>

\[ -f hello.txt \] は "hello.txtがファイルである"->真. ファイルでない/存在しない->偽.<br/>

## コマンド1; コマンド2

コマンド1を終了したら、結果に関わらずコマンド2を実行<br/>

<pre>
$ ls hello.txt; cp hello.txt yeah.txt
</pre>

hello.txtの有無を確認し、その結果に関わらずhello.txtのコピーをyeah.txtとして生成する<br/>
hello.txtがない場合、それにも関わらずコピーしようとするので後者cpコマンドはエラー.<br/>

## コマンド1 | コマンド2

言わずと知れたパイプ処理. コマンド1の出力をコマンド2の入力として実行.<br/>

<pre>
$ ps aux | grep ntpd
</pre>

プロセス一覧リストを出力して、そのうち"ntpd"が含まれる行を出力.<br/>
