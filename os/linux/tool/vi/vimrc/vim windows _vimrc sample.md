## Windows $HOME\_vimrc sample
<pre>
set compatible
set encoding=utf8
set ambiwidth=double
set fileencodings=iso-2022-jp,utf8,euc-jp,cp932
set guifont=ＭＳ_ゴシック:h8:cSHIFTJIS
set guioptions-=m
set guioptions-=T
set iminsert=0
set imsearch=0
set directory=.,C:\Windows\Temp
</pre>

|設定|説明|
|:--|:--|
|echo set compatible|オリジナルのviエディタと互換性のある動作をする|
|echo set encoding=utf8|新規ファイルを保存する場合に文字エンコーディングをUTF-8とする|
|echo set fileencodings=iso-2022-jp,utf8,euc-jp,cp932|文字エンコーディングとして、JIS・UTF-8・日本語EUC・シフトJISを扱えるようにする|
|echo set ambiwidth=double|全角記号を英数字2文字分の幅で表示する|
|echo set guifont=ＭＳ_ゴシック:h8:cSHIFTJIS|表示用フォントを"MSゴシック"の8ポイントに指定する|
|echo set guioptions-=m|メニューバーを表示しないようにする|
|echo set guioptions-=T|ツールバーを表示しないようにする|
|echo set iminsert=0|入力時に日本語入力(IM)が自動的にオンにならないようにする|
|echo set imsearch=0|検索時に日本語入力(IM)が自動的にオンにならないようにする|
|echo set directory=.,C:\Windows\Temp|作業用フォルダを指定する|
