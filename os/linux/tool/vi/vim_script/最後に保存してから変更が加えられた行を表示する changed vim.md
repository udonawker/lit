## [changed.vim : 最後に保存してから変更が加えられた行を表示する](https://nanasi.jp/articles/vim/changed_vim.html)

- http://www.vim.org/scripts/script.php?script_id=2496から`changed.vim`をダウンロード<br>
  - windows $HOME\vimfiles\plugin に配置<br>
    - $MYVIMRC に :source $HOME/vimfiles/plugin/changed.vim を追加
  - linux   $HOME/.vim/ に配置
    - $MYVIMRC に source ~/.vim/changed.vim を追加

<br><br>
### [Windows環境のvimエディタでdiff機能を使うには](https://nanasi.jp/articles/howto/diff/vimdiff_in_windows.html)
- http://gnuwin32.sourceforge.net/packages/diffutils.htm から以下をダウンロード
  - Binaries(diffutils-2.8.7-1-bin.zip)
  - Dependencies(diffutils-2.8.7-1-dep.zip)
- それぞれのbin配下のexe、dllファイルを全てvimフォルダにコピー(vimの実行ファイルがあるフォルダ)
