引用 
[Docker環境で、コンテナのログをFluentdに出力する](https://kazuhira-r.hatenablog.com/entry/2019/01/02/125947 "Docker環境で、コンテナのログをFluentdに出力する")

# logging driver

Dockerでは、コンテナに出力されたログは「docker logs」コマンドで参照することができます。<br/>
[View logs for a container or service | Docker Documentation](https://docs.docker.com/config/containers/logging/ "View logs for a container or service | Docker Documentation")<br/>
[Configure logging drivers | Docker Documentation](https://docs.docker.com/config/containers/logging/configure/ "Configure logging drivers | Docker Documentation")<br/>


このログの出力先は、logging driverというもので制御されているようです。<br/>
logging driverにはいくつか種類があり、デフォルトのlogging driverは「json-file」のようです。これは、ホスト側の
「/var/lib/docker/containers/[コンテナID]/[コンテナID]-json.log」に出力されるものです。<br/>

<pre>
$ docker container run --rm --name httpd httpd:2.4.37

$ docker inspect httpd | grep -i -A 3 Log
        "LogPath": "/var/lib/docker/containers/e01a9083c3a98b48aaeda25292d69ab409b6f5f04e01a9cee31e5549e1a94693/e01a9083c3a98b48aaeda25292d69ab409b6f5f04e01a9cee31e5549e1a94693-json.log",
        "Name": "/httpd",
        "RestartCount": 0,
        "Driver": "overlay2",
--
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
</pre>
ちなみに、どんな感じでログが入っているのかというと、
<pre>
$ sudo cat /var/lib/docker/containers/e01a9083c3a98b48aaeda25292d69ab409b6f5f04e01a9cee31e5549e1a94693/e01a9083c3a98b48aaeda25292d69ab409b6f5f04e01a9cee31e5549e1a94693-json.log
{"log":"AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message\n","stream":"stderr","time":"2019-01-01T15:21:11.353294509Z"}
{"log":"AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message\n","stream":"stderr","time":"2019-01-01T15:21:11.355605364Z"}
{"log":"[Tue Jan 01 15:21:11.357255 2019] [mpm_event:notice] [pid 1:tid 140069608740032] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations\n","stream":"stderr","time":"2019-01-01T15:21:11.357434441Z"}
{"log":"[Tue Jan 01 15:21:11.357493 2019] [core:notice] [pid 1:tid 140069608740032] AH00094: Command line: 'httpd -D FOREGROUND'\n","stream":"stderr","time":"2019-01-01T15:21:11.357602487Z"}
</pre>

「log」という要素に標準出力なりの内容が全部入っているようですね。標準出力か標準エラー出力かは「stream」をログの時間については「time」を見れば良さそうです。<br/>
Dockerでサポートされているlogging driverは、ここに一覧があります。<br/>

[Supported logging drivers](https://docs.docker.com/config/containers/logging/configure/#supported-logging-drivers "Supported logging drivers")<br/>
なお、「json-fiile」と「journald」以外のlogging driverを選択した場合は、「docker logs」コマンドは使えなくなるようです。<br/>
logging driverを含む、コンテナログの設定は、「docker container run」時にコンテナ単位に設定するか、Linuxの場合であれば
「/etc/docker/daemon.json」でDockerデーモン全体の設定として行うこともできるようです。<br/>
[Configure the default logging driver](https://docs.docker.com/config/containers/logging/configure/#configure-the-default-logging-driver "Configure the default logging driver")<br/>

# Fluentd logging driver

それで、今回はこのlogging driverをFluentdに変更してみます。<br/>
Fluentd logging driverについては、Docker、Fluentd両方にドキュメントがあります。<br/>
[Fluentd logging driver | Docker Documentation](https://docs.docker.com/config/containers/logging/fluentd/ "Fluentd logging driver | Docker Documentation")<br/>
[Docker Logging | Fluentd](https://www.fluentd.org/guides/recipes/docker-logging "Docker Logging | Fluentd")<br/>
このあたりを見ながら、設定していってみましょう。

# お題と環境
ApacheのDockerイメージに対してFluentd logging driverを設定し、Fluentdにログを送信してみようと思います。<br/>
[httpd](https://hub.docker.com/_/httpd/ "httpd")<br/>
Fluentd自体もDockerで立ち上げますが、こちらはコンテナ内に自分でインストールしたものを使用することにします。<br/>
また、送信されたApacheのログは、Fluentdのログ（stdout）に出力するものとします。<br/>
各種バージョン。<br/>

<pre>
$ docker --version
Docker version 18.09.0, build 4d60db4


$ docker container run --rm --name httpd httpd:2.4.37


2019-01-02 03:17:45 +0000 [info]: gem 'fluentd' version '1.2.6'
</pre>

各コンテナのIPアドレスは、<br/>
- Fluentd … 172.17.0.2
- Apache … 172.17.0.3
とします。<br/>

また、Apacheのイメージはindex.htmlしか入っていないので、ApacheのドキュメントをDocumentRootに設置し、ドキュメントに対するアクセスログを見ていくことにします。<br/>

こんな感じで。<br/>

<pre>
$ wget https://www-eu.apache.org/dist//httpd/docs/httpd-docs-2.4.33.en.zip
$ unzip httpd-docs-2.4.33.en.zip
$ docker container run --rm --name httpd -v `pwd`/httpd-docs-2.4.33.en:/usr/local/apache2/htdocs httpd:2.4.37
</pre>
この時点では、まだFluentd logging driverは設定していません。<br/>

# Fluentdの設定
Fluentd側は、ドキュメント側に習ってデフォルトの設定ファイルを編集してこのように設定。<br/>
[Docker Logging | Fluentd](https://www.fluentd.org/guides/recipes/docker-logging "Docker Logging | Fluentd")<br/>
/etc/td-agent/td-agent.conf<br/>
<pre>
<source>
  @type forward
  @id input_forward
</source>

<match *.**>
  @type stdout
  @id output_stdout
</match>
</pre>

「@id」は付けておきました。<br/>
ドキュメントだとportおよびbindも指定していますが、デフォルト値そのものみたいなので、まあいいかなと。<br/>
[forward Input Plugin | Fluentd](https://docs.fluentd.org/v1.0/articles/in_forward "forward Input Plugin | Fluentd")

# Apache側
ドキュメントルートにApacheのドキュメントを置きつつ、構築したFluentdに対してlogging driverを設定します。<br/>
<pre>
$ docker container run --rm \
  --name httpd \
  -v `pwd`/httpd-docs-2.4.33.en:/usr/local/apache2/htdocs \
  --log-driver=fluentd \
  --log-opt fluentd-address=tcp://172.17.0.2:24224 \
  --log-opt tag=docker.{{.ImageName}}.{{.Name}}.{{.ID}} \
  httpd:2.4.37
</pre>
「--log-driver」に「fluentd」を指定し、「--log-opt」でオプションの設定を行います。このあたりの情報は、こちらに記載があります。<br/>
[Fluentd logging driver / Options](https://docs.docker.com/config/containers/logging/fluentd/#options "Fluentd logging driver / Options")<br/>
「fluentd-address」では送信先のFluentdを指定し（デフォルトは「localhost:24224」）、「tag」ではFluentdで使うタグを指定します（デフォルトでは12文字のコンテナID）。<br/>
今回は、タグとして「docker.[イメージ名].[コンテナ名].[コンテナID（12文字）]」を指定しています。指定しているテンプレートの意味は、こちらを参照してください。<br/>
[Customize log driver output | Docker Documentation](https://docs.docker.com/config/containers/logging/log_tags/ "Customize log driver output | Docker Documentation")<br/>

# 確認
では、ファイルを参照して確認してみましょう。<br/>
ここは、一気にwgetでミラーしてみます。<br/>

<pre>
$ wget -m -p -r -nH -np 172.17.0.3
</pre>

Fluentd側には、こんな感じでログ出力されます。<br/>

<pre>
2019-01-02 03:55:42.000000000 +0000 docker.httpd:2.4.37.httpd.76d3304af17a: {"log":"172.17.0.1 - - [02/Jan/2019:03:55:42 +0000] \"GET / HTTP/1.1\" 200 7004","container_id":"76d3304af17a71ce363407f855d544bccab2c0e39142c4be1dc2ba4385304c34","container_name":"/httpd","source":"stdout"}
2019-01-02 03:55:42.000000000 +0000 docker.httpd:2.4.37.httpd.76d3304af17a: {"container_name":"/httpd","source":"stdout","log":"172.17.0.1 - - [02/Jan/2019:03:55:42 +0000] \"GET /robots.txt HTTP/1.1\" 404 208","container_id":"76d3304af17a71ce363407f855d544bccab2c0e39142c4be1dc2ba4385304c34"}
2019-01-02 03:55:42.000000000 +0000 docker.httpd:2.4.37.httpd.76d3304af17a: {"container_id":"76d3304af17a71ce363407f855d544bccab2c0e39142c4be1dc2ba4385304c34","container_name":"/httpd","source":"stdout","log":"172.17.0.1 - - [02/Jan/2019:03:55:42 +0000] \"GET /style/css/manual-zip.css HTTP/1.1\" 200 874"}
2019-01-02 03:55:42.000000000 +0000 docker.httpd:2.4.37.httpd.76d3304af17a: {"container_id":"76d3304af17a71ce363407f855d544bccab2c0e39142c4be1dc2ba4385304c34","container_name":"/httpd","source":"stdout","log":"172.17.0.1 - - [02/Jan/2019:03:55:42 +0000] \"GET /style/css/manual-zip-100pc.css HTTP/1.1\" 200 885"}
2019-01-02 03:55:42.000000000 +0000 docker.httpd:2.4.37.httpd.76d3304af17a: {"log":"172.17.0.1 - - [02/Jan/2019:03:55:42 +0000] \"GET /style/css/manual-print.css HTTP/1.1\" 200 13200","container_id":"76d3304af17a71ce363407f855d544bccab2c0e39142c4be1dc2ba4385304c34","container_name":"/httpd","source":"stdout"}
2019-01-02 03:55:42.000000000 +0000 docker.httpd:2.4.37.httpd.76d3304af17a: {"container_id":"76d3304af17a71ce363407f855d544bccab2c0e39142c4be1dc2ba4385304c34","container_name":"/httpd","source":"stdout","log":"172.17.0.1 - - [02/Jan/2019:03:55:42 +0000] \"GET /style/css/prettify.css HTTP/1.1\" 200 3616"}
</pre>

含まれる要素は、「log」、「container_name」、「container_name」、「source」のようです。<br/>
「source」は、標準出力か標準エラー出力かを表すようですね。<br/>
例えば、Apache起動時のログは標準エラー出力に出るようなので、こんな感じになります。<br/>
<pre>
2019-01-02 03:44:54.000000000 +0000 docker.httpd:2.4.37.httpd.76d3304af17a: {"container_id":"76d3304af17a71ce363407f855d544bccab2c0e39142c4be1dc2ba4385304c34","container_name":"/httpd","source":"stderr","log":"[Wed Jan 02 03:44:54.260937 2019] [core:notice] [pid 1:tid 140541962106048] AH00094: Command line: 'httpd -D FOREGROUND'"}
</pre>

この時、Apache側のコンテナに対して「docker container logs」を実行すると、エラーになります。<br/>

<pre>
$ docker container logs httpd
Error response from daemon: configured logging driver does not support reading
</pre>

こんな感じで動作確認できました。<br/>

また、ログメッセージのJSONをパースするサンプルや、ログメッセージが複数行になっている場合に結合するサンプルも、こちらのドキュメントに記載があります。<br/>

[Docker Logging | Fluentd](https://www.fluentd.org/guides/recipes/docker-logging "Docker Logging | Fluentd")<br/>
こんなところで。<br/>
