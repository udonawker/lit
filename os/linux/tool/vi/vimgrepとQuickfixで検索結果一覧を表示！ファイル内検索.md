## [vimgrepとQuickfixで検索結果一覧を表示！](https://qiita.com/y_hideshi/items/80c85e46360fbb0dbf91?utm_source=stock_summary_mail&utm_medium=email&utm_term=udonta&utm_content=vim%E3%81%AE%E3%81%8A%E3%81%99%E3%81%99%E3%82%81%E3%81%97%E3%81%9F%E3%81%84%E5%B0%8F%E6%8A%80%E9%9B%86&utm_campaign=stock_summary_mail_2020-10-03)

#### コマンド
<pre>
:vim 検索文字列(正規表現も使えます！) 検索対象ファイル
</pre>

#### vimrcの設定
<pre>
" vim grepすると自動的にあたらしいウィンドウで検索結果一覧を表示する
autocmd QuickFixCmdPost *grep* cwindow
</pre>

#### ファイル内検索
現在開いているファイル内で文字列を検索する際は%を使用します！<br>
<pre>
:vim function %
</pre>

#### 別ファイル内の文字列検索
srcディレクトリ配下のファイルから特定の文字列を検索する場合<br>
<pre>
:vim function src/*
</pre>

### 検索結果へ移動
<pre>
Ctrl + w
</pre>

|操作|コマンド|
|:--|:--|
|次の検索結果へ|:cn[ext]|
|前の検索結果へ|:cN[ext] :cp[revious]|

### Quickfixと組み合わせる
<pre>
:vim {pattern} {file} | cw[:window]
</pre>

### 自動的にquickfix-windowを開く
:vimgrepに加えて:grep、:Ggrepでも自動的にquickfix-windowを開く<br>
.vimrcに以下を記述<br>
<pre>
autocmd QuickFixCmdPost *grep* cwindow
</pre>

windowの移動   `ctrl + w`<br>
windowを閉じる  `<c-w>o` `<c-w><c-o>` `:only` `:on`<br>
