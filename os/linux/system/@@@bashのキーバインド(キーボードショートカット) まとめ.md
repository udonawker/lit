[bashのキーバインド(キーボードショートカット) まとめ](https://hogem.hatenablog.com/entry/20090411/1239451878)<br/>


### カーソル移動系

| キーバインド | readlineの関数名　| 説明 |
| :----------- |:----------------- | :--- |
|C-a    | beginning-of-line    | 行頭に移動 # Home|
|C-e    | end-of-line          | 行末に移動 # End|
|C-b    | backward-char        | 1文字戻る # ←|
|C-f    | forward-char         | 1文字進む # →|
|C-n    | next-history         | 次の履歴を表示 # ↓|
|C-p    | previous-history     | 前の履歴 # ↑|
|M-f    | forward-word         | 次の単語に移動    |
|M-b    | backward-word        | 前の単語に移動|
|M-<    | beginning-of-history | 履歴の先頭を表示|
|M->    | end-of-history       | 履歴の最後を表示|

### 文字入力、削除、貼り付け


| キーバインド | readlineの関数名　| 説明 |
| :----------- |:----------------- | :--- |
|C-h   |  backward-delete-char  |  直前の1文字を削除 # BackSpace|
|C-d   |  delete-char           |  直後の1文字を削除 # Delete|
|C-w   |  unix-word-rubout      |  直前の1単語を削除(単語境界は空白類)|
|MC-h  |  backward-kill-word    |  直前の1単語を削除|
|M-d   |  kill-word             |  直後の1単語を削除|
|C-u   |  unix-line-discard     |  カーソル以前の文字を削除 # パスワード間違ったときなどに|
|C-k   |  kill-line             |  カーソル以降の文字を削除|
|C-y   |  yank                  |  削除,killした単語を貼り付け|
|C-t   |  transpose-chars       |  直前の文字と、その前の文字を入れ替える|


### 検索、補完

| キーバインド | readlineの関数名　| 説明 |
| :----------- |:----------------- | :--- |
C-r   |  reverse-search-history  履歴を後方に(遡って)インクリメンタルサーチ|
C-s   |  forward-search-history  履歴を前方にインクリメンタルサーチ *2|
C-i   |  complete                コマンド、引数など。適した単語を補完 # Tab|
M-!   |  complete-command        コマンドを補完|
M-/   |  complete-filename       filenameを補完|
M-@   |  complete-hostname       hostnameを補完 # /etc/hosts から?|
M-~   |  complete-username       usernameを補完 # /etc/passwd から?|
M-$   |  complete-variable       シェル変数を補完|
M-.   |  insert-last-argument    直前のコマンドの最後の引数を挿入|
C-x*  |  glob-expand-word        globを展開する|
M-*   |  insert-completions      補完対象の単語を引数に挿入|

### その他

| キーバインド | readlineの関数名　| 説明 |
| :----------- |:----------------- | :--- |
C-l    | clear-screen          |  ターミナルをクリア # clearコマンド|
M-l    | downcase-word         |  直後の単語を大文字に変換|
M-u    | upcase-word           |  直後の単語を大文字に変換|
C-xC-r | re-read-init-file     |  .inpurtc?をreload|
C-xC-v | display-shell-version |  version表示|

<br/>
バインド確認<br/>
<pre>
$ bind -p | egrep -v '^#|self-insert|do-lowercase-version|digit-argument'
"\C-g": abort
"\C-x\C-g": abort
"\e\C-g": abort
"\C-j": accept-line
"\C-m": accept-line
"\C-b": backward-char
"\eOD": backward-char
"\e[D": backward-char
"\C-h": backward-delete-char
"\C-?": backward-delete-char
"\C-x\C-?": backward-kill-line
"\e\C-h": backward-kill-word
"\e\C-?": backward-kill-word
"\e\e[D": backward-word
"\e[1;5D": backward-word
"\e[5D": backward-word
"\eb": backward-word
"\e<": beginning-of-history
"\C-a": beginning-of-line
"\eOH": beginning-of-line
"\e[1~": beginning-of-line
"\e[H": beginning-of-line
"\C-xe": call-last-kbd-macro
"\ec": capitalize-word
"\C-]": character-search
"\e\C-]": character-search-backward
"\C-l": clear-screen
"\C-i": complete
"\e\e": complete
"\e!": complete-command
"\e/": complete-filename
"\e@": complete-hostname
"\e{": complete-into-braces
"\e~": complete-username
"\e$": complete-variable
"\C-d": delete-char
"\e[3~": delete-char
"\e\\": delete-horizontal-space
"\C-x\C-v": display-shell-version
"\el": downcase-word
"\e\C-i": dynamic-complete-history
"\C-x\C-e": edit-and-execute-command
"\C-x)": end-kbd-macro
"\e>": end-of-history
"\C-e": end-of-line
"\eOF": end-of-line
"\e[4~": end-of-line
"\e[F": end-of-line
"\C-x\C-x": exchange-point-and-mark
"\C-f": forward-char
"\eOC": forward-char
"\e[C": forward-char
"\C-s": forward-search-history
"\e\e[C": forward-word
"\e[1;5C": forward-word
"\e[5C": forward-word
"\ef": forward-word
"\eg": glob-complete-word
"\C-x*": glob-expand-word
"\C-xg": glob-list-expansions
"\e^": history-expand-line
"\e#": insert-comment
"\e*": insert-completions
"\e.": insert-last-argument
"\e_": insert-last-argument
"\C-k": kill-line
"\ed": kill-word
"\C-n": next-history
"\eOB": next-history
"\e[B": next-history
"\en": non-incremental-forward-search-history
"\ep": non-incremental-reverse-search-history
"\C-o": operate-and-get-next
"\C-x!": possible-command-completions
"\e=": possible-completions
"\e?": possible-completions
"\C-x/": possible-filename-completions
"\C-x@": possible-hostname-completions
"\C-x~": possible-username-completions
"\C-x$": possible-variable-completions
"\C-p": previous-history
"\eOA": previous-history
"\e[A": previous-history
"\C-q": quoted-insert
"\C-v": quoted-insert
"\e[2~": quoted-insert
"\C-x\C-r": re-read-init-file
"\C-r": reverse-search-history
"\e\C-r": revert-line
"\er": revert-line
"\C-@": set-mark
"\e ": set-mark
"\e\C-e": shell-expand-line
"\C-x(": start-kbd-macro
"\e&": tilde-expand
"\C-t": transpose-chars
"\et": transpose-words
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
