## [Pacemaker/Heartbeat で良く使うクラスタ操作コマンド](https://ngyuki.hatenablog.com/entry/20110511/p1)

### クラスタ情報の表示
```
crm_mon -1

# ノードでグループ化
crm_mon -1n

# フェイルカウントも表示
crm_mon -1f
```

### ノード一覧の表示
```
crmadmin -N
crm node list
crm node status
```

### リソース一覧の表示
```
crm_resource -L
```

### リソースの位置を表示
```
crm_resource -WQ -r <resource>
```

### スタンバイの設定（ローカルホストに対して）
```
# スタンバイにする
crm_standby -v on

# スタンバイから復帰
crm_standby -D
```

### リソースのフェイルカウントのクリア
```
crm_failcount -D -r <rsc>
crm resource failcount <rsc> delete <node>
```

### リソースのクリーンアップ ※フェイルカウントと故障履歴をクリア
```
crm_resource -C -r <resource>
crm resource cleanup <resource> [<node>]
```

### メンテナンスモードのON/OFF
すべてのリソースが unmanaged になって start/stop/monitor が行なわれなくなります<br>
```
crm configure property maintenance-mode=true
crm configure property maintenance-mode=false
```

### cib.xml の表示
```
cibadmin --query
```

### cib を xpath で抽出
```
cibadmin --query --xpath "//crm_config"
```

### リソースやグループやノードのスコアを見る
```
ptest -s -L
```

### リソースやグループやノードのスコアをもっとよくみる
```
wget http://hg.clusterlabs.org/pacemaker/stable-1.0/raw-file/c3869c00c759/extra/showscores.sh
chmod +x showscores.sh 
./showscores.sh
```

### ノードのアトリビュート（属性）を表示
crm_mon の -A オプションが使えるならそれで。<br>
```
crm_mon -A
```
使えない場合は・・・<br>
cibadmin --xpath でローカルノードのアトリビュートを一覧表示。<br>
```
cibadmin --query --xpath "//status/node_state[@uname='$(uname -n)']//nvpair"
```
crm_attribute で属性名を指定して表示。<br>
```
crm_attribute --type status --node $(uname -n) --name ping_val --query
```
