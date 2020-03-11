カレントディレクトリ配下で直近30分以内に更新されたtxtファイル一覧取得
<pre>
$ find . -mmin -30 -type f -name "*.txt"
</pre>

fdの場合
<pre>
$ fd -g '*.txt' --changed-within '30m' -t f
</pre>
