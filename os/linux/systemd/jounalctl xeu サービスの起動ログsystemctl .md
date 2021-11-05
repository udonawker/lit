## [journalctl 最低限覚えておくコマンド](https://qiita.com/aosho235/items/9fbff75e9cccf351345c)

最近のメッセージを表示（-e）<br>
```
journalctl -e
```

-x をつけると詳細情報も表示される（-xe）<br>
```
journalctl -xe
```

tail -fのようにログを監視する（-f）<br>
```
journalctl -f
```

特定サービスのメッセージだけを表示<br>
-u ユニット名で指定する。<br>
ユニット名とはsystemctlで表示されるsshd.serviceなど。.serviceは省略できる。<br>
ワイルドカードとして*（アスタリスク）が使える。<br>
```
journalctl -u sshd
journalctl -u httpd
journalctl -u nginx
journalctl -u mysqld
journalctl -u cronie
journalctl -u updatedb
journalctl -u 'up*'
```

特定のサービスの最近のログ
```
journalctl -xeu サービス名
```
