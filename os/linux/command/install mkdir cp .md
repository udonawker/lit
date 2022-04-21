## [installコマンドでコマンド数を減らす](https://blog.n-z.jp/blog/2014-02-14-install.html)

mkdir とか touch とか chown とか chmod とか個別に実行しなくても install コマンドだけでまとめて出来るという話です。<br>

## 問題例
Dockerfile の RUN などが典型的な例ですが、他でも例えば `mkdir -p /home/foo/.ssh; chown foo /home/foo/.ssh; chmod 0700 /home/foo/.ssh` のようなことをすることがあると思います。<br>

## install でディレクトリを作る
```
 mkdir -p /home/foo/.ssh
 chown foo /home/foo/.ssh
 chgrp users /home/foo/.ssh
 chmod 0700 /home/foo/.ssh
```
なら `install -o foo -g users -m 0700 -d /home/foo/.ssh` にまとめられます。<br>

`install -o foo -g users -m 0700 -d /home/foo/.ssh /home/foo/tmp` のように複数ディレクトリを同時に作成することも出来ます。<br>

## install でファイルをコピーする
```
 cp /path/from/*.txt /path/to/
 chown foo /path/to/*.txt
 chgrp users /path/to/*.txt
 chmod 0644 /path/to/*.txt
```
なら `install -o foo -g users -m 0644 /path/from/*.txt /path/to/` にまとめられます。<br>
1ファイルだけなら `install -o foo -g users -m 0644 /path/from/foo.txt /path/to/bar.txt` のようにコピー先のファイル名を指定することも出来ます。<br>
