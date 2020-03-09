1. 前提: Rustがインストール済みであること
2. [sharkdp/fd](https://github.com/sharkdp/fd/releases)から最新バージョンをダウンロード<br/>
    rootで/usr/local/srcへ<br/>
3. tar.gzを解凍
4. fd-vX.X.X-x86_64-unknown-linux-gnu/fd -> /usr/loca/bin/fd にsoft link

<pre>
@/usr/local/src# wget -c https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz
--2020-03-07 17:29:28--  https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz
github.com (github.com) をDNSに問いあわせています... 52.192.72.89
github.com (github.com)|52.192.72.89|:443 に接続しています... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 302 Found
場所: https://github-production-release-asset-2e65be.s3.amazonaws.com/90793418/80888980-d7f2-11e9-920e-fc36be30c616?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200307%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200307T082929Z&X-Amz-Expires=300&X-Amz-Signature=833600823ced72c205f5832e0464452e20401f2569070f5b6daf3972b21456e8&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dfd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz&response-content-type=application%2Foctet-stream [続く]
--2020-03-07 17:29:29--  https://github-production-release-asset-2e65be.s3.amazonaws.com/90793418/80888980-d7f2-11e9-920e-fc36be30c616?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200307%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200307T082929Z&X-Amz-Expires=300&X-Amz-Signature=833600823ced72c205f5832e0464452e20401f2569070f5b6daf3972b21456e8&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dfd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz&response-content-type=application%2Foctet-stream
github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com) をDNSに問いあわせています... 52.217.15.180
github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.217.15.180|:443 に接続しています... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 200 OK
長さ: 1137018 (1.1M) [application/octet-stream]
`fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz' に保存中

fd-v7.4.0-x86_64-unknown-li 100%[===========================================>]   1.08M   746KB/s    時間 1.5s

2020-03-07 17:29:31 (746 KB/s) - `fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz' へ保存完了 [1137018/1137018]

@/usr/local/src# ll
合計 5696
drwxr-xr-x  3 root root     4096  3月  7 17:29 ./
drwxr-xr-x 10 root root     4096  4月 26  2016 ../
-rw-r--r--  1 root root  1137018  9月 16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz
@/usr/local/src# tar tvf fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz
drwxrwxr-x travis/travis     0 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/autocomplete/
-rw-rw-r-- travis/travis  3804 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/autocomplete/_fd
-rw-rw-r-- travis/travis  4843 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/autocomplete/fd.bash-completion
-rw-rw-r-- travis/travis  3389 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/autocomplete/fd.fish
-rwxrwxr-x travis/travis 2865976 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/fd
-rw-rw-r-- travis/travis    5914 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/fd.1
-rw-rw-r-- travis/travis   10833 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/LICENSE-APACHE
-rw-rw-r-- travis/travis    1023 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/LICENSE-MIT
-rw-rw-r-- travis/travis   18730 2019-09-16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu/README.md
@/usr/local/src# tar xf fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz
@/usr/local/src# ll
合計 5700
drwxr-xr-x  4 root root     4096  3月  7 17:31 ./
drwxr-xr-x 10 root root     4096  4月 26  2016 ../
drwxr-xr-x  3 root root     4096  3月  7 17:31 fd-v7.4.0-x86_64-unknown-linux-gnu/
-rw-r--r--  1 root root  1137018  9月 16 02:53 fd-v7.4.0-x86_64-unknown-linux-gnu.tar.gz
@/usr/local/src# cd fd-v7.4.0-x86_64-unknown-linux-gnu/
@/usr/local/src/fd-v7.4.0-x86_64-unknown-linux-gnu# ll
合計 2856
drwxr-xr-x 3 root root    4096  3月  7 17:31 ./
drwxr-xr-x 4 root root    4096  3月  7 17:31 ../
-rw-rw-r-- 1 2000 2000   10833  9月 16 02:53 LICENSE-APACHE
-rw-rw-r-- 1 2000 2000    1023  9月 16 02:53 LICENSE-MIT
-rw-rw-r-- 1 2000 2000   18730  9月 16 02:53 README.md
drwxrwxr-x 2 2000 2000    4096  9月 16 02:53 autocomplete/
-rwxrwxr-x 1 2000 2000 2865976  9月 16 02:53 fd*
-rw-rw-r-- 1 2000 2000    5914  9月 16 02:53 fd.1
@/usr/local/src/fd-v7.4.0-x86_64-unknown-linux-gnu# fd
プログラム 'fd' はまだインストールされていません。 次のように入力することでインストールできます:
apt install fdclone
@/usr/local/src/fd-v7.4.0-x86_64-unknown-linux-gnu# ./fd
LICENSE-APACHE
LICENSE-MIT
README.md
autocomplete
autocomplete/_fd
autocomplete/fd.bash-completion
autocomplete/fd.fish
fd
fd.1
@/usr/local/src/fd-v7.4.0-x86_64-unknown-linux-gnu# ln -s /usr/local/src/fd-v7.4.0-x86_64-unknown-linux-gnu/fd /usr/local/bin/fd
@/usr/local/src/fd-v7.4.0-x86_64-unknown-linux-gnu# which fd
/usr/local/bin/fd
</pre>
