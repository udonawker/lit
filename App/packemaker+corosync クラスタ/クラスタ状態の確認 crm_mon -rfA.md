引用 
 [PowerGres HA Pacemaker 版の運用中に行うクラスタに関する操作について説明します。](https://powergres.sraoss.co.jp/manual/pacemaker/1.0.1/manual/operate.html#cleanup-service "PowerGres HA Pacemaker 版の運用中に行うクラスタに関する操作について説明します。")


# クラスタの状態の確認  
クラスタの状態は crm_mon コマンドで確認します。 コマンドは root ユーザで実行します。
<pre>
# crm_mon -rfA
============
Last updated: Mon Nov 11 07:26:23 2013
Stack: Heartbeat
Current DC: alice (dbf44f6c-f753-48f9-9f15-a786a116c142) - partition with quorum
Version: 1.0.13-30bb726
2 Nodes configured, unknown expected votes
2 Resources configured.
============

Online: [ alice bob ]

Full list of resources:

 Master/Slave Set: powergres_drbd.drbd.ms_drbd
     Masters: [ alice ]
     Slaves: [ bob ]
 Resource Group: powergres.pgsql-drbd.group_pgsql
     powergres_drbd.drbd.filesystem     (ocf::heartbeat:Filesystem):    Started alice
     powergres_ipaddr.ipaddr    (ocf::heartbeat:IPaddr2):       Started alice
     powergres.pgsql-drbd.pgsql (ocf::heartbeat:pgsql): Started alice

Node Attributes:
* Node alice:
    + bob-eth0                          : up
    + bob-eth1                          : up
    + bob-eth2                          : up
    + master-powergres_drbd.drbd.drbd:1 : 10000
* Node bob:
    + alice-eth0                        : up
    + alice-eth1                        : up
    + alice-eth2                        : up
    + master-powergres_drbd.drbd.drbd:0 : 10000

Migration summary:
* Node alice:
* Node bob:
</pre>
r オプションは停止中のリソース、-f オプションはリソースの障害回数、-A オプションはノードの属性を表示するオプションです。<br/>
表示はデフォルトでは 15 秒間隔で更新されます。<br/>
更新の間隔は -i オプションで指定することもできます。<br/>
終了するには Ctrl キーを押しながら C キーを押します。<br/>
詳細については crm_mon コマンドのオンラインマニュアルを参照してください。<br/>
<br/>
「Last updated:」の後に最後にクラスタの状態が更新された日時、「Stack:」の後に Pacemaker とともにクラスタの制御を行うソフトウェア名、「Current DC:」の後に現在の DC のノード名、「Version:」の後に Pacemaker のバージョンが表示されます。<br/>
<br/>
**DC とは**  
**DC (Desinated Co-ordinator) は、クラスタ全体を統一的に管理するノードで、クラスタ内から一台のノードが選択されます。**
**DC になったノードではほかのノードより多くのログメッセージが出力されます。**  
<br/>
「Online:」の後に Pacemaker が起動しているノード名が表示されます。 起動していないノードがあれば「OFFLINE:」の後にノード名が表示されます。<br/>
<pre>
Online: [ alice bob ]
</pre>
「Full list of resources:」の下にリソースの状態が表示されます。<br/>
リソースの状態は、リソース名とリソースを制御するリソースエージェント名の後に表示され、Started が起動している状態、Stopped が停止している状態を表します。<br/>
また、「Started」の後にはリソースが起動しているノード名が表示されます。<br/>
<br/>
「Master/Slave Set:」の後にマスタスレーブリソース名が表示されます。<br/>
マスタスレーブリソースは、複数のノードで起動するリソースで、起動中のリソースにはマスタとスレーブの状態があります。<br/>
PowerGres HA Pacemaker 版では、DRBD リソースがマスタスレーブリソースになります。<br/>
<br/>
DRBD リソースでは、「Masters:」の後に DRBD リソースがプライマルロールとして起動しているノード名、「Slaves:」の後にセカンダリロールとして起動しているノード名が表示されます。 DRBD リソースが停止してい場合には「Stopped:」の後にノード名が表示されます。<br/>
<pre>
 Master/Slave Set: powergres_drbd.drbd.ms_drbd
     Masters: [ alice ]
     Slaves: [ bob ]
</pre>
<br/>
「Resource Group:」の後にグループ名が表示されます。 グループは複数のリソースを一つにまとめたものです。<br/>
PowerGres HA Pacemaker 版では、PowerGres サービスとノードごとの STONITH サービスを構成するリソースがグループになります。<br/>
「Resource Group:」の下にグループを構成するリソースの状態が表示されます。<br/>
<pre>
 Resource Group: powergres.pgsql-drbd.group_pgsql
     powergres_drbd.drbd.filesystem     (ocf::heartbeat:Filesystem):    Started alice
     powergres_ipaddr.ipaddr    (ocf::heartbeat:IPaddr2):       Started alice
     powergres.pgsql-drbd.pgsql (ocf::heartbeat:pgsql): Started alice
</pre>
「Node Attributes:」の下にノードの属性がノードごとに表示されます。<br/>
コミュニケーションパスの状態は、接続先のノード名とネットワークインタフェース名を - でつないだ属性名の後に表示され、up が通信できている状態、dead が通信できていない状態を表します。<br/>
<pre>
* Node alice:
    + bob-eth0                          : up
    + bob-eth1                          : up
    + bob-eth2                          : up
    + master-powergres_drbd.drbd.drbd:1 : 10000
</pre>
「Migration summary:」の下にリソースの障害回数がノードごとに表示されます。<br/>
障害が検知されていない場合には表示されません。<br/>
リソース名の後には「migration-threshold=」の後にリソースをほかのノードに切り替えて起動するかの閾値になる障害回数、「fail-count=」の後に障害の検知された回数、「last-failure=」の後に最後に障害の検知された日時が表示されます。<br/>
<pre>
* Node alice:
   powergres.pgsql-drbd.pgsql: migration-threshold=2 fail-count=1 last-failure='Sat Nov 16 23:23:33 2013'
</pre>
リソースの障害が検知されると障害回数が増えていきます。<br/>
障害回数が閾値に達していない場合には同じノードで、閾値に達した場合にはほかのノードに切り替えてリソースの起動が試みられます。<br/>
 リソースの障害回数は障害を解消した後に手動で消去します。<br/>
 障害回数の消去については サービスの障害履歴の削除 を参照してください。<br/>
