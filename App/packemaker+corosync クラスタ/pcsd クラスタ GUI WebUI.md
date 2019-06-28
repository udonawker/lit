引用[Pacemaker用GUI(web)ツール「pcs(pcsd)」](https://drbd.jp/pacemaker%E7%94%A8guiweb%E3%83%84%E3%83%BC%E3%83%AB%E3%80%8Cpcspcsd%E3%80%8D/ "Pacemaker用GUI(web)ツール「pcs(pcsd)」")

# Pacemaker用GUI(web)ツール「pcs(pcsd)」
Pacemaker＋Corosyncでクラスタ構成を構築する場合に利用できる設定ツール「pcs(pcsd)」について紹介します。<br/>

## 「Pacemaker」とは
Pacemakerは、一連のマシン間で関連する「サービス起動」と「サービス復旧」をコントロールするためのクラスタソフトウェアです。<br/>
Pacemakerは多くの異なるリソースタイプを理解し、それらの間の関係を正確にモデル化できます。<br/>
Dockerなどのテクノロジーを使用して、クラスタによって管理されているリソースを自動的に分離することもできます。<br/>
Pacemakerの概要については、こちらも参照ください。<br/>

[→クラスタ構成ソフトウェア「Pacemaker」と「Heartbeat」「Corosync」の関係性](https://drbd.jp/%E3%82%AF%E3%83%A9%E3%82%B9%E3%82%BF%E6%A7%8B%E6%88%90%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E3%80%8Cpacemaker%E3%80%8D%E3%81%A8%E3%80%8Cheartbeat%E3%80%8D%E3%80%8Ccorosync%E3%80%8D/ "→クラスタ構成ソフトウェア「Pacemaker」と「Heartbeat」「Corosync」の関係性")

## 「pcs(pcsd)」とは
### Pacemaker/Corosync構成ツール「pcs」<br/>
Pacemaker/Corosync構成ツール「pcs」<br/>
「PCS(Pacemaker Configuration Tool)」は、Pacemaker/Corosync構成ツールです。<br/>
コマンドラインインターフェースによるpacemaker/corosyncの制御や設定が可能で、ユーザーはPacemakerベースのクラスタについて作成/表示/変更などを行えます。<br/>
「pcs」は旧来の「crmsh」に代わるPacemakerクラスタ管理ツールであり、RHEL/CentOS7においては「pcs」の使用が推奨されています。<br/>

### pcsデーモン「pcsd」
pcsには、pcsデーモン「pcsd」が含まれており、pcsのリモートサーバとして動作し、Web UIを提供します。<br/>
pcsdはPacemaker/corosyncとは独立したサービスであり、このデーモンが起動していない状態では、クラスタ構成に使用するpcsコマンドが使用できません。<br/>

#### Web UIへのアクセス
Web UIにアクセスするためには、クラスタに接続可能なブラウザで、pcsdが起動中のどちからのノードの2224ポートにhttps接続します。<br/>
1 https://<pcsd起動中ノードのipアドレス>:2224 に接続<br/>
2 Username/password 入力 (hacluster/********)<br/>
3 MANAGE CLUSTERS ⇒ Add Existing ⇒ Node Name/IP:に1.のIPアドレスを設定し{Add Existing}ボタン<br/>
4 2.のクラスタパスワードを設定し{Authenticate}ボタン<br/>
ログインするとpcsdのGUI(web)画面が表示され、クラスタ構成/操作などを行えます。<br/>

## 「pcs(pcsd)」のインストール方法
### インストール手順
pcs(pcsd)のインストールの前に、関連プロダクトのインストールが必要です。<br/>
手順については、こちらのドキュメントを参照ください。<br/>
[→GitHub　→ClusterLabs/pcs(Pacemaker command line interface and GUI)](https://github.com/ClusterLabs/pcs "→GitHub　→ClusterLabs/pcs(Pacemaker command line interface and GUI)")<br/>

### パッケージ
「pcs(pcsd)」は、主要Linuxディストリビューション(Fedora/Red Hat Enterprise Linux/Debianなど)にパッケージとして組み込まれています。<br/>

## 「pcs(pcsd)」の主な機能
### 主な機能
・pcsバージョン確認<br/>
・クラスタノード認証<br/>
・クラスタ作成<br/>
・クラスタ起動<br/>
・クラスタ停止<br/>
・クラスタ状態取得<br/>
・クラスタ設定取得<br/>
・特定ノードをスタンバイモードに移行<br/>
・特定ノードをスタンバイモードから復帰<br/>
・特定リソースの手動フェールオーバー<br/>
・特定リソースのフェールオーバー履歴の削除<br/>
・手動でのフェンシング（STONITH機能によるサーバ再起動）　など<br/>

### 主なコマンド
#### cluster
クラスタオプションおよびノードの設定を行います。<br/>

####resource
クラスタリソースの作成と管理を行います。<br/>

####stonith
フェンスデバイスを設定します。<br/>

####constraint
リソース制約を管理します。<br/>

####property
Pacemakerのプロパティを設定します。<br/>

####status
現在のクラスタとリソースの状態を表示します。<br/>

####config
ユーザーが読みやすい形式でクラスターの全設定を表示します。<br/>

## まとめ
設定ツール類を利用することで、Pacemaker＋Corosyncでのクラスタ環境に関する管理工数を低減化できます。<br/>


参考元サイト
- [https://github.com/ClusterLabs/pcs](https://github.com/ClusterLabs/pcs)
- https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/configuring_the_red_hat_high_availability_add-on_with_pacemaker/ch-pcscommand-haar
- https://qiita.com/HideoYamauchi/items/bb13b4ff474b750eeb23
- http://kan3aa.hatenablog.com/entry/2015/06/05/135150
- http://kan3aa.hatenablog.com/entry/2015/11/14/194942
