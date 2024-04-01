## 20240401 [Linuxでトラブルが発生したときの診断に役立つツール一覧](https://gigazine.net/news/20240327-linux-crisis-tools/)

Linuxで動くシステムで何か問題が発生した際の原因分析に役立つツールの一覧をNetflixやIntelでクラウドコンピューティングのパフォーマンス改善に取り組んできたエンジニアのブレンダン・グレッグ氏がブログにまとめています。

## Linux Crisis Tools
https://www.brendangregg.com/blog/2024-03-24/linux-crisis-tools.html

### ◆procps
このパッケージには「ps」「vmstat」「uptime」「top」という基本的なステータス表示に役立つツールが含まれています。<br>


### ◆util-linux
このパッケージには「dmesg」「lsblk」「lscpu」というシステムのログを取得したりデバイスの情報を出力するツールが含まれています。<br>


### ◆sysstat
このパッケージには「iostat」「mpstat」「pidstat」「sar」などデバイスの状態を表示するためのツールが含まれています。<br>


### ◆iproute2
このパッケージには「ip」「ss」「nstat」「tc」などネットワーク関係のツールが含まれています。<br>


### ◆numactl
このパッケージには複数のCPUやメモリを管理するNUMAの状態を表示したり操作したりするためのツールが含まれています。<br>


### ◆tcpdump
このパッケージにはトラフィックを監視するためのツールが含まれています。<br>


### ◆linux-tools-common
このパッケージにはパフォーマンス・モニタリング・ユニット(PMU)を使用してプロセッサの状態をより詳しく調べるためのツールが含まれています。<br>


### ◆bcc・bpfcc-tools・bpftrace
このパッケージにはLinuxのカーネルを変更せずにカーネルコードをフックするためのツールが含まれています。なお、bccとbpftraceパッケージには同じ機能を持つツールが多数重複して存在していますが、bccの方が高機能な一方でbpftraceはその場で編集が可能など長所が異なるとのこと。<br>

### ◆trace-cmd
カーネルの動作を追跡するLinuxの機能「Ftrace」を操作するためのコマンドラインツールです。<br>

### ◆nicstat
ネットワークのトラフィック情報を表示するツールです。<br>


### ◆ethtool
ネットワークデバイスの情報を表示するツールです。<br>


### ◆tiptop
パフォーマンス監視ユニットを使用したリアルタイムの性能監視ツールです。<br>

### ◆cpuid
CPUの詳細な情報を確認するためのツールです。<br>


### ◆msr-tools
このパッケージにはCPUのレジスタを操作するツールが含まれています。<br>

グレッグ氏はトラブルの発生後にこうした調査用のツールをインストールしようとしてもシステムに高い負荷がかかっていてスムーズにはインストールできなかったという経験を述べた上で、「リストに含まれているツールは合計数MBしか容量を消費しないため事前にインストールしておく価値がある」と訴えました。<br>

なお、記事作成時点でリストに含まれているツールをUbuntuにまとめてインストールするには下記のコマンドを入力すればOKです。<br>
```
sudo apt install procps util-linux sysstat iproute2 numactl tcpdump linux-tools-common linux-tools-$(uname -r) bpfcc-tools bcc bpftrace trace-cmd nicstat ethtool tiptop cpuid msr-tools
```
