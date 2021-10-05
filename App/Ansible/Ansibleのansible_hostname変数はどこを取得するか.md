## [Ansibleのansible_hostname変数はどこを取得するか](https://anikitech.hatenablog.com/entry/2019/08/16/144948)

##### Ansibleバージョン
`ansible-2.8.1-1.el7.noarch`<br>

---

### 対象サーバのホスト名状態
hostnameコマンドにて、一時的にホスト名をcheck-serverに変更<br>
```
[root@test-server ]# hostname
test-server
[root@test-server ]# hostname check-server
[root@test-server ]# hostname
check-server
```

/etc/hostnameの設定ファイルはそのまま<br>
```
[root@test-server ]# cat /etc/hostname
test-server
```

---

### 検証
#### Playbook
```
[root@ansible-server ]# cat ValidateAnsibleHostname.yml
- hosts: testserver1
  remote_user: user1
  tasks:
    - name: debug ansible_hostname
      debug:
        msg: "{{ansible_hostname}}"
```

#### インベントリファイル
```
[root@ansible-server ]# cat hosts/local
[testserver1]
10.0.0.11
```

#### 結果
```
[root@ansible-server ]# ansible-playbook --inventory-file hosts/local ValidateAnsibleHostname.yml

PLAY [testserver1] *************************************************************

TASK [Gathering Facts] *********************************************************
ok: [10.0.0.11]

TASK [debug ansible_hostname] **************************************************
ok: [10.0.0.11] => {
    "msg": "check-server"
}

PLAY RECAP *********************************************************************
10.0.0.11                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### 解説
永続的なホスト名が設定される/etc/hostnameではなく、現在の（メモリ上の？）ホスト名を参照するみたい。<br>
また、ansible_nodenameとansible_fqdnにも同じようにcheck-serverが設定されていた。<br>
hostnameとnodenameって違いはなんだろう？<br>

