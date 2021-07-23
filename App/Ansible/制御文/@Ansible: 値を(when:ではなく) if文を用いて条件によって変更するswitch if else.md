## [Ansible: 値を(when:ではなく) if文を用いて条件によって変更する](https://qiita.com/hiroyuki_onodera/items/11ea24b40d774b2df755)

### 解1: jinja2のifを使用

```

- unarchive:
    src: >-
      {%- if   ansible_distribution == 'CentOS' -%} foo.trz
      {%- elif ansible_distribution == 'Ubuntu' -%} bar.trz
      {%- else -%}                                  baz.trz
      {%- endif -%}
    dest:  /qux
```
* &gt;- はyamlの構文で、続く節を空白で繋ぎ、最後に改行を付けない。
* {%- -%}はjinja2の構文で、内側ではjinja2の構文を含めることが可能、外側では前後の空白、改行を除去する。
    * 従って、もちろんfoo.trzなどを次の行としても可。お好みで。
* jinja2では、if, elif, else, endif, for, endfor, setなどが使用可能。

#### jinja2をplaybookで使用する場合の考慮事項
* yamlそのものの構文をjinja2にて変更することはできない。
    * あくまでも値などyamlの一要素に対しての変更のみ。

### 解2: Hash|辞書|mapによる対応
```
- vars:
    dist2src:
      CentOS: foo.trz
      Ubuntu: bar.trz
      else: baz.trz
  unarchive:
    src: '{{ dist2src[ansible_distribution]|default(dist2src.else) }}'
    dest:  /qux
```
task varsでHashにて対応を定義し、本文では単に参照。<br>

### 解3: python?によるif文対応

```
- unarchive:
    src: >-
      {{
         'foo.trz' if ansible_distribution == 'CentOS' else 
         'bar.trz' if ansible_distribution == 'Ubuntu' else 
         'baz.trz'
      }}
    dest:  /qux
```

### 解4: ternaryフィルターによる対応

```
- unarchive:
    src: >-
      {{
        (  ansible_distribution == 'CentOS' )|ternary ( 'foo.trz' , (
         ( ansible_distribution == 'Ubuntu' )|ternary ( 'bar.trz' , 
                                                        'baz.trz' )
        ))
      }}
    dest:  /qux
```
3項演算子的に使用可能なternaryフィルターを利用する例。<br>
ansible_distribution == xxxx を括弧で括っているのは、フィルターの優先順位が==よりも高い為。<br>

* [プログラマーのための YAML 入門 (初級編)](https://magazine.rubyist.net/articles/0009/0009-YAML.html)
* [jinja2: Template Designer Documentation](http://jinja.pocoo.org/docs/2.10/templates/)
* [ほげめも: Ansible の Jinja2 を活用する](http://blog.keshi.org/hogememo/2015/12/07/exploiting-ansible-jinja2) リスト(Array)やディレクトリー(Hash)に値を設定する場合には要注意。set _ = は set dummy = などと置き換えると混乱しないか。
* [Ansibleのregisterから任意のディクショナリやリストを生成する - Qiita](https://qiita.com/isobecky74/items/40a2c5a7e89a45eeaf3b)
* [Ansibleで条件を使用して変数値を設定する方法を教えてください。 - 答えられる](https://steakrecords.com/ja/62251-how-can-i-use-a-condition-to-set-a-variable-value-in-ansible-ansible.html)
* [Other Useful Filters](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#id8)

