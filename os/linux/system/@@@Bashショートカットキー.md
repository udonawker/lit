引用 
[Bashショートカットキー](https://qiita.com/takayu90/items/011a674b0a903572a50c "Bashショートカットキー")

<br/>

**動作環境**
<pre>
$ bash --version
GNU bash, version 4.4.23(1)-release (x86_64-unknown-linux-gnu)
...
</pre>

# マニュアルページ
インタラクティブシェルで使えるショートカットキーについてはBashのマニュアルページのREADLINEの箇所に記載してあります。man bashで参照できます。<br/>
本記事のタイトルは「ショートカットキー」としましたがマニュアルページでは「key bindings」という表現となってます。<br/>

# ショートカットキー一覧

ショートカットキーはマニュアルページの記載に合わせて以下のように表現します。<br/>
<br/>
- `Ctrl`キーとの同時押しは`C-x`と表現します。
- `Alt`キー(Metaキー)との同時押しは`M-x`と表現します。
<br/>

※`Esc`キーもMetaキーとして使用できます。この場合、同時押しでなくてもショートカットキーとして使用できます。(例: `Alt + f`と`Esc`, fが同じ動作をする。)
<br/>

## カーソル移動★★★<br/>

|key|コマンド名|説明|
|---|---|---|
|C-a|beginning-of-line|行頭へ移動|
|C-e|end-of-line|行末へ移動|
|C-f|forward-char|１文字進む|
|C-b|backward-char|１文字戻る|
|M-f|forward-word|１単語進む|
|M-b|backward-word|１単語戻る|
|C-l|clear-screen|現在行を残して画面をクリアする|
<br/>

## 履歴操作<br/>

|key|コマンド名|説明|
|---|---|---|
|C-p|previous-history|１つ前に実行したコマンドを挿入する。|
|C-r|reverse-search-history|コメンド履歴を検索※インクリメンタルサーチ<br/>※入力練習のためにはあまり使わないほうがいいかも|
|M-p|non-incremental-reverse-search-history|コマンド履歴を検索|
|M-.|yank-last-arg|直前のコマンドの引数を入力|

## テキスト処理<br/>

|key|コマンド名|説明|
|---|---|---|
|C-d|end-of-file|EOF(End Of File, ファイルの終端)を入力する。<br/>※コマンドラインに何も入力していない状態でやるとターミナルが終了する。|
|C-d|delete-char|コマンドラインに文字列を入力途中の場合、1文字削除する。Deleteキーと同じ。|
|C-v TAB|tab-insert|タブを挿入。<br/>Terminalでもタブを挿入できる。使い道はない。|
|C-t|transpose-chars|カーソル前後の文字を入れ替える。カーソルが行末にある場合、最後の2文字を入れ替える。|
|M-u|upcase-word|単語を大文字にする。|
|M-l|downcase-word|単語を小文字にする。|

## コピーペースト<br/>

|key|コマンド名|説明|
|---|---|---|
|C-k|kill-line|行末まで削除|
|C-u|unix-line-discard|行頭まで削除|
|M-d|kill-word|次の単語削除(単語の最後まで削除)|
|M-Rubout|backward-kill-word|前の単語削除(単語の最初まで削除)|
|C-w|unix-word-rubout|前の単語削除(スペースで区切られているものを単語とする)|

## 他<br/>

|key|コマンド名|説明|
|---|---|---|
|C-_|undo|やり直す|
|C-]|character-search|続けて入力する文字までカーソルを移動する<br/>例) 「$ cat hoge fuga」の行頭にカーソルがあるとして、`Ctrl + ], g`を押すと「fuga」のgにカーソルが移動する。|
|M-C-]|character-search-backward|上記「character-serarch」の逆(反対方向へ文字検索)|
<br/>

# 補足<br/>

**end-of-file (C-d)**<br/>
<br/>
ファイル終端を挿入するということは、もうそれ以上プログラムに渡すデータがないことを示します。<br/>
例)<br/>
`cat`コマンドはファイルの内容を出力するコマンドです。<br/>
引数にファイルを指定しなかった場合は、プログラムは標準入力から延々入力を受け付けます。<br/>
`Ctrl + d`でEOF(ファイル終端)が入力されると正常終了します。<br/>
イメージとして、下の例では、`^#`を入力して`Enter`を押した後に`Ctrl + d`でEOFを渡して入力を終了しています。<br/>
<pre>
$ cat > regex # 標準入力をregexというファイルにリダイレクトする
self-insert
^#
$ 
</pre>
<br/>

**単語**<br/>

単語の単位で移動したり削除したりするショートカットキーがありますが、大体は連続した英数字(alphanumeric)を単語とします。<br/>
記号は無視されます。全角ひらがなは単語として扱われましたがそんな使い方する人はいないでしょう。<br/>
例えば以下の入力の行末にカーソルがあり、`Alt + BackSpace`を押していくと以下のようになります。<br/>
<pre>
$ [ -a hoge ] && echo 'true' || echo 'false'
$ [ -a hoge ] && echo 'true' || echo '
$ [ -a hoge ] && echo 'true' || 
$ [ -a hoge ] && echo '
$ [ -a hoge ] && 
$ ...
</pre>
<br/>
`Ctrl + w`も同じく前の単語を削除しますが、スペース単位で消します。<br/>
上に挙げたコマンドではこれだけ例外です。<br/>
<pre>
$ [ -a hoge ] && echo 'true' || echo 'false'
$ [ -a hoge ] && echo 'true' || echo 
$ [ -a hoge ] && echo 'true' || 
$ [ -a hoge ] && echo 'true' 
$ [ -a hoge ] && echo 
$ ...
</pre>
<br/>

# おまけ
<br/>

**Ctrlキーが押しにくい**<br/>
キーバインドをカスタマイズしてCaps Lockに割り当てる人が多いようです。<br/>
日本のキーボードは無変換や変換がある分、手前のキーが多いので、わざわざ日本語キーボードを買って修飾キーを全部親指で押せるようにカスタマイズしている海外の人もいるそうです。<br/>
<br/>
Linuxの場合、xkbの設定(setxkbmapとか)やxmodmapなどで実現できます。<br/>
Windowsはアプリを入れたくなければレジストリエディタで設定できます。<br/>
<br/>
日本人で無変換変換を使わない人は修飾キーを割り当てたり、片方に日本語ON、片方に日本語OFFを割り当てるといいと思います。<br/>
<br/>
**キーバインドを確認する**

`bind -p`で設定されているキーバインドが一覧で表示されます。<br/>
効かない場合は確認してみてください。<br/>
`\C`が`Ctrl`キー、`\e`が`Esc`キー(Metaキー)のことです。<br/>
<pre>
$ bind -p > bindp
$ grep -E '^"\\[CeM]' bindp
"\C-g": abort
"\C-x\C-g": abort
"\e\C-g": abort
"\C-j": accept-line
"\C-m": accept-line
"\C-b": backward-char
"\eOD": backward-char
"\e[D": backward-char
"\C-h": backward-delete-char
(省略)
"\C-x\C-u": undo
"\C-_": undo
"\C-u": unix-line-discard
"\C-w": unix-word-rubout
"\eu": upcase-word
"\C-y": yank
"\e.": yank-last-arg
"\e_": yank-last-arg
"\e\C-y": yank-nth-arg
"\ey": yank-pop
</pre>
<br/>
普段使わないだろうというのもたくさんあります。<br/>
`Esc`, `O`, `D`で「一文字戻る」、など。<br/>
<br/>

**ターミナルエミュレータの設定**<br/>
シェルを使うためのソフトウェア・アプリケーションによってはツールバーのショートカットキーが優先されてしまうことがあります。<br/>
１単語進めようとして`Alt + f`を入力したら、ツールバーのファイルタブが開いてしまうなど。<br/>
シェルを使うことを前提にしているのであれば、ツールバーを非表示にするか、エミュレータのショートカットキーを無効にする設定が必ずあります。<br/>
