## [ripgrep + fd + sd + vim で高速な grep & replace](https://marmooo.blogspot.com/2019/11/ripgrep-fd-sd-vim-grep-replace.html)

まず vimmer の人は vim の標準機能を使い、以下のコマンドで grep & replace している人が多いのではないでしょうか。<br>
```
:%s/foo/bar/gc       # 編集中のファイルを grep & replace
:'<,'>%s/foo/bar/gc  # 選択中の文字列を grep & replace
q:                   # コマンド履歴から置換コマンドを復唱

# 複数のファイルを grep & replace
:args **/*.csv                 # 置換対象を決定
:argsadd ./*.html              # 置換対象を追加
:args                          # 置換対象を確認
:argsdo %s/foo/bar/g | update  # 対象を置換
```

grep だけなら fzf.vim と組み合わせて、以下の機能を使っている人も多いでしょう。<br>
```
:Files    # ファイル検索
:Rg foo   # ripgrep で 高速な grep
:History  # ヒストリ検索
```

さて本題。fd / sd を使う場合、以下のようにすれば、高速に grep & replace ができます。<br>
```
:!sd foo bar %       # 編集中のファイルを grep & replace
:'<,'>!sd foo bar %  # 選択中の文字列を grep & replace
q:                   # コマンド履歴から置換コマンドを復唱

# 複数のファイルを grep & replace
:!sd foo bar $(fd -e csv)
:!sd foo bar $(fd -e csv && fd -e html)
```
sd コマンドで grep & replace をすると、コマンド履歴に :!sd ... という検索しやすい形で残ります。 これが地味に便利で良いです。<br>
