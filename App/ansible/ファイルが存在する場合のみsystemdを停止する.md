<pre>
---
- name: check services
  stat:
    path: '/etc/systemd/system/{{ item }}'
  register: services
  with_items:
    - temptest.service

- name: systemctl stop services
  systemd:
    name: '{{ item._ansible_item_label }}'
    state: stopped
  when: item.stat.exists
  with_items: "{{ services.results }}"

- name: copy services
  copy: src='{{ item._ansible_item_label }}' dest='{{ item.invocation.module_args.path }}' owner='root' group='root' mode=0644
  with_items: "{{ services.results }}"

- name: systemctl start {{ item }}
  systemd:
    name: '{{ item._ansible_item_label }}'
    state: started
    enabled: True
    daemon_reload: yes
  with_items: "{{ services.results }}"
</pre>

参考デバッグ
<pre>
---
- name: check file '{{ item }}'
  stat:
    path: '/etc/systemd/system/{{ item }}'
  register: result
  with_items:
    - test.service
    - test1
    - test2

- name: check file debug '{{ item }}'
  debug: var={{ item }}
  with_items:
    - result


TASK [Gathering Facts] *********************************************************
ok: [host00]

TASK [test : check file '{{ item }}'] ******************************************
ok: [host00] => (item=test.service)
ok: [host00] => (item=test1)
ok: [host00] => (item=test2)

TASK [test : check file debug '{{ item }}'] **************************************
ok: [host00] => (item=result) => {
    "item": "result",
    "result": {
        "changed": false,
        "msg": "All items completed",
        "results": [
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": "test.service",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": false,
                "failed": false,
                "invocation": {
                    "module_args": {
                        "checksum_algorithm": "sha1",
                        "follow": false,
                        "get_attributes": true,
                        "get_checksum": true,
                        "get_md5": null,
                        "get_mime": true,
                        "path": "/etc/systemd/system/test.service"
                    }
                },
                "item": "test.service",
                "stat": {
                    "atime": 1554892322.2858524,
                    "attr_flags": "",
                    "attributes": [],
                    "block_size": 4096,
                    "blocks": 8,
                    "charset": "us-ascii",
                    "checksum": "45eb19b15babf897f7198661eca179986ab33d65",
                    "ctime": 1550122823.1138003,
                    "dev": 64768,
                    "device_type": 0,
                    "executable": false,
                    "exists": true,
                    "gid": 0,
                    "gr_name": "root",
                    "inode": 873104533,
                    "isblk": false,
                    "ischr": false,
                    "isdir": false,
                    "isfifo": false,
                    "isgid": false,
                    "islnk": false,
                    "isreg": true,
                    "issock": false,
                    "isuid": false,
                    "mimetype": "text/plain",
                    "mode": "0644",
                    "mtime": 1550122822.8998003,
                    "nlink": 1,
                    "path": "/etc/systemd/system/test.service",
                    "pw_name": "root",
                    "readable": true,
                    "rgrp": true,
                    "roth": true,
                    "rusr": true,
                    "size": 151,
                    "uid": 0,
                    "version": "1003928719",
                    "wgrp": false,
                    "woth": false,
                    "writeable": true,
                    "wusr": true,
                    "xgrp": false,
                    "xoth": false,
                    "xusr": false
                }
            },
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": "test1",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": false,
                "failed": false,
                "invocation": {
                    "module_args": {
                        "checksum_algorithm": "sha1",
                        "follow": false,
                        "get_attributes": true,
                        "get_checksum": true,
                        "get_md5": null,
                        "get_mime": true,
                        "path": "/etc/systemd/system/test1"
                    }
                },
                "item": "test1",
                "stat": {
                    "exists": false
                }
            },
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": "test2",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": false,
                "failed": false,
                "invocation": {
                    "module_args": {
                        "checksum_algorithm": "sha1",
                        "follow": false,
                        "get_attributes": true,
                        "get_checksum": true,
                        "get_md5": null,
                        "get_mime": true,
                        "path": "/etc/systemd/system/test2"
                    }
                },
                "item": "test2",
                "stat": {
                    "exists": false
                }
            }
        ]
    }
}

PLAY RECAP *********************************************************************
host00               : ok=3    changed=0    unreachable=0    failed=0
</pre>
