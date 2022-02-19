```
#!/bin/bash

#スクリプトディレクトリ
readonly SCRIPT_DIR=$(\cd $(dirname -- $0); pwd)
#スクリプトの絶対パス
readonly SCRIPT_PATH=${SCRIPT_DIR}/$(basename $0)
#スクリプト名
readonly SCRIPT_NAME=${0##*/}
# 対象ファイル
readonly TARGET_FILE="${1}"
# 出力ファイル
readonly OUTPUT_FILE="${TARGET_FILE%.*}_ext.${TARGET_FILE##*.}"

usage() {
    echo "usage: ${SCRIPT_NAME} FILE"
}

if [ $# -ne 1 ]; then
    echo "引数の数が誤っています。"
    usage
    exit 1
fi

if [ ! -f "${TARGET_FILE}" ]; then
    echo "対象ファイルが存在しません。"
    usage
    exit 1
fi

echo "OUTPUT ${OUTPUT_FILE}"

readonly STOCK_DAY=$(curl -sSL https://stooq.com/q/d/l?s=^nkx&d1=20200925&d2=$(date +"%Y%m%d")&i=d | tail -n +2)

if [ $? != 0 ]; then
    echo "株リストの取得に失敗しました。"
    usage
    exit 1
fi

sed 's/"//g' "${TARGET_FILE}" | while read LINE
do
    DATE=$(echo ${LINE} | awk -F "," '{print $1}')
    DATE=${DATE//\//-}
    echo "DATE=${DATE}"
    date +"%Y-%m-%d" -d ${DATE} > /dev/null 2>&1
    # 1番目のフィールドが日付形式かどうかチェック
    if [ $? != 0 ]; then
        continue
    fi

    # 対象日付が休日かどうかチェック
    echo ${STOCK_DAY} | grep ${DATE} > /dev/null
    IS_STOCKDAY=$?
    if [ ${IS_STOCKDAY} != 0 ]; then
        continue
    fi

    # 休日でない場合はファイル出力
    echo ${LINE} | awk -F "," '{ print "'${DATE}'," $3 "," $5 }' >> "${OUTPUT_FILE}"
done
```
