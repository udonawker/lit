### 1. ssh インストール
<pre>
$ sudo apt-get install ssh
</pre>

※先に sudo apt-get update が必要かも？

### 2. ssh 自動起動設定＆起動
<pre>
$ sudo systemctl enable ssh
$ sudo systemctl start ssh
</pre>

### 3. VirtualBox ネットワーク設定
* デバイスタブ⇒ネットワーク⇒ネットワーク設定<br/>
* ネットーワークをフォーカスしアダプター1タブで▷高度をクリック<br/>
* ポートフォワーディングボタン押下<br/>
* 右端の＋ボタンを押下<br/>
* 名前カラムに適当な名前、ホストポートに3333、ゲストポートに22を設定<br/>

### 4. Teratermで接続
* Teratermを実行し、ホスト(T)に「localhost:3333」、TCPポート(P)に「22」を設定し接続する
