# tar zxvf archive.tgz file.txt -C /home/xxxx/
archive.tgz内のfile.txtを/home/xxxx/に解凍

<pre>
hoge.tar.gz
  hoge/
    001/
      001.txt
    002/
      002.txt

の場合
tar xvfz hoge.tar.gz hoge/001/001.txt
↓
./hoge/
  001/
    001.txt

tar xvfz hoge.tar.gz hoge/001/aaa.txt (-C .) --strip-components 2
↓
./001.txt

<pre>
カレントディレクトリに展開
$ tar xzvf hoge.tar.gz

ディレクトリ(フォルダ)「/root/tenkai」内に展開する。
$ tar xzvf hoge.tar.gz -C /root/tenkai

★★★
拡張子が「txt」のファイルのみをディレクトリ(フォルダ)「/root/tenkai」内に展開する。
$ tar xzvf hoge.tar.gz -C /root/tenkai *.txt

</pre>

引用 
[tarバックアップから一部のディレクトリ・ファイルを取り出す](http://tesiri.hateblo.jp/entry/2015/02/22/090248 "tarバックアップから一部のディレクトリ・ファイルを取り出す")

<pre>
tarバックアップから一部のディレクトリ・ファイルを取り出す
sasaki - Fri, 2009-01-23 10:20
朝会社に到着すると、「昨日のバックアップからfooディレクトリ以下のファイルを復活させて欲しい！」と言われた。

毎晩、Webサイトのpublic_htmlを丸ごとtarでバックアップしておいて良かったと思う。

しかし、Webサイトは細かいファイルが約20,000ほどあり、tarで固めたファイルサイズは2GB弱あるので、解凍するにも時間がかかってしまう。

 

そこで、一部のディレクトリ、あるいはファイルを取り出す方法をメモしておく。

（Solarisでは、/usr/sfw/bin/gtar 等、GNUのtarを使うことをお勧め）

 

■ディレクトリ名、ファイル名を確認する
必要であれば、ファイルの情報を見る。tオプションを使えば、解凍せずにファイル名を一覧できるので便利。

$ tar tvf public_html.tar 
タイムスタンプの情報が必要なければ、tar tf public_html.tar というように vオプションを省くとシンプルな表示になるのでお勧め。

 

■あるディレクトリ以下のファイルを取得する
fooディレクトリが、public_html/foo/として存在している場合。

$ tar xvf public_html.tar *foo  
ディレクトリfooの前に*を付けている理由は、

public_html/foo/index.html

public_html/foo/bar/index.html

public_html/foo/bar/baz/index.html

のようにpublic_html/以下に保存されているため。

 

■ファイルを1つだけ取得する
tar tvf public_html.tar で確認して、ファイル名が確実に分かっている場合。

$ tar xvf public_html.tar public_html/foo/bar/index.html
 

■gzipで固められているtar.gzファイルから一部のディレクトリを戻す
実際には、tarではなく、tar.gzファイルから取り出すことも多い。

1. 確認作業

$ gunzip -c public_html.tar.gz | tar tvf -
 

2. fooディレクトリを抽出する

$ gunzip -c public_html.tar.gz | tar xvf - *foo
 

3. public_html/foo/bar/index.htmlを取り出す

$ gunzip -c public_html.tar.gz | tar xvf - public_html/foo/bar/index.html
 

gunzip の -cオプションを使えば、ファイルに出力せずにtarコマンドへ渡すことができるのでスピーディーに作業を完了させることができる。
</pre>
