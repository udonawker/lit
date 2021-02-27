## [GNU tarでアーカイブ内のファイルをgrep(相当の処理を)する](https://orebibou.com/ja/home/202001/20200102_001/)

よく作業用のディレクトリとかを一定期間ごとにtar(+gzip)でアーカイブしてあるのだが、たまに過去のデータを調べるためにそのアーカイブしたファイルの中を検索したい事があったりする。 そういった際にいちいちアーカイブを展開して調べるのは面倒なので、なんかいい方法が無いかなと考えていたところ、どうやらGNU tarだと「--to-command」で指定したコマンドに対し、標準入力でtar内のファイルの中身を渡すことができるらしい。 なので、環境変数でtar内のどのファイルなのかも出力させることができる。<br>
ただ標準入力から受け付けてるので、tar内のどのファイルに指定した文字列が含まれているか？といった場合だと--to-commandにgrepを指定する方式はちょっとめんどくさい。 こういった場合は、↓のようにawkで処理するのが楽みたいだ。<br>

```
tar xf 対象となるアーカイブファイル --to-command "awk '//{printf(\"%s:%s\\n\",ENVIRON[\"TAR_FILENAME\"],\$0)}'"
```

```
$ # アーカイブ内のファイルの一覧を出力
$ tar tf test.tar.gz
a.txt
d.txt
g.txt
$
$ # 行頭にファイル名を付与して中身を出力
$ tar xf /home/blacknon/Work/201912/20191220/work/test.tar.gz --to-command 'sed "s,^,${TAR_FILENAME}: ,g";echo ===='
a.txt: a01 a02 a03 a04 a05
a.txt: b01 b02 b03 b04 b05
a.txt: c01 c02 c03 c04 c05
====
d.txt: d01 d02 d03 d04 d05
d.txt: e01 e02 e03 e04 e05
d.txt: f01 f02 f03 f04 f05
====
g.txt: g01 g02 g03 g04 g05
g.txt: h01 h02 h03 h04 h05
g.txt: i01 i02 i03 i04 i05
====
$
$ # a01で検索
$ tar xf test.tar.gz --to-command "awk '/a01/{printf(\"%s:%s\\n\",ENVIRON[\"TAR_FILENAME\"],\$0)}'"
a.txt:a01 a02 a03 a04 a05
```
