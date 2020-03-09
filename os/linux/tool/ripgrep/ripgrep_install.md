[BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep/releases)<br/>

<pre>
root:x:0:0:root:/root:/bin/bash
@~# cd /usr/local/src/
@/usr/local/src# wget -c https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz
--2020-03-09 14:46:16--  https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz
長さ: 2224246 (2.1M) [application/octet-stream]
`ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz' に保存中

ripgrep-11.0.2-x86_64-unknown-l 100%[=======================================================>]   2.12M   400KB/s    時間 8.8s  

2020-03-09 14:46:27 (245 KB/s) - `ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz' へ保存完了 [2224246/2224246]

@/usr/local/src# ll
合計 5412
drwxr-xr-x  3 root root    4096  3月  9 14:46 ./
drwxr-xr-x 10 root root    4096  3月  9 13:48 ../
-rw-r--r--  1 root root 2224246  8月  2  2019 ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz
@/usr/local/src# tar xf ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz 
@/usr/local/src# ll ripgrep-11.0.2-x86_64-unknown-linux-musl
合計 5480
drwxrwxr-x 4 2000 2000    4096  8月  2  2019 ./
drwxr-xr-x 4 root root    4096  3月  9 14:46 ../
-rw-rw-r-- 1 2000 2000     126  8月  2  2019 COPYING
-rw-rw-r-- 1 2000 2000    1081  8月  2  2019 LICENSE-MIT
-rw-rw-r-- 1 2000 2000   17250  8月  2  2019 README.md
-rw-rw-r-- 1 2000 2000    1211  8月  2  2019 UNLICENSE
drwxrwxr-x 2 2000 2000    4096  8月  2  2019 complete/
drwxrwxr-x 2 2000 2000    4096  8月  2  2019 doc/
-rwxr-xr-x 1 2000 2000 5561824  8月  2  2019 rg*
@/usr/local/src# ln -s /usr/local/src/ripgrep-11.0.2-x86_64-unknown-linux-musl/rg /usr/local/bin/rg
@/usr/local/src# which rg
/usr/local/bin/rg
@/usr/local/src#
</pre>
