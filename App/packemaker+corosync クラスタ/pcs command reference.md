引用 
[pcs command reference](http://fibrevillage.com/sysadmin/304-pcs-command-reference "pcs command reference")

**pcs command reference**

pcs is a command line tool to manage pacemaker/cman based High availability cluster, here are some of mostly being used commands

**cluster management**
**Display the configuration in xml style**

<pre>
# pcs cluster cib
</pre>
**Display the current status**
<pre>
# pcs status
</pre>
**Display the current cluster status**
<pre>
# pcs cluster status
</pre>
**Create a cluster**
<pre>
# pcs cluster setup [--start] [--local] --name cluster_ name node1 [node2] [...]
</pre>
**Start the cluster**
<pre>
# pcs cluster start [--all] [node] [...]
</pre>
**Stop the cluster**
<pre>
# pcs cluster stop [--all] [node] [...]
</pre>
**Forcebly stop cluster service on a node**
<pre>
# pcs cluster kill
</pre>
**Enable cluster service on node[s]**
<pre>
# pcs cluster enable [--all] [node] [...]
</pre>
**Disable cluster service on node[s]**
<pre>
# pcs cluster disable [--all] [node] [...]
</pre>
**Put node in standby**
<pre>
# pcs cluster standby pcmk-1
</pre>
**Remove node from standby**
<pre>
# pcs cluster unstandby pcmk-1
</pre>
**Set cluster property**
<pre>
# pcs property set stonith-enabled=false
</pre>
**Destroy/remove cluster configuration on a node**
<pre>
# pcs cluster destroy [--all] 
</pre>
**Cluster node authentication**
<pre>
# pcs cluster auth [node] [...]
</pre>
**Add a node to cluster**
<pre>
# pcs cluster node add [node]
</pre>
**Remove a node to cluster**
<pre>
# pcs cluster node remove [node]
</pre>
**Resource manipulation**
**List Resource Agent (RA) classes**
<pre>
# pcs resource standards
</pre>
**List available RAs**
<pre>
# pcs resource agents ocf
# pcs resource agents lsb
# pcs resource agents service
# pcs resource agents stonith
# pcs resource agents
</pre>
**Filter by provider**
<pre>
# pcs resource agents ocf:pacemaker
</pre>
**List RA info**
<pre>
# pcs resource describe RA
# pcs resource describe ocf:heartbeat:RA
</pre>
**Create a resource**
<pre>
 params ip=192.168.122.120 cidr_netmask=32 op monitor interval=30s
# pcs resource create ClusterIP IPaddr2 ip=192.168.0.120 cidr_netmask=32

The standard and provider (ocf:heartbeat) are determined automatically since IPaddr2 is unique. The monitor operation is automatically created based on the agent's metadata.
</pre>
**Delete a resource**
<pre>
# pcs resource delete resourceid
</pre>
**Display a resource**
<pre>
# pcs resource show
# pcs resource show ClusterIP
</pre>
**Display fencing resources**
<pre>
# pcs stonith show
</pre>
pcs treats STONITH devices separately.

**Display Stonith RA info**
<pre>
# pcs stonith describe fence_ipmilan
</pre>
**Start a resource**
<pre>
# pcs resource enable ClusterIP
</pre>
**Stop a resource**
<pre>
# pcs resource disable ClusterIP
</pre>
**Remove a resource**
<pre>
# pcs resource delete ClusterIP
</pre>
**Modify a resource**
<pre>
# pcs resource update ClusterIP clusterip_hash=sourceip
</pre>
**Delete parameters for a given resource**
<pre>
# pcs resource update ClusterIP ip=192.168.0.98
</pre>
**List the current resource defaults**
<pre>
# pcs resource rsc default
</pre>
**Set resource defaults**
<pre>
# pcs resource rsc defaults resource-stickiness=100
</pre>
**List the current operation defaults**
<pre>
# pcs resource op defaults
</pre>
**Set operation defaults**
<pre>
# pcs resource op defaults timeout=240s
</pre>
**Set Colocation**
<pre>
# pcs constraint colocation add ClusterIP with WebSite INFINITY
</pre>
**With roles**
<pre>
# pcs constraint colocation add Started AnotherIP with Master WebSite INFINITY
</pre>
**Set ordering**
<pre>
# pcs constraint order ClusterIP then WebSite
</pre>
**With roles:**
<pre>
# pcs constraint order promote WebSite then start AnotherIP
</pre>
**Set preferred location**
<pre>
# pcs constraint location WebSite prefers pcmk-1=50
</pre>
**With roles:**
<pre>
# pcs constraint location WebSite rule role=master 50 \#uname eq pcmk-1
</pre>
**Move resources**
<pre>
# pcs resource move WebSite pcmk-1
# pcs resource clear WebSite
</pre>
**A resource can also be moved away from a given node:**
<pre>
# pcs resource ban Website pcmk-2
</pre>
Moving a resource sets a stickyness to -INF to a given node until unmoved
Also, pcs deals with constraints differently. These can be manipulated by the command above as well as the following and others
<pre>
# pcs constraint list --full
# pcs constraint remove cli-ban-Website-on-pcmk-1
</pre>
**Set a resource failure threshold**
<pre>
# pcs resource meta RA migration-threshold=3
</pre>
**Move default resource failure threshold**
<pre>
# pcs resource meta default migration-threshold=3
</pre>
**Show a resource failure count**
<pre>
# pcs resource failcount show RA
</pre>
**Reset a resource failure count**
<pre>
# pcs resource failcount reset RA
</pre>
**Create a clone**
<pre>
# pcs resource clone ClusterIP globally-unique=true clone-max=2 clone-node-max=2
</pre>
**Create a master/slave clone**
<pre>
meta master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
</pre>
<pre>
# resource master WebDataClone WebData master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
</pre>
**To manage a resource**
<pre>
# pcs resource manage RA
</pre>
**To UNmanage a resource**
<pre>
# pcs resource unmanage RA
**STONITH**
</pre>
**List available resource agents**
<pre>
#pcs stonith list
</pre>
**Add a filter to List available resource agents**
<pre>
#pcs stonith list <string>
</pre>
**Setup properties for STONITH**
<pre>
# pcs property set no-quorum-policy=ignore
# pcs property set stonith-action=poweroff     # default is reboot
</pre>
**Create a fencing device**
<pre>
#pcs stonith create stonith-rsa-nodeA fence_rsa action=off ipaddr="nodeA_rsa" login=<user> passwd=<pass> pcmk_host_list=nodeA secure=true
</pre>
**Display fencing devices**
<pre>
#pcs stonith show
</pre>
**Fence a node off**
<pre>
#pcs stonith fence <node>
</pre>
**Modify a fencing device**
<pre>
#pcs stonith update stonithid [options]
</pre>
**Display a fencing device options**
<pre>
#pcs stonith describe <stonith_ra>
</pre>
**Deleting a fencing device**
<pre>
#pcs stonith delete stonithid
</pre>
**Config a fencing device level**
<pre>
pcs stonith level add level node devices
</pre>
**Other operations**
**Batch changes**
<pre>
# pcs cluster cib drbd_cfg
# pcs -f drbd_cfg resource create WebData ocf:linbit:drbd drbd_resource=wwwdata \
        op monitor interval=60s
# pcs -f drbd_cfg resource master WebDataClone WebData master-max=1 master-node-max=1 \
        clone-max=2 clone-node-max=1 notify=true
# pcs cluster push cib drbd_cfg
</pre>

