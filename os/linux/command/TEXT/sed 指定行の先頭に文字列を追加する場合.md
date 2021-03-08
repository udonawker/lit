## [指定行の先頭に文字列を追加する場合](https://orebibou.com/ja/home/201602/20160227_001/#:~:text=sed%E3%81%A7%E3%80%81%E6%8C%87%E5%AE%9A%E3%81%97%E3%81%9F%E8%A1%8C,%E3%82%92%E6%8C%87%E5%AE%9A%E3%81%99%E3%82%8C%E3%81%B0%E3%81%84%E3%81%84%E3%80%82)

## 指定行の先頭に文字列を追加する場合

```
sed '/文字列/s/^/追加文字列/g' 対象ファイル # 文字列を検索して行を指定
sed '◯s/^/追加文字列/g' 対象ファイル # 行番号を直接指定
sed 's/^/追加文字列/g' 対象ファイル # すべての行
```

```
[root@test-node ~]# cat /work/test_1.txt
aaaaa
bbbbb
ccccc
ddddd
eeeee
fffff
ggggg
[root@test-node ~]#
[root@test-node ~]# # 「ccc」を含む文字列をコメントアウトする
[root@test-node ~]# sed '/ccc/s/^/# /g' /work/test_1.txt
aaaaa
bbbbb
# ccccc
ddddd
eeeee
fffff
ggggg
[root@test-node ~]#
[root@test-node ~]# # 5行目をコメントアウトする
[root@test-node ~]# sed '5s/^/# /g' /work/test_1.txt
aaaaa
bbbbb
ccccc
ddddd
# eeeee
fffff
ggggg
```

## 指定行の末尾に文字列を追加する場合

```
sed '/文字列/s/$/追加文字列/g' 対象ファイル # 文字列を検索して行を指定
sed '◯s/$/追加文字列/g' 対象ファイル # 行番号を直接指定
sed 's/$/追加文字列/g' 対象ファイル # すべての行
```

```
[root@test-node ~]# cat /work/test_1.txt
aaaaa
bbbbb
ccccc
ddddd
eeeee
fffff
ggggg
[root@test-node ~]#
[root@test-node ~]# # 「ddd」を含む行の末尾に文字列追加
[root@test-node ~]# sed '/ddd/s/$/-------/g' /work/test_1.txt
aaaaa
bbbbb
ccccc
ddddd-------
eeeee
fffff
ggggg
[root@test-node ~]#
[root@test-node ~]# # 6行目の末尾に文字列追加
[root@test-node ~]# sed '6s/$/-------/g' /work/test_1.txt
aaaaa
bbbbb
ccccc
ddddd
eeeee
fffff-------
ggggg
```
