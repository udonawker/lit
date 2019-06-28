[PaceMaker環境の構築・運用で使うコマンド集](http://infra.blog.shinobi.jp/Entry/107/ "PaceMaker環境の構築・運用で使うコマンド集")<br/>

PaceMaker構築前に使うコマンド<br/>
- RA規格(例えばocf)をリストアップする
<pre>
# pcs resource standards
</pre>
- プロバイダをリストアップする
<pre>
# pcs resource providers
</pre>
- リソースエージェントをリストアップする
<pre>
# pcs resource agents ocf:heartbeat
</pre>
- リソースエージェントの説明を表示する
<pre>
# pcs resource describe ocf:heartbeat:IPaddr2
</pre>

PaceMaker構築時よく使うコマンド<br/>
- Pacemakerリソース設定の初期化方法
<pre>
すべてのサーバのリソースを停止します。このための簡単な方法は，サーバの状態をスタンバイにすることです。
# pcs cluster standby server-name01(サーバ名)
# pcs cluster standby server-name02(サーバ名)

次にリソース設定を削除（crm configure erase コマンド)
# crm configure erase

サーバをオンライン状態に戻します。
# pcs cluster unstandby server-name01(サーバ名)
# pcs cluster unstandby server-name02(サーバ名)
</pre>
- 登録済みPacemakerリソースの確認
<pre>
# pcs resource show
</pre>
- 登録済みPaceMakerリソースの起動順序確認
<pre>
# pcs constraint order
Ordering Constraints:
  promote ms-mysql then start grp-network
  start res-ping-clone then promote ms-mysql
  start res-chk-vip1 then start res-vip1
</pre>
- Cluster.confの定義整合性チェック
<pre>
# ccs_config_validate
Relax-NG validity error : Extra element cman in interleave
tempfile:23: element cman: Relax-NG validity error : Element cluster failed to validate content
Configuration fails to validate
※上記はエラーが発生している。エラーがでなけれあOK
</pre>
- Pacemaker設定チェック
<pre>
# crm_verify -LV
</pre>

PaceMaker環境の運用でよく使うコマンド集<br/>
- インターコネクトLANの状況確認
<pre>
 # crm_mon -fA
</pre>
- 特定時間のログ取得
<pre>
# pcs cluster  report --from="2014-07-19 15:00:00" --to="2014-07-19 15:30:00"
</pre>
- ノード起動状態を確認(Corosync)
<pre>
# corosync-cfgtool -s
</pre>
- VIP確認
<pre>
ip addr show
</pre>
- PaceMakerリソースの復旧
<pre>
失敗カウントの確認とクリア
# pcs resource failcount show res-mysql(リソースID)
# pcs resource failcount reset res-mysql(リソースID)

・リソース状態の確認とクリア
# pcs status
# pcs resource cleanup res-mysql(リソースID)
</pre>
- Location制約の解除
<pre>
# pcs constraint location rm cli-standby-<RSC_NAME> [NODE]
元いたノードに対して「もうこっちでは活性化させない」というlocation制約が立ってしまうので、解除 
</pre>
- ノードのスタンバイ＆オンライン
<pre>
・ノードのスタンバイ
# pcs cluster standby server1(ホスト名)

・ノードのオンライン
# pcs cluster unstandby server1(ホスト名)
</pre>
- リソース監視の失敗回数の確認
<pre>
# pcs resource failcount show res-mysql
No failcounts for res-mysql
</pre>
- PaceMakerリソースの監視状態クリア
<pre>
# pcs resource failcount reset res-mysql
# pcs resource cleanup res-mysql
</pre>
- リソースの個別開始
<pre>
# pcs resource start mysql-clone
</pre>
- スイッチオーバー
<pre>
# pcs resource move ms-mysql --master
</pre>
- 現行設定のcib.xmlを出力する
<pre>
# pcs cluster cib /tmp/test.txt
</pre>
