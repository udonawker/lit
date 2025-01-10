## [快適なUnixLifeのために覚えておきたい10のTips](https://yut.hatenablog.com/entry/20111125/1322177659)

1. screen
2. zsh
3. find
4. grep
5. mkdir
6. diff
7. nkf
8. perl
9. cut,sort,uniq
10. その他


## Perl 使用例

ファイルのバックアップをとって(.bakファイルを生成し)、正規表現のルールに従ってファイルの内容を置換<br>
```
$ perl -pi.bak -e 's/<置換文字列>/置換後文字列/g' <file>
```

改行コードをWindows形式(キャリッジリターン、ラインフィールド)からUnix形式(ラインフィールド)に置換<br>
```
$ perl -pi.bak -e 's/\015\012/\012/g' <file>
```

スペースで区切られたファイルの0-4番目と6番目の項目を出力<br>
```
$ perl -lane 'print "@F[0..4] $F[6]"' <file>
```

タブで区切られたファイルの0-4番目の項目を出力<br>
```
$ perl -F '\t' -lane 'print "@F[0..4] "' <file>
```

標準出力をURlEncode<br>
```
$ echo "<Encodeしたい文字列>" | perl -MURI::Escape -ne 'print uri_escape($_)'
```

標準出力をURIDecode<br>
```
$ echo '<Decodeしたい文字列>' | perl -MURI::Escape -ne 'print uri_unescape($_)'
```

標準出力をBase64Encode<br>
```
$ echo "<Encodeしたい文字列>" | perl -MMIME::Base64 -ne 'print encode_base64($_)'
```

標準出力をBase64Decode<br>
```
$ echo "<Decodeしたい文字列>" | perl -MMIME::Base64 -ne 'print decode_base64($_)'
```




---
## その他
### dig
host名とipアドレスの対応をDNSに問い合わせるコマンド。/etc/hostsに設定を追加する場合などによく使う。
同じような機能のコマンドとしてnslookupがある。nslookupより結果として表示される情報量が多いのと使い勝手がよいのでdigを使っている。
digとはdomain information groperの略。

### base64encode/decode
標準出力のbase64encode/decodeを行う<br>
```
$ echo '<base64encodeしたい文字列>' | b+ase64 -e
$ echo '<base64decodeしたい文字列>' | base64 -d
```

ファイルのbase64encode/decodeを行う<br>
```
$ base64 -e file
$ base64 -d file
```

### 容量表示
ディスク容量<br>
```
$ df -h
```


ディレクトリ容量<br>
```
$ du -sh
```


### コマンドラインphp
単純な処理をしたい時は-rのワンライナーで書くと便利。そこそこコード量が必要になる場合はファイルに記述して実行する方が良い。<br>
-l:syntax check<br>
```
$ php -l <file>
```

-r:コード解釈、実行。<br>
```
$ php -r 'echo "test";'
```

### 設定ファイル配布
.vimrcなどを修正した時にログインした事があるサーバに対して一斉に配布したい時に利用する。下のスクリプトをdeliverという名前でファイルに保存。<br>
```
#!/bin/sh
for i in `perl -ne 'if (/([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`
do
    scp ~/.zshrc $i:
done
-------------
$ deliver .vimrc
```

上のようにshellscriptファイルとしても良いが、.zshrcなどに関数として記述すると尚良い。<br>
```
function deliver() {
    for i in  `perl -ne  'if (/([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`
    do  
        echo scp $PWD/$1 $i:$2
    done
}
-------------
$ deliver .vimrc
```

### lessをvimのカラーで表示させる
.zshrcなどに以下の設定を追記。vimのバージョン等によりパスは適宜変更。<br>
```
alias less='/usr/share/vim/vim72/macros/less.sh'
```
