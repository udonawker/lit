[GNU date コマンドで unix time 変換](https://qiita.com/albatross/items/b97df73dcfcedabb070d)<br/>

<pre>
$ date --version | head -n 1
date (GNU coreutils) 8.4
$ date +%s
1404138773
$ date -d @1404138773 +"%Y/%m/%d %T"
2014/06/30 23:32:53
</pre>
