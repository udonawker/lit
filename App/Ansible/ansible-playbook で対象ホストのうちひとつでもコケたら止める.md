## [ansible-playbook で対象ホストのうちひとつでもコケたら止める](https://53ningen.com/ansible-playbook-stop-on-fail/)

実際には以下を playbook に書いてあげればよい。<br>
```
max_fail_percentage: 0
```

playbook example<br>
```
- hosts: test_inventory
  become: yes
  become_method: su
  max_fail_percentage: 0
  roles:
    - test
  vars:
    test_file: /tmp/{{ inventory_hostname }}.tar.gz
```
