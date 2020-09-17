### 1. /etc/apt/apt.confに設定

<pre>
Acquire::ftp::proxy "ftp://username:password@your.proxy.address:proxy.port/";
Acquire::http::proxy "http://username:password@your.proxy.address:proxy.port/";
Acquire::https::proxy "https://username:password@your.proxy.address:proxy.port/";
</pre>

### 2. apt-get update
<pre>
$ sudo apt-get update --fix-missing
</pre>

### 3. 言語サポートからインストール
- 検索から言語サポートを起動
- 言語のインストールと削除から日本語をインストール
