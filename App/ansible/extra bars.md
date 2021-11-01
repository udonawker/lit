<pre>
ansible-playbook -i site site.yml --extra-vars="AAA=aaa is_bbb=true"
</pre>

## [ansible-playbook コマンドの -e (--extra-vars) オプションは変数ファイル名も指定できる](https://tekunabe.hatenablog.jp/entry/2018/12/14/ansible_extra_vars_file)

### -e @ファイル名 で変数ファイルも指定できる
-e オプションの指定が多かったり、リストやディクショナリの値を指定すると、コマンドが見にくくなってしまいます。<br>
そこで、-e @ファイル名 のように指定すると、変数たちを書き出したファイルを扱うことができ、コマンドをすっきりさせることができます。<br>
（ドキュメントやコマンドヘルプにも記載があります）<br>

playbook<br>
```
- hosts: localhost
  gather_facts: no

  tasks:
    - name: vars test
      debug:
        var: "{{ item }}"
      loop:
        - key1
        - key2
        - key3
```

myvars.yml (変数たちを書き出したファイル)<br>
```
---
key1: val1
key2: val2
key3:
  - val3_1
  - val3_2
  - val3_3
```

実行結果<br>
```
$ ansible-playbook -i localhost, varstest.yml -e @myvars.yml

PLAY [localhost] ***********************************************************

TASK [vars test] ***********************************************************
ok: [localhost] => (item=key1) => {
    "item": "key1",
    "key1": "val1"
}
ok: [localhost] => (item=key2) => {
    "item": "key2",
    "key2": "val2"
}
ok: [localhost] => (item=key3) => {
    "item": "key3",
    "key3": [
        "val3_1",
        "val3_2",
        "val3_3"
    ]
}

PLAY RECAP *****************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0
```
