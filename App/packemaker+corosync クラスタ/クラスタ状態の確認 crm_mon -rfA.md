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
r オプションは停止中のリソース、-f オプションはリソースの障害回数、-A オプションはノードの属性を表示するオプションです。  
表示はデフォルトでは 15 秒間隔で更新されます。  
更新の間隔は -i オプションで指定することもできます。  
終了するには Ctrl キーを押しながら C キーを押します。  
詳細については crm_mon コマンドのオンラインマニュアルを参照してください。  
<br/>
「Last updated:」の後に最後にクラスタの状態が更新された日時、「Stack:」の後に Pacemaker とともにクラスタの制御を行うソフトウェア名、「Current DC:」の後に現在の DC のノード名、「Version:」の後に Pacemaker のバージョンが表示されます。  
**DC とは**  
**DC (Desinated Co-ordinator) は、クラスタ全体を統一的に管理するノードで、クラスタ内から一台のノードが選択されます。**
**DC になったノードではほかのノードより多くのログメッセージが出力されます。**  
