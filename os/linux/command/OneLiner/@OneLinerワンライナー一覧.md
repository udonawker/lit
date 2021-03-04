## [俺の愛用ワンライナー、Web企業のエンジニア16人に聞きました 2018/5/8](https://eh-career.com/engineerhub/entry/2018/05/08/110000#:~:text=%E3%83%AF%E3%83%B3%E3%83%A9%E3%82%A4%E3%83%8A%E3%83%BC%E3%81%A8%E3%81%AF%E3%80%81%E4%BD%95,%E3%81%AE%E3%81%A7%E3%81%AF%E3%81%AA%E3%81%84%E3%81%A7%E3%81%97%E3%82%87%E3%81%86%E3%81%8B%E3%80%82)
## [仕事で使えるLinux ワンライナー集 2019/1/6](https://qiita.com/ryuichi1208/items/55b73d8ae75993dc10c1)
## [個人的なシェル芸(シェルワンライナー)のまとめ](https://orebibou.com/ja/documents/shellgei/)
<br>

### プロセスを停止する
サーバ内で実行されているhogehogeという名前のプロセスを、ゴースト化・サスペンド化にかかわらず絶対にkillします。プロセス名の1文字目を[]で囲むことにより、pgrepで探しているプロセス自体が除外されます。<br>
```
pgrep -f [h]ogehoge | sudo xargs kill -9
```
<br> 

### 物理メモリを多く使用しているプロセスを抽出する
物理メモリを多く使用しているプロセスの上位10件を抽出します。引数の数字を変えるだけでCPUとメモリについて調べることができて便利です。<br>
```
ps aux | sort -n -k 6 | tail -n 10
```
<br>

### CPU使用率が高いプロセスを見つける
CPU使用率が高いプロセスを見つけるときに使用します。なお、+4はメモリの使用率が高いプロセスを見つけるときのオプションです。<br>
```
watch -n 2 "ps aux| sort -nk +3 | tail" or watch -n 2 "ps aux| sort -nk +4 | tail"
```
<br>

### Apacheのアクセスログから、ページごとのアクセスランキングを集計
Apacheのアクセスログから、アクセスランキングを算出。アクセス数の多い順にそのURLとアクセス数を表示します（Common Log Format with Virtual Hostで動作します）。<br>
```
zgrep -hE "\"GET /.+ HTTP.+\" 200 " `find /var/log/httpd -name 'access_log.*'` | awk '{print $1$8}' | sort | uniq -c | sort -nr
```
実行例<br>
```
1263 www.example.com/
1352 www.example.com/about/
 456 www2.example.com/
```
<br>

### Webサーバーログの時間帯ごとのおおまかなエラーレートを集計する
```
awk '{$2=substr($2,1,13);print $2,$3,$4,$6;}' access.log | sort | uniq -c
```
access.log は以下のようなWebサーバ(nginxなど)のログファイルを想定します。<br>
```
10.229.60.225 2018-02-27T08:40:14+09:00 "GET /path/to/app HTTP/1.1" 200
10.93.104.150 2018-02-27T11:06:47+09:00 "DELETE /path/to/app HTTP/1.1" 200
10.255.181.79 2018-02-27T11:07:47+09:00 "GET /path/to/app HTTP/1.1" 200
10.108.135.104 2018-02-27T14:43:21+09:00 "POST /path/to/app HTTP/1.1" 200
10.209.240.194 2018-02-27T18:39:07+09:00 "POST /path/to/app HTTP/1.1" 502
```
<br>

### fluentdのログを見やすく整形する
```
cat /var/log/td-agent/td-agent.log |awk -F'[:{+]' '{print $4, $5}'|sort |uniq -c
```
<br>

### 自然数の数列をビジュアライズする
```
for i in `seq 0 30`;do echo $RANDOM;done | awk -v scale=1500 -v max=30 '{num=int($1/scale);for(i=0;i<=max;i++){if(i==num){p="o"}else if(I<num){p="| "}else{p=". "};printf p" "};printf "\n\n"}' | rs -T | tail -r | sed -e "s/\./ /g"
```
```
※"for i in `seq 0 30`;do echo $RANDOM;done" は任意の自然数の数列に変更する。 ※scale, maxは任意の自然数に変更する。
```
出力されたログの行数を日付ごとに出したいときなどに、増加傾向にあるのか減少傾向にあるのかチェックするために使用していました。<br>
<br>

### ランダムな大文字小文字英数字を、スピーディにクリップコピーする
```
ruby -e "src = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a ; puts (0...20).map{ src[rand(src.size-1)] }.join" | pbcopy
```
ランダムな大文字小文字英数字の20文字をターミナルに出さずにクリップコピーします。適当な文字列にパッと書き換えたいシーンで利用しています。<br>
<br>

### JMeterによる負荷テスト
```
threads=( cat config/threads); duration=`cat config/duration`; for file in plans/*.jmx; do for thread in ${threads[@]}; do jmeter -n -t ${file} -Jthread=${thread} -Jduration=${duration}; done done
```
<br>

### 物理メモリを多く使用しているプロセスを抽出
```
$ ps aux | sort -n -k 6 | tail -n 10
```
<br>

### CPU使用率が高いプロセスを見つける
```
$ vmstat 1 | awk '{print strftime("%y/%m/%d %H:%M:%S"), $0}'
```
<br>

### ヘッダーとフッターを除外して表示
```
$ cat ファイル名 | sed -e '$d' | awk 'NR > 1 {print}'
```
<br>

### 任意のディレクトリ以下のファイルを検索
```
$ find ./ -name '*'|xargs grep 'xxx'
```
<br>

### ディレクトリ作成後そこへ移動
```
$ mkdir dir_name ; cd $_
```
<br>

### 指定ディレクトリ配下のファイルのパーミッションを見る
```
$ find . -printf "%U %G %m %p\n"
```
<br>

### バックアップ的なやつ
```
$ cp passwd{,.bak}
```
<br>

### パスの最後のスラッシュを削除(じゃなければ何もしない)
```
MYDIR=${MYDIR%/}
```
<br>

### ディレクトリサイズが大きい順で表示
```
$ du -m / --max-depth=3 --exclude="/proc*" | sort -k1 -n -r
```
<br>

### 拡張子を一括変換
```
$ for filename in *.txt; do mv $filename ${filename%.txt}.txt.old; done
# txtからtxt.oldへ変換する
```
<br>

### パスワードをランダム生成する 
```
$ head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''
```
<br>

### 連番ファイルの作成
```
$ touch foo_{1..30}.txt
$ touch {A..Z}.txt
```
<br>

### 定期的にコマンドを実行
```
$ while true; do `sleep 1; say hello`; done
```
<br>

### ファイル名を指定してファイルを保存する curl
```
$ curl -o foo.txt https://hoge.com/fuga.txt -o bar.txt https://piyo.com/hogera.txt
```
<br>

### sortとuniqのイディオム
```
$ .. | sort | uniq -c | sort -nr
```
<br>

### .DS_storeを一括削除
```
$ find . -name '.DS_Store' -type f -ls -delete
```
<br>

### 並列化してxargs
```
echo "aaa" "iii" | xargs -r -n 1 -P 2 echo "Output:"
```
<br>

### ストップウォッチ的なやつ
```
$ time read
# Ctrl + Dを押したら止まる。
```
<br>

### シスログsyslogを時間指定で見る
```
$ awk -F - '"開始時間" < $1 && $1 <= "終了時間"' /抽出を行うログのPATH
```
<br>

### 文字列を抜き出す
```
$ echo 'abcde' | awk '{print substr($0, 2)}'
```
<br>

### あるディレクトリ配下のファイルを一括コピー
```
$ for txt in $(find . -name *.txt); do cp -ip ${txt} ~/work/ ; done
```
<br>

### 定期的にプロセス状態を監視
```
$ while true ; do ps aux | grep httpd ; echo ""; sleep 2 ; done ;
# watchあるならそっちでも。ログ見やすいから個人的にはこっち
```
<br>

### タイムスタンプつきでtailf
```
tailf file | while read; do echo "$(date +%T.%N) $REPLY"; done
```
<br>

### 表示整形 column
```
$ mount | column -t
```
<br>

### grepする時間を指定して出力がなければエラー終了
```
$ timeout 5 tailf hoge.txt | grep -q --line-buffered "hoge"
```
<br>

### ユーザ毎のCPU使用率を見る
```
$ ps aux | awk '{ if(NR>1){p[$1] += $3; n[$1]++ }}END{for(i in p) print p[i], n[i], i}'
```
<br>

## AWKつかうやつ
### 文字数/単語数をカウントする
```
# 文字数カウント(wc -c)
$ awk '{n+=length($0)} END{print n}' filename

# 単語数カウント(wc -w)
$ awk '{n+=NF} END{print n}' filename

# 行数カウント(wc -l)
$ awk 'END{print NR}' filename
```
<br>

### 指定行から指定行まで表示
```
$ awk 'NR==10,NR==20'
```
<br>

### 奇数/偶数行のみ表示
```
# 奇数行
$ awk 'NR%2' filename

# 偶数行
$ awk 'NR%2==0' filename
```
<br>

### プロセス名で一括kill
```
$ kill `ps -aux | grep "プロセス名" | awk '{print $2;}'`
``` 
<br>

### 20:00に/home/hoge/test.txt（空ファイル）を作成するように登録する
```
$ at 20:00 -f <(touch /home/hoge/test.txt)
```
<br>

### 20:00に/home/hoge/test.txt（空ファイル）を作成するように登録する例
```
(TIME=date "+%H%M"; while[${TIME} -lt 2000]; do sleep 60; TIME=date “+%H%M”; done; touch /home/hoge/test.txt) &
```
<br>

### cdをしたあとにコマンドを実行し、かつコマンドを実行したシェルはcdしたくない。
```
$ pwd
/Users/watashi_user
$ sh -c "cd /tmp/; pwd"
/tmp
$ pwd
/Users/watashi_user
```
```
-cオプションが存在する場合、コマンドはstringから読み取られます。文字列の後に引数がある場合は、$0から始まる位置パラメータに割り当てられます。
```
sudo -i をしたときでもできるのでAWS環境などでは便利<br>
```
$ sudo -i sh -c "cd /tmp/;whoami; pwd"
root
/tmp
```

## ブレース展開を用いたバックアップファイルの作成
```
cp file.txt{,.bk}
```
```
$ # echoが実行されるより前にブレース展開が展開されるため
$ # cpで同じことをした場合、出力結果と同じコマンドが実行されることになる
$ echo cp file.txt{,.bk}
cp file.txt file.txt.bk
```

## ブレース展開を用いたファイル名変更
```
mv file.txt{,.bk}
```
```
$ ls
file.txt
$ mv file.txt{,.bk}
$ ls
file.txt.bk
```

### 今日の日付のディレクトリ、ファイルを作成する
```
$ mkdir $(date +%Y%m%d)
$ touch $(date +%Y%m%d).txt
$ midir $(date +%Y%m%d_%H%M%S) #時分秒
```

### 雑なサンプルCSVの生成
どの列もテキトーに文字列でいいのなら、ブレース展開で適当に生成してxargsで列数ごとに分割してやる。 基本的にはこの方式でだいたい対処できると思う。<br>
```
# csvの場合
echo {a..z}{01..05} | xargs -n 5 | tr \  ,

# tsvの場合
echo {a..z}{01..05} | xargs -n 5 | tr \  $'\t'
```
列の値に制限があるのであれば、ブレース展開で処理しているところを書き換えてやれば対応できるだろう。<br>

### 【 printf 】コマンド――データを整形して表示する
printfという名前のコマンドは複数あり、一つはbashの内部コマンド（ビルトインコマンド、シェルコマンド）、もう一つは外部コマンド（/usr/bin/printf）です。パスなどを指定しないで実行した場合は、ビルトインコマンドのprintfを実行します<br>
数値をカンマ区切り<br>

```
# printf "書式" 値
# （値を書式に従って表示する）
# printf "%X\n" 1234656
# （16進数で123456を表示後、改行する）
# printf "%'d\n" 123456
# （3桁区切りで123456を表示後、改行する）
# printf "%3d\n" 10
# （3桁で10を表示後、改行する）
# printf "%-3d\n" 10
# （3桁で左寄せにして10を表示後、改行する）
# printf "%03d\n" 10
# （先頭を0で埋めた3桁で10を表示後、改行する）

$ printf "%X\n" 1234656
12D6E0
$ printf "%'d\n" 123456
123,456
$ printf "%3d\n" 10
 10
$ printf "%-3d\n" 10
10
$ printf "%03d\n" 10
010
```

## 【 numfmt 】コマンド――数値を読みやすい単位で整形して表示する
「numfmt」は数値を読みやすい単位で整形して表示するコマンドです。「k（キロ）」や「M（メガ）」などの換算も可能です。<br>
　負の数や小数点を含む数も整形できますが、単位換算では正の数だけを受け付けます。<br>
　「numfmt --format="書式" 数値」で、数値を書式に従って整形して表示します。使用できる書式は「%桁数f」と「%'f」です。例えば「--format="%5f"」とすると数値を5桁の幅で表示し、「--format="%'f"」では数値を3桁区切りで表示します。<br>
```
# numfmt --format="書式" 数値
# （数値を%fで指定した書式で表示）
# numfmt --format="%5f" 123
# （123を5桁の幅で表示）
# numfmt --format="%'f" 10000
# （10000を3桁区切りで表示）
# numfmt --format="%'8f" 10000
# （10000を3桁区切りで8桁の幅で表示）
# numfmt --grouping 10000
# （10000をシステムのロケールに従ったスタイルで表示）
$ numfmt --format="%5f" 123
  123
$ numfmt --format="%'f" 10000
10,000
$ numfmt --format="%'8f" 10000
  10,000
$ numfmt --grouping 10000
10,000
```

## scriptコマンドで記録するターミナルログにタイムスタンプを付与する
Teratermログみたいな形式(行の先頭にタイムスタンプが付いてる形式)でターミナルログを記録する方法<br>
```
$ script -fq >(awk '{print strftime("%F %T ") $0}{fflush() }'>> PATH)
```

### (応用例)コマンド実行とセットで使用する
応用で、コマンドの実行と同時にターミナルログを取得するようにもできる。<br>
#### Linuxでのコマンド
```
$ script -fq -c "コマンド" >(awk '{print strftime("%F %T ") $0}{fflush() }'>> PATH)
```
#### Mac(BSD系)でのコマンド
```
script -Fq >(awk '{print strftime("%F %T ") $0}{fflush() }'>> PATH) 'コマンド("などで囲まない)'
```
### (応用例)ssh接続と同時にターミナルログをタイムスタンプ付きで取得
#### Linuxでのコマンド
```
script -fq -c "ssh user@hostname" >(awk '{print strftime("%F %T ") $0}{fflush() }'>> PATH)
```
#### Mac(BSD系)でのコマンド
```
script -Fq >(awk '{print strftime("%F %T ") $0}{fflush() }'>> PATH) "ssh user@hostname"
```
### (応用例)pingの行頭にタイムスタンプを付与する
```
$ ping 8.8.8.8 | awk '{print strftime("%F %T ") $0}{fflush() }'
2020-05-02 10:49:48 PING 8.8.8.8 (8.8.8.8): 56 data bytes
2020-05-02 10:49:48 64 bytes from 8.8.8.8: icmp_seq=0 ttl=55 time=265.068 ms
2020-05-02 10:49:49 64 bytes from 8.8.8.8: icmp_seq=1 ttl=55 time=67.235 ms
2020-05-02 10:49:50 64 bytes from 8.8.8.8: icmp_seq=2 ttl=55 time=127.855 ms
2020-05-02 10:49:51 64 bytes from 8.8.8.8: icmp_seq=3 ttl=55 time=59.600 ms
```
ちなみに、`moreutils`にはtsコマンドというタイムスタンプを付与するコマンドがある。 awkやperlなどで処理するのがめんどくさかったらそちらを使う方法もありかもしれない。<br>

## ssh接続先にローカルのbashrc・vimrcを、ファイルを作らずにリモートのシェルで使用する
bashの場合、シェル起動時に--rcfileオプションでbashrcファイルを指定できるのだが、そこにプロセス置換でローカルのbashrcファイルの内容を渡すことで実現する。<br>
このとき、そのまま渡すと改行やエスケープ、クォーテーションが悪さをするのでbase64にしてssh接続先に渡すようにする。<br>
### Linuxでのコマンド
Linuxでバンドルされてるbase64の場合、-w0を付けないと改行が入ってしまう。<br>
```
ssh -t user@host '
    bash --rcfile <(
        echo -e ' $(cat <(echo "function lvim() { vim -u <(echo "$(cat ~/.vimrc|base64)"|base64 -d) $@ ; }") \
                        ~/dotfiles/{.bashrc,sh_function,sh_alias,bash_prompt} \
                        <(echo -e alias vim=lvim) | \
                        base64 -w0
                   ) ' \
        |base64 -d)'

```

## パラレルにpingを実行して一気にセグメント内の疎通確認を行う
pingを実行する際、xargsで並列にプロセスを立ち上げることで一気に複数ホストへのpingをして、短時間で一気に疎通確認を行える<br>
```
# 192.168.0.1-254に一気にpingをして疎通できたIPアドレスだけ抽出
$ echo 192.168.0.{1..254} | xargs -P254 -n1 ping -s1 -c1 -w1 | grep ttl | sort -V -k4
```

## ls -l のファイルの合計サイズを簡単に計算する awk
```
# ls -l messages*
-rw---- 1 root root  572080 Dec 13 04:02 messages.4
-rw---- 1 root root  975690 Dec 20 04:02 messages.3
-rw---- 1 root root 1021894 Dec 27 04:02 messages.2
-rw---- 1 root root  953634 Jan  3 04:02 messages.1
-rw---- 1 root root  474283 Jan  6 22:16 messages
```
標準出力された結果から、ファイルサイズが表示されたカラムが左から何番目か確認します。この例の場合、５番目になります。確認できたら、先程のlsコマンドの後にパイプをつけ、下記の様にawkコマンドに 渡します。<br>
```
# ls -l messages* | awk '{i+=$5}END{print i}'
3997581
```

## 数字数値文字列をKB MB GB等 数値の整形・カンマ挿入・単位変換を行う numfmt
http://x68000.q-e-d.net/~68user/unix/pickup?numfmt<br>
numfmt コマンドに --to=iec を渡すことで、下記のように K・M・G 接頭辞を追加してくれる。<br>
```
% du -s -b /usr/* | numfmt --to=iec
538M /usr/bin
21M /usr/include
968M /usr/lib
2.5G /usr/local
3.7M /usr/sbin
2.4G /usr/share
```
サイズ順にソートしたい場合は、sort -n で数値としてソートしてから numfmt コマンドで変換すればよい。<br>
```
% du -s /usr/* | sort -n | numfmt --to=iec
3.7M /usr/sbin
21M /usr/include
538M /usr/bin
968M /usr/lib
2.4G /usr/share
2.5G /usr/local
```
