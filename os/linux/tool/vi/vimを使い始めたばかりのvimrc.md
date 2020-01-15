引用[vimを使い始めたばかりのvimrc](https://qiita.com/giri5p/items/227fc2f5e3e48a5709fc)<br/>

<pre>
"-----------------------------------------
" 検索の挙動に関する設定
"-----------------------------------------
" 検索時大文字小文字の区別を無視(noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" ファイルの最後まで検索したら先頭に戻って検索する(nowrapscan:戻らない)
set wrapscan

"-----------------------------------------
" 編集に関する設定
"-----------------------------------------
" タブをスペースに変換
set expandtab
" 自動的にインデントする(noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 括弧入力時対応する括弧を表示(noshowmatch:表示しない)
set showmatch
" コマンドライン補完時に強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"-----------------------------------------
" 画面表示の設定
"-----------------------------------------
" 行番号を表示
set number
" ルーラーを表示(noluler:表示しない)
set ruler
" タブや改行を表示
set list
" タブや改行の表示用記号を設定
set listchars=tab:>-,extends:<,trail:-
" 長い行を折り返して表示(nowrap:折り返さない)
set wrap
" 常にステータス行を表示(参照 :he laststatus)
set laststatus=2
" コマンドラインの高さ
set cmdheight=1
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" カラー設定
"colorscheme koehler
" フォーカス確認
augroup focus_colorscheme
  autocmd!
  autocmd FocusGained * colorscheme koehler
  autocmd FocusLost   * colorscheme evening
augroup END

"-----------------------------------------
" ファイル操作に関する設定
"-----------------------------------------
" バックアップを作成しない
set nobackup
" undoの履歴ファイルを作成しなお
set noundofile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" 上下n行見える状態でスクロール
set scrolloff=5
" クリップボードにyank,選択範囲自動yank
set clipboard=unnamed,unnamedplus,autoselect
" インサートモードから抜けると自動的にIMEをオフにする
"set iminsert=2

"-----------------------------------------
" 文字コード設定
"-----------------------------------------
" 改行での自動コメントアウト無効(無効が効かないのでバッファを読むたびのセット)
augroup auto_commentout
  autocmd!
  autocmd BufRead * set formatoptions-=ro
augroup END
" 文字コード指定
set encoding=utf-8
" ファイル読み込み時の文字コード指定
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
" 改行コード判別
set fileformats=unix,dos,mac

"-----------------------------------------
" タブサイズ設定
"-----------------------------------------
" タブの画面上での幅
set tabstop=2
" インデントの単位となるスペース幅
set shiftwidth=2
" ファイル拡張子によって設定を変える
augroup file_type_indent
  autocmd!
  " インデントサイズ2
  set TabEnter,BufRead *.html,*.tpl setlocal tabstop=2 siftwidth=2
  set TabEnter,BufRead *.js setlocal tabstop=2 siftwidth=2
  " インデントサイズ4
  set TabEnter,BufRead *.php setlocal tabstop=4 siftwidth=4
  set TabEnter,BufRead *.rb setlocal tabstop=4 siftwidth=4
augroup END

"-----------------------------------------
" スペルチェック
"-----------------------------------------
set spelllang=en,cjk

fun! s:SpellConf()
  redir! => syntax
  silent syntax
  redir END

  set spell

  if syntax =~? '/<comment¥>'
    syntax spell default
    syntax match SpellMaybeCode /¥<¥h¥l*[_A-Z]¥h¥{-}¥>/ contains=@NoSpell transparent containedin=Comment contained
  else
    syntax spell toplevel
    syntax match SpellMaybeCode /¥<¥h¥l*[_A-Z]¥h¥{-}¥>/ contains=@NoSpell transparent
  endif

  syntax cluster Spell add=SpellNotAscii,SpellMaybeCode
endfunc

augroup spell_check
  autocmd!
  autocmd BufReadPost,BufNewFile * call s:SpellConf()
augroup END

"-----------------------------------------
" キーマッピング
"-----------------------------------------
" 方向キーの無効化
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" 入力モード時のカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" 文字の削除、置き換え時yankしないようにする
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X
nnoremap s "_s
vnoremap s "_s
nnoremap S "_S
vnoremap S "_S
xnoremap <expr> p 'pgv"'.v:register.'y`>'
" 改行挿入
nnoremap <C-o> o<ESC>
nnoremap <CR> i<CR><ESC>
" スペース挿入
nnoremap <Space> i<Space><ESC>
" 補完
inoremap <C-Space> <C-p>
inoremap <C-Space> <C-n>
" エスケープ
inoremap :; <ESC>
inoremap ;: <C-c>
" 別ファイルを開く
command TN tabnew .
command O open .
" 改行の無いjsonデータを見やすくする
command Json %s/,/,¥r/ge | %s/¥v(¥[|¥]|¥{|¥})/¥r¥l¥r/ge | v/./d | %s/:¥n{/:{/ge | %s/:¥n¥[/:[/ge | %s/}¥n,/},/ge | %s/¥]¥n,/],/ge | %s/¥[¥n¥]/[]/ge | set filetype= json

" コメントアウト記号設定
nnoremap // 0i//<Space><ESC>
vnoremap // 0<C-v>I//<Space><ESC>
augroup commentout
  autocmd!
  autocmd TabEnter,BufRead *vimrc nnoremap // 0i"<Space><ESC>
  autocmd TabEnter,BufRead *vimrc vnoremap // 0<C-v>I"<Space><ESC>
  autocmd TabEnter,BufRead *.rb nnoremap // 0i#<Space><ESC>
  autocmd TabEnter,BufRead *.rb vnoremap // 0<C-v>I#<Space><ESC>
  autocmd TabEnter,BufRead *.php nnoremap // 0i//<Space><ESC>
  autocmd TabEnter,BufRead *.php vnoremap // 0<C-v>I//<Space><ESC>
  autocmd TabEnter,BufRead *.html nnoremap // 0i<!--<Space><ESC>$A<Space>--><ESC>
  autocmd TabEnter,BufRead *.html vnoremap // A<Space>--><ESC>gvo0I<!--<Space><ESC>
  autocmd TabEnter,BufRead *.js nnoremap // 0i//<Space><ESC>
  autocmd TabEnter,BufRead *.js vnoremap // $hA<Space>*/<ESC>gvo0I/*<Space><ESC>
augroup END

" 閉じタグ補完
augroup MyXML
  autocmd!
  autocmd TabEnter,BufRead *.xml,*.html,*.php inoremap <buffer> </ </<C-x><C-o><ESC>F<i
augroup END

" デバッグコード入力
augroup debug_code
  autocmd!
  autocmd TabEnter,BufRead *.php inoremap @pp var_dump();<ESC>hi
  autocmd TabEnter,BufRead *.js inoremap @pp console.log();<ESC>hi
augroup END
</pre>
