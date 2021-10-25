## [ワイルドカードでディレクトリを検索して中身をコピーする](https://qiita.com/horit/items/7b77e823a0e4b4027794)

```
- name: ディレクトリを探す
  find:
    paths: /hogehoge/
    patterns: "copy*"
    file_type: directory
  register: find_result

- name: 中身をコピー
  synchronize:
    src: "{{ item.path }}/"
    dest: /fugafuga/copyto/
  with_items: "{{ find_result.files }}"
  delegate_to: "{{ inventory_hostname }}"
 ```

 ### ディレクトリを探す
 まず、findモジュールでディレクトリを探します。<br>
https://docs.ansible.com/ansible/latest/modules/find_module.html<br>

例では/hogehoge/copy*ディレクトリを探しています。<br>
結果をfind_resultに格納します。<br>


### 中身をコピー
synchronizeモジュールでコピーします。<br>
https://docs.ansible.com/ansible/latest/modules/synchronize_module.html<br>

例では事前に探したディレクトリの中身を/fugafuga/copyto/以下にコピーしています。<br>

synchronizeモジュールはローカルからリモートに同期するモジュールですが、<br>
delegate_toキーワードを使うとリモート内で（リモートからリモートに）同期できます。<br>
inventory_hostnameは処理中のリモートのことです。<br>
https://docs.ansible.com/ansible/latest/user_guide/playbooks_delegation.html#delegation<br>

コピー元のパスはfind_result.files.pathに入ってますが、filesが配列になってるので with_items で一つずつ取り出して処理します。<br>
https://docs.ansible.com/ansible/2.4/playbooks_loops.html#using-register-with-a-loop<br>

