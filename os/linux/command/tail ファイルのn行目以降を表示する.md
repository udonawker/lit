引用 
 [ファイルのn行目以降を表示する](https://qiita.com/sugyan/items/523ed9417678fbdbae53 "ファイルのn行目以降を表示する")
<br/><br/>

**-n**オプションに対する値に+を使う
<br/>
<pre>
$ cat lines.txt
line_1
line_2
line_3
line_4
line_5
line_6
line_7
line_8
line_9
$ tail -n 3 lines.txt
line_7
line_8
line_9
$ tail -n +3 lines.txt
line_3
line_4
line_5
line_6
line_7
line_8
line_9
</pre>
