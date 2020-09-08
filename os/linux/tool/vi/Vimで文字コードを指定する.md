# [Vimで文字コードを指定する](https://qiita.com/bezeklik/items/2c9925f9c07762559471)

## 指定の文字コードでファイルを開き直す
### Shift JIS でファイルを開き直す
<pre>
:edit ++encoding=sjis
</pre>
<pre>
:e ++enc=cp932
</pre>

### UTF-8 でファイルを開き直す
<pre>
:e ++enc=utf-8
</pre>

## 指定の文字コードでファイルを保存する
### Shift JIS でファイルを保存
<pre>
:set fileencoding=sjis
</pre>
<pre>
:se fenc=cp932
</pre>

## 現在のエンコードを確認する
### Vim のエンコード
<pre>
:se enc?
</pre>

ファイルのエンコード
<pre>
:se fenc?
</pre>
