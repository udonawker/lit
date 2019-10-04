参考<br/>
[manコマンドの出力結果を日本語化する](https://linuxserver.jp/linux/man%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%81%AE%E5%87%BA%E5%8A%9B%E7%B5%90%E6%9E%9C%E3%82%92%E6%97%A5%E6%9C%AC%E8%AA%9E%E5%8C%96%E3%81%99%E3%82%8B/) <br/>
[manコマンドの表示を日本語にする方法](https://webkaru.net/linux/man-locale-jp/) <br/>

### 環境変数LANGの確認

シェル内で日本語を扱うには、環境変数LANGに日本語が設定されている必要があります。<br/>

<pre>
[root@centos ~]# echo $LANG
en_US.UTF-8    ※日本語ではなく英語に設定されている
</pre>

このように日本語以外の言語が$LANGに設定されている場合は下記のようにして日本語に変更します。<br/>

<pre>
[root@centos ~]# locale -a | grep ja    ※利用可能な日本語と文字コードを確認
ja_JP
ja_JP.eucjp
ja_JP.ujis
ja_JP.utf8
japanese
japanese.euc
[root@centos ~]# export LANG=ja_JP.utf8    ※一覧から日本語(UTF-8)を選んで変更する
[root@centos ~]# echo $LANG
ja_JP.utf8    ※設定が反映された
</pre>

また”ja_JP.utf8″は、下記の様な意味をもちます。<br/>
- ja
    - : 日本語という言語
- JP
    - : 日本という国、地域
- utf8
    - : 使用する文字コードとしてUTF-8を使う

これでmanコマンドの出力が日本語化されます。<br/>
※ただし、日本語のmanページが用意されていないコマンドでは日本語化されません。<br/>

<pre>
[root@centos ~]# man man
man(1)                                                                  man(1)

名前
       man - オンラインマニュアルページを整形し表示する。
       manpath - ユーザー個々のマニュアルページの検索パスを決める。

～略～

[root@centos ~]# date    ※このように他コマンドの出力も日本語化される
2009年 12月 20日 日曜日 15:15:44 JST
</pre>

ここまでの手順で日本語化されない場合は次項も確認しましょう。<br/>

### 環境変数MANPATHの確認

環境変数LANGに日本語を設定してもmanページが日本語化されない場合は、manの検索パスに日本語のmanが格納されているディレクトリが通っていないか、そもそも日本語のmanページがインストールされていないかのどちらかの可能性があります。<br/>
<br/>
まず、日本語のmanページが格納されているディレクトリが存在するかを確認してみます。<br/>

<pre>
[root@centos ~]# whereis man
man: /usr/bin/man /etc/man.config /usr/share/man /usr/share/man/man1/man.1.gz /usr/share/man/man1p/man.1p.gz /usr/share/man/man7/man.7.gz
[root@centos ~]# ll /usr/share/man/ | grep ja
drwxr-xr-x  5 root root   136 11月  2  2008 ja    ※jaというディレクトリがある場合は日本語のmanページはインストールされている
</pre>

jaというディレクトリがあれば日本語のmanページはインストールされています。<br/>
<br/>
続いて、manの検索パスにjaディレクトリへのパスが通っているかどうかを確認します。<br/>

<pre>
[root@centos ~]# manpath
/usr/local/share/man:/usr/share/man/ja:/usr/share/man
</pre>

manpathコマンドは文字通り、manコマンドで表示されるテキストの検索先パス名を表示するコマンドです。<br/>
上記のようにjaディレクトリへのパスが通っていればOKです。<br/>
パスが通っていない場合は下記のようにしてパスを通します。<br/>

<pre>
[root@centos ~]# MANPATH=/usr/local/man/ja:/usr/local/share/man/ja:/usr/share/man/ja:/usr/X11R6/man/ja
[root@centos ~]# export MANPATH
[root@centos ~]# vi .bashrc    ※ログイン時に自動的にセットするようにシェルの設定ファイルに記述(ここではbashの設定ファイルに記述する例)
MANPATH=/usr/local/man/ja:/usr/local/share/man/ja:/usr/share/man/ja:/usr/X11R6/man/ja
export MANPATH
</pre>

または、manの設定ファイル”/etc/man.config（ディストリビューションによって異なります）“に直接記述する方法もあります。<br/>

### 日本語manページ集のインストール

<pre>
[root@centos ~]# yum -y install man-pages-ja
</pre>

<pre>
[root@centos ~]# apt-get install manpages-ja
</pre>
