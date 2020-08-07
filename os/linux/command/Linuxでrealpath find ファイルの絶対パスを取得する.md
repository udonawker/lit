## [ファイルの絶対パスを取得する](https://staffblog.amelieff.jp/entry/2018/05/30/094427)

### readlinkコマンド
<pre>
$ readlink -f hoge.sam
</pre>
readlinkコマンドは、シンボリックリンクに対してオプションを付けずに実行すると、リンクの実体の絶対パスを返すコマンドです。 -fを指定すると、ファイルの絶対パスが得られました。<br>

### findコマンド
<pre>
$ find `pwd` -name "hoge.sam"
/home/user/anaysis/hoge.sam
</pre>
findに与える検索場所に、まさかpwdコマンドを与えられるとは、知りませんでした。<br>
ちなみに、findはディレクトリの中を再帰的に検索するので、作業ディレクトリの中のディレクトリに同名のファイルがあると、そのファイルも出てきてしまいます。<br>

<pre>
$ find `pwd` -name "hoge.sam"
/home/user/anaysis/hoge.sam
/home/user/anaysis/test/hoge.sam
</pre>
これを防ぐためには、findが検索するディレクトリの深さを指定します。<br.

<pre>
$ find `pwd` -mindepth -maxdepth 1 -name "hoge.sam"
/home/user/anaysis/hoge.sam
</pre>

## 使い分け
readlink -fのほうが、圧倒的に短く簡便そうなので、もうreadlinkだけでいいように思えたので、最初はこの記事もreadlinkだけで終わらせる予定でした。<br>
しかし、複数のファイルの絶対パスをまとめて取得したいときに、readlinkが使いにくいことに気づきました。<br>

<pre>
$ ls *.fastq
sampleA.fastq
sampleB.fastq
sampleC.fastq
sampleD.fastq
$ readlink *.fastq
readlink: extra operand 'filname.txt'
詳しくは `readlink --help' を実行して下さい.
</pre>
どうやらワイルドカードを使うと、よくわからない挙動をするようです。 一方findコマンドは、ファイル名にワイルドカードを指定すると、下記のような結果を返します。<br>

<pre>
$ find `pwd` -name "*fastq"
/home/user/anaysis/sampleA.fastq
/home/user/anaysis/sampleB.fastq
/home/user/anaysis/sampleC.fastq
/home/user/anaysis/sampleD.fastq
</pre>
状況に合わせて、使いやすいほうを選択するとよさそうですね！
