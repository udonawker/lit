## yumコマンドいろいろ

```
# yum
check             distro-sync       history           load-transaction  remove            update
check-update      downgrade         info              makecache         repolist          upgrade
clean             groups            install           provides          search            version
deplist           help              list              reinstall         shell

# yum clean
all           cache         dbcache       expire-cache  headers       metadata      packages

# yum groups
info     install  list     remove   summary

# yum list
all        available  extras     installed  obsoletes  recent     updates

# yum history
addon-info     list           packages-info  redo           stats          sync
info           new            packages-list  rollback       summary        undo

# yum repolist
all       disabled  enabled

# yum
erase
localinstall
localupdate
updateinfo
```

## [【 yum 】コマンド（応用編その4）――パッケージファイル（RPMファイル）を使ってインストールする](https://atmarkit.itmedia.co.jp/ait/articles/1609/23/news012.html)


## createrepo
## [yumリポジトリサーバの構築方法](https://qiita.com/hana_shin/items/f714376d041941320290)
## [6.3.6. YUM リポジトリの作成](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/deployment_guide/sec-yum_repository)
1. シェルプロンプトで root として以下を入力し、createrepo パッケージをインストールします。
```
yum install createrepo
```

2. リポジトリーに配置するパッケージすべてを、/mnt/local_repo/ などの一つのディレクトリーにコピーします。
3. このディレクトリーに移動して、以下のコマンドを実行します。
```
createrepo --database /mnt/local_repo
```
これにより、Yum リポジトリに必要なメタデータ、さらには sqlite データベースが作成されるため yum の動作が迅速化します。<br>

