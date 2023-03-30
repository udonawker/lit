## [Linuxコマンド truncate（ファイルを指定したサイズに切り詰める/拡張する）](https://kcfran.com/2021/05/01/linux-command-truncate/)

–c,–no-create	ファイルを作成しない<br>
-r ファイル名,–reference=ファイル名	指定したファイルのサイズを参照する<br>
-s サイズ,–size=サイズ	ファイルサイズを指定する<br>

<br>

サイズを指定してからファイルを作成する<br>
```
$ truncate -s 1MB truncate-1mb.txt 
```

実行結果<br>
```
[centos@xxx work]$ truncate -s 1MB truncate-1mb.txt
[centos@xxx work]$ ls -l
total 0
-rw-rw-r-- 1 centos centos 1000000 May  1 05:37 truncate-1mb.txt
[centos@xxx work]$ 
```

<br>

## テキストのファイルサイズを調整する
テキストファイルを拡張したり切り詰めてみる。<br>

```
$ truncate -s 20 sample.txt
```

実行結果<br>
```
[centos@xxx work]$ cat sample.txt 
sample text

[centos@xxx work]$ ls -l
total 4
-rw-rw-r-- 1 centos centos 13 May  1 05:42 sample.txt
[centos@xxx work]$ truncate -s 20 sample.txt # 20バイトにサイズを拡張する
[centos@xxx work]$ ls -l
total 4
-rw-rw-r-- 1 centos centos 20 May  1 05:42 sample.txt # 13バイトから20バイトに拡張された。
[centos@xxx work]$ cat sample.txt 
sample text

[centos@xxx work]$ truncate -s 10 sample.txt  # 13バイトのテキストファイルを10バイトに切り詰める
[centos@xxx work]$ ls -l
total 4
-rw-rw-r-- 1 centos centos 10 May  1 05:44 sample.txt
[centos@xxx work]$ cat sample.txt # 文字列がカットされている。
sample tex[centos@xxx work]$ 
```
