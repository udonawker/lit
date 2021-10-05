## [Ansibleのlookup pluginについて調べてみた](https://qiita.com/yunano/items/4325935b8567572cc172)

* lookup pluginはwith_*の処理、つまりloopを作るための処理が書かれたプラグインである。
* 他にlookup('プラグイン名', 引数)の形で呼び出すこともできる。
* lookup pluginはAnsibleを実行しているコンピュータで実行される。操作対象のコンピュータ上ではない。
* pluginはPythonで実装される。
* 自作したlookup pluginはplaybookのあるディレクトリにlookup_pluginsというディレクトリを作り配置するか、ansible.cfgの[defaults]セクション、lookup_plugins項に指定されたディレクトリに配置すると利用できる。

参考とした公式ドキュメントは次である。<br>
http://docs.ansible.com/playbooks_lookups.html<br>
http://docs.ansible.com/playbooks_loops.html<br>
