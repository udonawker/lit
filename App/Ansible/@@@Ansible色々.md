## [φ(.. ) のメモ](https://dekitakotono.blogspot.com/2019/05/blog-post_6.html)

## 基本
* Ansible
* Ansible のインストール : CentOS7.6.1810
* Ansible のインストール : Ubuntu 19.04 desktop
## コマンド
* ansible コマンド
* ansible-playbook コマンド
## 構造 / 構成
* ファイルの配置場所 = ディレクトリレイアウト
* inventory ファイル
* inventory ファイルを使用しないで対象ホストに接続
* playbook ファイル
* targets セクション
* targets セクションの hosts: と ansible-playbook コマンドの -l / --limit オプション
* --list-tasks オプション（タスクの一覧）と --start-at-task オプション（タスクの開始位置の指定）
* vars セクション
* vars_promp - 実行時に変数の値をキーボード入力
* --extra-vars オプション - コマンドラインから変数を渡す
* handlers セクション
* roles - タスクのグループ化
* pre_tasks / post_tasks
* タスクの実行順序
* import_tasks と include_tasks の違い
## 変数
* facts 変数
* magic 変数
* register 変数
## ディレクティブ / キーワード
* async / poll
* become - sudo / su
* block - タスクをまとめる
* changed_when - タスクの変更条件を定義する
* delegate_to - タスクを実行するホストの指定
* failed_when - タスクの失敗条件を定義する
* ignore_errors - タスクのエラーを無視する
* local_action - 管理サーバーでタスクを実行
* Loop - 繰り返し
* loop_var - ループ変数を変更する
* name - play やタスクに名前を付ける
* rescue / always - block 内のエラー処理
* tags - タスクにタグを付ける
* when - 条件判断
## Commands modules
* command – Executes a command on a remote node
* script – Runs a local script on a remote node after transferring it
* shell – Execute commands in nodes.
## Crypto modules
* openssl_privatekey – Generate OpenSSL private keys.
* openssl_publickey – Generate an OpenSSL public key from its private key.
## Files modules
* blockinfile – Insert/update/remove a text block surrounded by marker lines
* copy – Copies files to remote locations
* fetch – Fetches a file from remote nodes
* file – Sets attributes of files
* lineinfile – Manage lines in text files
* read_csv – Read a CSV file
* replace – Replace all instances of a particular string in a file using a back-referenced regular expression.
* stat – Retrieve file or file system status
* template – Templates a file out to a remote server
## Notification modules
* slack – Send Slack notifications
## Packaging modules
* yum – Manages packages with the yum package manager
## System modules
* authorized_key – Adds or removes an SSH authorized key
* firewalld – Manage arbitrary ports/services with firewalld
* group – Add or remove groups
* ping – Try to connect to host, verify a usable python and return "pong" on success
* reboot – Reboot a machine
* systemd – Manage services
* user – Manage user accounts
## Utilities modules
* debug – Print statements during execution
* fail – Fail with custom message
* import_role – Import a role into a play
* import_tasks – Import a task list
* include_role – Load and execute a role
* include_tasks – Dynamically include a task list
* wait_for_connection – Waits until remote system is reachable/usable
