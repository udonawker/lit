[シェルスクリプトで一行ずつ読込む while read line 4パターン](https://server.etutsplus.com/sh-while-read-line-4pattern/)<br/>

__ワンライナー__<br/>
<pre>
$ cat (text file) | while read line; do (command); done
</pre>
<pre>
$ while read line ; do echo ${line} ; done < (text file)
</pre>
<pre>
$ cat ccc.txt | while read line; do echo $(basename ${line}) &gt;&gt; ddd.txt; done
</pre>

- while read line について
- Bash でファイル、またはコマンドの実行結果を一行ずつ読込むための 4つの方法
- その1.　Here Document 内に直接記述した値を使う場合
- その2.　変数に格納した値を Here Document で読み込んで使う場合
- その3.　標準入力リダイレクトでファイルを読み込んで使う場合
- その4.　コマンドを実行すると同時に使う場合
- 参考.　複数の Here Document を使う場合
- 行の前後空白が消える問題
- 行の前後に入っている空白が勝手に消えてしまう
- 行の前後に入っている空白をそのまま読み込む
- エスケープ文字が消える問題
- バックスラッシュが勝手に消えてしまう
- バックスラッシュを解析せずにそのまま読み込む
- バックスラッシュをそのまま読み込むと同時に状況に応じてエスケープ文字を解析する
- 結論.　Bash でありのままのデータを一行ずつ読み込む
- おまけ、その他の使い方 (随時追加) 
- おまけ 1.　配列にセットしたい場合
- おまけ 2.　IFS 応用編 - csv 読み込み、及び フィールドの値取得
- 終わりに

## その1.　Here Document 内に直接記述した値を使う場合
<pre>
#!/bin/bash

cnt=0
while read line
do
    cnt=`expr $cnt + 1`
    echo "LINE $cnt : $line"
done &lt;&lt;END
ABC DEF GHI JKL MNO PQR STU VWX YZA
BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
CDE FGH IJK LMN OPQ RST UVW XYZ ABC
END
</pre>

出力結果<br/>

<pre>
$ ./read_line_test.sh
LINE 1 : ABC DEF GHI JKL MNO PQR STU VWX YZA
LINE 2 : BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
LINE 3 : CDE FGH IJK LMN OPQ RST UVW XYZ ABC
</pre>

## その2.　変数に格納した値を Here Document で読み込んで使う場合

/tmp/test.txt<br/>
<pre>
$ cat test.txt
ABC DEF GHI JKL MNO PQR STU VWX YZA
BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
CDE FGH IJK LMN OPQ RST UVW XYZ ABC
</pre>

<pre>
#!/bin/bash

DATA=`cat /tmp/test.txt`

cnt=0
while read line
do
    cnt=`expr $cnt + 1`
    echo "LINE $cnt : $line"
done &lt;&lt;END
$DATA
END
</pre>

出力結果<br/>
<pre>
$ ./read_line_test.sh
LINE 1 : ABC DEF GHI JKL MNO PQR STU VWX YZA
LINE 2 : BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
LINE 3 : CDE FGH IJK LMN OPQ RST UVW XYZ ABC
</pre>

## その3.　標準入力リダイレクトでファイルを読み込んで使う場合
<pre>
#!/bin/bash

cnt=0
while read line
do
    cnt=`expr $cnt + 1`
    echo "LINE $cnt : $line"
done &lt; /tmp/test.txt
</pre>

出力結果<br/>
<pre>
$ ./read_line_test.sh
LINE 1 : ABC DEF GHI JKL MNO PQR STU VWX YZA
LINE 2 : BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
LINE 3 : CDE FGH IJK LMN OPQ RST UVW XYZ ABC
</pre>

## その4.　コマンドを実行すると同時に使う場合
<pre>
#!/bin/bash

cnt=0
cat /tmp/test.txt | while read line
do
    cnt=`expr $cnt + 1`
    echo "LINE $cnt : $line"
done
</pre>

出力結果<br/>
<pre>
$ ./read_line_test.sh
LINE 1 : ABC DEF GHI JKL MNO PQR STU VWX YZA
LINE 2 : BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
LINE 3 : CDE FGH IJK LMN OPQ RST UVW XYZ ABC
</pre>

## 参考.　複数の Here Document を使う場合
<pre>
#!/bin/bash

DATA=`cat /tmp/test.txt`

echo "----------- OH-MY-GOT -----------"

cnt=0
while read line
do
    cnt=`expr $cnt + 1`
    echo "LINE $cnt : $line"
done &lt;&lt;OH-MY-GOT
$DATA
OH-MY-GOT


echo
echo "----------- !!! -----------"

cnt=0
while read line
do
    cnt=`expr $cnt + 1`
    echo "LINE $cnt : $line"
done &lt;&lt;!!!
$DATA
!!!


echo
echo "----------- %%% -----------"

cnt=0
while read line
do
    cnt=`expr $cnt + 1`
    echo "LINE $cnt : $line"
done &lt;&lt;%%%
$DATA
%%%
</pre>

出力結果<br/>
<pre>
$ ./read_line_test.sh
----------- OH-MY-GOT -----------
LINE 1 : ABC DEF GHI JKL MNO PQR STU VWX YZA
LINE 2 : BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
LINE 3 : CDE FGH IJK LMN OPQ RST UVW XYZ ABC

----------- !!! -----------
LINE 1 : ABC DEF GHI JKL MNO PQR STU VWX YZA
LINE 2 : BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
LINE 3 : CDE FGH IJK LMN OPQ RST UVW XYZ ABC

----------- %%% -----------
LINE 1 : ABC DEF GHI JKL MNO PQR STU VWX YZA
LINE 2 : BCD EFG HIJ KLM NOP QRS TUV WXY ZAB
LINE 3 : CDE FGH IJK LMN OPQ RST UVW XYZ ABC
</pre>
