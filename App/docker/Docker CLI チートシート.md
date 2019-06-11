引用
[Docker CLI チートシート](https://www.qoosky.io/techs/0a0bd52cd3 "Docker CLI チートシート")<br/>

# 概要
Docker に関するコマンド逆引き集です。公式ページの「[Reference documentation](https://docs.docker.com/engine/reference/commandline/docker/ "Reference documentation")」情報をもとにしています。



# Docker 用語について


## コンテナ
後述のイメージという型をもとに作られる実体です。例えるならば、オブジェクト指向プログラミングにおけるクラスが Docker イメージで、インスタンスが Docker コンテナです。あるイメージをもとにして複数のコンテナが作成され得ります。コンテナには containerId が自動で付与されます。containerId は英数字の羅列であり人間にとって分かり良いものではありません。そこで利便性のためにコンテナ名も付与できます。明示的に付与しない場合は適当な名前が自動で付与されます。containerId はもちろん一意ですが、コンテナ名も一意である必要があります。
containerId の例 "bc533791f3f5"
コンテナ名の例 "nostalgic_morse"



## イメージ
前述のコンテナという実体を作成するための型です。繰り返しになりますが、例えるならばオブジェクト指向プログラミングにおけるクラスが Docker イメージで、インスタンスが Docker コンテナです。イメージには imageId が自動で付与されます。imageId は英数字の羅列であり人間にとって分かり良いものではありません。そこで利便性のために、ある imageId のイメージには任意の個数のタグが付与できます。タグ名はコンテナ名と異なり自動で付与されることはありません。イメージは後述のレポジトリに格納されます。imageId はレポジトリ間全体で一意です。タグ名は若干制約が緩く、あるレポジトリ内で一意であれば設定可能です。
- imageId の例 "fc77f57ad303"
- タグ名の例 "latest", "13.10", "dev", "v2"
- レポジトリ名の例 "ubuntu", "training/webapp"



## レポジトリ
あるレポジトリには複数のバージョンのイメージ (v10, v11,...) が格納され得ります。以上のことから言える事実として「レポジトリ名:タグ名」とすればイメージが一意に定まります。もちろん「imageId」だけでも一意に定まります。あるレポジトリ内の最新のイメージには latest タグが自動で付与されます。「レポジトリ名」とだけしたときは「レポジトリ名:latest」として処理されます。レポジトリ名には「ubuntu」といった base image や root image とよばれるものと、「training/webapp」といった user image の二種類があります。



# 逆引きコマンド集


## イメージからコンテナを作成してシェルを起動して入る
オプション -i (--interactive) および -t (--tty) を付与して起動するのがポイントです。
<pre>
$ docker run -it レポジトリ名:タグ名 /bin/bash   ←例 centos:centos6
</pre>

シェル内で exit したらコンテナを自動で削除するためには --rm オプションも追加しておきます。オプション -d とは併用できません。
<pre>
$ docker run --rm -it レポジトリ名:タグ名 /bin/bash
</pre>


## コンテナ一覧を表示
起動中のコンテナ一覧を表示します。
<pre>
$ docker ps
</pre>

停止中のものも含めてすべてのコンテナ一覧を表示するためにはオプション -a (--all) を付与します。
<pre>
$ docker ps -a
</pre>

停止中のものを含むすべてのコンテナの中で最後に作成したものを表示するためにはオプション -l (--latest) を付与します。
<pre>
$ docker ps -l
</pre>

containerId だけを表示するためにはオプション -q (--quiet) を付与します。
<pre>
$ docker ps -q
</pre>

長いコマンドなどを省略せずにすべて表示するためにはオプション --no-trunc を付与します。
<pre>
$ docker ps --no-trunc
</pre>


## イメージ一覧の表示
ホストに格納されているイメージの一覧は以下のコマンドで確認できます。
<pre>
$ docker images
</pre>

history によってイメージが作成される過程における RUN, ADD, CMD などの発行履歴を表示できます。
<pre>
$ docker history レポジトリ名:タグ名
</pre>


## あるイメージに依存している子コメージの一覧を取得
<pre>
for i in $(docker images -q); do
    docker history $i | grep -q xxxxxxxx && echo $i
done | sort -u
</pre>


## コンテナの停止および起動
コンテナを停止するには以下のようにします。
<pre>
$ docker stop コンテナ名
</pre>

最後に作成されたコンテナを stop したのであれば、以下のコマンド latest オプションで何も表示されないことをもって停止されたと確認できます。
<pre>
$ docker ps -l
</pre>

コンテナの起動には start を利用します。
<pre>
$ docker start コンテナ名
</pre>

コンテナの再起動も可能です。
<pre>
$ docker restart コンテナ名
</pre>

何らかの原因で stop できないコンテナに対しては kill を実行できます。
<pre>
$ docker kill コンテナ名
</pre>


## コンテナ名を指定する
オプション --name を使用します。
<pre>
$ docker run -d -P --name コンテナ名  レポジトリ名:タグ名  コマンド
</pre>

ある containerId のコンテナ名は docker ps や以下のコマンドで確認します。
<pre>
$ docker inspect -f "{{ .Name }}" containerId
</pre>

後からコンテナ名を変更することもできます。
<pre>
$ docker rename 旧コンテナ名  新コンテナ名
</pre>


## バックグラウンドで起動中のコンテナ COMMAND をフォアグラウンドに変更
オプション -d (--detach) で起動したコンテナの COMMAND はバックグラウンドで実行されます。
<pre>
$ docker run -d -it centos:centos6 /bin/bash
</pre>

docker start で起動したコンテナの COMMAND もバックグラウンドで実行されます。
<pre>
host$ docker run -it centos:centos6 /bin/bash
container$ exit
host$ docker start containerId
</pre>

バックグラウンドで実行中のコンテナ COMMAND をフォアグラウンドに変更するためには attach を利用します。コンテナを作成した際に指定した COMMAND である /bin/bash がフォアグラウンドに戻ります。
<pre>
$ docker attach containerId
</pre>

この方法はコンテナを作成した際に指定した COMMAND を変更するものではないことに注意してください。
<pre>
$ docker run -d centos:centos6 top -b
$ docker attach containerId
</pre>

例えば上記方法で attach したとしても依然として top -b が実行された状態です。/bin/bash に変更することはできません。



## 起動中のコンテナに COMMAND を追加で発行する


### コンテナ COMMAND に関する理解を深める
イメージには COMMAND が一つだけ指定できます。例えば Dockerfile の CMD に指定されたコマンドは、その Dockerfile でビルドされたイメージの COMMAND になります。

Dockerfile
<pre>
FROM centos:centos6
CMD top -b
</pre>

イメージに COMMAND が設定されている場合、その COMMAND はイメージで作成されるコンテナの COMMAND になります。
<pre>
$ docker build -t username/top .
$ docker run -d username/top
</pre>

コンテナの COMMAND は ps によって確認できます。
<pre>
$ docker ps -l
CONTAINER ID  IMAGE                 COMMAND               CREATED ...
f1237583f707  username/top:latest  "/bin/sh -c 'top -b'   6 seconds ago ...
</pre>

ただし、イメージに設定された COMMAND は必ずしもコンテナの COMMAND にはなりません。run または create によってコンテナを作成する時に引数として指定したもので上書くことができるためです。
<pre>
$ docker run -d username/top ping www.yahoo.co.jp
$ docker ps -l
CONTAINER ID  IMAGE                 COMMAND               CREATED ...
d8be9e3e36c3  username/top:latest  "ping www.yahoo.co.j  3 seconds ago ...
</pre>

逆に、イメージに COMMAND が設定されていない場合は run または create によってコンテナを作成する時に引数として COMMAND を指定しなければエラーになります。
<pre>
$ docker run -d centos:centos6
FATA[0000] Error response from daemon: No command specified
</pre>


### 追加 COMMAND を発行
exec を使用することで、起動中のコンテナに追加の COMMAND を発行できます。

バックグラウンドでコマンドを発行
<pre>
$ docker exec -d コンテナ名 touch hello.txt
</pre>

フォアグラウンドでコマンドを発行
<pre>
$ docker exec コンテナ名 touch hello.txt
</pre>

/bin/bash コマンドを発行
<pre>
$ docker exec -it コンテナ名 /bin/bash   ←SSH ではなく直接ログイン
</pre>

特に最後の例は重要です。コンテナ内に sshd を立てるようなことは避けてください。コンテナには必要最小限のリソースのみを含めるべきだからです。



## コンテナの状態を知る
コンテナがどの程度ホストのリソースを消費しているかを調査するためには stats を利用します。
<pre>
$ docker stats コンテナ名, コンテナ名,...
</pre>

コンテナ内のプロセス一覧を表示するためには top を利用します。
<pre>
$ docker top コンテナ名
</pre>

logs を利用するとコンテナ COMMAND がターミナルに出力する内容を表示することができます。
<pre>
$ docker logs コンテナ名
</pre>

Unix におけるテクニックの一つ tail -f のように監視出力するためには以下のようにします。
<pre>
$ docker logs -f コンテナ名
</pre>

コンテナの状態を知るための汎用コマンド docker ps でも取得できますが、特にポートマッピングの情報だけを取得したい場合は以下のようにします。
<pre>
$ docker port コンテナ名  コンテナ内のポート番号
</pre>

コンテナ内の各種情報を json で出力するためには inspect を利用します。オプション -f で情報のフィルタリングが可能です。
<pre>
$ docker inspect コンテナ名
$ docker inspect -f '{{ .NetworkSettings.IPAddress }}' コンテナ名
</pre>


## ホストの状態を知る
コンテナ数やイメージ数、それらを格納しているホストのディレクトリ情報などを表示します。
<pre>
$ docker info
</pre>

ホストの Docker デーモンにレポートされるコンテナおよびイメージのイベントを監視するためには以下のコマンドを実行します。
<pre>
$ docker events
</pre>

過去のある時刻からさかのぼって表示するためには --since を利用します。引数は UNIX 時間です。
<pre>
$ docker events --since=0
</pre>



## コンテナの削除
事故防止のため running 状態のコンテナは削除できません。事前に stop しておく必要があります。
<pre>
$ docker stop コンテナ名
$ docker rm コンテナ名
</pre>

オプション -f (--force) を付与すれば running 状態であっても削除できます。
<pre>
$ docker rm -f コンテナ名
</pre>


## ホストからイメージを削除$ docker rmi レポジトリ名:タグ名



## イメージのダウンロード
イメージは必要なときになければ自動でダウンロードされます。しかしながら事前にダウンロードするためには以下のようにします。まず以下のコマンドで検索します。
<pre>
$ docker search 検索ワード
</pre>

以下のコマンドで実際にダウンロードします。用語集に記載したようにレポジトリには様々なバージョンのイメージが格納されています。タグ名を省略すると latest タグの付与されたイメージが取得されます。
<pre>
$ docker pull レポジトリ名:タグ名
</pre>


## タグをイメージに付与$ docker tag imageId レポジトリ名:新タグ名



## 新しいイメージを作成
コンテナに施された各種変更をコミットして新しいイメージを作成するためには commit を使用します。これは実験的にいろいろなことを試す用途で使用します。
<pre>
host$ docker run -it レポジトリ名:タグ名 /bin/bash
container$ コンテナ内でいろいろなコマンドを実行 && exit
host$ docker commit -m "メッセージ" -a "AUTHOR" containerId  レポジトリ名:タグ名
</pre>

最後にコミットした `Author` を確認
<pre>
docker inspect -f "{{ .Author  }}" レポジトリ名:タグ名
</pre>

作成された時刻を知る
<pre>
docker inspect -f '{{ .Created }}' イメージID
</pre>

本番環境で動作させるコンテナのイメージを用意する目的としては commit ではなく Dockerfile からビルドして作成したイメージを利用します。カレントディレクトリ '.' 内に Dockerfile が存在する場合は以下のコマンドでビルドします。
<pre>
$ docker build -t レポジトリ名:タグ名 .
</pre>

作成したイメージは Docker Hub にアップロードします。
<pre>
$ docker push レポジトリ名:タグ名
</pre>


## ファイルシステムの変更状態を表示
diff はファイルシステムの変更状態を確認するコマンドです。commit の際に意図しない変更が含まれていないか確認できます。
<pre>
$ docker diff コンテナ名
</pre>

- A: Add
- C: Change
- D: Deleted



## コンテナをポートマッピングされた状態で作成する
コンテナ内サービスが LISTEN しているポート番号すべてについて、ホストの任意のインタフェースから転送するためには以下のように -P オプションを使用します。これは loopback interface (いわゆる localhost 127.0.0.1 が割り当てられているインタフェース) を含みます。
<pre>
$ docker run -d -P レポジトリ名:タグ名  コマンド
</pre>

マッピングするポート番号を明示的に指定するためには -p オプションを使用します。複数のポートをマッピングするためにはオプション -p を複数回指定します。
<pre>
$ docker run -d -p ホストのポート番号:コンテナ内サービスがLISTENするポート番号  レポジトリ名:タグ名  コマンド
</pre>

ホストの特定のインタフェースにだけポートを bind することもできます。例えば上述の loopback interface にだけ bind するためには以下のようにします。
<pre>
$ docker run -d -p 127.0.0.1:ホストのポート番号:コンテナ内サービスがLISTENするポート番号  レポジトリ名:タグ名  コマンド
</pre>

コンテナ内サービスが UDP ポートを LISTEN している場合には /udp を付与します。
<pre>
$ docker run -d -p ホストのポート番号:コンテナ内サービスがLISTENするポート番号/udp  レポジトリ名:タグ名  コマンド
</pre>


## コンテナ間の通信路を設定する (legacy)
各コンテナは内部的なネットワークに所属しており、そのネットワークにおける IP が割り当てられています。この IP は docker inspect で調査できます。
<pre>
$ docker inspect -f '{{ .NetworkSettings.IPAddress }}' コンテナ名
</pre>

オプション --link によってコンテナ間の通信路を確保できます。
<pre>
$ docker run -d --name コンテナ名1  レポジトリ名:タグ名  コマンド
$ docker run -d --name コンテナ名2  --link コンテナ名1:エイリアス名  レポジトリ名:タグ名  コマンド
</pre>

JSON の出力情報をフィルタリングすることで確認できます。
<pre>
$ docker inspect -f "{{ .HostConfig.Links }}" コンテナ名2
</pre>

リンクオプション --link を付与して起動したコンテナ内では特殊な環境変数が利用できるようになります。また、環境変数に加えて /etc/hosts にリンク先のコンテナの DNS 情報が追記されます。リンク先のコンテナを再起動するなどして IP が更新されると環境変数はそのままですが /etc/hosts は自動更新されます。名前解決のためには環境変数ではなく /etc/hosts を利用することが推奨されています。



## NAT ネットワークの作成
Docker container networking
<pre>
docker network ls
docker network create --subnet=172.18.0.0/16 mynetwork
docker network rm mynetwork
</pre>

独自に作成したネットワークでは固定 IP を指定できます。
<pre>
docker run --net mynetwork --ip 172.18.0.101 --entrypoint /bin/bash --rm イメージID -c "ip a"

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
23: eth0@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:12:00:65 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.18.0.101/16 brd 172.18.255.255 scope global eth0
       valid_lft forever preferred_lft forever
</pre>


## コンテナ内のファイルを取得
cp によってコンテナ内のディレクトリまたはファイルをホスト側にコピーできます。
<pre>
$ docker cp コンテナ名:ファイルまたはディレクトリのパス情報  ホストのパス情報
</pre>

ファイルシステム毎バックアップするためには export を利用します。
<pre>
$ docker export コンテナ名 > backup.tar
$ gzip backup.tar
</pre>

後述の data volume は export の対象外となることに注意してください。復旧時に利用するためには以下のようにまずイメージを新規に作成します。
<pre>
$ cat backup.tar.gz | docker import - レポジトリ名:タグ名
</pre>

これを利用して作成されるコンテナにはバックアップ時のファイル一式がすべて含まれています。
<pre>
$ docker run -it レポジトリ名:タグ名  /bin/bash
</pre>

ただし、イメージとしては新規作成となるためタグ情報や docker history で確認できる履歴は失われます。イメージの共有を目的とする場合は export/import ではなく、イメージをビルドしてから後述の save/load を利用してください。

Docker イメージの差分を確認するためには以下のようにできます。
<pre>
docker run --name c1 -d --rm --entrypoint="" xxxxx tail -f /dev/null
docker run --name c2 -d --rm --entrypoint="" yyyyy tail -f /dev/null
mkdir c1
docker export c1 | tar -C c1 -xvf -
mkdir c2
docker export c2 | tar -C c2 -xvf -
diff -ur c1 c2
</pre>
