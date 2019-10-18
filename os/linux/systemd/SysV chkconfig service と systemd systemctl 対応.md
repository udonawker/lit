## SysV chkconfig service と systemd systemctl 対応

|内容|SysV系|systemctl|
|---|---|---|
|自動起動設定|chkconfig サービス名 on|systemctl enable サービス名|
|自動起動を無効化|chkconfig サービス名 off|systemctl disable サービス名|
|状態確認|chkconfig --list|systemctl list-unit-files|
|サービスの状態を表示する|service サービス名 status|systemctl status サービス名|
|サービスを起動する|service サービス名 start|systemctl start サービス名|
|サービスを停止する|service サービス名 stop|systemctl stop サービス名|
|サービスを再起動する|service サービス名 restart|systemctl restart サービス名|
|設定の再読み込み|service サービス名 reload|systemctl reload サービス名|
|全サービス状態表示|service --status-all|systemctl --full|
|サービス設定の追加|chkconfig --add サービス名||
|サービス設定の削除|chkconfig --del サービス名||
|設定ファイルの再読込||systemctl daemon-reload サービス名|
|スクリプト|/etc/init.d/script|/lib/systemd/system/unit-file<br/>書式は以下の man page<br/>systemd.unit(5),<br/>systemd.service(5),<br/>systemd.exec(5)|


参考 [【新旧対応】Linuxでの自動起動の設定方法を解説](https://eng-entrance.com/linux_startup) <br/>

## Linuxの自動起動

現在、Linuxのシステム起動には２種の方法が混在している。<br/>

SysVinit系とsystemdの2種類だ。<br/>
古くて安定的に動いているものはSysVinit系が多く、現場ではこちらに出会う確率が高い。<br/>
しかし、最近出た新しいディストリビューションでは新しいsystemdが採用されている。<br/>

* CentOS 7
* SUSE Linux Enterprise Server 12
* Fedora 15以降
* Ubuntu 15

などのディストリビューションはsystemdが使われている。<br/>

## SysVinit系の自動起動

1. 電源が入る
1. BIOSが起動し、ハードウェアを初期化
1. ブートローダが起動し、Linuxカーネルをメモリ上に展開する
1. Linuxカーネルが起動
1. ドライバなどがロードされ、最後にinitプロセスを起動
1. 指定されたランレベルに応じた起動処理を実行
1. ログインを受け付け開始

## systemd系の自動起動

1. 電源が入る
1. BIOSが起動し、ハードウェアを初期化
1. ブートローダが起動し、Linuxカーネルをメモリ上に展開する
1. Linuxカーネルが起動
1. ドライバなどがロードされ、systemdプロセスを起動
1. default.targetというUnitが処理される
1. システムの用途に適したターゲットが処理される
1. ログインを受け付け開始
