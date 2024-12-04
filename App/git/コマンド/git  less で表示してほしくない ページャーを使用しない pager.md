## [「そこは less で表示してほしくない！」という時に使える cat](https://qiita.com/talog/items/370e6c5739f40f39dde0)

#### 最後に | cat - をつけるだけ。
```
# git diff # => less で表示されてしまう
git diff | cat - # => コンソールに表示される
```

---

## [gitの結果を一時的にページャを使用せずに表示する](https://qiita.com/iwata-n/items/4ffe96b7a6024cd7f7fe)

`git log` や `git diff` を何気なく使うとページャ機能が有効になっている。<br>
これを無効にして実行するには `git --no-pager log` や `git --no-pager diff` のように `git --no-pager XXX` とすればよい<br>
