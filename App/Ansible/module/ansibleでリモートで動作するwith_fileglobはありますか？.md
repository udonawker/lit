## [ansibleでリモートで動作するwith_fileglobはありますか？](https://www.webdevqa.jp.net/ja/ansible/ansible%E3%81%A7%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%88%E3%81%A7%E5%8B%95%E4%BD%9C%E3%81%99%E3%82%8Bwithfileglob%E3%81%AF%E3%81%82%E3%82%8A%E3%81%BE%E3%81%99%E3%81%8B%EF%BC%9F/1056675183/)

残念ながら、すべてのwith_*ループメカニズムはローカルルックアップであるため、Ansibleでこれを実行するための明確な方法はありません。設計によるリモート操作は、接続やインベントリなどに対処する必要があるため、タスクに含める必要があります。<br>
できることは、ホストにシェルアウトし、出力を登録して、出力のstdout_lines部分をループすることにより、ファイルグロブを生成することです。<br>
簡単な例は次のようになります。<br>

```
- name    : get files in /path/
  Shell   : ls /path/*
  register: path_files

- name: fetch these back to the local Ansible Host for backup purposes
  fetch:
    src : /path/"{{item}}"
    dest: /path/to/backups/
  with_items: "{{ path_files.stdout_lines }}"
 ```

 これは、リモートホスト（たとえば、Host.example.com）に接続し、/path/の下にあるすべてのファイル名を取得し、Ansible Hostにコピーしてパス/path/Host.example.com/に戻します。<br>

 ---

 find module を使用してファイルをフィルタリングし、結果のリストを処理します。<br>

 ```
 - name: Get files on remote machine
  find:
    paths: /path/on/remote
  register: my_find

- debug:
    var: item.path
  with_items: "{{ my_find.files }}"
 ```

 ---

 ls /path/*を使用しても機能しなかったので、findといくつかの単純な正規表現を使用してすべてのnginx管理仮想ホストを削除する例を次に示します。<br>

 ```
 - name: get all managed vhosts
  Shell: find /etc/nginx/sites-enabled/ -type f -name \*-managed.conf
  register: nginx_managed_virtual_hosts

- name: delete all managed nginx virtual hosts
  file:
    path: "{{ item }}"
    state: absent
  with_items: "{{ nginx_managed_virtual_hosts.stdout_lines }}"
 ```

 これを使用して、特定の拡張子または他の任意の組み合わせを持つすべてのファイルを見つけることができます。たとえば、ディレクトリ内のすべてのファイルを取得するには、次のようにします：find /etc/nginx/sites-enabled/ -type f。<br>

