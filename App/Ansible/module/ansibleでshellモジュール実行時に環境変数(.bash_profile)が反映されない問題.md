## [ansibleでshellモジュール実行時に環境変数(.bash_profile)が反映されない問題](https://www.bunkei-programmer.net/entry/2015/05/16/162020)

## 2通りの解決策

### 1. shellモジュールを使う時は必ずログインシェルとして実行する

```
- name: install ruby
  shell: bash -lc "rbenv install {{ ruby_version }}"
```
このように「-l」オプションを付けてbashコマンドを実行する事で、ログインシェルとして実行する事で、.bash_profile等を読み込む事ができ、rbenvコマンドが参照できるようになります。<br>

#### メリット
必要な時だけログインシェルとして実行して各種設定ファイルを読み込むので、shellモジュール実行時のオーバーヘッドが最小限になる。<br>

#### デメリット
.bash_profile等に記述した環境変数上にあるバイナリを実行する際は、毎回「/bin/bash -l」等と書かなくてはならず、面倒だし冗長になる。<br>
また、ダブルクォートで挟むので、sed等のコマンドでシングル・ダブルクォートが、壊れないよう注意する必要がある。<br>

### 2. ansible.cfgにexecutableを追加してしまう

ansible.cfgに以下のように記述してしまう事で、shellコマンド実行時は必ずログインシェルとして実行するようにしてしまいます。<br>

```
[defaults]
executable = /bin/bash -l
```

#### メリット
shellモジュール実行毎に「/bin/bash -l」を書かなくて済むのでplaybookがシンプルになる。<br>

#### デメリット
shellモジュール実行時はログインシェルを都度読み込んでしまい、オーバーヘッドが発生する。（shellだけでなくexecutables属性があるモジュール全てにいえるかもしれません）<br>
