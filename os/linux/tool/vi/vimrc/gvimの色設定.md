## [WindowsのGVimでカラースキームwombatの設定](https://qiita.com/sifue/items/89c6c983732a4ed26e1a)
## [Vimのすっごく見やすい白背景カラースキーム「shirotelin」を作ってみました！](https://recruit.cct-inc.co.jp/tecblog/editor/vim/)
<br>

### GVim自体は、香り屋さんのGVim<br>
http://www.kaoriya.net/software/vim<br>

### colorshceme<br>
[wombat](http://www.vim.org/scripts/script.php?script_id=1778)<br>
[shirotelin](https://github.com/yasukotelin/shirotelin/blob/master/colors/shirotelin.vim)<br>

1. colorshcemeを$HOME\vimfiles\colors\に配置する
1. $HOME\gvimrc_に以下を記載(gvimrc_が存在しない場合は作成する)
<pre>
"---------------------------------------------------------------------------
" カラー設定:
"colorscheme morning
"colorscheme shirotelin
colorscheme wombat

" Copyright (C) 2011 KaoriYa/MURAOKA Taro
"独自に見た目を設定
set guioptions-=T " ツールバーを非表示
"set lines=90 columns=200 " 全画面表示起動したい方はコメントアウトを戻す 
gui
set transparency=221 " ウインドウを半透明に
</pre>
