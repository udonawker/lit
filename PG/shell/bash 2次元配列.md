<pre>
#!/bin/bash

# 途中のspaceはNG
dataArray=(
    "くま もり peachpuff"
    "ねこ まち lightpink"
    "さる 上野動物園 burlywood"
    "りす 鎌倉 khaki"
    "魚 海 lightblue"
)

for i in "${dataArray[@]}"; do
    data=(${i[@]})
    animal=${data[0]}
    place=${data[1]}
    color=${data[2]}
    echo ${animal}
    echo ${place}
    echo ${color}
done
