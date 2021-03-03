## [プロキシ接続環境でWindows Updateなどが行えない時の対処法 2019/10/9](https://qiita.com/Yorcna/items/ea23f54bf207abde25c1)

Windows設定からプロキシを設定した場合、Widoews Updateなどに接続できない場合あった。<br>
コマンドプロンプトからWinhttpのプロキシ構成をすると解決した。<br>

#### Winhttp 設定
```
netsh winhttp set proxy proxy-server =<プロキシ サーバー> bypass-list=<バイパス リスト>
```

#### IEのプロキシ設定読み込む場合
```
netsh winhttp import proxy source=ie
```

#### Winhttp 設定確認コマンド
```
netsh winhttp show proxy
```

#### Winhttp 既定(直接アクセス)へリセットコマンド
```
netsh winhttp reset proxy
```

#### 参考URL
https://support.microsoft.com/ja-jp/help/2894304
