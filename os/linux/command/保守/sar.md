## インストール
<pre>
# redhat
$ sudo yum install sysstat
# ubuntu
$ sudo apt-get install sysstat
</pre>

## 有効化
<pre>
# redhat
$ sudo systemctl start sysstat
# ubuntu
# /etc/default/sysstat
# ENABLED="true" とする
</pre>

## ファイル
<pre>
# redhat
/var/log/sa
# ubuntu
/var/log/sysstat
</pre>

## サンプル
<pre>
sar -b // ディスク関連の情報を表示
sar -P ALL // CPU情報全表示
sar -r /var/log/sysstat/sa09 // ファイルを指定してメモリ情報(9日の)
</pre>

## オプション
|オプション|説明|
|:--|:--|
|-A|全項目を表示|
|-b|ディスク関連の情報を表示|
|-c|プロセスの生成回数を表示|
|-n DEV|ネットワーク関連の情報を表示|
|-r|メモリ,スワップ関連の情報を表示|
|-u|CPU関連の情報表示(オプション無しの場合と同じ)|
|-P id/ALL|CPU毎の情報を表示|
|-R|メモリの統計情報を表示|
|-W|スワップの情報を表示|

## ディスク関連
<pre>
# sar -b -f /var/log/sa/sa11 
Linux 3.10.0-957.12.2.el7.x86_64 (webapp1)  09/11/2019  _x86_64_    (1 CPU)

12:56:18 PM       LINUX RESTART

01:00:01 PM       tps      rtps      wtps   bread/s   bwrtn/s
01:10:01 PM    166.00     85.35     80.65   6122.16   2065.23
01:20:01 PM      2.04      1.38      0.66    127.12     17.91
01:30:01 PM      0.13      0.06      0.07      4.36      0.80
Average:        54.91     28.34     26.57   2042.62    680.41
</pre>

|項目|説明|
|:--|:--|
|tps|I/O転送リクエスト数/秒|
|rtps|ディスク読み込みリクエスト数/秒|
|wtps|ディスク書き込みリクエスト数/秒|
|bread/s|ディスク読み込みブロック数/秒|
|bwrtn/s|ディスク書き込みブロック数/秒|

## CPU関連
<pre>
# sar -u -f /var/log/sa/sa11 
Linux 3.10.0-957.12.2.el7.x86_64 (webapp1)  09/11/2019  _x86_64_    (1 CPU)

12:56:18 PM       LINUX RESTART

01:00:01 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
01:10:01 PM     all      2.32      0.00      3.36      2.12      0.00     92.19
01:20:01 PM     all      0.03      0.00      0.11      0.02      0.00     99.84
01:30:01 PM     all      0.01      0.00      0.07      0.00      0.00     99.92
Average:        all      0.77      0.00      1.16      0.70      0.00     97.37
</pre>
項目はtopコマンドと同じ<br>

## メモリ関連
<pre>
# sar -r -f /var/log/sa/sa11 
01:00:01 PM kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty
01:10:01 PM     10692    488196     97.86         0     18524   3129288    120.54    204436    208128         0
01:20:01 PM      8832    490056     98.23         0     32320   3129288    120.54    208088    207360         0
01:30:01 PM      7668    491220     98.46         0     33248   3129288    120.54    208396    208048         0
01:40:01 PM      7988    490900     98.40         0     34356   3129288    120.54    209404    206548         0
Average:         8730    490158     98.25         0     30556   3129288    120.54    207957    207310         0
</pre>

|項目|説明|
|:--|:--|
|kbmemfree|空きメモリ（KB）|
|kbmemused|使用中のメモリ（KB）|
|%memused|メモリ使用率|
|kbbuffers|バッファの使用量（KB）|
|kbcached|キャッシュの使用量（KB）|
|kbcommit|現在必要とされているメモリ量（KB）|
|%commit|メモリ総量（RAM＋スワップ）における必要メモリ量の割合|
|kbactive|activeな(利用頻度の高い)メモリ（ページ）|
|kbinact|inactiveな(利用頻度の低い、解放されやすい)メモリ（ページ）|
|kbdirty|dirtyな(ディスクに同期されていない)メモリ（ページ）|

## ネットワーク関連
<pre>
# sar -n DEV -f /var/log/sa/sa11 
Linux 3.10.0-957.12.2.el7.x86_64 (webapp1)  09/11/2019  _x86_64_    (1 CPU)

12:56:18 PM       LINUX RESTART

01:00:01 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
01:10:01 PM      eth0      0.97      0.58      0.07      0.06      0.00      0.00      0.00
01:10:01 PM      eth1      0.44      1.80      0.05      3.11      0.00      0.00      0.00
01:10:01 PM        lo    156.88    156.88     62.74     62.74      0.00      0.00      0.00
01:20:01 PM      eth0      0.18      0.12      0.01      0.01      0.00      0.00      0.00
01:20:01 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
01:20:01 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
01:30:01 PM      eth0      0.09      0.06      0.01      0.01      0.00      0.00      0.00
01:30:01 PM      eth1      0.01      0.00      0.00      0.00      0.00      0.00      0.00
01:30:01 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
01:40:01 PM      eth0      0.54      0.33      0.04      0.03      0.00      0.00      0.00
01:40:01 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
01:40:01 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         eth0      0.44      0.27      0.03      0.03      0.00      0.00      0.00
Average:         eth1      0.11      0.44      0.01      0.76      0.00      0.00      0.00
Average:           lo     38.30     38.30     15.32     15.32      0.00      0.00      0.00
</pre>

|項目|説明|
|:--|:--|
|IFACE|IF名|
|rxpck/s|受信パケット数/秒|
|txpck/s|送信パケット数/秒|
|rxkB/s|受信キロバイト数/秒|
|txkB/s|送信キロバイト数/秒|
|rxcmp/s|圧縮パケットの受信バイト数/秒|
|txcmp/s|圧縮パケットの送信バイト数/秒|
|rxmcst/s|マルチキャストパケットの受信パケット数|


