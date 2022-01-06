## [古いマシーンに ssh 接続できない時の対策](https://qiita.com/ekzemplaro/items/d3309af44bee063c0018)
## [SSHのコマンドラインでKeyExchangeアルゴリズムを追加する方法](http://transparent-to-radiation.blogspot.com/2021/02/sshkeyexchange.html)

古いサーバへのSSHで以下のように表示されることがある。<br>
```
Unable to negotiate with 192.168.1.10 port 22: no matching key exchange method found. Their offer: diffie-hellman-group1-sha1
```

以下のようにすればよい<br>
```
$ ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 192.168.1.10
$ ssh -o KexAlgorithms=+diffie-hellman-group1-sha1 192.168.1.10
$ ssh -o KexAlgorithms=diffie-hellman-group1-sha1 192.168.1.10
```

## [ssh コマンドでパスワード認証を指定して接続するオプション](https://qiita.com/dounokouno/items/2e9086fef19ff20fb3f9)
```
ssh username@ipaddress -o PreferredAuthentications=password
```
