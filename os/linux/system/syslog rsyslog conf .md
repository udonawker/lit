## [LinuCレベル1 1.09.2 システムのログ](https://linuc.org/study/samples/3218/?hm_ct=3eb824ddc0011d34ef2a9dee409b1391&hm_cv=3f25211b47622df5e60f618ed4840d13&hm_cs=3405646265fcc645dc30868.60445446&hm_mid=majtb)

rsyslogデーモンは、アプリケーションなどが出力するメッセージを集めてログファイルに出力します。<br>
ログ出力先は、「/etc/rsyslog.conf」ファイルで設定することができます。設定ファイルの記述方法の一つに、ファシリティとプライオリティを条件として、ログファイルを指定する方法があります。<br>
<br>
構文は以下の通りです。<br>
<br>
```
ファシリティ.プライオリティ	出力先ファイルパス
```

なお、条件（ファシリティとプライオリティ）を複数指定したい場合は、セミコロン（;）でつなげます。<br>
<br>
ログを分類するファシリティには以下の種類があります。<br>
<br>
ファシリティ名		概要<br>
```
kern     ：	カーネルのメッセージ
user     ：	ユーザープロセスのメッセージ
mail     ：	メールシステムのメッセージ
daemon   ：	システムデーモンのメッセージ
auth     ：	認証サービスのメッセージ
syslog   ：	syslogdによる内部メッセージ
lpr      ：	プリンタサービスのメッセージ
news     ：	ニュースサービスのメッセージ
uucp     ：	uucp転送を行うプログラムのメッセージ
cron     ：	cronのメッセージ
authpriv ：	認証サービスのメッセージ
ftp      ：	ftpサービスのメッセージ
local0～local7	：	ローカル利用用
```

メッセージの優先度であるプライオリティには以下の種類があります。（優先度が高い順に記載しています）<br>
<br>
プライオリティ名		概要<br>
```
emerg   ：	システムが動作しないような状態
alert   ：	緊急で対応すべきエラー
crit    ：	致命的なエラー
err     ：	一般的なエラー
warn    ：	警告
notice  ：	通知
info    ：	情報
debug   ：	デバッグ情報
```

プライオリティの前に、イコール（=）をつけると指定されたプライオリティのみ選択されます。<br>
一方、プライオリティの前に何もつけない場合は、指定されたプライオリティもしくは、それよりも高いプライオリティが選択されます。また、プライオリティの前に、感嘆符（!）をつけた場合は指定したプライオリティ以外のプライオリティ全てが選択されます。<br>
<br>
この他に、アスタリスク (*) を使用してすべてのファシリティもしくはプライオリティを定義することもできます。<br>
また、プライオリティに「none」を指定した場合は、「そのファシリティの出力を行わない」という設定になります。<br>
<br>
それでは、例題の設定を確認します。<br>
<br>
```
*.info;mail.none;authpriv.none;cron.none                /var/log/messages
```

条件にマッチしたログは、「/var/log/messages」に出力するという設定で、条件はセミコロン（;）を用いて4つ設定されていることが分かります。<br>
<br>
*.info	：	すべてのファシリティ (*) でinfoもしくはinfoより高い優先度を選択<br>
mail.none	：	mailのファシリティの出力は行わない<br>
authpriv.none	：	authprivのファシリティの出力は行わない<br>
cron.none	：	cronのファシリティの出力は行わない<br>
