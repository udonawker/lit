## /etc/ssh/sshd_config 編集

PasswordAuthentication no → yes に編集<br/>

## sudo passwd

rootのパスワード変更 → ******<br/>

※
passwd: Authentication token manipulation error エラーが出た場合は`pwconv`を実施する。<br/>


## ssh 自動起動

<pre>
#!/bin/bash

service ssh start
</pre>
を自分で実行するか

~/.bashrcに
<pre>
# mysql
retval=$(service ssh status >/dev/null 2>&1; echo $?)
if [ ! $retval == "0" ]; then
  echo "start ssh"
  service ssh start
fi
</pre>
