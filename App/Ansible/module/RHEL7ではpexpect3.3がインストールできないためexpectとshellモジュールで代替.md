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

## [Does Red Hat ship pexpect 3.3 ?](https://access.redhat.com/solutions/3440581)
### 問題
- Ansible 2.3.1 requires Python pexpect in version 3.3 or higher which is not available in RHEL 6 repositories
- Upgrade pexpect package version to 3.3 or higher
- Where can I get pexpect 3.3 ?
- How to install pexpect 3.3 ?

### 解決策
- RHEL6 and RHEL7 includes pexpect 2.x
- Red Hat does not ship pexpect 3.3

### 原因
- A feature request - 1525809 was raised for including pexpect 3
- The request was rejected as, upgrading pexpect to next major release could break several applications that are dependent of this package.
