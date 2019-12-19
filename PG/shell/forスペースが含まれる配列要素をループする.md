[スペースが含まれる配列要素をループする](https://qiita.com/YumaInaura/items/934fc415a497753995e7)

## ループの中で、添え字を使って配列要素にアクセスする。
<pre>
arr=(
"Space delimited text A"
"Space delimited text B"
"Space delimited text C"
)


for ((i = 0; i < ${#arr[@]}; i++))
do
  echo "${arr[$i]}"
done
</pre>

## 結果
<pre>
$ bash example.sh
Space delimited text A
Space delimited text B
Space delimited text C
</pre>
<br/><br/>
### 以下の書き方では、スペースの区切りで別要素として扱われてしまっていた。
<pre>
arr=(
"Space delimited text A"
"Space delimited text B"
"Space delimited text C"
)

for item in ${arr[@]}; do
  echo "$item"
done
</pre>

## 結果
<pre>
$ bash example.sh
Space
delimited
text
A
Space
delimited
text
B
Space
delimited
text
C
</pre>
