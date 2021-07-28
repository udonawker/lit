## [Reboot 後も処理を継続する方法](https://nwengblog.com/ansible-reboot/)

1. 非同期で Reboot 処理を実施する
1. 対象機器の ssh ポートが down するのを待つ
1. 対象機器の ssh ポートが up するのを待つ
1. 後続処理

playbook例<br>
```
- hosts: all
  become: yes
  tasks:
    - name: Execute reboot
      shell:
        cmd: 'sleep 2 && reboot'
      async: 1
      poll: 0
    - name: Wait for SSH port down
      become: no
      wait_for:
        host: '{{ inventory_hostname }}'
        port: '{{ ansible_ssh_port }}'
        state: stopped
      delegate_to: 127.0.0.1
    - name: Wait for SSH port up
      become: no
      wait_for:
        host: '{{ inventory_hostname }}'
        port: '{{ ansible_ssh_port }}'
        state: started
      delegate_to: 127.0.0.1
    - name: Debug
      debug:
        msg: Finish!
```

## [Ansibleのwait_for_connectionをつかってOSの再起動を待つ](https://www.kabegiwablog.com/entry/2018/05/18/100000)

#### playbook例
```
- hosts: target
  gather_facts: false

  tasks:
    - name: connect check
      ping:

    - name: restart machine
      shell: sleep 2 && shutdown -r now
      async: 1
      poll: 0
      become: true
      ignore_errors: true

    - name: wait for reboot
      wait_for_connection:
        delay: 30
        timeout: 300

    - name: connect check
      ping:
```
`shell`でサーバの再起動を実施しています。`async`と`pollを指定することでsshコネクションが切断されても処理をそのまま続けることができます。<br> wait_for_conenctionを利用してssh:22ポートがオープンするまで待機する設定をいれています。<br>

実行結果<br>
```
PLAY [all] **********************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************
ok: [10.69.34.191]

TASK [Execute reboot] ***********************************************************************************************
changed: [10.69.34.191]

TASK [Wait for SSH port down] ***************************************************************************************
ok: [10.69.34.191 -> 127.0.0.1]

TASK [Wait for SSH port up] *****************************************************************************************
ok: [10.69.34.191 -> 127.0.0.1]

TASK [Debug] ********************************************************************************************************
ok: [10.69.34.191] => {
    "msg": "Finish!"
}

PLAY RECAP **********************************************************************************************************
10.69.34.191               : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## [逆引きマニュアル: Ansibleでリブートする方法](https://www.ikemo3.com/inverted/ansible/reboot/)
### Ansible 2.7でrebootモジュールが追加
[reboot - Reboot a machine — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/reboot_module.html#reboot-module)

```
    - name: reboot
      shell: "sleep 5 && reboot"
      async: 1
      poll: 0

    - name: wait
      wait_for_connection:
        connect_timeout: 20
        sleep: 5
        delay: 5
        timeout: 60
```

## [Ansibleのwait_for_connectionをつかってOSの再起動を待つ](https://www.kabegiwablog.com/entry/2018/05/18/100000)

#### playbook例
```
- hosts: target
  gather_facts: false

  tasks:
    - name: connect check
      ping:

    - name: restart machine
      shell: sleep 2 && shutdown -r now
      async: 1
      poll: 0
      become: true
      ignore_errors: true

    - name: wait for reboot
      wait_for_connection:
        delay: 30
        timeout: 300

    - name: connect check
      ping:
```
`shell`でサーバの再起動を実施しています。`async`と`poll`を指定することでsshコネクションが切断されても処理をそのまま続けることができます。<br>
`wait_for_conenction`を利用してssh:22ポートがオープンするまで待機する設定をいれています。<br>

