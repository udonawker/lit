## 20241006 [初学者のためのxargs](https://qiita.com/s_akibayashi/items/d43d43d2a635d8f2958c)
## 20241006 [xargsコマンドの使い方](https://qiita.com/P-man_Brown/items/c3f2634b7b5e08306c8f)
## 20241006 [xargsの便利な使い方が一目で分かる！初心者におすすめの記事](https://yossi-note.com/about_xargs/)

---

### ドライラン
-pをつけると実際にはコマンドは実行されず実行される予定のコマンドの内容が出力されます。<br>
```
$ find . -name "*.log" | xargs -p rm -fv
rm -fv ./path/to/sample1.log ./path/to/sample2.log ./path/to/sample3.log?...
```

### 引数の位置を指定
```
find . -name "*.log" | xargs -i cp {} /exampledir/
```
以下のようなコマンドが実行されます。<br>
```
cp ./path/to/sample.log /exampledir/
```
また以下のように記述しても上記と同様のことが実現できます。<br>
```
find . -name "*.yml" | xargs -IXXX cp -f XXX ./exampledir/
```



### 引数の最大数を指定
-L 数値を追記するとコマンドに一度に渡す引数の最大数を指定できます。<br>
```
find . -name "*.log" | xargs -L 1 rm -fv
```

上記の場合にfindコマンドで3つのパスを取得したとすると以下のように実行されます。<br>
```
$ rm -fv ./path/to/sample1.log
$ rm -fv ./path/to/sample2.log
$ rm -fv ./path/to/sample3.log
```

なお-L 数値は改行ごとに1つの引数として扱います。<br>

`-n` 数値でも引数の数を指定できますがこちらは`xargs`がコマンドに渡す引数の最大数を指定します。<br.

```
$ seq -s ' ' 10 | xargs -L 2 echo T
T 1 2 3 4 5 6 7 8 9 10

$ seq -s ' ' 10 | xargs -n 2 echo T
T 1 2
T 3 4
T 5 6
T 7 8
T 9 10
```

### 同時実行の最大数を指定
`-P` 数値を追記すると同時実行の最大数を指定できます。<br>

```
find . -name "*.log" | xargs -L 1 -P 2 rm -fv
```
上記の場合にfindコマンドで3つのパスを取得したとすると1つ目と2つ目が同時実行されその後に3つ目が実行されます。<br>


### 実行されるコマンドとその引数を表示する
`-t`オプション<br>
表示＋実際に実行<br>

### 入力を区切るためのデリミタを指定する
xargsの-dオプションは、入力を区切るためのデリミタを指定するために使用されます。デフォルトでは、xargsは空白文字（スペース、タブ、改行など）を区切り文字として使用しますが、-dオプションを使用することで、異なる区切り文字を指定することができます。<br>
```
echo "apple,banana,orange" | xargs -d, echo
```

### -0 オプション
xargsの-0オプションは、入力をnull文字(\0)で区切って処理することを指定します。通常、xargsはスペース、タブ、改行文字で区切られた入力を処理しますが、-0オプションを使用すると、空白文字や改行文字が含まれるファイル名やディレクトリ名などの入力を正しく処理することができます。<br>
例えば、以下のようにfindコマンドで検索したファイルをxargsを使用してrmコマンドで一括削除する場合、ファイル名に空白文字が含まれている場合にエラーが発生する可能性があります。<br>
```
find /path/to/files -name "*.txt" | xargs rm
```
この場合、-0オプションを使用すると、null文字で区切った入力を処理するため、空白文字が含まれるファイル名やディレクトリ名でも正しく処理することができます。<br>
```
find /path/to/files -name "*.txt" -print0 | xargs -0 rm
```
この例では、-print0オプションを使用して、findコマンドで検索したファイル名をnull文字で区切った形式で出力し、-0オプションを使用してxargsがnull文字で区切った入力を処理するように指定しています。これにより、空白文字が含まれるファイル名やディレクトリ名でも正しく削除することができます。<br>


### 複数のコマンドへ渡したいときは
bashの-cオプションを使い文字列として引数を渡してあげることで複数のコマンド処理も可能です。<br>
下記コマンドはカレントディレクトリにあるファイルを圧縮しつつ、圧縮後の中身をチェックしています。<br>
```
❯ ls
a.txt	b.txt	c.txt

❯ cat a.txt
a

❯ ls |xargs -I {} bash -c 'gzip {} && zcat {}.gz'
a
b
c

❯ ls
a.txt.gz	b.txt.gz	c.txt.gz
```
```
❯ cat domain.lst
qiita.com
esu2.co.jp
google.com

❯ cat domain.lst|xargs -I {} bash -c 'echo && echo {} && dig {} +shor'

qiita.com
52.68.203.46
54.150.97.130
3.113.225.145

esu2.co.jp
54.150.23.130

google.com
216.58.220.110
```

### ヒアドキュメントの併用がおすすめ
```
❯ cat << eof | xargs -I {} bash -c 'echo && echo {} && dig {} +shor'
google.com
qiita.com
esu2.co.jp
eof

google.com
172.217.26.238

qiita.com
52.68.203.46
54.150.97.130
3.113.225.145

esu2.co.jp
54.150.23.130
```

### 複雑なことをしたい場合はxargs -I{} bash -c
xargsで受け取った1つのパラメータを何度も使いたい場合や、リダイレクトやパイプなどを自然に使いたい場合がよくあります。<br>
例えば、上で列挙した.inファイルを入力としてプログラムを何度も実行しつつ、入力のファイル名も表示して処理の経過や順序を確認したい場合などです。<br>
bash -cでシェルの中にコマンドを並べてしまえば、難しいことを考えずに、いつものようにコマンドを書けます。<br>
```
# 列挙した.inファイルのファイル名を表示しつつ、main.pyにリダイレクトで与える
$ find . | grep ".in" | xargs -I{} bash -c "echo {}; cat {} | python3 main.py"
```
