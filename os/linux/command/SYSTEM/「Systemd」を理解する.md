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

#### ランレベルを取り扱う

従来のランレベル関連の操作に相当する操作を説明する。

##### 現在稼働するtarget（ランレベル）の変更
以下のコマンドで現在稼働するtarget（従来のランレベル相当）を変更できる。<br/>
なお、対象とするUnitは「起動ON / OFFの設定」に記載したUnitを指定する。<br/>

<pre>
systemctl isolate [対象Target Unit名]
</pre>

##### デフォルトの起動target（デフォルトのランレベル）の変更
以下のコマンドでデフォルトで起動するtarget（デフォルトのランレベル相当）を変更できる。

<pre>
systemctl set-default [対象Target Unit名]
</pre>

<pre>
$ #デフォルトtargetをgraphical.targetに設定
$ #従来の「デフォルトランレベル=5設定」に相当
$ sudo systemctl set-default graphical.target
rm '/etc/systemd/system/default.target'
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'
</pre>

実行結果から分かるように`/etc/systemd/system/deafult.target`に`/usr/lib/systemd/graphical.target`へのシンボリックリンクを作成していることが分かる。<br/>
`default.target`はSystemdによるブートの基点となるUnitである。<br/>
Systemdはシステムブート時に`default.target`を探索し、`default.target`の設定を元にブートを操作を実行する。<br/>
従来のランレベル切り替えに相当する操作は、この`default.target`のリンク先を変更することで実現されている。<br/>

#### Unitの状態を把握する
次に個々のUnitの状態を確認するためのコマンド群を見ていこう。

##### 起動中のUnit一覧を取得

以下のコマンドを実行することで、有効化されているUnit一覧を取得できる。

<pre>
systemctl  または  systemctl list-units
</pre>

<pre>
$ #一部抜粋
$ #現在有効化されているUnitの一覧
$ systemctl list-units
UNIT                                                       LOAD   ACTIVE SUB       DESCRIPTION
proc-sys-fs-binfmt_misc.automount                          loaded active waiting   Arbitrary Executable File Formats File System Automount Poi
sys-subsystem-net-devices-enp0s3.device                    loaded active plugged   PRO/1000 MT Desktop Adapter
sys-subsystem-net-devices-enp0s8.device                    loaded active plugged   PRO/1000 MT Desktop Adapter
-.mount                                                    loaded active mounted   /
boot.mount                                                 loaded active mounted   /boot
dev-hugepages.mount                                        loaded active mounted   Huge Pages File System
dev-mqueue.mount                                           loaded active mounted   POSIX Message Queue File System
auditd.service                                             loaded active running   Security Auditing Service
avahi-daemon.service                                       loaded active running   Avahi mDNS/DNS-SD Stack
...
</pre>

また、`--type`オプションを利用することでUnitタイプを指定できる。

<pre>
$ #一部抜粋
$ #現在有効化されており、かつserviceタイプのUnit一覧
$ systemctl list-units --type=service
UNIT                                                        LOAD   ACTIVE SUB     DESCRIPTION
auditd.service                                              loaded active running Security Auditing Service
avahi-daemon.service                                        loaded active running Avahi mDNS/DNS-SD Stack
crond.service                                               loaded active running Command Scheduler
dbus.service                                                loaded active running D-Bus System Message Bus
firewalld.service                                           loaded active running firewalld - dynamic firewall daemon
getty@tty1.service                                          loaded active running Getty on tty1
...
</pre>

表示項目のうちUNITはUnit名、LOADはSystemdへの設定読み込み状況、ACTIVE、SUBがUnitの実行状態、DESCRIPTIONがUnitの概要を表している。<br/>
起動対象となっているにも関わらず、起動に失敗している場合はACTIVEやSUBがfailedといった表記となる。<br/>

##### Systemdが認識しているUnit一覧の表示

以下のコマンドで確認できる。

<pre>
systemctl list-unit-files
</pre>

<pre>
$ #一部抜粋
$ #Systemdが認識しているUnitの一覧
$ systemctl list-unit-files
UNIT FILE                                   STATE   
proc-sys-fs-binfmt_misc.automount           static  
dev-hugepages.mount                         static  
dev-mqueue.mount                            static  
proc-sys-fs-binfmt_misc.mount               static  
sys-fs-fuse-connections.mount               static  
sys-kernel-config.mount                     static  
sys-kernel-debug.mount                      static  
tmp.mount                                   disabled
brandbot.path                               disabled
systemd-ask-password-console.path           static  
systemd-ask-password-plymouth.path          static  
...
</pre>

STATE列はUNITの起動設定を表している。<br/>
表示されている内容は「起動ON / OFFの確認方法」に記載した表の内容と同様である。<br/>

##### Unitの現在の状態を確認
以下のコマンドでUnitの状態を確認できる。

<pre>
systemctl status [Unit名]
</pre>

<pre>
$ #apache起動
$ sudo systemctl start httpd.service
 
$ #apacheの状態確認 -起動状態-
$ systemctl status httpd.service
httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; linked)
   Active: active (running) since 土 2014-07-19 23:39:27 JST; 1min 34s ago
 Main PID: 2641 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/httpd.service
           ├─2641 /usr/sbin/httpd -DFOREGROUND
           ├─2642 /usr/sbin/httpd -DFOREGROUND
           ├─2643 /usr/sbin/httpd -DFOREGROUND
           ├─2644 /usr/sbin/httpd -DFOREGROUND
           ├─2645 /usr/sbin/httpd -DFOREGROUND
           └─2646 /usr/sbin/httpd -DFOREGROUND
 
$ #apache停止
$ sudo systemctl stop httpd.service
 
$ #apacheの状態確認 -停止状態-
$ systemctl status httpd.service
httpd.service - The Apache HTTP Server
 Loaded: loaded (/usr/lib/systemd/system/httpd.service; linked)
 Active: inactive (dead)
 
 7月 19 23:39:27 localhost.localdomain systemd[1]: Starting The Apache HTTP Server...
 7月 19 23:39:27 localhost.localdomain httpd[2641]: AH00558: httpd: Could not reliably determine the server's fully qualified domain...essage
 7月 19 23:39:27 localhost.localdomain systemd[1]: Started The Apache HTTP Server.
 7月 19 23:44:49 localhost.localdomain systemd[1]: Stopping The Apache HTTP Server...
 7月 19 23:44:50 localhost.localdomain systemd[1]: Stopped The Apache HTTP Server.
Hint: Some lines were ellipsized, use -l to show in full.
</pre>

調査対象Unitの現在の状況（上記例ではactive）や、対象Unitを元としたプロセス一覧などを把握できる。

#### UNITの依存関係を把握する

Unit間の依存関係は個々のUnitファイルに定義されている。<br/>
しかし、Unitファイルは多数存在し、全体の依存関係を把握するのは困難だ。<br/>
以下のコマンドで対象のUnitの依存関係をツリー構造で表示できる。<br/>

<pre>
systemctl list-dependencies [Unit名]
</pre>

<pre>
$ #一部抜粋
$ #apahceが依存しているUnit一覧を表示
$ systemctl list-dependencies httpd.service
httpd.service
├─system.slice
└─basic.target
  ├─firewalld.service
  ├─microcode.service
  ├─rhel-autorelabel-mark.service
  ├─rhel-autorelabel.service
  ├─rhel-configure.service
  ├─rhel-dmesg.service
  ├─rhel-loadmodules.service
  ├─paths.target
  ├─slices.target
  │ ├─-.slice
  │ └─system.slice
  ├─sockets.target
  │ ├─avahi-daemon.socket
  │ ├─dbus.socket
...
</pre>

また、以下のオプションも利用可能だ。<br/>

|オプション|意味|
|--- |--- |
|--reverse|対象Unitに依存しているUnit一覧を表示する。<br/>例えばsystemctl --reverse list-dependencies sysinit.targetは、sysinit.targetが起動対象とならない限り、起動できないUnitを一覧表示する。|
|--after|対象Unitよりも先に起動されるべきUnit一覧を表示する。<br/>例えばsystemctl --after list-dependencies sysinit.targetは、systeinit.targetよりも先に起動されるべきUnitを一覧表示する。<br/>※ 結果に表示されるUnitはあくまで起動順を指しており、必ずしも同時起動の対象となるUnitではない|
|--before|対象Unitよりも後に起動されるべきUnit一覧を表示する。<br/>例えばsystemctl --reverse list-dependencies sysinit.targetは、sysinit.targetが起動した後に起動されるべきUnitを一覧表示する。|

なお、Systemdでは、暗黙的に起動順や依存関係が設定されるtargetが存在する（特殊なUnitはマニュアル[systemd.special(7)](http://www.freedesktop.org/software/systemd/man/systemd.special.html "systemd.special(7)")を参照）。<br/>
`list-dependencies`はこういったUnitファイルに直接記載されない依存・起動順の表示が行えるため、依存・起動順の確認はファイルの中身を直接見るよりも当コマンドで利用した方が確実だ。<br/>

#### Unitファイルを編集し、Systemdに反映する

##### Unitファイルを編集する
様々なシステム管理コマンドを列挙したが、Unitファイルを編集することで設定を変更することができる。<br/>
`/etc/systemd/system`ディレクトリ配下に`/usr/lib/systemd/system`配下のUnitファイルをコピーしてからUnitファイルを編集しよう。<br/>
`/usr/lib/systemd/system`配下のUnitファイルはUnitインストール時の初期設定を保持するためのディレクトリであり、このディレクトリ配下のUnitは編集してはいけない。<br/>

##### Unitファイルの変更をSystemdに通知する

以下のコマンドを実行する事で、Unitファイルの変更をSystemdに通知することができる。<br/>
このコマンドを実行しないと変更内容がSystemdに反映されない。<br/>
（Unitファイルの直接編集ではなく、`systemctl`コマンドを利用して設定変更した場合は実行不要である）<br/>

<pre>
systemctl daemon-reload
</pre>

#### サーバシャットダウン・再起動・サスペンドを実施する

`systemctl`コマンドはサーバのシャットダウンや再起動を実施できる。<br/>
（従来の`shutdown`コマンドも引き続き利用可能）<br/>

<pre>
systemctl halt/poweroff/reboot/suspend/hibernate/hybrid-sleep
</pre>

`suspend`は”suspend to ram”、`hibernate`は”suspend to disk(swap)”、`hybrid-sleep`は”suspend to both”と思われる。

### journalctlを利用してSystemdログを参照する

ここからはSystemctl独自のログ機構であるSystemd journalを利用したログの照会方法を解説していく。

#### Systemd journalとは

Systemdは独自のログ機構である[Systemd journal](http://www.freedesktop.org/software/systemd/man/systemd-journald.service.html "Systemd journal")を保持している。RHEL7/CentOS7はFedora19をベースとしており、syslog（rsyslogd）とSystemd Journalが相乗りした状態となっているが、[Fedora20からはsyslogが非デフォルトとなり](http://fedoraproject.org/wiki/Changes/NoDefaultSyslog "http://fedoraproject.org/wiki/Changes/NoDefaultSyslog")、基本的にSystemd journalを利用する方針となった。<br/>
この点を踏まえるとRHEL/CentOSのログ機構は将来的にはSystemd journalに一本化される可能性が高い。<br/>
<br/>

Systemd journalではSystemdが記録した様々なログを`journalctl`コマンドを通して照会する。<br/>
Systemdはシステムの起動〜サービスの管理を行うため、ありとあらゆるシステムのログを収集できる立場にあるが、`journalctl`では、こららのログを必要に応じて抽出して閲覧することができるのだ。<br/>
<br/>
当項では、`journalctl`の基本的な利用方法と、Systemdが取得するログの永続化方法について解説する。<br/>
（RHEL7/CentOS7のSystemdのログはデフォルトではtmpfs上に格納されており、システム再起動時にログが消失してしまう）

#### journalctlの利用方法
パラメータ無しで`journalctl`を実行すると古いログから順に全ログが出力される。

<pre>
journalctl
</pre>

<pre>
$ #一部抜粋
$ #全ログの表示
$ sudo journalctl
-- Logs begin at 日 2014-07-20 20:23:11 JST, end at 日 2014-07-20 21:02:46 JST. --
 7月 20 20:23:11 localhost.localdomain systemd-journal[80]: Runtime journal is using 4.0M (max 24.5M, leaving 36.7M of free 241.1M, current li
 7月 20 20:23:11 localhost.localdomain systemd-journal[80]: Runtime journal is using 4.0M (max 24.5M, leaving 36.7M of free 241.1M, current li
 7月 20 20:23:11 localhost.localdomain kernel: Initializing cgroup subsys cpuset
 7月 20 20:23:11 localhost.localdomain kernel: Initializing cgroup subsys cpu
 7月 20 20:23:11 localhost.localdomain kernel: Initializing cgroup subsys cpuacct
 7月 20 20:23:11 localhost.localdomain kernel: Linux version 3.10.0-123.el7.x86_64 (builder@kbuilder.dev.centos.org) (gcc version 4.8.2 201401
 7月 20 20:23:11 localhost.localdomain kernel: Command line: BOOT_IMAGE=/vmlinuz-3.10.0-123.el7.x86_64 root=UUID=3e7830d3-0d7c-4f1d-9b6b-2ca10
 7月 20 20:23:11 localhost.localdomain kernel: e820: BIOS-provided physical RAM map:
...
</pre>
ログを見ると分かるが、システム起動時のカーネルログや個々のUnitに関するログが混在した状態で表示される。<br/>
以下に記載するオプションを利用して、表示対象を抜粋することができる。<br/>
（オプション一覧と詳細は[journalctlのmanページ](http://www.freedesktop.org/software/systemd/man/journalctl.html "journalctlのmanページ")を参照）

|オプション|書式|意味|
|--- |--- |--- |
|-u<br/>--unit|jorunalctl -u [Unit名]<br/>journalctl --unit=[Unit名]|指定したUnitに関するログのみ抜粋する。|
|_PID|jounalctl _PID=[プロセスID]|指定したプロセスIDを持つプロセスのログのみ抜粋する。|
|-p<br/>--priority|jounalctl -p [Priority]<br/>jounalctl --priority=[Priority]|指定したプライオリティに関するログのみ抜粋する。<br/>指定できるプライオリティはsyslogと同じ。<br/>(ただし、syslogでいう"warn"は"warning"と表記する)|
|-b|journalctl -b<br/>jounalctl -b -[数値]|起動時からの全メッセージを表示。<br/>[数値]に"0"（デフォルト）を指定した場合、現在の起動以降のログを表示する。<br/>"1"の場合は前回起動の関するログを表示する。<br/>"2"は前々回起動・・・という形式。|
|-f|journalctl -f|新しいログを表示し、ログが追加される度に追跡表示する。<br/>tail -fと同じ使い方ができる。|
|-n<br/>--line|journalctl -n [行数]<br/>journalctl --line=[行数]|指定した末尾の行数を表示する。<br/>-fはデフォルト10行なので、組み合わせて使うと良い。<br/>（よくあるtailの使い方）|
|-o<br/>--output|journalctl -o [Format]<br/>journalctl --output=[Format]|指定したフォーマットでログを出力する。<br/>指定できるフォーマットはman journalctl(1)を参照。<br/>json形式でログ出力もできる。|
|-k<br/>--dmesg|journalctl -k<br/>journalctl --dmesg|カーネルログのみ抜粋する。<br/>dmesgと同様の表示。|


#### journalログを永続化する

Systemd journalのログはデフォルト設定の場合`/run/log/journal`配下に保存されている。<br/>
`/run`ディレクトリはtmpfsとなっているため、システムを再起動した場合ログが消失してしまう。<br/>
これを防ぐ（journalログを永続化する）方法を確認していこう。<br/>

##### jorunalログの設定

Systemd journalの設定は`/etc/systemd/journald.conf`で行う。<br/>
デフォルトの状態では、以下のように全ての設定がコメントアウトされた状態となっている。<br/>

<pre>
$ cat /etc/systemd/journald.conf 
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#
# See journald.conf(5) for details
 
[Journal]
#Storage=auto
#Compress=yes
#Seal=yes
#SplitMode=login
#SyncIntervalSec=5m
#RateLimitInterval=30s
#RateLimitBurst=1000
#SystemMaxUse=
#SystemKeepFree=
#SystemMaxFileSize=
#RuntimeMaxUse=
#RuntimeKeepFree=
#RuntimeMaxFileSize=
#MaxRetentionSec=
#MaxFileSec=1month
#ForwardToSyslog=yes
#ForwardToKMsg=no
#ForwardToConsole=no
#TTYPath=/dev/console
#MaxLevelStore=debug
#MaxLevelSyslog=debug
#MaxLevelKMsg=notice
#MaxLevelConsole=info
ログの永続化に関する設定項目は12行目に表示されてい
</pre>

ログの永続化に関する設定項目は12行目に表示されているStorageである。Storageは主に以下の項目を設定できる。<br/>

|設定値|内容|
|--- |--- |
|auto|デフォルト設定。以下のルールでログの格納先を決定する。<br/>/var/log/journalディレクトリが存在する場合、この配下にログを記録する。<br/>（ディスク保存）<br/>/var/log/journalディレクトリが存在しない場合は/run/log/journal配下にログを記録する。<br/>（メモリ保存）|
|volatile|ログはメモリ上(/run/log/journal配下）に格納される。<br/>システム再起動後にログを持ち越すことはできない。|
|persistent|ログはディスク上（/var/log/journal配下）に格納される。<br/>/var/log/journalディレクトリが存在しない場合でも、systemdは自動的にディレクトリを作成し、その配下にログを記録する。|

### まとめ
駆け足でSystemdによるシステム管理のコマンドを紹介させていただいた。<br/>Systemd理解への一助となれば幸いである。<br/>
<br/>
今回、Systemdを調査を通してSystemdの適用範囲が非常に広い事を改めて思い知った次第だ。Systemdはシステムの起動から管理まで至るところに登場し、様々な操作を行うことができる。”システムデーモン”というネーミングは、システムそのものを管理するデーモンという意味で正に的を得ているのではないだろうか。今後RHEL7/CentOS7の導入が進んだ場合、Systemdの理解は必須となると思われる。<br/>
init/Upstartをはじめ、様々な既存の仕組みを置き換えるSystemdを理解しなければまともなサーバ管理は行えないだろう。<br/>
<br/>
また、Systemdではmanが非常に充実している。<br/>
例えばSystemd本体は[systemd(1)](http://www.freedesktop.org/software/systemd/man/systemd.html "systemd(1)") 、systemctlは[systemctl(1)](http://www.freedesktop.org/software/systemd/man/systemctl.html "systemctl(1)")、Unitファイルは[systemd.unit(5)](http://www.freedesktop.org/software/systemd/man/systemd.unit.html "systemd.unit(5)")といった具合だ。<br/>
これらのSystemd関連のmanは[systemd.index(7)](http://www.freedesktop.org/software/systemd/man/systemd.unit.html "systemd.index(7)")にまとめられている。<br/>
Systemdでつまづいた際は、落ち着いてmanを参照すると良いだろう。<br/>





