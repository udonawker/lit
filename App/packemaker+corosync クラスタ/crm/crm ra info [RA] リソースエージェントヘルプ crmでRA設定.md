## [第2回　Pacemakerをインストールしてみよう！［構築基本編］](https://gihyo.jp/admin/serial/01/pacemaker/0002?page=4)


## crmでRA設定
```
# crm configure primitive help
usage: primitive <rsc> [<class>:[<provider>:]]<type>
        [params <param>=<value> [<param>=<value>...]]
        [meta <attribute>=<value> [<attribute>=<value>...]]
        [operations id_spec
            [op op_type [<attribute>=<value>...] ...]]
```

|リソース|リソース名|RA|設定情報の表示コマンド|
|:--|:--|:--|:--|
|Apache|httpd|apache|crm ra info apache|
|仮想IP|vip|IPaddr2|crm ra info IPaddr2|
|ネットワーク監視|ping|pingd|crm ra info ocf:pacemaker:pingd|
