[プログラムのシステムコールを観察する方法](https://riptutorial.com/ja/bash/example/32543/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%A0%E3%81%AE%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E3%82%B3%E3%83%BC%E3%83%AB%E3%82%92%E8%A6%B3%E5%AF%9F%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)<br>
<br>
実行ファイルまたはコマンド execの場合、これを実行するとすべてのシステムコールが一覧表示されます<br>
<pre>
$ ptrace exec
</pre>

特定のシステムコールを表示するには、-eオプションを使用します。<br>
<pre>
$ strace -e open exec
</pre>

出力をファイルに保存するには、-oオプションを使用します。<br>
<pre>
$ strace -o output exec
</pre>

アクティブなプログラムが使用するシステムコールを見つけるには、pid [pidの取得方法 ]を指定するときに-pオプションを使用します。<br>
<pre>
$ sudo strace -p 1115
</pre>

使用するすべてのシステムコールの統計レポートを生成するには、オプション-cを使用します。<br>
<pre>
$ strace -c exec 
</pre>
