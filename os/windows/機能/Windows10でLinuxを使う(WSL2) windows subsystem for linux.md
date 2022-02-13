## [Windows10でLinuxを使う(WSL2)](https://qiita.com/whim0321/items/ed76b490daaec152dc69)

### 0.事前準備
#### BIOS で [Virtualization Technology] を有効にする
[Windows 10 「BIOS」を起動させる手順をPCメーカー毎に紹介](https://tanweb.net/2017/12/22/17401/)<br>
* ［スタート］をクリック、［設定］をクリック
*  [更新とセキュリティ] をクリック
* 左サイドメニューから「回復」を選択し、右画面にある「PCの起動をカスタマイズする」項目の「今すぐ再起動」を選択
* 再起動後、オプションの選択が起動。「トラブルシューティング」を選択
* 「詳細オプション」を選択
* 「UEFI ファームウェアの設定」を選択
* 「再起動」を選択
* 再起動後にBIOSが起動

#### 「Windows Subsystem for Linux」を有効にする
[「Windows Subsystem for Linux」を有効にする方法](https://kb.seeck.jp/archives/8788)
* ［スタート］をクリック、［設定］をクリック
* ［アプリ］をクリック
* 「関連設定」から［プログラムと機能］をクリック
* ［Windows の機能の有効化または無効化］をクリック
*  [Linux 用 Windows サブシステム] にチェックを入れる
    * 「必要なファイルを検索してます」や「変更を適用しています」と表示される
* 「必要な変更が完了しました。」と表示されたら［今すぐ再起動］をクリック

### 1.
(Windows 10 version 2004以降でKB5004296を適用済みの場合（おすすめ）)<br>
コマンドプロンプトを管理者モードで開き、下記のコマンドだけでインストール完了。<br>
```
wsl --install
```

### 2. Microsoft Store からUbuntuをインストールする
* ubuntuを検索してインストール
