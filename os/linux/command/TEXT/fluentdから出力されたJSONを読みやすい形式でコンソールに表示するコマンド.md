## [fluentdから出力されたJSONを読みやすい形式でコンソールに表示するコマンド 2013/01/21](https://reiki4040.hatenablog.com/entry/20130121/1358765403)

python -m json.toolに任意のJSONを渡すことで整形表示されます。<br>
```
$ echo '{"key":"value","obj":{"count":100}}' | python -m json.tool
{
    "key": "value", 
    "obj": {
        "count": 100
    }
}
```

fluentdのログ渡すときは、タブ区切りの3フィールド目がJSONなので、cutを使います。<br>
catやzcatなどとパイプで組み合わせます。<br>
```
$ zcat versions.20130120_0.log.gz | cut -f3 | python -m json.tool
{
    "ver1.0.0_count": 0,
    "ver1.0.0_percentage": 0.0,
    "ver1.0.0_rate": 0.0,
    "ver1.0.1_count": 0,
    "ver1.0.1_percentage": 0.0,
    "ver1.0.1_rate": 0.0,
    "ver1.1.0_count": 0,
    "ver1.1.0_percentage": 0.0,
    "ver1.1.0_rate": 0.0,
    "ver1.1.1_count": 0,
    "ver1.1.1_percentage": 0.0,
    "ver1.1.1_rate": 0.0,
    "ver1.2.0_count": 0,
    "ver1.2.0_percentage": 0.0,
    "ver1.2.0_rate": 0.0,
    "unmatched_count": 0,
    "unmatched_percentage": 0.0,
    "unmatched_rate": 0.0
}
```

```
#!/bin/bash

numLine=1
cat $1 | while read line
do
    echo ""
    echo "$line" | cut -f1
    echo "$line" | cut -f2
    echo "$line" | cut -f3 | python -m json.tool
    numLine=$((numLine + 1))
done
```
