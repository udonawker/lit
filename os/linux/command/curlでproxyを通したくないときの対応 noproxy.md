## [curlでproxyを通したくないときの対応](https://qiita.com/tenten0213/items/a68cca7952dfb5f4a06a)

curlには7.19.4以降--noproxyというオプションが追加されています。<br>
manを読むと、proxyを使いたくない宛先ホスト名をカンマ区切りで並べろということです。<br>
```
--noproxy <no-proxy-list>
      Comma-separated  list of hosts which do not use a proxy, if one is specified.  The only wildcard is a
      single * character, which matches all hosts, and effectively disables the proxy. Each  name  in  this
      list  is matched as either a domain which contains the hostname, or the hostname itself. For example,
      local.com would match local.com, local.com:80, and www.local.com, but not  www.notlocal.com.   (Added
      in 7.19.4).
```

sample<br>
```
$ curl --noproxy example.com -i -X POST -H "Content-Type: application/json" http://example.com/users -d @user.json

# curl --noproxy localhost localhost:5000/v2/_catalog
```

ちなみに7.53.0からは、空文字("")を指定することで、環境変数に設定したno_proxyを打ち消すこともできるようになる(まだリリースされていないはず？)みたいです。<br>
```
--noproxy <no-proxy-list>

Comma-separated list of hosts which do not use a proxy, if one is specified. The only wildcard is a single * character, which matches all hosts, and effectively disables the proxy. Each name in this list is matched as either a domain which contains the hostname, or the hostname itself. For example, local.com would match local.com, local.com:80, and www.local.com, but not www.notlocal.com.

Since 7.53.0, This option overrides the environment variables that disable the proxy. If there's an environment variable disabling a proxy, you can set noproxy list to "" to override it.

Added in 7.19.4.
```
