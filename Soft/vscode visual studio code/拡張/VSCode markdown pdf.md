## [VS CodeでMarkdownをHTMLやPDFに変換するには？](https://www.atmarkit.co.jp/ait/articles/1804/27/news034.html)

### [詳細設定](https://github.com/yzane/vscode-markdown-pdf/blob/master/README.ja.md)

#### 1. 拡張機能からMarkdown PDFをインストール

#### 2. Markdown pdf の詳細設定から以下を設定
`markdown-pdf.executablePath`<br>
* バンドルされた Chromium の代わりに実行する Chromium または Chrome のパスを指定します
* 全ての \ は \\ と記述する必要があります (Windows)
* 設定の反映には、Visutal Studio Code の再起動が必要です
<pre>
"markdown-pdf.executablePath": "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
</pre>

#### 3. `Ctrl+Shift+P` を押してコマンドパレットを開き `convert Markdown to PDF`

<br><br>
任意に改行を入れる場合<br>
<pre>
&lt;div style="page-break-before:always"&gt;&lt;/div&gt;
</pre>
