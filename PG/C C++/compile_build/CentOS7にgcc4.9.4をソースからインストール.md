## [【CentOS7】gccをソースからインストール](https://www.server-memo.net/memo/gcc-install.html)
## [CentOS 7にgcc 4.9をインストール（SCL）](https://qiita.com/witchcraze/items/b9aa3dc6789cb90b8268) devtoolset

### 1. ソースダウンロード＆展開
https://gcc.gnu.org/mirrors.html<br>
↓ ミラー<br>
http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/<br>
<pre>
$ wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-4.9.4/gcc-4.9.4.tar.gz
$ tar xf gcc-4.9.4.tar.gz
$ cd /usr/local/src/gcc-8.2.0/
</pre>

### 2. 依存ライブラリのダウンロード
<pre>
 ./contrib/download_prerequisites
2019-02-25 23:17:31 URL: ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.1.0.tar.bz2 [2383840] -> "./gmp-6.1.0.tar.bz2" [1]
2019-02-25 23:17:36 URL: ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2 [1279284] -> "./mpfr-3.1.4.tar.bz2" [1]
2019-02-25 23:17:41 URL: ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz [669925] -> "./mpc-1.0.3.tar.gz" [1]
2019-02-25 23:17:46 URL: ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2 [1658291] -> "./isl-0.18.tar.bz2" [1]
gmp-6.1.0.tar.bz2: OK
mpfr-3.1.4.tar.bz2: OK
mpc-1.0.3.tar.gz: OK
isl-0.18.tar.bz2: OK
All prerequisites downloaded successfully.
</pre>

<pre>
--2020-12-05 05:18:41--  ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2
           => `mpfr-2.4.2.tar.bz2'
gcc.gnu.org (gcc.gnu.org) をDNSに問いあわせています... 失敗しました: 名前またはサービスが不明です.
wget: ホストアドレス `gcc.gnu.org' を解決できませんでした。
</pre>
となった場合は`contrib/download_prerequisites`をエディタで編集し`ftp://`→`http://`とする。<br>

### configure make make install
<pre>
# mkdir build
# cd build
# ../configure --enable-languages=c,c++ --prefix=/usr/local --disable-bootstrap --disable-multilib
# make
# make install
</pre>
