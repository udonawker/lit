## Tips: findで検索したディレクトリを消去
```
$ find . -name "hoge" -type d -print0 | xargs -0 rm -r 
```
* find の -print0 は空白の代わりにヌル文字を区切り文字とする。
* xargsの -0 はヌル文字を区切り文字とする。
* こうすることでディレクトリリストに空白等の特殊文字が入っていても対処できる。
