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

<br>

### ファイルを検索して、各ファイルに処理を実行
検索したファイルに、sedで置換処理をかける例です。最初に find コマンドでファイルを絞り込み、その後に for-in でループして処理します。<br>

```
~$ files=$(find . -name '*.java'); for file in $files; do sed -i '.bak' -e 's/foo/bar/g' $file; done
```
grepを使い、さらに絞り込むこともできます。<br>

```
~$ files=$(find . -name '*.java' | xargs grep 'foo'); for file in $files; do sed -i '.bak' -e 's/foo/bar/g' $file; done
```
特定のファイルを全部消すには、以下のようにします。<br>
```
~$ files=$(find . -name '*.java' | xargs grep 'foo'); for file in $files; do rm $file; done
```
あるディレクトリにあるファイル名の中の「スペース」を、まとめてアンダースコアに変換する例は、以下です。（ファイル群があるディレクトリに移動してから実行してください）。<br>
```
for file in * ; do echo $file ; mv "${file}" `echo $file | sed -e 's/ /_/g'` ; done
```
<br>

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

## ●繰り返し処理

### 定期的に処理を実行
以下の例は、1秒間隔で5回、dateコマンドを実行します。<br>
```
~$ i=1; while [ $i -le "5" ]; do date; sleep 1; i=$(($i+1)); done
2012年  6月 30日 土曜日 21:17:21 JST
2012年  6月 30日 土曜日 21:17:22 JST
2012年  6月 30日 土曜日 21:17:23 JST
2012年  6月 30日 土曜日 21:17:24 JST
2012年  6月 30日 土曜日 21:17:25 JST
```
最初に、ループ用の変数iを初期化しています。'do'の後から、whileループ内で実行するコマンドを書きます。今回は、「dateコマンドの実行」「sleepコマンドの実行」「変数iのインクリメント」の3つを実行しています。<br>

無限ループ<br>
```
#while true; do date; sleep 1; done
2023年 12月 20日 水曜日22:44:00 JST
2023年 12月 20日 水曜日22:44:01 JST
2023年 12月 20日 水曜日22:44:02 JST
```

#### {数字..数字}による一括実行
{01..10}とすることで、01~10までのループ文として実行<br>
```
~/work # echo {01..10}
01 02 03 04 05 06 07 08 09 10
```

#### for文による一括実行
{01..10}をfor文の変数（ここでは変数i）に入れることでループ文として実行<br>
単純にコマンドを指定回数実行することも可能<br>
```
~/work # for i in {01..10} ; do echo $i; done
01
02
03
...
```

#### awkコマンド結果をfor文に入れた一括実行
awkコマンドにより、出力結果から特定の列を入力とすることでループ文として実行<br>
```
# for i in `[for文の入力としたいコマンド] | [awkコマンド]` ; do echo "$i"; done
```
Number 01~Number 10が書かれたファイルを用意し、数字列に記載された名前のディレクトリ（01等）を作成<br>
```
~/work # for i in {01..10} ; do echo "Number $i" >> file_awk_test ; done
~/work # cat file_awk_test
Number 01
Number 02
Number 03
...
```
```
~/work # for i in `cat file_awk_test | awk '{print $2}'` ; do echo "$i"; done
01
02
03
...
```
```
~/work # for i in `cat file_awk_test | awk '{print $2}'` ; do mkdir "$i"; done
~/work # ll
total 0
drwxr-xr-x 1 root root 4096 Oct  5 13:40 01
drwxr-xr-x 1 root root 4096 Oct  5 13:40 02
drwxr-xr-x 1 root root 4096 Oct  5 13:40 03
...
```

#### xargsコマンドによる一括実行
標準入力からリストを読み込み、それをコマンドの引数として実行<br>
```
~/work # mkdir {01..10}
~/work # ll
total 0
drwxr-xr-x 1 root root 4096 Oct  5 12:51 01
drwxr-xr-x 1 root root 4096 Oct  5 12:51 02
drwxr-xr-x 1 root root 4096 Oct  5 12:51 03
...
```

```
~/work # find /root/work -mindepth 1 -type d -print0 | xargs -0 -I% echo %
/root/work/01
/root/work/02
/root/work/03
...
```

```
~/work # find /root/work -mindepth 1 -type d -print0 | xargs -0 -I% mv % %_2020-10-05
~/work # ll
total 0
drwxr-xr-x 1 root root 4096 Oct  5 12:51 01_2020-10-05
drwxr-xr-x 1 root root 4096 Oct  5 12:51 02_2020-10-05
drwxr-xr-x 1 root root 4096 Oct  5 12:51 03_2020-10-05
...
```
