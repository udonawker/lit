readコマンドで 矢印キー や Ctrl+x などの入力を読み取る](https://tanishiking24.hatenablog.com/entry/readascii)<br/>

<pre>
くわからないので矢印キーの asciiコード16進数表記を調べてみましょう. 入力の16進数変換にはxxdやhexdumpコマンドが便利

Arrow keyの入力値をreadで読み取りその入力値を16進数変換して表示してみます.

read key; echo "$key" | hexdump

このコマンドを入力したあとにUp Arrow(上矢印)を入力すると1b 5b 41というような結果が得られます. どういうことかというとUp Arrow(上矢印)の入力は1b 5b 41という3つのascii codeの入力によって実現されてるっぽいです.
</pre>
<pre>
$ read key; echo "$key" | hexdump   ★Escape押下
^[
0000000 0a1b                                   
0000002
$ read key; echo "$key" | hexdump   ★Enter押下

0000000 000a                                   
0000001
$

$ read key; echo -n "$key" | hexdump    ★Escape押下
^[
0000000 001b                                   
0000001
$ read key; echo -n "$key" | hexdump    ★Escape押下

$
</pre>
