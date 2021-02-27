## [sedみたいに使えるバイナリ置換用のコマンド『bbe』](https://orebibou.com/ja/home/202010/20201014_001/)

### 1. インストール
```
# MacOSの場合
brew install bbe

# aptの場合
sudo apt install bbe

# pacman
sudo pacman -S bbe
```

### 2. 使い方
```
$ # `quick`から数えて21byte先までを対象に、` `を`X`に置換(また、このとき最初の4バイトはスキップする(`j 4`))
$ echo "The quick brown fox jumps over a lazy dog" | bbe -b "/quick/:21" -e "j 4" -e "s/ /X/"
The quickXbrownXfoxXjumps over a lazy dog
$
$ # スペースの後ろに改行を追加する(また、このとき最初から2個はスキップする)
$ echo "The quick brown fox jumps over a lazy dog" | bbe -b ":/ /" -e "J 2" -e "A \x0a"
The quick brown
fox
jumps
over
a
lazy
dog

$ # `Linux`というワードが含まれているバイナリをリスト表示(バイナリ用のgrepみたいなものかな)
$ bbe -b "/Linux/:5" -s -e "N;D;A \x0a" $(find /bin/ -type f)
/bin/grub-mkrescue:
/bin/dirmngr:
/bin/x86_64-linux-gnu-readelf:
/bin/x86_64-linux-gnu-readelf:
/bin/x86_64-linux-gnu-readelf:
(snip...)

$ # 各byteの間に3回だけ`-`を追加
$ echo "1234567890" | bbe -b ":1" -e "L 3" -e "A -"
1-2-3-4567890
```

その他のサンプルは[こちら](http://bbe-.sourceforge.net/bbe.html#bbe-programs)を参考にしてほしい。<br>
ぱっと触った感じ、-bでの指定や対象のスキップを指定できるのが特徴的な感じ。 バイナリ向けということだったけど、普通にテキスト置換でも便利に使えそうな感じだ。<br>
sedでもs/\x00/\x01/みたいにすれば置換自体は可能だけど、無理しないでこういうコマンド使ったほうが良いのかもしれない。<br>
