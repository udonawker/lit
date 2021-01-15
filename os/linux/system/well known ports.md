ポート番号とはコンピュータが通信に使用するプログラムを識別するための番号です。ポート番号は「0～65535」の範囲で割り当てられています。<br>
このポート番号は下記の3つに分類されています。<br>

### Well Known Ports
ポート番号の範囲は0～1023であり、IANAで管理<br>
アプリケーション層の特定のプロトコルを割り当てるための領域<br>
### Registered Ports
ポート番号の範囲は1024～49151<br>
特定目的のために用途が予約されている領域<br>
### Dynamic and/or Private Ports
ポート番号の範囲は49152～65535<br>
クライアントが、始点ポートとしてポート番号を使う場合の領域<br>
<br>
以下は主要なWell Known Portsです。<br>
* DNS(53)
* NTP(123)
* SSH(22)
* FTP(21)
* DHCP(67)
* HTTP(80)
* HTTPS(443)
* SMTP(25)
* SMTP-submission(587)
* SMTPS(465)
* IMAP(143)
* IMAPS(993)
* POP3(110)
* POP3S(995)
* LDAP(389)
* LDAPS(636)
* SNMP(161)
* SNMPTRAP(162)
* SYSLOG(514)
