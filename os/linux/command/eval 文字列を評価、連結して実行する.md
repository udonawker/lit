<pre>
eval 文字列

（文字列をコマンドとしてシェルに実行させる）

eval `dircolors -b /etc/DIR_COLORS`

（「dircolors -b /etc/DIR_COLORS」の実行結果を現在のシェルで実行する）

eval $変数名

（変数の内容をコマンドとしてシェルに実行させる）

eval $SHELL --version

（「/bin/bash --version」を実行。/bin/bashは変数SHELLの内容）
</pre>
