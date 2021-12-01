## [ディレクトリ配下の全てのファイルのMD5のハッシュ値一覧を作成する](http://halucolor.blogspot.com/2012/11/md5.html)

### md5取得
```
$ find [対象のディレクトリ] -type f -exec md5sum {} \;
$ find [対象のディレクトリ] -type f -exec md5sum {} \; > output.md5sum
```

### md5確認
```
md5sum -c output.md5sum
```
