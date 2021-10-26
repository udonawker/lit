## [Ansible 2.7でyum + with_itemsを使うと出る警告の直し方](https://qiita.com/ikemo/items/9b563db81bba1a2fdc94)

### 警告の内容
Ansible 2.7でyumモジュールを使っていたところ、以下の警告が出ました。<br>
```
[DEPRECATION WARNING]: Invoking "yum" only once while using a loop via 
squash_actions is deprecated. Instead of using a loop to supply multiple items 
and specifying `name: {{ item }}`, please use `name: ['git', 'gcc']` and remove
 the loop. This feature will be removed in version 2.11. Deprecation warnings 
can be disabled by setting deprecation_warnings=False in ansible.cfg.
```

### squash_actionsとは
[ANSIBLE_SQUASH_ACTIONS](https://docs.ansible.com/ansible/2.7/reference_appendices/config.html#envvar-ANSIBLE_SQUASH_ACTIONS)に以下のように記載されています。<br>
<br>
ざっくり言うと、with_によるループを使っているときに、リストで渡すように最適化する機能です。<br><br>

具体的には、以下のように書かれているときに、<br>
yumモジュールを2回実行するのではなく、['git', 'gcc']のように自動的にリストにして、1回で実行してくれます。便利ですね。<br>
```
- yum: name={{ item }}
  with_items:
    - git
    - gcc
```

### 修正方法
Ansible 2.7 Porting Guideやyumに書かれているように、以下のようにします。<
```
- yum:
    name: "{{ packages }}"
    state: present
  vars:
    packages:
    - git
    - gcc
```

また、yumモジュールに関しては、以下のようにも書けます。こちらの方がシンプルですね。<br>
```
- yum:
    name:
      - git
      - gcc
```
