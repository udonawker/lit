| |A|B|C|
|:-----------|:------------:|:------------:|:------------:|
|1|&lt;Id&gt;0000001&lt;&frasl;Id&gt;|Id|0000001|
|2|&lt;Name&gt;山田　太郎&lt;&frasl;Name&gt;|Name|山田　太郎|

```
=MID(元の文字列,抜き出したい初めの文字が何文字目か,抜き出したい文字数)
```

#### タグ名抽出
```
=MID(LEFT(A3,FIND(">",A3)), FIND("<",A3) + 1, FIND(">",A3) - FIND("<",A3) - 1)
```

#### 値抽出
```
=MID(A3, FIND(">", A3) + 1, FIND("<", A3, FIND(">", A3) + 1) - FIND(">", A3) - 1)
```
