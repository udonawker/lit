<pre>
[root ~]# pcs resource
agents         clone          debug-start    disable        manage         providers      ungroup
ban            create         debug-stop     enable         master         relocate       unmanage
bundle         debug-demote   defaults       failcount      meta           restart        update
cleanup        debug-monitor  delete         group          move           standards      utilization
clear          debug-promote  describe       list           op             unclone
[root ~]# pcs resource
agents         clone          debug-start    disable        manage         providers      ungroup
ban            create         debug-stop     enable         master         relocate       unmanage
bundle         debug-demote   defaults       failcount      meta           restart        update
cleanup        debug-monitor  delete         group          move           standards      utilization
clear          debug-promote  describe       list           op             unclone
[root ~]# pcs cluster
auth         cib-upgrade  disable      kill         reload       start        sync
cib          corosync     edit         node         report       status       uidgid
cib-push     destroy      enable       pcsd-status  setup        stop         verify
[root ~]# pcs stonith
cleanup   create    describe  enable    level     sbd
confirm   delete    disable   fence     list      update
colocation  location    order       ref         remove      rule        ticket
[root ~]# pcs constraint
colocation  location    order       ref         remove      rule        ticket
set    unset
[root ~]# pcs property
set    unset
[root ~]# pcs status
cluster    corosync   groups     nodes      pcsd       qdevice    quorum     resources  xml
[root ~]# pcs config
backup       checkpoint   export       import-cman  restore
[root ~]# pcs config
</pre>
