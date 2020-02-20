[【Bash】forループ中の出力をまとめてファイルにリダイレクトする方法](https://linuxfan.info/post-2934)<br/>

### 元
<pre>
#!/bin/bash
echo -n > mirai.txt
for i in {1..100}
do
  echo ${i}分後 >> mirai.txt
  date -d "${i} minutes" '+%Y/%m/%d %H:%M:%S' >> mirai.txt
done
</pre>

### まとめて
<pre>
#!/bin/bash
for i in {1..100}
do
  echo ${i}分後
  date -d "${i} minutes" '+%Y/%m/%d %H:%M:%S'
done > mirai.txt
</pre>

### ワンライナー
<pre>
for i in {1..100}; do echo ${i}分後; date -d "${i} minutes" '+%Y/%m/%d %H:%M:%S'; done > mirai.txt
</pre>

### パイプ後変数に代入
<pre>
DIR=$(while [ "${DIR}" != "/" ]
do  
    echo "${DIR}"
    DIR=$(dirname ${DIR})
done | peco)
</pre>
