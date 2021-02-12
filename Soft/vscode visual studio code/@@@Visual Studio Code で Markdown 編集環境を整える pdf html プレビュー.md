## [Visual Studio Code で Markdown 編集環境を整える](https://qiita.com/kumapo0313/items/a59df3d74a7eaaaf3137)

プレビュー表示:Ctrl + k → v
html化:プレビュー表示で右クリック → HTML → HTML(offline)<br>
pdf化:html化したものをブラウザでpdf印刷<br>
(もしくは拡張機能Markdown PDF[yzane]をインストール → ソース画面で Ctrl + Shift + p → Markdown PDF : Export (pdf)を実行)<br>

### 1. markdownlint をインストール
拡張機能『[markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)』をインストールします。<br>
markdownlint はその名の通り Markdown の lint ツールです。<br>

### 2. Markdown Preview Enhanced をインストール
拡張機能『[Markdown Preview Enhanced](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced)』をインストールする。<br>

#### テーブルの colspan,rowspan に対応
ユーザー設定でmarkdown-preview-enhanced.enableExtendedTableSyntax を trueにするとテーブルの colspan と rowspan に対応できます。<br>
sample<br>
```
colspan `>` or `empty cell`:
| a   | b   |
| --- | --- |
| >   | 1   |
| 2   |

rowspan `^`:
| a   | b   |
| --- | --- |
| 1   | 2   |
| ^   | 4   |
```

#### html 出力時にサイドバー TOC を有効化
**※セキュリティリスクがあるので利用の際はご注意ください。**<br>
以前はデフォルトで有効でしたが、セキュリティの関係上デフォルトで無効になっています（ver.0.3.5 以降）。<br>
有効にするには、ユーザー設定でmarkdown-preview-enhanced.enableScriptExecutionをtrueにします。<br>
有効にすると、html 出力時にサイドバーメニュー（目次）が生成されます。<br>
ちなみにメニューボタンが左下に表示されるのですが、好みでないので左上にカスタマイズしています。<br>

1. ctrl+shift+p を押し、 `Markdown Preview Enhanced: Customize Css`を開きます<br>
2. 以下を最終行の後に追加します。<br>
style.less<br>
```
// サイドバーTOCを左上にする
.md-sidebar-toc.md-sidebar-toc {
  padding-top: 40px;
}

#sidebar-toc-btn {
  bottom: unset;
  top: 8px;
}
```
