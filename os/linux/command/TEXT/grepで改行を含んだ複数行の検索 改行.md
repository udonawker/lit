## [grepで改行を含んだ複数行の検索](https://teratail.com/questions/5as07snjkqdfxn)
```
Web上のgrepシミュレーターでは問題ないのですが、実際にSUSE環境で実施してみるとマッチしません。
どなたか原因がわかる方、もしくは複数行の検索を行う方法をご存じの方いらっしゃらないでしょうか。

・grepコマンド
grep -P BBB[\s\S]*?DDD hoge.txt

・検索対象文字列
AAABBBCCC
DDDEEEFFF
GGGHHHIII

・期待結果
AAABBBCCC
DDDEEEFFF
```

正解<br>
```
$ grep --version
grep (GNU grep) 3.7

$ grep -zPo '(?<=\b).*?BBB(.|\n)*?DDD.*\n' hoge.txt | tr -d '\0'
AAABBBCCC
DDDEEEFFF
```
