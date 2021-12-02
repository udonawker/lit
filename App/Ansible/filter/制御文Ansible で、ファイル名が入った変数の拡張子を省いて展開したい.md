## [Ansible で、ファイル名が入った変数の拡張子を省いて展開したい](https://ja.stackoverflow.com/questions/31490/ansible-%E3%81%A7-%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E5%90%8D%E3%81%8C%E5%85%A5%E3%81%A3%E3%81%9F%E5%A4%89%E6%95%B0%E3%81%AE%E6%8B%A1%E5%BC%B5%E5%AD%90%E3%82%92%E7%9C%81%E3%81%84%E3%81%A6%E5%B1%95%E9%96%8B%E3%81%97%E3%81%9F%E3%81%84)

1つ以上の拡張子をリストに分割する splitext というフィルタがあるので、それを通してから最初の要素を取り出せば、拡張子全てを除いたファイル名が得られるかと。<br>

```
---
- name: test ansible
  hosts: localhost
  user: ubuntu
  vars:
    file_name: "hoge.txt"
  tasks:
    - name: Hello server
      debug:
        msg: "Expand file_name Result: {{ file_name | splitext | first }}"
```

Playbookを作らず試すならこんな感じですね。<br>
```
$ ansible localhost -m debug -a "msg={{'hoge.txt' | splitext | first }}"
```

他にもファイルパスに関する様々なフィルタが用意されています。<br>
http://docs.ansible.com/ansible/playbooks_filters.html#other-useful-filters
