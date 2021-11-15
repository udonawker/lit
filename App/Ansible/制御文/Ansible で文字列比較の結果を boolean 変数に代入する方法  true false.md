## [Ansible で文字列比較の結果を boolean 変数に代入する方法](https://muziyoshiz.hatenablog.com/entry/2020/03/29/221616)

## 実験
文字列比較の内容は何でもいいので、("1" == "1") という単純な条件式で実験します。以下の実験は、Ansible 2.9 の最新版（2.9.6）で行いました。<br>

## いろいろな方法での代入
まず、代入した値をそのまま debug モジュールで出力してみます。<br>

playbook:<br>
```
- hosts: localhost
  connection: local
  vars:
    var1: True
    var2: False
    var3: "True"
    var4: "False"
    var5: ("1" == "1")
    var6: ("1" == "1")|bool
    var7: "{{ ('1' == '1') }}"
    var8: "{{ ('1' == '1')|bool }}"
  tasks:
    - name: Print vars
      debug: msg="{{ item }}"
      with_items:
        - "{{ var1 }}"
        - "{{ var2 }}"
        - "{{ var3 }}"
        - "{{ var4 }}"
        - "{{ var5 }}"
        - "{{ var6 }}"
        - "{{ var7 }}"
        - "{{ var8 }}"
```

結果:
```
% ansible-playbook test.yml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match
'all'

PLAY [localhost] *****************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************
ok: [localhost]

TASK [Print vars] ****************************************************************************************************
ok: [localhost] => (item=True) => {
    "msg": true
}
ok: [localhost] => (item=False) => {
    "msg": false
}
ok: [localhost] => (item=True) => {
    "msg": true
}
ok: [localhost] => (item=False) => {
    "msg": false
}
ok: [localhost] => (item=("1" == "1")) => {
    "msg": "(\"1\" == \"1\")"
}
ok: [localhost] => (item=("1" == "1")|bool) => {
    "msg": "(\"1\" == \"1\")|bool"
}
ok: [localhost] => (item=True) => {
    "msg": true
}
ok: [localhost] => (item=True) => {
    "msg": true
}

PLAY RECAP ***********************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

|変数名|代入方法|結果|
|:--|:--|:--|
|var1|True を代入|boolean true|
|var2|False を代入|boolean false|
|var3|"True" という文字列を代入|boolean true|
|var4|"False" という文字列を代入|boolean false|
|var5|条件式を代入|条件式の文字列|
|var6|条件式を |bool 付きで代入|条件式の文字列|
|var7|条件式を "{{ }}" で囲んで代入|boolean true|
|var8|条件式に |bool を付けた上で "{{ }}" で囲んで代入|boolean true|

条件式を "{{ }}" で囲めば、その結果が boolean として代入されるし、囲まなければ文字列として代入されることがわかります。いずれにせよ、代入の時点で |bool の有無は全く関係ないようです。<br>

## when 節への文字列の渡し方
代入時に boolean になっている場合は当然成功するので、ここからは代入時に文字列になってしまった場合のみを考えます。<br>
|bool の有無と、結果が True になるかどうかの4通りで実験しました。Playbook が長くなるので、以下には var1 のタスクだけ記載しています。<br>

```
---
- hosts: localhost
  connection: local
  vars:
    var1: ("1" == "1")
    var2: ("1" == "1")|bool
    var3: ("1" == "2")
    var4: ("1" == "2")|bool
  tasks:
    - name: 1. var1 should be printed
      debug: msg="{{ var1 }}"
      when: var1

    - name: 2. var1 should NOT be printed
      debug: msg="{{ var1 }}"
      when: not var1

    - name: 3. var1 should be printed
      debug: msg="{{ var1 }}"
      when: var1|bool

    - name: 4. var1 should NOT be printed
      debug: msg="{{ var1 }}"
      when: not var1|bool

    - name: 5. var1 should NOT be printed
      debug: msg="{{ var1 }}"
      when: not (var1|bool)

    - name: 6. var1 should be printed
      debug: msg="{{ var1 }}"
      when: "{{ var1 }}"

    - name: 7. var1 should NOT be printed
      debug: msg="{{ var1 }}"
      when: "{{ not var1 }}"

# Template error
#    - name: 8. var1 should NOT be printed
#      debug: msg="{{ var1 }}"
#      when: not "{{ var1 }}"

    - name: 9. var1 should be printed
      debug: msg="{{ var1 }}"
      when: "{{ var1|bool }}"

    - name: 10. var1 should NOT be printed
      debug: msg="{{ var1 }}"
      when: "{{ not var1|bool }}"

    - name: 11. var1 should NOT be printed
      debug: msg="{{ var1 }}"
      when: not "{{ var1|bool }}"
```

結果:
```
% ansible-playbook test.yml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match
'all'

PLAY [localhost] *****************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************
ok: [localhost]

TASK [1. var1 should be printed] *************************************************************************************
[DEPRECATION WARNING]: evaluating u'var1' as a bare variable, this behaviour will go away and you might need to add
|bool to the expression in the future. Also see CONDITIONAL_BARE_VARS configuration toggle. This feature will be
removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [localhost] => {
    "msg": "(\"1\" == \"1\")"
}

TASK [2. var1 should NOT be printed] *********************************************************************************
skipping: [localhost]

TASK [3. var1 should be printed] *************************************************************************************
skipping: [localhost]

TASK [4. var1 should NOT be printed] *********************************************************************************
ok: [localhost] => {
    "msg": "(\"1\" == \"1\")"
}

TASK [5. var1 should NOT be printed] *********************************************************************************
ok: [localhost] => {
    "msg": "(\"1\" == \"1\")"
}

TASK [6. var1 should be printed] *************************************************************************************
[WARNING]: conditional statements should not include jinja2 templating delimiters such as {{ }} or {% %}. Found: {{
var1 }}
ok: [localhost] => {
    "msg": "(\"1\" == \"1\")"
}

TASK [7. var1 should NOT be printed] *********************************************************************************
[WARNING]: conditional statements should not include jinja2 templating delimiters such as {{ }} or {% %}. Found: {{
not var1 }}
skipping: [localhost]

TASK [9. var1 should be printed] *************************************************************************************
[WARNING]: conditional statements should not include jinja2 templating delimiters such as {{ }} or {% %}. Found: {{
var1|bool }}
skipping: [localhost]

TASK [10. var1 should NOT be printed] ********************************************************************************
[WARNING]: conditional statements should not include jinja2 templating delimiters such as {{ }} or {% %}. Found: {{
not var1|bool }}
ok: [localhost] => {
    "msg": "(\"1\" == \"1\")"
}

TASK [11. var1 should NOT be printed] ********************************************************************************
[WARNING]: conditional statements should not include jinja2 templating delimiters such as {{ }} or {% %}. Found: not
"{{ var1|bool }}"
skipping: [localhost]
```

まとめると、1番の when: varX または 6番の when: {{ varX }} の書き方をすると、DEPRECATION WARNING は出るが、想定通りの結果になりました。それ以外は、文字列の中身に関わらず同じ結果になりました。<br>

|when の書き方|var1|var2|var3|var4|
|:--|:--|:--|:--|:--|
|1. varX|ok|ok|skipping|skipping|
|2. not varX|skipping|skipping|skipping|skipping|
|3. varX|bool|skipping|skipping|skipping|skipping|
|4. not varX|bool|ok|ok|ok|ok|
|5. not (varX|bool)|ok|ok|ok|ok|
|6. {{ varX }}|ok|ok|skipping|skipping|
|7. {{ not varX }}|skipping|skipping|skipping|skipping|
|9. {{ varX|bool }}|skipping|skipping|skipping|skipping|
|10. {{ not varX|bool }}|ok|ok|ok|ok|
|11. not {{ varX|bool }}|skipping|skipping|skipping|skipping|

