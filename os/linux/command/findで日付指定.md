[findで日付指定](https://iww.hateblo.jp/entry/20140930/find)<br>

findで日付指定して検索する際、 ▲日前ではなく、★月▼日を指定したい<br>
2014-09-25 00:00:00 から 2014-09-25 23:59:59 までのファイルを検索<br>

### ★月▼日が何日前かを計算して指定する
<pre>
STARTTIME=$(( (`date +%s`-`date --date='2014-09-25' +%s`)/86400 +1 ))
ENDTIME=$(( (`date +%s`-`date --date='2014-09-26' +%s`)/86400 -1 ))

find ./ -daystart -mtime -$STARTTIME -and -mtime +$ENDTIME
</pre>

### newermtオプションを使用する
<pre>
find ./ -newermt '2014-09-25' -and ! -newermt '2014-09-26'
</pre>

### 仮ファイルを二つ指定する
<pre>
touch start.txt -m -d "2014-09-24 23:59:59.9999"
touch end.txt -m -d "2014-09-25 23:59:59.9999"

find ./ -newer start.txt -and ! -newer end.txt
</pre>
