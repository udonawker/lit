引用[複数端末でのssh鍵共有](https://gist.github.com/to4iki/b27b40700bcd46484326#file-ssh-md)<br/>

## sshの鍵設定

[SSHの公開鍵を作成しGithubに登録する手順 - mon_sat at Co-Edo（半年前の自分への教科書 / 別院）](http://monsat.hatenablog.com/entry/generating-ssh-keys-for-github)  
[【メモ】githubの複数アカウントにSSH接続するための設定手順 ｜ Developers.IO](http://dev.classmethod.jp/tool/github-ssh-sub-account-setting/)

### github / bitbucket
[まとめ# BitbucketへのSSH公開鍵の手順メモ.自分用](https://gist.github.com/deroter/5308648)  
[SSH認証キーをBitbucket/GitHubに設定しよう！ [Mac簡単手順] - 酒と泪とRubyとRailsと](http://morizyun.github.io/blog/ssh-key-bitbucket-github/)

### 各PC間で共有したい
./ssh/id_rsa
./ssh/id_rsa.pub
のpermisionをいじる
```bash
$ chmod 600 .ssh/id_rsa
```

#### パーミッションの@を消す
[Mac ls パーミッションの横にある@アットマークを消す xattrコマンド - yasuakiのめげないゲーム開発](http://yasuaki-ohama.hatenablog.com/entry/2015/12/04/103650)

#### ssh-addでマシンに鍵登録
```bash
$ eval `ssh-agent`
$ ssh-add keyのパス（デフォルトは~/.ssh/id_rsaだと思う）
```
[複数PCでsshキーを共有する - About Digital](http://blog.digital-bot.com/blog/2013/09/16/ssh-add/)

[SSH の自動ログインメモ](http://www.asahi-net.or.jp/~iu9m-tcym/ssh/auto_login.html)
