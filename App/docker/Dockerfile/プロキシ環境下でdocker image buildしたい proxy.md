## [プロキシ環境下でdocker image buildしたい 2021/01/25](https://qiita.com/charon/items/d8365d610343d64d598e)

### やりたいこと
- プロキシ環境下でdocker image buildしたい
    - yumやaptを利用してパッケージインストールする時に困る
- プロキシサーバーは、サーバー名で指定したい
- Dockerfileには、ENV http_proxyとかENV https_proxyとか書きたくない

### `--build-arg`を使う
解決方法は`--build-arg`で`http_proxy`や`https_proxy`を、`docker build`時に指定してあげればOKです。

```
$ docker image build --build-arg http_proxy=http://your-proxy-host:your-proxy-port --build-arg https_proxy=http://your-proxy-host:your-proxy-port -t charon/your-container-image:latest .
```

さらに、プロキシサーバーを名前で指定したい場合で、かつDockerコンテナ内からプロキシサーバーの名前解決が面倒な場合。<br>
[Container networking](https://docs.docker.com/config/containers/container-networking/)<br>

`--dns`オプションを使用してもよいのですが、それも面倒。<br>
`dig +short`でいいんではないでしょうか？<br>

```
#!/bin/bash

docker image build --build-arg http_proxy=http://$(dig +short your-proxy-host):your-proxy-port --build-arg https_proxy=http://$(dig +short your-proxy-host):your-proxy-port "$@"
```

このスクリプトに、実行を付けて/usr/loca/binにでも置いておきましょう。<br>

```
$ chmod a+x docker-proxy-build
$ sudo cp docker-proxy-build /usr/local/bin
```

使う時。
```
$ docker-proxy-build -t charon/your-container-image:latest .
```
