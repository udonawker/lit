#!/bin/bash

DIRS=
GREP=
HOST_NAME=$(hostname)

DIRS=($(find . -maxdepth 1 -type d | tr -d "./" ))

for dir in ${DIRS[@]}; do
    echo "${dir}"
    FTIME=$(date -I -r ${dir})
    ARCHIVE=$(date -d "${FTIME}" "+%Y%m%d")_${HOST_NAME}_${dir}.tar.gz
    tar cvfz ${ARCHIVE} ${dir} > /dev/null
done

exit 0
