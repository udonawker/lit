## ダウンロード
<pre>
$ sudo git clone https://github.com/vim/vim
</pre>
ビルドに以下が必要
$ sudo apt install mercurial libncursesw5-dev make gcc<br>

## ビルド
<pre>
$ cd vim
$ sudo ./configure --with-features=huge --enable-multibyte
#$ sudo ./configure --with-features=huge --enable-multibyte --disable-selinux
$ sudo make
$ mv vim $HOME/local/src
$ cd $HOME/local/bin
$ ln -s $HOME/local/src/vim/src/vim vim
</pre>

## 設定
.bashrc等に以下を追加<br>
<pre>
export VIMRUNTIME="$HOME/local/src/vim/runtime"
</pre>
