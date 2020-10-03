## [Vim のウィンドウ分割機能](http://vimblog.hatenablog.com/entry/vim_window)

Vim は、ウィンドウを分割することが出来ます。Vim のウィンドウは、バッファと独立に存在する「覗き窓」です。<br>
分割されたウィンドウで、同じバッファ（ファイル）を開くことも、別のバッファを開くことも出来ます。あるファイルを編集しながら、ウィンドウ分割を利用して、同じファイルの別の部分を参照することも、別のファイルを参照することも可能です。<br>
Vim のウィンドウ関連でノーマルモードで利用できるコマンドは、すべて &lt;c-w&gt; から始まる２ストロークのコマンドです。<br>

<pre>
:h CTRL-W
</pre>

からすべてを網羅した一覧を確認することも出来ます。<br>
下に使用頻度の高いウィンドウ分割関連のコマンドを紹介します。<br>

|コマンド|動作|覚え方|
|:--|:--|:--|
|<lt;c-w>gt;s<br><lt;c-w>gt;<lt;c-s>gt;<br>:sp (ファイル名)<br>:split (ファイル名)|ウィンドウの上下分割|split|
|<lt;c-w>gt;v<br><lt;c-w>gt;<lt;c-v>gt;<br>:vs (ファイル名)<br>:vsplit (ファイル名)|ウィンドウの左右分割|vertical|
|<lt;c-w>gt;w<br><lt;c-w>gt;<lt;c-w>gt;|次のウィンドウに移動する|w 二回で手軽に移動|
|<lt;c-w>gt;c<br><lt;c-w>gt;<lt;c-c>gt;<br>:close|現在のウィンドウを閉じる|close|
|<lt;c-w>gt;o<br><lt;c-w>gt;<lt;c-o>gt;<br>:only<br>:on|現在のウィンドウ以外のウィンドウを閉じる|only|
|<lt;c-w>gt;h<br><lt;c-w>gt;<lt;c-h>gt;|ウィンドウを左に移動|カーソル移動と同じ|
|<lt;c-w>gt;j<br><lt;c-w>gt;<lt;c-j>gt;|ウィンドウを下に移動|カーソル移動と同じ|
|<lt;c-w>gt;k<br><lt;c-w>gt;<lt;c-k>gt;|ウィンドウを上に移動|カーソル移動と同じ|
|<lt;c-w>gt;l<br><lt;c-w>gt;<lt;c-l>gt;|ウィンドウを右に移動|カーソル移動と同じ|
|<lt;c-w>gt;x<br><lt;c-w>gt;<lt;c-x>gt;|現在のウィンドウと次のウィンドウを入れ替える|exchange|
|<lt;c-w>gt;+<br><lt;c-w>gt;<lt;c-+>gt;|現在のウィンドウを１文字分高くする|高さ + 1|
|<lt;c-w>gt;-<br><lt;c-w>gt;<lt;c-->gt;|現在のウィンドウを１文字分低くする|高さ - 1|
|<lt;c-w>gt;<lt;<br><lt;c-w>gt;<lt;c-<lt;>gt;|現在のウィンドウの横幅を１文字分狭くする|幅 <lt;|
|<lt;c-w>gt;>gt;<br><lt;c-w>gt;<lt;c->gt;>gt;|現在のウィンドウの横幅を１文字分広くする|幅 >gt;|

ヘルプ<br>
<pre>
:h window
</pre>
