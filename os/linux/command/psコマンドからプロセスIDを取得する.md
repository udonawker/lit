[psコマンドからプロセスIDを取得する](https://qiita.com/gisuyama/items/397d664d82551a9d4526)<br/>

### ローカルの場合
<pre>
ps -ef | grep name | grep -v grep | awk '{ print $2 }'
</pre>

### リモートの場合
<pre>
# awkのパラメータをエスケープする必要がある
ssh user@remotehost "ps -ef | grep name | grep -v grep | awk '{ print \$2 }'"
</pre>
