## [Pacemakerの基本(プロセス構成)](https://qiita.com/HideoYamauchi/items/8de47f8b9de8f557129c)

### Pacemaker1.1系(corosync+pacemaker)でのプロセスの関連と構成について

### corosync層
- corosync : corosyncの本体(pacemakerとは別物)
- cpg : Cluster Process Group Service - corosync配下にグループを作成し、グループ内でメッセージなどを配送するサービス(pacemakerもCPGサービスのクライアント)
- quorum : Quorum Service - ノード数管理(QUORUM)サービス(pacemakerにQUORUM情報を伝搬)

### Pacemaker層
Pacemaker自体は、corosyncのCPGサービスのクライアントとして動作する。<br>
クラスタ間のメッセージ送信は、CPGサービスを利用して行う。プロセス間の通信は、IPCを利用して行う。<br>

- pacemakerd : 各以下pacemakerプロセスを起動、停止、監視するメインコントロール
- crmd : クラスタマネージャー(クラスタ構成の管理などを行う、pengineにて作成された状態遷移の実行(自ノードのlrmdへの依頼、他ノードのcrmdへの依頼）も行う)
- cib : CIB情報(リソース構成情報やノード状態、リソース状態）の更新、管理プロセス
- pengine：状態遷移を計算するプロセス
- attrd：属性管理プロセス
- lrmd：ローカルリソースマネージャープロセス(自ノードのリソースの起動、停止、モニター)
- stonith：STONITHプロセス
