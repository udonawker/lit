## [知ると便利なヒアドキュメント](https://qiita.com/kite_999/items/e77fb521fc39454244e7)

### ヒアドキュメントとは
```
echo line1
echo line2
echo line3
```
上記のような事を下記に置き換える事ができます。<br>

```
cat <<EOF
line1
line2
line3
EOF
```

ファイルを作りたいときはリダイレクトするだけです。<br>

```
cat <<EOF > test
line1
line2
line3
EOF
```
これだけで複数行に渡ったファイルを作れます。<br>
シェルスクリプトの中でちょっとしたファイルや接続ファイル、エクスクルードファイルなどが必要な時、シェルスクリプトに含める事ができます。<br>

ヒアドキュメントは標準入力として扱われます。文字列リテラルではありません。<br>
従ってファイルを作る時もechoに渡すのではなく、catを使用しています。<br>

### 文法
```
cat <<EOF > test
line1
line2
line3
EOF
```
コマンドに<< EOSが渡されると次の行からEOSが単独で現れる行までの間がヒアドキュメントの内容になります。<br>
EOSの部分は任意の文字を使うことができます。<br>
また「EOSが単独で現れる行」というのは空白やタブも含んではいけません。<br>

### 行頭のタブを取り除く
ヒアドキュメントは便利ですが、インデントできないのが難点です。<br>
EOSをインデントしてしまうとヒアドキュメントの終わりとして認識してくれませんし、ヒアドキュメントの内容にインデントがそのまま反映されてしまいます。<br>
この問題を解決するための機能が用意されていて、<<を<<-に書き換えるだけで使用できます。<<-でヒアドキュメントを書くと、行頭のタブを無視してくれます。<br>
ただ、やはり空白だけは無視してくれません。<br>

```
cat <<-EOF > test
\t\tline1
\tline2
\t\tline3
\tEOF
```

`testファイル`
```
        line1
    line2
        line3
```

### 変数展開をやめさせる
EOFをクォートします。<br>

```
HOGE=hogehoge
cat <<'EOF' > test
line1
lne2
line3
$HOGE
EOF
```
としておけば下記のように$HOGEは文字列として扱われます。<br>

`testファイル`
```
line1
line2
line3
$HOGE
```

### 応用
ファイルを作るだけなく色々な所で役に立ちます。<br>
```
sftp -oPort=2222 -oIdentityFile=hoge hoge@hogehoge.hogehoge.hoge << EOF
cd /tmp
put hoge1
cd /home
put hoge2
put hoge3
quit
```
