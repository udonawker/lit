[@@@bashのキーバインドを覚えて快適コマンドライン生活](https://unskilled.site/bash%E3%81%AE%E3%82%AD%E3%83%BC%E3%83%90%E3%82%A4%E3%83%B3%E3%83%89%E3%82%92%E8%A6%9A%E3%81%88%E3%81%A6%E5%BF%AB%E9%81%A9%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%83%A9%E3%82%A4%E3%83%B3%E7%94%9F/)<br/>
[Bashショートカットのチートシート](https://qiita.com/rma/items/b718ff398a7b1e16557c)<br>
[Bashショートカットキー](https://qiita.com/takayu90/items/011a674b0a903572a50c)<br>
[bashで覚えておきたいショートカットキー(キーバインド)](https://orebibou.com/ja/home/201506/20150629_001/)<br>
<br>
|キーバインド|意味|readlineのコマンド名|
|:--|:--|:--|
|ctrl + j|コマンド実行(Enter)|accept-line|
|ctrl + t|文字の前後入れ替え|transpose-chars|
|alt + t|単語の前後入れ替え|transpose-words|
|alt + u|カーソル位置の(または後ろの)単語を大文字にする|upcase-word|
|alt + l|カーソル位置の(または後ろの)単語を小文字にする|downcase-word|
|alt + c|カーソル位置の文字を小文字⇔大文字に変換する (変換後、単語の最後にカーソル位置を移動する)||
|alt + i|補完|complete|
|alt + !(shift+1)|コマンド補完|complete-command|
|alt + /|ファイル名補完|complete-filename|
|alt + @|ホスト名補完|complete-hostname|
|alt + ~(shift+^)|ユーザ名補完|complete-username|
|alt + $(shift+4)|シェル変数補完|complete-variable|
|alt + .|前のコマンドの引数を挿入(押すたびに遡る)|yank-last-arg|
|ctrl + x, *(shift+:)|globを展開する|glob-expand-word|
|ctrl + x, ctrl + u|undo|undo|
|ctrl + ]|文字を 1 つ読み込み、 その文字が次に現われる場所に移動|character-search|
|ctrl + alt + ]|文字を 1 つ読み込み、 その文字が次に現われる場所に移動|character-search-backward|
|ctrl + xx|カーソルの位置を記憶する (再度同じキーを実行すると、最初に記憶したカーソルの位置に戻る)||
|ctrl + y|切り取った文字(Ctrl + w,u,k)を貼り付ける|yank|
