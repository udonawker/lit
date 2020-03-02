#!/bin/bash

PECO_FOUND_FILE=""

function peco_find_dir() {
    local FILE="."
    local FOUND_FILE=""

    while FOUND_FILE="$(find "${FILE}" -maxdepth 1 | sed -e 's;^\./;;' | grep -v "^\.$" | sort | peco)"; do
        if [ -z "${FOUND_FILE}" ]; then
            FILE=""
            break
        fi
        printf "%s (\e[1mc\e[monfirm/\e[1mp\e[mrevious/\e[1mn\e[mext)" "${FOUND_FILE}"
        IFS= read -r -n1 -s char;
        printf "\e[2K"
        echo -en "\r"
        case ${char} in
        p)          # previous
            FILE="$(dirname "${FOUND_FILE}")";;
        n)          # next
            if [ -d "${FOUND_FILE}" ]; then
                FILE="${FOUND_FILE}"
            fi
            ;;
        c|$'\0a')   # comfirm(Enter)
            if [ -f "${FOUND_FILE}" ]; then
                FILE="${FOUND_FILE}"
                break
            fi
            ;;
        q|$'\e')    # quit(Escape)
            FILE=""
            break;;
        *)
            ;;
        esac
    done

    PECO_FOUND_FILE="${FILE}"
}

peco_find_dir
echo "GET_FILE=${PECO_FOUND_FILE}"
