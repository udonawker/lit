#!/bin/bash

images=($@)

for ((i=0 ; i<${#images[@]} ; i++))
do
    echo "${images[${i}]}"
done

# bash test.sh aaa bbb ccc
# aaa
# bbb
# ccc
