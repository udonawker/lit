[dockerの起動オプション確認方法](https://ja.stackoverflow.com/questions/41126/docker%E3%81%AE%E8%B5%B7%E5%8B%95%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E7%A2%BA%E8%AA%8D%E6%96%B9%E6%B3%95)<br/>

Docker version 1.10.3, build cb079f6-unsupported を使っています。CentOS7上で。<br/>
<br/>
dockerコンテナ作成時の起動オプションをどのようなものを付けたか忘れてしまいました。<br/>
ポートフォワーディングについてはdocker psで確認できますが、restart, e, privilegedなどどのようなものを付与したかを動いているdockerコンテナから探ることはできないでしょうか。<br/>
<br/>
ご存知の方、ご教示お願いします。<br/>
<br/>
<br/>
docker inspectで必要な情報が取得できないでしょうか。<br/>
情報は、json形式で出力されるのでjqコマンドと組み合わせると良いと思います。<br/>
<br/>
例えば、testという名前のコンテナでrestartは、下記で確認することができます。<br/>
<pre>
$ docker inspect test | jq '.[0].HostConfig.RestartPolicy'
{
  "Name": "always",
  "MaximumRetryCount": 0
}
</pre>

その他の情報も下記の通り確認できます。<br/>

<pre>
$ docker inspect test | jq '.[0].Config.Env'
[
  "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  "TEST=aaa"
]
$ docker inspect test | jq '.[0].HostConfig.Privileged'
false
$
</pre>
