[Linux shell PIDを取得する方法まとめ](https://qiita.com/koara-local/items/ee57dc7923e23d3143c5)<br/>

## shellの `$!` を使用して直前のPIDを取得する
shellの `$!` で 最後に実行したバックグラウンドプロセスのPIDを取得できる。<br/>
POSIXで定義されているので基本使用できるとのこと<br/>
<pre>
#!/bin/bash
hoge_detach_process &
pid=$!
</pre>

## `pidof` コマンドを使用する
`pidof [PROGRAM_NAME]` でPIDを取得できる。<br/>
組み込みLinux環境ではおそらく入ってないため使えない。<br/>
<pre>
$ hoge_detach_process &
$ pidof hoge_detach_process
</pre>

## `ps` コマンドから絞り込む
目で確認するだけか、同名のプロセスがない場合のみ可能。(直前であればPIDの番号の大きい方を使えば良いとは思われる)<br/>
<pre>
# ps の C オプションで指定する
$ ps --no-heading -C <prog_name> -o pid

# grep で絞り込む
$ hoge_detach_process &
$ ps -e -o pid,cmd | grep hoge_detach_process | grep -v grep | awk '{ print $1 }'

# 正規表現を使用する
$ ps -e -o pid,cmd | grep -E "^.*hoge_detach_process$" | awk '{print $1}'
$ ps -e -o pid,cmd | awk '/^.*hoge_detach_process$/ {print $1}'
</pre>
