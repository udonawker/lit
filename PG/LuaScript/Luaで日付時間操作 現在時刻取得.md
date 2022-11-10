## [Luaで日付時間操作。](http://noriko3.blog42.fc2.com/blog-entry-128.html)

lua で日付をごにょごにょするのは、os.date() です。<br>
```
$ lua -e 'print(os.date())'
Wed Nov 5 14:34:06 2008
```

<br>

引数なしで呼ぶと、今の日時が表示されます。<br>
```
$ lua -e 'print(os.date("*t"))'
table: 0x962fdd0
```

<br>

第一引数はフォーマット。 *t というのを指定すると、year , month などが入ったテーブルが返ります。<br>
```
$ lua -e 'for k,v in pairs(os.date("*t")) do print(k) end'
hour
min
wday
day
month
year
sec
yday
isdst
```

<br>

年だけさくっと取得したい場合は<br>
```
$ lua -e 'print(os.date("*t").year)'
2008
```

<br>

こんな感じでできちゃいます。<br>
```
$ lua -e 'print(os.date("%Y"))'
2008
```

<br>

これでもいいですが。フォーマットは、unix コマンドの、date と同じっぽいです。man date してみると、<br>
```
時刻フィールド
%H 時 (00..23)
%I 時 (01..12)
%k 時 (0..23)
%l 時 (1..12)
%M 分 (00..59)
%p AM あるいは PM のロケール
%r 時刻、12 時間 (hh:mm:ss [AP]M)
%s 1970-01-01 00:00:00 UTC からの秒数 (標準外の拡張)
%S 秒 (00..60)
%T 時刻、24 時間 (hh:mm:ss)
%X ロケールによる時刻の表現 (%H:%M:%S)
%Z タイムゾーン (例 EDT)、あるいはタイムゾーンが決定できないならば無し

日付フィールド
%a ロケールの省略形の曜日名 (Sun..Sat)
%A ロケールの完全表記の曜日名、可変長 (Sunday..Saturday)
%b ロケールの省略形の月名 (Jan..Dec)
%B ロケールの完全表記の月名、可変長 (January..December)
%c ロケールの日付と時刻 (Sat Nov 04 12:02:33 EST 1989)
%d 月内通算日数 (01..31)
%D 日付 (mm/dd/yy)
%h %b と同じ
%j 年内通算日数 (001..366)
%m 月 (01..12)
%U 日曜日を週の最初の日とした年内通算週 (00..53)
%w 週のうちの曜日 (0..6) (0 が日曜日)
%W 月曜日を週の最初の日とした年内通算週 (00..53)
%x ロケールの日付表現 (mm/dd/yy)
%y 年の最後の 2 つの数字 (00..99)
%Y 年 (1970...)

文字フィールド
%% 文字 %
%n 改行
%t 水平タブ
```
とあるので、参考にしてください。<br>

<br>

第二引数は、変換したいunix timeをいれます。デフォルトでは、今です。<br>
```
$ lua -e 'print(os.date(nil,0))'
Thu Jan 1 09:00:00 1970
```

<br>

フォーマットを指定したくない場合は、nil を入れてあげるとよいようです。<br>
```
$ lua -e 'print(os.date(nil,-100000))'
Wed Dec 31 05:13:20 1969
```
