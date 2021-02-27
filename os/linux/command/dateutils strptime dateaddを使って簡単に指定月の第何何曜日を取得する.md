## [dateutilsを使って簡単に指定月の第何何曜日を取得する](https://orebibou.com/ja/home/201511/20151127_001/)

## 1.インストール
インストールは、RHEL系だとコンパイルが必要のようだ。<br>
以下のコマンドを実行する。<br>
```
wget https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-0.3.4.tar.xz
tar xvf dateutils-0.3.4.tar.xz
cd dateutils-0.3.4
./configure
make
make install
```

Ubuntuの場合、apt-getでインストールできる。<br>
```
sudo apt-get install dateutils
```

## 2.コマンドの実行
以下のように実行する事で、指定した月の第何何曜日を取得できる。<br>
```
dateconv YYYY-MM-何週目か-曜日 -i "%Y-%m-%c-%a" -f '%Y/%m/%d'
```
```
[root@test-centos7 ~]# dateconv 2015-01-03-Mon -i "%Y-%m-%c-%a" -f '%Y/%m/%d'
2015/01/19
[root@test-centos7 ~]# cal 01 2015
      1月 2015
日 月 火 水 木 金 土
             1  2  3
 4  5  6  7  8  9 10
11 12 13 14 15 16 17
18 19 20 21 22 23 24
25 26 27 28 29 30 31

[root@test-centos7 ~]#
[root@test-centos7 ~]# dateconv 2015-11-03-Mon -i "%Y-%m-%c-%a" -f '%Y/%m/%d'
2015/11/16
[root@test-centos7 ~]# cal 11 2015
      11月 2015
日 月 火 水 木 金 土
 1  2  3  4  5  6  7
 8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29 30
```
