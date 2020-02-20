[WSLで始めるUbuntu 第14回　キーバインドについて知ろう](https://www.school.ctc-g.co.jp/columns/miyazaki/miyazaki14.html)<br/>

## Readline
bashでは GNU Readline というライブラリを使用して、コマンドラインからの文字入力読み込みを行います。<br/>
キー入力はそのキーに割り当てられた機能を実行します。<br/>
通常「a」という文字を打つと self-insert という打ち込んだ文字をそのまま挿入します。<br/>
機能には幾つかの種類があり、特殊文字(Return、TAB、Delなど)も別の機能が割り当てられます。<br/>
キーに機能を割り当てることをキーバインドと呼ばれます。コントロール・エスケープと通常文字を組み合わせて、キーバインドを設定する事ができます。<br/>
<br/>

## キーバインド
現在のキーバインドは、`bind -p` を実行すると表示できます。bash のデフォルトキーバインドは、emacs-standard です。<br/>
emacs-standard は、GNU Emacsというエディタのキーバインドをベースにしています。<br/>
<br/>
キーバインドには、幾つか表示方法があります。今回はEmacs方式の表示とします。<br/>
\C-文字は、コントロールキーを押しながら文字キーを押します。<br/>
\e文字は、エスケープを押したあとに続く文字入力を行います。<br/>
キーには特殊キー(カーソルキー、ファンクションキーなど)が含まれますが、都度解説します。<br/>
<br/>
デフォルトのemacs-standardのキーバインドは以下のようになります。<br/>
以下はキーバインドされていないコマンドなどを含みません。<br/>
すべてを表示したい場合は、コマンド`bind -p`を実行して下さい。<br/>

|キー| 機能 | 説明|
|:--|:--|:-- |
|\C-g、\C-x\C-g、\e\C-g              |abort                       |文字入力を中断する|
|\C-j、\C-m                          |accept-line                 |文字入力位置に関係なく、入力中の文を実行する|
|\C-b、←(\e[D)                       |backward-char               |一文字戻る|
|Backspace(\C-?、\C-h                |backward-delete-char        |一文字前を削除する|
|\C-Backspace(\C-x\C-?)              |backward-kill-line          |行頭まで削除する|
|\eDEL(\e\C-?)、\e\C-h               |backward-kill-word          |一単語前まで削除する|
|\C-←(\e[1;5D)、\e←(\e\e[D)、\eb     |backward-word               |一単語前まで移動する|
|\e<                                 |beginning-of-history        |履歴の先頭まで戻る|
|\C-a、Home(\e[H)                    |beginning-of-line           |行頭に移動する|
|\ec                                 |capitalize-word             |単語をキャピタライズ(単語の先頭のみ大文字で以下小文字)する|
|__\C-]__                                |character-search            |文字を一文字読み込み、右側のその文字位置に移動する|
|__\e\C-]__                              |character-search-backward   |文字を一文字読み込み、左側のその文字位置に移動する|
|\C-l                                |clear-screen                |画面をクリアする|
|TAB(\C-i)、\e\e                     |complete                    |単語を補完する|
|__\e!__                                 |complete-command            |コマンドを補完する|
|__\e/__                                 |complete-filename           |ファイル名を補完する|
|\e@                                 |complete-hostname           |ホスト名を補完する|
|\e{                                 |complete-into-braces        |ファイル名を補完し、シェルから利用可能なブレース付きのリストとして展開します|
|\e~                                 |complete-username           |ユーザ名を補完する|
|\e$                                 |complete-variable           |変数を補完する|
|\C-d、DEL(\e[3~)                    |delete-char                 |文字入力位置の文字を削除する|
|\C-x\C-v                            |display-shell-version       |shell versionを表示する|
|\el                                 |downcase-word               |単語を小文字化する|
|\e\C-i                              |dynamic-complete-history    |文字位置より前のテキストに対し、履歴リストから補完する|
|\C-x\C-e                            |edit-and-execute-command    |エディタを起動して現在のコマンドラインの内容を開き、 その結果をシェルのコマンドとして実行する|
|\e>                                 |end-of-history              |履歴の末尾まで戻る|
|\C-e、\e[F(End)                     |end-of-line                 |行末まで移動する|
|\C-\、\e[C(→)                       |forward-char                |一文字進む|
|\C-s                                |forward-search-history      |現在の行から新しい方に履歴の検索をインクリメンタルに行う(別原因で\C-sは使用不可)|
|\C-→(\e[1;5C)、\e→(\e→(\e\e[C)、\ef |forward-word                |一単語進む|
|\eg                                 |glob-complete-word          |文字位置より前のテキストをファイル名として補完し、リストを表示する|
|\C-x*                               |glob-expand-word            |文字位置より前のワイルドカードを含むテキストを、ファイル名として補完・展開する|
|\C-xg                               |glob-list-expansions        |文字位置より前のワイルドカードを含むテキストを、ファイル名として補完してリスト表示する|
|\e^                                 |history-expand-line         |行中のヒストリ文字列(!で始まる文字列)を展開する|
|\C-k                                |kill-line                   |行末まで削除する|
|\ed                                 |kill-word                   |単語を削除する|
|\C-n、\COB、\e[B                    |next-history                |次の履歴に移動する|
|\C-p、\eOA、\e[A                    |previous-history            |前の履歴に移動する|
|\C-q、\C-v、\e[2~                   |quoted-insert               |特殊文字含む文字をそのまま入力|
|\C-r                                |reverse-search-history      |現在の行から古い方に履歴の検索をインクリメンタルに行う|
|\e\C-r、\er                         |revert-line                 |この行に行った変更をすべて打ち消す|
|a,b,c                               |self-insert                 |押した文字をそのまま入力する|
|\e\C-e                              |shell-expand-line           |bashが行うのと同じように行を展開する|
|\C-t                                |transpose-chars             |文字入力位置とその前の文字を置き換える|
|\et                                 |transpose-words             |文字入力位置の単語とその前の単語を置き換える|
|\C-_、\C-x\C-u                      |undo                        |前回の操作を打ち消す|
|\C-u                                |unix-line-discard           |入力中の文字列をすべて消す|
|\C-w                                |unix-word-rubout            |文字位置より前の単語を削除します|
|\eu                                 |upcase-word                 |単語を大文字化する|
