## [Brocade SAN Switchのゾーニング設定方法](http://xn--u9j0md1592aqmt715c.net/brocade-san-switch-zone-create/)

### 事前準備
作業用端末からBrocade SAN スイッチにtelnetで接続し、adminでログインします<br>

---

### エイリアスの作成
エイリアスを作成します<br>

ポートの場合<br>
```
swd77:admin> alicreate "alias名","Domain ID,ポート番号"
swd77:admin> alicreate "Server01","1,1"
```

WWWNの場合<br>
```
swd77:admin> alicreate "alias名","WWN"
swd77:admin> alicreate "Server01","00:00:00:00:00:00:00:00"
```

---

### Zoneの作成
ゾーンを作成します<br>

エイリアス名で作成する場合<br>
```
swd77:admin> zonecreate "Zone名","alias名;alias名"
swd77:admin> zonecreate "Zone1","Server1;Server2"
```

ポート番号で作成する場合<br>
```
swd77:admin> zonecreate "Zone名","Domain ID,ポート番号;Domain ID,ポート番号"
swd77:admin> zonecreate "Zone1","1,1;1,2"
```

WWNで作成する場合<br>
```
swd77:admin> zonecreate "Zone名","WWN;WWN"
swd77:admin> zonecreate "Zone1","00:00:00:00:00:00:00:00;11:11:11:11:11:11:11:11"

```

---

### Zoneの確認
`zoneshow`コマンドで確認できます。<br>
```
swd77:admin> zoneshow
```

---

### ZoneConfigを作成
ゾーンコンフィグを作成します。<br>
```
swd77:admin> cfgcreate "ZoneConfig名","Zone名"
swd77:admin> cfgcreate "ZoneConfig1","Zone1"
```

複数のゾーンが存在する場合は、ゾーンコンフィグに追加します。<br>
```
swd77:admin> cfgadd "ZoneConfig名","Zone名"
swd77:admin> cfgadd "ZoneConfig1","Zone2"
```

---

### ZoneConfigの確認
`cfgshow`コマンドでコンフィグの内容を確認できます。<br>
```
	
swd77:admin> cfgshow
```

---

### ZoneConfigを有効化
ゾーンコンフィグを有効化します。<br>
```
swd77:admin> cfgenable "ZoneConfig名"
swd77:admin> cfgenable "Zoneconfig1"
```

---

### 設定の保存
設定を保存します。<br>
```
swd77:admin> cfgsave
```
