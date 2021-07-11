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
