## [diffでコマンドの出力の結果を直接比較する。](https://qiita.com/wingedtw/items/2f05c5d0c37d71f209f4)

### 実直な方法。
```
$ ls dir1 > file_list.dir1.txt
$ ls dir2 > file_list.dir2.txt
$ diff file_list.dir1.txt file_list.dir2.txt
```

### コマンドの結果を直接食う！！
```
tar czf - * | ssh hoge@fuga.com "tar xzf -"
```

### パイプに結果を流す。
```
diff <(ls dir1) <(ls dir2)
```
`<(...)` はコマンドの結果を(名前付き)パイプに放り込む方法で、名前付きパイプはファイルと同等の扱いをされます。<br>
この結果、ls dir1の結果　と　ls dir2の結果　が名前付きパイプとしてファイル扱いされ、diffによって比較されることとなります。<br>

### そんなに使うのかい・・・？
この　`<(...)`　って結構使えてですね。<br>
ファイルしか入力に対応してないものとか、標準入力からの入力に対応してるけど複数食わせたいときとかに重宝します。<br>
```
cat <(grep -E "^hoge" file) <(grep -vE "^hoge" file) > hoge_head.txt
```
とかやって、hogeから始まる行だけを先頭にまとめるとか<br>
