■playbook<br>

```
- hosts: xxx
  become: yes
  become_method: su
  max_fail_percentage: 
  tasks:
  - set_fact:
      test_addr: "192.168.100.100"
  - set_fact:
      ip_split: "{{ test_addr.split('.')[0:4] }}"
  - set_fact:
      ip_split_math: "{{ ip_split.3 | int - 3 }}"
  - set_fact:
      target_address: "{{ip_split.0}}.{{ip_split.1}}.{{ip_split.2}}.{{ip_split_math}}"
  - name: print ansible_host
    debug:
      msg:
        - "{{ target_address }}"
```

■出力<br>
```
TASK [print ansible_host] ******************************************************
ok: [xxx] => {
    "msg": [
        "192.168.100.97"
    ]
}
```

---

## [Increment a Byte in an IP address](https://stackoverflow.com/questions/64620759/increment-a-byte-in-an-ip-address)

Really simple thing I want to do in Ansible ... or so you would think.<br>
All I want to do is to set a variable [which I later use in a j2 template] to the value of ansible_default_ipv4.network, with the last byte chopped off and third incremented.<br>
so, if ansible_default_ipv4.network is 192.168.10.0, I want to the new variable set to 192.168.11.<br>
Here's how I presently do it:<br>
```
- set_fact:
   x: "{{ ansible_default_ipv4.network.split('.')[0:3] }}"
- set_fact:
   x2: "{{ x.2 | int  + 1 }}"
- set_fact:
   x3: "{{x.0}}.{{x.1}}.{{x2}}"
```

Answer<br>
```
    - set_fact:
        x: "{{ ansible_default_ipv4.network|ipmath(256)|splitext|first }}"
```
