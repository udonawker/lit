## [renameコマンドが使えないときにファイル名を一括置換するワンライナー](https://qiita.com/h-nabata/items/f18eb202bf035fb4d705)

## forループを利用する場合

bash系<br>
```
for file in *test1*; do mv -n "$file" "${file/test1/test2}"; done
```

csh系<br>
```
foreach file (*test1*) ; mv -n "$file" `echo "$file" | sed 's/test1/test2/'` ; end
```

などとすればよい。拡張子が .txt のファイルのみリネームしたい場合は *test1* の部分を *test1*.txt と書けばよい。<br>

## forループを利用しない場合
ファイル名の "test1" の部分を "test2" に一括置換するコマンド①<br>
```
ls * | xargs -n 1 | sed 'p;s/test1/test2/g' | xargs -n 2 mv
```

1. ls * でカレントディレクトリ内の全ファイルとディレクトリをリストする。
2. xargs -n 1 でそれらを1行ずつ sed に渡す。
3. sed 'p;s/test1/test2/g' で各ファイルについて変更前後の名前をそれぞれ出力する。1回目（pの部分）はそのまま、2回目（sで置換している部分）は test1 を test2 に置き換えたもの。
4. xargs -n 2 mv で2つの引数をまとめて mv コマンドに渡し、ファイル名を変更する。最初の引数は元のファイル名、2番目の引数は新しいファイル名となる。-n オプションは同名のファイルが既に存在する場合に上書きを禁止する。

## findを利用するケース

ファイル名の "test1" の部分を "test2" に一括置換するコマンド③<br>
```
find . -type f -name '*test1*' | sed 'p;s/test1/test2/' | paste - - | xargs -n 2 mv -n
```

`paste - -` によって標準入力を2行ずつ結合して一行にまとめている。<br>
なお -n が2回登場しているが、 `xargs` コマンドの `-n` オプションと `mv` コマンドの `-n` オプションは別物なので、この形式で正しい。<br>

<br>
sh を呼び出しているのでやや回りくどいが、以下の方法でも同様の処理が実行される。<br>

ファイル名の "test1" の部分を "test2" に一括置換するコマンド②<br>
```
find . -type f -name '*test1*' | xargs -I {} sh -c 'mv -n "$1" "${1//test1/test2}"' _ {}
```
