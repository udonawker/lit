## [Ansibleでシェルコマンドを実行させるときのノウハウ](https://qiita.com/chroju/items/ec2f7bb87d9ae3603c6a)

### エラーハンドリング
Ansibleはリターンコードが0以外の場合に`failed`と判断するが、シェルコマンドを実行させる際にこの条件だと困ることがある。`ignore_error: True`を使ってエラーを完全に無視させることも可能だが、`register:とfailed_when:`を使った方がより細かく制御できる。
```
- name: check default ruby version
  shell: /home/{{ user_name }}/.rbenv/bin/rbenv version | grep {{ ruby_version }}
  register: ruby_version_check
  failed_when: ruby_version_check.rc not in [0, 1]
```
`register:`は指定した名前の変数にコマンドの実行結果をregisterする。公式ドキュメント上での記載はおそらくここになると思うものの、あまり詳しくなくてモンニョリするのだが、キーバリュー形式でいくつかの値が収まっており、`.hoge`と記述することで値を取り出すことができる。

* rc => リターンコード
* stdout => 標準出力
* stderr => 標準エラー出力
* stdout_lines => 標準出力を1行ずつ出力する（with_items等と組み合わせて使う模様）

上記のyamlではリターンコードを取り出して、0か1以外の場合は`failed`となるよう指定している。`grep`のリターンコードは0と1に限られるので事実上`ignore_error:`と変わらない指定になっているが、例えば0のときに`failed`にもできるし、`stdout`の内容を確認して`failed`させることもできるので、`failed_when:`を使う習慣を身に付けて良さそうに思う。<br>
またregisterした変数はその後のtaskでも引き続き使えるので、コマンド実行結果を`when:`で条件分岐として利用して、taskの実行要否を判断させることができる。上述のyamlでやろうとしているのがまさにそれで、rbenvで指定しているデフォルトのRubyバージョンが想定と異なる場合に限り`rbenv global`を実行させるよう、下記のtaskを続かせている。<br>

```
- name: set default ruby version
  shell: /home/{{ user_name }}/.rbenv/bin/rbenv global {{ ruby_version }}
  when: ruby_version_check.rc == 1
```
