#!/bin/bash

PECO_FOUND_DIR=""

function peco_find_dir() {
    local DIR="."
    local FOUND_DIR=""

    # 引数が1以上で引数$1がディレクトリで内場合はエラー終了
    if [ $# -ge 1 ]; then
        if [ -d "${1}" ]; then
            DIR="${1}" #DIR=ls -1pd "${1}"
        else
            return 1
        fi
    fi

    while FOUND_DIR="$(find "${DIR}" -maxdepth 1 -type d | sed -e 's;^\./;;' | grep -v "^\.$" | sort | peco)"; do
        if [ -z "${FOUND_DIR}" ]; then
            DIR=""
            break
        fi
        printf "%s (\e[1mc\e[monfirm/\e[1mp\e[mrevious/\e[1mn\e[mext/\e[1mq\e[muit)" "${FOUND_DIR}"
        IFS= read -r -n1 -s char;
        printf "\e[2K"
        echo -en "\r"
        case ${char} in
        p)          # previous
            DIR="$(dirname "${FOUND_DIR}")";;
        n)          # next
            DIR="${FOUND_DIR}";;
        c|$'\0a')   # comfirm(Enter)
            DIR="${FOUND_DIR}"
            break;;
        q|$'\e')    # quit(Escape)
            DIR=""
            break;;
        *)
        esac
    done

    PECO_FOUND_DIR="${DIR}"
}

peco_find_dir
echo "GET_DIR=${PECO_FOUND_DIR}"
