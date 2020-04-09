## インストール
<pre>
# redhat
$ sudo yum install sysstat
# ubuntu
$ sudo apt-get install sysstat
</pre>

## 有効化
<pre>
# redhat
$ sudo systemctl start sysstat
# ubuntu
# /etc/default/sysstat
# ENABLED="true" とする
</pre>

## ファイル
<pre>
# redhat
/var/log/sa
# ubuntu
/var/log/sysstat
</pre>
