<pre>
find . -type f -name '*.log' | wc -l
find . -type f -name '*.log' -daystart -mtime +2 | xargs ls -l
find . -type f -name '*.log' -daystart -mtime +2 | xargs rm -f
</pre>
