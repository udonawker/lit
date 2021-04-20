### 1. rpmファイルダウンロード
#### ■CentOS6
```
http://download.opensuse.org/repositories/network:/ha-clustering:/Stable/CentOS_CentOS-6/noarch/
crmsh-3.0.0-6.1.noarch.rpm
crmsh-scripts-3.0.0-6.1.noarch.rpm
python-parallax-1.0.1-28.1.noarch.rpm
```

#### ■CentOS7
```
http://download.opensuse.org/repositories/network:/ha-clustering:/Stable/CentOS_CentOS-7/noarch/
crmsh-3.0.0-6.2.noarch.rpm
crmsh-scripts-3.0.0-6.2.noarch.rpm
python-parallax-1.0.1-29.1.noarch.rpm
```

#### ■redhat6
```
crmsh-3.0.0-6.1.noarch.rpm
crmsh-scripts-3.0.0-6.1.noarch.rpm
python-parallax-1.0.1-28.1.noarch.rpm
http://ftp.iij.ad.jp/pub/linux/centos-vault/6.7/cr/x86_64/Packages/
redhat-rpm-config-9.0.3-51.el6.centos.noarch.rpm ★Redhat6の場合は←が必要 CentOS6も未確認だが必要？
```

#### ■redhat7
```
crmsh-3.0.0-6.1.noarch.rpm
crmsh-scripts-3.0.0-6.1.noarch.rpm
python-parallax-1.0.1-29.1.noarch.rpm
```

### 2. 1.のディレクトリを指定して`createrepo --database crmsh_repo`
```
# createrepo --database crmsh_repo
```

### 3. `/etc/yum.repos.d/` にリポジトリファイル作成 ex. crmsh.repo
`/tmp/crmsh_repo` に2.で作成したrpmファイル群+repodataを置いた場合<br>
```
[crmsh-Linux-RPM-Packaging]
name=crmsh Linux RPM Packaging
baseurl=file:///tmp/crmsh_repo
enabled=1
gpgcheck=0
```
```
# ls -l /tmp/crmsh_repo
-rwxrwxrwx 1 root root 803456  4月 20 14:18 2021 crmsh-3.0.0-6.1.noarch.rpm
-rwxrwxrwx 1 root root  95732  4月 20 14:18 2021 crmsh-scripts-3.0.0-6.1.noarch.rpm
-rwxrwxrwx 1 root root  37120  4月 20 14:18 2021 python-parallax-1.0.1-28.1.noarch.rpm
-rwxrwxrwx 1 root root  61640  4月 20 14:39 2021 redhat-rpm-config-9.0.3-51.el6.centos.noarch.rpm
drwxr-xr-x 2 root root   4096  4月 20 14:41 2021 repodata
```

### 4. `yum install crmsh`
```
# yum install crmsh

;# yum -c /etc/yum.repos.d/crmsh.repo install crmsh
```
