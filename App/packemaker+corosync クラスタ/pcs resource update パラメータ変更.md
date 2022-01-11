<pre>
# pcs resource update <リソース名> op start interval=0s on-fail=restart timeout=60s
# pcs resource update <リソース名> op stop interval=0s on-fail=fence timeout=60s

# pcs config show --all
# pcs resource show <リソース名>
</pre>

## [REDHAD 6.6. リソースの動作](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/high_availability_add-on_reference/s1-resourceoperate-haar)
監視オプションの値を変更する場合は、リソースを更新します。たとえば、以下のコマンドで VirtualIP を作成できます。<br>
```
# pcs resource create VirtualIP ocf:heartbeat:IPaddr2 ip=192.168.0.99 cidr_netmask=24 nic=eth2
```

デフォルトでは、次の操作が作成されます。<br>
```
Operations: start interval=0s timeout=20s (VirtualIP-start-timeout-20s)
            stop interval=0s timeout=20s (VirtualIP-stop-timeout-20s)
            monitor interval=10s timeout=20s (VirtualIP-monitor-interval-10s)
```

stop の timeout 操作を変更するには、以下のコマンドを実行します。<br>
```
# pcs resource update VirtualIP op stop interval=0s timeout=40s

# pcs resource show VirtualIP
 Resource: VirtualIP (class=ocf provider=heartbeat type=IPaddr2)
  Attributes: ip=192.168.0.99 cidr_netmask=24 nic=eth2
  Operations: start interval=0s timeout=20s (VirtualIP-start-timeout-20s)
              monitor interval=10s timeout=20s (VirtualIP-monitor-interval-10s)
              stop interval=0s timeout=40s (VirtualIP-name-stop-interval-0s-timeout-40s)
```


注記<br>
pcs resource update コマンドでリソースの操作を更新すると、具体的に呼び出されていないオプションは、デフォルト値にリセットされます。<br>
