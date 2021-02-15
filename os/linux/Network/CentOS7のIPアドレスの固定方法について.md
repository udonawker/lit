# [CentOS7のIPアドレスの固定方法について](https://picasablog.wordpress.com/2014/11/09/centos7%E3%81%AEip%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9%E3%81%AE%E5%9B%BA%E5%AE%9A%E6%96%B9%E6%B3%95%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6/)

## その１　/etc/sysconfig/network-scripts/ifcfg-*ファイルを直接編集

1. NetworkManagerを停止(service NetworkManager stopに相当)
```
# systemctl stop NetworkManager
```

2. NetworkManagerの自動起動を無効化(chkconfig NetworkManager offに相当)
```
# systemctl disable NetworkManager
```

3. /etc/sysconfig/network-scripts/ifcfg-*を編集
```
TYPE="Ethernet"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
NAME="ens3"
UUID="そのまま"
ONBOOT="yes"
HWADDR="そのまま"
IPADDR0="192.168.11.70"
PREFIX0="24"
GATEWAY0="192.168.11.1"
DNS1="8.8.8.8"
IPV6_PEERDNS="yes"
IPV6_PEERROUTES="yes"
```

4. networkを再起動(service network restartに相当)
```
# systemctl restart network
```

これでIPが固定になります<br>

## その２　nmcliコマンドを利用(推奨)

1. コマンドを打ちます。
```
# nmcli connection modify ens3 ipv4.addresses "192.168.11.111/24 192.168.11.1" ipv4.dns 8.8.8.8 ipv4.method manual
 
意味
# nmcli connection modify <NIC名> ipv4.addresses "<IPアドレス/サフィックス ゲートウェイ>" ipv4.dns <DNSIP> ipv4.method <手動>
```

2. NetworkManagerを再起動します
```
# systemctl restart NetworkManager
```

3. IPを確認します
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:7a:09:10 brd ff:ff:ff:ff:ff:ff
    inet 192.168.11.70/24 brd 192.168.11.255 scope global ens3
       valid_lft forever preferred_lft forever
    inet 192.168.11.111/24 brd 192.168.11.255 scope global secondary ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe7a:910/64 scope link 
       valid_lft forever preferred_lft forever
```

ip addrで確認すると固定はできましたが、先にIPが割り振られていたため今追加したIPがsecondaryとなってしまいました。<br>
nmcliコマンドで”先に割り振られているIP”すなわち、DHCP環境下から固定にした際に、または、固定IPから別な固定IPにした際には以前の設定が残ってしまいます。<br>
おそらく、nmcliコマンドにてDHCPを無効にしたり、先のIPを削除するなどできると思いますが、今その部分を勉強中で御座います。<br>
<br>
加えて、NetworkManagerが動いている状態で./etc/sysconfig/network-scripts/ifcfg-を直接編集しNetworkManagerをリスタートすると、編集して固定IPにしたはずのIPがsecondaryとなります。<br>
ifcfg-以外に設定を保存している場所があるためそちらをNetworkManagerは参照しているのだと思われます。<br>
<br>
