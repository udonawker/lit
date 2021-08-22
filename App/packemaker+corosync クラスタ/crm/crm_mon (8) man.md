## [crm_mon (8)](http://www.novell.com/ja-jp/documentation/sle_ha/book_sleha/data/man_crmmon.html)

## Name
crm_mon - クラスタのステータスを監視します<br>

## 書式
```
crm_mon [-V] -d -pfilename -h filename
crm_mon [-V] [-1|-n|-r] -h filename
crm_mon [-V] [-n|-r] -X filename
crm_mon [-V] [-n|-r] -c|-1
crm_mon [-V] -i interval
crm_mon -?
```

## 説明
crm_monコマンドによって、クラスタのステータスと環境設定を監視できます。<br>
ノード数、uname、uuid、ステータス、クラスタに設定されたリソース、それぞれの現在のステータスが出力に含まれます。<br>
crm_monの出力はコンソールに表示することも、HTMLファイルに印刷することもできます。<br>
ステータスセクションのないクラスタの環境設定ファイルが提供された場合、crm_monはファイル内で指定されたノードとリソースの概要を作成します。<br>

## オプション
--help, -?<br>
　　ヘルプを表示する.<br>

--verbose, -V<br>
　　詳細なデバッグ出力を行います。<br>

--interval *seconds*, -i *seconds*<br>
　　更新頻度を決定します。-iが指定されていない場合、15秒のデフォルト値が採用されます。<br>

--group-by-node, -n<br>
　　ノードごとにリソースをグループ化します。<br>

--inactive, -r<br>
　　非アクティブなリソースを表示します。<br>

--simple-status, -s<br>
　　簡単な一行の出力としてクラスタステータスを1度表示します(nagiosには適している)。<br>

--one-shot, -1<br>
　　コンソールにクラスタステータスを1度表示して、終了します(ncursesは使用しない)。<br>

--as-html *filename*, -h *filename*<br>
　　クラスタステータスを指定のファイルに書き込みます。<br>

--web-cgi, -w<br>
　　CGIに適した出力のWebモード。<br>

--daemonize, -d<br>
　　バックグラウンドでデーモンとして実行します。<br>

--pid-file *filename*, -p *filename*<br>
　　デーモンのpidファイルを指定します。<br>

## 例
クラスタのステータスを表示し、15秒ごとに更新済みのリストを取得します。<br>
　　`crm_mon`<br>
クラスタのステータスを表示し、-iで指定した間隔で更新済みのリストを取得します。-iを指定しない場合、デフォルトのリフレッシュ間隔として15秒が採用されます。<br>
　　`crm_mon -i interval[s]`<br>
クラスタのステータスをコンソールに表示します。<br>
　　`crm_mon -c`<br>
クラスタのステータスをコンソールに1度だけ表示して、終了します。<br>
　　`crm_mon -1`<br>
クラスタのステータスとノードごとのグループリソースを表示します。<br>
　　`crm_mon -n`<br>
クラスタのステータス、ノードごとのグループリソースを表示し、リストに非アクティブなリソースを含みます。<br>
　　`crm_mon -n -r`<br>
クラスタのステータスをHTMLファイルに書き込みます。<br>
　　`crm_mon -h filename`<br>
crm_monをバックグランドでデーモンとして実行し、デーモンのpidファイルを指定してデーモンプロセスの制御を簡単に行えるようにし、HTML出力を作成します。このオプションは他の監視用アプリケーションで簡単に処理できるHTML出力を継続的に作成できるようにします。<br>
　　`crm_mon -d -p filename -h filename`<br>
既存のクラスタ環境設定ファイル(filename)のクラスタの環境設定を表示し、ノードごとにリソースをグループ化して、非アクティブなリソースをリストに含みます。このコマンドは、ライブクラスタへの導入前に、クラスタの環境設定をテストするために使用できます。<br>
　　`crm_mon -r -n -X filename`<br>

## ファイル
/var/lib/heartbeat/crm/cib.xml?ディスク上のCIB(ステータスセクションを除く)。このファイルを直接編集しないでください。<br>

## 著者
crm_monはAndrew Beekhofによって作成されました。<br>

