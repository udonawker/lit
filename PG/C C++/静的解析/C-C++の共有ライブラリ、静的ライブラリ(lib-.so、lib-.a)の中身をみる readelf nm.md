## [C++の共有ライブラリ（lib〜.so）の中に、どんな関数の実装が書かれているか確かめるのってどのようにすれば良いのでしょうか？](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1079008475)
## [Linuxのsoの中身って、どうやって調べるんですか？](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q13156933193)

```
readelf -s xxx.so
readelf -s xxx.a
nm xxx.so
nm xxx.a
```

stripされているとnmコマンドは使用できない<br>
<br>
```
nm: xxx.so: no symbols
```
```
file xxx.so
xxx.so: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, BuildID[sha1]=xxx...xxx, stripped
```

<br><br>


readelfというコマンドです。<br>
```
readelf -d libXext.so
readelf -a libXext.so
```
なんかで情報が表示できます。
