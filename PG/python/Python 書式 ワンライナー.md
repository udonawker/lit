## [python one liner 2019/9/19](https://www.python-tec.info/2019/09/19/%E2%96%A01%E3%83%A9%E3%82%A4%E3%83%8A%E3%83%BC%E3%81%AE%E6%9B%B8%E3%81%8D%E6%96%B9/)

## ■for 文の書き方
例えば、下記のような年齢の文字リストを作成したい場合、<br>
```
AgeList = ['18 aged', '19 aged', '20 aged', '21 aged']
```
真面目に書くと<br>
```
#空リストを作成
AgeWord= []

#for 文で追加
for a in range(18 , 22) :
    AgeWord.append( str(a)+' aged' )
```

ワンライナーで 書くと<br>
```
AgeWord= [ str(a)+' aged'  for a in range(18 , 22) ]
```
<br>

## ■ enumurateを使う
```
 [[i , x] for i, x in enumerate("hoge"*100) if i < 10]
```
 もう一つ[]で囲む<br>
 <br>
 
## ■import
多くのライブラリーをimportする際に、import文が長くなるが、<br>
```
import sys
import time
import os
import urllib.request
```
を<br>
```
import sys ,  time , os , urllib.request
と1行にまとまることが出来る。
```

asを使う場合も、<br>
```
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
```
を<br>
```
import pandas as pd , numpy as np , matplotlib.pyplot as plt
```
と書ける。<br>
<br>

## ■条件文の書き方
条件文も書ける。if文であれば、<br>
```
for n in range(0,4):
    if n%2 ==0 :
        print('偶数')
        print(n)
    
    else:
        print('奇数')

#偶数 0 奇数 偶数 2 奇数
```
を<br>
```
for n in range(0,4):
    if n%2 ==0 : print('偶数') , print(n)
    else: print('奇数')

#偶数 0 奇数 偶数 2 奇数
```
と半角スペースを入れて、ワンライナーで書くことが可能。改行を入れる場合は「,」を入れれば、何行でも追加することが出来る。<br>
※変数を2つ以上定義するのは出来ない模様(2019-11-19 現在)<br>
<br>

## ■複数の代数を定義
```
x = 10
y = 15
z = 20
```
を<br>
```
x, y, z = 10, 15, 20
```

----
## [pythonのワンライナー至上主義！](https://encr.jp/blog/posts/20200403_lunch/)
## リスト内包表記とlambda式とmapやfilterの利用
```
>>> dict_sample = {"a":1,"b":2,"c":3}

>>> for key in dict_sample.keys():
...   print(f"{key}:{dict_sample[key]}")
... 
a:1
b:2
c:3
```
の代わりを色々書いてみます。
<br>
## リスト内包表記
### dict
```
>>> dict_sample = {"a":1,"b":2,"c":3}

>>> [print(f"{x}:{dict_sample[x]}") for x in dict_sample.keys()]
a:1
b:2
c:3

>>> [print(f"{x[0]}:{x[1]}") for x in list(dict_sample.items())]
a:1
b:2
c:3
```

### list
```
>>> list_sample = ["a","b","c"]

>>> [print(f"{x}:{dict_sample[x]}") for x in list_sample]
a
b
c
```

## mapとlambda式の利用
### dict
```
>>> list(map(lambda x:print(f"{x}:{dict_sample[x]}"),dict_sample.keys()))
a:1
b:2
c:3

>>> list(map(lambda x:print(f"{x[0]}:{x[1]}"),dict_sample.keys()))
a:1
b:2
c:3
```

### list
```
>>> list_sample = ["a","b","c"]

>>> list(map(lambda x:print(f"{x}"),list_sample))
a
b
c
```

----
### dictのlist
```
dict_sample = [
    {"InstanceId":"i-xxxxxxxxxxxxxxxxx","Instance":"m5.large","Name":"test1"}
    ,{"InstanceId":"i-yyyyyyyyyyyyyyyyy","Instance":"t2.micro","Name":"test2"}
]
```

### 必要な要素だけ抽出
#### InstanceIdだけをlistで取得<br>
```
>>> list(map(lambda x:x["InstanceId"],dict_sample))
['i-xxxxxxxxxxxxxxxxx', 'i-yyyyyyyyyyyyyyyyy']
```

#### InstanceIdだけをdictで取得
```
>>> list(map(lambda x:{"instanceId":x["InstanceId"]},dict_sample))
[{'instanceId': 'i-xxxxxxxxxxxxxxxxx'}, {'instanceId': 'i-yyyyyyyyyyyyyyyyy'}]
```

#### Nameだけを削除したdictを取得
```
>>> [x.pop("Name") for x in dict_sample]
['test1', 'test2']
>>> dict_sample
[{'InstanceId': 'i-xxxxxxxxxxxxxxxxx', 'Instance': 'm5.large'}, {'InstanceId': 'i-yyyyyyyyyyyyyyyyy', 'Instance': 't2.micro'}]
```

#### Nameのtestをテストに置き換えたdictを取得
```
>>> [x.update({'Name': x['Name'].replace('test', 'テスト')}) for x in dict_sample]
[None, None]
>>> dict_sample
[{'InstanceId': 'i-xxxxxxxxxxxxxxxxx', 'Instance': 'm5.large', 'Name': 'テスト1'}, {'InstanceId': 'i-yyyyyyyyyyyyyyyyy', 'Instance': 't2.micro', 'Name': 'テスト2'}]
```
