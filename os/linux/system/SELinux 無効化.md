1. SELinuxを一時的に無効にする方法
2. SELinuxを永続的に無効にする方法

# 現状の確認
<pre>
# getenforce
  Enforcing
</pre>

- enforcing ･･･ SELinuxは有効で、アクセス制限も有効。
- permissive ･･･ SELinuxは有効だが、アクセス制限は行わず警告を出力。
- disabled ･･･ SELinux機能は無効。

# 一時的に無効にする
<pre>
# setenforce 0
</pre>

→ 設定が"Permissive"になる。

<pre>
# setenforce 1
</pre>

→ 設定がEnforcingになる。

# 永続的に無効にする
<pre>
# vi /etc/selinux/config
SELINUX=enforcing
</pre>

enforcingをdisabledに変更→リブート
