## [Ansible souceコマンドを実行するならshellモジュールで](http://blog.rutake.com/techmemo/2015/10/18/ansible-souce%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%82%92%E5%AE%9F%E8%A1%8C%E3%81%99%E3%82%8B%E3%81%AA%E3%82%89shell%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E3%81%A7/)

調べたところsourceはshellのビルドインモジュールらしいので、shellモジュールで実施せよとのことであった。<br>
以下のように記述したら問題なかった。<br>

基本的にOSコマンドをAnsibleで実施したい場合は、Commandモジュールを使うのがよいのだが、今回のsourceコマンドのみならず、Shellモジュールじゃないとできないこと(パイプやリダイレクト)も多いので注意である。<br>
```
- name: reflect .bash_profile
  shell: source ~/.bash_profile
```
