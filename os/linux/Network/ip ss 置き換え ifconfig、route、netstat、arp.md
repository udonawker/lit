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
<br />
・特定デバイスの状態確認
<pre>
# ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.122.70  netmask 255.255.255.0  broadcast 192.168.122.255
        inet6 fe80::5054:ff:fe41:c632  prefixlen 64  scopeid 0x20<link>
        ether 52:54:00:41:c6:32  txqueuelen 1000  (Ethernet)
        RX packets 1539  bytes 2117655 (2.0 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 194  bytes 28160 (27.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0<br />
# ip a show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:41:c6:32 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.70/24 brd 192.168.122.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe41:c632/64 scope link 
       valid_lft forever preferred_lft forever
</pre>
<br />
・デバイスのup/down
<pre>
# ifconfig eth1 up
# ifconfig eth1 down<br/>
# ip l set eth1 up
# ip l set eth1 down<br/>
# nmcli c down eth1
# nmcli c up eth1
</pre>
ここで指定する「eth1」はデバイス名ではなくて、先に指定した「接続名」ですので、ご注意下さい。デバイスに対するIPアドレスなどの割り当てもnmcliでやるのがよいでしょう。
<br/>
・ルーティングテーブルの確認
<pre>
# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.122.1   0.0.0.0         UG    1024   0        0 eth0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 eth0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 eth1<br/>
# ip r
default via 192.168.122.1 dev eth0  proto static  metric 1024 
192.168.122.0/24 dev eth0  proto kernel  scope link  src 192.168.122.70 
192.168.122.0/24 dev eth1  proto kernel  scope link  src 192.168.122.69 
</pre>
<br/>
・デフォルトゲートウェイの追加、削除
<pre>
# route add default gw 192.168.122.1
# route del default gw 192.168.122.1<br/>
# ip route add default via 192.168.122.1
# ip route del default via 192.168.122.1
</pre>
<br/>
・デバイスごとのパケット処理数
<pre>
# netstat -i
Kernel Interface table
Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0      1500     6375      0      0 0          1723      0      0      0 BMRU
eth1      1500     2095      0      0 0           126      0      0      0 BMRU
lo       65536     1040      0      0 0          1040      0      0      0 LRU<br/>
# ip -s l
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast   
    82260      1040     0       0       0       0      
    TX: bytes  packets  errors  dropped carrier collsns 
    82260      1040     0       0       0       0      
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether 52:54:00:41:c6:32 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    3861081    6396     0       0       0       0      
    TX: bytes  packets  errors  dropped carrier collsns 
    237222     1733     0       0       0       0      
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether 52:54:00:a2:e8:73 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    1478655    2098     0       0       0       0      
    TX: bytes  packets  errors  dropped carrier collsns 
    20043      126      0       0       0       0  
</pre>
<br/>
・TCPソケットの状態確認
<pre>
# netstat -nat
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 192.168.122.70:22       192.168.122.1:34328     ESTABLISHED
tcp6       0      0 ::1:25                  :::*                    LISTEN     
tcp6       0      0 :::80                   :::*                    LISTEN     
tcp6       0      0 :::22                   :::*                    LISTEN     <br/>
# ss -nat
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      100               127.0.0.1:25                       *:*     
LISTEN     0      128                       *:22                       *:*     
ESTAB      0      0            192.168.122.70:22           192.168.122.1:34328 
LISTEN     0      100                     ::1:25                      :::*     
LISTEN     0      128                      :::80                      :::*     
LISTEN     0      128                      :::22                      :::*  
</pre>
<br/>
・UDPソケットの状態確認
<pre>
# netstat -nau
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
udp        0      0 0.0.0.0:123             0.0.0.0:*                          
udp        0      0 0.0.0.0:53481           0.0.0.0:*                          
udp        0      0 0.0.0.0:5353            0.0.0.0:*                          
udp        0      0 127.0.0.1:323           0.0.0.0:*                          
udp6       0      0 :::123                  :::*                               
udp6       0      0 ::1:323                 :::*                               <br/>
# ss -nau
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
UNCONN     0      0                         *:123                      *:*     
UNCONN     0      0                         *:53481                    *:*     
UNCONN     0      0                         *:5353                     *:*     
UNCONN     0      0                 127.0.0.1:323                      *:*     
UNCONN     0      0                        :::123                     :::*     
UNCONN     0      0                       ::1:323                     :::*  
</pre>
<br/>
・ARPテーブルの確認
<pre>
# arp -n
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.122.71           ether   52:54:00:a5:2c:75   C                     eth0
192.168.122.1            ether   02:13:97:c1:47:ec   C                     eth0<br/>
# ip n
192.168.122.71 dev eth0 lladdr 52:54:00:a5:2c:75 REACHABLE
192.168.122.1 dev eth0 lladdr 02:13:97:c1:47:ec REACHABLE
</pre>
<br/>
・ARPテーブルの無効化
<pre>
# arp -d 192.168.122.71 -i eth0<br/>
# ip n flush 192.168.122.71 dev eth0
# ip n del 192.168.122.71 dev eth0　（←エントリーを削除）
</pre>
