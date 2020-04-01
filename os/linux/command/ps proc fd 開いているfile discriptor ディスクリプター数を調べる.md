[Linuxでプロセスごとに開いているファイルディスクリプタの数を調べる](https://oishi-kenko.hatenablog.com/entry/2017/11/17/162708)<br/>

## Linuxでプロセスごとに開いているファイルディスクリプタの数を調べる
<pre>
for i in $(ps aux | grep "XXX" | awk '{print $2}'); do  ls /proc/$i/fd | wc -l; done

ls /proc/$(ps aux | grep XXX | grep -v grep | awk '{ print $2 }')/fd
</pre>

## dockerでfile descriptorの数を設定する
検証にはdockerを使います。 起動時に--ulimitというオプションを渡すだけで制限が可能です。 検証用なので極端に小さく設定します。<br/>

<pre>
$ docker run --ulimit="nofile=64" --rm -it ruby:2.4.2-jessie /bin/bash
root@ea6e45c79d10:/# ulimit -n
64
</pre>
