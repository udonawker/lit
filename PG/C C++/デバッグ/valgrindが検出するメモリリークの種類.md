## [valgrindが検出するメモリリークの種類](https://www.wagavulin.jp/entry/2016/08/28/231547)
## [Valgrindの結果の見方、日本語訳、など役に立つことまとめ](https://taiyakisun.hatenablog.com/entry/20150902/1441214819)

<pre>
valgrind --show-leak-kinds=indirect,reachable --leak-check=full ./executable
</pre>

<pre>
$ sudo apt-get install valgrind
[sudo] user のパスワード:
パッケージリストを読み込んでいます... 完了
依存関係ツリーを作成しています
状態情報を読み取っています... 完了
提案パッケージ:
  valgrind-dbg kcachegrind alleyoop valkyrie
以下のパッケージが新たにインストールされます:
  valgrind
アップグレード: 0 個、新規インストール: 1 個、削除: 0 個、保留: 763 個。
11.2 MB のアーカイブを取得する必要があります。
この操作後に追加で 66.5 MB のディスク容量が消費されます。
取得:1 http://jp.archive.ubuntu.com/ubuntu xenial-updates/main amd64 valgrind amd64 1:3.11.0-1ubuntu4.2 [11.2 MB]
11.2 MB を 2秒 で取得しました (4,764 kB/s)
以前に未選択のパッケージ valgrind を選択しています。
(データベースを読み込んでいます ... 現在 183335 個のファイルとディレクトリがインストールされています。)
.../valgrind_1%3a3.11.0-1ubuntu4.2_amd64.deb を展開する準備をしています ...
valgrind (1:3.11.0-1ubuntu4.2) を展開しています...
man-db (2.7.5-1) のトリガを処理しています ...
doc-base (0.10.7) のトリガを処理しています ...
doc-base ファイルを 32 個変更, doc-base ファイルを 1 個追加 を処理中...
valgrind (1:3.11.0-1ubuntu4.2) を設定しています ...
</pre>
