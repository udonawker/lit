このとき-dオプションを付けることで実際にlogrotateは行われずに、どのように動作するのかをデバッグすることができます。
https://qiita.com/zom/items/c72c7bac63462225971b
<pre>
$ /usr/sbin/logrotate -d /tmp/log/logrotate.conf
reading config file /tmp/log/logrotate.conf
reading config info for /tmp/log/httpd/access_log

Handling 1 logs

rotating pattern: /tmp/log/httpd/access_log  1048576 bytes (no old logs will be kept)
empty log files are rotated, old logs are removed
considering log /tmp/log/httpd/access_log
  log needs rotating
rotating log /tmp/log/httpd/access_log, log->rotateCount is 0
dateext suffix '-20161203'
glob pattern '-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
renaming /tmp/log/httpd/access_log.1 to /tmp/log/httpd/access_log.2 (rotatecount 1, logstart 1, i 1),
renaming /tmp/log/httpd/access_log.0 to /tmp/log/httpd/access_log.1 (rotatecount 1, logstart 1, i 0),
renaming /tmp/log/httpd/access_log to /tmp/log/httpd/access_log.1
disposeName will be /tmp/log/httpd/access_log.1
removing old log /tmp/log/httpd/access_log.1
error: error opening /tmp/log/httpd/access_log.1: そのようなファイルやディレクトリはありません
</pre>
