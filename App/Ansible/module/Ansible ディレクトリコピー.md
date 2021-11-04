## [Ansibleでローカルのディレクトリをリモートにコピーする](https://qiita.com/petitviolet/items/dbff0b1a949b54efc5af)

synchronizeとcopy<br>

### copy
ファイルをコピーするためのコマンドっぽい<br>
documentのサンプルでも<br>
```
# Example from Ansible Playbooks
- copy: src=/srv/myfiles/foo.conf dest=/etc/foo.conf owner=foo group=foo mode=0644

# The same example as above, but using a symbolic mode equivalent to 0644
- copy: src=/srv/myfiles/foo.conf dest=/etc/foo.conf owner=foo group=foo mode="u=rw,g=r,o=r"

# Another symbolic mode example, adding some permissions and removing others
- copy: src=/srv/myfiles/foo.conf dest=/etc/foo.conf owner=foo group=foo mode="u+rw,g-wx,o-rwx"

# Copy a new "ntp.conf file into place, backing up the original if it differs from the copied version
- copy: src=/mine/ntp.conf dest=/etc/ntp.conf owner=root group=root mode=644 backup=yes

# Copy a new "sudoers" file into place, after passing validation with visudo
- copy: src=/mine/sudoers dest=/etc/sudoers validate='visudo -cf %s'
```

### synchronize
rsyncコマンドを実行するモジュールっぽい<br>
```
# Synchronization of src on the control machine to dest on the remote hosts
synchronize: src=some/relative/path dest=/some/absolute/path

# Synchronization without any --archive options enabled
synchronize: src=some/relative/path dest=/some/absolute/path archive=no

# Synchronization with --archive options enabled except for --recursive
synchronize: src=some/relative/path dest=/some/absolute/path recursive=no
```

recursiveとかあるし、ディレクトリを持って行くにはsynchronizeモジュールが適切っぽく思われる<br>
しかし、synchronizeで実行すると、<br>

```
msg: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
rsync: connection unexpectedly closed (0 bytes received so far) [sender]
rsync error: unexplained error (code 255) at io.c(226) [sender=3.1.1]
```

と出てしまってコピー出来なかった。<br>
sshを使ったrsyncのはずが、何故かパスワードを求められていて、Permission deniedとなってしまっている。<br>

### ディレクトリのコピー
最初のまとめにも書いた通り、<br>

```
copy: src={{ src_dir }} dest={{ dest_dir }}
```
だけで良かった。<br>
なお、ディレクトリを丸ごとコピーするには<br>

```
vars/main.yml
src_dir: /src/path/local_dir
dest_dir: /dest/path/remot_dir
```

とする。<br>
これでローカルの/src/path/のlocal_dirというディレクトリが、リモートの/dest/path/のremote_dirという名前でコピーされる<br>

```
src_dir: /src/path/local_dir/
dest_dir: /dest/path/remot_dir/
```

とすると、<br>
/src/path/local_dir/*が/dest/path/remote_dir/にコピーされる<br>

### リモートからリモートにディレクトリをコピーする場合は
remote_src: yesを設定する<br>
```
  - name: Backup the default settings
    copy:
      src: '{{ src_dir }}'
      dest: '{{ dest_dir }}'
      remote_src: yes
```

---

## [Ansibleの操作対象ホスト上でファイルやディレクトリをコピーする：synchronizeモジュールの振る舞い](https://www.simpline.co.jp/recruit/blog/tech_ty/ansible%E3%81%AE%E6%93%8D%E4%BD%9C%E5%AF%BE%E8%B1%A1%E3%83%9B%E3%82%B9%E3%83%88%E4%B8%8A%E3%81%A7%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%84%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA/)
Ansibleにおいて操作対象ホスト上でファイルやディレクトリをコピーすることはcopyモジュールではできないが、synchronizeモジュールではできるようになっている。<br>
synchronizeモジュールはrsyncを実行させるモジュールであり、他のモジュールにないちょっと特殊な動きをする。
というのもsynchronizeモジュールは通常、”操作対象ホスト”ではなく”Ansibleの実行ホスト”でrsyncが起動されるのだが、にもかかわらずdelegate_toアトリビュートを指定すれば”Ansibleの実行ホスト”でもなく”delegate_toで指定されたホスト”でrsyncが起動されるようにすることができるのである。<br>
synchronizeモジュールは「rsync起動ホスト」から「操作対象ホスト」へのファイルやディレクトリのコピーを行う。1
つまりdelegate_toを使って「rsync起動ホスト」を「操作対象ホスト」と同じものにしてやれば、操作対象ホスト上でファイルやディレクトリをコピーすることができる、というわけである。<br>

操作対象ホストはplaybook中ではinventory_hostnameで取得することができる。<br>
よって以下のようなtaskが操作対象ホスト上でコピーを行う一番単純な形である。<br>
```
- synchronize:
    src: /from_dir/
    dest: /to_dir
  delegate_to: "{{ inventory_hostname }}"
```

コピーではなく移動するならrsync_optsオプションで?remove-source-filesを付ければ良い。<br>
```
- synchronize:
    src: /from_dir/
    dest: /to_dir
    rsync_opts:
    - --remove-source-files
  delegate_to: "{{ inventory_hostname }}"
```

ただし--remove-source-filesでは移動元のファイルは消えるがディレクトリは消えず空ディレクトリが残るので、それも消したければさらにfileモジュールを使って削除する。<br>
（synchronizeモジュールはrsyncを呼び出すため、srcのパスの最後にスラッシュを付けた場合と付けない場合の動作の違いに注意。付けた場合は「/from_dir/*」と見なされることになる）<br>

```
- synchronize:
    src: /from_dir
    dest: /to_dir
    rsync_opts:
    - --remove-source-files
  delegate_to: "{{ inventory_hostname }}"
- file:
    path: /from_dir
    state: absent
```

なお、synchronizeモジュールはrsync起動ホストにrsyncがインストールされていないと当然動作しない。<br>
またそのオプションの多さからかバグ報告数が比較的多い気がするので期待通りの動きをしないことが割とある、かもしれない。<br>

