引用<br/>
[GitHubから特定のディレクトリだけを直接ダウンロード](https://qiita.com/raucha/items/1219327df8a9ded494df) <br/>

git及びGitHubのAPIに，一部のディレクトリだけをダウンロードするための機能はありません．<br/>
ので，GitHubのsvn用のサポートを使います．<br/>
svn exportで指定したディレクトリがダウンロード出来ます．<br/>

<pre>
$ svn export https://github.com/ユーザー名/リポジトリ名/trunk/ディレクトリ名1/ディレクトリ名2/...
</pre>

e.x. <br/>
https://github.com/ros/rosdistro で/docだけをダウンロードしたい場合：<br/>

<pre>
svn export https://github.com/ros/rosdistro/trunk/doc
</pre>

### ブランチ名を指定する場合

<pre>
$ svn export https://github.com/ユーザー名/リポジトリ名/branches/ブランチ名/ディレクトリ名1/ディレクトリ名2
</pre>

### svnで利用できるディレクトリを表示

svn lsを使う<br/>

<pre>
$ svn ls https://github.com/ユーザー名/リポジトリ名/branches/
</pre>

---

引用<br/>
[GitHubで部分的にフォルダをダウンロードする方法（含Windows版）](https://ossyaritoori.hatenablog.com/entry/2017/05/07/GitHub%E3%81%A7%E9%83%A8%E5%88%86%E7%9A%84%E3%81%AB%E3%83%95%E3%82%A9%E3%83%AB%E3%83%80%E3%82%92%E3%83%80%E3%82%A6%E3%83%B3%E3%83%AD%E3%83%BC%E3%83%89%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95%EF%BC%88)

### svnコマンドを用いた特定のディレクトリのダウンロード

例えば，以下のディレクトリにファイルが存在するとして，<br/>

<pre>
https://github.com/XXX/YYY/tree/master/ZZZ
</pre>

/tree/masterの部分を/trunkに書き換えて以下のコマンドを打ちます。<br/>

<pre>
svn checkout https://github.com/XXX/YYY/trunk/ZZZ
</pre>

### GitShell（Git for Windows）を用いた場合

GitShellを用いた場合は，svnコマンドはgit svnと打つことで模擬できます。<br/>
ただ，上のコマンドは登録されてないか，initが必要っぽいのでめんどくさそうです。<br/>

最も簡単なのは恐らくcloneしてしまうことでしょう。<br/>

<pre>
git svn clone https://github.com/XXX/YYY/trunk/ZZZ
</pre>

（当然，tree/masterをtrunkに変更することを忘れずに！）<br/>

### cloneして出来たフォルダの処理

cloneして出来たフォルダですが，Gitの管理から外すには<br/>
以下のように.gitと書いてあるフォルダを削除します。<br/>

その他
[GitHub のリポジトリ内のサブディレクトリのみをダウンロードする](https://blog.clock-up.jp/entry/2016/12/09/github-sub-directory-download)<br/>
