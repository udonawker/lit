引用 [【Redmine】Wiki制作で大活躍！よく使う13の記法について](https://www.cg-method.com/entry/2016/05/18/230502/) <br/>

## よくつかう記法

### 見出し

<pre>
h1.
</pre>
ページ名

<pre>
h2.
</pre>
大見出し

<pre>
h3.
</pre>
小見出し

### 目次
<pre>
{{toc}}
</pre>

### 画像
<pre>
!{width:640px}image.jpg!
</pre>

### 並列に画像を複数並べる
<pre>
||!{width:640px}image.jpg!||!{width:640px}image.jpg!||
</pre>

### 水平線
<pre>
---
</pre>

### リンク
<pre>
"Redmine.JP":http://redmine.jp/
</pre>

### リポジトリのリンク
<pre>
revisions/000001/entry/trunk
</pre>

revisionsとリビジョン番号の部分のパスを削除すると常に最新のデータになる<br/>
[【Redmine】SVNの最新のデータを参照する方法](http://www.cg-method.com/entry/2015/06/10/001308)<br/>

### テーブル
[【Redmine】Wikiのテーブルに色を付ける方法](http://www.cg-method.com/entry/2015/05/03/102845)<br/>

### 引用
<pre>
bq.
</pre>

### 折りたたむ
<pre>
{{collapse
あいうえお
}}
</pre>

### 赤文字
<pre>
%{color:red}赤文字%
</pre>

### 蛍光ペン
<pre>
%{background-color: #ffff00}蛍光ペン%
</pre>

### 箇条書き項目
<pre>
*
**
</pre>
