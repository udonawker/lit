## [シェルスクリプト(bash)のif文とtestコマンド([])自分メモ](https://qiita.com/toshihirock/items/461da0f60f975f6acb10)

* if文では条件式に指定されたコマンドの終了ステータスを判定し分岐をしている。終了ステータスが0の場合に真となり、そうでない場合には偽となる
* if []と書いた場合、if testと書いたことと同じ扱い（[]はtestコマンドの略式）
* [ "A" = "A" ]というように[]の間にスペースがないとエラーとなる。例えば["A" = "A"]とか書くとエラー。[がコマンドだと思うと理解しやすい
* 条件式で<,>,<=,>=は使えない。代わりに-lt(<),-gt(>),-le(<=),-ge(>=)というのが使える。それぞれ-lt(less than),-gt(greater than),-le(less than or equal),-ge(greater than or equal)と覚える。でもわかりにくいので全部書いておきました。
* 困ったらman testで確認すればOK

## 文字列が等しいか
```
#!/bin/bash

hoge="A"
fuga="A"

if [ $hoge = $fuga ]; then
  echo "文字列は同じです"
else
  echo "文字列は違います"
fi
```

## >を条件式に使いたい
-gt(greater than)を使う<br>

```
#!/bin/bash

var1=1
var2=2

# >
if [ $var2 -gt $var1 ] ; then
  echo "var2はvar1より大きい"
else
  echo "var2はvar1以下"
fi
```

## <を条件式に使いたい
-lt(less than)を使う<br>

```
#!/bin/bash

var1=1
var2=2

# <
if [ $var1 -lt $var2 ] ; then
  echo "var1はvar2より小さい"
else
  echo "var1はvar2以上"
fi
```

## >=を条件式に使いたい
-ge(greater than or equal)を使う<br>

```
#!/bin/bash

var1=2
var2=2

# >=
if [ $var2 -ge $var1 ] ; then
  echo "var2はvar1以上"
else
  echo "var2はvar1より小さい"
fi
```

## <=を条件式に使いたい
-le(less than equal)を使う<br>

```
#!/bin/bash

var1=2
var2=2

# <=
if [ $var1 -le $var2 ] ; then
  echo "var1はvar2以下"
else
  echo "var1はvar2より大きい"
fi
```

## ディレクトリの存在確認をしたい
-dオプションを使う。<br>

```
#!/bin/bash

DIR="test"

if [ -d ${DIR} ]; then
  echo "ディレクトリが存在します"
else
  echo "ディレクトリが存在しません"
fi
```

## ファイルの存在確認をしたい
-fオプションを使う<br>

```
#!/bin/bash

LOCK_FILE="lock"

if [ -f ${LOCK_FILE} ]; then
  echo "ファイルが存在します"
else
  echo "ファイルが存在しません"
fi
```

## シェルスクリプト内で実行したコマンドが正常終了したかを判定
コマンド実行後、`$?`によって直前のコマンドの終了ステータスコードが取得できるので0（正常終了であるか）判定する<br>

```
#!/bin/bash

curl http://www.google.co.jp >/dev/null 2>&1

if [ $? = 0 ]; then
  echo "curlは正常終了"
else
  echo "curlは異常終了"
fi
```
`$?`は直前のコマンドの終了ステータスコードのみ保持しているので判定したいコマンドとif文の間で別のコマンドの実行をする場合には一度変数に`$?`の内容を保持しておく<br>

## NOT条件を使う
!オプションを使う。<br>

```
#!/bin/bash

hoge=true

if [ ! $hoge ]; then
  echo "こっちにはこない"
else
  echo "こっちになる"
fi
```

## AND条件、OR条件を使う
testコマンドの-a(AND条件）、-o(OR条件）で書けるが、&&(AND条件）、||(OR条件）の方が個人的には分かりやすい。<br>
ただし、-a、-oは１つのtestコマンドで条件判定するのに対し、&&、||は終了ステータスコードを判断して以降の処理を実行するものなので書き方が少し違う点に注意。<br>

-a、-oを利用する場合<br>

```
#!/bin/bash

LOCK_FILE="lock"
DIR="dir"

if [ -f ${LOCK_FILE} -a -d ${DIR} ]; then
  echo "ファイルとディレクトリが存在します"
else
  echo "ファイルかディレクトリのいずれかが存在しません"
fi
```

&&、||を利用する場合<br>

```
#!/bin/bash

LOCK_FILE="lock"
DIR="dir"

if [ -f ${LOCK_FILE} ] && [ -d ${DIR} ]; then
  echo "ファイルとディレクトリが存在します"
else
  echo "ファイルかディレクトリのいずれかが存在しません"
fi
```



