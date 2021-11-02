## [Ansible Jinja2 select selectattr を使った配列と辞書のフィルタリング](https://zaki-hmkc.hatenablog.com/entry/2021/02/18/000228)

* 配列 (select)
    * 数値 (一致・大小)
    * 文字列 (一致・大小)
    * 正規表現
    * 型でフィルタリング
    * ファイルパス
    * バージョン文字列
    * 含む (in)
* 辞書 (selectattr)
    * キーが存在するか
    * キーnameの値との一致
    * 値に対する正規表現
    * 含む (contains)
    * 含む (in)
* (おまけ) reject() / rejectattr()
* 見るべきドキュメント等
    * select() / selectattr() フィルター本体
    * Jinja2 Tests
    * Ansible Tests
* まとめ
    * (疑問 追記あり) builtin 以外の Filter / Test は…
* サンプルplaybook (on GitHub)
