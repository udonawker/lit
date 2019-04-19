ディレクトリ全体
<pre>
# du -sh .
</pre>

ディレクトリ配下
<pre>
# du -sh ./*
</pre>

<pre>
[root .ssh]# du -sh .
16K     .
[root .ssh]# du -sh ./*
8.0K    ./known_hosts
8.0K    ./known_hosts.old
</pre>

おまけ
<pre>
df -Th
</pre>
