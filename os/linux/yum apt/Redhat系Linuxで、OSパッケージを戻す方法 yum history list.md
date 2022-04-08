## [Redhat系Linuxで、OSパッケージを戻す方法](https://qiita.com/sasasin/items/f865848239e7b0a38e06)

### yumでインストール可能なバージョンを調べたい
```
yum --showduplicate list <packagename>
```

### yumで特定のバージョンに戻したい
```
yum downgrade <packagename>-<version>
```

### yumで直前のバージョンに戻したい
```
yum downgrade <packagename>
```

### yumコマンドによる変更履歴を調べたい
直近20回の履歴<br>
```
[root@web01 ec2-user]# yum history list
Loaded plugins: priorities, upgrade-helper
ID     | Login user               | Date and time    | Action(s)      | Altered
-------------------------------------------------------------------------------
   104 | EC2 ... <ec2-user>       | 2016-08-31 17:40 | Install        |   12
   103 | EC2 ... <ec2-user>       | 2016-08-25 11:10 | Install        |    1
   102 | EC2 ... <ec2-user>       | 2016-07-28 12:07 | Update         |    1 EE
   101 | EC2 ... <ec2-user>       | 2016-07-12 14:35 | Install        |    8
   100 | EC2 ... <ec2-user>       | 2016-07-12 14:34 | Update         |    1 EE
    99 | EC2 ... <ec2-user>       | 2016-05-10 12:48 | Update         |    3
    98 | EC2 ... <ec2-user>       | 2016-05-10 12:40 | Update         |    2
    97 | EC2 ... <ec2-user>       | 2016-05-10 12:40 | Update         |    1
    96 | System <unset>           | 2016-05-10 12:31 | Install        |    1
    95 | System <unset>           | 2016-05-10 12:31 | Erase          |    1
    94 | EC2 ... <ec2-user>       | 2016-05-10 12:15 | I, U           |    7 EE
    93 | EC2 ... <ec2-user>       | 2016-03-18 13:14 | E, I, U        |   12 EE
    92 | EC2 ... <ec2-user>       | 2016-03-13 11:11 | Update         |   15
    91 | EC2 ... <ec2-user>       | 2016-03-13 11:10 | Update         |    2
    90 | EC2 ... <ec2-user>       | 2016-03-10 14:44 | Install        |    1
    89 | EC2 ... <ec2-user>       | 2016-03-10 14:43 | Update         |    4 E<
    88 | EC2 ... <ec2-user>       | 2016-03-09 18:46 | Update         |    4 >E
    87 | EC2 ... <ec2-user>       | 2016-03-01 21:58 | Install        |    1
    86 | EC2 ... <ec2-user>       | 2016-03-01 21:57 | Update         |    4 EE
    85 | EC2 ... <ec2-user>       | 2016-02-23 10:29 | Update         |    3
history list
```

全履歴<br>
```
yum history list all
```


### yumコマンドの履歴IDごとの作業内容を調べる
```
[root@web01 ec2-user]# yum history info 96
Loaded plugins: priorities, upgrade-helper
Transaction ID : 96
Begin time     : Tue May 10 12:31:56 2016
Begin rpmdb    : 620:b2548581121a92f05d2abb13a36606703d422fb6
End time       :            12:31:57 2016 (1 seconds)
End rpmdb      : 621:151e4d1786935d2faf91e0a13ccef4836a4ee9d9
User           : System <unset>
Return-Code    : Success
Command Line   : -d0 -e0 -y --disablerepo=* localinstall /var/lib/aws/opsworks/cache.stage2/opsworks_assets/opsworks-ruby22.PVoU39yu/opsworks-ruby22-2.2.5-1.x86_64.rpm
Transaction performed with:
    Installed     rpm-4.11.2-2.73.amzn1.x86_64  @amzn-updates/2015.09
    Installed     yum-3.4.3-137.65.amzn1.noarch @amzn-updates/2015.09
Packages Altered:
    Install opsworks-ruby22-2.2.5.1-1.x86_64 @/opsworks-ruby22-2.2.5-1.x86_64/2015.09
history info
```

### yum install, yum updateなどの作業を取り消したい
履歴ID「96」を取り消すなら。<br>
```
yum history undo 96
```

### まとまった範囲の作業を取り消したい
履歴ID 116 ~ 156 を取り消すなら<br>
```
seq 116 156 \
| sort -r \
| while read F; do
  yum -y history undo $F
done
```
