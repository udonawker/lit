## [yum｜rpm パッケージをダウンロードする](https://kazmax.zpp.jp/linux_beginner/yum_rpm_download.html#an2)

### 1. yumdownloader で rpm パッケージをダウンロードする
#### yumdownloader のインストール
```
# yum install yum-utils
```

#### yumdownloader の書式
```
# yumdownloader パッケージ名 [パッケージ名1 [パッケージ名2…]]
```
カレントディレクトリに、指定したパッケージがダウンロードされます。<br>
バージョンを指定する場合はバージョンもつける (krb5-libs-1.13.2-10.el7.x86_64)<br>

```
オプション	動作
--destdir DIR	DIRで指定したディレクトリにパッケージをダウンロードする
--source	バイナリパッケージではなく、ソースパッケージをダウンロードする
```


### 2. downloadonly プラグインで rpm パッケージをダウンロードする
#### downloadonly プラグインのインストール
```
# yum install yum-plugin-downloadonly
```

#### downloadonly プラグインの書式
「--downloadonly」オプションをつけて、yum コマンドを実行します。<br>
```
# yum install --downloadonly --downloaddir=ダウンロードディレクトリ パッケージ名
```
