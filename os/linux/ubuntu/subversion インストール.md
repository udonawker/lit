クライアントのみ<br/>
<pre>
# sudo apt-get install subversion
</pre>


引用<br/>
## [Subversion:インストール](http://wisdomtrees.net/?p=271)

<pre>
$ sudo apt-get install subversion subversion-tools libapache2-svn
</pre>

subversion-toolsはリポジトリのバックアップやファイルのマージ等を行うツール群がパッケージされています。<br/>
libapache2-svnはリポジトリをApache2を利用して公開するためのパッケージという事です。<br/>

## Subversion:設定

インストールが終わったら、Subversionリポジトリをウェブサーバーで公開できるようにApache2の設定をしましょう。<br/>

<pre>
$ sudo vim /etc/apache2/mods-enabled/dav_svn.conf
</pre>

開いてみるとほぼ全文コメントアウトみたいな状態だと思います。<br/>
該当箇所だけコメントアウトを外すのは面倒くさいので、ファイルの一番下に<br/>

<pre>
&lt;Location /svn&gt;
  DAV svn
  SVNParentPath /home/svn
&lt;/Location&gt;
</pre>

を追記してあげるといいと思います。<br/>
終わったら設定反映の為にApacheの再起動<br/>

<pre>
$ sudo apache2ctl restart
</pre>

## Subversion:リポジトリの作成

さて設定が終わったので早速リポジトリを作成しましょう。<br/>

リポジトリの場所は本来好きな場所に設定する事ができますが、<br/>
上の方でApache2のSVN用公開ディレクトリを<br/>
`SVNParentPath /home/svn` <br/>
に設定していますのでココにディレクトリを作成し、リポジトリを作ります。<br/>

<pre>
$ sudo mkdir /home/svn/
$ cd /home/svn/
$ sudo svnadmin create test
</pre>
`svnadmin create リポジトリ名`

を実行すると自動的にSubversionを使うにあたって必要なファイル郡が作成されます。<br/>

### Subversionファイル郡のユーザーグループ設定

このままではsudoによりroot権限でリポジトリ「test」を作成してしまった手前、Apache2の権限ではSubversionファイル郡に触れる事ができません。<br/>
のでユーザーを変更してあげる必要があります。<br/>
ちなみにApache2はwww-dataというユーザーで動いていますので～<br/>

<pre>
$ sudo chown -R www-data:www-data test
</pre>

`chown -R`
の-Rでディレクトリの中のすべてのディレクトリ、ファイルを一度にユーザー:www-data,グループ:www-dataに変更してしまう事ができます。<br/>
後はsvnコマンドのimportやcheckoutオプションを使ってファイルのインポートやチェックアウトが可能になります。<br/>

## Subversion:運用の参考
### 参考：インポート

<pre>
$ cd
$ mkdir test
$ cd test
$ cat > test
aaa
bb
ccc
^D
$ cd ../
$ svn import test/  http://localhost/svn/test/ -m "import test"
追加しています              test/test
</pre>

### 参考：チェックアウト

<pre>
$ svn checkout http://localhost/svn/test
A    test/test
リビジョン 1 をチェックアウトしました
</pre>

また、Apache2によってwebserver上にリポジトリが公開されていますのでブラウザ等を開き、アドレス欄にdomain/svn/リポジトリ名/と入力<br/>
（先ほどの例ではdomain/svn/test/になりますね。) <br/>
する事でインポートしたファイルの一覧を見ることができるようになっています。<br/>

Linux自体から参照する場合は当然、http://localhost/svn/test/に<br/>
またIPで示すならばlocalhostを表わす http://127.0.0.1/svn/test/で<br/>
リポジトリを参照する事ができます。<br/>
<br/>
Windowsからチェックアウトする時にはTortoiseSVNなどを使ってチェックアウトしてあげるとはかどります。<br/>
