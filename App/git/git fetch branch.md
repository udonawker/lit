[git branchメモ - ローカルやリモートのブランチ一覧を見る。リモートブランチ（追跡ブランチ）の情報を更新する(オプション-r、-a)](https://www.tweeeety.blog/entry/2014/10/23/232844)<br>

## ■特定ブランチをfetch
<pre>
$ git fetch origin/xxx
</pre>

## ■全てのリモートブランチをfetch
<pre>
$ git fetch
</pre>

## ■リモートブランチのlog
<pre>
$ git log origin/xxx
</pre>

## ■ローカルのbranch一覧を見る
<pre>
$ git branch
</pre>

## ■リモートのbranch情報である追跡ブランチの一覧を見る
<pre>
$ git branch -r
</pre>

## ■ローカルとリモート（追跡）両方のbranch一覧を見る
<pre>
$ git branch -a
</pre>

## ■リモートリポジトリ情報を見る
<pre>
$ git remote
origin

※ 詳細がでる
$ git remote -v
origin  git@github.com:pj/myProject (fetch)
origin  git@github.com:pj/pmProject (push)
</pre>
