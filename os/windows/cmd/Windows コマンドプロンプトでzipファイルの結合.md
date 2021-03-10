## [Windows コマンドプロンプトでzipファイルの結合](https://qiita.com/ichigobambi/items/55574fc9341552cc7a1a)<br/>
## [Windowsのコマンドでファイルを結合する 2018/10/7](https://qiita.com/5zm/items/6688ded69d2ddc4bec10)

### `copy /b` コマンドで結合<br/>
bunkatsu.zip.001<br/>
bunkatsu.zip.002<br/>
bunkatsu.zip.003<br/>
とを結合する場合<br/>
<pre>
copy /b bunkatsu.zip.001+bunkatsu.zip.002+bunkatsu.zip.003 ketsugou.zip
</pre>



### Linux<br/>
$ cat file1 file2 file3 > out_file
</pre>

### ディレクトリ配下の１つのファイルに結合するコマンド
```
C:\tmp>copy /b C:\tmp\data\*.txt C:\tmp\all.txt
C:\tmp\data\A.txt
C:\tmp\data\B.txt
C:\tmp\data\C.txt
        1 個のファイルをコピーしました。

C:\tmp>
```

### 指定したファイルを１つのファイルに結合するコマンド
```
C:\tmp>copy /b A.txt + B.txt + C.txt ABC.txt
A.txt
B.txt
C.txt
        1 個のファイルをコピーしました。

C:\tmp>
```
