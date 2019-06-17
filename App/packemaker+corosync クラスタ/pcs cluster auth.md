<pre>
pcs cluster auth [node1] [node2] -u hacluster -p [password]
</pre>

削除時は以下
<pre>
⇒ /var/lib/pcsd
pcs_settings.conf
pcs_users.conf
tokens
</pre>

<pre>
pcs cluster setup --name [クラスタ名] [node1] [node2]
⇒ /etc/corosync/corosync.conf

pcs cluster destroy
すると
/etc/corosync/corosync.confも消える
</pre>
