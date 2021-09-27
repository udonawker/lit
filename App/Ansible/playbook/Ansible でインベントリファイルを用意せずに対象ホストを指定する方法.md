## [Ansible でインベントリファイルを用意せずに対象ホストを指定する方法](https://tekunabe.hatenablog.jp/entry/2018/06/11/ansible_inventory_list)

### `-i` にカンマ区切りで直接ホストを指定できる
通常、 ansible-playbook コマンドや ansible コマンドのオプション `-i` オプションでは、イベントリファイル名を指定することが多いと思います。<br>
この `-i` オプションですが、インベントリファイルを用意することなく、対象ホストをカンマ区切りで直接指定することもできます。<br>

例えば、rt01 と sw01 を対象とする場合は、以下のように指定します。<br>
```
ansible-playbook -i rt01,sw01 playbook.yml
```

対象が1ホストだけの場合は、末尾のカンマを残したかたちにします。<br.
```
ansible-playbook -i rt01, playbook.yml
```

なお、末尾のカンマがないと、インベントリファイル名が指定されたとみなされます。<br>
```
ansible-playbook -i rt01 playbook.yml
```
（この場合 rt01 というインベントリファイルを探しいく）<br>


---

command<br>
```
ansible-playbook -i 192.168.1.100, playbook.yml -k -K -u test_user
```

playbook.yml<br>
```
- hosts: 192.168.1.100
  become: yes
  become_method: su
  max_fail_percentage: 0
  roles:
    - test_role
```

roles/test_role/tasks/main.yml<br>
```
---
- name: command whoami test_user2
  become: yes
  become_user: test_user2
  command: whoami
  register: result_test_user2

- name: debug result_test_user2
  debug:
    msg: "result_test_user2={{ result_test_user2.stdout }}"

- name: command whoami root
  command: whoami
  register: result_root

- name: debug root
  debug:
    msg: "result={{ result_root.stdout }}"
```
