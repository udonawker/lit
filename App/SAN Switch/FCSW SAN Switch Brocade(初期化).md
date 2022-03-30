## [SAN Switch Brocade(初期化)](http://network-cisco.seesaa.net/article/265837451.html)

```
1.スイッチの初期化
switchdisable
コマンドでスイッチをオフラインにする。

configdefault
コマンドで初期化する。

reboot
コマンドでスイッチを再起動する必要があります。

IPアドレスやスイッチ名、Zone設定など一部の
情報はこれでは戻りません。

2.Zone情報の削除
cfgdisable
コマンドでZoneの無効化を行う。

cfgclear
コマンドでZoneの削除。

cfgsave
コマンドで新しくなったZone情報の保存。

ほとんどの場合これで初期状態に戻ります。
万が一もどらないようであれば個別に削除してください。

3.それ以外の情報を個別に初期化する場合

・IPアドレスの初期化
ipaddrset
Ethernet IP Address : 10.77.77.77
Ethernet Subnetmask : 255.0.0.0
Fibre Channel IP Address [none] :
Fibre Channel Subnetmask [none] :
Gateway IP Address : none
DHCP [off] :

・スイッチ名の初期化
switchname "switch"

デフォルトスイッチ名はswitch

・ポート設定のクリア
portcfgdefault 0 (ポートの数だけ実施する)

・Zone情報がないときにデバイス通信で使用されるDefault Zoningの設定
defzone --allaccess
cfgsave

・SNMP設定クリア
snmpconfig --default (snmpv1,snmpv3)

・Fabric Watchの設定クリア
fwsettodefault
fwalarmsfilterset 0
fwconfigure --disable --port 0　(ポートの数だけ実施する)

・ユーザの設定クリア
userconfig --delete ユーザ名

root,factory,admin,userはデフォルトユーザとなります。
ユーザを確認する場合は
userconfig --show -a

---
SANSW1:FID128:admin> userconfig --show -a
Account name: root
Description: root
Enabled: Yes
Password Last Change Date: Wed Mar 30 2011 (UTC)
Password Expiration Date: Not Applicable (UTC)
Locked: No
Home LF Role: root
Role-LF List: root: 1-128
Chassis Role: root
Home LF: 128
Account name: factory
Description: Diagnostics
Enabled: Yes
Password Last Change Date: Wed Mar 30 2011 (UTC)
Password Expiration Date: Not Applicable (UTC)
Locked: No
Home LF Role: factory
Role-LF List: factory: 1-128
Chassis Role: factory
Home LF: 128
Account name: admin
Description: Administrator
Enabled: Yes
Password Last Change Date: Wed Apr 6 2011 (UTC)
Password Expiration Date: Not Applicable (UTC)
Locked: No
Home LF Role: admin
Role-LF List: admin: 1-128
Chassis Role: admin
---

・セッションタイムアウトの初期化
timeout 10
デフォルト10分

・Ethernetのコネクションモード初期化
ifmodeset eth0

デフォルトはAuto-negotiateとなります。
```
