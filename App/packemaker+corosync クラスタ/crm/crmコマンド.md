# [Pacemaker/Heartbeat で良く使うクラスタ操作コマンド](https://ngyuki.hatenablog.com/entry/20110511/p1)
# [crm_mon(8) - Linux man page](https://linux.die.net/man/8/crm_mon)

### クラスタ情報の表示
```
crm_mon -1

# ノードでグループ化
crm_mon -1n

# フェイルカウントも表示
crm_mon -1f
```

### ノード一覧の表示
```
crmadmin -N
crm node list
crm node status
```

### リソース一覧の表示
```
crm_resource -L
```

### リソースの位置を表示
```
crm_resource -WQ -r <resource>
```

### スタンバイの設定（ローカルホストに対して）
```
# スタンバイにする
crm_standby -v on

# スタンバイから復帰
crm_standby -D
```

### リソースのフェイルカウントのクリア
```
crm_failcount -D -r <rsc>
crm resource failcount <rsc> delete <node>
```

### リソースのクリーンアップ ※フェイルカウントと故障履歴をクリア
```
crm_resource -C -r <resource>
crm resource cleanup <resource> [<node>]
```

### メンテナンスモードのON/OFF
すべてのリソースが unmanaged になって start/stop/monitor が行なわれなくなります<br>
```
crm configure property maintenance-mode=true
crm configure property maintenance-mode=false
```

### cib.xml の表示
```
cibadmin --query
```

### cib を xpath で抽出
```
cibadmin --query --xpath "//crm_config"
```

### リソースやグループやノードのスコアを見る
```
ptest -s -L
```

### リソースやグループやノードのスコアをもっとよくみる
```
wget http://hg.clusterlabs.org/pacemaker/stable-1.0/raw-file/c3869c00c759/extra/showscores.sh
chmod +x showscores.sh 
./showscores.sh
```

### ノードのアトリビュート（属性）を表示
crm_mon の -A オプションが使えるならそれで。<br>
```
crm_mon -A
```

使えない場合は・・・<br>
cibadmin --xpath でローカルノードのアトリビュートを一覧表示。<br>
```
cibadmin --query --xpath "//status/node_state[@uname='$(uname -n)']//nvpair"
```

crm_attribute で属性名を指定して表示。<br>
```
crm_attribute --type status --node $(uname -n) --name ping_val --query
```

## [manpage](http://www.novell.com/ja-jp/documentation/sle_ha/book_sleha/data/man_crmmon.html)
```
# 書式
crm_mon [-V] -d -pfilename -h filename
crm_mon [-V] [-1|-n|-r] -h filename
crm_mon [-V] [-n|-r] -X filename
crm_mon [-V] [-n|-r] -c|-1
crm_mon [-V] -i interval
crm_mon -?

# 説明
crm_monコマンドによって、クラスタのステータスと環境設定を監視できます。ノード数、uname、uuid、ステータス、クラスタに設定されたリソース、それぞれの現在のステータスが出力に含まれます。crm_monの出力はコンソールに表示することも、HTMLファイルに印刷することもできます。ステータスセクションのないクラスタの環境設定ファイルが提供された場合、crm_monはファイル内で指定されたノードとリソースの概要を作成します。

# オプション
--help, -?
    ヘルプを表示する.
--verbose, -V
    詳細なデバッグ出力を行います。
--interval seconds, -i seconds
    更新頻度を決定します。-iが指定されていない場合、15秒のデフォルト値が採用されます。
--group-by-node, -n
    ノードごとにリソースをグループ化します。
--inactive, -r
    非アクティブなリソースを表示します。
--simple-status, -s
    簡単な一行の出力としてクラスタステータスを1度表示します(nagiosには適している)。
--one-shot, -1
    コンソールにクラスタステータスを1度表示して、終了します(ncursesは使用しない)。
--as-html filename, -h filename
    クラスタステータスを指定のファイルに書き込みます。
--web-cgi, -w
    CGIに適した出力のWebモード。
--daemonize, -d
    バックグラウンドでデーモンとして実行します。
--pid-file filename, -p filename
    デーモンのpidファイルを指定します。
    
# 例
クラスタのステータスを表示し、15秒ごとに更新済みのリストを取得します。
    crm_mon
クラスタのステータスを表示し、-iで指定した間隔で更新済みのリストを取得します。-iを指定しない場合、デフォルトのリフレッシュ間隔として15秒が採用されます。
    crm_mon -i interval[s]
クラスタのステータスをコンソールに表示します。
    crm_mon -c
クラスタのステータスをコンソールに1度だけ表示して、終了します。
    crm_mon -1
クラスタのステータスとノードごとのグループリソースを表示します。
    crm_mon -n
クラスタのステータス、ノードごとのグループリソースを表示し、リストに非アクティブなリソースを含みます。
    crm_mon -n -r
クラスタのステータスをHTMLファイルに書き込みます。
    crm_mon -h filename
crm_monをバックグランドでデーモンとして実行し、デーモンのpidファイルを指定してデーモンプロセスの制御を簡単に行えるようにし、HTML出力を作成します。このオプションは他の監視用アプリケーションで簡単に処理できるHTML出力を継続的に作成できるようにします。
    crm_mon -d -p filename -h filename
既存のクラスタ環境設定ファイル(filename)のクラスタの環境設定を表示し、ノードごとにリソースをグループ化して、非アクティブなリソースをリストに含みます。このコマンドは、ライブクラスタへの導入前に、クラスタの環境設定をテストするために使用できます。
    crm_mon -r -n -X filename

# ファイル
/var/lib/heartbeat/crm/cib.xml—ディスク上のCIB(ステータスセクションを除く)。このファイルを直接編集しないでください。
```

## [manpage](https://linux.die.net/man/8/crm_mon)
```
Description
crm_mon - Provides a summary of cluster's current state.
Outputs varying levels of detail in a number of different formats.

Options
-?, --help
    This text
-$, --version
    Version information
-V, --verbose
    Increase debug output
-Q, --quiet
    Display only essential output

Modes:
-h, --as-html=value
    Write cluster status to the named html file
-X, --as-xml
    Write cluster status as xml to stdout. This will enable one-shot mode.
-w, --web-cgi
    Web mode with output suitable for cgi
-s, --simple-status
    Display the cluster status once as a simple one line output (suitable for nagios)

Display Options:
-n, --group-by-node
    Group resources by node
-r, --inactive
    Display inactive resources
-f, --failcounts
    Display resource fail counts
-o, --operations
    Display resource operation history
-t, --timing-details
    Display resource operation history with timing details
-c, --tickets
    Display cluster tickets
-W, --watch-fencing
    Listen for fencing events. For use with --external-agent, --mail-to and/or --snmp-traps where supported
-A, --show-node-attributes
    Display node attributes

Additional Options:
-i, --interval=value
    Update frequency in seconds
-1, --one-shot
    Display the cluster status once on the console and exit
-N, --disable-ncurses
    Disable the use of ncurses
-d, --daemonize
    Run in the background as a daemon
-p, --pid-file=value
    (Advanced) Daemon pid file location
-E, --external-agent=value
    A program to run when resource operations take place.
-e, --external-recipient=value A recipient for your program (assuming you want the program to send something to someone).

Examples
Display the cluster status on the console with updates as they occur:
# crm_mon

Display the cluster status on the console just once then exit:
# crm_mon -1

Display your cluster status, group resources by node, and include inactive resources in the list:
# crm_mon --group-by-node --inactive

Start crm_mon as a background daemon and have it write the cluster status to an HTML file:
# crm_mon --daemonize --as-html /path/to/docroot/filename.html

Start crm_mon and export the current cluster status as xml to stdout, then exit.:
# crm_mon --as-xml
```
