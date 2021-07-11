## [Ansibleのタスクを適度に待たせて適切なタイミングで実行したい 2018/12/10](https://qiita.com/chataro0/items/6005da37b0d21dc1581f)

* 特定の時間待つ/手動で再開を支持する
    * [pauseモジュール](https://docs.ansible.com/ansible/latest/modules/pause_module.html)
* ポートの応答を待つ
    * [wait_forモジュール](https://docs.ansible.com/ansible/latest/modules/wait_for_module.html)
* 取得した値が特定の値になるのを待つ
    * [Do-Until Loops](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#do-until-loops)
