## [bashで文字列分解する時、cutやawkもいいけど、setの方が早い、けどreadが最強](https://qiita.com/hasegit/items/5be056d67347e1553f08)

## お題
例えば、こんなhostsがあったとします。空白はすべてスペースであるとします。<br>
```
123.123.123.123         geeg1   # application server
123.123.123.124         geeg2   # web frontend server
123.123.123.125         geeg3   # super fabulous exciting backup server #1
```

これをループして、IP、ホスト名、コメント部分を別々の変数に格納し、表示します。<br>

## cutの場合
```
while read line
do
  ip=$(cut -d' ' -f 1 <<<${line})
  hostn=$(cut -d' ' -f 2 <<<${line})
  comment=$(cut -d' ' -f 4- <<<${line})
  echo "[ip]${ip} [hostname]${hostn} [comment]${comment}"
done < hosts
```

## awkの場合
```
while read line
do
  ip=$(awk '{print $1}' <<<${line})
  hostn=$(awk '{print $2}' <<<${line})
  comment=$(awk '{for(i=4;i<NF;i++){ printf("%s%s",$i,OFS=" ")}print $NF}' <<<${line})
  echo "[ip]${ip} [hostname]${hostn} [comment]${comment}"
done < hosts
```

## setの場合
```
while read line
do
  set ${line}
  ip=${1}
  hostn=${2}
  comment=$(eval echo $(eval echo \\\$\{$(echo {4..${#}})\}))
  echo "[ip]${ip} [hostname]${hostn} [comment]${comment}"
done < hosts
```

`$(eval echo $(eval echo \\\$\{$(echo {4..${#}})\}))`の部分ですが、なんと、<br>
`${*:4}`…たったこれだけで行けてしまいます…。<br>
```
while read line
do
  set ${line}
  ip=${1}
  hostn=${2}
  comment=${*:4}
  echo "[ip]${ip} [hostname]${hostn} [comment]${comment}"
done < hosts
```
まず、変数${*}は特殊パラメータであり、何を意味するかというと、全ての位置パラメータ($1とか$2とか)を意味します。<br>
こいつに部分文字列展開${parameter:offset}を適用することで、位置パラメータの4番以降…という表現ができてしまうんですね。<br>

## readの場合
```
while read ip hostname n comment
do
  echo "[ip]${ip} [hostname]${hostn} [comment]${comment}"
done < hosts
```

## 実行速度比較
上記のwhileを以下な感じで500回ほど回して、実行時間を計測しました。<br>
time for i in {0..500}; do ./case_of_cut.sh >/dev/null; done<br>

|command|time(s)|
|:--|:--|
|cut|23.692|
|awk|28.268|
|set(tricky)|13.493|
|set(4..99)|8.421|
|read|3.207|

## setの仕組み
$1,$2等はPositional Parametersと言って、通常はシェル起動時に引数が代入されます。<br>
代入分による代入はできませんが、setコマンドを使うことにより代入しなおすことが可能です。<br>
この時、IFSで区切られてPositional Parametersに格納されるので、cutやawkの代替として使えるわけです。<br>
また、setはシェルの組み込みコマンドのため、パフォーマンス的にも有利、かも。<br>

尚、Positional Parametersが10以上の数字になる場合は、ブレース(これ→{})で括る必要があります。<br>

## 結局どれを使うか
- cut
誰が見ても分かりやすいけど遅い<br>

- awk
少々トリッキーな上、遅い<br>

- set
途中途中に捨てる部分が多い文字列であれば有用<br>

- read
文字列全部分解して使う際は勿論、途中で捨てるものがある場合でもOK<br>
使いようによってはsetの真似事も可能<br>

## おまけ setの範囲指定部分の簡単な解説
`comment=$(eval echo $(eval echo \\\$\{$(echo {4..${#}})\}))`

まず、`$(echo {4..${#}})`で${#}を展開、`{4..9}`みたいなのが取れます。これがブレース展開のネタ。
次に、evalで変数を評価してから表示します。{4..9}のブレース展開が行われます。
$は次のevalの評価で使うため、エスケープする必要がありますので、`\\\$`という書き方になっています。
更に、10以上の数字になることを考慮して、ブレース展開される外側をブレースで括ります。
この時、外側ブレースはエスケープしないと評価されてしまうので、エスケープします。
ここまでで`${4} ${5} ${6} ${7} ${8} ${9}`が取れます。
最後に、それら変数を再度evalで評価すると、$4とかの中身がようやく取れます。
