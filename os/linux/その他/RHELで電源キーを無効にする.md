## [RHELで電源キー処理を無効にする](https://access.redhat.com/ja/solutions/3170871)

### 1. /etc/systemd/logind.conf から電源キー処理を無効にし、以下の設定を定義します。
```
HandlePowerKey=ignore
```

### 2. systemd 設定をリロードします。
```
# systemctl daemon-reload
```

もしくは、以下のドキュメントで、その他の方法が紹介されています。<br>
[RHEL 7 - 5.12. Configuring ACPI For Use with Integrated Fence Devices](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/High_Availability_Add-On_Reference/s1-acpi-CA.html)<br>
