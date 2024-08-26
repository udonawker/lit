## ●ファイル・ディレクトリ

一つ前のディレクトリへ戻る<br>
```
$ cd -
```

ファイルを空にする<br>
```
$ cat /dev/null > sample.txt
```

ディレクトリ作成後そこへ移動<br>
```
$ mkdir dir_name ; cd $_
```

文字コード変換<br>
```
$ perl -MEncode -pe '$_ = encode("utf8", decode("eucjp", $_))' eucjp.txt > utf.txt
```

任意のディレクトリのファイル数をカウント<br>
```
$ ls -F |grep -v / |wc -l
```

指定ディレクトリ配下のファイルのパーミッションを見る<br>
```
$ find . -printf "%U %G %m %p\n"
```

バックアップ的なやつ<br>
```
$ cp passwd{,.bak}
```

ディレクトリサイズが大きい順で表示<br>
```
$ du -m / --max-depth=3 --exclude="/proc*" | sort -k1 -n -r
```

拡張子を一括変換  txtからtxt.oldへ変換<br>
```
$ for filename in *.txt; do mv $filename ${filename%.txt}.txt.old; done
```

連番ファイルの作成<br>
```
$ touch foo_{1..30}.txt
$ touch {A..Z}.txt
```

あるディレクトリ配下のファイルを一括コピー<br>
```
$ for txt in $(find . -name *.txt); do cp -ip ${txt} ~/work/ ; done
```

.DS_storeを一括削除(findで検索したファイルを一括削除)<br>
```
$ find . -name '.DS_Store' -type f -ls -delete
```

## ●検索
任意のディレクトリ以下のファイルを検索<br>
```
$ find ./ -name '*'|xargs grep 'xxx'
```

grepする時間を指定して出力がなければエラー終了<br>
```
$ timeout 5 tailf hoge.txt | grep -q --line-buffered "hoge"
```

## ●テキスト
ヘッダーとフッターを除外して表示<br>
```
$ cat ファイル名 | sed -e '$d' | awk 'NR > 1 {print}'
```

文字列を抜き出す<br>
```
$ echo 'abcde' | awk '{print substr($0, 2)}'
```

文字数/単語数をカウントする<br>
```
# 文字数カウント(wc -c)
$ awk '{n+=length($0)} END{print n}' filename

# 単語数カウント(wc -w)
$ awk '{n+=NF} END{print n}' filename

# 行数カウント(wc -l)
$ awk 'END{print NR}' filename
```

指定行から指定行まで表示<br>
```
$ awk 'NR==10,NR==20'
```

奇数/偶数行のみ表示<br>
```
# 奇数行
$ awk 'NR%2' filename

# 偶数行
$ awk 'NR%2==0' filename
```

## ●ログ等
シスログを時間指定で見る<br>
```
$ awk -F - '"開始時間" < $1 && $1 <= "終了時間"' /抽出を行うログのPATH
```

タイムスタンプつきでtailf<br>
```
tailf file | while read; do echo "$(date +%T.%N) $REPLY"; done
```

## ●スクリプト
スクリプトが置かれている場所の絶対パスとスクリプト名を取得<br>
```
$ echo $(cd $(dirname $0) && pwd)/$(basename $0)
```

定期的にコマンドを実行<br>
```
$ while true; do `sleep 1; say hello`; done
```

並列化してxargs  forでは不可能な並列実行を行う<br>
```
echo "aaa" "iii" | xargs -r -n 1 -P 2 echo "Output:"
```

## ●リソース・プロセス・メモリ
物理メモリを多く使用しているプロセスを抽出<br>
```
$ ps aux | sort -n -k 6 | tail -n 10
```

CPU使用率が高いプロセスを見つける<br>
```
$ vmstat 1 | awk '{print strftime("%y/%m/%d %H:%M:%S"), $0}'
```

指定したポートを使ってるプロセスをkill<br>
```
$ lsof -i :8080 | awk '{l=$2} END {print l}' | xargs kill
```

定期的にプロセス状態を監視 watchあるならそっちでも<br>
```
$ while true ; do ps aux | grep httpd ; echo ""; sleep 2 ; done ;
```

ユーザ毎のCPU使用率を見る<br>
```
$ ps aux | awk '{ if(NR>1){p[$1] += $3; n[$1]++ }}END{for(i in p) print p[i], n[i], i}'
```

プロセス名で一括kill<br>
```
$ kill `ps -aux | grep "プロセス名" | awk '{print $2;}'`
```

## ●ネットワーク
Listen中のポート一覧<br>
```
$ lsof -Pan -i tcp -i udp
```

ファイル名を指定してファイルを保存する curl<br>
```
$ curl -o foo.txt https://hoge.com/fuga.txt -o bar.txt https://piyo.com/hogera.txt
```

## ●その他
sortとuniqのイディオム<br>
```
$ .. | sort | uniq -c | sort -nr
```

ストップウォッチ的なやつ Ctrl + Dを押したら止まる<br>
```
$ time read
```

パスワードをランダム生成する<br>
```
$ head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''
```

表示整形 column<br>
```
$ mount | column -t
```
