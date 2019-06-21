引用[「Systemd」を理解する ーシステム管理編ー](http://equj65.net/tech/systemd-manage/ "「Systemd」を理解する ーシステム管理編ー")


# Systemd」を理解する ーシステム管理編ー
前回の記事[「Systemd」を理解するーシステム起動編ー](http://equj65.net/tech/systemd-boot/ "「Systemd」を理解するーシステム起動編ー")では、Systemdの概念とSystemdによるLinux起動プロセスの内容を解説させていただいた。第二回となる今回の記事では、Systemdを利用したシステムの管理方法を記載していきたいと思う。<br/>
今回の記事ではSystemdの`systemctl`コマンドを利用した[サービス（プロセス）管理方法](http://equj65.net/tech/systemd-manage/#servicemanage "サービス（プロセス）管理方法")と、`journalctl`コマンドを利用した[Systemd journalログ照会](http://equj65.net/tech/systemd-manage/#journalmanage "Systemd journalログ照会")の2章立てでSystemdによるシステム管理を解説させていただく。また、各コマンドは先日リリースされたCentOS7上で動作確認させていただいた。<br/>

## systemctlを利用してサービスを管理する
Systemd環境にてサービス管理を行う場合、主に`systemctl`コマンドを利用するが、一部、従来のコマンドも利用可能となっている。使途別のコマンドを見ていこう。<br/>

### Unitの起動／停止／再起動など
前回の記事でも説明させていただいたが、Systemd上で起動するサービスや各種ファイルシステムのマウント、ソケットの監視等の振る舞いは全てUnitとして表現される。`systemctl`コマンドを利用することで、これらのUnitの起動／停止（Unitはサービスに限った話ではないので、有効化・無効化とも表現できる）を行う事ができる。<br/>

<pre>
systemctl [Unitコマンド] [Unit名]
</pre>

Unitコマンドには以下の種類がある。この辺の考え方は従来のserviceコマンドと似ている。<br/

|*Unitコマンド* |*意味*|
|---       |---   |
|start|Unitを開始する。|
|stop|Unitを停止する。|
|reload|Unitに対して設定ファイルの再読み込みを促す。<br/>（対象のUnitがreload動作に対応している必要がある）|
|restart|起動中のUnitを停止後、起動（stop -> start）する。<br/>対象のUnitが停止中である場合、起動操作のみ実施する。|
|try-restart|起動中のUnitを停止後、起動する。<br/>対象Unitが停止中である場合、起動操作は実施しない。<br/>（Unit起動中のみ再起動する）|
|reload-or-restart|対象のUnitがreloadに対応している場合、reloadする。<br/>reloadに対応していない場合はrestart（stop -> start）する。<br/>対象Unitが停止中である場合、起動操作のみ実施する。|
|reload-or-try-restart|reload-or-restartと同じだが、対象Unitが停止中の場合、起動操作は行わない。|
|kill|対象のUnitに対してシグナルを送信する。<br/>デフォルトで送信されるシグナルはSIGTERM（killコマンドと同じ）である。<br/>--signal=[シグナル名]オプションで送信するシグナルを変更できる。|

なお、従来の`service`コマンドも引き続き利用可能だ。<br/>
<pre>
service [Unit名] [Unitコマンド]
</pre>

#### systemctlとserviceの違い
取り扱う事ができるUnitタイプが異なる。`systemctl`は全てのUnitタイプを扱えるのに対して、`service`はserviceタイプのUnitしか取り扱う事ができない。<br;>
また、`systemctl`を利用する場合は、拡張子を含めたUnit名（`*.mount`、`*.socket`等）を指定する必要がある（※）が、`service`はserviceタイプのUnitのみ取り扱うため、Unitの拡張子は指定できない。（`service`コマンド内で自動的に.serviceが付与される）
※ ただし、serviceタイプのUnitは拡張子を省略可能だ。そのため、`systemctl start/stop httpd`のように指定できる。<br/>

### システムブート時のサービスの起動設定
#### 起動ON / OFFの設定
システムブート時のサービスの起動設定は`systemctl`コマンドと`chkconfig`コマンドで設定可能だ。<br/>
<pre>
systemctl enable/disable [Unit名]
</pre>
<pre>
$ sudo systemctl enable httpd
ln -s '/usr/lib/systemd/system/httpd.service' '/etc/systemd/system/multi-user.target.wants/httpd.service'
 
$ sudo systemctl disable httpd
rm '/etc/systemd/system/multi-user.target.wants/httpd.service'
</pre>

`systemctl`は起動設定を行うtarget（このtargetの設定方法は次項参照）のwantsディレクトリに対して対象のUnitへのシンボリックリンクを作成/削除する（依存性を設定する）。<br/>
これは従来の`/etc/init.d/rc[runlevel].d/`に対するシンボリックリンク作成/削除に相当する処理と言えるだろう。
なお、従来の`chkconfig`も利用可能となっている。<br/>

<pre>
chkconfig [Unit名] on/off
</pre>
<pre>
$ sudo chkconfig httpd on
情報:'systemctl enable httpd.service'へ転送しています。
ln -s '/usr/lib/systemd/system/httpd.service' '/etc/systemd/system/multi-user.target.wants/httpd.service'
 
$sudo chkconfig httpd off
情報:'systemctl disable httpd.service'へ転送しています。
rm '/etc/systemd/system/multi-user.target.wants/httpd.service'
</pre>

`chkconfig`をを実行した場合、その内容は`systemctl`に転送され、`systemctl`と同様の処理が行われる。<br/>
また、`--level`オプションは指定可能であるものの、その指定は無視（設定方法は次項参照）される。

#### 起動設定するtargetの指定方法（起動設定するランレベルの指定方法）

前回の記事でも説明させていただいたが、Systemdにランレベルは存在しない。<br/>
代わりに従来のランレベルに相当するtargetタイプのUnitが用意されており、これらUnitへの依存性を定義することでON / OFFを設定する。<br/>
初期状態では以下のtargetが用意されている。<br/>

|*target名* |*内容*|*従来のランレベル<br/>(RedHat)*|
|---       |---   |--- |
|poweroff.target|システム停止|0|
|rescue.target|シングルユーザモード|1|
|multi-user.target|マルチユーザモード<br/>（コンソールログイン）|3|
|graphical.target|マルチユーザ＋GUI|5|
|reboot.target|再起動|6|
|emergency.target|緊急シェル<br/>rescue.targetよりも起動対象が少ない<br/>ルートファイルシステムですらマウントできない場合などに利用|無し|

`systemctl`や`chkconfig`コマンドが起動設定を行うtargetはUnitファイル内の[Install]セクションに在る`WantedBy`で設定する。<br/>
（`systemctl`のオプションや`chkconfig --level`は利用しない）<br/>
<pre>
$ cat /usr/lib/systemd/system/httpd.service 
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
 
[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd
ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target
</pre>
上記のUnitファイルは16行目に`WantedBy=multi-user.target`が指定されている。<br/>
この場合、`systemctl`や`chkconfig`コマンドは`multi-user.target`を対象として起動設定を行う。<br/>
（`multi-user.target`は従来のランレベル3に相当する）<br/>
<br/>
WantedByのUnitを変更することで起動設定を行うtargetを変更できる。<br/>
（Unitファイルを編集する場合は、`/usr/lib/systemd/system`配下を直接編集するのでは無く、`/etc/systemd/system`配下にコピーのうえ編集すること）<br/>

#### Unitのマスキング（無効化）

Systemdではmaskという操作を実行できる。mask操作を行う事で、サービスの起動自体不可能になる。[systemctl(1)](http://www.freedesktop.org/software/systemd/man/systemctl.html#mask%20NAME... "systemctl(1)")では、これはdisableの強化版だとの説明されている。<br/>
<pre>
systemctl mask/unmask [Unit名]
</pre>
<pre>
$ sudo systemctl mask httpd
ln -s '/dev/null' '/etc/systemd/system/httpd.service'
 
$ sudo systemctl unmask httpd
rm '/etc/systemd/system/httpd.service'
</pre>
実行結果を見ると分かるように、`/etc/systemd/system`上のUnitファイルに`/dev/null`へのシンボリックリンクが張られている。<br/>
前回の記事でも紹介させていただいたが、Unitファイルは`/etc/systemd/system`⇒`/usr/lib/systemd/system`の順に参照される。<br/>
優先度の高い`/etc/systemd/system`上に`/dev/null`へのシンボリックリンクを配置することで、対象Unitへの操作を無効化している事が分かる。

|*ディレクトリ*|*設定内容*|
|--- |---|
|/usr/lib/systemd/system|インストール時の初期設定<br/>当ディレクトリ内のUnitは編集しない|
|/etc/systemd/system|ユーザによる個別設定<br/>デフォルトの設定を変更する場合は、当ディレクトリにUnitファイルをコピーして編集する<br/>（Systemdは当ディレクトリのUnitを優先する）|
ちなみに、`/etc/systemd/system`配下に既にUnit定義ファイルが存在する場合、マスク操作は実行できない。（実行できたらユーザ個別設定が上書きされてしまう）<br/>

<pre>
$ file /etc/systemd/system/httpd.service
/etc/systemd/system/httpd.service: ASCII text
 
$ #既にUnit定義ファイルが存在するからmask化失敗
$ sudo systemctl mask httpd.service
Failed to issue method call: File exists
</pre>

#### 起動ON / OFF設定の確認方法
システムブート時の起動ON/OFF設定は`systemctl is-enabled`コマンドで確認できる。<br/>
<pre>
systemctl is-enabled [Unit名]
</pre>
<pre>
$ systemctl is-enabled httpd.service
enabled
</pre>
上記の例では”enabled”となっているため、`httpd.service`はシステムブート時に有効化される。<br/>
実行結果には”enabled”の他に以下のような種類がある。<br/>

|*結果*|*内容*|
|--- |---|
|enabled|有効化されている。<br/>UnitファイルのWantedBy句に指定されたtargetと同時に起動する。|
|disabled|無効化されている。<br/>UnitファイルのWantedBy句に指定されたtargetと同時起動しない。|
|masked|マスクされている。<br/>自動起動対象とならないし、手動起動もできない。|
|linked|リンクされている。<br/>Unitファイルは異なるUnitファイルへのシンボリックリンクとなっている。<br/>（Systemdはリンク先の別Unitファイルの設定を読み取る）|
|static|有効化／無効化の対象外。<br/>UnitファイルにWantedBy句がそもそも指定されていない。|






