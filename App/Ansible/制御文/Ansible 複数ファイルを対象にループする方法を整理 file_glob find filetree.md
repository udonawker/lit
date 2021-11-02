## [Ansible 複数ファイルを対象にループする方法を整理](https://qiita.com/htnosm/items/253a734cd476cba89b4f)

ディレクトリ構成<br>
```
.
├── files
│   ├── conf1.d
│   │   ├── conf1.conf
│   │   └── conf2.conf
│   ├── conf2.d
│   │   └── test.txt
│   └── conf3.d
│       └── sub.d
│           └── sub_conf1.conf
├── templates
│   ├── conf1.d
│   │   ├── conf1.conf
│   │   └── conf2.conf
│   ├── conf2.d
│   │   └── test.txt
│   └── conf3.d
│       └── sub.d
│           └── sub_conf1.conf
├── test
│   └── test.conf
```


### file glob (files)
```
    - name: local dir files (file glob for files)
      debug: msg="{{ item | replace(playbook_dir + '/', '') }}"
      with_fileglob:
        - "conf1.d/*.conf"
        - "*/*.conf"  # Not Support
        - "**/*.conf" # Not Support
```
```
TASK [local dir files (file glob for files)] ***********************************
 [WARNING]: Unable to find '*' in expected paths (use -vvvvv to see paths)

 [WARNING]: Unable to find '**' in expected paths (use -vvvvv to see paths)

ok: [localhost] => (item=/tmp/loop_match_files/files/conf1.d/conf1.conf) => {
    "msg": "files/conf1.d/conf1.conf"
}
ok: [localhost] => (item=/tmp/loop_match_files/files/conf1.d/conf2.conf) => {
    "msg": "files/conf1.d/conf2.conf"
}
```

### file glob (templates)
files 配下が起点となるため、相対パスで templates ディレクトリから取得する。<br>
```
    - name: local dir files (file glob for templates)
      debug: msg="{{ item | replace(playbook_dir + '/files/../', '') }}"
      with_fileglob:
        - "../templates/conf1.d/*.conf"
```
```
TASK [local dir files (file glob for templates)] *******************************
ok: [localhost] => (item=/tmp/loop_match_files/files/../templates/conf1.d/conf1.conf) => {
    "msg": "templates/conf1.d/conf1.conf"
}
ok: [localhost] => (item=/tmp/loop_match_files/files/../templates/conf1.d/conf2.conf) => {
    "msg": "templates/conf1.d/conf2.conf"
}
```

### with_lines + find
* lines - read lines from command — Ansible Documentation
    * コマンド実行結果でループさせる
        * findコマンドの実行結果を利用する

戻り値がフルパスとなるため相対パスへ書き換える。<br>

```
    - name: local dir files (find)
      debug: msg="{{ item | replace(playbook_dir + '/', '') }}"
      with_lines:
        - "find {{ playbook_dir }}/files -type f -name '*.conf'"
        - "find {{ playbook_dir }}/templates -type f -name '*.conf'"
```
```
TASK [local dir files (find)] **************************************************
ok: [localhost] => (item=/tmp/loop_match_files/files/conf1.d/conf1.conf) => {
    "msg": "files/conf1.d/conf1.conf"
}
ok: [localhost] => (item=/tmp/loop_match_files/files/conf1.d/conf2.conf) => {
    "msg": "files/conf1.d/conf2.conf"
}
ok: [localhost] => (item=/tmp/loop_match_files/files/conf3.d/sub.d/sub_conf1.conf) => {
    "msg": "files/conf3.d/sub.d/sub_conf1.conf"
}
ok: [localhost] => (item=/tmp/loop_match_files/templates/conf1.d/conf1.conf) => {
    "msg": "templates/conf1.d/conf1.conf"
}
ok: [localhost] => (item=/tmp/loop_match_files/templates/conf1.d/conf2.conf) => {
    "msg": "templates/conf1.d/conf2.conf"
}
ok: [localhost] => (item=/tmp/loop_match_files/templates/conf3.d/sub.d/sub_conf1.conf) => {
    "msg": "templates/conf3.d/sub.d/sub_conf1.conf"
}
```

### filetree
* filetree - recursively match all files in a directory tree — Ansible Documentation
    * v2.4 から利用可能
    * item.state で種別が取得できる
        * directory / file / link
        * when と組み合わせる事で file のみを対象にできる(条件に合致しない場合は skip)
    * item.path でファイルパスが取得できる
        * when と組み合わせる事で任意のファイル名や拡張子のみを対象にできる(条件に合致しない場合は skip)

with_filetree に複数指定した場合、with_first_found ロジックが適用される。( item.path の重複が排除される)<br>

```
    - name: local dir files (filetree)
      debug: msg="{{ item.root | replace(playbook_dir + '/', '') }}{{ item.path }}"
      with_filetree:
        - files/
        - templates/
        - test/
      when: item.state == 'file' and item.path is match(".*\.conf$")
```

上記の例は file/、template/、test/ を指定しているが、file/ と template/ 配下は同様のファイル構成のため、template/ 配下は処理されない。<br>
test/ 配下のファイルはファイル名が異なるため処理される。<br>

```
TASK [local dir files (filetree)] **********************************************
skipping: [localhost] => (item={'group': u'wheel', 'uid': 0, 'state': 'directory', 'gid': 0, 'mode': '0755', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf1.d', 'size': 136, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0})
skipping: [localhost] => (item={'group': u'wheel', 'uid': 0, 'state': 'directory', 'gid': 0, 'mode': '0755', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf2.d', 'size': 102, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0})
skipping: [localhost] => (item={'group': u'wheel', 'uid': 0, 'state': 'directory', 'gid': 0, 'mode': '0755', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf3.d', 'size': 102, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0})
ok: [localhost] => (item={'src': u'/tmp/loop_match_files/files/conf1.d/conf1.conf', 'group': u'wheel', 'uid': 0, 'state': 'file', 'gid': 0, 'mode': '0644', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf1.d/conf1.conf', 'size': 0, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0}) => {
    "msg": "files/conf1.d/conf1.conf"
}
ok: [localhost] => (item={'src': u'/tmp/loop_match_files/files/conf1.d/conf2.conf', 'group': u'wheel', 'uid': 0, 'state': 'file', 'gid': 0, 'mode': '0644', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf1.d/conf2.conf', 'size': 0, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0}) => {
    "msg": "files/conf1.d/conf2.conf"
}
skipping: [localhost] => (item={'src': u'/tmp/loop_match_files/files/conf2.d/test.txt', 'group': u'wheel', 'uid': 0, 'state': 'file', 'gid': 0, 'mode': '0644', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf2.d/test.txt', 'size': 0, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0})
skipping: [localhost] => (item={'group': u'wheel', 'uid': 0, 'state': 'directory', 'gid': 0, 'mode': '0755', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf3.d/sub.d', 'size': 102, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0})
ok: [localhost] => (item={'src': u'/tmp/loop_match_files/files/conf3.d/sub.d/sub_conf1.conf', 'group': u'wheel', 'uid': 0, 'state': 'file', 'gid': 0, 'mode': '0644', 'mtime': 1530000000.0, 'owner': 'root', 'path': u'conf3.d/sub.d/sub_conf1.conf', 'size': 0, 'root': u'/tmp/loop_match_files/files/', 'ctime': 1530000000.0}) => {
    "msg": "files/conf3.d/sub.d/sub_conf1.conf"
}
ok: [localhost] => (item={'src': u'/tmp/loop_match_files/test/test.conf', 'group': u'wheel', 'uid': 0, 'state': u'file', 'gid': 0, 'mode': u'0644', 'mtime': 1530000000.0, 'owner': u'root', 'path': u'test.conf', 'size': 0, 'root': u'/tmp/loop_match_files/test/', 'ctime': 1530000000.0}) => {
    "msg": "test/test.conf"
}
```
