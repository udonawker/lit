## ブロックデバイスに関する情報を表示する

## blkid
blkid コマンドは利用可能なブロックデバイスに関する以下の情報を表示します。<br>

* LABEL	：	ボリュームラベル
* UUID	：	汎用一意識別子
* TYPE	：	ファイルシステムのタイプ

```
# blkid
/dev/sda1: LABEL="boot" UUID="e1db09d6-01a6-4056-91d6-57816330ed27" TYPE="ext4" PARTUUID="163f1632-01"
/dev/sda2: LABEL="LVM2" UUID="DqPfbS-Vdff-r6DO-pddW-WC43-jI0j-iEDS9i" TYPE="LVM2_member" PARTUUID="163f1632-02"
/dev/sda3: LABEL="LVM3" UUID="L5GnDC-slpU-kR1m-Tb0t-1iuv-EQDb-z8efTv" TYPE="LVM2_member" PARTUUID="163f1632-03"
/dev/mapper/cl-root: LABEL="root" UUID="df6a1046-376c-4e21-8aca-4c48b28e21c7" TYPE="xfs"
```
このように、すべての利用可能なブロックデバイスのラベル、UUID、ファイルシステムタイプが表示されます。なお、引数にデバイス名を指定した場合は、特定のデバイスの情報のみが表示されます。<br>

## lsblk
lsblk コマンドは、以下のように利用可能なブロックデバイスの一覧を表示します。<br>

```
$ lsblk
NAME          MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda             8:0    0   13G  0 disk
├─sda1        8:1    0  512M  0 part /boot
├─sda2        8:2    0  2.5G  0 part
｜└─cl-root 253:0    0 12.5G  0 lvm  /
└sda3          8:3    0   10G  0 part
  └─cl-root 253:0    0 12.5G  0 lvm  /
sr0            11:0    1 1024M  0 rom
```

## cat /etc/fstab
Linuxの起動時に読み込まれる(マウントする)ファイルシステムやパーティションなどの情報を設定するファイルです。<br>

```
$ cat /etc/fstab
/dev/mapper/cl-root     /                       xfs     defaults        0 0
UUID=e1db09d6-01a6-4056-91d6-57816330ed27 /boot                   ext4    defaults        1 2
```
