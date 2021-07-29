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
    
    - name: date
      command: date
      register: date_result
    
    - debug: var=date_result.stdout
    - debug: msg="message {{ variable }} message"
```
