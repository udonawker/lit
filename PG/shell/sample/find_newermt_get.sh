BASE_TIME=$(date "+%Y%m%d %H:%M:%S")
echo "Reference time [${BASE_TIME}]"

sleep 10
touch temp.txt

find . -newermt "${BASE_TIME}" -type f
