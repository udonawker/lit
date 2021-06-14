## [expectモジュールを使ったAnsibleでの対話式のプログラム実行の呼び出し](https://zaki-hmkc.hatenablog.com/entry/2020/01/15/221519)

対話式のプログラムなんかをAnsibleで実行したい場合はexpectモジュールを使用する。<br>
なお、以下のライブラリが追加で必要<br>

* pexpect >= 3.3

システムにインストールされていないとエラーになる。<br>
※ インストールが必要なのはコントロールノードでなく、ターゲットノード。もちろんPlaybookでインストールするtaskを書いてよい。<br>

- 実行例
    - プロンプト毎に値を入力する
        - サンプルスクリプト
        - playbook
        - ansible-playbook実行
    - 同じプロンプトに対して順番に違う値を入力する
        - playbook
        - 実行結果
- 余談 ... aliasをぶっこ抜く
