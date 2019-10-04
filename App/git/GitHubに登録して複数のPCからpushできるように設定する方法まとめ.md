引用[GitHubに登録して複数のPCからpushできるように設定する方法まとめ](http://soramugi.hateblo.jp/entry/2012/02/12/234946) <br/>

[Gitの学習をした時の参照リンクとメモ - 見方次第](http://soramugi.hateblo.jp/entry/2012/02/10/202111) <br/>
上記の記事である程度のgitを使える知識が付いたのでそのままGitHubにコードを乗せて複数のPCからコードが編集出来るように設定した方法まとめ。<br/>

[ Macにgitをインストールしてそのままgithubにも登録 at kishi-r.com](http://kishi-r.com/archives/444) <br/>
上記記事を参考にして進む。<br/>

途中の「SSH Keys」がPC毎に設定した方がよさげらしいです。<br/>

## SSH Keysの作成、設定
使用するPC毎に設定するみたいなのでメモ<br/>
.ssh/ 以下に移動して<br/>

<pre>
# ssh-keygen
</pre>

を入力、最初のファイル名を「github_id_rsa」にしてパスワード登録<br/>
作成された「github_id_rsa.pub」の中身を<br/>
[Log in - GitHub](https://github.com/settings/ssh)<br/>
に登録させておく<br/>
.ssh/configを作成して以下を記入<br/>

<pre>
Host github.com
 User git
 Port 22
 Hostname github.com
 IdentityFile ~/.ssh/github_id_rsa
 TCPKeepAlive yes
 IdentitiesOnly yes
</pre>

## 他、設定

<pre>
# git config --global user.name 'ユーザー名'
# git config --global user.email '登録メールアドレス'
</pre>

最初のバージョンを公開するときコミットしてから以下<br/>

<pre>
# git remote add original git@github.com:ユーザー名/作成したディレクトリ名.git
# git push original master
</pre>

すでに公開しているリポジトリをローカルに持ってくるとき<br/>
リポジトリを置きたいディレクトリで以下<br/>

<pre>
# git clone ＜git@github.com:ユーザー名/リポジトリ名.git＞
</pre>

GitHubにあげるときはコミットしてから<br/>

<pre>
# git push
</pre>

上がってるのを持ってきたい時は<br/>

<pre>
# git pull
</pre>
