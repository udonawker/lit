## [Is it still applicable to use pexpect on RedHat7 or is there alternative way to Executes a command and responds to prompts?](https://stackoverflow.com/questions/56126549/is-it-still-applicable-to-use-pexpect-on-redhat7-or-is-there-alternative-way-to)
## [the documentation for the shell module:](https://docs.ansible.com/ansible/latest/modules/shell_module.html#examples)

```
# You can use shell to run other executables to perform actions inline
- name: Run expect to wait for a successful PXE boot via out-of-band CIMC
  shell: |
    set timeout 300
    spawn ssh admin@{{ cimc_host }}

    expect "password:"
    send "{{ cimc_password }}\n"

    expect "\n{{ cimc_name }}"
    send "connect host\n"

    expect "pxeboot.n12"
    send "\n"

    exit 0
  args:
    executable: /usr/bin/expect
  delegate_to: localhost
```
