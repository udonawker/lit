<pre>
ps aux | grep [プロセス名] | grep -v grep | awk '{ print "kill -9", $2 }' | sh
</pre>
