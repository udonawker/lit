#!/bin/bash

#スクリプトディレクトリ
readonly SCRIPT_DIR=$(cd $(dirname $0); pwd)
#スクリプトの絶対パス
readonly SCRIPT_PATH=${SCRIPT_DIR}/$(basename $0)
#スクリプト名
readonly SCRIPT_NAME=${0##*/}

YYYYMM=$1
BEGIN_DAY=$2
END_DAY=$3

usage() {
    echo "usage: ${SCRIPT_NAME} YYYYMM BEGIN_DAY END_DAY"
}

isNotEmptyStrings(){
    while [ "$1" != "" ]
    do
        # 空文字チェック判定
        if [ -z "${1}" ]; then
            # Empty string
            return 1
        fi
        
        shift
    done
    
    return 0
}

isNumericString(){
    while [ "$1" != "" ]
    do
        #半角数字判定
        if ! expr "${1}" : '^[0-9]*$' > /dev/null ; then
           # Not numeric string
           return 1
        fi
        
        shift
    done
    
    return 0
}

echo "script path : ${SCRIPT_PATH}"
echo "script name : ${SCRIPT_NAME}"
echo "argument1   : ${YYYYMM}"
echo "argument2   : ${BEGIN_DAY}"
echo "argument3   : ${END_DAY}"

if [ $# -ne 3 ]; then
    usage
    exit 1
fi

if ! isNotEmptyStrings ${YYYYMM} ${BEGIN_DAY} ${END_DAY} ; then
    echo "Argument check (isNotEmptyStrings) ${YYYYMM} ${BEGIN_DAY} ${END_DAY}"
    usage
    exit 1
fi

if ! isNumericString ${YYYYMM} ${BEGIN_DAY} ${END_DAY} ; then
    echo "Argument check (isNumericString) ${YYYYMM} ${BEGIN_DAY} ${END_DAY}"
    usage
    exit 1
fi

LOOP=$(seq ${BEGIN_DAY} ${END_DAY})

if [ $? -ne 0 ]; then
    usage
    exit 1
fi

for i in ${LOOP}
do
    echo ${YYYYMM}$(printf %02d $i)
done

exit 0


#script path : /root/template.sh
#script name : template.sh
#argument1   : 201904
#argument2   : 1
#argument3   : 30
#20190401
#20190402
#20190403
#20190404
#20190405
#20190406
#20190407
#20190408
#20190409
#20190410
#20190411
#20190412
#20190413
#20190414
#20190415
#20190416
#20190417
#20190418
#20190419
#20190420
#20190421
#20190422
#20190423
#20190424
#20190425
#20190426
#20190427
#20190428
#20190429
#20190430
