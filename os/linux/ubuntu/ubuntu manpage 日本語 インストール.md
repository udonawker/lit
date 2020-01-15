[Ubuntu/Debian系Linuxに「日本語マニュアルページ」をインストールする方法](https://linuxfan.info/ubuntu-debian-ja-manpages)<br/>

<pre>
$ sudo apt install -y manpages-ja manpages-ja-dev
</pre>
<br/>
これで、ロケール環境変数（LANGなど）に「ja_JP.UTF-8」などの日本語ロケールが設定されていれば、manコマンドで日本語のマニュアルページが表示されるようになります。<br/>
ただし、マニュアルページが日本語に訳されていないコマンドを指定した場合は、英語のマニュアルページが表示されます。<br/>
コマンドの出力する言語などを設定する「ロケール環境変数」については、以下の記事で詳しく解説しています。<br/>

[「ロケール環境変数」の種類と優先順位のまとめ LC_ALL LC_＊ LANG LANGUAGE](https://linuxfan.info/locale-variables)<br/>

<br/>
日本語のマニュアルページは内容が古かったり、翻訳が分かりにくかったりすることもあります。そんな場合は、以下の例のように頭に「LANG=C」を付けてmanコマンドを実行し、英語のマニュアルページを参照すると良いでしょう。<br/>
<pre>
$ LANC=C man date
</pre>
<br/>
ただし、「~/.bashrc」などで環境変数「LC_ALL」に「ja_JP.UTF-8」が設定されている場合、上記のコマンドを実行しても日本語のマニュアルページが表示されます。その場合は、以下のように「LC_ALL=C」を頭につけて実行します。<br/>
<pre>
$ LC_ALL=C man date
</pre>
