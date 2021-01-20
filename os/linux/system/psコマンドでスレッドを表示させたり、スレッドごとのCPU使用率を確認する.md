## [psコマンドでスレッドを表示させたり、スレッドごとのCPU使用率を確認する](https://www.na3.jp/entry/20101219/p1)

### 普通に"ps -ef"を実行
<pre>
$ ps -ef | grep -e mysqld -e PID | grep -v grep
UID        PID  PPID  C STIME TTY          TIME CMD
root      4570     1  0 Dec09 ?        00:00:00 /bin/sh /usr/bin/mysqld_safe
mysql     4606  4570 10 Dec09 ?        1-01:24:14 /usr/sbin/mysqld
</pre>

### -Lオプションを付けて実行
↓のような感じでmysqldがスレッド単位で表示されました。<br>
NLWP(スレッド数)も表示されていますね。<br>
<pre>
$ ps -efL | grep -e mysqld -e PID | grep -v grep
UID        PID  PPID   LWP  C NLWP STIME TTY          TIME CMD
root      4570     1  4570  0    1 Dec09 ?        00:00:00 /bin/sh /usr/bin/mysqld_safe
mysql     4606  4570  4606  0   12 Dec09 ?        00:00:02 /usr/sbin/mysqld
mysql     4606  4570  4608  0   12 Dec09 ?        00:00:00 /usr/sbin/mysqld
mysql     4606  4570  4609  0   12 Dec09 ?        00:00:05 /usr/sbin/mysqld
mysql     4606  4570  4610  0   12 Dec09 ?        00:03:37 /usr/sbin/mysqld
mysql     4606  4570  4611  0   12 Dec09 ?        00:15:21 /usr/sbin/mysqld
mysql     4606  4570  4615  0   12 Dec09 ?        00:00:00 /usr/sbin/mysqld
mysql     4606  4570  4616  0   12 Dec09 ?        00:00:03 /usr/sbin/mysqld
mysql     4606  4570  4617  0   12 Dec09 ?        00:17:35 /usr/sbin/mysqld
mysql     4606  4570  4618  0   12 Dec09 ?        01:20:07 /usr/sbin/mysqld
mysql     4606  4570  4619  3   12 Dec09 ?        08:11:25 /usr/sbin/mysqld
mysql     4606  4570  4620  6   12 Dec09 ?        15:15:46 /usr/sbin/mysqld
mysql     4606  4570  4631  0   12 Dec09 ?        00:00:16 /usr/sbin/mysqld
</pre>

### CPU使用率なんかも見たい場合
"ps auxww"などではCPUやメモリの利用状況も表示されますよね。<br>

<pre>
$ ps auxww | grep -e mysqld -e PID | grep -v grep
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      4570  0.0  0.0  63828  1212 ?        S    Dec09   0:00 /bin/sh /usr/bin/mysqld_safe
mysql     4606 10.2 28.4 7238080 7012620 ?     Sl   Dec09 1524:33 /usr/sbin/mysqld
</pre>

### スレッド単位でCPU使用率も表示させる
ということで、これも"-L"オプションを付けて実行してやることで、↓のようにスレッド単位でのCPU使用率を確認することが出来ます。なるほどねー。<br>

<pre>
$ ps auxww -L | grep -e mysqld -e PID | grep -v grep
USER       PID   LWP %CPU NLWP %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      4570  4570  0.0    1  0.0  63828  1212 ?        S    Dec09   0:00 /bin/sh /usr/bin/mysqld_safe
mysql     4606  4606  0.0   12 28.4 7238080 7012620 ?     Sl   Dec09   0:02 /usr/sbin/mysqld
mysql     4606  4608  0.0   12 28.4 7238080 7012620 ?     Sl   Dec09   0:00 /usr/sbin/mysqld
mysql     4606  4609  0.0   12 28.4 7238080 7012620 ?     Sl   Dec09   0:05 /usr/sbin/mysqld
mysql     4606  4610  0.0   12 28.4 7238080 7012620 ?     Sl   Dec09   3:37 /usr/sbin/mysqld
mysql     4606  4611  0.1   12 28.4 7238080 7012620 ?     Sl   Dec09  15:21 /usr/sbin/mysqld
mysql     4606  4615  0.0   12 28.4 7238080 7012620 ?     Sl   Dec09   0:00 /usr/sbin/mysqld
mysql     4606  4616  0.0   12 28.4 7238080 7012620 ?     Sl   Dec09   0:03 /usr/sbin/mysqld
mysql     4606  4617  0.1   12 28.4 7238080 7012620 ?     Sl   Dec09  17:35 /usr/sbin/mysqld
mysql     4606  4618  0.5   12 28.4 7238080 7012620 ?     Sl   Dec09  80:08 /usr/sbin/mysqld
mysql     4606  4619  3.3   12 28.4 7238080 7012620 ?     Sl   Dec09 491:33 /usr/sbin/mysqld
mysql     4606  4620  6.1   12 28.4 7238080 7012620 ?     Sl   Dec09 916:02 /usr/sbin/mysqld
mysql     4606  4631  0.0   12 28.4 7238080 7012620 ?     Sl   Dec09   0:16 /usr/sbin/mysqld
</pre>
ちなみにmanの通りですが、"-L"オプションだけではなく"H"オプションなどでも表示されます。<br>
