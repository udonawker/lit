## [Ansible 2.8 リリース、便利機能や注意点まとめ](https://tekunabe.hatenablog.jp/entry/2019/05/16/ansible28)

## 変更
### 全体
* ★ PLAY RECAP に skipped、rescued、ignored 追加
* ★ retry file の生成がデフォルトで無効に

### 権限昇格
* ★ ansible-playbook コマンドの --sudo などの権限昇格方式固有の引数は削除されて --become に統一
* become パスワードプロンプトがデフォルトで BECOME password: に
* become が plugin 化

### ansible-galaxy
* ansible-galaxy install サブコマンドに --force-with-deps オプション追加

### 制御 / jinja2 / 変数
* import_tasks 自体を notify で呼び出しできなくなる
* loop 内 ループインデックスなどが利用可能に（ansible_loop.index0 など）
* ★ jinja2 で現在時刻を now() で取得可能に
* ★ 未定義変数へのアクセス柔軟性が向上
* inclide_role、import_role で from_handlers オプションが利用可能に
* ★ register 変数名等でテンプレートが使用不可に
* PLAY の名前を示す ansible_play_name マジック変数が追加
* 認証情報の変数名の標準化 (ansible_user、ansible_password など)
* ★ 文字列変換時の WARNING
* notify で handler 名を呼び出す際、中間一致で呼び出してしまう

### インベントリ
* ★ Netbox をインベントリとして利用可能に
* Gitlab runners をインベントリとして利用可能に
* ★ グループ名に利用できる文字の厳格化

### 環境
* ★ paramiko が同梱されなくなる
* macOS でコネクションプラグインに smart の場合、paramiko の代わりに ssh をデフォルトで利用
* Python Interpreter Discovery
* Ansible Collections

### ファイル
* copy モジュールで remote_src 有効時でも再帰コピーをサポート

### システム
* ★ Windows ホストへの SSH 接続サポート（experimental）
* パスワードなしの権限昇格

### ネットワーク
* ＊_config にバックアップファイルのパスを変更できる backup_options オプション追加
* persistent command_timeout のデフォルト値が変更 (10秒から30秒へ)
* panos_* (PaloAlto) モジュールが 非推奨（deprecated）に
* cli_config モジュール にコンフィグバックアップする backup オプション追加
* ios_facts モジュールで config 取得時に Building configuration などの不要な行を削除するように

## 新規プラグイン
### コネクションプラグイン
* vmware_tools
* napalm
* podman

### インベントリプラグイン
* docker_swarm
* gitlab_runners
* netbox

### Lookup
* aws_secret
* rabbitmq

## 新規モジュール
### Cloud
* ali_＊ 新規対応 (Alicloud)
* podman_＊ 新規対応

### Files
* ★ read_csv: CSVファイルをリストやディクショナリとして読み込む

### Monitoring
* zabbix_action
* zabbix_map

### Net Tools
* netbox_＊ 新規対応

### Network
* checkpoint_＊ 新規対応
* eos_bgp
* fortios_＊ 200モジュール以上追加
* ★ ios_bgp
* ios_ntp
* iosxr_bgp
* restconf_＊ 新規対応
* junos_config に commit_check オプション追加

### Notification
* rabbitmq_publish

### Source Control
* gitlab_runner

### System
* gather_facts
    * https://docs.ansible.com/ansible/2.8/modules/gather_facts_module.html
