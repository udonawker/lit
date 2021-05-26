## [シェルの変数展開](https://qiita.com/bsdhack/items/597eb7daee4a8b3276ba)

シェルスクリプトを作成する際にシェル変数に値を代入したり参照したりする事は頻繁に発生するが、 シェル変数の展開にも便利な使い方がある。<br>
basename (1) や dirname (1) と同様な動作がシェルの組込みとして利用できるので資源の節約にもつながり、 上手に利用すると可読性の高いスクリプトが作成できる。<br>

## 機能一覧

|記述|機能|
|:--|:--|
|${parameter:-word}|デフォルト値への置換|
|${parameter:=word}|デフォルト値の代入|
|${parameter:?[word]}|値の検査とエラー|
|${parameter:+word}|代替値の使用|
|${#parameter}|文字列長の取得|
|${parameter%word}|最短後置パターンの削除|
|${parameter%%word}|最長後置パターンの削除|
|${parameter#word}|最短前置パターンの削除|
|${parameter##word}|最長前置パターンの削除|

## 実例
### デフォルト値への置換

__${parameter:-word}__<br>
${parameter} が NULL の場合 word に置換される。<br>
```
$ echo ${foo}

$ echo ${foo:-FOO}
FOO
$ echo ${foo}

$ foo=BAR
$ echo ${foo:-FOO}
BAR
```

### デフォルト値の代入

__${parameter:=word}__<br>
${parameter} が NULL の場合 word に置換され、 かつ parameter に代入される。<br>

```
$ echo ${foo}

$ echo ${foo:=FOO}
FOO
$ echo ${foo}
FOO
$ echo ${foo:=BAR}
FOO
```

### 値の検査とエラー

__${parameter:?[word]}__<br>
${parameter} が NULL の場合 word が指定されていればその値を、 指定されていない場合はデフォルトの値を表示し、 非対話実行されているシェルをエラー終了させる。<br>

```
$ echo ${foo}

$ echo ${foo:?value not set}
value not set
```

### 代替値の使用

__${parameter:+word}__<br>

${parameter} が NULL 以外の場合 word に置換される<br>

```
$ echo ${foo:+FOO}

$ echo ${foo}

$ foo=BAR
$ echo ${foo}
BAR
$ echo ${foo:+FOO}
FOO
```

### 文字列長の取得

__${#parameter}__<br>

${parameter} の文字列としての長さに置換される<br>

```
$ echo ${foo}

$ echo ${#foo}
0
$ foo=FOO
$ echo ${foo}
FOO
$ echo ${#foo}
3
```

### 最短後置パターンの削除

__${parameter%word}__<br>

${parameter} の右から word で示されるパターンの最短部分を削除する<br>

```
$ foo=/foo/bar/baz
$ echo ${foo%/*}
/foo/bar
$ foo=foo.c
$ echo ${foo%.*}
foo
$ foo=foo
$ echo ${foo%.*}
foo
```

### 最長後置パターンの削除

__${parameter%%word}__<br>

${parameter} の右から word で示されるパターンの最長部分を削除する<br>

```
$ foo=foo.example.com
$ echo ${foo%%.*}
foo
$ foo=http://www.example.com:8888/
$ echo ${foo%%:*}
http
$ foo=foo
$ echo ${foo%%.*}
foo
```

### 最短前置パターンの削除

__${parameter#word}__<br>

${parameter} の左から word で示されるパターンの最短部分を削除する<br>

```
$ foo=foo.c
$ echo ${foo#*.}
c
$ foo=foo.example.com
$ echo ${foo#*.}
example.com
$ foo=foo
$ echo ${foo#*.}
foo
```

### 最長前置パターンの削除

__${parameter##word}__<br>

${parameter} の左から word で示されるパターンの最長部分を削除する<br>

```
$ foo=foo.example.com
$ echo ${foo##*.}
com
$ foo=/foo/bar/baz
$ echo ${foo##*/}
baz
$ foo=foo
$ echo ${foo##*.}
foo
```
