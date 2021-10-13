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
