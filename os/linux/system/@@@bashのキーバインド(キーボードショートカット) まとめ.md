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
