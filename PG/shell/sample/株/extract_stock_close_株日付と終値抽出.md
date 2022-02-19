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

tail -n +2 "${TARGET_FILE}" | awk -F "," '{print $1 "," $5}' > "${OUTPUT_FILE}"
```
