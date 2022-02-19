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

readonly HOLIDAY_LIST=$(curl -sS https://raw.githubusercontent.com/holiday-jp/holiday_jp-ruby/master/holidays.yml | awk '{print $1}')

if [ $? != 0 ]; then
    echo "休日リストの取得に失敗しました。"
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
    echo ${HOLIDAY_LIST} | grep ${DATE} > /dev/null
    IS_HOLIDAY=$?
    IS_DAYOFF=$(date +"%w" -d ${DATE})
    echo "IS_HOLIDAY=${IS_HOLIDAY} IS_DAYOFF=${IS_DAYOFF}"
    if [ ${IS_HOLIDAY} = 0 ] || [ ${IS_DAYOFF} = 0 ] || [ ${IS_DAYOFF} = 6 ]; then
        continue
    fi

    # 休日でない場合はファイル出力
    echo ${LINE} | awk -F "," '{ print "'${DATE}'," $3 "," $5 }' >> "${OUTPUT_FILE}"
done
```
