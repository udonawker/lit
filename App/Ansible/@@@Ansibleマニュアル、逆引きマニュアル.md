## [マニュアル: Ansible](https://www.ikemo3.com/manual/ansible/)

* 独自ドメインを作りました
* 環境変数
* 設定
* adhoc実行
* よく使う起動オプション
* 環境変数
* インベントリファイル
    * 1つのホストに2つのポートは設定できない(回避策あり)
* 変更があったときだけ実行
* 変数定義
    * set_fact
* notify
    * ハンドラが呼ばれるタイミング
    * ハンドラを強制的に呼ぶ方法
    * ハンドラで複数のタスクをこなす方法
* ロール
* ループ
* モジュール
    * ファイルの展開
    * ファイルの取得(ダウンロード)
    * 文字列置換
    * AWS
    * MySQL
    * Google Cloud
* テンプレート
    * フィルタ
* 個人的に気をつけていること
    * ディレクトリ構成

## 公式サイト
* [Ansible Documentation](https://docs.ansible.com/)
* [ansible-playbook ? Ansible Documentation](http://docs.ansible.com/ansible/latest/ansible-playbook.html)
* [ansible ? Ansible Documentation](http://docs.ansible.com/ansible/latest/ansible.html)
* [Patterns ? Ansible Documentation](http://docs.ansible.com/ansible/latest/intro_patterns.html)

## 外部サイト
* [Ansible マジック変数の一覧と内容 - Qiita](https://qiita.com/h2suzuki/items/15609e0de4a2402803e9)
* [Ansible オレオレベストプラクティス - Qiita](https://qiita.com/yteraoka/items/5ed2bddefff32e1b9faf)
* [Ansibleのplaybookで使用できるアトリビュートの一覧 - Qiita](https://qiita.com/yunano/items/8494e785390360011a88)
* [jinja2 - Ansible: Get all the IP addresses of a group - Stack Overflow](https://stackoverflow.com/questions/36328907/ansible-get-all-the-ip-addresses-of-a-group)
* [ansible で prompt (入力待ち) の実現とその周辺テクニックのまとめ - Qiita](https://qiita.com/waterada/items/5f3e5d776c50f2aadec4)

## 関連項目
* [辞書: Ansible](https://www.ikemo3.com/dic/ansible/)
* [タグ: Ansible](https://www.ikemo3.com/tags/ansible/)
* [マニュアル: Ansible Container](https://www.ikemo3.com/manual/ansible-container/)

## [逆引きマニュアル]
* [Ansible: tarファイルをディレクトリ指定で展開する方法](https://www.ikemo3.com/inverted/ansible/extract-tar-with-directory/)<br>
* [Ansible: ドキュメントをローカルで表示する方法](https://www.ikemo3.com/inverted/ansible/create-docs-locally/)<br>
* [Ansible 2.7でyum + with_itemsを使うと出る警告の直し方](https://www.ikemo3.com/inverted/ansible/2.7-yum/)<br>
* [Ansibleでリブートする方法](https://www.ikemo3.com/inverted/ansible/reboot/)<br>
* [Ansible: Mavenアーティファクトの利用方法](https://www.ikemo3.com/inverted/ansible/maven-artifact/)<br>
* [Ansible: 開発環境と本番環境を同じように管理する方法](https://www.ikemo3.com/inverted/ansible/development/)<br>
* [Ansible: チェックモードでエラーが起きて停止してしまう場合の修正](https://www.ikemo3.com/inverted/ansible/fix-error-in-check-mode/)<br>
* [Ansible: 文字列からファイルを作成](https://www.ikemo3.com/inverted/ansible/create-from-string/)<br>
* [Ansible + Vagrant + CentOS: パスワード認証を有効化する](https://www.ikemo3.com/inverted/ansible/enable-password-authentication/)<br>
* [Ansible: command,shellモジュールの結果を検証したい場合](https://www.ikemo3.com/inverted/ansible/check-command-and-shell-result/)<br>
* [Ansible: sudoで環境を引き継ぎたい場合](https://www.ikemo3.com/inverted/ansible/sudo-environment/)<br>
* [Ansible: ルーティング対応](https://www.ikemo3.com/inverted/ansible/routing/)<br>
* [Ansible: 設定の外部ファイルによる管理](https://www.ikemo3.com/inverted/ansible/use-external-setting/)<br>
* [Ansible: 対象ホストを間違えないようにする方法](https://www.ikemo3.com/inverted/ansible/restrict-target-host/)<br>
* [Ansible: 相対パスでシンボリックリンクを作成する方法](https://www.ikemo3.com/inverted/ansible/create-relative-symbolic-link/)<br>
* [タスクを部分的に実行する](https://qiita.com/noel9109/items/fb9c52aab90324cb0e9a#%E3%82%BF%E3%82%B9%E3%82%AF%E3%82%92%E9%83%A8%E5%88%86%E7%9A%84%E3%81%AB%E5%AE%9F%E8%A1%8C%E3%81%99%E3%82%8B)
    * タスクにタグを付け、オプションでタグを指定する。タスクのまとまり毎に同じタグを付ける
* [対象サーバのホスト名を変数にセットする](https://qiita.com/noel9109/items/fb9c52aab90324cb0e9a#%E5%AF%BE%E8%B1%A1%E3%82%B5%E3%83%BC%E3%83%90%E3%81%AE%E3%83%9B%E3%82%B9%E3%83%88%E5%90%8D%E3%82%92%E5%A4%89%E6%95%B0%E3%81%AB%E3%82%BB%E3%83%83%E3%83%88%E3%81%99%E3%82%8B)
    * {{ inventory_hostname }}
