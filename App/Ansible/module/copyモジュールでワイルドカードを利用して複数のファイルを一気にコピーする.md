## [copyモジュールでワイルドカードを利用して複数のファイルを一気にコピーする](https://www.kabegiwablog.com/entry/2018/07/12/100000)

playbook<br>
```
- hosts: dest_server
  tasks:
    - copy:
        src: "{{item}}"
        dest: /home/ec2-user/dest/
      with_fileglob:
        - "/home/ec2-user/src/*.txt"
```

実行結果<br>
```
$ ansible-playbook copy_wild.yml

PLAY [localhost] ************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************
ok: [localhost]

TASK [debug] ****************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "読み込まれたよー"
}

PLAY RECAP ******************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0
```

コピー元<br>
```
$ ls -l /home/ec2-user/src/
合計 0
-rw-rw-r-- 1 ec2-user ec2-user 0  7月  5 14:57 dadada.sh
-rw-rw-r-- 1 ec2-user ec2-user 0  7月  5 14:57 sasasa.txt
-rw-rw-r-- 1 ec2-user ec2-user 0  7月  5 14:57 wawawa.txt
```

コピー先<br>
```
$ ssh ec2-user@192.140.1.215 ls -l /home/ec2-user/dest/
合計 0
-rw-rw-r-- 1 ec2-user ec2-user 0  7月  5 15:05 sasasa.txt
-rw-rw-r-- 1 ec2-user ec2-user 0  7月  5 15:05 wawawa.txt
```
