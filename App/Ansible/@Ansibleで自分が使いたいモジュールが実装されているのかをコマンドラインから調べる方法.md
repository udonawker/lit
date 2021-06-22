## [Ansibleで自分が使いたいモジュールが実装されているのかをコマンドラインから調べる方法](https://qiita.com/ma2muratomonori/items/34acefeb56c6449a4a56)


全てのモジュールをファイルに書き出す<br>
```
ansible-doc --list_files > .list
```
