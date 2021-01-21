<pre>
while sleep 1; do ps -Af | grep http | wc -l ; done
while sleep 1; do : ; done
while sleep 10; do (date; df . | sed -n 2P) ; done
# 60秒ごとに df
while sleep 60; do (date +"%Y%m%d_%H:%M:%S"; df -BM . | sed -n 2P) ; done
</pre>
