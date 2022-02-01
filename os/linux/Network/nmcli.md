## [Linuxチートシート｜ネットワーク設定編](https://qiita.com/shtnkgm/items/11ea9609f246c633a878)

```
# ネットワークを有効化
$ nmcli networking on

# ネットワークを無効化
$ nmcli networking off

# NetWorkManagerの状態を確認
$ nmcli general status

# デバイスとコネクションの接続状態を確認する
$ nmcli device status

# デバイスを接続
$ nmcli device connect DEVICENAME

# デバイスを切断
$ nmcli device disconnect DEVICENAME

# ホスト名を変更
$ nmcli general hostname HOSTNAME

# コネクションを確認
$ nmcli connection show

# コネクションを有効化
$ nmcli connection up CONNECTIONNAME

# コネクションを無効化
$ nmcli connection down CONNECTIONNAME

# コネクションのIPアドレスを変更
$ nmcli connection modify CONNECTIONNAME ipv4.addresses IPADDRESS

# デバイスにコネクションを追加
$ nmcli connection add type ethernet con-name CONNECTIONNAME ifname DEVICENAME

# デバイスからコネクションを削除
$ nmcli connection delete CONNECTIONNAME

# ホスト名を確認
$ hostname

# ホスト名を変更（専用コマンド）
$ hostnamectl set-hostname HOSTNAME

# ホスト名を確認（専用コマンド）
$ hostnamectl status

# ICMPパケットを5回送信
$ ping -c5 IPADDRESS

# ソケットの統計情報を確認
$ ss

```

## [nmcliコマンドの基礎](https://endy-tech.hatenablog.jp/entry/2018/09/08/140950)

* 1.本記事で紹介すること
* 2.nmcliの概要
* 3.Device と Connection
	* 3.1.Device の説明
	* 3.2.Connection の説明
	* 3.3.Device と Connection のまとめ
* 4.nmcli コマンドの基本的な使い方
	* 4.1.コマンドのヘルプ
	* 4.2.設定確認
	* 4.3.設定の変更/反映
	* 4.4.Connection をDeviceから紐付け解除する
	* 4.5.Connectionの設定を複製する
	* 4.6.(参考) nmcli device modify
	* 4.7.(参考) Connection名は被っても良い？
* 5.省略表現
* 6.覚えておきたいコマンド
* 7.(参考) nmtui
	* 7.1.概要
	* 7.2.nmtuiの使い方
* 8.(参考) ipコマンド
* 9.まとめ
* 10.次の記事
