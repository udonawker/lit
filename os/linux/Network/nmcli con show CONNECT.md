<pre>
# nmcli con show CONNECT

connection.id:                          teamXXX.<VLAN-ID>
connection.uuid:                        xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx
connection.stable-id:                   --
connection.type:                        vlan
connection.interface-name:              teamXXX.<VLAN-ID>
connection.autoconnect:                 はい
connection.autoconnect-priority:        0
connection.autoconnect-retries:         -1 (default)
connection.auth-retries:                -1
connection.timestamp:                   1559546686
connection.read-only:                   いいえ
connection.permissions:                 --
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 --
connection.gateway-ping-timeout:        0
connection.metered:                     不明
connection.lldp:                        default
802-3-ethernet.port:                    --
802-3-ethernet.speed:                   0
802-3-ethernet.duplex:                  --
802-3-ethernet.auto-negotiate:          いいえ
802-3-ethernet.mac-address:             --
802-3-ethernet.cloned-mac-address:      --
802-3-ethernet.generate-mac-address-mask:--
802-3-ethernet.mac-address-blacklist:   --
802-3-ethernet.mtu:                     自動
802-3-ethernet.s390-subchannels:        --
802-3-ethernet.s390-nettype:            --
802-3-ethernet.s390-options:            --
802-3-ethernet.wake-on-lan:             default
802-3-ethernet.wake-on-lan-password:    --
ipv4.method:                            manual
ipv4.dns:                               --
ipv4.dns-search:                        --
ipv4.dns-options:                       ""
ipv4.dns-priority:                      0
ipv4.addresses:                         xxx.xxx.xxx.xxx/24
ipv4.gateway:                           xxx.xxx.xxx.xxx
ipv4.routes:                            --
ipv4.route-metric:                      -1
ipv4.route-table:                       0 (unspec)
ipv4.ignore-auto-routes:                いいえ
ipv4.ignore-auto-dns:                   いいえ
ipv4.dhcp-client-id:                    --
ipv4.dhcp-timeout:                      0 (default)
ipv4.dhcp-send-hostname:                はい
ipv4.dhcp-hostname:                     --
ipv4.dhcp-fqdn:                         --
ipv4.never-default:                     いいえ
ipv4.may-fail:                          いいえ
ipv4.dad-timeout:                       -1 (default)
ipv6.method:                            ignore
ipv6.dns:                               --
ipv6.dns-search:                        --
ipv6.dns-options:                       ""
ipv6.dns-priority:                      0
ipv6.addresses:                         --
ipv6.gateway:                           --
ipv6.routes:                            --
ipv6.route-metric:                      -1
ipv6.route-table:                       0 (unspec)
ipv6.ignore-auto-routes:                いいえ
ipv6.ignore-auto-dns:                   いいえ
ipv6.never-default:                     いいえ
ipv6.may-fail:                          はい
ipv6.ip6-privacy:                       -1 (不明)
ipv6.addr-gen-mode:                     stable-privacy
ipv6.dhcp-send-hostname:                はい
ipv6.dhcp-hostname:                     --
ipv6.token:                             --
vlan.parent:                            teamXXX
vlan.id:                                <VLAN-ID>
vlan.flags:                             1 (ヘッダーの順序変更<E3>)
vlan.ingress-priority-map:              --
vlan.egress-priority-map:               --
proxy.method:                           none
proxy.browser-only:                     いいえ
proxy.pac-url:                          --
proxy.pac-script:                       --
GENERAL.NAME:                           teamXXX.<VLAN-ID>
GENERAL.UUID:                           xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx
GENERAL.DEVICES:                        teamXXX.<VLAN-ID>
GENERAL.STATE:                          アクティベート済み
GENERAL.DEFAULT:                        はい
GENERAL.DEFAULT6:                       いいえ
GENERAL.SPEC-OBJECT:                    --
GENERAL.VPN:                            いいえ
GENERAL.DBUS-PATH:                      /org/freedesktop/NetworkManager/ActiveConnection/9
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/Settings/9
GENERAL.ZONE:                           --
GENERAL.MASTER-PATH:                    --
IP4.ADDRESS[1]:                         xxx.xxx.xxx.xxx/24
IP4.GATEWAY:                            xxx.xxx.xxx.xxx
IP4.ROUTE[1]:                           dst = xxx.xxx.xxx.xxx/24, nh = 0.0.0.0, mt = 400
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = xxx.xxx.xxx.xxx, mt = 400
</pre>
