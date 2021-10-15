digコマンドはDNSサーバに問い合わせを行い、ドメイン名からIPアドレスを確認したり、IPアドレスからドメイン名を確認することができるコマンドです。<br>
新しくDNSサーバを用意した時に問題なく名前解決ができるか確認したり、障害発生時の切り分け等に利用することができます。<br>

digコマンドの主なオプションは以下の通りです。<br>
```
-x IPアドレス        ： 逆引きを行う
-t クエリタイプ      ： クエリタイプを指定する
-c クエリクラス      ： クエリクラスを指定する
-p ポート番号        ： 問い合わせに使用するポート番号（デフォルトは53）
-4                   ： IPv4を利用する
-6                   ： IPv6を利用する
+debug、+nodebug     ： デバッグモードの有効／無効
+recurse、+norecurse ： 再帰的な探索の有効／無効
+retry=回数          ： リトライの回数(デフォルトは4回)
+time=秒数           ： タイムアウトまでの秒数(デフォルトは4秒)
+defname、+nodefname ： デフォルトドメインを使用するかどうか
+search、+nosearch   ： ドメインサーチリストを使うかどうか
+trace、+notrace     ： ルートDNSからの名前解決をトレースするかどうか
+tcp、+vc            ： TCPを利用するかどうか
+dnssec、+nodnssec   ： DNSSECを使用するかどうか
```

コマンドの実行例は以下です。<br>
```
$ dig www.example.com @ns.example.com +tcp
; <<>> DiG 9.9.4-RedHat-9.9.4-61.el7 <<>> www.example.com @ns.example.com +tcp
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 25555
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.example.com.            IN      A

;; ANSWER SECTION:
www.example.com.     3600    IN      A       10.1.1.10

;; Query time: 0 msec
;; SERVER: ns.example.com#53(ns.example.com)
;; WHEN: 月  9月 13 13:33:47 JST 2021
;; MSG SIZE  rcvd: 63
```
