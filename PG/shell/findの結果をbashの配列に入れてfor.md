```
TEXTS=$(find . -name "*.txt")

for text in ${TEXTS[@]}; do
  echo "${text}"
done
```
