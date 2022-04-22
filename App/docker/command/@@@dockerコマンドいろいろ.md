## [docker image](https://docs.docker.jp/engine/reference/commandline/image_ls.html)
### docker image ls
全てのイメージが列挙される<br>
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

### docker image ls <イメージ名>
指定したイメージが列挙される<br>

### docker image --format

|プレースホルダ|説明|
|:--|:--|
|.ID|イメージ ID|
|.Repository|リポジトリ|
|.Tag|イメージのタグ|
|.Digest|イメージのダイジェスト版|
|.CreatedSince|イメージを作成してからの経過時間|
|.CreatedAt|イメージの作成時間|
|.Size|イメージ・ディスクの容量|

例 以下の例は ID と Repository のエントリをテンプレートで指定します。そして、コロン区切りで全てのイメージを表示します。<br>
```
$ docker images --format "{{.ID}}: {{.Repository}}"
```

例 リポジトリとタグを表形式で一覧表示するには、次のようにします。<br>
```
$ docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"
```
