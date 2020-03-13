リダイレクトがコマンドより先に行われるのでリダイレクトはNG<br/>
<pre>
# NG
sort hoge > hoge
</pre>

上書きするには以下の方法<br/>
<pre>
sort hoge -o hoge
# -o, --output=FILE
# uniq
sort -u hoge -o hoge
</pre>
