## [フィルター](https://docs.ansible.com/ansible/2.9_ja/user_guide/playbooks_filters.html)

* フィルター
    * データフォーマットのフィルター
    * 定義する変数の強制
    * 未定義変数のデフォルト設定
    * パラメーターの省略
    * リストのフィルター
    * 集合論フィルター
    * ディクショナリーフィルター
    * items2dict filter
    * zip フィルターおよび zip_longest フィルター
    * サブ要素フィルター
    * ランダムの MAC アドレスフィルター
    * 乱数フィルター
    * シャッフルフィルター
    * 計算
    * JSON クエリーフィルター
    * IP アドレスフィルター
    * ネットワーク CLI フィルター
    * ネットワーク XML フィルター
    * ネットワーク VLAN フィルター
    * ハッシュフィルター
    * ハッシュ/ディクショナリーの統合
    * コンテナーからの値の抽出
    * コメントフィルター
    * URL Split フィルター
    * 正規表現フィルター
    * Kubernetes フィルター
    * 他の有用なフィルター
    * 組み合わせフィルター
    * 製品フィルター
    * デバッグフィルター
    * コンピューター理論のアサーション
    * 人間が読み取り可能
    * 人間からバイト


```
- name set_fact
  set_fact:
    test_var: '/path/to/file'
  
- name debug basename
  debug: var='{{ test_var | basename }}'
  # file

- name debug dirname
  debug: var='{{ test_var | dirname }}'
  # /path/to
```
