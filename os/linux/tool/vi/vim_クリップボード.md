<pre>
$ vim --version | grep clipboard
+clipboard       +insert_expand   +path_extra      +user_commands
+emacs_tags      +mouseshape      +startuptime     +xterm_clipboard
$ /usr/bin/vim.basic --version | grep clipboard
-clipboard       +insert_expand   +path_extra      +user_commands
+emacs_tags      -mouseshape      +startuptime     -xterm_clipboard
</pre>

:echo has('clipboard')が0を返す場合システムクリップボードからのコピー/貼り付け機能しません<br/>
この場合、vimは+clipboard機能でコンパイルされず、別のバージョンをインストールするか、再コンパイルします。<br/>
一部のLinuxディストリビューションでは、デフォルトで最小限のvimインストールが提供されますが、一般的にvim-gtkまたはvim-gtk3パッケージをインストールを使用すると、追加機能を取得できます。<br/>
<br/>

[Vim でコピペするときの Tips](http://cohama.hateblo.jp/entry/20130108/1357664352#f2)

## 0（ゼロ）レジスタで同じ文字列を何度も貼り付ける
<pre>
"0p
</pre>
と打てばヤンクされた文字列をいつでも使うことができます。<br/>


## * レジスタでクリップボードと連携する
<pre>
"*p
</pre>
とすると、クリップボードの内容を貼り付けることができます。<br/>
逆にクリップボードに文字列を書き込むには "*yy などとします。<br/>

## <C-R>でインサートモードから貼り付け
インサートモードにいるときに、ヤンクした文字列を貼り付けたくなったら・・・？インサートモードで<br/>
<pre>
&lt;C-R&gt;"
</pre>
とすると、ノーマルモードに戻らずに無名レジスタの内容を貼り付けることができます。<br/>
&lt;C-R&gt;のあとはレジスタを指定できます。<br/>
&lt;C-R&gt;a で a レジスタの内容を貼り付けます。<br/>
無名レジスタのときは " です。<br/>
あと、&lt;C-R&gt; による貼り付けはコマンドモードでも使えます。<br/>
<br/>
<br/>
[vimエディタからクリップボードを利用する。](https://nanasi.jp/articles/howto/editing/clipboard.html)<br/>

* 概要
* ショートカットキー入力によるクリップボードの操作
    * Windows環境
    * Mac OSX環境
* メニューによるクリップボードの操作
* 「*レジスタ」によるクリップボードの操作
    * 「*レジスタ」
    * レジスタにデータをセットする
    * レジスタからデータを読み込む
* クリップボード関連の設定
    * ビジュアルモードで選択したテキストが、クリップボードに入るようにする。
    * yankしたテキストが無名レジスタだけでなく、*レジスタにも入るようにする。
* 注意事項など

Windows環境のvimエディタでは、次のコマンドでクリップボードのデータを操作できます。<br/>
この操作は、ノーマルモード、入力モード、コマンドラインモード、ビジュアルモード、 検索と全ての操作で使用可能です。<br/>
* `Control` キー + `Insert` キーでコピー
* `Control` キー + `Delete` キーでカット
* `Shift` キー + `Delete` キーでカット
* `Shift` キー + `Insert` キーでペースト
