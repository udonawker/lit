## [Ansible: 値を(when:ではなく) if文を用いて条件によって変更する](https://qiita.com/hiroyuki_onodera/items/11ea24b40d774b2df755)

* whenを使用すると冗長
* 解1: jinja2のifを使用
* jinja2をplaybookで使用する場合の考慮事項
* 解2: Hash|辞書|mapによる対応
* 解3: python?によるif文対応
* 解4: ternaryフィルターによる対応
