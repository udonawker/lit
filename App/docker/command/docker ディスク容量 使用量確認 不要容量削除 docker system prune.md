## 20241023 [Docker の容量不足解決（docker system prune）](https://qiita.com/shione/items/dfa956a47b6632d8b3b3)

### 1. Dockerのディスク利用状況を確認
```
# Docker のディスク利用状況を確認
> docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              0                   0                   0B                  0B
Containers          0                   0                   0B                  0B
Local Volumes       20                  0                   24.84GB             24.84GB (100%)
Build Cache         0                   0                   0B                  0B

# -v オプションで詳細表示
> docker system df -v
Images space usage:

REPOSITORY          TAG                 IMAGE ID            CREATED ago         SIZE                SHARED SIZE         UNIQUE SiZE         CONTAINERS

Containers space usage:

CONTAINER ID        IMAGE               COMMAND             LOCAL VOLUMES       SIZE                CREATED ago         STATUS              NAMES

Local Volumes space usage:

VOLUME NAME                                                        LINKS               SIZE
2377861222d0a9f4c17b0c8be0fcfb6007349e9dc49068101d6c7154363f4976   0                   0B
52277ff5bdde3f484517af28f16816a996fafafd5f9eeaddbb8e59be0c60e796   0                   0B
5983a937123b4d17fdae4b4cb8c08c70748561c08d11aa5c3034f38541da7179   0                   708.3MB
6f0262bd4dd1066ec7a987faf6da9df982fa5ea0a80d632941b72344bc878438   0                   0B
a73a80634dead8ddcab26efaea9e5797ad45cc294ebe7a87c8becdf409aa3c37   0                   0B
...
```

### 2. Local Volumes の整理
docker system pruneは、Docker のバージョンによって動作が異なる。<br>
[docker docs - docker system prune](https://docs.docker.com/engine/reference/commandline/system_prune/)<br>

#### Docker 17.06.1以降
不要な volume を削除するには、--volumesオプションの付与が必要。<br>

```
# 不要なコンテナ／ネットワーク／イメージ／ボリュームの一括削除
> docker system prune -a --volumes
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all volumes not used by at least one container
        - all images without at least one container associated to them
        - all build cache
Are you sure you want to continue? [y/N]
```
オプション--volumesなしで実行すると、WARNING に volumes の記載がない。<br>

```
# 不要なコンテナ／ネットワーク／イメージの一括削除(ボリュームは対象外)
> docker system prune -a
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all images without at least one container associated to them
        - all build cache
Are you sure you want to continue? [y/N]
```

#### Docker 17.06.1 より古いバージョン
docker system prune -aで、不要なコンテナ／ネットワーク／イメージ／ボリュームを一括削除する。<br>

### 3. 個別に削除する場合
```
# 不要コンテナの一括削除
> docker container prune

# 不要ネットワークの一括削除
> docker network prune

# 不要イメージの一括削除
> docker image prune

# 不要ボリュームの一括削除
> docker volume prune
```

---

## [Docker image, containerのお掃除方法](https://zenn.dev/minedia/articles/2023-02-20-docker-416d4f98ea1b75)

### コンテナから参照されていないボリュームを削除
```
% docker volume rm $(docker volume ls -qf dangling=true)
```

### 1週間以上使っていないコンテナの削除をします。
```
% docker container prune --force --filter "until=168h"
```

### 1週間以上前に停止したコンテナの削除
```
% docker ps --filter "status=exited" | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
```

### 宙ぶらりんなイメージを削除
タグが打たれていなかったり、ビルド途中でエラーになってしまったイメージを削除します。<br>
```
% docker rmi $(docker images -f "dangling=true" -q)
```

### Build cacheの削除
ビルド途中の中間イメージの削除<br>
```
% docker builder prune
```

### 全コンテナの削除
※実行注意<br>
```
$ docker rm $(docker ps -aq)
```

### 全イメージの削除
※実行注意<br>
以下のいずれかを実行します。同義です。イメージを消すためには関連するコンテナが存在しない状態でなければ消せません。<br>

```
% docker rmi $(docker images -q)
% docker image prune
```

### 全てのデータを削除
※実行注意<br>
停止中のコンテナ、ボリューム、ネットワーク、イメージを一括削除するコマンドです。<br>
ほぼDockerのリセットと同義です。<br>

```
% docker system prune 
```

---

最後の3つのコマンド以外を実行しています。<br>
以下のコマンドをシェルスクリプトにして、定期的に実行するとかしておけば良いかなと思います。<br>
```
#!/usr/bin/env bash

set -Eeuo pipefail

docker volume rm $(docker volume ls -qf dangling=true)
docker container prune --force --filter "until=168h"
docker ps --filter "status=exited" | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
docker rmi $(docker images -f "dangling=true" -q)
docker builder prune
```
