## [Linuxサーバ管理のTips](http://kodama.fubuki.info/wiki/wiki.cgi/Linux/server_tips?lang=jp)

## コンパイル
### objdump: 共有ライブラリの依存関係等を表示する
```
$ objdump -p bin-filename
```

## インストール
### yum: 直前のinstallを取り消す
```
# yum history
# yum history undo "ID"
```

### rpm: ユーザ権限でrpmパッケージ（バイナリ版）をインストールする
```
$ rpm2cpio.pl rpm-filename | cpio -ivd
```
これで展開された中身を適宜配置し、PATHやLD_LIBRARY_PATHを書き換える。<br>

## ディスク
### 利用可能なブロックデバイスを表示する
```
$ lsblk
```

## ネットワーク
### ネットワークデバイスの確認
* CentOS 7, Debian 10 etc
```
nmcli device show デバイス名
```

* CentOS 6 etc
```
ifconfig
```

### Tips: IPアドレスからホスト名を得る
```
$ dig -x IP-address
```

### Tips: Basic認証のパスワード追加
```
$ htpasswd [path].htpasswd user-name
```
