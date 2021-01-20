## [Linuxでプロセスのスレッド数を監視するにはどうすればよいですか？](https://qastack.jp/programming/268680/how-can-i-monitor-the-thread-count-of-a-process-on-linux)

### 特定のPIDのスレッド数を取得するには：
<pre>
$ ps -o nlwp &lt;pid&gt;
</pre>

どこnlwpの略番号軽量のプロセス（スレッド）。したがって、ps別名nlwpにthcountどの手段もの、<br>
<pre>
$ ps -o thcount &lt;pid&gt;
</pre>
も機能します。<br>

### スレッド数を監視する場合は、次のように使用しますwatch。
<pre>
$ watch ps -o thcount &lt;pid&gt;
</pre>

### システムで実行されているすべてのスレッドの合計を取得するには：
<pre>
$ ps -eo nlwp | tail -n +2 | awk '{ num_threads += $1 } END { print num_threads }'
</pre>
