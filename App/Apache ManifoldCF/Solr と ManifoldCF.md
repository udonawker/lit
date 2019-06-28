引用[Solr と ManifoldCF](http://aspplus.nobody.jp/20140714solr/solr.html "Solr と ManifoldCF")<br/>

## Solr と ManifoldCF
- Apahe Lucene ⇒ 全文検索の部品
- Apahe Solr ⇒ 全文検索のサーバー
- Apahe ManifoldCF ⇒ クローラー
<br/>
CentOS 7.0 を使った。<br/>
CentOS 上のファイルシステムに PDF や Excel, Word を置いて全文検索するまでの記録。<br/>
<br/>

### ネットワーク穴あけ
<pre>
systemctl stop firewalld.service
</pre>

### Solr を起動
<pre>
rm -rf solr-4.9.0
export _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"
tar xf solr-4.9.0.tgz
cd solr-4.9.0/example/
java -jar start.jar
</pre>

Started SocketConnector@0.0.0.0:8983 と表示されたら起動完了。<br/>

### ManifoldCF 起動
<pre>
rm -rf apache-manifoldcf-1.6.1
export _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"
tar xf apache-manifoldcf-1.6.1-bin.tar.gz
cd apache-manifoldcf-1.6.1/example/
java -jar start.jar
</pre>
Starting crawler… と表示されたら起動完了。<br/>

### 検索対象の文書ファイルを設置
- /home/user2/doc/ フォルダを掘り、そこに色々とファイルを置く。
- 手元 Windows に存在した各種文書を CentOS にアップロードした。
- PDF や MS Office 文書も大丈夫。
- フォルダやファイルの名称に日本語使っていても大丈夫だけど、アップロード後にフォルダ名、ファイル名が文字化けていないか確認すること。
- 文字化けていると、ManifoldCF によるクロールの対象にならなかった。
- WinSCP でアップロードするなら、SCP ではなく SFTP を選び、UTF-8 encoding for filenames を On にする。

### クローラーを動かす
- http://192.168.0.7:8345/mcf-crawler-ui をブラウザーで開く。
- ユーザー、パスワードともに admin

.....
