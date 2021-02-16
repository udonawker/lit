## [シェル芸？なにそれ？時代はPythonワンライナー 2019/11/20](https://b.ueda.tech/?page=python_shellgei)
## [Python Tips：ワンライナーが書きたい 2015/1/27](https://www.lifewithpython.com/2015/01/python-use-command-one-liner.html)
<br>

```
python -c "print("hello world")"
# hello world と出力される
```

### 引数を扱いたい場合には sys.argv を使います。
```
python -c "import sys; print(sys.argv)" a b c def
# ['-c', 'a', 'b', 'c', 'def'] と出力される
```
<br>

### sys.argv を使えば、たとえば、引数の合計値を計算することなんかもできます。
```
python -c "import sys; print(sum([int(x) for x in sys.argv[1:]]))" 3 4 5
# 合計の 12 が出力される
```
<br>

### また、標準入力を扱いたい場合には input() もしくは sys.stdin.read() を使います。
```
hayato:Desktop$ pwd | python -c "import sys; print(input().split('/'))"
# カレントディレクトリを構成するディレクトリが配列に分割されて表示される
```
<br>

### jsonを整形するなら
```
$ echo '{"foo": "lorem", "bar": "ipsum"}' | python -mjson.tool
{
    "bar": "ipsum",
    "foo": "lorem"
}
```
