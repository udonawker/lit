## [Ansibleでリモートからローカルにファイルをコピーする方法](https://nobiemon.hatenablog.com/entry/2020/10/16/101034)

## やりたいこと
* Ansibleコマンド実行しているマシン（ローカル）に操作しているマシン（リモート）からファイルをコピーしたい。
* Ansibleで構成管理を行う前に、すでに内容がバラバラバラになっている設定ファイルの内容をかき集めて確認したい。

## 使用モジュール
[ansible.builtin.fetch – Fetch files from remote nodes — Ansible Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/fetch_module.html)<br>

## サンプル
```
tasks:
- name: fetch httpd.con
  fetch:
   src:   /etc/httpd/conf/httpd.conf
   dest:  /root/{{ ansible_host }}_httpd.conf
   flat:   yes
```

### ポイント

fetchという専用のモジュールがあるのでそれを使用する。<br>
srcがリモートのパスで、destがクライアントのパスになる。<br>
普段はあまり意識しないと思うが、要はcopyモジュールやtemplateモジュールの逆を行っている。<br>
この例では2台以上のリモートマシンを扱う場合を考慮して、fetchしたファイル名にマジック変数でリモートのIPを付与して上書きしないようにしている。<br>

## [fetch モジュール](https://dekitakotono.blogspot.com/2019/05/fetch.html)
## 例
■ 対象ホストからパス名を維持したままでファイルをコピーする<br>
```
    - name: 対象ホスト上の /tmp/somefile ファイルを ./fetched フォルダにコピーする
      fetch:
        src: /tmp/somefile
        dest: ./fetched
```
dest: で指定したディレクトリの構造<br>
dest: で指定したディレクトリ内に host 名 - src: で指定したファイルのパス名 のディレクトリが作成され、その中にファイルが格納される<br>

```
.
└── fetched
     └── node-c0706
         └── tmp
             └── somefile
```

■ flat: yes を指定して、ファイルだけをコピーする<br>
```
    - name: 対象ホスト上の /tmp/somefile ファイルを ./fetched フォルダにコピーする
      fetch:
        src: /tmp/somefile
        dest: ./fetched/
        flat: yes
```

dest: で指定したディレクトリの構造<br>
 dest: で指定したディレクトリ内に src: で指定したファイルが格納される。ホスト名や src: で指定したファイルのパスは含まれない。<br>

```
.
└── fetched
     └── somefile
```

■ fail_on_missing: no を指定して対象ホスト上にコピー対象のファイルがない場合でもエラーにしない<br>
```
    - name: 対象ホスト上の /tmp/oterfile ファイルを ./fetched フォルダにコピーする(失敗してもエラーにしない)
      fetch:
        src: /tmp/otherfile
        dest: ./fetched/
        flat: yes
        fail_on_missing: no
```
