引用 [screenのコマンドの備忘録](https://qiita.com/mgoldchild/items/e336618487eb7d90f6d4)<br/>

## 用語

|項目|値|
|--- |---|
|プリフィックスコマンド|ctrl + a|
|セッション|仮想端末を管理する概念|
|ウィンドウ|一つの仮想端末のこと|
|ペイン|分割された仮想端末画面のこと|
|リージョン|分割された仮想端末画面領域のこと|
|レイアウト|仮想端末画面領域の区切られ方|
|アタッチ|セッションがフォアグラウンドで使用中のこと|
|デタッチ|セッションがバッググラウンドで使用中のこと|
|サスペンド|セッションを使用停止にすること|

## セッションの操作

|項目|値|
|--- |---|
|セッション開始|screen|
|セッション一覧|screen -ls|
|セッションの削除|screen -r PID|
|セッションのデタッチ|screen -d PID|
|セッションのデタッチ(-dオプションでデタッチ出来ない場合)|ps x &#124; grep pts &#124; grep sshd <br> kill -KILL {PID} <br> # grepが走っていない擬似端末のPIDを切る|
|セッション名をつけてアッタチ|screen -S {セッション名}|
|セッションアタッチ（既にアッタチ済みは無理）|screen -r PID|
|セッション強制アタッチ|screen -d -r PID|
|セッション重複アタッチ|screen -x PID|
|直前のセッションアタッチ|screen -R|
|死んだセッションの削除|screen -wipe|
|セッション一括削除|screen -r -X quit <br> rm -rf /var/run/screen/S-名前/*|
|マニュアル|man screen|

## ウィンドウの操作

|項目|値|
|--- |---|
|ウィンドウ一覧取得|ctrl+a w|
|ウィンドウ作成|ctrl+a c<br>ctrl+a ctrl+a|
|ウィンドウ切り替え選択|ctrl+a "|
|ウィンドウ切り替え|ctrl+a {画面番号}|
|直前のウィンドウ切り替え|ctrl+a ctrl+a|
|昇順にウィンドウの切り替え|ctrl+a space|
|前方のウィンドウの切り替え|ctrl+a n|
|後方のウィンドウの切り替え|ctrl+a p|
|ウィンドウ終了|exit<br>ctrl+D<br>ctrl+a k|
|セッションデタッチ|ctrl+a ctrl+d|
|ウィンドウ全終了|ctrl+a \|
|セッションの停止|ctrl+z|
|ウィンドウの名前変更|ctrl+a + A|
|ウィンドウの初期化|ctrl+a + Z|
|ウィンドウinfo表示|ctrl+a + i|
|ヘルプ|ctrl+a ?|

## コピーモード

|項目|値|
|--- |---|
|コピーモードに入る|ctrl+a [|
|始点|space|
|終点|space|
|コピーモード終了|ctrl+a ]|
|バッファからペースト|ctrl+a ]|
|バッファを|ctrl+a ]|
|ペースト|ctrl+a ]|

## リージョン

|項目|値|
|--- |---|
|リージョンの横分割|ctrl+a S|
|リージョンの縦分割|ctrl+a|
|リージョンの移動|ctrl+a tab|
|現在のリージョンの削除|ctrl+a X|
|リージョンの削除|ctrl+a x|
|リージョンを広げる|ctrl+a +|
|リージョンを狭める|ctrl+a -|
|カレントリージョン以外を一括削除|ctrl+a Q|

## その他

|項目|値|
|--- |---|
|バージョン情報|ctrl+a v|
|時刻情報|ctrl+a v|
|.screenrcの再読み込み|ctrl+a : source $HOME/.screenrc|
