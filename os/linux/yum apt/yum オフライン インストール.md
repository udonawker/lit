## オンラインサーバで実施
1.パッケージをダウンロードする。
<pre>
# yum install -y  --downloadonly --downloaddir=<ダウンロードディレクトリ> <パッケージ名>
</pre>
2.レポジトリ作成
<pre>
# createrepo --database <ダウンロードディレクトリ>
</pre>
3.ダウンロード＆createrepoしたディレクトリをアーカイブ

## オフラインサーバで実施
1.レポジトリアーカイブを任意のディレクトリに展開<br/>
2.yum repoファイル作成<br/>
<pre>
1.で展開したディレクトリが "/root/local_repo" の場合

/etc/yum.repos.d/local_repo.repo として以下を作成
--------------------------------
[local-repo]
name=local repo
baseurl=file:///root/local_repo
enabled=1
gpgcheck=0
--------------------------------
</pre>
3.yum install<br/>
<pre>
# yum install -y <パッケージ名>
</pre>
