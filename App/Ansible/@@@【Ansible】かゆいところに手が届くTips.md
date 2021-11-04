## [【Ansible】かゆいところに手が届く12のTips その1](https://qiita.com/Gin/items/653ae4d9a628334cf34b)
## [【Ansible】かゆいところに手が届く12のTips その2](https://qiita.com/Gin/items/58df302714f9a28048c5)

### shell moduleでの状態確認にchangedは出したくない
changed_when: falseをつける<br>
```
shell: systemctl get-default
changed_when: false
```

### 変数が未定義の時の判定
is definedを使う<br>

```
- copy:
    src: "{{ host }}"
    dest: /etc/hosts

  when: host is defined
```

### 配列が空の場合にエラーを出さない
default([])を使う<br>

```
- sysctl:
    name: "{{ item.name }}"
    value: "{{ item.value }}"

  with_items:
    - "{{ KERNELPARAMETER_LIST | default([]) }}"
```

### 多重配列をループさせたい
with_subelementsを使う<br>
```
userlist:
  - name: user1
    uid: 100
    groups:
      - user1
      - wheel
```
```
user:
  name: "{{ item.0.name }}"
  uid: "{{ item.0.uid }}"
  group: "{{ item.1 }}"

with_subelements:
  - "{{ userlist }}"
  - groups
```

### 現在時刻を取得したい
lookupを使う<br>
```
date: "{{ lookup('pipe','date +%Y%m%d%H%M') }}"
```

### ローカルに作業前のバックアップ領域を作成したい
```
- file:
    path: "/tmp/{{ lookup('pipe','date +%Y%m%d%H%M') }}"
    state: directory
    mode: 0777
    owner: root
    group: root
  connection: local
  run_once: True
  changed_when: False
```

### handlerを即座に実行したい
meta: flush_handlersを使う。<br>
notifyを利用してhandlerを呼び出した場合、handlerが実行されるのは、いずれかです。<br>

* pre_task/tasks/post_taskセクションの終了時
* roleを呼び出したtasksセクションの終了時

即座に実行させるためには、以下のようにします。<br>
```
tasks:
   - shell: some tasks go here
   - meta: flush_handlers
   - shell: some other tasks
```

### Ansibleの変数の優先順位
↑弱い↓強い<br>

```
- role defaults [1]
- inventory vars [2]
- inventory group_vars
- inventory host_vars
- playbook group_vars
- playbook host_vars
- host facts
- registered vars
- set_facts
- play vars
- play vars_prompt
- play vars_files
- role and include vars
- block vars (only for tasks in block)
- task vars (only for the task)
- extra vars (always win precedence)
```

## 変数のスコープについて
Ansibleの変数のスコープは以下の３つです。<br>

|種類|内容|
|:--|:--|
|Global|コンフィグや環境変数やコマンドラインでセットされたもの|
|Play|それぞれのPlaybookごとに設定された値やinclude_varsの値|
|Host|実行されたホストごとの変数、gather_factsで収集した値や、registerで登録した値などそれぞれ独立しています|

そのため、role内で定義した変数も別のroleに引き継がれます。変数は被らないように注意しましょう。<br>

### Jinja2のtemplateはとても便利
template内でifやforが使え、自由度の高い記載が行えます。<br>
ここを参考にすると良いです。<br>
[Template Designer Documentation](http://jinja.pocoo.org/docs/dev/templates/)

hosts.j2<br>
```
{% for item in HOST_LIST %}
{{ item }}
{% endfor %}
```
ntp.conf.j2<br>
```
・・・
{% for hostname in NTP_LIST %}
{% if loop.first %}
server {{ hostname }} iburst minpoll 4 maxpoll 5 prefer
{% else %}
server {{ hostname }} iburst minpoll 4 maxpoll 5
{% endif %}
{% endfor %}
・・・
```

### 仮想マシン作り直したらAnsibleが届かなくなった
SSHコマンドは通るのになぜー？<br>

```
rhel7 | UNREACHABLE! => {
    "changed": false,
    "msg": "ERROR! SSH Error: data could not be sent to the remote host. Make sure this host can be reached over ssh",
    "unreachable": true
}
```

/var/log/secure<br>
```
Mar 14 17:41:42 localhost sshd[5796]: Connection closed by x.x.x.x [preauth]
```

以下のいずれかを実施しましょう。<br>

* known_hostsに前のデータが残っている場合があるので削除
* ansible.cfg内のANSIBLE_HOST_KEY_CHECKING=Falseのコメントを外す

### User用のパスワードの生成
```
python -c 'import crypt; print crypt.crypt("パスワード", "$1$SomeSalt$")'
```

参考:[AnsibleのUserモジュールでpasswordを設定する時の注意](http://longkey1.net/blog/2014/01/22/ansible-add-user-password/)

### OSユーザのパスワードは事前にハッシュ化しなくてもいい！
password_hashを使う<br>

以前お伝えしたテクニックでは事前に暗号化しておく手順でしたが、リファレンスをよくよく見ると暗号化してくれる書き方がありました。<br>
以下に対応しています。<br>
* sha256
* sha512

使い方<br>
```
  - name: ユーザー作成
    user:
      name: test
      #SHA256の時はこちら
      password: "{{ 'password' |password_hash('sha256', 'mysecretsalt') }}"
      #SHA512の時はこちら
      password: "{{ 'password' |password_hash('sha512', 'mysecretsalt') }}"
      home: /home/test
```

ただし注意点として、以下のように変数をリスト化しループを回した場合、実行結果にパスワードが平文で流れてしまいます。<br>

```
  vars:
    test:
      - name: test1
        password: password
        home: /home/test1

      - name: test2
        password: password
        home: /home/test2

  tasks:
    - user:
        name: "{{ item.name }}"
        password: "{{ item.password |password_hash('sha256', 'mysecretsalt') }}"
        home: "{{ item.home }}"
      with_items:
        - "{{ test }}"
```

passwordが平文で見える！<br>

```
PLAY ***************************************************************************

TASK [user] ********************************************************************
changed: [rhel6_d] => (item={u'home': u'/home/test1', u'password': u'password', u'name': u'test1'})
changed: [rhel6_d] => (item={u'home': u'/home/test2', u'password': u'password', u'name': u'test2'})
```

なので、リスト化する場合はno_log: Trueをつけ、出力しないようにします。<br>

```
  vars:
    test:
      - name: test1
        password: password
        home: /home/test1

      - name: test2
        password: password
        home: /home/test2

  tasks:
    - user:
        name: "{{ item.name }}"
        password: "{{ item.password |password_hash('sha256', 'mysecretsalt') }}"
        home: "{{ item.home }}"
      with_items:
        - "{{ test }}"
      no_log: True
```

こうなります<br>

```
TASK [user] ********************************************************************
changed: [rhel6_d] => (item=(censored due to no_log))
changed: [rhel6_d] => (item=(censored due to no_log))
```

### role内変数を、role内のみで使うプライベート変数にする
private_role_vars = yesを使う<br>

roleで呼び出された・定義された変数は、別のroleに処理が移っても引き継がれます。<br>
Ansibleの変数命名ルールにて、先頭にrole名をつけろと記載されているのもそのためです。<br>
しかし、そうもできない場合はroleの中で変数を閉じる必要がありますのでansible.cfgに以下の記載を追記します。<br>
<br>
ansible.cfg<br>

```
private_role_vars = yes
```

### Ansibleモジュール内で*（アスタリスク）を使用する
with_fileglobを使う<br>

```
- copy: 
    src: {{ item }} 
    dest: /path

  with_fileglob:
    - "/etcsysconfig/network-scripts/ifcfg-*"
```

ちなみにfetchモジュールで、with_fileglobを使用すると出力はOKとでるのにファイルが取得されないケースがあります。<br>
これは、with_fileglobの解決がローカルホストで行われるのに対し、fetchはターゲットマシン（構成管理対象サーバー）で実施されるためです。<br>
そのため、*指定をしたい場合には、shellモジュールでfind検索を実施し、registerで登録した値をwith_itemsに入れるやり方となります。<br>

### RPMパッケージをインストールさせたい
yum モジュールを使う<br>

yumモジュールでは、nameアトリビュートにてフルパスでの指定ができるため、ローカル上のRPMファイルを指定することでインストールが可能です。<br>

```
yum:
  name: xxxxx.rpm
  state: present
```

参考:[Ansible で RPM を扱う](http://qiita.com/dayflower/items/21c64a6f5da155a5ade3)

### become使用時にsudoパスワードを自動入力したい
ansible_become_passを使う<br>

自動入力ができない！ということで、sudo時のパスワードをNOPASSWDにしている皆さん朗報です。<br>
以前はsudo_passwordとかありましたが、becomeが推奨されてからはansible.cfg内では指定できなくなりました。じゃあどうするのか！というと、ansible_become_passが用意されています。<br>

こいつの使い方は2通りあります。<br>

* インベントリファイルで指定
* 変数ファイルで指定（変数として作成する）

インベントリファイルの場合<br>
```
[target]
hostname1 ansible_become_pass=xxxx
```

変数ファイルの場合<br>
```
ansible_become_pass: xxxx
```

#### 発展ケース（環境変数渡し）
変数ファイルの場合<br>
```
ansible_become_pass: "{{ lookup('env','SUDO_PASSWD') }}"
```

### ansible-vault使用時にパスワードを環境変数で渡したい
JenkinsなどのCIツールを使用している場合や、vaultのパスワードファイルを残しておきたくない場合に使えるテクニックです。<br>
`--vault-password-file`を使います。<br>
`--vault-password-file`は引数にファイルだけではなく、実行権限の付与されたスクリプトを取ることができ、その標準出力をパスワードとして利用することができます。<br>
つまり、環境変数をスクリプトで解析し標準出力させることで、vaultパスワードをローカルに残す必要がなくなります。<br>
ダイナミックインベントリ的な使い方ですね。<br>

vault.sh<br>
```
#!/bin/bash
echo $VAULT_PASS
```

bash<br>
```
export VAULT_PASS=xxx
ansible-playbook site.yml --vault-password-file vault.sh
```

#### メモ
プロセス置換を利用して、シェルすら作りたくない！という場合はMacのみプロセス置換にて以下が可能です。（CentOSではできなかった）<br>

bash<br>
```
ansible-playbook site.yml --vault-password-file <(echo $VAULT_PASS)
```

Centos系のLinuxではプロセス置換時に一時ファイルを以下のようにpipe:[xxxxxxxx]で管理しています。<br>

```
[server ]# ll <(date)
lr-x------ 1 root root 64  4月  8 11:01 /dev/fd/63 -> pipe:[24349835]
```

ansible-vaultコマンド実行時に読み込まれる以下のファイルでは、os.path.realpath（実際のファイルのパスを参照する）とかかれているためにpipe:[xxxxxxxx]が読まれてしまいうまく動作しないようです。（realpathを取り除くとうまくいった）<br>

```
this_path = os.path.realpath(to_bytes(os.path.expanduser(vault_password_file), errors='strict'))
if not os.path.exists(to_bytes(this_path, errors='strict')):
  raise AnsibleFileNotFound("The vault password file %s was not found" % this_path)
```

MacではCentosとプロセス管理の仕組み（proc周辺）が異なるため、プロセス置換でもうまくいくようです。<br>

### 何回も書く必要のあるパラメーターをまとめる！
YAMLのマージ記法を使う。<br>
参考: [ansible-playbook内でもYAMLのマージ記法が使えます!](http://qiita.com/tbuchi888/items/2ff64060290bcabc721e)

```
 - file:
     path: /tmp/a
     << : &DEF
       owner: ansible
       group: ansible
       mode: 0755
       state: directory
 - file:
     path: /tmp/b
     << : *DEF
```

DEF変数にowner/group/mode/stateの設定をいれ、それを使いまわしています。これにより次回以降のパーミッション周りの設定をすっきりさせています。（変数名はなんでもよいです<< : &と<< : *が大事）<br>

### Ansibleでevalチックな変数の中に変数がある場合
```
{{ somvar_{{other_var}} }}
```

こういうことしたいときは、以下のようにします。<br>
```
{{['somevar_'  + other_var] }}

host_varsを使ってる時はこっちらしい
{{ hostvars[inventory_hostname]['somevar_'  + other_var] }}
```

