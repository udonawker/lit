■Zabbix側でのSNMP受信ログ<br>
/var/log/messages<br>
  ⇒ snmptrapd[プロセスID]: 送信元アドレス: ~<br>

/var/log/snmptt/snmptt.log<br>

■エラーログ(unmatch?)<br>
/var/log/zabbix/zabbix_server.log<br>

■tcpdumpでsnmptrapが受信できているか確認<br>
Zabbixサーバー上で以下のコマンドでsnmptrapのキャプチャを行ってください。<br>
tcpdump -i <zabbixサーバのインターフェース> src host <snmptrapするホスト> and dst port snmptrap<br>

■[【Zabbix】snmptrapの監視設定が上手くいかない時の対処方法](https://qiita.com/shiojojo/items/dd7e663f2bae40b98266)<br>
■[ZabbixでSNMPTTを利用してSNMPトラップを監視する](https://www.cybertrust.co.jp/blog/linux-oss/system-monitoring/tech-lounge/zbx-tl-001.html)<br>
■[@@ZABBIXの設定](https://www.bigbang.mydns.jp/zabbix-x.htm#snmptttrap-kanshi)<br>
■[Zabbix等で大量のSNMPトラップをオープンソースソフトウェアで処理するための設定とチューニングの検証](https://qiita.com/tj8000rpm/items/1365c2e975ab455fdceb)<br>
snmptrap コマンドシェル<br>
■[SNMPTT その2@@@変数定義 ](http://ricemalt.blog98.fc2.com/blog-entry-21.html)<br>

<br>

[【Zabbix2.0】snmpttによるトラップメッセージ](https://www.slideshare.net/qryuu/zabbix20snm-ptt)

snmpttによるTrapの動き <br>

1. snmptrapdがsnmpTrapを受信 
2. snmptrapdがsnmpttのhandlerをキック
3. Handlerがspoolファイルを生成 
4. Snmpttはiniファイルで指定されたsleep秒数毎にspoolファイルを読み込み 
5. Snmpttはmib変換ファイルに従い、書式整形、カテゴリ名、重要度情報を付加し、ファイルに出 力 
6. Zabbixのsnmp trapperが５．のファイルを読み込む 
7. log内の“ZBXTRAP” 文字列の後ろの文字列をIPアドレスと解釈し、当該IPアドレスと一致する SNMPインターフェイスを持つホストの タイプ：snmpトラップ キー:snmptrap[<重要度> “カテゴリ名”] に対してメッセージを登録する。 
8. 重要度、カテゴリ名が一致しない場合 タイプ：snmpトラップ キー:snmptrap.fallbak に対してメッセージを登録する。 
9. IPアドレスが一致しない場合、アイテムには登録せずzabbix_server.log(zabbix_proxy.log)に unmatched trap received from[IPaddress]:メッセージ というログが記録される。 ※ＩＰアドレスが登録されていないホストからのTrapを集約登録する機能は無い。 


[SNMPトラップ受信の設定](https://secure.nanako-net.info/redmine/projects/know-how/wiki/Zabbix-conf-snmptrap)
