## [ipコマンド](https://linuc.org/study/samples/2201/)

「ip」コマンドは、ネットワークデバイスやルーティング、ポリシーなどの表示と変更を行うコマンドになります。<br>
ipコマンドの構文は以下の通りです。<br>

<pre>
$ ip (オプション) オブジェクト [サブコマンド]
</pre>

オブジェクトは省略することはできませんが、短縮表記をすることができます。サブコマンドも同様に短縮表記ができます。例えばオブジェクトの「address」は、最小の省略が「a」であり、「addr」や「ad」といった省略も可能です。<br>
サブコマンドを省略すると、「show」というサブコマンドが実行されます。<br>

代表的なオブジェクトは以下の通りです。<br>

* ip address
ネットワークインタフェースに設定されているIPアドレスを表示したり、ネットワークインタフェースにIPアドレスを設定したりすることができます。<br>
表示結果は下記のようになります。<br>

<pre>
$ ip address show
1: lo: &lt;LOOPBACK,UP,LOWER_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens3: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 06:b4:e0:00:00:d4 brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.111/16 brd 10.1.255.255 scope global noprefixroute ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::d9c8:51f:1d16:43c0/64 scope link dadfailed tentative noprefixroute
       valid_lft forever preferred_lft forever
</pre>
<br>

* ip route
ルーティングテーブルの内容を表示します。また、デフォルトルートやスタティックルートを変更することができます。<br>
表示結果は下記のようになります。<br>

<pre>
$ ip route show
default via 10.1.0.1 dev ens3 proto dhcp metric 100
10.1.0.0/16 dev ens3 proto kernel scope link src 10.1.1.111 metric 100
</pre>
<br>

* ip link
ネットワークデバイスの現在の設定を表示します。また、ネットワークデバイスの状態をUPまたはDOWNに変更することができます。<br>
表示結果は下記のようになります。<br>

<pre>
$ ip link show
1: lo: &lt;LOOPBACK,UP,LOWER_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens3: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 06:b4:e0:00:00:d4 brd ff:ff:ff:ff:ff:ff
</pre>
<br>

オプションには下記のようなものがあります。<br>

* -s
情報をより詳しく表示します。例えば下記のように「ip -s link」を実行するとネットワークデバイス毎のパケット数などを表示します。<br>

<pre>
$ ip -s link show
1: lo: &lt;LOOPBACK,UP,LOWER_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast
    266389346  696328   0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    266389346  696328   0       0       0       0
</pre>
<br>

* -o
デバイス毎の出力を1行にします。例えば「ip -o addrress」を実行すると、改行が"\"に置き換えられ下記のようになります。<br>

<pre>
$ ip -o address show
1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever
1: lo    inet6 ::1/128 scope host \       valid_lft forever preferred_lft forever
2: ens3    inet 10.1.1.111/16 brd 10.1.255.255 scope global noprefixroute ens3\       valid_lft forever preferred_lft forever
2: ens3    inet6 fe80::d9c8:51f:1d16:43c0/64 scope link dadfailed tentative noprefixroute \       valid_lft forever preferred_lft forever
</pre>
<br>

最後にサブコマンドについて説明します。<br>

それぞれのオブジェクトにサブコマンドを使用することで、設定の変更等が可能になります。addressオブジェクトの代表的なサブコマンドは下記のとおりです。<br>

* add
例えば下記のように使用することで、指定のデバイスにipアドレスを追加することができます。<br>

<pre>
# ip address add IPアドレス dev デバイス名
</pre>
<br>

* del
こちらはaddの反対で、指定のデバイスからipアドレスを削除することができます。<br>

<pre>
# ip delete del IPアドレス dev デバイス名
</pre>
<br>

* help
オブジェクトの使用方法を表示します。下記のように表示されます。<br>

<pre>
$ ip addr help
Usage: ip address {add|change|replace} IFADDR dev IFNAME [ LIFETIME ]
                                                      [ CONFFLAG-LIST ]
       ip address del IFADDR dev IFNAME [mngtmpaddr]
       ip address {save|flush} [ dev IFNAME ] [ scope SCOPE-ID ]
                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]
       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]
                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]
                         [ label LABEL ] [up] [ vrf NAME ] ]
       ip address {showdump|restore}
　　　　　　　　　　　　　　　（以下省略）
</pre>
