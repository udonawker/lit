## ファイル全体
#### 全体を置換
<pre>
:%s/置換前文字列/置換後文字列/g
</pre>
※ **`g`** は同一行の複数ヒットを含む

## 行指定で置換
#### 現在のカーソル行のみ
<pre>
:s/置換前/置換後/g
</pre>

#### 行数を指定して
<pre>
:開始行数,終了行数s/置換前/置換後/g
</pre>

#### 現在行以降
<pre>
:,$s/置換前/置換後/g
</pre>

#### Visualモードで範囲選択して
1. `Shift + v` で VISUAL LINE モードへ
1. 選択したい範囲を `h or k` で指定
1. コロンをタイプ `:`
1. コマンドラインに `:'<,'>` のように表示されるので、続けて置換コマンドである `s/置換前/置換後/g`
<pre>
:'<,'>s/置換前/置換後/g
</pre>
