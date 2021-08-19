## [Ansible : Playbook を利用する (include)](https://www.server-world.info/query?os=CentOS_8&p=ansible&f=7)

[1] タスクを他からインクルードする場合は、[tasks] 内に [include: ***] と記述します。<br>
```
[cent@dlp ~]$ vi playbook_sample.yml
# [tasks] ディレクトリ配下の [included.yml] をインクルード
- hosts: target_servers
  become: yes
  become_method: sudo
  tasks:
    - include: tasks/included.yml

[cent@dlp ~]$ mkdir tasks
[cent@dlp ~]$ vi tasks/included.yml
# タスクの部分のみの記述で OK
- name: General packages are installed
  yum:
    name: "{{ packages }}"
    state: present
  vars:
    packages:
    - tar
    - wget
    - unzip
  tags: General_Packages

[cent@dlp ~]$ ansible-playbook playbook_sample.yml --ask-become-pass
BECOME password:

PLAY [target_servers] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [10.0.0.52]
ok: [10.0.0.51]

TASK [General packages are installed] ******************************************
changed: [10.0.0.52]
changed: [10.0.0.51]

PLAY RECAP *********************************************************************
10.0.0.51                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
10.0.0.52                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

[2]	Playbook を他からインクルードする場合は、[import_playbook] を利用します。<br>
[1] の例に加えて、[httpd] の起動状態を保つ Playbook をインクルードします。<br>
```
[cent@dlp ~]$ vi playbook_sample.yml
- hosts: target_servers
  become: yes
  become_method: sudo
  tasks:
    - include: tasks/included.yml
# 他の Playbook をインクルード
- import_playbook: httpd.yml

[cent@dlp ~]$ vi httpd.yml
# 通常の Playbook と同様の書式で記述する
- hosts: target_servers
  become: yes
  become_method: sudo
  tasks:
  - name: httpd is installed
    yum:
      name: httpd
      state: present
  - name: httpd is running and enabled
    service:
      name: httpd
      state: started
      enabled: yes

[cent@dlp ~]$ ansible-playbook playbook_sample.yml --ask-become-pass
BECOME password:

PLAY [target_servers] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [10.0.0.51]
ok: [10.0.0.52]

TASK [General packages are installed] ******************************************
changed: [10.0.0.52]
changed: [10.0.0.51]

PLAY [target_servers] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [10.0.0.52]
ok: [10.0.0.51]

TASK [httpd is installed] ******************************************************
changed: [10.0.0.52]
changed: [10.0.0.51]

TASK [httpd is running and enabled] ********************************************
changed: [10.0.0.52]
changed: [10.0.0.51]

PLAY RECAP *********************************************************************
10.0.0.51                  : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
10.0.0.52                  : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
