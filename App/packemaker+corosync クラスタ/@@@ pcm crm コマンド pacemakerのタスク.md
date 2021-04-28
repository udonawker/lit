# [Pacemakerのタスク](https://www.it-o.net/soft_hard/pacemaker/pacemakerTask.html)

```
起動確認（crm_mon）
 ・クラスタ状態をCUIベース画面で表示
         基本情報、ノード情報、リソース情報、属性値、故障回数
  crm_mon -rfA
         -r 停止しているリソース（stopped）も表示
         -f 故障状態
         -A 属性値

 crmコマンド
 ・crm configure show （抜ける「q」）
 ・crm configure load update [CRM設定ファイル]
 ・crm configure edit
 ・crm configure erase
 ・crm configure save [ファイル名]
 ・crm node standby [Host Name]
 ・crm node online [Host Name]
 ・crm resource cleanup [Resource Name] [Host Name]
 ・crm resource restart [Resource Name]

 バージョン関連（pacemaker.service）
 ・Pacemakerインストールで使用可能なバージョンとサポートされているクラスタースタック
         # pacemakerd --features

 アップデート（pacemaker）
 ・Pacemaker自体、Pacemakerでクラスタ化しているAPをアップデート
 ・クラスタ全体を停止してアップデート
         メジャーバージョンアップなどでデータや設定の互換性がなくなる場合など
 ・ローリングアップデート（サービスを継続しながら各サーバを順次アップデート）
         前提：アップデート前後でAPなどの互換性が保たれていること。
         先ずスタンバイサーバに対してアップデートを実施
         スタンバイサーバをプライマリサーバに切替え
         現スタンバイサーバに対してアップデートを実施
 ・スタンバイモードを利用するリソースのローリングアップデートの実行例
         （CentOS、Pacemaker、Corosync、ノード（kvm1、kvm2））
         スタンバイノード(メンテナンス対象ノード)で実行
         # crm node standby kvm2
         # pcs cluster standby kvm2
         メンテやアップデート実施
         スタンバイモードを解除
         # crm node online kvm2
         # pcs cluster unstandby kvm2
         アクティブノード(メンテナンス対象ノード)で実行
         # crm node standby kvm1
         # pcs cluster standby kvm1
         スタンバイモードに移行、リソースはスタンバイノードへフェイルオーバー
         現スタンバイノードでメンテやアップデート実施
         スタンバイモードを解除
         # crm node online kvm1
         # pcs cluster unstandby kvm1
         必要なら、リソースのフェイルバックを行う。
 ・Pacemaker／Corosyncのローリングアップデート
         スタンバイノードPacemaker停止
         # systemctl stop pacemaker.service
         スタンバイノードのPacemaker／Corosyncのアップデートを実施
         # yum update ・・・・
         スタンバイノードPacemaker起動
         # systemctl start pacemaker.service
         クラスタの正常確認
         リソースをアクティブノードからスタンバイノードへフェイルオーバー
         # crm node standby kvm1
         # pcs cluster standby kvm1
         # crm node online kvm1
         # pcs cluster unstandby kvm1
         現スタンバイノードPacemaker停止
         # systemctl stop pacemaker.service
         現スタンバイノードのPacemaker／Corosyncのアップデートを実施
         # yum update ・・・・
         現スタンバイノードPacemaker起動
         # systemctl start pacemaker.service
         クラスタの正常確認
 ・メンテナンスモードを利用するリソースのローリングアップデートの実行
         メンテナンスモード有効時は、リソースの起動・停止・監視が行われない。
         メンテナンスモード状態で作業実施、作業完了でメンテナンスモードを解除
         クラスタ全体をメンテナンスモードにする場合
         ノード単位でメンテナンスモードにする場合

 プロセス確認
 ・必要なプロセスが実行されていることを確認
         # ps axf | grep pacemaker 
　　　　　　 4457 ?        Ss     0:00 /usr/sbin/pacemakerd -f
　　　　　　 4460 ?        Ss     0:00  \_ /usr/libexec/pacemaker/cib
　　　　　　 4461 ?        Ss     0:00  \_ /usr/libexec/pacemaker/stonithd
　　　　　　 4462 ?        Ss     0:00  \_ /usr/libexec/pacemaker/lrmd
　　　　　　 4463 ?        Ss     0:00  \_ /usr/libexec/pacemaker/attrd
　　　　　　 4464 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pengine
　　　　　　 4465 ?        Ss     0:00  \_ /usr/libexec/pacemaker/crmd

 status確認
 ・pcs statusの出力を確認
         # pcs status 
　　　　　　Cluster name:
　　　　　　Stack: corosync
　　　　　　Current DC: xxxx2 (version 1.1.19-1.el7-c3c624e) - partition with quorum
　　　　　　Last updated: Fri Aug  9 15:35:02 2019
　　　　　　Last change: Fri Aug  9 13:38:10 2019 by hacluster via crmd on xxxx1
　　　　　　2 nodes configured
　　　　　　4 resources configured
　　　　　　Online: [ xxxx1 xxxx2 ]
　　　　　　Full list of resources:
　　　　　　 Resource Group: grp
　　　　　　     resource1  (ocf::heartbeat:Dummy): Started xxxx2
　　　　　　     resource2  (ocf::heartbeat:Dummy): Started xxxx2
　　　　　　 Clone Set: clnResource [resource3]
　　　　　　     Started: [ xxxx1 xxxx2 ]
　　　　　　Daemon Status:
　　　　　　  corosync: active/disabled
　　　　　　  pacemaker: active/disabled
　　　　　　  pcsd: inactive/disabled

 設定の有効性を確認
 ・矛盾を検出したらエラー表示
         # crm_verify -L -V

 Unitファイルの修正（pacemaker.service）
         # cp -p /usr/lib/systemd/system/pacemaker.service /etc/systemd/system
         # vi /etc/systemd/system/pacemaker.service
         ExecStopPost=/bin/sh -c 'pidof crmd || killall -TERM corosync' #コメントアウトを外す 
　　　　　　[Service]
　　　　　　ExecStopPost=
　　　　　　ExecStopPost=/bin/sh -c 'pidof crmd || killall -TERM corosync'

 property（クラスタ全体の設定）
 ・no-quorum-policy
 ・stonith-enabled

 rsc_defaults（リソース全体のデフォルト設定）
 ・resource-stickiness
 ・migration-threshold
 ・pcsの場合
         # pcs resource defaults resource-stickiness=INFINITY migration-threshold=

 ha-log
 ・Pacemakerが出力するログの名前、デフォルト「/var/log/messages」に出力
 ・設定を変更し、「/var/log/ha-log」など、個別ファイルに変更

 ログの出力設定 （rsyslog.conf）
 ・ログの出力先を/etc/rsyslog.confに設定
         # vi /etc/rsyslog.conf 
　　　　（略）
　　　　*.info;mail.none;authpriv.none;cron.none;local1.none  /var/log/messages （;local1.none 追加）
　　　　（略）
　　　　# Save boot messages also to boot.log
　　　　local7.*                                             /var/log/boot.log
　　　　local1.info   /var/log/ha-log;RSYSLOG_TraditionalFileFormat （行追加）

 ・xfsによるログ欠落を防ぐための設定（  /etc/rsyslog.conf に追加）
         # vi /etc/rsyslog.conf
         （略）
         $SystemLogRateLimitInterval 0 （追記）
         $imjournalRatelimitInterval 0 （追記）

         （/etc/systemd/journald.conf に追加）
         # vi /etc/systemd/journald.conf
         （略）
         RateLimitInterval=0s （追記）
 ・rsyslogを再起動（# systemctl restart rsyslog）

 ログメッセージ制御機能設定（pm_logconv.conf）
 ・Pacemaker標準のログ出力から、運用上必要なログだけを出力することができる
 ・基本設定部（[Setting]セクション）を編集
         # cp /etc/pm_logconv.conf.sample /etc/pm_logconv.conf
         # vi /etc/pm_logconv.conf
         コメントを外す 
        （略）
        [Settings]
        #ha_log_path = /var/log/ha-log
        #output_path = /var/log/pm_logconv.out
        #output_logfacility = local2
        #syslogformat = True
        （ネットワーク監視を行う）
        attribute_ping = not_defined default_ping_set or default_ping_set lt 100
        （内蔵ディスク監視を行う）
        attribute_diskd = not_defined diskcheck_status or diskcheck_status eq ERROR
        attribute_diskd_inner = not_defined diskcheck_status_internal or diskcheck_status_internal eq ERROR
        #logconv_logfacility = daemon
        #logconv_logpriority = info
        （フェイルオーバの発生と成否の判断基準となるリソースのIDを設定）
        act_rsc = vip-master, vip-rep

 ログローテーションの追加設定（syslog）
 ・Pacemaker用ログファイル(/var/log/ha-log)のローテーション設定
         /var/log/ha-log追加
         # vi /etc/logrotate.d/syslog 
        /var/log/cron
        /var/log/maillog
        /var/log/messages
        /var/log/secure
        /var/log/spooler
        /var/log/ha-log
        {
            missingok
            sharedscripts
            postrotate
                /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
            endscript
        }
 ・インストール時作成のローテーション設定 /etc/logrotate.d/pacemaker は使用しない。
         # rm -f /etc/logrotate.d/pacemaker
 ・/etc/logrotate.d/ に syslog.xx は置かない。
         # grep include /etc/logrotate.conf
         include /etc/logrotate.d

 pm_logconvプロセス、ifcheckdプロセスの起動
 ・pm_logconvプロセスの自動起動を有効に設定
         # systemctl enable pm_logconv
         # systemctl is-enabled pm_logconv
         # systemctl start pm_logconv
         # ps -ef | grep pm_logcon[v]
 ・ifcheckdプロセスの自動起動を有効に設定
         Corosync環境でインターフェースの状態を監視する。
         監視情報は、自ノードに接続されている他ノードのインターフェースの状態として表示
                 # crm_mon -A
         # systemctl enable ifcheckd
         # systemctl is-enabled ifcheckd
         # systemctl start ifcheckd
         # ps -ef | grep ifcheck[d]
         # ls -ld /var/log/ha-log

 リソース追加
 ・確認
         # crm configure show
 ・RAの場所
         /usr/lib/ocf/resource.d/heartbeat  など
 ・FIP（IPaddr2）とVIPcheckの追加
         #  pcs resource create FIP1 ocf:heartbeat:IPaddr2 \
                 ip=192.168.xxx.xxx cidr_netmask=24 op monitor interval=30s
                     ocf:リソーススクリプトが準拠している標準であり、それを見つける場所
                     heartbeat:リソーススクリプトが含まれるOCF名前空間をクラスターに伝える。
                     IPaddr2 リソーススクリプトの名前
         フローティングIPが発生していることを「ip addr」などで確認
                 inet 192.168.xx.xx/24 brd 192.168.xx.255 scope global secondary ethx
         VIPcheck（FIP衝突チェックリソース）の追加（crm confg edit に追加の場合）
                 params target_ip=192.168.xx.xx count=1 wait=10 \
                 op start interval=0s timeout=90s on-fail=restart start-delay=4s
                 ※10秒間の間に1回のECHO_REPLYを受け取った時に成功
         FIP（IPaddr2）とVIPcheckとの順序制約の追加
                 VIPcheckが先に立ち上がる。
 ・グループ化  （ノード間を一団で移動）
         # pcs resource group add GrpBalancer VIPCHK1 LB_VIP LDIRECTOR1
 ・全ノードで同時に活性化
         # pcs resource clone PINGD

 リソースcrm設定（pm_crmgen環境定義書）
 ・そのまま設計書の一部として使用できる。（フォーマット）
 ・リソース定義用Excelテンプレートシートに「 リソース構成」を入力
 ・ExcelのシートをCSVファイルで保存し、Masterに転送
 ・Pacemakerのツールコマンドを使用してCRM設定ファイルに変換
         # pm_crmgen -o CRM設定ファイル名 CSVファイル名
 ・Pacemakerのツールコマンドを使用してCRM設定ファイルをPacemakerにロード
         # crm configure load update CRM設定ファイル名
 ・参考 

 リソース構成  （エクセル表）
 ・リソース定義・パラメータ設定（表7.1（リソース分）、表3.1）
         リソースID（リソース毎にユニークなID）
         リソースが使用するRA
         リソースの起動に必要な、RA毎のパラメータ
         起動・監視・停止処理のタイムアウトや失敗時の自動対処
 ・リソース種類選択（表4.1）
         プリミティブリソース
                 クラスタ内で単独起動
                 基本となるリソース種類
         リソースグループ
                 複数のプリミティブリソースを一括管理し、1つのリソースの様に動作
                 同一ノード内での起動、及び起動順序を保証
         クローンリソース
                 同一リソースを複数のノード上で起動
         マスタ/スレーブリソース
                 複数ノード上にマスタとなるリソースとスレーブとなるリソースを起動
 ・リソース制約（表8.1）
         リソース種類選択だけでは実現できない細かい動作をここで設定
                 リソースが起動するノードを決める設定
                         リソース配置制約
                         リソース同居制約（表9.1）
                 リソースが起動する順番を決める設定（リソース起動順序制約）（表10.1）
 ・クラスタ設定（表2.1）
         スプリットブレイン時の排他制御

 リソース制約
 ・場所制約  （起動ノード）
         # crm configure show
         location GrpBalancer-location GrpBalancer \
             rule 200: #uname eq node1 \
             rule 100: #uname eq node2
 ・同居制約  （一つのノード上で一緒に活性化するリソース）
         # pcs constraint colocation add webServer with FIP10 INFINITY
         # pcs constraint colocation add GrpBalancer PINGD-clone INFINITY id=GrpBalancer-with-PINGD
 ・順序制約  （活性順を定義（symmetrical属性trueは、停止するときの順序が開始時と逆））
         # pcs constraint order FIP10 then webServer
         # pcs constraint order \
             PINGD-clone then GrpBalancer score=INFINITY symmetrical=false \
             id=order-PINGD-then-GrpBalancer
         # pcs constraint order \
             VIPCHK1 then LB_VIP score=INFINITY symmetrical=true \
             id=order-VIPCHK1-then-LB_VIP
         # pcs constraint order \
             LB_VIP then LDIRECTOR1 score=INFINITY symmetrical=true \
             id=order-LB_VIP-then-LDIRECTOR1
         # pcs constraint show all  （リソース設定確認）
         # crm configure show
 ・リソースエージェントのグループ化
         # pcs resource group add GrpMail vip-check ML_VIP postfix


 リソース停止
 ・pcsによるリソース停止

 cibadminコマンド
 ・cibadminコマンドを使用してCIB（/var/lib/pacemaker/cib）のxmlファイルを編集
         # cibadmin --query > tmp.xml
         # vi tmp.xml
         # cibadmin --replace --xml-file tmp.xml
 ・変更は即時反映される。

 crmsh（The CRM Shell）コマンド
 ・crmコマンドでPacemakerのクラスタ設定／管理を行うソフトウェア
 ・対話式でも設定が可能（1行完結式でもよい。）
         # crm
         # crm(live)# configure    コマンド入力モード
         # crm(live)configure#    設定モード
         # up    1つ前のモードに戻る
         # exit    crmコマンド入力モードから抜ける
 ・ リソース構成を記述したファイルの読み込み設定ができる。
         # crm configure load update vip.conf
         記述したファイル例「vip.conf」 
　　　　primitive res_ip IPaddr2 \
　　　　        params ip=192.168.10.1 cidr_netmask=24 \
　　　　        op start interval=0 timeout=20 \
　　　　        op monitor interval=10 timeout=20 \
　　　　        op stop interval=0 timeout=20

 ・設定内容を直接編集モード（Vi／Vimエディタと同じ）
         # crm configure show
         # crm configure edit
         # crm configure erase
                 事前に全ノードを「running」以外に
                 # crm node standby server1
                 # crm node standby server2
         # crm node online ノード名
         # crm configure save ファイル名

 排他制御
 ・スプリットブレインやリソースの停止の故障によるサービス停止を防ぐ。
 ・STONITH
         スプリットブレイン、リソースの停止の故障に対応
         リソース定義ファイルへの設定事項
                 STONITH有効
                 プラグイン設定
                 プラグイン実行順序設定
                 リソースの停止の故障時にSTONITH発動の設定
 ・VIPcheck
         仮想IPを用いる。
                 仮想IPが他のノードに割り当てられていることを確認し、起動失敗となる。
         スプリットブレインに対応
 ・SFEX
         共有ディスクを用いる。
         スプリットブレインに対応

 pcs（Pacemaker Configuration Tool）コマンド
 ・pcs起動
 ・pcsクラスタサービス停止
         # pcs cluster stop --all    （全ノード）
         # pcs cluster stop    [node] [...]
         # pcs cluster kill    （ローカルノードで、kill -9）
 ・pcsクラスタサービス起動
         # pcs cluster start --all    （全ノード）
 ・構成ツールPCS
         「crmsh」と同様なPacemakerクラスタ管理ツール
         Pacemakerのバージョン1.1で採用、コマンド1つずつが完結
         pcsdがpcsのリモートサーバとして動作し、Web UIを提供
                 ブラウザで2224ポートにhttps接続
 ・コマンド使用例
         # pcs -h
 ・状態
         # pcs status
         # pcs status pacemaker
         # pcs status corosync
         # pcs status xml
         # pcs cluster cib
 ・プロパティ
         # pcs property    （cib.xml内のcrm_configの一部（プロパティ）を表示）
         # pcs property list    
         # pcs property set stonith-enabled=false     （stonith 無効）
         # pcs property set no-quorum-policy=ignore    （quorum 無視）
         # pcs property set default-resource-stickiness="INFINITY"     （自動フェイルバック 無効）
 ・リソース制約（constraint）
         同居制約
         順序制約
 ・リソース
         # pcs resource defaults
         # pcs resource defaults resource-stickiness=xxx
         # pcs resource defaults migration-threshold=1
         # pcs resource list    （利用できる全リソースの一覧表示）
         # pcs resource show    （設定されているリソースの全一覧）
                 # pcs resource show --full    （パラメーターを表示）
         # pcs resource standards
         # pcs resource providers
         # pcs resource agents ocf:heartbeat    （特定のOCFプロバイダーで使用可能なRA）
 ・リソースpcs設定例 （デフォルト値を変える時は「--force」を使う。）
         # pcs resource create vip-check ocf:heartbeat:VIPcheck \
                  target_ip=192.168.5.55 count=1 wait=10 \
                  op start interval=0s timeout=90s on-fail=restart start-delay=6s
         # pcs resource create VIP1 ocf:heartbeat:IPaddr2 ip=192.168.5.55 cidr_netmask=24 \
                  op start interval=0s timeout=60s on-fail=restart \
                 （リソースが起動するまでの間隔 0 秒、60 秒以内に起動できなかったらタイムアウト）
                  op monitor interval=10s timeout=60s on-fail=restart \
                 （リソースの正常稼働を 10 秒に1回確認、60 秒以内に稼働確認ができなかったらタイムアウト）
                  op stop interval=0s timeout=60s on-fail=ignore
                 （リソースが停止するまでの間隔 0 秒、60 秒以内に停止できなかったらタイムアウト）
         # pcs resource create webServer ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf
                 statusurl="http://127.0.0.1/server-status"    （httpdリソース）
         # pcs resource op add webServer monitor interval=1m --force    （httpdオプション）
 ・リソース停止
         # pcs resource disable resource_id [--wait[=n]]
                 実行中のリソースを手作業で停止し、その後そのリソースがクラスターにより再起動されない。
                 （例）httpdの場合、pacemaker.serviceのstatus（CGroup:）からhttpdが消える。
         # pcs resource enable resource_id [--wait[=n]]
                 クラスターによるリソースの起動を許可する。
 ・リソース削除
         # pcs resource delete resource_id
 ・リソースグループ削除
         # pcs resource group remove group_name resource_id...
 ・リソースグループ追加
         リソースはコマンドで指定した順序で起動し、起動とは逆順で停止
         # pcs resource group add group_name resource_id...
 ・エラークリア
         登録手順でエラーが発生し正常に稼働していない場合、クリアする。
         # pcs resource cleanup
         Waiting for 1 reply from the CRMd. OK
 ・フェイルオーバー
         # pcs cluster standby kvm3.xxxx.xxx
         # 強制終了
         $ ログアウト
         未同期
 ・スタンバイから戻し
         # pcs cluster unstandby kvm3.xxxx.xxx
         DRBDの同期発生、プライマリにはならない。
```
