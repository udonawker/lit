## [Ansibleのdebugモジュールを使ってログを出力する方法がshellモジュールを使ったかどうかで違ったのでまとめる 2019/09/7](https://qiita.com/gkzz/items/fe73227557ea853904cc)

### モジュール別のdebug方法一覧表

||標準出力のdebug|エラー出力のdebug|
|:--|:--|:--|
|shellモジュール|"{{ $RESULT.stdout }}"|"{{ $RESULT.stderr }}"|
|shellモジュール以外(fileなど)|"{{ $RESULT }}"|"{{ $RESULT }}"|

##### sample.yml
```
---
- hosts: 
    - dev
  become: yes
  vars:
    ##成功、stdoutのみ"dir_test "と出力あり。
    #target: /usr/etc/
　　 ##成功、stdout/stderrともに出力なし。
    #target: /usr/etc/dir_test 
    ##失敗、stderのみ"No such file or directory"と出力あり。
    target: /usr/ett  

  tasks:
    #- name: Check if target dir exists or not
    - stat:
        path: "{{ target }}"
      register: result_stat
      failed_when: false 
      ##moduleの実行結果を確認する場合は"{{ $REGISTER }}"
    - name: debug 
      debug:
        msg: "{{ result_stat }}"
    - shell: ls "{{ target }}"
      register: result_shell
      failed_when: false
      changed_when: false
　　  #shellモジュールで直接コマンドを叩いた実行結果を確認する場合は"{{ $REGISTER.stdout or $REGISTER.stderr }}"
    - name: debug result_shell.stdout
      debug:
        msg: "{{ result_shell.stdout }}"
    - name: debug result_shell.stderr
      debug:
        msg: "{{ result_shell.stderr }}"
```

### キッチリ正常判定を行う場合
```
failed_when: result.rc == 0 or "No such" not in result.stdout
```

### 条件が複数行にまたがる場合にスマートに書く場合
```

- name: example of many failed_when conditions with OR
  shell: "./myBinary"
  register: ret
  failed_when: >                                        #":"の後に">"を書けば改行できるようですね。
    ("No such file or directory" in ret.stdout) or
    (ret.stderr != '') or
    (ret.rc == 10)
```
