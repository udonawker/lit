[ADBコマンドいろいろ](https://qiita.com/961neko/items/aae283521d5b01cdc8c9)<br/>

## 基本
### ADBのバージョン
<pre>
adb version
</pre>

### 接続している端末の確認
<pre>
adb devices
</pre>

### アプリインストール
<pre>
adb install xxxx.apk
</pre>

### アプリアンインストール
<pre>
adb uninstall パッケージ名
</pre>

### すでに端末に同じ署名のapkがインストールされてる場合
<pre>
adb install -r xxxx.apk
</pre>

## 覚えておくと便利かも
### Wi-Fi環境でADB接続
- 端末をPCと同一のWi-Fi環境に接続させIPアドレスをメモなどで控えておく
- Android 端末と PC を USB ケーブルで接続
- TCPIPモードでホストのadbを再起動(下記コマンドを入力)

<pre>
adb tcpip 5555
</pre>

- adb connect Android端末のIPアドレス(さっきメモしたアドレス):5555

### Textをコマンドで入力(フォームなど)
まずは下記コマンドを入力してshellを起動します。<br/>

<pre>
adb shell
</pre>

これで準備ができました。<br/>
次に入力したいところを選択している状態で下記のように入力していけばいいです。<br/>

<pre>
input text hoge
</pre>
終了時にはexitで終わらます。<br/>
一度の入力でも可能。<br/>

<pre>
adb shell input text hoge
</pre>

### インストールされているアプリパッケージを取得
イントールされているアプリのパッケージ名を知りたいときなんかもあります。<br/>

<pre>
adb shell pm list package
</pre>

### 端末のバージョン

<pre>
adb shell getprop ro.build.version.release
</pre>

### データ削除

<pre>
adb shell pm clear パッケージ名
</pre>

### 強制終了
強制的にアプリを終了させます。<br/>

<pre>
adb shell am force-stop パッケージ名
</pre>

### アプリ内のデータベース(sqlite)を確認
新規参画のときなどはDBの中身からテーブル一覧をみたり、<br/>
最初にどんなデータが入っているのかを見たほうが仕様書を見るよりわかりやすかったりすることもあります。<br/>
<br/>
まずはデータベースのある場所に移動します。<br/>

<pre>
cd data/data/パッケージ名/databases
</pre>

lsコマンドで中を確認したいファイル名を出力してから、下記を実行。<br/>

<pre>
slete3 ファイル名
</pre>

あとはsql文を打つだけです。<br/>
