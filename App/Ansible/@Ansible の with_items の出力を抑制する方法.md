## [Ansible の with_items の出力を抑制する方法](https://innossh.hatenablog.com/entry/2019/03/09/140328)

#### [loop-control](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#loop-control)

```
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: execute docker commands
      command: "docker {{ item }}"
      with_items:
        - "ps --help"
        - "logs --help"
      changed_when: false
      register: command_result

    - name: output docker command's help
      debug:
        msg: "{{ item.stdout_lines }}"
      with_items: "{{ command_result.results }}"
      loop_control:
        label: "{{ item.cmd | default(item) }}"
      when: command_result.results is defined
        and item.stdout_lines is defined
```

結果<br>
```
$ ansible-playbook loop.yml

PLAY [localhost] ****************************************************************************************************************************

TASK [execute docker commands] **************************************************************************************************************
ok: [localhost] => (item=ps --help)
ok: [localhost] => (item=logs --help)

TASK [output docker command's help] *********************************************************************************************************
ok: [localhost] => (item=['docker', 'ps', '--help']) => {
    "msg": [
        "",
        "Usage:\tdocker ps [OPTIONS]",
        "",
        "List containers",
        "",
        "Options:",
        "  -a, --all             Show all containers (default shows just running)",
        "  -f, --filter filter   Filter output based on conditions provided",
        "      --format string   Pretty-print containers using a Go template",
        "  -n, --last int        Show n last created containers (includes all",
        "                        states) (default -1)",
        "  -l, --latest          Show the latest created container (includes all",
        "                        states)",
        "      --no-trunc        Don't truncate output",
        "  -q, --quiet           Only display numeric IDs",
        "  -s, --size            Display total file sizes"
    ]
}
ok: [localhost] => (item=['docker', 'logs', '--help']) => {
    "msg": [
        "",
        "Usage:\tdocker logs [OPTIONS] CONTAINER",
        "",
        "Fetch the logs of a container",
        "",
        "Options:",
        "      --details        Show extra details provided to logs",
        "  -f, --follow         Follow log output",
        "      --since string   Show logs since timestamp (e.g.",
        "                       2013-01-02T13:23:37) or relative (e.g. 42m for 42",
        "                       minutes)",
        "      --tail string    Number of lines to show from the end of the logs",
        "                       (default \"all\")",
        "  -t, --timestamps     Show timestamps",
        "      --until string   Show logs before a timestamp (e.g.",
        "                       2013-01-02T13:23:37) or relative (e.g. 42m for 42",
        "                       minutes)"
    ]
}

PLAY RECAP **********************************************************************************************************************************
localhost    
```
