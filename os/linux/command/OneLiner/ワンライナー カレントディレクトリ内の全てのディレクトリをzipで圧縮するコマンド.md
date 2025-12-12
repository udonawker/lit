```
$ find . -mindepth 1 -maxdepth 1 -type d | sed 's!^.*/!!' | xargs -I% zip -qr %.zip %
```
<br>

参考<br>

### [ディレクトリを順次圧縮しようぜという話](https://qiita.com/kakinoshin/items/b7d46f3a89ccd3bd01a8)
