## [設定ファイル (.vimrc) を開く、リロードする](https://maku77.github.io/vim/settings/reload-vimrc.html)

## 設定ファイルを開く

設定ファイル（.vimrc や .gvimrc）を開くには、下記のようにします。<br>
<pre>
:edit ~/.vimrc
:edit ~/.gvimrc
</pre>

Windows の場合は、.vimrc ではなく、_vimrc というファイル名なので、下記のようにしなければいけません。<br>
<pre>
:edit ~/_vimrc
:edit ~/_gvimrc
</pre>

実は、これらの設定ファイル名（パス）は、$MYVIMRC、$MYGVIMRC という変数に格納されているので、次のように実行すれば、環境に依存しない指定方法で設定ファイルを開くことができます。<br>
<pre>
:edit $MYVIMRC
:edit $MYGVIMRC
</pre>

## 設定ファイルを再読み込みする
設定ファイルを変更した後で、その内容を反映させるには下記のように実行します。<br>
<pre>
:source $MYVIMRC
:source $MYGVIMRC
</pre>
