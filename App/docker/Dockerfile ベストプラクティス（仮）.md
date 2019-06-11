引用
[Dockerfile ベストプラクティス (仮)](https://www.qoosky.io/techs/f38c112ca9 "Dockerfile ベストプラクティス (仮)")

# Dockerfile ポイント集

## .dockerignore で不要なファイルを除外
Dockerfile をもとに build コマンドを実行すると Dockerfile の存在するディレクトリ以下のファイルすべてが "build context" として Docker デーモンに転送されます。ビルドは docker クライアントコマンドで実行されずに docker デーモンで実行されるためです。<br/>

**Sending build context to Docker daemon**

という出力で転送されるファイルのうちビルドに不要なものは無視リスト .dockerignore に含めましょう。転送にかかる時間を短縮できます。例えば .git は除外するべきです。<br/>


## コピー用途ならば ADD ではなく COPY

COPY はホストからコンテナ内にファイルをコピーすることしかできません。一方で ADD は COPY のようにホストからコンテナ内にファイルをコピーする機能に加えて tar.gz など圧縮ファイルをコピー後に解凍する機能など有しています。そのような機能の使用を意図していないことを明らかにするために、単純なコピー用途であれば COPY を使用することが推奨されます。<br/>


## USER を頻繁に使用しない

USER の記載された行以降の CMD, RUN, ENTRYPOINT は設定された権限で実行されます。しかしながら頻繁に root → 一般ユーザ → root → ... とスイッチしなければならないような Dockerfile は好ましくありません。ちなみに CMD には docker run で指定されたコマンドも含みます。また、ユーザは事前に作成しておく必要があります。<br/>
<pre>
RUN useradd username
USER username
</pre>

## RUN で cd するのではなく WORKDIR を利用

すべての Instruction は独立しており初期化されます。<br/>
<pre>
RUN cd /path/to/dir
</pre>

としても次の RUN ではまたもとの位置に戻ってしまいます。すべての RUN で<br/>
<pre>
RUN cd /path/to/dir && コマンド
</pre>

とすることでも解決できますが、もっとスマートに WORKDIR を利用しましょう。この情報は以降の RUN, CMD, ENTRYPOINT, COPY, ADD で使用されます。CMD には run で指定されたコマンドも含みます。WORKDIR では cd コマンドのように相対パスも使用できます。例えば<br/>
<pre>
WORKDIR /a
WORKDIR b
WORKDIR c
</pre>

とすると RUN pwd の結果は /a/b/c となります。存在しないディレクトリが指定された場合は自動で作成されます。<br/>


## ENV はまとめて一行にできる

<pre>
ENV myName="John Doe" \
    myCat=fluffy
</pre>
と<br/>
<pre>
ENV myName John Doe
ENV myCat fluffy
</pre>

は同じ結果になります。前者は 1 LAYER で実現されるためビルド時のステップ数を節約できます。<br/>


## バックスラッシュで複数行に分ける
例えば apt-get で大量のパッケージをインストールする RUN はバックスラッシュで複数行に分けてアルファベット順にしておきます。見易いだけでなく重複した記載を避けることができます。<br/>
<pre>
RUN apt-get update && apt-get install -y \
  bzr \
  cvs \
  git \
  mercurial \
  subversion
</pre>

## EXPOSE は -P のヒント
EXPOSE で提供される情報は -P で bind する際やコンテナ同士を link するときの情報として使用されます。EXPOSE で指定したポート番号は必ずしもホストのインタフェースに bind されないことに注意してください。コンテナを実行する管理者の判断によっては、そもそも -P オプションが付与されなかったり -p (小文字) で一部のポートしか bind されない状態でコンテナが作成される可能性があります。<br/>


## CMD について


### 有効に指定できるのは一つだけ
CMD は Dockerfile 内に一つだけ指定可能です。仮に複数指定すると最後の CMD だけが有効になります。<br/>


### 必ずしも実行されない
こちらのチートシートに記載したように CMD で指定された内容はあくまでもイメージの COMMAND です。コンテナを作成するコマンド run および create の引数で COMMAND が指定された場合は CMD の内容は上書かれます。<br/>


### ENTRYPOINT との違い
CMD は ENTRYPOINT の引数を指定します。ENTRYPOINT の既定値は [""] です。ENTRYPOINT を変更しない場合、コンテナ内では start または exec 時に<br/>
<pre>
CMD top -b
→ /bin/sh -c 'top -b'

CMD ["top", "-b"]
→ top -b
</pre>

が実行されます。ENTRYPOINT を変更すると以下のように CMD は ENTRYPOINT の引数として機能します。<br/>
<pre>
ENTRYPOINT ["top", "-b"]
CMD this_does_not_work
→ top -b /bin/sh -c this_does_not_work

ENTRYPOINT ["top", "-b"]
CMD ["-d1"]
→ top -b -d1
</pre>

## Dockerfile 内で ENV を利用可能
<pre>
ENV foo /bar
</pre>
としておくと、コンテナ内だけでなく以降の Dockerfile 内の ENV, ADD, COPY, WORKDIR, EXPOSE, VOLUME, USER で $foo が利用できます。<br/>
<pre>
WORKDIR $foo
WORKDIR ${foo}_blah
</pre>

## 複数のイメージを一つの Dockerfile で作成できる

FROM は Dockerfile 内に何度も指定できます。これは複数のイメージを一つの Dockerfile で作成できるということを意味します。<br/>
<pre>
FROM ubuntu
RUN echo foo > bar
# Will output something like ===> 907ad6c2736f

FROM ubuntu
RUN echo moo > oink
# Will output something like ===> 695d7793cbe4
</pre>

## VOLUME で作成したボリュームは rm -v で削除可能
Dockerfile<br/>
<pre>
FROM centos:centos6
VOLUME /DataVolume名
</pre>

以下のコマンドで作成したコンテナには /DataVolume名 ボリュームがマウントされます。<br/>
<pre>
$ docker build -t username/mydata .
$ docker create -it username/mydata /bin/bash
$ docker volume list
DRIVER              VOLUME NAME
local               18f4246b6f977ea865e17c6bc5c8465dc2987ff3738c129673728610bab77f23
</pre>

コンテナを削除 rm する際に -v オプションを付与するとボリュームも削除されます。<br/>
<pre>
$ docker rm -v コンテナ名
</pre>

複数の VOLUME が指定されている場合は複数削除されます。<br/>
<pre>
VOLUME ["/DataVolume名1", "/DataVolume名2"] 
→ $ docker rm -v コンテナ名
</pre>
