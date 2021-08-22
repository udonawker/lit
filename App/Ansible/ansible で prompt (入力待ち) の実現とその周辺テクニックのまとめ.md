## [ansible で prompt (入力待ち) の実現とその周辺テクニックのまとめ](https://qiita.com/waterada/items/5f3e5d776c50f2aadec4)

ansible でキー入力待ちを実現するには pause というモジュールを使います。<br>

## ■「Enterキーを押してください」

tasks<br>
```
- name: confirm
  pause: prompt="Enterキーを押してください"
```
nameがあることで下記の出力にできる<br>
```
TASK: [confirm] ***********************************
[webservers]
Enterキーを押してください:
```

__ちょいテク: 出力を汚さないために name を使う:__<br>
nameがない場合はちょっと出力がカッコ悪い<br>
```
TASK: [pause prompt="Enterキーを押してください"] ****
[webservers]
Enterキーを押してください:
```
nameがあれば<br>
```
TASK: [confirm] ***********************************
[webservers]
Enterキーを押してください:
```

## ■y/nで確認
```
- name: confirm
  pause: prompt="このまま進めて良いですか？ (y/n)"
  register: yn

- name: abort
  fail: msg="Aborted!!"
  when: yn.user_input != 'y'
  run_once: true
````

__ちょいテク: 条件付きで強制終了するなら `when + fail`__<br>
__ちょいテク: `run_once: true` でホストが複数でも１度しか実行しない。__<br>

* pause は性質上もともと１回しか動かないので `run_once: true` は不要。つけても害はないが。

## ■何かを入力させる

```
- name: branch
  pause:
    prompt: "branch 名 もしくは リリース tag を指定してください [develop]"
  register: branch_input

- name: set branch
  set_fact:
    branch_name: "{{ branch_input.user_input | default('develop', true) }}"
```

表示イメージ<br>
```
TASK: [branch] *****************************************
[127.0.0.1]
branch 名 もしくは リリース tag を指定してください [develop]:
ここで入力
ok: [127.0.0.1]

TASK: [set branch] *************************************
ok: [127.0.0.1]
```

__ちょいテク: `.user_input` で入力された内容を取れる。__<br>
* 末尾の改行は含まれない。
* 何も入力せずに Enter おされたら `""` が入る。

__ちょいテク: `default()` でデフォルトを指定できる__<br>
* 第１引数でデフォルト値を指定する。
* 第２引数を `true` にすることで、（未定義だけでなく）空欄も default の対象にできる。

__ちょいテク: `set_fact` で変数への代入ができる__<br>

## ■`vars_prompt` でも入力させることができる
playbook<br>
```
- hosts: 127.0.0.1
  vars_prompt:
    - name: "branch_name"
      prompt: "リリース tag もしくは branch 名を指定してください"
      default: develop
      private: no
```

表示イメージ<br>
```
[ansibleadm@localhost playbooks]$ ansible-playbook -i hosts xxxx.yml
リリース tag もしくは branch 名を指定してください [develop]:
```

__この方法の良い所:__<br>
* デフォルト機能が備わっている
* パスワードの場合の文字が見えない入力機能`(private: yes)`が備わっている
* 冒頭で訊いてくれるので task の出力を汚さない

__この方法の問題点:__<bt>
* デフォルトに変数(`{{ default_branch }}` 等)を使えない（変数展開されずそのまま使われてしまう）
* role 化できない

## おまけ1：hosts が複数サーバだった場合どうなるか
全サーバで１度しかプロンプトはでません。<br>

## おまけ2：promptで改行する方法
改行されない<br>
```
  pause: prompt="aaa\nbbb"
```
上記では改行されないが、下記なら改行されます:<br>
改行される1<br>
```
  pause:
    prompt: "aaa\nbbb"
```
もしくは<br>
```
改行される2
  pause: prompt="{{"aaa\nbbb"}}"
```
