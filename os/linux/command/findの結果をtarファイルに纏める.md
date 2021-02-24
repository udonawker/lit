## [findの結果をtarファイルに纏める](http://diaryruru.blog.fc2.com/blog-entry-32.html)
## [findしてtarしたけどファイルが全部アーカイブされていない](https://qiita.com/m-dove/items/c6eb35976c929e540e4f)
## [findの結果をtarでアーカイブしたい](https://fei-yen.jp/maya/wordpress/blog/2013/01/15/find%E3%81%AE%E7%B5%90%E6%9E%9C%E3%82%92tar%E3%81%A7%E3%82%A2%E3%83%BC%E3%82%AB%E3%82%A4%E3%83%96%E3%81%97%E3%81%9F%E3%81%84/)

```
$ find . -type f -name "*.log" | tar -c -T - --null -f logs.tar
$ find . -type f -name "*.log" | tar -cz -T - --null -f logs.tar.gz
$ find . -type f -name "*.log" | tar -cj -T - --null -f logs.tar.bz2
```
```
# ssh先にアーカイブ
$ find -name "hoge*" -print0 | tar -cvj -T - --null | ssh user@myserver "cat - > hoges.tar.bz2"
# 手元のサーバにCPU負荷をかけたくないけどbzip2圧縮はしたい
$ find -name "hoge*" -print0 | tar -cv -T - --null | ssh user@myserver "bzip2 -cz > hoges.tar.bz2"
# サーバにそのまま解凍したい
$ find -name "hoge*" -print0 | tar -cv -T - --null | ssh user@myserver "cd /tmp; tar x"
```
