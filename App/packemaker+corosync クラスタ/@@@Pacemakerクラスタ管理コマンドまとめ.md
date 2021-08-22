## [Pacemakerクラスタ管理コマンドまとめ](https://kan3aa.hatenablog.com/)

## 1. pcsバージョン確認
```
[root@centos01 ~]# pcs --version
0.9.137
```

## 2. クラスタ起動
全ノードのpacemaker/corosyncサービスを同時に起動する場合は以下の通り。<br>
```
[root@centos01 ~]# pcs cluster start --all
centos01: Starting Cluster...
centos02: Starting Cluster...
```

ノード個別にサービスを起動したい場合は以下の通り。<br>
```
[root@centos01 ~]# pcs cluster start centos02
centos02: Starting Cluster...
```

## 3. クラスタ停止
全ノードのpacemaker/corosyncサービスを同時に停止する場合は以下の通り。
```
[root@centos01 ~]# pcs status
Cluster name:
Last updated: Thu Jun 25 14:08:44 2015
Last change: Wed Jun 24 19:20:03 2015
Stack: corosync
Current DC: centos01 (1) - partition with quorum
Version: 1.1.12-a14efad
2 Nodes configured
10 Resources configured


Online: [ centos01 centos02 ]

Full list of resources:

 Resource Group: GroupPostgreSQL
     FilesystemForPostgreSQL    (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForPostgreSQL    (ocf::heartbeat:IPaddr2):       Started centos01
     PostgreSQL    (ocf::heartbeat:pgsql): Started centos01
 Resource Group: GroupNFS
     FilesystemForNFS   (ocf::heartbeat:Filesystem):    Started centos02
     VirtualIPForNFS   (ocf::heartbeat:IPaddr2):       Started centos02
     NFS   (ocf::heartbeat:nfsserver):     Started centos02
 Clone Set: MonitorGateway-clone [MonitorGateway]
     Started: [ centos01 centos02 ]
 StonithForCentos01    (stonith:fence_ipmilan):        Started centos02
 StonithForCentos02    (stonith:fence_ipmilan):        Started centos01

PCSD Status:
  centos01: Online
  centos02: Online

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
 ```

 ## 5. クラスタ設定取得
 ```
 [root@centos01 ~]# pcs config
Cluster Name:
Corosync Nodes:
 centos01 centos02
Pacemaker Nodes:
 centos01 centos02

...
```

## 6. 特定ノードをスタンバイモードに移行
下記コマンドにて、特定ノードまたは全ノードをスタンバイモードへ移行できる。<br>
スタンバイモードに移行したノードではリソース実行が不可となるため、移行前にリソースが実行されていた場合はリソース実行可能なノードへフェールオーバーする。<br>
```
pcs cluster standby <node name> [--all]
```

実際の操作例は以下の通り。<br>
```
[root@centos01 ~]# pcs status
Cluster name:
Last updated: Thu Jun 25 14:16:41 2015
Last change: Thu Jun 25 14:16:39 2015
Stack: corosync
Current DC: centos01 (1) - partition with quorum
Version: 1.1.12-a14efad
2 Nodes configured
10 Resources configured


Online: [ centos01 centos02 ]

Full list of resources:

 Resource Group: GroupPostgreSQL
     FilesystemForPostgreSQL    (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForPostgreSQL    (ocf::heartbeat:IPaddr2):       Started centos01
     PostgreSQL    (ocf::heartbeat:pgsql): Started centos01
 Resource Group: GroupNFS
     FilesystemForNFS   (ocf::heartbeat:Filesystem):    Started centos02
     VirtualIPForNFS   (ocf::heartbeat:IPaddr2):       Started centos02
     NFS   (ocf::heartbeat:nfsserver):     Started centos02
 Clone Set: MonitorGateway-clone [MonitorGateway]
     Started: [ centos01 centos02 ]
 StonithForCentos01    (stonith:fence_ipmilan):        Started centos02
 StonithForCentos02    (stonith:fence_ipmilan):        Started centos01

PCSD Status:
  centos01: Online
  centos02: Online

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@centos01 ~]#
[root@centos01 ~]# pcs cluster standby centos02
[root@centos01 ~]#
[root@centos01 ~]# pcs status
Cluster name:
Last updated: Thu Jun 25 14:17:16 2015
Last change: Thu Jun 25 14:17:13 2015
Stack: corosync
Current DC: centos01 (1) - partition with quorum
Version: 1.1.12-a14efad
2 Nodes configured
10 Resources configured


Node centos02 (2): standby
Online: [ centos01 ]

Full list of resources:

 Resource Group: GroupPostgreSQL
     FilesystemForPostgreSQL    (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForPostgreSQL    (ocf::heartbeat:IPaddr2):       Started centos01
     PostgreSQL    (ocf::heartbeat:pgsql): Started centos01
 Resource Group: GroupNFS
     FilesystemForNFS   (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForNFS   (ocf::heartbeat:IPaddr2):       Started centos01
     NFS   (ocf::heartbeat:nfsserver):     Started centos01
 Clone Set: MonitorGateway-clone [MonitorGateway]
     Started: [ centos01 ]
     Stopped: [ centos02 ]
 StonithForCentos01    (stonith:fence_ipmilan):        Stopped
 StonithForCentos02    (stonith:fence_ipmilan):        Started centos01

PCSD Status:
  centos01: Online
  centos02: Online

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
```

## 7. 特定ノードをスタンバイモードから復帰
```
pcs cluster unstandby <node name>
```
実際の操作例は以下の通り。<br>
```
[root@centos01 ~]# pcs cluster unstandby centos02
[root@centos01 ~]#
[root@centos01 ~]# pcs status
Cluster name:
Last updated: Thu Jun 25 14:18:14 2015
Last change: Thu Jun 25 14:18:13 2015
Stack: corosync
Current DC: centos01 (1) - partition with quorum
Version: 1.1.12-a14efad
2 Nodes configured
10 Resources configured


Online: [ centos01 centos02 ]

Full list of resources:

 Resource Group: GroupPostgreSQL
     FilesystemForPostgreSQL    (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForPostgreSQL    (ocf::heartbeat:IPaddr2):       Started centos01
     PostgreSQL    (ocf::heartbeat:pgsql): Started centos01
 Resource Group: GroupNFS
     FilesystemForNFS   (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForNFS   (ocf::heartbeat:IPaddr2):       Started centos01
     NFS   (ocf::heartbeat:nfsserver):     Started centos01
 Clone Set: MonitorGateway-clone [MonitorGateway]
     Started: [ centos01 centos02 ]
 StonithForCentos01    (stonith:fence_ipmilan):        Started centos02
 StonithForCentos02    (stonith:fence_ipmilan):        Started centos01

PCSD Status:
  centos01: Online
  centos02: Online

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
```

## 8. 特定リソースの手動フェールオーバー
```
pcs resource move <resource id> [destination node name]
```
実際の操作例は以下の通り。<br>

```
[root@centos01 ~]# pcs status
Cluster name:
Last updated: Thu Jun 25 14:15:38 2015
Last change: Wed Jun 24 19:20:03 2015
Stack: corosync
Current DC: centos01 (1) - partition with quorum
Version: 1.1.12-a14efad
2 Nodes configured
10 Resources configured


Online: [ centos01 centos02 ]

Full list of resources:

 Resource Group: GroupPostgreSQL
     FilesystemForPostgreSQL    (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForPostgreSQL    (ocf::heartbeat:IPaddr2):       Started centos01
     PostgreSQL    (ocf::heartbeat:pgsql): Started centos01
 Resource Group: GroupNFS
     FilesystemForNFS   (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForNFS   (ocf::heartbeat:IPaddr2):       Started centos01
     NFS   (ocf::heartbeat:nfsserver):     Started centos01
 Clone Set: MonitorGateway-clone [MonitorGateway]
     Started: [ centos01 centos02 ]
 StonithForCentos01    (stonith:fence_ipmilan):        Started centos02
 StonithForCentos02    (stonith:fence_ipmilan):        Started centos01

PCSD Status:
  centos01: Online
  centos02: Online

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@centos01 ~]#
[root@centos01 ~]#
[root@centos01 ~]# pcs resource move GroupNFS
[root@centos01 ~]#
[root@centos01 ~]# pcs status
Cluster name:
Last updated: Thu Jun 25 14:15:56 2015
Last change: Thu Jun 25 14:15:51 2015
Stack: corosync
Current DC: centos01 (1) - partition with quorum
Version: 1.1.12-a14efad
2 Nodes configured
10 Resources configured


Online: [ centos01 centos02 ]

Full list of resources:

 Resource Group: GroupPostgreSQL
     FilesystemForPostgreSQL    (ocf::heartbeat:Filesystem):    Started centos01
     VirtualIPForPostgreSQL    (ocf::heartbeat:IPaddr2):       Started centos01
     PostgreSQL    (ocf::heartbeat:pgsql): Started centos01
 Resource Group: GroupNFS
     FilesystemForNFS   (ocf::heartbeat:Filesystem):    Started centos02
     VirtualIPForNFS   (ocf::heartbeat:IPaddr2):       Started centos02
     NFS   (ocf::heartbeat:nfsserver):     Started centos02
 Clone Set: MonitorGateway-clone [MonitorGateway]
     Started: [ centos01 centos02 ]
 StonithForCentos01    (stonith:fence_ipmilan):        Started centos02
 StonithForCentos02    (stonith:fence_ipmilan):        Started centos01

PCSD Status:
  centos01: Online
  centos02: Online

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
```

## 9. 特定リソースのフェールオーバー履歴の削除
主系にて障害が発生しリソースが自動でフェールオーバーした場合、主系を復旧後にリソースをフェールバックしたい場合は事前にフェールオーバー履歴の削除が必要となる。（過去に障害が検出されたノードにはリソースを移動できないため）<br>
```
pcs resoruce clear <resource id>
```

## 10. 手動でのフェンシング（STONITH機能によるサーバー再起動）
```
pcs stonith fence <node name>
```


