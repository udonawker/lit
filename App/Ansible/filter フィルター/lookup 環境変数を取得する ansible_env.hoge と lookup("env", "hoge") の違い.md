## [環境変数を取得する ansible_env.hoge と lookup("env", "hoge") の違い](https://tekunabe.hatenablog.jp/entry/2019/03/09/ansible_env)

||ansible_env.hoge|lookup("env", "hoge")|
|:--|:--|:--|
|取得場所|リモートホスト（ターゲット）|ローカルホスト（ansible-playbookコマンド実行ホスト）|
|取得タイミング|gather_facts: yes （デフォルト）などによる setup 実行時|参照時（のはず）|
|取得可能な環境変数|setup モジュールに依存|すべて|

## ■動作確認
Ansible 2.7.8<br>
<br>
playbook<br>
```
- hosts: linux  # taget1 、target2 定義済みグループ
  gather_facts: yes   # デフォルトはyes。no の場合は ansible_env 自体が定義されない

  tasks:  
    - name: debug lookup("env", "PWD") 
      debug:
        var: lookup("env", "PWD") 

    - name: debug ansible_env.PWD
      debug:
        var: ansible_env.PWD

    - name: debug ansible_env
      debug:
        var: ansible_env       # ansible_env 全体を表示
```

実行結果<br>
```
$ echo $PWD # ローカルホスト上の 環境変数 `PWD` をあらかじめ確認。
/vagrant/blog/env
$ ansible-playbook -i inventory env.yml    # Playbook 実行

PLAY [linux] *************************************************************************************

TASK [Gathering Facts] ***************************************************************************
ok: [target2]
ok: [target1]

TASK [debug lookup("env", "PWD")] ****************************************************************
ok: [target1] => {
    "lookup(\"env\", \"PWD\")": "/vagrant/blog/env"
}
ok: [target2] => {
    "lookup(\"env\", \"PWD\")": "/vagrant/blog/env"
}

TASK [debug ansible_env.PWD] *********************************************************************
ok: [target1] => {
    "ansible_env.PWD": "/home/vagrant"
}
ok: [target2] => {
    "ansible_env.PWD": "/home/testuser"
}

TASK [debug ansible_env] *************************************************************************
ok: [target1] => {
    "ansible_env": {
        "HOME": "/home/vagrant", 
        "LANG": "C", 
        "LC_ALL": "C", 
        "LC_MESSAGES": "C", 
        "LESSOPEN": "||/usr/bin/lesspipe.sh %s", 
        "LOGNAME": "vagrant", 
        "LS_COLORS": "rs=0:di=38;(...略...)", 
        "MAIL": "/var/mail/vagrant", 
        "PATH": "/usr/local/bin:/usr/bin", 
        "PWD": "/home/vagrant", 
        "SELINUX_LEVEL_REQUESTED": "", 
        "SELINUX_ROLE_REQUESTED": "", 
        "SELINUX_USE_CURRENT_RANGE": "", 
        "SHELL": "/bin/bash", 
        "SHLVL": "2", 
        "SSH_CLIENT": "172.16.0.9 53026 22", 
        "SSH_CONNECTION": "172.16.0.9 53026 172.16.0.11 22", 
        "SSH_TTY": "/dev/pts/5", 
        "TERM": "xterm-256color", 
        "USER": "vagrant", 
        "XDG_RUNTIME_DIR": "/run/user/1000", 
        "XDG_SESSION_ID": "18", 
        "_": "/usr/bin/python"
    }
}
ok: [target2] => {
    "ansible_env": {
        "HOME": "/home/testuser", 
        "LANG": "ja_JP.UTF-8", 
        "LESSOPEN": "||/usr/bin/lesspipe.sh %s", 
        "LOGNAME": "testuser", 
        "LS_COLORS": "rs=0:di=38;(...略...)", 
        "MAIL": "/var/mail/testuser", 
        "PATH": "/usr/local/bin:/usr/bin", 
        "PWD": "/home/testuser", 
        "SELINUX_LEVEL_REQUESTED": "", 
        "SELINUX_ROLE_REQUESTED": "", 
        "SELINUX_USE_CURRENT_RANGE": "", 
        "SHELL": "/bin/bash", 
        "SHLVL": "2", 
        "SSH_CLIENT": "172.16.0.9 49312 22", 
        "SSH_CONNECTION": "172.16.0.9 49312 172.16.0.12 22", 
        "SSH_TTY": "/dev/pts/1", 
        "TERM": "xterm-256color", 
        "USER": "testuser", 
        "XDG_RUNTIME_DIR": "/run/user/1001", 
        "XDG_SESSION_ID": "20", 
        "_": "/usr/bin/python"
    }
}

PLAY RECAP ***************************************************************************************
target1                    : ok=4    changed=0    unreachable=0    failed=0   
target2                    : ok=4    changed=0    unreachable=0    failed=0
```

#### 確認できたこと
上記の Playbook 実行結果から以下のことが分かります。<br>
* lookup("env", "PWD") の値は、target1、target2 向けのいずれのタスクでも /vagrant/blog/env になっています。
    * これらはローカルホスト上の環境変数 PWD の値です。
* ansible_env.PWD の値は、target1 では /home/vagrant、 target2 では /home/testuser となっています。これは各ターゲットに異なるユーザーでログインしたため、ログイン先での PWD も異なっている、という状態です。リモートホストの PWD である /vagrant/blog/env とも異なっています。
    * これらはリモートホスト上の環境変数 PWD の値です。
* ansible_env 配下には、すべてのローカル環境変数が入るわけではない
    * たとえば、HOSTNAME がない

### ■まとめ
環境変数を取得する方法である、ansible_env.hoge と lookup("env", "hoge") の違いについて確認しました。 主な違いは、リモートのものなのか、ローカルのものなのかでした、<br>
