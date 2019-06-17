<pre>
[root ~]# pcs status corosync

Membership information
----------------------
    Nodeid      Votes Name
         1          1 [node1] (local)
         2          1 [node2]
</pre>

<pre>
[root ~]# pcs cluster corosync
totem {
    version: 2
    cluster_name: [クラスタ名]
    secauth: off
    transport: udpu
    token: 1200
}

nodelist {
    node {
        ring0_addr: [node1]
        nodeid: 1
    }

    node {
        ring0_addr: [node2]
        nodeid: 2
    }
}

quorum {
    provider: corosync_votequorum
    two_node: 1
}

logging {
    to_logfile: yes
    logfile: /var/log/cluster/corosync.log
    to_syslog: yes
}
</pre>
/etc/corosync/corosync.confが表示される？
