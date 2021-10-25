## [findモジュールで特定コンテンツを含むファイル一覧を取得(grep -E -l ライクな動作)](ntoskrnl.exe!SeAccessCheckWithHint)

## 要点
Ansibleにgrepを行うためのモジュールが用意されていないが、findモジュールのcontentsパラメータをつかえば`grep -E -l 'regex_pattern' path | xargs ls -l`と同様の結果を取得できる<br>

## 説明
本家のfindモジュールのページを確認すると、以下パラメータの記述がある。<br>

|Parameter|Choices/Defaults|Comments|
|:--|:--|:--|
|contains(string)||ファイルコンテンツにマッチするべき1つもしくはそれ以上の正規表現パターン|

つまり、ファイルのコンテンツ(中身)に対してマッチさせる正規表現パターンを設定できるということ。<br>
注意すべきは<br>
- "One or more regex patterns"と書いてあるにもかかわらず値にはstringをとるので1つしかパターンを設定できない<br>
- パターンは行に対して前方一致しなければならない(らしい)(ver 2.5.0)<br>

Ansible grep moduleとかでWeb検索かけてもgrep用のモジュール見つからなかったので、shellモジュールで実現していたが、これでgrepするためだけのshellモジュールの利用をやめられる。<br>
参考: https://docs.ansible.com/ansible/latest/modules/find_module.html<br>

## 利用方法
以下の３つのテストファイルと、プレイブックを用意して実行すると、想定通り正規表現にマッチするコンテンツを持つファイルのみリストできる。<br>

test_files_to_be_matched<br>
```
$ more /tmp/match_file_A.txt /var/tmp/match_file_B /var/tmp/unmatch_file_C
::::::::::::::
/tmp/match_file_A.txt
::::::::::::::
This file matches to the Regex pattern !
::::::::::::::
/var/tmp/match_file_B
::::::::::::::
This file matches to the regex pattern !
::::::::::::::
/var/tmp/unmatch_file_C
::::::::::::::
This file doesn't match to the pattern !
```

playbook.yml
```
---
- name: findモジュールを利用したファイルコンテンツのパターンマッチテスト
  hosts: all
  become: true
  gather_facts: no
  tasks:
  - find:
      paths:
      - /tmp
      - /var/tmp
      contains: '.*[Rr]egex pattern'
    register: out

  - debug:
      msg: '{{ item.path }}'
    with_items: '{{ out.files }}'
```

実行結果<br>
```
PLAY [findモジュールを利用したファイルコンテンツのパターンマッチテスト] ************************************************************************************************************************************************************************

TASK [find] ******************************************************************************************************************************************************************************************************
ok: [localhost] => {"changed": false, "examined": 53, "files": [{"atime": 1570198229.0649102, "ctime": 1570198162.909055, "dev": 64768, "gid": 100, "gr_name": "users", "inode": 17126543, "isblk": false, "ischr": false, "isdir": false, "isfifo": false, "isgid": false, "islnk": false, "isreg": true, "issock": false, "isuid": false, "mode": "0644", "mtime": 1570198162.908055, "nlink": 1, "path": "/tmp/match_file_A.txt", "pw_name": "user", "rgrp": true, "roth": true, "rusr": true, "size": 41, "uid": 10004, "wgrp": false, "woth": false, "wusr": true, "xgrp": false, "xoth": false, "xusr": false}, {"atime": 1570198163.526063, "ctime": 1570198152.7819242, "dev": 64768, "gid": 100, "gr_name": "users", "inode": 17125304, "isblk": false, "ischr": false, "isdir": false, "isfifo": false, "isgid": false, "islnk": false, "isreg": true, "issock": false, "isuid": false, "mode": "0644", "mtime": 1570198152.780924, "nlink": 1, "path": "/var/tmp/match_file_B", "pw_name": "user", "rgrp": true, "roth": true, "rusr": true, "size": 41, "uid": 10004, "wgrp": false, "woth": false, "wusr": true, "xgrp": false, "xoth": false, "xusr": false}], "matched": 2, "msg": ""}

TASK [debug] *****************************************************************************************************************************************************************************************************
ok: [localhost] => (item=None) => {
    "msg": "/tmp/match_file_A.txt"
}
ok: [localhost] => (item=None) => {
    "msg": "/var/tmp/match_file_B"
}

PLAY RECAP *******************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0
```

## 注意事項
前述の通り「__パターンは行に対して前方一致しなければならない(らしい)__」ので、以下のようにパターンをcontains: '[Rr]egex pattern'とすると、とたんにマッチしなくなる。<br>

playbook.yml<br>
```
---
- name: findモジュールを利用したファイルコンテンツのパターンマッチテスト
  hosts: all
  become: true
  gather_facts: no
  tasks:
  - find:
      paths:
      - /tmp
      - /var/tmp
      contains: '[Rr]egex pattern'
    register: out

  - debug:
      msg: '{{ item.path }}'
    with_items: '{{ out.files }}'
```

実行結果<br>
```
PLAY [findモジュールを利用したファイルコンテンツのパターンマッチテスト] **********************************************************************************************

TASK [find] ****************************************************************************************************************************
ok: [localhost] => {"changed": false, "examined": 53, "files": [], "matched": 0, "msg": ""}

TASK [debug] ***************************************************************************************************************************

PLAY RECAP *****************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0
```
