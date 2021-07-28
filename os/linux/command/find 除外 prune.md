```
$ find . -name .git -prune -o -print
```
というようなのがあります。<br>
findコマンドでたまに使われる用法ですが、「その前の条件に当てはまるものは検索対象から除外」というオプションですね。<br>
上記の例だと「名前が.gitであるものは検索対象から外し、そうでなければ(-o)プリントアウトする(-print)」ということで、つまりは今のディレクトリ以下の.gitディレクトリを除いた全てのファイルを表示するコマンドになります。<br>

下記と同じ<br>
```
$ find . -not -name .git
```

```
[root tmp]# ls -l
合計 0
-rw-r--r-- 1 root root 0  7月 28 17:24 aaa
-rw-r--r-- 1 root root 0  7月 28 17:24 aaa.txt
-rw-r--r-- 1 root root 0  7月 28 17:37 bbb
[root tmp]# find . -name aaa -prune
./aaa
[root tmp]# find . -name aaa -prune -o -print
.
./aaa.txt
./bbb
[root tmp]# find . -not -name aaa
.
./aaa.txt
./bbb
[root tmp]# find . -name "aaa*" -prune -o -print
.
./bbb
[root tmp]# find . -not -name "aaa*"
.
./bbb
```
