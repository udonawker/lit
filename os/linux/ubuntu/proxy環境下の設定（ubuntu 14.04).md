## [proxy環境下の設定（ubuntu 14.04)](https://qiita.com/showsuzu/items/9ee031208d38ff8ac889)

### 環境変数の設定
とりあえず、export設定。<br>
.bashrcや、.bash_profileに設定することも可なので、使用頻度や、環境に合わせて設定してもよいと思います。<br>
とりあえずこの設定で大部分はまかなえるかと思います。<br>

<pre>
$ export https_proxy="http://username:password@your.proxy.address:proxy.port/"
$ export http_proxy="http://username:password@your.proxy.address:proxy.port/"
$ export ftp_proxy="http://username:password@your.proxy.address:proxy.port/"
</pre>

### sudo
sudoは一般の環境変数を引き継がないので、configファイルに設定している、http-proxyなどは無視される傾向にあります。<br>
以下のように、-E を付加すれば、環境変数が引き継ぐ事ができます。<br>

<pre>
$ sudo -E apt-add-repository ppa:.....
$ sudo -E apt-get update
$ sudo -E apt-get install subversion
</pre>

### apt-getの場合
環境変数(http_proxy,ftp_proxy等)に設定する方法と、/etc/apt/apt.confに設定する方法の2パターンがあります。<br>
両方に設定されている場合は、apt.confのものが有効になるようです。<br>
<br>
環境変数の設定を行う場合は、前述の記載を参照。<br>
/etc/apt/apt.confに設定する場合は、apt.confに以下の行を追加します。<br>

<pre>
Acquire::ftp::proxy "ftp://username:password@your.proxy.address:proxy.port/";
Acquire::http::proxy "http://username:password@your.proxy.address:proxy.port/";
Acquire::https::proxy "https://username:password@your.proxy.address:proxy.port/";
</pre>

### wgetの場合
/etc/wgetrc を編集します。<br>

<pre>
https_proxy = http://username:password@your.proxy.address:proxy.port/
http_proxy = http://username:password@your.proxy.address:proxy.port/
ftp_proxy = http://username:password@your.proxy.address:proxy.port/
</pre>

### gitの場合
~/.gitconfig ファイルのhttpの項目に次の設定を追加します。<br>

<pre>
[http]
proxy = http://username:password@your.proxy.address:proxy.port/
</pre>

config コマンドで次のように設定することもできます。<br>

<pre>
$ git config --global http.proxy http://username:password@your.proxy.address:proxy.port/
</pre>

### npmの場合
以下のコマンドで、npmのconfigファイルを設定します。<br>

<pre>
$ npm config set proxy http://username:password@your.proxy.address:proxy.port/
$ npm config set https-proxy http://username:password@your.proxy.address:proxy.port/
</pre>

### SVNの場合
~/.subversion/servers ファイルの[global] httpの項目に次の設定を追加します。<br>

<pre>
[global]
http-proxy-host = host ip address
http-proxy-port = port number
http-proxy-username = defaultusername
http-proxy-password = defaultpassword
</pre>

### gsutil(Google Cloud(Boto))の場合
Google Cloud Storageを使用するためのユーティリティ、”gsutil”を使用する場合に必要となる設定です。<br>
設定に必要な、"~/.boto"ファイルは、以下のようにconfig を実行することによって、作成されるファイルです。<br>

<pre>
$ gsutil config
</pre>
~/.boto ファイルのhttpの項目に次の設定を追加します。<br>

<pre>
[Boto]
proxy = <ip address>
proxy_port = <port>
proxy_user = <your proxy user name>
proxy_pass = <your proxy password>
</pre>

### gemの場合
環境変数の設定を行っていれば、実行可能だと思いますが、それでもダメな時は、gem installコマンドと同時にProxy環境を指定します。<br>

<pre>
$ gem install パッケージ名 -r -p http://username:password@your.proxy.address:proxy.port/
</pre>

### gradleの場合
専用のプロパティファイルに設定します。プロパティファイルは、"~/.gradle/gradle.properties" ファイルです。<br>
このファイルは、インストール後に自動的に生成されていないので、新規作成する必要があります。<br>
各Proxyは以下のように設定します。（詳細は公式サイトを参照願います）<br>

<pre>
systemProp.http.proxyHost=your.proxy.address
systemProp.http.proxyPort=proxy.port
systemProp.http.proxyUser=username
systemProp.http.proxyPassword=password
systemProp.https.proxyHost=your.proxy.address
systemProp.https.proxyPort=proxy.port
systemProp.https.proxyUser=username
systemProp.https.proxyPassword=password
</pre>

### curlの場合
~/.curlrc ファイルに次の設定を追加します。<br>

<pre>
proxy-user = "username:password"
proxy = "http://your.proxy.address:proxy.port"
ここまではubuntu 14.04の設定方法でしたが、Mac OS Xでもほぼ同様です。
ただし、ユーザー認証付きProxy環境下では、アプリをApp StoreへSubmitはできませんでした…
</pre>
