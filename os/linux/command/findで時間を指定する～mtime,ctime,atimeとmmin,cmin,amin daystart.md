[findで時間を指定する～mtime,ctime,atimeとmmin,cmin,amin](https://www.greptips.com/posts/617/)<br/>

<pre>
Numeric arguments can be specified as  
       +n     for greater than n,  
       -n     for less than n,  
       n      for exactly n.  
</pre>

||-n|n|+n|
|:-:|:-:|:-:|:-:|
|time|< n*24|>= n*24,<= (n+1)*24|> (n+1)*24|
|min|< n|>= n,<= n+1|> n+1|

<pre>
mtime +2 更新日が3日より前
mmin +2  更新日が3分より前
mtime +0.5 更新日が36時間より前
</pre>

## from A to Bのように期間を指定するには？
結論: +nと-nを並べて書き、and条件にする<br/>
`-mmin -2880 -mmin +1440`で「更新日時が2日前～1日前のファイル」となる。<br/>

<pre>
$ date
2015年  8月  7日 金曜日 13:45:32 JST
$ ll
合計 0
-rw-r--r-- 1 root root 0  8月  5 13:00 2015 a
-rw-r--r-- 1 root root 0  8月  6 13:00 2015 b
-rw-r--r-- 1 root root 0  8月  7 13:00 2015 c

# 更新日時が2日前までのファイル（2日前～今）
$ find ./* -mmin -2880
./b
./c

# 更新日時が1日前を過ぎたファイル（∞～1日前）
$ find ./* -mmin +1440
./a
./b

# 更新日時が2日前～1日前のファイル
$ find ./* -mmin -2880 -mmin +1440
./b
</pre>

## -daystartオプションの考え方は？

`-daystart`を指定すると、計算基準が今日の 24:00 (= 明日の 0:00)になる。<br/>

<pre>
$ date
2015年  8月  7日 金曜日 14:08:37 JST
$ ll
合計 0
-rw-r--r-- 1 root root 0  8月  7 13:00 2015 c
$ find ./* -mmin +120
$ find ./* -daystart -mmin +120
./c
</pre>
