<pre>
★サブスクリプションアカウント登録
[root@localhost ~]# subscription-manager register
登録中: subscription.rhsm.redhat.com:443/subscription
ユーザー名: xxxxxx
パスワード:
このシステムは、次の ID で登録されました: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
登録したシステム名: localhost.localdomain
[root@localhost ~]#

★有効なサブスクリプションの確認
[root@localhost ~]# subscription-manager register
このシステムは既に登録されています。上書きするには  --force を使用します
[root@localhost ~]# subscription-manager list --available
+-------------------------------------------+
    利用可能なサブスクリプション
+-------------------------------------------+
サブスクリプション名:     30 Day Red Hat Enterprise Linux Server Self-Supported Evaluation
提供:                     Red Hat Beta
                          Oracle Java (for RHEL Server)
                          Red Hat Enterprise Linux Server
                          Red Hat CodeReady Linux Builder for x86_64
                          Red Hat Enterprise Linux for x86_64
                          Red Hat Ansible Engine
                          Red Hat Container Images Beta
                          Red Hat Enterprise Linux Atomic Host Beta
                          Red Hat Enterprise Linux Atomic Host
                          Red Hat Container Images
SKU:                      RH00065
契約:                     11920000
プール ID:                yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
管理の提供:               いいえ
数量:                     2
推奨:                     1
サービスレベル:           Self-Support
サービスタイプ:           L1-L3
サブスクリプションタイプ: Instance Based
終了:                     2019年06月07日
システムタイプ:           物理


★サブスクリプション割り当て
# subscription-manager subscribe --pool=yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
サブスクリプションが正しく割り当てられました: 30 Day Red Hat Enterprise Linux Server Self-Supported Evaluation

★サブスクリプション割り当て確認
# subscription-manager list
+-------------------------------------------+
    インストール済み製品のステータス
+-------------------------------------------+
製品名:           Red Hat Enterprise Linux Server
製品 ID:          69
バージョン:       7.5
アーキテクチャー: x86_64
状態:             サブスクライブ済み
状態の詳細:
開始:             2018年08月26日
終了:             2018年09月25日

★サブスクリプション削除
# subscription-manager remove --all
1 ローカル証明書が削除されました。
1 サブスクリプションが、サーバーで削除されました。

★登録解除
[root@localhost ~]# subscription-manager unregister
登録の解除中: subscription.rhsm.redhat.com:443/subscription
システムの登録は解除されました。
</pre>
