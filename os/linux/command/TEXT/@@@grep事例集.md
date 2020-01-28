<pre>
text:
01-23 04:56:32.992  ----  ---- AAA
                               |31
grep:
grep '[-. :0-9]\{31\}AAA'
</pre>

<pre>
text:
LAST_MODIFIED="1578644898"

grep:
grep -o 'LAST_MODIFIED="[0-9]\{10\}"'
## -o はmatch部分のみ表示
</pre>
