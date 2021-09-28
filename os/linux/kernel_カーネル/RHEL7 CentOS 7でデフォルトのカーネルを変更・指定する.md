## [CentOS 7でデフォルトのカーネルを変更・指定する](https://qiita.com/kojiwell/items/9b5c18f399642a0679e9)

CentOS 7でカーネルをビルドする機会があったので、デフォルトのカーネルを変更する方法をメモしておきます。テキストエディタで`grub.cfg`を編集するものだとすっかり思い込んでたのでしばらく`grub.cfg`をじーーっと眺めてたのですが、調べてみたところ準備されている`grub2-set-default`コマンドで変更できます。<br>


### 現在のデフォルトを調べる

```
[root@host ~]# grub2-editenv list
saved_entry=CentOS Linux (3.10.0-327.el7.x86_64) 7 (Core)
```

### カーネルのリストを表示する
```
[root@host ~]# awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
0 : CentOS Linux (3.10.0-327.3.1.el7.x86_64.debug) 7 (Core)
1 : CentOS Linux (3.10.0-327.3.1.el7_lustre.x86_64) 7 (Core)
2 : CentOS Linux (3.10.0-327.el7.x86_64) 7 (Core)
3 : CentOS Linux (0-rescue-6eb4b54119134fe79ebe5bf35fbf8018) 7 (Core)
```

boot方式によっては以下<br>
```
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2-efi.cfg
```

### 利用したいカーネルをデフォルトに設定する
例えば`1 : CentOS Linux (3.10.0-327.3.1.el7_lustre.x86_64) 7 (Core)`に変更する場合は下記の通りです。<br>

```
[root@host ~]# grub2-set-default 1
[root@host ~]# grub2-editenv list
saved_entry=1
```
NOTE: カーネルのリストが0(ゼロ)から始まっている点に気をつけて下さい。<br>


### 再起動して確認する
再起動してログインすると、下記のように指定したカーネルになっていることが確認できると思います。<br>
```
[root@host ~]# uname -r
3.10.0-327.3.1.el7_lustre.x86_64
```


### 参考リンク
[Setting Up grub2 on CentOS 7](https://wiki.centos.org/HowTos/Grub2)
