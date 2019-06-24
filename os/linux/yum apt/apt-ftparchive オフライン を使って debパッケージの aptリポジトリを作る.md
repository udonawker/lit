引用[apt-ftparchive を使って debパッケージの aptリポジトリを作る](http://usamimi.info/~pochi/linux/apt-ftparchive.html "apt-ftparchive を使って debパッケージの aptリポジトリを作る")

## apt-ftparchive を使って debパッケージの aptリポジトリを作る

debian を使う最大の利点は apt によるパッケージ管理です。既存の debパッケージが無かったり自分でパッチを当てたりしてソースコードからビルドする場合でも、debパッケージにまとめて apt で管理すると削除や更新がとてもらくちんになります。<br/>
さて、その作った debパッケージはどこに置いておきましょう？<br/>
<br/>
このページでは debian squeeze で apt-ftparchive を使って debパッケージの aptリポジトリを作る方法をメモしておきます。<br/>
<br/>
apt-ftparchive を使う為にまずは apt-utilsパッケージをインストールします。<br/>

<pre>
$ sudo apt-get install apt-utils
</pre>

そして aptリポジトリを作りたいディレクトリに移動して、debパッケージ作成時に出来たファイルをそこへ放り込み、<br/>

<pre>
$ apt-ftparchive sources . > Sources                                # Sourcesファイルを作る
$ apt-ftparchive packages . > Packages                              # Pakagesファイルを作る
$ apt-ftparchive contents . > Contents-$(dpkg --print-architecture) # Contentsファイルを作る
$ apt-ftparchive release . > Release                                # Releaseファイルを作る
$ gzip -c9 Sources > Sources.gz                                     # Sourcesファイルを gzに圧縮する
$ gzip -c9 Packages > Packages.gz                                   # Pakagesファイルを gzに圧縮する
$ gzip -c9 Contents-$(dpkg --print-architecture) > Contents-$(dpkg --print-architecture).gz # Contentsファイルを gzに圧縮する
$ gpg --sign -b -a -o Release.gpg Release                           # Releaseファイルに GPG署名を作る
</pre>

debian の通常の環境なら gnupgパッケージは既にインストールされていると思います。<br/>
gpg で署名する為には、GnuPG を使って暗号化したり署名したりするを参考にしてあらかじめ自分用にGPGの秘密鍵と公開鍵を作っておきましょう。ちなみにあんまり関係ありませんけどもぽちの公開鍵の Key ID は、ぽち＊ぷ〜ちの各記事の一番下に書いてありますので pgp.nic.ad.jp などの公開鍵サーバから公開鍵を取って来れます。<br/>
<br/>
aptリポジトリを置きたい場所が /var/www/debian/ だと仮定して例を挙げると、ローカルで利用するだけの場合は<br/>
<pre>
deb file:///var/www/debian/ ./
</pre>
Webサーバで公開する場合には<br/>
<pre>
deb http://host/debian/ ./
</pre>
を /etc/apt/sources.list に追記しましょう。<br/>
<br/>
新しく作った aptリポジトリを追記して sudo apt-get update すると署名エラーが出ると思います。<br/>
ローカルで利用するだけなら無視しても問題無いのですが、折角 Release.gpg も作ったので、apt の鍵束に自分の公開鍵をインポートして使いましょう。<br/>
<pre>
$ sudo apt-key add [自分の公開鍵ファイル]
</pre>
動作確認環境 : Debian GNU/Linux 7.0 wheezy<br/>

