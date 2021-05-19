## [Brocade SAN SwitchのDomain ID設定方法](http://xn--u9j0md1592aqmt715c.net/brocade-san-switch-domain-id/) 

## 事前準備
作業用端末からBrocade SAN スイッチにtelnetで接続し、adminでログインします。<br>

---

### Domain ID 設定
#### スイッチをdisableにする
switchdisable コマンドを実行してスイッチをdisableにします。<br>
```
swd77:admin> switchdisable
```

#### Domain IDを設定する
configure コマンドを実行して設定を進めます。ドメインIDだけ設定したら、[ctrl + D]で設定を抜けます。<br>
```
swd77:admin> configure
 
configure...
Fablic parameters(yes, y, no, n):[no]y★yを入力
Domain:(1...239)[1]2★設定したいドメインIDを入力
WWW Based persistent PID (yes, y, no, n):[no]^D ★Ctrl+D で抜ける
```

#### スイッチをenableにする
switchenable コマンドを実行してスイッチをenableにします。<br>
```
swd77:admin> switchenable
```

---

### 設定確認
switchshow コマンドで設定を確認します。<br>
```
swd77:admin> switchshow

～～中略～～

switchDomain: 2 ★設定したドメインIDが表示される
```

