### 1. ssh インストール
<pre>
$ sudo apt-get update
$ sudo apt-get install openssh-server
</pre>

### 2. sshd_config編集
<pre>
~$ sudo diff /etc/ssh/sshd_config{,.org}
28,29c28
< #PermitRootLogin without-password
< PermitRootLogin no
---
> PermitRootLogin without-password
</pre>

### 3. ssh 再起動
<pre>
sudo /etc/init.d/ssh restart
</pre>
