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

### 20:00に/home/hoge/test.txt（空ファイル）を作成するように登録する例
```
(TIME=date "+%H%M"; while[${TIME} -lt 2000]; do sleep 60; TIME=date “+%H%M”; done; touch /home/hoge/test.txt) &
```
