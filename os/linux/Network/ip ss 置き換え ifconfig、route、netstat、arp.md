引用 
 [RHEL7/CentOS7でipコマンドをマスター](http://enakai00.hatenablog.com/entry/20140712/1405139841 "RHEL7/CentOS7でipコマンドをマスター")

対比  

|net-tools | iproute2             |
|---       |---                   |
|ifconfig  |ip a(addr), ip l(link)|
|route     |ip r(route)           |
|netstat   |ss                    |
|netstat -i|ip -s l(link)         |
|arp       |ip n(neighbor)        |
