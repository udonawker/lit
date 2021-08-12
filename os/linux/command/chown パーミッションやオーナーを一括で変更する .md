## [パーミッションやオーナーを一括で変更する](https://qiita.com/YumaInaura/items/631832f591484ee06432)

### オーナー変更
(例) /usr/share/nginx/html ディレクトリ以下のファイル/ディレクトリを全てnginx ユーザ、nginx グループのものに変更。<br>
```
$ chown -R nginx:nginx /usr/share/nginx/html
```

### パーミッション変更
(例) /usr/share/nginx/html ディレクトリ以下の、ディレクトリを755、ファイルを644に変更。<br>

findの-execオプションで処理する方式<br>
```
$ find /usr/share/nginx/html -type d -exec chmod 755 {} \;
$ find /usr/share/nginx/html -type f -exec chmod 644 {} \;
```

findの結果をパイプでxargsに与える方式<br>
```
$ find /usr/share/nginx/html -type d -print0 | xargs -0 chmod 755
$ find /usr/share/nginx/html -type f -print0 | xargs -0 chmod 644
```
